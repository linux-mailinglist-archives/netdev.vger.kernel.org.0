Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C671864AB80
	for <lists+netdev@lfdr.de>; Tue, 13 Dec 2022 00:20:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233973AbiLLXUf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 18:20:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234018AbiLLXUT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 18:20:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E990C1CB06
        for <netdev@vger.kernel.org>; Mon, 12 Dec 2022 15:20:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 894F46125E
        for <netdev@vger.kernel.org>; Mon, 12 Dec 2022 23:20:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E4FE8C433D2;
        Mon, 12 Dec 2022 23:20:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670887216;
        bh=3q3pQEENBpble+P8HsWtHWtvJIPA8Ye9B9LhfPUcY3Q=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=qVWLamxf3u2UpXouIQPLAwCq9mC6psCwUbeicUWcdDL64+/DhL3sUFDpWirkGy8BY
         kD8NlH3pOt5sBYPQ2wI5wuCExEqu4QOQVWtXI/NCDscL4kmt+Uq8IyX8OWP8wcbDZC
         0opqS257zut6awjMhhZEkQTRi1sH6fJhC4XCP5excmaXKcOcrdyUL1LecCJ4C/394z
         NcwagLW95j0Zz7zXALFnEQRdx8doTf/be0r67iUed21tc8tD5RbXF/00OqMjt2N4aB
         MhejsyOIxnB3RXVYbOhyUEnFaAD9rb1APYt5F4BOrqaASeFaKzC7NxWeol02Jt42ZU
         mJT3YZrWLp0Ew==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id CABB3C41606;
        Mon, 12 Dec 2022 23:20:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net 1/1] stmmac: fix potential division by 0
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167088721582.27199.17800143260465196314.git-patchwork-notify@kernel.org>
Date:   Mon, 12 Dec 2022 23:20:15 +0000
References: <de4c64ccac9084952c56a06a8171d738604c4770.1670678513.git.piergiorgio.beruto@gmail.com>
In-Reply-To: <de4c64ccac9084952c56a06a8171d738604c4770.1670678513.git.piergiorgio.beruto@gmail.com>
To:     Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
Cc:     peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, mcoquelin.stm32@gmail.com,
        richardcochran@gmail.com, julien.beraud@orolia.com,
        netdev@vger.kernel.org, andrew@lunn.ch
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
by Jakub Kicinski <kuba@kernel.org>:

On Sat, 10 Dec 2022 23:37:22 +0100 you wrote:
> When the MAC is connected to a 10 Mb/s PHY and the PTP clock is derived
> from the MAC reference clock (default), the clk_ptp_rate becomes too
> small and the calculated sub second increment becomes 0 when computed by
> the stmmac_config_sub_second_increment() function within
> stmmac_init_tstamp_counter().
> 
> Therefore, the subsequent div_u64 in stmmac_init_tstamp_counter()
> operation triggers a divide by 0 exception as shown below.
> 
> [...]

Here is the summary with links:
  - [v2,net,1/1] stmmac: fix potential division by 0
    https://git.kernel.org/netdev/net/c/ede5a389852d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


