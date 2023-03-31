Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E03046D22ED
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 16:48:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232623AbjCaOsm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 10:48:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231880AbjCaOsl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 10:48:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81EEB1BF74;
        Fri, 31 Mar 2023 07:48:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 013DD62982;
        Fri, 31 Mar 2023 14:48:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CC4BC433D2;
        Fri, 31 Mar 2023 14:48:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680274117;
        bh=5ePi48wbJ5nUNiKpOzeUOhE93WQhUl7OagIaj68RWtc=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=HHoebeHZWshu5IOH6JeTSkEtwzcWHuyhuXAE0iq7Uy9J4iykllymczOrEUbUuvcHd
         ptBX0AMJIP3FmLGMKyR5n22IE6AUOuYY5iAORKU6sRjALYux0TGNMTGj9d9hOF5BEW
         vYijLVkJ3X1F2P4MjuzNhvNNvIXO9MaV83kfP1YXysFIocL35rLSDsbfkx/LFetUlE
         OBm/l9m/uRMCf2aEBV10yheVekV4fyFU/cyAB6u6smC11p2fB449h59E7cdW0MK1Rp
         xs5GeiM+sIznxPDzGgsaaT0SmyPgT3edrv7xNgk5yB3MGL0NaVAhfzs0ZxZBXS8UhU
         ydpOfzedLsfew==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH][next] wifi: rndis_wlan: Replace fake flex-array with
 flexible-array member
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <ZBtIbU77L9eXqa4j@work>
References: <ZBtIbU77L9eXqa4j@work>
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     Jussi Kivilinna <jussi.kivilinna@iki.fi>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-hardening@vger.kernel.org
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <168027411323.32751.4098580285097268358.kvalo@kernel.org>
Date:   Fri, 31 Mar 2023 14:48:34 +0000 (UTC)
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"Gustavo A. R. Silva" <gustavoars@kernel.org> wrote:

> Zero-length arrays as fake flexible arrays are deprecated and we are
> moving towards adopting C99 flexible-array members instead.
> 
> Address the following warning found with GCC-13 and
> -fstrict-flex-array=3 enabled:
> drivers/net/wireless/rndis_wlan.c:2902:23: warning: array subscript 0 is outside array bounds of ‘struct ndis_80211_auth_request[0]’ [-Warray-bounds=]
> 
> This helps with the ongoing efforts to tighten the FORTIFY_SOURCE
> routines on memcpy() and help us make progress towards globally
> enabling -fstrict-flex-arrays=3 [1].
> 
> Link: https://github.com/KSPP/linux/issues/21
> Link: https://github.com/KSPP/linux/issues/274
> Link: https://gcc.gnu.org/pipermail/gcc-patches/2022-October/602902.html [1]
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>

Patch applied to wireless-next.git, thanks.

06dabcccc08b wifi: rndis_wlan: Replace fake flex-array with flexible-array member

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/ZBtIbU77L9eXqa4j@work/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

