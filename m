Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 331675F8794
	for <lists+netdev@lfdr.de>; Sat,  8 Oct 2022 23:53:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229561AbiJHVxW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Oct 2022 17:53:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbiJHVxV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Oct 2022 17:53:21 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D911E31DF9
        for <netdev@vger.kernel.org>; Sat,  8 Oct 2022 14:53:19 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id l22so11313596edj.5
        for <netdev@vger.kernel.org>; Sat, 08 Oct 2022 14:53:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=WWnu/e75grG8zQoYg6HqJPh8lKO50wYkxeDWkUb70dU=;
        b=JvcRkXAI4sjgMpwbxseElRiKa32DIFX6U2Rqqk+j6wpue/cBLlLhL/djEs8FjhOl/j
         M6U+23XWPCADU5EW6DI+nbYe682vdWw+dGKc+3sYUJ9gdPB3qr+lxjJfGFJ4AEwK12qb
         MkeSqdC79HYba1KeS/cbPPg5Q/OI87xX1uFllarL/lGAAZVl9JVW2J3ky36vVLLjYWQk
         LbSTO7t+Ub1aAJ59v8AKai6HhLShRfx2wR6Wfh7bAiScmSMCSgm5MvTBD+FJj+JWuETc
         u96bIxwqWv9h7+DhIfUBuWZGzuOsVqI86cqoZobcumyQaQBIAK0CJGDBNakoySkzdlay
         oZrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WWnu/e75grG8zQoYg6HqJPh8lKO50wYkxeDWkUb70dU=;
        b=Y7ezCiyO1B8lvnda+hojstUa5mFylFvBv8Hct2v7ac+C0uhYzsrr8McI+zmskPtHXC
         41AJCQGJDMy8nCP2Hm7cvcWAKnvTaARyHaItkKS5DDCswKMKde9UxMw5SdFJClyymv3l
         GXVlfcq1gtN6xo/pfWiPt7peLzb3OE/JnUh4hYHmTl6Wk7H2kYFxq1Yyabrn9g4jAUJS
         k8STXR4t89AkQ1H9/4w14yuK5w3Cacf5QK/HLNP2+8UZp1/KJQecmhL1c96NRj6TO7VL
         1XuwseabOhvujDq99Y0J51s9TI43VlPYQXxjXSBxuUV8CPF5BGZpxDK5e+lrnNn/6hzI
         JQ8A==
X-Gm-Message-State: ACrzQf0vG/aaeEIA8kno8VhjWP6fYslRbESYdiq65e7rUfoCWxvHDZlx
        PRKFYm12dCNrxR0MxVNV7os=
X-Google-Smtp-Source: AMsMyM4yF0CdKqSC9UAwNpuHOva7519pBCY5zD9LHyATq6kylYW1FITYsuulP41L7bP/JB3l/a3HIA==
X-Received: by 2002:aa7:d848:0:b0:458:9ccc:f605 with SMTP id f8-20020aa7d848000000b004589cccf605mr10768383eds.68.1665265998413;
        Sat, 08 Oct 2022 14:53:18 -0700 (PDT)
Received: from ?IPV6:2a01:c23:b845:3000:401c:95b2:a7eb:33c5? (dynamic-2a01-0c23-b845-3000-401c-95b2-a7eb-33c5.c23.pool.telefonica.de. [2a01:c23:b845:3000:401c:95b2:a7eb:33c5])
        by smtp.googlemail.com with ESMTPSA id p4-20020a170906604400b0078015cebd8csm3216126ejj.117.2022.10.08.14.53.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 08 Oct 2022 14:53:17 -0700 (PDT)
Message-ID: <f9657431-68d7-6d38-d140-a69c203808f2@gmail.com>
Date:   Sat, 8 Oct 2022 23:53:13 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH net] r8169: fix rtl8125b dmar pte write access not set
 error
