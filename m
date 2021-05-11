Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32AD337A325
	for <lists+netdev@lfdr.de>; Tue, 11 May 2021 11:12:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231300AbhEKJNv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 May 2021 05:13:51 -0400
Received: from mail-mw2nam12on2048.outbound.protection.outlook.com ([40.107.244.48]:9269
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230474AbhEKJNu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 11 May 2021 05:13:50 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b7V/vXzY0QHKYHpwJtn+1RfAw/h8ac/bikNfCkBaX/XEFWDOGG0SGB4YO1UIaggBBeW7S1FMorg9X8oJXuWszk9YRUjn9C2r0TLsHOjSoRF/yqNO+PRfNf7jWVHn8itAvWoC+jQSAKoMpXfs3+ormbAs+hVEgR1T6WFwvt4fLNjNDNlEIkFFepMYLazjqnxgRPTwwwYyX1DaPL9i83j85ynt+75yf7lyobB1dbpamF0A/jPquhUhPU3IpyEGV66y52u3GscCfRy2droKdqUG+Dtt0hSbJxayTv8IRctdjNPkjBpTvTgAnFu68PV2UTPDne/EypIkuZ7Jz1D0JMu24Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tnHV5mJNnwgq/koCsth+OHwF0qvxxSoE41hzLBBf3f4=;
 b=Wjo1H9JxKKvtF3igrgiov5FP0PHMRqsY6Kr8wkBZ5VCU8+O8OHgqmkhhBmVvEiJaJvMOdDtIOd56lBb5lM9wAmv9zkQ4LgWI4Vd8fcA69Yc2jydPmjVptgc/zRbCs+KOtiotXtgKxuTUp3T9sUauZf+JI8BAe6n86gxLnRlWX4VhbxPy+paEJ9CMTg0YQIdkbhpfH+9067iKB2v1BS6Ox5PKy3HYmO/cMFO+iFwcGntb+hLu/k4ISkp/kvADcGC1LzCeziGMJ03OsAPzsvy4dm/+tv+FZFbFlN49if18yv8vjIdZtv/L7/JIXQPllAkui7n2ZZqWqCWRw07nrbLc8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tnHV5mJNnwgq/koCsth+OHwF0qvxxSoE41hzLBBf3f4=;
 b=TaN2A0vg3d9w9dbXcQmcPA5d1mn7cM37G77LRleKGROWOvwSmhxav+aMOAoKLcfEVEqGFhAulhAk5pv5hdmsRdgxh8ZyjPfswXUHityz5pD6m3NbOy8vr3C3MjcdVs2f67kbyzcrY0OJKqE4TUHJief+SU7IQHfmnIZfMBIs9PH8zk1m1NbU89LT6hyQlBcvOoFGmP12u5Gr1cT9HPe2IicBQG1ZB3VceE4ww2YAi6Qs2mKM2FjM8kobp6wXXzjaSF0b7Q2oKZBDJ3n0DSrQU7WEEfETuC2Rp66Uoup3hyZi47OTrmL2VBbtJ2U7IJ63NImyr49Wvos2tWPExroCFw==
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB5278.namprd12.prod.outlook.com (2603:10b6:5:39e::17)
 by DM4PR12MB5183.namprd12.prod.outlook.com (2603:10b6:5:396::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25; Tue, 11 May
 2021 09:12:44 +0000
Received: from DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::d556:5155:7243:5f0f]) by DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::d556:5155:7243:5f0f%6]) with mapi id 15.20.4108.031; Tue, 11 May 2021
 09:12:43 +0000
Subject: Re: [net-next v2 02/11] net: bridge: mcast: add wrappers for router
 node retrieval
To:     =?UTF-8?Q?Linus_L=c3=bcssing?= <linus.luessing@c0d3.blue>,
        netdev@vger.kernel.org
