Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 824E937F743
	for <lists+netdev@lfdr.de>; Thu, 13 May 2021 13:59:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233083AbhEMMAa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 May 2021 08:00:30 -0400
Received: from mail-bn7nam10on2047.outbound.protection.outlook.com ([40.107.92.47]:34337
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229701AbhEMMAY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 May 2021 08:00:24 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m0scKdHFSwJk/3uf6vtVKxtnNcGEDs57mxkbzTmQL9B0d8ttorDz0Ix5cq3BXjbDgIylyKzb+GxHDvbjwwbjCPKy4wfZejBCqh5A6qNuI00EsOY+ZST3PQsd8OM5sKmYvVq3MyNHGc3KOVOgki9TitSpnqRQe0UJk7oHDR7anSaxPifrbcwTrINYMpn0FAyO6R2hJuH1niwoRdHEJB9AA7kFj96mTuM8GY70KjAq3PCVj6C+sNW22AMBASLGMXcH+Xm0eJlf34WoQB33+9XhCPZ1fE+/X/vrZMWBZ1i4dqqP+YGcZNYnTLqbqlICfY8UmebGg4Cr8zzOTxiHzu7PpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DEI5367nvVWe338aGxsIi2NyQRft4Tal14uBz5MpxX4=;
 b=TQXZGqh+LfQz0j6k4I2AWZ85fGdvT7DFBk/uOfuM4q9cfenjuI5D1hGxWzoW5K2H2y424fjs0sxDF31l5vrecmDDGdKhHERJHndxZpPr89VRSYEf+LmCjCbb9/y5B37DK4F/iaUccKFdc2QitI/fW5ba73AeeO5ChR0zcBqK+03G6mQBc00bb47tsJvqrgzawznPEYy7RIBLzMWUIF0Ki+NhTOuxzqlxU3MfFaagTWPivLnIL1/+Fngd079oSEF9quCIy82tvFDiXoNB1QtPAa912Jq7FSxKU0H7pt8Fvh7aIERV9Wi/ey4p+MKYAlZNTC7qOo3wWEB1ZiHRblYkOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DEI5367nvVWe338aGxsIi2NyQRft4Tal14uBz5MpxX4=;
 b=FA2IeGvqTm8WWzz5yOc46ISx+pEazX/0xV8Ours1P1Af4f9iAqIeKvcED5dv9BwdYp6V3h1ffS7MzsHh4Jy7QHUo1Jm2+FfLMZUaegfCEKhlrDg3kLoHfDYX4twbONUh2ilsSBt8L19uFDXm3teBDXha7TOgeSKeKtWLIsddgrwMgmBCwf2MZ9hGKaGTXzxGxf9HJQJC21MzwvQCpqbswC94jhbL6ldLmIVLRqZJiNC03bSiye6LLk2pMrGDp71CK96M5V/jcCMDzFEm22xvY3Jd+uUXSIulikni9LAgMtid+lQlnCQrZvMzduWueICUIYLHM1/fS2rpc59CmYrVBQ==
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB5278.namprd12.prod.outlook.com (2603:10b6:5:39e::17)
 by DM8PR12MB5397.namprd12.prod.outlook.com (2603:10b6:8:38::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4129.26; Thu, 13 May 2021 11:59:13 +0000
Received: from DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::d556:5155:7243:5f0f]) by DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::d556:5155:7243:5f0f%6]) with mapi id 15.20.4129.026; Thu, 13 May 2021
 11:59:13 +0000
Subject: Re: [net-next v3 09/11] net: bridge: mcast: split multicast router
 state for IPv4 and IPv6
To:     =?UTF-8?Q?Linus_L=c3=bcssing?= <linus.luessing@c0d3.blue>,
        netdev@vger.kernel.org
Cc:     Roopa Prabhu <roopa@nvidia.com>, Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        bridge@lists.linux-foundation.org, linux-kernel@vger.kernel.org
References: <20210512231941.19211-1-linus.luessing@c0d3.blue>
 <20210512231941.19211-10-linus.luessing@c0d3.blue>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
Message-ID: <e0e67364-14c2-a391-7de9-be2e5dd76793@nvidia.com>
Date:   Thu, 13 May 2021 14:59:06 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
In-Reply-To: <20210512231941.19211-10-linus.luessing@c0d3.blue>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [213.179.129.39]
X-ClientProxiedBy: ZR0P278CA0005.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:16::15) To DM4PR12MB5278.namprd12.prod.outlook.com
 (2603:10b6:5:39e::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.21.241.170] (213.179.129.39) by ZR0P278CA0005.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:16::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25 via Frontend Transport; Thu, 13 May 2021 11:59:11 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3f79839e-4af4-4341-3d33-08d9160686ae
