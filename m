Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A93683C3E02
	for <lists+netdev@lfdr.de>; Sun, 11 Jul 2021 18:36:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232075AbhGKQjb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Jul 2021 12:39:31 -0400
Received: from mail-sn1anam02on2110.outbound.protection.outlook.com ([40.107.96.110]:12225
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229817AbhGKQja (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 11 Jul 2021 12:39:30 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UPa3mZc0ELXtOspTFSGePrGDWIacM1KUIeaLfW31DZoRiZ2NL0TTjhaVE6t8oF3/F6Jwc1zH/49aNbppd5tRmtKrOB7bbOyJeo3rNt1a6FYfqYQlHw19jehjvkOOscxoQaR9Tins01eU0BPEOK8P1n7NAd+TwZzL4EY5iQUj9P5xCeVjWEYXdktiD2WKa44+vT/wgIMrBEg5aDfYQL1ngKKipf6xXGEksy6aKmfVqBCw4AS/fGBeOvAaDVrbZ02V9ur8+a9FpOh+T/Vz7UNd7FmyWn5rqUZ6SPKqFcFmxund/DJX70W6OhUObO0I/pAgVioAMniwurt3e7DFOj3r2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kt+Gi6vfczkLUw28/k21Fxo+cPdjU4tugWtKDTq5DtI=;
 b=i0aq+CJD3HKVRKlkYyQ/ei2QO04ZPWIhJ6Yf3e9ZHWhMoNASFHOVz6A4p/GSqUqgVt6OeIPo0/uw4XeJhETKu7c6sBVDi7z1vC3Vbx+N/4nraBhe8CzO28egs1h0eD6ke0WZjlLyT0EGmt7FL5gNYntHt2TNxDhM3Q4OPfoUnbe0qSye9RuuFDG9bD0tcn7CXPHFjIQtZW146hYzZSA6l7oRahgpEv16P5a4H9PAOdB/9OL4lIIE/2WvXlDgONdFjd5AgzaUW8Xtnlo8P0+rhRDv+ICCvPbcF8CfCN9cgJQ2xYwclPRU+mr9xR72IUfJ3ATu+UabH3VTOF9/H7hcbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kt+Gi6vfczkLUw28/k21Fxo+cPdjU4tugWtKDTq5DtI=;
 b=Jz1sfCptJ6KNyj4lvtc36BFhd1/7GbqskyYN1DZdWaNmrNUI3hv8W39vBcMZ/R/fhI29PFUer6MGf3y8wOdwoQ6E33xeyga5phtk9qO3ua3t5XkdRLu5a/vSZTFyAttrUc4GMwbT1aHx7k+U35BgDcS8aeZtX+h7LApx3g1spK8=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by MWHPR10MB1759.namprd10.prod.outlook.com
 (2603:10b6:301:8::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.23; Sun, 11 Jul
 2021 16:36:42 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::e81f:cf8e:6ad6:d24d]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::e81f:cf8e:6ad6:d24d%3]) with mapi id 15.20.4308.026; Sun, 11 Jul 2021
 16:36:41 +0000
Date:   Sun, 11 Jul 2021 09:36:38 -0700
From:   Colin Foster <colin.foster@in-advantage.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        claudiu.manoil@nxp.com, alexandre.belloni@bootlin.com,
        UNGLinuxDriver@microchip.com, linux@armlinux.org.uk,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 net-next 1/8] net: dsa: ocelot: remove unnecessary
 pci_bar variables
Message-ID: <20210711163638.GB2219684@euler>
References: <20210710192602.2186370-1-colin.foster@in-advantage.com>
 <20210710192602.2186370-2-colin.foster@in-advantage.com>
 <20210710195318.jq3xu2gkbttmcsfy@skbuf>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210710195318.jq3xu2gkbttmcsfy@skbuf>
