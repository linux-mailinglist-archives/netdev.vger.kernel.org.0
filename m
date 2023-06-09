Return-Path: <netdev+bounces-9590-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8477F729EE9
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 17:43:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4330C281968
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 15:43:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B64D19BA7;
	Fri,  9 Jun 2023 15:43:50 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 779A217757
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 15:43:50 +0000 (UTC)
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77A5735BC
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 08:43:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686325424; x=1717861424;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=ED257QZ4AvJzRmeDda38kZB4gMj4bxg1ERASAzCQFIw=;
  b=K0AEgQozMvJnqyJ1XUxWxTMOVz+SbQpaHXee90XzirSLluufDN1NnRjk
   7fMSV45yS52p+g6+4YfIbMun5Z5hjOTQJnjxOoQFiUdENN3LZ4EbPZedE
   yoX7jZ/btGnNCmZ3Ol/9l6Xw3Jw5O1qylAIkthvqf3KtcqW5pWxYfQd8w
   MG6TLW0RFqW9EhNTuqhUINW6VFs5VWuGLB7G7dlw75cx5/OKe51J/8Wn9
   pdLX4BnQvYU7ely+FRTHz1TeRv5rRoWnjI8Z8/7p2fjYKVk2KVxCnaToD
   3hN5yg0YIq6zD/vhOYmsW8YCzPL4VdbbPSguVc/9fI0inY0GWf+ACupmB
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10736"; a="360982598"
X-IronPort-AV: E=Sophos;i="6.00,229,1681196400"; 
   d="scan'208";a="360982598"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2023 08:43:43 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10736"; a="884636216"
X-IronPort-AV: E=Sophos;i="6.00,229,1681196400"; 
   d="scan'208";a="884636216"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga005.jf.intel.com with ESMTP; 09 Jun 2023 08:43:43 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 9 Jun 2023 08:43:43 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Fri, 9 Jun 2023 08:43:43 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.102)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Fri, 9 Jun 2023 08:43:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DeOlvprAYHhLCtHQMdfLKfv36NgCqo7OKGEIZVuXjXYXt+5Hhdy5ZhXAkveJgnYN8D7dZcggySJ6uRmMVBI7ox6Bu6HGJiwhKHmOs5iMqTUeHhsEG+jG7M7G3JR/4ZsYkTgqdH+UEuhpYpkfK8/U4TeX2Ph/1aObLKe2lP+uWJ7vqLKxAQw9yX2Z5N3U5ZBKbhGJF1BZ7qilaeKFo2BoEYtR7mzltEsCLBmiO6YBkyNxK2LkPLJXKuxzRogknRnMLmKc3FrF5UQSJxocDn7K7TfRgiRQCbtij3TrI4vFS+Xc29nuK5qC4TTNRdV5/Z+BEMzPTw9p9CJHTs1OxT36Bw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TTozhz0fUALXxZWtu0laeWf2mh/SDI7/zN1KatGGuYo=;
 b=YYRHVd/HrdKYgAt+O/aWkRdYoPm0FFvqplbe3F80ht+hpHVuNrimAJFN4Ty9CqdrYT0IYGr47TGg6dAPh39lwLOkaShTZCY68rSsfLB1BqGvOHBvoC8tZz5tZ/TppkYTg0nWaXxLwQL0dXtGJFFfqMqzLGZ3l5fICZXXViiKOGAWXxxY3CA+oXJ5jC2/s2w5n0YN6bptZb1IjAW/3bFCXYwgmsjMoDTdNF4KlNt5XNLo06K63zVdQWnRRTjQGGmLniDbDDNwQ20AfkvZ8S4VumzYdlKckF91Et3c5BoaDSraPWXNujldTqXm+HN1056vpwImc+RA4+B8dcrP9pPIpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SN7PR11MB7540.namprd11.prod.outlook.com (2603:10b6:806:340::7)
 by CY8PR11MB7847.namprd11.prod.outlook.com (2603:10b6:930:7c::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Fri, 9 Jun
 2023 15:43:38 +0000
Received: from SN7PR11MB7540.namprd11.prod.outlook.com
 ([fe80::9376:9c9d:424a:a0fe]) by SN7PR11MB7540.namprd11.prod.outlook.com
 ([fe80::9376:9c9d:424a:a0fe%5]) with mapi id 15.20.6455.030; Fri, 9 Jun 2023
 15:43:37 +0000
Date: Fri, 9 Jun 2023 17:40:29 +0200
From: Larysa Zaremba <larysa.zaremba@intel.com>
To: Hangbin Liu <liuhangbin@gmail.com>
CC: <netdev@vger.kernel.org>, David Ahern <dsahern@kernel.org>, "Daniel
 Borkmann" <daniel@iogearbox.net>, Mahesh Bandewar <maheshb@google.com>,
	"Paolo Abeni" <pabeni@redhat.com>
Subject: Re: [PATCHv2 net] ipvlan: fix bound dev checking for IPv6 l3s mode
Message-ID: <ZINH7W59xIRypmGh@lincoln>
References: <20230609091502.3048339-1-liuhangbin@gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230609091502.3048339-1-liuhangbin@gmail.com>
X-ClientProxiedBy: FR0P281CA0226.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:b2::19) To SN7PR11MB7540.namprd11.prod.outlook.com
 (2603:10b6:806:340::7)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN7PR11MB7540:EE_|CY8PR11MB7847:EE_
