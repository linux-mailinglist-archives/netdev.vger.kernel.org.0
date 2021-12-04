Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB01D4686FF
	for <lists+netdev@lfdr.de>; Sat,  4 Dec 2021 19:23:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1385453AbhLDS0p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Dec 2021 13:26:45 -0500
Received: from mail-dm6nam10on2091.outbound.protection.outlook.com ([40.107.93.91]:64320
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1355318AbhLDS0m (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 4 Dec 2021 13:26:42 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MObG0D67u9CrUSxPcedikc0YXQaZHHIEQeenPH9b2pymKaX4/FYTzepryPjIiX1LIDGTJsnph5pEHnLj7XCsD0KpCrmw+7ARWIBILUJSJcA1ZbUMCPLsR9nkZ11VFB0uDD2glT3GYberwoSUAzbTE64CSOqodDpgaR1CwBygE1KTn+xFWzQtWo0bQ9gY+20XmjQVhf44Ob6O+IshsktyAcWU7vwmEXT1PhmieFlHvkTvdUUkzz+god2EJOYsLuRTYa8aA/Lch1AliTnWjM+pMwIcf/AON2KqO5KWzpXlMHeApjSzVOpPDylLdgJYqTUCe1dPHs1yjdoRcoGWR0dtSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iUNk4QKNdYcH7XLhl/4P/gFMYdJp7bV3Sh5atD3YpfU=;
 b=QxaUzxhkJiuWZVNkz2AVU9w01XLusnQycgLE5hztNuYPpaDVyo/0maqZATNzUItWzHjMAKA7mgMkbNmlrx9POdaocc3Cg84kInC9h1bt9yT4uHXHXJuN6uYECDiIJ/re3mmPSGMm0bWtbQvpsy4fAUiSf38eWEBAc02e/wNY3OlqSv2dQmig88pFJZbDsbrWQihKuiHdvkkrz1c3DIIiABjT2AQURfakBwsmlljjz9/e347fSNZUowlu1s5Tqz89Idn4BL6j4Q+4/uuOb7ob434XdhJBAsCwEQvdPNv5beetxFjC/ASt0WhpY6iVUf5rv8UOHBx0AEc4IOw1UlQjRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iUNk4QKNdYcH7XLhl/4P/gFMYdJp7bV3Sh5atD3YpfU=;
 b=KtyiPoGc7wCb5apOYUzIZmfyKIRiqjTWnjV4Vhxv63JJpUvgxrsGfkNl+nw1UZ3jQ4JGsAetqSZu9uKmgUEUYwS5XJlSxj5YnTzF9CwNsaR97ErA7l9gmg9u4jGg2WjUXZUuJAWzR01BO2MCFo1whIpVRk7mw60Erhi7Q9mNlRo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by MWHPR1001MB2061.namprd10.prod.outlook.com
 (2603:10b6:301:36::39) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.20; Sat, 4 Dec
 2021 18:23:15 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::6430:b20:8805:cd9f]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::6430:b20:8805:cd9f%5]) with mapi id 15.20.4755.020; Sat, 4 Dec 2021
 18:23:15 +0000
Date:   Sat, 4 Dec 2021 10:23:13 -0800
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>
Subject: Re: [PATCH v3 net-next 0/5] prepare ocelot for external interface
 control
Message-ID: <20211204182313.GB1037231@euler>
References: <20211204182129.1044899-1-colin.foster@in-advantage.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211204182129.1044899-1-colin.foster@in-advantage.com>
X-ClientProxiedBy: MW4PR03CA0096.namprd03.prod.outlook.com
 (2603:10b6:303:b7::11) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
