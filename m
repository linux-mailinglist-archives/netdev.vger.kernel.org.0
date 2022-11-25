Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E86E6384E2
	for <lists+netdev@lfdr.de>; Fri, 25 Nov 2022 09:00:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229805AbiKYIAV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Nov 2022 03:00:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229810AbiKYIAU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Nov 2022 03:00:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DDFC2FFF4;
        Fri, 25 Nov 2022 00:00:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 08959622D7;
        Fri, 25 Nov 2022 08:00:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 61E4CC433B5;
        Fri, 25 Nov 2022 08:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669363217;
        bh=ruBqTWcWxHPaHlIDNK66y1xdcEMgPYn9mLhg1dwyEKM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Q+MYzveXuflfbpKh8a5IopVyfg783+H0dsZOXDZ4HFHsTJ4CfUATpaGBja5H8lfTQ
         eA6fkQmDIVic2efTQN3C6MLpVQLL/RS4LdMgr6e/0qlzYcPQlHfyYa+IrdAtSuCUVM
         ITO0zSAtTmv3Z1gMLsaKW+6b+tMOs/UB+zRW5zGu/eVupTKslbFQLpfkZGUA26HGCV
         HnK8T8IvMXN0LtzHrmxnu204QTJYDCpvTzjcAX7ShB9tlZ5WP0bfOSbr4zel3YzTgm
         X2QlNUyNav15xwQCXxLjAQh+0UoXr/NzbaA9Y9ujN5ien34sT7ZWMEN6DfyhRFGUUH
         X5kBEZ7ai4oTg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 4D438E29F3C;
        Fri, 25 Nov 2022 08:00:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/8] can: can327: can327_feed_frame_to_netdev(): fix
 potential skb leak when netdev is down
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166936321731.29613.6776566910480934923.git-patchwork-notify@kernel.org>
Date:   Fri, 25 Nov 2022 08:00:17 +0000
References: <20221124195708.1473369-2-mkl@pengutronix.de>
In-Reply-To: <20221124195708.1473369-2-mkl@pengutronix.de>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        linux-can@vger.kernel.org, kernel@pengutronix.de,
        william.xuanziyang@huawei.com, max@enpas.org,
        stable@vger.kernel.org
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

On Thu, 24 Nov 2022 20:57:01 +0100 you wrote:
> From: Ziyang Xuan <william.xuanziyang@huawei.com>
> 
> In can327_feed_frame_to_netdev(), it did not free the skb when netdev
> is down, and all callers of can327_feed_frame_to_netdev() did not free
> allocated skb too. That would trigger skb leak.
> 
> Fix it by adding kfree_skb() in can327_feed_frame_to_netdev() when netdev
> is down. Not tested, just compiled.
> 
> [...]

Here is the summary with links:
  - [net,1/8] can: can327: can327_feed_frame_to_netdev(): fix potential skb leak when netdev is down
    https://git.kernel.org/netdev/net/c/8fa452cfafed
  - [net,2/8] can: sja1000: fix size of OCR_MODE_MASK define
    https://git.kernel.org/netdev/net/c/26e8f6a75248
  - [net,3/8] can: sja1000_isa: sja1000_isa_probe(): add missing free_sja1000dev()
    https://git.kernel.org/netdev/net/c/92dfd9310a71
  - [net,4/8] can: cc770: cc770_isa_probe(): add missing free_cc770dev()
    https://git.kernel.org/netdev/net/c/62ec89e74099
  - [net,5/8] can: etas_es58x: es58x_init_netdev(): free netdev when register_candev()
    https://git.kernel.org/netdev/net/c/709cb2f9ed20
  - [net,6/8] can: m_can: pci: add missing m_can_class_free_dev() in probe/remove methods
    https://git.kernel.org/netdev/net/c/1eca1d4cc21b
  - [net,7/8] can: m_can: Add check for devm_clk_get
    https://git.kernel.org/netdev/net/c/68b4f9e0bdd0
  - [net,8/8] can: mcba_usb: Fix termination command argument
    https://git.kernel.org/netdev/net/c/1a8e3bd25f1e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


