Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90AE05BFFBE
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 16:20:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229666AbiIUOUV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 10:20:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229694AbiIUOUT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 10:20:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FB736B163;
        Wed, 21 Sep 2022 07:20:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0133262C12;
        Wed, 21 Sep 2022 14:20:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5601FC433C1;
        Wed, 21 Sep 2022 14:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663770017;
        bh=b32hqK1FbsE1UFqLjjsrZaAYgRoyw69u1rQqZakozO0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=krK3hQeS/4thM7oS3HHzqHpuPpH3+X4/Hy1hAxFEKdGeivycaocA1Cf1IJwYhC5M+
         s0CFwPjEGLNSDGpfpX0ElBV0xRcq/mpRRHR5UEXQ7GPihg4CxZqh1uliKl+HZVZT4k
         jBmvMrYoxy2zrNdj69KVi029o1VltaTTGlxciRW7eyv26U05LCUylUVZVHwh3P81KA
         7WUuL5MN0KdO17rCfYNVdla4GTSoS/93UgvqKKWeFwH6llB49n6DC/SMAtjKRJ2dYV
         lNWCrmem7MHVkZFajlkQkVTdyg4whcKypD3eW00zwE7nShC2IX3o3synCbqBi5kVWf
         i4QGj7k3t5wwQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 39922E21ECF;
        Wed, 21 Sep 2022 14:20:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/3] can: flexcan: flexcan_mailbox_read() fix return value
 for drop = true
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166377001723.1981.13753994801087834439.git-patchwork-notify@kernel.org>
Date:   Wed, 21 Sep 2022 14:20:17 +0000
References: <20220921083609.419768-2-mkl@pengutronix.de>
In-Reply-To: <20220921083609.419768-2-mkl@pengutronix.de>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        linux-can@vger.kernel.org, kernel@pengutronix.de,
        stable@vger.kernel.org, u.kleine-koenig@pengutronix.de,
        t.scherer@eckelmann.de
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

On Wed, 21 Sep 2022 10:36:07 +0200 you wrote:
> The following happened on an i.MX25 using flexcan with many packets on
> the bus:
> 
> The rx-offload queue reached a length more than skb_queue_len_max. In
> can_rx_offload_offload_one() the drop variable was set to true which
> made the call to .mailbox_read() (here: flexcan_mailbox_read()) to
> _always_ return ERR_PTR(-ENOBUFS) and drop the rx'ed CAN frame. So
> can_rx_offload_offload_one() returned ERR_PTR(-ENOBUFS), too.
> 
> [...]

Here is the summary with links:
  - [net,1/3] can: flexcan: flexcan_mailbox_read() fix return value for drop = true
    https://git.kernel.org/netdev/net/c/a09721dd47c8
  - [net,2/3] can: gs_usb: gs_can_open(): fix race dev->can.state condition
    https://git.kernel.org/netdev/net/c/5440428b3da6
  - [net,3/3] can: gs_usb: gs_usb_set_phys_id(): return with error if identify is not supported
    https://git.kernel.org/netdev/net/c/0f2211f1cf58

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


