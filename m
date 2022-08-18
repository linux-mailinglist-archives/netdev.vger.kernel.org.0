Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55B99598074
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 11:01:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241137AbiHRJAU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 05:00:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235263AbiHRJAS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 05:00:18 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60106.outbound.protection.outlook.com [40.107.6.106])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 699D7AE9D7;
        Thu, 18 Aug 2022 02:00:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ViFcmJiR7+bRSVzgMHpZKSTuYhJ/gVUETMyn6+pFININKU1xRFzixJh0vlVVPhKs1Pk2PMCZUYgKvV23NVM/BMFUeTOtG+9HjrZyVTIBaZ1l4WzPSDBf52dWHkTTXIrgyI/HBrgTqQN+DMyutc6j8BalPdecCBcyJcIJn1hhmvPhul06PtCNJxOObrrmKEikF9ef8iWSsADaaiT1U4P/pJ9G2IoZMSRJG0OcU34/5j1OhMflQn+AcNQi/m8Ha3d0eE3Pa7YbrDHPRijWa9RXGwpjNbM3JRv2pF0Yz/3R+oKkCNnWlr6H4cyCPZe7Uppw99eap8hnIu0FoOF9glc2Mw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mctnCNvtzl1cn2MrdBNwOZaqRf0nHPHZsIZnbY1ODe8=;
 b=g/RPj3XuVzRyt4KcLZdOHC4lK4TUPbFgFRNJZpdkC+V8/kMYqzMgnNZwocY66kLaaGbDuSz10XCUQdlx3RvfFFZB4YjfluaN8jqpzXrocHiE1qmao1FMgkERWz4Teu0NoE94Nobi58p+a+w/vcYfEC9sprv015ZalWi3aSYMXz42jxjAGoM8JFOhg7r1xQJqEKVbNk/YxXBqEmlhAif2Ueuzd/Zv4jh06RYixUxNza905uXVRKobOXxN1U2eZe1swzCeRjxa3aU8I4cxE2TSgCcDkBbu/pa+0ARWdV9e23H6hNpvtjU12nylyIf5grDp5NAGzgCDKIP+jQVgtcYX5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mctnCNvtzl1cn2MrdBNwOZaqRf0nHPHZsIZnbY1ODe8=;
 b=wa8OG/GAC7Sbj0zkbV1e6RijRB3cOhPdGFeaZzWn9Nrx1zbIuueYWOswd+qQnMjXswIoG++oiTW3fS3ggS+SsT7lJJWwQyV0Ah8W9/fdKMwO933Wjh0P5raS6+NmRnm3zYLnptfcHuDqNKDSjTNTS/hIOCQeggb/vjDXGlFLvBx8dJH6Vz1+tZQIiJEb6LL8FaKZada6klHBwL4/vQQfRiGPiT85wYTYQi8ZqqbVFMGDTQckRuOa2YHa/dlzldsu02f1bp/6+hIf/4T3fLGnDMXG/TPJE/+CZdB6PALqoX+fX7DOJuShR1fzqZwGujf57RH06UuWs4RT3aqaG37rcA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=virtuozzo.com;
Received: from PAXPR08MB6956.eurprd08.prod.outlook.com (2603:10a6:102:1db::9)
 by DBBPR08MB4917.eurprd08.prod.outlook.com (2603:10a6:10:f1::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.10; Thu, 18 Aug
 2022 09:00:15 +0000
Received: from PAXPR08MB6956.eurprd08.prod.outlook.com
 ([fe80::813d:902d:17e5:499d]) by PAXPR08MB6956.eurprd08.prod.outlook.com
 ([fe80::813d:902d:17e5:499d%4]) with mapi id 15.20.5504.028; Thu, 18 Aug 2022
 09:00:15 +0000
Message-ID: <79784952-0d15-8a4a-aa8d-590bc243ab5e@virtuozzo.com>
Date:   Thu, 18 Aug 2022 11:00:13 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH -next] net: neigh: use dev_kfree_skb_irq instead of
 kfree_skb()
