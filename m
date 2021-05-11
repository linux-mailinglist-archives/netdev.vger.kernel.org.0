Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9977E37A339
	for <lists+netdev@lfdr.de>; Tue, 11 May 2021 11:14:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231359AbhEKJO7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 May 2021 05:14:59 -0400
Received: from mail-dm6nam11on2067.outbound.protection.outlook.com ([40.107.223.67]:10289
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231266AbhEKJO6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 11 May 2021 05:14:58 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XaVH92SQDLIU1S2vR3ysx7v0h1lNrxBeowczL3AxfrkTj/K9m+1qS9wqFQeoulg0mByqIpwNkvfZQStpZvK41zrTH1YoElzHdE5WbMLfi8amiHml5qLnOWK/vEgGuo2g7xnQOeALI4Hf6ih5DIfcejgbi1svtqfrABOtstEvRG96IIMe4j+xmucZrQ2O9tJETkT3VF3bvCywgwvamAMKf0ap04pjdKvDWYLY93x3N2FhEWGxCjkCftb8XuNTY7QIyhyWxNg+fXzGEezc6H2OG6Hr0N8M71BpV8Drih63qqRYZGUlj4eiJAkHLF9LIfTBaGKS/QH/uzgn3wVK3ZwYUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E0k2TY0Csq3Ttf2PgdwRjxpN1/zgPzBYnPla7sPL/sY=;
 b=kEpzabCBuP7QJT0WwcoyZDpdW+IJWaR/jjrdTIlyNCtrJyM23qNi08IhygmE75P1oQMtHSz1F4vFWrt/7k0owUT8UbGZz0qjjNHqPQLg62sD+ch71ExG24439sWDYUw5XLSvKnHviBV88HOW62USXEZp4DzzFtyYoyI35mr4Ye3Ey4Sso8hP3w7OT7vRvB4HHTQEKZ+hFq7zxhqIKZa1wv9XQfOOjrsxl8aWE134TgEXABSTlh3MInn8hSdSwdDuhxV57rf6NuzdE0W367OI7fb8TgQXty+P7TSBS2MlLPNCIefo8lRV2WvYixHpopEul0HnLqP349QYNcyZlkX1+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E0k2TY0Csq3Ttf2PgdwRjxpN1/zgPzBYnPla7sPL/sY=;
 b=QWJlRWqnC7RRl9XDgupG8Rs/I2OQLZwjluz5WJ9lAVkliB7axvHsLRhQF6nKBkLj2l+vtMmaBvDvH8cxemcLFH851ygT11/8xVg+VGSOvpZi61Ycop5XSHqwtmBjOYO1cBufytglCJyZ9kKg21bUjnelUMSnG+1oyBhl0enZfd/iXWJNY8jP4KjarVzmFoDcDukimozkxzi0/9gTYD8DqkgQHgPFW5J2teytAHXz9LnZ0CNL0t/El4B+MxVf2x3/VGanQDfjYSDZATVuvFzcpbIhG0EXPBzqiarZlEnJybSQIqm153po3ULl89ThS9glFhOO7ncLPfEKyBPiIHrrfw==
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB5278.namprd12.prod.outlook.com (2603:10b6:5:39e::17)
 by DM4PR12MB5294.namprd12.prod.outlook.com (2603:10b6:5:39e::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25; Tue, 11 May
 2021 09:13:51 +0000
Received: from DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::d556:5155:7243:5f0f]) by DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::d556:5155:7243:5f0f%6]) with mapi id 15.20.4108.031; Tue, 11 May 2021
 09:13:51 +0000
Subject: Re: [net-next v2 04/11] net: bridge: mcast: prepare query reception
 for mcast router split
To:     =?UTF-8?Q?Linus_L=c3=bcssing?= <linus.luessing@c0d3.blue>,
        netdev@vger.kernel.org
Cc:     Roopa Prabhu <roopa@nvidia.com>, Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        bridge@lists.linux-foundation.org, b.a.t.m.a.n@lists.open-mesh.org,
        linux-kernel@vger.kernel.org
References: <20210509194509.10849-1-linus.luessing@c0d3.blue>
 <20210509194509.10849-5-linus.luessing@c0d3.blue>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
