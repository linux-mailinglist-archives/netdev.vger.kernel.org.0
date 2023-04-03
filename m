Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3C456D402B
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 11:21:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231960AbjDCJU7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 05:20:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231655AbjDCJUs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 05:20:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1798CEB70;
        Mon,  3 Apr 2023 02:20:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C1CFBB8163F;
        Mon,  3 Apr 2023 09:20:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6E8FDC433A1;
        Mon,  3 Apr 2023 09:20:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680513625;
        bh=HOvs3Az/e1R8EGkt90B9hBsreIGgQ7JOuGysC4UKjs0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=a4vvq4tiYCIbHg8kEzXlq4iWWS2DhfthAnJuWPrZyDRH0+2b4YnfiMd+B/2XpruM7
         9nnvvXRFJpL3ShmpilVGF/FPGxFgJeOThfVa7qxhTYYkAjybc8UvOq1joWCbiPOO8o
         JUdSB6BxwtbLRevsjrsRsx9CzrWG4yLc1lNMihPr8AOCik2//7cxJ9qT/CJyZjNiIg
         e/9IOSmyRl0vfPnzTygQLHhdL6CgEiMcHznrgEiA8D6ySPR8pSn77K634pL3rpAsjw
         YoPpa3xsYaj6mSMWyJnMNKxi7Ub52C+ZBXV9TUIhLkc9QzKIorMv6ZcmMbLXXA+gdp
         dcYhpfsGP7x5Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 4C1D9E5EA84;
        Mon,  3 Apr 2023 09:20:25 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 00/14] net: dsa: add support for MT7988
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168051362530.15794.2568241679390947127.git-patchwork-notify@kernel.org>
Date:   Mon, 03 Apr 2023 09:20:25 +0000
References: <cover.1680483895.git.daniel@makrotopia.org>
In-Reply-To: <cover.1680483895.git.daniel@makrotopia.org>
To:     Daniel Golle <daniel@makrotopia.org>
Cc:     devicetree@vger.kernel.org, netdev@vger.kernel.org,
        linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        andrew@lunn.ch, f.fainelli@gmail.com, olteanv@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, matthias.bgg@gmail.com,
        angelogioacchino.delregno@collabora.com, sean.wang@mediatek.com,
        Landen.Chao@mediatek.com, dqfext@gmail.com, p.zabel@pengutronix.de,
        linux@armlinux.org.uk, arinc.unal@arinc9.com,
        Sam.Shih@mediatek.com, lorenzo@kernel.org, john@phrozen.org,
        nbd@nbd.name
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (main)
by David S. Miller <davem@davemloft.net>:

On Mon, 3 Apr 2023 02:16:40 +0100 you wrote:
> The MediaTek MT7988 SoC comes with a built-in switch very similar to
> previous MT7530 and MT7531. However, the switch address space is mapped
> into the SoCs memory space rather than being connected via MDIO.
> Using MMIO simplifies register access and also removes the need for a bus
> lock, and for that reason also makes interrupt handling more light-weight.
> 
> Note that this is different from previous SoCs like MT7621 and MT7623N
> which also came with an integrated MT7530-like switch which yet had to be
> accessed via MDIO.
> 
> [...]

Here is the summary with links:
  - [net-next,v2,01/14] net: dsa: mt7530: make some noise if register read fails
    https://git.kernel.org/netdev/net-next/c/b6f56cddb5f5
  - [net-next,v2,02/14] net: dsa: mt7530: refactor SGMII PCS creation
    https://git.kernel.org/netdev/net-next/c/9ecc00164dc2
  - [net-next,v2,03/14] net: dsa: mt7530: use unlocked regmap accessors
    https://git.kernel.org/netdev/net-next/c/1bd099c49f65
  - [net-next,v2,04/14] net: dsa: mt7530: use regmap to access switch register space
    https://git.kernel.org/netdev/net-next/c/a08c045580e0
  - [net-next,v2,05/14] net: dsa: mt7530: move SGMII PCS creation to mt7530_probe function
    https://git.kernel.org/netdev/net-next/c/6de285229773
  - [net-next,v2,06/14] net: dsa: mt7530: introduce mutex helpers
    https://git.kernel.org/netdev/net-next/c/1557c679f71c
  - [net-next,v2,07/14] net: dsa: mt7530: move p5_intf_modes() function to mt7530.c
    https://git.kernel.org/netdev/net-next/c/25d15dee34a1
  - [net-next,v2,08/14] net: dsa: mt7530: introduce mt7530_probe_common helper function
    https://git.kernel.org/netdev/net-next/c/37c9c0d8d0b2
  - [net-next,v2,09/14] net: dsa: mt7530: introduce mt7530_remove_common helper function
    https://git.kernel.org/netdev/net-next/c/720d73635176
  - [net-next,v2,10/14] net: dsa: mt7530: split-off common parts from mt7531_setup
    https://git.kernel.org/netdev/net-next/c/7f54cc9772ce
  - [net-next,v2,11/14] net: dsa: mt7530: introduce separate MDIO driver
    https://git.kernel.org/netdev/net-next/c/cb675afcddbb
  - [net-next,v2,12/14] net: dsa: mt7530: skip locking if MDIO bus isn't present
    https://git.kernel.org/netdev/net-next/c/54d4147a121c
  - [net-next,v2,13/14] net: dsa: mt7530: introduce driver for MT7988 built-in switch
    https://git.kernel.org/netdev/net-next/c/110c18bfed41
  - [net-next,v2,14/14] dt-bindings: net: dsa: mediatek,mt7530: add mediatek,mt7988-switch
    https://git.kernel.org/netdev/net-next/c/386f5fc9061b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


