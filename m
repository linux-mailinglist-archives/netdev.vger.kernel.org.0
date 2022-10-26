Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6841560E3E3
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 16:58:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234422AbiJZO6T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 10:58:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233690AbiJZO6J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 10:58:09 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08DAF11DA8A
        for <netdev@vger.kernel.org>; Wed, 26 Oct 2022 07:58:08 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id v4-20020a17090a088400b00212cb0ed97eso2332475pjc.5
        for <netdev@vger.kernel.org>; Wed, 26 Oct 2022 07:58:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lQspLFJNk92dGNCql3itw09Xxw2xf+/ZyAlzO0dOHWo=;
        b=AWvAN8eu3xhaAYR219UIA8XCZMmJvJPjxPT8wqr2vcE5guF1SZzFxla4mZBi/vU1Ar
         SZ75lUOKQYSHrD9eZp2MM8fNbyWmtD+QJmKBmBlYoar/4qGyuR2qkbmtah9ABqHN7eM6
         1q6byFmDC2K57VwHJrFIzXdZQI8ACqrrRq/vYND3FuTdj7l7jGtMDrHBjcx+M9gssAvG
         jlvBmhvu8zYfaLG7Wn9FiVDQlyiCKp9F5cW0PPSk7nASkH0TO1o34vaUZIDuy4S63QN4
         3SXqAUrjgNOywT+2xDIe0NhKslZmQjJOy2PM3xd3DgKo5F0tkP/gtsucbNKIDfxstaMn
         nZgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lQspLFJNk92dGNCql3itw09Xxw2xf+/ZyAlzO0dOHWo=;
        b=yDH5bKqduuRh7j83+Q+fg9Bkx3amfeH3SnOh6SqbmkgPzibaoMZ4Qe5KfdoWokKIJ1
         Skeas4Q7fbeu8cFc9uxm1KVFf/4sNaIGP7RBiBjSceCVX99hPPbfgm6jJmdBenaNjRGZ
         is3DSHY3L+NRipOzuhBwKppHhpL2hISYEbmcBgMDuL+Jm3hCmpB4yZIA0wA6yRlDndU9
         LcGFrNpymWXP/lyip3BrFHql3Ze5DFhb2x3a5jFlUJGm6X7qg3NZegeopjq9LBi0rp0Z
         eoRIJnmBU6WRbpOGKeo2yZhQgx0Mmhi/nm2COHZQLwHTJGrctB7aqq7W8wTizWGuKsq6
         jsBg==
X-Gm-Message-State: ACrzQf1pLwE05Ih0zO8l15tAhHrwDR2bTcd1P4B9lFqb0ognQKkZhTXU
        C9SYNqHLAuToKSqibdePzvLgtcSlJJ8=
X-Google-Smtp-Source: AMsMyM5XkuYtKr6/NZgXy1uGAxLWtafzFUVTzHR2a/xe69GxgLTtIr1+ooQ5AZvUQmlBpL1aY6Z6CQ==
X-Received: by 2002:a17:90a:8b93:b0:20a:bd84:5182 with SMTP id z19-20020a17090a8b9300b0020abd845182mr4828595pjn.161.1666796288009;
        Wed, 26 Oct 2022 07:58:08 -0700 (PDT)
Received: from ?IPV6:2600:8802:b00:4a48:1c5e:eaed:5c17:c765? ([2600:8802:b00:4a48:1c5e:eaed:5c17:c765])
        by smtp.gmail.com with ESMTPSA id m19-20020a62a213000000b0056bc1d7816dsm3190885pff.99.2022.10.26.07.58.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Oct 2022 07:58:07 -0700 (PDT)
Message-ID: <9db364c8-f003-4622-8eee-fedb6e6b712e@gmail.com>
Date:   Wed, 26 Oct 2022 07:58:06 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH] net: broadcom: bcm4908_enet: report queued and
 transmitted bytes
To:     =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, bcm-kernel-feedback-list@broadcom.com,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
References: <20221026142624.19314-1-zajec5@gmail.com>
Content-Language: en-US
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20221026142624.19314-1-zajec5@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/26/2022 7:26 AM, Rafał Miłecki wrote:
> From: Rafał Miłecki <rafal@milecki.pl>
> 
> This allows BQL to operate avoiding buffer bloat and reducing latency.
> 
> Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
> ---
>   drivers/net/ethernet/broadcom/bcm4908_enet.c | 7 +++++++
>   1 file changed, 7 insertions(+)
> 
> diff --git a/drivers/net/ethernet/broadcom/bcm4908_enet.c b/drivers/net/ethernet/broadcom/bcm4908_enet.c
> index 93ccf549e2ed..e672a9ef4444 100644
> --- a/drivers/net/ethernet/broadcom/bcm4908_enet.c
> +++ b/drivers/net/ethernet/broadcom/bcm4908_enet.c
> @@ -495,6 +495,7 @@ static int bcm4908_enet_stop(struct net_device *netdev)
>   	netif_carrier_off(netdev);
>   	napi_disable(&rx_ring->napi);
>   	napi_disable(&tx_ring->napi);
> +	netdev_reset_queue(netdev);
>   
>   	bcm4908_enet_dma_rx_ring_disable(enet, &enet->rx_ring);
>   	bcm4908_enet_dma_tx_ring_disable(enet, &enet->tx_ring);
> @@ -564,6 +565,8 @@ static netdev_tx_t bcm4908_enet_start_xmit(struct sk_buff *skb, struct net_devic
>   	enet->netdev->stats.tx_bytes += skb->len;
>   	enet->netdev->stats.tx_packets++;
>   
> +	netdev_sent_queue(enet->netdev, skb->len);

There is an opportunity for fixing an use after free here, after you 
call bcm4908_enet_dma_tx_ring_enable() the hardware can start 
transmission right away and also call the TX completion handler, so you 
could be de-referencing a freed skb reference at this point. Also, to 
ensure that DMA is actually functional, it is recommended to increase TX 
stats in the TX completion handler, since that indicates that you have a 
functional completion process.

So long story short, if you record the skb length *before* calling 
bcm4908_enet_dma_tx_ring_enable() and use that for reporting sent bytes, 
you should be good.
-- 
Florian
