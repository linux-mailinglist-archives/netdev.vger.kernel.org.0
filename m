Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45202679148
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 07:50:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233212AbjAXGuZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 01:50:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230346AbjAXGuV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 01:50:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE0B9166C0;
        Mon, 23 Jan 2023 22:50:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 68524B810DB;
        Tue, 24 Jan 2023 06:50:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0E644C433A1;
        Tue, 24 Jan 2023 06:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674543018;
        bh=VsX1wSUEqP60wlA0dZvKv45ZpLVniDwwjZ1VRPUUQWU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=qUor4UnSotlU+BOvl6BeINm0qaVRj20Qs8ef86kSEKUeu1Ry5/KKcLV0EEQ8xyH/C
         owdlYVm3znc/2IiycaYowxbeN4T8nYXeUewjrKoutbC03ufWgWSNZwD307hIiivc/T
         Zmh2xA2F8DMja9xu3O4w6z5Le6EQHM45hUonugEqvFi0q4/7CYJ4oCwUgh17s3zsG7
         EhhWXWa0mC/BuAmJmgiq6B6oc5KJzdRzZGkJNNRccG4Ex0l2S2W1YMl/yPjRtpyIVi
         r3M2K4l9MFE3EGIly22Hk6KQNpblUFsOjqpFqH6cErxuZEtBVvf+BALTLrb2tpZCnB
         M3Gh3+tqlQ5Tg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id EFC3AC04E33;
        Tue, 24 Jan 2023 06:50:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net-next] net: phy: microchip: run phy initialization
 during each link update
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167454301797.1018.1803720096268710399.git-patchwork-notify@kernel.org>
Date:   Tue, 24 Jan 2023 06:50:17 +0000
References: <20230120104733.724701-1-rakesh.sankaranarayanan@microchip.com>
In-Reply-To: <20230120104733.724701-1-rakesh.sankaranarayanan@microchip.com>
To:     Rakesh Sankaranarayanan <rakesh.sankaranarayanan@microchip.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        arun.ramadoss@microchip.com, UNGLinuxDriver@microchip.com,
        andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 20 Jan 2023 16:17:33 +0530 you wrote:
> PHY initialization is supposed to run on every mode changes.
> "lan87xx_config_aneg()" verifies every mode change using
> "phy_modify_changed()" function. Earlier code had phy_modify_changed()
> followed by genphy_soft_reset. But soft_reset resets all the
> pre-configured register values to default state, and lost all the
> initialization done. With this reason gen_phy_reset was removed.
> But it need to go through init sequence each time the mode changed.
> Update lan87xx_config_aneg() to invoke phy_init once successful mode
> update is detected.
> 
> [...]

Here is the summary with links:
  - [v2,net-next] net: phy: microchip: run phy initialization during each link update
    https://git.kernel.org/netdev/net-next/c/d7bf56e0c591

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


