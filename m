Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A8F05FA238
	for <lists+netdev@lfdr.de>; Mon, 10 Oct 2022 18:54:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229841AbiJJQyn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Oct 2022 12:54:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229731AbiJJQyk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Oct 2022 12:54:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 635012AE4;
        Mon, 10 Oct 2022 09:54:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DF72660EF2;
        Mon, 10 Oct 2022 16:54:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A1FEC433D6;
        Mon, 10 Oct 2022 16:54:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665420875;
        bh=qPWTNZGEFYJEvDdkwFCY39pduTasoX2MPE4faZjFyb4=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=t5l+1qwolo90SbopV9MI+P+M+f7fq6BmW4pX1FJAWtWDWbvPCt430v6pyP3RHQ/Wt
         WXhBOzZPLGHezZoSxWW4wCcuOMQBy/ShYXEQgQTtDl623KuQO+vtAURfkwzqUtpiK9
         bJ6f/pKi8qgT3k4u5nfQHdOy6I3521qnJ7S1owY3e3ahcYzRVCEtlpfAN/sAN3Gr4B
         RK07rqwIMD3qkovObsKN2CVTLqEsNB1seI3uCb5Vx0EyRHmFYOhb9YU01UTSyHS8uL
         c6yWO8xfCroHNMUKiyn8aM5LpNkk/T4m1iJnGISl1nzNP1cfBm+adbZgIieTkgtDiu
         mQBMoOT4prXLQ==
From:   Kalle Valo <kvalo@kernel.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>
Cc:     Netdev <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        linux-wireless@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, ath11k@lists.infradead.org,
        regressions@lists.linux.dev, lkft-triage@lists.linaro.org
