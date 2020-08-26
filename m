Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44E3A25351E
	for <lists+netdev@lfdr.de>; Wed, 26 Aug 2020 18:43:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727863AbgHZQm6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Aug 2020 12:42:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728005AbgHZQm1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Aug 2020 12:42:27 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DEF9C0613ED
        for <netdev@vger.kernel.org>; Wed, 26 Aug 2020 09:42:27 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id g33so1320888pgb.4
        for <netdev@vger.kernel.org>; Wed, 26 Aug 2020 09:42:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=R/ib6Ww1+kDrDThZznQQ5PG5P20/sGy3hQifxbMCpwI=;
        b=otmH89k+uki+rkxLLYXH0IZWr8i+nK1NpLrt0vnfX6WIhZwY1qa7LOqqtdgFV5EOS4
         yXvaC8v2z7AabGqek5Mw6cjHkSZ2P0LjMXHVbAKrJ1DXjQKkoYx3KWmZtOvRe6ZlYwJj
         2TwSps2YLgjPeaKFulRrkq5vS13GOwQgy2NGZ/4Agr6/5qxltlVYp6Jg3E196ck/oYYR
         hf1k7D8Jp6GJy2muforrfAbwJSJ/OQTOC7CzgoUXAgrcMhh4yFREW3GBtgAKC+h2HqD1
         Z9ncyJLPDoykpMoJ0V5OcxLVR+OmwsBv6rZeVxBqnj0AlCL5lOwKCxOw+SYBq0CxBDiu
         dp9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=R/ib6Ww1+kDrDThZznQQ5PG5P20/sGy3hQifxbMCpwI=;
        b=NXwJgCsFJS2e0VxeGDC1EUz0sKgf5y039Wkd3W3a9m6+ryC943Kru72T7Tr02sk4h+
         igNZtrSPTHKtHHym69Eohj6NYNu4cXCNS7ZFAzzLKgUEiAUILkxuGsvj5Y9vFqT3zm1W
         q0FM4HDrNpJUB0BSBOWOSoYIfNuzbaDS+nrazOYmRNBbMfQrdKry2bo3Xfhh942ddUqx
         jYgx+jiXcMfPGdhAqzN+gdvEO0T4cJBJNChdIfN+DDCSkvp1rJcvCcSp6pV7hkgjE4xL
         Gnpy+6/a/h6HD+PqHzREJa3dWhpWolflfj14/XObCsMgF7efpQmvuT/oG0yTDaMeb3XD
         FHSw==
X-Gm-Message-State: AOAM533gRi3q9/Eqs3pch60mDhk4gfyRy5zTqmZ8mfJW/KwjhsuLFJTe
        BmXJbsVKXJM9bOLf4+Erhi5XjcjEpu3zFg==
X-Google-Smtp-Source: ABdhPJwl8HBoTsZ3C+SatpQ6VhTH5SXxMRxdQ54gXZ3P9yl8n4bAsGgHxM49D5vaS1EU5Tlohvi5Qg==
X-Received: by 2002:a65:45ca:: with SMTP id m10mr4966190pgr.187.1598460146204;
        Wed, 26 Aug 2020 09:42:26 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id h193sm2986052pgc.42.2020.08.26.09.42.25
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 26 Aug 2020 09:42:25 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net-next 04/12] ionic: remove lif list concept
Date:   Wed, 26 Aug 2020 09:42:06 -0700
Message-Id: <20200826164214.31792-5-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200826164214.31792-1-snelson@pensando.io>
References: <20200826164214.31792-1-snelson@pensando.io>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As we aren't yet supporting multiple lifs, we can remove
complexity by removing the list concept and related code,
to be re-engineered later when actually needed.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 drivers/net/ethernet/pensando/ionic/ionic.h   |   4 +-
 .../ethernet/pensando/ionic/ionic_bus_pci.c   |  32 +++--
 .../net/ethernet/pensando/ionic/ionic_dev.c   |   6 +-
 .../ethernet/pensando/ionic/ionic_devlink.c   |   2 +-
 .../net/ethernet/pensando/ionic/ionic_lif.c   | 131 +++++-------------
 .../net/ethernet/pensando/ionic/ionic_lif.h   |  14 +-
 6 files changed, 62 insertions(+), 127 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic.h b/drivers/net/ethernet/pensando/ionic/ionic.h
