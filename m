Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E9CD5B26C8
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 21:35:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230338AbiIHTfF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 15:35:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230355AbiIHTfD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 15:35:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D71E333E3C;
        Thu,  8 Sep 2022 12:35:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D0D5F61DF1;
        Thu,  8 Sep 2022 19:35:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEDA1C433C1;
        Thu,  8 Sep 2022 19:34:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662665700;
        bh=BioAyTQYLotc4j+JLo7fzrrs4D6BavNTrHJbE7RcGyw=;
        h=From:To:Cc:Subject:Date:From;
        b=hLpkvCTxYqlA1cxFmtMeoA6e4w45k9DzrRjkemHJjM6RWcEvj5Way0YuuNC+KxT5j
         +hG8ml6sfYiOpoeMieixXQk4/gaxjZgBbq+H2P6H0g6V5dl7d7xaQiOhrjwjqKV7Ln
         TuQNPyjfhGEgWqgNNOu75unCe5XGLax51wmVQfym9ISCEKQjp3pcrhh958qBXKapjQ
         dysQxCQFlYjzE0UB2v4G0hgJ0XxnLzKzV2xTg1HRFFCWII+sgkwPT8pKaUb+X3uPZR
         kJCq5sxWmhlt4nGhI/B6yj8MtXkORoODBrRWRjEm/r/iJSaRwPt1NhRL5+VSfJcG5y
         9saTY62Bb0JEQ==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     nbd@nbd.name, john@phrozen.org, sean.wang@mediatek.com,
        Mark-MC.Lee@mediatek.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, matthias.bgg@gmail.com,
        linux-mediatek@lists.infradead.org, lorenzo.bianconi@redhat.com,
        Bo.Jiao@mediatek.com, sujuan.chen@mediatek.com,
        ryder.Lee@mediatek.com, evelyn.tsai@mediatek.com,
        devicetree@vger.kernel.org, robh@kernel.org
Subject: [PATCH net-next 00/12] Add WED support for MT7986 chipset
Date:   Thu,  8 Sep 2022 21:33:34 +0200
Message-Id: <cover.1662661555.git.lorenzo@kernel.org>
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

Lorenzo Bianconi (12):
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
  net: ethernet: mtk_eth_soc: add foe info in mtk_soc_data structure
  net: ethernet: mtk_eth_wed: add mtk_wed_configure_irq and
    mtk_wed_dma_{enable/disable}
  net: ethernet: mtk_eth_wed: add wed support for mt7986 chipset
  net: ethernet: mtk_eth_wed: add axi bus support
  net: ethernet: mtk_eth_soc: introduce flow offloading support for
    mt7986

 .../devicetree/bindings/net/mediatek,net.yaml |   9 +
 arch/arm64/boot/dts/mediatek/mt7986a.dtsi     |  20 +
 drivers/net/ethernet/mediatek/mtk_eth_soc.c   | 184 ++++++-
 drivers/net/ethernet/mediatek/mtk_eth_soc.h   |  45 +-
 drivers/net/ethernet/mediatek/mtk_ppe.c       | 271 ++++++----
 drivers/net/ethernet/mediatek/mtk_ppe.h       |  54 +-
 .../net/ethernet/mediatek/mtk_ppe_debugfs.c   |  10 +-
 .../net/ethernet/mediatek/mtk_ppe_offload.c   |  62 ++-
 drivers/net/ethernet/mediatek/mtk_ppe_regs.h  |   8 +
 drivers/net/ethernet/mediatek/mtk_wed.c       | 473 ++++++++++++++----
 drivers/net/ethernet/mediatek/mtk_wed.h       |   8 +-
 .../net/ethernet/mediatek/mtk_wed_debugfs.c   |   3 +
 drivers/net/ethernet/mediatek/mtk_wed_regs.h  |  85 +++-
 include/linux/soc/mediatek/mtk_wed.h          |  15 +
 14 files changed, 955 insertions(+), 292 deletions(-)

-- 
2.37.3

