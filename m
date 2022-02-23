Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5660E4C137C
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 14:00:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239903AbiBWNAl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 08:00:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237128AbiBWNAk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 08:00:40 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BB1C2CCA5;
        Wed, 23 Feb 2022 05:00:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E170E614EF;
        Wed, 23 Feb 2022 13:00:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 46EE3C340F3;
        Wed, 23 Feb 2022 13:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645621212;
        bh=weB59aojM0OQn/Xy7GXVElCcLRWhcGJyd2VR3nEi3pU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ct0NHB9Nd5GUht0vGmmowfkBuECMqOdVCTYuW1bjKGm+GaG4mc4bqoiUMBwijiHqe
         w0poqSK8qzwF0TgAboZsjKp8IBWR/1oNCuKkb33r3+B5x3Irzead19u2BqTB/Cp96I
         pYNn49CBc8I/YZxlxEvFEdb9Ne1O55OQYaSbQfQ6aIjAEVTXEWmlECebaF5k9Jwy/Q
         oDvrX5GRyKwYV6x26QfBHh2LoS392fVVUCcwjcJ42NohYoPs2vbVJPkSQPpyWohlAC
         SmrLdQL0oXJ1FhfcIMpgjkWMrwVuESYthoTOJv1v4/Eznaj9569JAbVYo5y/NlOUBh
         xGjR3wU8QmB8Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 2B22EE6D528;
        Wed, 23 Feb 2022 13:00:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v5 0/5] Add support for locked bridge ports (for
 802.1X)
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164562121216.5194.10519557733137319145.git-patchwork-notify@kernel.org>
Date:   Wed, 23 Feb 2022 13:00:12 +0000
References: <20220223101650.1212814-1-schultz.hans+netdev@gmail.com>
In-Reply-To: <20220223101650.1212814-1-schultz.hans+netdev@gmail.com>
To:     Hans Schultz <schultz.hans@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        schultz.hans+netdev@gmail.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com,
        roopa@nvidia.com, nikolay@nvidia.com, shuah@kernel.org,
        ssuryaextr@gmail.com, dsahern@kernel.org, idosch@nvidia.com,
        petrm@nvidia.com, amcohen@nvidia.com, po-hsu.lin@canonical.com,
        baowen.zheng@corigine.com, linux-kernel@vger.kernel.org,
        bridge@lists.linux-foundation.org, linux-kselftest@vger.kernel.org
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

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed, 23 Feb 2022 11:16:45 +0100 you wrote:
> This series starts by adding support for SA filtering to the bridge,
> which is then allowed to be offloaded to switchdev devices. Furthermore
> an offloading implementation is supplied for the mv88e6xxx driver.
> 
> Public Local Area Networks are often deployed such that there is a
> risk of unauthorized or unattended clients getting access to the LAN.
> To prevent such access we introduce SA filtering, such that ports
> designated as secure ports are set in locked mode, so that only
> authorized source MAC addresses are given access by adding them to
> the bridges forwarding database. Incoming packets with source MAC
> addresses that are not in the forwarding database of the bridge are
> discarded. It is then the task of user space daemons to populate the
> bridge's forwarding database with static entries of authorized entities.
> 
> [...]

Here is the summary with links:
  - [net-next,v5,1/5] net: bridge: Add support for bridge port in locked mode
    https://git.kernel.org/netdev/net-next/c/a21d9a670d81
  - [net-next,v5,2/5] net: bridge: Add support for offloading of locked port flag
    https://git.kernel.org/netdev/net-next/c/fa1c83342987
  - [net-next,v5,3/5] net: dsa: Include BR_PORT_LOCKED in the list of synced brport flags
    https://git.kernel.org/netdev/net-next/c/b9e8b58fd2cb
  - [net-next,v5,4/5] net: dsa: mv88e6xxx: Add support for bridge port locked mode
    https://git.kernel.org/netdev/net-next/c/34ea415f927e
  - [net-next,v5,5/5] selftests: forwarding: tests of locked port feature
    https://git.kernel.org/netdev/net-next/c/b2b681a41251

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