Subject: Re: drivers/net/wireless/ath/ath11k/mac.c:2238:29: warning: 'ath11k_peer_assoc_h_he_limit' reading 16 bytes from a region of size 0
References: <CA+G9fYsZ_qypa=jHY_dJ=tqX4515+qrV9n2SWXVDHve826nF7Q@mail.gmail.com>
Date:   Mon, 10 Oct 2022 19:54:29 +0300
In-Reply-To: <CA+G9fYsZ_qypa=jHY_dJ=tqX4515+qrV9n2SWXVDHve826nF7Q@mail.gmail.com>
        (Naresh Kamboju's message of "Wed, 21 Sep 2022 16:05:39 +0530")
Message-ID: <87ilkrpqka.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

+ arnd

Naresh Kamboju <naresh.kamboju@linaro.org> writes:

> Following build warnings noticed while building arm64 on Linux next-20220921
>
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
>
> In function 'ath11k_peer_assoc_h_he',
>     inlined from 'ath11k_peer_assoc_prepare' at
> drivers/net/wireless/ath/ath11k/mac.c:2662:2:
> drivers/net/wireless/ath/ath11k/mac.c:2238:29: warning:
> 'ath11k_peer_assoc_h_he_limit' reading 16 bytes from a region of size
> 0 [-Wstringop-overread]
>  2238 |                         v = ath11k_peer_assoc_h_he_limit(v,
> he_mcs_mask);
>       |                             ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> drivers/net/wireless/ath/ath11k/mac.c: In function 'ath11k_peer_assoc_prepare':
> drivers/net/wireless/ath/ath11k/mac.c:2238:29: note: referencing
> argument 2 of type 'const u16 *' {aka 'const short unsigned int *'}
> drivers/net/wireless/ath/ath11k/mac.c:2019:12: note: in a call to
> function 'ath11k_peer_assoc_h_he_limit'
>  2019 | static u16 ath11k_peer_assoc_h_he_limit(u16 tx_mcs_set,
>       |            ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
> In function 'ath11k_peer_assoc_h_he',
>     inlined from 'ath11k_peer_assoc_prepare' at
> drivers/net/wireless/ath/ath11k/mac.c:2662:2:
> drivers/net/wireless/ath/ath11k/mac.c:2251:21: warning:
> 'ath11k_peer_assoc_h_he_limit' reading 16 bytes from a region of size
> 0 [-Wstringop-overread]
>  2251 |                 v = ath11k_peer_assoc_h_he_limit(v, he_mcs_mask);
>       |                     ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> drivers/net/wireless/ath/ath11k/mac.c: In function 'ath11k_peer_assoc_prepare':
> drivers/net/wireless/ath/ath11k/mac.c:2251:21: note: referencing
> argument 2 of type 'const u16 *' {aka 'const short unsigned int *'}
> drivers/net/wireless/ath/ath11k/mac.c:2019:12: note: in a call to
> function 'ath11k_peer_assoc_h_he_limit'
>  2019 | static u16 ath11k_peer_assoc_h_he_limit(u16 tx_mcs_set,
>       |            ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
> In function 'ath11k_peer_assoc_h_he',
>     inlined from 'ath11k_peer_assoc_prepare' at
> drivers/net/wireless/ath/ath11k/mac.c:2662:2:
> drivers/net/wireless/ath/ath11k/mac.c:2264:21: warning:
> 'ath11k_peer_assoc_h_he_limit' reading 16 bytes from a region of size
> 0 [-Wstringop-overread]
>  2264 |                 v = ath11k_peer_assoc_h_he_limit(v, he_mcs_mask);
>       |                     ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> drivers/net/wireless/ath/ath11k/mac.c: In function 'ath11k_peer_assoc_prepare':
> drivers/net/wireless/ath/ath11k/mac.c:2264:21: note: referencing
> argument 2 of type 'const u16 *' {aka 'const short unsigned int *'}
> drivers/net/wireless/ath/ath11k/mac.c:2019:12: note: in a call to
> function 'ath11k_peer_assoc_h_he_limit'
>  2019 | static u16 ath11k_peer_assoc_h_he_limit(u16 tx_mcs_set,
>       |            ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
> In function 'ath11k_peer_assoc_h_he',
>     inlined from 'ath11k_peer_assoc_prepare' at
> drivers/net/wireless/ath/ath11k/mac.c:2662:2:
> drivers/net/wireless/ath/ath11k/mac.c:2264:21: warning:
> 'ath11k_peer_assoc_h_he_limit' reading 16 bytes from a region of size
> 0 [-Wstringop-overread]
>  2264 |                 v = ath11k_peer_assoc_h_he_limit(v, he_mcs_mask);
>       |                     ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> drivers/net/wireless/ath/ath11k/mac.c: In function 'ath11k_peer_assoc_prepare':
> drivers/net/wireless/ath/ath11k/mac.c:2264:21: note: referencing
> argument 2 of type 'const u16 *' {aka 'const short unsigned int *'}
> drivers/net/wireless/ath/ath11k/mac.c:2019:12: note: in a call to
> function 'ath11k_peer_assoc_h_he_limit'
>  2019 | static u16 ath11k_peer_assoc_h_he_limit(u16 tx_mcs_set,
>       |            ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
> In function 'ath11k_peer_assoc_h_he',
>     inlined from 'ath11k_peer_assoc_prepare' at
> drivers/net/wireless/ath/ath11k/mac.c:2662:2:
> drivers/net/wireless/ath/ath11k/mac.c:2264:21: warning:
> 'ath11k_peer_assoc_h_he_limit' reading 16 bytes from a region of size
> 0 [-Wstringop-overread]
>  2264 |                 v = ath11k_peer_assoc_h_he_limit(v, he_mcs_mask);
>       |                     ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> drivers/net/wireless/ath/ath11k/mac.c: In function 'ath11k_peer_assoc_prepare':
> drivers/net/wireless/ath/ath11k/mac.c:2264:21: note: referencing
> argument 2 of type 'const u16 *' {aka 'const short unsigned int *'}
> drivers/net/wireless/ath/ath11k/mac.c:2019:12: note: in a call to
> function 'ath11k_peer_assoc_h_he_limit'
>  2019 | static u16 ath11k_peer_assoc_h_he_limit(u16 tx_mcs_set,
>       |            ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
> In function 'ath11k_peer_assoc_h_he',
>     inlined from 'ath11k_peer_assoc_prepare' at
> drivers/net/wireless/ath/ath11k/mac.c:2662:2:
> drivers/net/wireless/ath/ath11k/mac.c:2251:21: warning:
> 'ath11k_peer_assoc_h_he_limit' reading 16 bytes from a region of size
> 0 [-Wstringop-overread]
>  2251 |                 v = ath11k_peer_assoc_h_he_limit(v, he_mcs_mask);
>       |                     ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> drivers/net/wireless/ath/ath11k/mac.c: In function 'ath11k_peer_assoc_prepare':
> drivers/net/wireless/ath/ath11k/mac.c:2251:21: note: referencing
> argument 2 of type 'const u16 *' {aka 'const short unsigned int *'}
> drivers/net/wireless/ath/ath11k/mac.c:2019:12: note: in a call to
> function 'ath11k_peer_assoc_h_he_limit'
>  2019 | static u16 ath11k_peer_assoc_h_he_limit(u16 tx_mcs_set,
>       |            ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
>
> Build log: https://builds.tuxbuild.com/2F4W7nZHNx3T88RB0gaCZ9hBX6c/

Thanks, I was able to reproduce it now and submitted a patch:

https://patchwork.kernel.org/project/linux-wireless/patch/20221010160638.20152-1-kvalo@kernel.org/

But it's strange that nobody else (myself included) didn't see this
earlier. Nor later for that matter, this is the only report I got about
this. Arnd, any ideas what could cause this only to happen on GCC 11?

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
