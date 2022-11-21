Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED833631C38
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 10:00:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229951AbiKUJAG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 04:00:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229829AbiKUJAC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 04:00:02 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DCD0DF95
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 01:00:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ADB5F60F2C
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 09:00:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9113C433D6;
        Mon, 21 Nov 2022 08:59:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669021200;
        bh=MVcO3ogxAd/KcHMWx684Sc9JzdpDv0NfQ0bb44ZRPKg=;
        h=From:To:Cc:Subject:Date:From;
        b=ZZTwf31oNK+xdYrwCPNbeKvC0eaT9ZD3bbg9uBgWiLmXj+1GnJ6UTicTUo+WACi0D
         +NCp73Tp9VxmOjYCxod0kZ8L1BxvD26X1qXALYTcUm3yoQ2mzym+4Y/y8CkCYkNJYL
         jpSeAhIXDBhbpqVMtsic7vfa8q7N/v2kPYvS7keMNaKnF/OnJ1gwIMQi9tM2O6ynjY
         T3C3vrPArSuVP+hBXnV4VJQazW+1yPBen9qB+X/2Qw9qqcf3+3iFTlNC5DKXKZfmOZ
         ft1J81CS+HSv9nO2SYRFoem+k/iKgf/wTRawP3iPWvWqhPndevcT2dYY/6KQa3CpPV
         qPaWPDGwNxWGA==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     nbd@nbd.name, john@phrozen.org, sean.wang@mediatek.com,
        Mark-MC.Lee@mediatek.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, lorenzo.bianconi@redhat.com,
        sujuan.chen@mediatek.com, linux-mediatek@lists.infradead.org
Subject: [PATCH net-next 0/5] refactor mtk_wed code to introduce SER support
Date:   Mon, 21 Nov 2022 09:59:20 +0100
Message-Id: <cover.1669020847.git.lorenzo@kernel.org>
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

