Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 951D241B243
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 16:41:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241340AbhI1OnQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 10:43:16 -0400
Received: from mail-bn8nam11on2053.outbound.protection.outlook.com ([40.107.236.53]:34142
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S241270AbhI1OnP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Sep 2021 10:43:15 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aQgSAU1nY8KIc0GpQkxqW9T+Ag5b1AYYjMUt73aYxdsWThYqf6FllZALrES9yJpV4GFD1ym5ZM/zL9MHIfBWs/rxdNzv/0qtN9ktufdgufjpKb8TwRGJE7OB9G/Gpr5963eN1tjx3MhkYfHK8d+Hsv5DU5RgB3R1PJxurWjx0F7TDQU1WHJfXfDe2p1OEu2UAzYvy7sFni9qCcg7MHGKAU5OYFY1E+JRCZ66GB98Db6IrZPrfoPkylP3456LHgHyZxPgVUjcIzmVzs+MSY3Gpf6je9byfRKXebbS4lovc1t5wGPc7AQ/MX5Kumb4EHQu/HkI5TB5jeb55sNcW/5vsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=UIwQ9/TafDLoAJVWfcXzWWen5B7h2Hct5LhSIUHQr6k=;
 b=io+uuCNw0av1JZchHnuBws9Sm8J6qiu0jjNuxstEXIq+Cj+M1P0AnzgtmJ3Afk8Emqatjkpti0R6a4J2Mu0tz1+RvSGlgRuL4Ing706WBIFMakuzvb2c1y/3k6Sih9Zi7crcyHfyHxwYGdtMqq1p+Y4ues42/J+zBPaTYGoyUoX0Yn8wwRFjJ69ybXt6/EAFpXrcdkSJilws2sch4geswzsYT7mWzjrYIw8fI1iJn3hXhoaMFchj4xZcUHt+CK4JVHJhGgjMZ4TffSDuMnlidS7mMvWMsrEqVrd0c3vq/NJZFozfePnhBFInQ7S8Yol4eQ2FXndpW0pm1dvz9GRb0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UIwQ9/TafDLoAJVWfcXzWWen5B7h2Hct5LhSIUHQr6k=;
 b=JkKc9vjHHdZVm8pD/5ifrBkh/CqjbXC+grcCraYtGzXrPSDyyqhwyxjAb0f+2me6o/sy5QqrcQs4LlBva/xfnjcTKQ01XPENPcDdvGSdpMAWrTeIXhxyBAJSDg6TVtImfQmuS5FKSqKqXbg9t7Uy8ni2dlHQ+f/wgnAUPV5TS02soCOdpfPWVRdWuSj/1bMMWTVu0XeWC16LjWSCCTgxsHiVlljqDGXHSv7v6g0ljb4CYk0yobyuFO7F7iper/0bsMsrYfSckj4/AE8MDjX/V7gOkRQ9BDLUiKXCL1gYwRVR1mBNRVHYNQeaD1GcSNfSBlaafSdhxKbuGFM0IGkfdg==
Authentication-Results: gmx.de; dkim=none (message not signed)
 header.d=none;gmx.de; dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB5278.namprd12.prod.outlook.com (2603:10b6:5:39e::17)
 by DM4PR12MB5149.namprd12.prod.outlook.com (2603:10b6:5:390::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13; Tue, 28 Sep
 2021 14:41:34 +0000
Received: from DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::95f7:ab4d:a8e6:da7c]) by DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::95f7:ab4d:a8e6:da7c%8]) with mapi id 15.20.4544.022; Tue, 28 Sep 2021
 14:41:34 +0000
