Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDC00630C8F
	for <lists+netdev@lfdr.de>; Sat, 19 Nov 2022 07:41:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231954AbiKSGlL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Nov 2022 01:41:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231300AbiKSGlJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Nov 2022 01:41:09 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAE6BA13CA;
        Fri, 18 Nov 2022 22:41:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 55EBA60A73;
        Sat, 19 Nov 2022 06:41:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9ACF8C433D6;
        Sat, 19 Nov 2022 06:41:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668840066;
        bh=ZeqWS3qlxBPkQlLxIdswf7hLuV3mbyIpTRc3e2a1flE=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=PVN7pS/StHDC8nqh91wKoPK4gJL2fVkFtwNv/G2XVFvKaVCGVmI3gC+PgkUcIo/Fm
         MU7LL0eL51JvmxhLy/KTMyF+Fvi9WYCNJyql22Bp+KmCI77upsvWri+TTlhxSoIKBp
         DJIhOGjszVvFO9Lc/LlPwgJsg/pMvUJtBo2cuNUBKjS4xavooRBPxQ2LuTOd+J8GeM
         RQkovpx6aX/psuZq8emOysPjFClkKfTbK0qZz9fijAy8Dp7mt+/1REP9P+JO7Ki0p5
         iK3Oc865hrybBYcfzFBHc8eg3FCgwuVY6ZDVMV6MTYzuaInP12Or3Ogj8qONtQpodt
         hUZOIq6U2pkmQ==
From:   Kalle Valo <kvalo@kernel.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     Christian Lamparter <chunkeey@googlemail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH v2] p54: Replace zero-length array of trailing structs with flex-array
References: <20221118234240.gonna.369-kees@kernel.org>
Date:   Sat, 19 Nov 2022 08:41:02 +0200
In-Reply-To: <20221118234240.gonna.369-kees@kernel.org> (Kees Cook's message
        of "Fri, 18 Nov 2022 15:42:44 -0800")
Message-ID: <87zgcnphtt.fsf@kernel.org>
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

Kees Cook <keescook@chromium.org> writes:

> Zero-length arrays are deprecated[1] and are being replaced with
> flexible array members in support of the ongoing efforts to tighten the
> FORTIFY_SOURCE routines on memcpy(), correctly instrument array indexing
> with UBSAN_BOUNDS, and to globally enable -fstrict-flex-arrays=3.
>
> Replace zero-length array with flexible-array member.
>
> This results in no differences in binary output (most especially because
> struct pda_antenna_gain is unused). The struct is kept for future
> reference.
>
> [1] https://github.com/KSPP/linux/issues/78
>
> Cc: Christian Lamparter <chunkeey@googlemail.com>
> Cc: Kalle Valo <kvalo@kernel.org>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Paolo Abeni <pabeni@redhat.com>
> Cc: "Gustavo A. R. Silva" <gustavoars@kernel.org>
> Cc: linux-wireless@vger.kernel.org
> Cc: netdev@vger.kernel.org
> Signed-off-by: Kees Cook <keescook@chromium.org>

I'll add "wifi:".

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