index f5a910c458ba..f699ed19eb4f 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic.h
@@ -42,13 +42,11 @@ struct ionic {
 	struct ionic_dev_bar bars[IONIC_BARS_MAX];
 	unsigned int num_bars;
 	struct ionic_identity ident;
-	struct list_head lifs;
-	struct ionic_lif *master_lif;
+	struct ionic_lif *lif;
 	unsigned int nnqs_per_lif;
 	unsigned int neqs_per_lif;
 	unsigned int ntxqs_per_lif;
 	unsigned int nrxqs_per_lif;
-	DECLARE_BITMAP(lifbits, IONIC_LIFS_MAX);
 	unsigned int nintrs;
 	DECLARE_BITMAP(intrs, IONIC_INTR_CTRL_REGS_MAX);
 	struct work_struct nb_work;
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c b/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
index 85c686c16741..d1d6fb6669e5 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
@@ -294,21 +294,21 @@ static int ionic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		goto err_out_port_reset;
 	}
 
-	err = ionic_lifs_size(ionic);
+	err = ionic_lif_size(ionic);
 	if (err) {
-		dev_err(dev, "Cannot size LIFs: %d, aborting\n", err);
+		dev_err(dev, "Cannot size LIF: %d, aborting\n", err);
 		goto err_out_port_reset;
 	}
 
-	err = ionic_lifs_alloc(ionic);
+	err = ionic_lif_alloc(ionic);
 	if (err) {
-		dev_err(dev, "Cannot allocate LIFs: %d, aborting\n", err);
+		dev_err(dev, "Cannot allocate LIF: %d, aborting\n", err);
 		goto err_out_free_irqs;
 	}
 
-	err = ionic_lifs_init(ionic);
+	err = ionic_lif_init(ionic->lif);
 	if (err) {
-		dev_err(dev, "Cannot init LIFs: %d, aborting\n", err);
+		dev_err(dev, "Cannot init LIF: %d, aborting\n", err);
 		goto err_out_free_lifs;
 	}
 
@@ -321,9 +321,9 @@ static int ionic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 			dev_err(dev, "Cannot enable existing VFs: %d\n", err);
 	}
 
-	err = ionic_lifs_register(ionic);
+	err = ionic_lif_register(ionic->lif);
 	if (err) {
-		dev_err(dev, "Cannot register LIFs: %d, aborting\n", err);
+		dev_err(dev, "Cannot register LIF: %d, aborting\n", err);
 		goto err_out_deinit_lifs;
 	}
 
@@ -336,12 +336,13 @@ static int ionic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	return 0;
 
 err_out_deregister_lifs:
-	ionic_lifs_unregister(ionic);
+	ionic_lif_unregister(ionic->lif);
 err_out_deinit_lifs:
 	ionic_vf_dealloc(ionic);
-	ionic_lifs_deinit(ionic);
+	ionic_lif_deinit(ionic->lif);
 err_out_free_lifs:
-	ionic_lifs_free(ionic);
+	ionic_lif_free(ionic->lif);
+	ionic->lif = NULL;
 err_out_free_irqs:
 	ionic_bus_free_irq_vectors(ionic);
 err_out_port_reset:
@@ -377,11 +378,12 @@ static void ionic_remove(struct pci_dev *pdev)
 	if (!ionic)
 		return;
 
-	if (ionic->master_lif) {
+	if (ionic->lif) {
 		ionic_devlink_unregister(ionic);
-		ionic_lifs_unregister(ionic);
-		ionic_lifs_deinit(ionic);
-		ionic_lifs_free(ionic);
+		ionic_lif_unregister(ionic->lif);
+		ionic_lif_deinit(ionic->lif);
+		ionic_lif_free(ionic->lif);
+		ionic->lif = NULL;
 		ionic_bus_free_irq_vectors(ionic);
 	}
 
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_dev.c b/drivers/net/ethernet/pensando/ionic/ionic_dev.c
index d83eff0ae0ac..25cf376f3b40 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_dev.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_dev.c
@@ -21,8 +21,8 @@ static void ionic_watchdog_cb(struct timer_list *t)
 
 	hb = ionic_heartbeat_check(ionic);
 
-	if (hb >= 0 && ionic->master_lif)
-		ionic_link_status_check_request(ionic->master_lif);
+	if (hb >= 0 && ionic->lif)
+		ionic_link_status_check_request(ionic->lif);
 }
 
 void ionic_init_devinfo(struct ionic *ionic)
