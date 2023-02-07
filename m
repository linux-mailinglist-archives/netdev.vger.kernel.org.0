Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 721E068DDF3
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 17:28:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231250AbjBGQ2z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 11:28:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbjBGQ2y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 11:28:54 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B277A9EF2
        for <netdev@vger.kernel.org>; Tue,  7 Feb 2023 08:28:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675787333; x=1707323333;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=KkjfcYZKt2/u2xvDfYKfaYtpAU0GPPfS1Uj1rKW/i5M=;
  b=lThkL8WK8GL0uJvlaS51QhLQvWSxeGyXxX4Y7RwGQEp7DW/vj//FzdoE
   hgAue5UkFMrimoInPqJ+7wzue72kS/a/V33KVJrwavAHzVd/ewpB+nUA2
   vDFDXAIukKaPHgNdrxxl1S2ana7SreM/fDlpKCFuk27x/4UbmlhBLL23m
   TvwGrb7yOMbrCOl0JpfOFmCvCK2MEQExsBIpoEqCgfnEIWJNW3TXFp2zF
   u8t3lqdZnN+exLGku+QV405/TlgAezD8RA91MaZxW/FsR02Ph4tI3M55s
   g4N15d5UfcBiYA7kanx1FHXBmg5hvWgD5Dy3UsVC+2p0pnvc0SO4dNiSg
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10614"; a="327241025"
X-IronPort-AV: E=Sophos;i="5.97,278,1669104000"; 
   d="scan'208";a="327241025"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Feb 2023 08:28:53 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10614"; a="840826474"