Message-ID: <02190208-f5b9-d761-abf5-1d85d0c62cd6@nvidia.com>
Date:   Tue, 11 May 2021 12:13:45 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
In-Reply-To: <20210509194509.10849-5-linus.luessing@c0d3.blue>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [213.179.129.39]
X-ClientProxiedBy: ZR0P278CA0021.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:1c::8) To DM4PR12MB5278.namprd12.prod.outlook.com
 (2603:10b6:5:39e::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.21.241.170] (213.179.129.39) by ZR0P278CA0021.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:1c::8) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25 via Frontend Transport; Tue, 11 May 2021 09:13:49 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 623bb74e-ed9a-42d5-59c9-08d9145d17b1
X-MS-TrafficTypeDiagnostic: DM4PR12MB5294:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM4PR12MB52947DA94DCA23D4B9B70D70DF539@DM4PR12MB5294.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1728;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wUp+QnQ1tkRQU3yeb3OGKKkRzaqiUFa9ZgGFUSQmri8WpmPFfLBC9GD3Xl3coH+X+c4QTAIO0WfH6nPNxt0WjEX3QkhkYNcYqQIKdrrBRx+qouxBU+rGEkVCE4QdQT3ty1bbTpfv/6zUob5CzfaLbnpQ8++4fWrqkuZuhUx17d6ZZDy3zONIidgQFnNhrMIU9XcDPZVdGG9Wpkxpez0LRgoa6v6jneR1yQpAmdCRZEyLxVMUB6HXkPWLVT4OQOd69bpWXGWRYLHfgk1S15SSOBKRD8tK1G2c8mB/UdqrTg4AcswkmA8MCMoHt+DleXrKsrgYN1l8br/plUyRel9xguKBkNEM0FQzpYhYtRkAEYuTw/HG1r8zbMUzdo6R5wt8BRMft8wx2akeRkcBqwanuQAZ309xuDzPkvCTcNleQXvlN7EKpqfMulIshm5QouwTzAqUhdg+gGPmkSZFo3Q0TlAfJT3qrVvBqb+aOkALr4ZC7kyHCxr8eH2rOL1Baj1beC9OCxyk+i9y/bigA1lRnNLi7Nr6sttbf+VosbAksZjL7ktZpTVKvYQZB1Qdmf6RxxqcK0/zwDx+i7gvQ/7TkSwKFQdopAMTKNrivCIRnrcPZwlbN58m2EHO+meYs34cl4SIPGq/HM5aZ0PpmFH5sPEhkKiDt4Zt2mbDydB8vP68PbDb682fkGNhW4z3n0Lm
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5278.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(39860400002)(346002)(136003)(366004)(396003)(2906002)(16526019)(186003)(54906003)(31686004)(66946007)(8676002)(6486002)(66476007)(66556008)(316002)(31696002)(5660300002)(16576012)(83380400001)(4326008)(86362001)(36756003)(38100700002)(66574015)(53546011)(2616005)(956004)(6666004)(478600001)(8936002)(26005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?MC9rdHdQWElQMlhZaitCbGxOakl3czluZjFEN1FnRUJXVmcwS3dNc0FYREpT?=
 =?utf-8?B?UjBMcUVNZFFMT0tJK2hET29EMTNmN0x5dk0ybG95Q09DZ05zUzhvSmdlajBD?=
 =?utf-8?B?OEM5eTZlb2ViL2prcHljdWdZQ2dRZ0EzVlF5aHlGMXB2UTNCTWt1QzRsbVA5?=
 =?utf-8?B?c1Z5TllrdXhybGdMSTdoN2IycDc5Ukh5Z2EzZXpaYXd0UGVjQnRTdCtjY3Fh?=
 =?utf-8?B?Q1diQ0pGN29QdTZaM1ZjdGpaR2Z6U3BZUlA3RW4zUXoxL21ycTRIaUNQMmds?=
 =?utf-8?B?TGRUendoa1BDQ3FEeXNUS3paL3U1K21jaVhJSmRqRlRnSjkzak9KcEpMN0hn?=
 =?utf-8?B?eDV2WDBTQUdPY05ET3FGa0krV1RJUUE5b0NNQnY2ZHFBWUNYNHFMU0oxT3FV?=
 =?utf-8?B?bFhjZVhOM2pwZiswZHRTbEhqNVBUK2ZHNjhVOCtMclQwdXJ1SkdaZ0pWWFgx?=
 =?utf-8?B?YWV1bVUvOVJxdkpOMVZnUnVscUoyUW1Kb0pxTGpGcnkxYmlMZjJqeEVzYUND?=
 =?utf-8?B?UWFMUXBZa3pUTVJqdnpucjF2SlpRWG14TE8zSW9JU3RjZlN3M3NCbTR5OXV3?=
 =?utf-8?B?WEJiZU9CRnhER01BUDRYWXZlQS9EaFRZS1BTWjVuYllqUm1waHQ0QkZyWnc3?=
 =?utf-8?B?U2ZHd3hNT2VxS0xKMTVIei9KRURHRGVlT2hwMmxKdmVwYVdmT2tnQUlTeDNv?=
 =?utf-8?B?ZnpyZ1N4MW9iWXl2SnluQzE0Rzhma2lEY1doRXRtUmVZVEVOakF0cGFqTnM2?=
 =?utf-8?B?SDloWGs1QWE2K3dqOVdlRWNJWFNhZEhRN29td0lRRzBJdjNRKzlhU2R5VFBl?=
 =?utf-8?B?T0JtWFFsS2xXbTl4SVRkaGw3dVNsQUpVdDAvUE1aVjIxZ3RaZ2lLNlAxYU1t?=
 =?utf-8?B?bmRiWkRubzFPZ0JWSElqckE3V0dlSWZCdUh0NDVBVlZab2xuWGQyOGI3ZUhQ?=
 =?utf-8?B?WEpvNlNrL25mS05hQnM1alJYTzhSUlY3empoQTRqNGNxbEkvd1dMRmsxWm1T?=
 =?utf-8?B?N0s0NHNySkFUNkR6aGlIbGowdU1YdkpXczdCemIyMUY4TGgxZVRmM3ZRNzgv?=
 =?utf-8?B?c1kwRlNtL3l6c3VHMVRQa1MzNmk0d0JIblcxSENNdVl5NXUzWi80UGZra0d6?=
 =?utf-8?B?UHc2MnR5ZHI3ZmprWjROdHNhdndwTkNTMjhPanJTVXBJUVhYdm1rYjRRYkpG?=
 =?utf-8?B?TzJoOFZOQzZsSFE1c2F3MUx3YVZpR2FDTDM5bTgvTWhyM1Z5a1dwQnJ2eVRP?=
 =?utf-8?B?YVpLVGtzMm1GUGtUbFIrRE53eFJTQVlPTW1DYXNUeHY1NzhTNGU5NFRvYXo3?=
 =?utf-8?B?VkljVjdHMTZ5c3Y1eGVjOUFlN1JYZjlqODBKY0ZOYzE4NmwzbEtHUW1remU1?=
 =?utf-8?B?VzRLTnl5Y2J2RkJzb1UrUEVWZG5WYlpoUGhMTDdRWmd3aHdObHMwaGN1NlZT?=
 =?utf-8?B?SGJNZmdKVlRmaHY0SURTaGxpZTUycVBiaytEOFlXQ2xKOWFRWEQxcnh0eENt?=
 =?utf-8?B?SjllMy9mc3FzZm8zcFRvYlJZTHJaY2xRT1IzSy9KWUVHaE9rQ3FmclBGQ01x?=
 =?utf-8?B?a0xneWROc0wzLy8vM0xSSU5NajRwamRDWXlDeDZrN3hveUN3dEE4RjVLakdv?=
 =?utf-8?B?a3M0cmlCVk1YM2xtdTZBK3dtTXgvYm9QN3Vya1pzai9XbXVJU052ODhQekc2?=
 =?utf-8?B?OVkxZGRvdGpodWJBM3F2U3FocG5GbjFvTTc0Z0FaSGJPTVdLak1OV2w3dWdE?=
 =?utf-8?Q?5rOwLiLPGykyLyjvQkLiFxmuYUI5qsYqkaPEZdC?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 623bb74e-ed9a-42d5-59c9-08d9145d17b1
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5278.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2021 09:13:51.3590
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rfaJoQpiEiud+UbsQbcT9FOZOzhLKCWqrcOyWNBCBj4ZVARv9UC9Gp4jVqPX0K4yJFtCju0Fl42QKA+DbcFeSQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5294
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 09/05/2021 22:45, Linus Lüssing wrote:
> In preparation for the upcoming split of multicast router state into
> their IPv4 and IPv6 variants and as the br_multicast_mark_router() will
> be split for that remove the select querier wrapper and instead add
> ip4 and ip6 variants for br_multicast_query_received().
> 
> Signed-off-by: Linus Lüssing <linus.luessing@c0d3.blue>
> ---
>  net/bridge/br_multicast.c | 53 ++++++++++++++++++++-------------------
>  1 file changed, 27 insertions(+), 26 deletions(-)
> 

Acked-by: Nikolay Aleksandrov <nikolay@nvidia.com>

> diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
> index 6fe93a3..7edbbc9 100644
> --- a/net/bridge/br_multicast.c
> +++ b/net/bridge/br_multicast.c
> @@ -2615,22 +2615,6 @@ update:
>  }
>  #endif
>  
> -static bool br_multicast_select_querier(struct net_bridge *br,
> -					struct net_bridge_port *port,
> -					struct br_ip *saddr)
> -{
> -	switch (saddr->proto) {
> -	case htons(ETH_P_IP):
> -		return br_ip4_multicast_select_querier(br, port, saddr->src.ip4);
> -#if IS_ENABLED(CONFIG_IPV6)
> -	case htons(ETH_P_IPV6):
> -		return br_ip6_multicast_select_querier(br, port, &saddr->src.ip6);
> -#endif
> -	}
> -
> -	return false;
> -}
> -
>  static void
>  br_multicast_update_query_timer(struct net_bridge *br,
>  				struct bridge_mcast_other_query *query,
> @@ -2708,19 +2692,36 @@ static void br_multicast_mark_router(struct net_bridge *br,
>  		  now + br->multicast_querier_interval);
>  }
>  
> -static void br_multicast_query_received(struct net_bridge *br,
> -					struct net_bridge_port *port,
> -					struct bridge_mcast_other_query *query,
> -					struct br_ip *saddr,
> -					unsigned long max_delay)
> +static void
> +br_ip4_multicast_query_received(struct net_bridge *br,
> +				struct net_bridge_port *port,
> +				struct bridge_mcast_other_query *query,
> +				struct br_ip *saddr,
> +				unsigned long max_delay)
>  {
> -	if (!br_multicast_select_querier(br, port, saddr))
> +	if (!br_ip4_multicast_select_querier(br, port, saddr->src.ip4))
>  		return;
>  
>  	br_multicast_update_query_timer(br, query, max_delay);
>  	br_multicast_mark_router(br, port);
>  }
>  
> +#if IS_ENABLED(CONFIG_IPV6)
> +static void
> +br_ip6_multicast_query_received(struct net_bridge *br,
> +				struct net_bridge_port *port,
> +				struct bridge_mcast_other_query *query,
> +				struct br_ip *saddr,
> +				unsigned long max_delay)
> +{
> +	if (!br_ip6_multicast_select_querier(br, port, &saddr->src.ip6))
> +		return;
> +
> +	br_multicast_update_query_timer(br, query, max_delay);
> +	br_multicast_mark_router(br, port);
> +}
> +#endif
> +
>  static void br_ip4_multicast_query(struct net_bridge *br,
>  				   struct net_bridge_port *port,
>  				   struct sk_buff *skb,
> @@ -2768,8 +2769,8 @@ static void br_ip4_multicast_query(struct net_bridge *br,
>  		saddr.proto = htons(ETH_P_IP);
>  		saddr.src.ip4 = iph->saddr;
>  
> -		br_multicast_query_received(br, port, &br->ip4_other_query,
> -					    &saddr, max_delay);
> +		br_ip4_multicast_query_received(br, port, &br->ip4_other_query,
> +						&saddr, max_delay);
>  		goto out;
>  	}
>  
> @@ -2856,8 +2857,8 @@ static int br_ip6_multicast_query(struct net_bridge *br,
>  		saddr.proto = htons(ETH_P_IPV6);
>  		saddr.src.ip6 = ipv6_hdr(skb)->saddr;
>  
> -		br_multicast_query_received(br, port, &br->ip6_other_query,
> -					    &saddr, max_delay);
> +		br_ip6_multicast_query_received(br, port, &br->ip6_other_query,
> +						&saddr, max_delay);
>  		goto out;
>  	} else if (!group) {
>  		goto out;
> 

