Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB0D93F7FD2
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 03:25:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236473AbhHZB0C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 21:26:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236264AbhHZB0A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Aug 2021 21:26:00 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 033F8C061757
        for <netdev@vger.kernel.org>; Wed, 25 Aug 2021 18:25:14 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id om1-20020a17090b3a8100b0017941c44ce4so5382406pjb.3
        for <netdev@vger.kernel.org>; Wed, 25 Aug 2021 18:25:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=fQezromumKGqEMRX5hPd02ISfkZNUOevzjCMA0JA6qU=;
        b=WE48fF+xmSn2Chlh9WwujaTCPq99rSAxuGDWuj7lfMW2h5DrUTQDOxpz5lyzR79971
         jZasekmCEdxWQ8zq12Rucq4kGzw0RA8zQ6ahwAyeVbSlwdUNLLvjg5T+yb2QmWCtrTcE
         SW/7htWMV4PBv9CGnZtvcKoKkoJLiMkHCvn+lsfOWq4Ch1gC013JyZsI3XJtxNl/NhVJ
         0kQNmLcvzy336NJLKFNL6tJTE1yYcFjaorDcuiW3fpUFSPHVkdAodbKBepMOrfAxte0C
         ig8V3cXXdgz7REzn5zYZva98efhyHHPKGJzyCyNh1OpHdohJq2oExj09XLWF3wGgzez/
         kBgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=fQezromumKGqEMRX5hPd02ISfkZNUOevzjCMA0JA6qU=;
        b=TWufJkIYNilCfU72gMqxZjKvMCJRK6HwVk2+auOPVSRPVaMFCflbfLVMVqTMbGQ5bu
         OKQBBHG+CxKmavoKwbEtjlmTNmAbKHvlKi4oxdoXbRElm3yobRJulW1vYDSY1VTtgCmq
         yFKn/UX5d0briRFya6utIJpQmaZVojtmwsbjbS5bs/2MuDII/vsjjnLxlIVQthzoTNkk
         2FqnSCbkeHDXAMG/Qs8FUTwA9j3YaUdZHbDgezLwmWAvMI70KqxrpB/nWAYMyCd2rXov
         OL8SLJ7yJsYbfgf1HfUfT8b+lHM/w6BzYZ+DntWc5q5yhmlYx8n68X1vwqZXnAeUT7wW
         MitQ==
X-Gm-Message-State: AOAM532ZAfZqacd0lNfbV8liCsY0dQprwjAOlPWYnUq0AT3ka4taCn/m
        HkbmR8lDj3GpLgqN8itwVr1+EA==
X-Google-Smtp-Source: ABdhPJzHGJXh+plm5BokrX9h5x2X5gfe43FMgvOHF/HKRE1+I5Ef4pkMjFqIcnyPTar9wTTwWd/jDA==
X-Received: by 2002:a17:90a:c481:: with SMTP id j1mr1264278pjt.164.1629941113537;
        Wed, 25 Aug 2021 18:25:13 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id h13sm1113458pgh.93.2021.08.25.18.25.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Aug 2021 18:25:13 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Cc:     drivers@pensando.io, jtoppins@redhat.com,
        Shannon Nelson <snelson@pensando.io>
Subject: [PATCH 6/6] filter-debug
Date:   Wed, 25 Aug 2021 18:24:51 -0700
Message-Id: <20210826012451.54456-7-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210826012451.54456-1-snelson@pensando.io>
References: <20210826012451.54456-1-snelson@pensando.io>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 .../ethernet/pensando/ionic/ionic_ethtool.c   |  2 ++
 .../net/ethernet/pensando/ionic/ionic_lif.c   |  6 +++++
 .../ethernet/pensando/ionic/ionic_rx_filter.c | 27 +++++++++++++++++++
 .../ethernet/pensando/ionic/ionic_rx_filter.h |  1 +
 4 files changed, 36 insertions(+)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c b/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
index adc9fdb03e86..61b4b1772eb2 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
@@ -687,6 +687,8 @@ static u32 ionic_get_priv_flags(struct net_device *netdev)
 	struct ionic_lif *lif = netdev_priv(netdev);
 	u32 priv_flags = 0;
 
+	ionic_rx_filter_dump(lif);
+
 	if (test_bit(IONIC_LIF_F_SW_DEBUG_STATS, lif->state))
 		priv_flags |= IONIC_PRIV_F_SW_DBG_STATS;
 
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index 77394135d1cd..202155c866fe 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -1261,6 +1261,7 @@ int ionic_lif_addr_add(struct ionic_lif *lif, const u8 *addr)
 	struct ionic_rx_filter *f;
 	int err = 0;
 
