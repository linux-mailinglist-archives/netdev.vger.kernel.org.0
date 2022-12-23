Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C508654F40
	for <lists+netdev@lfdr.de>; Fri, 23 Dec 2022 11:39:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230316AbiLWKjV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Dec 2022 05:39:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235994AbiLWKjS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Dec 2022 05:39:18 -0500
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8612B6559
        for <netdev@vger.kernel.org>; Fri, 23 Dec 2022 02:39:17 -0800 (PST)
Received: by mail-ej1-x634.google.com with SMTP id m18so11161150eji.5
        for <netdev@vger.kernel.org>; Fri, 23 Dec 2022 02:39:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:from:content-language
         :references:cc:to:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XmAakv1R76KcyeJgiQ5DV81zbdAv0luSojiCWT4Dm8c=;
        b=ptJZ1+/E2rohccOVyddgNq3+cG/v7MNQmBqUNjbA6EsroW4jeH4nugK/QVlHMYj/jM
         ZkvqQQHSBzNlQAiTKNE50w6usmWXjeE3iHZp4gIbSJuGgEJtATfjpFG7WXDoUWlGVP/i
         6nnax6DAujbTyf121sHd9hoqy6SoGcmKJ0FQvgToAIEsbosTD/bDcXA+1/BA5+QqIS0E
         mvuEgjbH5P3ktfDmJSUuW5BIcy3StDeNZfCiSxgf0mB1h51I2CZH6rAUyZyL1pDaF5U2
         O4doDkTvFWBEBalI31zS9EcttzgggbAon9SONwZCeOwethKZ6I22qafj5dWj3i0+ZZqH
         XehA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:from:content-language
         :references:cc:to:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XmAakv1R76KcyeJgiQ5DV81zbdAv0luSojiCWT4Dm8c=;
        b=jZGC5KrqnZELUxOevWwme2coCwe9dLeX8xOq9D2NLfbUQx7BhxUX8wW4u/7Lf6Bvdt
         /Fz/k78UP12alsEsqmpI3VL/DYJpURrsQkSzZw3ABDemZ5GLlf+ilZukx/L1FoU2Bd8b
         jXZIb+i1lUWWZ1Km/uWFxSti8rwgooQyresSny1XOK+5hiy7tspfrMT34Njt8NzI66Sx
         Jviznd2qkRWzlxYmg32L+V4hUJHRWlvHsKwxH46XMvFNyyhDqKTk13jDptWtYSLDmp2X
         W6+4odE9RbhCK67V2g2dOv65voywVarSKdXqDDCHrtKKPBRopod0Uzm4kUVZpZoEzkRP
         r8dw==
X-Gm-Message-State: AFqh2kq1ZaclEtQNaodmma8zv6aPAwwiY64bSQ+kJMT1Cbtr+VbZNZrZ
        Ygdb5OpLKNdQtnJFUjvMMeVt3CR+AEU=
X-Google-Smtp-Source: AMrXdXtGSuUZpsB9iCtnVQjvnCpwWWEBDBZT2QRaGQO+R8OCUARgHMEcn3dRNA0lswvyALaVj9ZsGw==
X-Received: by 2002:a17:906:1d4a:b0:81a:c653:4a06 with SMTP id o10-20020a1709061d4a00b0081ac6534a06mr11001095ejh.66.1671791955870;
        Fri, 23 Dec 2022 02:39:15 -0800 (PST)
Received: from ?IPV6:2a01:c22:7239:9600:c934:9f9d:249d:da6f? (dynamic-2a01-0c22-7239-9600-c934-9f9d-249d-da6f.c22.pool.telefonica.de. [2a01:c22:7239:9600:c934:9f9d:249d:da6f])
        by smtp.googlemail.com with ESMTPSA id a18-20020a17090682d200b007be301a1d51sm1233646ejy.211.2022.12.23.02.39.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Dec 2022 02:39:15 -0800 (PST)
Message-ID: <ea257540-edae-2803-4726-778a44f96a34@gmail.com>
Date:   Fri, 23 Dec 2022 11:39:10 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
To:     Chunhao Lin <hau@realtek.com>
Cc:     netdev@vger.kernel.org, nic_swsd@realtek.com
References: <20221223074321.4862-1-hau@realtek.com>
Content-Language: en-US
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH net v2] r8169: fix rtl8125b dmar pte write access not set
 error