Cc:     Roopa Prabhu <roopa@nvidia.com>, Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        bridge@lists.linux-foundation.org, b.a.t.m.a.n@lists.open-mesh.org,
        linux-kernel@vger.kernel.org
References: <20210509194509.10849-1-linus.luessing@c0d3.blue>
 <20210509194509.10849-3-linus.luessing@c0d3.blue>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
Message-ID: <971325eb-b0e9-d1a8-b7a1-b8a2b30fc267@nvidia.com>
Date:   Tue, 11 May 2021 12:12:35 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
In-Reply-To: <20210509194509.10849-3-linus.luessing@c0d3.blue>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [213.179.129.39]
X-ClientProxiedBy: ZR0P278CA0060.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:21::11) To DM4PR12MB5278.namprd12.prod.outlook.com
 (2603:10b6:5:39e::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.21.241.170] (213.179.129.39) by ZR0P278CA0060.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:21::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25 via Frontend Transport; Tue, 11 May 2021 09:12:41 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ded8465e-587a-4f8d-b107-08d9145cef8d
X-MS-TrafficTypeDiagnostic: DM4PR12MB5183:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM4PR12MB5183DE9C309189A448C94F00DF539@DM4PR12MB5183.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KZM0J9w7a+rjeDOVVVL5HDaDTHxWS0KxCUbOURjbt7ESRypZJrcmkmkNAiNV0YxNAn7bUNVIdZNAvvtIjTQCRwC3wxvZ51wqZKlYg0jNP5hzz59wG+6Td02EIS/zyAZT0TJzY/1nwZaUI0M98ltO6noVZlc2wZpdlRnbpHiQmtjhVf0H2ajGHcdczll6kSm7kEeBNdOw19j8EL0rHPVCxMsP7KbLZHE+peMyMgNf2XL3oRqm0DNCh8wafkN7b61Pafixtj9IrC/JS8GpwrJHzGKrE99ZNWBzvxdD2buBVN1cSRDu7HftHQRuSIB8h837DMAhZBXuR20jHGvKdxyVKr1vmEAKmPi5dsqF3+BOwb2zddsdLBcJ26PPfU7oB2Qov1oJPVMGS1or7IeP8Zj5neIMGhWzB8Ef6wE7QT86T6LtvkPZULHTbv79t+TELqjFAIUkt0qtz7t9pSyFGWOMf20Aiquzq74GjiSvACOIEMFsB+OcVx9jML7LlhU60NO4ZV4lw+HPrnysHbkQ0bOtfNnURXUM8oiWUS+JVOX42oJj1UXeuhQOD1G5Mjdol4rWSM7PGsDw0lN0TPZy+KMY0yUTmZNXW2IYSC8vr/dNWT3j5ObEQrPeVR6RCiy/q8j5W+LV91SOf7aZ1i93/ayYwFPD0QIzI+vteuPxPw28kgogAmkSm90udKZgg7Ub+oT7
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5278.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(136003)(396003)(346002)(39860400002)(376002)(54906003)(8936002)(66946007)(5660300002)(36756003)(66556008)(8676002)(316002)(16576012)(6486002)(66476007)(26005)(186003)(31696002)(16526019)(86362001)(6666004)(31686004)(38100700002)(956004)(2906002)(66574015)(83380400001)(478600001)(2616005)(53546011)(4326008)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?eEJueHNqWVhaZ3lJZEp5N3o4UER0OXR6R0VxL1ZOMFB6YkU2SUg0Snl3S3JM?=
 =?utf-8?B?Y09NYml0REVQNVhzMVFZaE5LODA5eXBpK2xYV0UwcFYyVDNSMFhmRkEwd0J0?=
 =?utf-8?B?cGVHZ3pmckIwNjFKUTV3TkJUQ2loSUgrbnBHZ1IzWGx6RFA4S01MRG1rYUJS?=
 =?utf-8?B?NFV6b3dNMmxQR0M3RnVrRGY3TzdpcmRJWEJyU3cvN1lmRFgrR2JRYlIrdjU1?=
 =?utf-8?B?WGI2dHozZXNpOTJWdDNNUlMzemFkbnFsN0VRUmd1b1NEZUQ4NmVHYjBySUVU?=
 =?utf-8?B?NlpCamd3cHhVVGtGdk10Mk9INHF5NnlBckJuYUJ6SCtkYi9LQ0pxaG9EZGJp?=
 =?utf-8?B?MDgxRHZFbWE5YnU1UmVkL1h0MHdMYVRESXFWS1haNkc4b2RwYit6clRsVlhN?=
 =?utf-8?B?VmpQQXpqVXpaZWtIbFMwR3gvcnFmYVRjUDkyYlc3MW13Y1IrMm1nWHJxczNS?=
 =?utf-8?B?VGJNMC9rUFZGQ3NwcmlhVHJlazZ6NzZNZUViWlZIK2IydHhBRzdKWUhVU3JD?=
 =?utf-8?B?RGlLZCtUOTNmaDByampxbjl6eVhNQ1M5NWN3R2gxc1RwR0dFUDdaTkdIekNV?=
 =?utf-8?B?SUpaZlh2VkZDWUxmeXFDZ3U0RTcwRTltR3FmM1o5aEtQMC9RQ2NVZXVWQlRo?=
 =?utf-8?B?MXhnZlk0SnFETTlKK01WK0doRkdMZnJxcXRhRWIzang1M1lqRFd1eHNPZ1gr?=
 =?utf-8?B?RW9xYm4zMDl1aWxVV0xBbloyMmZZZEdLNW1Gc1hoejNJQzV3QmV3dW9UMFB3?=
 =?utf-8?B?ckdFR0ltTXlFTjc0WG1nYmRTUm1vQndUanRtNDYrd1kzSlBBNXVVekxNdWk3?=
 =?utf-8?B?M3lGU0FZRmEyaVc2VWFsTTdFVGVPTjhYMU8wd3FLMlRaSTR6VlNkeHBzZzlX?=
 =?utf-8?B?V1hUa3BvMEhlQkYyZyt1dFUvOVhzS0lMSUlrdUFlVkg1bHF5Y1BsdFJ0WUhO?=
 =?utf-8?B?UlpCYW5DMll0R2ptcjVZd0VXbHFMTHJsZy82SXF5MUlVRDNoUGttTlkxNXgr?=
 =?utf-8?B?ZklZZXIxdnhHeGdmU1RXN2o4dmNkRkFHa1dwVC9aZnhWVFVpeUtlUm5YTjBr?=
 =?utf-8?B?R0tVaUVqS2d1cmlnRHJ2NzUxaEtuVHpvbDBxVmhVcmlJNnB6QXB4Wnoybm1B?=
 =?utf-8?B?cVBhVVpDakR0RTZyNndRdGJUN2V5eFZ4a2V3Ym1ocndNQ3RORHJ1b09yU25T?=
 =?utf-8?B?dTNiZlJUVzNpYUJPY3BYY0o3NmI5OUdwNzNOQ056Nndtek1vUWUxc0hwSVda?=
 =?utf-8?B?elU2M1VJK250NHlQNklxZk9USXZ3Z1RocDRlUHJCaENNOERIUHFsT21admlx?=
 =?utf-8?B?dWZTNTVYZkFQRTJCS3FMRkY3YkRHZmR2UFJRcHNYL1dsU0VNakFBRlZmYVh6?=
 =?utf-8?B?S2hjZmhzNzcwV285RHVZU2VFa0FzcWZFbHl2MThEY1E0NmlXdFFncHBqajc3?=
 =?utf-8?B?RGpkTWl4K0Z5ZVd6elJPd0E3dVJlTnpGMWlrSUZLQi9wQVhPTGhJaVI4U3hH?=
 =?utf-8?B?dkZLOWxhQWpVZXhyZGR6bXp4YUY5OHJrTTZYdzU3cDNLWkUyczNvQXZuenpq?=
 =?utf-8?B?bTVQOXdpK0VNUnZKaEhoUGlhelpHZnlRUk1LQ0xYek1Jdis4azk2UDB0U2N3?=
 =?utf-8?B?MTRLUE40QitaVlVocENGUktVSzNjeGtsWk1VZy9PeXMwNmVqZUtIU0c3K1gw?=
 =?utf-8?B?SHM4QzRKTm5zZUc5bWZOeWVHL3ZFMmhJR3A4a0RFcjVPRjBLWHdlakNYLzFn?=
 =?utf-8?Q?RMB2/uOOxOfjN2M7aGKli5wxSkJ4nfQ0+CEfBJ3?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ded8465e-587a-4f8d-b107-08d9145cef8d
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5278.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2021 09:12:43.9198
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +0hQvjiglya7Jv3bh98tMfujcGCkkeWusuaopJ1NGrrzJ5Le/qzyZTu4ka6ZHj5xTzGW8NfQo/333KGiqbwFmw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5183
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 09/05/2021 22:45, Linus Lüssing wrote:
> In preparation for the upcoming split of multicast router state into
> their IPv4 and IPv6 variants and to avoid IPv6 #ifdef clutter later add
> two wrapper functions for router node retrieval in the payload
> forwarding code.
> 
> Signed-off-by: Linus Lüssing <linus.luessing@c0d3.blue>
> ---
>  net/bridge/br_forward.c | 15 +++++++++++++--
>  1 file changed, 13 insertions(+), 2 deletions(-)
> 
> diff --git a/net/bridge/br_forward.c b/net/bridge/br_forward.c
> index 3b67184..b5ec4f9 100644
> --- a/net/bridge/br_forward.c
> +++ b/net/bridge/br_forward.c
> @@ -264,6 +264,16 @@ static void maybe_deliver_addr(struct net_bridge_port *p, struct sk_buff *skb,
>  	__br_forward(p, skb, local_orig);
>  }
>  
> +static inline struct hlist_node *
> +br_multicast_get_first_rport_node(struct net_bridge *b, struct sk_buff *skb) {
> +	return rcu_dereference(hlist_first_rcu(&b->ip4_mc_router_list));
> +}
> +
> +static inline struct net_bridge_port *
> +br_multicast_rport_from_node(struct hlist_node *rp, struct sk_buff *skb) {
> +	return hlist_entry_safe(rp, struct net_bridge_port, ip4_rlist);
> +}
> +

Inline functions in .c files are not allowed, please move these to br_private.h

>  /* called with rcu_read_lock */
>  void br_multicast_flood(struct net_bridge_mdb_entry *mdst,
>  			struct sk_buff *skb,
> @@ -276,7 +286,8 @@ void br_multicast_flood(struct net_bridge_mdb_entry *mdst,
>  	bool allow_mode_include = true;
>  	struct hlist_node *rp;
>  
> -	rp = rcu_dereference(hlist_first_rcu(&br->router_list));
> +	rp = br_multicast_get_first_rport_node(br, skb);
> +
>  	if (mdst) {
>  		p = rcu_dereference(mdst->ports);
>  		if (br_multicast_should_handle_mode(br, mdst->addr.proto) &&
> @@ -290,7 +301,7 @@ void br_multicast_flood(struct net_bridge_mdb_entry *mdst,
>  		struct net_bridge_port *port, *lport, *rport;
>  
>  		lport = p ? p->key.port : NULL;
> -		rport = hlist_entry_safe(rp, struct net_bridge_port, ip4_rlist);
> +		rport = br_multicast_rport_from_node(rp, skb);
>  
>  		if ((unsigned long)lport > (unsigned long)rport) {
>  			port = lport;
> 

