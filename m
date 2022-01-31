Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AF514A4AF9
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 16:51:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379893AbiAaPvG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 10:51:06 -0500
Received: from mail-dm6nam10on2129.outbound.protection.outlook.com ([40.107.93.129]:31841
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235351AbiAaPvF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 31 Jan 2022 10:51:05 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jCPkEbAd29epGjy/9VRK5Ujo6hVdaH7YVI2huxyJs8OZsmFIxySRT/7q1T6PwO2DV2FJch2o43zn7dU/CAipFTNWvuaObO6u7EFY22XIYG8JQBEGuEGxBPU6Epi0ZJzuhczmMDTr/FbZyJGDuSnTWKYGy/1/NZx1CakmzFXHtZLHGASdPwfu3kHYse3WuLY4At06XHJ5kaq5hHdBMw5BomWriZzBaPpzrcZtKq4t231YrFfi/fvkzomuaKqwcDYjMRKoiHv+2sM1HP+gH76y30/a5ebieH1ro4FfKnZaRb/iJjRDUF0ZzMPl8KjPYVDYxkXZsC2n0vYgUKYr40gnYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XFY++8BXELZgF8+M5Gjy9v1VJ5OqBONJ8sXpmf7S494=;
 b=ZE+GnPvJc//zUXvmF43zRbZfeeuiBPFwMShyUqomWEqOjjPUQ6VKKAeJq7efat8O2FgfLEIUnW/C/5U9GBdQT2uqlRSnhTvhmpFj5elv2m0kdynM9A+p6wMx4yUG4ELQphu40Nyn1RXAi7QYy80PT4hTT3fnmsrFhA2Bf6z0luIAyL1KfnRU01lzjt6In1YPeapu4fmTw3F7xsv8qOao4fcIN918K4BUc+lzZi+eewYvAo72/WVKFl1BPHKs3OOaprjIwCrycm2iW7TUaXP7naBQpHNtbii3Y3P7Uo8pdNzV9kmcebcxftqo8uttcsxmK/zpXqK6g3Ql80Dsi3qEpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XFY++8BXELZgF8+M5Gjy9v1VJ5OqBONJ8sXpmf7S494=;
 b=VPuc8B8r0KQYF7QVQPncNi2dya3Yh0Vlfy5JagmWFSP+dMF9tqQCZ6xmfB6T4WO18QTtrP108l0nlt4gUPuH/enzaQCfyLiamWptLGG1rSYcKIrvFDkrdVr69QXmyjyCxWlUHFklHuzOPWBCWbaKhvK1S/mp/BG1RmAc7OiFEDM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by BYAPR10MB2885.namprd10.prod.outlook.com
 (2603:10b6:a03:82::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.15; Mon, 31 Jan
 2022 15:51:02 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2d52:2a96:7e6c:460f]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2d52:2a96:7e6c:460f%4]) with mapi id 15.20.4930.020; Mon, 31 Jan 2022
 15:51:01 +0000
Date:   Mon, 31 Jan 2022 07:51:10 -0800
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
Message-ID: <20220131155110.GA28107@COLIN-DESKTOP1.localdomain>
References: <20220125071531.1181948-1-colin.foster@in-advantage.com>
 <20220125071531.1181948-3-colin.foster@in-advantage.com>
 <20220131102255.zgfmbzmffup6rste@skbuf>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220131102255.zgfmbzmffup6rste@skbuf>
X-ClientProxiedBy: MWHPR19CA0004.namprd19.prod.outlook.com
 (2603:10b6:300:d4::14) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e89edf8f-2e38-412a-14f3-08d9e4d17af3
