Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 206F737A33F
	for <lists+netdev@lfdr.de>; Tue, 11 May 2021 11:16:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231132AbhEKJRc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 May 2021 05:17:32 -0400
Received: from mail-bn8nam11on2072.outbound.protection.outlook.com ([40.107.236.72]:5912
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230427AbhEKJRa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 11 May 2021 05:17:30 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YJ2S9z17O2DUEQL8sRjg1HEZa0d04xJwtnvXjFjS03kNF2cjxscRWra8q+FGf7NW8Psj+K4ZchootzV1mKbT7KLBPAA4S/6PcrU4dm5sNIKHfIW8UbWWUNb0DlDotVi0PVqnDMdvLjUz/hG7ZDtErJIEMeRPxyezMXX753EvESFytS29XDHRgXXndVTMWz9L5J3MCfQOfEXdLdlEFeRrpsupmdD2LH4GzD3162uWKx8mNz44EOOpcFc7gJbVhfIO2FPIamrOJRfP7eu//IrjbW2EPkGObrvBUmtnXy0WPt9+PpAgAjknObGSrMZuQwiuYFAGwDrfjs3uOD9kSP78+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J4XkyP1TlrLUN1TwDhG55u0q1y3824PO14R1vE3XBGw=;
 b=FxlIadZa6+bbXHXOl5wQPBQsiTRWzFk2JfZN/Lf58wuFYgcTTBZ7MToyZvOPIT+HotQIC+3/R/RoRRtB53JfwLlxsbyW+2ox4NQBZ3XZ4b9Cwh/MD6eCqJ9NT9WNFWBRYtJppyybso3OA7u5DcH/2HS0SO6rW6jyoqm/ewAmn0wtup81wkWGVyl5uo2ULixuSTLTku2qbSBEp3ZD882GfGf6WR2l1L0Te3GtQjfoOurZGesLVyzlfoBWxo8qHlMyaJvWyA+5A9R7v8+H5lGau6ReAeFtWniwJjAc36bFc3PBnSQAA2Ir79cHgHz26lIGWNdy6rgzVm+HQ6VSPAw/Lg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J4XkyP1TlrLUN1TwDhG55u0q1y3824PO14R1vE3XBGw=;
 b=mxjAl1nPu1KJqWfPJqvNKiuEXyIVBT3VW1oMVMOpEWNeBuW27cFRzwdRe/xAtLxNqyaQRVq8Cdz8/OmXj2s9ysRi5G9aV+OtSjNGL0pq2/Gr6dvUJkij3wBQiAbrq3IcAQAyjD4+dGJd6EkX1zZOHE68kIUdtJUDQcWnRStjAqpAfyiM/iNl6HzwBjRENXZFlHE+chYgzkIBYqJImHWs8fZ15k0Nw1AH92OIRGfcnChewpAeorKYTJrylt0J4LFhh6Ly1M1Av+yz6YJJyIfjjZe6Ic1eRPaVrDmunoZv8h6CNj8EHq2D51e5lKwBCRWrglwxbgmZKngF/iCCgEyOyg==
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB5278.namprd12.prod.outlook.com (2603:10b6:5:39e::17)
 by DM4PR12MB5326.namprd12.prod.outlook.com (2603:10b6:5:39f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.25; Tue, 11 May
 2021 09:16:23 +0000
Received: from DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::d556:5155:7243:5f0f]) by DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::d556:5155:7243:5f0f%6]) with mapi id 15.20.4108.031; Tue, 11 May 2021
 09:16:23 +0000
Subject: Re: [net-next v2 05/11] net: bridge: mcast: prepare is-router
 function for mcast router split
To:     =?UTF-8?Q?Linus_L=c3=bcssing?= <linus.luessing@c0d3.blue>,
        netdev@vger.kernel.org
Cc:     Roopa Prabhu <roopa@nvidia.com>, Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        bridge@lists.linux-foundation.org, b.a.t.m.a.n@lists.open-mesh.org,
        linux-kernel@vger.kernel.org
References: <20210509194509.10849-1-linus.luessing@c0d3.blue>
 <20210509194509.10849-6-linus.luessing@c0d3.blue>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
