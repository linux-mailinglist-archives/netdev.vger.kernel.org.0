Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22A1A69873E
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 22:19:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229882AbjBOVTP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 16:19:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbjBOVTO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 16:19:14 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EEAC39294;
        Wed, 15 Feb 2023 13:19:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=s06QXZD2epJvazS97JjdTPMJBT7sTvjcgysko1ATtgA=; b=NMcuXd8Ik0RHOiEU2KR8jg9qf2
        VHxQ8HugeYVJCssmdeMYaossBfogChl4HasI/+CTFM93kEbkatfZHenGbL/nNl6SmNG+c7uOZLOrh
        nEZo+gL0enL1Zly6rasRchDwcMPQeW81zcn831RFSy2c3aWqedpeB0OMmL+t83h88gJKOgC84p+Oi
        bW3vRiZ9qSlD0kJ50ciAQIZtFRq4MagEOLsxlF+o2MSgEb5jZaNj3Chlwlz2Qy2SruCLkcOKhuVIl
        FV4HqljJsGsImRw1Kpspold5GzkPQchuiQKmcJq4iHCPe72wWK8B1KDfVlrtX1PaKJOisQaJ52C5S
        jrW6MyRA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:55894)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pSPBG-0007Gq-Ka; Wed, 15 Feb 2023 21:19:10 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pSPBF-0005D3-Db; Wed, 15 Feb 2023 21:19:09 +0000
Date:   Wed, 15 Feb 2023 21:19:09 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Daniel Golle <daniel@makrotopia.org>
Cc:     devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        netdev@vger.kernel.org, linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        John Crispin <john@phrozen.org>, Felix Fietkau <nbd@nbd.name>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Jianhui Zhao <zhaojh329@gmail.com>,
        =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>
Subject: Re: [PATCH v7 00/12] net: ethernet: mtk_eth_soc: various enhancements
Message-ID: <Y+1MTXX1+uRsPnNO@shell.armlinux.org.uk>
References: <cover.1676491901.git.daniel@makrotopia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1676491901.git.daniel@makrotopia.org>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Daniel,

Please don't be so quick to send the next revision as soon as you
receive comments on a series - as has just been demonstrated, I've
replied to Rob's comment about moving the binding to clocks which
I don't agree with having read the documentation.

Posting a new series so quickly cuts off any hope of a sensible
discussion, and leads to people having to scramble to say "no,
we're still discussing the previous series" to possibly prevent
netdev applying the patches before the discussion has reached
a conclusion.

Thanks.


On Wed, Feb 15, 2023 at 08:59:37PM +0000, Daniel Golle wrote:
> This series brings a variety of fixes and enhancements for mtk_eth_soc,
> adds support for the MT7981 SoC and facilitates sharing the SGMII PCS
> code between mtk_eth_soc and mt7530.
> 
> Note that this series depends on commit 697c3892d825
> ("regmap: apply reg_base and reg_downshift for single register ops") to
> not break mt7530 pcs register access.
> 
> The whole series has been tested on MT7622+MT7531 (BPi-R64),
> MT7623+MT7530 (BPi-R2) and MT7981+GPY211 (GL.iNet GL-MT3000).
> 
> Changes since v6:
>  * label MAC MCR bit 12 in 08/12, MediaTek replied explaining its function
>  * move mediatek,sgmiisys bindings to
>    Documentation/devicetree/bindings/clock
> 
> Changes since v5:
>  * drop dev pointer also from struct mtk_sgmii, pass it as function
>    paramter instead
>  * address comments left for dt-bindings
>  * minor improvements to commit messages
> 
> Changes since v4:
>  * remove unused dev pointer in struct pcs_mtk_lynxi
>  * squash link timer check into correct follow-up patch
> 
> Changes since v3:
>  * remove unused #define's
>  * use BMCR_* instead of #define'ing our own constants
>  * return before changing registers in case of invalid link timer
> 
> Changes since v2:
>  * improve dt-bindings, convert sgmisys bindings to dt-schema yaml
>  * fix typo
> 
> Changes since v1:
>  * apply reverse xmas tree everywhere
>  * improve commit descriptions
>  * add dt binding documentation
>  * various small changes addressing all comments received for v1
> 
> 
> Daniel Golle (12):
>   net: ethernet: mtk_eth_soc: add support for MT7981 SoC
>   dt-bindings: net: mediatek,net: add mt7981-eth binding
>   dt-bindings: arm: mediatek: sgmiisys: Convert to DT schema
>   dt-bindings: arm: mediatek: sgmiisys: add MT7981 SoC
>   net: ethernet: mtk_eth_soc: set MDIO bus clock frequency
>   net: ethernet: mtk_eth_soc: reset PCS state
>   net: ethernet: mtk_eth_soc: only write values if needed
>   net: ethernet: mtk_eth_soc: fix RX data corruption issue
>   net: ethernet: mtk_eth_soc: ppe: add support for flow accounting
>   net: pcs: add driver for MediaTek SGMII PCS
>   net: ethernet: mtk_eth_soc: switch to external PCS driver
>   net: dsa: mt7530: use external PCS driver
> 
>  .../arm/mediatek/mediatek,sgmiisys.txt        |  27 --
>  .../bindings/clock/mediatek,sgmiisys.yaml     |  55 ++++
>  .../devicetree/bindings/net/mediatek,net.yaml |  52 ++-
>  MAINTAINERS                                   |   7 +
>  drivers/net/dsa/Kconfig                       |   1 +
>  drivers/net/dsa/mt7530.c                      | 277 ++++------------
>  drivers/net/dsa/mt7530.h                      |  47 +--
>  drivers/net/ethernet/mediatek/Kconfig         |   2 +
>  drivers/net/ethernet/mediatek/mtk_eth_path.c  |  14 +-
>  drivers/net/ethernet/mediatek/mtk_eth_soc.c   |  67 +++-
>  drivers/net/ethernet/mediatek/mtk_eth_soc.h   | 105 +++---
>  drivers/net/ethernet/mediatek/mtk_ppe.c       | 114 ++++++-
>  drivers/net/ethernet/mediatek/mtk_ppe.h       |  25 +-
>  .../net/ethernet/mediatek/mtk_ppe_debugfs.c   |   9 +-
>  .../net/ethernet/mediatek/mtk_ppe_offload.c   |   8 +
>  drivers/net/ethernet/mediatek/mtk_ppe_regs.h  |  14 +
>  drivers/net/ethernet/mediatek/mtk_sgmii.c     | 192 ++---------
>  drivers/net/pcs/Kconfig                       |   7 +
>  drivers/net/pcs/Makefile                      |   1 +
>  drivers/net/pcs/pcs-mtk-lynxi.c               | 303 ++++++++++++++++++
>  include/linux/pcs/pcs-mtk-lynxi.h             |  13 +
>  21 files changed, 802 insertions(+), 538 deletions(-)
>  delete mode 100644 Documentation/devicetree/bindings/arm/mediatek/mediatek,sgmiisys.txt
>  create mode 100644 Documentation/devicetree/bindings/clock/mediatek,sgmiisys.yaml
>  create mode 100644 drivers/net/pcs/pcs-mtk-lynxi.c
>  create mode 100644 include/linux/pcs/pcs-mtk-lynxi.h
> 
> 
> base-commit: 9d9019bcea1aac7eed64a1a4966282b6b7b141c8
> -- 
> 2.39.1
> 
> 

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
