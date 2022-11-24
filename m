Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB80E637CDA
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 16:23:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229615AbiKXPXL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Nov 2022 10:23:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229706AbiKXPXJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 10:23:09 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 787A1112A
        for <netdev@vger.kernel.org>; Thu, 24 Nov 2022 07:23:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 08A24B8284D
        for <netdev@vger.kernel.org>; Thu, 24 Nov 2022 15:23:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34022C433C1;
        Thu, 24 Nov 2022 15:23:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669303385;
        bh=gRYYTAEJr3fe2c9lFj3Q9D4ENhny0lOxwI/+OWY2074=;
        h=From:To:Cc:Subject:Date:From;
        b=G5P5s7hdRx9Adzn6NlYklNr5jJ+qnIe/FNwXbMRydzZssykK5oBLnoPcBnjU+3Jhq
         B7eufUKVB8Lt1K5Ov5iEeFoj174Yw0fbnMo+VLqQe67AQBYjBj4RjPSXAchQMxtgMo
         r8V0g6ZKs5zKYVpU6czQicLVqTlBQbwqdnKvY4Mb64DTSqndRWn3S0mR8+YzUby2ur
         ShV0O98K1nS15xdTRHGwTrMnVAt8qQ8bl90utbVuVnuTxzl4K9tzPSgLoYcIUVC3GR
         oCqMTL6tlzHrBND1mKCJkaUlyslOJ6SN0GdRm9PCMytk//Clj27cynLWMMD8V6m2VX
         yZuv8cBIiEXSw==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     nbd@nbd.name, john@phrozen.org, sean.wang@mediatek.com,
        Mark-MC.Lee@mediatek.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, lorenzo.bianconi@redhat.com,
        sujuan.chen@mediatek.com, linux-mediatek@lists.infradead.org
Subject: [PATCH v2 net-next 0/5] refactor mtk_wed code to introduce SER support
Date:   Thu, 24 Nov 2022 16:22:50 +0100
Message-Id: <cover.1669303154.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Refactor mtk_wed support in order to introduce proper integration for hw reset
between mtk_eth_soc/mtk_wed and mt76 drivers.

Changes since v1:
- improve commit logs

Lorenzo Bianconi (5):
  net: ethernet: mtk_wed: return status value in mtk_wdma_rx_reset
  net: ethernet: mtk_wed: move MTK_WDMA_RESET_IDX_TX configuration in
    mtk_wdma_tx_reset
  net: ethernet: mtk_wed: update mtk_wed_stop
  net: ethernet: mtk_wed: add mtk_wed_rx_reset routine
  net: ethernet: mtk_wed: add reset to tx_ring_setup callback

 drivers/net/ethernet/mediatek/mtk_wed.c      | 279 ++++++++++++++-----
 drivers/net/ethernet/mediatek/mtk_wed_regs.h |   9 +
 drivers/net/wireless/mediatek/mt76/dma.c     |   2 +-
 include/linux/soc/mediatek/mtk_wed.h         |  12 +-
 4 files changed, 220 insertions(+), 82 deletions(-)

-- 
2.38.1

