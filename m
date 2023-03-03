Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 138CA6A9105
	for <lists+netdev@lfdr.de>; Fri,  3 Mar 2023 07:30:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229702AbjCCGaX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Mar 2023 01:30:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbjCCGaU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Mar 2023 01:30:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46CE7EB49;
        Thu,  2 Mar 2023 22:30:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D25A06175D;
        Fri,  3 Mar 2023 06:30:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2E08FC433EF;
        Fri,  3 Mar 2023 06:30:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677825018;
        bh=UtECWJpXZHKnHvCL32tsjeaj1N7CRhiW8Jz/UUlE4lo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=u6GOhNxuvNIEsVrxSZcBU99jkoKYnz22NZ2k7HNIXWyjzJzDTzS5+m3EQPRWbNMbt
         ti0e6u5wKhKtr8HXp3ey33aEj9ukDbglklXzy7JWNzOzvCgWOnvrQh43O6NQ4v8TDm
         liLAgiq8MqcmYrfplnTDgc7q2n+VhaCVBAkSdg/E5GjiNwGhAGLaiHzEcJd9H0OI4L
         t519esalEnLw9j/Bs3tzZG6+wnWeNJLQCWQ3C/EhVj3RkqKVuZ5adLpoJ7IO5gn/N6
         uxFB1RSj59+Jr6gLJ26Tg6QPfT6LdgXnSeRygfL4H1o80TD8nqdnX70V5lxHfGTv+9
         jeiv4VAB7+W9Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 0A6D1C395D9;
        Fri,  3 Mar 2023 06:30:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3 net] net:usb:lan78xx: fix accessing the LAN7800's internal
 phy specific registers from the MAC driver
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167782501803.9922.3371696918749912081.git-patchwork-notify@kernel.org>
Date:   Fri, 03 Mar 2023 06:30:18 +0000
References: <20230301154307.30438-1-yuiko.oshino@microchip.com>
In-Reply-To: <20230301154307.30438-1-yuiko.oshino@microchip.com>
To:     Yuiko Oshino <yuiko.oshino@microchip.com>
Cc:     enguerrand.de-ribaucourt@savoirfairelinux.com,
        woojung.huh@microchip.com, andrew@lunn.ch, hkallweit1@gmail.com,
        netdev@vger.kernel.org, pabeni@redhat.com, davem@davemloft.net,
        UNGLinuxDriver@microchip.com, linux@armlinux.org.uk,
        edumazet@google.com, linux-usb@vger.kernel.org, kuba@kernel.org
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 1 Mar 2023 08:43:07 -0700 you wrote:
> Move the LAN7800 internal phy (phy ID  0x0007c132) specific register
> accesses to the phy driver (microchip.c).
> 
> Fix the error reported by Enguerrand de Ribaucourt in December 2022,
> "Some operations during the cable switch workaround modify the register
> LAN88XX_INT_MASK of the PHY. However, this register is specific to the
> LAN8835 PHY. For instance, if a DP8322I PHY is connected to the LAN7801,
> that register (0x19), corresponds to the LED and MAC address
> configuration, resulting in unapropriate behavior."
> 
> [...]

Here is the summary with links:
  - [v3,net] net:usb:lan78xx: fix accessing the LAN7800's internal phy specific registers from the MAC driver
    https://git.kernel.org/netdev/net/c/e57cf3639c32

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


