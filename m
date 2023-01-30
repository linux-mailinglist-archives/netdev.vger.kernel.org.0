Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 442DE681421
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 16:09:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235401AbjA3PJ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 10:09:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237906AbjA3PJ1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 10:09:27 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 882CC27D51;
        Mon, 30 Jan 2023 07:09:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675091363; x=1706627363;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=65IMUhjRnjvZtYxWisioQV67qc0K0fq77S3C1YXXg28=;
  b=n1/EncXCMxR+m9IGHYN5CiCafH4v3atPNcN7dExiij6hm4SZ+pli/ZTG
   rXo5ModbbNsyt8opp7tcPiNh5RgesRm3TokD1lFc5S3JtV7pK71uG0UFe
   /WRp9Dwa9+S+ub5QS66vXwYOTucLJSc/KaY6JBFF+IcZoz7Ne62S/KX8a
   BQsfnl66m75Sj0fFvfcsOlda4VCj6nSzfo3RdFrv0B5r8CvdNjuNrBUQa
   NVsEGSpRS/PokKC+v7bHyReMSO761uPYyN9N8swFjXRA08rHQ+UltQiDQ
   EUlcMzntxa4p2p+JjKCv/vGZ2jMudMtIx19UaVYPjAd33E1XJU3Ot2zVa
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10606"; a="354895082"
X-IronPort-AV: E=Sophos;i="5.97,258,1669104000"; 
   d="scan'208";a="354895082"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jan 2023 07:08:04 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10606"; a="614055931"
X-IronPort-AV: E=Sophos;i="5.97,258,1669104000"; 
   d="scan'208";a="614055931"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga003.jf.intel.com with ESMTP; 30 Jan 2023 07:08:03 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 30 Jan 2023 07:08:02 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 30 Jan 2023 07:08:02 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 30 Jan 2023 07:08:02 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.177)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 30 Jan 2023 07:08:00 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dFJJ/8i9cb7XM8fZ0Jv+ax24qUbf6A68UA1gL6mpGMesirZBl0rSTTysXHwrbm4kOpWOX/YCdKTolaeE85mzIUY+utkU9gF+c2Ja5hmQnQ79+hlOUPqG9y40s8uE5Pg/AVZ07gGJ/LphhQ3scM0CW3eW631R3EqF8L8wzPdkNkcmJ1mPexd+kc+URdgRakfteD9k5v9cLDL4MEXhuxwoDfKagSgRlycwlx8Vbad384vKeL+poEpo7tVI8gRrVHNsykJ3Tbv1QWYR7XQ67d4TZxir3xcnA1JmIO4Qn+OBuS8q12/IUQuSMNR9MicFHOEVKnsvuH4xluE9Hjl6MUb1Tg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RKfEfGPBRIBoCzfnfR4L/9mCqliLcvQeKhtS1uUf1mE=;
 b=iLz+jhSjIF7Wm9acXqMIop/U7/kVCMiSxWmi1y1bSVne6ggEYMP4xDWTIxJosgYbl/jAvHp7AcL39Jg0FUg1S1VnPtc55A/QsgNFgTiGCfoFEy+Rf0PHaI3ouC4AejgLoAf9GuWKxkTBKtIRZPqW8CgmVo8NloAU9EUBaf5QtH3Myrk1cd7vkuqJDt43MZpavb6b71vg0dJ6eyh8cdyPiQk5GYL28KgwYzvSjytL1fniL8xnAsD4ff6NAtDnIW0KAnMP1VOXjUUNR1hvLvPAYGIwhSXjxTerUXL8R3jJLoKIXQjVVtPqn0kU8QOiNeER4AgP9pzNLIXAEiNReqkmJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6117.namprd11.prod.outlook.com (2603:10b6:8:b3::19) by
 MW4PR11MB5821.namprd11.prod.outlook.com (2603:10b6:303:184::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6043.28; Mon, 30 Jan 2023 15:07:58 +0000
Received: from DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::39d8:836d:fe2c:146]) by DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::39d8:836d:fe2c:146%6]) with mapi id 15.20.5986.019; Mon, 30 Jan 2023
 15:07:58 +0000
