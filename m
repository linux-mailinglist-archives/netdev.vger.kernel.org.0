Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C2CE610012
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 20:20:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235256AbiJ0SUY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 14:20:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229565AbiJ0SUX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 14:20:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E95BF2CE05
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 11:20:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8583A62440
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 18:20:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D62DBC43470;
        Thu, 27 Oct 2022 18:20:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666894820;
        bh=XLyS+vOHpZCYjBimGnwRLuNYarqTnlzkGUhTBduxt38=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=cO9qWEUhVkVIB4QpJNJOr4IdNYIYNOjRdmQKiFNdFiSiL6YVUHk0fKcCYmGU7ytcu
         twu51bAzuXQrow1xHgLseFIhEKWrTwRfneNDnB+AmeZCrIdDWRA/vWMm74Zr4mfBo7
         djLf+qAeVV3wHU76axG6UyF0demfeuGx14QOiiKpP8RbFVS2tB5nlxAC3tznNtWv4S
         PnT4x/nsHkkUldeGfyUT+eoMqJ1tCbZROBIr6pF4eag4WVksRaNo6EJepl9iWS2zNH
         3bNEHVzTjrprSGJK4Q18Qe3ToGOKje98w3ppns2dXLedy4XVhFqN3serbuS7p7Kj8v
         V+Xg46BL0h0Og==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id BA962E270D9;
        Thu, 27 Oct 2022 18:20:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [V4 net 01/15] net/mlx5e: Do not increment ESN when updating IPsec
 ESN state
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166689482076.378.7374777770971119455.git-patchwork-notify@kernel.org>
Date:   Thu, 27 Oct 2022 18:20:20 +0000
References: <20221026135153.154807-2-saeed@kernel.org>
In-Reply-To: <20221026135153.154807-2-saeed@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, saeedm@nvidia.com, netdev@vger.kernel.org,
        tariqt@nvidia.com, hyonkim@cisco.com, leonro@nvidia.com
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 26 Oct 2022 14:51:39 +0100 you wrote:
> From: Hyong Youb Kim <hyonkim@cisco.com>
> 
> An offloaded SA stops receiving after about 2^32 + replay_window
> packets. For example, when SA reaches <seq-hi 0x1, seq 0x2c>, all
> subsequent packets get dropped with SA-icv-failure (integrity_failed).
> 
> To reproduce the bug:
> - ConnectX-6 Dx with crypto enabled (FW 22.30.1004)
> - ipsec.conf:
>   nic-offload = yes
>   replay-window = 32
>   esn = yes
>   salifetime=24h
> - Run netperf for a long time to send more than 2^32 packets
>   netperf -H <device-under-test> -t TCP_STREAM -l 20000
> 
> [...]

Here is the summary with links:
  - [V4,net,01/15] net/mlx5e: Do not increment ESN when updating IPsec ESN state
    https://git.kernel.org/netdev/net/c/888be6b279b7
  - [V4,net,02/15] net/mlx5: Wait for firmware to enable CRS before pci_restore_state
    https://git.kernel.org/netdev/net/c/212b4d7251c1
  - [V4,net,03/15] net/mlx5: DR, Fix matcher disconnect error flow
    https://git.kernel.org/netdev/net/c/4ea9891d6641
  - [V4,net,04/15] net/mlx5e: Extend SKB room check to include PTP-SQ
    https://git.kernel.org/netdev/net/c/19b43a432e3e
  - [V4,net,05/15] net/mlx5e: Update restore chain id for slow path packets
    https://git.kernel.org/netdev/net/c/8dc47c0527c1
  - [V4,net,06/15] net/mlx5: ASO, Create the ASO SQ with the correct timestamp format
    https://git.kernel.org/netdev/net/c/0f3caaa2c6fb
  - [V4,net,07/15] net/mlx5: Fix possible use-after-free in async command interface
    https://git.kernel.org/netdev/net/c/bacd22df9514
  - [V4,net,08/15] net/mlx5e: TC, Reject forwarding from internal port to internal port
    https://git.kernel.org/netdev/net/c/f382a2413dae
  - [V4,net,09/15] net/mlx5e: TC, Fix cloned flow attr instance dests are not zeroed
    https://git.kernel.org/netdev/net/c/94d651739e17
  - [V4,net,10/15] net/mlx5: Update fw fatal reporter state on PCI handlers successful recover
    https://git.kernel.org/netdev/net/c/416ef7136319
  - [V4,net,11/15] net/mlx5: Fix crash during sync firmware reset
    https://git.kernel.org/netdev/net/c/aefb62a99887
  - [V4,net,12/15] net/mlx5e: Fix macsec coverity issue at rx sa update
    https://git.kernel.org/netdev/net/c/d3ecf037569c
  - [V4,net,13/15] net/mlx5e: Fix macsec rx security association (SA) update/delete
    https://git.kernel.org/netdev/net/c/74573e38e933
  - [V4,net,14/15] net/mlx5e: Fix wrong bitwise comparison usage in macsec_fs_rx_add_rule function
    https://git.kernel.org/netdev/net/c/d550956458a8
  - [V4,net,15/15] net/mlx5e: Fix macsec sci endianness at rx sa update
    https://git.kernel.org/netdev/net/c/12ba40ba3dc3

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


