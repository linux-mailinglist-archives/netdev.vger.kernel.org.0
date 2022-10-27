Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8B2960F616
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 13:20:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234842AbiJ0LU1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 07:20:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234740AbiJ0LUZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 07:20:25 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26F0C37416
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 04:20:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id E973ACE25F4
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 11:20:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 61F28C433D7;
        Thu, 27 Oct 2022 11:20:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666869615;
        bh=tSFf575/p62mSRMdRQSlvxHLUQVIBmjPvfmHPYDoP78=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=C+J6q1uGmzSBh87FW1xgWz8JAx5jSrB2CtPvxtdQAhf38XC93STbrft4gdrzj2aqh
         GSb2ncoYuD9v2odr+jnfKcOWMfSO/x0UKXT57m1ZOcS13+R3mEz3V5BW8E2P6IW9mw
         0PxcACCBQfLAnvMoBj/2jTfFJfLulxk3uKu0MN5VU65UiNA9+Z6e73JpETg5y30F1Z
         uDZR714PTSI+PTs7OUtuZa5fH2Owv2qlNoXWWqkXAdHfVrYOFGxfxAlTy98On3kjeo
         iCAY39EAYRqg5em/ctZWNbh/7woAHqq6WMgy4GA8zQdEi8E79d8xGeY5jxYOmgk8/i
         aMlJqRgoE0Nyw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 48136E270DA;
        Thu, 27 Oct 2022 11:20:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: broadcom: bcm4908_enet: use build_skb()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166686961529.9402.9754688232913670518.git-patchwork-notify@kernel.org>
Date:   Thu, 27 Oct 2022 11:20:15 +0000
References: <20221025132245.22871-1-zajec5@gmail.com>
In-Reply-To: <20221025132245.22871-1-zajec5@gmail.com>
To:     =?utf-8?b?UmFmYcWCIE1pxYJlY2tpIDx6YWplYzVAZ21haWwuY29tPg==?=@ci.codeaurora.org
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com, rafal@milecki.pl
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Tue, 25 Oct 2022 15:22:45 +0200 you wrote:
> From: Rafał Miłecki <rafal@milecki.pl>
> 
> RX code can be more efficient with the build_skb(). Allocating actual
> SKB around eth packet buffer - right before passing it up - results in
> a better cache usage.
> 
> Without RPS (echo 0 > rps_cpus) BCM4908 NAT masq performance "jumps"
> between two speeds: ~900 Mbps and 940 Mbps (it's a 4 CPUs SoC). This
> change bumps the lower speed from 905 Mb/s to 918 Mb/s (tested using
> single stream iperf 2.0.5 traffic).
> 
> [...]

Here is the summary with links:
  - net: broadcom: bcm4908_enet: use build_skb()
    https://git.kernel.org/netdev/net-next/c/3a1cc23a75ab

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


