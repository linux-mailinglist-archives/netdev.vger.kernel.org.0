Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5426368EB0E
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 10:23:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231282AbjBHJXG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 04:23:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230252AbjBHJWf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 04:22:35 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C81EC65C;
        Wed,  8 Feb 2023 01:20:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8F6FC61584;
        Wed,  8 Feb 2023 09:20:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E6E23C433D2;
        Wed,  8 Feb 2023 09:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675848018;
        bh=2TjSaonTghxRKNuPgBnNQG/ietR7NZYTH0JtktEO3B0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ouTkdaf1lKuKbqD2hmcJm4/cs2ayH05CAFsEeAgYXBeVQ/Kw8iovnCrnuoBfL2sGr
         t0YdnvSzbZHjsCoWVwmvazIBEoGVmprlhLoaF1eYXm6RaNwzADowTvPWluUNnqRV6O
         kO0L/8TL0jsUCkP46MPKTd0CezaYLFyn2a5GFhBYx7ViQCwszo1JHZ2CPsrohgQgwq
         mfyVisu8k5TsqQhtWjuCubZkGXUbxCALYieX+cpwgwq64GHysFmYtT0ytN5o14o4Wk
         UMKtQjUB4UeciJbxLHD3IGfcfKYcUIV54ji+JghIutWXBYpRL8RZydYlkMBsNXz/jl
         krFxUp8Ys/zUg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C5EDDE4D032;
        Wed,  8 Feb 2023 09:20:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: ethernet: mtk_eth_soc: fix DSA TX tag hwaccel for
 switch port 0
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167584801780.16330.2115452134771424523.git-patchwork-notify@kernel.org>
Date:   Wed, 08 Feb 2023 09:20:17 +0000
References: <20230207103027.1203344-1-vladimir.oltean@nxp.com>
In-Reply-To: <20230207103027.1203344-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, nbd@nbd.name, john@phrozen.org,
        sean.wang@mediatek.com, Mark-MC.Lee@mediatek.com,
        lorenzo@kernel.org, matthias.bgg@gmail.com,
        angelogioacchino.delregno@collabora.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, arinc.unal@arinc9.com
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

On Tue,  7 Feb 2023 12:30:27 +0200 you wrote:
> Arınç reports that on his MT7621AT Unielec U7621-06 board and MT7623NI
> Bananapi BPI-R2, packets received by the CPU over mt7530 switch port 0
> (of which this driver acts as the DSA master) are not processed
> correctly by software. More precisely, they arrive without a DSA tag
> (in packet or in the hwaccel area - skb_metadata_dst()), so DSA cannot
> demux them towards the switch's interface for port 0. Traffic from other
> ports receives a skb_metadata_dst() with the correct port and is demuxed
> properly.
> 
> [...]

Here is the summary with links:
  - [net] net: ethernet: mtk_eth_soc: fix DSA TX tag hwaccel for switch port 0
    https://git.kernel.org/netdev/net/c/1a3245fe0cf8

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


