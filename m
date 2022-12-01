Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB43A63F0E1
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 13:50:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230354AbiLAMu0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 07:50:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229843AbiLAMuY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 07:50:24 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7CD191C3A;
        Thu,  1 Dec 2022 04:50:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6AA2AB81F3E;
        Thu,  1 Dec 2022 12:50:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1D218C433D7;
        Thu,  1 Dec 2022 12:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669899018;
        bh=tHu/RAOQMiQxnwrAgil/D4i7F+V8yl6O/JMiB1Av2Xk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=p1iJnIIScCz0obgtCvhTltSGf8OHkdanhSeB8S3DoTjJookiLeNnulaibwWc2K0bR
         keac/9EuibCSDE0k53Az2bmvrADwvkj71J0tJdpSrbEB/vh0lRJ2qClPSmjbnVUfXv
         Sw/h4qsUEw39XSp/kVSvpZe0BIff6ItfJLGtYw1tyHjyYKGKh7d9MnTLJD6UrGMM0x
         JbESfEFE73PS29SbCChcMI/KtprwTe4LIT/hPAJXlKpVy04iwGNQClH2oC4ByNvuPl
         1kplYwAfXee6rxFjlYM3M3DREvQkKHAbn2BQ4XvTNNOUglQsTNl5PtKab0oFge4Ihi
         s+ZrFNTUow35Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id F2384E21EF1;
        Thu,  1 Dec 2022 12:50:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 00/12] Fix rtnl_mutex deadlock with DPAA2 and SFP
 modules
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166989901798.1197.13323886521084195316.git-patchwork-notify@kernel.org>
Date:   Thu, 01 Dec 2022 12:50:17 +0000
References: <20221129141221.872653-1-vladimir.oltean@nxp.com>
In-Reply-To: <20221129141221.872653-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, ioana.ciornei@nxp.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux@armlinux.org.uk, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
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
by Paolo Abeni <pabeni@redhat.com>:

On Tue, 29 Nov 2022 16:12:09 +0200 you wrote:
> This patch set deliberately targets net-next and lacks Fixes: tags due
> to caution on my part.
> 
> While testing some SFP modules on the Solidrun Honeycomb LX2K platform,
> I noticed that rebooting causes a deadlock:
> 
> ============================================
> WARNING: possible recursive locking detected
> 6.1.0-rc5-07010-ga9b9500ffaac-dirty #656 Not tainted
> 
> [...]

Here is the summary with links:
  - [net-next,01/12] net: dpaa2-eth: don't use -ENOTSUPP error code
    https://git.kernel.org/netdev/net-next/c/91c71bf14da4
  - [net-next,02/12] net: dpaa2: replace dpaa2_mac_is_type_fixed() with dpaa2_mac_is_type_phy()
    https://git.kernel.org/netdev/net-next/c/320fefa9e2ed
  - [net-next,03/12] net: dpaa2-mac: absorb phylink_start() call into dpaa2_mac_start()
    https://git.kernel.org/netdev/net-next/c/385333888154
  - [net-next,04/12] net: dpaa2-mac: remove defensive check in dpaa2_mac_disconnect()
    https://git.kernel.org/netdev/net-next/c/ccbd7822950f
  - [net-next,05/12] net: dpaa2-eth: assign priv->mac after dpaa2_mac_connect() call
    https://git.kernel.org/netdev/net-next/c/02d61948e8da
  - [net-next,06/12] net: dpaa2-switch: assign port_priv->mac after dpaa2_mac_connect() call
    https://git.kernel.org/netdev/net-next/c/88d64367cea0
  - [net-next,07/12] net: dpaa2: publish MAC stringset to ethtool -S even if MAC is missing
    https://git.kernel.org/netdev/net-next/c/29811d6e19d7
  - [net-next,08/12] net: dpaa2-switch replace direct MAC access with dpaa2_switch_port_has_mac()
    https://git.kernel.org/netdev/net-next/c/bc230671bfb2
  - [net-next,09/12] net: dpaa2-eth: connect to MAC before requesting the "endpoint changed" IRQ
    https://git.kernel.org/netdev/net-next/c/55f90a4d07ec
  - [net-next,10/12] net: dpaa2-eth: serialize changes to priv->mac with a mutex
    https://git.kernel.org/netdev/net-next/c/2291982e29b1
  - [net-next,11/12] net: dpaa2-switch: serialize changes to priv->mac with a mutex
    https://git.kernel.org/netdev/net-next/c/3c7f44fa9c4c
  - [net-next,12/12] net: dpaa2-mac: move rtnl_lock() only around phylink_{,dis}connect_phy()
    https://git.kernel.org/netdev/net-next/c/87db82cb6149

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


