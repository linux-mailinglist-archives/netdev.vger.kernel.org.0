Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81F094AE948
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 06:30:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235619AbiBIF1x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 00:27:53 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:48882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233174AbiBIFU1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 00:20:27 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0048DC03C19A
        for <netdev@vger.kernel.org>; Tue,  8 Feb 2022 21:20:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A6078B81EBB
        for <netdev@vger.kernel.org>; Wed,  9 Feb 2022 05:20:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 53420C340EE;
        Wed,  9 Feb 2022 05:20:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644384028;
        bh=6GCWCBHRvjx1yZ16/hgDtoxyjRz2nD2OMbxVKkY3qao=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=h8GETW4Acqap2tI3VCxJo6Gsuqzx3H5Wa9rGJUl76fQTJRim28zoQkrgTtFjyR5av
         lC+5/Y4yHlFk5Mkwfr0NEcecVJ2gLYNPySe8j9X97nIHKh5JMZHmOS79tQvCTTxW2b
         5NGroScw3nUIozdaH9wS7th83WPy3c+yD2mrz9hrIZeDX4+RzPGNl6znEg89/biqNj
         3+FAVFTOCe7WypkBgUw825AiJDZOQ1PktPBBZY8NuMdVPXp7SJKqE3E8vZn1gMg+ni
         L+JjXg1vH4Og87n5oauWSIs4hjyKOdPkcz2KdKG2UwrZou3bpO/1sVu6AfhLCcsBSa
         x0AMqIPs4rXyw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 40BB4E5D09D;
        Wed,  9 Feb 2022 05:20:28 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/7] More DSA fixes for devres + mdiobus_{alloc,register}
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164438402826.12376.7316616001737418970.git-patchwork-notify@kernel.org>
Date:   Wed, 09 Feb 2022 05:20:28 +0000
References: <20220207161553.579933-1-vladimir.oltean@nxp.com>
In-Reply-To: <20220207161553.579933-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, f.fainelli@gmail.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, olteanv@gmail.com, davem@davemloft.net,
        kuba@kernel.org, hauke@hauke-m.de, sean.wang@mediatek.com,
        Landen.Chao@mediatek.com, dqfext@gmail.com, matthias.bgg@gmail.com,
        claudiu.manoil@nxp.com, alexandre.belloni@bootlin.com,
        UNGLinuxDriver@microchip.com, linux@rempel-privat.de,
        bgolaszewski@baylibre.com, laurentiu.tudor@nxp.com,
        rafael.richter@gin.de, daniel.klauer@gin.de
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

This series was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon,  7 Feb 2022 18:15:46 +0200 you wrote:
> The initial patch series "[net,0/2] Fix mdiobus users with devres"
> https://patchwork.kernel.org/project/netdevbpf/cover/20210920214209.1733768-1-vladimir.oltean@nxp.com/
> fixed some instances where DSA drivers on slow buses (SPI, I2C) trigger
> a panic (changed since then to a warn) in mdiobus_free. That was due to
> devres calling mdiobus_free() with no prior mdiobus_unregister(), which
> again was due to commit ac3a68d56651 ("net: phy: don't abuse devres in
> devm_mdiobus_register()") by Bartosz Golaszewski.
> 
> [...]

Here is the summary with links:
  - [net,1/7] net: dsa: mv88e6xxx: don't use devres for mdiobus
    https://git.kernel.org/netdev/net/c/f53a2ce893b2
  - [net,2/7] net: dsa: ar9331: register the mdiobus under devres
    https://git.kernel.org/netdev/net/c/50facd86e9fb
  - [net,3/7] net: dsa: bcm_sf2: don't use devres for mdiobus
    https://git.kernel.org/netdev/net/c/08f1a2082234
  - [net,4/7] net: dsa: felix: don't use devres for mdiobus
    https://git.kernel.org/netdev/net/c/209bdb7ec6a2
  - [net,5/7] net: dsa: seville: register the mdiobus under devres
    https://git.kernel.org/netdev/net/c/bd488afc3b39
  - [net,6/7] net: dsa: mt7530: fix kernel bug in mdiobus_free() when unbinding
    https://git.kernel.org/netdev/net/c/9ffe3d09e32d
  - [net,7/7] net: dsa: lantiq_gswip: don't use devres for mdiobus
    https://git.kernel.org/netdev/net/c/0d120dfb5d67

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


