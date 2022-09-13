Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCB145B78F8
	for <lists+netdev@lfdr.de>; Tue, 13 Sep 2022 20:01:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231838AbiIMR7u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Sep 2022 13:59:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231709AbiIMR7T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Sep 2022 13:59:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1986DAA4F8;
        Tue, 13 Sep 2022 10:01:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 57C3DB80EFC;
        Tue, 13 Sep 2022 17:01:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C2F6C43141;
        Tue, 13 Sep 2022 17:01:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663088500;
        bh=YSN7KrVC6f0TmUoKp3H49EC0rXQ3ViO2eJhR8EljM1A=;
        h=From:To:Cc:Subject:Date:From;
        b=vP5D/vJOX7xz0ayxIILzSvRiaHZb01N5em5Oll0OvmZ+RvaRqr5NGSigY2s4ux59G
         a/Sxl0Y1dwF3r6yN3DTmsTScYD8NCXu+CMMnfEaIBMKbuPVbWEKazN7h7h8S+6XbeZ
         czSUGyQ4IEl0aZeyE8wSME+y94fSiIqGgM+CKTIFxn762rmyEi/OXY4ddK1Y+bPHtp
         3lkCfpb/Ft1ZprBSB2W5xaVcgc6z7ZOKsmRShPgJFBu7mboKlCPy2T8kN7JkRQdWaz
         M6R+Ys2pXmrYGnYqjz0EArEBzien1+TgLhZ60Uwl+ZrTu71SEO+7BcMIsfQ4mvodoK
         aPvnxhvLNGK1g==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     nbd@nbd.name, john@phrozen.org, sean.wang@mediatek.com,
        Mark-MC.Lee@mediatek.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, matthias.bgg@gmail.com,
        linux-mediatek@lists.infradead.org, lorenzo.bianconi@redhat.com,
        Bo.Jiao@mediatek.com, sujuan.chen@mediatek.com,
        ryder.Lee@mediatek.com, evelyn.tsai@mediatek.com,
        devicetree@vger.kernel.org, robh@kernel.org, daniel@makrotopia.org
Subject: [PATCH v2 net-next 00/11] Add WED support for MT7986 chipset
Date:   Tue, 13 Sep 2022 19:00:50 +0200
Message-Id: <cover.1663087836.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Similar to MT7622, introduce Wireless Ethernet Dispatch (WED) support
for MT7986 chipset in order to offload to the hw packet engine traffic
received from LAN/WAN device to WLAN nic (MT7915E).

Changes since v1:
- drop foe structure in mtk_soc_data structure and fix compilation error
  on ARMv7 (e.g. MT7623)
- add missing dt bindings
- rely on syscon_regmap_lookup_by_phandle to read/write into wed-pcie
  controller

Lorenzo Bianconi (11):
  arm64: dts: mediatek: mt7986: add support for Wireless Ethernet
    Dispatch
  dt-bindings: net: mediatek: add WED binding for MT7986 eth driver
  net: ethernet: mtk_eth_soc: move gdma_to_ppe and ppe_base definitions
    in mtk register map
  net: ethernet: mtk_eth_soc: move ppe table hash offset to mtk_soc_data
    structure
  net: ethernet: mtk_eth_soc: add the capability to run multiple ppe
  net: ethernet: mtk_eth_soc: move wdma_base definitions in mtk register
    map
  net: ethernet: mtk_eth_soc: add foe_entry_size to mtk_eth_soc
  net: ethernet: mtk_eth_wed: add mtk_wed_configure_irq and
    mtk_wed_dma_{enable/disable}
  net: ethernet: mtk_eth_wed: add wed support for mt7986 chipset
  net: ethernet: mtk_eth_wed: add axi bus support
  net: ethernet: mtk_eth_soc: introduce flow offloading support for
    mt7986

 .../arm/mediatek/mediatek,mt7622-wed.yaml     |   1 +
 .../mediatek/mediatek,mt7986-wed-pcie.yaml    |  43 ++
 .../devicetree/bindings/net/mediatek,net.yaml |  27 +-
 arch/arm64/boot/dts/mediatek/mt7986a.dtsi     |  24 +
 drivers/net/ethernet/mediatek/mtk_eth_soc.c   |  98 +++-
 drivers/net/ethernet/mediatek/mtk_eth_soc.h   |  93 +++-
 drivers/net/ethernet/mediatek/mtk_ppe.c       | 302 +++++++----
 drivers/net/ethernet/mediatek/mtk_ppe.h       |  67 ++-
 .../net/ethernet/mediatek/mtk_ppe_debugfs.c   |  10 +-
 .../net/ethernet/mediatek/mtk_ppe_offload.c   |  62 ++-
 drivers/net/ethernet/mediatek/mtk_ppe_regs.h  |   8 +
 drivers/net/ethernet/mediatek/mtk_wed.c       | 486 ++++++++++++++----
 drivers/net/ethernet/mediatek/mtk_wed.h       |   8 +-
 .../net/ethernet/mediatek/mtk_wed_debugfs.c   |   3 +
 drivers/net/ethernet/mediatek/mtk_wed_regs.h  |  89 +++-
 include/linux/soc/mediatek/mtk_wed.h          |  19 +-
 16 files changed, 1027 insertions(+), 313 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/arm/mediatek/mediatek,mt7986-wed-pcie.yaml

-- 
2.37.3

