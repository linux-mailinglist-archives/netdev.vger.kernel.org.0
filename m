Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CD3A525505
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 20:40:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357738AbiELSkR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 14:40:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357744AbiELSkP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 14:40:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F4602716C7
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 11:40:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 05D0861A5E
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 18:40:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5B385C34118;
        Thu, 12 May 2022 18:40:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652380813;
        bh=TccM//Yq8RA0MetRtJ7hbf0ckXK8GufoXlzD0TpVA1M=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=NondkKFfJcmwbCeytx/N1wnFGEASTqFl2+8u61XDF8vsJaz+EiWN+XBtQ4MW/gGCp
         /UytwHNjZf5JlLMtvlyrI9pOt9kIL/lLNnyh9ZjTrerGAS6eCZfW4/YfIEOYhWvSf4
         Yw16SyRxfyL6XJQedeH+UbSfbHNVCn38+rspx/D2muN97LrJ51J8EumizRCjiLZhIb
         1w0wSDG6RpU129FdTFIVLr2/S1j0+B7Qo5ipKtiBUxENrTYYOssteze0VBPvlishAr
         NIk8x/XhpL7QfRKmeda+/QuDzZW0+oPfLm7Y5Cj9M8dUJxIlvjkWrzg/oOQHJxM8Re
         wjp0cjhV4jo3A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 14C29F03934;
        Thu, 12 May 2022 18:40:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] tls: Fix context leak on tls_device_down
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165238081307.29516.16468570894556405517.git-patchwork-notify@kernel.org>
Date:   Thu, 12 May 2022 18:40:13 +0000
References: <20220512091830.678684-1-maximmi@nvidia.com>
In-Reply-To: <20220512091830.678684-1-maximmi@nvidia.com>
To:     Maxim Mikityanskiy <maximmi@nvidia.com>
Cc:     kuba@kernel.org, davem@davemloft.net, daniel@iogearbox.net,
        john.fastabend@gmail.com, pabeni@redhat.com, borisp@nvidia.com,
        tariqt@nvidia.com, edumazet@google.com, netdev@vger.kernel.org
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 12 May 2022 12:18:30 +0300 you wrote:
> The commit cited below claims to fix a use-after-free condition after
> tls_device_down. Apparently, the description wasn't fully accurate. The
> context stayed alive, but ctx->netdev became NULL, and the offload was
> torn down without a proper fallback, so a bug was present, but a
> different kind of bug.
> 
> Due to misunderstanding of the issue, the original patch dropped the
> refcount_dec_and_test line for the context to avoid the alleged
> premature deallocation. That line has to be restored, because it matches
> the refcount_inc_not_zero from the same function, otherwise the contexts
> that survived tls_device_down are leaked.
> 
> [...]

Here is the summary with links:
  - [net] tls: Fix context leak on tls_device_down
    https://git.kernel.org/netdev/net/c/3740651bf7e2

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


