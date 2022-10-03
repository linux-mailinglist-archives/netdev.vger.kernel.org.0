Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AD2B5F2FD5
	for <lists+netdev@lfdr.de>; Mon,  3 Oct 2022 13:50:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229810AbiJCLuW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Oct 2022 07:50:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229690AbiJCLuT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Oct 2022 07:50:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3C293057C;
        Mon,  3 Oct 2022 04:50:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5038BB81092;
        Mon,  3 Oct 2022 11:50:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0B894C43470;
        Mon,  3 Oct 2022 11:50:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664797815;
        bh=vVimnp4wVXRu2RYMM8Bka2hvV81/4nCHp6+HBBhBgLM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=j0gXbmZOcqXbIU7h3x1NeJeBYgxZ0GHHufhCjmh9DZ1bwhqWJI5+Sb1Ru48O/gBIY
         Z0eDjFrdDnHAvRN3GBuAGMieErcDdP/tyb+FODrVtNlyQa3ckebIMKxchMc9Lg9Joz
         iHrHFGSAA/g3jTQ+nILE/ttgbU4Mt7TpKYmveELVCTukfkBMW+Gu8ByML4nh//rhff
         sfNFUS7LkI6pRpH+lRqcOp5Bpni+KL9sr9L/a0FVKLvKINOgAackwLcHLpVC0mWIoE
         eGNLCUDbYA/F0y/r3r8d9RVeZW1qdavs9mC1l365pCVdUXuU34VjCaqgRVdqmEbF54
         ftNIob+zukrWA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E16B9E52505;
        Mon,  3 Oct 2022 11:50:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] bnx2x: fix potential memory leak in bnx2x_tpa_stop()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166479781491.26331.11983869215638641295.git-patchwork-notify@kernel.org>
Date:   Mon, 03 Oct 2022 11:50:14 +0000
References: <20220930062843.5654-1-niejianglei2021@163.com>
In-Reply-To: <20220930062843.5654-1-niejianglei2021@163.com>
To:     Jianglei Nie <niejianglei2021@163.com>
Cc:     aelior@marvell.com, skalluru@marvell.com, manishc@marvell.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 30 Sep 2022 14:28:43 +0800 you wrote:
> bnx2x_tpa_stop() allocates a memory chunk from new_data with
> bnx2x_frag_alloc(). The new_data should be freed when gets some error.
> But when "pad + len > fp->rx_buf_size" is true, bnx2x_tpa_stop() returns
> without releasing the new_data, which will lead to a memory leak.
> 
> We should free the new_data with bnx2x_frag_free() when "pad + len >
> fp->rx_buf_size" is true.
> 
> [...]

Here is the summary with links:
  - bnx2x: fix potential memory leak in bnx2x_tpa_stop()
    https://git.kernel.org/netdev/net/c/b43f9acbb894

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


