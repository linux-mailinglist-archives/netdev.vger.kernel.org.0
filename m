Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7246D638663
	for <lists+netdev@lfdr.de>; Fri, 25 Nov 2022 10:40:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229632AbiKYJkV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Nov 2022 04:40:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229619AbiKYJkU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Nov 2022 04:40:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78B853057D;
        Fri, 25 Nov 2022 01:40:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 34D67B82A15;
        Fri, 25 Nov 2022 09:40:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CB1B7C433D7;
        Fri, 25 Nov 2022 09:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669369216;
        bh=Yren0HJ7km4sZa95qF5G0hT934SQakZ3VmowUXfyCkU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=SLDAMCYPl2FKxxpRavmX2F9kYtKvUkglfb0F5whv76llAtVL/lQEeI7kFgshPlvju
         /HzewGZiL4D8N4NZEzlq+qFxZqVxYAKYSxhpu9Hnn6evs7aeziwBwMWrRtjGWGBA1F
         xo6xTuurO/Xnxnzefmid1z+QJkiAUfsK9hCzIi0Ye+6KVLo3ZDHSpUDnp0Kreq9R7K
         C0I5ADKjnf/4ON0F34OYTfP8mtmYKzFAdvKoezB2AczMCkoYkqgs/ee+vx6ossVz4N
         xGKFT+ravZVw22RY6QrvdhFz+G7LIzT8bgtYymVvSHZwHoGv+0tfU26fr8qRTxTHxj
         Wc7DkfO7VRtuQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A52D0C395EC;
        Fri, 25 Nov 2022 09:40:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v4] net: stmmac: Set MAC's flow control register to
 reflect current settings
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166936921667.2800.1734006486713251964.git-patchwork-notify@kernel.org>
Date:   Fri, 25 Nov 2022 09:40:16 +0000
References: <20221123105110.23617-1-wei.sheng.goh@intel.com>
In-Reply-To: <20221123105110.23617-1-wei.sheng.goh@intel.com>
To:     Goh@ci.codeaurora.org, Wei Sheng <wei.sheng.goh@intel.com>
Cc:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, mcoquelin.stm32@gmail.com,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        alexandre.torgue@foss.st.com, boon.leong.ong@intel.com,
        weifeng.voon@intel.com, tee.min.tan@intel.com,
        noor.azura.ahmad.tarmizi@intel.com, hong.aun.looi@intel.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed, 23 Nov 2022 18:51:10 +0800 you wrote:
> Currently, pause frame register GMAC_RX_FLOW_CTRL_RFE is not updated
> correctly when 'ethtool -A <IFACE> autoneg off rx off tx off' command
> is issued. This fix ensures the flow control change is reflected directly
> in the GMAC_RX_FLOW_CTRL_RFE register.
> 
> Fixes: 46f69ded988d ("net: stmmac: Use resolved link config in mac_link_up()")
> Cc: <stable@vger.kernel.org> # 5.10.x
> Signed-off-by: Goh, Wei Sheng <wei.sheng.goh@intel.com>
> Signed-off-by: Noor Azura Ahmad Tarmizi <noor.azura.ahmad.tarmizi@intel.com>
> 
> [...]

Here is the summary with links:
  - [net,v4] net: stmmac: Set MAC's flow control register to reflect current settings
    https://git.kernel.org/netdev/net/c/cc3d2b5fc0d6

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


