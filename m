Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88349694D5E
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 17:53:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230132AbjBMQxl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 11:53:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229945AbjBMQxk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 11:53:40 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84D123C22;
        Mon, 13 Feb 2023 08:53:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 22C34611F9;
        Mon, 13 Feb 2023 16:53:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE2CEC433D2;
        Mon, 13 Feb 2023 16:53:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676307215;
        bh=VwYE7aVvyDzD/DxS6sahyXa/rZ64ucTf7BYc9c60MdM=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=uxaRyNlZNvQ8idaYJ11I1qIvOy/BXvbSVyoKGySMqMdgX0HdUTBhHvkwIOyfuRUuc
         rTJNftQXtCvvLDyZSmNTLCFTsr1ePgT9Zm7DLFebprYl6wBwPujqntRgH+bNz3MqO8
         OdrA3SXt8NXElURiEPvU5ejAwb2XmI4lfqTmMR+b9P7uildlrma21qXvI5zwXZDYbY
         4b/O5yho68bWRM8/VeSaBtQyMZDVLo8vQd32O3ll2i4AgG28lU79TrV1eznM3yDBCk
         fnl84t/whbcTLuxrtVnIaP8epcYFDCTSb9C8HM/yob5HorkfkGFic5MwsmlkvoC5yV
         VMVCB+ujf3PnQ==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH][next] wifi: mwifiex: Replace one-element array with
 flexible-array member
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <Y9xkjXeElSEQ0FPY@work>
References: <Y9xkjXeElSEQ0FPY@work>
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi017@gmail.com>,
        Sharvari Harisangam <sharvari.harisangam@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-hardening@vger.kernel.org
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <167630721096.12830.15488375975791023564.kvalo@kernel.org>
Date:   Mon, 13 Feb 2023 16:53:32 +0000 (UTC)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"Gustavo A. R. Silva" <gustavoars@kernel.org> wrote:

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
> 
> This helps with the ongoing efforts to tighten the FORTIFY_SOURCE
> routines on memcpy() and help us make progress towards globally
> enabling -fstrict-flex-arrays=3 [1].
> 
> Link: https://github.com/KSPP/linux/issues/79
> Link: https://github.com/KSPP/linux/issues/252
> Link: https://gcc.gnu.org/pipermail/gcc-patches/2022-October/602902.html [1]
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
> Reviewed-by: Kees Cook <keescook@chromium.org>

Patch applied to wireless-next.git, thanks.

235fd607c6cb wifi: mwifiex: Replace one-element array with flexible-array member

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/Y9xkjXeElSEQ0FPY@work/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

