Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59A1F37B31E
	for <lists+netdev@lfdr.de>; Wed, 12 May 2021 02:41:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229964AbhELAmi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 May 2021 20:42:38 -0400
Received: from mail-dm6nam10on2113.outbound.protection.outlook.com ([40.107.93.113]:62994
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229736AbhELAmh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 11 May 2021 20:42:37 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hKGNcBEhONyNKBh1Vm0DwpLS0kMrRFg2O+hUVGtrAAlmcNdUSXdS+/DFD2y5eAW8zF6oyBLtk9OWP0updhXvRAjKWNiWzA7eFC0KFJsVtWfNcW2ijiAGZknGYVWcpGHPp4EjJ8im1hwpq5oiUuZd44UEfFloI41DvaB0aFjIBM4kFf9hdjQ5Z7iyeMLt5UiZjoXyl5dlGNwCGfj8OnaZy0mcT8NOChpDJg5Vygz81up3JRA2j/jCfAtT9IX1OWms6LsJL6TT7Ebophtm5T8JBt6pH8JxSM6GMcK9uTyTXU16sP45Go/CwDRoiReup2RbJl+FF0qvRw4Ua6hNPh74Xw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=08a1txlpF2tW81TlIBJJFYiuK5fTExUrtU8CXDKdidw=;
 b=DXlROxjjXeW2MVNgRtNc4PKVyiG/Hj/4tEGnFg1lEWvE1xdJFbwiJ1bQjMpUy8rKDzG2CbD8DpoewmS2uDv66uPvxN0ekxs3G7J2dhYaH5b/zd/nxrxeDjHDHF/gmzBwVhWS6OrIUm7MfZLZxpz9eDLkADmGFpTDeM6YphKo1p3WfmDzJ8hpDnynXyXRKm6IHtZRHAlVOH62zXM5TwpN9cTj1SsxzBKr50uNLFHUJ7dP0zXV2NRvUKc3vrma0k1+oFPIzohf8RrJ2hVrnnqgN55nlW3NEbO4tCVLTrhS2sJ3QP0XVPSKVSux5+8lXbr5vJq96wIUNFcxNdL/HO3VMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=08a1txlpF2tW81TlIBJJFYiuK5fTExUrtU8CXDKdidw=;
 b=gWp6U9v1EZvcx75ZescvyuWkzxwVs2eNqZb9kf3TFHYpEslMGl/Ch7rvzj4UeRDPyIWDhzhHhxIurC2ohtzhrxcQgxPEDMWuuQHEAVYjZB5C5hARHi0noFTU7X4Jp2iZa5V4nI9PFQZ2PtgDObpspch3vGN1fB/THC9TbSBy1U4=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=in-advantage.com;
Received: from DM5PR1001MB2345.namprd10.prod.outlook.com (2603:10b6:4:2d::31)
 by DS7PR10MB4912.namprd10.prod.outlook.com (2603:10b6:5:3a1::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.25; Wed, 12 May
 2021 00:41:27 +0000
Received: from DM5PR1001MB2345.namprd10.prod.outlook.com
 ([fe80::58ab:dcd:3271:cb5]) by DM5PR1001MB2345.namprd10.prod.outlook.com
 ([fe80::58ab:dcd:3271:cb5%6]) with mapi id 15.20.4108.031; Wed, 12 May 2021
 00:41:27 +0000
Date:   Sat, 8 May 2021 15:26:06 -0700
From:   Colin Foster <colin.foster@in-advantage.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Rob Herring <robh+dt@kernel.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "supporter:OCELOT ETHERNET SWITCH DRIVER" 
        <UNGLinuxDriver@microchip.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:OCELOT ETHERNET SWITCH DRIVER" <netdev@vger.kernel.org>
Subject: Re: [RFC PATCH vN net-next 2/2] net: mscc: ocelot: add support for
 VSC75XX SPI control
Message-ID: <20210508222606.GA20333@MSI.localdomain>
References: <20210504051130.1207550-1-colin.foster@in-advantage.com>
 <20210504051130.1207550-2-colin.foster@in-advantage.com>
 <20210506102204.wuwwnoarn5r5cun2@skbuf>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210506102204.wuwwnoarn5r5cun2@skbuf>
X-Originating-IP: [96.93.101.165]
X-ClientProxiedBy: MWHPR22CA0022.namprd22.prod.outlook.com
 (2603:10b6:300:ef::32) To DM5PR1001MB2345.namprd10.prod.outlook.com
 (2603:10b6:4:2d::31)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from MSI.localdomain (96.93.101.165) by MWHPR22CA0022.namprd22.prod.outlook.com (2603:10b6:300:ef::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.50 via Frontend Transport; Wed, 12 May 2021 00:41:25 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ec68f1d6-8851-4f39-8fc1-08d914dead05
X-MS-TrafficTypeDiagnostic: DS7PR10MB4912:
X-Microsoft-Antispam-PRVS: <DS7PR10MB4912B46A5A7B772550DFF019A4529@DS7PR10MB4912.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kPC5TYk0MVn5oQT4I2gOMCCxKm9lJlyHOyNZt5//30lALOsAim/NGkzaSQb/THXg10iu/GQgotoZVgQ7U8qKrBMo2aOVGXnnY+MpQoUSYO22iNfCtHxTsnntkzeR3037WevVtwFQXhO9cP88gZu1LyY4U8q+4vjol0hHAn57NxAhBnX1sDmNNEKxApEvmUSJWv8DrVC9XSK8WugB79TQ6MBlv+jReNoJUdhMoWB1x2U5NLiRZ1fC55A84ZNi647OQwxc5zZmxENCq1pWRRt+8e7b4tdAUwRLNK8MpwDCRnmR41GcmH7RLn/1Z1zWQPDpNgstk6WGGagzYaaB4GGdZ4kPtXP+VPSg2Rnl9DL3dzBpeoGoZ7mYgrzXxMdB5nwlW1qmE6AG1CHgwowcI4qGq1agUO6jX+WZFN4AQQuWJGW5MsG3wwlnIcUztE6HfCTOrYfUnlD94FxkUArQItsj8AqE4uYXqVJBhmaOmAFtgMFLYgP1p1dhQs6LDqhBlWp9Ckdbp8LoAljhubQqH8TcwLqj/6liVzb3SbBSHF5nO649Efa6Ml/xf7fFORoabV6nfwkxjRH9iplnHIlPSz9D9P0n7eJmHC75juCJuYDN6pbpJg1N3lwkvAPojBGQntEO6kPWGV8xc3iSjaF5dIuX2A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR1001MB2345.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(136003)(39830400003)(366004)(396003)(376002)(54906003)(8676002)(478600001)(16526019)(8936002)(186003)(6506007)(55016002)(7696005)(6666004)(52116002)(66476007)(30864003)(44832011)(6916009)(9686003)(66556008)(5660300002)(26005)(38100700002)(956004)(1076003)(4326008)(7416002)(86362001)(2906002)(33656002)(316002)(66946007)(83380400001)(38350700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?GXsGZCW6xxTgDSO0OIHB0v0BmBjY5egTKYLT9/NXOP0RtxlRHlbuqwo2cYBV?=
 =?us-ascii?Q?OgfDAJmWXzIoUAY1XccZnzTvU6xgvyvXYPemD/5iww9EBw6VTjQoGSaWyCTA?=
 =?us-ascii?Q?kZf8iH0w5YAr9fasKL0eSIv3/qDbpjxjPcDwOq5vLzdY18GvanmS3jOZ3VlU?=
 =?us-ascii?Q?EhE2Sj4Gg+wFQGiQdb2XaCfwXN61Rl2RDtRhF/BcY6n4ZkvD0K3bng/GcjPO?=
 =?us-ascii?Q?W5SvIzgrQZMWtSA4kJr0P61DtjNgIUt/nDhzkwxGvAtPCzKMP5/0EH9hrNop?=
 =?us-ascii?Q?ns1xARlYhRJ1fGWdjVA1UEXb0zej+5KAFeKJKAq1Q7CMuFjVDnRDrOXj277Y?=
 =?us-ascii?Q?Z7lbgd0baX5do7kKwYSLTv9pi7SrHDEKkeHWiDykiKLHG/801/6Vd+k0K3lK?=
 =?us-ascii?Q?gJgGGKHiq2o1avtqGIUEDwnvVvWb4XgpLC6Iz66iUNIKWnXTCsQx+qPurehn?=
 =?us-ascii?Q?cJLi6QVzpqSKeE7MSaCeYGfLpiAahDLQJYzQ49gheaHIp93xQVqiBbYAZXtX?=
 =?us-ascii?Q?n1qCEoyVIrFigvRGWXiub1ZP9Cb+P2IZ2eSBK7xSlhQrUx1jJQTKrKGyhQ5H?=
 =?us-ascii?Q?pfVdhARRvMH/w8fb37HYKBsAAABdUTiITINfX8V+4USGepaXAmgUctfXbRaT?=
 =?us-ascii?Q?lw6ClwFHUyFRXtZQTHXpFSgLxEmrCo+lpiPgO5zYHZHb9kMiLmkOAvXM3fpk?=
 =?us-ascii?Q?cl7A7t8ZDzxmeIxuhQSIznRk6pOt6xGhu1AgflXczLBdf8UABCeHH8AS0ySW?=
 =?us-ascii?Q?eIrBB5AHGhdlFN761wL0giefszuR0fiJxI3ekiAid7lycdYduuCdK/ZJXln+?=
 =?us-ascii?Q?ugASm21ukj1tCXohTrjKcn1ygy0k1J7luFi1XxNNRzABI3TtK38CiENhaCKj?=
 =?us-ascii?Q?lgVUq56ydI9iQ+ELHBlCaer5FEIVwpItibogbgGcDOmZBpvTx2RJj20uyHtY?=
 =?us-ascii?Q?KzIoVnoPq+RNhbVJYxdKEjD6zfQ1KgCDZJ2AFh4GsVgn4tguHBT0mRl9UQrq?=
 =?us-ascii?Q?pDwGkTzluMm78eSX1JwdVFPnpa57HY6NqMmDFFWJQYmwsnHuCiG4iiVDYHSj?=
 =?us-ascii?Q?bp9SXhNbjbk0WxDRjnTFgiFH6i7FLgdPpLLc3lGcgrI8UuYyBEQMgD/QUGCl?=
 =?us-ascii?Q?ow+nUQwkO2ydQ+cod1h8wv+k5V1uG7O9LMyOKVeBwZz4dlbtYWwGT61jqp0+?=
 =?us-ascii?Q?JItvjtlBFJ38SibpbJt7TZMyLloeiU3oMqWFFwzWSm7mnhL3+fq3nSIcBLfA?=
 =?us-ascii?Q?SZ48xb/bSHySvgbehnrZ6DyLtVBmLfUuSAdT+JPh3A88JF329ffHe4R9GNKm?=
 =?us-ascii?Q?5ERMKhMQXp9WcqCFViGaypbo?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ec68f1d6-8851-4f39-8fc1-08d914dead05
X-MS-Exchange-CrossTenant-AuthSource: DM5PR1001MB2345.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2021 00:41:27.3700
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OA59Q6WpCMbQDWjEpX1SIYByDc/uRZ6irF5NFPAj+ouoZwH54tLmh7+TMf6IZjSjVa3jsc5JJZ433rLp5wCtHMuqfIdwXGoMRZwQvJSO35Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB4912
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 06, 2021 at 01:22:04PM +0300, Vladimir Oltean wrote:
> On Mon, May 03, 2021 at 10:11:27PM -0700, Colin Foster wrote:
> > +static const u32 vsc7512_dev_gmii_regmap[] = {
> > +	REG(DEV_CLOCK_CFG,			0x0),
> > +	REG(DEV_PORT_MISC,			0x1),
> > +	REG(DEV_EEE_CFG,			0x3),
> > +	REG(DEV_RX_PATH_DELAY,			0x4),
> > +	REG(DEV_TX_PATH_DELAY,			0x5),
> > +	REG(DEV_PTP_PREDICT_CFG,		0x6),
> > +	REG(DEV_MAC_ENA_CFG,			0x7),
> > +	REG(DEV_MAC_MODE_CFG,			0x8),
> > +	REG(DEV_MAC_MAXLEN_CFG,			0x9),
> > +	REG(DEV_MAC_TAGS_CFG,			0xa),
> > +	REG(DEV_MAC_ADV_CHK_CFG,		0xb),
> > +	REG(DEV_MAC_IFG_CFG,			0xc),
> > +	REG(DEV_MAC_HDX_CFG,			0xd),
> > +	REG(DEV_MAC_DBG_CFG,			0xe),
> > +	REG(DEV_MAC_FC_MAC_LOW_CFG,		0xf),
> > +	REG(DEV_MAC_FC_MAC_HIGH_CFG,		0x10),
> > +	REG(DEV_MAC_STICKY,			0x11),
> > +	REG_RESERVED(PCS1G_CFG),
> > +	REG_RESERVED(PCS1G_MODE_CFG),
> > +	REG_RESERVED(PCS1G_SD_CFG),
> > +	REG_RESERVED(PCS1G_ANEG_CFG),
> > +	REG_RESERVED(PCS1G_ANEG_NP_CFG),
> > +	REG_RESERVED(PCS1G_LB_CFG),
> > +	REG_RESERVED(PCS1G_DBG_CFG),
> > +	REG_RESERVED(PCS1G_CDET_CFG),
> > +	REG_RESERVED(PCS1G_ANEG_STATUS),
> > +	REG_RESERVED(PCS1G_ANEG_NP_STATUS),
> > +	REG_RESERVED(PCS1G_LINK_STATUS),
> > +	REG_RESERVED(PCS1G_LINK_DOWN_CNT),
> > +	REG_RESERVED(PCS1G_STICKY),
> > +	REG_RESERVED(PCS1G_DEBUG_STATUS),
> > +	REG_RESERVED(PCS1G_LPI_CFG),
> > +	REG_RESERVED(PCS1G_LPI_WAKE_ERROR_CNT),
> > +	REG_RESERVED(PCS1G_LPI_STATUS),
> > +	REG_RESERVED(PCS1G_TSTPAT_MODE_CFG),
> > +	REG_RESERVED(PCS1G_TSTPAT_STATUS),
> > +	REG_RESERVED(DEV_PCS_FX100_CFG),
> > +	REG_RESERVED(DEV_PCS_FX100_STATUS),
> > +};
> > +
> > +static const u32 vsc7512_cpu_org_regmap[] = {
> > +	REG(DEV_CPUORG_IF_CTRL,			0x0000),
> > +	REG(DEV_CPUORG_IF_CFGSTAT,		0x0001),
> > +	REG(DEV_CPUORG_ORG_CFG,			0x0002),
> > +	REG(DEV_CPUORG_ERR_CNTS,		0x0003),
> > +	REG(DEV_CPUORG_TIMEOUT_CFG,		0x0004),
> > +	REG(DEV_CPUORG_GPR,			0x0005),
> > +	REG(DEV_CPUORG_MAILBOX_SET,		0x0006),
> > +	REG(DEV_CPUORG_MAILBOX_CLR,		0x0007),
> > +	REG(DEV_CPUORG_MAILBOX,			0x0008),
> > +	REG(DEV_CPUORG_SEMA_CFG,		0x0009),
> > +	REG(DEV_CPUORG_SEMA0,			0x000a),
> > +	REG(DEV_CPUORG_SEMA0_OWNER,		0x000b),
> > +	REG(DEV_CPUORG_SEMA1,			0x000c),
> > +	REG(DEV_CPUORG_SEMA1_OWNER,		0x000d),
> > +};
> 
> I know I changed my mind, but if the regmap is the same as for
> drivers/net/ethernet/mscc/ocelot_vsc7514.c, just divided by 4, then it
> makes a lot more sense to implement the custom regmap accessors and
> reuse the regmaps from there.

I moved these to a new file, ocelot_regs.c, to be built with the ocelot
library and referenced by both the ocelot and this new "ocelot_spi".

> > +static u16 vsc7512_wm_enc(u16 value)
> > +{
> > +	WARN_ON(value >= 16 * BIT(8));
> > +
> > +	if (value >= BIT(8))
> > +		return BIT(8) | (value / 16);
> > +
> > +	return value;
> > +}
> 
> Don't duplicate, just EXPORT_SYMBOL(ocelot_wm_enc) and call here.

As above, I moved this to a new file ocelot_wm.c as part of the library,
with the prototypes in ocelot.h. Including wm_dec and wm_stats.
Otherwise these functions are only built as the vsc7514 driver.

> 
> > +static const struct ocelot_ops vsc7512_ops = {
> > +	.reset		= vsc7512_reset,
> > +	.wm_enc		= vsc7512_wm_enc,
> 
> You must be working on an old kernel or something. There's also a
> watermark decode function which you can reuse from ocelot (ocelot_wm_dec).
> 
> > +	.port_to_netdev	= felix_port_to_netdev,
> > +	.netdev_to_port	= felix_netdev_to_port,
> > +};
> > +
> > +/* Addresses are relative to the SPI device's base address, downshifted by 2*/
> > +static const struct resource vsc7512_target_io_res[TARGET_MAX] = {
> > +	[ANA] = {
> > +		.start	= 0x1c620000,
> > +		.end	= 0x1c623fff,
> > +		.name	= "ana",
> > +	},
> > +	[QS] = {
> > +		.start	= 0x1c420000,
> > +		.end	= 0x1c42003f,
> > +		.name	= "qs",
> > +	},
> > +	[QSYS] = {
> > +		.start	= 0x1c600000,
> > +		.end	= 0x1c607fff,
> > +		.name	= "qsys",
> > +	},
> > +	[REW] = {
> > +		.start	= 0x1c40c000,
> > +		.end	= 0x1c40ffff,
> > +		.name	= "rew",
> > +	},
> > +	[SYS] = {
> > +		.start	= 0x1c404000,
> > +		.end	= 0x1c407fff,
> > +		.name	= "sys",
> > +	},
> > +	[S0] = {
> > +		.start	= 0x1c410000,
> > +		.end	= 0x1c4100ff,
> > +		.name	= "s0",
> > +	},
> > +	[S1] = {
> > +		.start	= 0x1c414000,
> > +		.end	= 0x1c4140ff,
> > +		.name	= "s1",
> > +	},
> > +	[S2] = {
> > +		.start	= 0x1c418000,
> > +		.end	= 0x1c4180ff,
> > +		.name	= "s2",
> > +	},
> > +	[GCB] =	{
> > +		.start	= 0x1c41c000,
> > +		.end	= 0x1c41c07f,
> > +		.name	= "devcpu_gcb",
> > +	},
> > +	[DEV_CPUORG] = {
> > +		.start	= 0x1c400000,
> > +		.end	= 0x1c4000ff,
> > +		.name	= "devcpu_org",
> > +	},
> > +};
> > +
> > +static const struct resource vsc7512_port_io_res[] = {
> > +	{
> > +		.start	= 0x1c478000,
> > +		.end	= 0x1c47bfff,
> > +		.name	= "port0",
> > +	},
> > +	{
> > +		.start	= 0x1c47c000,
> > +		.end	= 0x1c47ffff,
> > +		.name	= "port1",
> > +	},
> > +	{
> > +		.start	= 0x1c480000,
> > +		.end	= 0x1c483fff,
> > +		.name	= "port2",
> > +	},
> > +	{
> > +		.start	= 0x1c484000,
> > +		.end	= 0x1c487fff,
> > +		.name	= "port3",
> > +	},
> > +	{
> > +		.start	= 0x1c488000,
> > +		.end	= 0x1c48bfff,
> > +		.name	= "port4",
> > +	},
> > +	{
> > +		.start	= 0x1c48c000,
> > +		.end	= 0x1c48ffff,
> > +		.name	= "port5",
> > +	},
> > +};
> > +
> > +static const struct reg_field vsc7512_regfields[REGFIELD_MAX] = {
> > +	[ANA_ADVLEARN_VLAN_CHK] = REG_FIELD(ANA_ADVLEARN, 11, 11),
> > +	[ANA_ADVLEARN_LEARN_MIRROR] = REG_FIELD(ANA_ADVLEARN, 0, 10),
> > +	[ANA_ANEVENTS_MSTI_DROP] = REG_FIELD(ANA_ANEVENTS, 27, 27),
> > +	[ANA_ANEVENTS_ACLKILL] = REG_FIELD(ANA_ANEVENTS, 26, 26),
> > +	[ANA_ANEVENTS_ACLUSED] = REG_FIELD(ANA_ANEVENTS, 25, 25),
> > +	[ANA_ANEVENTS_AUTOAGE] = REG_FIELD(ANA_ANEVENTS, 24, 24),
> > +	[ANA_ANEVENTS_VS2TTL1] = REG_FIELD(ANA_ANEVENTS, 23, 23),
> > +	[ANA_ANEVENTS_STORM_DROP] = REG_FIELD(ANA_ANEVENTS, 22, 22),
> > +	[ANA_ANEVENTS_LEARN_DROP] = REG_FIELD(ANA_ANEVENTS, 21, 21),
> > +	[ANA_ANEVENTS_AGED_ENTRY] = REG_FIELD(ANA_ANEVENTS, 20, 20),
> > +	[ANA_ANEVENTS_CPU_LEARN_FAILED] = REG_FIELD(ANA_ANEVENTS, 19, 19),
> > +	[ANA_ANEVENTS_AUTO_LEARN_FAILED] = REG_FIELD(ANA_ANEVENTS, 18, 18),
> > +	[ANA_ANEVENTS_LEARN_REMOVE] = REG_FIELD(ANA_ANEVENTS, 17, 17),
> > +	[ANA_ANEVENTS_AUTO_LEARNED] = REG_FIELD(ANA_ANEVENTS, 16, 16),
> > +	[ANA_ANEVENTS_AUTO_MOVED] = REG_FIELD(ANA_ANEVENTS, 15, 15),
> > +	[ANA_ANEVENTS_DROPPED] = REG_FIELD(ANA_ANEVENTS, 14, 14),
> > +	[ANA_ANEVENTS_CLASSIFIED_DROP] = REG_FIELD(ANA_ANEVENTS, 13, 13),
> > +	[ANA_ANEVENTS_CLASSIFIED_COPY] = REG_FIELD(ANA_ANEVENTS, 12, 12),
> > +	[ANA_ANEVENTS_VLAN_DISCARD] = REG_FIELD(ANA_ANEVENTS, 11, 11),
> > +	[ANA_ANEVENTS_FWD_DISCARD] = REG_FIELD(ANA_ANEVENTS, 10, 10),
> > +	[ANA_ANEVENTS_MULTICAST_FLOOD] = REG_FIELD(ANA_ANEVENTS, 9, 9),
> > +	[ANA_ANEVENTS_UNICAST_FLOOD] = REG_FIELD(ANA_ANEVENTS, 8, 8),
> > +	[ANA_ANEVENTS_DEST_KNOWN] = REG_FIELD(ANA_ANEVENTS, 7, 7),
> > +	[ANA_ANEVENTS_BUCKET3_MATCH] = REG_FIELD(ANA_ANEVENTS, 6, 6),
> > +	[ANA_ANEVENTS_BUCKET2_MATCH] = REG_FIELD(ANA_ANEVENTS, 5, 5),
> > +	[ANA_ANEVENTS_BUCKET1_MATCH] = REG_FIELD(ANA_ANEVENTS, 4, 4),
> > +	[ANA_ANEVENTS_BUCKET0_MATCH] = REG_FIELD(ANA_ANEVENTS, 3, 3),
> > +	[ANA_ANEVENTS_CPU_OPERATION] = REG_FIELD(ANA_ANEVENTS, 2, 2),
> > +	[ANA_ANEVENTS_DMAC_LOOKUP] = REG_FIELD(ANA_ANEVENTS, 1, 1),
> > +	[ANA_ANEVENTS_SMAC_LOOKUP] = REG_FIELD(ANA_ANEVENTS, 0, 0),
> > +	[ANA_TABLES_MACACCESS_B_DOM] = REG_FIELD(ANA_TABLES_MACACCESS, 18, 18),
> > +	[ANA_TABLES_MACTINDX_BUCKET] = REG_FIELD(ANA_TABLES_MACTINDX, 10, 11),
> > +	[ANA_TABLES_MACTINDX_M_INDEX] = REG_FIELD(ANA_TABLES_MACTINDX, 0, 9),
> > +	[GCB_SOFT_RST_SWC_RST] = REG_FIELD(GCB_SOFT_RST, 0, 0),
> > +	[QSYS_TIMED_FRAME_ENTRY_TFRM_VLD] = REG_FIELD(QSYS_TIMED_FRAME_ENTRY, 20, 20),
> > +	[QSYS_TIMED_FRAME_ENTRY_TFRM_FP] = REG_FIELD(QSYS_TIMED_FRAME_ENTRY, 8, 19),
> > +	[QSYS_TIMED_FRAME_ENTRY_TFRM_PORTNO] = REG_FIELD(QSYS_TIMED_FRAME_ENTRY, 4, 7),
> > +	[QSYS_TIMED_FRAME_ENTRY_TFRM_TM_SEL] = REG_FIELD(QSYS_TIMED_FRAME_ENTRY, 1, 3),
> > +	[QSYS_TIMED_FRAME_ENTRY_TFRM_TM_T] = REG_FIELD(QSYS_TIMED_FRAME_ENTRY, 0, 0),
> > +	[SYS_RESET_CFG_CORE_ENA] = REG_FIELD(SYS_RESET_CFG, 2, 2),
> > +	[SYS_RESET_CFG_MEM_ENA] = REG_FIELD(SYS_RESET_CFG, 1, 1),
> > +	[SYS_RESET_CFG_MEM_INIT] = REG_FIELD(SYS_RESET_CFG, 0, 0),
> > +	/* Replicated per number of ports (12), register size 4 per port */
> > +	[QSYS_SWITCH_PORT_MODE_PORT_ENA] = REG_FIELD_ID(QSYS_SWITCH_PORT_MODE, 14, 14, 12, 4),
> > +	[QSYS_SWITCH_PORT_MODE_SCH_NEXT_CFG] = REG_FIELD_ID(QSYS_SWITCH_PORT_MODE, 11, 13, 12, 4),
> > +	[QSYS_SWITCH_PORT_MODE_YEL_RSRVD] = REG_FIELD_ID(QSYS_SWITCH_PORT_MODE, 10, 10, 12, 4),
> > +	[QSYS_SWITCH_PORT_MODE_INGRESS_DROP_MODE] = REG_FIELD_ID(QSYS_SWITCH_PORT_MODE, 9, 9, 12, 4),
> > +	[QSYS_SWITCH_PORT_MODE_TX_PFC_ENA] = REG_FIELD_ID(QSYS_SWITCH_PORT_MODE, 1, 8, 12, 4),
> > +	[QSYS_SWITCH_PORT_MODE_TX_PFC_MODE] = REG_FIELD_ID(QSYS_SWITCH_PORT_MODE, 0, 0, 12, 4),
> > +	[SYS_PORT_MODE_DATA_WO_TS] = REG_FIELD_ID(SYS_PORT_MODE, 5, 6, 12, 4),
> > +	[SYS_PORT_MODE_INCL_INJ_HDR] = REG_FIELD_ID(SYS_PORT_MODE, 3, 4, 12, 4),
> > +	[SYS_PORT_MODE_INCL_XTR_HDR] = REG_FIELD_ID(SYS_PORT_MODE, 1, 2, 12, 4),
> > +	[SYS_PORT_MODE_INCL_HDR_ERR] = REG_FIELD_ID(SYS_PORT_MODE, 0, 0, 12, 4),
> > +	[SYS_PAUSE_CFG_PAUSE_START] = REG_FIELD_ID(SYS_PAUSE_CFG, 10, 18, 12, 4),
> > +	[SYS_PAUSE_CFG_PAUSE_STOP] = REG_FIELD_ID(SYS_PAUSE_CFG, 1, 9, 12, 4),
> > +	[SYS_PAUSE_CFG_PAUSE_ENA] = REG_FIELD_ID(SYS_PAUSE_CFG, 0, 1, 12, 4),
> > +};

Move this into the newly-created ocelot_regs.c file?

> > +
> > +static const struct ocelot_stat_layout vsc7512_stats_layout[] = {
> > +	{ .offset = 0x00,	.name = "rx_octets", },
> > +	{ .offset = 0x01,	.name = "rx_unicast", },
> > +	{ .offset = 0x02,	.name = "rx_multicast", },
> > +	{ .offset = 0x03,	.name = "rx_broadcast", },
> > +	{ .offset = 0x04,	.name = "rx_shorts", },
> > +	{ .offset = 0x05,	.name = "rx_fragments", },
> > +	{ .offset = 0x06,	.name = "rx_jabbers", },
> > +	{ .offset = 0x07,	.name = "rx_crc_align_errs", },
> > +	{ .offset = 0x08,	.name = "rx_sym_errs", },
> > +	{ .offset = 0x09,	.name = "rx_frames_below_65_octets", },
> > +	{ .offset = 0x0A,	.name = "rx_frames_65_to_127_octets", },
> > +	{ .offset = 0x0B,	.name = "rx_frames_128_to_255_octets", },
> > +	{ .offset = 0x0C,	.name = "rx_frames_256_to_511_octets", },
> > +	{ .offset = 0x0D,	.name = "rx_frames_512_to_1023_octets", },
> > +	{ .offset = 0x0E,	.name = "rx_frames_1024_to_1526_octets", },
> > +	{ .offset = 0x0F,	.name = "rx_frames_over_1526_octets", },
> > +	{ .offset = 0x10,	.name = "rx_pause", },
> > +	{ .offset = 0x11,	.name = "rx_control", },
> > +	{ .offset = 0x12,	.name = "rx_longs", },
> > +	{ .offset = 0x13,	.name = "rx_classified_drops", },
> > +	{ .offset = 0x14,	.name = "rx_red_prio_0", },
> > +	{ .offset = 0x15,	.name = "rx_red_prio_1", },
> > +	{ .offset = 0x16,	.name = "rx_red_prio_2", },
> > +	{ .offset = 0x17,	.name = "rx_red_prio_3", },
> > +	{ .offset = 0x18,	.name = "rx_red_prio_4", },
> > +	{ .offset = 0x19,	.name = "rx_red_prio_5", },
> > +	{ .offset = 0x1A,	.name = "rx_red_prio_6", },
> > +	{ .offset = 0x1B,	.name = "rx_red_prio_7", },
> > +	{ .offset = 0x1C,	.name = "rx_yellow_prio_0", },
> > +	{ .offset = 0x1D,	.name = "rx_yellow_prio_1", },
> > +	{ .offset = 0x1E,	.name = "rx_yellow_prio_2", },
> > +	{ .offset = 0x1F,	.name = "rx_yellow_prio_3", },
> > +	{ .offset = 0x20,	.name = "rx_yellow_prio_4", },
> > +	{ .offset = 0x21,	.name = "rx_yellow_prio_5", },
> > +	{ .offset = 0x22,	.name = "rx_yellow_prio_6", },
> > +	{ .offset = 0x23,	.name = "rx_yellow_prio_7", },
> > +	{ .offset = 0x24,	.name = "rx_green_prio_0", },
> > +	{ .offset = 0x25,	.name = "rx_green_prio_1", },
> > +	{ .offset = 0x26,	.name = "rx_green_prio_2", },
> > +	{ .offset = 0x27,	.name = "rx_green_prio_3", },
> > +	{ .offset = 0x28,	.name = "rx_green_prio_4", },
> > +	{ .offset = 0x29,	.name = "rx_green_prio_5", },
> > +	{ .offset = 0x2A,	.name = "rx_green_prio_6", },
> > +	{ .offset = 0x2B,	.name = "rx_green_prio_7", },
> > +	{ .offset = 0x40,	.name = "tx_octets", },
> > +	{ .offset = 0x41,	.name = "tx_unicast", },
> > +	{ .offset = 0x42,	.name = "tx_multicast", },
> > +	{ .offset = 0x43,	.name = "tx_broadcast", },
> > +	{ .offset = 0x44,	.name = "tx_collision", },
> > +	{ .offset = 0x45,	.name = "tx_drops", },
> > +	{ .offset = 0x46,	.name = "tx_pause", },
> > +	{ .offset = 0x47,	.name = "tx_frames_below_65_octets", },
> > +	{ .offset = 0x48,	.name = "tx_frames_65_to_127_octets", },
> > +	{ .offset = 0x49,	.name = "tx_frames_128_255_octets", },
> > +	{ .offset = 0x4A,	.name = "tx_frames_256_511_octets", },
> > +	{ .offset = 0x4B,	.name = "tx_frames_512_1023_octets", },
> > +	{ .offset = 0x4C,	.name = "tx_frames_1024_1526_octets", },
> > +	{ .offset = 0x4D,	.name = "tx_frames_over_1526_octets", },
> > +	{ .offset = 0x4E,	.name = "tx_yellow_prio_0", },
> > +	{ .offset = 0x4F,	.name = "tx_yellow_prio_1", },
> > +	{ .offset = 0x50,	.name = "tx_yellow_prio_2", },
> > +	{ .offset = 0x51,	.name = "tx_yellow_prio_3", },
> > +	{ .offset = 0x52,	.name = "tx_yellow_prio_4", },
> > +	{ .offset = 0x53,	.name = "tx_yellow_prio_5", },
> > +	{ .offset = 0x54,	.name = "tx_yellow_prio_6", },
> > +	{ .offset = 0x55,	.name = "tx_yellow_prio_7", },
> > +	{ .offset = 0x56,	.name = "tx_green_prio_0", },
> > +	{ .offset = 0x57,	.name = "tx_green_prio_1", },
> > +	{ .offset = 0x58,	.name = "tx_green_prio_2", },
> > +	{ .offset = 0x59,	.name = "tx_green_prio_3", },
> > +	{ .offset = 0x5A,	.name = "tx_green_prio_4", },
> > +	{ .offset = 0x5B,	.name = "tx_green_prio_5", },
> > +	{ .offset = 0x5C,	.name = "tx_green_prio_6", },
> > +	{ .offset = 0x5D,	.name = "tx_green_prio_7", },
> > +	{ .offset = 0x5E,	.name = "tx_aged", },
> > +	{ .offset = 0x80,	.name = "drop_local", },
> > +	{ .offset = 0x81,	.name = "drop_tail", },
> > +	{ .offset = 0x82,	.name = "drop_yellow_prio_0", },
> > +	{ .offset = 0x83,	.name = "drop_yellow_prio_1", },
> > +	{ .offset = 0x84,	.name = "drop_yellow_prio_2", },
> > +	{ .offset = 0x85,	.name = "drop_yellow_prio_3", },
> > +	{ .offset = 0x86,	.name = "drop_yellow_prio_4", },
> > +	{ .offset = 0x87,	.name = "drop_yellow_prio_5", },
> > +	{ .offset = 0x88,	.name = "drop_yellow_prio_6", },
> > +	{ .offset = 0x89,	.name = "drop_yellow_prio_7", },
> > +	{ .offset = 0x8A,	.name = "drop_green_prio_0", },
> > +	{ .offset = 0x8B,	.name = "drop_green_prio_1", },
> > +	{ .offset = 0x8C,	.name = "drop_green_prio_2", },
> > +	{ .offset = 0x8D,	.name = "drop_green_prio_3", },
> > +	{ .offset = 0x8E,	.name = "drop_green_prio_4", },
> > +	{ .offset = 0x8F,	.name = "drop_green_prio_5", },
> > +	{ .offset = 0x90,	.name = "drop_green_prio_6", },
> > +	{ .offset = 0x91,	.name = "drop_green_prio_7", },
> > +};

Share this in a new ocelot_stats.c file? Just want to check that it
makes sense to create all these smaller files that just contain tables
before going ahead with it.

> > +
> > +static const struct vcap_field vsc7512_vcap_es0_actions[]   = {
> > +	[VCAP_ES0_ACT_PUSH_OUTER_TAG]           = { 0,   2 },
> > +	[VCAP_ES0_ACT_PUSH_INNER_TAG]           = { 2,   1 },
> > +	[VCAP_ES0_ACT_TAG_A_TPID_SEL]           = { 3,   2 },
> > +	[VCAP_ES0_ACT_TAG_A_VID_SEL]            = { 5,   1 },
> > +	[VCAP_ES0_ACT_TAG_A_PCP_SEL]            = { 6,   2 },
> > +	[VCAP_ES0_ACT_TAG_A_DEI_SEL]            = { 8,   2 },
> > +	[VCAP_ES0_ACT_TAG_B_TPID_SEL]           = { 10,  2 },
> > +	[VCAP_ES0_ACT_TAG_B_VID_SEL]            = { 12,  1 },
> > +	[VCAP_ES0_ACT_TAG_B_PCP_SEL]            = { 13,  2 },
> > +	[VCAP_ES0_ACT_TAG_B_DEI_SEL]            = { 15,  2 },
> > +	[VCAP_ES0_ACT_VID_A_VAL]                = { 17, 12 },
> > +	[VCAP_ES0_ACT_PCP_A_VAL]                = { 29,  3 },
> > +	[VCAP_ES0_ACT_DEI_A_VAL]                = { 32,  1 },
> > +	[VCAP_ES0_ACT_VID_B_VAL]                = { 33, 12 },
> > +	[VCAP_ES0_ACT_PCP_B_VAL]                = { 45,  3 },
> > +	[VCAP_ES0_ACT_DEI_B_VAL]                = { 48,  1 },
> > +	[VCAP_ES0_ACT_RSV]                      = { 49, 24 },
> > +	[VCAP_ES0_ACT_HIT_STICKY]               = { 73,  1 },
> > +};
> > +
> > +static const struct vcap_field vsc7512_vcap_is1_keys[] = {
> > +	[VCAP_IS1_HK_TYPE]                      = { 0,    1 },
> > +	[VCAP_IS1_HK_LOOKUP]                    = { 1,    2 },
> > +	[VCAP_IS1_HK_IGR_PORT_MASK]             = { 3,   12 },
> > +	[VCAP_IS1_HK_RSV]                       = { 15,   9 },
> > +	[VCAP_IS1_HK_OAM_Y1731]                 = { 24,   1 },
> > +	[VCAP_IS1_HK_L2_MC]                     = { 25,   1 },
> > +	[VCAP_IS1_HK_L2_BC]                     = { 26,   1 },
> > +	[VCAP_IS1_HK_IP_MC]                     = { 27,   1 },
> > +	[VCAP_IS1_HK_VLAN_TAGGED]               = { 28,   1 },
> > +	[VCAP_IS1_HK_VLAN_DBL_TAGGED]           = { 29,   1 },
> > +	[VCAP_IS1_HK_TPID]                      = { 30,   1 },
> > +	[VCAP_IS1_HK_VID]                       = { 31,  12 },
> > +	[VCAP_IS1_HK_DEI]                       = { 43,   1 },
> > +	[VCAP_IS1_HK_PCP]                       = { 44,   3 },
> > +	/* Specific Fields for IS1 Half Key S1_NORMAL */
> > +	[VCAP_IS1_HK_L2_SMAC]                   = { 47,  48 },
> > +	[VCAP_IS1_HK_ETYPE_LEN]                 = { 95,   1 },
> > +	[VCAP_IS1_HK_ETYPE]                     = { 96,  16 },
> > +	[VCAP_IS1_HK_IP_SNAP]                   = { 112,  1 },
> > +	[VCAP_IS1_HK_IP4]                       = { 113,  1 },
> > +	/* Layer-3 Information */
> > +	[VCAP_IS1_HK_L3_FRAGMENT]               = { 114,  1 },
> > +	[VCAP_IS1_HK_L3_FRAG_OFS_GT0]           = { 115,  1 },
> > +	[VCAP_IS1_HK_L3_OPTIONS]                = { 116,  1 },
> > +	[VCAP_IS1_HK_L3_DSCP]                   = { 117,  6 },
> > +	[VCAP_IS1_HK_L3_IP4_SIP]                = { 123, 32 },
> > +	/* Layer-4 Information */
> > +	[VCAP_IS1_HK_TCP_UDP]                   = { 155,  1 },
> > +	[VCAP_IS1_HK_TCP]                       = { 156,  1 },
> > +	[VCAP_IS1_HK_L4_SPORT]                  = { 157, 16 },
> > +	[VCAP_IS1_HK_L4_RNG]                    = { 173,  8 },
> > +	/* Specific Fields for IS1 Half Key S1_5TUPLE_IP4 */
> > +	[VCAP_IS1_HK_IP4_INNER_TPID]            = { 47,   1 },
> > +	[VCAP_IS1_HK_IP4_INNER_VID]             = { 48,  12 },
> > +	[VCAP_IS1_HK_IP4_INNER_DEI]             = { 60,   1 },
> > +	[VCAP_IS1_HK_IP4_INNER_PCP]             = { 61,   3 },
> > +	[VCAP_IS1_HK_IP4_IP4]                   = { 64,   1 },
> > +	[VCAP_IS1_HK_IP4_L3_FRAGMENT]           = { 65,   1 },
> > +	[VCAP_IS1_HK_IP4_L3_FRAG_OFS_GT0]       = { 66,   1 },
> > +	[VCAP_IS1_HK_IP4_L3_OPTIONS]            = { 67,   1 },
> > +	[VCAP_IS1_HK_IP4_L3_DSCP]               = { 68,   6 },
> > +	[VCAP_IS1_HK_IP4_L3_IP4_DIP]            = { 74,  32 },
> > +	[VCAP_IS1_HK_IP4_L3_IP4_SIP]            = { 106, 32 },
> > +	[VCAP_IS1_HK_IP4_L3_PROTO]              = { 138,  8 },
> > +	[VCAP_IS1_HK_IP4_TCP_UDP]               = { 146,  1 },
> > +	[VCAP_IS1_HK_IP4_TCP]                   = { 147,  1 },
> > +	[VCAP_IS1_HK_IP4_L4_RNG]                = { 148,  8 },
> > +	[VCAP_IS1_HK_IP4_IP_PAYLOAD_S1_5TUPLE]  = { 156, 32 },
> > +};
> > +
> > +static const struct vcap_field vsc7512_vcap_is1_actions[] = {
> > +	[VCAP_IS1_ACT_DSCP_ENA]                 = { 0,   1 },
> > +	[VCAP_IS1_ACT_DSCP_VAL]                 = { 1,   6 },
> > +	[VCAP_IS1_ACT_QOS_ENA]                  = { 7,   1 },
> > +	[VCAP_IS1_ACT_QOS_VAL]                  = { 8,   3 },
> > +	[VCAP_IS1_ACT_DP_ENA]                   = { 11,  1 },
> > +	[VCAP_IS1_ACT_DP_VAL]                   = { 12,  1 },
> > +	[VCAP_IS1_ACT_PAG_OVERRIDE_MASK]        = { 13,  8 },
> > +	[VCAP_IS1_ACT_PAG_VAL]                  = { 21,  8 },
> > +	[VCAP_IS1_ACT_RSV]                      = { 29,  9 },
> > +	/* The fields below are incorrectly shifted by 2 in the manual */
> > +	[VCAP_IS1_ACT_VID_REPLACE_ENA]          = { 38,  1 },
> > +	[VCAP_IS1_ACT_VID_ADD_VAL]              = { 39, 12 },
> > +	[VCAP_IS1_ACT_FID_SEL]                  = { 51,  2 },
> > +	[VCAP_IS1_ACT_FID_VAL]                  = { 53, 13 },
> > +	[VCAP_IS1_ACT_PCP_DEI_ENA]              = { 66,  1 },
> > +	[VCAP_IS1_ACT_PCP_VAL]                  = { 67,  3 },
> > +	[VCAP_IS1_ACT_DEI_VAL]                  = { 70,  1 },
> > +	[VCAP_IS1_ACT_VLAN_POP_CNT_ENA]         = { 71,  1 },
> > +	[VCAP_IS1_ACT_VLAN_POP_CNT]             = { 72,  2 },
> > +	[VCAP_IS1_ACT_CUSTOM_ACE_TYPE_ENA]      = { 74,  4 },
> > +	[VCAP_IS1_ACT_HIT_STICKY]               = { 78,  1 },
> > +};
> > +
> > +static const struct vcap_field vsc7512_vcap_is2_keys[] = {
> > +	/* Common: 46 bits */
> > +	[VCAP_IS2_TYPE]                         = { 0,    4 },
> > +	[VCAP_IS2_HK_FIRST]                     = { 4,    1 },
> > +	[VCAP_IS2_HK_PAG]                       = { 5,    8 },
> > +	[VCAP_IS2_HK_IGR_PORT_MASK]             = { 13,  12 },
> > +	[VCAP_IS2_HK_RSV2]                      = { 25,   1 },
> > +	[VCAP_IS2_HK_HOST_MATCH]                = { 26,   1 },
> > +	[VCAP_IS2_HK_L2_MC]                     = { 27,   1 },
> > +	[VCAP_IS2_HK_L2_BC]                     = { 28,   1 },
> > +	[VCAP_IS2_HK_VLAN_TAGGED]               = { 29,   1 },
> > +	[VCAP_IS2_HK_VID]                       = { 30,  12 },
> > +	[VCAP_IS2_HK_DEI]                       = { 42,   1 },
> > +	[VCAP_IS2_HK_PCP]                       = { 43,   3 },
> > +	/* MAC_ETYPE / MAC_LLC / MAC_SNAP / OAM common */
> > +	[VCAP_IS2_HK_L2_DMAC]                   = { 46,  48 },
> > +	[VCAP_IS2_HK_L2_SMAC]                   = { 94,  48 },
> > +	/* MAC_ETYPE (TYPE=000) */
> > +	[VCAP_IS2_HK_MAC_ETYPE_ETYPE]           = { 142, 16 },
> > +	[VCAP_IS2_HK_MAC_ETYPE_L2_PAYLOAD0]     = { 158, 16 },
> > +	[VCAP_IS2_HK_MAC_ETYPE_L2_PAYLOAD1]     = { 174,  8 },
> > +	[VCAP_IS2_HK_MAC_ETYPE_L2_PAYLOAD2]     = { 182,  3 },
> > +	/* MAC_LLC (TYPE=001) */
> > +	[VCAP_IS2_HK_MAC_LLC_L2_LLC]            = { 142, 40 },
> > +	/* MAC_SNAP (TYPE=010) */
> > +	[VCAP_IS2_HK_MAC_SNAP_L2_SNAP]          = { 142, 40 },
> > +	/* MAC_ARP (TYPE=011) */
> > +	[VCAP_IS2_HK_MAC_ARP_SMAC]              = { 46,  48 },
> > +	[VCAP_IS2_HK_MAC_ARP_ADDR_SPACE_OK]     = { 94,   1 },
> > +	[VCAP_IS2_HK_MAC_ARP_PROTO_SPACE_OK]    = { 95,   1 },
> > +	[VCAP_IS2_HK_MAC_ARP_LEN_OK]            = { 96,   1 },
> > +	[VCAP_IS2_HK_MAC_ARP_TARGET_MATCH]      = { 97,   1 },
> > +	[VCAP_IS2_HK_MAC_ARP_SENDER_MATCH]      = { 98,   1 },
> > +	[VCAP_IS2_HK_MAC_ARP_OPCODE_UNKNOWN]    = { 99,   1 },
> > +	[VCAP_IS2_HK_MAC_ARP_OPCODE]            = { 100,  2 },
> > +	[VCAP_IS2_HK_MAC_ARP_L3_IP4_DIP]        = { 102, 32 },
> > +	[VCAP_IS2_HK_MAC_ARP_L3_IP4_SIP]        = { 134, 32 },
> > +	[VCAP_IS2_HK_MAC_ARP_DIP_EQ_SIP]        = { 166,  1 },
> > +	/* IP4_TCP_UDP / IP4_OTHER common */
> > +	[VCAP_IS2_HK_IP4]                       = { 46,   1 },
> > +	[VCAP_IS2_HK_L3_FRAGMENT]               = { 47,   1 },
> > +	[VCAP_IS2_HK_L3_FRAG_OFS_GT0]           = { 48,   1 },
> > +	[VCAP_IS2_HK_L3_OPTIONS]                = { 49,   1 },
> > +	[VCAP_IS2_HK_IP4_L3_TTL_GT0]            = { 50,   1 },
> > +	[VCAP_IS2_HK_L3_TOS]                    = { 51,   8 },
> > +	[VCAP_IS2_HK_L3_IP4_DIP]                = { 59,  32 },
> > +	[VCAP_IS2_HK_L3_IP4_SIP]                = { 91,  32 },
> > +	[VCAP_IS2_HK_DIP_EQ_SIP]                = { 123,  1 },
> > +	/* IP4_TCP_UDP (TYPE=100) */
> > +	[VCAP_IS2_HK_TCP]                       = { 124,  1 },
> > +	[VCAP_IS2_HK_L4_DPORT]                  = { 125, 16 },
> > +	[VCAP_IS2_HK_L4_SPORT]                  = { 141, 16 },
> > +	[VCAP_IS2_HK_L4_RNG]                    = { 157,  8 },
> > +	[VCAP_IS2_HK_L4_SPORT_EQ_DPORT]         = { 165,  1 },
> > +	[VCAP_IS2_HK_L4_SEQUENCE_EQ0]           = { 166,  1 },
> > +	[VCAP_IS2_HK_L4_FIN]                    = { 167,  1 },
> > +	[VCAP_IS2_HK_L4_SYN]                    = { 168,  1 },
> > +	[VCAP_IS2_HK_L4_RST]                    = { 169,  1 },
> > +	[VCAP_IS2_HK_L4_PSH]                    = { 170,  1 },
> > +	[VCAP_IS2_HK_L4_ACK]                    = { 171,  1 },
> > +	[VCAP_IS2_HK_L4_URG]                    = { 172,  1 },
> > +	[VCAP_IS2_HK_L4_1588_DOM]               = { 173,  8 },
> > +	[VCAP_IS2_HK_L4_1588_VER]               = { 181,  4 },
> > +	/* IP4_OTHER (TYPE=101) */
> > +	[VCAP_IS2_HK_IP4_L3_PROTO]              = { 124,  8 },
> > +	[VCAP_IS2_HK_L3_PAYLOAD]                = { 132, 56 },
> > +	/* IP6_STD (TYPE=110) */
> > +	[VCAP_IS2_HK_IP6_L3_TTL_GT0]            = { 46,   1 },
> > +	[VCAP_IS2_HK_L3_IP6_SIP]                = { 47, 128 },
> > +	[VCAP_IS2_HK_IP6_L3_PROTO]              = { 175,  8 },
> > +	/* OAM (TYPE=111) */
> > +	[VCAP_IS2_HK_OAM_MEL_FLAGS]             = { 142,  7 },
> > +	[VCAP_IS2_HK_OAM_VER]                   = { 149,  5 },
> > +	[VCAP_IS2_HK_OAM_OPCODE]                = { 154,  8 },
> > +	[VCAP_IS2_HK_OAM_FLAGS]                 = { 162,  8 },
> > +	[VCAP_IS2_HK_OAM_MEPID]                 = { 170, 16 },
> > +	[VCAP_IS2_HK_OAM_CCM_CNTS_EQ0]          = { 186,  1 },
> > +	[VCAP_IS2_HK_OAM_IS_Y1731]              = { 187,  1 },
> > +};
> > +
> > +static const struct vcap_field vsc7512_vcap_is2_actions[] = {
> > +	[VCAP_IS2_ACT_HIT_ME_ONCE]              = { 0,   1 },
> > +	[VCAP_IS2_ACT_CPU_COPY_ENA]             = { 1,   1 },
> > +	[VCAP_IS2_ACT_CPU_QU_NUM]               = { 2,   3 },
> > +	[VCAP_IS2_ACT_MASK_MODE]                = { 5,   2 },
> > +	[VCAP_IS2_ACT_MIRROR_ENA]               = { 7,   1 },
> > +	[VCAP_IS2_ACT_LRN_DIS]                  = { 8,   1 },
> > +	[VCAP_IS2_ACT_POLICE_ENA]               = { 9,   1 },
> > +	[VCAP_IS2_ACT_POLICE_IDX]               = { 10,  9 },
> > +	[VCAP_IS2_ACT_POLICE_VCAP_ONLY]         = { 19,  1 },
> > +	[VCAP_IS2_ACT_PORT_MASK]                = { 20, 11 },
> > +	[VCAP_IS2_ACT_REW_OP]                   = { 31,  9 },
> > +	[VCAP_IS2_ACT_SMAC_REPLACE_ENA]         = { 40,  1 },
> > +	[VCAP_IS2_ACT_RSV]                      = { 41,  2 },
> > +	[VCAP_IS2_ACT_ACL_ID]                   = { 43,  6 },
> > +	[VCAP_IS2_ACT_HIT_CNT]                  = { 49, 32 },
> > +};
> > +
> > +static struct vcap_props vsc7512_vcap_props[] = {
> > +	[VCAP_ES0] = {
> > +		.action_type_width = 0,
> > +		.action_table = {
> > +			[ES0_ACTION_TYPE_NORMAL] = {
> > +				.width = 73,
> > +				.count = 1,
> > +			},
> > +		},
> > +		.target = S0,
> > +		.keys = vsc7512_vcap_es0_keys,
> > +		.actions = vsc7512_vcap_es0_actions,
> > +	},
> > +	[VCAP_IS1] = {
> > +		.action_type_width = 0,
> > +		.action_table = {
> > +			[IS1_ACTION_TYPE_NORMAL] = {
> > +				.width = 78,
> > +				.count = 4,
> > +			},
> > +		},
> > +		.target = S1,
> > +		.keys = vsc7512_vcap_is1_keys,
> > +		.actions = vsc7512_vcap_is1_actions,
> > +	},
> > +	[VCAP_IS2] = {
> > +		.action_type_width = 1,
> > +		.action_table = {
> > +			[IS2_ACTION_TYPE_NORMAL] = {
> > +				.width = 49,
> > +				.count = 2,
> > +			},
> > +			[IS2_ACTION_TYPE_SMAC_SIP] = {
> > +				.width = 6,
> > +				.count = 4,
> > +			},
> > +		},
> > +		.target = S2,
> > +		.keys = vsc7512_vcap_is2_keys,
> > +		.actions = vsc7512_vcap_is2_actions,
> > +	},
> > +};

Again, more tables that could be shared with the library? Perhaps this
time in the existing ocelot_vcap.c file?

I'm wondering if a different structure for all these shared registers
should be considered, instead of just plopping them in the ocelot
library.