Content-Language: en-US
To:     Chunhao Lin <hau@realtek.com>
Cc:     netdev@vger.kernel.org, nic_swsd@realtek.com, kuba@kernel.org,
        grundler@chromium.org
References: <20221004081037.34064-1-hau@realtek.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
In-Reply-To: <20221004081037.34064-1-hau@realtek.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 04.10.2022 10:10, Chunhao Lin wrote:
> When close device, rx will be enabled if wol is enabeld. When open device
> it will cause rx to dma to wrong address after pci_set_master().
> 
> In this patch, driver will disable tx/rx when close device. If wol is
> eanbled only enable rx filter and disable rxdv_gate to let hardware
> can receive packet to fifo but not to dma it.
> 
> Fixes: 120068481405 ("r8169: fix failing WoL")
> Signed-off-by: Chunhao Lin <hau@realtek.com>
> ---
>  drivers/net/ethernet/realtek/r8169_main.c | 14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
> index 1b7fdb4f056b..c09cfbe1d3f0 100644
> --- a/drivers/net/ethernet/realtek/r8169_main.c
> +++ b/drivers/net/ethernet/realtek/r8169_main.c
> @@ -2239,6 +2239,9 @@ static void rtl_wol_enable_rx(struct rtl8169_private *tp)
>  	if (tp->mac_version >= RTL_GIGA_MAC_VER_25)
>  		RTL_W32(tp, RxConfig, RTL_R32(tp, RxConfig) |
>  			AcceptBroadcast | AcceptMulticast | AcceptMyPhys);
> +
> +	if (tp->mac_version >= RTL_GIGA_MAC_VER_40)
> +		RTL_W32(tp, MISC, RTL_R32(tp, MISC) & ~RXDV_GATED_EN);

Wouldn't this be sufficient? Why is the change to rtl8169_cleanup() needed?

>  }
>  
>  static void rtl_prepare_power_down(struct rtl8169_private *tp)
> @@ -3981,7 +3984,7 @@ static void rtl8169_tx_clear(struct rtl8169_private *tp)
>  	netdev_reset_queue(tp->dev);
>  }
>  
> -static void rtl8169_cleanup(struct rtl8169_private *tp, bool going_down)
> +static void rtl8169_private (struct rtl8169_private *tp)
>  {
>  	napi_disable(&tp->napi);
>  
> @@ -3993,9 +3996,6 @@ static void rtl8169_cleanup(struct rtl8169_private *tp, bool going_down)
>  
>  	rtl_rx_close(tp);
>  
> -	if (going_down && tp->dev->wol_enabled)
> -		goto no_reset;
> -
>  	switch (tp->mac_version) {
>  	case RTL_GIGA_MAC_VER_28:
>  	case RTL_GIGA_MAC_VER_31:
> @@ -4016,7 +4016,7 @@ static void rtl8169_cleanup(struct rtl8169_private *tp, bool going_down)
>  	}
>  
>  	rtl_hw_reset(tp);
> -no_reset:
> +
>  	rtl8169_tx_clear(tp);
>  	rtl8169_init_ring_indexes(tp);
>  }
> @@ -4027,7 +4027,7 @@ static void rtl_reset_work(struct rtl8169_private *tp)
>  
>  	netif_stop_queue(tp->dev);
>  
> -	rtl8169_cleanup(tp, false);
> +	rtl8169_cleanup(tp);
>  
>  	for (i = 0; i < NUM_RX_DESC; i++)
>  		rtl8169_mark_to_asic(tp->RxDescArray + i);
> @@ -4715,7 +4715,7 @@ static void rtl8169_down(struct rtl8169_private *tp)
>  	pci_clear_master(tp->pci_dev);
>  	rtl_pci_commit(tp);
>  
> -	rtl8169_cleanup(tp, true);
> +	rtl8169_cleanup(tp);
>  	rtl_disable_exit_l1(tp);
>  	rtl_prepare_power_down(tp);
>  }