Message-ID: <6a7f2310-3b15-2a60-803b-6a9abafe5612@nvidia.com>
Date:   Tue, 11 May 2021 12:16:16 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
In-Reply-To: <20210509194509.10849-6-linus.luessing@c0d3.blue>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [213.179.129.39]
X-ClientProxiedBy: ZR0P278CA0125.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:20::22) To DM4PR12MB5278.namprd12.prod.outlook.com
 (2603:10b6:5:39e::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.21.241.170] (213.179.129.39) by ZR0P278CA0125.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:20::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25 via Frontend Transport; Tue, 11 May 2021 09:16:20 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9ff79af9-7437-4ba5-5485-08d9145d721e
X-MS-TrafficTypeDiagnostic: DM4PR12MB5326:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM4PR12MB5326049E1A73FEC0BD3EB33DDF539@DM4PR12MB5326.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5a6UZTtOpbwWqHSdBZveYNGskwNpuJsfT5OJySUcXAwvRQkCv+jSO4kQM65LzLjf2awOgZqEGT/0FdZ7oJZ1XfUBEPK5Z73CgFjZwn3KUos7rbL6WbOlzALNRyQf7CGgb3wJXl1BDASVxxuv7pO3+sWeQkdwQv4HkuCpdJHcDmL+dd42JijkggbQFK2GeSHJ9rY1pdQs4VOY8z+C4xY9BWPYbXa8QLUo+9128OFwvR7hiLICXWIQJ0IiFeEd4D1TWYZpQ7E+1SZ6kBha8WBgYMFuLrGnBed+saIJNWqBVRjxTinoeHeXBOkpEF2IBngDJsFH+XVt6lv5nwDjfYXqRDJ4qBOa53hYsYKHg02KOHRMvWtdkmRXr2XYhHlGbkIZ9Tx9vIGKm7BBDCYQauh6E3XUjZ/A9YJQDV64CGNAEhuAg4ATfAswO7IwSopmLLNJmQ41zhsiyGUQtIgNS8aClF7xdrcLEHyDBE5rCII1x+3Hi3E7vbG/acXW1avv28odrlveqkwo504QtWesu0mi4wH9XempplsA3tujCqQiMk2kZZMcvVhvCiy5Ht0SYBBlktpYKz88tNGoCayD0SPBX58nMJrTrgEoGJ+O7hh/qZ71qpjXHTXrZWZSEEma0eTjL14mJ4Cc8dlOOC7dEo335QMkLKCuQZr9bfi2TMstFc17nPP609LKw0ThugR0bAOf
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5278.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(136003)(376002)(39860400002)(366004)(396003)(6486002)(8676002)(54906003)(478600001)(316002)(16576012)(16526019)(186003)(956004)(2616005)(2906002)(4326008)(5660300002)(31686004)(53546011)(26005)(8936002)(38100700002)(66574015)(36756003)(31696002)(86362001)(6666004)(66556008)(66946007)(66476007)(83380400001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?dHpOUTcxYzZVYUFNeUhVZGJOa3ErSGN6ZmxQWGxpbnl0d1pBVlY5UmlWSmxl?=
 =?utf-8?B?SXJ1OEFFUmJwaTBTRmdCQThUM2U5a1BIMXp0SHFCMlE2Zk5EREZJM25FMWYr?=
 =?utf-8?B?ZGVNaVpiTXlmQ0NUWE1ScWZwS3A5YkF1cDVIWU9WZFhzOEZ3VWVMS0NjR3o0?=
 =?utf-8?B?ajArSVJGeThjL0RjVjFJRDNLLzJFMHJWWkVBVXBaV3l3YjFyM2dVbk1zM21X?=
 =?utf-8?B?MExJU09pQzZmSXhhKzQ5ZXBXNExORytINWxGTEJ6MFNUeUxuS09JeGswN0J6?=
 =?utf-8?B?TVg5c3ZTaStpclAxOU1OV082Q1RFdGlvdFpRU05rSWkzaXZDR2NJMXk4UnZJ?=
 =?utf-8?B?ajFqcUNmejJxT0FFWlBpdVIyakh3MmdGSGdEYU1VNGN0TnljVjVzUldtZVR5?=
 =?utf-8?B?aTA2S3JvdkpqZ2JkQkxtdFA3dnoxQ2xtc0xkQXpvSkNrNjgyaVB6UXRDLzhy?=
 =?utf-8?B?TC9ydlI0bjZkaEVFcHdyMFd0TFVORk14dTRWb0dPcVRmZWs5OFMyUmQxR25F?=
 =?utf-8?B?OHhaQjhaQkxkTUYvRUhOZENBOHpLZHRZM2dJQnVlTWl5OGNJVTBjQmtSMmFN?=
 =?utf-8?B?S2lmTmVKVElLVkJFU011Q1FWcjVsalprQVl1ZFZxd1IxZHlpVXFmYVZ4ZjdD?=
 =?utf-8?B?ZTJGYndrTUE5cWEvZG1qRzVWams4U3A3RGc4Y0RnLzVmMWxzN2ErZW4vWW93?=
 =?utf-8?B?aktMRy9SNm43M09NRVlieVhhcjN6c2s5ZmVKZVQxaGNKWlhUa0E5dDJuTUdo?=
 =?utf-8?B?VFNuaFpzbTRkSzVSTHFzSnU3WkNZdzdpZEYvUFFOOEhDZWZLWndCVUNzdGxo?=
 =?utf-8?B?ZzVpbmxNa0pwMGFSdU44c0F6UURmL0lMVXAvb3Q5SHhUUi91WHVvdkdLdHRn?=
 =?utf-8?B?N1VZVG84T1lsdTF4ejJqL1VLRlI3QkhPWXloTERtdnNpd0pUK0diaDM5dTNK?=
 =?utf-8?B?M1pQSVpZeng1UitJOUdpeDRXNjF1eFpIYzFHSmxpcSt0RzZFN1FIVHVkMDIw?=
 =?utf-8?B?OFVtQkFnYXlZQkpiTHVIWHlVT3RVVCtkWVQ3Qk1BMFJ4ZEM2K2tid1h2ZlQ4?=
 =?utf-8?B?b21FZkZGM0h6ZGY1OTlaTXU2THVrWXRBOU43Zzd0T2crbDh6SUNNRGdWdEdL?=
 =?utf-8?B?dFEvSXdFUERtY0g1bVNoMjY4VkZPRW16UWgzU1gxL0FZK0xrYmVseDJTak1K?=
 =?utf-8?B?M0JRdksxekpzTnJpdmlQRno4ZURyb0J6eFNwTHltRDhJUW1aWVZXd3lQUWVp?=
 =?utf-8?B?Zm1rRXZkODVLV3h6S1lmQW80OEFFRnFSOFdKTEU2TjFFQmJmRDcvdnRKUlJ5?=
 =?utf-8?B?Z0pZN1p6SDBzYnlIZ0JmWUhObWlMUnJoZmhNK3FjY1FoQ09GakFGQ210WUYy?=
 =?utf-8?B?K3ZvanBqWHFrR3htRkNUdkxwbFV6L0k5Zkc3ZVJqeG9veHk0bTJMSW5KbnFU?=
 =?utf-8?B?YVkvMXZpWWZXaCtOK09pMUxabjdnRDRqNm15V3RTWHRMK1Zic014S3dpOFpH?=
 =?utf-8?B?ck9oR1pYVUl5VmpGUDdZTTdnTU5mTSthSUNPZVZJSnRYY2NnR252dEsxN1Qz?=
 =?utf-8?B?VThiK2N4dmpTNi96elAvVFNYRzVyOWk3VjZwdDZaWUJDcStRWW5UUHYvaEpT?=
 =?utf-8?B?S0k4L2ZuOFNhQzBpamdZVkV5RkprOFgvZW1mbmlsRjNrdXdUV0NveGhhTDZQ?=
 =?utf-8?B?dzNKakhIU2VCUk5STnVzaE1kQnI5NjRiWWdMNlBSM1k0ZUNRYjZqeHdRV1lk?=
 =?utf-8?Q?YYUVqQduShuvLEEqAs3pRncpPs6byD80UeEzEZj?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ff79af9-7437-4ba5-5485-08d9145d721e
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5278.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2021 09:16:22.9705
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: plj6bjkOVq1Jax1iz0QTYokUFpdanEFhRWn04gbkQzDHqTv1+E+KAw0PmVOfd0xdVdFdS7dbg7Yn6vwEs1q0YQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5326
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 09/05/2021 22:45, Linus Lüssing wrote:
> In preparation for the upcoming split of multicast router state into
> their IPv4 and IPv6 variants make br_multicast_is_router() protocol
> family aware.
> 
> Note that for now br_ip6_multicast_is_router() uses the currently still
> common ip4_mc_router_timer for now. It will be renamed to
> ip6_mc_router_timer later when the split is performed.
> 
> While at it also renames the "1" and "2" constants in
> br_multicast_is_router() to the MDB_RTR_TYPE_TEMP_QUERY and
> MDB_RTR_TYPE_PERM enums.
> 
> Signed-off-by: Linus Lüssing <linus.luessing@c0d3.blue>
> ---
>  net/bridge/br_input.c     |  2 +-
>  net/bridge/br_multicast.c |  5 +++--
>  net/bridge/br_private.h   | 36 ++++++++++++++++++++++++++++++++----
>  3 files changed, 36 insertions(+), 7 deletions(-)
> 

Minor comment below, but either way:
Acked-by: Nikolay Aleksandrov <nikolay@nvidia.com>

> diff --git a/net/bridge/br_input.c b/net/bridge/br_input.c
> index 8875e95..1f50630 100644
> --- a/net/bridge/br_input.c
> +++ b/net/bridge/br_input.c
> @@ -132,7 +132,7 @@ int br_handle_frame_finish(struct net *net, struct sock *sk, struct sk_buff *skb
>  		if ((mdst || BR_INPUT_SKB_CB_MROUTERS_ONLY(skb)) &&
>  		    br_multicast_querier_exists(br, eth_hdr(skb), mdst)) {
>  			if ((mdst && mdst->host_joined) ||
> -			    br_multicast_is_router(br)) {
> +			    br_multicast_is_router(br, skb)) {
>  				local_rcv = true;
>  				br->dev->stats.multicast++;
>  			}
> diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
> index 7edbbc9..048b5b9 100644
> --- a/net/bridge/br_multicast.c
> +++ b/net/bridge/br_multicast.c
> @@ -1391,7 +1391,8 @@ static void br_multicast_local_router_expired(struct timer_list *t)
>  	spin_lock(&br->multicast_lock);
>  	if (br->multicast_router == MDB_RTR_TYPE_DISABLED ||
>  	    br->multicast_router == MDB_RTR_TYPE_PERM ||
> -	    timer_pending(&br->ip4_mc_router_timer))
> +	    br_ip4_multicast_is_router(br) ||
> +	    br_ip6_multicast_is_router(br))
>  		goto out;
>  
>  	br_mc_router_state_change(br, false);
> @@ -3622,7 +3623,7 @@ bool br_multicast_router(const struct net_device *dev)
>  	bool is_router;
>  
>  	spin_lock_bh(&br->multicast_lock);
> -	is_router = br_multicast_is_router(br);
> +	is_router = br_multicast_is_router(br, NULL);
>  	spin_unlock_bh(&br->multicast_lock);
>  	return is_router;
>  }
> diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
> index 26e91d2..ac5ca5b 100644
> --- a/net/bridge/br_private.h
> +++ b/net/bridge/br_private.h
> @@ -864,11 +864,39 @@ static inline bool br_group_is_l2(const struct br_ip *group)
>  #define mlock_dereference(X, br) \
>  	rcu_dereference_protected(X, lockdep_is_held(&br->multicast_lock))
>  
> -static inline bool br_multicast_is_router(struct net_bridge *br)
> +static inline bool br_ip4_multicast_is_router(struct net_bridge *br)
>  {
> -	return br->multicast_router == 2 ||
> -	       (br->multicast_router == 1 &&
> -		timer_pending(&br->ip4_mc_router_timer));
> +	return timer_pending(&br->ip4_mc_router_timer);
> +}
> +
> +static inline bool br_ip6_multicast_is_router(struct net_bridge *br)
> +{
> +#if IS_ENABLED(CONFIG_IPV6)
> +	return timer_pending(&br->ip4_mc_router_timer);
> +#else
> +	return false;
> +#endif
> +}
> +
> +static inline bool
> +br_multicast_is_router(struct net_bridge *br, struct sk_buff *skb)
> +{
> +	if (br->multicast_router == MDB_RTR_TYPE_PERM)
> +		return true;
> +
> +	if (br->multicast_router == MDB_RTR_TYPE_TEMP_QUERY) {
> +		if (skb) {
> +			if (skb->protocol == htons(ETH_P_IP))
> +				return br_ip4_multicast_is_router(br);
> +			else if (skb->protocol == htons(ETH_P_IPV6))
> +				return br_ip6_multicast_is_router(br);
> +		} else {
> +			return br_ip4_multicast_is_router(br) ||
> +			       br_ip6_multicast_is_router(br);
> +		}
> +	}

Personally I'd prefer using a switch statement for br->multicast_router.

> +
> +	return false;
>  }
>  
>  static inline bool
> 

