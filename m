Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 016A7624F05
	for <lists+netdev@lfdr.de>; Fri, 11 Nov 2022 01:40:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230173AbiKKAkU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 19:40:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229558AbiKKAkT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 19:40:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9903F101E4
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 16:40:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 33D1561E59
        for <netdev@vger.kernel.org>; Fri, 11 Nov 2022 00:40:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7E3B5C433D7;
        Fri, 11 Nov 2022 00:40:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668127217;
        bh=Nx446gufwZWp+TWBP9SsV8I/OGJXxDx75jxksFU0F+E=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=GOMZ+2lOiXrRVSPLZsnqIO88wCaAZRLl+VRAqzzzLCQd5yQJ6KPwMbIRf010abpBZ
         jM2w0WEw7IvxYOh9IlnepnB/IjkLkDWSTyF9amVVHTMbVRXMS67ou8FhzBEWnrlSs5
         GqQaXfFtAEXZjMf9U7DtDi9iCyO0zLbIP2x1CuKMkSDrB1P7XILZO3dsMJpdg3lfeK
         PbbozKlZLzZLrAFKLmuF4yCnOA9kMfmcTti1LxinqBIdobXYb2d/qvmgPUIRjpG5ME
         mEDg6Fm+qOJ5csOC2G7sO6Mtk3/avoU90YbRWT81PoCaXQhG6dB1ses2ETcPS5q+Rf
         nkwW55lrxgqKA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 5B95DE270EF;
        Fri, 11 Nov 2022 00:40:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [V3 net 01/10] net/mlx5: Bridge,
 verify LAG state when adding bond to bridge
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166812721737.19097.9172609428528296162.git-patchwork-notify@kernel.org>
Date:   Fri, 11 Nov 2022 00:40:17 +0000
References: <20221109184050.108379-2-saeed@kernel.org>
In-Reply-To: <20221109184050.108379-2-saeed@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, saeedm@nvidia.com, netdev@vger.kernel.org,
        tariqt@nvidia.com, vladbu@nvidia.com, roid@nvidia.com,
        mbloch@nvidia.com
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

On Wed,  9 Nov 2022 10:40:41 -0800 you wrote:
> From: Vlad Buslov <vladbu@nvidia.com>
> 
> Mlx5 LAG is initialized asynchronously on a workqueue which means that for
> a brief moment after setting mlx5 UL representors as lower devices of a
> bond netdevice the LAG itself is not fully initialized in the driver. When
> adding such bond device to a bridge mlx5 bridge code will not consider it
> as offload-capable, skip creating necessary bookkeeping and fail any
> further bridge offload-related commands with it (setting VLANs, offloading
> FDBs, etc.). In order to make the error explicit during bridge
> initialization stage implement the code that detects such condition during
> NETDEV_PRECHANGEUPPER event and returns an error.
> 
> [...]

Here is the summary with links:
  - [V3,net,01/10] net/mlx5: Bridge, verify LAG state when adding bond to bridge
    https://git.kernel.org/netdev/net/c/15f8f168952f
  - [V3,net,02/10] net/mlx5: Allow async trigger completion execution on single CPU systems
    https://git.kernel.org/netdev/net/c/2808b37b5928
  - [V3,net,03/10] net/mlx5: E-switch, Set to legacy mode if failed to change switchdev mode
    https://git.kernel.org/netdev/net/c/e12de39c07a7
  - [V3,net,04/10] net/mlx5: fw_reset: Don't try to load device in case PCI isn't working
    https://git.kernel.org/netdev/net/c/7d167b4a4c81
  - [V3,net,05/10] net/mlx5e: Add missing sanity checks for max TX WQE size
    https://git.kernel.org/netdev/net/c/f9c955b4fe5c
  - [V3,net,06/10] net/mlx5e: Fix usage of DMA sync API
    https://git.kernel.org/netdev/net/c/8d4b475e9d0f
  - [V3,net,07/10] net/mlx5e: Fix tc acts array not to be dependent on enum order
    https://git.kernel.org/netdev/net/c/08912ea799cd
  - [V3,net,08/10] net/mlx5e: TC, Fix wrong rejection of packet-per-second policing
    https://git.kernel.org/netdev/net/c/9e0643084136
  - [V3,net,09/10] net/mlx5e: E-Switch, Fix comparing termination table instance
    https://git.kernel.org/netdev/net/c/f4f4096b410e
  - [V3,net,10/10] net/mlx5e: TC, Fix slab-out-of-bounds in parse_tc_actions
    https://git.kernel.org/netdev/net/c/7f1a6d4b9e82

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