X-IronPort-AV: E=Sophos;i="5.97,278,1669104000"; 
   d="scan'208";a="840826474"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga005.jf.intel.com with ESMTP; 07 Feb 2023 08:28:52 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 7 Feb 2023 08:28:52 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 7 Feb 2023 08:28:51 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 7 Feb 2023 08:28:49 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.107)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 7 Feb 2023 08:28:49 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n/ScOWWvaEdgyeJgpNAW+WHbaulHIwtrmDSzRP202XVyJbDY9n1uc5lAiQBEmWh5AQZ+oBgYvab0FPETzJEbOC8C3cPnF4cYquSNh52JKLB1+17iVQeqW8YNBx8zIB9dOA7CkzInh4InABK0ebL77hAQ40VWLnFWHRuFGPwRCnYwbu8pvvieJ77y8dOyObdQnLExodHJ4y+6zMHQb8q3KCOdTTMguBgLWHFYSKex6DVzxv83yl2COA3RKwoMc/dtcE/9lHz0X1Cd89hgL+L7KtK+UzCaHRH6OtdZmRx7TGTDRNTy0qZx4z782DdXBOcW+slw4Anjx88NqZC32FMmmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7FbOl4sO3M3Gt66acxq6MY2Dv8aNblOa1xs00QbeiXE=;
 b=DsKX8i1ZO/9ZxfSMAhJveRi68HJwNYUeTACiGfef5q2jnbMl25iGX/nrHihn8pHApPDCC5HnMGyzf2Qnqrds7/BF4SXbfQhSrkI/qQZzD4Aj2dQrFdHnHYWXwCijNYAMpb88kM5SAWu+oFQzn5plv08UM7CMH73WHwK/WwzayS+o94mO24OXHjqXipNQRYS/m1IxP8HoJXnSCFYmEtqbZJ8fLzyASpUQhhGnyGx651tgONk43PpauZ9KZo6y0Nsl2Ai5IGZFBih2DwE0AcAyEmK5Ml+vGk16lJ9fvah77T26nsSHC2LC6whISHX981oC+HaSVOV4RsXUzsXOUYavKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3882.namprd11.prod.outlook.com (2603:10b6:5:4::24) by
 MN0PR11MB6009.namprd11.prod.outlook.com (2603:10b6:208:370::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.34; Tue, 7 Feb
 2023 16:28:44 +0000
Received: from DM6PR11MB3882.namprd11.prod.outlook.com
 ([fe80::23af:b75f:a459:3895]) by DM6PR11MB3882.namprd11.prod.outlook.com
 ([fe80::23af:b75f:a459:3895%5]) with mapi id 15.20.6064.036; Tue, 7 Feb 2023
 16:28:44 +0000
Date:   Tue, 7 Feb 2023 17:26:34 +0100
From:   Pawel Chmielewski <pawel.chmielewski@intel.com>
To:     Paul Menzel <pmenzel@molgen.mpg.de>
CC:     <netdev@vger.kernel.org>, <intel-wired-lan@osuosl.org>
Subject: Re: [Intel-wired-lan] [PATCH 1/1] ice: add support BIG TCP on IPv6
Message-ID: <Y+J7uhD5hamFiiSL@baltimore>
References: <20230206155912.2032457-1-pawel.chmielewski@intel.com>
 <6eed8aad-1520-5789-264e-b952b6ff4502@molgen.mpg.de>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <6eed8aad-1520-5789-264e-b952b6ff4502@molgen.mpg.de>
X-ClientProxiedBy: FR0P281CA0055.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:49::15) To DM6PR11MB3882.namprd11.prod.outlook.com
 (2603:10b6:5:4::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3882:EE_|MN0PR11MB6009:EE_
X-MS-Office365-Filtering-Correlation-Id: a9340460-07c7-47da-9d91-08db0928618e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: i2/qI/j9IE74NbiTN69a6QZUnuw8P08oKHO3uDMiD08/L3i7eff8/F2uD18J8FlFygaIG5WyONAa4Xp17UfJdnzQDq3wnB7oOx6JXS7qqO3F4YN0zSNgdv4b9pGu8t1kCU94rAj4zc7N2R0PN9PZMhE3jxykelcIyN5JV8G1w1rT263+2ekhHP9JeSW3NvkJmOQE1pdPe38G5D3DqG08g0YJVI1mIrmSUchDC9k1secKs2p8bE72EVqokqUYAqiw5gZiG8tsVRrAtAElBdxzP9Mk4zpQjtm12HXOHI7rumCQykuikHY59XUVBm2rPZYfRP2cYjnxsnj4RLbKj40Rkabp5T42z78OeorKBvF5RcnegLpwgqSLOZdhEQJbfb2kEcmUNToftQJaqLHCX5usvgKODCmuMlpo5/lFhbz5Stq8EbwrPcRM+RL9SONztFhvRNHi3Q0uYtAqf5jGx3sSZySlvTAHi9MceDcgcXNeKzeVj4Pgmo0CLv2qgGPAvuBzML9eoRWqU3IpIxW47JlGd6jEG91ImPkQ38e7Z0RP5FqWzV0q3/Z+NSLkDENymr2GnDSVQxIEyxsrMYsoxb0EGOBw4OhlVbCsL5s8AFk8IsQCHy5/RJBojBfdI8UpFCDwXAShHlJnxLWJ68Q6Zc6lIAVytvPyULbqSviTNh5VSoMRmO3U93CDzz1E0zEfGkIu
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3882.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(39860400002)(136003)(366004)(396003)(346002)(376002)(451199018)(86362001)(38100700002)(33716001)(82960400001)(6486002)(2906002)(316002)(478600001)(66946007)(41300700001)(5660300002)(9686003)(6506007)(66556008)(6916009)(83380400001)(8676002)(8936002)(4326008)(6512007)(6666004)(44832011)(26005)(186003)(66476007)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?sCyRRfK+2Ql1BQRdZBKSGfvNIbhRvSFvh4kvW9obr30olibRv3kMxdbCh1C1?=
 =?us-ascii?Q?GDxIHT/PwN3ckekDm38Zyob8PMuwLK3DPDMn7hws2Qs5476a6OsAd/lTPSdT?=
 =?us-ascii?Q?PyEsLaBIx7Bzi476y3U0pwMGFJ27NSFsH5CpIZOPEaP85Xq32mv13kG+DmL0?=
 =?us-ascii?Q?QV/IHBQCyF29hybmnpA0zSIhoTSavboflLoxbu9sT+Sg7+IrVSUSV8EMSouB?=
 =?us-ascii?Q?R3Ka29gkbSUBs0l/Ok50jG7MfeXC6PrSWBOwJGwRK7MSVuUZv1ePxlKfh0wX?=
 =?us-ascii?Q?6VtS2MkCrrF0LxhY4TrHSH+2Xl0PUSxHc24jIHcaAocapXzN7C02YDYI/Fjh?=
 =?us-ascii?Q?FzsgfbPSrWPhA6VYHZc+GAbHjXNCt9KoaXddQzOyOVIEWaUHgxZvfPhYXP8X?=
 =?us-ascii?Q?1wFB9MJc3iGHCQ+FgrrKuQwrTncf8k8A0JAM4d4dyJ8yRwyqq+8RA7D4ssMI?=
 =?us-ascii?Q?/1RJBJ3+mzWmyieGs2Zwp3SRM4DCIlZmeQ3SS9K9+yIC3P37QhQ7Q+ymN74l?=
 =?us-ascii?Q?Bpc5RS5qeIAv4eLuOInbvNX+p+W+2Yib6Trsu9B8ExpHsVMjbHRahJ1KDNal?=
 =?us-ascii?Q?gotmKa7q7lQexI0kg3ygEVEAuBT4fJH1eEOUA+2HQ7uRDy439ki7smcjCZej?=
 =?us-ascii?Q?iJC3zywOt1rI30J77DTovGNFH2eUpB0LKGA9vEFZnUxAdT/izVDscd5rXkyg?=
 =?us-ascii?Q?TzuXicjeaJXxzyJTYhGhD75C3UaxgJiAOPnXNxlHoa32LhKrLUblvOzliLvq?=
 =?us-ascii?Q?NVaunXaCkdSfwTeCn6BPFPj7/jwO1ZjsU42MUZvF1YlqbM+cZ9u2Xqo/KVU2?=
 =?us-ascii?Q?uzEi5MhpOwgPaQpVtjueCaSPSutQnPHyL/+BXhbKY8tuLHGS+0fwrHiPomb2?=
 =?us-ascii?Q?kpm/X4+YHx0gHiFKgwrVOF00LnFILohWMsPJ1t43TPZ2mo+7uv/IN4asv/1A?=
 =?us-ascii?Q?nzbLg9t+jvMh0vPkQOq6NKmI47cMeA/oNPgCDEQSRw19NZBm3hiXSl+IKP1N?=
 =?us-ascii?Q?7GVMAfMXH7jXdfiqgB0WacdrxZwHeduqU18N5DUJVhM9r36u9KEq3LobtJw3?=
 =?us-ascii?Q?IxxeX5maVbZk5R+4Vuax3LC2N2vBa85A4mlPKI+7HwY+0pho4eV8y2t7L9a3?=
 =?us-ascii?Q?9mRTrjawO85KZpO1wsq9TQLBBh9KCQqSJk8M+aB48reeNA9WO7k3VYP3uPYd?=
 =?us-ascii?Q?yNfp/0Azv1UNdz2UP104fRkcneCAgiJdbXLs5MBV91kyyy8zO4xObr/cs4AA?=
 =?us-ascii?Q?NlhG3rSlL0OBDAJ7cbNL1zN2tW1jixNcQMFTrnpMw3WFGoHom92dOaNIYAIn?=
 =?us-ascii?Q?hvnleVMycdES1D6LJWBU2Uk8grPb6TNFOXYBaaLPvpdoSqPOp++rAQ2LclEc?=
 =?us-ascii?Q?RL8cXJOFUiNUquydNODCEkL7ODui0hg7Q/597FIoF/YN2f01lH3qrmb4NGEZ?=
 =?us-ascii?Q?FYNLliALjKP9olnrvZk39BTe/ztuYiddVmHJsHzQ3aPXPOeYkhlVUkwaiW+7?=
 =?us-ascii?Q?v+U1repcwQ+RCX1SnnHpofN2z8tRsM0I5bKv45FGH/1HkuzFprsPP1oYypGj?=
 =?us-ascii?Q?k0Uz7+1l2RKEd4wwtYwlXFLi+LREKRwA8kuagZLmiokYesT3X7ffvDBQNc0c?=
 =?us-ascii?Q?Eg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a9340460-07c7-47da-9d91-08db0928618e
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3882.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Feb 2023 16:28:44.5791
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZK6DrcO49Ajo48ESgecHTJDEzJWwdoD6EVjkZb+f3nqZ1OcFhouNH/1pbS3cG2hSHxV4fnk/VIazw9JoukdEOrmUGGXw9EOkTpK/eozBCio=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR11MB6009
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 06, 2023 at 05:53:00PM +0100, Paul Menzel wrote:
> Dear Pawel,
> 
> 
> Thank you for your patch.
> 
> Am 06.02.23 um 16:59 schrieb Pawel Chmielewski:
> > This change enables sending BIG TCP packets on IPv6 in the ice driver using
> > generic ipv6_hopopt_jumbo_remove helper for stripping HBH header.
> > 
> > Tested:
> > netperf -t TCP_RR -H 2001:db8:0:f101::1  -- -r80000,80000 -O MIN_LATENCY,P90_LATENCY,P99_LATENCY,THROUGHPUT
> > 
> > Results varied from one setup to another, but in every case we got lower
> > latencies and increased transactions rate.
> 
> Please give some concrete examples nevertheless.
Of course. I'll send v2 with the results. Thank you.

> 
> 
> Kind regards,
> 
> Paul
> 
> 
> > Signed-off-by: Pawel Chmielewski <pawel.chmielewski@intel.com>
> > ---
> >   drivers/net/ethernet/intel/ice/ice.h      | 2 ++
> >   drivers/net/ethernet/intel/ice/ice_main.c | 2 ++
> >   drivers/net/ethernet/intel/ice/ice_txrx.c | 3 +++
> >   3 files changed, 7 insertions(+)
> > 
> > diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
> > index 3d26ff4122e0..c774fdd482cd 100644
> > --- a/drivers/net/ethernet/intel/ice/ice.h
> > +++ b/drivers/net/ethernet/intel/ice/ice.h
> > @@ -122,6 +122,8 @@
> >   #define ICE_MAX_MTU	(ICE_AQ_SET_MAC_FRAME_SIZE_MAX - ICE_ETH_PKT_HDR_PAD)
> > +#define ICE_MAX_TSO_SIZE 131072
> > +
> >   #define ICE_UP_TABLE_TRANSLATE(val, i) \
> >   		(((val) << ICE_AQ_VSI_UP_TABLE_UP##i##_S) & \
> >   		  ICE_AQ_VSI_UP_TABLE_UP##i##_M)
> > diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
> > index 22b8ad058286..8c74a48ad0d3 100644
> > --- a/drivers/net/ethernet/intel/ice/ice_main.c
> > +++ b/drivers/net/ethernet/intel/ice/ice_main.c
> > @@ -3421,6 +3421,8 @@ static void ice_set_netdev_features(struct net_device *netdev)
> >   	 * be changed at runtime
> >   	 */
> >   	netdev->hw_features |= NETIF_F_RXFCS;
> > +
> > +	netif_set_tso_max_size(netdev, ICE_MAX_TSO_SIZE);
> >   }
> >   /**
> > diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.c b/drivers/net/ethernet/intel/ice/ice_txrx.c
> > index ccf09c957a1c..bef927afb766 100644
> > --- a/drivers/net/ethernet/intel/ice/ice_txrx.c
> > +++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
> > @@ -2297,6 +2297,9 @@ ice_xmit_frame_ring(struct sk_buff *skb, struct ice_tx_ring *tx_ring)
> >   	ice_trace(xmit_frame_ring, tx_ring, skb);
> > +	if (unlikely(ipv6_hopopt_jumbo_remove(skb)))
> > +		goto out_drop;
> > +
> >   	count = ice_xmit_desc_count(skb);
> >   	if (ice_chk_linearize(skb, count)) {
> >   		if (__skb_linearize(skb))
