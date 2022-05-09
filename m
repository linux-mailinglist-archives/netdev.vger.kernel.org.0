Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5B6751F43B
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 08:02:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231231AbiEIGEI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 02:04:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235111AbiEIF4E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 01:56:04 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2062.outbound.protection.outlook.com [40.107.22.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5F09128176
        for <netdev@vger.kernel.org>; Sun,  8 May 2022 22:52:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mR1cuuOd+vjn7m4BMpQk3OPNTXhUgPWMiy2GcyM2NrCe3ZY2AM+/gkXQh8K8rKwzJDSlWHiAniHYZuE+wyGYlDKVNiDfZ4aE0vr47FWm1Lgh8n24hq2yndMnW0/CrwbflGnu0CxaZbLHB7TBJbewVTBZcVLB4TRsRURLs8pl0hzfbYhr2SxYISFuD3OMFDgHaG9FVi9nMHltZL10ZAhwo9dJ8/fKOJW12uMW33EK7GYzSmxHfLONUKJd1vimtkgV26gksZXR3G8bpUaMK4vxDLauUEvD7PFjubclO/Z+h5fGsxoNDtum3GwYTrSKU5Q4EpRFffhLw/J/3n44pzzGkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OinqEBuqG1dy/Iu+gXZd42Bb6ywH1Qlr8QOx86I/ZRE=;
 b=E2dqXMKcgYqsVU6lW+dPY+Bkmu4bc2+yIzZCbpAOu4BF5mibeEJpdGtw9QS5vgNkF4NfCxkhgqnCOHj34kJzHiZUWFpJcVqNwmkb/EI6Rp1LHh21fy8GuL1yq5xuQxPLBUeWM3EG0S9E0lvMNfEgOhrPNRlytpx2N656e4cUeXMOPuaadcSXCmJe3R6Cod2SvkZmxhI16XRCEmBx/lU9wlSOUAOvt8AihFehml8mquC5s+m6zcImHU+VgRXE6p2Q57VdAKTUHsHVWpuv0djV47jgS0vvBSzj5ObRqwnvVfdHbsduDuiDW8UaZLNq6ixPRwh8+DMmfJ0c76EMsFAfYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vaisala.com; dmarc=pass action=none header.from=vaisala.com;
 dkim=pass header.d=vaisala.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vaisala.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OinqEBuqG1dy/Iu+gXZd42Bb6ywH1Qlr8QOx86I/ZRE=;
 b=dA3cg19o460whJWK1J2FyednPIDU/NyGKC3l5uEW4nmOiHkduR8sd/PMH2bvY7lEkSAOjkEvGRMPkZ7Yo/KVG/WV9acbLhDjlrW3wq/ntxuKE+xAtzBHeek47mqn2F4Ee4JguZxevvU8QlLKUIVFjU2EXqCIICik0kikrSoA9yGWWPaeuFKrJep5fK+ZRJzp7lbFGtd+jWmfnfN+fxDbb1MXD6HcNoe7mJLCB48RnXgcBqfmsXRcfKF4inod3c5FksdbeaIUXjVwzSKsPIW/TIo2MQHSTu/56hsePvElGN3czhkyyXuga/TupxboCXpkS7rwbEoFe5gM4J6OzFvIjg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vaisala.com;
Received: from HE1PR0602MB3625.eurprd06.prod.outlook.com (2603:10a6:7:81::18)
 by DBAPR06MB6648.eurprd06.prod.outlook.com (2603:10a6:10:180::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.18; Mon, 9 May
 2022 05:49:49 +0000
Received: from HE1PR0602MB3625.eurprd06.prod.outlook.com
 ([fe80::58ca:a1d:54ff:1473]) by HE1PR0602MB3625.eurprd06.prod.outlook.com
 ([fe80::58ca:a1d:54ff:1473%3]) with mapi id 15.20.5227.023; Mon, 9 May 2022
 05:49:49 +0000
Message-ID: <cc63933a-24e8-bf83-a214-57e3810d640f@vaisala.com>
Date:   Mon, 9 May 2022 08:49:46 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH net-next 2/2] net: macb: use NAPI for TX completion path
Content-Language: en-US
To:     Robert Hancock <robert.hancock@calian.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc:     "nicolas.ferre@microchip.com" <nicolas.ferre@microchip.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "claudiu.beznea@microchip.com" <claudiu.beznea@microchip.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>
References: <20220429223122.3642255-1-robert.hancock@calian.com>
 <20220429223122.3642255-3-robert.hancock@calian.com>
 <d75679b0-d9a7-619f-bc35-a63704c255ee@vaisala.com>
 <9db520c5889481baf48705b16ab402b26ada49f7.camel@calian.com>
From:   Tomas Melin <tomas.melin@vaisala.com>
In-Reply-To: <9db520c5889481baf48705b16ab402b26ada49f7.camel@calian.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: GV3P280CA0083.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:150:a::11) To HE1PR0602MB3625.eurprd06.prod.outlook.com
 (2603:10a6:7:81::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f6e7ad07-8780-435f-61ad-08da317fbaba
X-MS-TrafficTypeDiagnostic: DBAPR06MB6648:EE_
X-Microsoft-Antispam-PRVS: <DBAPR06MB66485FB88E9C03420211DCCDFDC69@DBAPR06MB6648.eurprd06.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TwGLyYaRKA+S55ORzNmSuj2LOUbBo8Pq+r34gHFxjapiifjqxZiV8gddPlsF7ovHjAh3qE01rCzIPROOgADQOJO0IQYp/ixdmsRGm4RNze4KTXHfgidSrQ/YjD0RMdnLvpdMsUx5Ucw8we78FUaMHUu+ap7lsOucl3eAT3Sh+pVGsvA80J4TYQEdmjqggDbQx801IAnsOT9hCjzsOz/FvhrGw4TVv5T3NBVLNMRMUWNKyR5pOqahjKVoCMTG9o2h+5moyJ577zhmviA5oSZq/AUVEwfWp9/2XtHvuiWh6bRa5gi9XEdneeBstH/BYwA18sxRISjSTGnsh/aIBtUpyAuJJl90Ek215gr5EoaQCC1ZC0hQJTpQp5gXAYPp+fXPM260zJxyBwvNBuakF4huazPyjlQntmeTTiVVDtl7adJR1AsCWH3W0VZgl19b2/IbDHRK/NJqJfmvqWH97FjMHPr/O12EBhzoF+48ceKcXx+2vcjryp6Cs5MWP/W+a3c5Sh9UuoZtmcwL7ax0iY1EtazhW5BsHcvjvvC0U1nvq53M9oBQMh+HrZuN13M5oDcXxH+qSbK4Xf0vdysTQU1HvjgaEb0LfeutrcUhnTneolcYAaX16PjGI1LFrJe4bcehSLCPaqGGoMkyf9LbtN4MERfFjLbQ+VtDdSINyB1EVWcAcjmoIZf6PzLvvz9ahSsjhg8iPpMdDO6V2enWsA5QNMp+dMQe7++IeCHQR0Bo6s0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR0602MB3625.eurprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(110136005)(26005)(66946007)(8936002)(44832011)(30864003)(54906003)(66556008)(5660300002)(6512007)(2616005)(86362001)(66476007)(31696002)(316002)(8676002)(4326008)(83380400001)(186003)(53546011)(36756003)(31686004)(6506007)(6666004)(6486002)(38100700002)(2906002)(508600001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NGEyVFJSSkE1ZkRaOWphT1RhbEV4ZUt4Tm9SOW1YL3l6QVpWekR3MW9IU2pi?=
 =?utf-8?B?VTd3UVpGT011VzhBS3luN1hIdHB0WGI5Um1MNUQvSkVpQWpyWHY0aTl0TXhK?=
 =?utf-8?B?cm1YY2FIME52VUJPWS9CL0t4SCtKU01sQ2xIemhlRXl0cDZHNzlRZ3V3SXV4?=
 =?utf-8?B?UlpCQ0tETVR3TWFUbVVKQXl3cXRFb08rN2c2WEdNekUzL3NuVGxyeDlhcXdU?=
 =?utf-8?B?TDg3ZEplVGRrZlRoazd1SkViemVkVWtVU0JSVGJwQ1BoUlk4dThNS21qYnJP?=
 =?utf-8?B?amU1M2JBV2NRcnBNeGhkdWxCMUs4Ymd5YnM5NnlpQlhKQ2RXamFKME83c0xk?=
 =?utf-8?B?bi9aMVNUMmlFSkRESUpmS3BBamlzeVFvODRvdmlFdDdGeHIyOEJaOUJOU1dN?=
 =?utf-8?B?WHNjM1Q4NVh0ZlR3TkJReHNab0RicGw2dDBVQWtLR1VVZktYY202Mlg3T1NJ?=
 =?utf-8?B?WitiQyszMHNNcEFscjhyL0ZkUVpiYmsrQkR4ZENxWlZlUVpRVCtZeGZnSzRw?=
 =?utf-8?B?cU5YZGVYZkY4UE5ETzc1U09UT2d5azkxUzdaTHZQTkt0LzljZjR0ckN2RXlB?=
 =?utf-8?B?akVuTWVVNXRRcWFKRnBOdEVUbVpqdG4rSXpBRlh4OGJNdUlrOW93eEVUSUkv?=
 =?utf-8?B?OE8vbEdhVWxxUXJ3Zmhna0xjbVVwZnYxSmtBa0trZk92K3h5RUJ2REtIZ3hn?=
 =?utf-8?B?dm02bStOd2NmdEJHUXlsOGo0TUZ6RU5sR3lmOVYrNGlNUzMvdDEwK1MzQURp?=
 =?utf-8?B?RmtxbExOZ1FLc0JHQ2wrM3IxV3A2UkJ1c2JCdTBGZUt6VTZZcE9PSG8vRnY5?=
 =?utf-8?B?Z0djNlBiSWMzQzhzcFFpN2x3ajJvZ1ZKbWQ1ZUxiWUxzak1JZHVjOTZRL0JG?=
 =?utf-8?B?ZGR0a0ZWQ3JoTnVIUGNuNnlJVXpLL04rcjF4anh0dWI0ODBpNFpESi9nNlRu?=
 =?utf-8?B?cHdlVjdCZUdEL3ZlVFpLblZROVRPMEk2bEtmZS94RGpnVVU4V1F3S284bU8y?=
 =?utf-8?B?YWxET0NUMnBXb1RQNHdsdkpTVW9xcXdaK2o5YnY5c0RxZ1FTKzAxMllVRmhM?=
 =?utf-8?B?dW5zK3pUVWhQU2JnSlVielNlR1ZxWmliL3ovUk4yb214K1I3a24xcTNMRDcz?=
 =?utf-8?B?eTZaOWgreVlJQkFXZlVxcjdheFluSHlCdUhWWE9scWhtcUt4TWIxcUUrL0Nq?=
 =?utf-8?B?ZlNHdE0vMjJTclllQURDeGhWY0grLzBjaU50K0lsanB2NURVUXIwNVE0a1Vz?=
 =?utf-8?B?VlpsV1JIRTJhQjR1SkFYU0thR2k4QkVocXZuQW1QYnBTUUlwVVFzV21zK1Yr?=
 =?utf-8?B?UG9GVFpHbUhuWkczZlJ0eDVvOUl3YmZROVh1MlNtd1k5TC9icnNLOE9NaDE4?=
 =?utf-8?B?dnNqMGlCWStQbUlFc2FwVyt0U3NTenQrS1k2aGZlbGJSZWYxSjBZMG53MjJz?=
 =?utf-8?B?RlUyNHY0cDNOczArSWc2VXk5SWZqYlAvaUc3RFlUUFNNZFUxVjhEeVY5bzIr?=
 =?utf-8?B?NW9pV0Y5RGx4R2dwRmF1TURQcG5iQUh0bWYvV2wwcDVBWWlYaUkyTUxWblh3?=
 =?utf-8?B?YkVmcGl6NytQMkZ4c1dFNEVJS21LbWlUeDVPZW9OeVBoRnh1MDVHdnBKTVR4?=
 =?utf-8?B?KzQ1THFlWTVsU2djVy9qdmZGaWVXOG1ONHNybXd5bmp6NFVuUWZrdkp6dkEw?=
 =?utf-8?B?Y0lYamhTclRIazVWU3BsZWljcGJUOER5SnhuV2FaVzVUa3lUYjBOOWJVTU4w?=
 =?utf-8?B?SDdBbThNd2JvNEZ0VGgyR2pwcFNjQWY5Mm5TdFBBNmlIUFBPN3RsdFNhdDRz?=
 =?utf-8?B?YU91a0FBVGN1Q2RXQTROWWtTQUJCRHowRzdQSnk3YnBLZnNiZXdTYXROM0h3?=
 =?utf-8?B?NHNXQ25ueTBLcGJ1R3JPV3lHMWFKczRDUjFlbzRFdnFoTkkyT0ltaVdwQXJG?=
 =?utf-8?B?TkYzZFZMdDNxOEVaak5UeEthbTZPS2pFcVRxeTNpU01BczdCWUdLQXF1TGdh?=
 =?utf-8?B?YWNUUWNpTEFJOWgyNnF2WXRNSVFIMm5qSDI3TktYT0x4MUgvcHQ0RVNLc3gz?=
 =?utf-8?B?N2JTMjJ5dVM3NXBzWC9naGhsZkhRVndSdDd2VTFxTE8vS3hrWFRmVS9RVHli?=
 =?utf-8?B?OXhKUzBUSDVVT1JXTGlwUFEvRHpHL0wvSDhDbnIxNFoxY2tiOXNoNVRjU2xH?=
 =?utf-8?B?QTI0S01BY2RXaG1SaHNZR252ZUQ3UFhYSk9NVUl1NTVPM01MVXhGbXdrYkt2?=
 =?utf-8?B?OEdCSXBhcHlxKzNjVEJ6bE9VTDliL1BrK0tVRkRzblpMSDEvczVmdEhvMktG?=
 =?utf-8?B?YW9wTnNSdURYN0g1SlIzMktJL2gveG1FbUtvcms0RXBNUGdlZXY4V2hCSlIr?=
 =?utf-8?Q?2Eb14JDtLckiuawo=3D?=
X-OriginatorOrg: vaisala.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f6e7ad07-8780-435f-61ad-08da317fbaba
X-MS-Exchange-CrossTenant-AuthSource: HE1PR0602MB3625.eurprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 May 2022 05:49:49.1918
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 6d7393e0-41f5-4c2e-9b12-4c2be5da5c57
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uzijEUAprNi0bPQXwuAlKHE5qeS9gf3MZj2O39t3VSIGUCxFliTNJmDqCKXRNpEQ/wuEIY4LGXAD/z+WS22wzw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR06MB6648
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Robert,

On 03/05/2022 20:07, Robert Hancock wrote:
> On Tue, 2022-05-03 at 12:57 +0300, Tomas Melin wrote:
>> Hi,
>>
>>
>> On 30/04/2022 01:31, Robert Hancock wrote:
>>> This driver was using the TX IRQ handler to perform all TX completion
>>> tasks. Under heavy TX network load, this can cause significant irqs-off
>>> latencies (found to be in the hundreds of microseconds using ftrace).
>>> This can cause other issues, such as overrunning serial UART FIFOs when
>>> using high baud rates with limited UART FIFO sizes.
>>>
>>> Switch to using the NAPI poll handler to perform the TX completion work
>>> to get this out of hard IRQ context and avoid the IRQ latency impact.
>>>
>>> The TX Used Bit Read interrupt (TXUBR) handling also needs to be moved
>>> into the NAPI poll handler to maintain the proper order of operations. A
>>> flag is used to notify the poll handler that a UBR condition needs to be
>>> handled. The macb_tx_restart handler has had some locking added for global
>>> register access, since this could now potentially happen concurrently on
>>> different queues.
>>>
>>> Signed-off-by: Robert Hancock <robert.hancock@calian.com>
>>> ---
>>>  drivers/net/ethernet/cadence/macb.h      |   1 +
>>>  drivers/net/ethernet/cadence/macb_main.c | 138 +++++++++++++----------
>>>  2 files changed, 80 insertions(+), 59 deletions(-)
>>>
>>> diff --git a/drivers/net/ethernet/cadence/macb.h
>>> b/drivers/net/ethernet/cadence/macb.h
>>> index f0a7d8396a4a..5355cef95a9b 100644
>>> --- a/drivers/net/ethernet/cadence/macb.h
>>> +++ b/drivers/net/ethernet/cadence/macb.h
>>> @@ -1209,6 +1209,7 @@ struct macb_queue {
>>>  	struct macb_tx_skb	*tx_skb;
>>>  	dma_addr_t		tx_ring_dma;
>>>  	struct work_struct	tx_error_task;
>>> +	bool			txubr_pending;
>>>  
>>>  	dma_addr_t		rx_ring_dma;
>>>  	dma_addr_t		rx_buffers_dma;
>>> diff --git a/drivers/net/ethernet/cadence/macb_main.c
>>> b/drivers/net/ethernet/cadence/macb_main.c
>>> index 160dc5ad84ae..1cb8afb8ef0d 100644
>>> --- a/drivers/net/ethernet/cadence/macb_main.c
>>> +++ b/drivers/net/ethernet/cadence/macb_main.c
>>> @@ -959,7 +959,7 @@ static int macb_halt_tx(struct macb *bp)
>>>  	return -ETIMEDOUT;
>>>  }
>>>  
>>> -static void macb_tx_unmap(struct macb *bp, struct macb_tx_skb *tx_skb)
>>> +static void macb_tx_unmap(struct macb *bp, struct macb_tx_skb *tx_skb, int
>>> budget)
>>>  {
>>>  	if (tx_skb->mapping) {
>>>  		if (tx_skb->mapped_as_page)
>>> @@ -972,7 +972,7 @@ static void macb_tx_unmap(struct macb *bp, struct
>>> macb_tx_skb *tx_skb)
>>>  	}
>>>  
>>>  	if (tx_skb->skb) {
>>> -		dev_kfree_skb_any(tx_skb->skb);
>>> +		napi_consume_skb(tx_skb->skb, budget);
>>>  		tx_skb->skb = NULL;
>>>  	}
>>>  }
>>> @@ -1025,12 +1025,13 @@ static void macb_tx_error_task(struct work_struct
>>> *work)
>>>  		    (unsigned int)(queue - bp->queues),
>>>  		    queue->tx_tail, queue->tx_head);
>>>  
>>> -	/* Prevent the queue IRQ handlers from running: each of them may call
>>> -	 * macb_tx_interrupt(), which in turn may call netif_wake_subqueue().
>>> +	/* Prevent the queue NAPI poll from running, as it calls
>>> +	 * macb_tx_complete(), which in turn may call netif_wake_subqueue().
>>>  	 * As explained below, we have to halt the transmission before updating
>>>  	 * TBQP registers so we call netif_tx_stop_all_queues() to notify the
>>>  	 * network engine about the macb/gem being halted.
>>>  	 */
>>> +	napi_disable(&queue->napi);
>>>  	spin_lock_irqsave(&bp->lock, flags);
>>>  
>>>  	/* Make sure nobody is trying to queue up new packets */
>>> @@ -1058,7 +1059,7 @@ static void macb_tx_error_task(struct work_struct
>>> *work)
>>>  		if (ctrl & MACB_BIT(TX_USED)) {
>>>  			/* skb is set for the last buffer of the frame */
>>>  			while (!skb) {
>>> -				macb_tx_unmap(bp, tx_skb);
>>> +				macb_tx_unmap(bp, tx_skb, 0);
>>>  				tail++;
>>>  				tx_skb = macb_tx_skb(queue, tail);
>>>  				skb = tx_skb->skb;
>>> @@ -1088,7 +1089,7 @@ static void macb_tx_error_task(struct work_struct
>>> *work)
>>>  			desc->ctrl = ctrl | MACB_BIT(TX_USED);
>>>  		}
>>>  
>>> -		macb_tx_unmap(bp, tx_skb);
>>> +		macb_tx_unmap(bp, tx_skb, 0);
>>>  	}
>>>  
>>>  	/* Set end of TX queue */
>>> @@ -1118,25 +1119,28 @@ static void macb_tx_error_task(struct work_struct
>>> *work)
>>>  	macb_writel(bp, NCR, macb_readl(bp, NCR) | MACB_BIT(TSTART));
>>>  
>>>  	spin_unlock_irqrestore(&bp->lock, flags);
>>> +	napi_enable(&queue->napi);
>>>  }
>>>  
>>> -static void macb_tx_interrupt(struct macb_queue *queue)
>>> +static bool macb_tx_complete_pending(struct macb_queue *queue)
>>
>> This might be somewhat problematic approach as TX_USED bit could
>> potentially also be set if a descriptor with TX_USED is found mid-frame
>> (for whatever reason).
>> Not sure how it should be done, but it would be nice if TCOMP
>> would rather be known on per queue basis.
> 
> I think this scenario would already have been a problem if it were possible -
> i.e. when we detect the TCOMP interrupt was asserted, it has likely already
> started sending the next frame in the ring when we are processing the ring
> entries, so if a TX_USED bit was set in the middle of a frame we would
> potentially already have been acting on it and likely breaking? So it seems
> like a safe assumption that this doesn't happen, as it that would make it very
> difficult for the driver to tell when a frame was actually done or not..
The consideration was that TCOMP and TX_USED are as such separate
interrupts, so TX_USED can be asserted even though there is no TCOMP.

