Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2BB2331369
	for <lists+netdev@lfdr.de>; Mon,  8 Mar 2021 17:29:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230429AbhCHQ3B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Mar 2021 11:29:01 -0500
Received: from mail-eopbgr70055.outbound.protection.outlook.com ([40.107.7.55]:18832
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230439AbhCHQ2i (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Mar 2021 11:28:38 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gNVhv2uxiQqEHB4Ejmi4WRBEVIhQjERqqOo6u382F4jG9lOB/SLCKlGlwmv+l2lMenrQuCqw+HaBdyw1RkNsuYZromCXD+GA5HtWTEJxBwKdEO+aeoSl/oIl9uwyXBMCc+degSlSNSpa2bsT0F5MCjruxG29L+a9IV5sOh9F4iIwmuOwk82lVK/NTf2hWNbom8P6/xy+o9pntgqZlvtomIEDOPbIpXSnx1CleG/QMsWJIBl31A4qi+ozPVvTl/EIN+0I4FzZ5biXwnnKqh5hs7PgxQUnby8680AiKvfUFwlCapNTsI0j3fUzkVVgowdOqzTvIb/o3zRA7UK9gv0Jtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6eFH7RbzDd1DfXEQDbNikC/nFOYpd1ns2ocx5Odg/ac=;
 b=Tgg0C6iveaLz3AXGvt9yR56lLIWSocCYmRv/CRcXzYwn/5W6lJOEKdvFNFaPbRnG8Ml+ynyC+OWx2fMjtsifk1aW5AVfG5JJyZBYKA54RCpfeTxpBbfw/LPp87C3FIcsO9d7LQQMbKzpFOMHeVFKX9mGlnTb8aDRPoh8Cm4wrxrtvNnqRDF9allci+8X896w2a5AO3a4ovkA9ezO+EP+VD0gTQgDTYHUNsuldgr+DEAiPHcxr+DEeIe0AgCJNgb/X3H2MVA6KW2OmGXWxnMgO5l4Ob3d6Ia1bZEEA4fhRIiJz1C+1k9W1TEkvsLKSXl/RNvtLoJYqVeSRFpvsnne7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6eFH7RbzDd1DfXEQDbNikC/nFOYpd1ns2ocx5Odg/ac=;
 b=L9MmAz8CKcl6tBb4MxrZVDuJG4waL8saFeoE5NPoX9BjO7SE5qif4ldgd/+X+si71EorQ/yUEBTpX065zwa2QQ1g39vpTII1yCQe+5px3xcczeF0m9ndnGSTwuv5DA3wUz8FLQc2cAClksGGx+I2xHIRUCeTKf2vcBoQ8sWGqSk=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR04MB4770.eurprd04.prod.outlook.com (2603:10a6:208:cd::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.19; Mon, 8 Mar
 2021 16:28:26 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::1cd:7101:5570:cd79]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::1cd:7101:5570:cd79%7]) with mapi id 15.20.3912.027; Mon, 8 Mar 2021
 16:28:26 +0000
Date:   Mon, 8 Mar 2021 21:58:11 +0530
From:   Calvin Johnson <calvin.johnson@oss.nxp.com>
To:     Andy Shevchenko <andy.shevchenko@gmail.com>
Cc:     Grant Likely <grant.likely@arm.com>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Florin Laurentiu Chiculita <florinlaurentiu.chiculita@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Pieter Jansen Van Vuuren <pieter.jansenvv@bamboosystems.io>,
        Jon <jon@solid-run.com>, Saravana Kannan <saravanak@google.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        linux-arm Mailing List <linux-arm-kernel@lists.infradead.org>,
        "linux.cj" <linux.cj@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [net-next PATCH v6 10/15] net: mdio: Add ACPI support code for
 mdio
Message-ID: <20210308162811.GB2740@lsv03152.swis.in-blr01.nxp.com>
References: <20210218052654.28995-1-calvin.johnson@oss.nxp.com>
 <20210218052654.28995-11-calvin.johnson@oss.nxp.com>
 <CAHp75VdpvTN2R-FTb81GnwvAr_eoprEhsOMx+akukaDNBrptsQ@mail.gmail.com>
 <20210308140936.GA2740@lsv03152.swis.in-blr01.nxp.com>
 <CAHp75Vc2OtScGFhCL7QiRsakrQAZYE6Wz-0qzmz5uB63cjieQw@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHp75Vc2OtScGFhCL7QiRsakrQAZYE6Wz-0qzmz5uB63cjieQw@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Originating-IP: [14.142.151.118]
