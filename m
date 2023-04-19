Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44C5F6E7967
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 14:10:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233139AbjDSMKX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 08:10:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232482AbjDSMKW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 08:10:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B88210FE
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 05:10:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 088126340A
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 12:10:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 59D89C4339B;
        Wed, 19 Apr 2023 12:10:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681906220;
        bh=TE5Wuk+D50mdxlxHF1taubsu79aksCziASxKzYhqbkw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=jMRIRwI7NftHT/IuwTR4ovjg52A54E3j5lSqvrgGZ8wp3UvjCGCmFeeWWZc+7RGlh
         A2YJl+AiPmKXRLFalm/tJuGuZvGaLWODqzu4KesQUmN629ThDEzPVlnRVb5kzppM55
         Wgk09+/I/PRa35Rv1sGotirZkEtC1iciU1BVVWduiHLOOvdKE7XkxGwkahw/N/Phbc
         ck2xKsFIS4yTFdT2P3vSzJWDcB4SWyK4+dPyH89D3sDolGrWtJLyE/LO8crDr5NvRl
         tm5rcJ3atYITnZ1tN2iqYX1F4f6HMGcd5bdj2oXpaVv76/c0B+FiLhSw3u8P1yeDjS
         bL+swn+teC+NA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 3EE31E270E5;
        Wed, 19 Apr 2023 12:10:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] mlxsw: pci: Fix possible crash during initialization
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168190622025.8890.5823614081879485303.git-patchwork-notify@kernel.org>
Date:   Wed, 19 Apr 2023 12:10:20 +0000
References: <303aa6102f0f9a8be9af749342d2afc82dd9dc53.1681749167.git.petrm@nvidia.com>
In-Reply-To: <303aa6102f0f9a8be9af749342d2afc82dd9dc53.1681749167.git.petrm@nvidia.com>
To:     Petr Machata <petrm@nvidia.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org, idosch@nvidia.com,
        amitc@mellanox.com, mlxsw@nvidia.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by David S. Miller <davem@davemloft.net>:

On Mon, 17 Apr 2023 18:52:51 +0200 you wrote:
> From: Ido Schimmel <idosch@nvidia.com>
> 
> During initialization the driver issues a reset command via its command
> interface in order to remove previous configuration from the device.
> 
> After issuing the reset, the driver waits for 200ms before polling on
> the "system_status" register using memory-mapped IO until the device
> reaches a ready state (0x5E). The wait is necessary because the reset
> command only triggers the reset, but the reset itself happens
> asynchronously. If the driver starts polling too soon, the read of the
> "system_status" register will never return and the system will crash
> [1].
> 
> [...]

Here is the summary with links:
  - [net] mlxsw: pci: Fix possible crash during initialization
    https://git.kernel.org/netdev/net/c/1f64757ee2bb

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


