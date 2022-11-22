Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9582D633978
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 11:14:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232528AbiKVKOJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 05:14:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232351AbiKVKOH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 05:14:07 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02486391E3;
        Tue, 22 Nov 2022 02:14:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A5B99B819D0;
        Tue, 22 Nov 2022 10:14:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48865C433C1;
        Tue, 22 Nov 2022 10:14:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669112044;
        bh=9BZuoRdOaXihtuwT4dcZSbLK0vWFZ22pJY1UOhoGDp4=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=nSPPoPMhzRlAucQPRV7HhRx+1cIRjGq7jso32ZVKIBZQtwUnGAcQkdPDmH+j5H0yl
         GNs6tDsSDqZKR3UK9YARmlzJaEyCPli6te3GXYjT9s6VwaNb+GFGiwKrTw27eFUIW0
         w6lIMTLsfbIeOQCO4mIqkbsjfSsDhYTjuIhOk5Qq1Ve1JPglPZNt7yOgowOpcfRuuX
         Ge1Z8o8evbR/mvD02IuoWtI1YVk9khZzY0LcndUKVjAlZMVnTOGJaEeadP+U45d4Vv
         ixGRiaiP4OUsbwBcTlvkr93jkU9Q9cK0Pt75Nq50oZXdEGqsR3GKu7rg8IrZlgS7Q7
         R3ZfOw4WqiY5A==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 1/2][next] wifi: brcmfmac: Replace one-element array with
 flexible-array member
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <7694550aa9a2753a73a687f61af9441c8cf52fd7.1668466470.git.gustavoars@kernel.org>
References: <7694550aa9a2753a73a687f61af9441c8cf52fd7.1668466470.git.gustavoars@kernel.org>
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-hardening@vger.kernel.org
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <166911203827.12832.4781552690392721679.kvalo@kernel.org>
Date:   Tue, 22 Nov 2022 10:14:01 +0000 (UTC)
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"Gustavo A. R. Silva" <gustavoars@kernel.org> wrote:

> One-element arrays are deprecated, and we are replacing them with flexible
> array members instead. So, replace one-element array with flexible-array
> member in struct brcmf_gscan_config.
> 
> Important to mention is that doing a build before/after this patch results
> in no binary output differences.
> 
> This helps with the ongoing efforts to tighten the FORTIFY_SOURCE routines
> on memcpy() and help us make progress towards globally enabling
> -fstrict-flex-arrays=3 [1].
> 
> Link: https://github.com/KSPP/linux/issues/79
> Link: https://github.com/KSPP/linux/issues/241
> Link: https://gcc.gnu.org/pipermail/gcc-patches/2022-October/602902.html [1]
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
> Reviewed-by: Kees Cook <keescook@chromium.org>

2 patches applied to wireless-next.git, thanks.

61b0853d0314 wifi: brcmfmac: Replace one-element array with flexible-array member
f0e0897b4c7e wifi: brcmfmac: Use struct_size() and array_size() in code ralated to struct brcmf_gscan_config

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/7694550aa9a2753a73a687f61af9441c8cf52fd7.1668466470.git.gustavoars@kernel.org/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

