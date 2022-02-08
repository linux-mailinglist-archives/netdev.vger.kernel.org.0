Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11D0B4AD066
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 05:35:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346225AbiBHEfT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 23:35:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238046AbiBHEfR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 23:35:17 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2106.outbound.protection.outlook.com [40.107.243.106])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 563E0C0401DC;
        Mon,  7 Feb 2022 20:35:16 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gJlY2IfQgxidksvFwPFvwgXYuaEnaIv+OIFSyknCheg8fuTCbhio/cC6u0XYBUGH4LwlOrAAB/eUNEu/iWclmjegW+we+47rSa2mSm8nWMlA2ifMOAmFEFviYpvNvVVmFRbqQwl6j/+nAj45vfiEKca7n9G0tYJzgIW22pPS+sCCBP9Lc8cfV5uVlHFSJVM4qK4tF7rFz7I0rS2L1ZdVIY+VQye4zuY3yiR1uLyf2kgwVwjgCSDsWdGXiGapecMUv/KAbPh4RTXPjC5gIWGHgPHT2OEKyEfhfxunFjNZuXiRWk87jmljFLSi7w83ABwVdut1y1VkANvwOW69jGB5fg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IF9kwQdD6j4REMOJI9tanY0TsHv4ChvNxqT78EOb6zI=;
 b=AnR6z6U8H4JW2VZRvXfFI5iphbbVJTnSj9jG9yZaD2E98vmyiLMso9cgvW7IwSQrwPQy882YYe/fVu4oSe3gCx09Qczd6dEHNbjqH9Frnnu8MIdHM7pNSc/vqiWYtCnugQhZHkc0xQ/4RgIfFdvdgirFN67SuIyTKdMc9S7S7HYqO904iJU8CiZnhGQWpNiAQ6XeslalG0Y9mWksHZwaXlQyalHMp1hv4X6qGzRnjCkGQMw/fkY+Mo5DDcrnFn2UP/gbhZhqV5Hpp2xFRWPtFHjr5jAWlzZkIXn1tFsHKyHT/fMUajF8TLL9m4JNaFjjoPO0Zwlhu/HYwlV59Osxlw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IF9kwQdD6j4REMOJI9tanY0TsHv4ChvNxqT78EOb6zI=;
 b=HL7B1sxFqVdOrIvBnTKH5abEnPBF8usk41VFthIsuG6dXcdRCCNGWJe2C/lorg1/nM9d5FT3yiSOLO14J3JHDlW5aS5IrM2mBKzqjbixTEOEcgX4fd/icbh63hCCnjAUKK4J6SMN2r28kmANyEkVmuoTnuL0K6kdCqa+w3SCISc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by BLAPR10MB4852.namprd10.prod.outlook.com
 (2603:10b6:208:30f::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.12; Tue, 8 Feb
 2022 04:35:14 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2d52:2a96:7e6c:460f]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2d52:2a96:7e6c:460f%4]) with mapi id 15.20.4951.018; Tue, 8 Feb 2022
 04:35:13 +0000
Date:   Mon, 7 Feb 2022 20:35:07 -0800
From:   Colin Foster <colin.foster@in-advantage.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
Subject: Re: [PATCH v3 net-next 2/2] net: mscc: ocelot: use bulk reads for
 stats
Message-ID: <20220208043507.GA246307@euler>
References: <20220125071531.1181948-1-colin.foster@in-advantage.com>
 <20220125071531.1181948-3-colin.foster@in-advantage.com>
 <20220131102255.zgfmbzmffup6rste@skbuf>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220131102255.zgfmbzmffup6rste@skbuf>
X-ClientProxiedBy: MWHPR1701CA0003.namprd17.prod.outlook.com
 (2603:10b6:301:14::13) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c0e4a057-af40-43cd-3503-08d9eabc65bd
