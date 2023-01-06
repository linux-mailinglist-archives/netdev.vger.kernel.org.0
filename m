Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A34B86600FD
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 14:10:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229476AbjAFNKX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 08:10:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233538AbjAFNKU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 08:10:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12BAE76804
        for <netdev@vger.kernel.org>; Fri,  6 Jan 2023 05:10:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A586B61E33
        for <netdev@vger.kernel.org>; Fri,  6 Jan 2023 13:10:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 09A71C433F0;
        Fri,  6 Jan 2023 13:10:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673010618;
        bh=f+HRQSGojnPIfuTfBPClM0EQZsTx/PN0DLX75EoZaIE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=NbeMZlISFOj7NJTyMxC12niGFxe22hvh7QND1Xon0cZYvAVRdhhQr2UyJfxxBoLod
         D/k0EJAuvTx6YEmrGBaJcOss2LWY8sP2q1FRL69BKtjToQ+nnMyMvSvW3LeSHkHtYD
         kjXN+/OZ6Eh16mFvwlrDGCn2ipd/zBkicYT7rkEWyDHC7rlT0GKkuXZqXGqG6FUrNB
         fUR6TjLlSA+mholLcy9yo6n/F4/4N6lJSchWV4/3au7bsmZNrmraouLUcH+mA+lkK/
         cVCGKKao0Ss2tcVbpwd/b/ArxPR23uUMEMF9LM4Gni3Ld93zlHL3jUPHAj9d8ro7bn
         A5kUJdDWma3DA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E2B51E270EC;
        Fri,  6 Jan 2023 13:10:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/9] devlink: remove the wait-for-references on
 unregister
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167301061792.5551.10032135395535882008.git-patchwork-notify@kernel.org>
Date:   Fri, 06 Jan 2023 13:10:17 +0000
References: <20230106063402.485336-1-kuba@kernel.org>
In-Reply-To: <20230106063402.485336-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, jacob.e.keller@intel.com, jiri@resnulli.us
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu,  5 Jan 2023 22:33:53 -0800 you wrote:
> Move the registration and unregistration of the devlink instances
> under their instance locks. Don't perform the netdev-style wait
> for all references when unregistering the instance.
> 
> Instead the devlink instance refcount will only ensure that
> the memory of the instance is not freed. All places which acquire
> access to devlink instances via a reference must check that the
> instance is still registered under the instance lock.
> 
> [...]

Here is the summary with links:
  - [net-next,1/9] devlink: bump the instance index directly when iterating
    https://git.kernel.org/netdev/net-next/c/d77278196441
  - [net-next,2/9] devlink: update the code in netns move to latest helpers
    https://git.kernel.org/netdev/net-next/c/7a54a5195b2a
  - [net-next,3/9] devlink: protect devlink->dev by the instance lock
    https://git.kernel.org/netdev/net-next/c/870c7ad4a52b
  - [net-next,4/9] devlink: always check if the devlink instance is registered
    https://git.kernel.org/netdev/net-next/c/ed539ba614a0
  - [net-next,5/9] devlink: remove the registration guarantee of references
    https://git.kernel.org/netdev/net-next/c/9053637e0da7
  - [net-next,6/9] devlink: don't require setting features before registration
    https://git.kernel.org/netdev/net-next/c/6ef8f7da9275
  - [net-next,7/9] devlink: allow registering parameters after the instance
    https://git.kernel.org/netdev/net-next/c/1d18bb1a4ddd
  - [net-next,8/9] netdevsim: rename a label
    https://git.kernel.org/netdev/net-next/c/5c5ea1d09fd8
  - [net-next,9/9] netdevsim: move devlink registration under the instance lock
    https://git.kernel.org/netdev/net-next/c/82a3aef2e6af

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


