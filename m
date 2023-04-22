Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D45596EB737
	for <lists+netdev@lfdr.de>; Sat, 22 Apr 2023 05:50:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229575AbjDVDu0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 23:50:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbjDVDuX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 23:50:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0565C1BC8
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 20:50:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8834663BC3
        for <netdev@vger.kernel.org>; Sat, 22 Apr 2023 03:50:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D0332C433D2;
        Sat, 22 Apr 2023 03:50:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682135420;
        bh=i5/aNX1fGaNUmbXK9aYtIIExZs1A/uPT3A8ubvKI9RU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=slewg67JjgU88qYXBrmX0YvPbMZLjiIBL5SUJSZirjfCDkBtwvL2aIEpdG0PcdeRH
         JmqNVEny4t+4Y+aRj5KQXchxkwWSJSzt54kBwq0HU0Xo9ACKyAzlflWQn3MCHltWWa
         +skmjQ69co55hueQKDS52bA8mxNL1Y4g3bQqMfD67Z2bAuHD3I/qPOANO7f5Byiyq/
         cJ6cNUhLOOMvyb+B+x4XtnZ36BcAAxSMhtb8GGY2h2W3i4a43RrY2KH5vJebsZww67
         Y2lmAJgXb43GEmX9QHjFupbqTZsShwz0mAIuRk23k9b1oZa5WPUil4MT49fZSknpb8
         02khc0q7MHcUg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B4087E270DA;
        Sat, 22 Apr 2023 03:50:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net V2 01/10] net/mlx5e: Don't clone flow post action attributes
 second time
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168213542073.31717.3866727182906999762.git-patchwork-notify@kernel.org>
Date:   Sat, 22 Apr 2023 03:50:20 +0000
References: <20230421015057.355468-2-saeed@kernel.org>
In-Reply-To: <20230421015057.355468-2-saeed@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, saeedm@nvidia.com, netdev@vger.kernel.org,
        tariqt@nvidia.com, vladbu@nvidia.com, roid@nvidia.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (main)
by Saeed Mahameed <saeedm@nvidia.com>:

On Thu, 20 Apr 2023 18:50:48 -0700 you wrote:
> From: Vlad Buslov <vladbu@nvidia.com>
> 
> The code already clones post action attributes in
> mlx5e_clone_flow_attr_for_post_act(). Creating another copy in
> mlx5e_tc_post_act_add() is a erroneous leftover from original
> implementation. Instead, assign handle->attribute to post_attr provided by
> the caller. Note that cloning the attribute second time is not just
> wasteful but also causes issues like second copy not being properly updated
> in neigh update code which leads to following use-after-free:
> 
> [...]

Here is the summary with links:
  - [net,V2,01/10] net/mlx5e: Don't clone flow post action attributes second time
    https://git.kernel.org/netdev/net/c/e9fce818fe00
  - [net,V2,02/10] net/mlx5e: Release the label when replacing existing ct entry
    https://git.kernel.org/netdev/net/c/8ac04a28144c
  - [net,V2,03/10] net/mlx5: E-switch, Create per vport table based on devlink encap mode
    https://git.kernel.org/netdev/net/c/fd745f4c0abe
  - [net,V2,04/10] net/mlx5: E-switch, Don't destroy indirect table in split rule
    https://git.kernel.org/netdev/net/c/4c8189302567
  - [net,V2,05/10] net/mlx5: Release tunnel device after tc update skb
    https://git.kernel.org/netdev/net/c/4fbef0f8ea63
  - [net,V2,06/10] net/mlx5e: Fix error flow in representor failing to add vport rx rule
    https://git.kernel.org/netdev/net/c/0a6b069cc60d
  - [net,V2,07/10] Revert "net/mlx5: Remove "recovery" arg from mlx5_load_one() function"
    https://git.kernel.org/netdev/net/c/21608a2cf38e
  - [net,V2,08/10] net/mlx5: Use recovery timeout on sync reset flow
    https://git.kernel.org/netdev/net/c/dfad99750c0f
  - [net,V2,09/10] net/mlx5e: Nullify table pointer when failing to create
    https://git.kernel.org/netdev/net/c/1b540decd03a
  - [net,V2,10/10] Revert "net/mlx5e: Don't use termination table when redundant"
    https://git.kernel.org/netdev/net/c/081abcacaf0a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


