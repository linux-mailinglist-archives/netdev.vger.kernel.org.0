Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FAC437A331
	for <lists+netdev@lfdr.de>; Tue, 11 May 2021 11:13:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231345AbhEKJOe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 May 2021 05:14:34 -0400
Received: from mail-bn8nam11on2064.outbound.protection.outlook.com ([40.107.236.64]:24339
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230445AbhEKJOd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 11 May 2021 05:14:33 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CpYj2VVWOq4CMVKHIawB+2SWFmQFqsIBAdWUjcetle3ipoqaKRSIA/BMCIaoAawUO6hQXoMtovEToI03bEKZ+DkfC3DEnyMZZ4aa3oNZpf3twdvuT7KStYypBaqQWZDzOahT6x208YC46niLZiQLnH//pQtD5Dg7TZO6euJSEhHJRcdS5udTngj8sgmk9whKqeDXAf2xMaPV8w8m79kG8LF+aYKOO68XJ05jAXHD9W7FqTfWIOp0mfIiQgLCcuVEWQ+QUPv0bpkVGHAWtlumyiMW14BsARFb60r1ietrUuxv4nk1My6tNR+DS8VupSu6MVRC38xYsp1rEfjFyg27Aw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g+rADTgXKtl+xV7sJI60a9rrH+kwgRJHnwjmjfxHhwg=;
 b=XNEqi0TJA+RCYfgqve154cfvk6J7uvLyoZJpgsgZ4QsBMw6iQPQ+CmJIbU1wgkqLqFH7zBg5MBlaCoS3h7Bz8VDI2QW39dUXmWVguqulFf/wefuGkyfNMapND03B7yBIfkThCUw8JaLwFsBX3QPW2hHveCpTz/la2wTy1B7bLr6ww2xnAx+s/npTLPbTudngLH9L6dsWJq5I5Hvo0XAGBuaiTJCfFA0LfPwtfCssbgw7ZX1wJPHwuBVmueBDVSc2LuLtFxWGKDyEA+XgCkOhasQZqxbdFZ+CypkqvOtOiQ1c+2R3WbZFqi9ChS8jO9mBT/pPDI2ldCvc0Dhv9Ta/hw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g+rADTgXKtl+xV7sJI60a9rrH+kwgRJHnwjmjfxHhwg=;
 b=rq3fsThVd4R8XiZjG/RJzcNtwTIxXrTUlqK1MtwyeWQoNQSLW1IulVZD/jIS13D9UQlSY4Q74LWub6yCFM4Qsl2Y4Bbd0MGtpAV1ipRXYSZ+ulwbL39mv+fF0rnDXbCeA3X81x4rZtrA7Zt/uyMfCRhFcwpVHdwYFfdOVHCTlKQW7LWc+udQdWHpM9qaX/opplg74OyCgaOgpdBODdfcS3epCGqcogBuEPx8tQkZFMmI43qvpeK0xn4TcRJOsmVfz3FCq/7EB4aLtiGwPrfQcSUU3QTglA/ru1NJqZbC/JUoNlr+dCqefvcNVqpreajUfbjvOsuphSj/CQ9xGghwrQ==
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB5278.namprd12.prod.outlook.com (2603:10b6:5:39e::17)
 by DM4PR12MB5118.namprd12.prod.outlook.com (2603:10b6:5:391::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25; Tue, 11 May
 2021 09:13:26 +0000
Received: from DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::d556:5155:7243:5f0f]) by DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::d556:5155:7243:5f0f%6]) with mapi id 15.20.4108.031; Tue, 11 May 2021
 09:13:26 +0000
Subject: Re: [net-next v2 03/11] net: bridge: mcast: prepare mdb netlink for
 mcast router split
To:     =?UTF-8?Q?Linus_L=c3=bcssing?= <linus.luessing@c0d3.blue>,
        netdev@vger.kernel.org
Cc:     Roopa Prabhu <roopa@nvidia.com>, Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        bridge@lists.linux-foundation.org, b.a.t.m.a.n@lists.open-mesh.org,
        linux-kernel@vger.kernel.org
References: <20210509194509.10849-1-linus.luessing@c0d3.blue>
 <20210509194509.10849-4-linus.luessing@c0d3.blue>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