X-MS-TrafficTypeDiagnostic: DM8PR12MB5397:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM8PR12MB53974C0C5D5002BE4D817D7CDF519@DM8PR12MB5397.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9dCHQE76zfs9oXGPmnd9cR1QBKT/31bFFoTO/ropVcn6A8IiRMHfR2pTP3bSSBUbPsF/q7cJnRDVbloHkhbixn8kQtm6xBEysEwK9cmBxOV1dViBDp+AKuezyKyPjB0DtAguWDuWzDK5g+l87PGpHjYU8n6P6elHK2WbmS/V1pyZrUnaMFYzqArFRtqf9YWSRIgm7WAkvFPIJ7sa0gNuUvq0KQbuHBrRBrYVLkINpi9RAYGVOu2L7Z1OdWK15EzMuDXJngjKIsK91gb7KQ9xLqusr0H5huf01hW0OKnvBKXlt3zosm4fVTbICok/Zbgw3iJH4BvAH/epC1iDUXqfU7+1QFgj5MeNmCTXKkgbMMTjTOvQIhD4w0hJyVpJgm6dBublVHE2NxDJyJ6iERantEeOGAFYYFLARckpLVMP//afZbFUhMvRKsurYR6aLxEYVn7ccXggl1wN5Pxv+V94UWLIG1bowgrVqfOFeSB2mVGGxjM7nYImJq8GPM+7T9HBs8ob/BJLFooa/YjC9z5qOzk0avX6b8lNMQZAPNXZSw1g/ndfICLK+YSo27YglzlZRhzzvbF+o88wzm9MGCWioi1VMJsedELX3MuDOQAH6JNKGAMpPJXD1yO7V1nJwS/STKhsJQdCqgv6j5WBBAAaqZwc+wCAnpO5rgwIG+GDwBHIO28k4BC4Q0+0xZ36mYGP
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5278.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(136003)(396003)(366004)(346002)(39860400002)(30864003)(66556008)(16526019)(26005)(478600001)(5660300002)(186003)(316002)(2616005)(6486002)(66476007)(956004)(38100700002)(4326008)(66574015)(6666004)(16576012)(8936002)(54906003)(2906002)(66946007)(83380400001)(8676002)(36756003)(31686004)(53546011)(31696002)(86362001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?NGM3QktTOXkwNlROUnEvcmJraitBcGFKbTdVVGc4aHFJbTlSV0V5clJCRHZS?=
 =?utf-8?B?T3laWERVSHFnbTNEemMwYndrYWlud2c4K3pqQ21ieVJOd1ZpRTJHc1pDbXJD?=
 =?utf-8?B?bFlBME50WkVjNDVSdm1VcHRwQ1dJb3NZcWltaVRodDRUZ2lTakU0VDM1a2dU?=
 =?utf-8?B?NkR3VDFhQmdiMmJuMFRaMHY1N2Y1VTIvM3RreTNoWGJDcFpPd3dLcURUVnN5?=
 =?utf-8?B?QXJ0VXlsMUdlMEhycCtWMTE5ODR1d25YMThPUjRNRnMrYndmQ0FBL0xrU2dr?=
 =?utf-8?B?TFB6eWtyL3VSdDBod0hTTkdNSzMzMDFLODFsQnZuTVZ2eEpJTlpFZURTT3ln?=
 =?utf-8?B?aGJQR1pQN1pQWjdpc3VaVVViKzdyNG4vTENsS3ZPblV6Rjl4VnNvSC9uNmlu?=
 =?utf-8?B?QVFFQVRtRjRUM3d2MWhxaHRLZTA0SkNMSFU1QTIreVhlSzRJTFdIaTQ0amJT?=
 =?utf-8?B?VUduditZNGlJTFIvNWxZMmpDR2x1c25rbUVhajhBOHRpQWRqTnlhdG9WUGJG?=
 =?utf-8?B?M3FjUFMzMXF1WlRjQzJHVGVyRndoVzJZTUZweUErSXMzRkVOUlNnNUROT3R2?=
 =?utf-8?B?Sk8xaGVyK3ZIczQvalJzeEFJcjhIUXR6dTZHR1pudUNnbytVZWpVOVpNY3JY?=
 =?utf-8?B?Zk8zQm1xU253ak9Xa1VMT1hqTm1TaHg5WGZrbUlGM0NsbHBBd2tDSG9DbjI0?=
 =?utf-8?B?WUtaYVhGODRKTUo5QmtJQStWU1RDT2w5SXpWTFJtckF5QUdMYVpFVUdnaitz?=
 =?utf-8?B?b0NNd3JadGVhM0krajlUckhvV1RCNHQ4YTdSNzZIUEtVUWk5NlRyZE9SV1BM?=
 =?utf-8?B?b0g1Q05CN2Y5L0VJc2xVUVc0ODZwWGp0bGVTdXhTOFYwUWFVb2NqNjl1Tk5L?=
 =?utf-8?B?dW85M3hzV3lKS0ZyeVNsZUoyRWxzRjJHK0xObWpySms5eUlWN3lIcE11TGZk?=
 =?utf-8?B?N0ZOSDRqR1lobEFLM1k4eFJTQStodWVUZEpKU3M2cDVzK1JoZkpJemg0UmVQ?=
 =?utf-8?B?QTF1TkRZUkh4bUFWYkRuRU1RL3kwNE01aG5hYVZ4TDVTUEdvZC9IRVZhQjBt?=
 =?utf-8?B?TDMrY3VVajhuT1JMdlZNMHpPekZweSsyelhhSGtHa3JsTXVsQmpzSTd1ZzI2?=
 =?utf-8?B?NE8vR1pxb3lKaFIyK2hXVFQzNjVaOHRya2NkR0JPY1ErVEprMGxqSDA0NlEv?=
 =?utf-8?B?b2FxVmNPVkxzUkpoNGwybURiRUMwUGtpVzFWck5menFkbnZMT0ZiYk1DSm9x?=
 =?utf-8?B?YUw0RzdyZElHWUdJVkI2ZXVHcHVwemViQ2ZYSThkZGJ1SndhbDNTRWpVRDI1?=
 =?utf-8?B?aXNiRVQ5Q3RCcEtSQXlCMUdjaDQyenFldFltNksrbGlzNGovNXdHSDlkVTU0?=
 =?utf-8?B?RitQMzhweUZPVmxaMnhBM0cxUVlRd2cvdWtNSEp6eHVIVU01MUVNYUQrK3N1?=
 =?utf-8?B?WmhNM1BMa0VTd251RUI1azhRUis3Q01LMWo0NUoveHN2WkV4MnhKQjY0UlhE?=
 =?utf-8?B?VE1LSDhFaHN5QncrTFYraTdVNDhBRFU4SStYN2M1RmYzejdRMzZHdmFtWkZ3?=
 =?utf-8?B?NEo3SDJ5cndmTVFNMTFmM01sZ3p2WFI4b1IzSFhabmlZS1dUclZpdFpVVXNI?=
 =?utf-8?B?N1ZMaVNTVzJSRExkNjRpTVNvamlNbFRISUhWQW4wdENjeVNVQUdrcjRXZHZl?=
 =?utf-8?B?d0ZwZHZyMWxIelFpdmp3UHhPanVXRGFybnJETFIrVHE1ckRIT1ZjWWZGbElU?=
 =?utf-8?Q?ICqv52N9Zur5AU3k8FvqcjLQXLEq+XvaDCCu9V5?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f79839e-4af4-4341-3d33-08d9160686ae
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5278.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 May 2021 11:59:13.6987
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ire/uCXxpKsox6HMf0bu437jX8eARNpWJjzQUuN3pbNdPD6eCoJC7eT/29SuWCRbbQGZMfrPM8Tj3HYYJf0gsA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR12MB5397
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 13/05/2021 02:19, Linus Lüssing wrote:
> A multicast router for IPv4 does not imply that the same host also is a
> multicast router for IPv6 and vice versa.
> 
> To reduce multicast traffic when a host is only a multicast router for
> one of these two protocol families, keep router state for IPv4 and IPv6
> separately. Similar to how querier state is kept separately.
> 
> For backwards compatibility for netlink and switchdev notifications
> these two will still only notify if a port switched from either no
> IPv4/IPv6 multicast router to any IPv4/IPv6 multicast router or the
> other way round. However a full netlink MDB router dump will now also
> include a multicast router timeout for both IPv4 and IPv6.
> 
> Signed-off-by: Linus Lüssing <linus.luessing@c0d3.blue>
> ---
>  net/bridge/br_mdb.c       |  10 ++
>  net/bridge/br_multicast.c | 197 ++++++++++++++++++++++++++++++++++----
>  net/bridge/br_private.h   |  14 ++-
>  3 files changed, 201 insertions(+), 20 deletions(-)
> 

Hmm, this one is a bit more tricky, I hope it was tested well. :)
Acked-by: Nikolay Aleksandrov <nikolay@nvidia.com>

