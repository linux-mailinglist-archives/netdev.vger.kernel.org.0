Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A1944ADD29
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 16:42:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381262AbiBHPmG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 10:42:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381201AbiBHPmF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 10:42:05 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2094.outbound.protection.outlook.com [40.107.236.94])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1047BC061576;
        Tue,  8 Feb 2022 07:42:04 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z8CFtoy8ipOnvezTWrtm90CjoRxQVMxuNeE6nyJDXczorPg7FxIPiwZi50Ia3C0wRo08piGxUpqPjMuozFZenCMqeSgzQDEcQHu+rq1yp99XfUAQt4OM8TDk8Zbr+LwrKJKUI9FFzWcmuT95zrXKlZbBrUyWuWeUftTtV0TRxEZE4XQhS4fQMeKxZgJ+/dIy+7in43uAu8JjCGcrZPTQq9d1DQF/+1CPyxTLhP6OZZNSfFuJFXSbgJXK5aalOpcwaQvVsmj3xi1PusiURw/U40lNucaoo62eBdJmEEeVW/hN/EMnGmSV3DOiTZ79QXd4wGTT6iXXsex9q+4oXTensg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8bD5WbGEm+tRkmelTLzHqw5jfpZFuTpkoUxqt6tPOBs=;
 b=Q/7b56xobJIu6hE+SIe9bXyuSu/8hNgBNndBx+NG6tG7A34ESPDCgZgsgi4X2WhVJQUF8dJx+FP0vJWsqlGCZwdjkbbm4qjWJeFpK/QYxTtcd6j7GZknly9fXKXBavrojB0BnC1SOpw92/sJk0Z0noGZohwf7XDTraXF16/gb9UPF/l0Z3sHTXD/TSBVjwgCZvyC0a4WSxkMrtmtvrd3ZGhMe03YmBHOos2/+Jx64/um5ripdQKpCxKSSKAtfaq3u1P1swiXrhM7j/wmE7bEuvZyguMJtjPBV2aFsd5/ZO5olIhpoxgn3vysF63XKzJZBjyb6f30Lf5dY8HhAV5OgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8bD5WbGEm+tRkmelTLzHqw5jfpZFuTpkoUxqt6tPOBs=;
 b=nFRhuuj//6IjbRhm48BsTyQ+/elnsEAJVToBOYN8N6JjCCyy7JjWEiYizU+Ww4CkS220AlkHPFvfso2rwrCtYZ/hJvK61xFr64Iz+iEkdoh78lplMtoNZUA88MZG/FDQnEMazBPzKaibeW4k91zgJE7UzpVnLJSDOMEIacGSxpE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by CH2PR10MB3895.namprd10.prod.outlook.com
 (2603:10b6:610:9::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.17; Tue, 8 Feb
 2022 15:42:01 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2d52:2a96:7e6c:460f]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2d52:2a96:7e6c:460f%4]) with mapi id 15.20.4951.018; Tue, 8 Feb 2022
 15:42:01 +0000
Date:   Tue, 8 Feb 2022 07:41:56 -0800
From:   Colin Foster <colin.foster@in-advantage.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
Subject: Re: [PATCH v5 net-next 3/3] net: mscc: ocelot: use bulk reads for
 stats
Message-ID: <20220208153913.GA4785@euler>
References: <20220208044644.359951-1-colin.foster@in-advantage.com>
 <20220208044644.359951-4-colin.foster@in-advantage.com>
 <20220208150303.afoabx742j4ijry7@skbuf>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220208150303.afoabx742j4ijry7@skbuf>
X-ClientProxiedBy: CO2PR05CA0007.namprd05.prod.outlook.com
 (2603:10b6:102:2::17) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 08f44c29-5be9-4e60-146f-08d9eb198c62
