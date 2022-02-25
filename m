Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A69CB4C42C2
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 11:50:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239813AbiBYKup (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 05:50:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233510AbiBYKuo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 05:50:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4915F235335;
        Fri, 25 Feb 2022 02:50:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CDF4A61752;
        Fri, 25 Feb 2022 10:50:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 328D7C340EF;
        Fri, 25 Feb 2022 10:50:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645786211;
        bh=LC08xMH6CWt69AaKVSvadbtW1VHUd5kvo4F8105Xn3s=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=m/rycRA/3JDZtPIlVxvF05spVkxMWCU2KsoWyudLBjn/+vuN8miTZ3470lfzaJEyb
         zgdG7lGpXeunRXwt+WLmnZ9lob0g3aKH6oVR6VDMMJcOTukRfIFLxBNBjz9L9AXFBl
         6Q9faNDtTecp3PhoquJ7QTcYPMUENJJc99XGA+fPexBq9LLdECubHd6zK/K264KeMM
         rG6bM8NVs8f3HtEydMs9hhN5/l/mHASkyUVpC6AkNMPnuUDTy7fz8j43R0kElfJLjy
         0hUly9MfGcTDKDuiEa7aTZ3yMjXn8RtSEsmEN9kjm2TRBf1+NMLdEuUiQkGvnGcP4H
         eaySrIK/WoP+g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 12FC5EAC09B;
        Fri, 25 Feb 2022 10:50:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] net: stmmac: only enable DMA interrupts when ready
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164578621107.20500.7059281134747424686.git-patchwork-notify@kernel.org>
Date:   Fri, 25 Feb 2022 10:50:11 +0000
References: <20220224113829.1092859-1-vincent.whitchurch@axis.com>
In-Reply-To: <20220224113829.1092859-1-vincent.whitchurch@axis.com>
To:     Vincent Whitchurch <vincent.whitchurch@axis.com>
Cc:     peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org,
        mcoquelin.stm32@gmail.com, kernel@axis.com, larper@axis.com,
        srinivas.kandagatla@st.com, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by David S. Miller <davem@davemloft.net>:

On Thu, 24 Feb 2022 12:38:29 +0100 you wrote:
> In this driver's ->ndo_open() callback, it enables DMA interrupts,
> starts the DMA channels, then requests interrupts with request_irq(),
> and then finally enables napi.
> 
> If RX DMA interrupts are received before napi is enabled, no processing
> is done because napi_schedule_prep() will return false.  If the network
> has a lot of broadcast/multicast traffic, then the RX ring could fill up
> completely before napi is enabled.  When this happens, no further RX
> interrupts will be delivered, and the driver will fail to receive any
> packets.
> 
> [...]

Here is the summary with links:
  - [v2] net: stmmac: only enable DMA interrupts when ready
    https://git.kernel.org/netdev/net/c/087a7b944c5d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