In-Reply-To: <20221223074321.4862-1-hau@realtek.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 23.12.2022 08:43, Chunhao Lin wrote:
> When close device, if wol is enabled, rx will be enabled. When open device
> it will cause rx to dma to the wrong memory address after pci_set_master().
> System log will show blow messages.
> 
> DMAR: DRHD: handling fault status reg 3
> DMAR: [DMA Write] Request device [02:00.0] PASID ffffffff fault addr ffdd4000 [fault reason 05] PTE Write access is not set
> 
> In this patch, driver disable tx/rx when close device. If wol is
> enabled, only enable rx filter and disable rxdv_gate to let hardware only
> receive packet to fifo but not to dma it.
> 
> Signed-off-by: Chunhao Lin <hau@realtek.com>
> ---
> v1 -> v2: update commit message and adjust the code according to current kernel code.
> 
>  drivers/net/ethernet/realtek/r8169_main.c | 58 +++++++++++------------
>  1 file changed, 29 insertions(+), 29 deletions(-)
> 
> diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
> index a9dcc98b6af1..24592d972523 100644
> --- a/drivers/net/ethernet/realtek/r8169_main.c
> +++ b/drivers/net/ethernet/realtek/r8169_main.c
> @@ -2210,28 +2210,6 @@ static int rtl_set_mac_address(struct net_device *dev, void *p)
>  	return 0;
>  }
>  
> -static void rtl_wol_enable_rx(struct rtl8169_private *tp)
> -{
> -	if (tp->mac_version >= RTL_GIGA_MAC_VER_25)
> -		RTL_W32(tp, RxConfig, RTL_R32(tp, RxConfig) |
> -			AcceptBroadcast | AcceptMulticast | AcceptMyPhys);
> -}
> -
> -static void rtl_prepare_power_down(struct rtl8169_private *tp)
> -{
> -	if (tp->dash_type != RTL_DASH_NONE)
> -		return;
> -
> -	if (tp->mac_version == RTL_GIGA_MAC_VER_32 ||
> -	    tp->mac_version == RTL_GIGA_MAC_VER_33)
> -		rtl_ephy_write(tp, 0x19, 0xff64);
> -
> -	if (device_may_wakeup(tp_to_dev(tp))) {
> -		phy_speed_down(tp->phydev, false);
> -		rtl_wol_enable_rx(tp);
> -	}
> -}
> -
>  static void rtl_init_rxcfg(struct rtl8169_private *tp)
>  {
>  	switch (tp->mac_version) {
> @@ -2455,6 +2433,31 @@ static void rtl_enable_rxdvgate(struct rtl8169_private *tp)
>  	rtl_wait_txrx_fifo_empty(tp);
>  }
>  
> +static void rtl_wol_enable_rx(struct rtl8169_private *tp)
> +{
> +	if (tp->mac_version >= RTL_GIGA_MAC_VER_25)
> +		RTL_W32(tp, RxConfig, RTL_R32(tp, RxConfig) |
> +			AcceptBroadcast | AcceptMulticast | AcceptMyPhys);
> +
> +	if (tp->mac_version >= RTL_GIGA_MAC_VER_40)
> +		rtl_disable_rxdvgate(tp);
> +}
> +
> +static void rtl_prepare_power_down(struct rtl8169_private *tp)
> +{
> +	if (tp->dash_type != RTL_DASH_NONE)
> +		return;
> +
> +	if (tp->mac_version == RTL_GIGA_MAC_VER_32 ||
> +	    tp->mac_version == RTL_GIGA_MAC_VER_33)
> +		rtl_ephy_write(tp, 0x19, 0xff64);
> +
> +	if (device_may_wakeup(tp_to_dev(tp))) {
> +		phy_speed_down(tp->phydev, false);
> +		rtl_wol_enable_rx(tp);
> +	}
> +}
> +
>  static void rtl_set_tx_config_registers(struct rtl8169_private *tp)
>  {
>  	u32 val = TX_DMA_BURST << TxDMAShift |
> @@ -3872,7 +3875,7 @@ static void rtl8169_tx_clear(struct rtl8169_private *tp)
>  	netdev_reset_queue(tp->dev);
>  }
>  
> -static void rtl8169_cleanup(struct rtl8169_private *tp, bool going_down)
> +static void rtl8169_cleanup(struct rtl8169_private *tp)
>  {
>  	napi_disable(&tp->napi);
>  
> @@ -3884,9 +3887,6 @@ static void rtl8169_cleanup(struct rtl8169_private *tp, bool going_down)
>  
>  	rtl_rx_close(tp);
>  
> -	if (going_down && tp->dev->wol_enabled)
> -		goto no_reset;
> -
>  	switch (tp->mac_version) {
>  	case RTL_GIGA_MAC_VER_28:
>  	case RTL_GIGA_MAC_VER_31:
> @@ -3907,7 +3907,7 @@ static void rtl8169_cleanup(struct rtl8169_private *tp, bool going_down)
>  	}
>  
>  	rtl_hw_reset(tp);
> -no_reset:
> +
>  	rtl8169_tx_clear(tp);
>  	rtl8169_init_ring_indexes(tp);
>  }
> @@ -3918,7 +3918,7 @@ static void rtl_reset_work(struct rtl8169_private *tp)
>  
>  	netif_stop_queue(tp->dev);
>  
> -	rtl8169_cleanup(tp, false);
> +	rtl8169_cleanup(tp);
>  
>  	for (i = 0; i < NUM_RX_DESC; i++)
>  		rtl8169_mark_to_asic(tp->RxDescArray + i);
> @@ -4605,7 +4605,7 @@ static void rtl8169_down(struct rtl8169_private *tp)
>  	pci_clear_master(tp->pci_dev);
>  	rtl_pci_commit(tp);
>  
> -	rtl8169_cleanup(tp, true);
> +	rtl8169_cleanup(tp);
>  	rtl_disable_exit_l1(tp);
>  	rtl_prepare_power_down(tp);
>  }

The change affects also chip versions other than RTL8125B.
Is the problem you're fixing really specific to RTL8125B?
Or could it happen also with other chip versions?
Either patch or commit message need to be changed.
And it would be better to split the patch:
1. Moving rtl_wol_enable_rx() and rtl_prepare_power_down() in the code
2. Actual change
This makes it easier to track the actual change.

