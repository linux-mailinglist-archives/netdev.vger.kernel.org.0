Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E206365FB35
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 07:10:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231659AbjAFGKU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 01:10:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbjAFGKT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 01:10:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5027C6147A;
        Thu,  5 Jan 2023 22:10:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D247761D20;
        Fri,  6 Jan 2023 06:10:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2F770C43396;
        Fri,  6 Jan 2023 06:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672985417;
        bh=BqR+YVXxf+OLUvUxFDwbMkvpUZi8r+0UlXr60rYEOQo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=S44TqlIF6L3ct0gTR0XX5+WX7yKMIg5ldo2K5eeQpIQVau2mFBSaP0KicRNz8KYN2
         +MOZLq/GMYHXyJhiUO0c4NunvJcVI14wrEEJsAbvX9AlDZJp7B3nJztbeb6izqhAHp
         2ioW3TnkuQW74Ub+ENG7CnMkzHrZeha9xr6945iiBYwz/eHOfBdBynah3QMIpqCzsw
         J0PpbNzS19doPIvUxK/D2KhLGPowkWFjWFoiShbr3SVNDRNsWEQ3ozH2NoTmcpXOH2
         Kw4LgMmhY/qZdhIVRJ8SK9JEizCZpnDoi1ju/I24C3vCN5TQvVdAl/Adsbf4KDKYVb
         bQVb0ybfX9hkg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 1A51CC395DF;
        Fri,  6 Jan 2023 06:10:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 0/6] net: ipa: simplify IPA interrupt handling
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167298541710.969.9209439108124310998.git-patchwork-notify@kernel.org>
Date:   Fri, 06 Jan 2023 06:10:17 +0000
References: <20230104175233.2862874-1-elder@linaro.org>
In-Reply-To: <20230104175233.2862874-1-elder@linaro.org>
To:     Alex Elder <elder@linaro.org>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, caleb.connolly@linaro.org, mka@chromium.org,
        evgreen@chromium.org, andersson@kernel.org,
        quic_cpratapa@quicinc.com, quic_avuyyuru@quicinc.com,
        quic_jponduru@quicinc.com, quic_subashab@quicinc.com,
        elder@kernel.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
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
by Jakub Kicinski <kuba@kernel.org>:

On Wed,  4 Jan 2023 11:52:27 -0600 you wrote:
> One of the IPA's two IRQs fires when data on a suspended channel is
> available (to request that the channel--or system--be resumed to
> recieve the pending data).  This interrupt also handles a few
> conditions signaled by the embedded microcontroller.
> 
> For this "IPA interrupt", the current code requires a handler to be
> dynamically registered for each interrupt condition.  Any condition
> that has no registered handler is quietly ignored.  This design is
> derived from the downstream IPA driver implementation.
> 
> [...]

Here is the summary with links:
  - [net-next,v2,1/6] net: ipa: introduce a common microcontroller interrupt handler
    https://git.kernel.org/netdev/net-next/c/e5709b7c1ede
  - [net-next,v2,2/6] net: ipa: introduce ipa_interrupt_enable()
    https://git.kernel.org/netdev/net-next/c/8e461e1f092b
  - [net-next,v2,3/6] net: ipa: enable IPA interrupt handlers separate from registration
    https://git.kernel.org/netdev/net-next/c/d50ed3558719
  - [net-next,v2,4/6] net: ipa: register IPA interrupt handlers directly
    https://git.kernel.org/netdev/net-next/c/482ae3a993e4
  - [net-next,v2,5/6] net: ipa: kill ipa_interrupt_add()
    https://git.kernel.org/netdev/net-next/c/8d8d3f1a3ef9
  - [net-next,v2,6/6] net: ipa: don't maintain IPA interrupt handler array
    (no matching commit)

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


