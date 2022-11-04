Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1DF261943A
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 11:10:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230233AbiKDKKT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 06:10:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229770AbiKDKKR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 06:10:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C454129835
        for <netdev@vger.kernel.org>; Fri,  4 Nov 2022 03:10:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 533E76212C
        for <netdev@vger.kernel.org>; Fri,  4 Nov 2022 10:10:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A9E92C433C1;
        Fri,  4 Nov 2022 10:10:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667556615;
        bh=LDp7jnGLtJjo9S/qZAL0kiniy9bWv5Dyr9rkObOriWs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=gwlzBxMnK9dlXPAF890IWiaNTwddBQlHuQDro166kgMQKnWG5XPFwEoSqTdKTecXh
         uo6Sj0lNPwavvDWsp8O0VUJpTSRPP1VZLRKrhhHHHgKTr++brUjPuffpSa3yFJOmhC
         ++0T28fTQHpATYN936FT6uYfxyAENJyZDRbpUNkzAwK9h7rWa9XP7ujCcCRjyC5Gis
         yGeFCjaX1U8M8Kgn9dgn9jWiYuDsjg/m3ifxDoGz/+r2Hm/BezigZfIRGOXdWK/y2g
         8ayxK4I2QljEzb+utSJFA+mxanjDnMuUD06wxN6wpu/15wqpMdE6VHLeJKhh0y1JhO
         c7H85gS4Tyllw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 8A56DE29F4C;
        Fri,  4 Nov 2022 10:10:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: octeontx2-pf: mcs: consider MACSEC setting
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166755661556.16370.8312709205326237183.git-patchwork-notify@kernel.org>
Date:   Fri, 04 Nov 2022 10:10:15 +0000
References: <20221101050813.31567-1-rdunlap@infradead.org>
In-Reply-To: <20221101050813.31567-1-rdunlap@infradead.org>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     netdev@vger.kernel.org, lkp@intel.com, sbhatta@marvell.com,
        sgoutham@marvell.com, gakula@marvell.com, hkelam@marvell.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Mon, 31 Oct 2022 22:08:13 -0700 you wrote:
> Fix build errors when MACSEC=m and OCTEONTX2_PF=y by having
> OCTEONTX2_PF depend on MACSEC if it is enabled. By adding
> "|| !MACSEC", this means that MACSEC is not required -- it can
> be disabled for this driver.
> 
> drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.o: in function `otx2_remove':
> ../drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c:(.text+0x2fd0): undefined reference to `cn10k_mcs_free'
> mips64-linux-ld: drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.o: in function `otx2_mbox_up_handler_mcs_intr_notify':
> ../drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c:(.text+0x4610): undefined reference to `cn10k_handle_mcs_event'
> 
> [...]

Here is the summary with links:
  - net: octeontx2-pf: mcs: consider MACSEC setting
    https://git.kernel.org/netdev/net/c/4581dd480c9e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