X-MS-TrafficTypeDiagnostic: CH2PR10MB3895:EE_
X-Microsoft-Antispam-PRVS: <CH2PR10MB3895830F4D44B3C7C033A346A42D9@CH2PR10MB3895.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6lJCbX5ApBewAG5XI96ecg9n1DoQ+ysOCmLb12Vbe2kLhIs7iBcopV+4FvYPhnFrrqQX0sdRdpWrVJYPojCRNaP9iSFx9KInENVqQNxUt7nqtVZRYf9TdqtMkGdbEVVGdmR0dH/AnQQcrZsk9i6Ym1Zb0DZSQ45lX35+GnfDI3WwDgdrwDnmmas77CqyPxhUT6UNKrLkGmL0WQag7eDrBCXtpZbD03muqDmgRsmyKMCtnK7RW239bmOiwNEpkBFFA7GQQ+WhTLvo2IP4r84ZxSMgbtQPnLB1n0TpwrrbONdRX8aZgWiMztDZRB1EieBp+XTd7YZJfOc5x7u3IINyNHxwhrNIImZ5FROhPqXjskIcfLRMzeXgeXhqlI2b9rqfdWkvQYMSMovgkCKKy8HmCn3ZFYXZxMDg2iImCCSTwYlpBq0ZleQCdNsoz7JvcnNOKBRWaRZymgxi/7/rVC+liOpLjzlhzSGW1Ja/RHYMw+6qW8iOG1dCKpOiTgQdWkztE4BGUtLqRaSparBwnDnhFv7M5gnhG731pDXZOUs7BpGrhhgkx9418HPK//BQPyBo4sD76FxtB93mgZ55RmErThgy1tKApPWNTWX+3a5wxHUaO8vETOiznIYK2bTB5vZTiS2WvMVkGFTPwgXbfieg5A2m+kY84pij/59wodedYb19DCrvvi8+bhtle/j5Uxpp42sUDZPbUIhKikDpV8xhHA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(136003)(39830400003)(376002)(42606007)(396003)(346002)(6916009)(9686003)(5660300002)(44832011)(66476007)(6486002)(6512007)(2906002)(83380400001)(54906003)(33656002)(6506007)(52116002)(86362001)(6666004)(4326008)(66946007)(8936002)(8676002)(33716001)(26005)(186003)(1076003)(508600001)(66556008)(316002)(38100700002)(38350700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?x+k3UjE/Ip+RCkSEbfe/zIqsh3/zbb9b+NabyOKiUSNQ0gq57mxPTcJiiOjA?=
 =?us-ascii?Q?yDV9Kzv+Vw9RaPcVTbpDh0CVmuDUv2rwvA1EcNjPZthMvWEeh/ja5GYs1TAg?=
 =?us-ascii?Q?A1xiOBXox0FQSdPb7J+9dmhtoeY7jR4j8mWTq7N5CXv0tZG7BDp3IbrsXuij?=
 =?us-ascii?Q?dFAshELdlnjqWNY5DkK0EZh55qwdLbBUeQQErkWscLfVmTSkRVOCW6JTt2ue?=
 =?us-ascii?Q?PUmy+++q/CevKwTzJ7UZb7HQS7SwVlfRlXs4NU1jYHTLj668PyDoWGhr34oh?=
 =?us-ascii?Q?JUrPDkjjOjkqnyZJWpOYID775/LFqF5CdBWL721YQwX/VpBzWsRuCvQL7uuj?=
 =?us-ascii?Q?FaM0urlsPcibbF3ob/5Nah1Ao8wJ+1gpWt1qnqLYCeEbohiBsXZ4l3wFHl+X?=
 =?us-ascii?Q?2UpMWkHgHW7mh59wnMYiz6PIjyDM/6vYC2ZJUXHykrz/5f6GOyi3UIT3y/5v?=
 =?us-ascii?Q?s5e7737HJojSTFhhByadbR611c2BD972QltJ54AWKZcH6TOcIZAi8ZnDEvdi?=
 =?us-ascii?Q?D7UUZ+ExRtMsFBh49+paPP0DDgC2aCQwyc8h7g+GSJerFrewgYN0McJM3b/K?=
 =?us-ascii?Q?B/cBs3PCt/0+7UmwlV2R6qXdguNlkh6CfRf5dgmW1/P+TTk19u5izuJ0fvF0?=
 =?us-ascii?Q?hVdxKYIflqRxWKVZAhd1SodMCluKZwvFkrsirR8thP3K4BkIPEyKnHWtN6cz?=
 =?us-ascii?Q?wUo8M4G98tyinGkZvyswko9WUPjWh8Y3TEnk1BjYogqsKVEfQ0gRNZz5iPCi?=
 =?us-ascii?Q?cVVKLrAHsvwgUSEXBuJXsIYw1U17rCDV3cjH0k9+yVw15MF8jaQ3Sm4mknkt?=
 =?us-ascii?Q?beGNbHGuk6tQwzFoU2fvjt3MnHfKbjZy6YIF3Y5yhCnKMdW3CvnNYbSz/DrX?=
 =?us-ascii?Q?yK6DdvokRaqMOVofzjxIu/D1/rte+PKViBo9w1Kv8Hm6dZwe5wZqHmjksQbz?=
 =?us-ascii?Q?L+WIJY4TeU/hNv95epF/2N8kF2v6owBDXiDAZthaqX0Sf+cdcbvqQYe83cDT?=
 =?us-ascii?Q?PF2bRURce37ffd8x2rKTcwr4cF/iO+phsCXDOuIEYAMonBjv5h7Y4ojSp/Jd?=
 =?us-ascii?Q?e/ae4iJ0u8iirimlfKc9QAgN8do3bynBI5+GtYhWfUupo+rnvkDKNE7D0ROJ?=
 =?us-ascii?Q?1ezaPFLAxSUXGg51Ez9425SyMrVWICGCJQt0ov589tMDiBqSIcRydfXC8yC0?=
 =?us-ascii?Q?k+b0pxBExjRFBOroxTzujLoQW59rqGPRr0Oe9Z8JvFxssF+NLNWKkyCBnN91?=
 =?us-ascii?Q?bt3yqva/amDgm+Fs7FTPjSsDy7NpXvjYmqhIedGI1GfPnHSm92y+Nrw9roLB?=
 =?us-ascii?Q?jjCgLOzrR3y7zpD7NSNq8u1Ua4AyDo9613+atJBQ+GDReuhnm7zHkoWLjzNf?=
 =?us-ascii?Q?0Tvut28CxxfgU1w4J3bTesn5PsX4gK9Q/u14ntOTRCmVf3loKZr7NK4BwMi+?=
 =?us-ascii?Q?oUxeUIroWocrDji3olowlYOyf+p7HNfLiYGmfXsMtibH9detVwM3cxCasL0t?=
 =?us-ascii?Q?e7j9G+pk7JNQZUAx7Q2BAWD3/eaFUWkgpVyXyBYa4WGUKXv3psj0i+8Z8Cag?=
 =?us-ascii?Q?TnjWxAJlROb8zINq7kG+4Hi4oo1nS41X8gWo3VQO0yhXwfleYD59h/0D7V+N?=
 =?us-ascii?Q?fO8sFhHkTFqeFAz3kh7c+tNv19FbFJxj5RNi5XQ20S6Tk1MtXuWhUviUdJQD?=
 =?us-ascii?Q?IKa89Q=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 08f44c29-5be9-4e60-146f-08d9eb198c62
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Feb 2022 15:42:01.3614
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iJTJhq8Kf4Q0LmgUG11jCU63DpRW3DC+oViv3BQXLAWlqabPctr0g2BjW+CLW3IE6oJJTdP/N7BgLuqCLhAQRA9yNKQCSXq7YHGPnHF7gNk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB3895
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vladimir,