Subject: Re: [PATCH net] net: bridge: mcast: Associate the seqcount with its
 protecting lock.
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        bridge@lists.linux-foundation.org, netdev@vger.kernel.org
Cc:     Roopa Prabhu <roopa@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Mike Galbraith <efault@gmx.de>
References: <20210928141049.593833-1-bigeasy@linutronix.de>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
Message-ID: <b98edd1b-2ec0-2b3c-5205-f2f0eaefe868@nvidia.com>
Date:   Tue, 28 Sep 2021 17:41:26 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <20210928141049.593833-1-bigeasy@linutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: ZR0P278CA0002.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:16::12) To DM4PR12MB5278.namprd12.prod.outlook.com
 (2603:10b6:5:39e::17)
MIME-Version: 1.0
Received: from [10.21.240.119] (213.179.129.39) by ZR0P278CA0002.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:16::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13 via Frontend Transport; Tue, 28 Sep 2021 14:41:32 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6e19510c-0d8d-4e55-9b8b-08d9828e11b5
X-MS-TrafficTypeDiagnostic: DM4PR12MB5149:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM4PR12MB51490A81C93D76E4C8BC1276DFA89@DM4PR12MB5149.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: R+HBAlsDygoWtzdCL9Vcjn5xpC30cSc+MeqZ8txq46HCOtQN2rBAT4gfP9UiU3z93LE3FcFYBiOz1WHAMBgyaZ9+RNEPUntCcH57pj6rXx9A5YoQxojsoQOgk37Ni5QVOefRfKOF1MmzbpO6uZ3WTY6r/EvQIi/J1kyEragMhc8s0nkYgX443+2Yx1Hg3JhgNdEZC6RcM1xpAyyJclMXE6czbOUgysIWFTgbdrTz7pAmUIb8OlfSohN/7FQ1EpsZxUJHGQgdDEnoMZ2pDl6Wvx8iKqLg+gkNdnoPCvQLpj3DDfBOtxtSJ92OKRz9wmduhbBwG/OSKLHUt4N3Ktz9bAXF/pnmBSO3gVCiGeB2rhVwAUu38mxL1wW0GaEDRG01Ok9+879NcGmJWWAC8dzppkC1mQL+sGBWkc24CC8raDshGaZr46XZ29Zyd9CYjbW+V3ehN7kR112PlHGZzxouSums1pfgkWrJq16+iCN7rNGfXMXvMLRqcWPRGM2smmca3ya/AP1M6XfAAk3g9uFAb5DWmXYMYIVQv3nrEbHlKsCzCN90g5DLmKqvdABjvDtEMzD0Q4Ft+AADUVSVGkJFMtlqAU4+ydYud7+eZe70D56lN+JMV2HukWJWrM2FNEXmV4fC4cKhos2z46XDglSO6P4jZhxlyWkfYyyJyjnE6znQXf9iempJY3soDGlsGeAAJQsZuF8Cg2smjyYYbwLs6aSXOfMAItQvB/uRkTMTiPA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5278.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(31696002)(8936002)(26005)(186003)(2906002)(5660300002)(53546011)(2616005)(66946007)(31686004)(956004)(83380400001)(66574015)(8676002)(66476007)(66556008)(86362001)(6486002)(36756003)(38100700002)(54906003)(4326008)(16576012)(6666004)(316002)(508600001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?a2RyTmN0RENhUjFTblVjdEZLM0dxemY4MFpHbHM0UE9pUlBYNHdHRzZrM1dq?=
 =?utf-8?B?aDE5R203VTZYT2tHM2l1Vm1DTkcrTjRYclpwd0R3QVpJYTNrdnl0WHo4WGRj?=
 =?utf-8?B?WFNjMUkyR3FpYnE4TzRCWk5vWnV1dGswVURFN0NCN2JHT3RBNDA2R3VKYjFv?=
 =?utf-8?B?UGE0M2NvcGF4MWYvWlNoZExxdkh0TWl0RXR6dlByQUhEN1VlM242a2NTV0Nz?=
 =?utf-8?B?cEZ2NWJlYlZMZWEwV1RtYXgrSWd0UkZJa2o2VURyWnJPSW9vZjMzSkU2Q2tx?=
 =?utf-8?B?YlFZc0plMTBnZDZHRDJKc3Z0NEFqVW1LcFVxSXM4cFRpcnQxRzVDZDZVSktR?=
 =?utf-8?B?Q1pRZlI4Vi95UlB2M0ZxZmZqM2dsNERseFJWUU0zRlVlQ0d4RnNjQVg5dzNG?=
 =?utf-8?B?dnBHNmU2NTlQSFdsWFhVY2NwNS9kQlVOTkpIK0UySGlhVzZVZmFiMithRU84?=
 =?utf-8?B?T1Y1b1B4bU9hL0hoc2J2TmdPOGxtZHo1TGFrWWNWc2NPd3Q2REFWdXIyU1ll?=
 =?utf-8?B?R1FpRjU2d0pJZ3J5aUM3eVQ3RW51WDRqM2FGenArcGhJall3STQ2NzlnMzFx?=
 =?utf-8?B?L1RDa0MyYi8rcy9Yd0NRM1NnUWVmTkRPenZ2UzFPNmkxekJzYnQ3bjdBVExw?=
 =?utf-8?B?ZWN1ckR2R2x3MzRGY1pVcllLVmFMQWZvZHhQVVpicDFUSVI3cjJydEM4VE5z?=
 =?utf-8?B?cjRnS2I5Wmd3MkJXRVBmRmJtZXhPZUh0YU5OTzBKcUQ1aHZ4ZWtva3F1ak9F?=
 =?utf-8?B?KzdoSEMzNTFpK05pTlJUejFUeWdiVjRmV0VhNGpPTXVoTnlXOFhRc1Bna3RY?=
 =?utf-8?B?UGtWYW1YVHNPN1hxM2xPRjE0MEREU2RKaTRJcVQ2YmdaNlI2b241QmthRllu?=
 =?utf-8?B?NE5OWlBUc3EyS01xOEN0bE5WckhUejM3YXp5b20zUGg1NzVWSE4zSzd4TjAw?=
 =?utf-8?B?WTdCK1d2dDdxWXV1WXhNZS9teUpZMklIcTFRZHhEajB0SFgzdnpFUHhLQ1Br?=
 =?utf-8?B?UUxPUjNlMWlkMjBUblVWbFdIZmN5UlpmS09rMTNLZ3lUWjYycXpjaTZTWUxv?=
 =?utf-8?B?S2p4c1ZNb24ySHpORzltNDZjVCtvYkNmdTAyZXVvRFJpZnpTaTRuN0RmMFUr?=
 =?utf-8?B?ZnRubFR6Sy91ZmpVeU52VXYrcWFsV0pndEVkT0NMQ3MvcXdLL3hkekxsMGl3?=
 =?utf-8?B?b0RidDY4emlQQngvY3ovdGN0c0pEeDdGam14MkRPVWpucXJTNnhLeVBWK2Mr?=
 =?utf-8?B?UWVnbFhQM0hqdGZsZTY5Tkx2eW1FWDFOd3RjbWRPL3NESW5ZM0x2UFdxcVpo?=
 =?utf-8?B?R2kzeVkyd25sVzUyQkcxNEJ3eVB2RFdVbmY5cXhlUHM4KzdGeVBJaFpXMU4r?=
 =?utf-8?B?Qm5rclM3azROYzBuN290VWRwYU0zWHhBODBiUUZGL1U3NUlmQlNaMmVIdzh5?=
 =?utf-8?B?NW1ScDBGMDVvcWxTQVFaNEtuWm1vdStDRTJrNisvQUE0RzRXb2ZMcWNrbjl0?=
 =?utf-8?B?dmtTS05WVU5sUEp6Y2h1d3F1RU15UlMyK1VkS2h4SHpvSU5IU1lxWUdNNFM3?=
 =?utf-8?B?aXZHYlZpY2FSRVc4c0dWU1hhbE9nUElWZUVac2Ric1RxelRpTE1GaUJlNDRD?=
 =?utf-8?B?WjVzTFBjUXMvWVo4dkplQ3lML1VGM0tqU05aZG4ydW96cVZnQk94cDl0UkdD?=
 =?utf-8?B?V1ZzbEY4dHc3cVdTL0RPQWIyR2ZYeENRZ3hEU2ZOdjBmZlhBaHV5Yi9RRlNi?=
 =?utf-8?Q?tOW6+V/gyYACAenHGNAc8LdgoIffOEv6XmBGKmn?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e19510c-0d8d-4e55-9b8b-08d9828e11b5
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5278.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Sep 2021 14:41:34.5330
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dPT0j4yPHcCyRL9/kVCn/kgVr8azc/pY6zGyUXPqn/NxrBtCScnWXfxePC2Q8z+bkRAViph98C78aFwcbaH8Sg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5149
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 28/09/2021 17:10, Sebastian Andrzej Siewior wrote:
> From: Thomas Gleixner <tglx@linutronix.de>
> 
> The sequence count bridge_mcast_querier::seq is protected by
> net_bridge::multicast_lock but seqcount_init() does not associate the
> seqcount with the lock. This leads to a warning on PREEMPT_RT because
> preemption is still enabled.
> 
> Let seqcount_init() associate the seqcount with lock that protects the
> write section. Remove lockdep_assert_held_once() because lockdep already checks
> whether the associated lock is held.
> 	
> Fixes: 67b746f94ff39 ("net: bridge: mcast: make sure querier port/address updates are consistent")
> Reported-by: Mike Galbraith <efault@gmx.de>
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> Tested-by: Mike Galbraith <efault@gmx.de>
> ---
>  net/bridge/br_multicast.c |    6 ++----
>  net/bridge/br_private.h   |    2 +-
>  2 files changed, 3 insertions(+), 5 deletions(-)
> 
> --- a/net/bridge/br_multicast.c
> +++ b/net/bridge/br_multicast.c
> @@ -1677,8 +1677,6 @@ static void br_multicast_update_querier(
>  					int ifindex,
>  					struct br_ip *saddr)
>  {
> -	lockdep_assert_held_once(&brmctx->br->multicast_lock);
> -
>  	write_seqcount_begin(&querier->seq);
>  	querier->port_ifidx = ifindex;
>  	memcpy(&querier->addr, saddr, sizeof(*saddr));
> @@ -3867,13 +3865,13 @@ void br_multicast_ctx_init(struct net_br
>  
>  	brmctx->ip4_other_query.delay_time = 0;
>  	brmctx->ip4_querier.port_ifidx = 0;
> -	seqcount_init(&brmctx->ip4_querier.seq);
> +	seqcount_spinlock_init(&brmctx->ip4_querier.seq, &br->multicast_lock);
>  	brmctx->multicast_igmp_version = 2;
>  #if IS_ENABLED(CONFIG_IPV6)
>  	brmctx->multicast_mld_version = 1;
>  	brmctx->ip6_other_query.delay_time = 0;
>  	brmctx->ip6_querier.port_ifidx = 0;
> -	seqcount_init(&brmctx->ip6_querier.seq);
> +	seqcount_spinlock_init(&brmctx->ip6_querier.seq, &br->multicast_lock);
>  #endif
>  
>  	timer_setup(&brmctx->ip4_mc_router_timer,
> --- a/net/bridge/br_private.h
> +++ b/net/bridge/br_private.h
> @@ -82,7 +82,7 @@ struct bridge_mcast_other_query {
>  struct bridge_mcast_querier {
>  	struct br_ip addr;
>  	int port_ifidx;
> -	seqcount_t seq;
> +	seqcount_spinlock_t seq;
>  };
>  
>  /* IGMP/MLD statistics */
> 

Thanks for fixing it,
Acked-by: Nikolay Aleksandrov <nikolay@nvidia.com>

