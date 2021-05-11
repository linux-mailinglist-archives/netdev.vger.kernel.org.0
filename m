Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A248C37A375
	for <lists+netdev@lfdr.de>; Tue, 11 May 2021 11:23:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231316AbhEKJYl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 May 2021 05:24:41 -0400
Received: from mail-bn7nam10on2042.outbound.protection.outlook.com ([40.107.92.42]:48608
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230126AbhEKJYj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 11 May 2021 05:24:39 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FU1YFM8k0Z9MgpTovtrLHcTWPRO287KT8iaY0PtQ5H0BFbVmmr3wLKFtR1gIV4BYppLtfaEZM+r/GFg2iTvtfJZutMF5iFS4jEnFEtNttQdj4acHQMqjwLCHAtzvcOLX/L8GuKoA92WNNa4DpHZlqTz6VEI010EB5g8UTR0kC58ddYhZ8kCNjkURPrNlzFa/ncpgr/EDka04ldDfgqo7poc3hQzCjEaVjZJDSI/jYLi9cMp6j+C6T/1VbvYFBV9An6J4nWwOlGJIjdzf7zbacSl2NyBdCOOqcZhpcSfL0shngB5ElKRLEHoICLeFFSjh/2VWi3OQf5bYKDHEu5KqSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QslpgAfoPSMyQTcwVuRxE/Clc9H3kQJwpSw0ATzzLfM=;
 b=HjMb6EndRzhKJ1VlJGbDzcllHUnQQ5QsjKoGuyoZLvxooTAAUmAAGdludkw5KrOaeYZlmsTnignbH4a058yf9RuUHu7kTQBS3dqCgGPe4sbbdE4TcCrTorqE7l3wjif5m37vGAjmZorpTsaUwMmKn2W9fq/+GOekbzlFf6tSqDegVgV9jFh6U347BgvJV4Wo0NrN730iKL1BtMXQy2IfMrUPYu+1oAly6+DH/b4hKxTFZawUdAuQZ5XKRDXdwfMJZ0qujeaxXbBy0RV7OjAgXw98beCtykv2J3qz3X9SCWbZty89SNWHLQ4YNTse9lAZwiM3ZmmlIdGl0N+Iovxspg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QslpgAfoPSMyQTcwVuRxE/Clc9H3kQJwpSw0ATzzLfM=;
 b=A4WJgu5U1MfknRodQBGk03f9hDOevSNbW1whKJ8i/FJPs+k97L8+DNHp40FEaAc/plSBqKPPe+Mt/m5tPA+rCmHzwi3s9b5p5nPvMIcwgSA9Pu7a+tuYaJ1YwKcGM+er7MyNflDZn+wswSKbiv8//hy7qvzsrPe3XT3EXqOx+KnzOAqJFSkbZMA3qmxnn76d5qyp3ay1BBarD/5EXBpcZFEn0hXsb8+FdWblckMfzso9JADsDi6waJWjHrK5fQh5ZgruPOLG3yUYDPJ4DS15ct67dRSqDpDCP9TYDTvpEVIfxp+a+2W9KJWn/UuASqgylc/gB7I5ux0I9Y69Regulg==
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB5278.namprd12.prod.outlook.com (2603:10b6:5:39e::17)
 by DM4PR12MB5326.namprd12.prod.outlook.com (2603:10b6:5:39f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.25; Tue, 11 May
 2021 09:23:32 +0000
Received: from DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::d556:5155:7243:5f0f]) by DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::d556:5155:7243:5f0f%6]) with mapi id 15.20.4108.031; Tue, 11 May 2021
 09:23:32 +0000
Subject: Re: [net-next v2 11/11] net: bridge: mcast: export multicast router
 presence adjacent to a port
To:     =?UTF-8?Q?Linus_L=c3=bcssing?= <linus.luessing@c0d3.blue>,
        netdev@vger.kernel.org
Cc:     Roopa Prabhu <roopa@nvidia.com>, Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        bridge@lists.linux-foundation.org, b.a.t.m.a.n@lists.open-mesh.org,
        linux-kernel@vger.kernel.org
