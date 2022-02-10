Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E13A4B118B
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 16:21:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243539AbiBJPVM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 10:21:12 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:55360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239853AbiBJPVL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 10:21:11 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2131.outbound.protection.outlook.com [40.107.244.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41C701B3;
        Thu, 10 Feb 2022 07:21:09 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JwNqWn3ghDymSIcIwBZ+otG9JN3KKTUAov5kOHqLWFbL561Tg8JYMlA+h3AAJ2VRSAP1MITBTji+lI/z/WlNKsC2FsHj8GmXjZ+0x0GIc648x7zI42dNJwDeuu+DcD0Cw9x2r30hWDjHOW5hCsOAHhQTbL9fSbne0Yi1PXjSEWqHoZc+tRIjO/4eYpK3exZR7vVGvh1FoCqZY2X8b5C5hN/dq8PGogk+xLG7kHmQMCzlIyKyWLAjEFJ+Inj4EhnqiI7yY9C8DN29vTycPN3xbV1rDNVr2ZzzdpROt+Tr2I7g0FuUEh/GzVdUbV4djwaNJ8I0QXy8FeRUem6dzI02iw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mlkUZqjvYrQRpAJVQ3r+I7VBSVyWP/0mue1gbmZtjq0=;
 b=mI5D5G/rmi0Crt/KnNT5EFWKpwm3LoGyW0UlQm1tgggKVfqWZ4dlDj3rOkLDaGQjMg69jSgAUImU97u5WraeV1i+Fs1nfrEHH+kSJqfVCl5pOUCuqJESYzQDXUXS9MmjDPb84F14vaqdVnA0yG3qrXHV2J7vgHmnU8jPdKYL0MeLxE/twxkxaoH+QcbfSzi4mdG8KYcierZ8xYOh8XbA/zPVvoc9BuxYZ8POxUQrj6KymE/ysq3ZKCEPJQzxyDKjkbNXJJ5ZWBlmFSpCIz05GjG5qA7S+hOlT6roFzeNEanY6TFAIPuVulSWVcFSjn/YOsSqkL58ehd7g26wUJaP8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mlkUZqjvYrQRpAJVQ3r+I7VBSVyWP/0mue1gbmZtjq0=;
 b=HEAbYAKKKlf1OziLncPHhoqVn8RF3m+nO6Gm4A6152p/R8nrw6BVjyQpS7E8n4E6b/tKQhOGSDFwsHOG0KmpuHHJUTmauamgglXUGdrc/sWrJgZoGI8Q3KshscHoBYZrejyvCy7bofWubV9RkHZuTaRFASwrAfGJRfiVx/Rcm/Y=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by DM5PR1001MB2121.namprd10.prod.outlook.com
 (2603:10b6:4:32::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.12; Thu, 10 Feb
 2022 15:21:06 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::7c:dc80:7f24:67c5]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::7c:dc80:7f24:67c5%6]) with mapi id 15.20.4975.012; Thu, 10 Feb 2022
 15:21:06 +0000
Date:   Thu, 10 Feb 2022 07:21:03 -0800
From:   Colin Foster <colin.foster@in-advantage.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
Subject: Re: [PATCH v6 net-next 5/5] net: mscc: ocelot: use bulk reads for
 stats
Message-ID: <20220210152103.GB354478@euler>
References: <20220210041345.321216-1-colin.foster@in-advantage.com>
 <20220210041345.321216-6-colin.foster@in-advantage.com>
 <20220210103636.gtkky2l2q7jyn7y5@skbuf>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220210103636.gtkky2l2q7jyn7y5@skbuf>
X-ClientProxiedBy: CO1PR15CA0063.namprd15.prod.outlook.com
 (2603:10b6:101:1f::31) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e6ed054c-a070-40c7-97c0-08d9eca8f4fe
