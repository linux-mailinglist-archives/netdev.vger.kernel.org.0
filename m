Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36E3537A3B4
	for <lists+netdev@lfdr.de>; Tue, 11 May 2021 11:31:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231378AbhEKJa5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 May 2021 05:30:57 -0400
Received: from mail-dm6nam08on2066.outbound.protection.outlook.com ([40.107.102.66]:42916
        "EHLO NAM04-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231343AbhEKJa5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 11 May 2021 05:30:57 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bjL02u544KBvVTQHElBvBFRYPRlZdkwIdzgywH/W1SQbsOLK7TB/V2OtcSJdFHYZrfzHXiVanwRKLwH3GVj0lTnIr4OiGkADEdyKE1V3pMHR6c1aMpxGnySjbkbyM4HRZKdHIZzlIp1u9HjMPzxHzgUu5Z9IPMJCZ3qMP/qG29OrlUbgpNxcGrj8kQMcaIxcT/zAN5dml0PFavTk1lOzg4wR4u4ZqQ9HfG9sy/M2HoimXYZxFAOKfeNZ8p1WLLxHUGClhPoecQe0aY3kCf7p9iPd4/FpL5nTgMuC6Bv9Li3hYVOj3u2mXY9SolhbblKWXY2H5eNoIoGblEssaq6Teg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qBm73m658A4EW/YZLiEiQBI7rG376XvrN7SYlDjWtlE=;
 b=BcGVNuy1bymVgt09N9IvDVP7vGphJa6nDtregQ6zVfavTJcJLhpuTfWwbAntjcgjz8hfGZO1Wwtrkc1q128bX7iz3CUnVGFxFzNVtds/FI8jUZ0syxvHKzwXkQ/ujGuCo6UxnIGuxuWGPGAzpBy2Nsp+bWRatKBDsixJ1iGIaod/udEoNDaDZif7h74DXK5zT6kNc+Cb/UikT5KkgHt19XPshYri6+WKhoz7EOxdxLnvEOPp73DStFydHYssiqhDkLgpl6Wx9gZtiBHwdCV5h98sMlxsE4gWMj/7p99TUblZNtNPozOPVZQKHuqNHVBM4jFCo/i0UKnCGwccdoQJuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qBm73m658A4EW/YZLiEiQBI7rG376XvrN7SYlDjWtlE=;
 b=fXDUFdw/npq1o+aqqSWoM0+WirniaunfNKlEB1cmAgtFjw6BoUoV04ncdXNNr4e0+EFGofYR4VOkG9PL2vssy6IKESYFEG1GQY98hTu/dGhEXsA2TNPNVYYZuxqhf9MjYrrfT4hZfQtSu+m6F9if6IJC8NfRza3oNyLYc9aeUKtlIfFZPkVJVXBfFtJ2Kwrcwi5ldUqGqr9rvkTsTlkZhlgM6QBEGs4xwk2sblwiFjsZBoyQYBiwGVE73rGOQMj9kpE/wJX5ONsp3ypO3NY5DjxpaO9eeyc6WazbPnawM/t9IxssKtV7eVTUBfZm1A6JhSQNRUEJ8xWSaXOduKEDSA==
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB5278.namprd12.prod.outlook.com (2603:10b6:5:39e::17)
 by DM8PR12MB5416.namprd12.prod.outlook.com (2603:10b6:8:28::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25; Tue, 11 May
 2021 09:29:49 +0000
Received: from DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::d556:5155:7243:5f0f]) by DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::d556:5155:7243:5f0f%6]) with mapi id 15.20.4108.031; Tue, 11 May 2021
 09:29:49 +0000
Subject: Re: [net-next v2 09/11] net: bridge: mcast: split multicast router
 state for IPv4 and IPv6
To:     =?UTF-8?Q?Linus_L=c3=bcssing?= <linus.luessing@c0d3.blue>,
        netdev@vger.kernel.org
Cc:     Roopa Prabhu <roopa@nvidia.com>, Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        bridge@lists.linux-foundation.org, b.a.t.m.a.n@lists.open-mesh.org,
        linux-kernel@vger.kernel.org
