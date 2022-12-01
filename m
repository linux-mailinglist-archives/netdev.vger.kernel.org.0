Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19A0C63F48D
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 16:55:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232029AbiLAPzN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 10:55:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231518AbiLAPzL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 10:55:11 -0500
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B4E0A8FC0;
        Thu,  1 Dec 2022 07:55:10 -0800 (PST)
Received: by mail-ej1-x62d.google.com with SMTP id ml11so5215005ejb.6;
        Thu, 01 Dec 2022 07:55:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=vNEcMG0EBXvXFShK7G3laBiXFlt1hWqdjXEuldp73CM=;
        b=TSXTYBvUoCbde0OMspmrya4Jnft+s1LQ9vcQisruFpGkhn9/9Jr3vzuLnjTNM1UkFm
         zbX+OVPUVCYITrbJ4b18vANqAEwCcdjgEyP6X4LyM/eFMbiewmqiFB6CSih1crXBdUnV
         KiqdZ7TIcjbWHjabj89ARS1NKogChN/udiCkVSE7RLS4gyANTBdHlo5t6Sa4AJbOum+l
         BsjRrKapkG5Pn5XR6G5k3m7ArDPRWCDnOuC4wGrSbJ3OCZNPDL9SvaTO8ArVsB8lW/ph
         HADu0JHhALMZKwVQovvJ157rN2tZ8Bt+XG/gaTZvCGVU+0sjF6gpWfOUYZ+IIZu9tNg3
         VsSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vNEcMG0EBXvXFShK7G3laBiXFlt1hWqdjXEuldp73CM=;
        b=CabblVHFcbeZ9kjiHDBHl197dvV0d342p5uzcgMcewaPIFAb6ABSJXSfc5arYWLxWn
         pBuZy9t80j6vRKsL7evaJdAkzMve7gFWXkYWus3zoBbC+1XBOiMe+Qc1x/nS26LfKf4X
         z3lCUD3txyFwS56NXRGnjLgggVGtaf8gVwHfrn5Zhr5SgZqiHEMxUfENUyFR5HZ5Rtxh
         fBIojomKBTgqJYd+n+WiT2nt+nHRdZSMe1YEwQA5VkVcgaQAAuh1r2dZ6Lb7jDanjlRz
         0WDITpvU/kgTWCo7f+fpP+gt4pkt5WSeKSLh+TZh9tvde/WgnD+HctGorjz4FquTHToE
         7Qug==
X-Gm-Message-State: ANoB5plfbTLjmjxSh4vSTD+KP0PTolQOxzMi65hlx6Qpdj7mQEeLauQ3
        7y/J5TDCCefjVBqWI+BuW7M=
X-Google-Smtp-Source: AA0mqf5fdooxcZRkV3o0PacuzWIkuVtdq7D0YWsLf09YX8IYmX2yVjm9iOBvf7HS1RX8wt1al5J+0w==
X-Received: by 2002:a17:906:da0f:b0:7ad:95cf:726e with SMTP id fi15-20020a170906da0f00b007ad95cf726emr40839312ejb.60.1669910108800;
        Thu, 01 Dec 2022 07:55:08 -0800 (PST)
Received: from [192.168.1.50] ([79.119.240.254])
        by smtp.gmail.com with ESMTPSA id dn11-20020a05640222eb00b00462bd673453sm1894661edb.39.2022.12.01.07.55.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Dec 2022 07:55:08 -0800 (PST)
