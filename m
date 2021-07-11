Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87DE43C3E2E
	for <lists+netdev@lfdr.de>; Sun, 11 Jul 2021 19:09:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232756AbhGKRMV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Jul 2021 13:12:21 -0400
Received: from mail-mw2nam12on2119.outbound.protection.outlook.com ([40.107.244.119]:46176
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229801AbhGKRMS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 11 Jul 2021 13:12:18 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=avBEn/wLdl6o/9XFJJFnQB8GGcTsFnRyzGy15MFo8hmuNlJDYM5gFB+srwW11B1PAMze2hnPQcqpMZSjPFcnqHutNtVsn4OUAAcT4Vi2tWMfhyxLx8lvkg9/WAnDDDJP9AUHjx2TrqwmCM7hith6LqcRuQVfM5gTMV8aCso1T2tx7cxgY8xyWM6fXUoJQJ/GwtHmouYefbN18yqe4XMVxsik2RE1rg1cUbYni300DsTcv3cFsV+Q5ILeU6AQiDtBWROUx/rm/h7WqyYVzfkDmchRkNzb5Pk9oGftqULe/czHxGdGARk2+/tymvjj3G8GdlmMqeDFXwId7sxekWiUPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ll8rolpSxFM/SgComeoW1Co3BcFE/QMgkv8RTYwR7ls=;
 b=Wuq6HtqscYjQDsILhTE9Pqm5Y1T8np07YIguhRevOpbmVivHqBS0JcnSZruYD87XJA1Ps1KaX4dfpKw7LO9jxC9Jc7vcogJjW52BCAFKeNA2QQAKj4oqjUlG+jkcSggO2bZ2J/HrKBe3ASM4PT6V3l2c8j1IcQ7VZgkGT7/dZQ57yfrCE1+eq+PXVQVaRsoB90dEmJYeVhJLCHs/Sc2DPe8gYmFIqXCmWKOHpX0K0TQnKKchJLWNESDiqMOhJh3OZnyk5j1jhqownW0t5v7OJ+j0Hf4MZ2uP+Up3h4RSAEOHVxibF9mhsFOl/FNDY42NmNVIXaviAeenfyAX+2expg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ll8rolpSxFM/SgComeoW1Co3BcFE/QMgkv8RTYwR7ls=;
 b=wiq/L34dnO5stlewbCSe/k/8y8GOaFcROAvfvvTpFt41K547S/RXHNvl9O0KFEibIcB3QK7uqy0lyw4xvOANQJnDNrqDQajMueZxiZTHMs4Ucw6K+/z9AP4QacSkOHIoE2RxXA+TgUSmHoMbeLI2Z4lvQIqHcyL35FSwM8WyD54=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by CO1PR10MB4420.namprd10.prod.outlook.com
 (2603:10b6:303:97::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.23; Sun, 11 Jul
 2021 17:09:30 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::e81f:cf8e:6ad6:d24d]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::e81f:cf8e:6ad6:d24d%3]) with mapi id 15.20.4308.026; Sun, 11 Jul 2021
 17:09:30 +0000
Date:   Sun, 11 Jul 2021 10:09:27 -0700
From:   Colin Foster <colin.foster@in-advantage.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        claudiu.manoil@nxp.com, alexandre.belloni@bootlin.com,
        UNGLinuxDriver@microchip.com, linux@armlinux.org.uk,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 net-next 7/8] net: dsa: ocelot: felix: add support
 for VSC75XX control over SPI
Message-ID: <20210711170927.GG2219684@euler>
References: <20210710192602.2186370-1-colin.foster@in-advantage.com>
 <20210710192602.2186370-8-colin.foster@in-advantage.com>
 <20210710205205.blitrpvdwmf4au7z@skbuf>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210710205205.blitrpvdwmf4au7z@skbuf>
