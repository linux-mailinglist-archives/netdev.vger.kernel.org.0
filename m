Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 010685F189C
	for <lists+netdev@lfdr.de>; Sat,  1 Oct 2022 04:20:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232296AbiJACUb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 22:20:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231968AbiJACU3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 22:20:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82679F479A
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 19:20:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7E40AB82B49
        for <netdev@vger.kernel.org>; Sat,  1 Oct 2022 02:20:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1D3FAC433D7;
        Sat,  1 Oct 2022 02:20:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664590824;
        bh=v1Y3KSUbzDa+6fRHZWDYww6W7f4VLs63qATncEW6lzg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=FtsgGxt7vVgOmUpOi1e5th8ym/9fqsCcfNC54UJOz4WqHPW8TZ+pg7S5QL4VHkD5s
         XFwemdzLSM+am/4TTCvIAfomrX2a6YjcgBkcRuzuZOv/Chpu7pNss5A0IdUzlu6e9A
         rKETVVU74O6YUMZQQ2mQDbbA8GQjgwVZZlv0zg/p/npAy2VKGCNyvvej9aoYeGvNBS
         0sCtQugoTeMaLqktyIWrN/5CnXONjImpN8CrkaljI/qfhgo/+v53U3R0sN3j+osx6q
         kcF+ujnu1yyE1ubEPSnaA+M+IOoDDheERDvmhQ7R4ohyZNuhsJJYCGbxep/rj4Y3c1
         OjSIxn30gFsmQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 011BCE50D64;
        Sat,  1 Oct 2022 02:20:24 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] net: ethernet: mtk_eth_soc: fix state in
 __mtk_foe_entry_clear
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166459082399.26825.7869128536663169925.git-patchwork-notify@kernel.org>
Date:   Sat, 01 Oct 2022 02:20:23 +0000
References: <YzY+1Yg0FBXcnrtc@makrotopia.org>
In-Reply-To: <YzY+1Yg0FBXcnrtc@makrotopia.org>
To:     Daniel Golle <daniel@makrotopia.org>
Cc:     kuba@kernel.org, linux-mediatek@lists.infradead.org,
        netdev@vger.kernel.org, lorenzo@kernel.org,
        sujuan.chen@mediatek.com, Bo.Jiao@mediatek.com, nbd@nbd.name,
        john@phrozen.org, sean.wang@mediatek.com, Mark-MC.Lee@mediatek.com,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        matthias.bgg@gmail.com, ptpt52@gmail.com,
        thomas.huehn@hs-nordhausen.de
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Fri, 30 Sep 2022 01:56:53 +0100 you wrote:
> Setting ib1 state to MTK_FOE_STATE_UNBIND in __mtk_foe_entry_clear
> routine as done by commit 0e80707d94e4c8 ("net: ethernet: mtk_eth_soc:
> fix typo in __mtk_foe_entry_clear") breaks flow offloading, at least
> on older MTK_NETSYS_V1 SoCs, OpenWrt users have confirmed the bug on
> MT7622 and MT7621 systems.
> Felix Fietkau suggested to use MTK_FOE_STATE_INVALID instead which
> works well on both, MTK_NETSYS_V1 and MTK_NETSYS_V2.
> 
> [...]

Here is the summary with links:
  - [v2] net: ethernet: mtk_eth_soc: fix state in __mtk_foe_entry_clear
    https://git.kernel.org/netdev/net/c/ae3ed15da588

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


