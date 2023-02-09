Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B683468FF93
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 06:00:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229579AbjBIFAY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 00:00:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbjBIFAX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 00:00:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81B5116AF1
        for <netdev@vger.kernel.org>; Wed,  8 Feb 2023 21:00:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 110FAB81FF2
        for <netdev@vger.kernel.org>; Thu,  9 Feb 2023 05:00:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7AE10C4339B;
        Thu,  9 Feb 2023 05:00:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675918819;
        bh=cKFeXNeqzdMkUYtAr4uZgeV3zux3Sl7pdl55suPqoI8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Gp1/DTEkq+EQIy/pl/CxdKScuo3mFVwwhXd0FUdGpKTXunhnh9kyKNi+XBYSkrQNP
         t5rKqGkBuHG+0TRAxqt2p6oXc/GnK9bwGjTT2+e7tJB6ZZLXPdnP+VbKs05ZtoBgnI
         Wpx1CZp1Ijqtfm7p1idHTZ/XOkbunGo+xzSCJUM9HT8cWBA5IUL5D6oFP4RVuswilj
         AwIxkCJ+/vZ6ajRjYIJFL8UMHLUO4ZehCchtOMZKb4MiEjFMv/I7P/c8RKM6fARWnx
         p+sFL/mOitmL3R7SsCT+04+qwDpdxMyURWMv3xx5RboNghehLA+pqyAenAWunNaOW3
         HC0zsDbysxthA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 5B7A7E49FB0;
        Thu,  9 Feb 2023 05:00:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net 01/10] net/mlx5e: Update rx ring hw mtu upon each rx-fcs flag
 change
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167591881937.30038.5955044803507018084.git-patchwork-notify@kernel.org>
Date:   Thu, 09 Feb 2023 05:00:19 +0000
References: <20230208030302.95378-2-saeed@kernel.org>
In-Reply-To: <20230208030302.95378-2-saeed@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, saeedm@nvidia.com, netdev@vger.kernel.org,
        tariqt@nvidia.com, afaris@nvidia.com
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
by Saeed Mahameed <saeedm@nvidia.com>:

On Tue,  7 Feb 2023 19:02:53 -0800 you wrote:
> From: Adham Faris <afaris@nvidia.com>
> 
> rq->hw_mtu is used in function en_rx.c/mlx5e_skb_from_cqe_mpwrq_linear()
> to catch oversized packets. If FCS is concatenated to the end of the
> packet then the check should be updated accordingly.
> 
> Rx rings initialization (mlx5e_init_rxq_rq()) invoked for every new set
> of channels, as part of mlx5e_safe_switch_params(), unknowingly if it
> runs with default configuration or not. Current rq->hw_mtu
> initialization assumes default configuration and ignores
> params->scatter_fcs_en flag state.
> Fix this, by accounting for params->scatter_fcs_en flag state during
> rq->hw_mtu initialization.
> 
> [...]

Here is the summary with links:
  - [net,01/10] net/mlx5e: Update rx ring hw mtu upon each rx-fcs flag change
    https://git.kernel.org/netdev/net/c/1e66220948df
  - [net,02/10] net/mlx5: DR, Fix potential race in dr_rule_create_rule_nic
    https://git.kernel.org/netdev/net/c/288d85e07fbc
  - [net,03/10] net/mlx5: Bridge, fix ageing of peer FDB entries
    https://git.kernel.org/netdev/net/c/da0c52426cd2
  - [net,04/10] net/mlx5e: Fix crash unsetting rx-vlan-filter in switchdev mode
    https://git.kernel.org/netdev/net/c/8974aa9638df
  - [net,05/10] net/mlx5e: IPoIB, Show unknown speed instead of error
    https://git.kernel.org/netdev/net/c/8aa5f171d51c
  - [net,06/10] net/mlx5: Store page counters in a single array
    https://git.kernel.org/netdev/net/c/c3bdbaea654d
  - [net,07/10] net/mlx5: Expose SF firmware pages counter
    https://git.kernel.org/netdev/net/c/9965bbebae59
  - [net,08/10] net/mlx5: fw_tracer, Clear load bit when freeing string DBs buffers
    https://git.kernel.org/netdev/net/c/db561fed6b8f
  - [net,09/10] net/mlx5: fw_tracer, Zero consumer index when reloading the tracer
    https://git.kernel.org/netdev/net/c/184e1e4474db
  - [net,10/10] net/mlx5: Serialize module cleanup with reload and remove
    https://git.kernel.org/netdev/net/c/8f0d1451ecf7

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