X-ClientProxiedBy: HK0PR01CA0065.apcprd01.prod.exchangelabs.com
 (2603:1096:203:a6::29) To AM0PR04MB5636.eurprd04.prod.outlook.com
 (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by HK0PR01CA0065.apcprd01.prod.exchangelabs.com (2603:1096:203:a6::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend Transport; Mon, 8 Mar 2021 16:28:18 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 56285c54-e3d0-4240-135c-08d8e24f3339
X-MS-TrafficTypeDiagnostic: AM0PR04MB4770:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB4770A23E2FE837B24C7A5787D2939@AM0PR04MB4770.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AqssUcFWTX3JlajQhTxohq+OtG2xymZ9iQM1Mud7+wuUNa38IMU/viq08rH0lzPPeHraIPffifYZGHIXi6AM6R1hOHN6SwVYa7TDFrPLetWI1sIdPMSICRZTW7Ef7+sZTZ+Hh68PjjA+dy34KPLeAZ+l76MIVV+S49I0E7yvBtHF7ujRD1AZTezP1KZsVVA34NG4OKNR79T688aZQIPZceO7iS4IazGmvdukrTslVt5Q8uk47hwrNDekz3nnZ+bXSRU/CXjsQrgXZ08fkAZsmQpixobQzIcfhxOcgeym1PGdUn47f2I6UPAHPY2Sw/O3fJZU+Cf2oT7/LcMBnf7Sehh2OEqLhHZBqxzS2+RehoV9ccVmwBpDgc4xSN3oGq9VwoBY7Dit5dHpuAHlB71Wl22b28EP0ByP0RxEIvsPrDT6zrDPyRThNyE7sewJKmld9aB7d0DsX3/LQ0b9sCaThrJKPX8IAsd8tMLDEpd+M0BV1FDvugIX8OEBjWRdxJcnL9QtoGQYIPPWSm6A1xX9TPzw1I5gRjLap8cPBuyCudMcTYkduws0Zavh8WGkL0pH
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39860400002)(376002)(346002)(136003)(396003)(53546011)(6666004)(1006002)(44832011)(55016002)(8936002)(55236004)(26005)(6506007)(1076003)(7416002)(66556008)(478600001)(66476007)(66946007)(6916009)(54906003)(9686003)(8676002)(7696005)(316002)(4326008)(33656002)(86362001)(16526019)(2906002)(956004)(52116002)(186003)(5660300002)(110426009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?WjsfSu/LvMn3g2Hhw9Y6AJT3XreTaL51ObLaJBc+eJF2J3oUP8HxOGeDqq+4?=
 =?us-ascii?Q?CKPUs1MiwsbEzL+voY/a1Fy5cwWuFFfGHqy+N1dDeKvGLwg0pQ2vZg8nlLD6?=
 =?us-ascii?Q?9ShJnSCYFBHCUAsMJKttDsPpQMyBBruVuQAPViy20Tusjg/Oe4aL7UVkMs4g?=
 =?us-ascii?Q?iWUGID0N80gu76C1Yw1k/KmV0O6KVL9Ju5AyXGDRH9mVWzUm9biksHdekh8B?=
 =?us-ascii?Q?BzwwyQA4J1hHUCpX2r4DBka2a3ik1E1pWJVXpt/2avxHLeQJHf4Zk513Q3lP?=
 =?us-ascii?Q?DNoW+MqGzRGSQQ0e0eMascW71AKv5nCeS/zyLCZ1hCMsa4FRW9K1nEoAb4gV?=
 =?us-ascii?Q?FVLqIZh21/FUIsWYwp/+9BJtD66eQGWPBKlTIaW4kvVUofeiQjkILhWFtoUr?=
 =?us-ascii?Q?QTxazDlPpdSDOVscaT4HkJmMvKwQ59Jru5AX5hK0ZcHy9ff6/6E5f1/d9cQw?=
 =?us-ascii?Q?a06IPaPLzrdmB9KlkG5oVfF2oxkG21WfDrmxfnIYJl3iL8tP9oiWZP4Bg2rV?=
 =?us-ascii?Q?sg9DDXC2KDJV4GJTC7xAeo3nh8v2wxv2GuRGV8DiHUEmBA1JQ2NxBgcau/bX?=
 =?us-ascii?Q?p6Q6ZIaElt0Gdu6iSkeb56WsA1lt8pOKmwFSBtocIAOiaibTMqyjAYno3PTV?=
 =?us-ascii?Q?udXFt9t1McJiJdkwjZc79GS3NK1TfFxnoYehfgVstPI+F37Nf090ewG82Vpo?=
 =?us-ascii?Q?5Fwpg59UYxggWYFvpyXhNfhLxz57As+k6NsdAgU1aZxLdYNLAYxKH4AiHZE+?=
 =?us-ascii?Q?xyxTF3a+5BGK+V0FVA6hUMoWrnNcyUiOQkBvBUi3ahU1mHaX7gnhRglbRouY?=
 =?us-ascii?Q?aLd2+BsRPgYzGIku0dZZ/ji131gHkYCiyteZeWLPFUourmQJn/1qwO/VAz8L?=
 =?us-ascii?Q?ekqVkrxkeu9gEO2mXs6q8TXrM9DhVQ1anR9RSINJLZjUJ1zwk1KgC7BgdVCW?=
 =?us-ascii?Q?Go8flvnvsaNHqCziS5fecEp4t7eGvPQ0PJGrW0hdRgKZW++ghjmzX2g/WT2g?=
 =?us-ascii?Q?/Pn/6VNRemhjeSuDLoxGq6R4LcTzi4OTazWpYePq1pLbLtZ/3edULVQL6dhH?=
 =?us-ascii?Q?2SpCAGcVAbS/wJOLqDQvZUB/sOidGQ5O/HI/2aqhUEMiSsuvv9BDEmM/q30f?=
 =?us-ascii?Q?pcERSZXjZmvfMgtvRU5JfiJ0+R4YJNPlrfe777Ar1FzLLmO1MzZjdXXGMz+9?=
 =?us-ascii?Q?FovN1P1KecMxBdlz22wKQv+TBqAB2ZZzyZxM1ytHlFVFyZSxDD9rNMllWMwy?=
 =?us-ascii?Q?UNkSl9Hl2MHkEIijBBp1FfU4RZip+qIhzMFYXpY5tT0dQMzrLfTZhzHi2xbY?=
 =?us-ascii?Q?ULUqY7eBaJeogAp32j8YU4c1D0+kCIziokV78aYQ7XBdJw=3D=3D?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 56285c54-e3d0-4240-135c-08d8e24f3339
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5636.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2021 16:28:26.7284
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZemzRZ6WHB0BVXpUPXjr5O4QGDXkyB81L3MTa5a0TY3/ouCmMZrB51mYA07HSsUlkC51gWjd6J8Xx8SxIJVskA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB4770
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 08, 2021 at 04:57:35PM +0200, Andy Shevchenko wrote:
> On Mon, Mar 8, 2021 at 4:11 PM Calvin Johnson
> <calvin.johnson@oss.nxp.com> wrote:
> > On Thu, Feb 18, 2021 at 05:08:05PM +0200, Andy Shevchenko wrote:
> > > On Thu, Feb 18, 2021 at 7:28 AM Calvin Johnson
> > > <calvin.johnson@oss.nxp.com> wrote:
> 
> > > > Define acpi_mdiobus_register() to Register mii_bus and create PHYs for
> > > > each ACPI child node.
> > >
> > > > +#include <linux/acpi.h>
> > > > +#include <linux/acpi_mdio.h>
> > >
> > > Perhaps it's better to provide the headers that this file is direct
> > > user of, i.e.
> > >  bits.h
> > >  dev_printk.h
> >
> > Looks like device.h needs to be used instead of dev_printk.h. Please
> > let me know if you've a different opinion.
> 
> I don't see the user of device.h. dev_printk.h is definitely in use here...
> Do you see a user for device.h? Which line in your code requires it?
> 
> It might be that I don't see something quite obvious...

I thought of including device.h instead of dev_printk.h because, it is the
only file that includes dev_printk.h and device.h is widely used. Of course,
it will mean that dev_printk.h is indirectly called.

Regards
Calvin
