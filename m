Return-Path: <netdev+bounces-8589-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 66E3B724A91
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 19:51:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BB7061C20B10
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 17:51:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 55C3422E27;
	Tue,  6 Jun 2023 17:51:11 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CB4B1ED55
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 17:51:10 +0000 (UTC)
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0765AE47;
	Tue,  6 Jun 2023 10:51:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686073867; x=1717609867;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=gYDUqI1NviLlnfJQpyFmn3AVEv+3U67g2GIOOWEByhc=;
  b=CBVDoOzm/oPI+EVSFOlLkrvZdd2n/rnVUHhsinptYYiRppRVfQ4gRMbu
   60Tkrclmx4ovjBFJq26pNqcPzoRtW0D6egIiexB8R708kcuVXqyROR1zG
   jomrcgIS402goPvfB7/LWGhbpdXyxp3b/S0dFQZXVAw67EpFzSyx/BoXz
   TY7mJfUMw9/W13gNqe7jEehzCZ17bECUlfbpjj7mgJUMw8YUzhhzxeKkS
   3YtoYjxqdpkhy4eXtM8TzWtnL7NFDCdDQReqS96PWyGTCKioo+HGLOnWo
   36qh7tKCKPcNNwDIc15MBZR3yuH89rJBJS6SKDGpzedlxPFhy3fobv4mJ
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10733"; a="354250989"
X-IronPort-AV: E=Sophos;i="6.00,221,1681196400"; 
   d="scan'208";a="354250989"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jun 2023 10:51:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10733"; a="774210181"
X-IronPort-AV: E=Sophos;i="6.00,221,1681196400"; 
   d="scan'208";a="774210181"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga008.fm.intel.com with ESMTP; 06 Jun 2023 10:51:06 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 6 Jun 2023 10:51:05 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 6 Jun 2023 10:51:05 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.174)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 6 Jun 2023 10:51:05 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TGv/4XvY/jz/ed1wwvgLr50i6jCrNM8B/eUMcoz/q5i5Oasai5h2aLBJClAdfFMGldlCjGGydBhr8rGYmm/G5RYbEhLPdZtl3vt29mPIKCKVr/LVrEYk22MUpaiUvXih+F5YE2hA6DGsRYmYsZXCfkO+MxR2dy01ejRvHYfKz35MhCVz+gIhR3YFwgR0cTL5KizMt+ErcjaOoTpOFbjFB2OWYYGPxdIpRsoAwlXjsQRikJsqWxT+nH5a9UFpKEglCZReuxuU/oqrscDzU23glchTsAWN+XVPCaqxCAjXI7VfYpm6BURUKVkcF0z3mlqZxfGYWHreP7zdetiIpLx6TA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RBlkwGIMCT5Vt+44+W7MXXbLqa58ApNHMohjqVGlv+8=;
 b=dKQ32hMAR6Tyb9SXEX3Xufa354Z/PpJbKsOgD3tDGp6LB68bEFFqAsC9McptMUnDdfl2DcG0z6jRLQTqGMN5wIhH/QadOpdvnBWmomJdod4CAYbVyB7TSUekcLRc8W46JL3Rh3KFp8JVY+eKVIS1Eiyh+vANmuIol0InyuKsIWJXF9GAbxhdMj2GhlzjIk12Gj/dgPX90vKXx4im3cNd0ehneEOvoQHkv2ahzLkU1epGv04sg51wlrql6hqBqEaNUCJKqPAwMcLL+FeAIpUpleCnheBx/XqM25Rdh+aFyV43/CcEg+cw6bBxXL0jg2zITunFGbIgg6FjDMsc/P6vug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6117.namprd11.prod.outlook.com (2603:10b6:8:b3::19) by
 PH7PR11MB6555.namprd11.prod.outlook.com (2603:10b6:510:1a9::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Tue, 6 Jun
 2023 17:51:04 +0000
Received: from DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::9e4f:80cc:e0aa:6809]) by DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::9e4f:80cc:e0aa:6809%2]) with mapi id 15.20.6477.016; Tue, 6 Jun 2023
 17:51:03 +0000
Date: Tue, 6 Jun 2023 19:50:50 +0200
From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
CC: <s.shtylyov@omp.ru>, <davem@davemloft.net>, <edumazet@google.com>,
	<kuba@kernel.org>, <pabeni@redhat.com>, <netdev@vger.kernel.org>,
	<linux-renesas-soc@vger.kernel.org>
Subject: Re: [PATCH net-next v2 1/2] net: renesas: rswitch: Use
 napi_gro_receive() in RX
