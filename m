Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C3EB65B43F
	for <lists+netdev@lfdr.de>; Mon,  2 Jan 2023 16:32:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236204AbjABPcc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Jan 2023 10:32:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232479AbjABPca (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Jan 2023 10:32:30 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFF6ECEE
        for <netdev@vger.kernel.org>; Mon,  2 Jan 2023 07:32:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 64F456100B
        for <netdev@vger.kernel.org>; Mon,  2 Jan 2023 15:32:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A981C433D2;
        Mon,  2 Jan 2023 15:32:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672673548;
        bh=qwZ1aPuHjR7DPDi2JQbPGAuQE2P3o1AtyNZJiGrHJZA=;
        h=From:To:Cc:Subject:Date:From;
        b=C4U5HJoliwpVpCx39eOZmghqWo2p79j4f1JvOSZXkT79OfKxFj+dDKoVNldyxffYl
         PUdMqiLuAXZkWhHgcICFa1A5aQ675IsL3IJZL2JGIDccwDFVAVRKjoDw9mVG6vRml/
         cx8Qs+sJoVJ73uI84ATxgQOQtaFgflQGgKaQzQD4k1+H5uDbemTAzxUEVTQAF6FKqz
         ecqP5vcWaJ/xyi6yKe1qGRghFUQ28ghpUfyqwgP9rmoPNMfjALTpQ3338DMDv31p4L
         U8EFJuUebgeRGqCSTnGA5lcmQsUi434QRbh9uJJf4Q1f2Nx2nkOvGJhLtrDAbCKFB8
         hmww4YjslfPZw==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, lorenzo.bianconi@redhat.com, nbd@nbd.name,
        john@phrozen.org, sean.wang@mediatek.com, Mark-MC.Lee@mediatek.com,
        sujuan.chen@mediatek.com, daniel@makrotopia.org
Subject: [PATCH net-next 0/5] net: ethernet: mtk_wed: introduce reset support
Date:   Mon,  2 Jan 2023 16:32:14 +0100
Message-Id: <cover.1672672965.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.39.0
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

Introduce proper reset integration between ethernet and wlan drivers in order
to schedule wlan driver reset when ethernet/wed driver is resetting.
Introduce mtk_hw_reset_monitor work in order to detect possible DMA hangs.

Lorenzo Bianconi (5):
  net: ethernet: mtk_eth_soc: introduce mtk_hw_reset utility routine
  net: ethernet: mtk_eth_soc: introduce mtk_hw_warm_reset support
  net: ethernet: mtk_eth_soc: align reset procedure to vendor sdk
  net: ethernet: mtk_eth_soc: add dma checks to mtk_hw_reset_check
  net: ethernet: mtk_wed: add reset/reset_complete callbacks

 drivers/net/ethernet/mediatek/mtk_eth_soc.c  | 288 ++++++++++++++++---
 drivers/net/ethernet/mediatek/mtk_eth_soc.h  |  38 +++
 drivers/net/ethernet/mediatek/mtk_ppe.c      |  27 ++
 drivers/net/ethernet/mediatek/mtk_ppe.h      |   1 +
 drivers/net/ethernet/mediatek/mtk_ppe_regs.h |   6 +
 drivers/net/ethernet/mediatek/mtk_wed.c      |  40 +++
 drivers/net/ethernet/mediatek/mtk_wed.h      |   8 +
 include/linux/soc/mediatek/mtk_wed.h         |   2 +
 8 files changed, 369 insertions(+), 41 deletions(-)

-- 
2.39.0

