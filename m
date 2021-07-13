Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E9B63C73D7
	for <lists+netdev@lfdr.de>; Tue, 13 Jul 2021 18:08:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230120AbhGMQKv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Jul 2021 12:10:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229615AbhGMQKm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Jul 2021 12:10:42 -0400
Received: from nbd.name (nbd.name [IPv6:2a01:4f8:221:3d45::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4BABC061787;
        Tue, 13 Jul 2021 09:07:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=kALmQlVD1mXKtMl6SNLC4u0N8cLUAa7AgdTZMgUMrik=; b=HO7dvPiFO7OIlF4z8ZZnmKEnme
        xCwubAKsnJBXSBeu6kuwOxtRWa3LwtkKTocdOszdXp+zKXYvfSEQ+Qpd7cAI8BLCTVVUyT4DAsgDz
        fmsTF5GD8hi4LHqx1ZC4UyVL0lAb+nlO284OY0cONHa+624Y8fnm70+Fr60sJ2/vHKLw=;
Received: from p54ae93f7.dip0.t-ipconnect.de ([84.174.147.247] helo=localhost.localdomain)
        by ds12 with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <nbd@nbd.name>)
        id 1m3Kwn-0008TX-Ox; Tue, 13 Jul 2021 18:07:49 +0200
From:   Felix Fietkau <nbd@nbd.name>
To:     linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, pablo@netfilter.org, ryder.lee@mediatek.com
Subject: [RFC 6/7] mt76: mt7915: remove irq parameter from mt7915_mmio_init
Date:   Tue, 13 Jul 2021 18:07:44 +0200
Message-Id: <20210713160745.59707-7-nbd@nbd.name>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210713160745.59707-1-nbd@nbd.name>
References: <20210713160745.59707-1-nbd@nbd.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It is unused

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/mt7915/mmio.c   | 2 +-
 drivers/net/wireless/mediatek/mt76/mt7915/mt7915.h | 2 +-
 drivers/net/wireless/mediatek/mt76/mt7915/pci.c    | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/mmio.c b/drivers/net/wireless/mediatek/mt76/mt7915/mmio.c
index af712a936ef6..45b277618ef6 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mmio.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mmio.c
@@ -123,7 +123,7 @@ static u32 mt7915_rmw(struct mt76_dev *mdev, u32 offset, u32 mask, u32 val)
 	return dev->bus_ops->rmw(mdev, addr, mask, val);
 }
 
-int mt7915_mmio_init(struct mt76_dev *mdev, void __iomem *mem_base, int irq)
+int mt7915_mmio_init(struct mt76_dev *mdev, void __iomem *mem_base)
 {
 	struct mt76_bus_ops *bus_ops;
 	struct mt7915_dev *dev;
diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/mt7915.h b/drivers/net/wireless/mediatek/mt76/mt7915/mt7915.h
index 3f613fae6218..0652b711ae81 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mt7915.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mt7915.h
@@ -418,7 +418,7 @@ void mt7915_mac_sta_remove(struct mt76_dev *mdev, struct ieee80211_vif *vif,
 void mt7915_mac_work(struct work_struct *work);
 void mt7915_mac_reset_work(struct work_struct *work);
 void mt7915_mac_sta_rc_work(struct work_struct *work);
-int mt7915_mmio_init(struct mt76_dev *mdev, void __iomem *mem_base, int irq);
+int mt7915_mmio_init(struct mt76_dev *mdev, void __iomem *mem_base);
 int mt7915_tx_prepare_skb(struct mt76_dev *mdev, void *txwi_ptr,
 			  enum mt76_txq_id qid, struct mt76_wcid *wcid,
 			  struct ieee80211_sta *sta,
diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/pci.c b/drivers/net/wireless/mediatek/mt76/mt7915/pci.c
index 340b364da5f0..5e93620195da 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/pci.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/pci.c
@@ -271,7 +271,7 @@ static int mt7915_pci_probe(struct pci_dev *pdev,
 	if (ret < 0)
 		goto free;
 
-	ret = mt7915_mmio_init(mdev, pcim_iomap_table(pdev)[0], pdev->irq);
+	ret = mt7915_mmio_init(mdev, pcim_iomap_table(pdev)[0]);
 	if (ret)
 		goto error;
 
-- 
2.30.1