References: <20210509194509.10849-1-linus.luessing@c0d3.blue>
 <20210509194509.10849-12-linus.luessing@c0d3.blue>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
Message-ID: <7279c94e-a4ff-2fbb-290e-bdaf5844148c@nvidia.com>
Date:   Tue, 11 May 2021 12:23:24 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
In-Reply-To: <20210509194509.10849-12-linus.luessing@c0d3.blue>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [213.179.129.39]
X-ClientProxiedBy: ZR0P278CA0057.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:21::8) To DM4PR12MB5278.namprd12.prod.outlook.com
 (2603:10b6:5:39e::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.21.241.170] (213.179.129.39) by ZR0P278CA0057.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:21::8) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.24 via Frontend Transport; Tue, 11 May 2021 09:23:30 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 267782ce-ef72-44fe-ffb2-08d9145e71ef
X-MS-TrafficTypeDiagnostic: DM4PR12MB5326:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM4PR12MB53263A9EE31CBCB7887BA057DF539@DM4PR12MB5326.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5RHwPtdbfN8J9iyoFBwB8xuApdMIWGn3Jn6230HIoX+AXOtv6St0qlCIuYAb3R/a6h29OV/XxRzySpdOuQsrg7nhfzSPdmBUVEFsTSc3J/3NonnlLW1DquqQzw7IEinhMNfXkJ9HHzN0roiZZnRjoUF+7y7UHTrO6fJalfNRQbKT28/JRk9htxuoZbpGvRHL8/E4jNlLwE+cz73Q+NzvQb9foOxkSAfrZ/NiOOFKGKh04DadS8PBd4Qjl2ZuGvMZu12r6xfcdwU4kgi3iWCKFGQih987TVIYQub3JxOzw5XQ+VjPvXcPCFUZ1ESKyVM+oAkIOodN14RRckFKVPgzz3Gzl/4EQwXy2uS2nQgHgyI2fUhLWEB5FMEQPLmbKNFCOiSDcVApMwk1za4u4Qo+4sO6XmsN/yKShaz/dscnbRkI4NX4cXNF8VQh7NqCa4nsWg/KChrXiUCSfKJtBDiSL7Qyi90v4VVRe05k7ITvPKLZe+G3EXZ8L+yoDOLOYy/DVNzgwtEGr+uUnvIxoPYuU8WAQgqjuHyYdiO13hlu6txYf/fk2U7A8tDtPZhXBDSLVB2QQ1OMp6Ju6b0oV9h/dPjR1nraFKcp40tY50xTRS3Q74kS+++WlUbK8LjO3uVAJe5U7/fbx/YsAYx5fTCJb7ljcV/xKWupIQOutPWccFSKW5jvshj1/GiVwiyXFGtL
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5278.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(136003)(376002)(39860400002)(366004)(396003)(6486002)(8676002)(54906003)(478600001)(316002)(16576012)(16526019)(186003)(956004)(2616005)(2906002)(4326008)(5660300002)(31686004)(53546011)(26005)(8936002)(38100700002)(66574015)(36756003)(31696002)(86362001)(6666004)(66556008)(66946007)(66476007)(83380400001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?eTR6SGYwSmJkRjNkM1hNdlVlS0lyMERlSXZyWjlTSDZZUUtMV2wzU1pHMjRl?=
 =?utf-8?B?OXZCRTFOd2VDZmJ6UXVNVWNTZm1RZlNoU0hqMWdUWjBqUmxpZm5BZmh5Zng1?=
 =?utf-8?B?KzJhUWhIVTY5VTNqazcvUmNRZFJ2OUJCcm1MckQ5dnBSSzl0bHArZEpXc0xY?=
 =?utf-8?B?SjcwMW8vczlCU3hPUWw1MUI2bmswOExhYjBSZTAxRlFnM2ZoMGo0eG5FUEp0?=
 =?utf-8?B?SGV0cXhWaFQ3MFFXL3JGaE04dks1eit5MFZXZEVxd0FMczNUS0ljNFg4Mlhx?=
 =?utf-8?B?eXVjTFJINHBxSVlVSnpvc2Q3bEI3QVNtNFRUdDFrVjdCZGNxTGl6TzVqRzdG?=
 =?utf-8?B?aCtxeWZXRzY2SFllQWg4R3lqdk9WNlFRcWppenR0NEZyQVY5WVYxbnJQWDFn?=
 =?utf-8?B?WWQ4M3A2OE05TS9YMU91SWxYVm0xWW9mTmNIMGdUOUZUSVBSU09jM2g3YWxB?=
 =?utf-8?B?VzBiY01WTjRTZCtZVlhUS0p5RWVrbUxJSmI4MTFFSnc1RVFvb05zbzhaaCt1?=
 =?utf-8?B?cWJHdzlhWVpzSnQ5VVpPYThCTXAwcTZoRHQrd3NDSnk1dm1pdmRrcmt1bVI2?=
 =?utf-8?B?ZTZKbDhQQlFxYkN3WDVYQnZHYVlvN1RWQ0l0UlZnYlNkU1d6aHpSUjBiQ013?=
 =?utf-8?B?UC9jdmIrRDJ2QTlEU25rSTdSQ1R5YzVSd2dNVlJ5bFUxVXpvVDN4MzZabDJq?=
 =?utf-8?B?UVZMWCtVQ1Izd1dTdkhmUWE0L1RtV1V0bHZXNGlGRlJQUGNlNTBsc0xUMEZU?=
 =?utf-8?B?ZTIwSmFlNThla0drVTgzMUtseDJXdEJ6T3pFTUFnNzNsOHNpUWc3M045M0oz?=
 =?utf-8?B?RWw5TzhVejY1TUtyYk5IcmkyU002VlN2d0xock0zTkZVcW9ZSFIyNXB3L2Vh?=
 =?utf-8?B?SWJoR2h6Q3ZNNXdiRnREMHlWQ245RCtJejg3MVgzUmNObGN4ZTA2VlE1VWVZ?=
 =?utf-8?B?KzgzZjNMSGtWbG1OeCtVT2o3ZkdIZmRpbDVjY1NuTW5NS3krRS9ZYllmU3Rl?=
 =?utf-8?B?cWhFWmFOZktxaS9OUEFaK0xsWlYzSzhQcm5idkJLVXdnYU52UWlUcTJrWWEy?=
 =?utf-8?B?UlovZGphZm9wYmhpOU9CVCtIcU41MGluNEhXVFpkcDVkY3NHanh2M0o3c2tj?=
 =?utf-8?B?L3NCWEZneCtiNGk2allwYng4NzJlcUplMEczd1YxSEcvOVc1bzFSMzJrbDNS?=
 =?utf-8?B?ZUswN1hvSFNRT3RHYUFwT1RxQ2o3ZzBuZEdlWWZlZUEzeW56Y1ZlSWJUYWZp?=
 =?utf-8?B?aXJXcFQ2QlhpaXNMcTR4QUZ2cFFQUGhpWFZxbHAxeXhwY05qZnFqWDZrRXQ1?=
 =?utf-8?B?U2w3SCtqNnJjM2dCMEQ0eG1MajJiRzdGSzBZam9ma25EdWdOaGlwUURBaGNT?=
 =?utf-8?B?OEVUaUE0cFgrd0s4M1N4aU1nK3drRnljb25JNFNiY2VGdXRZZzB2dXB1cTBX?=
 =?utf-8?B?VlpzNm5Ta3BCRnQ0dThLOG11RTUySGI5a0hNMlpwSUduZUZlczVtYTc5UFZo?=
 =?utf-8?B?ajVGZ1JPTXdKNjFSdG9ESGhINmVsdVQ5dTh0bGdURmtVdXdjN3htWk5aRXFS?=
 =?utf-8?B?SVhidU8zSUNZaTVKNThtdWViUEtqYnRjejRIOGJ4VkM5Z1NVcEhvK1UyNTVF?=
 =?utf-8?B?QUNKSkRPZDFyRzZpc3NhWUlXU0JKdHhrSDcrbExvaHh6UGw4dy9oVDVhNzc2?=
 =?utf-8?B?V3N0ZSsyWUhDb3l5OGRVYjREdHpSUHEzTTJ1VEVOakZpdVcyUElSWUUzZitG?=
 =?utf-8?Q?j+ZFIKUgWwVBPDe0O2uYxzEjN1IfP1dvh7zvY1+?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 267782ce-ef72-44fe-ffb2-08d9145e71ef
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5278.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2021 09:23:32.2134
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6VieaMAypGIxUSTXcotuaV/u/C+MvtepqBXnnEN6hgDao/h8NdtrbH1StbIoFK4qjQfSHfXNVachr6lJVJ+oqQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5326
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 09/05/2021 22:45, Linus Lüssing wrote:
> To properly support routable multicast addresses in batman-adv in a
> group-aware way, a batman-adv node needs to know if it serves multicast
> routers.
> 
> This adds a function to the bridge to export this so that batman-adv
> can then make full use of the Multicast Router Discovery capability of
> the bridge.
> 
> Signed-off-by: Linus Lüssing <linus.luessing@c0d3.blue>
> ---
>  net/bridge/br_multicast.c | 58 +++++++++++++++++++++++++++++++++++++++
>  1 file changed, 58 insertions(+)
> 
> diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
> index b625fd6..e963de5 100644
> --- a/net/bridge/br_multicast.c
> +++ b/net/bridge/br_multicast.c
> @@ -4061,6 +4061,64 @@ unlock:
>  }
>  EXPORT_SYMBOL_GPL(br_multicast_has_querier_adjacent);
>  
> +/**
> + * br_multicast_has_router_adjacent - Checks for a router behind a bridge port
> + * @dev: The bridge port adjacent to which to check for a multicast router
> + * @proto: The protocol family to check for: IGMP -> ETH_P_IP, MLD -> ETH_P_IPV6
> + *
> + * Checks whether the given interface has a bridge on top and if so returns
> + * true if a multicast router is behind one of the other ports of this
> + * bridge. Otherwise returns false.
> + */
> +bool br_multicast_has_router_adjacent(struct net_device *dev, int proto)
> +{
> +	struct net_bridge_port *port, *p;
> +	bool ret = false;
> +
> +	rcu_read_lock();
> +	if (!netif_is_bridge_port(dev))
> +		goto unlock;
> +
> +	port = br_port_get_rcu(dev);

You can combine both of netif_is_bridge_port and br_port_get_rcu() checks and use
br_port_get_check_rcu(). Then you can also drop the port->br check.


> +	if (!port || !port->br)
> +		goto unlock;
> +
> +	switch (proto) {
> +	case ETH_P_IP:
> +		hlist_for_each_entry_rcu(p, &port->br->ip4_mc_router_list,
> +					 ip4_rlist) {
> +			if (p == port)
> +				continue;
> +
> +			ret = true;
> +			goto unlock;
> +		}
> +		break;
> +#if IS_ENABLED(CONFIG_IPV6)
> +	case ETH_P_IPV6:
> +		hlist_for_each_entry_rcu(p, &port->br->ip6_mc_router_list,
> +					 ip6_rlist) {
> +			if (p == port)
> +				continue;
> +
> +			ret = true;
> +			goto unlock;
> +		}
> +		break;
> +#endif
> +	default:
> +		/* when compiled without IPv6 support, be conservative and
> +		 * always assume presence of an IPv6 multicast router
> +		 */
> +		ret = true;
> +	}
> +
> +unlock:
> +	rcu_read_unlock();
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(br_multicast_has_router_adjacent);
> +
>  static void br_mcast_stats_add(struct bridge_mcast_stats __percpu *stats,
>  			       const struct sk_buff *skb, u8 type, u8 dir)
>  {
> 

