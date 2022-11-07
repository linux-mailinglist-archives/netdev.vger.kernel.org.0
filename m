Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F13161EF43
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 10:40:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231607AbiKGJkb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 04:40:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231487AbiKGJkR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 04:40:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBE25BCB6
        for <netdev@vger.kernel.org>; Mon,  7 Nov 2022 01:40:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 893D260FA5
        for <netdev@vger.kernel.org>; Mon,  7 Nov 2022 09:40:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E6CEAC4314B;
        Mon,  7 Nov 2022 09:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667814015;
        bh=czT+AnDfLW5M+kUfr4ICtFVOsSGUgwgY9Q8QammmOyI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=g7ukVbla4H4o9qo0gClmKeputTDjlPhacuw5mwfBPjIZicAYCvt/0bbRBBIlYhkn7
         rHDY9Mfv/G1YrjTqtocAcvTbdcy5AqvGkqAEtIwl7cnaycBa1wD0PZJesdKPEq2Fpo
         YYfIaOMcdNTCh4tnYnH+FQgTTyjTqDua9Uq5BnB1qXdWbUjy2ui7Xd9FNIKJw8zkoX
         NqCCzWO28UOXQbUBoz3qbC8QYOXHCKPiHOZtMWEu65n7i9qZNK5QmS//tJ0T1ZarrO
         F6tuh6/r4yvo09fRtq2Tygx/kotgC2xd6aPddm1BHqMtDY8bp37ytkply1S86WtQxh
         Ib4YqoCAei2WA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D1156C73FFC;
        Mon,  7 Nov 2022 09:40:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v3 1/2] net: wwan: t7xx: Use needed_headroom instead
 of hard_header_len
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166781401585.17779.13219230975466028783.git-patchwork-notify@kernel.org>
Date:   Mon, 07 Nov 2022 09:40:15 +0000
References: <20221103091829.28432-1-sreehari.kancharla@linux.intel.com>
In-Reply-To: <20221103091829.28432-1-sreehari.kancharla@linux.intel.com>
To:     Sreehari Kancharla <sreehari.kancharla@linux.intel.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        johannes@sipsolutions.net, ryazanov.s.a@gmail.com,
        loic.poulain@linaro.org, m.chetan.kumar@intel.com,
        chandrashekar.devegowda@intel.com, linuxwwan@intel.com,
        chiranjeevi.rapolu@linux.intel.com, haijun.liu@mediatek.com,
        ricardo.martinez@linux.intel.com,
        andriy.shevchenko@linux.intel.com, dinesh.sharma@intel.com,
        ilpo.jarvinen@linux.intel.com, moises.veleta@intel.com,
        sreehari.kancharla@intel.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu,  3 Nov 2022 14:48:28 +0530 you wrote:
> From: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
> 
> hard_header_len is used by gro_list_prepare() but on Rx, there
> is no header so use needed_headroom instead.
> 
> Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
> Signed-off-by: Sreehari Kancharla <sreehari.kancharla@linux.intel.com>
> Reviewed-by: Sergey Ryazanov <ryazanov.s.a@gmail.com>
> --
> v2, v3:
>  * No change.
> 
> [...]

Here is the summary with links:
  - [net-next,v3,1/2] net: wwan: t7xx: Use needed_headroom instead of hard_header_len
    https://git.kernel.org/netdev/net-next/c/c053d7b6bdcb
  - [net-next,v3,2/2] net: wwan: t7xx: Add NAPI support
    https://git.kernel.org/netdev/net-next/c/5545b7b9f294

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