X-ClientProxiedBy: MW3PR05CA0029.namprd05.prod.outlook.com
 (2603:10b6:303:2b::34) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from euler (67.185.175.147) by MW3PR05CA0029.namprd05.prod.outlook.com (2603:10b6:303:2b::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.10 via Frontend Transport; Sun, 11 Jul 2021 17:09:29 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 14ed7193-55d5-4938-9f8d-08d9448ea539
X-MS-TrafficTypeDiagnostic: CO1PR10MB4420:
X-Microsoft-Antispam-PRVS: <CO1PR10MB44201A55045DF977F480E5F7A4169@CO1PR10MB4420.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VRauUL1ZZY53KCfUm3uc1ECyz+jo70an43gC+sUv5zfzxvDltzLSVStT9TGGzAXobOoMCvHfM7fA2gZoElU4aide3qmhmzmyJOHCPpwt1maHnWyTNKTHnlE6ijcvi78gCvH9v4Xm/AxRQv8TYEGVJn3c9+rSyjc0HKO0iBFyFknJRi05pHjt0py3UsrJqnpP3v2pxNK9sxK4GjjwVvY96wC9qy2Mx8AFlCIYXkWyYhPYDWV7LLn17ALrh24+zrSXluXzSPylEjgCKGKUMZkmqrbTAE5xmySbh/liKyLUPrl6pdE6oPYtXI9Fmw7d0FqIeOQ/2kLQi9oCkAU+EHKxvN2DZSVtMs3QLGNRVVBgDpIRh7K/HS+nF7oCBTE/OkWUeXpzsuwbQIcLUPy58XWZRTJdgesEAX6D2G+oKgUeTLipQgjgYIwAFGD2hJRH+xqGHgyzgv5+GCrCBpKtLV/49pDFsneJAU9kZ/MGK672TZvJUQok8xByBGrUlqy4P5YKp7/YCaKZk0C3R1TN9ms4B/HnBn8AqvHfSxIhdqXWPCSfrZViNZKURbbnYx+eK1/Ke33lPBiJRba8DvmUXmXqw494SZ5iBXgaFWgP3HHSzXU6QcGYdgeuTGYqohXvjmT3QfsVGeOymstTq2rSvDT7q51hjBU7PjloHyFKVAFDAgXTq8+vBoVRahcnd09V+taqusD/3OVSDPhoENvl8jn5zw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(346002)(39830400003)(366004)(396003)(376002)(26005)(956004)(66476007)(55016002)(66556008)(33656002)(316002)(478600001)(186003)(38100700002)(66946007)(6916009)(5660300002)(38350700002)(8676002)(8936002)(86362001)(9576002)(83380400001)(6496006)(52116002)(9686003)(33716001)(4326008)(7416002)(2906002)(1076003)(44832011);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?QYG4IoNiZXCjU0C63S39uJPgfRYi7QBAe0M0ataCJl6Ov32auen97A+iB3Fh?=
 =?us-ascii?Q?IVYW6KlKghntxVTK+f5xBMphiYPQPSz/G4iAz76NZJvhx3UBzSCGoz+tzxAl?=
 =?us-ascii?Q?QVRq5I9QJOmez73vGwk9YrHztMF+0/LqCpfO225sy0W67KLFyGAffwMHQ7m+?=
 =?us-ascii?Q?SBXC2YTOJ1D6cKGSqHC2TjSupWytxYiRHWYO9Mi+7X46NauI0CvsC10RM+sg?=
 =?us-ascii?Q?HZRIu5FuMqfc0wCgj6W+FbqOdhIUXeJIpOQyCHO+XqXejy6kSONRxr2wd33m?=
 =?us-ascii?Q?vOiveeZZ7toVTNP30hVAzHSGzgD0c1Jq1svKfLnGbKF3IxWzkMKdk5sqXBHx?=
 =?us-ascii?Q?3OiozCdO8kWkI44vCjpfVPxaJq7Fmt3bBi4D8MhffQt9hV4I8yUhmTinlHpS?=
 =?us-ascii?Q?qMXzj67qsdsU/uodIIFAFZpVXzcguSE6YXWXatb0Sw9S7GxEGuxqVZ9GNnoN?=
 =?us-ascii?Q?kRH5gin+Z28pGFfyhL14vneEAh7wXdWnAy9O+ruEnJr67CYuvt1UicrX+cwL?=
 =?us-ascii?Q?QPsaFf3KSsV5TI/jOoMSHCwOG5RCkg2grWGTJJJjOUiz+bY9afGCE/mXI2g2?=
 =?us-ascii?Q?sl89b+Uhq6ic0FsjHK3Q/1/6LscQzqgNKd5x3sbi55s4xfC0xG7OIxudCy1j?=
 =?us-ascii?Q?rD3RVpkB2ZSWZYZUknXM9DmdtyP5r1S/e+lAxu69SDGqqwgb6Qh2AKVLsblY?=
 =?us-ascii?Q?f7YI6bhYZjSDjttwLGkNQNBcLQvacgaxxT08X7FRNQjqiak+ahwJIHAupq1v?=
 =?us-ascii?Q?eKGuBwIMHydh7stJWhyH5zuN67SUzNzCHBv4RDL2UKjzqy1jxkQQ2v9u/3UC?=
 =?us-ascii?Q?QkWjTTTmPucGkIMgbDlZxh3ViQ6Q06QTWhHAUKGOKN765cU84GbPZrctyoqN?=
 =?us-ascii?Q?uQFWTD4UJle7UlEsfcCFkMoQ8w9F8LIQOiBLfuRlF0VNQFUl1yRwWlsIfNz2?=
 =?us-ascii?Q?ZYIghmKJRVieogcTCJ7pvpevBvaaH7chaWuOg7BZgJfKS8FtgecN7/Lkpict?=
 =?us-ascii?Q?TkAUsSqtWZ+XwM3DgMrQC41K4l1RWYTZUljTIpmoFfeq/4xDHeWLq96r7iIU?=
 =?us-ascii?Q?Aqc2EIPL6ttvEPi0DZbB4Tjmid8BTinfVDjJkWjJ5VzfkM8kmSmeWXM4c7i3?=
 =?us-ascii?Q?dGXS+Hn8mdqZMAF5AZ0y4PIvzGKZ7IL2XHbYvh97nZrOLlP4TkFthbXzCY82?=
 =?us-ascii?Q?u+XyGr7oM9Gd6o0lwbzLck2t9vT29o7IQ/rBmnlzuVxEzkcs6Lb1ze8bsiuc?=
 =?us-ascii?Q?CjFOoaLkyS8F90vBPlSQEfM83s+ut7fBjMaxH0nOz9hqEEQUUbpwNScjCPYR?=
 =?us-ascii?Q?mY+ZwPDmzjDXk9Gf1Ds+WSFu?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 14ed7193-55d5-4938-9f8d-08d9448ea539
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jul 2021 17:09:30.0386
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qAgn73AoR4w9PB5wl0dp176G1U1hnmDO9AK34jSSsp9qssi95TJkqETin2I3HV5Ebu9ZORWeuJ/bPGhDfpxhZBJck6fnSYGToFvJKXtT00I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4420
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 10, 2021 at 11:52:05PM +0300, Vladimir Oltean wrote:
> On Sat, Jul 10, 2021 at 12:26:01PM -0700, Colin Foster wrote:
> > +static const struct felix_info ocelot_spi_info = {
> > +	.target_io_res			= vsc7512_target_io_res,
> > +	.port_io_res			= vsc7512_port_io_res,
> > +	.regfields			= vsc7512_regfields,
> > +	.map				= vsc7512_regmap,
> > +	.ops				= &vsc7512_ops,
> > +	.stats_layout			= vsc7512_stats_layout,
> > +	.num_stats			= ARRAY_SIZE(vsc7512_stats_layout),
> > +	.vcap				= vsc7512_vcap_props,
> > +	.num_mact_rows			= 1024,
> > +
> > +	/* The 7512 and 7514 both have support for up to 10 ports. The 7511 and
> > +	 * 7513 have support for 4. Due to lack of hardware to test and
> > +	 * validate external phys, this is currently limited to 4 ports.
> > +	 * Expanding this to 10 for the 7512 and 7514 and defining the
> > +	 * appropriate phy-handle values in the device tree should be possible.
> > +	 */
> > +	.num_ports			= 4,
> 
> Ouch, this was probably not a good move.
> felix_setup() -> felix_init_structs sets ocelot->num_phys_ports based on
> this value.
> If you search for ocelot->num_phys_ports in ocelot and in felix, it is
> widely used to denote "the index of the CPU port module within the
> analyzer block", since the CPU port module's number is equal to the
> number of the last physical port + 1. If VSC7512 has 10 ports, then the
> CPU port module is port 10, and if you set num_ports to 4 you will cause
> the driver to misbehave.

Yes, this is part of my concern with the CPU / NPI module mentioned
before. In my hardware, I'd have port 0 plugged to the external CPU. In
Ocelot it is the internal bus, and in Felix it is the NPI. In this SPI
design, does the driver lose significant functionality by not having
access to those ports?

In my test setup (and our expected production) we'd have port 0
connected to the external chip, and ports 1-3 exposed. Does Ocelot need
to be modified to allow a parameter for the CPU port?

And obviously I'd imagine this would want to be done in such a way that
it doesn't break existing device trees...

> 
> > +	.num_tx_queues			= OCELOT_NUM_TC,
> > +	.mdio_bus_alloc			= felix_mdio_bus_alloc,
> > +	.mdio_bus_free			= felix_mdio_bus_free,
> > +	.phylink_validate		= vsc7512_phylink_validate,
> > +	.prevalidate_phy_mode		= vsc7512_prevalidate_phy_mode,
> > +	.port_setup_tc			= vsc7512_port_setup_tc,
> > +	.init_regmap			= vsc7512_regmap_init,
> > +};
> 
> > +	/* Not sure about this */
> > +	ocelot->num_flooding_pgids = 1;
> 
> Why are you not sure? It's the same as ocelot.

Sorry - missed removing that comment... Removed.
