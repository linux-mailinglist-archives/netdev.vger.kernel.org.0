Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 067D8695799
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 04:50:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231526AbjBNDuW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 22:50:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229781AbjBNDuV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 22:50:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC0C1A5FA;
        Mon, 13 Feb 2023 19:50:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3F2166140B;
        Tue, 14 Feb 2023 03:50:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9000DC433A7;
        Tue, 14 Feb 2023 03:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676346619;
        bh=n9qOiH0RUbj9t+6MFTaBCd3iC12UZ0ekk/x0pMcHtYI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=TqugRf9U4rSu/UzbqTgMaSG1wAW12A2epaYg4QgsZsL1sq7lgqWoZn4qLetVgEFtP
         isoR51XuN5rFekVkxVeLXDb1m0Y7rQ3vCsvQH5c1Hf39LPOEIF1/094Uf1tPBJENao
         sWVN6V0bHS/hDPxhVrwZ5RY+rCY9KZn60gXU4l4eJclCNZhDbDdHoiQajL19jjXLO+
         fase24yUkPLmrFzvvD7Fowc3rNi4frTp3ITainCRsGtYGty784OivbqkaB2XHxKaAw
         UdSL/z8xcy4pUpnFxcK1Qp24HaD4Tn/0nbAKeBj0PV5MdvwjnS4w+XMFV4vrZrixOG
         yHVvlwe2H1jhA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 74403C41677;
        Tue, 14 Feb 2023 03:50:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: ethernet: mtk_wed: No need to clear memory
 after a dma_alloc_coherent() call
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167634661945.22468.7891071719271483314.git-patchwork-notify@kernel.org>
Date:   Tue, 14 Feb 2023 03:50:19 +0000
References: <d5acce7dd108887832c9719f62c7201b4c83b3fb.1676184599.git.christophe.jaillet@wanadoo.fr>
In-Reply-To: <d5acce7dd108887832c9719f62c7201b4c83b3fb.1676184599.git.christophe.jaillet@wanadoo.fr>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     nbd@nbd.name, john@phrozen.org, sean.wang@mediatek.com,
        Mark-MC.Lee@mediatek.com, lorenzo@kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        matthias.bgg@gmail.com, angelogioacchino.delregno@collabora.com,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Sun, 12 Feb 2023 07:51:51 +0100 you wrote:
> dma_alloc_coherent() already clears the allocated memory, there is no need
> to explicitly call memset().
> 
> Moreover, it is likely that the size in the memset() is incorrect and
> should be "size * sizeof(*ring->desc)".
> 
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> 
> [...]

Here is the summary with links:
  - [net-next] net: ethernet: mtk_wed: No need to clear memory after a dma_alloc_coherent() call
    https://git.kernel.org/netdev/net-next/c/511b88fedab4

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


