Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6848F6BAB5E
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 10:00:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231898AbjCOJAd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 05:00:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231899AbjCOJA1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 05:00:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 028BD637E4;
        Wed, 15 Mar 2023 02:00:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 676F0B81DAA;
        Wed, 15 Mar 2023 09:00:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id EB4FBC433A0;
        Wed, 15 Mar 2023 09:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678870819;
        bh=zg85Y3KVT7sBvQP4OrW5AAcolBWcX/lD9WhGvmRd3JY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=uHFE5USFiTRb3GnTCINqQcMLR275M+LsaT0aY1M9D6oQbXTiuCvH+z4zS68mhnWh+
         8xZXSnPaTiGciyEIju0JnitCBEZSGWoXj19RBdkqTHShiBOKDNd34jzjlsFPHdWNSy
         fPXba8xwCjaOik5q5VlR4PJE6FfttOIqi0Tk83kJkut7lc+OJLkNAjsuJvkBfjAoM5
         iiBZqbkFtv7j7bj4+RgfIWSyrEuGNLTNjxCLhHipxEB1QNPRWLgT8hjQCByvDTDFAI
         hXPu8GAy2VBUWlVKTGo4CvyogxOXt4ZRC4z1mDDzEeoRAElf880TO4dxP4uzqJ0ox6
         QwB31EeRhc29w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id CBE97E66CBA;
        Wed, 15 Mar 2023 09:00:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/2] net: ethernet: mtk_eth_soc: minor SGMII fixes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167887081883.17591.12121593716328275431.git-patchwork-notify@kernel.org>
Date:   Wed, 15 Mar 2023 09:00:18 +0000
References: <cover.1678753669.git.daniel@makrotopia.org>
In-Reply-To: <cover.1678753669.git.daniel@makrotopia.org>
To:     Daniel Golle <daniel@makrotopia.org>
Cc:     devicetree@vger.kernel.org, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, netdev@vger.kernel.org,
        linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux@armlinux.org.uk, hkallweit1@gmail.com, lorenzo@kernel.org,
        Mark-MC.Lee@mediatek.com, john@phrozen.org, nbd@nbd.name,
        angelogioacchino.delregno@collabora.com, matthias.bgg@gmail.com,
        dqfext@gmail.com, Landen.Chao@mediatek.com, sean.wang@mediatek.com,
        pabeni@redhat.com, kuba@kernel.org, edumazet@google.com,
        davem@davemloft.net, olteanv@gmail.com, f.fainelli@gmail.com,
        andrew@lunn.ch, vladimir.oltean@nxp.com, bjorn@mork.no,
        frank-w@public-files.de, lynxis@fe80.eu
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (main)
by David S. Miller <davem@davemloft.net>:

On Tue, 14 Mar 2023 00:34:05 +0000 you wrote:
> This small series brings two minor fixes for the SGMII unit found in
> MediaTek's router SoCs.
> 
> The first patch resets the PCS internal state machine on major
> configuration changes, just like it is also done in MediaTek's SDK.
> 
> The second patch makes sure we only write values and restart AN if
> actually needed, thus preventing unnesseray loss of an existing link
> in some cases.
> 
> [...]

Here is the summary with links:
  - [1/2] net: ethernet: mtk_eth_soc: reset PCS state
    https://git.kernel.org/netdev/net/c/611e2dabb4b3
  - [2/2] net: ethernet: mtk_eth_soc: only write values if needed
    https://git.kernel.org/netdev/net/c/6e933a804c7d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


