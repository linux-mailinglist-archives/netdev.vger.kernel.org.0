Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D21B4647CB6
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 05:05:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229824AbiLIDuY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 22:50:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229720AbiLIDuX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 22:50:23 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE29BB2EF4
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 19:50:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7ADE862155
        for <netdev@vger.kernel.org>; Fri,  9 Dec 2022 03:50:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C8D21C433EF;
        Fri,  9 Dec 2022 03:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670557816;
        bh=Sq507ZJKfFu5pvL5ZO0IknPxsb3Z4M7hywSu7GplW5g=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=qK8aMrswXFZgPETa564QByWToQjjAOZisFm/3bpZ7wIyw25An69w4PCDCGNkI9E1t
         NIXBKpLf7vWQwbVvahtFGIeTy0Kna64nj3voadMwhp1Tpwwu9RRMPZKqc5dkg060hu
         1EZcvxQtE255WtrM+Ma2FIe7Z0/HpBiVzvfx1OIgGdDom2bJnBBU01PA1lYU6P60nS
         hRP2hXw8vM8D76b0g/sSqKm078niFokhJg8D9/SGot/7XFoUzyihvn0t1TNDMdZCVe
         x72XXJ5O8GLJ3crsy0LACsJGWljyRciFmunUsiCzrcLJtyG5Ve/iyTn+vNBKRDBfU6
         ARoVje+nKeYDg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A3ED3E1B4D8;
        Fri,  9 Dec 2022 03:50:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3 net-next 0/2] fix possible deadlock during WED attach
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167055781666.4041.15328883962417059725.git-patchwork-notify@kernel.org>
Date:   Fri, 09 Dec 2022 03:50:16 +0000
References: <cover.1670421354.git.lorenzo@kernel.org>
In-Reply-To: <cover.1670421354.git.lorenzo@kernel.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, nbd@nbd.name, john@phrozen.org,
        sean.wang@mediatek.com, Mark-MC.Lee@mediatek.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, matthias.bgg@gmail.com,
        linux-mediatek@lists.infradead.org, lorenzo.bianconi@redhat.com,
        leon@kernel.org, sujuan.chen@mediatek.com
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
by Jakub Kicinski <kuba@kernel.org>:

On Wed,  7 Dec 2022 15:04:53 +0100 you wrote:
> Fix a possible deadlock in mtk_wed_attach if mtk_wed_wo_init routine fails.
> Check wo pointer is properly allocated before running mtk_wed_wo_reset() and
> mtk_wed_wo_deinit().
> 
> Changes sice v2:
> - add WARN_ON in mtk_wed_mcu_msg_update()
> - split in two patches
> Changes since v1:
> - move wo pointer checks in __mtk_wed_detach()
> 
> [...]

Here is the summary with links:
  - [v3,net-next,1/2] net: ethernet: mtk_wed: fix some possible NULL pointer dereferences
    https://git.kernel.org/netdev/net-next/c/c79e0af5ae5e
  - [v3,net-next,2/2] net: ethernet: mtk_wed: fix possible deadlock if mtk_wed_wo_init fails
    https://git.kernel.org/netdev/net-next/c/587585e1bbeb

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