Message-ID: <5804d062-4b3d-9fab-50ba-e9dfa085f4f0@nvidia.com>
Date:   Tue, 11 May 2021 12:13:17 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
In-Reply-To: <20210509194509.10849-4-linus.luessing@c0d3.blue>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [213.179.129.39]
X-ClientProxiedBy: ZR0P278CA0159.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:41::8) To DM4PR12MB5278.namprd12.prod.outlook.com
 (2603:10b6:5:39e::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.21.241.170] (213.179.129.39) by ZR0P278CA0159.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:41::8) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25 via Frontend Transport; Tue, 11 May 2021 09:13:23 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ba18411d-4c0f-41d0-9e39-08d9145d08a3
X-MS-TrafficTypeDiagnostic: DM4PR12MB5118:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM4PR12MB51187D54388AAC7FA6AF216FDF539@DM4PR12MB5118.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: B+PPhRmqjidlZCsbfUj6r8g86sAhB4nLSVP8UoKDKmgO9EcVGLHu2xAf30Fwky1iRzeoi9QdG6FsxWNehkGb1PSe3U8nzwcqzvy7i/mOH3E1JzYhbtaePWtg7xkHoOFBXb31DKRxq5fDwjxqGRG9Jsl/xPLjmgpM6Xxi0upHQiu7/0mv+KQdNaotjWYJTYrGM3QvAPdAuNe6k4TNnBOqyyBEdlhil9DpGjD05w9McqRM3t4NrD/TxHOx7U8W0qHGuafVvWtuD6WylO30akWeyYWUxQCkkHm/E4yozY5vbtR0WmOyqoV4KIrMCWTJv5A1rYn95b43nv31iunN7fSzxKwRKcPz+SGA7a7zSPQiJdP2F781TtZpiGkA/yk6WtJFOoigvjaAvdLF6ZgG9mjmuFpzLLQ38WW3g8AZGHeADks96xkNRV8vIYme2fBBzWrefVlsLyiHHtjj2QOEbU0sgCoFfXBDOvADDbT+daM/rfxFJZs2ocTmDWoxgUm0gEQPl4zx5oCPCqRv5S42pgk+lRuyQlhz1b0ELx575p7PWBsALx+obBOZCzSgnjEw+f/9ZlQX/WTQqgAEQmAHn51PGQprb/qFx2cfFjL7jao4ffufREfwZcActXkqRT4Rvhp2dEchfJZ66W1yesDQyHb8CNFqudO8hdAi8snD/RqvdccrddYtnU0UDWnv6LmVzmbp
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5278.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39860400002)(136003)(376002)(346002)(366004)(4326008)(53546011)(31696002)(956004)(2616005)(86362001)(478600001)(54906003)(26005)(6666004)(8676002)(316002)(16576012)(31686004)(38100700002)(6486002)(2906002)(8936002)(36756003)(83380400001)(66476007)(66574015)(66946007)(186003)(5660300002)(66556008)(16526019)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?TTUvYnpHZjRGRUJLSHZHbWpLejRxRk9RWUVZMU1KMjE3aUtBaE1mNlhtWkJr?=
 =?utf-8?B?YlhKc3BPcEF3U0xaOTZsSGpmU0UzeVlZcTYwMmJhNnlOQ1pXbFB6RVZGRkRa?=
 =?utf-8?B?b0tpQVNWVkFRYW5KMXdkdE5UNzNpQUxnUGp4RkNSZTNpMDd6WmhtRk85Z1Vs?=
 =?utf-8?B?ajYyMGdtZ0tDL3ZYa1NqOGF4NVNlWTJsZk9wLzFoaXdhVUtQL1V2S2orSHdE?=
 =?utf-8?B?MHRTNzlqVGk2akREM0VOY25GMWVtNld5ZkRsMmxqdWY0LzBFRWJoUXhrYkRK?=
 =?utf-8?B?WkJxbTdVYmoxcVRka2Z6bmlQUlE5b0dMTGJOTGsvd3BCYWlBTVpPakVEK3ZX?=
 =?utf-8?B?YXM4Wi90MG5panVndFpOVHVQU2tHalFWNmN0TW45TW5YM2UyWG1DUU1zL25h?=
 =?utf-8?B?cWxxYkwzT21wUVhDZTdJdTNzcTZ1TlorWkt5allPcDR4cWxhWUxvTm5GK1BB?=
 =?utf-8?B?MVdDbjV2ODlFMURXbXRRS01XL2dveEVjcE9yc2h0R2pHRzlyRHB0R1pJYjdp?=
 =?utf-8?B?SlJnU093dzZ0SjMyYmswVUZVRzhZUjBRTVkyb1kraXdYb2xtdHNWZXZETHVP?=
 =?utf-8?B?MGVpTnFEWEk1NktOeExKcXdobXNGMFNJR3pnS0dPYVZrdmJBbWRyY1lTRFlX?=
 =?utf-8?B?OUZhUmd0ZWNERWZKcEFGODF4ejdDV0t3T3hiSFVRSFRodUlGR3J0SUtNK1ph?=
 =?utf-8?B?SU1LQnFGbkpycXh1cTNQcWkxYmYwZzVnRGhjeE5ROFpKeTl6T1VDTm85VEhn?=
 =?utf-8?B?eXdUTEpsSUc1RmFHalIyQUxXVTRZOVNZOWU0ai9jUXNEb2I4dEJTRUtsSDR2?=
 =?utf-8?B?bVU1SEx0NHRHZVFkd3FlU0wrL3ZjczlyeUZwMkV3WXdaTkQyMWFST2EyalZy?=
 =?utf-8?B?SnEvNFZtV21UYkd6T25WMSt0WjFQc0RwUUtNMnZOa3V5cXFLN0VyT1BQYlNx?=
 =?utf-8?B?eUcrSk5DeFZ2RkE0ZEFJR2pIOWJ3Qjl5THZSMzBXTDZKVkNTd0x4L1JzZHhK?=
 =?utf-8?B?aE1xYjd0L0JYUjV0R3h5TXA5UEVqOVhLM3BkUjFoKzZrQ3pKbC9ZUUVUSVlL?=
 =?utf-8?B?UlYwZ3p2UXZ0eHp2VytHMzBIeXZyVEJCYmYzYVF2WUxYQUkwb3k1a3VCWHVo?=
 =?utf-8?B?d1VrdGErNjFZR2w3dkxUOERvN3lLekYzOWF2UGd2NzNFc3lsS3lIaWI5TDNF?=
 =?utf-8?B?dnBHTGtxT01kV1dZdTRlNFhJb2NhUnB2aGRxMUZJNUhOVkYxN1lObDNxaSs3?=
 =?utf-8?B?MmFNNDNYL0JlcW9PYjJDNXJ5VU91VzhUeDNnNEZ4dTdpRWpIdnNvbVYvRWlY?=
 =?utf-8?B?SldJSXB4U2RQbnFoL1ljeCtSd2NHNkxTUkQ2eHo2YkRDVmJxSks3NmV3Zkhx?=
 =?utf-8?B?V1E5ZWxlbzBZdkE1MElSelB5cjBuMU5JY2l0OGRFaEN3Zmh1VDBFTjc2dEdj?=
 =?utf-8?B?L2Rod0MrcUlkM1U5Zm5RbFdoaVRobThoVE1rVDRoSFE4TEpsNjJ5cHhkZUt2?=
 =?utf-8?B?NGhkU0NKeCttMHBXdVZITis5RFVrSjBHeGN4Q0V6dGNZRlgrZS9VOE5KTnZ6?=
 =?utf-8?B?eFBKMERkUlZhek1JdmZpMExsOFdkaVZNOFlhVEp2Uyt2K09QN2llQXdGRXpZ?=
 =?utf-8?B?QzRUSmI3THJZOHpqRFRVNzlhZGdPa2tiYzYrUU9kdE1rOGsrUGVqVzNsMnRU?=
 =?utf-8?B?M0I1MkFFWjBHU3hyWFJnT01YTm9GeXRSY3QvZWl2dlpaS3VrV1pBSXJIY2JL?=
 =?utf-8?Q?jQ2k0xJ7Lx2ZN/LCOPSNN0Zmww0iPRTFluxQ89E?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ba18411d-4c0f-41d0-9e39-08d9145d08a3
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5278.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2021 09:13:26.1250
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: x17lTpKQenKa7evjgW4G3y4MkE/yXijLxOl4IjHf06uKwy+3WJYHtd8bgKpdEpLDkbBcGBk9guf1rSTjaSSw+Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5118
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 09/05/2021 22:45, Linus Lüssing wrote:
> In preparation for the upcoming split of multicast router state into
> their IPv4 and IPv6 variants and to avoid IPv6 #ifdef clutter later add
> some inline functions for the protocol specific parts in the mdb router
> netlink code. Also the we need iterate over the port instead of router
> list to be able put one router port entry with both the IPv4 and IPv6
> multicast router info later.
> 
> Signed-off-by: Linus Lüssing <linus.luessing@c0d3.blue>
> ---
>  net/bridge/br_mdb.c | 39 ++++++++++++++++++++++++++++++++++-----
>  1 file changed, 34 insertions(+), 5 deletions(-)
> 
> diff --git a/net/bridge/br_mdb.c b/net/bridge/br_mdb.c
> index d61def8..6937d3b 100644
> --- a/net/bridge/br_mdb.c
> +++ b/net/bridge/br_mdb.c
> @@ -16,29 +16,58 @@
>  
>  #include "br_private.h"
>  
> +static inline bool br_rports_have_mc_router(struct net_bridge *br)
> +{
> +	return !hlist_empty(&br->ip4_mc_router_list);
> +}
> +
> +static inline bool
> +br_ip4_rports_get_timer(struct net_bridge_port *port, unsigned long *timer)
> +{
> +	*timer = br_timer_value(&port->ip4_mc_router_timer);
> +	return !hlist_unhashed(&port->ip4_rlist);
> +}
> +
> +static inline bool
> +br_ip6_rports_get_timer(struct net_bridge_port *port, unsigned long *timer)
> +{
> +	*timer = 0;
> +	return false;
> +}
> +

