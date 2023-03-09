Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6A6E6B1C53
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 08:30:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230019AbjCIHa3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 02:30:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229611AbjCIHaY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 02:30:24 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D83661A91;
        Wed,  8 Mar 2023 23:30:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CE253B81E92;
        Thu,  9 Mar 2023 07:30:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 76B23C433D2;
        Thu,  9 Mar 2023 07:30:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678347020;
        bh=JgUaHUieKlq5j09NA5/MYf0E8p1BKJC2tOJvSLQP9zc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=a32uoB6llCfq/3LqJgnWyzcl64fzX26ZD9f1MyFDb4LFKG7/+R241ALklF3/3+iS5
         Ch8FMs9wUcL0BWInmu93H/ohnZi/5lsqfmHRK5Ek5krOc+yVnYfhD+TQT1g1x+sNrE
         3MuMisg4xxyYuYkURUtxEm4JIhHG6bMPcGLYurit3oN4i760ZyKWIDIG4FGpiLoxTL
         /YQuFTBFAEiD31ZiDt4e4vcu9cSVSOZQM/sCjifI5MQoH3c4gcRsusfU4NhhE4Wm/a
         vHUnPgulmoheQNLCzuEqS7h/xIrSHZQ8iTevj3f0ZbqybU6GS3+3ngJgiWWpikAUVf
         ug5oFiQwdNYYQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 56542E5250A;
        Thu,  9 Mar 2023 07:30:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: dsa: mt7530: permit port 5 to work without port 6 on
 MT7621 SoC
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167834701934.22182.717765078192352405.git-patchwork-notify@kernel.org>
Date:   Thu, 09 Mar 2023 07:30:19 +0000
References: <20230307155411.868573-1-vladimir.oltean@nxp.com>
In-Reply-To: <20230307155411.868573-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, sean.wang@mediatek.com,
        Landen.Chao@mediatek.com, dqfext@gmail.com, andrew@lunn.ch,
        f.fainelli@gmail.com, matthias.bgg@gmail.com,
        angelogioacchino.delregno@collabora.com, linux@armlinux.org.uk,
        opensource@vdorst.com, lynxis@fe80.eu, ilya.lipnitskiy@gmail.com,
        richard@routerhints.com, frank-w@public-files.de,
        erkin.bozoglu@xeront.com, gerg@kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, arinc9.unal@gmail.com,
        arinc.unal@arinc9.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Tue,  7 Mar 2023 17:54:11 +0200 you wrote:
> The MT7530 switch from the MT7621 SoC has 2 ports which can be set up as
> internal: port 5 and 6. Arınç reports that the GMAC1 attached to port 5
> receives corrupted frames, unless port 6 (attached to GMAC0) has been
> brought up by the driver. This is true regardless of whether port 5 is
> used as a user port or as a CPU port (carrying DSA tags).
> 
> Offline debugging (blind for me) which began in the linked thread showed
> experimentally that the configuration done by the driver for port 6
> contains a step which is needed by port 5 as well - the write to
> CORE_GSWPLL_GRP2 (note that I've no idea as to what it does, apart from
> the comment "Set core clock into 500Mhz"). Prints put by Arınç show that
> the reset value of CORE_GSWPLL_GRP2 is RG_GSWPLL_POSDIV_500M(1) |
> RG_GSWPLL_FBKDIV_500M(40) (0x128), both on the MCM MT7530 from the
> MT7621 SoC, as well as on the standalone MT7530 from MT7623NI Bananapi
> BPI-R2. Apparently, port 5 on the standalone MT7530 can work under both
> values of the register, while on the MT7621 SoC it cannot.
> 
> [...]

Here is the summary with links:
  - [net] net: dsa: mt7530: permit port 5 to work without port 6 on MT7621 SoC
    https://git.kernel.org/netdev/net/c/c8b8a3c601f2

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


