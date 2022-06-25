Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8147F55A751
	for <lists+netdev@lfdr.de>; Sat, 25 Jun 2022 07:41:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231946AbiFYFkR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jun 2022 01:40:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231331AbiFYFkQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Jun 2022 01:40:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9586A51333;
        Fri, 24 Jun 2022 22:40:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3089F60AE3;
        Sat, 25 Jun 2022 05:40:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5AB8CC341CC;
        Sat, 25 Jun 2022 05:40:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656135614;
        bh=DDmA3+A5PginCNfJ8pUS0urfuAliRawSeMY/W6w8LRw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=cLrB7WOu3OG1JF2sheq1bhBZ42+UENE4BCOpP5gqn628eC2Ic7W7Yttriqz+FW99r
         hgXyPzGWbFldn0j2NAPLkDHBiPLYLBeZD/vPN1V8ldJFXQd7W5gv7A3FI1YqfYXjAH
         4vY6nbB2SaimTQBasxyBag0IY4KDLZ4b6M8kXRAHkqoYmZS/fsZ7SSgsF44XbzZVas
         EJluPdvejP/t79E8AMkpK0BXMD/sTC99GwHRjHvFGQIarlfZSkfW9I8/TvklIWrybZ
         Dg/7RGj4XCWQshQ0ytJjerGIRjLduZnCOx6+voH077Lx7J2uzlQgYI3o+yYxwN8uP/
         EKkDHXB9eXPpg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 3E75EE8DBEE;
        Sat, 25 Jun 2022 05:40:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2] usbnet: Fix linkwatch use-after-free on
 disconnect
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165613561425.1389.15199490480360862907.git-patchwork-notify@kernel.org>
Date:   Sat, 25 Jun 2022 05:40:14 +0000
References: <d1c87ebe9fc502bffcd1576e238d685ad08321e4.1655987888.git.lukas@wunner.de>
In-Reply-To: <d1c87ebe9fc502bffcd1576e238d685ad08321e4.1655987888.git.lukas@wunner.de>
To:     Lukas Wunner <lukas@wunner.de>
Cc:     oneukum@suse.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, jannh@google.com, o.rempel@pengutronix.de,
        linux@rempel-privat.de, edumazet@google.com,
        netdev@vger.kernel.org, linux-usb@vger.kernel.org, andrew@lunn.ch,
        jackychou@asix.com.tw, w@1wt.eu, LinoSanfilippo@gmx.de,
        p.rosenberger@kunbus.com, hkallweit1@gmail.com
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

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 23 Jun 2022 14:50:59 +0200 you wrote:
> usbnet uses the work usbnet_deferred_kevent() to perform tasks which may
> sleep.  On disconnect, completion of the work was originally awaited in
> ->ndo_stop().  But in 2003, that was moved to ->disconnect() by historic
> commit "[PATCH] USB: usbnet, prevent exotic rtnl deadlock":
> 
>   https://git.kernel.org/tglx/history/c/0f138bbfd83c
> 
> [...]

Here is the summary with links:
  - [net-next,v2] usbnet: Fix linkwatch use-after-free on disconnect
    https://git.kernel.org/netdev/net-next/c/a69e617e533e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


