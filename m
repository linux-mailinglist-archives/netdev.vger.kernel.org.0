Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9F915F8A08
	for <lists+netdev@lfdr.de>; Sun,  9 Oct 2022 09:49:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229916AbiJIHqI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Oct 2022 03:46:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbiJIHqH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Oct 2022 03:46:07 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4804C9FDA
        for <netdev@vger.kernel.org>; Sun,  9 Oct 2022 00:46:02 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id a13so12187708edj.0
        for <netdev@vger.kernel.org>; Sun, 09 Oct 2022 00:46:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=QEIF/D8MGN1Grd5pufvetE+4rHYJOEsIRZPIWJ9t55E=;
        b=mTXUTmCxtEmhmoex9KJV9nB/M76FNtV0PSkYeE9bIQVO5C5U3vETqbcfigGSb4zHgW
         b57tTJZ0xPxLc99NFy2CKKxUYZhJukoh13srwBq4rJGAiNYoiThX+SrjzUPfR8QAT2IB
         KoFyYC71XgQ1uXmF42N9VH25vmTDRWIZlDVOsp7iHFumA0gIozHY0kiQrSGqFlhvmwtv
         Yh8xS/dh8mNRSYRZSILDSaWqYuXrqQN46USD1bzszTaTypOG0yAX+qd2CsAsDE61I72m
         ygnIRPWLHFPGTxo/URC/mUEZzld7hOlW9Nu5xF5U/QoEDbkVNscSvwgwS9oE+wOEgrdU
         na6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QEIF/D8MGN1Grd5pufvetE+4rHYJOEsIRZPIWJ9t55E=;
        b=NlmvCswoZN4YPi8dsFrwLgQuLoFthc1gSrWCoxtggDbHEB5actPNa6uy2PevyvhYBJ
         FQ1AiVo22Mrs8xbMbV0KgiUY3moHR4PFbJ2A/wfSbTC2tUjIdXMIPk1opE/7/zeHdA1o
         A5g067E77V2MbR8LYD71Ztsq4a9JG2XygHNgCqSquOIFlWi8MfYujqItLKxIiBrwP5vN
         7NsgOKbhasidht/4P4PqLPZmjp2lGvmWDm+VDArDq/fBJ1DqUG8X+d6mrzR/bPeCg7wh
         54SeqVl3SyyEII+/KqgmIl45C98b6S3v4hyyj9GJjR7mB3woiVPAoZKuGua362F2pg8W
         oYIg==
X-Gm-Message-State: ACrzQf0oWffyl/Ixgk2h4PQ8OiMVA+5RldTp86ZiLMlWddO3uZl6Sghe
        Vx8k0N91eBb/oTUnkNCjpXs=
X-Google-Smtp-Source: AMsMyM7QKKuILy/emu5UixMAQAHCVWeAmEhFPYdPKj7W0n5IUnYqsz0ppf05T7PCo898HNlsYFKmYQ==
X-Received: by 2002:aa7:d651:0:b0:459:d1c:394e with SMTP id v17-20020aa7d651000000b004590d1c394emr12318710edr.10.1665301560406;
        Sun, 09 Oct 2022 00:46:00 -0700 (PDT)
Received: from ?IPV6:2a01:c22:7b77:2a00:a91b:cd60:e8c2:700e? (dynamic-2a01-0c22-7b77-2a00-a91b-cd60-e8c2-700e.c22.pool.telefonica.de. [2a01:c22:7b77:2a00:a91b:cd60:e8c2:700e])
        by smtp.googlemail.com with ESMTPSA id g14-20020a170906538e00b0073bdf71995dsm3652647ejo.139.2022.10.09.00.45.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 09 Oct 2022 00:45:59 -0700 (PDT)
Message-ID: <6d607965-53ab-37c7-3920-ae2ad4be09e5@gmail.com>
Date:   Sun, 9 Oct 2022 09:45:47 +0200
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

Is this correct anyway? Supposedly you want to set this bit to disable DMA.
