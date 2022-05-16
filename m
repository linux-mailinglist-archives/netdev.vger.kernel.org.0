Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B0B3528993
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 18:07:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241791AbiEPQHx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 12:07:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245718AbiEPQHm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 12:07:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E4FD37A90;
        Mon, 16 May 2022 09:07:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2273160F58;
        Mon, 16 May 2022 16:07:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9870CC385AA;
        Mon, 16 May 2022 16:07:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652717257;
        bh=XOhhReOwl1Pta9qaV5a9VKBGR6h1O872iZhq1RArjgw=;
        h=From:To:Cc:Subject:Date:From;
        b=Z9w9vAvjqf6xTrUJzIy0ZmAp6aN/Ic2InydiMkWR/4TD/jbtEUV0S82Dteq1LiEFy
         Nx1TlzUXrGsFzDdgql3otFWH8E6BWCqzWIDebJU2WdJYNpSdv7I/hV81x8xLlcKpeK
         mKTFjhbEl2xsQMBWKzvn86RSrhqWyklyDSvWeatFt9Jk487L+urKUD4MuLwWW5X03q
         Gi4ObBCpeXGcNwk9J73OuUl8xC2mm7m+8geDFqRmq6vjx/qeT8zhpH+qCcTWrvphl3
         c4Pw5A6RzWEfIIVgx093C9yiRX2uu7AIdYKu9iVFk3DdbaLfIrVdONtAh8oT5LVCbr
         Z5zFQEt0dihHg==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     nbd@nbd.name, john@phrozen.org, sean.wang@mediatek.com,
        Mark-MC.Lee@mediatek.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, Sam.Shih@mediatek.com,
        linux-mediatek@lists.infradead.org, devicetree@vger.kernel.org,
        robh@kernel.org, lorenzo.bianconi@redhat.com
Subject: [PATCH v2 net-next 00/15] introduce mt7986 ethernet support
Date:   Mon, 16 May 2022 18:06:27 +0200
Message-Id: <cover.1652716741.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.35.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for mt7986-eth driver available on mt7986 soc.

Changes since v1:
- drop SRAM option
- convert ring->dma to void
- convert scratch_ring to void
- enable port4
- fix irq dts bindings
- drop gmac1 support from mt7986a-rfb dts for the moment

Lorenzo Bianconi (15):
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
  net: ethernet: mtk_eth_soc: introduce device register map
  net: ethernet: mtk_eth_soc: introduce MTK_NETSYS_V2 support
  net: ethernet: mtk_eth_soc: convert ring dma pointer to void
  net: ethernet: mtk_eth_soc: convert scratch_ring pointer to void
  net: ethernet: mtk_eth_soc: introduce support for mt7986 chipset

 .../devicetree/bindings/net/mediatek,net.yaml | 141 +++-
 arch/arm64/boot/dts/mediatek/mt7986a-rfb.dts  |  74 ++
 arch/arm64/boot/dts/mediatek/mt7986a.dtsi     |  39 ++
 arch/arm64/boot/dts/mediatek/mt7986b-rfb.dts  |  70 ++
 drivers/net/ethernet/mediatek/mtk_eth_soc.c   | 630 +++++++++++++-----
 drivers/net/ethernet/mediatek/mtk_eth_soc.h   | 328 +++++++--
 6 files changed, 1037 insertions(+), 245 deletions(-)

-- 
2.35.3