X-MS-TrafficTypeDiagnostic: BLAPR10MB4852:EE_
X-Microsoft-Antispam-PRVS: <BLAPR10MB4852B8CAEB9B1B5BAE26247CA42D9@BLAPR10MB4852.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2512;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4+efP3LFNUDKutAJ/6/8GH0VCOl1X3sHgj4bwcZb4gyobCbAxGEzkvGHahrBXRE9nz1w6npe3n2yVU0hu/T0yJK3ewIFOM90jS1S8xrGTzzEunQaiDOFEgZITD68pqAVzg2SvAVsHwa2wnNfTsUS2iuaDvlgiVrjNjxvPdauj7ZQlwXCpxuDwbsqc28bxPqk2amCY3j8GC+X/7CryUxlVBA1hL9QG7dWZUF9l/Vp4xDsOgyoufjopx1PFi16mNJUn8heSiw4LCrS+UoIqi9Tq19FyqmuSCUCHH30owf/hpByXb7SCJ5aOjVkRGVE7NsDJr4maJJkqF43rixcfhKXAEcVadqW8j0Xxid7XTvVF+rwGd7tD5srGAaqY+KzHQTMOf3HrxDCWzrI3Bb25cJPzzKJWXHlw0Uhor6+3KikfqfNwv6MFK+oJO85b8c4AXqL6VQdxXhEAlORlXlsk8u2kSOTW2PgpthTzooZQbQm08U9tGBcw1eNcwFb6LXAsZw6OFdSaC2k5+PkutUz8Tc3V/38cmoh7CWSEtRzr1ZX1HYnVM+uC7HpjYCRV9XvgeQ4alTK7D9mjxzKXu8R/bAk9b51TQDW7mBfQ1zHyKvcPwqKT7HW5POCOmnM8/L9NpJYV10APP6d/8wuy0HGnJ4vUknCop+GMl0U0qZLNB7GplHfh7dn+uSDojRgNBa1/mwjdB8/0PEY06gjScTJCdiSbQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(396003)(366004)(136003)(376002)(346002)(39830400003)(42606007)(6916009)(33716001)(38350700002)(6512007)(5660300002)(44832011)(9686003)(54906003)(26005)(1076003)(316002)(83380400001)(186003)(66476007)(66556008)(66946007)(8676002)(8936002)(6486002)(52116002)(2906002)(508600001)(6506007)(86362001)(6666004)(4326008)(33656002)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?njmxvCg/0ochMd8Fe+qZ598MOK4yDqovjBmO1Y52is5Fkoe8PyhV4XzalIHY?=
 =?us-ascii?Q?7RhP2fVPsCBXWKRhk+ks00NULkheqDELByw/9lxHCmCt/ReQs8rV2DH3rhvy?=
 =?us-ascii?Q?USJP8p0P5YeXt6sELLkJP36L5IeZKdwWXDEit2Nlu9QNWZ/oZrGtbv773BMi?=
 =?us-ascii?Q?j6PQabMLzrCuy7tZV3oJ+rskQidEN/Eg6fFOSud79FMkkEPwLB+d3TVDK1TX?=
 =?us-ascii?Q?eKA8a0j8TPQqUN+RxkJ75m5oW/07KJvObHs7AnqIXiZBWdglyuWcjBPdnQIY?=
 =?us-ascii?Q?4dCT1MRBzj2v1SdlFw5FZlVf1fjyeUCSsu38pDXdGfRHg7dcv3CjdOKTBQvI?=
 =?us-ascii?Q?Cl5x4+yhkoswv1k2pMCKsH1lR7oY6OyylVeXOUnK8S7VW6or2lIT6ngsTJfE?=
 =?us-ascii?Q?56+u53gAZotQbBabLF3nO0YVSk3IiusGvqwQTDOugl7sn6LH3S/xZt5lcufu?=
 =?us-ascii?Q?eV36xpwyRdbzUqsIXM8ZO0EJ+CRUjFb0KSyCfhN75DQQnopeYf2vv+kmCKt4?=
 =?us-ascii?Q?B00KfkFXvc1Nycqq1FwyRolwrk7wDLhA3s5okcgMMHtZ8/NH3mY9Jovawai+?=
 =?us-ascii?Q?qPQ3sYARYnCyaesNUbQWwx2CYLgMKSPXKUp8ljxOp8N5I+uxXvDEjgSoiwNK?=
 =?us-ascii?Q?N9hkK5uebTSmZDGF4mXd5PMXsUqADDOsJLZm6h1q4xvj55sjtbMz+jF4V+NU?=
 =?us-ascii?Q?s9ujQsLVvERDmj2MXVVep0CCc5CI8lXWb/f2K8AsfvWZN6s6nc80Uo84qpkS?=
 =?us-ascii?Q?2SC0umznmyepc7R9KjrZj4ogsz4+L04jzRaToscoihaucgSl4+JD6ya34hoa?=
 =?us-ascii?Q?iEGJygKjzzc58AlXL2cDlERMuFyDifk4rauGJ+gmixticXiLnZBKGRsbwfTW?=
 =?us-ascii?Q?xpvRkNEqOJL9BWctl/RVJY+Fny9KqEO68ZskfSXXTziZnlXWd5z72ilwwPjV?=
 =?us-ascii?Q?G47V6b9l7ILmfeU8cVi4avotxMwHZq2h6LdIqYRgpkRjUFvFZ1au33+dcfQc?=
 =?us-ascii?Q?c5lWsABv8Ohn6O6hbWs4WYuRA+SrgdnoQgNIr7RasdA3ZU4zvcU2lFTp0FvB?=
 =?us-ascii?Q?ohzz9j9mUBStWDITyCMRQUN6QXR9d8hr+cCgy8XFMP9qa6zlrjy145AfuhVe?=
 =?us-ascii?Q?XhFw4i7KDdv2+RqesAb+n3JuPA2FcME35/NVyLcyaEvc7bJOWcXsUeIfRtp1?=
 =?us-ascii?Q?OTjg9yAYYJEAXG1PB7OVfh6/Q+c17XyKvyALzEv8nhAc3TFWD74EE4VHTpeM?=
 =?us-ascii?Q?CCI2dwWxiMhOqHLdTgBBFYkLQPA6SEmfaXfNCwLJCu6tQ3+nxeRYeuSMmWNP?=
 =?us-ascii?Q?cpEiVWZLoaxWANRKaz9B57nSC142DU70cbhRujFz4Lh4o1zNQu44YAYntUFp?=
 =?us-ascii?Q?6mfUHoIeIxQH8hvSImTkEilsv0r2aSWfPcdhSqwg2swV6XACeDjazZNDxQq7?=
 =?us-ascii?Q?sgkjYrgmd3V6MU974HTzbhwO9C2h72u2ghXKW5LT6DZFO7Dzm6w9WwKTAcmV?=
 =?us-ascii?Q?cHCEWa5lSfKif89+4woVh3vyIp9DDLizxpIBc3Ik2heYT9KaF8gFNBvliJFg?=
 =?us-ascii?Q?cgUWBDOs+5Ql83IzfQL6nZ0dOeuCse2KbmbLfXop89scRR870sVI6v8Xw3yt?=
 =?us-ascii?Q?8JmP16kLe4AF2RPvPE/O2B7BigQchFXyvwFFLLs5uzPX2u8z6UyTJ8c6BzXp?=
 =?us-ascii?Q?WiJwzg=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c0e4a057-af40-43cd-3503-08d9eabc65bd
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Feb 2022 04:35:13.4879
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vl8ZM7cvfnwpSBcnkNzrQhE+QVZXhZOMNtNoCzeggCIT18lOjkHHUB6Dxo+LhK0l7cvPuEKdNT2B6eYA15WPqdtRe5TICXSXPSS4g5R1CzU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4852
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vladimir,

