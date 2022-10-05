Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4C865F5844
	for <lists+netdev@lfdr.de>; Wed,  5 Oct 2022 18:29:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229592AbiJEQ3w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Oct 2022 12:29:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229868AbiJEQ3t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Oct 2022 12:29:49 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C392664D7
        for <netdev@vger.kernel.org>; Wed,  5 Oct 2022 09:29:47 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id w10so10839114edd.4
        for <netdev@vger.kernel.org>; Wed, 05 Oct 2022 09:29:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2cBzXt8f9tNT6Opw9tWFoAHBBQPgU4JpH4/IhdBB2cA=;
        b=XEAa2TNo1h1bGAh1t/Don++Bm1D/4v7NpM7CBceQ+ZqS+BBrn2VGsHvRGqGvFIbLE7
         y2qox6UmzuZVd9COaqLpa+5Rw4QN7uflVjz/wkNXYxsYZEImX0gkjPwM7LW5TH5JEAM0
         /3RLGGHWba0VmYlcC4Ytr9QFvVGycH3Z7UPTdAYT8P/voOuBS02ApvOlBHGHu3kYD2oK
         LkkuukeWV4ij9xqec4Z/N8D50w/iMcMuKA0kpCQiYbBw1P56wHXPGQ444x/hjxhTnfod
         dg3JIzS0ZiFbgaX9ivH8jj9vcUhjdXrJMHbsbEWZHBOmx//nERHZ1JtrGjQzBpw+poqm
         ti0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2cBzXt8f9tNT6Opw9tWFoAHBBQPgU4JpH4/IhdBB2cA=;
        b=09bsOYOI8a7reWwkthcitKzRtdOkTBhZ1wTwLpEn0cR+a84sJS5hfuBniVA1IYBAXg
         C3s90LVVcOPaRrpjPL6/pE+5KIyJNZfg//YYgrzDw4BwCji6tsSLiejfOkc+bcYYVjw/
         JI4tanoK7Z46TtCl14CWCfsvhD961Ez7ULDN0r5svEX7VHjKgabKR3yIYyLj4F2949NX
         P6+PkbMUKfi2UfA99NV96cB6fBI+pKpwzpc+WRLKI590UZX6P5saT+qj9u3VUwC8lhSE
         Nx0r3+PAzy+kwXyD71sUmncX5lKqiwfQ/s4WIxP3lQMjnhzkMGN8KMAUHzBcdLm88Sc3
         EJgg==
X-Gm-Message-State: ACrzQf1YIEvHICXfIayfKgxEXlOlD4/0VbTr4uiL7GvOIyKtVMonRA7G
        bmXQHxkHHHPwAFRvb/ktcTvWOjOABQs=
X-Google-Smtp-Source: AMsMyM4ytoxpzKlkbLpVqNclOMrSuDmxLk4nzQvFXXiEdZauDzmmvUm7OMbPrgxgICZ5ZJD97S2ulg==
X-Received: by 2002:a05:6402:1e96:b0:459:68bb:867 with SMTP id f22-20020a0564021e9600b0045968bb0867mr537026edf.45.1664987386107;
        Wed, 05 Oct 2022 09:29:46 -0700 (PDT)
Received: from ?IPV6:2a01:c23:c13b:e000:c905:ab1f:e5db:24f8? (dynamic-2a01-0c23-c13b-e000-c905-ab1f-e5db-24f8.c23.pool.telefonica.de. [2a01:c23:c13b:e000:c905:ab1f:e5db:24f8])
        by smtp.googlemail.com with ESMTPSA id n15-20020aa7c78f000000b00458d50b4a24sm4019582eds.96.2022.10.05.09.29.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Oct 2022 09:29:45 -0700 (PDT)
Message-ID: <4d5fe96b-26ef-a9c8-f385-a3428d5562f5@gmail.com>
Date:   Wed, 5 Oct 2022 18:29:39 +0200
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
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
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
>  }
>  
>  static void rtl_prepare_power_down(struct rtl8169_private *tp)
> @@ -3981,7 +3984,7 @@ static void rtl8169_tx_clear(struct rtl8169_private *tp)
>  	netdev_reset_queue(tp->dev);
>  }
>  
> -static void rtl8169_cleanup(struct rtl8169_private *tp, bool going_down)
> +static void rtl8169_cleanup(struct rtl8169_private *tp)
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

Hi Hau,

I think the following simple change should also fix the issue.
DMA is enabled only after the chip has been reset in rtl_reset_work().
This should ensure that there are no stale RX DMA descriptors any longer.
Could you please test it?


diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 114f88497..1d72691a4 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -4610,13 +4610,13 @@ static void rtl8169_down(struct rtl8169_private *tp)
 
 static void rtl8169_up(struct rtl8169_private *tp)
 {
-	pci_set_master(tp->pci_dev);
 	phy_init_hw(tp->phydev);
 	phy_resume(tp->phydev);
 	rtl8169_init_phy(tp);
 	napi_enable(&tp->napi);
 	set_bit(RTL_FLAG_TASK_ENABLED, tp->wk.flags);
 	rtl_reset_work(tp);
+	pci_set_master(tp->pci_dev);
 
 	phy_start(tp->phydev);
 }
-- 
2.38.0