X-MS-Office365-Filtering-Correlation-Id: 9386deac-df6b-4027-150c-08db69004a8b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WxM2E6lLY/Ikj+f2LT6kR09zmmcsnjpFjmxs1FsjUsElVKIGFSGZIi2BiFjIuHAAZdpw8BDQDnVRLuAP/gzcgl5gQWhZOQ8VHo+qGUPOoss4mONGde54yS+JRWWhrAFdqGAu9kgkVNeHuvwvtSLqVfQRoAxUIiIG2Mp7+iJ/racB9mQrvk2DvsVR/wiDiqAx4w3KuNViFEgPYy7qWDKZG+4WYTgyuUNVUHvrXDvYEfohkJljpxfcVrvyKszLMbvbIO+HKT/b/4FpEy7qgDAV5DXWbgP5jTF+4T6uZlEFSB+iIcGpR/xXlw27PVi+FL5GyUX5dggmFBhvtWAFgl9KYBPvhZXzaNEUj5WCh/CNTVuvV6X5PDJC2skVXVXbmSdnkDSBUa39EKmYdFa8gOh6U+E+VIgVM+wFj3MuqDNbWKpM3XrjQsaeIbsmnUAhvYagjfqme0es5qUu8xzZKrmS5MVMkUZxOOKpCXEMiPWBkVGhuREybeERDZZli5ivly3yKfmI6N0ba5jFRZI832AtEVJlEfp/R2rk1I7WLU0vqyPfxR6Kfcw99wOoKnW9fd2fKTNvFF0XbibXH0RFrP92i3HgEfcu77U0ssBnZgrqC0I=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN7PR11MB7540.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(346002)(396003)(136003)(39860400002)(366004)(376002)(451199021)(41300700001)(8676002)(4326008)(66476007)(6916009)(66556008)(8936002)(66946007)(5660300002)(316002)(44832011)(54906003)(2906002)(6512007)(38100700002)(82960400001)(26005)(9686003)(86362001)(33716001)(186003)(6506007)(478600001)(6486002)(966005)(6666004)(42413004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?JRTleYD8KDwOcFtQs2J/pWIeGA2IOg+r8B6Y1i3EIlKHoWL4QMb1ynl8dWsK?=
 =?us-ascii?Q?KV2SA1jvct2YFG3Vd2R4+ALRNttg0JmDXDKdoBTfm+CWpCjSB5LMWdAtVlI5?=
 =?us-ascii?Q?m4T+FnMLuVJhEf5fm5JUbSm9vXbtXXjD2Td/F0B1/Zv8MnDj7pLKx2+zPPa9?=
 =?us-ascii?Q?rEuuAaVxRbyH0CsO+v6XcFF93KVDTYeFNiL4UNW2kvMVRrRkZJOuSvsgGYFP?=
 =?us-ascii?Q?9PTQZvHndekBkrrPsRpekFsc918xeSKR+usig6lDrBsRBKubUJX2FBoAA3uG?=
 =?us-ascii?Q?PGKZiV8fnVYBgPUB8G0ZItUAUZZ9BJGXXFwTmIVFbzMnNBLr3IhHFVAM3Ayv?=
 =?us-ascii?Q?/684q3g6IsB/uDRT4oM1XdOmrhKHw8qhCEcymDVxl8JALVR4cMpDdwB2Ad7j?=
 =?us-ascii?Q?G3jbu9WRswhxwz/mVhOs7fom6y3MDdUGWh5Gd3+8mrrDCHsa4aqsHHa+Va8Y?=
 =?us-ascii?Q?3oSOJveTnYAQFPXz6lFpvkpWgmki0G2gV6zWMQ80VIMUxmAVBYKZTmke3Xqq?=
 =?us-ascii?Q?5Yqwf1hKo9qC8DFVdu/wqVM2r3snfqBVrFQc5qZOp+iTw613mdIzt2Ohh/0J?=
 =?us-ascii?Q?n49XMn0vMfLqGsbTfbyzN2d9wYUKaU2Yy+E4+AwLvsgzYB51gIYSP+f0TaTG?=
 =?us-ascii?Q?gq1PLVZsXOxL+L2sLJvM+Xot05BUSQhZnVrZT8C1OtjbhOnL/LBYjWTihiWb?=
 =?us-ascii?Q?in6zIjnOOjzZa0bib4vljLpqmIZoe0OkVIvFL2FGCF/w7ScVrhT63i7okVRx?=
 =?us-ascii?Q?FfeZMyXV+Z9mGURDNRXsUQ0+qFu285mFjHGYKZy50Y9/75RaAjEZLlDDIT9v?=
 =?us-ascii?Q?M1gDsGubSsj2FP1gs/bhs9ezLpdSqru8x/ihRPhiwI8jHqGnCjGVSWPWWZx6?=
 =?us-ascii?Q?ZFOsOl9cC1wXLZBtvebxtzB1tQo2G3QfRFvR2FhEvNBX6dXpoTL98XWhQ9Yv?=
 =?us-ascii?Q?VetwQ4NayuZAGy2Muf8w0qt2OvztgJ8svJET5rs36SbG36GX5n5n1lzCiRg5?=
 =?us-ascii?Q?z7AXHKZybDmVvIzwMW1VLXedSKAjrEojtL/p1H07UaxYD43onU7M9D+9TKq2?=
 =?us-ascii?Q?CLohxBrKiUfErGWOlBaCti598oOnqO1b2bhlAJuYWLAkaBbbm5eyvYE+YXX/?=
 =?us-ascii?Q?w5wuGfc5uucw2c7e/XeXaQWRmzZwOEHYl5iwFGg5NREKrCV4p5lamwZwNRe6?=
 =?us-ascii?Q?7AghDeymeUy6b0PGPuYbPv1yitH3vvQ2pDbfzyy0aLVVQRer1rDl2TmMa6f5?=
 =?us-ascii?Q?z62Ai5kHZP1imq8HjXpP8Y057TDOEuz4Nk/rhLVTCaUPrCZ8Vv6Bq3wSxUU3?=
 =?us-ascii?Q?TdH04NoeIiWNvK3gP//4cJwjt2tlB8SegCGz7R1REITPoADAzpSYHUDLGXXx?=
 =?us-ascii?Q?RIlX3JVL8FremZBk7v0KeP6dicxh4VduXkwuC9MW8sO7ZnHh8f6/0wm99krW?=
 =?us-ascii?Q?M8y/4nXs4+r7BoTqvjOVaNbWtzhR8hORi1vWZHET2SDmfZASeFp7H1ReoPIC?=
 =?us-ascii?Q?QDdKRKwEckPNs2KfaRq5Lcx6MrouAztr/zsiHrSoMYyTu+x3I2lxGmuX+KrG?=
 =?us-ascii?Q?WYecZLQnRxc+94YyCtn0j3CEQOlwS8IRIe0Hk9UalrSSUi9wA7w7gbM9txh2?=
 =?us-ascii?Q?Aw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 9386deac-df6b-4027-150c-08db69004a8b
X-MS-Exchange-CrossTenant-AuthSource: SN7PR11MB7540.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2023 15:43:37.5723
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8SutAcT96F2UCSih8FuLDGmuebPitOn/gQmuppw5vArfIWlTme2FZylGdFF1KYuaP9HAH4mYmm/KtgAgJzIzLTSf8GOpB85n1zu/Px2YQy4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7847
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, Jun 09, 2023 at 05:15:02PM +0800, Hangbin Liu wrote:
> The commit 59a0b022aa24 ("ipvlan: Make skb->skb_iif track skb->dev for l3s
> mode") fixed ipvlan bonded dev checking by updating skb skb_iif. This fix
> works for IPv4, as in raw_v4_input() the dif is from inet_iif(skb), which
> is skb->skb_iif when there is no route.
> 
> But for IPv6, the fix is not enough, because in ipv6_raw_deliver() ->
> raw_v6_match(), the dif is inet6_iif(skb), which is returns IP6CB(skb)->iif
> instead of skb->skb_iif if it's not a l3_slave. To fix the IPv6 part
> issue. Let's set IP6CB(skb)->iif to correct ifindex.
> 
> BTW, ipvlan handles NS/NA specifically. Since it works fine, I will not
> reset IP6CB(skb)->iif when addr->atype is IPVL_ICMPV6.
> 
> Fixes: c675e06a98a4 ("ipvlan: decouple l3s mode dependencies from other modes")
> Link: https://bugzilla.redhat.com/show_bug.cgi?id=2196710
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>

Despite broken prefix, unlike v1, this fix looks good.

Reviewed-by: Larysa Zaremba <larysa.zaremba@intel.com>

> ---
> v2: set IP6CB(skb)->iif instead of setting IP6SKB_L3SLAVE flag
> ---
>  drivers/net/ipvlan/ipvlan_l3s.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/net/ipvlan/ipvlan_l3s.c b/drivers/net/ipvlan/ipvlan_l3s.c
> index 71712ea25403..d5b05e803219 100644
> --- a/drivers/net/ipvlan/ipvlan_l3s.c
> +++ b/drivers/net/ipvlan/ipvlan_l3s.c
> @@ -102,6 +102,10 @@ static unsigned int ipvlan_nf_input(void *priv, struct sk_buff *skb,
>  
>  	skb->dev = addr->master->dev;
>  	skb->skb_iif = skb->dev->ifindex;
> +#if IS_ENABLED(CONFIG_IPV6)
> +	if (addr->atype == IPVL_IPV6)
> +		IP6CB(skb)->iif = skb->dev->ifindex;
> +#endif
>  	len = skb->len + ETH_HLEN;
>  	ipvlan_count_rx(addr->master, len, true, false);
>  out:
> -- 
> 2.38.1
> 
> 