I'm sending out v5 shortly. Sorry I seem to have forgotten to respond.
All changes made, except the SYS << TARGET_OFFSET. The macros for *_rix
use reg##_RSZ for expansion.

On Mon, Jan 31, 2022 at 10:22:55AM +0000, Vladimir Oltean wrote:
> On Mon, Jan 24, 2022 at 11:15:31PM -0800, Colin Foster wrote:
[ ... ]
> >  	mutex_lock(&ocelot->stats_lock);
> >  
> >  	for (i = 0; i < ocelot->num_phys_ports; i++) {
> > +		unsigned int idx = 0;
> 
> It is usual to leave a blank line between variable declarations and code.
> 
> >  		/* Configure the port to read the stats from */
> >  		ocelot_write(ocelot, SYS_STAT_CFG_STAT_VIEW(i), SYS_STAT_CFG);
> >  
> > -		for (j = 0; j < ocelot->num_stats; j++) {
> > -			u32 val;
> > -			unsigned int idx = i * ocelot->num_stats + j;
> > +		list_for_each_entry(region, &ocelot->stats_regions, node) {
> > +			err = ocelot_bulk_read_rix(ocelot, SYS_COUNT_RX_OCTETS,
> 
> I'd be tempted to pass SYS << TARGET_OFFSET here.

Expands to SYS_COUNT_RX_OCTETS_RSZ, defined in
include/soc/mscc/ocelot_sys.h.

> 
> > +						   region->offset, region->buf,
> > +						   region->count);
[ ... ]
> > +@ -2799,6 +2845,10 @@ int ocelot_init(struct ocelot *ocelot)
> >  				 ANA_CPUQ_8021_CFG_CPUQ_BPDU_VAL(6),
> >  				 ANA_CPUQ_8021_CFG, i);
> >  
> > +	ret = ocelot_prepare_stats_regions(ocelot);
> > +	if (ret)
> > +		return ret;
> > +
> 
> Destroy ocelot->stats_queue and ocelot->owq.
> 
> >  	INIT_DELAYED_WORK(&ocelot->stats_work, ocelot_check_stats_work);
> >  	queue_delayed_work(ocelot->stats_queue, &ocelot->stats_work,
> >  			   OCELOT_STATS_CHECK_DELAY);
> > diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
> > index b66e5abe04a7..837450fdea57 100644
> > --- a/include/soc/mscc/ocelot.h
> > +++ b/include/soc/mscc/ocelot.h
> > @@ -542,6 +542,13 @@ struct ocelot_stat_layout {
> >  	char name[ETH_GSTRING_LEN];
> >  };
> >  
> > +struct ocelot_stats_region {
> > +	struct list_head node;
> > +	u32 offset;
> > +	int count;
> > +	u32 *buf;
> > +};
> > +
> >  enum ocelot_tag_prefix {
> >  	OCELOT_TAG_PREFIX_DISABLED	= 0,
> >  	OCELOT_TAG_PREFIX_NONE,
> > @@ -673,6 +680,7 @@ struct ocelot {
> >  	struct regmap_field		*regfields[REGFIELD_MAX];
> >  	const u32 *const		*map;
> >  	const struct ocelot_stat_layout	*stats_layout;
> > +	struct list_head		stats_regions;
> >  	unsigned int			num_stats;
> >  
> >  	u32				pool_size[OCELOT_SB_NUM][OCELOT_SB_POOL_NUM];
> > -- 
> > 2.25.1
> >