Date:   Mon, 30 Jan 2023 16:07:50 +0100
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Jason Xing <kerneljasonxing@gmail.com>
CC:     <jesse.brandeburg@intel.com>, <anthony.l.nguyen@intel.com>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <richardcochran@gmail.com>, <ast@kernel.org>,
        <daniel@iogearbox.net>, <hawk@kernel.org>,
        <john.fastabend@gmail.com>, <alexandr.lobakin@intel.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <intel-wired-lan@lists.osuosl.org>, <bpf@vger.kernel.org>,
        Jason Xing <kernelxing@tencent.com>
Subject: Re: [Intel-wired-lan] [PATCH v2 net] ixgbe: allow to increase MTU to
 some extent with XDP enabled
Message-ID: <Y9fdRqHp7sVFYbr6@boxer>
References: <20230127122018.2839-1-kerneljasonxing@gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230127122018.2839-1-kerneljasonxing@gmail.com>
X-ClientProxiedBy: LO2P265CA0040.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:61::28) To DM4PR11MB6117.namprd11.prod.outlook.com
 (2603:10b6:8:b3::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6117:EE_|MW4PR11MB5821:EE_
X-MS-Office365-Filtering-Correlation-Id: 5bd75438-7f1e-429d-b606-08db02d3c5d7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WqdtovQZYMQtXftYpx6Mkt4ubW2BvaUwaih5DV3UBhWP2rgKHGCBqSgvtDQXk2oFVWiGIy1LKFG/L0+QebCt6XLXv1FMZDY1hVWrHXEFNsjkBDatB8NzfAQMpSyuSSA7kxZhWlD0ow2RGWWn3SUlRlJKFyFiTkxOZxONDjGhhFybedxZBrTOtFvyYpdJ/LQwnF1yvm/w1vJAPXlzZVolKWYTuwTLxOfHT0ooukjxVmBj+dsfi8zctOZkJ+Nz/Z5RKvgP8vHRcZ4UfuJ4Pxyd539x+bOHUMze37GvQgTScUw6qv27JghXm66Xv/geyWL+xSyMf3g/utKUwdYWgZN5WmUace51K5yMSHPTL4+dDolmpvNlx33kopkqUSWdc57b52KGm2QH4TTVdndCGf419WprU9MQD5cpsq1OZiE9ifD555g0gOK6SJ7JsSztOVNykVxyGNb7jlo8zV1Z8/eIfDw3KIaLMy5XS4K9wkpYbuNBtqNG8pD96u7q72LsIbgux1ndvVsLIQ0EDwxWTDP7Q3OK5yIt2Qud4DDzfLftI8JDkKYbCzjPAZ7O66DExlm9Z+lNnWFa2/EM2LPrYKxvmx2sviWPnW0iXzZ5/SslpgUb7yhF4IGz47vQAukpfw/wZT6o4cnuszKKR4Vv4lsOF++wAunxwrNlV8mSXylkIfYy2Fj/onn0SUil34QLjkYbyGN/090IqItqBJoXGjkmkA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6117.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(366004)(346002)(136003)(39860400002)(376002)(396003)(451199018)(6486002)(966005)(9686003)(478600001)(26005)(186003)(6512007)(6506007)(82960400001)(38100700002)(6666004)(83380400001)(7416002)(44832011)(8936002)(5660300002)(2906002)(316002)(66476007)(86362001)(66946007)(6916009)(66556008)(4326008)(8676002)(41300700001)(33716001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Tph1CS7yuICvQ0/mpTe5+GguSyT+ofuq/g5pf7O2KxwYzTUvbRZ3XTto1hqs?=
 =?us-ascii?Q?sAuNBEF84J+Bq6aSnciITFl11s1/Tlo/c8E1hxyksGHx9AR0lSiW4JvEy02K?=
 =?us-ascii?Q?6w514wlHK9WSe3qfh+veVswRRd5SPccVd7uJlcOEbYDFmA6F/7igrNdR1l8C?=
 =?us-ascii?Q?aU0lBcSLoC23W0WBheHUmdt24qZnCJzAiHno2GrMHQhIQjjkM5r+jloPbO7I?=
 =?us-ascii?Q?0vtYRiYsaRpyBZK96GTh0Xf36bh/hQgGVx63974/thP+/cwpHl8mUrr+yUsd?=
 =?us-ascii?Q?c4XlF7eu+AX7v8NFRWl4QDWHV1NyBua75FJxUNlNdNl8HXPjxDg2DqZ84chd?=
 =?us-ascii?Q?x+YYOR5dtnT+AQMo7ea4vPbeKB2sy8pRKnzeFxGAzT962HtKflHKZV1Xn25z?=
 =?us-ascii?Q?rWS8OphYwrh5RcCHwj0hkrc4HWLx2WQJc/bunxCsjANNKRkNUnfFC8SDP0kY?=
 =?us-ascii?Q?YKDSdNTCYsEdUerJqgTbB8PbZD4qCdd4ZChefcgEY9chxd0DY4IXLY8f60Bi?=
 =?us-ascii?Q?fWlogHVY1N1ygPJzVnfejXtb/9RhYkNHw20HTVWeY+kqKJM0unofimZoFFGW?=
 =?us-ascii?Q?ndqEmDyH2Al5GfLOyq3JgoGGSriDFcMfEtDYeTHu8BLjH9yCv1DBOguo306p?=
 =?us-ascii?Q?AGepEAl8zuH1cDG4JI88N0bbZhIcpi9afkq2jC22wp5AfeIkDwnMuM0Gvsmm?=
 =?us-ascii?Q?QAR/bjYCb6dwcMFcYS+b4Pl+KSOMOQXoWUeJcSKaqk57pQFQs1vVeSDzo8h5?=
 =?us-ascii?Q?p9aDC54oYX16/wVh8ZJAWyUitPhNXder4QUMov/N3LpVONvL9/FB5nY0PzTQ?=
 =?us-ascii?Q?8hZZFzTleyUbY06i296nLGMwq1sxWq7FQy78ooYBoWmtzqVR37Fv+G3Ze4yg?=
 =?us-ascii?Q?e3yw965qQMYSAfENIAbbcOpy4Q3G03PrW7FF+kH+rsteIDNPnpKZtJobT2Nt?=
 =?us-ascii?Q?R8TeKBHIXey42iz26l5iySj7wNHEFXCYpFk72L3vkVlBctW1Jd57Isik9RB7?=
 =?us-ascii?Q?FN+SL8C6c76EsK/ixJaCD9WDB5bi7STEYCmdJF1g3wWyvz3e9rkVOA40z+1G?=
 =?us-ascii?Q?3KxQz0zH4WtYj2bUKIMISzuRVWk4144oCaNmV8ylTqHZP6Zdy7sDr41g8k4b?=
 =?us-ascii?Q?+FbnAz3IwcM8ARUcXqtHaao9h+wSsc/t+iW/qb967A8o0/oVu3nKLyYJc5hL?=
 =?us-ascii?Q?XCHFnQjQu8WtEcMVt9yXgp6c2TdrPkNF0oBxM7YOklV0zLgDFiuJ4YCHqysJ?=
 =?us-ascii?Q?wF6Qu3PNEGZJiglHaSobDRn+QRkOrp/e6slkgtg8lU6oqCqgNiB3sH6wqx5X?=
 =?us-ascii?Q?L/GCmYM9JAaPuOgIdNidoZnTuTU/CzPyQjC/QUnX0t5S6J47eXH4HKdT5nTK?=
 =?us-ascii?Q?KnKsf+orJyL+PLme5PFiZfpzSwzBMjKUtMT/iYUY8uoGfiTkPDXTqxw9W6I7?=
 =?us-ascii?Q?wMz/g6B4gNfTK0ka/y22miPrtQUWew1Y/gZfUGjVwecpWelkSgMn4KuTs8lZ?=
 =?us-ascii?Q?yuJCCIMTwd86FeleGfSaf4NcmR0lYcu/oZq2skUIGQHi3KCvfwMB67t51CWc?=
 =?us-ascii?Q?/W4XXldgyCg8CbrLMeq2XcYkQ5yBqQ6TmPnKViEXaoJEgyP76oIUjZp3DkOU?=
 =?us-ascii?Q?9+UNqo4bsyV7gYzxDuDjNEM=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5bd75438-7f1e-429d-b606-08db02d3c5d7
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6117.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2023 15:07:58.5535
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: W4lpoKg3cIq0FtpI1cIapUCevVobZvl8Px9o30QT1p6Dda64fxnANrpOeLjQ2bpAS6ut7E0UUMBNzfX7f0h3DCzFqtLnGjvOtJ+Lig9PiK8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB5821
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 27, 2023 at 08:20:18PM +0800, Jason Xing wrote:
> From: Jason Xing <kernelxing@tencent.com>
> 
> I encountered one case where I cannot increase the MTU size directly
> from 1500 to 2000 with XDP enabled if the server is equipped with
> IXGBE card, which happened on thousands of servers in production
> environment.

You said in this thread that you've done several tests - what were they?
Now that you're following logic from other drivers, have you tested 3k MTU
against XDP? Because your commit msg still refer to 2k as your target. If
3k is fine then i would reflect that in the subject of the patch.

> 
> This patch follows the behavior of changing MTU as i40e/ice does.
> 
> Referrences:
> commit 23b44513c3e6f ("ice: allow 3k MTU for XDP")
> commit 0c8493d90b6bb ("i40e: add XDP support for pass and drop actions")
> 
> Link: https://lore.kernel.org/lkml/20230121085521.9566-1-kerneljasonxing@gmail.com/

Why do you share a link to v1 here?

You're also missing Fixes: tag, as you're targetting the net tree.

> Signed-off-by: Jason Xing <kernelxing@tencent.com>
> ---
> v2:
> 1) change the commit message.
> 2) modify the logic when changing MTU size suggested by Maciej and Alexander.
> ---
>  drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 25 ++++++++++++-------
>  1 file changed, 16 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
> index ab8370c413f3..2c1b6eb60436 100644
> --- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
> +++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
> @@ -6777,6 +6777,18 @@ static void ixgbe_free_all_rx_resources(struct ixgbe_adapter *adapter)
>  			ixgbe_free_rx_resources(adapter->rx_ring[i]);
>  }
>  
> +/**
> + * ixgbe_max_xdp_frame_size - returns the maximum allowed frame size for XDP
> + * @adapter - device handle, pointer to adapter
> + */
> +static int ixgbe_max_xdp_frame_size(struct ixgbe_adapter *adapter)
> +{
> +	if (PAGE_SIZE >= 8192 || adapter->flags2 & IXGBE_FLAG2_RX_LEGACY)
> +		return IXGBE_RXBUFFER_2K;
> +	else
> +		return IXGBE_RXBUFFER_3K;
> +}
> +
>  /**
>   * ixgbe_change_mtu - Change the Maximum Transfer Unit
>   * @netdev: network interface device structure
> @@ -6788,18 +6800,13 @@ static int ixgbe_change_mtu(struct net_device *netdev, int new_mtu)
>  {
>  	struct ixgbe_adapter *adapter = netdev_priv(netdev);
>  
> -	if (adapter->xdp_prog) {
> +	if (ixgbe_enabled_xdp_adapter(adapter)) {
>  		int new_frame_size = new_mtu + ETH_HLEN + ETH_FCS_LEN +
>  				     VLAN_HLEN;
> -		int i;
> -
> -		for (i = 0; i < adapter->num_rx_queues; i++) {
> -			struct ixgbe_ring *ring = adapter->rx_ring[i];
>  
> -			if (new_frame_size > ixgbe_rx_bufsz(ring)) {
> -				e_warn(probe, "Requested MTU size is not supported with XDP\n");
> -				return -EINVAL;
> -			}
> +		if (new_frame_size > ixgbe_max_xdp_frame_size(adapter)) {
> +			e_warn(probe, "Requested MTU size is not supported with XDP\n");
> +			return -EINVAL;
>  		}
>  	}
>  
> -- 
> 2.37.3
> 
> _______________________________________________
> Intel-wired-lan mailing list
> Intel-wired-lan@osuosl.org
> https://lists.osuosl.org/mailman/listinfo/intel-wired-lan
