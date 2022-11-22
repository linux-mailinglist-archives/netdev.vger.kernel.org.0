Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 618386339A8
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 11:18:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233518AbiKVKSD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 05:18:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232893AbiKVKR3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 05:17:29 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 490D1310;
        Tue, 22 Nov 2022 02:17:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D8267615F8;
        Tue, 22 Nov 2022 10:17:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF07EC433D6;
        Tue, 22 Nov 2022 10:17:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669112244;
        bh=ND68hnkjba0GVllvUV/YBAXJHbUnHdXUBGD+ZZqUcVA=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=Sg0xRnhDkewhctADJ2YcEwpuio9UuuifRlZdEcijAZusFgThJwApWXvVRFw/8OLEA
         9Qp6mH4xH4H0sWI2IXiTwZtFoL5wvU0a/52IO6S2c/uEk5fjSvvAaLGSYvER0tx/nU
         TyK7N31zvzmcmKqaKYjgHaJv59yyxhqyVrr2e8nT+bQBxg1QxaUCGuPXbqL7UHbgr7
         ZciK0CH8ZddhyQLAsRgCWLXaQnw26ekJsRsRvGHvwWSU70AAd1xZnSV/YwAop+6ith
         oFxfv+6C8EujDzRVMNK3WUMT51pIFzJSd46BrWo8+eniSS2EdrIHcCKbz1N7Kl0vQ8
         3bTbdJvYOpt8Q==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [v2] wifi: p54: Replace zero-length array of trailing structs
 with flex-array
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20221118234240.gonna.369-kees@kernel.org>
References: <20221118234240.gonna.369-kees@kernel.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     Christian Lamparter <chunkeey@googlemail.com>,
        Kees Cook <keescook@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <166911223826.12832.1582733446998520230.kvalo@kernel.org>
Date:   Tue, 22 Nov 2022 10:17:21 +0000 (UTC)
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Kees Cook <keescook@chromium.org> wrote:

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
> Acked-by: Christian Lamparter <chunkeey@gmail.com>

Patch applied to wireless-next.git, thanks.

3b79d4bad3a0 wifi: p54: Replace zero-length array of trailing structs with flex-array

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20221118234240.gonna.369-kees@kernel.org/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