Message-ID: <0ebf9f47-16bd-aad0-309f-af7616292785@gmail.com>
Date:   Thu, 1 Dec 2022 17:55:06 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.3
Subject: Re: [PATCH v3] wifi: rtl8xxxu: fixing IQK failures for rtl8192eu
Content-Language: en-US
To:     Jun ASAKA <JunASAKA@zzy040330.moe>, Jes.Sorensen@gmail.com
Cc:     kvalo@kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20221201145500.7832-1-JunASAKA@zzy040330.moe>
From:   Bitterblue Smith <rtl8821cerfe2@gmail.com>
In-Reply-To: <20221201145500.7832-1-JunASAKA@zzy040330.moe>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 01/12/2022 16:55, Jun ASAKA wrote:
> Fixing "Path A RX IQK failed" and "Path B RX IQK failed"
> issues for rtl8192eu chips by replacing the arguments with
> the ones in the updated official driver as shown below.
> 1. https://github.com/Mange/rtl8192eu-linux-driver
> 2. vendor driver version: 5.6.4
> 
> Tested-by: Jun ASAKA <JunASAKA@zzy040330.moe>
> Signed-off-by: Jun ASAKA <JunASAKA@zzy040330.moe>
> ---
> v3: 
>  - add detailed info about the newer version this patch used.
>  - no functional update.
> ---
>  .../realtek/rtl8xxxu/rtl8xxxu_8192e.c         | 76 +++++++++++++------
>  1 file changed, 54 insertions(+), 22 deletions(-)
> 
> diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192e.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192e.c
> index b06508d0cd..82346500f2 100644
> --- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192e.c
> +++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192e.c
> @@ -734,6 +734,12 @@ static int rtl8192eu_iqk_path_a(struct rtl8xxxu_priv *priv)
>  	 */
>  	rtl8xxxu_write32(priv, REG_FPGA0_IQK, 0x00000000);
>  	rtl8xxxu_write_rfreg(priv, RF_A, RF6052_REG_UNKNOWN_DF, 0x00180);
> +
> +	rtl8xxxu_write_rfreg(priv, RF_A, RF6052_REG_WE_LUT, 0x800a0);
> +	rtl8xxxu_write_rfreg(priv, RF_A, RF6052_REG_RCK_OS, 0x20000);
> +	rtl8xxxu_write_rfreg(priv, RF_A, RF6052_REG_TXPA_G1, 0x0000f);
> +	rtl8xxxu_write_rfreg(priv, RF_A, RF6052_REG_TXPA_G2, 0x07f77);
> +>  	rtl8xxxu_write32(priv, REG_FPGA0_IQK, 0x80800000);
>  
>  	/* Path A IQK setting */
> @@ -779,11 +785,16 @@ static int rtl8192eu_rx_iqk_path_a(struct rtl8xxxu_priv *priv)
>  	rtl8xxxu_write_rfreg(priv, RF_A, RF6052_REG_WE_LUT, 0x800a0);
>  	rtl8xxxu_write_rfreg(priv, RF_A, RF6052_REG_RCK_OS, 0x30000);
>  	rtl8xxxu_write_rfreg(priv, RF_A, RF6052_REG_TXPA_G1, 0x0000f);
> -	rtl8xxxu_write_rfreg(priv, RF_A, RF6052_REG_TXPA_G2, 0xf117b);
> +	rtl8xxxu_write_rfreg(priv, RF_A, RF6052_REG_TXPA_G2, 0xf1173);
> +
> +	rtl8xxxu_write_rfreg(priv, RF_B, RF6052_REG_WE_LUT, 0x800a0);
> +	rtl8xxxu_write_rfreg(priv, RF_B, RF6052_REG_RCK_OS, 0x30000);
> +	rtl8xxxu_write_rfreg(priv, RF_B, RF6052_REG_TXPA_G1, 0x0000f);
> +	rtl8xxxu_write_rfreg(priv, RF_B, RF6052_REG_TXPA_G2, 0xf1173);
>  
>  	/* PA/PAD control by 0x56, and set = 0x0 */
>  	rtl8xxxu_write_rfreg(priv, RF_A, RF6052_REG_UNKNOWN_DF, 0x00980);
> -	rtl8xxxu_write_rfreg(priv, RF_A, RF6052_REG_UNKNOWN_56, 0x51000);
> +	rtl8xxxu_write_rfreg(priv, RF_A, RF6052_REG_UNKNOWN_56, 0x511e0);
>  
>  	/* Enter IQK mode */
>  	rtl8xxxu_write32(priv, REG_FPGA0_IQK, 0x80800000);
> @@ -798,14 +809,14 @@ static int rtl8192eu_rx_iqk_path_a(struct rtl8xxxu_priv *priv)
>  	rtl8xxxu_write32(priv, REG_TX_IQK_TONE_B, 0x38008c1c);
>  	rtl8xxxu_write32(priv, REG_RX_IQK_TONE_B, 0x38008c1c);
>  
> -	rtl8xxxu_write32(priv, REG_TX_IQK_PI_A, 0x82160c1f);
> -	rtl8xxxu_write32(priv, REG_RX_IQK_PI_A, 0x68160c1f);
> +	rtl8xxxu_write32(priv, REG_TX_IQK_PI_A, 0x8216031f);
> +	rtl8xxxu_write32(priv, REG_RX_IQK_PI_A, 0x6816031f);
>  
>  	/* LO calibration setting */
>  	rtl8xxxu_write32(priv, REG_IQK_AGC_RSP, 0x0046a911);
>  
>  	/* One shot, path A LOK & IQK */
> -	rtl8xxxu_write32(priv, REG_IQK_AGC_PTS, 0xfa000000);
> +	rtl8xxxu_write32(priv, REG_IQK_AGC_PTS, 0xf9000000);
>  	rtl8xxxu_write32(priv, REG_IQK_AGC_PTS, 0xf8000000);
>  
>  	mdelay(10);
> @@ -836,11 +847,16 @@ static int rtl8192eu_rx_iqk_path_a(struct rtl8xxxu_priv *priv)
>  	rtl8xxxu_write_rfreg(priv, RF_A, RF6052_REG_WE_LUT, 0x800a0);
>  	rtl8xxxu_write_rfreg(priv, RF_A, RF6052_REG_RCK_OS, 0x30000);
>  	rtl8xxxu_write_rfreg(priv, RF_A, RF6052_REG_TXPA_G1, 0x0000f);
> -	rtl8xxxu_write_rfreg(priv, RF_A, RF6052_REG_TXPA_G2, 0xf7ffa);
> +	rtl8xxxu_write_rfreg(priv, RF_A, RF6052_REG_TXPA_G2, 0xf7ff2);
> +
> +	rtl8xxxu_write_rfreg(priv, RF_B, RF6052_REG_WE_LUT, 0x800a0);
> +	rtl8xxxu_write_rfreg(priv, RF_B, RF6052_REG_RCK_OS, 0x30000);
> +	rtl8xxxu_write_rfreg(priv, RF_B, RF6052_REG_TXPA_G1, 0x0000f);
> +	rtl8xxxu_write_rfreg(priv, RF_B, RF6052_REG_TXPA_G2, 0xf7ff2);
>  
>  	/* PA/PAD control by 0x56, and set = 0x0 */
>  	rtl8xxxu_write_rfreg(priv, RF_A, RF6052_REG_UNKNOWN_DF, 0x00980);
> -	rtl8xxxu_write_rfreg(priv, RF_A, RF6052_REG_UNKNOWN_56, 0x51000);
> +	rtl8xxxu_write_rfreg(priv, RF_A, RF6052_REG_UNKNOWN_56, 0x510e0);
>  
>  	/* Enter IQK mode */
>  	rtl8xxxu_write32(priv, REG_FPGA0_IQK, 0x80800000);
> @@ -854,14 +870,14 @@ static int rtl8192eu_rx_iqk_path_a(struct rtl8xxxu_priv *priv)
>  	rtl8xxxu_write32(priv, REG_TX_IQK_TONE_B, 0x38008c1c);
>  	rtl8xxxu_write32(priv, REG_RX_IQK_TONE_B, 0x38008c1c);
>  
> -	rtl8xxxu_write32(priv, REG_TX_IQK_PI_A, 0x82160c1f);
> -	rtl8xxxu_write32(priv, REG_RX_IQK_PI_A, 0x28160c1f);
> +	rtl8xxxu_write32(priv, REG_TX_IQK_PI_A, 0x821608ff);
> +	rtl8xxxu_write32(priv, REG_RX_IQK_PI_A, 0x281608ff);
>  
>  	/* LO calibration setting */
>  	rtl8xxxu_write32(priv, REG_IQK_AGC_RSP, 0x0046a891);
>  
>  	/* One shot, path A LOK & IQK */
> -	rtl8xxxu_write32(priv, REG_IQK_AGC_PTS, 0xfa000000);
> +	rtl8xxxu_write32(priv, REG_IQK_AGC_PTS, 0xf9000000);
>  	rtl8xxxu_write32(priv, REG_IQK_AGC_PTS, 0xf8000000);
>  
>  	mdelay(10);
> @@ -891,22 +907,28 @@ static int rtl8192eu_iqk_path_b(struct rtl8xxxu_priv *priv)
>  
>  	rtl8xxxu_write32(priv, REG_FPGA0_IQK, 0x00000000);
>  	rtl8xxxu_write_rfreg(priv, RF_B, RF6052_REG_UNKNOWN_DF, 0x00180);
> -	rtl8xxxu_write32(priv, REG_FPGA0_IQK, 0x80800000);
>  
> -	rtl8xxxu_write32(priv, REG_FPGA0_IQK, 0x00000000);
> +	rtl8xxxu_write_rfreg(priv, RF_B, RF6052_REG_WE_LUT, 0x800a0);
> +	rtl8xxxu_write_rfreg(priv, RF_B, RF6052_REG_RCK_OS, 0x20000);
> +	rtl8xxxu_write_rfreg(priv, RF_B, RF6052_REG_TXPA_G1, 0x0000f);
> +	rtl8xxxu_write_rfreg(priv, RF_B, RF6052_REG_TXPA_G2, 0x07f77);
> +
>  	rtl8xxxu_write32(priv, REG_FPGA0_IQK, 0x80800000);
>  
> +	// rtl8xxxu_write32(priv, REG_FPGA0_IQK, 0x00000000);
> +	// rtl8xxxu_write32(priv, REG_FPGA0_IQK, 0x80800000);
> +
This commented code is not needed.

