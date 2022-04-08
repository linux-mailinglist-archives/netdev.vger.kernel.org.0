Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B05464F9089
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 10:16:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231367AbiDHIQo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Apr 2022 04:16:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231345AbiDHIQm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Apr 2022 04:16:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6960360D87;
        Fri,  8 Apr 2022 01:14:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 054B3615A7;
        Fri,  8 Apr 2022 08:14:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31BDFC385A1;
        Fri,  8 Apr 2022 08:14:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649405678;
        bh=DXntX2Jz7Nztnd1dMcRMCaGMy0UPIH0WJlp5HA4774s=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=Qu+tD/xH27JIeXTaUKCquAn5fQayD4kxRqf9nIEs5/Z/nJRRkNrYMgZhuJZXKt8Al
         NkLhsVjHZOQo7GV7TnXxgY/OhKOkJU3Osmzr9x7wxOTEUJqNBpdfoz4FPDWMUGX/64
         u5jSI6cp8wrTBzl12n2nao2HO36tXUvV7ocDKe08fD9PBw+bB24wUGrlfy8Po3axfC
         48EribHBfxK/csfTD4gSi23AoDNCMmpAeki/n+TADylKpJEf3htCMIfhNEuUqVJq8e
         vepktCqnHgHTjfdLOMttvcbqtGvHV3pvfSY79LhuYzJ1SgqriOd3dpsluPlBAmvsnT
         YOSlmsHLEDPGA==
From:   Kalle Valo <kvalo@kernel.org>
To:     Wolfram Sang <wsa+renesas@sang-engineering.com>
Cc:     linux-mmc@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Ulf Hansson <ulf.hansson@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi017@gmail.com>,
        Sharvari Harisangam <sharvari.harisangam@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>,
        linux-kernel@vger.kernel.org, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com
Subject: Re: [PATCH 1/3] mmc: core: improve API to make clear mmc_hw_reset is for cards
References: <20220408080045.6497-1-wsa+renesas@sang-engineering.com>
        <20220408080045.6497-2-wsa+renesas@sang-engineering.com>
Date:   Fri, 08 Apr 2022 11:14:31 +0300
In-Reply-To: <20220408080045.6497-2-wsa+renesas@sang-engineering.com> (Wolfram
        Sang's message of "Fri, 8 Apr 2022 10:00:42 +0200")
Message-ID: <87bkxcouu0.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wolfram Sang <wsa+renesas@sang-engineering.com> writes:

> To make it unambiguous that mmc_hw_reset() is for cards and not for
> controllers, we make the function argument mmc_card instead of mmc_host.
> Also, all users are converted.
>
> Suggested-by: Ulf Hansson <ulf.hansson@linaro.org>
> Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
> ---
>
> Ulf prefers one cross-subsystem patch to have all users converted. So,
> we are looking for ACKs from the maintainers of the wireless drivers.
> Thank you!
>
> Changes since RFC:
> * don't rename the function but only change the argument type
> * remove fallback and convert all users in one go
> * remove comment as suggested by Ulf
>
>  drivers/mmc/core/block.c                                | 2 +-
>  drivers/mmc/core/core.c                                 | 5 +++--
>  drivers/mmc/core/mmc_test.c                             | 3 +--
>  drivers/net/wireless/ath/ath10k/sdio.c                  | 2 +-
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c | 2 +-
>  drivers/net/wireless/marvell/mwifiex/sdio.c             | 2 +-
>  drivers/net/wireless/ti/wlcore/sdio.c                   | 2 +-

For wireless:

Acked-by: Kalle Valo <kvalo@kernel.org>

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
