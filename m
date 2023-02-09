Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D95268FDDA
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 04:21:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231710AbjBIDVF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 22:21:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232678AbjBIDU4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 22:20:56 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12C6DFF2F
        for <netdev@vger.kernel.org>; Wed,  8 Feb 2023 19:20:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B3DABB81F26
        for <netdev@vger.kernel.org>; Thu,  9 Feb 2023 03:20:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 651CFC4339C;
        Thu,  9 Feb 2023 03:20:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675912819;
        bh=8MYUfwckiUXuoIsEuABzjjjRsr5XmtCakYLz4RzFEwE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=aLYBb38brYOy+JwOM9p4u5wNliybQgGjKG+tjWuVQyWab7QyRhMtFCemiJYHinwcZ
         ztl/5PRIHX3ulZJLHsU89MU+6pPeJx1DRdJuK6ZbhzNPjf0/ZzLT/w3mWnSlxScliu
         yi9GKEYdgJfYkPPQN5HBaFGy2DlNQQhs640hwaUVEqJO8OV5NVQlvcUrvvcaoH/ukO
         OhO4ckFbxA2yjKhoZqTlXT3XKQuACb8TFGUVd1W+f1V2PfTRZ8EaDgoebI2Ny0Mwgg
         Zr4Ans5y9RtvQhkZxX4TeYMSp2NOQEBsH5BbAE428mq5gPEaK24Fr+KzZ/tMTWp8f0
         JOPcXJBZiiGcw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 499A6E55F07;
        Thu,  9 Feb 2023 03:20:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next 01/15] mlx5: reduce stack usage in mlx5_setup_tc
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167591281929.25667.2549143959724347508.git-patchwork-notify@kernel.org>
Date:   Thu, 09 Feb 2023 03:20:19 +0000
References: <20230208003712.68386-2-saeed@kernel.org>
In-Reply-To: <20230208003712.68386-2-saeed@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, saeedm@nvidia.com, netdev@vger.kernel.org,
        tariqt@nvidia.com, arnd@arndb.de, jacob.e.keller@intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Saeed Mahameed <saeedm@nvidia.com>:

On Tue,  7 Feb 2023 16:36:58 -0800 you wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> Clang warns about excessive stack usage on 32-bit targets:
> 
> drivers/net/ethernet/mellanox/mlx5/core/en_main.c:3597:12: error: stack frame size (1184) exceeds limit (1024) in 'mlx5e_setup_tc' [-Werror,-Wframe-larger-than]
> static int mlx5e_setup_tc(struct net_device *dev, enum tc_setup_type type,
> 
> [...]

Here is the summary with links:
  - [net-next,01/15] mlx5: reduce stack usage in mlx5_setup_tc
    https://git.kernel.org/netdev/net-next/c/7802886274cc
  - [net-next,02/15] net/mlx5: Remove redundant health work lock
    https://git.kernel.org/netdev/net-next/c/67257cba905d
  - [net-next,03/15] net/mlx5: fw reset: Skip device ID check if PCI link up failed
    https://git.kernel.org/netdev/net-next/c/114b295470e7
  - [net-next,04/15] net/mlx5e: Don't listen to remove flows event
    https://git.kernel.org/netdev/net-next/c/a2a73ea14b1a
  - [net-next,05/15] net/mlx5e: Remove redundant code for handling vlan actions
    https://git.kernel.org/netdev/net-next/c/633ad4b29c21
  - [net-next,06/15] net/mlx5: fs, Remove redundant vport_number assignment
    https://git.kernel.org/netdev/net-next/c/2e762e65998e
  - [net-next,07/15] net/mlx5e: Remove incorrect debugfs_create_dir NULL check in hairpin
    https://git.kernel.org/netdev/net-next/c/afae6254c5ea
  - [net-next,08/15] net/mlx5e: Remove incorrect debugfs_create_dir NULL check in TLS
    https://git.kernel.org/netdev/net-next/c/1e985a8d887c
  - [net-next,09/15] net/mlx5: Fix memory leak in error flow of port set buffer
    https://git.kernel.org/netdev/net-next/c/e3e01c1c1598
  - [net-next,10/15] net/mlx5: fs_core, Remove redundant variable err
    https://git.kernel.org/netdev/net-next/c/08929f32da0f
  - [net-next,11/15] net/mlx5: fs, Remove redundant assignment of size
    https://git.kernel.org/netdev/net-next/c/beeebdc52caf
  - [net-next,12/15] net/mlx5: fw_tracer: Fix debug print
    https://git.kernel.org/netdev/net-next/c/988c23522739
  - [net-next,13/15] net/mlx5: fw_tracer, allow 0 size string DBs
    https://git.kernel.org/netdev/net-next/c/b0118ced6b2e
  - [net-next,14/15] net/mlx5: fw_tracer, Add support for strings DB update event
    https://git.kernel.org/netdev/net-next/c/7dfcd110a458
  - [net-next,15/15] net/mlx5: fw_tracer, Add support for unrecognized string
    https://git.kernel.org/netdev/net-next/c/f7133135235d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


