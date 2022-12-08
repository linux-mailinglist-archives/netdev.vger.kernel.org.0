Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C039646789
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 04:10:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229917AbiLHDKf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 22:10:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229777AbiLHDKS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 22:10:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD26F7616E;
        Wed,  7 Dec 2022 19:10:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5821D61D4B;
        Thu,  8 Dec 2022 03:10:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9C1CFC433D7;
        Thu,  8 Dec 2022 03:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670469016;
        bh=JKY8taeO76lQp+JsyteED53SJMrGqBbdviof8+x0utc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=t0XrHDgWndWrQZvfUAb2kzAcTS/n0KqiLeQoEDqroVWuPtYtp1sAwRayd8phD6ZSv
         kJb730fQ6U7Wi5ewjkN8Wce1dNFfSPOQ8dCVn7hzmvFQdTjnfvv177jtkew19R2Xyl
         YhRscrdOey9YCqAeEILt/a3cycLszEOcfzT5vcHH1NmbxxWd2jZELClHlIpirnlOwJ
         V1pgLS9yOgdg3mnmyGjCdlEQpr2z7BO6RjrKmqBy0qHZdgpmlZmrXIe/z/yuYeWbH/
         C8TAFdS0Vkp+RCays2LkNyBWu4cFnflJX4EwXb0Bbw5Rf23RXbkGilqVHNmVQ0IZPX
         Obc6ZTCbuKEBg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7FC9CE4D02C;
        Thu,  8 Dec 2022 03:10:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/4] can: af_can: fix NULL pointer dereference in
 can_rcv_filter
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167046901651.21108.4760310811680515367.git-patchwork-notify@kernel.org>
Date:   Thu, 08 Dec 2022 03:10:16 +0000
References: <20221207105243.2483884-2-mkl@pengutronix.de>
In-Reply-To: <20221207105243.2483884-2-mkl@pengutronix.de>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        linux-can@vger.kernel.org, kernel@pengutronix.de,
        socketcan@hartkopp.net,
        syzbot+2d7f58292cb5b29eb5ad@syzkaller.appspotmail.com,
        harperchen1110@gmail.com, stable@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by Marc Kleine-Budde <mkl@pengutronix.de>:

On Wed,  7 Dec 2022 11:52:40 +0100 you wrote:
> From: Oliver Hartkopp <socketcan@hartkopp.net>
> 
> Analogue to commit 8aa59e355949 ("can: af_can: fix NULL pointer
> dereference in can_rx_register()") we need to check for a missing
> initialization of ml_priv in the receive path of CAN frames.
> 
> Since commit 4e096a18867a ("net: introduce CAN specific pointer in the
> struct net_device") the check for dev->type to be ARPHRD_CAN is not
> sufficient anymore since bonding or tun netdevices claim to be CAN
> devices but do not initialize ml_priv accordingly.
> 
> [...]

Here is the summary with links:
  - [net,1/4] can: af_can: fix NULL pointer dereference in can_rcv_filter
    https://git.kernel.org/netdev/net/c/0acc442309a0
  - [net,2/4] can: slcan: fix freed work crash
    https://git.kernel.org/netdev/net/c/fb855e9f3b6b
  - [net,3/4] can: can327: flush TX_work on ldisc .close()
    https://git.kernel.org/netdev/net/c/f4a4d121ebec
  - [net,4/4] can: esd_usb: Allow REC and TEC to return to zero
    https://git.kernel.org/netdev/net/c/918ee4911f7a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