Received: from euler (67.185.175.147) by MW4PR03CA0096.namprd03.prod.outlook.com (2603:10b6:303:b7::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.17 via Frontend Transport; Sat, 4 Dec 2021 18:23:14 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 06708b3e-8082-4f3c-d584-08d9b753234b
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2061:
X-Microsoft-Antispam-PRVS: <MWHPR1001MB20617E4D6542C4FCDFCF8E46A46B9@MWHPR1001MB2061.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BCb4IHF5j2vwh+gpx8HfxSG1e717o1mgWKnV6IeH+pxxLaORfnbl8O5/jU9vTS3TsEZb4322fyQWldQmjU4sPA2MIdbk1q9bk/8JLVyeSxiVd3BBBeRspsedkGh8qkAdK6hB5VxBG8CvbFNQDFmNoxIcL9r/NISYAlsZYth4id9kcJBrwZbBSrBqikMiDUzuExKCOZ/lMnP+Zn4x51t0uS/Kt+A/0dtPgcaeOXWylHfpzcOaf09y2r9Ckgg+KlTkiN552lDRAnE1JCBpCM3kjJJTfkSIkpEi9UWDMq9+9e/On4Nqp/3hcdBZCp9kollOT5ugf97fpw0FYm02ugpjQDiZCRuYDLaYBuBvvo9SV6XiYrYBbTDoJwBA6xw1DxgJYek94mHvO0e8RvuifDb7u1awllXIH6ybmMD2YG6qUOxEJrGfhFIijTT6HQUVQ0Au38d6eT4paDuAJz858potY9KbFi4I+vt5L4l6YlU3Cz7fvV7PXdSKh8IpxZTCWp5N3x61lEHD4HlYJK9PHzf12OFyhRtATfn1zJZ3chZR93xj42cW9KrUjLCKUm575XvFcs3E1KwQ8MQigTG+fdYSZpH7LS5gQ55Rrx1ooZcxdtrHP9xD7QuYQxzx7U/flDJWf2gczwUeWLb8x19eAALTxwpoPPwXwwHg3xYft8sIAuMSlgMxyG7GNyflzWqs1ZkXdR9kA1B/NIR4j5qVh0C/Iw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(366004)(396003)(376002)(39830400003)(346002)(33716001)(54906003)(52116002)(7416002)(9576002)(2906002)(6496006)(66556008)(8676002)(26005)(186003)(55016003)(66476007)(316002)(8936002)(83380400001)(9686003)(86362001)(33656002)(5660300002)(66946007)(956004)(38100700002)(4326008)(38350700002)(44832011)(508600001)(1076003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?MvKfHy1J4xwimDljnvY5Too+CjNQB5sC4xzMtrGTLlcaDRcEwyDzju8l2MQA?=
 =?us-ascii?Q?EUEjlyY2Tjvw8nG/ghbUfexiVrU0D4wcILqLiiCc4QE7ap4LmtRPk2A/CLKA?=
 =?us-ascii?Q?HkkxOVdBOPlvyk++WGOvGnvah7G66jMXKL/vIL3TMZdB4tdJ2bqqeKmU9Jwd?=
 =?us-ascii?Q?2DMuWaupqh98jZ3ev0G/BmS0hK2qw0+8HxnYBWcadJospkNXp3j/vEJtM/z7?=
 =?us-ascii?Q?5lbDA39SfMNUbzWoJGRzNSQhyEKlKsBfYzOMJN6boQDx/ldK7JMgXynQPAnB?=
 =?us-ascii?Q?nR+31nEvsjcsVHl30L51572537xNU2Sca8o0Jvw1MFt/sbSA7GRRsJP63or7?=
 =?us-ascii?Q?5ru+2badAhopi8UF2xjGET/vw2oWPWv4RnIL4dTHhuRrSB+bZH5Qw3yZTea/?=
 =?us-ascii?Q?ln/jWADgEUllNr1JORGq6rE1q1inY8YsNFZdkg9nczM/VLurjxjOBHinimwL?=
 =?us-ascii?Q?4nnseQnx/GtAT1BXI/tnjnUkxxKMjOpHSyRDez7cQacPPFNFJAGxBglxMjBi?=
 =?us-ascii?Q?s3hK37LYoync7IGK4dzHk4MLbZvvCGYxlfF8E7aH1UxtclwLGV9s6FVVJeuz?=
 =?us-ascii?Q?c4TyVOYk61ZZTYxGQdE3hl2+iBiI0DCXpYdbk6iGRuckuwxL1rKDdwu45yWO?=
 =?us-ascii?Q?IM9s8HBMHudQicrHeLW0xhW00dYq2tJMdTVJys607kokrLJzp/b/Vb9celHk?=
 =?us-ascii?Q?BUmDqUfJopQM5paht9yDIvGA4V+CVNQyk3vXsyPIchBikWo1SmjbcO01AEE4?=
 =?us-ascii?Q?6wbrdaqaeREINrr0dq/3I2xa7qNOnyJ/tPt7EdQ74q4TCVAX04h957TZDyNX?=
 =?us-ascii?Q?u3ym9JFl/jWrzqak5m5bNtNEJKXuhihPg2nu0HyWDLxmflGoEFyzK4skeg2Z?=
 =?us-ascii?Q?8LPAvaWRv0DykKUh7oTrearuNJgYqEyWNoePvB6bdjNchS5HS0JhTYjMOmBK?=
 =?us-ascii?Q?77ISX60gUd20OH3KszLnBSp7Scjsly5uu0T5TX0FbnOdqPrxVm+a78GXhY0Z?=
 =?us-ascii?Q?BfUI3CVoS7Tz2jwziXPsdZjQy4JtgJGljQHcZjMJ+Z5f4nQEmkuECPxAOyYV?=
 =?us-ascii?Q?C5+Qc3+sOpPzQGpiyqz9Z/WR7Xk+8kWFSzSDCm2dXJC7RDRM6bVQ3Z8VQAY7?=
 =?us-ascii?Q?y69A5uQkbFAWxMjPV7JjCEHqob8z3y0bqCOv67Qt6gz+fMtg2UwY4wfUP4d9?=
 =?us-ascii?Q?SWqAMYlFi/fzuWyEtKMjv8/nuyxY8qJrL2g7ORMPvmO+6l6dob3BwNFslo9v?=
 =?us-ascii?Q?3Ly0JvdciBORIFshNEkf6Cs1jYf/mrQHnw0wfYVC/1ZCk3O8YRptaNwU08d1?=
 =?us-ascii?Q?EKnTWzU3CHKGTB67m7FVmBlWqI8Nf4qs8g0JfG8fzzBc1crgGMAdaDx5ry82?=
 =?us-ascii?Q?Ku9a7MiLmSHYOmW9o7RV9fy+SUJsBz+3HAWD/Rc40qae9Xz2rYeMEKe+fhtz?=
 =?us-ascii?Q?s57A6YESs9ylSP+HsteIBirCcJt6XxhDrn/OpfBj6W7YY5iwlFr1qTs+BSJN?=
 =?us-ascii?Q?AuLPH8eIfqhJ3t3PbhxVvPYt788z9HXHGOSSAwGyjslQdIGjZtY4p04nHSen?=
 =?us-ascii?Q?06EjeiL87lVQqqCkQPwC+eLv8Ba7FtmMETBp8+ISZSMA0KeKGwOgIMRX6L+z?=
 =?us-ascii?Q?gYS5tesVrUb7qIlplsZukONzbCAD/Th0SpRso5dtwsUciv+xt5Iio9rDlJM2?=
 =?us-ascii?Q?guWKD/ksn1t9657x3Lbo6ge9i1w=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 06708b3e-8082-4f3c-d584-08d9b753234b
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Dec 2021 18:23:15.2966
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ry8/tY0/7MA9RA/NYoh7tg3PsU9DRETJ1wMalVlZlkRBiXr3hqCl3MIPy5gwY+z17Imjvu1LaP6VaAn4xYmJto9iwsoO4JvHVOcTcqZDXsY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1001MB2061
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Dec 04, 2021 at 10:21:24AM -0800, Colin Foster wrote:
> This patch set is derived from an attempt to include external control
> for a VSC751[1234] chip via SPI. That patch set has grown large and is
> getting unwieldy for reviewers and the developers... me.
> 
> I'm breaking out the changes from that patch set. Some are trivial 
>   net: dsa: ocelot: remove unnecessary pci_bar variables
>   net: dsa: ocelot: felix: Remove requirement for PCS in felix devices
> 
> some are required for SPI
>   net: dsa: ocelot: felix: add interface for custom regmaps
> 
> and some are just to expose code to be shared
>   net: mscc: ocelot: split register definitions to a separate file
>   net: mscc: ocelot: expose ocelot wm functions
> 
> 
> The entirety of this patch set should have essentially no impact on the
> system performance.
> 
> v1 -> v2
>     * Removed the per-device-per-port quirks for Felix. Might be
>     completely unnecessary.
>     * Fixed the renaming issue for vec7514_regs. It includes the
>     Reported-by kernel test robot by way of git b4... If that isn't the
>     right thing to do in this instance, let me know :-)
> 
> v2 -> v3
>     * Fix an include. Thanks Jakub Kicinski!

Oops - I didn't use git b4 to pull in the reviewed by tags. Sending V4
with those changes and this fix. Apologies!

> 
> Colin Foster (5):
>   net: dsa: ocelot: remove unnecessary pci_bar variables
>   net: dsa: ocelot: felix: Remove requirement for PCS in felix devices
>   net: dsa: ocelot: felix: add interface for custom regmaps
>   net: mscc: ocelot: split register definitions to a separate file
>   net: mscc: ocelot: expose ocelot wm functions
> 
>  drivers/net/dsa/ocelot/felix.c             |   6 +-
>  drivers/net/dsa/ocelot/felix.h             |   4 +-
>  drivers/net/dsa/ocelot/felix_vsc9959.c     |  11 +-
>  drivers/net/dsa/ocelot/seville_vsc9953.c   |   1 +
>  drivers/net/ethernet/mscc/Makefile         |   3 +-
>  drivers/net/ethernet/mscc/ocelot_devlink.c |  31 ++
>  drivers/net/ethernet/mscc/ocelot_vsc7514.c | 548 +--------------------
>  drivers/net/ethernet/mscc/vsc7514_regs.c   | 523 ++++++++++++++++++++
>  include/soc/mscc/ocelot.h                  |   5 +
>  include/soc/mscc/vsc7514_regs.h            |  27 +
>  10 files changed, 610 insertions(+), 549 deletions(-)
>  create mode 100644 drivers/net/ethernet/mscc/vsc7514_regs.c
>  create mode 100644 include/soc/mscc/vsc7514_regs.h
> 
> -- 
> 2.25.1
> 