Same comment about inlines in .c files, please move them to br_private.h

>  static int br_rports_fill_info(struct sk_buff *skb, struct netlink_callback *cb,
>  			       struct net_device *dev)
>  {
>  	struct net_bridge *br = netdev_priv(dev);
> -	struct net_bridge_port *p;
> +	bool have_ip4_mc_rtr, have_ip6_mc_rtr;
> +	unsigned long ip4_timer, ip6_timer;
>  	struct nlattr *nest, *port_nest;
> +	struct net_bridge_port *p;
>  
> -	if (!br->multicast_router || hlist_empty(&br->ip4_mc_router_list))
> +	if (!br->multicast_router)
> +		return 0;
> +
> +	if (!br_rports_have_mc_router(br))
>  		return 0;
>  
>  	nest = nla_nest_start_noflag(skb, MDBA_ROUTER);
>  	if (nest == NULL)
>  		return -EMSGSIZE;
>  
> -	hlist_for_each_entry_rcu(p, &br->ip4_mc_router_list, ip4_rlist) {
> -		if (!p)
> +	list_for_each_entry_rcu(p, &br->port_list, list) {
> +		have_ip4_mc_rtr = br_ip4_rports_get_timer(p, &ip4_timer);
> +		have_ip6_mc_rtr = br_ip6_rports_get_timer(p, &ip6_timer);
> +
> +		if (!have_ip4_mc_rtr && !have_ip6_mc_rtr)
>  			continue;
> +
>  		port_nest = nla_nest_start_noflag(skb, MDBA_ROUTER_PORT);
>  		if (!port_nest)
>  			goto fail;
> +
>  		if (nla_put_nohdr(skb, sizeof(u32), &p->dev->ifindex) ||
>  		    nla_put_u32(skb, MDBA_ROUTER_PATTR_TIMER,
> -				br_timer_value(&p->ip4_mc_router_timer)) ||
> +				max(ip4_timer, ip6_timer)) ||
>  		    nla_put_u8(skb, MDBA_ROUTER_PATTR_TYPE,
>  			       p->multicast_router)) {
>  			nla_nest_cancel(skb, port_nest);
> 