>  	/* Path B IQK setting */
>  	rtl8xxxu_write32(priv, REG_TX_IQK_TONE_A, 0x38008c1c);
>  	rtl8xxxu_write32(priv, REG_RX_IQK_TONE_A, 0x38008c1c);
>  	rtl8xxxu_write32(priv, REG_TX_IQK_TONE_B, 0x18008c1c);
>  	rtl8xxxu_write32(priv, REG_RX_IQK_TONE_B, 0x38008c1c);
>  
> -	rtl8xxxu_write32(priv, REG_TX_IQK_PI_B, 0x821403e2);
> +	rtl8xxxu_write32(priv, REG_TX_IQK_PI_B, 0x82140303);
>  	rtl8xxxu_write32(priv, REG_RX_IQK_PI_B, 0x68160000);
>  
>  	/* LO calibration setting */
> -	rtl8xxxu_write32(priv, REG_IQK_AGC_RSP, 0x00492911);
> +	rtl8xxxu_write32(priv, REG_IQK_AGC_RSP, 0x00462911);
>  
>  	/* One shot, path A LOK & IQK */
>  	rtl8xxxu_write32(priv, REG_IQK_AGC_PTS, 0xfa000000);
> @@ -942,11 +964,16 @@ static int rtl8192eu_rx_iqk_path_b(struct rtl8xxxu_priv *priv)
>  	rtl8xxxu_write_rfreg(priv, RF_B, RF6052_REG_WE_LUT, 0x800a0);
>  	rtl8xxxu_write_rfreg(priv, RF_B, RF6052_REG_RCK_OS, 0x30000);
>  	rtl8xxxu_write_rfreg(priv, RF_B, RF6052_REG_TXPA_G1, 0x0000f);
> -	rtl8xxxu_write_rfreg(priv, RF_B, RF6052_REG_TXPA_G2, 0xf117b);
> +	rtl8xxxu_write_rfreg(priv, RF_B, RF6052_REG_TXPA_G2, 0xf1173);
> +
> +	rtl8xxxu_write_rfreg(priv, RF_A, RF6052_REG_WE_LUT, 0x800a0);
> +	rtl8xxxu_write_rfreg(priv, RF_A, RF6052_REG_RCK_OS, 0x30000);
> +	rtl8xxxu_write_rfreg(priv, RF_A, RF6052_REG_TXPA_G1, 0x0000f);
> +	rtl8xxxu_write_rfreg(priv, RF_A, RF6052_REG_TXPA_G2, 0xf1173);
>  
>  	/* PA/PAD control by 0x56, and set = 0x0 */
>  	rtl8xxxu_write_rfreg(priv, RF_B, RF6052_REG_UNKNOWN_DF, 0x00980);
> -	rtl8xxxu_write_rfreg(priv, RF_B, RF6052_REG_UNKNOWN_56, 0x51000);
> +	rtl8xxxu_write_rfreg(priv, RF_B, RF6052_REG_UNKNOWN_56, 0x511e0);
>  
>  	/* Enter IQK mode */
>  	rtl8xxxu_write32(priv, REG_FPGA0_IQK, 0x80800000);
> @@ -961,8 +988,8 @@ static int rtl8192eu_rx_iqk_path_b(struct rtl8xxxu_priv *priv)
>  	rtl8xxxu_write32(priv, REG_TX_IQK_TONE_B, 0x18008c1c);
>  	rtl8xxxu_write32(priv, REG_RX_IQK_TONE_B, 0x38008c1c);
>  
> -	rtl8xxxu_write32(priv, REG_TX_IQK_PI_B, 0x82160c1f);
> -	rtl8xxxu_write32(priv, REG_RX_IQK_PI_B, 0x68160c1f);
> +	rtl8xxxu_write32(priv, REG_TX_IQK_PI_B, 0x8216031f);
> +	rtl8xxxu_write32(priv, REG_RX_IQK_PI_B, 0x6816031f);
>  
>  	/* LO calibration setting */
>  	rtl8xxxu_write32(priv, REG_IQK_AGC_RSP, 0x0046a911);
> @@ -1002,11 +1029,16 @@ static int rtl8192eu_rx_iqk_path_b(struct rtl8xxxu_priv *priv)
>  	rtl8xxxu_write_rfreg(priv, RF_B, RF6052_REG_WE_LUT, 0x800a0);
>  	rtl8xxxu_write_rfreg(priv, RF_B, RF6052_REG_RCK_OS, 0x30000);
>  	rtl8xxxu_write_rfreg(priv, RF_B, RF6052_REG_TXPA_G1, 0x0000f);
> -	rtl8xxxu_write_rfreg(priv, RF_B, RF6052_REG_TXPA_G2, 0xf7ffa);
> +	rtl8xxxu_write_rfreg(priv, RF_B, RF6052_REG_TXPA_G2, 0xf7ff2);
> +
> +	rtl8xxxu_write_rfreg(priv, RF_B, RF6052_REG_WE_LUT, 0x800a0);
> +	rtl8xxxu_write_rfreg(priv, RF_B, RF6052_REG_RCK_OS, 0x30000);
> +	rtl8xxxu_write_rfreg(priv, RF_B, RF6052_REG_TXPA_G1, 0x0000f);
> +	rtl8xxxu_write_rfreg(priv, RF_B, RF6052_REG_TXPA_G2, 0xf7ff2);
These four lines you added here should be using RF_A.

