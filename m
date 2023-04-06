Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 385916D8BE6
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 02:30:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234499AbjDFAaX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 20:30:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232832AbjDFAaV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 20:30:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5561A65B9;
        Wed,  5 Apr 2023 17:30:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B31A062838;
        Thu,  6 Apr 2023 00:30:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 06EE4C4339B;
        Thu,  6 Apr 2023 00:30:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680741019;
        bh=YltVwM566EynBdXKC++louwOvG8Ao22xLaga+QCbfG4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=hRlx8XdCIgYU+kagKwT+YFpNvENrkBKQVXKPncWm3JWJBRFdwzH+28rAqNKkkzvGA
         z4VGbZtyEDtnFuIIvYmBOeZn2UwBTXnjuXBzk18maVYK23DVCm1KXpkFxjsTmVxzk0
         FlXZQDlCNrMMWRr8vkRMRFfvfKamNTCZsZ7ZKzl7HM+IBYNtN5K5W7htejQwcCqcnR
         2nUSEADye0sLSiM+uOxRKbtez1J0NAHDhQqZeb1SIGAyie04sVPMPW/w99c7KULFyI
         +AvoCzQMHh4k6mAf37+jRgXp00IAFZjRPfUQGByNcnO0c+7CZOQDt54IxaIPBmdlZc
         O+29XyQ3BILlA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id DFE32C41671;
        Thu,  6 Apr 2023 00:30:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/4] can: j1939: j1939_tp_tx_dat_new(): fix out-of-bounds
 memory access
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168074101891.1850.786445177337726896.git-patchwork-notify@kernel.org>
Date:   Thu, 06 Apr 2023 00:30:18 +0000
References: <20230405092444.1802340-2-mkl@pengutronix.de>
In-Reply-To: <20230405092444.1802340-2-mkl@pengutronix.de>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        linux-can@vger.kernel.org, kernel@pengutronix.de,
        o.rempel@pengutronix.de, sjb7183@psu.edu, stable@vger.kernel.org
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (main)
by Marc Kleine-Budde <mkl@pengutronix.de>:

On Wed,  5 Apr 2023 11:24:41 +0200 you wrote:
> From: Oleksij Rempel <o.rempel@pengutronix.de>
> 
> In the j1939_tp_tx_dat_new() function, an out-of-bounds memory access
> could occur during the memcpy() operation if the size of skb->cb is
> larger than the size of struct j1939_sk_buff_cb. This is because the
> memcpy() operation uses the size of skb->cb, leading to a read beyond
> the struct j1939_sk_buff_cb.
> 
> [...]

Here is the summary with links:
  - [net,1/4] can: j1939: j1939_tp_tx_dat_new(): fix out-of-bounds memory access
    https://git.kernel.org/netdev/net/c/b45193cb4df5
  - [net,2/4] can: isotp: isotp_recvmsg(): use sock_recv_cmsgs() to get SOCK_RXQ_OVFL infos
    https://git.kernel.org/netdev/net/c/0145462fc802
  - [net,3/4] can: isotp: isotp_ops: fix poll() to not report false EPOLLOUT events
    https://git.kernel.org/netdev/net/c/79e19fa79cb5
  - [net,4/4] can: isotp: fix race between isotp_sendsmg() and isotp_release()
    https://git.kernel.org/netdev/net/c/051737439eae

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


