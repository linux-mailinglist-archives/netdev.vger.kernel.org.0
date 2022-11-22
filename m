Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5C7A63397C
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 11:14:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232351AbiKVKOo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 05:14:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230111AbiKVKOm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 05:14:42 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7CC53FBA4;
        Tue, 22 Nov 2022 02:14:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 70607B81604;
        Tue, 22 Nov 2022 10:14:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A80EC433D6;
        Tue, 22 Nov 2022 10:14:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669112079;
        bh=W6RmaRtEKsdccRRkVtkpGTg6p7bsnuwaQ7GRM6ChBYs=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=X0tIPTeDzjcOD8FGxmpHueD6VKqJlgI4Wyhw3ssQqgJeiuUZ3A7uTVfCPuqwErm5g
         Q58AhUt7m1paHqkM24s/qQ9YgX1DgSfdltO42o96CDoe/GVrRUqRtn2VOGqqnKe1Ow
         NGIH0CSD5iE4fQ/e1YDxi4m4jFmQI93f+rMR3PFY7FOyugK3sIwHfEkspHiUvmoozi
         R4e0FaFe9pypLufihlub/zbYe13O/XFMtaCMebgeHs+JSuuhYrZ1y+uORqS0KZ2VqO
         0dvkffM0gT49l3ygAPuzzRGmpdErhJMVitNTnTufB3a+RiOb40187C4HOMOkbR+tv+
         NMWkoIKDQ+bvQ==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 1/2][next] wifi: brcmfmac: replace one-element array with
 flexible-array member in struct brcmf_dload_data_le
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <905f5b68cf93c812360d081caae5b15221db09b6.1668548907.git.gustavoars@kernel.org>
References: <905f5b68cf93c812360d081caae5b15221db09b6.1668548907.git.gustavoars@kernel.org>
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     Hante Meuleman <hante.meuleman@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Arend van Spriel <aspriel@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        SHA-cyfmac-dev-list@infineon.com,
        brcm80211-dev-list.pdl@broadcom.com, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-hardening@vger.kernel.org
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <166911207406.12832.1501959806535365341.kvalo@kernel.org>
Date:   Tue, 22 Nov 2022 10:14:35 +0000 (UTC)
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
> member in struct brcmf_dload_data_le.
> 
> Important to mention is that doing a build before/after this patch results
> in no binary output differences.
> 
> This helps with the ongoing efforts to tighten the FORTIFY_SOURCE routines
> on memcpy() and help us make progress towards globally enabling
> -fstrict-flex-arrays=3 [1].
> 
> Link: https://github.com/KSPP/linux/issues/230
> Link: https://github.com/KSPP/linux/issues/79
> Link: https://gcc.gnu.org/pipermail/gcc-patches/2022-October/602902.html [1]
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
> Reviewed-by: Kees Cook <keescook@chromium.org>

2 patches applied to wireless-next.git, thanks.

0001650b3d89 wifi: brcmfmac: replace one-element array with flexible-array member in struct brcmf_dload_data_le
633a9b6f514c wifi: brcmfmac: Use struct_size() in code ralated to struct brcmf_dload_data_le

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/905f5b68cf93c812360d081caae5b15221db09b6.1668548907.git.gustavoars@kernel.org/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