>  
>  	/* PA/PAD control by 0x56, and set = 0x0 */
>  	rtl8xxxu_write_rfreg(priv, RF_B, RF6052_REG_UNKNOWN_DF, 0x00980);
> -	rtl8xxxu_write_rfreg(priv, RF_B, RF6052_REG_UNKNOWN_56, 0x51000);
> +	rtl8xxxu_write_rfreg(priv, RF_B, RF6052_REG_UNKNOWN_56, 0x510e0);
>  
>  	/* Enter IQK mode */
>  	rtl8xxxu_write32(priv, REG_FPGA0_IQK, 0x80800000);
> @@ -1020,8 +1052,8 @@ static int rtl8192eu_rx_iqk_path_b(struct rtl8xxxu_priv *priv)
>  	rtl8xxxu_write32(priv, REG_TX_IQK_TONE_B, 0x38008c1c);
>  	rtl8xxxu_write32(priv, REG_RX_IQK_TONE_B, 0x18008c1c);
>  
> -	rtl8xxxu_write32(priv, REG_TX_IQK_PI_A, 0x82160c1f);
> -	rtl8xxxu_write32(priv, REG_RX_IQK_PI_A, 0x28160c1f);
> +	rtl8xxxu_write32(priv, REG_TX_IQK_PI_A, 0x821608ff);
> +	rtl8xxxu_write32(priv, REG_RX_IQK_PI_A, 0x281608ff);
>  
>  	/* LO calibration setting */
>  	rtl8xxxu_write32(priv, REG_IQK_AGC_RSP, 0x0046a891);

The rest of your changes look okay to me.
