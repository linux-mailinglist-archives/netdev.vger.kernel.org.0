Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F904599695
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 10:06:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347285AbiHSH43 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 03:56:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347128AbiHSH42 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 03:56:28 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2120.outbound.protection.outlook.com [40.107.21.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29EB21834E;
        Fri, 19 Aug 2022 00:56:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WDu230W10QEzCNQjkUKueGwP0Ft0vcRVd6kaZJiPuYdrtAiHOj049ke/0jhWXelSHXpN/nQxuC2EIFZovZeoNnvBeXp5jw/hzhG2ElAG5rix3Qb7PejP/fQFYhckPLm7jikpz9cUuh0hN/Sj17hLsD5eN3UnlJyXD7V0JAZj5iaUKHzMATs067ls3Zudfu765KdWOmEUBKs8+6mlxXkAZOtYowh5tOs0GHsnfRudfrlq8YEtOZIGirBZjWtEczzVqcrYLPQsvlBffXZ9e/NV0wyx6Zu4d9m2iGD4zMw4GOcdqtExejibWjvMO368NMpQzb+ThsCQD0VWokoqmPNeJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UszB1K2YO7Pd9XnJLi6Vi1RBIXTsh5pTGkCP8qm4sqc=;
 b=mM1X7KtfF46mgV4jSiVCq+pW7f5E2jc2Yj57GU/0MudNTfjRpuHDE3vLFyykp5XoZ9KpGnmY47gaCQVJwfPNvoEgJgFMXPi8Rph/26DO39TtBVC9ZuY3lcatEr1ekUrNrwInGhuCce7Ch1xv9wYxkjXpHt1xOM1Y3YGrc43eO0MgsuYEBOd1yYvd7XUMkiqoZY/foZ4SfR/fKB58RJeV9Zlp8GuDp24KbCUE8RRXGqoPDxsO4/tDu9pyECdgV7GlHXKrrSbp/EvG0Agyve09xWww3UxvbB0PKO8gsP6FW5Q88nmq2ekqKKe7eRXlE+wDah/799BWw2qK3PRZgkMhMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UszB1K2YO7Pd9XnJLi6Vi1RBIXTsh5pTGkCP8qm4sqc=;
 b=yF43JMjV5YhFSr0HxY8RVsMLU5ZElYy0ns0NY8t+riKPbcSGAmT1yVMfV0Wu8EuwGoZGagcMZYRJQgazhp1hmrJJ+8Hc3RGFmsp6oz3ijdsjHXeGRgA3PuOx1TX8VUmN3BNGs8wXPdFZRohtKeykgf528EfWmMCSOA0G+iZKNs0L+a+wzf4pcpIFGaqcWUqQ9eybIzo9sXucTQbU3MtIpFuPEMCtKD/KtU/SruD0Bg4Ju6ZT1SzCF8uXo1cMZ1kRKd0cVzSvn+gBVSKwmuvouO4DvcpT2sVaxe55/NpX8ohho3lwlT5AfWLfnwntSVCJxVjcBEjaNnj2GAVQKIZr1A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=virtuozzo.com;
Received: from AS8PR08MB6946.eurprd08.prod.outlook.com (2603:10a6:20b:345::17)
 by AM0PR08MB3652.eurprd08.prod.outlook.com (2603:10a6:208:d5::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.10; Fri, 19 Aug
 2022 07:56:23 +0000
Received: from AS8PR08MB6946.eurprd08.prod.outlook.com
 ([fe80::f8b4:ced7:1f39:17b7]) by AS8PR08MB6946.eurprd08.prod.outlook.com
 ([fe80::f8b4:ced7:1f39:17b7%5]) with mapi id 15.20.5546.016; Fri, 19 Aug 2022
 07:56:23 +0000
Message-ID: <c0e9b02e-9314-2ad7-047e-d51b8d049610@virtuozzo.com>
Date:   Fri, 19 Aug 2022 09:56:21 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH net v2] net: neigh: don't call kfree_skb() under
 spin_lock_irqsave()
Content-Language: en-US
To:     Yang Yingliang <yangyingliang@huawei.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org
References: <20220819044724.961356-1-yangyingliang@huawei.com>
From:   "Denis V. Lunev" <den@virtuozzo.com>
In-Reply-To: <20220819044724.961356-1-yangyingliang@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: VI1P194CA0010.EURP194.PROD.OUTLOOK.COM
 (2603:10a6:800:be::20) To AS8PR08MB6946.eurprd08.prod.outlook.com
 (2603:10a6:20b:345::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4c43acde-0dd0-412a-b038-08da81b84f80
X-MS-TrafficTypeDiagnostic: AM0PR08MB3652:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /7rV/GBxbpEgLZ9gTCER/ipn7tGPGSwPE0+wWvJZoG32p20rBeNJEQcoYpiuCw2ws9cpSbBi6znJtouFCqpC3jKPgoqI3b9AXmPnu00D8TzQm/pNHRI+bkK/rlU79kA/Mng7TY9AEh7dKcs1oVzYpINBCSSISxH2OIO4tWZH641gAdXkmr2xD4yr142gbCJqASO0ujvrdN6YHvgBzugkMHiIMjxu3fgRg86XrD+XV5vKsi0/qOWCh0xQHEenJ58atRpoKuA6Apzcph0D22qqcjtprlkd7M/cqkTHxRWIqzi8/PDXy2R0/Ih1kUWc4oP/svMQBf++W9pFyyzcrX+UsW7sIJEfZ28EaKCKvK6PBbK6b1yqT4/b0PS002aDCoY9QWWEYXvAnx7xPW+WTAQfBSdstwTM0jkFVDH6c81erd+qGWM6L4jqeMKVHtj8SXikJU07e2mxkWcyYqyNzMSd1QUMJZTF+f9FM3JYq+BrC2lFemdUQJpYMNjkioGq7K0MrOQl3xXSivkLrxFtryXG0mtaGbgeoqRqQaTV2+gM42/BngtC5fhHvnf/oQRy3wFK6QQUSN9mKPnSmhyAibVDLeUNTmT6knIVS6pmXsfe9lvSMT6vVRU/DUD/LKe2imKC1Abw/sURWqvXU29C+eJiS4B1fn11KFKNUUBKwrvmRGiaQqCLF0HGlcxSfOBlqMUk0paq2hUbczxjcLXY+MKIyJ7FIOTdkUT09out6QHMmRETXNzQTs84Hi6juzCBZ4OOM/sRm8qtvJ9tk54hOmi/uENeQWBLq0UP7G7txQqjEy4duKWfHgxBoQKxCdqMrzkBvBvshhkW+Igc4hRDPzSq3A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8PR08MB6946.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(376002)(366004)(396003)(346002)(39850400004)(66476007)(31696002)(6512007)(31686004)(41300700001)(186003)(2616005)(6506007)(86362001)(6486002)(478600001)(53546011)(26005)(316002)(52116002)(38100700002)(2906002)(5660300002)(38350700002)(8676002)(4326008)(36756003)(66556008)(83380400001)(66946007)(8936002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Q2FTWDlXbWRjakNIbjFkTmZnVmE2MzV4bWRPNS81ekRuYVZxelFXekJGeVBr?=
 =?utf-8?B?Z3B1QWwveVZCOGtmcG1iMzlha3FQL2FZc1F1cS9wNUFlOU04QnBRZWlzVGtI?=
 =?utf-8?B?SEhHTVgvQk10d0l3NkVTOTY0eml1dlBwSUU3dVhWdytEQzhQMTk5MGVCMHEx?=
 =?utf-8?B?d21IZ3UxejVTRlJ2NjBWTlFOTFY4NElMK0xEV3phaVBtNnQ2eGhxWnBFZXNG?=
 =?utf-8?B?ZXhlUG9wTUhwMkl4Vk9USWdZUzc1NXgyWUt4QzZMSWdjdnRlOW9hZXlsSDZ4?=
 =?utf-8?B?eDFTU3A1OS9zSlVIYWRJTVZzT3BPMHdjdGdIVmtHS3hDK2ZEZTlIMU0vQ1FR?=
 =?utf-8?B?SUR3WEdkdStDdTg5Rm53cEErVVljNU5LWlpUTDBBSVZyNExaS0wxYnhSZGFU?=
 =?utf-8?B?OUlKR1NHU2FyZ296NUs5ZHdBNDRLZzNURjdpVmZrck9PbS9LZHV0RjBGSW1i?=
 =?utf-8?B?T0xMby90N2wxMVBDWkdxTlh0Tm1sRkNiRk1NODNSR0h0YXlIOXc2MUhjaGJY?=
 =?utf-8?B?SHZYRlBYUGlWaTduWjZIUXAwZ2ZnYjhwSHFFRWxpNjQ2b285M2dQbmxmeTE5?=
 =?utf-8?B?MDZ2QkUvbUxFVWkyUzVNQUYwWmN2dmZ0WDJQUnFZTm5MRlA1eThGQTJHaVFz?=
 =?utf-8?B?UzF4ZEpic2NUZ0xROFVYRFVkdU9TOG1IU0wzeGIrT25iZFNRNDBPNjYzMGhX?=
 =?utf-8?B?VzJ4Mys1U2pPNi93Tm5oKytxYy96TFd2RVNrMEV0UXdhclVhMXZkZWtHOGVZ?=
 =?utf-8?B?WFU1OENLZko1amVTSmVlN0UvRHFESEF3aW5aTWhEWHdBM29Id0YrRWdsN1d6?=
 =?utf-8?B?ZWZUQjVBMExRaFRXQmNmd01UMDEwWEN2R1cwdjhqalBUYjJ1U01MME11L3dt?=
 =?utf-8?B?M0tRcGgvbnc2NU5wdEhZakJQdWVMY1ZYdU93RFpxWmtKZFp1OVYrSjh3VGVh?=
 =?utf-8?B?VWd6eTd4aXJ2aW5UajQzL3lWZytuRWhpcXNzSGlnZUprV1hJTWpEWXgxcEQ1?=
 =?utf-8?B?RjdVL01PUnBKd2QxVFVGdHZyaFNsZmd1Q1BIdHF3bE9ZdUZ5NHh6bDl1UWN5?=
 =?utf-8?B?MHdWdk5PNWZRaldBMzJRZi9KZnNwNHltQVpOYzJFNGUvNnVxdEZIMHEwU1dQ?=
 =?utf-8?B?THU4MWYrU01ra3RiekNpQjNoOXBGR3NodnJic1poN1pRRkp0L2wyTDBjdXJy?=
 =?utf-8?B?ZGhJRlV3cGtCT0d3N0ZzcDlqVi9FZUplcWgwM3dBWFd3OGZwUkN6R3NCVy9a?=
 =?utf-8?B?RExsck1WeTdrUjk1ZWI1SDdpYzdDc2cvQXlrUThzdk9VMjQ2RnBXMHB0QUhs?=
 =?utf-8?B?d3VIa21NYjFoaUlXYUtpbGt3N0JEZHREeGNoMUY4S0NZeTlTTEx5TXVJRnpC?=
 =?utf-8?B?MW43djk3d1RBeGpQcnIySlhVdGgyMVY1TFVTc3dwR2RId0NVcmRMV2hjYmc0?=
 =?utf-8?B?WXpNeFN2VmlmbDFoMzhJdDVKaDhLUHZtZFlLU3Z4MWtJZFd3YllWTjJjbVc0?=
 =?utf-8?B?NGtNeXZyQTRvRDhQbG9uRC9nWEdzdXhubVVuRHZCNERYdy9Ca2I4OExkNnpC?=
 =?utf-8?B?ZVM2U2RXTjg1T3RrSVJkdk1lS2RMQ3NsY0dyVllhMkQrNzlmYm9NeUFQTWxm?=
 =?utf-8?B?V0hWMkdaYktQb2FlWDNqTW02ck9tcFdmZElUeERJTlNScVpkL3UwUThxUm8x?=
 =?utf-8?B?NEtRSnBtbDY2bis5RHI1MWNmNExmKy9jZTNCWmNLMjRxSVlKMDFUZlZ2dU5j?=
 =?utf-8?B?TGRwdE1QZTMrWG05MTVPWXlMY2lwUW5NbHdSZVJSY0hjaVZlSXZ3UkFwN3RW?=
 =?utf-8?B?T0ViT1hEUkIwV1I3RnpDbFBPVTlGYlFEaEg0MzZGektGMEF5dDUySXdRN3FJ?=
 =?utf-8?B?UzhMN21yenZBNWZxdFYyenUxRGZPMldzVDV0eTcraTdjdlZUeG9kd0E1WDkx?=
 =?utf-8?B?cXgzSHM1aStxREFpSUpjcnUzTlRSdVM1YXpIWjM3eUZLZG5rSDdBSkl6dmVH?=
 =?utf-8?B?OW1pWldWSnBtWkpld2hORldjZjBHUk42bGpIMTdMQ2phZGprMU5uemxMK3dv?=
 =?utf-8?B?ek1wa3dWR1ZrenkvTWxaTEpXTUN4NWdYVFgxcmVlS29nWU00bldJclhUc2pi?=
 =?utf-8?Q?XMwOUMPaRKiy++28HlDqEV3qd?=
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c43acde-0dd0-412a-b038-08da81b84f80
X-MS-Exchange-CrossTenant-AuthSource: AS8PR08MB6946.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Aug 2022 07:56:23.6020
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xmjM5ES78N9RI6SuljjH853g7Qy0XY+e3tA7Ckl9Tk1Gy/EVrpbvwWfyzlCnBqfjQkivnWs6Qn3ZMwZ8VT6pdg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR08MB3652
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 19.08.2022 06:47, 'Yang Yingliang' via den wrote:
> It is not allowed to call kfree_skb() from hardware interrupt
> context or with interrupts being disabled. So add all skb to
> a tmp list, then free them after spin_unlock_irqrestore() at
> once.
>
> Fixes: 66ba215cb513 ("neigh: fix possible DoS due to net iface start/stop loop")
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> ---
>   net/core/neighbour.c | 10 +++++++++-
>   1 file changed, 9 insertions(+), 1 deletion(-)
>
> diff --git a/net/core/neighbour.c b/net/core/neighbour.c
> index 5b669eb80270..d21c7de1ff1a 100644
> --- a/net/core/neighbour.c
> +++ b/net/core/neighbour.c
> @@ -309,14 +309,17 @@ static int neigh_del_timer(struct neighbour *n)
>   
>   static void pneigh_queue_purge(struct sk_buff_head *list, struct net *net)
>   {
> +	struct sk_buff_head tmp;
>   	unsigned long flags;
>   	struct sk_buff *skb;
>   
> +	skb_queue_head_init(&tmp);
>   	spin_lock_irqsave(&list->lock, flags);
>   	skb = skb_peek(list);
>   	while (skb != NULL) {
>   		struct sk_buff *skb_next = skb_peek_next(skb, list);
>   		struct net_device *dev = skb->dev;
> +
>   		if (net == NULL || net_eq(dev_net(dev), net)) {
>   			struct in_device *in_dev;
>   
> @@ -328,11 +331,16 @@ static void pneigh_queue_purge(struct sk_buff_head *list, struct net *net)
>   			__skb_unlink(skb, list);
>   
>   			dev_put(dev);
> -			kfree_skb(skb);
> +			dev_kfree_skb_irq(skb);
>   		}
>   		skb = skb_next;
>   	}
>   	spin_unlock_irqrestore(&list->lock, flags);
> +
> +	while ((skb = __skb_dequeue(&tmp))) {
> +		dev_put(skb->dev);
> +		kfree_skb(skb);
> +	}
>   }
>   
>   static void neigh_flush_dev(struct neigh_table *tbl, struct net_device *dev,
Reviewed-by: Denis V. Lunev <den@openvz.org>