Content-Language: en-US
To:     Yang Yingliang <yangyingliang@huawei.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org
References: <20220818043729.412753-1-yangyingliang@huawei.com>
From:   "Denis V. Lunev" <den@virtuozzo.com>
In-Reply-To: <20220818043729.412753-1-yangyingliang@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: VI1PR09CA0081.eurprd09.prod.outlook.com
 (2603:10a6:802:29::25) To PAXPR08MB6956.eurprd08.prod.outlook.com
 (2603:10a6:102:1db::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b1ef3a33-5120-412b-01d6-08da80f810f8
X-MS-TrafficTypeDiagnostic: DBBPR08MB4917:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tg8dD+sHngFzLdl3PG5nWM57auptgrW1FNv7TcyQbwJ+5uqxwUOMsxJha2Jlnroo00mL78Y7aBa0yWhchuje8f1jy+p2prTytz1Cj4wRIKTtk6/BYxmVcOZDVzgaGQ3Bi80ZJGZZ6x8HhuOnHul11MZ1MB9lhjgKgmm6N7aPy8bF6gNniaIcWXVMrJnnyu2I3e8WjE+j77po428By2O+eonWp0Puz1GhzWwxn4jcNJBSu2UlCrTFqWCq8cfavViFGQbjvZx+iuz0UX831BlJi/MKw+h+8a8PwCndlFyk/i+Vzy2Op9LAa4FYLK8Ho8JvWlUOMfJF42MxD2D0LeWcFQC4f/Bmfhkr21bh34LTtcGpDROMlrjTpdKIP3jU/t80Lc7KtpxfTqHyJnKU2AJPIhnT0GNE81OaIceyRdfuBhCObeJGjk5wRlEsBs5yk5Kku5lxw/jjZp4iYCIzh0OO1S/hKYBuX3iT8w2wsCN3XZu3iDOq0MKi7ifA859teALzg8IumFJOgKA+Tf7HXCr3ocYxPFBCKleTNNn6txdOroE3hNB3fUXyzYYxeToZN7MSdmOe/ZzLtAVVlvuMUJVHRXeXkoelEMBIIcaYJpA8Z6xAgK1cIjdKQ5Vg4YiWPi1saljoE2DCdzqQBn9PcRFC+ZCR4wlImv+jSh9f2GfD5s1mSyDKCDZHtEJKb4ztndnvm7WymLGTJ3qwnWOZSG6Lv8v8+JsXjQqRPengDwTxXz2PBpz66eybsdD5yH+LMSIQzpclgJ75mkc8KfMxJbdpCRHuzVMYNEejczcqhgs2DAsnLgDu/8T4Owmb7zp9m6ztuLRwLBRp4Wa2n6aXXYK+Iw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXPR08MB6956.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(376002)(39850400004)(366004)(396003)(136003)(4326008)(66556008)(8676002)(66946007)(66476007)(2906002)(26005)(31686004)(31696002)(186003)(6512007)(41300700001)(2616005)(38350700002)(316002)(83380400001)(86362001)(38100700002)(36756003)(6506007)(5660300002)(52116002)(53546011)(8936002)(6486002)(478600001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YmtUcE1EUFZoQXNUOWFRL0FYUHQ4NW9CNklGOHEyUkc2VExJN3ljSzRKUVNG?=
 =?utf-8?B?ZXA4Vi80U1FHWkNHdGJMcC9Rc1hLc0QvMFdGUUJGa2pVNlFHRDAzNmExL1ZY?=
 =?utf-8?B?RVBZQ2hKa0hhNWF5V2VoYVlFcWtJcXdCWTEvWFFlaC8xaEVNZCtiWTk1bEI1?=
 =?utf-8?B?K29hNkoxSk8va3FzZ3NmTHo5V2JrMGRoWWFqSDZzOEliMm1OZ2tZMkRjWENK?=
 =?utf-8?B?Z0k2YjJSMjlucDJndXg2ZWlsblB6UjRJZHl2c1ZZaWFTU3JxQU9wQWJPcXh4?=
 =?utf-8?B?bWhVdnl6L1VIRDduN1VrZzduTXpBbFhmclJqY0ZoQ25qTG9NM1pIejQvb1pC?=
 =?utf-8?B?bUdSZ0o0MDg5TnBva3pJY01kK3UzaDBvZDdwM0RpdEtBblBmaHhnWXFCZ215?=
 =?utf-8?B?cHBrQXNrNHp2eDR5bWkxYXpQSVhJcngvcUtydE5HaEQ5U0p5MW1BcnRHOGd1?=
 =?utf-8?B?ekRWcS9RN3dqb29CQXZzK05GVzkwZHVvTFkySXdiYVRvUWFob2pONkZjeFBn?=
 =?utf-8?B?Q0hUbVQ1Q1JSSi9ic1JGSFNKWnlVSzJ1VDVRdjdXMUdaN1AyRmV1ZGRhR0NU?=
 =?utf-8?B?OHNVVkN2QzFXaXZNNGVMdWVSK1JIdCs1emU1b2g0OFNQckprKzdwRlNKQVhU?=
 =?utf-8?B?RUZjTHFNVzYwSFVZWVpOMEtoeU5oNzUvelVUUjdleUlUWDdyODNISDJrUERU?=
 =?utf-8?B?U0lGM0xqMjlmVnp2cmpZc1ljVFUvN215ak1vVVI2RmYwTmRIK1FHRk9xYUFl?=
 =?utf-8?B?Z1BQaHc4Y3o2cjE0eWVScVIvR3JZN1gxNEVpRXUrQ1dzMXlQN01nNkVxUnFi?=
 =?utf-8?B?M2puNEovWE44VEdNMElWbXZGN0gwYWo2UE1CRnBjYzJJVnVYK283cXNlaXlz?=
 =?utf-8?B?MWFsOVZNRXA1WDQ4c3NrSHVnL3RMRmphYjNQR21xbW9kTmdjbU81Q0JFSVJh?=
 =?utf-8?B?bS9ZM1ducnR0MWk3MEtkK3UvQjM5RnhLYnFZeDFVUlF6N1dlTjhIdTY2RkIw?=
 =?utf-8?B?blh1OVRpL2ljSkZ5eTdXeUcrSDEvQmNhUGU4dUFWbkpIbVJXNi80eCszVURh?=
 =?utf-8?B?Z0VxMmpGRndvSWJyNnk1cXBoeHpjQVh2NTZPdEpVK0JZTlNlL0ZxYTkzZ0cx?=
 =?utf-8?B?c0wzaFRKYklNRkYycDlHbDFBRDU4LzNqWTR5OHFTZk9SVzBWL2s0TXRIYmZZ?=
 =?utf-8?B?Z2J1WHVRVzBIVWJMdWxZNThoUEo5bDBqVDNXMzZ0cmd0enRTVEhEN0lqYVF6?=
 =?utf-8?B?ZFo5bng3MTVncEFIajlWNk9iWFZmckZGeUJkWGx2TEw0Q3QweVRqa3BWMlBu?=
 =?utf-8?B?bUw5UlBmQXlTRUNZYnNoMll5ekJKK0xrVFBBOEZiNkFQZVVwS0wwb3BRNlk2?=
 =?utf-8?B?WEtKZ2RjYS8zZnZpdHdCU1NjRlhWTVBuS3VYYVh6NTJTNTh6UjM5akNvemY5?=
 =?utf-8?B?R082ejF2SExMcE9xU2xGQWVBcDd2S2hlbmFoN1N5UlRISXdzMldBN2RYYkV2?=
 =?utf-8?B?NThzS0ExYyswU2pxbXV5VUx2WWJhQWJPRlVocjlkUlpYRmo4ckNUdytkS01m?=
 =?utf-8?B?b3pvLytNQXQ1MkF0ZFU2Qm1weFg4UEVwTEpCMldsVzV6alF6eGtvcWZlc2lR?=
 =?utf-8?B?N0RMRm5McTQ0Mm1nVFlma252bDRzVFk1Ris2NTJ2b0IrMUtFU0w2RHBLN3dP?=
 =?utf-8?B?MEx4T3AwQ3BNZXcxQnptTHE4RXRLVTk1RDNrTHQ3dU9UbWlHd21GRGhnT2M4?=
 =?utf-8?B?T284Q2pYRnE0bDhQKzNSOTZLdC9udE1LVVJTTGd0dVdMa1c5L0RuaDMreG1W?=
 =?utf-8?B?R3BkUnh5amxsWmJGOHNKZGtvZVo0SmpoZTBxOElQWGdwclJwWUJZSElvUFl4?=
 =?utf-8?B?ZHNEdWFsalVxcWlYTUVNNXVUK3J6UTdweUt3a0dKWStBZ1NoZldYWnR4RFRl?=
 =?utf-8?B?Zm11TytRT0ZFMU9MY1lJNWlkK3VOaGJpTkViLzdQQWdJWUxNVGV3N0pwVEZS?=
 =?utf-8?B?QVdoN2RVV1BZa2ZXZ2FINXVFVXNkVUpOV25VZ0hBWTdhRkMwZkk1NE4yTitB?=
 =?utf-8?B?QTlCdE5BWDRBYlNmSExpR0tvdUU3NThqZmQzZ1BPanRVZ2J0dWNiTUJxVnhX?=
 =?utf-8?Q?xoTC51gui1qBUmS/FW+LTvWaM?=
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b1ef3a33-5120-412b-01d6-08da80f810f8
X-MS-Exchange-CrossTenant-AuthSource: PAXPR08MB6956.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2022 09:00:15.2217
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HskiSvlzwvj7yyVYhzzEjEgkj8dFA2T8joLxfUVvAiFFES8I6XrrBRJgjLZdLvamik4rRfgKb+wcjMPsLIaOvg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR08MB4917
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 18.08.2022 06:37, 'Yang Yingliang' via den wrote:
> It is not allowed to call kfree_skb() from hardware interrupt
> context or with interrupts being disabled. So replace kfree_skb()
> with dev_kfree_skb_irq() under spin_lock_irqsave().
>
> Fixes: 66ba215cb513 ("neigh: fix possible DoS due to net iface start/stop loop")
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> ---
>   net/core/neighbour.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/net/core/neighbour.c b/net/core/neighbour.c
> index 5b669eb80270..167826200f3e 100644
> --- a/net/core/neighbour.c
> +++ b/net/core/neighbour.c
> @@ -328,7 +328,7 @@ static void pneigh_queue_purge(struct sk_buff_head *list, struct net *net)
>   			__skb_unlink(skb, list);
>   
>   			dev_put(dev);
> -			kfree_skb(skb);
> +			dev_kfree_skb_irq(skb);
>   		}
>   		skb = skb_next;
>   	}