+dev_info(lif->ionic->dev, "%s: addr %pM mc %d\n", __func__, addr, mc);
 	spin_lock_bh(&lif->rx_filters.lock);
 	f = ionic_rx_filter_by_addr(lif, addr);
 	if (f) {
@@ -1345,6 +1346,7 @@ int ionic_lif_addr_del(struct ionic_lif *lif, const u8 *addr)
 	int state;
 	int err;
 
+dev_info(lif->ionic->dev, "%s: addr %pM\n", __func__, addr);
 	spin_lock_bh(&lif->rx_filters.lock);
 	f = ionic_rx_filter_by_addr(lif, addr);
 	if (!f) {
@@ -1419,9 +1421,11 @@ void ionic_lif_rx_mode(struct ionic_lif *lif)
 	if ((lif->nucast + lif->nmcast) >= nfilters) {
 		rx_mode |= IONIC_RX_MODE_F_PROMISC;
 		rx_mode |= IONIC_RX_MODE_F_ALLMULTI;
+if (!lif->uc_overflow) dev_info(lif->ionic->dev, "%s: uc_overflow toggled to true\n", __func__);
 		lif->uc_overflow = true;
 		lif->mc_overflow = true;
 	} else if (lif->uc_overflow) {
+if (lif->uc_overflow) dev_info(lif->ionic->dev, "%s: uc_overflow toggled to false\n", __func__);
 		lif->uc_overflow = false;
 		lif->mc_overflow = false;
 		if (!(nd_flags & IFF_PROMISC))
@@ -1701,6 +1705,7 @@ static int ionic_set_mac_address(struct net_device *netdev, void *sa)
 	if (ether_addr_equal(netdev->dev_addr, mac))
 		return 0;
 
+netdev_info(netdev, "%s: mac %pM\n", __func__, mac);
 	err = eth_prepare_mac_addr_change(netdev, addr);
 	if (err)
 		return err;
@@ -3200,6 +3205,7 @@ static int ionic_station_set(struct ionic_lif *lif)
 	struct sockaddr addr;
 	int err;
 
+dev_info(lif->ionic->dev, "%s: netdev addr %pM\n", __func__, netdev->dev_addr);
 	err = ionic_adminq_post_wait(lif, &ctx);
 	if (err)
 		return err;
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_rx_filter.c b/drivers/net/ethernet/pensando/ionic/ionic_rx_filter.c
index 7e3a5634c161..ba0cbf487fd6 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_rx_filter.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_rx_filter.c
@@ -244,6 +244,7 @@ int ionic_lif_list_addr(struct ionic_lif *lif, const u8 *addr, bool mode)
 	struct ionic_rx_filter *f;
 	int err;
 
+dev_info(lif->ionic->dev, "%s: addr %pM mode %d\n", __func__, addr, mode);
 	spin_lock_bh(&lif->rx_filters.lock);
 
 	f = ionic_rx_filter_by_addr(lif, addr);
@@ -349,6 +350,7 @@ void ionic_rx_filter_sync(struct ionic_lif *lif)
 	list_for_each_entry_safe(sync_item, spos, &sync_add_list, list) {
 		(void)ionic_lif_addr_add(lif, sync_item->f.cmd.mac.addr);
 
+dev_info(lif->ionic->dev, "%s: sync addr %pM state %d\n", __func__, sync_item->f.cmd.mac.addr, sync_item->f.state);
 		if (sync_item->f.state != IONIC_FILTER_STATE_SYNCED)
 			set_bit(IONIC_LIF_F_FILTER_SYNC_NEEDED, lif->state);
 
@@ -356,3 +358,28 @@ void ionic_rx_filter_sync(struct ionic_lif *lif)
 		devm_kfree(dev, sync_item);
 	}
 }
+
+void ionic_rx_filter_dump(struct ionic_lif *lif)
+{
+	struct device *dev = lif->ionic->dev;
+	struct ionic_rx_filter *f;
+	struct hlist_head *head;
+	struct hlist_node *tmp;
+	unsigned int i;
+
+	spin_lock_bh(&lif->rx_filters.lock);
+	for (i = 0; i < IONIC_RX_FILTER_HLISTS; i++) {
+		head = &lif->rx_filters.by_id[i];
+		hlist_for_each_entry_safe(f, tmp, head, by_id) {
+			dev_info(dev, "%s: mac %pM flow %d filter_id %d state %d rxq %d\n",
+				 __func__, f->cmd.mac.addr, f->flow_id, f->filter_id, f->state, f->rxq_index);
+
+		}
+	}
+	spin_unlock_bh(&lif->rx_filters.lock);
+
+	dev_info(dev, "%s: nucast %d nmcast %d\n",
+		 __func__, lif->nucast, lif->nmcast);
+	dev_info(dev, "%s: netdev_uc_count %d netdev_mc_count %d\n",
+		 __func__, netdev_uc_count(lif->netdev), netdev_mc_count(lif->netdev));
+}
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_rx_filter.h b/drivers/net/ethernet/pensando/ionic/ionic_rx_filter.h
index a66e35f0833b..8a0b5460510f 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_rx_filter.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_rx_filter.h
@@ -45,4 +45,5 @@ void ionic_rx_filter_sync(struct ionic_lif *lif);
 int ionic_lif_list_addr(struct ionic_lif *lif, const u8 *addr, bool mode);
 int ionic_rx_filters_need_sync(struct ionic_lif *lif);
 
+void ionic_rx_filter_dump(struct ionic_lif *lif);
 #endif /* _IONIC_RX_FILTER_H_ */
-- 
2.17.1

