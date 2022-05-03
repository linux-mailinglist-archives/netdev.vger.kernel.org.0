Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EE285181CC
	for <lists+netdev@lfdr.de>; Tue,  3 May 2022 11:57:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233774AbiECKBO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 May 2022 06:01:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232918AbiECKBN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 May 2022 06:01:13 -0400
Received: from EUR03-VE1-obe.outbound.protection.outlook.com (mail-eopbgr50042.outbound.protection.outlook.com [40.107.5.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E16235DE2
        for <netdev@vger.kernel.org>; Tue,  3 May 2022 02:57:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bvyVXt/pL/cch1zwMf2pJ5a1LxgER7kWYljsLUt11rTd7Cad65Nn7xJvEoorr0eCPmK2e1cF9BYw7QpWGSk+XcRldAJdEjQVfQn7e3LHLPzqZK5ZFUDSxExZENJcQ2i4uRex6QSnewvpGtljS894hLgie3Sf7Zsr/isvY4sVqZxI8ylfQtHIYYKGQ7csUPWjt3eZTliTQTCbuRikUN26bo+f6P+OK35oc57ooWeOCqWSysmoVoEwEn6Er6P1ncfldGIExy24O41/eLfQoThynmcGw4PzmFXg6/6MyXF0ixFqUdcdOemmaSOYBTdIy7CbTGQurwp3e+Vf3eGfiCHfSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xVVxzk+J0oFw42ywUpnRsui9FJYCA0F2nrAIxCFpJbs=;
 b=evtfYKQ/1p/4RO13ZFrr9QeZBYgQ055pknEa+4bDAlxW77SLw4muVjr8c99xjG1nyEeV3fnAU9vZ8fdDpOUheIXCPF+jFfos17cr94NK4O8QCqaAqb2t5MaQaPbuPmv8ovBVKu7DHF07wGqchxL4ZTm7A/tpWZvEBL+NTrOysA55nImoi2CbqshldZ7g3RxLGMGyh3KujbxvZ17VccNZMss9OjIGWWUB0onX1GXCl83O9NqVbV/uALWI/8KuDZvAAmWy4nPhFdlf3ap2kUHPZJ93+78fe/jsGQV+61jISxLQdpRF3m6RORJMIFFrKRwfvFap/sQgTJvhI0R4WBcODw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vaisala.com; dmarc=pass action=none header.from=vaisala.com;
 dkim=pass header.d=vaisala.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vaisala.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xVVxzk+J0oFw42ywUpnRsui9FJYCA0F2nrAIxCFpJbs=;
 b=bZqwhjjZjrc3iQ6tfmYvPYYIUSGTNSawa53KUOq37cJuoCH/xQCc9Ut9gVyw297ogexpwACQsosJYM72RoF72/FL+b33jIUdStznpuylgJWzAnh1eumn09IMhQlJYS9cwq8NTCtpHLoVG0HWrfn44WNd9wFQA5vPlJSSCmu9RHNuH27nten8tjgKi8xE7M3/mtv/79gKRzx8cGeUe+tKqVWAJ21QQeMb9FwdhT4xEXAJb43wM2HJEdndBqKFLpKb8UW5DTc4LM9hnznBmmFqg96T4xvGJUfycNe5OQ6AlhBfnQ0irnSwCwSJ4+JBF5CQfsZwxl+aEQZlGahmSKp9Jw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vaisala.com;
Received: from HE1PR0602MB3625.eurprd06.prod.outlook.com (2603:10a6:7:81::18)
 by AM0PR0602MB3555.eurprd06.prod.outlook.com (2603:10a6:208:1f::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.14; Tue, 3 May
 2022 09:57:37 +0000
Received: from HE1PR0602MB3625.eurprd06.prod.outlook.com
 ([fe80::5872:9ec6:429c:9de7]) by HE1PR0602MB3625.eurprd06.prod.outlook.com
 ([fe80::5872:9ec6:429c:9de7%4]) with mapi id 15.20.5206.012; Tue, 3 May 2022
 09:57:38 +0000
Message-ID: <d75679b0-d9a7-619f-bc35-a63704c255ee@vaisala.com>
Date:   Tue, 3 May 2022 12:57:34 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH net-next 2/2] net: macb: use NAPI for TX completion path
Content-Language: en-US
To:     Robert Hancock <robert.hancock@calian.com>, netdev@vger.kernel.org
Cc:     nicolas.ferre@microchip.com, claudiu.beznea@microchip.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
References: <20220429223122.3642255-1-robert.hancock@calian.com>
 <20220429223122.3642255-3-robert.hancock@calian.com>
From:   Tomas Melin <tomas.melin@vaisala.com>
In-Reply-To: <20220429223122.3642255-3-robert.hancock@calian.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: OL1P279CA0055.NORP279.PROD.OUTLOOK.COM
 (2603:10a6:e10:15::6) To HE1PR0602MB3625.eurprd06.prod.outlook.com
 (2603:10a6:7:81::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dcaaf951-7b6e-44c1-ee19-08da2ceb5abd
X-MS-TrafficTypeDiagnostic: AM0PR0602MB3555:EE_
X-Microsoft-Antispam-PRVS: <AM0PR0602MB3555BDFAF5D6575753AA660FFDC09@AM0PR0602MB3555.eurprd06.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: J8cqZn3WL+AFjA/F1b7zEWjdV4DuF+2DHE3zPdSBXBmRVp5VWhlXw8XgfKELWnWFWTQqxbgAEenmGCwlsXySoxd5yB/E9IEYsPt10N94Rv+6bXMPEb6pYoEyAZxpOGpOXNt9QxnHu99oCQPLlXJnEUlhCfwFBnpMgl/hw/kKx3dfHR2Ycxinwqz55kWrsxsNIt6e1HX/devhNctuTRaZrkTXLEnRpv0gIsrGvGl9fxf8OsQJjuQlo9vOXaJixWPQIDAeUIN2PyCtLCDWFoeOKmTSRh+X65I+E3VvjR6j6BnUXZDtvYVctcrbmMCoMPfLVBa85Z38/dGVHXhljuoqidRzgbEl7pL6KIYc+driq9K/tCOsNnqwntvdFzh6IFHRXC0ie99uls6LObzuGKTDG7Lpe5f6geSYpGuJyg3ed5iLoWz+lGI7qR0orx4hHh5Vk3xrYI4a5DDszWMEACu++shsdDLQTod0b7i470sNEypWPA3Qd4B6bvB6xaYU0Ntmt9iaTyddMOQp4HSCen4TrfhdOZM4gqXZAZ2WwLfyXCobblRC2FIvdfnNY0l1fyeUq4wP7aTnLBhLYZ1WzzPWnonnzxVBf2uGpOi07xK/znv+OYqIq58fmHt7MaxEsSLk8Q/iaIPjtEFXxg9Vv3nuhklJUh1Iu58r7mRfPRAuz961holY3PYu/C5bBrPTSN5VyLknxIOJ659QcaIoRFkuPoZ/0UBYnQTMOLjfwMDJdV85x49+LnHtzVa9iXRro/Q2
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR0602MB3625.eurprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(31696002)(44832011)(2906002)(26005)(4326008)(8676002)(36756003)(66946007)(66476007)(31686004)(86362001)(66556008)(6666004)(316002)(8936002)(30864003)(5660300002)(38100700002)(2616005)(508600001)(83380400001)(186003)(6486002)(6506007)(6512007)(53546011)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SDl0Ym9Da2tLUjIvNDltU3FYcmVzNTZhK3IwSXFMQWdGVUtJSnVUUHQrM1Bh?=
 =?utf-8?B?S2RBR0NBNjhqVTIvbFduZS93Ujg4Z3JwNzJ5SXZzb1RNeU1DdW03dURqcXow?=
 =?utf-8?B?MkYvSGFrWnV6b3Y5Umozc3Y5U28zNXNlRVg4TS9iMWYrT0ZtbVdaS2svVHlv?=
 =?utf-8?B?Ynp5dkRTTGJldHhjaVJJbVlsK0w5cVE4RkRkVEpMaXdmMmZZNHdNR3RQMUc3?=
 =?utf-8?B?TWpwd2t0RUpKWUM0QWNrYzZiQ244KzRrRG1QNnU0TlFNOS9SeHpLQTF3QjIr?=
 =?utf-8?B?M0NqNHMzN2RodXlvZGJ1Q3dsb0w3L3FYTUZCMUI5OU5DNlNRTHlWSXlTQXhv?=
 =?utf-8?B?SXJFRnE4ZHk5dGoxYTFMemdIeFZERGJzYyswTkM3a05acHNGNGF4WWxBNUlR?=
 =?utf-8?B?MHRhREFQYXd4WU5uUXQ4a21wSC9sdzRoRkQvaTZmc25xMUM5alI2dEpRYy9y?=
 =?utf-8?B?SGVtcXdUaFB1NDY1WGQra3c1UmRBdWhqREVMdTliMDRxNDhNdlhEZEJhVkxz?=
 =?utf-8?B?UjQ1U2QwdzZRc2Z1ajkzckVIeFUrNEgxbXpaNGpBZzVhNzNURHBHcmp3U0tG?=
 =?utf-8?B?UEZJVW11cE1ESlhuU2tMSExRZmZVT1VJNGNUTUp4TmR3RHEzV0QyU1lPeDE0?=
 =?utf-8?B?eEVmYk9WejJoM2R6SFViMnpzaDdVS1o3Wm9CcWExRWNUbm4rRTZoblRNSHp1?=
 =?utf-8?B?YjFCbmJXM3RVOG5IQStrcW8rUzRZWHFnK09XanFzTm5UZ0s3bmcxWVBqcjRM?=
 =?utf-8?B?SFgrSEdsbUJkZVpGMkxpWGdRVjYxMjJTQjhYREwxSmU3Rkh0TFlLUWVxcklI?=
 =?utf-8?B?ejltM2dyRFBCdzd5eUlUZm1qTmxkYzhIQThXTjNEZXdtcVhMd1NxY3owMVNU?=
 =?utf-8?B?bUhzTmlaTW1iRDgrMHlsYndrLzJKOXJkd1dXOVh6VUdKeDJ4UU9IODU2eElh?=
 =?utf-8?B?MHdXVWZ2Qk1jK3FmWmkzRVZzdWdsOW43VTVsYVJaZFN2M2NENkRnZThmb3dV?=
 =?utf-8?B?ZVdlR2V3cUk4dWFoc21zeFdzMWZiL0ZndngrQ3kxb1hRUjBZbjZBV01TclRQ?=
 =?utf-8?B?Y2ZzMWdpODF1TER4QWNOai9taEZndHFsbkwzUVJyTFpMemV3N2FzeXZ5aWls?=
 =?utf-8?B?YWpuWW5oUmplR044TERxVzBueXNDb1d1V01VcnpZeEFTb0kxYUF0eGlsWmlH?=
 =?utf-8?B?aFY3cmVJN3JRNWJ2RDhHWGpnUzFCNzlFb3hnRnV6aURleXNSaUdNQnFabWc0?=
 =?utf-8?B?d2c1cmsyV3JiTTJEU1hybWZZK0J4Z1p2aHNIbnVIdHNQZ200eUhQWmFJRmJh?=
 =?utf-8?B?QW1FRm5DRExEQVZEY2MxemZTRXhhbityN1RJRDVWcG9FK2xCZGsxdk5Bc0Nh?=
 =?utf-8?B?RHZCNVVLSGJoVTJydUx1K0FhSWorVk5mZmZuU0VGdjM5alNBOGg1cC9aMGtC?=
 =?utf-8?B?MlRPTFNBbzlBQm9McVRhSUlqbURrLzZxSVkzdDRndEJJNFkzcGxDZGxIVHVz?=
 =?utf-8?B?WTkza3FNWWtrL2d1aDNFVVk1QytYYVo5c2RjVjlna2JuT1FjM3VNZ2VXWkxS?=
 =?utf-8?B?ZU1SYVRxUEZ1ckFhVXhVOE5BRTBJV1IxVjQ4d3VJN2hkWGx6Tk9DTnNJcmVu?=
 =?utf-8?B?eDRrY3VKLzBkL1BndVhVT1gyM3FJN0I5dDV2SWQxM3VxYTB3Nlg2Qkhxc01X?=
 =?utf-8?B?djlFVFMyWVNGS3Zwc0xBQ0NISGs4WDFLY0x1WnJlQ0VGbnhiOWxlOW14WDRE?=
 =?utf-8?B?KzdNL3RST2x4WVNDVFBxTW5XZFhnQWFiRko3OTNTbDBoT3RYQ2c0Znl6QlVV?=
 =?utf-8?B?ZHJzM2RwYkY4RDIvS0RxZnZYRU5SMUVxMkQxMTBsbktlS2xiYndUdDN1RTN3?=
 =?utf-8?B?U0NySHppUDJCbHBOd1JtNmk2dVRLVGJlRDJQSUE4MHg2ZFVRL3ZRYjNVdEFG?=
 =?utf-8?B?bGkxTXh4NUFIb2VWVU9kU1AvcGUxbG5CeTdweTNsbFdrUmdXRHhkZkltc3Nj?=
 =?utf-8?B?WW9oQ0pLSG9VanJsaDBBallUV0F5MFpMTUxWaUVaWnRsUEErZE1QRUVabDVq?=
 =?utf-8?B?YS80K0w2WHhYQ2dUMkdZWjZMNUwveHVlVlgvelhlMVYxazBlTWJ5SEdXTytm?=
 =?utf-8?B?S2hzc2lHRG5jYUg4SzQvZlBLLzAxVE1TUDF1MFJuTG9yclhvVlRHSG5xcG03?=
 =?utf-8?B?UDg1QmNKcVlwY3Q2WDMra1kvT2gyb3pHbWNYRzlJRno3M3FrTW1ITEQyMzdz?=
 =?utf-8?B?OTQvZ2ZzZmhEa0xWUElGT0NyRjRORzlSWHBhbjBncWhqYzJJd1VHRkI1TlhR?=
 =?utf-8?B?dlpqMGk3RkZ5MWxYVmQxTHNqZFBuTG9TaHg4N2VETm1adnp1dU5TcWNpdnIv?=
 =?utf-8?Q?BkcNLcztynqSYZCU=3D?=
X-OriginatorOrg: vaisala.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dcaaf951-7b6e-44c1-ee19-08da2ceb5abd
X-MS-Exchange-CrossTenant-AuthSource: HE1PR0602MB3625.eurprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 May 2022 09:57:38.0179
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 6d7393e0-41f5-4c2e-9b12-4c2be5da5c57
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dTSaAaOzY/nHoE8FgEJlY5n5grIZpoMslSjvO4JSi/HLjcIdViP94W0qjqrSun8wYtAG0qflcbaRaAjz0eCuCA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR0602MB3555
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,


On 30/04/2022 01:31, Robert Hancock wrote:
> This driver was using the TX IRQ handler to perform all TX completion
> tasks. Under heavy TX network load, this can cause significant irqs-off
> latencies (found to be in the hundreds of microseconds using ftrace).
> This can cause other issues, such as overrunning serial UART FIFOs when
> using high baud rates with limited UART FIFO sizes.
> 
> Switch to using the NAPI poll handler to perform the TX completion work
> to get this out of hard IRQ context and avoid the IRQ latency impact.
> 
> The TX Used Bit Read interrupt (TXUBR) handling also needs to be moved
> into the NAPI poll handler to maintain the proper order of operations. A
> flag is used to notify the poll handler that a UBR condition needs to be
> handled. The macb_tx_restart handler has had some locking added for global
> register access, since this could now potentially happen concurrently on
> different queues.
> 
> Signed-off-by: Robert Hancock <robert.hancock@calian.com>
> ---
>  drivers/net/ethernet/cadence/macb.h      |   1 +
>  drivers/net/ethernet/cadence/macb_main.c | 138 +++++++++++++----------
>  2 files changed, 80 insertions(+), 59 deletions(-)
> 
> diff --git a/drivers/net/ethernet/cadence/macb.h b/drivers/net/ethernet/cadence/macb.h
> index f0a7d8396a4a..5355cef95a9b 100644
> --- a/drivers/net/ethernet/cadence/macb.h
> +++ b/drivers/net/ethernet/cadence/macb.h
> @@ -1209,6 +1209,7 @@ struct macb_queue {
>  	struct macb_tx_skb	*tx_skb;
>  	dma_addr_t		tx_ring_dma;
>  	struct work_struct	tx_error_task;
> +	bool			txubr_pending;
>  
>  	dma_addr_t		rx_ring_dma;
>  	dma_addr_t		rx_buffers_dma;
> diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
> index 160dc5ad84ae..1cb8afb8ef0d 100644
> --- a/drivers/net/ethernet/cadence/macb_main.c
> +++ b/drivers/net/ethernet/cadence/macb_main.c
> @@ -959,7 +959,7 @@ static int macb_halt_tx(struct macb *bp)
>  	return -ETIMEDOUT;
>  }
>  
> -static void macb_tx_unmap(struct macb *bp, struct macb_tx_skb *tx_skb)
> +static void macb_tx_unmap(struct macb *bp, struct macb_tx_skb *tx_skb, int budget)
>  {
>  	if (tx_skb->mapping) {
>  		if (tx_skb->mapped_as_page)
> @@ -972,7 +972,7 @@ static void macb_tx_unmap(struct macb *bp, struct macb_tx_skb *tx_skb)
>  	}
>  
>  	if (tx_skb->skb) {
> -		dev_kfree_skb_any(tx_skb->skb);
> +		napi_consume_skb(tx_skb->skb, budget);
>  		tx_skb->skb = NULL;
>  	}
>  }
> @@ -1025,12 +1025,13 @@ static void macb_tx_error_task(struct work_struct *work)
>  		    (unsigned int)(queue - bp->queues),
>  		    queue->tx_tail, queue->tx_head);
>  
> -	/* Prevent the queue IRQ handlers from running: each of them may call
> -	 * macb_tx_interrupt(), which in turn may call netif_wake_subqueue().
> +	/* Prevent the queue NAPI poll from running, as it calls
> +	 * macb_tx_complete(), which in turn may call netif_wake_subqueue().
>  	 * As explained below, we have to halt the transmission before updating
>  	 * TBQP registers so we call netif_tx_stop_all_queues() to notify the
>  	 * network engine about the macb/gem being halted.
>  	 */
> +	napi_disable(&queue->napi);
>  	spin_lock_irqsave(&bp->lock, flags);
>  
>  	/* Make sure nobody is trying to queue up new packets */
> @@ -1058,7 +1059,7 @@ static void macb_tx_error_task(struct work_struct *work)
>  		if (ctrl & MACB_BIT(TX_USED)) {
>  			/* skb is set for the last buffer of the frame */
>  			while (!skb) {
> -				macb_tx_unmap(bp, tx_skb);
> +				macb_tx_unmap(bp, tx_skb, 0);
>  				tail++;
>  				tx_skb = macb_tx_skb(queue, tail);
>  				skb = tx_skb->skb;
> @@ -1088,7 +1089,7 @@ static void macb_tx_error_task(struct work_struct *work)
>  			desc->ctrl = ctrl | MACB_BIT(TX_USED);
>  		}
>  
> -		macb_tx_unmap(bp, tx_skb);
> +		macb_tx_unmap(bp, tx_skb, 0);
>  	}
>  
>  	/* Set end of TX queue */
> @@ -1118,25 +1119,28 @@ static void macb_tx_error_task(struct work_struct *work)
>  	macb_writel(bp, NCR, macb_readl(bp, NCR) | MACB_BIT(TSTART));
>  
>  	spin_unlock_irqrestore(&bp->lock, flags);
> +	napi_enable(&queue->napi);
>  }
>  
> -static void macb_tx_interrupt(struct macb_queue *queue)
> +static bool macb_tx_complete_pending(struct macb_queue *queue)

This might be somewhat problematic approach as TX_USED bit could
potentially also be set if a descriptor with TX_USED is found mid-frame
(for whatever reason).
Not sure how it should be done, but it would be nice if TCOMP
would rather be known on per queue basis.

Related note, rx side function seems to be named as macb_rx_pending(),
should be similary macb_tx_pending()?


Thanks,
Tomas


> +{
> +	if (queue->tx_head != queue->tx_tail) {
> +		/* Make hw descriptor updates visible to CPU */
> +		rmb();
> +
> +		if (macb_tx_desc(queue, queue->tx_tail)->ctrl & MACB_BIT(TX_USED))
> +			return true;
> +	}
> +	return false;
> +}
> +
> +static void macb_tx_complete(struct macb_queue *queue, int budget)
>  {
>  	unsigned int tail;
>  	unsigned int head;
> -	u32 status;
>  	struct macb *bp = queue->bp;
>  	u16 queue_index = queue - bp->queues;
>  
> -	status = macb_readl(bp, TSR);
> -	macb_writel(bp, TSR, status);
> -
> -	if (bp->caps & MACB_CAPS_ISR_CLEAR_ON_WRITE)
> -		queue_writel(queue, ISR, MACB_BIT(TCOMP));
> -
> -	netdev_vdbg(bp->dev, "macb_tx_interrupt status = 0x%03lx\n",
> -		    (unsigned long)status);
> -
>  	head = queue->tx_head;
>  	for (tail = queue->tx_tail; tail != head; tail++) {
>  		struct macb_tx_skb	*tx_skb;
> @@ -1182,7 +1186,7 @@ static void macb_tx_interrupt(struct macb_queue *queue)
>  			}
>  
>  			/* Now we can safely release resources */
> -			macb_tx_unmap(bp, tx_skb);
> +			macb_tx_unmap(bp, tx_skb, budget);
>  
>  			/* skb is set only for the last buffer of the frame.
>  			 * WARNING: at this point skb has been freed by
> @@ -1569,23 +1573,55 @@ static bool macb_rx_pending(struct macb_queue *queue)
>  	return (desc->addr & MACB_BIT(RX_USED)) != 0;
>  }
>  
> +static void macb_tx_restart(struct macb_queue *queue)
> +{
> +	unsigned int head = queue->tx_head;
> +	unsigned int tail = queue->tx_tail;
> +	struct macb *bp = queue->bp;
> +	unsigned int head_idx, tbqp;
> +
> +	if (head == tail)
> +		return;
> +
> +	tbqp = queue_readl(queue, TBQP) / macb_dma_desc_get_size(bp);
> +	tbqp = macb_adj_dma_desc_idx(bp, macb_tx_ring_wrap(bp, tbqp));
> +	head_idx = macb_adj_dma_desc_idx(bp, macb_tx_ring_wrap(bp, head));
> +
> +	if (tbqp == head_idx)
> +		return;
> +
> +	spin_lock_irq(&bp->lock);
> +	macb_writel(bp, NCR, macb_readl(bp, NCR) | MACB_BIT(TSTART));
> +	spin_unlock_irq(&bp->lock);
> +}
> +
>  static int macb_poll(struct napi_struct *napi, int budget)
>  {
>  	struct macb_queue *queue = container_of(napi, struct macb_queue, napi);
>  	struct macb *bp = queue->bp;
>  	int work_done;
>  
> +	macb_tx_complete(queue, budget);
> +
> +	rmb(); // ensure txubr_pending is up to date
> +	if (queue->txubr_pending) {
> +		queue->txubr_pending = false;
> +		netdev_vdbg(bp->dev, "poll: tx restart\n");
> +		macb_tx_restart(queue);
> +	}
> +
>  	work_done = bp->macbgem_ops.mog_rx(queue, napi, budget);
>  
>  	netdev_vdbg(bp->dev, "poll: queue = %u, work_done = %d, budget = %d\n",
>  		    (unsigned int)(queue - bp->queues), work_done, budget);
>  
>  	if (work_done < budget && napi_complete_done(napi, work_done)) {
> -		queue_writel(queue, IER, bp->rx_intr_mask);
> +		queue_writel(queue, IER, bp->rx_intr_mask |
> +					 MACB_BIT(TCOMP));
>  
>  		/* Packet completions only seem to propagate to raise
>  		 * interrupts when interrupts are enabled at the time, so if
> -		 * packets were received while interrupts were disabled,
> +		 * packets were sent/received while interrupts were disabled,
>  		 * they will not cause another interrupt to be generated when
>  		 * interrupts are re-enabled.
>  		 * Check for this case here to avoid losing a wakeup. This can
> @@ -1593,10 +1629,13 @@ static int macb_poll(struct napi_struct *napi, int budget)
>  		 * actions if an interrupt is raised just after enabling them,
>  		 * but this should be harmless.
>  		 */
> -		if (macb_rx_pending(queue)) {
> -			queue_writel(queue, IDR, bp->rx_intr_mask);
> +		if (macb_rx_pending(queue) ||
> +		    macb_tx_complete_pending(queue)) {
> +			queue_writel(queue, IDR, bp->rx_intr_mask |
> +						 MACB_BIT(TCOMP));
>  			if (bp->caps & MACB_CAPS_ISR_CLEAR_ON_WRITE)
> -				queue_writel(queue, ISR, MACB_BIT(RCOMP));
> +				queue_writel(queue, ISR, MACB_BIT(RCOMP) |
> +							 MACB_BIT(TCOMP));
>  			netdev_vdbg(bp->dev, "poll: packets pending, reschedule\n");
>  			napi_schedule(napi);
>  		}
> @@ -1646,29 +1685,6 @@ static void macb_hresp_error_task(struct tasklet_struct *t)
>  	netif_tx_start_all_queues(dev);
>  }
>  
> -static void macb_tx_restart(struct macb_queue *queue)
> -{
> -	unsigned int head = queue->tx_head;
> -	unsigned int tail = queue->tx_tail;
> -	struct macb *bp = queue->bp;
> -	unsigned int head_idx, tbqp;
> -
> -	if (bp->caps & MACB_CAPS_ISR_CLEAR_ON_WRITE)
> -		queue_writel(queue, ISR, MACB_BIT(TXUBR));
> -
> -	if (head == tail)
> -		return;
> -
> -	tbqp = queue_readl(queue, TBQP) / macb_dma_desc_get_size(bp);
> -	tbqp = macb_adj_dma_desc_idx(bp, macb_tx_ring_wrap(bp, tbqp));
> -	head_idx = macb_adj_dma_desc_idx(bp, macb_tx_ring_wrap(bp, head));
> -
> -	if (tbqp == head_idx)
> -		return;
> -
> -	macb_writel(bp, NCR, macb_readl(bp, NCR) | MACB_BIT(TSTART));
> -}
> -
>  static irqreturn_t macb_wol_interrupt(int irq, void *dev_id)
>  {
>  	struct macb_queue *queue = dev_id;
> @@ -1754,19 +1770,29 @@ static irqreturn_t macb_interrupt(int irq, void *dev_id)
>  			    (unsigned int)(queue - bp->queues),
>  			    (unsigned long)status);
>  
> -		if (status & bp->rx_intr_mask) {
> -			/* There's no point taking any more interrupts
> -			 * until we have processed the buffers. The
> +		if (status & (bp->rx_intr_mask |
> +			      MACB_BIT(TCOMP) |
> +			      MACB_BIT(TXUBR))) {
> +			/* There's no point taking any more RX/TX completion
> +			 * interrupts until we have processed the buffers. The
>  			 * scheduling call may fail if the poll routine
>  			 * is already scheduled, so disable interrupts
>  			 * now.
>  			 */
> -			queue_writel(queue, IDR, bp->rx_intr_mask);
> +			queue_writel(queue, IDR, bp->rx_intr_mask |
> +						 MACB_BIT(TCOMP));
>  			if (bp->caps & MACB_CAPS_ISR_CLEAR_ON_WRITE)
> -				queue_writel(queue, ISR, MACB_BIT(RCOMP));
> +				queue_writel(queue, ISR, MACB_BIT(RCOMP) |
> +							 MACB_BIT(TCOMP) |> +							 MACB_BIT(TXUBR))> +
> +			if (status & MACB_BIT(TXUBR)) {
> +				queue->txubr_pending = true;
> +				wmb(); // ensure softirq can see update
> +			}
>  
>  			if (napi_schedule_prep(&queue->napi)) {
> -				netdev_vdbg(bp->dev, "scheduling RX softirq\n");
> +				netdev_vdbg(bp->dev, "scheduling NAPI softirq\n");
>  				__napi_schedule(&queue->napi);
>  			}
>  		}
> @@ -1781,12 +1807,6 @@ static irqreturn_t macb_interrupt(int irq, void *dev_id)
>  			break;
>  		}
>  
> -		if (status & MACB_BIT(TCOMP))
> -			macb_tx_interrupt(queue);
> -
> -		if (status & MACB_BIT(TXUBR))
> -			macb_tx_restart(queue);
> -
>  		/* Link change detection isn't possible with RMII, so we'll
>  		 * add that if/when we get our hands on a full-blown MII PHY.
>  		 */
> @@ -2019,7 +2039,7 @@ static unsigned int macb_tx_map(struct macb *bp,
>  	for (i = queue->tx_head; i != tx_head; i++) {
>  		tx_skb = macb_tx_skb(queue, i);
>  
> -		macb_tx_unmap(bp, tx_skb);
> +		macb_tx_unmap(bp, tx_skb, 0);
>  	}
>  
>  	return 0;