Technically this is pretty much correct, but would it be better to
move all skb to purge into the new list and after that purge
them at once?

what about something like this?

diff --git a/net/core/neighbour.c b/net/core/neighbour.c
index aa16a8017c5e..f7e30daa46ae 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -311,6 +311,9 @@ static void pneigh_queue_purge(struct sk_buff_head 
*list, struct net *net)
  {
         unsigned long flags;
         struct sk_buff *skb;
+       struct sk_buff_head tmp;
+
+       skb_queue_head_init(&tmp);

         spin_lock_irqsave(&list->lock, flags);
         skb = skb_peek(list);
@@ -318,12 +321,16 @@ static void pneigh_queue_purge(struct sk_buff_head 
*list, struct net *net)
                 struct sk_buff *skb_next = skb_peek_next(skb, list);
                 if (net == NULL || net == dev_net(skb->dev)) {
                         __skb_unlink(skb, list);
-                       dev_put(skb->dev);
-                       kfree_skb(skb);
+                       __skb_queue_tail(&tmp, skb);
                 }
                 skb = skb_next;
         } while (skb != NULL);
         spin_unlock_irqrestore(&list->lock, flags);
+
+       while ((skb = __skb_dequeue(&tmp)) != NULL) {
+               dev_put(skb->dev);
+               kfree_skb(skb);
+       }
  }

iris ~/src/linux-2.6 $

