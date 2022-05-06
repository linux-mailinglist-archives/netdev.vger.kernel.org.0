Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D6D351D7C7
	for <lists+netdev@lfdr.de>; Fri,  6 May 2022 14:31:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1391903AbiEFMe5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 May 2022 08:34:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349746AbiEFMey (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 May 2022 08:34:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1B245D675;
        Fri,  6 May 2022 05:31:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5B61BB835A8;
        Fri,  6 May 2022 12:31:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70896C385A9;
        Fri,  6 May 2022 12:31:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651840269;
        bh=NSQul1ApfnaW8wAQvzVcEwm5XDcRG4fs6JzoouRHRGc=;
        h=From:To:Cc:Subject:Date:From;
        b=JqVzKtWfh0ng6B0sSUND0n5XITQRVG47gHgY7/Gus6dmGClyshCPiTZh+exmgBaZR
         mPcUjXhj3wmOlhZJE0IBxYjGc5hE6q7i1RludB1oJJGm1zTPY9srOAEeVCbUTzS78Z
         LaaC/zA69QuagZ/2aaa1Wyao98CsZoKCzHsVzwZ1YZV5izKIha+NvXp/eOlKyMSJ00
         rG29hF0ArMvneTm944ciawWhV0lp/1uqdvZG4+s/PDypeb0EL1xCsTuc2mlkBEUwMU
         HEamlqrMkHgYlS47JqRLgOFR6LVIDh8OBvLxRA+EP84TqIe7x2cYqA05aVflN+/syC
         Vgky2ToaV10zg==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     nbd@nbd.name, john@phrozen.org, sean.wang@mediatek.com,
        Mark-MC.Lee@mediatek.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, Sam.Shih@mediatek.com,
        linux-mediatek@lists.infradead.org, devicetree@vger.kernel.org,
        robh@kernel.org
Subject: [PATCH net-next 00/14] introduce mt7986 ethernet support
Date:   Fri,  6 May 2022 14:30:17 +0200
Message-Id: <cover.1651839494.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for mt7986-eth driver available on mt7986 soc.

Lorenzo Bianconi (14):
  arm64: dts: mediatek: mt7986: introduce ethernet nodes
  dt-bindings: net: mediatek,net: add mt7986-eth binding
  net: ethernet: mtk_eth_soc: move tx dma desc configuration in
    mtk_tx_set_dma_desc
  net: ethernet: mtk_eth_soc: add txd_size to mtk_soc_data
  net: ethernet: mtk_eth_soc: rely on txd_size in
    mtk_tx_alloc/mtk_tx_clean
  net: ethernet: mtk_eth_soc: rely on txd_size in mtk_desc_to_tx_buf
  net: ethernet: mtk_eth_soc: rely on txd_size in txd_to_idx
  net: ethernet: mtk_eth_soc: add rxd_size to mtk_soc_data
  net: ethernet: mtk_eth_soc: rely on txd_size field in
    mtk_poll_tx/mtk_poll_rx
  net: ethernet: mtk_eth_soc: rely on rxd_size field in
    mtk_rx_alloc/mtk_rx_clean
  net: ethernet: mtk_eth_soc: add SRAM soc capability
  net: ethernet: mtk_eth_soc: introduce device register map
  net: ethernet: mtk_eth_soc: introduce MTK_NETSYS_V2 support
  net: ethernet: mtk_eth_soc: introduce support for mt7986 chipset

 .../devicetree/bindings/net/mediatek,net.yaml | 133 +++-
 arch/arm64/boot/dts/mediatek/mt7986a-rfb.dts  |  95 +++
 arch/arm64/boot/dts/mediatek/mt7986a.dtsi     |  39 +
 arch/arm64/boot/dts/mediatek/mt7986b-rfb.dts  |  91 +++
 drivers/net/ethernet/mediatek/mtk_eth_soc.c   | 727 +++++++++++++-----
 drivers/net/ethernet/mediatek/mtk_eth_soc.h   | 327 ++++++--
 6 files changed, 1146 insertions(+), 266 deletions(-)

-- 
2.35.1

