Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D8CA5EE3C1
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 20:00:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233790AbiI1SAa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 14:00:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234000AbiI1SAX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 14:00:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDEA1785B7;
        Wed, 28 Sep 2022 11:00:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 35771B821B6;
        Wed, 28 Sep 2022 18:00:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id EC4C1C433D6;
        Wed, 28 Sep 2022 18:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664388016;
        bh=x5vCGLUgiKM9GgDpJcD1e9Nm0haZqVbgAKbjfFedsak=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=b0pq3zcSTnPA47ezhG78x+OqOr2jGwsjkjRSlTNhdxivblf900VJkDSjEiRCXorKi
         v75YcF2flfHvAlzN1TaPZ+zUE4L8FfciLuayO8di9ocbx/oYyHiVKYjP72x6w2PXEI
         RejK1D4+G2VRBukuujtDHvkzvF6gcnuMOWi3xC/pjmRFEkKGgwTZ9lc5SRNM/MzRk1
         cLcq8OmacO7TQnL+4EO1+7kQsp9dZ93tf+QeexYiDFjvbDpT4BDRZJTbIvGaQfha7Y
         u6sjrDknmdk3akCW0Qby3zGHI2kt+lVlSPFBtNp0fNEj4TG7ZPTqinxQxq+X9IXYtj
         GMW5YpnXUwySg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D2673E21EC5;
        Wed, 28 Sep 2022 18:00:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] can: c_can: don't cache TX messages for C_CAN cores
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166438801585.1002.4512212910588751772.git-patchwork-notify@kernel.org>
Date:   Wed, 28 Sep 2022 18:00:15 +0000
References: <20220928090629.1124190-2-mkl@pengutronix.de>
In-Reply-To: <20220928090629.1124190-2-mkl@pengutronix.de>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        linux-can@vger.kernel.org, kernel@pengutronix.de,
        jacob.kroon@gmail.com, stable@vger.kernel.org
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Marc Kleine-Budde <mkl@pengutronix.de>:

On Wed, 28 Sep 2022 11:06:29 +0200 you wrote:
> As Jacob noticed, the optimization introduced in 387da6bc7a82 ("can:
> c_can: cache frames to operate as a true FIFO") doesn't properly work
> on C_CAN, but on D_CAN IP cores. The exact reasons are still unknown.
> 
> For now disable caching if CAN frames in the TX path for C_CAN cores.
> 
> Fixes: 387da6bc7a82 ("can: c_can: cache frames to operate as a true FIFO")
> Link: https://lore.kernel.org/all/20220928083354.1062321-1-mkl@pengutronix.de
> Link: https://lore.kernel.org/all/15a8084b-9617-2da1-6704-d7e39d60643b@gmail.com
> Reported-by: Jacob Kroon <jacob.kroon@gmail.com>
> Tested-by: Jacob Kroon <jacob.kroon@gmail.com>
> Cc: stable@vger.kernel.org # v5.15
> Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
> 
> [...]

Here is the summary with links:
  - [net] can: c_can: don't cache TX messages for C_CAN cores
    https://git.kernel.org/netdev/net/c/81d192c2ce74

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


