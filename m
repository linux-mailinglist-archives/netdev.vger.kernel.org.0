Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E049E554259
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 07:51:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357014AbiFVFuQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 01:50:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356811AbiFVFuP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 01:50:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B7C836687;
        Tue, 21 Jun 2022 22:50:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9D83E61984;
        Wed, 22 Jun 2022 05:50:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DE474C341C5;
        Wed, 22 Jun 2022 05:50:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655877014;
        bh=NYMvEwJ+Kg6KM2WUIA6aIdBjJvD5lTTcCxon/DwW/70=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=H8UGj6ZPOGQq5h7zyOv0y5h0Do8DlwJq26Em137Xed0vDBBDqyQ5LTB0ZnvdANfLw
         4zU1Z4ilBCA96zIt3qW7QBXyEzzunfgN9s2jSophUW+2Ab/hLw5BdJunXwAr9cRTFU
         PfS5eBTwiI24V7Tv74/13HAAyh093ZJ55PmSmPaNnOqYrSMJN2Q2tDOcmItEH6nnbn
         VwpqiP0fncCud3tdIrVyBs6VfwjVbwH4VOTaypRhSivoNVEZNu8F+KGbk43AHV37tC
         PbI9CZ0CBqr35lHonYA6U+Xd+sD9t+w40poUww3Wdn55DCWng54mvmnbEJmkdMI4o+
         mPsVgMhiyeW5g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id BB308E574DA;
        Wed, 22 Jun 2022 05:50:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: phy: smsc: Disable Energy Detect Power-Down in
 interrupt mode
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165587701375.11274.5335349577146413179.git-patchwork-notify@kernel.org>
Date:   Wed, 22 Jun 2022 05:50:13 +0000
References: <439a3f3168c2f9d44b5fd9bb8d2b551711316be6.1655714438.git.lukas@wunner.de>
In-Reply-To: <439a3f3168c2f9d44b5fd9bb8d2b551711316be6.1655714438.git.lukas@wunner.de>
To:     Lukas Wunner <lukas@wunner.de>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, steve.glendinning@shawell.net,
        UNGLinuxDriver@microchip.com, oneukum@suse.com,
        andre.edich@microchip.com, linux@rempel-privat.de,
        martyn.welch@collabora.com, ghojda@yo2urs.ro,
        chf.fritz@googlemail.com, LinoSanfilippo@gmx.de,
        p.rosenberger@kunbus.com, z.han@kunbus.com, hkallweit1@gmail.com,
        andrew@lunn.ch, linux@armlinux.org.uk, fntoth@gmail.com,
        m.szyprowski@samsung.com, krzk@kernel.org,
        linux-samsung-soc@vger.kernel.org
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 20 Jun 2022 13:04:50 +0200 you wrote:
> Simon reports that if two LAN9514 USB adapters are directly connected
> without an intermediate switch, the link fails to come up and link LEDs
> remain dark.  The issue was introduced by commit 1ce8b37241ed ("usbnet:
> smsc95xx: Forward PHY interrupts to PHY driver to avoid polling").
> 
> The PHY suffers from a known erratum wherein link detection becomes
> unreliable if Energy Detect Power-Down is used.  In poll mode, the
> driver works around the erratum by briefly disabling EDPD for 640 msec
> to detect a neighbor, then re-enabling it to save power.
> 
> [...]

Here is the summary with links:
  - [net] net: phy: smsc: Disable Energy Detect Power-Down in interrupt mode
    https://git.kernel.org/netdev/net/c/2642cc6c3bbe

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


