Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D6FA56514D
	for <lists+netdev@lfdr.de>; Mon,  4 Jul 2022 11:50:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233869AbiGDJuU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jul 2022 05:50:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233320AbiGDJuR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jul 2022 05:50:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E07A2AE2;
        Mon,  4 Jul 2022 02:50:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CDD52B80E80;
        Mon,  4 Jul 2022 09:50:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 74CCDC341CA;
        Mon,  4 Jul 2022 09:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656928214;
        bh=S8n6+Ngtee2wWA0ucOGCkhjmFZeStMy8nhrQpREw974=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=RR+b6BYfu0dBfuMItaWiqldYNbJnnyD7wo0ia1G8Fsl8GAr3VHGUAMIoKziD5tMfz
         reElwjbY7sbyCC7cQU285VOO1lAoJYkxoag+Qzf8vohZ/VWIccqQUL4Iqk7TzfxL+K
         JXQsMq0I1XsnrCIvOa3YGKVuxBXOCxhUtLsPz+9P6df8gBxXiuswNrsY0XBzcTSpjC
         kv6TwDvBefofIg6NuzNJG/1knC06gXaQVYVQSPVFLX59j6+ZQ4sWfhzpEHX9O1nVkU
         je0pWCFj8/cBSB5OmMjXF5q1By+VmGrFWHQJlRRsQo5ZvRsHYBBdRICgKSzTip1287
         wvutIxY9fjmUw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 5603EE45BDE;
        Mon,  4 Jul 2022 09:50:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 0/3] Deadlock no more in LAN95xx
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165692821434.21895.12215940507809769729.git-patchwork-notify@kernel.org>
Date:   Mon, 04 Jul 2022 09:50:14 +0000
References: <cover.1656707954.git.lukas@wunner.de>
In-Reply-To: <cover.1656707954.git.lukas@wunner.de>
To:     Lukas Wunner <lukas@wunner.de>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, steve.glendinning@shawell.net,
        UNGLinuxDriver@microchip.com, oneukum@suse.com,
        andre.edich@microchip.com, o.rempel@pengutronix.de,
        linux@rempel-privat.de, martyn.welch@collabora.com,
        ghojda@yo2urs.ro, chf.fritz@googlemail.com, LinoSanfilippo@gmx.de,
        p.rosenberger@kunbus.com, m.szyprowski@samsung.com,
        fntoth@gmail.com, andrew@lunn.ch, stern@rowland.harvard.edu
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Fri, 1 Jul 2022 22:47:50 +0200 you wrote:
> Second attempt at fixing a runtime resume deadlock in the LAN95xx USB driver:
> 
> In short, the driver isn't using the "nopm" register accessors in portions
> of its runtime resume path, causing a deadlock.  I'm fixing that by
> auto-detecting whether nopm accessors shall be used, instead of
> having to explicitly call them wherever it's necessary.
> As a byproduct, code size shrinks significantly (see diffstat below).
> 
> [...]

Here is the summary with links:
  - [net-next,v2,1/3] usbnet: smsc95xx: Fix deadlock on runtime resume
    https://git.kernel.org/netdev/net-next/c/7b960c967f2a
  - [net-next,v2,2/3] usbnet: smsc95xx: Clean up nopm handling
    https://git.kernel.org/netdev/net-next/c/3147242980c5
  - [net-next,v2,3/3] usbnet: smsc95xx: Clean up unnecessary BUG_ON() upon register access
    https://git.kernel.org/netdev/net-next/c/03b3df43ce1f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


