Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04D114CF24F
	for <lists+netdev@lfdr.de>; Mon,  7 Mar 2022 07:55:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231446AbiCGGy5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Mar 2022 01:54:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230224AbiCGGy4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Mar 2022 01:54:56 -0500
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFAB94B1DD
        for <netdev@vger.kernel.org>; Sun,  6 Mar 2022 22:54:02 -0800 (PST)
Received: by mail-lf1-x12d.google.com with SMTP id 3so5850882lfr.7
        for <netdev@vger.kernel.org>; Sun, 06 Mar 2022 22:54:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=girGdnOiuuSK7fyWZgiMbZcZgNPLUXxVPROFqq257GQ=;
        b=UdxjxCgowV21B2ZUc/Rx0ACXq3ygKnLYNluJ92s269Ip/qvGNdYjIfBAi5sgVv2tH5
         7nZDsQfpIGB9aL8O39S2WjCcrUCDt4ypTcDFssyBrHWVYq9EbnIFLXcWl+Fa/2tQRE9U
         kvOLyXgMD83Kt8ia9bQ1H0SK9GV3fBuBnagvH6csY/HigXbz5fP3nUEYZyHROdgm3lUI
         2VsUcZBPVIgp/h1oiu0ioVj495piCvXYR2EanUdHkEgdCLt7o++kwxLN7QzxU3nF0lbp
         ujwM7ZIbOougKGEa18GnQVjSzvK4xksz1g+9paG9lbLPR2r1e3nWQgU+bxGMoOXZx0qM
         u5rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=girGdnOiuuSK7fyWZgiMbZcZgNPLUXxVPROFqq257GQ=;
        b=cuDLik3eKs1wX6EFBIN/mAHw4KOmqlA5sb9Ee7jQbb+UW5x1aUqQFMXacldLS/8v9K
         02Ifw7rUKCYGVLqtbREeiImdjR+xCXJONVimL9vl6qQIICnAm1g04/EIiN2dTJJwo3/1
         u8ZkFpfz7ARHZefK0S0lyUdINn1ongdsLVZvGOeudKC09d3zQYLp0bKHOSMhOnio4N8G
         XuODMr8mXdIeXVsZ86eKdn+PtIkH9Fx1ZrNN53SQJtogaKaQK9hMEKgosX7IFi9UGQNs
         dJDE7D32R39GNoD19epGVfHIdxEDRcr9Y/pGz9i4NrBwqdF8mp558AMEi9rz/OWyN35s
         36ZQ==
X-Gm-Message-State: AOAM533u93/Ue9bLh/Ps+GI+f1eXcl+zyGVdrpmOwknITc32OAvihZ0S
        S30HJ3oKjqbI/ZzBgADg1tZhTKDS5BJD92pc
X-Google-Smtp-Source: ABdhPJxHUI1KUISNDrQy8O5JDNJBV7JHfumiTPz6TGBQIkVbBZ8sUz7jdSk6y76dKeSvz2UD4dbUpA==
X-Received: by 2002:ac2:54ad:0:b0:443:153e:97fc with SMTP id w13-20020ac254ad000000b00443153e97fcmr6848743lfk.252.1646636040932;
        Sun, 06 Mar 2022 22:54:00 -0800 (PST)
Received: from [192.168.8.104] (m91-129-96-255.cust.tele2.ee. [91.129.96.255])
        by smtp.gmail.com with ESMTPSA id i1-20020a2e8641000000b00247d94a6ac5sm1684398ljj.2.2022.03.06.22.53.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 06 Mar 2022 22:54:00 -0800 (PST)
Message-ID: <2013d6c1-cba7-03f2-7b56-1ab47656c928@gmail.com>
Date:   Mon, 7 Mar 2022 08:53:58 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH net-next v3 5/7] net: axienet: implement NAPI and GRO
 receive
Content-Language: en-US
To:     Robert Hancock <robert.hancock@calian.com>, netdev@vger.kernel.org
Cc:     radhey.shyam.pandey@xilinx.com, davem@davemloft.net,
        kuba@kernel.org, michal.simek@xilinx.com, linux@armlinux.org.uk,
        daniel@iogearbox.net, linux-arm-kernel@lists.infradead.org
References: <20220305022443.2708763-1-robert.hancock@calian.com>
 <20220305022443.2708763-6-robert.hancock@calian.com>
From:   Julian Wiedmann <jwiedmann.dev@gmail.com>
In-Reply-To: <20220305022443.2708763-6-robert.hancock@calian.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05.03.22 04:24, Robert Hancock wrote:
> Implement NAPI and GRO receive. In addition to better performance, this
> also avoids handling RX packets in hard IRQ context, which reduces the
> IRQ latency impact to other devices.
> 
> Signed-off-by: Robert Hancock <robert.hancock@calian.com>
> ---
>  drivers/net/ethernet/xilinx/xilinx_axienet.h  |  6 ++
>  .../net/ethernet/xilinx/xilinx_axienet_main.c | 81 ++++++++++++-------
>  2 files changed, 59 insertions(+), 28 deletions(-)
> 

[...]

> -static void axienet_recv(struct net_device *ndev)
> +static int axienet_poll(struct napi_struct *napi, int budget)
>  {
>  	u32 length;
>  	u32 csumstatus;
>  	u32 size = 0;
> -	u32 packets = 0;
> +	int packets = 0;
>  	dma_addr_t tail_p = 0;
> -	struct axienet_local *lp = netdev_priv(ndev);
> -	struct sk_buff *skb, *new_skb;
>  	struct axidma_bd *cur_p;
> +	struct sk_buff *skb, *new_skb;
> +	struct axienet_local *lp = container_of(napi, struct axienet_local, napi);
>  
>  	cur_p = &lp->rx_bd_v[lp->rx_bd_ci];
>  
> -	while ((cur_p->status & XAXIDMA_BD_STS_COMPLETE_MASK)) {
> +	while (packets < budget && (cur_p->status & XAXIDMA_BD_STS_COMPLETE_MASK)) {
>  		dma_addr_t phys;
>  
>  		/* Ensure we see complete descriptor update */
> @@ -918,7 +916,7 @@ static void axienet_recv(struct net_device *ndev)
>  					 DMA_FROM_DEVICE);
>  
>  			skb_put(skb, length);
> -			skb->protocol = eth_type_trans(skb, ndev);
> +			skb->protocol = eth_type_trans(skb, lp->ndev);
>  			/*skb_checksum_none_assert(skb);*/
>  			skb->ip_summed = CHECKSUM_NONE;
>  
> @@ -937,13 +935,13 @@ static void axienet_recv(struct net_device *ndev)
>  				skb->ip_summed = CHECKSUM_COMPLETE;
>  			}
>  
> -			netif_rx(skb);
> +			napi_gro_receive(napi, skb);
>  
>  			size += length;
>  			packets++;
>  		}
>  
> -		new_skb = netdev_alloc_skb_ip_align(ndev, lp->max_frm_size);
> +		new_skb = netdev_alloc_skb_ip_align(lp->ndev, lp->max_frm_size);
>  		if (!new_skb)
>  			break;
>  

Here you should be able to use napi_alloc_skb() now instead.