Message-ID: <ZH9x+qhVtqd+q3VM@boxer>
References: <20230606085558.1708766-1-yoshihiro.shimoda.uh@renesas.com>
 <20230606085558.1708766-2-yoshihiro.shimoda.uh@renesas.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230606085558.1708766-2-yoshihiro.shimoda.uh@renesas.com>
X-ClientProxiedBy: FR3P281CA0114.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a3::6) To DM4PR11MB6117.namprd11.prod.outlook.com
 (2603:10b6:8:b3::19)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6117:EE_|PH7PR11MB6555:EE_
X-MS-Office365-Filtering-Correlation-Id: 2c70113e-fb06-4330-cbf4-08db66b698c8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PR7nswgCKsYDEycMUsU/WMpsNTFQCptNgvilXG4tb4ZJ2tLT1qgFiDiLWt6PlDkbV4MpOpMi7QXyePnhl0r5pd3w+78Llly0NQOVs2PADH+6+Ob6kZpySzm7gtXjYaT0Qn6Omi8xejM7iW1cfCd29ojHCaACVF+c6e2LfMpiFtGhNf07uYkf5a3o7Lx19Lkj0ywzGzb0XWmdtrDApDNi1B/+jPZSVcuTwDs2tumU9UvVdu9HAjzsoGusse9T1Zb3pZLHcoA61LKt79PtOdzZV42sQ//oQIoO1GuO+m1/YEY6ZcXPrlOcw8N7fWcGn8ZhpnkkDz+mNbdMfDk47I7qMvrhugO1MUyBIb1FHyTfwwhR80Llw+1zMP8OlS3hvyWhtXCpKNZtl3Grcx7VuIktBYoZiUUbhKrQ7JnApllKJ0s94NU30kwIfJCfxEvkgL3zxyNq9/yxlRry6WGwiE84wI8dotGmeN+gcLg6pH+7y8f7IOvOEq2YxbIXdsVYJkxI3voJcPbMf/1Coc1CzuvR/Gx0Msu0LSSem2Lw5hN63L9rZP0XBvVyStCTnGqb5z1OTU+Ey0WAbNZVWvVMTzb4Lfk1K+OOTPSL+LdWmSojo9KKjTTWmOLm0GUqDCP7cQFb
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6117.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(136003)(366004)(346002)(39860400002)(376002)(396003)(451199021)(8676002)(8936002)(478600001)(6666004)(5660300002)(41300700001)(316002)(6486002)(26005)(44832011)(186003)(4326008)(66946007)(66556008)(66476007)(6916009)(6512007)(9686003)(6506007)(83380400001)(2906002)(38100700002)(82960400001)(86362001)(33716001)(83323001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?S0h04v8OqVM3Z+llIYg41088vFh//CoAnnh4sxnUfmLpeeKG1N+cSHkS1A3L?=
 =?us-ascii?Q?F4t5Twg/VY2Jz8MfLPY+Ra7HY+df/PzFVDwSD0crb4t47009ONDc6ltbEl0C?=
 =?us-ascii?Q?1phi7gODAb3l4RqhuCCncihB1YviRRunTMRMVsqgZhDAY/p+K1o6CvyMADf1?=
 =?us-ascii?Q?a3cw9fPY0rirIeySBoR3mZw21gltLsBd8A9ISDAeF3hMK+mn3zWi7Mm4S+kW?=
 =?us-ascii?Q?8ruA3+f+82qhobd8FTvbpDiPj6X1qaDPm/LfFKUHqI/tos3RYP1Veh1nwef9?=
 =?us-ascii?Q?CeBJYfmacsKn8Ds3M2Qlm8fVmE4Bk1B5XBt4BMTbE5hSAVLLVqu5R/hS98qT?=
 =?us-ascii?Q?R4EswYdGOyj2cFG/fwrQXCdggVllDvZM6HpfR5Jn7g13TQcuC5tdIg3AOQYV?=
 =?us-ascii?Q?NcugCRl9mNIaEOPvylw5AuuPmtG/9iXNiYgind7QNoJfGLxSk1KFYnfenq4C?=
 =?us-ascii?Q?buPxyuvdvLab56qVjYOpee8rGssx2ElB/AMVhQ3+fb3D76ivC2LLsIrikJV4?=
 =?us-ascii?Q?SaR6kmnmunVSItQRhcCyryluiyOuBuxsj+n4/Ti42ScvX0E+xo87bRv5lIAu?=
 =?us-ascii?Q?BFl4PrxPFUIjqu6tgWvqhBJR9BvmPHzLQ4Tce8lFT1QZQHXujKd5Jh6FrDs6?=
 =?us-ascii?Q?P/5r0xqxucVXJoU+inJVSf0S4kSmCff9bWSOUJQGy85brjSXLOlP5l5wmZMq?=
 =?us-ascii?Q?4/yuzO11cFsrxtzMZsGn2WGao+DuO4wi2/NDBLgfvAAIQ+LjekT/T/ENa9Zp?=
 =?us-ascii?Q?9JTvCnhHwzYzn8ReKurxGfnq7SYY2Gf4e1ruH3NUjUfh/bySGjaOpNLhTXax?=
 =?us-ascii?Q?/ef3ZT/YQo3kRNWcTZBpiKFCWS9nsU8Q5m0DdH5flBwjV09gukexG7BO9qjC?=
 =?us-ascii?Q?Nxc0lx7SPnES9v5nFYR/IKaasL6x15KxvJvTqcQX37ueWHidl8TwDcSEQzyw?=
 =?us-ascii?Q?diPzysY6oeLdlnDfpUSSp1MOwiDOf2Ap+Px0V2izcPxj+irF3vxPwjjdBAUK?=
 =?us-ascii?Q?WqFSEwWgsALievyA0Vj6cP9RRjy/iJiDtocZ1omCq+/A+38SKWqxfknuFM0P?=
 =?us-ascii?Q?rG+bxno6nkMDX5BSU2lAszB7CrDyzro5Gp0LknRn0UjW5HGtyYDjyPMV02so?=
 =?us-ascii?Q?U+m3dF+WKtCDlpGY2rXfYJscJzb/BWGQuB5LYnkvupPoRn9kBZd0sL8reJaz?=
 =?us-ascii?Q?QtorkI9crd+X4niExv+frSKuvzWIDsqSBW54qe43Dds9F0f0BEsZnYtnBwcZ?=
 =?us-ascii?Q?k7+7qjcvYGxMHBFUaXBE1dOk967ZOM/C89QaGtAUYvgXkAqSrgC2Z8aLrGfC?=
 =?us-ascii?Q?Oq+cjAYl1leqZFdx3E2/Z3ARopPVtRciHBuJONSAQvr4i0YWvk66g91EaFQA?=
 =?us-ascii?Q?AiMvmlRv3kR2d6qPBcssuoRajaBVcwj3RBxdMXYi967X1Puw7t/8vnVTvxzZ?=
 =?us-ascii?Q?2ontZArDnRoa/gLz9srxjnRyIeO8kZyPMOH5VSziBV7LkWqEZrJpnec6pbVo?=
 =?us-ascii?Q?2RzMba1YncMvS/cKv/SESqBgwEL/EQ9B3PsmZx9wn5o80P1lB1rJ/sumrDG4?=
 =?us-ascii?Q?VXrTFGxcy86OHn5CtFZdGxxCUC109SCeSB2DWJ+789gRuIsPS/r0dcYAalih?=
 =?us-ascii?Q?nKoenKp8AGo2eWNhmBlBzb0=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c70113e-fb06-4330-cbf4-08db66b698c8
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6117.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jun 2023 17:51:03.8757
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: J2w7KCmV+mc7+cDQqooCruScBd8+1VMbw2uxH15s5T6wNAhtTCy+z9XmlRiIy6tgJ1SOSuD4KhU9A92RcGxpG5KOinsIPhfVagXZw/cgTJA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6555
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, Jun 06, 2023 at 05:55:57PM +0900, Yoshihiro Shimoda wrote:
> This hardware can receive multiple frames so that using
> napi_gro_receive() instead of netif_receive_skb() gets good
> performance of RX.
> 
> Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>

Reviewed-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

> ---
>  drivers/net/ethernet/renesas/rswitch.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/renesas/rswitch.c b/drivers/net/ethernet/renesas/rswitch.c
> index aace87139cea..7bb0a6d594a0 100644
> --- a/drivers/net/ethernet/renesas/rswitch.c
> +++ b/drivers/net/ethernet/renesas/rswitch.c
> @@ -729,7 +729,7 @@ static bool rswitch_rx(struct net_device *ndev, int *quota)
>  		}
>  		skb_put(skb, pkt_len);
>  		skb->protocol = eth_type_trans(skb, ndev);
> -		netif_receive_skb(skb);
> +		napi_gro_receive(&rdev->napi, skb);

Some other optmization which you could do later on is to improve
rswitch_next_queue_index() as it is used on a per packet basis.

>  		rdev->ndev->stats.rx_packets++;
>  		rdev->ndev->stats.rx_bytes += pkt_len;
>  
> -- 
> 2.25.1
> 
> 

