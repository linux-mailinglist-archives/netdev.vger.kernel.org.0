Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C73F68A100
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 18:57:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232935AbjBCR5U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 12:57:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232416AbjBCR5S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 12:57:18 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FB1C3430D
        for <netdev@vger.kernel.org>; Fri,  3 Feb 2023 09:57:16 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id n13so5993722plf.11
        for <netdev@vger.kernel.org>; Fri, 03 Feb 2023 09:57:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=8WT95F+iS0qJ3SEQvMux6Ahdn4GMfowtUA6O/anLIZM=;
        b=JD6SPQ9aZzihVAy5oLJLWN+5hgdKbIBF2rpSwem3ale/1ZPxtGrY7JT5LqyOlN8N9a
         gQvpi4Ibc6CooqHBwRgwSulyLggbq2A9QwMp+NnDESjOVQBx/1iprLWtv+KW/MWFk3fR
         eFi87mm+flJSCzzGchzGmKBjVXtatjyWYwkhs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8WT95F+iS0qJ3SEQvMux6Ahdn4GMfowtUA6O/anLIZM=;
        b=jVNK8D3KUwaIGIkwto47GqptjtOFNbOm1uGAzrq42pb8egywDq41ZgVIaAa8DgYWRS
         EgxFCi4D7/UaaIgGDIR5XkoysnVjMLjntOMMFKB0ay6soCGc75f6g892GU1PBCYuwj7w
         6WI4c0H39h661UIey0sMyHaZhtdMz+UWy97S6RTdk5VtP9ejiWi/V8NkTv9dTAy+wYeY
         V1D8QwxLhHya7937la1d4MxtzIurN4oZiTf9N841MQ06GKWQEtkjj8l1ABY51XJU6LQD
         hYfqoaBeu4+Q/JuMOStSiS/3NU3jhaYLIzILdZ63lT/hAu9myE8kmrqMuRS/8lPD4PzN
         tQTA==
X-Gm-Message-State: AO0yUKVYi29N7LI4HhICRSJFmBsYXOylXDl0mzKEihKsvMLjVtniCSVw
        BvER/3vRH9t89CJWJQVDp06uZw==
X-Google-Smtp-Source: AK7set+iYFPlIHXpZDz4pifedq9Mx+/38gPmSWF0Ge7/VAK65kqXpKh8i2Cce6utIuqc++7/MnqoYg==
X-Received: by 2002:a17:902:f14d:b0:198:dd32:f0e1 with SMTP id d13-20020a170902f14d00b00198dd32f0e1mr2737051plb.0.1675447036042;
        Fri, 03 Feb 2023 09:57:16 -0800 (PST)
Received: from www.outflux.net (198-0-35-241-static.hfc.comcastbusiness.net. [198.0.35.241])
        by smtp.gmail.com with ESMTPSA id a21-20020a170902b59500b00186748fe6ccsm1872269pls.214.2023.02.03.09.57.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Feb 2023 09:57:15 -0800 (PST)
Message-ID: <63dd4afb.170a0220.27b4d.3935@mx.google.com>
X-Google-Original-Message-ID: <202302031755.@keescook>
Date:   Fri, 3 Feb 2023 17:57:15 +0000
From:   Kees Cook <keescook@chromium.org>
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi017@gmail.com>,
        Sharvari Harisangam <sharvari.harisangam@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: Re: [PATCH][next] wifi: mwifiex: Replace one-element array with
 flexible-array member
References: <Y9xkjXeElSEQ0FPY@work>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y9xkjXeElSEQ0FPY@work>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 02, 2023 at 07:34:05PM -0600, Gustavo A. R. Silva wrote:
> One-element arrays are deprecated, and we are replacing them with flexible
> array members instead. So, replace one-element array with flexible-array
> member in struct mwifiex_ie_types_rates_param_set.
> 
> These are the only binary differences I see after the change:
> 
> mwifiex.o
> _@@ -50154,7 +50154,7 @@
>                         23514: R_X86_64_32S     kmalloc_caches+0x50
>     23518:      call   2351d <mwifiex_scan_networks+0x11d>
>                         23519: R_X86_64_PLT32   __tsan_read8-0x4
> -   2351d:      mov    $0x225,%edx
> +   2351d:      mov    $0x224,%edx
>     23522:      mov    $0xdc0,%esi
>     23527:      mov    0x0(%rip),%rdi        # 2352e <mwifiex_scan_networks+0x12e>
>                         2352a: R_X86_64_PC32    kmalloc_caches+0x4c
> scan.o
> _@@ -5582,7 +5582,7 @@
>                         4394: R_X86_64_32S      kmalloc_caches+0x50
>      4398:      call   439d <mwifiex_scan_networks+0x11d>
>                         4399: R_X86_64_PLT32    __tsan_read8-0x4
> -    439d:      mov    $0x225,%edx
> +    439d:      mov    $0x224,%edx
>      43a2:      mov    $0xdc0,%esi
>      43a7:      mov    0x0(%rip),%rdi        # 43ae <mwifiex_scan_networks+0x12e>
>                         43aa: R_X86_64_PC32     kmalloc_caches+0x4c
> 
> and the reason for that is the following line:
> 
> drivers/net/wireless/marvell/mwifiex/scan.c:
> 1517         scan_cfg_out = kzalloc(sizeof(union mwifiex_scan_cmd_config_tlv),
> 1518                                GFP_KERNEL);
> 
> sizeof(union mwifiex_scan_cmd_config_tlv) is now one-byte smaller due to the
> flex-array transformation:
> 
>   46 union mwifiex_scan_cmd_config_tlv {
>   47         /* Scan configuration (variable length) */
>   48         struct mwifiex_scan_cmd_config config;
>   49         /* Max allocated block */
>   50         u8 config_alloc_buf[MAX_SCAN_CFG_ALLOC];
>   51 };

Interesting! So this looks like it's fixing a minor bug in the original
implementation which was allocation 1 byte too much.

> 
> Notice that MAX_SCAN_CFG_ALLOC is defined in terms of
> sizeof(struct mwifiex_ie_types_rates_param_set), see:
> 
>   26 /* Memory needed to store supported rate */
>   27 #define RATE_TLV_MAX_SIZE   (sizeof(struct mwifiex_ie_types_rates_param_set) \
>   28                                 + HOSTCMD_SUPPORTED_RATES)
> 
>   37 /* Maximum memory needed for a mwifiex_scan_cmd_config with all TLVs at max */
>   38 #define MAX_SCAN_CFG_ALLOC (sizeof(struct mwifiex_scan_cmd_config)        \
>   39                                 + sizeof(struct mwifiex_ie_types_num_probes)   \
>   40                                 + sizeof(struct mwifiex_ie_types_htcap)       \
>   41                                 + CHAN_TLV_MAX_SIZE                 \
>   42                                 + RATE_TLV_MAX_SIZE                 \
>   43                                 + WILDCARD_SSID_TLV_MAX_SIZE)

Yeah, the config_alloc_buf size appears to be very specifically
calculated, so this seems sane to me.

> 
> This helps with the ongoing efforts to tighten the FORTIFY_SOURCE
> routines on memcpy() and help us make progress towards globally
> enabling -fstrict-flex-arrays=3 [1].
> 
> Link: https://github.com/KSPP/linux/issues/79
> Link: https://github.com/KSPP/linux/issues/252
> Link: https://gcc.gnu.org/pipermail/gcc-patches/2022-October/602902.html [1]
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
