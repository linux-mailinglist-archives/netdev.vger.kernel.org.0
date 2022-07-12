Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CDB2571510
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 10:50:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232493AbiGLIuU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 04:50:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229780AbiGLIuT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 04:50:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 907A6A6F2D
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 01:50:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4C88AB8179E
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 08:50:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id EEBC4C3411E;
        Tue, 12 Jul 2022 08:50:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657615816;
        bh=qKWAYrLPIIBrdJiyXOF37d7QRPIL4oXUp3BfYSu0Dn8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ZpxlvHoKzCpKhm90kKPBsV1YAsXhoirXO8tijwUlA84CyswvfQOgpJOf6Yl3FwxbY
         FHHU81Z3o+4rC8qym4J+y5ksNhvK5YWfCJwvYMwwGy/e5wZwFQvN6n88bIkXBoE9dP
         NSb5B7ee5zrrfjFisXECLFSE2a2Mowd5mVMdMECVMioGImJPxsF25N45e6CXP+SBmn
         rgjJgO3OkNMrHmDS93C04Msav1Gbo3tfvknBSqU5Zdkn5ZKMqnlqKP+hoZ1QbWs82y
         WnaCpC57DZ8FhfMvYn/6MfTiN5QDeNF0XmFup/YB60gPPMceJCilymubjY0PkpaRDW
         +yBSYZp/qAwmg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id CE4A1E45221;
        Tue, 12 Jul 2022 08:50:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/9] mlx5 devlink mutex removal part 1 
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165761581584.31192.16421025749968041368.git-patchwork-notify@kernel.org>
Date:   Tue, 12 Jul 2022 08:50:15 +0000
References: <20220711081408.69452-1-saeed@kernel.org>
In-Reply-To: <20220711081408.69452-1-saeed@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, saeedm@nvidia.com, netdev@vger.kernel.org
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Mon, 11 Jul 2022 01:13:59 -0700 you wrote:
> From: Saeed Mahameed <saeedm@nvidia.com>
> 
> Moshe Shemesh Says:
> ===================
> 1) Fix devlink lock in mlx5 devlink eswitch callbacks
> 
> Following the commit 14e426bf1a4d "devlink: hold the instance lock
> during eswitch_mode callbacks" which takes devlink instance lock for all
> devlink eswitch callbacks and adds a temporary workaround, this patchset
> removes the workaround, replaces devlink API functions by devl_ API
> where called from mlx5 driver eswitch callbacks flows and adds devlink
> instance lock in other driver's path that leads to these functions.
> While moving to devl_ API the patchset removes part of the devlink API
> functions which mlx5 was the last one to use and so not used by any
> driver now.
> 
> [...]

Here is the summary with links:
  - [net-next,1/9] net/mlx5: Remove devl_unlock from mlx5_eswtich_mode_callback_enter
    https://git.kernel.org/netdev/net-next/c/367dfa121205
  - [net-next,2/9] net/mlx5: Use devl_ API for rate nodes destroy
    https://git.kernel.org/netdev/net-next/c/03f9c47d0f79
  - [net-next,3/9] devlink: Remove unused function devlink_rate_nodes_destroy
    https://git.kernel.org/netdev/net-next/c/868232f5cd38
  - [net-next,4/9] net/mlx5: Use devl_ API in mlx5_esw_offloads_devlink_port_register
    https://git.kernel.org/netdev/net-next/c/f1bc646c9a06
  - [net-next,5/9] net/mlx5: Use devl_ API in mlx5_esw_devlink_sf_port_register
    https://git.kernel.org/netdev/net-next/c/da212bd29d7f
  - [net-next,6/9] devlink: Remove unused functions devlink_rate_leaf_create/destroy
    https://git.kernel.org/netdev/net-next/c/df539fc62b06
  - [net-next,7/9] net/mlx5: Use devl_ API in mlx5e_devlink_port_register
    https://git.kernel.org/netdev/net-next/c/7b19119f4c7d
  - [net-next,8/9] net/mlx5: Remove devl_unlock from mlx5_devlink_eswitch_mode_set
    https://git.kernel.org/netdev/net-next/c/973598d46ede
  - [net-next,9/9] devlink: Hold the instance lock in port_new / port_del callbacks
    https://git.kernel.org/netdev/net-next/c/f0680ef0f949

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