References: <20210509194509.10849-1-linus.luessing@c0d3.blue>
 <20210509194509.10849-10-linus.luessing@c0d3.blue>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
Message-ID: <f2f1c811-0502-bde4-8ece-e47b3e30dc66@nvidia.com>
Date:   Tue, 11 May 2021 12:29:41 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
In-Reply-To: <20210509194509.10849-10-linus.luessing@c0d3.blue>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [213.179.129.39]
X-ClientProxiedBy: ZR0P278CA0017.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:16::27) To DM4PR12MB5278.namprd12.prod.outlook.com
 (2603:10b6:5:39e::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.21.241.170] (213.179.129.39) by ZR0P278CA0017.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:16::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25 via Frontend Transport; Tue, 11 May 2021 09:29:47 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: eee28e8d-b1a4-4779-a70d-08d9145f52c0
X-MS-TrafficTypeDiagnostic: DM8PR12MB5416:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM8PR12MB541632577D42B64C7437AB20DF539@DM8PR12MB5416.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FhWhhONalM9uHaF3zRuNgnZVhsKLRNYwPKYIG2nc0SuXLw6wSDYgGrKMbqmSh55Zu4kK/PCceMxZ8BHoIPeAlx29pcbv7Q26D9ixIOkI7ZSgfPxGeZ0MpCFrsfKfLubS3sEMIxe3+7KipPZ8pJhAPJYFQ2EzYjX7Wn6OQ0CeF+UKC4U+ofarSL3ighhsP9iHkMb1VO+Vtx23HNVD6nl80ra19QQO94RScZ070wp16bAyB1lAlPPpmUAulIdJDgTccSxtfxlLS5i/Oi655fsajCjXFVX49UA2WPDfKOK+hDcHUSjwnjzGnsq72yYy7Dnco8OyFrIKpTnrVlNirPcRGK9g67JtglonRa+l/8OajoRHYzcNqRvYiEFirKrGzIkTi6Q+ivSGeYLT+UIam2Nz2pk1s7qaoVLZ0J6bJxR5PQQD/IwqAKr+/mG+6H+VqLXu1qZxhOShbUUIteQ3pEATh7xl/F68vWNB5TIfxN2l2/8wo5ne94oDBj45mfs4TawRrpjtMmLVkC0Rbzd8TpgFpG+ApP1X+hlmueYsJQC5ZUPnVqZshomKS5PMVbXuBr2zxXfh5yYu4f/Einy0vJSgd91AWv9cxTVgORzYlHsFRmVmmBSFhyYUpzaYR2NZhrZ0eDdk8rI/61a0jA21EAya6sDlE4cnP6RFWgu8wCNOs7HjnWHSE4WaDvKFtJLi3sxb
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5278.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(396003)(39860400002)(136003)(366004)(31686004)(36756003)(956004)(2616005)(2906002)(316002)(186003)(83380400001)(66574015)(16526019)(8676002)(66556008)(26005)(4326008)(54906003)(53546011)(5660300002)(38100700002)(30864003)(6486002)(31696002)(8936002)(66476007)(478600001)(6666004)(66946007)(16576012)(86362001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?d2xtb1BvQTRMQ25YREdkdkdSYTg4RGNMOFh4RjFtZzlTamRsN3E5blJ0T1Vq?=
 =?utf-8?B?R3FjU3FsZURXL0szNEpIaDJVR0phMW5ZVHo0Y3M4OVpNSW4rUlJERUw0WW9F?=
 =?utf-8?B?TEk5T3p6ZmxPQUdpMnZYQWNLZkRyRjVPQWFxUUJvaE1PM1RUTWJlVUY4YmpE?=
 =?utf-8?B?dzBqNWFmUXpRajBRMVZ0THRhWXIwenJnQ3FaciswaE00d1pYbHA5THJacUw4?=
 =?utf-8?B?RW1hdWJLL3cwZXdMckhQNXQrbXBneld3Nm9YQlBBdFlNNVJxbG5JR1hiaWF0?=
 =?utf-8?B?QldOamZyZDh4ZVA2cXZlWjR0cHNuZU5keHhudVJwU1h1MG94ckl0M2F4cGFL?=
 =?utf-8?B?MStTYmsyWDZyU3U3Tjd1aFBjdDVJKzlZVnJNWUQzb0dudDg1K1UzOU8wdGdl?=
 =?utf-8?B?ZzYyU3pNL2RRZTBKZnZ6L083ZVgzWFB1dEdBMGVPQ1pvbVpRbEJKMXJrc3NX?=
 =?utf-8?B?dTN1WEVzb01sTGZzbTRqYU1TYWhhcnI1K2FtQ0V6am1YVC9uNkpBUmhmSmpL?=
 =?utf-8?B?OXB0RFFCNm1FOGdydU9NQndDZzFnQVBaTWhxTC94b2oxWXdISWx0YUc1dFVI?=
 =?utf-8?B?czVsSmpnY09mNCt0cFFrNUliOWhkUzQ1eUZIRFZOU0EvZEZsSkhLRUJsRHpi?=
 =?utf-8?B?aVUrWWJWV21aVCtzSUNtd25MTW1PcUpoL1BKQ2N6U2s2WlZyckFxZWIvbDJ3?=
 =?utf-8?B?Y2hUd3h6amlhRUEvUllSb3pZU0Zma3IyOWtlMGFQYUJ0UXlJeTU2L2RiU0sz?=
 =?utf-8?B?MlZLQm1ZblEwczBtS2pJT1ZWOFgraE52SUZJQW4xS29JT1ZBL01RRlN6b2Zy?=
 =?utf-8?B?TnBnT3Q3L1pjeVh5V01IUkQvWUplWURYVW5TMVlYQ21qeVBPbDBwSS82bWNL?=
 =?utf-8?B?KzJMUWJrUHZjZkE4VzhlYjY3MnF4M2Q1blgrNlFPdi9VcjVhK0xiUHNucEJL?=
 =?utf-8?B?VE1zNElxejBNN0p5dlpEQ1NPZEgvaEQzVVlPOFhRUytJNWdPMjVMUWVKT3A0?=
 =?utf-8?B?SkFSckpFcCtPaTlPRC81dkxtSWk0bUtEWUFmMWorTWVFeE0wMHpvS2hHT21h?=
 =?utf-8?B?MEh1bjRiWHIzc29GdGJoZFBMcGRTc3p4MlR4TXdLNzRRN2l3WjJpRmQzbitt?=
 =?utf-8?B?U3ZsNzhIUGM3UURKcmpJZWduMXpEb0ZOUmtvTDVvK3JtRjh3TDVNQ24wUnBh?=
 =?utf-8?B?K0hTVm5BM3lzc1FhVFJvQTFvNkI1ektpU2FTWUVqdmR1NzhUZGhmajdUZlI4?=
 =?utf-8?B?WHhYbFRBRm94eTVRa2lHS2V4Qnpvb3UrK2cyVXlFc1poR1poRGxpKzRtM1NC?=
 =?utf-8?B?SEsrL1hOU2tjTllHbi9GcDNGRDZCZ1FzZUxEcjcyODhmRlRBWFFobWd2TzU0?=
 =?utf-8?B?WDZjR0JXbTRLMDYweDFQMmtWNnU4S3VyVXQ4TE13RTRCbktzNXlvVFdQNlNH?=
 =?utf-8?B?cW5uTFhxODIvM0JXUENHcFcxSHRtNlF0Y1RWejZ1QUlxZ05nTnZwUDdDeHpG?=
 =?utf-8?B?MDFCOGRkb05ybjhSMDBKQk5jd3lQdnpQSHBBUUV3MGdEVVZXaGg3cTVGTVJ4?=
 =?utf-8?B?WVVVSWVOYUdQbVF1RklrelQ5OVpSaW45SUFvSmhwNHpyUStleldxRktOOFM2?=
 =?utf-8?B?N2o0UnlwYXl1ZXE1eEhCZitpTjRTUzFQcFdEdFJobjJuaW92c3ZpNFBnSUFC?=
 =?utf-8?B?NXpGZ3B5Vm02K0tibWtRTzlVWlVpNGRnVXArSDhxb2VRUU5oTDhmaWpNVWRW?=
 =?utf-8?Q?qMOuwh8PQfEYLo2xsO6QrDOoqyqRkVKn4c0TUNc?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eee28e8d-b1a4-4779-a70d-08d9145f52c0
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5278.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2021 09:29:49.4204
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FlL9YH/hz+xlurjABnRLuzclOdI1yc4GBPyUWNFyRD+Bm6t9c5auoydpbQdFnAnNsjQqKIiK01XABPbJ2oJY+A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR12MB5416
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 09/05/2021 22:45, Linus Lüssing wrote:
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
>  net/bridge/br_forward.c   |   8 ++
>  net/bridge/br_mdb.c       |  10 ++
>  net/bridge/br_multicast.c | 197 ++++++++++++++++++++++++++++++++++----
>  net/bridge/br_private.h   |   6 +-
>  4 files changed, 201 insertions(+), 20 deletions(-)
> 
> diff --git a/net/bridge/br_forward.c b/net/bridge/br_forward.c
> index b5ec4f9..31a02c5 100644
> --- a/net/bridge/br_forward.c
> +++ b/net/bridge/br_forward.c
> @@ -266,11 +266,19 @@ static void maybe_deliver_addr(struct net_bridge_port *p, struct sk_buff *skb,
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
> diff --git a/net/bridge/br_mdb.c b/net/bridge/br_mdb.c
> index 6937d3b..3c608da 100644
> --- a/net/bridge/br_mdb.c
> +++ b/net/bridge/br_mdb.c
> @@ -18,7 +18,12 @@
>  
>  static inline bool br_rports_have_mc_router(struct net_bridge *br)
>  {
> +#if IS_ENABLED(CONFIG_IPV6)
> +	return !hlist_empty(&br->ip4_mc_router_list) ||
> +	       !hlist_empty(&br->ip6_mc_router_list);
> +#else
>  	return !hlist_empty(&br->ip4_mc_router_list);
> +#endif
>  }
>  
>  static inline bool
> @@ -31,8 +36,13 @@ br_ip4_rports_get_timer(struct net_bridge_port *port, unsigned long *timer)
>  static inline bool
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
> index 39854d5..b625fd6 100644
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
> @@ -1369,6 +1371,15 @@ static inline bool br_ip4_multicast_rport_del(struct net_bridge_port *p)
>  	return br_multicast_rport_del(&p->ip4_rlist);
>  }
>  
> +static inline bool br_ip6_multicast_rport_del(struct net_bridge_port *p)
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
> @@ -1430,6 +1450,15 @@ static inline void br_ip4_multicast_local_router_expired(struct timer_list *t)
>  	br_multicast_local_router_expired(br, t);
>  }
>  
> +#if IS_ENABLED(CONFIG_IPV6)
> +static inline void br_ip6_multicast_local_router_expired(struct timer_list *t)
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
>  struct hlist_node *
> @@ -2722,14 +2777,54 @@ static void br_ip4_multicast_add_router(struct net_bridge *br,
>  				&br->ip4_mc_router_list);
>  }
>  
> -static void br_multicast_mark_router(struct net_bridge *br,
> -				     struct net_bridge_port *port)
> +#if IS_ENABLED(CONFIG_IPV6)
> +struct hlist_node *
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

The ip4/ip6 get_rport_slot functions are identical, why not add a list pointer
and use one function ?

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

Actually that goes for multicast_add_router, too.

I'm saying all this because soon I'll be adding per-vlan multicast router support
and these will be reusable there without any modification if they can take any list.
Also it'll be easier to maintain one set of functions instead of multiple identical ones.

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
> index ac5ca5b..5194210 100644
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
> @@ -872,7 +876,7 @@ static inline bool br_ip4_multicast_is_router(struct net_bridge *br)
>  static inline bool br_ip6_multicast_is_router(struct net_bridge *br)
>  {
>  #if IS_ENABLED(CONFIG_IPV6)
> -	return timer_pending(&br->ip4_mc_router_timer);
> +	return timer_pending(&br->ip6_mc_router_timer);
>  #else
>  	return false;
>  #endif
> 