X-ClientProxiedBy: CO2PR05CA0105.namprd05.prod.outlook.com
 (2603:10b6:104:1::31) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from euler (67.185.175.147) by CO2PR05CA0105.namprd05.prod.outlook.com (2603:10b6:104:1::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.11 via Frontend Transport; Sun, 11 Jul 2021 16:36:41 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 22710002-d99c-4848-e8f0-08d9448a100a
X-MS-TrafficTypeDiagnostic: MWHPR10MB1759:
X-Microsoft-Antispam-PRVS: <MWHPR10MB17597D824DD567B1AA71013EA4169@MWHPR10MB1759.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xPffMV7ML2CB5MIygbzSnE9N41AUTO6IJxUrjurFGVY2i0GvYUEpCCvFNX6FoJP8MBXavjATEk2GJuQU0b7kmnimoyocR9ERm/wp4jgR45+O/5+YTOHiZZai3AHAkH8tiJy5BqDqEQCc1YufvJmGyAO6K+eH0XR1Q6VRKmDrxe+0+Bq3WnFp2FXJePMdzkM6x3qguCyAy9iMRXGuDqtky6aCVgcISD1bwRvPrRSO0b890aLRViWVo/WTKvIF5bhkkjWLBXkiBYhpGzocAToz4EiWi7UcP7v/pRlIlqfLJ1MXHo8yddIWFc9pQ/9MTIXCkXXaIzI6n9PffvwLyPquu72Vu2hLtp2QjgCAZpsGpoFC4CTr+rpmdIGyZHrpDLxSvycpQMUtnwUXKTN6rZHQN7zgl8Hlew5AuwOKXtynZRTBw5xHhKczVKDqLk3rmWOXydGZrTlG87Cmkagfl1IWkj1y99HrDZ65uYl+0P/p9nMRPr5RO9EA29LqI/h9kW3gUBdut2hpv8eWZyGLU0vyDPuRv5GH6VyShzDjXqU0aCPb7WJZyH77aE+fzW13ffsEJngALIWfV0r7D8qVgAWpJVeaqQjM2mbmjBmRYwjq978VnSec86AXlZ2FSh4DRTizHhFdT5IiK6xNRW9oGrXIp3p5ZJjg5T/lbj2OsPzlH2VLriQOtUM84p2WMyfZkxkb92cUiO82iVo2mlGY88pHoA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(376002)(396003)(136003)(39830400003)(366004)(316002)(4326008)(86362001)(66946007)(478600001)(8936002)(33656002)(66476007)(83380400001)(55016002)(8676002)(7416002)(186003)(1076003)(52116002)(6916009)(26005)(5660300002)(6496006)(38350700002)(66556008)(6666004)(9686003)(956004)(2906002)(44832011)(9576002)(33716001)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/h2GXIcXQ9iW8l08ju2859oycqRgUiFovRUahwSc2DMqUqABLRXZgeF/x2tV?=
 =?us-ascii?Q?+0K9Nx6v2fz1gboVfFY/Qzhpgk9G6zlRQQEIGSfW191drHcxkD2L5D2d2scV?=
 =?us-ascii?Q?tT0F7GMCU7SobFva1bfq/5VsEkX9BLh/RKSE50Xd8zmHYBv3cR4Kc7Lb3ofV?=
 =?us-ascii?Q?dsE0wNB6J1Byr79yaQRj+u+koMLrXMYedKYuZOeXHTgDCVA4nUxBywYk3/1p?=
 =?us-ascii?Q?QPFa1/72zevV0kPIdcvVjTuXEQysNnaPpia06m1qZXKKLAMfci4cFr34wRlL?=
 =?us-ascii?Q?3riGixretACH8uwgz/M7DqksAYArLaJSubEZlHGIHfRt6incUhmGZTq7IDuC?=
 =?us-ascii?Q?lJlF/H5efOWutWTrSrGlvlUPiue8x3GLmu8Aso9BzazVw1PFIfYFrz14INKh?=
 =?us-ascii?Q?lGzSizrBNm4Hck/WVQFDXTrtPkGiKa9iWQ/PMqvXw9bK8RuGan5grzeQasbv?=
 =?us-ascii?Q?5DXC59wJlI0J8j1+1XuTzC8325clnxq+lkBTRBfmfanrG++TyudNGXLj2ntC?=
 =?us-ascii?Q?DZt4yIVYdNZbcJ44hS1sB+aMHmvu29d494umshgncVOdX4Sfng6UjjKqljLY?=
 =?us-ascii?Q?53m9xi/0USAQ52LNqusfx2rAE4Glu7z+UbisdZm9Zn8NdalJ+A/QfV+VwaAJ?=
 =?us-ascii?Q?0njf8THCvX2K+4JS3B9wOZxQbR7t6DzQ/ggjFHQPJQV5cABQDHUEQ98hvdwb?=
 =?us-ascii?Q?mDmPF6tJn+0KdJjAgj/+PcgloDmUECpuqtai3ra5M/DY6idjCMaEBcUmMIAU?=
 =?us-ascii?Q?5ddAJoQRBz5tf+BnLJ95C1iCd5Kc0ZLbkIZQR/c38gWI0d3CwWz+CHQSo1qJ?=
 =?us-ascii?Q?5AasyUVAlOFRNkQuIxo2QpRulLLDr4Bw9PsXmY5pFXfpFCFPbcrrlG32xnjE?=
 =?us-ascii?Q?FP4rMqquoxBFBwe8qFzbMmBT7y7mQfxpX+J+Z//0yK8Y6SLzbtrO9gBhKzw8?=
 =?us-ascii?Q?1PlhjBnUAGCP71nG2F0JbGWKnU2Ej1AuMqKd6mUX7Etu5VcDbziHYnLrK161?=
 =?us-ascii?Q?XyekSu1P/vUawoHfsSnNjbnetcBZM6M1XDMNbTDNFiL3//SJcY9M22wttFsj?=
 =?us-ascii?Q?VAi2se0ll6BXBHvd0mz3Qk30uMO2iN4EaMI5hSphPgjTPdjM3SGLVm0Hz57b?=
 =?us-ascii?Q?W0O9aTm3cOOWz3g/fGtdnPrbcu/3NvG1VggoXSIG2I+Bs6T2Z7HGzI8GP7pv?=
 =?us-ascii?Q?p5/ecAtGeq5RR4UFEKCT+r5SuqH3teSwQ7mPsMXVwJurKbuPxBfRr96Irzk3?=
 =?us-ascii?Q?B6lOuB4oe7NN+Z4Da+y3MctnrJ5Z3G8mB4hbxxfUYJip2YnNxoTaA384vaqF?=
 =?us-ascii?Q?F848e8dGNYP6h6zH6bWyaul0?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 22710002-d99c-4848-e8f0-08d9448a100a
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jul 2021 16:36:41.7950
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: U/X4aMhHnJ6D9850OFtxpXdSy0xkljUYzpssX3cYdfVqAPKZxm4UzrimMMJlRMtKgr7PuuENauEHFcZHk7iUHCjOIOHEKnvO+y5J0k7BRRY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1759
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 10, 2021 at 10:53:18PM +0300, Vladimir Oltean wrote:
> On Sat, Jul 10, 2021 at 12:25:55PM -0700, Colin Foster wrote:
> > The pci_bar variables for the switch and imdio don't make sense for the
> > generic felix driver. Moving them to felix_vsc9959 to limit scope and
> > simplify the felix_info struct.
> > 
> > Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> > ---
> 
> Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> Just one comment below.
> 
> >  drivers/net/dsa/ocelot/felix.h         |  2 --
> >  drivers/net/dsa/ocelot/felix_vsc9959.c | 11 +++++------
> >  2 files changed, 5 insertions(+), 8 deletions(-)
> > 
> > diff --git a/drivers/net/dsa/ocelot/felix.h b/drivers/net/dsa/ocelot/felix.h
> > index 4d96cad815d5..47769dd386db 100644
> > --- a/drivers/net/dsa/ocelot/felix.h
> > +++ b/drivers/net/dsa/ocelot/felix.h
> > @@ -20,8 +20,6 @@ struct felix_info {
> >  	int				num_ports;
> >  	int				num_tx_queues;
> >  	struct vcap_props		*vcap;
> > -	int				switch_pci_bar;
> > -	int				imdio_pci_bar;
> >  	const struct ptp_clock_info	*ptp_caps;
> >  
> >  	/* Some Ocelot switches are integrated into the SoC without the
> > diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
> > index f966a253d1c7..182ca749c8e2 100644
> > --- a/drivers/net/dsa/ocelot/felix_vsc9959.c
> > +++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
> > @@ -1359,8 +1359,6 @@ static const struct felix_info felix_info_vsc9959 = {
> >  	.num_mact_rows		= 2048,
> >  	.num_ports		= 6,
> >  	.num_tx_queues		= OCELOT_NUM_TC,
> > -	.switch_pci_bar		= 4,
> > -	.imdio_pci_bar		= 0,
> >  	.quirk_no_xtr_irq	= true,
> >  	.ptp_caps		= &vsc9959_ptp_caps,
> >  	.mdio_bus_alloc		= vsc9959_mdio_bus_alloc,
> > @@ -1388,6 +1386,9 @@ static irqreturn_t felix_irq_handler(int irq, void *data)
> >  	return IRQ_HANDLED;
> >  }
> >  
> > +#define VSC9959_SWITCH_PCI_BAR 4
> > +#define VSC9959_IMDIO_PCI_BAR 0
> > +
> 
> I would prefer these to be declared right below
> 
> #define VSC9959_TAS_GCL_ENTRY_MAX	63
> 
> and aligned with it

Done