Mixing terminology could become confusing here. I.e. IMHO
tx_complete_pending should check if there is TCOMP pending and
txubr_pending TX_USED.

> 
>>
>> Related note, rx side function seems to be named as macb_rx_pending(),
>> should be similary macb_tx_pending()?
> 
> I thought that naming might be a bit misleading, as in the TX case we are not
> only interested in whether frames are pending (i.e. in the TX ring to be sent)
> but also there are completed frames in the ring that have not been processed
> yet.

Wouldn't tx_pending() describe that better then? :) (That there is tx
side operations pending to be processed.)

Thanks,
Tomas



> 
>>
>>
>> Thanks,
>> Tomas
>>
>>
>>> +{
>>> +	if (queue->tx_head != queue->tx_tail) {
>>> +		/* Make hw descriptor updates visible to CPU */
>>> +		rmb();
>>> +
>>> +		if (macb_tx_desc(queue, queue->tx_tail)->ctrl &
>>> MACB_BIT(TX_USED))
>>> +			return true;
>>> +	}
>>> +	return false;
>>> +}
>>> +
>>> +static void macb_tx_complete(struct macb_queue *queue, int budget)
>>>  {
>>>  	unsigned int tail;
>>>  	unsigned int head;
>>> -	u32 status;
>>>  	struct macb *bp = queue->bp;
>>>  	u16 queue_index = queue - bp->queues;
>>>  
>>> -	status = macb_readl(bp, TSR);
>>> -	macb_writel(bp, TSR, status);
>>> -
>>> -	if (bp->caps & MACB_CAPS_ISR_CLEAR_ON_WRITE)
>>> -		queue_writel(queue, ISR, MACB_BIT(TCOMP));
>>> -
>>> -	netdev_vdbg(bp->dev, "macb_tx_interrupt status = 0x%03lx\n",
>>> -		    (unsigned long)status);
>>> -
>>>  	head = queue->tx_head;
>>>  	for (tail = queue->tx_tail; tail != head; tail++) {
>>>  		struct macb_tx_skb	*tx_skb;
>>> @@ -1182,7 +1186,7 @@ static void macb_tx_interrupt(struct macb_queue
>>> *queue)
>>>  			}
>>>  
>>>  			/* Now we can safely release resources */
>>> -			macb_tx_unmap(bp, tx_skb);
>>> +			macb_tx_unmap(bp, tx_skb, budget);
>>>  
>>>  			/* skb is set only for the last buffer of the frame.
>>>  			 * WARNING: at this point skb has been freed by
>>> @@ -1569,23 +1573,55 @@ static bool macb_rx_pending(struct macb_queue
>>> *queue)
>>>  	return (desc->addr & MACB_BIT(RX_USED)) != 0;
>>>  }
>>>  
>>> +static void macb_tx_restart(struct macb_queue *queue)
>>> +{
>>> +	unsigned int head = queue->tx_head;
>>> +	unsigned int tail = queue->tx_tail;
>>> +	struct macb *bp = queue->bp;
>>> +	unsigned int head_idx, tbqp;
>>> +
>>> +	if (head == tail)
>>> +		return;
>>> +
>>> +	tbqp = queue_readl(queue, TBQP) / macb_dma_desc_get_size(bp);
>>> +	tbqp = macb_adj_dma_desc_idx(bp, macb_tx_ring_wrap(bp, tbqp));
>>> +	head_idx = macb_adj_dma_desc_idx(bp, macb_tx_ring_wrap(bp, head));
>>> +
>>> +	if (tbqp == head_idx)
>>> +		return;
>>> +
>>> +	spin_lock_irq(&bp->lock);
>>> +	macb_writel(bp, NCR, macb_readl(bp, NCR) | MACB_BIT(TSTART));
>>> +	spin_unlock_irq(&bp->lock);
>>> +}
>>> +
>>>  static int macb_poll(struct napi_struct *napi, int budget)
>>>  {
>>>  	struct macb_queue *queue = container_of(napi, struct macb_queue, napi);
>>>  	struct macb *bp = queue->bp;
>>>  	int work_done;
>>>  
>>> +	macb_tx_complete(queue, budget);
>>> +
>>> +	rmb(); // ensure txubr_pending is up to date
>>> +	if (queue->txubr_pending) {
>>> +		queue->txubr_pending = false;
>>> +		netdev_vdbg(bp->dev, "poll: tx restart\n");
>>> +		macb_tx_restart(queue);
>>> +	}
>>> +
>>>  	work_done = bp->macbgem_ops.mog_rx(queue, napi, budget);
>>>  
>>>  	netdev_vdbg(bp->dev, "poll: queue = %u, work_done = %d, budget = %d\n",
>>>  		    (unsigned int)(queue - bp->queues), work_done, budget);
>>>  
>>>  	if (work_done < budget && napi_complete_done(napi, work_done)) {
>>> -		queue_writel(queue, IER, bp->rx_intr_mask);
>>> +		queue_writel(queue, IER, bp->rx_intr_mask |
>>> +					 MACB_BIT(TCOMP));
>>>  
>>>  		/* Packet completions only seem to propagate to raise
>>>  		 * interrupts when interrupts are enabled at the time, so if
>>> -		 * packets were received while interrupts were disabled,
>>> +		 * packets were sent/received while interrupts were disabled,
>>>  		 * they will not cause another interrupt to be generated when
>>>  		 * interrupts are re-enabled.
>>>  		 * Check for this case here to avoid losing a wakeup. This can
>>> @@ -1593,10 +1629,13 @@ static int macb_poll(struct napi_struct *napi, int
>>> budget)
>>>  		 * actions if an interrupt is raised just after enabling them,
>>>  		 * but this should be harmless.
>>>  		 */
>>> -		if (macb_rx_pending(queue)) {
>>> -			queue_writel(queue, IDR, bp->rx_intr_mask);
>>> +		if (macb_rx_pending(queue) ||
>>> +		    macb_tx_complete_pending(queue)) {
>>> +			queue_writel(queue, IDR, bp->rx_intr_mask |
>>> +						 MACB_BIT(TCOMP));
>>>  			if (bp->caps & MACB_CAPS_ISR_CLEAR_ON_WRITE)
>>> -				queue_writel(queue, ISR, MACB_BIT(RCOMP));
>>> +				queue_writel(queue, ISR, MACB_BIT(RCOMP) |
>>> +							 MACB_BIT(TCOMP));
>>>  			netdev_vdbg(bp->dev, "poll: packets pending,
>>> reschedule\n");
>>>  			napi_schedule(napi);
>>>  		}
>>> @@ -1646,29 +1685,6 @@ static void macb_hresp_error_task(struct
>>> tasklet_struct *t)
>>>  	netif_tx_start_all_queues(dev);
>>>  }
>>>  
>>> -static void macb_tx_restart(struct macb_queue *queue)
>>> -{
>>> -	unsigned int head = queue->tx_head;
>>> -	unsigned int tail = queue->tx_tail;
>>> -	struct macb *bp = queue->bp;
>>> -	unsigned int head_idx, tbqp;
>>> -
>>> -	if (bp->caps & MACB_CAPS_ISR_CLEAR_ON_WRITE)
>>> -		queue_writel(queue, ISR, MACB_BIT(TXUBR));
>>> -
>>> -	if (head == tail)
>>> -		return;
>>> -
>>> -	tbqp = queue_readl(queue, TBQP) / macb_dma_desc_get_size(bp);
>>> -	tbqp = macb_adj_dma_desc_idx(bp, macb_tx_ring_wrap(bp, tbqp));
>>> -	head_idx = macb_adj_dma_desc_idx(bp, macb_tx_ring_wrap(bp, head));
>>> -
>>> -	if (tbqp == head_idx)
>>> -		return;
>>> -
>>> -	macb_writel(bp, NCR, macb_readl(bp, NCR) | MACB_BIT(TSTART));
>>> -}
>>> -
>>>  static irqreturn_t macb_wol_interrupt(int irq, void *dev_id)
>>>  {
>>>  	struct macb_queue *queue = dev_id;
>>> @@ -1754,19 +1770,29 @@ static irqreturn_t macb_interrupt(int irq, void
>>> *dev_id)
>>>  			    (unsigned int)(queue - bp->queues),
>>>  			    (unsigned long)status);
>>>  
>>> -		if (status & bp->rx_intr_mask) {
>>> -			/* There's no point taking any more interrupts
>>> -			 * until we have processed the buffers. The
>>> +		if (status & (bp->rx_intr_mask |
>>> +			      MACB_BIT(TCOMP) |
>>> +			      MACB_BIT(TXUBR))) {
>>> +			/* There's no point taking any more RX/TX completion
>>> +			 * interrupts until we have processed the buffers. The
>>>  			 * scheduling call may fail if the poll routine
>>>  			 * is already scheduled, so disable interrupts
>>>  			 * now.
>>>  			 */
>>> -			queue_writel(queue, IDR, bp->rx_intr_mask);
>>> +			queue_writel(queue, IDR, bp->rx_intr_mask |
>>> +						 MACB_BIT(TCOMP));
>>>  			if (bp->caps & MACB_CAPS_ISR_CLEAR_ON_WRITE)
>>> -				queue_writel(queue, ISR, MACB_BIT(RCOMP));
>>> +				queue_writel(queue, ISR, MACB_BIT(RCOMP) |
>>> +							 MACB_BIT(TCOMP) |> +	
>>> 						 MACB_BIT(TXUBR))> +
>>> +			if (status & MACB_BIT(TXUBR)) {
>>> +				queue->txubr_pending = true;
>>> +				wmb(); // ensure softirq can see update
>>> +			}
>>>  
>>>  			if (napi_schedule_prep(&queue->napi)) {
>>> -				netdev_vdbg(bp->dev, "scheduling RX
>>> softirq\n");
>>> +				netdev_vdbg(bp->dev, "scheduling NAPI
>>> softirq\n");
>>>  				__napi_schedule(&queue->napi);
>>>  			}
>>>  		}
>>> @@ -1781,12 +1807,6 @@ static irqreturn_t macb_interrupt(int irq, void
>>> *dev_id)
>>>  			break;
>>>  		}
>>>  
>>> -		if (status & MACB_BIT(TCOMP))
>>> -			macb_tx_interrupt(queue);
>>> -
>>> -		if (status & MACB_BIT(TXUBR))
>>> -			macb_tx_restart(queue);
>>> -
>>>  		/* Link change detection isn't possible with RMII, so we'll
>>>  		 * add that if/when we get our hands on a full-blown MII PHY.
>>>  		 */
>>> @@ -2019,7 +2039,7 @@ static unsigned int macb_tx_map(struct macb *bp,
>>>  	for (i = queue->tx_head; i != tx_head; i++) {
>>>  		tx_skb = macb_tx_skb(queue, i);
>>>  
>>> -		macb_tx_unmap(bp, tx_skb);
>>> +		macb_tx_unmap(bp, tx_skb, 0);
>>>  	}
>>>  
>>>  	return 0;
