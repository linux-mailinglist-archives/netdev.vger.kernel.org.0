Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E0B04CEA64
	for <lists+netdev@lfdr.de>; Sun,  6 Mar 2022 10:53:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231508AbiCFJyh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Mar 2022 04:54:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230439AbiCFJyg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Mar 2022 04:54:36 -0500
Received: from mo4-p01-ob.smtp.rzone.de (mo4-p01-ob.smtp.rzone.de [85.215.255.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FE5D57B17
        for <netdev@vger.kernel.org>; Sun,  6 Mar 2022 01:53:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1646560411;
    s=strato-dkim-0002; d=hartkopp.net;
    h=In-Reply-To:From:References:Cc:To:Subject:Date:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=rNu0Ym8m91W4x+B9CID615EJ0b14nWRtbgwXQ46xT+M=;
    b=JGQ/VtiI6zZkC4GkrvPuRnAVcsfuW3N3rExg++mSGg62cWrqM0YfDe4Q2B3pMkMRGm
    ikRmtAr0XF0vq2lDpoWiRsCjZHbqvj47TOFYmb2ozTVwO8vX4MAIEz+k2aX8jvbvAT1E
    GgBiBl7D64MerCgJbLf1Kpit00EYXc/0tBal03ffiLFenRwvpa5Zqygr1YPShe6Bqo3+
    UDEtMDgWDRUiYMmp1I3pDb8R9ki9HKl/lQWrnLMlVQyd9sR/Exfhzwinz24qTYGmFBWz
    8+f4YNM82O7oPFnFbCPuFFrRG+RnGYhFejKb5Y//TqBfhiYL27fQkG3fT9Ot3x8pqax9
    tAPg==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjG14FZxedJy6qgO1qCHSa1GLptZHusx3hdd0DIgVuBOfXW6v7w=="
X-RZG-CLASS-ID: mo00
Received: from [IPV6:2a00:6020:1cfa:f900::b82]
    by smtp.strato.de (RZmta 47.40.1 AUTH)
    with ESMTPSA id 6c57e6y269rU4or
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Sun, 6 Mar 2022 10:53:30 +0100 (CET)
Message-ID: <5169c643-76cc-bafa-960f-75c5f8165e6a@hartkopp.net>
Date:   Sun, 6 Mar 2022 10:53:30 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [PATCH net-next 4/8] slip/plip: Use netif_rx().
Content-Language: en-US
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
References: <20220305221252.3063812-1-bigeasy@linutronix.de>
 <20220305221252.3063812-5-bigeasy@linutronix.de>
From:   Oliver Hartkopp <socketcan@hartkopp.net>
In-Reply-To: <20220305221252.3063812-5-bigeasy@linutronix.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 05.03.22 23:12, Sebastian Andrzej Siewior wrote:
> Since commit
>     baebdf48c3600 ("net: dev: Makes sure netif_rx() can be invoked in any context.")
> 
> the function netif_rx() can be used in preemptible/thread context as
> well as in interrupt context.
> 
> Use netif_rx().
> 
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

Acked-by: Oliver Hartkopp <socketcan@hartkopp.net>

(causing both patches)

Thanks,
Oliver

> ---
>   drivers/net/plip/plip.c | 2 +-
>   drivers/net/slip/slip.c | 2 +-
>   2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/plip/plip.c b/drivers/net/plip/plip.c
> index 0d491b4d66675..dafd3e9ebbf87 100644
> --- a/drivers/net/plip/plip.c
> +++ b/drivers/net/plip/plip.c
> @@ -676,7 +676,7 @@ plip_receive_packet(struct net_device *dev, struct net_local *nl,
>   	case PLIP_PK_DONE:
>   		/* Inform the upper layer for the arrival of a packet. */
>   		rcv->skb->protocol=plip_type_trans(rcv->skb, dev);
> -		netif_rx_ni(rcv->skb);
> +		netif_rx(rcv->skb);
>   		dev->stats.rx_bytes += rcv->length.h;
>   		dev->stats.rx_packets++;
>   		rcv->skb = NULL;
> diff --git a/drivers/net/slip/slip.c b/drivers/net/slip/slip.c
> index 98f586f910fb1..88396ff99f03f 100644
> --- a/drivers/net/slip/slip.c
> +++ b/drivers/net/slip/slip.c
> @@ -368,7 +368,7 @@ static void sl_bump(struct slip *sl)
>   	skb_put_data(skb, sl->rbuff, count);
>   	skb_reset_mac_header(skb);
>   	skb->protocol = htons(ETH_P_IP);
> -	netif_rx_ni(skb);
> +	netif_rx(skb);
>   	dev->stats.rx_packets++;
>   }
>   