> diff --git a/net/bridge/br_mdb.c b/net/bridge/br_mdb.c
> index 482edb9..10c416c 100644
> --- a/net/bridge/br_mdb.c
> +++ b/net/bridge/br_mdb.c
> @@ -18,7 +18,12 @@
>  
>  static bool br_rports_have_mc_router(struct net_bridge *br)
>  {
> +#if IS_ENABLED(CONFIG_IPV6)
> +	return !hlist_empty(&br->ip4_mc_router_list) ||
> +	       !hlist_empty(&br->ip6_mc_router_list);
> +#else
>  	return !hlist_empty(&br->ip4_mc_router_list);
> +#endif
>  }
>  
>  static bool
> @@ -31,8 +36,13 @@ br_ip4_rports_get_timer(struct net_bridge_port *port, unsigned long *timer)
>  static bool
>  br_ip6_rports_get_timer(struct net_bridge_port *port, unsigned long *timer)
>  {
> +#if IS_ENABLED(CONFIG_IPV6)
> +	*timer = br_timer_value(&port->ip6_mc_router_timer);
> +	return !hlist_unhashed(&port->ip6_rlist);
> +#else
>  	*timer = 0;
>  	return false;
> +#endif
>  }
>  
>  static int br_rports_fill_info(struct sk_buff *skb, struct netlink_callback *cb,
> diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
> index 01a1de4..4448490 100644
> --- a/net/bridge/br_multicast.c
> +++ b/net/bridge/br_multicast.c
> @@ -63,6 +63,8 @@ static void br_multicast_port_group_rexmit(struct timer_list *t);
>  static void
>  br_multicast_rport_del_notify(struct net_bridge_port *p, bool deleted);
>  #if IS_ENABLED(CONFIG_IPV6)
> +static void br_ip6_multicast_add_router(struct net_bridge *br,
> +					struct net_bridge_port *port);
>  static void br_ip6_multicast_leave_group(struct net_bridge *br,
>  					 struct net_bridge_port *port,
>  					 const struct in6_addr *group,
> @@ -1369,6 +1371,15 @@ static bool br_ip4_multicast_rport_del(struct net_bridge_port *p)
>  	return br_multicast_rport_del(&p->ip4_rlist);
>  }
>  
> +static bool br_ip6_multicast_rport_del(struct net_bridge_port *p)
> +{
> +#if IS_ENABLED(CONFIG_IPV6)
> +	return br_multicast_rport_del(&p->ip6_rlist);
> +#else
> +	return false;
> +#endif
> +}
> +
>  static void br_multicast_router_expired(struct net_bridge_port *port,
>  					struct timer_list *t,
>  					struct hlist_node *rlist)
> @@ -1395,6 +1406,15 @@ static void br_ip4_multicast_router_expired(struct timer_list *t)
>  	br_multicast_router_expired(port, t, &port->ip4_rlist);
>  }
>  
> +#if IS_ENABLED(CONFIG_IPV6)
> +static void br_ip6_multicast_router_expired(struct timer_list *t)
> +{
> +	struct net_bridge_port *port = from_timer(port, t, ip6_mc_router_timer);
> +
> +	br_multicast_router_expired(port, t, &port->ip6_rlist);
> +}
> +#endif
> +
>  static void br_mc_router_state_change(struct net_bridge *p,
>  				      bool is_mc_router)
>  {
> @@ -1430,6 +1450,15 @@ static void br_ip4_multicast_local_router_expired(struct timer_list *t)
>  	br_multicast_local_router_expired(br, t);
>  }
>  
> +#if IS_ENABLED(CONFIG_IPV6)
> +static void br_ip6_multicast_local_router_expired(struct timer_list *t)
> +{
> +	struct net_bridge *br = from_timer(br, t, ip6_mc_router_timer);
> +
> +	br_multicast_local_router_expired(br, t);
> +}
> +#endif
> +
>  static void br_multicast_querier_expired(struct net_bridge *br,
>  					 struct bridge_mcast_own_query *query)
>  {
> @@ -1649,6 +1678,8 @@ int br_multicast_add_port(struct net_bridge_port *port)
>  	timer_setup(&port->ip4_own_query.timer,
>  		    br_ip4_multicast_port_query_expired, 0);
>  #if IS_ENABLED(CONFIG_IPV6)
> +	timer_setup(&port->ip6_mc_router_timer,
> +		    br_ip6_multicast_router_expired, 0);
>  	timer_setup(&port->ip6_own_query.timer,
>  		    br_ip6_multicast_port_query_expired, 0);
>  #endif
> @@ -1681,6 +1712,9 @@ void br_multicast_del_port(struct net_bridge_port *port)
>  	spin_unlock_bh(&br->multicast_lock);
>  	br_multicast_gc(&deleted_head);
>  	del_timer_sync(&port->ip4_mc_router_timer);
> +#if IS_ENABLED(CONFIG_IPV6)
> +	del_timer_sync(&port->ip6_mc_router_timer);
> +#endif
>  	free_percpu(port->mcast_stats);
>  }
>  
> @@ -1704,9 +1738,14 @@ static void __br_multicast_enable_port(struct net_bridge_port *port)
>  #if IS_ENABLED(CONFIG_IPV6)
>  	br_multicast_enable(&port->ip6_own_query);
>  #endif
> -	if (port->multicast_router == MDB_RTR_TYPE_PERM &&
> -	    hlist_unhashed(&port->ip4_rlist))
> -		br_ip4_multicast_add_router(br, port);
> +	if (port->multicast_router == MDB_RTR_TYPE_PERM) {
> +		if (hlist_unhashed(&port->ip4_rlist))
> +			br_ip4_multicast_add_router(br, port);
> +#if IS_ENABLED(CONFIG_IPV6)
> +		if (hlist_unhashed(&port->ip6_rlist))
> +			br_ip6_multicast_add_router(br, port);
> +#endif
> +	}
>  }
>  
>  void br_multicast_enable_port(struct net_bridge_port *port)
> @@ -1733,7 +1772,9 @@ void br_multicast_disable_port(struct net_bridge_port *port)
>  	del |= br_ip4_multicast_rport_del(port);
>  	del_timer(&port->ip4_mc_router_timer);
>  	del_timer(&port->ip4_own_query.timer);
> +	del |= br_ip6_multicast_rport_del(port);
>  #if IS_ENABLED(CONFIG_IPV6)
> +	del_timer(&port->ip6_mc_router_timer);
>  	del_timer(&port->ip6_own_query.timer);
>  #endif
>  	br_multicast_rport_del_notify(port, del);
> @@ -2671,11 +2712,19 @@ static void br_port_mc_router_state_change(struct net_bridge_port *p,
>  	switchdev_port_attr_set(p->dev, &attr, NULL);
>  }
>  
> -/*
> - * Add port to router_list
> - *  list is maintained ordered by pointer value
> - *  and locked by br->multicast_lock and RCU
> - */
> +static bool br_multicast_no_router_otherpf(struct net_bridge_port *port,
> +					   struct hlist_node *rnode)
> +{
> +#if IS_ENABLED(CONFIG_IPV6)
> +	if (rnode != &port->ip6_rlist)
> +		return hlist_unhashed(&port->ip6_rlist);
> +	else
> +		return hlist_unhashed(&port->ip4_rlist);
> +#else
> +	return true;
> +#endif
> +}
> +
>  static void br_multicast_add_router(struct net_bridge *br,
>  				    struct net_bridge_port *port,
>  				    struct hlist_node *slot,
> @@ -2690,8 +2739,14 @@ static void br_multicast_add_router(struct net_bridge *br,
>  	else
>  		hlist_add_head_rcu(rlist, mc_router_list);
>  
> -	br_rtr_notify(br->dev, port, RTM_NEWMDB);
> -	br_port_mc_router_state_change(port, true);
> +	/* For backwards compatibility for now, only notify if we
> +	 * switched from no IPv4/IPv6 multicast router to a new
> +	 * IPv4 or IPv6 multicast router.
> +	 */
> +	if (br_multicast_no_router_otherpf(port, rlist)) {
> +		br_rtr_notify(br->dev, port, RTM_NEWMDB);
> +		br_port_mc_router_state_change(port, true);
> +	}
>  }
>  
>  static struct hlist_node *
> @@ -2722,14 +2777,54 @@ static void br_ip4_multicast_add_router(struct net_bridge *br,
>  				&br->ip4_mc_router_list);
>  }
>  
> -static void br_multicast_mark_router(struct net_bridge *br,
> -				     struct net_bridge_port *port)
> +#if IS_ENABLED(CONFIG_IPV6)
> +static struct hlist_node *
> +br_ip6_multicast_get_rport_slot(struct net_bridge *br, struct net_bridge_port *port)
> +{
> +	struct hlist_node *slot = NULL;
> +	struct net_bridge_port *p;
> +
> +	hlist_for_each_entry(p, &br->ip6_mc_router_list, ip6_rlist) {
> +		if ((unsigned long)port >= (unsigned long)p)
> +			break;
> +		slot = &p->ip6_rlist;
> +	}
> +
> +	return slot;
> +}
> +
> +/* Add port to router_list
> + *  list is maintained ordered by pointer value
> + *  and locked by br->multicast_lock and RCU
> + */
> +static void br_ip6_multicast_add_router(struct net_bridge *br,
> +					struct net_bridge_port *port)
> +{
> +	struct hlist_node *slot = br_ip6_multicast_get_rport_slot(br, port);
> +
> +	br_multicast_add_router(br, port, slot, &port->ip6_rlist,
> +				&br->ip6_mc_router_list);
> +}
> +#else
> +static inline void br_ip6_multicast_add_router(struct net_bridge *br,
> +					       struct net_bridge_port *port)
> +{
> +}
> +#endif
> +
> +static void br_ip4_multicast_mark_router(struct net_bridge *br,
> +					 struct net_bridge_port *port)
>  {
>  	unsigned long now = jiffies;
>  
>  	if (!port) {
>  		if (br->multicast_router == MDB_RTR_TYPE_TEMP_QUERY) {
> +#if IS_ENABLED(CONFIG_IPV6)
> +			if (!timer_pending(&br->ip4_mc_router_timer) &&
> +			    !timer_pending(&br->ip6_mc_router_timer))
> +#else
>  			if (!timer_pending(&br->ip4_mc_router_timer))
> +#endif
>  				br_mc_router_state_change(br, true);
>  			mod_timer(&br->ip4_mc_router_timer,
>  				  now + br->multicast_querier_interval);
> @@ -2747,6 +2842,39 @@ static void br_multicast_mark_router(struct net_bridge *br,
>  		  now + br->multicast_querier_interval);
>  }
>  
> +#if IS_ENABLED(CONFIG_IPV6)
> +static void br_ip6_multicast_mark_router(struct net_bridge *br,
> +					 struct net_bridge_port *port)
> +{
> +	unsigned long now = jiffies;
> +
> +	if (!port) {
> +		if (br->multicast_router == MDB_RTR_TYPE_TEMP_QUERY) {
> +			if (!timer_pending(&br->ip4_mc_router_timer) &&
> +			    !timer_pending(&br->ip6_mc_router_timer))
> +				br_mc_router_state_change(br, true);
> +			mod_timer(&br->ip6_mc_router_timer,
> +				  now + br->multicast_querier_interval);
> +		}
> +		return;
> +	}
> +
> +	if (port->multicast_router == MDB_RTR_TYPE_DISABLED ||
> +	    port->multicast_router == MDB_RTR_TYPE_PERM)
> +		return;
> +
> +	br_ip6_multicast_add_router(br, port);
> +
> +	mod_timer(&port->ip6_mc_router_timer,
> +		  now + br->multicast_querier_interval);
> +}
> +#else
> +static inline void br_ip6_multicast_mark_router(struct net_bridge *br,
> +						struct net_bridge_port *port)
> +{
> +}
> +#endif
> +
>  static void
>  br_ip4_multicast_query_received(struct net_bridge *br,
>  				struct net_bridge_port *port,
> @@ -2758,7 +2886,7 @@ br_ip4_multicast_query_received(struct net_bridge *br,
>  		return;
>  
>  	br_multicast_update_query_timer(br, query, max_delay);
> -	br_multicast_mark_router(br, port);
> +	br_ip4_multicast_mark_router(br, port);
>  }
>  
>  #if IS_ENABLED(CONFIG_IPV6)
> @@ -2773,7 +2901,7 @@ br_ip6_multicast_query_received(struct net_bridge *br,
>  		return;
>  
>  	br_multicast_update_query_timer(br, query, max_delay);
> -	br_multicast_mark_router(br, port);
> +	br_ip6_multicast_mark_router(br, port);
>  }
>  #endif
>  
> @@ -3143,7 +3271,7 @@ static void br_multicast_pim(struct net_bridge *br,
>  	    pim_hdr_type(pimhdr) != PIM_TYPE_HELLO)
>  		return;
>  
> -	br_multicast_mark_router(br, port);
> +	br_ip4_multicast_mark_router(br, port);
>  }
>  
>  static int br_ip4_multicast_mrd_rcv(struct net_bridge *br,
> @@ -3154,7 +3282,7 @@ static int br_ip4_multicast_mrd_rcv(struct net_bridge *br,
>  	    igmp_hdr(skb)->type != IGMP_MRDISC_ADV)
>  		return -ENOMSG;
>  
> -	br_multicast_mark_router(br, port);
> +	br_ip4_multicast_mark_router(br, port);
>  
>  	return 0;
>  }
> @@ -3222,7 +3350,7 @@ static void br_ip6_multicast_mrd_rcv(struct net_bridge *br,
>  	if (icmp6_hdr(skb)->icmp6_type != ICMPV6_MRDISC_ADV)
>  		return;
>  
> -	br_multicast_mark_router(br, port);
> +	br_ip6_multicast_mark_router(br, port);
>  }
>  
>  static int br_multicast_ipv6_rcv(struct net_bridge *br,
> @@ -3379,6 +3507,8 @@ void br_multicast_init(struct net_bridge *br)
>  	timer_setup(&br->ip4_own_query.timer,
>  		    br_ip4_multicast_query_expired, 0);
>  #if IS_ENABLED(CONFIG_IPV6)
> +	timer_setup(&br->ip6_mc_router_timer,
> +		    br_ip6_multicast_local_router_expired, 0);
>  	timer_setup(&br->ip6_other_query.timer,
>  		    br_ip6_multicast_querier_expired, 0);
>  	timer_setup(&br->ip6_own_query.timer,
> @@ -3476,6 +3606,7 @@ void br_multicast_stop(struct net_bridge *br)
>  	del_timer_sync(&br->ip4_other_query.timer);
>  	del_timer_sync(&br->ip4_own_query.timer);
>  #if IS_ENABLED(CONFIG_IPV6)
> +	del_timer_sync(&br->ip6_mc_router_timer);
>  	del_timer_sync(&br->ip6_other_query.timer);
>  	del_timer_sync(&br->ip6_own_query.timer);
>  #endif
> @@ -3510,6 +3641,9 @@ int br_multicast_set_router(struct net_bridge *br, unsigned long val)
>  	case MDB_RTR_TYPE_PERM:
>  		br_mc_router_state_change(br, val == MDB_RTR_TYPE_PERM);
>  		del_timer(&br->ip4_mc_router_timer);
> +#if IS_ENABLED(CONFIG_IPV6)
> +		del_timer(&br->ip6_mc_router_timer);
> +#endif
>  		br->multicast_router = val;
>  		err = 0;
>  		break;
> @@ -3532,6 +3666,16 @@ br_multicast_rport_del_notify(struct net_bridge_port *p, bool deleted)
>  	if (!deleted)
>  		return;
>  
> +	/* For backwards compatibility for now, only notify if there is
> +	 * no multicast router anymore for both IPv4 and IPv6.
> +	 */
> +	if (!hlist_unhashed(&p->ip4_rlist))
> +		return;
> +#if IS_ENABLED(CONFIG_IPV6)
> +	if (!hlist_unhashed(&p->ip6_rlist))
> +		return;
> +#endif
> +
>  	br_rtr_notify(p->br->dev, p, RTM_DELMDB);
>  	br_port_mc_router_state_change(p, false);
>  
> @@ -3550,9 +3694,14 @@ int br_multicast_set_port_router(struct net_bridge_port *p, unsigned long val)
>  	spin_lock(&br->multicast_lock);
>  	if (p->multicast_router == val) {
>  		/* Refresh the temp router port timer */
> -		if (p->multicast_router == MDB_RTR_TYPE_TEMP)
> +		if (p->multicast_router == MDB_RTR_TYPE_TEMP) {
>  			mod_timer(&p->ip4_mc_router_timer,
>  				  now + br->multicast_querier_interval);
> +#if IS_ENABLED(CONFIG_IPV6)
> +			mod_timer(&p->ip6_mc_router_timer,
> +				  now + br->multicast_querier_interval);
> +#endif
> +		}
>  		err = 0;
>  		goto unlock;
>  	}
> @@ -3561,21 +3710,31 @@ int br_multicast_set_port_router(struct net_bridge_port *p, unsigned long val)
>  		p->multicast_router = MDB_RTR_TYPE_DISABLED;
>  		del |= br_ip4_multicast_rport_del(p);
>  		del_timer(&p->ip4_mc_router_timer);
> +		del |= br_ip6_multicast_rport_del(p);
> +#if IS_ENABLED(CONFIG_IPV6)
> +		del_timer(&p->ip6_mc_router_timer);
> +#endif
>  		br_multicast_rport_del_notify(p, del);
>  		break;
>  	case MDB_RTR_TYPE_TEMP_QUERY:
>  		p->multicast_router = MDB_RTR_TYPE_TEMP_QUERY;
>  		del |= br_ip4_multicast_rport_del(p);
> +		del |= br_ip6_multicast_rport_del(p);
>  		br_multicast_rport_del_notify(p, del);
>  		break;
>  	case MDB_RTR_TYPE_PERM:
>  		p->multicast_router = MDB_RTR_TYPE_PERM;
>  		del_timer(&p->ip4_mc_router_timer);
>  		br_ip4_multicast_add_router(br, p);
> +#if IS_ENABLED(CONFIG_IPV6)
> +		del_timer(&p->ip6_mc_router_timer);
> +#endif
> +		br_ip6_multicast_add_router(br, p);
>  		break;
>  	case MDB_RTR_TYPE_TEMP:
>  		p->multicast_router = MDB_RTR_TYPE_TEMP;
> -		br_multicast_mark_router(br, p);
> +		br_ip4_multicast_mark_router(br, p);
> +		br_ip6_multicast_mark_router(br, p);
>  		break;
>  	default:
>  		goto unlock;
> diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
> index 41ed3fe..a2e7b9e 100644
> --- a/net/bridge/br_private.h
> +++ b/net/bridge/br_private.h
> @@ -311,6 +311,8 @@ struct net_bridge_port {
>  	struct hlist_node		ip4_rlist;
>  #if IS_ENABLED(CONFIG_IPV6)
>  	struct bridge_mcast_own_query	ip6_own_query;
> +	struct timer_list		ip6_mc_router_timer;
> +	struct hlist_node		ip6_rlist;
>  #endif /* IS_ENABLED(CONFIG_IPV6) */
>  	u32				multicast_eht_hosts_limit;
>  	u32				multicast_eht_hosts_cnt;
> @@ -457,6 +459,8 @@ struct net_bridge {
>  	struct bridge_mcast_querier	ip4_querier;
>  	struct bridge_mcast_stats	__percpu *mcast_stats;
>  #if IS_ENABLED(CONFIG_IPV6)
> +	struct hlist_head		ip6_mc_router_list;
> +	struct timer_list		ip6_mc_router_timer;
>  	struct bridge_mcast_other_query	ip6_other_query;
>  	struct bridge_mcast_own_query	ip6_own_query;
>  	struct bridge_mcast_querier	ip6_querier;
> @@ -866,11 +870,19 @@ static inline bool br_group_is_l2(const struct br_ip *group)
>  
>  static inline struct hlist_node *
>  br_multicast_get_first_rport_node(struct net_bridge *b, struct sk_buff *skb) {
> +#if IS_ENABLED(CONFIG_IPV6)
> +	if (skb->protocol == htons(ETH_P_IPV6))
> +		return rcu_dereference(hlist_first_rcu(&b->ip6_mc_router_list));
> +#endif
>  	return rcu_dereference(hlist_first_rcu(&b->ip4_mc_router_list));
>  }
>  
>  static inline struct net_bridge_port *
>  br_multicast_rport_from_node(struct hlist_node *rp, struct sk_buff *skb) {
> +#if IS_ENABLED(CONFIG_IPV6)
> +	if (skb->protocol == htons(ETH_P_IPV6))
> +		return hlist_entry_safe(rp, struct net_bridge_port, ip6_rlist);
> +#endif
>  	return hlist_entry_safe(rp, struct net_bridge_port, ip4_rlist);
>  }
>  
> @@ -882,7 +894,7 @@ static inline bool br_ip4_multicast_is_router(struct net_bridge *br)
>  static inline bool br_ip6_multicast_is_router(struct net_bridge *br)
>  {
>  #if IS_ENABLED(CONFIG_IPV6)
> -	return timer_pending(&br->ip4_mc_router_timer);
> +	return timer_pending(&br->ip6_mc_router_timer);
>  #else
>  	return false;
>  #endif
> 

