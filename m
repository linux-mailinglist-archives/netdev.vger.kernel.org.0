Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E5605661DB
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 05:30:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234167AbiGEDaU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jul 2022 23:30:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229751AbiGEDaS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jul 2022 23:30:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4A9811825;
        Mon,  4 Jul 2022 20:30:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 78596B812AC;
        Tue,  5 Jul 2022 03:30:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 270ECC341C7;
        Tue,  5 Jul 2022 03:30:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656991815;
        bh=6MoM+5xxITJI3xj5bsd+AwoMc9XoWA7FRzNuF7sXlbE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=DQ70G2fEoD/TW9CqrecsOvSoj2mvwq52zO3nDZVU8JE5pyqoJOPtaMmaGdEf3NBv3
         2iyuPugmc/9HEY9ONASyvZoMol7bv9+7zC41rnKRPNtASdTyVk0cr3BXA+Bf4UlBoh
         1wpwY2uisNG9IDqXhCj4tGSv6nkS4MjF3hNQY9hoVR/199MmSIRwvSltC9a6IqxMJ+
         wupNjJ3viDja2kiVgTLpO5jU6I6EL12OEe1oIYoiJwWw+Mm+QH2CNlvTF/6RBi/IxF
         4ZPqxQGG0LktTvIAlsmnSb56PQYNFSiwBIQ9sr3gGW7tbjXtExebiWw9C/9SvfDJnC
         r6TSPquTPo1UQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 0A889E45BDB;
        Tue,  5 Jul 2022 03:30:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 01/15] can: bcm: use call_rcu() instead of costly
 synchronize_rcu()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165699181503.30643.11616466744896977167.git-patchwork-notify@kernel.org>
Date:   Tue, 05 Jul 2022 03:30:15 +0000
References: <20220704122613.1551119-2-mkl@pengutronix.de>
In-Reply-To: <20220704122613.1551119-2-mkl@pengutronix.de>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        linux-can@vger.kernel.org, kernel@pengutronix.de,
        socketcan@hartkopp.net, stable@vger.kernel.org,
        edumazet@google.com, nslusarek@gmx.net, cascardo@canonical.com
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

This series was applied to netdev/net.git (master)
by Marc Kleine-Budde <mkl@pengutronix.de>:

On Mon,  4 Jul 2022 14:25:59 +0200 you wrote:
> From: Oliver Hartkopp <socketcan@hartkopp.net>
> 
> In commit d5f9023fa61e ("can: bcm: delay release of struct bcm_op
> after synchronize_rcu()") Thadeu Lima de Souza Cascardo introduced two
> synchronize_rcu() calls in bcm_release() (only once at socket close)
> and in bcm_delete_rx_op() (called on removal of each single bcm_op).
> 
> [...]

Here is the summary with links:
  - [net,01/15] can: bcm: use call_rcu() instead of costly synchronize_rcu()
    https://git.kernel.org/netdev/net/c/f1b4e32aca08
  - [net,02/15] Revert "can: xilinx_can: Limit CANFD brp to 2"
    https://git.kernel.org/netdev/net/c/c6da4590fe81
  - [net,03/15] can: rcar_canfd: Fix data transmission failed on R-Car V3U
    https://git.kernel.org/netdev/net/c/374e11f1bde9
  - [net,04/15] can: gs_usb: gs_usb_open/close(): fix memory leak
    https://git.kernel.org/netdev/net/c/2bda24ef95c0
  - [net,05/15] can: grcan: grcan_probe(): remove extra of_node_get()
    https://git.kernel.org/netdev/net/c/562fed945ea4
  - [net,06/15] can: m_can: m_can_chip_config(): actually enable internal timestamping
    https://git.kernel.org/netdev/net/c/5b12933de4e7
  - [net,07/15] can: m_can: m_can_{read_fifo,echo_tx_event}(): shift timestamp to full 32 bits
    https://git.kernel.org/netdev/net/c/4c3333693f07
  - [net,08/15] can: kvaser_usb: replace run-time checks with struct kvaser_usb_driver_info
    https://git.kernel.org/netdev/net/c/49f274c72357
  - [net,09/15] can: kvaser_usb: kvaser_usb_leaf: fix CAN clock frequency regression
    https://git.kernel.org/netdev/net/c/e6c80e601053
  - [net,10/15] can: kvaser_usb: kvaser_usb_leaf: fix bittiming limits
    https://git.kernel.org/netdev/net/c/b3b6df2c56d8
  - [net,11/15] can: mcp251xfd: mcp251xfd_regmap_crc_read(): improve workaround handling for mcp2517fd
    https://git.kernel.org/netdev/net/c/406cc9cdb3e8
  - [net,12/15] can: mcp251xfd: mcp251xfd_regmap_crc_read(): update workaround broken CRC on TBC register
    https://git.kernel.org/netdev/net/c/e3d4ee7d5f7f
  - [net,13/15] can: mcp251xfd: mcp251xfd_stop(): add missing hrtimer_cancel()
    https://git.kernel.org/netdev/net/c/d5a972f561a0
  - [net,14/15] can: mcp251xfd: mcp251xfd_register_get_dev_id(): use correct length to read dev_id
    https://git.kernel.org/netdev/net/c/0ff32bfa0e79
  - [net,15/15] can: mcp251xfd: mcp251xfd_register_get_dev_id(): fix endianness conversion
    https://git.kernel.org/netdev/net/c/1c0e78a287e3

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