@@ -126,7 +126,7 @@ int ionic_heartbeat_check(struct ionic *ionic)
 	/* is this a transition? */
 	if (fw_status != idev->last_fw_status &&
 	    idev->last_fw_status != 0xff) {
-		struct ionic_lif *lif = ionic->master_lif;
+		struct ionic_lif *lif = ionic->lif;
 		bool trigger = false;
 
 		if (!fw_status || fw_status == 0xff) {
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_devlink.c b/drivers/net/ethernet/pensando/ionic/ionic_devlink.c
index c4f4fd469fe3..8d9fb2e19cca 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_devlink.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_devlink.c
@@ -85,7 +85,7 @@ int ionic_devlink_register(struct ionic *ionic)
 		dev_err(ionic->dev, "devlink_port_register failed: %d\n", err);
 	else
 		devlink_port_type_eth_set(&ionic->dl_port,
-					  ionic->master_lif->netdev);
+					  ionic->lif->netdev);
 
 	return err;
 }
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index d73beddc30cc..de9da16db3a8 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -2045,7 +2045,7 @@ int ionic_reset_queues(struct ionic_lif *lif, ionic_reset_cb cb, void *arg)
 	return err;
 }
 
-static struct ionic_lif *ionic_lif_alloc(struct ionic *ionic, unsigned int index)
+int ionic_lif_alloc(struct ionic *ionic)
 {
 	struct device *dev = ionic->dev;
 	union ionic_lif_identity *lid;
@@ -2056,7 +2056,7 @@ static struct ionic_lif *ionic_lif_alloc(struct ionic *ionic, unsigned int index
 
 	lid = kzalloc(sizeof(*lid), GFP_KERNEL);
 	if (!lid)
-		return ERR_PTR(-ENOMEM);
+		return -ENOMEM;
 
 	netdev = alloc_etherdev_mqs(sizeof(*lif),
 				    ionic->ntxqs_per_lif, ionic->ntxqs_per_lif);
@@ -2070,7 +2070,7 @@ static struct ionic_lif *ionic_lif_alloc(struct ionic *ionic, unsigned int index
 
 	lif = netdev_priv(netdev);
 	lif->netdev = netdev;
-	ionic->master_lif = lif;
+	ionic->lif = lif;
 	netdev->netdev_ops = &ionic_netdev_ops;
 	ionic_ethtool_set_ops(netdev);
 
@@ -2089,7 +2089,7 @@ static struct ionic_lif *ionic_lif_alloc(struct ionic *ionic, unsigned int index
 	lif->nxqs = ionic->ntxqs_per_lif;
 
 	lif->ionic = ionic;
-	lif->index = index;
+	lif->index = 0;
 	lif->ntxq_descs = IONIC_DEF_TXRX_DESC;
 	lif->nrxq_descs = IONIC_DEF_TXRX_DESC;
 	lif->tx_budget = IONIC_TX_BUDGET_DEFAULT;
@@ -2101,7 +2101,7 @@ static struct ionic_lif *ionic_lif_alloc(struct ionic *ionic, unsigned int index
 	lif->tx_coalesce_usecs = lif->rx_coalesce_usecs;
 	lif->tx_coalesce_hw = lif->rx_coalesce_hw;
 
-	snprintf(lif->name, sizeof(lif->name), "lif%u", index);
+	snprintf(lif->name, sizeof(lif->name), "lif%u", lif->index);
 
 	spin_lock_init(&lif->adminq_lock);
 
@@ -2121,7 +2121,8 @@ static struct ionic_lif *ionic_lif_alloc(struct ionic *ionic, unsigned int index
 
 	ionic_debugfs_add_lif(lif);
 
-	/* allocate queues */
+	/* allocate control queues and txrx queue arrays */
+	ionic_lif_queue_identify(lif);
 	err = ionic_qcqs_alloc(lif);
 	if (err)
 		goto err_out_free_lif_info;
@@ -2140,9 +2141,7 @@ static struct ionic_lif *ionic_lif_alloc(struct ionic *ionic, unsigned int index
 	}
 	netdev_rss_key_fill(lif->rss_hash_key, IONIC_RSS_HASH_KEY_SIZE);
 
-	list_add_tail(&lif->list, &ionic->lifs);
-
-	return lif;
+	return 0;
 
 err_out_free_qcqs:
 	ionic_qcqs_free(lif);
@@ -2156,27 +2155,7 @@ static struct ionic_lif *ionic_lif_alloc(struct ionic *ionic, unsigned int index
 err_out_free_lid:
 	kfree(lid);
 
-	return ERR_PTR(err);
-}
-
-int ionic_lifs_alloc(struct ionic *ionic)
-{
-	struct ionic_lif *lif;
-
-	INIT_LIST_HEAD(&ionic->lifs);
-
-	/* only build the first lif, others are for later features */
-	set_bit(0, ionic->lifbits);
-
-	lif = ionic_lif_alloc(ionic, 0);
-	if (IS_ERR_OR_NULL(lif)) {
-		clear_bit(0, ionic->lifbits);
-		return -ENOMEM;
-	}
-
-	ionic_lif_queue_identify(lif);
-
-	return 0;
+	return err;
 }
 
 static void ionic_lif_reset(struct ionic_lif *lif)
@@ -2211,7 +2190,7 @@ static void ionic_lif_handle_fw_down(struct ionic_lif *lif)
 		ionic_txrx_deinit(lif);
 		ionic_txrx_free(lif);
 	}
-	ionic_lifs_deinit(ionic);
+	ionic_lif_deinit(lif);
 	ionic_reset(ionic);
 	ionic_qcqs_free(lif);
 
@@ -2234,7 +2213,7 @@ static void ionic_lif_handle_fw_up(struct ionic_lif *lif)
 	if (err)
 		goto err_out;
 
-	err = ionic_lifs_init(ionic);
+	err = ionic_lif_init(lif);
 	if (err)
 		goto err_qcqs_free;
 
@@ -2263,14 +2242,14 @@ static void ionic_lif_handle_fw_up(struct ionic_lif *lif)
 err_txrx_free:
 	ionic_txrx_free(lif);
 err_lifs_deinit:
-	ionic_lifs_deinit(ionic);
+	ionic_lif_deinit(lif);
 err_qcqs_free:
 	ionic_qcqs_free(lif);
 err_out:
 	dev_err(ionic->dev, "FW Up: LIFs restart failed - err %d\n", err);
 }
 
-static void ionic_lif_free(struct ionic_lif *lif)
+void ionic_lif_free(struct ionic_lif *lif)
 {
 	struct device *dev = lif->ionic->dev;
 
@@ -2299,23 +2278,10 @@ static void ionic_lif_free(struct ionic_lif *lif)
 
 	/* free netdev & lif */
 	ionic_debugfs_del_lif(lif);
-	list_del(&lif->list);
 	free_netdev(lif->netdev);
 }
 
-void ionic_lifs_free(struct ionic *ionic)
-{
-	struct list_head *cur, *tmp;
-	struct ionic_lif *lif;
-
-	list_for_each_safe(cur, tmp, &ionic->lifs) {
-		lif = list_entry(cur, struct ionic_lif, list);
-
-		ionic_lif_free(lif);
-	}
-}
-
-static void ionic_lif_deinit(struct ionic_lif *lif)
+void ionic_lif_deinit(struct ionic_lif *lif)
 {
 	if (!test_and_clear_bit(IONIC_LIF_F_INITED, lif->state))
 		return;
@@ -2336,17 +2302,6 @@ static void ionic_lif_deinit(struct ionic_lif *lif)
 	ionic_lif_reset(lif);
 }
 
-void ionic_lifs_deinit(struct ionic *ionic)
-{
-	struct list_head *cur, *tmp;
-	struct ionic_lif *lif;
-
-	list_for_each_safe(cur, tmp, &ionic->lifs) {
-		lif = list_entry(cur, struct ionic_lif, list);
-		ionic_lif_deinit(lif);
-	}
-}
-
 static int ionic_lif_adminq_init(struct ionic_lif *lif)
 {
 	struct device *dev = lif->ionic->dev;
@@ -2492,7 +2447,7 @@ static int ionic_station_set(struct ionic_lif *lif)
 	return 0;
 }
 
-static int ionic_lif_init(struct ionic_lif *lif)
+int ionic_lif_init(struct ionic_lif *lif)
 {
 	struct ionic_dev *idev = &lif->ionic->idev;
 	struct device *dev = lif->ionic->dev;
@@ -2582,22 +2537,6 @@ static int ionic_lif_init(struct ionic_lif *lif)
 	return err;
 }
 
-int ionic_lifs_init(struct ionic *ionic)
-{
-	struct list_head *cur, *tmp;
-	struct ionic_lif *lif;
-	int err;
-
-	list_for_each_safe(cur, tmp, &ionic->lifs) {
-		lif = list_entry(cur, struct ionic_lif, list);
-		err = ionic_lif_init(lif);
-		if (err)
-			return err;
-	}
-
-	return 0;
-}
-
 static void ionic_lif_notify_work(struct work_struct *ws)
 {
 }
@@ -2646,45 +2585,41 @@ static int ionic_lif_notify(struct notifier_block *nb,
 	return NOTIFY_DONE;
 }
 
-int ionic_lifs_register(struct ionic *ionic)
+int ionic_lif_register(struct ionic_lif *lif)
 {
 	int err;
 
-	INIT_WORK(&ionic->nb_work, ionic_lif_notify_work);
+	INIT_WORK(&lif->ionic->nb_work, ionic_lif_notify_work);
 
-	ionic->nb.notifier_call = ionic_lif_notify;
+	lif->ionic->nb.notifier_call = ionic_lif_notify;
 
-	err = register_netdevice_notifier(&ionic->nb);
+	err = register_netdevice_notifier(&lif->ionic->nb);
 	if (err)
-		ionic->nb.notifier_call = NULL;
+		lif->ionic->nb.notifier_call = NULL;
 
 	/* only register LIF0 for now */
-	err = register_netdev(ionic->master_lif->netdev);
+	err = register_netdev(lif->netdev);
 	if (err) {
-		dev_err(ionic->dev, "Cannot register net device, aborting\n");
+		dev_err(lif->ionic->dev, "Cannot register net device, aborting\n");
 		return err;
 	}
-	ionic->master_lif->registered = true;
-	ionic_lif_set_netdev_info(ionic->master_lif);
+	lif->registered = true;
+	ionic_lif_set_netdev_info(lif);
 
 	return 0;
 }
 
-void ionic_lifs_unregister(struct ionic *ionic)
+void ionic_lif_unregister(struct ionic_lif *lif)
 {
-	if (ionic->nb.notifier_call) {
-		unregister_netdevice_notifier(&ionic->nb);
-		cancel_work_sync(&ionic->nb_work);
-		ionic->nb.notifier_call = NULL;
+	if (lif->ionic->nb.notifier_call) {
+		unregister_netdevice_notifier(&lif->ionic->nb);
+		cancel_work_sync(&lif->ionic->nb_work);
+		lif->ionic->nb.notifier_call = NULL;
 	}
 
-	/* There is only one lif ever registered in the
-	 * current model, so don't bother searching the
-	 * ionic->lif for candidates to unregister
-	 */
-	if (ionic->master_lif &&
-	    ionic->master_lif->netdev->reg_state == NETREG_REGISTERED)
-		unregister_netdev(ionic->master_lif->netdev);
+	if (lif->netdev->reg_state == NETREG_REGISTERED)
+		unregister_netdev(lif->netdev);
+	lif->registered = false;
 }
 
 static void ionic_lif_queue_identify(struct ionic_lif *lif)
@@ -2803,7 +2738,7 @@ int ionic_lif_identify(struct ionic *ionic, u8 lif_type,
 	return 0;
 }
 
-int ionic_lifs_size(struct ionic *ionic)
+int ionic_lif_size(struct ionic *ionic)
 {
 	struct ionic_identity *ident = &ionic->ident;
 	unsigned int nintrs, dev_nintrs;
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.h b/drivers/net/ethernet/pensando/ionic/ionic_lif.h
index 1ee3b14c8d50..95d85502c18d 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.h
@@ -242,15 +242,15 @@ void ionic_get_stats64(struct net_device *netdev,
 		       struct rtnl_link_stats64 *ns);
 void ionic_lif_deferred_enqueue(struct ionic_deferred *def,
 				struct ionic_deferred_work *work);
-int ionic_lifs_alloc(struct ionic *ionic);
-void ionic_lifs_free(struct ionic *ionic);
-void ionic_lifs_deinit(struct ionic *ionic);
-int ionic_lifs_init(struct ionic *ionic);
-int ionic_lifs_register(struct ionic *ionic);
-void ionic_lifs_unregister(struct ionic *ionic);
+int ionic_lif_alloc(struct ionic *ionic);
+int ionic_lif_init(struct ionic_lif *lif);
+void ionic_lif_free(struct ionic_lif *lif);
+void ionic_lif_deinit(struct ionic_lif *lif);
+int ionic_lif_register(struct ionic_lif *lif);
+void ionic_lif_unregister(struct ionic_lif *lif);
 int ionic_lif_identify(struct ionic *ionic, u8 lif_type,
 		       union ionic_lif_identity *lif_ident);
-int ionic_lifs_size(struct ionic *ionic);
+int ionic_lif_size(struct ionic *ionic);
 int ionic_lif_rss_config(struct ionic_lif *lif, u16 types,
 			 const u8 *key, const u32 *indir);
 
-- 
2.17.1

