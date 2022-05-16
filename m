Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CB84528B8A
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 19:04:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344022AbiEPREc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 13:04:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344066AbiEPREa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 13:04:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71CCB27B37;
        Mon, 16 May 2022 10:04:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 141D36124A;
        Mon, 16 May 2022 17:04:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11760C34113;
        Mon, 16 May 2022 17:04:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652720667;
        bh=hFTULSm9gjKLJhiZF+rVg4Hgs0VcXXmYTYwDxYJvn5I=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=qP8F06M90hEBDfKMozhcKPHBnPKAf5XO30YiZx48MNi2WmlTEioN0D7nxx1GifHzJ
         OQRUMy4TcBn2tJWMPejOLGjYhr+X615s+XOYnepAsBlxRhg0eBUsU7vCpDj6Ar53AT
         YDGHHleZmIJVdHyFe0rgzStzs92Za90WDVYs8tTBpsMAeulTIxmckyn4r4M/Vvclwl
         5bqL0Tlw36mHX/T5ptkPccHs/ekPGtATGovTJJUOR8DR3w+bdgjmP0KUcFcotkmiE9
         4grV7hgLxsQtspbG/bRMqmw0rH/Vw7bUkMWZ0izszdjE2LLZAPAbqW2ymvUF0MDO+K
         YKMw6KpFU7dGA==
From:   Kalle Valo <kvalo@kernel.org>
To:     Guo Zhengkui <guozhengkui@vivo.com>
Cc:     Jiri Slaby <jirislaby@kernel.org>,
        Nick Kossifidis <mickflemm@gmail.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
        linux-wireless@vger.kernel.org (open list:ATHEROS ATH5K WIRELESS DRIVER),
        netdev@vger.kernel.org (open list:NETWORKING DRIVERS),
        linux-kernel@vger.kernel.org (open list),
        zhengkui_guo@outlook.com
Subject: Re: [PATCH linux-next] net: ath: fix minmax.cocci warnings
References: <20220516134057.72365-1-guozhengkui@vivo.com>
Date:   Mon, 16 May 2022 20:04:21 +0300
In-Reply-To: <20220516134057.72365-1-guozhengkui@vivo.com> (Guo Zhengkui's
        message of "Mon, 16 May 2022 21:40:57 +0800")
Message-ID: <874k1pxvca.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Guo Zhengkui <guozhengkui@vivo.com> writes:

> Fix the following coccicheck warnings:
>
> drivers/net/wireless/ath/ath5k/phy.c:3139:62-63: WARNING
> opportunity for min()
> drivers/net/wireless/ath/ath9k/dfs.c:249:28-30: WARNING
> opportunity for max()
>
> Signed-off-by: Guo Zhengkui <guozhengkui@vivo.com>
> ---
>  drivers/net/wireless/ath/ath5k/phy.c | 2 +-
>  drivers/net/wireless/ath/ath9k/dfs.c | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)

Please split this into two patches, one for ath5k and one for ath9k.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