X-MS-TrafficTypeDiagnostic: BYAPR10MB2885:EE_
X-Microsoft-Antispam-PRVS: <BYAPR10MB28856462A5B6FB8581D99F2EA4259@BYAPR10MB2885.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1091;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HKhgyBjMSg8Pq8+D5gvJfg7JstZSGflmYwXYkU5i604TRaxr9BmPLuJ2l6acMJNetoS0d9qj96hkcbP6rgrMjEllPvmBf13jbUptegZfbZCJ/1ACqKwO9XLMV+hw7QE5j75IjM1rxNMP3lb4LkpDSOSY0pZOYjtgBC7cRdCRB+VnCOCHkgcG/uTI2klcyQOPPBATUgPN1qFq8NnQMMz0Svn5fWIBDchwZw6v+uFwnSRES9OBDqhn/aQ4uO+Xt1wWdVHOuYlp/wFS3BSoY8GLHWtz1ky4/isT+Fg98/bLaz/8SIUjnymudkM68v4aFbV3uaCoBSsPW4T71RIvtCwUBQrjQ1G08f1/fiAUoz6pDZQox+N7SBziF0I2Sdx3wHLYuojACe1eJYDAPjIAAdlPsv8iES55/BQ2aOvJxL4STVgRn+DU8FdrKptN6Ohm3oXRbwMTh5hjOjLlNlo/Ll6xeKq3TG/BXy9h2WqCmcOrdbw0IxLJ8JMS9iJvNNwGtSpCkGdpr93vBmqsMlAJHQPjqgP2QV6uzcaedgBBW8T/0LTY+1QwD3zOfU8NUdxcPCo6Sfs7OuufpKNGA7pHypSD8INMNcFuEbUcJWuzgmUgeg1I5Rkqhce48NNS3qdzH9vmSkqaNIdE2Qirq42exYDKi57zmQYh8/bhNz3C7WjM6batRIkPI0hKZAVifnWn3mSS6xHxxIfxPS1AOkyLloxvUQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(42606007)(396003)(366004)(346002)(136003)(376002)(39830400003)(52116002)(508600001)(6486002)(66946007)(5660300002)(33656002)(44832011)(316002)(8676002)(2906002)(6916009)(8936002)(86362001)(66476007)(66556008)(54906003)(4326008)(6506007)(6512007)(6666004)(9686003)(26005)(186003)(1076003)(83380400001)(38350700002)(38100700002)(20210929001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?VG/5WUAk0iOioTKqzPpSk45NwFFCzTzjMQeY59jHR3IZEq63xxVltgD4VTkj?=
 =?us-ascii?Q?f5HyUp8z4M80GxmwInIk96CauW5Ij1CSketa9z8p0S0LzanExQMbg3RIVzS3?=
 =?us-ascii?Q?FaG1p33odquVnOlowMLR6BvfSFX/5ISng+xcurCqSqFRDis2MKy0BKiMeOLg?=
 =?us-ascii?Q?1c2HoM+LjcV0skCwf2i9wZk+tdFOKoVCPyHE1hQ0hDhiZY72p+xGh5HPen0q?=
 =?us-ascii?Q?DRCWc2ehv1elvnhbIqYTwmLzCQSB00qy7RNBZfeDj7/q3uPTpHlOE4xkJNB3?=
 =?us-ascii?Q?yFoTHmSnX6NSJkPHdS3+vxo4qpfaxIADMHpGSaTUg3Pc77XYv9Cl17FWtz+t?=
 =?us-ascii?Q?0vhS5GikLRx+dI8n7Do4PPJ24tvzFJqb/iBYjefTZvrJQBNmAuiIuK8D9U9+?=
 =?us-ascii?Q?lc2E3kK1Hwyq5ytlSaPT7UTQiDp5gQZN1Z4E0xOz4EJY8E/TCDEd5e1evTfe?=
 =?us-ascii?Q?m8B7kpbFxARXXFrQrzM+Aqt9vuVbCeY/SfnoxYYmSLE97wleHnrNVEHrastg?=
 =?us-ascii?Q?zojkPrygeOvoJ0Lse2g/zol/Lq46y5R8iD2njJhX2HcpWLuNdRRADhtBC5mz?=
 =?us-ascii?Q?sjFRUDmwofydSG3DNjY6rZaQfUXl3wvgGH/1glG9gXb5nmyk8gDNRnBn0aCZ?=
 =?us-ascii?Q?4RoZHtrbt71Ch4oIvzClLAuoNe4XclHr8A/BUCNE1r5E9OAxQWpUMykQSCPq?=
 =?us-ascii?Q?09IgeshjGSdXN+PJS1rB6TUCXdeTkEjyf9W1fDTp52kIDIHhAZb7HHdGMk43?=
 =?us-ascii?Q?psOTgxP3+UrEyB7rB6zjwts4re7eoPPEtquLZ04GCmvanhuALDJOdHBqJcm1?=
 =?us-ascii?Q?1d5ahVZqgFuXtQ8MohIcmdySNi+YbeavPAcs5RgVypLeIvbyiwCsDBqb9V6m?=
 =?us-ascii?Q?F7amDI1rt5+C5y6xvp8N2/MWahPW1X7uT6bJXq9f50Gxj93BOo4HegAWXR7/?=
 =?us-ascii?Q?YT4qsdbPSTdGRVCCoDEPXgp30csRvVgFxjoHNaXkYB0tFWOOCuZibDJP9ms0?=
 =?us-ascii?Q?W8g1vfZRAJjIMColAgjIlEskvMn7qR7j8HjGENvEFgJVxJ4KhQJ8UjlqUSVu?=
 =?us-ascii?Q?SN0KQ7/ZOasz3/o3jPIU+YJmQXEkqTHDmgt7iA8/U1Y8EUxwqQSYWNktlFwL?=
 =?us-ascii?Q?EUFdzUTyW2a1MquaI8tBiY6HIHbHJT0y8qqSSfwjvICPd+DmqB16bqGfQSvc?=
 =?us-ascii?Q?CsfRT68hPvZ5JWELbuY7Fw5WD/La3JT9GQrMY0MDBCzCRq2KDoaYodX3NCVw?=
 =?us-ascii?Q?BauFNLWz0VxvKBo1Nj9S88wJ3MIdMPOo6qt//gllfOYV7BeXUoPELI16iPA8?=
 =?us-ascii?Q?JrccNXC6W5FnLU6t1FuK6XO0j+kv206h8Ay/SYWDeI15kEcaigPrITf4GrQu?=
 =?us-ascii?Q?c7We1aagA/wphx5QxtPDw3YF7L89NAq5gaGU93ZgngAm+RNW8o3I+tkvxWvT?=
 =?us-ascii?Q?LSHsc50OiC8LG014jRtf/BUuEldTB0ROr5MKdTWgXwH96mKfwo+RbaG/E4Ar?=
 =?us-ascii?Q?DadCJPas3NCpbQMA6E6tR7vT10+0J7Uy1oXxNzG8FISFoOstV+nYfbuTzikg?=
 =?us-ascii?Q?Grs2EjVATHp/5eDo9J1k1qceWYpnUN8o5i6H7yjd9Gtr2r0swSfyrrt5wVXS?=
 =?us-ascii?Q?nUtXqpg8X/vnxM+zas4dGL4ieDck8QveqTWUzFNHid4G/Hxj/8s15Oop37Tu?=
 =?us-ascii?Q?b/M66Q=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e89edf8f-2e38-412a-14f3-08d9e4d17af3
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jan 2022 15:51:01.6996
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PmXwMCXyOnnvwHM6VI2Xh1jvYQNLvQOZXfzOIHsSONxLQR4zq1EELiHmb7ZLLeaDHkDJa5/0F9Bko+dM3uN/63wmrn5XqUi0y2FQRIWWRtQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2885
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vladimir,

Thanks for the feedback. I already submitted v4, so I'll put these into
v5 this week.

On Mon, Jan 31, 2022 at 10:22:55AM +0000, Vladimir Oltean wrote:
> On Mon, Jan 24, 2022 at 11:15:31PM -0800, Colin Foster wrote:
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
> >  drivers/net/ethernet/mscc/ocelot.c | 76 +++++++++++++++++++++++++-----
> >  include/soc/mscc/ocelot.h          |  8 ++++
> >  2 files changed, 71 insertions(+), 13 deletions(-)
> > 
> > diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
> > index 455293aa6343..bf466eaeba3d 100644
> > --- a/drivers/net/ethernet/mscc/ocelot.c
> > +++ b/drivers/net/ethernet/mscc/ocelot.c
> > @@ -1737,32 +1737,40 @@ void ocelot_get_strings(struct ocelot *ocelot, int port, u32 sset, u8 *data)
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

I'll take another look at this.

> 
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
> > @@ -1779,10 +1787,11 @@ static void ocelot_check_stats_work(struct work_struct *work)
> >  
> >  void ocelot_get_ethtool_stats(struct ocelot *ocelot, int port, u64 *data)
> >  {
> > -	int i;
> > +	int i, err;
> >  
> >  	/* check and update now */
> > -	ocelot_update_stats(ocelot);
> > +	err = ocelot_update_stats(ocelot);
> > +	WARN_ONCE(err, "Error %d updating ethtool stats\n", err);
> >  
> >  	/* Copy all counters */
> >  	for (i = 0; i < ocelot->num_stats; i++)
> > @@ -1799,6 +1808,43 @@ int ocelot_get_sset_count(struct ocelot *ocelot, int port, int sset)
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
> > +		region->buf = devm_kzalloc(ocelot->dev,
> > +					   region->count * sizeof(*region->buf),
> > +					   GFP_KERNEL);
> > +
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
> > @@ -2799,6 +2845,10 @@ int ocelot_init(struct ocelot *ocelot)
> >  				 ANA_CPUQ_8021_CFG_CPUQ_BPDU_VAL(6),
> >  				 ANA_CPUQ_8021_CFG, i);
> >  
> > +	ret = ocelot_prepare_stats_regions(ocelot);
> > +	if (ret)
> > +		return ret;
> > +
> 
> Destroy ocelot->stats_queue and ocelot->owq.

Wow, good catch!

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