X-MS-TrafficTypeDiagnostic: DM5PR1001MB2121:EE_
X-Microsoft-Antispam-PRVS: <DM5PR1001MB21219D66AF51CDE3335CC58FA42F9@DM5PR1001MB2121.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:489;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: esYANxR+HpNjAzgLtvbTXZuEhVwqZgwn4L6pYErbnQxy5P6Bgth+y9sTpRDgyo9bjJmh+Litl8eZWOWkpErpnTa9PZOeMcXv4iN5XunTpMXACz8J4ieFXDDDm3ZI7ZqjoM30CjNdNxLZJauuTRkNMg3O0WZBcl/3ItgugST1qXkrR29nVqRVRhMR3haNvNs545HNHVC0oQKi0chzWEFNnTyh9ljqb3ezKrycuerjwF4TTYigsIf3yiox97fwdBfeS/lLcaGx7SMQm1+wyADToekgCO3vt/K7/P21HCr5RjKVETxdBRqD2t2fwDKOVa7jlE+D21FP8ybxrjb6HWX1vQ5GGf6vJuFI6AKqEq4eVKp6a32ckyIE0fxsR0/quvBO50ldWgzQN1CFWzOeHPjMh/Dbz6JVunZH1bMX+UbFA2OrDsPHNXbMGvH4xJAu1AT2e3RvFBB2U4R4UXyp0un4sSNvhBlmYHi02Y8lzsUS4TaRTbc57SIPCFuxKSyTjJjDGgu7/yPN0MPya+G4+klZEE5TPtsZZWCzyvDJPfxpYrSGLEq+OdJi4oAAb5fp6Te4d9bTYgq8ry8CwQS/S+jOeso/OfNJha6ccDl2a95KNofOYrOn3PU3BhrufDJEyLlqlKjCNoaEr2nE2eTYfdoz8mkfO2grfB6I3gXFFOfc1N3f17qW1g9KNLo3BfGjIcq6rEtrlNwRdcY1/IEFgp0/Cw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(39840400004)(376002)(346002)(136003)(42606007)(366004)(396003)(66946007)(1076003)(8676002)(9686003)(26005)(186003)(66476007)(4326008)(66556008)(6512007)(6486002)(33656002)(33716001)(38350700002)(6666004)(86362001)(6506007)(38100700002)(316002)(54906003)(6916009)(8936002)(2906002)(52116002)(508600001)(44832011)(5660300002)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?YNkJ3auWjbnaEuJaVx2HNv9ju/8bqFzMXMBDWbHQa5Q0S0WikqMeGZSPizmJ?=
 =?us-ascii?Q?nOQuxVgWVg/reo8w2rh3OFa3Zg07ZPtaBuysOq25KNRSRkEtG8mnhiqRePaM?=
 =?us-ascii?Q?Jn2HKVR3Tsgm1ZV3r7RxeBuvh9IBy3JO/Y8xROhqgAI8rOhJutvc72ug1YOe?=
 =?us-ascii?Q?95odSbptOepgDa/Ml8Eee6VNKeJqG3j2AVB8WxghDKVqy2LU6lITgaOatn/8?=
 =?us-ascii?Q?s+Mq4Ov09pfwIXMRKDsoBHNN3UNdRXcbInnxdvUA4gmoNLAjMjVMl+i1VnA8?=
 =?us-ascii?Q?FvODIg/Z267+5fsRPTC8T1NzggXO61EPTGfxxWSqV9NfpHndfoDs9tWij/pg?=
 =?us-ascii?Q?P3+hTPFuWmzbA7YetQEkZlA+tSlMjJw0yL3qF0UPHhNI9mUF/O9c9Yuu84cv?=
 =?us-ascii?Q?pmWJNR98GhM9/Wf5eYkCW4NXqMd5V2kuo+UiTvHgBPGVJ0rGthNPdo5SUTlT?=
 =?us-ascii?Q?W2HaYphQjDQZTodi7GCYfuXXYftRHYQA+lDYLkbrAenTEd/eC5cPbB9J2FWH?=
 =?us-ascii?Q?e7UUKWBN7PF/357FfL2qg+ZjqhgpukDRPLbaM9EL1o2wv/xhrQ+qxFsCxwpR?=
 =?us-ascii?Q?f5NVKtOw/f5UUR63YvIU7wd7hJ8pIUfTOxebWLbWMWDvQ/9e/c/j5p2n3pIb?=
 =?us-ascii?Q?EhWA00JlgD08LsWVri5fT1eSBMcpiAHcpSvcJoOgY8zSmAsCVuGFB/rJpcjj?=
 =?us-ascii?Q?YNwGGsFF+7mkepLFbgG/TEi+IrYsiyNC4BLWJPvQ+CKlIOG2uFGuTuG7edpY?=
 =?us-ascii?Q?ifJ2+G6KMXfW5YRMRK2ER7bL786e+p7u+MtYcE05TOmBrTOBekFkXXqAvaK4?=
 =?us-ascii?Q?JhtA0LByTnnmw3/2wUS9XiBK7oh9wwdI0YcvYLsg0Ff2I/UcdUWUjWakWgxy?=
 =?us-ascii?Q?4xYUgcQqkBhczP7C+b4r5bGUuqRi0LVsudBD/2yj2cYguWmi4Nt4U4yRlXZs?=
 =?us-ascii?Q?6V760zL7VpXBSFnWHX8ZW31FtwsT/xMJ1htY+0tqfLrUxhjecClt/MtEQitR?=
 =?us-ascii?Q?bu0nKrDL0ta8W21PdHHXmISd84mxhaddwahGClD7qBohAEQsN3CbF24tz6YD?=
 =?us-ascii?Q?Tsmc/ztWCba1M0r5g4nnv8SNchp5e6pWdZ8U0f33ga8LtWK3RyqKXE3yqKQr?=
 =?us-ascii?Q?InBxmC5oOoVho8R38TAGPe2PGgFp96XPQKeStt+gzVD2bNqL0iia/1NScIje?=
 =?us-ascii?Q?Fz8ql2lkOz9NZOXeolr1DIOkxVOLPsZgJzF4O67fIv3zPG4h1QV+AteHt1Uo?=
 =?us-ascii?Q?tvDsjfxNENty2edyfyH2TxGn/MXnZEg/s7n1g0ePv6Q1OBlickyvSN725ja1?=
 =?us-ascii?Q?WgR0XKGl21G7tBTbjCD+uxhn7BCA9YlabMt73RarLh2cycfvJC/HGxlANYlG?=
 =?us-ascii?Q?s/mHM1JpTyriySMwaJLeAdZwuaUYHc++liSwN2LrsDnni+3CijFFLlR/vG4i?=
 =?us-ascii?Q?HslnUE22k/FnSV1iL6NsioRQUy6Hy4krkqX6FFXOE1aM2CTXMibzIr4TkBWx?=
 =?us-ascii?Q?cIibvGNtd9YlXlczdx0UqrCa0SogGXwslAGioDWE5fSkCVC03WDdfgOZBDSi?=
 =?us-ascii?Q?Z6IXv8g+DSNs+m2/AVCzFbzayT7ofv5uVpaB7qPEKmTS1Gyc0wLMfJNS+wtI?=
 =?us-ascii?Q?FPRrkKg5isvV0Z4ivjaeile4ZwFzHl1RdeR7mFd/sKZRAW16ms3PmY/1ER9R?=
 =?us-ascii?Q?8Jqb64OpNSiAzLeQSWCQ/9t0W/g=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e6ed054c-a070-40c7-97c0-08d9eca8f4fe
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2022 15:21:06.0341
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kx7eiWe/vPZnIRNNlvOFl2jxfaB4q4RaXoxOSYxRub0gww18efYi2mID6gMd5FK1D0CEk4n5gVWh53dfL0Bg2rixO+57pXTE4gVzP1hXACs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1001MB2121
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 10, 2022 at 10:36:37AM +0000, Vladimir Oltean wrote:
> On Wed, Feb 09, 2022 at 08:13:45PM -0800, Colin Foster wrote:
> > Create and utilize bulk regmap reads instead of single access for gathering
> > stats. The background reading of statistics happens frequently, and over
> > a few contiguous memory regions.
> > 
> > High speed PCIe buses and MMIO access will probably see negligible
> > performance increase. Lower speed buses like SPI and I2C could see
> > significant performance increase, since the bus configuration and register
> > access times account for a large percentage of data transfer time.
> > 
> > Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> > ---
> >  drivers/net/ethernet/mscc/ocelot.c | 79 +++++++++++++++++++++++++-----
> >  include/soc/mscc/ocelot.h          |  8 +++
> >  2 files changed, 75 insertions(+), 12 deletions(-)
> > 
> > diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
> > index ab36732e7d3f..fdbd31149dfc 100644
> > --- a/drivers/net/ethernet/mscc/ocelot.c
> > +++ b/drivers/net/ethernet/mscc/ocelot.c
> > @@ -1738,25 +1738,36 @@ void ocelot_get_strings(struct ocelot *ocelot, int port, u32 sset, u8 *data)
> >  EXPORT_SYMBOL(ocelot_get_strings);
> >  
> >  /* Caller must hold &ocelot->stats_lock */
> > -static void ocelot_update_stats_for_port(struct ocelot *ocelot, int port)
> > +static int ocelot_update_stats_for_port(struct ocelot *ocelot, int port)
> >  {
> > -	int j;
> > +	unsigned int idx = port * ocelot->num_stats;
> > +	struct ocelot_stats_region *region;
> > +	int err, j;
> >  
> >  	/* Configure the port to read the stats from */
> >  	ocelot_write(ocelot, SYS_STAT_CFG_STAT_VIEW(port), SYS_STAT_CFG);
> >  
> > -	for (j = 0; j < ocelot->num_stats; j++) {
> > -		u32 val;
> > -		unsigned int idx = port * ocelot->num_stats + j;
> > +	list_for_each_entry(region, &ocelot->stats_regions, node) {
> > +		err = ocelot_bulk_read_rix(ocelot, SYS_COUNT_RX_OCTETS,
> > +					   region->offset, region->buf,
> > +					   region->count);
> > +		if (err)
> > +			return err;
> >  
> > -		val = ocelot_read_rix(ocelot, SYS_COUNT_RX_OCTETS,
> > -				      ocelot->stats_layout[j].offset);
> > +		for (j = 0; j < region->count; j++) {
> > +			u64 *stat = &ocelot->stats[idx + j];
> > +			u64 val = region->buf[j];
> >  
> > -		if (val < (ocelot->stats[idx] & U32_MAX))
> > -			ocelot->stats[idx] += (u64)1 << 32;
> > +			if (val < (*stat & U32_MAX))
> > +				*stat += (u64)1 << 32;
> > +
> > +			*stat = (*stat & ~(u64)U32_MAX) + val;
> > +		}
> >  
> > -		ocelot->stats[idx] = (ocelot->stats[idx] & ~(u64)U32_MAX) + val;
> > +		idx += region->count;
> >  	}
> > +
> > +	return err;
> >  }
> >  
> >  static void ocelot_check_stats_work(struct work_struct *work)
> > @@ -1777,12 +1788,14 @@ static void ocelot_check_stats_work(struct work_struct *work)
> >  
> >  void ocelot_get_ethtool_stats(struct ocelot *ocelot, int port, u64 *data)
> >  {
> > -	int i;
> > +	int i, err;
> >  
> >  	mutex_lock(&ocelot->stats_lock);
> >  
> >  	/* check and update now */
> > -	ocelot_update_stats_for_port(ocelot, port);
> > +	err = ocelot_update_stats_for_port(ocelot, port);
> 
> ocelot_check_stats_work() should also check for errors.

Another change I'm catching: I assume calling dev_err while holding a
mutex is frowned upon, so I'm moving this err check after the counter
copy / mutex unlock. I'll submit that fix after patch 1 gets merged into
net / mainline.

> 
> > +	if (err)
> > +		dev_err(ocelot->dev, "Error %d updating ethtool stats\n", err);
> >  
> >  	/* Copy all counters */
> >  	for (i = 0; i < ocelot->num_stats; i++)
> > @@ -1801,6 +1814,41 @@ int ocelot_get_sset_count(struct ocelot *ocelot, int port, int sset)
> >  }
> >  EXPORT_SYMBOL(ocelot_get_sset_count);
> >  
> > +static int ocelot_prepare_stats_regions(struct ocelot *ocelot)
> > +{
> > +	struct ocelot_stats_region *region = NULL;
> > +	unsigned int last;
> > +	int i;
> > +
> > +	INIT_LIST_HEAD(&ocelot->stats_regions);
> > +
> > +	for (i = 0; i < ocelot->num_stats; i++) {
> > +		if (region && ocelot->stats_layout[i].offset == last + 1) {
> > +			region->count++;
> > +		} else {
> > +			region = devm_kzalloc(ocelot->dev, sizeof(*region),
> > +					      GFP_KERNEL);
> > +			if (!region)
> > +				return -ENOMEM;
> > +
> > +			region->offset = ocelot->stats_layout[i].offset;
> > +			region->count = 1;
> > +			list_add_tail(&region->node, &ocelot->stats_regions);
> > +		}
> > +
> > +		last = ocelot->stats_layout[i].offset;
> > +	}
> > +
> > +	list_for_each_entry(region, &ocelot->stats_regions, node) {
> > +		region->buf = devm_kcalloc(ocelot->dev, region->count,
> > +					   sizeof(*region->buf), GFP_KERNEL);
> > +		if (!region->buf)
> > +			return -ENOMEM;
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> >  int ocelot_get_ts_info(struct ocelot *ocelot, int port,
> >  		       struct ethtool_ts_info *info)
> >  {
> > @@ -2801,6 +2849,13 @@ int ocelot_init(struct ocelot *ocelot)
> >  				 ANA_CPUQ_8021_CFG_CPUQ_BPDU_VAL(6),
> >  				 ANA_CPUQ_8021_CFG, i);
> >  
> > +	ret = ocelot_prepare_stats_regions(ocelot);
> > +	if (ret) {
> > +		destroy_workqueue(ocelot->stats_queue);
> > +		destroy_workqueue(ocelot->owq);
> > +		return ret;
> > +	}
> > +
> >  	INIT_DELAYED_WORK(&ocelot->stats_work, ocelot_check_stats_work);
> >  	queue_delayed_work(ocelot->stats_queue, &ocelot->stats_work,
> >  			   OCELOT_STATS_CHECK_DELAY);
> > diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
> > index 312b72558659..d3291a5f7e88 100644
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