On Tue, Feb 08, 2022 at 03:03:04PM +0000, Vladimir Oltean wrote:
> On Mon, Feb 07, 2022 at 08:46:44PM -0800, Colin Foster wrote:
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
> >  drivers/net/ethernet/mscc/ocelot.c | 78 +++++++++++++++++++++++++-----
> >  include/soc/mscc/ocelot.h          |  8 +++
> >  2 files changed, 73 insertions(+), 13 deletions(-)
> > 
> > diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
> > index 455293aa6343..5efb1f3a1410 100644
> > --- a/drivers/net/ethernet/mscc/ocelot.c
> > +++ b/drivers/net/ethernet/mscc/ocelot.c
> > @@ -1737,32 +1737,41 @@ void ocelot_get_strings(struct ocelot *ocelot, int port, u32 sset, u8 *data)
> >  }
> >  EXPORT_SYMBOL(ocelot_get_strings);
> >  
> > -static void ocelot_update_stats(struct ocelot *ocelot)
> > +static int ocelot_update_stats(struct ocelot *ocelot)
> >  {
> > -	int i, j;
> > +	struct ocelot_stats_region *region;
> > +	int i, j, err = 0;
> >  
> >  	mutex_lock(&ocelot->stats_lock);
> >  
> >  	for (i = 0; i < ocelot->num_phys_ports; i++) {
> > +		unsigned int idx = 0;
> > +
> 
> This is a bug which causes ocelot->stats to be overwritten with the
> statistics of port 0, for all ports. Either move the variable
> declaration and initialization with 0 in the larger scope (outside the
> "for" loop), or initialize idx with i * ocelot->num_stats.

I see that now. It is confusing and I'll clear it up. I never caught
this because I'm testing in a setup where port 0 is the CPU port, so I
can't get ethtool stats. Thanks!

> 
> >  		/* Configure the port to read the stats from */
> >  		ocelot_write(ocelot, SYS_STAT_CFG_STAT_VIEW(i), SYS_STAT_CFG);
> >  
> > -		for (j = 0; j < ocelot->num_stats; j++) {
> > -			u32 val;
> > -			unsigned int idx = i * ocelot->num_stats + j;
> > +		list_for_each_entry(region, &ocelot->stats_regions, node) {
> > +			err = ocelot_bulk_read_rix(ocelot, SYS_COUNT_RX_OCTETS,
> > +						   region->offset, region->buf,
> > +						   region->count);
> > +			if (err)
> > +				goto out;
> >  
> > -			val = ocelot_read_rix(ocelot, SYS_COUNT_RX_OCTETS,
> > -					      ocelot->stats_layout[j].offset);
> > +			for (j = 0; j < region->count; j++) {
> > +				if (region->buf[j] < (ocelot->stats[idx + j] & U32_MAX))
> > +					ocelot->stats[idx + j] += (u64)1 << 32;
> 
> I'd prefer if you reduce the apparent complexity of this logic by
> creating some temporary variables:
> 
> 	u64 *stat = &ocelot->stats[idx + j];
> 	u64 val = region->buf[j];

Can do. Thanks for the suggestion.

> 
> >  
> > -			if (val < (ocelot->stats[idx] & U32_MAX))
> > -				ocelot->stats[idx] += (u64)1 << 32;
> > +				ocelot->stats[idx + j] = (ocelot->stats[idx + j] &
> > +							~(u64)U32_MAX) + region->buf[j];
> > +			}
> >  
> > -			ocelot->stats[idx] = (ocelot->stats[idx] &
> > -					      ~(u64)U32_MAX) + val;
> > +			idx += region->count;
> >  		}
> >  	}
> >  
> > +out:
> >  	mutex_unlock(&ocelot->stats_lock);
> > +	return err;
> >  }
> >  
> >  static void ocelot_check_stats_work(struct work_struct *work)
> > @@ -1779,10 +1788,11 @@ static void ocelot_check_stats_work(struct work_struct *work)
> >  
> >  void ocelot_get_ethtool_stats(struct ocelot *ocelot, int port, u64 *data)
> >  {
> > -	int i;
> > +	int i, err;
> >  
> >  	/* check and update now */
> > -	ocelot_update_stats(ocelot);
> > +	err = ocelot_update_stats(ocelot);
> 
> Please, as a separate change, introduce a function that reads the
> statistics for a single port, and make ethtool call that and not the
> entire port array, it's pointless.
> 
> > +	WARN_ONCE(err, "Error %d updating ethtool stats\n", err);
> >  
> >  	/* Copy all counters */
> >  	for (i = 0; i < ocelot->num_stats; i++)
> 
> and here, in the unseen part of the context, lies:
> 
> 	/* Copy all counters */
> 	for (i = 0; i < ocelot->num_stats; i++)
> 		*data++ = ocelot->stats[port * ocelot->num_stats + i];
> 
> I think this is buggy, because this is a reader of ocelot->stats which
> is not protected by ocelot->stats_lock (it was taken and dropped by
> ocelot_update_stats). But a second ocelot_update_stats() can run
> concurrently with ethtool and ruin the day, modifying the array at the
> same time as it's being read out.
> 
> The new function that you introduce, for reading the stats of a single
> port, should require that ocelot->stats_lock is already held, and you
> should hold it from top-level (ocelot_get_ethtool_stats).

I'll add this fix as a separate patch. Thanks as always for the
feedback!

> 
> > @@ -1799,6 +1809,41 @@ int ocelot_get_sset_count(struct ocelot *ocelot, int port, int sset)
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
> > @@ -2799,6 +2844,13 @@ int ocelot_init(struct ocelot *ocelot)
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
