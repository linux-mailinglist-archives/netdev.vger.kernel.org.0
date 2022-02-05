Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF0744AA9B7
	for <lists+netdev@lfdr.de>; Sat,  5 Feb 2022 16:40:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380259AbiBEPkW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Feb 2022 10:40:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379740AbiBEPkN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Feb 2022 10:40:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04231C061348
        for <netdev@vger.kernel.org>; Sat,  5 Feb 2022 07:40:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C165FB8068B
        for <netdev@vger.kernel.org>; Sat,  5 Feb 2022 15:40:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 904DFC340EC;
        Sat,  5 Feb 2022 15:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644075610;
        bh=Q1EbjSrGNFjQw+qwd1kynQ4Sblzsz+f7wZ8YMc8YauE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=rZOtVaV+VrrMZXWcPdnkjqwbOLcpqBijHs1fimE65iBiiBT3qI94WXsJupODuMvxq
         4GG9NHAjeIdO/en5UMwan1LRg3xwg6V8+dFsDpOmPkufdqRnkcGCLPYz6g4uAulex6
         mXcbWQPoXNAKrDgO31iap9+mVO/OnnnlNXEt7yI1RfdYoGrK8wf4Twf4yf8klW/kF0
         8JMYg+7DsnSaESmDqmi5/y1Z0/Fef7aO4jWNt2gzQhkVnuIy9izPh0ID+6MR9YfsNP
         lH7Ad4/VBFXbWUIoNipC4H2poEa9QL9jh7owJZt6g/BhBm6vwf2/hPPftbf3tfvule
         8zXnpyWx9mVQQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 74C39E5869F;
        Sat,  5 Feb 2022 15:40:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net-next 0/3] net: device tracking improvements
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164407561047.28243.2487705910471283005.git-patchwork-notify@kernel.org>
Date:   Sat, 05 Feb 2022 15:40:10 +0000
References: <20220204224237.2932026-1-eric.dumazet@gmail.com>
In-Reply-To: <20220204224237.2932026-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        edumazet@google.com
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri,  4 Feb 2022 14:42:34 -0800 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> Main goal of this series is to be able to detect the following case
> which apparently is still haunting us.
> 
> dev_hold_track(dev, tracker_1, GFP_ATOMIC);
>     dev_hold(dev);
>     dev_put(dev);
>     dev_put(dev);              // Should complain loudly here.
> dev_put_track(dev, tracker_1); // instead of here (as before this series)
> 
> [...]

Here is the summary with links:
  - [v2,net-next,1/3] ref_tracker: implement use-after-free detection
    https://git.kernel.org/netdev/net-next/c/e3ececfe668f
  - [v2,net-next,2/3] ref_tracker: add a count of untracked references
    https://git.kernel.org/netdev/net-next/c/8fd5522f44dc
  - [v2,net-next,3/3] net: refine dev_put()/dev_hold() debugging
    https://git.kernel.org/netdev/net-next/c/4c6c11ea0f7b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


