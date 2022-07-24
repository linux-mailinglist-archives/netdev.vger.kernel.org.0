Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 999DE57F7A1
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 01:16:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232344AbiGXXPR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Jul 2022 19:15:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232295AbiGXXPL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Jul 2022 19:15:11 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C30E3BBE
        for <netdev@vger.kernel.org>; Sun, 24 Jul 2022 16:15:08 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id w205so5599390pfc.8
        for <netdev@vger.kernel.org>; Sun, 24 Jul 2022 16:15:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version;
        bh=RSRfkxV14GN0XwoiiNBURkCMaxQruaHyP1E7NZEC3ew=;
        b=Sx7kZ2kHLe3UWeCeGAoATV8PbRzYA9dNFNixksKhArnmubQtvZQotp3yrTsLYE9mME
         er/3iqF0DK8Kc7VqSlO9ynwOfwkg1M8yPfeEUTS8Oph5+RNVjAV8kdpj5Wx34E2P91oM
         QJg9ECweCXP7mWtDNx3ZCsuO2LJjYd86LjP8w=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=RSRfkxV14GN0XwoiiNBURkCMaxQruaHyP1E7NZEC3ew=;
        b=QpBFl7TkifJIvchh4tqcu+9esLvX/wKQBQf9m+GDWWFF/N2czQUo0nGMzBhqcHtfTI
         AjgYJfUjevJ50YiLasRN1M8B1t+d21psDX+qvuOhk2iaWKz6faIYqDT0mCXhd5Nwyqho
         E2jsW80sWS5ccSbWpUPm4Rt7iyjW6YB6FVWWEDc6AU1e35ZOkFJErrW2iX1ikCO76+Vw
         8GZPZZ12l3lyX6sYLzdJBhGVLmPWDkPFKx/uK5fOTz+Yk8kl0PVp3eSaPUGfmIQhmwKs
         aY6qoueZHU3eBdt1kHOg3m4PLrXd4QgeLk6nZbVjeZiVRyb/cszhHWkk8tyL1G/Zms8T
         bENw==
X-Gm-Message-State: AJIora8ATMUXoyXqvnhzUuM3SpmnNfT8vz8GdpRPbUwA9mxBfd26MdGV
        H0Gsdbmk0NdTpZyjJ8iWePXiUQ==
X-Google-Smtp-Source: AGRyM1sQM6VB+Ys1m8fVA41dlZYwpWapXjKPtVg1posD0jOHk5LldGI/qEeba/vv+1lQ8oKFAiQkUA==
X-Received: by 2002:a63:5123:0:b0:419:9286:4be8 with SMTP id f35-20020a635123000000b0041992864be8mr8661765pgb.237.1658704507976;
        Sun, 24 Jul 2022 16:15:07 -0700 (PDT)
Received: from localhost.localdomain ([136.52.99.246])
        by smtp.gmail.com with ESMTPSA id g11-20020a170902d5cb00b0016a6cd546d6sm7661395plh.251.2022.07.24.16.15.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 Jul 2022 16:15:07 -0700 (PDT)
From:   Ajit Khaparde <ajit.khaparde@broadcom.com>
To:     michael.chan@broadcom.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org, jgg@ziepe.ca,
        selvin.xavier@broadcom.com, leon@kernel.org,
        linux-rdma@vger.kernel.org, andrew.gospodarek@broadcom.com
Subject: [PATCH 1/2] net/bnxt: Add auxiliary driver support
Date:   Sun, 24 Jul 2022 16:14:57 -0700
Message-Id: <20220724231458.93830-2-ajit.khaparde@broadcom.com>
X-Mailer: git-send-email 2.32.1 (Apple Git-133)
In-Reply-To: <20220724231458.93830-1-ajit.khaparde@broadcom.com>
References: <20220724231458.93830-1-ajit.khaparde@broadcom.com>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="00000000000004b2f005e4953dba"
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--00000000000004b2f005e4953dba
Content-Transfer-Encoding: 8bit

Add auxiliary driver support.
An auxiliary device will be created if the hardware indicates
support for RDMA.
The bnxt_ulp_probe() function has been removed and a new
bnxt_rdma_aux_device_add() function has been added.
The bnxt_free_msix_vecs() and bnxt_req_msix_vecs() will now hold
the RTNL lock when they call the bnxt_close_nic()and bnxt_open_nic()
since the device close and open need to be protected under RTNL lock.
The operations between the bnxt_en and bnxt_re will be protected
using the en_ops_lock.
This will be used by the bnxt_re driver in a follow-on patch
to create ROCE interfaces.

BUG: DCSG01157556
Change-Id: I544c83c6a19925ee49a1da4d580c0970c679e746
Signed-off-by: Ajit Khaparde <ajit.khaparde@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c     |  72 ++++++++-
 drivers/net/ethernet/broadcom/bnxt/bnxt.h     |   8 +
 drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c | 137 ++++++++++++------
 drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.h |   5 +-
 4 files changed, 172 insertions(+), 50 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index ba0f1ffac507..98d5884a8418 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -79,6 +79,8 @@
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Broadcom BCM573xx network driver");
 
+static DEFINE_IDA(bnxt_aux_dev_ids);
+
 #define BNXT_RX_OFFSET (NET_SKB_PAD + NET_IP_ALIGN)
 #define BNXT_RX_DMA_OFFSET NET_SKB_PAD
 #define BNXT_RX_COPY_THRESH 256
@@ -211,6 +213,68 @@ static const struct pci_device_id bnxt_pci_tbl[] = {
 
 MODULE_DEVICE_TABLE(pci, bnxt_pci_tbl);
 
+static void bnxt_aux_dev_free(struct bnxt *bp)
+{
+	kfree(bp->aux_dev);
+	bp->aux_dev = NULL;
+}
+
+static struct bnxt_aux_dev *bnxt_aux_dev_init(struct bnxt *bp)
+{
+	struct bnxt_aux_dev *bnxt_adev;
+
+	bnxt_adev =  kzalloc(sizeof(*bnxt_adev), GFP_KERNEL);
+	if (!bnxt_adev)
+		return ERR_PTR(-ENOMEM);
+
+	return bnxt_adev;
+}
+
+static void bnxt_aux_device_uninit(struct bnxt_aux_dev *bnxt_adev)
+{
+	struct auxiliary_device *adev;
+
+	if (IS_ERR_OR_NULL(bnxt_adev))
+		return;
+
+	adev = &bnxt_adev->aux_dev;
+	auxiliary_device_delete(adev);
+	auxiliary_device_uninit(adev);
+	if (bnxt_adev->id >= 0)
+		ida_free(&bnxt_aux_dev_ids, bnxt_adev->id);
+}
+
+static void bnxt_rdma_aux_device_init(struct bnxt *bp)
+{
+	struct net_device *dev = bp->dev;
+	int rc;
+
+	if (bp->flags & BNXT_FLAG_ROCE_CAP) {
+		bp->aux_dev = bnxt_aux_dev_init(bp);
+		if (IS_ERR_OR_NULL(bp->aux_dev)) {
+			netdev_warn(dev, "Failed to init auxiliary device for ROCE\n");
+			goto skip_aux_init;
+		}
+
+		bp->aux_dev->id = ida_alloc(&bnxt_aux_dev_ids, GFP_KERNEL);
+		if (bp->aux_dev->id < 0) {
+			netdev_warn(dev, "ida alloc failed for ROCE auxiliary device\n");
+			bnxt_aux_dev_free(bp);
+			goto skip_aux_init;
+		}
+
+		/* If aux bus init fails, continue with netdev init. */
+		rc = bnxt_rdma_aux_device_add(bp);
+		if (rc) {
+			netdev_warn(dev, "Failed to add auxiliary device for ROCE\n");
+			ida_free(&bnxt_aux_dev_ids, bp->aux_dev->id);
+			bnxt_aux_dev_free(bp);
+		}
+	}
+skip_aux_init:
+	return;
+}
+
 static const u16 bnxt_vf_req_snif[] = {
 	HWRM_FUNC_CFG,
 	HWRM_FUNC_VF_CFG,
@@ -13122,6 +13186,9 @@ static void bnxt_remove_one(struct pci_dev *pdev)
 	struct net_device *dev = pci_get_drvdata(pdev);
 	struct bnxt *bp = netdev_priv(dev);
 
+	bnxt_aux_device_uninit(bp->aux_dev);
+	bnxt_aux_dev_free(bp);
+
 	if (BNXT_PF(bp))
 		bnxt_sriov_disable(bp);
 
@@ -13719,11 +13786,13 @@ static int bnxt_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 		devlink_port_type_eth_set(&bp->dl_port, bp->dev);
 	bnxt_dl_fw_reporters_create(bp);
 
+	bnxt_rdma_aux_device_init(bp);
+
 	bnxt_print_device_info(bp);
 
 	pci_save_state(pdev);
-	return 0;
 
+	return 0;
 init_err_cleanup:
 	bnxt_dl_unregister(bp);
 init_err_dl:
@@ -13767,7 +13836,6 @@ static void bnxt_shutdown(struct pci_dev *pdev)
 	if (netif_running(dev))
 		dev_close(dev);
 
-	bnxt_ulp_shutdown(bp);
 	bnxt_clear_int_mode(bp);
 	pci_disable_device(pdev);
 
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index 075c6206325c..064856cf4a55 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -24,6 +24,7 @@
 #include <linux/interrupt.h>
 #include <linux/rhashtable.h>
 #include <linux/crash_dump.h>
+#include <linux/auxiliary_bus.h>
 #include <net/devlink.h>
 #include <net/dst_metadata.h>
 #include <net/xdp.h>
@@ -1622,6 +1623,12 @@ struct bnxt_fw_health {
 #define BNXT_FW_RETRY			5
 #define BNXT_FW_IF_RETRY		10
 
+struct bnxt_aux_dev {
+	struct auxiliary_device aux_dev;
+	struct bnxt_en_dev *edev;
+	int id;
+};
+
 enum board_idx {
 	BCM57301,
 	BCM57302,
@@ -2146,6 +2153,7 @@ struct bnxt {
 	struct dentry		*debugfs_pdev;
 	struct device		*hwmon_dev;
 	enum board_idx		board_idx;
+	struct bnxt_aux_dev	*aux_dev;
 };
 
 #define BNXT_NUM_RX_RING_STATS			8
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c
index 2e54bf4fc7a7..a21f40e1e57c 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c
@@ -31,26 +31,30 @@ static int bnxt_register_dev(struct bnxt_en_dev *edev, unsigned int ulp_id,
 	struct net_device *dev = edev->net;
 	struct bnxt *bp = netdev_priv(dev);
 	struct bnxt_ulp *ulp;
+	int rc = 0;
 
-	ASSERT_RTNL();
 	if (ulp_id >= BNXT_MAX_ULP)
 		return -EINVAL;
 
+	mutex_lock(&edev->en_ops_lock);
 	ulp = &edev->ulp_tbl[ulp_id];
 	if (rcu_access_pointer(ulp->ulp_ops)) {
 		netdev_err(bp->dev, "ulp id %d already registered\n", ulp_id);
-		return -EBUSY;
+		rc = -EBUSY;
+		goto exit;
 	}
 	if (ulp_id == BNXT_ROCE_ULP) {
 		unsigned int max_stat_ctxs;
 
 		max_stat_ctxs = bnxt_get_max_func_stat_ctxs(bp);
 		if (max_stat_ctxs <= BNXT_MIN_ROCE_STAT_CTXS ||
-		    bp->cp_nr_rings == max_stat_ctxs)
-			return -ENOMEM;
+		    bp->cp_nr_rings == max_stat_ctxs) {
+			rc = -ENOMEM;
+			goto exit;
+		}
 	}
 
-	atomic_set(&ulp->ref_count, 0);
+	atomic_set(&ulp->ref_count, 1);
 	ulp->handle = handle;
 	rcu_assign_pointer(ulp->ulp_ops, ulp_ops);
 
@@ -59,7 +63,9 @@ static int bnxt_register_dev(struct bnxt_en_dev *edev, unsigned int ulp_id,
 			bnxt_hwrm_vnic_cfg(bp, 0);
 	}
 
-	return 0;
+exit:
+	mutex_unlock(&edev->en_ops_lock);
+	return rc;
 }
 
 static int bnxt_unregister_dev(struct bnxt_en_dev *edev, unsigned int ulp_id)
@@ -69,10 +75,11 @@ static int bnxt_unregister_dev(struct bnxt_en_dev *edev, unsigned int ulp_id)
 	struct bnxt_ulp *ulp;
 	int i = 0;
 
-	ASSERT_RTNL();
 	if (ulp_id >= BNXT_MAX_ULP)
 		return -EINVAL;
 
+	edev->flags |= BNXT_EN_FLAG_ULP_STOPPED;
+
 	ulp = &edev->ulp_tbl[ulp_id];
 	if (!rcu_access_pointer(ulp->ulp_ops)) {
 		netdev_err(bp->dev, "ulp id %d not registered\n", ulp_id);
@@ -81,6 +88,7 @@ static int bnxt_unregister_dev(struct bnxt_en_dev *edev, unsigned int ulp_id)
 	if (ulp_id == BNXT_ROCE_ULP && ulp->msix_requested)
 		edev->en_ops->bnxt_free_msix(edev, ulp_id);
 
+	mutex_lock(&edev->en_ops_lock);
 	if (ulp->max_async_event_id)
 		bnxt_hwrm_func_drv_rgtr(bp, NULL, 0, true);
 
@@ -92,6 +100,7 @@ static int bnxt_unregister_dev(struct bnxt_en_dev *edev, unsigned int ulp_id)
 		msleep(100);
 		i++;
 	}
+	mutex_unlock(&edev->en_ops_lock);
 	return 0;
 }
 
@@ -126,7 +135,6 @@ static int bnxt_req_msix_vecs(struct bnxt_en_dev *edev, unsigned int ulp_id,
 	int total_vecs;
 	int rc = 0;
 
-	ASSERT_RTNL();
 	if (ulp_id != BNXT_ROCE_ULP)
 		return -EINVAL;
 
@@ -149,6 +157,8 @@ static int bnxt_req_msix_vecs(struct bnxt_en_dev *edev, unsigned int ulp_id,
 		max_idx = min_t(int, bp->total_irqs, max_cp_rings);
 		idx = max_idx - avail_msix;
 	}
+
+	mutex_lock(&edev->en_ops_lock);
 	edev->ulp_tbl[ulp_id].msix_base = idx;
 	edev->ulp_tbl[ulp_id].msix_requested = avail_msix;
 	hw_resc = &bp->hw_resc;
@@ -156,14 +166,17 @@ static int bnxt_req_msix_vecs(struct bnxt_en_dev *edev, unsigned int ulp_id,
 	if (bp->total_irqs < total_vecs ||
 	    (BNXT_NEW_RM(bp) && hw_resc->resv_irqs < total_vecs)) {
 		if (netif_running(dev)) {
+			rtnl_lock();
 			bnxt_close_nic(bp, true, false);
 			rc = bnxt_open_nic(bp, true, false);
+			rtnl_unlock();
 		} else {
 			rc = bnxt_reserve_rings(bp, true);
 		}
 	}
 	if (rc) {
 		edev->ulp_tbl[ulp_id].msix_requested = 0;
+		mutex_unlock(&edev->en_ops_lock);
 		return -EAGAIN;
 	}
 
@@ -176,6 +189,7 @@ static int bnxt_req_msix_vecs(struct bnxt_en_dev *edev, unsigned int ulp_id,
 	}
 	bnxt_fill_msix_vecs(bp, ent);
 	edev->flags |= BNXT_EN_FLAG_MSIX_REQUESTED;
+	mutex_unlock(&edev->en_ops_lock);
 	return avail_msix;
 }
 
@@ -184,19 +198,23 @@ static int bnxt_free_msix_vecs(struct bnxt_en_dev *edev, unsigned int ulp_id)
 	struct net_device *dev = edev->net;
 	struct bnxt *bp = netdev_priv(dev);
 
-	ASSERT_RTNL();
 	if (ulp_id != BNXT_ROCE_ULP)
 		return -EINVAL;
 
 	if (!(edev->flags & BNXT_EN_FLAG_MSIX_REQUESTED))
 		return 0;
 
+	mutex_lock(&edev->en_ops_lock);
 	edev->ulp_tbl[ulp_id].msix_requested = 0;
 	edev->flags &= ~BNXT_EN_FLAG_MSIX_REQUESTED;
 	if (netif_running(dev) && !(edev->flags & BNXT_EN_FLAG_ULP_STOPPED)) {
+		rtnl_lock();
 		bnxt_close_nic(bp, true, false);
 		bnxt_open_nic(bp, true, false);
+		rtnl_unlock();
 	}
+	mutex_unlock(&edev->en_ops_lock);
+
 	return 0;
 }
 
@@ -254,6 +272,7 @@ static int bnxt_send_msg(struct bnxt_en_dev *edev, unsigned int ulp_id,
 	if (rc)
 		return rc;
 
+	mutex_lock(&edev->en_ops_lock);
 	hwrm_req_timeout(bp, req, fw_msg->timeout);
 	resp = hwrm_req_hold(bp, req);
 	rc = hwrm_req_send(bp, req);
@@ -265,6 +284,7 @@ static int bnxt_send_msg(struct bnxt_en_dev *edev, unsigned int ulp_id,
 		memcpy(fw_msg->resp, resp, resp_len);
 	}
 	hwrm_req_drop(bp, req);
+	mutex_unlock(&edev->en_ops_lock);
 	return rc;
 }
 
@@ -347,25 +367,6 @@ void bnxt_ulp_sriov_cfg(struct bnxt *bp, int num_vfs)
 	}
 }
 
-void bnxt_ulp_shutdown(struct bnxt *bp)
-{
-	struct bnxt_en_dev *edev = bp->edev;
-	struct bnxt_ulp_ops *ops;
-	int i;
-
-	if (!edev)
-		return;
-
-	for (i = 0; i < BNXT_MAX_ULP; i++) {
-		struct bnxt_ulp *ulp = &edev->ulp_tbl[i];
-
-		ops = rtnl_dereference(ulp->ulp_ops);
-		if (!ops || !ops->ulp_shutdown)
-			continue;
-		ops->ulp_shutdown(ulp->handle);
-	}
-}
-
 void bnxt_ulp_irq_stop(struct bnxt *bp)
 {
 	struct bnxt_en_dev *edev = bp->edev;
@@ -457,12 +458,14 @@ static int bnxt_register_async_events(struct bnxt_en_dev *edev, unsigned int ulp
 	if (ulp_id >= BNXT_MAX_ULP)
 		return -EINVAL;
 
+	mutex_lock(&edev->en_ops_lock);
 	ulp = &edev->ulp_tbl[ulp_id];
 	ulp->async_events_bmap = events_bmap;
 	/* Make sure bnxt_ulp_async_events() sees this order */
 	smp_wmb();
 	ulp->max_async_event_id = max_id;
 	bnxt_hwrm_func_drv_rgtr(bp, events_bmap, max_id + 1, true);
+	mutex_unlock(&edev->en_ops_lock);
 	return 0;
 }
 
@@ -475,28 +478,70 @@ static const struct bnxt_en_ops bnxt_en_ops_tbl = {
 	.bnxt_register_fw_async_events	= bnxt_register_async_events,
 };
 
-struct bnxt_en_dev *bnxt_ulp_probe(struct net_device *dev)
+void bnxt_aux_dev_release(struct device *dev)
 {
-	struct bnxt *bp = netdev_priv(dev);
-	struct bnxt_en_dev *edev;
+	struct bnxt_aux_dev *bnxt_adev =
+		container_of(dev, struct bnxt_aux_dev, aux_dev.dev);
+	struct bnxt *bp = netdev_priv(bnxt_adev->edev->net);
+
+	bnxt_adev->edev->en_ops = NULL;
+	kfree(bnxt_adev->edev);
+	bnxt_adev->edev = NULL;
+	bp->edev = NULL;
+}
+
+static inline void bnxt_set_edev_info(struct bnxt_en_dev *edev, struct bnxt *bp)
+{
+	edev->en_ops = &bnxt_en_ops_tbl;
+	edev->net = bp->dev;
+	edev->pdev = bp->pdev;
+	edev->l2_db_size = bp->db_size;
+	edev->l2_db_size_nc = bp->db_size;
+	mutex_init(&edev->en_ops_lock);
 
-	edev = bp->edev;
-	if (!edev) {
-		edev = kzalloc(sizeof(*edev), GFP_KERNEL);
-		if (!edev)
-			return ERR_PTR(-ENOMEM);
-		edev->en_ops = &bnxt_en_ops_tbl;
-		edev->net = dev;
-		edev->pdev = bp->pdev;
-		edev->l2_db_size = bp->db_size;
-		edev->l2_db_size_nc = bp->db_size;
-		bp->edev = edev;
-	}
-	edev->flags &= ~BNXT_EN_FLAG_ROCE_CAP;
 	if (bp->flags & BNXT_FLAG_ROCEV1_CAP)
 		edev->flags |= BNXT_EN_FLAG_ROCEV1_CAP;
 	if (bp->flags & BNXT_FLAG_ROCEV2_CAP)
 		edev->flags |= BNXT_EN_FLAG_ROCEV2_CAP;
-	return bp->edev;
 }
-EXPORT_SYMBOL(bnxt_ulp_probe);
+
+int bnxt_rdma_aux_device_add(struct bnxt *bp)
+{
+	struct bnxt_aux_dev *bnxt_adev = bp->aux_dev;
+	struct bnxt_en_dev *edev = bnxt_adev->edev;
+	struct auxiliary_device *aux_dev;
+	int ret;
+
+	aux_dev = &bnxt_adev->aux_dev;
+	aux_dev->id = bnxt_adev->id;
+	aux_dev->name = "rdma";
+	aux_dev->dev.parent = &bp->pdev->dev;
+	aux_dev->dev.release = bnxt_aux_dev_release;
+
+	if (!edev) {
+		edev = kzalloc(sizeof(*edev), GFP_KERNEL);
+		if (!edev)
+			return -ENOMEM;
+	}
+
+	bnxt_set_edev_info(edev, bp);
+	bnxt_adev->edev = edev;
+	bp->edev = edev;
+
+	ret = auxiliary_device_init(aux_dev);
+	if (ret) {
+		kfree(edev);
+		kfree(bnxt_adev);
+		return ret;
+	}
+
+	ret = auxiliary_device_add(aux_dev);
+	if (ret) {
+		kfree(edev);
+		kfree(bnxt_adev);
+		auxiliary_device_uninit(aux_dev);
+		return ret;
+	}
+
+	return 0;
+}
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.h b/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.h
index 42b50abc3e91..db0d477045fc 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.h
@@ -65,6 +65,7 @@ struct bnxt_en_dev {
 	#define BNXT_EN_FLAG_MSIX_REQUESTED	0x4
 	#define BNXT_EN_FLAG_ULP_STOPPED	0x8
 	const struct bnxt_en_ops	*en_ops;
+	struct mutex			en_ops_lock;	/* serialize ops */
 	struct bnxt_ulp			ulp_tbl[BNXT_MAX_ULP];
 	int				l2_db_size;	/* Doorbell BAR size in
 							 * bytes mapped by L2
@@ -102,10 +103,10 @@ int bnxt_get_ulp_stat_ctxs(struct bnxt *bp);
 void bnxt_ulp_stop(struct bnxt *bp);
 void bnxt_ulp_start(struct bnxt *bp, int err);
 void bnxt_ulp_sriov_cfg(struct bnxt *bp, int num_vfs);
-void bnxt_ulp_shutdown(struct bnxt *bp);
 void bnxt_ulp_irq_stop(struct bnxt *bp);
 void bnxt_ulp_irq_restart(struct bnxt *bp, int err);
 void bnxt_ulp_async_events(struct bnxt *bp, struct hwrm_async_event_cmpl *cmpl);
-struct bnxt_en_dev *bnxt_ulp_probe(struct net_device *dev);
+void bnxt_aux_dev_release(struct device *dev);
+int bnxt_rdma_aux_device_add(struct bnxt *bp);
 
 #endif
-- 
2.32.1 (Apple Git-133)


--00000000000004b2f005e4953dba
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
RIaCW0xx+14NTQe17dkH6CEEpmCjejneq/FU0gmbuorwHoP9mOiqeh23/ZKVpmFO/eiDtvMNAMDW
6LzhOk/pMklUPTHu/gQNW3OQebyhyFUHiBSp8rDkfWZT57Asd0PtdQIDAQABo4IB2zCCAdcwDgYD
VR0PAQH/BAQDAgWgMIGjBggrBgEFBQcBAQSBljCBkzBOBggrBgEFBQcwAoZCaHR0cDovL3NlY3Vy
ZS5nbG9iYWxzaWduLmNvbS9jYWNlcnQvZ3NnY2NyM3BlcnNvbmFsc2lnbjJjYTIwMjAuY3J0MEEG
CCsGAQUFBzABhjVodHRwOi8vb2NzcC5nbG9iYWxzaWduLmNvbS9nc2djY3IzcGVyc29uYWxzaWdu
MmNhMjAyMDBNBgNVHSAERjBEMEIGCisGAQQBoDIBKAowNDAyBggrBgEFBQcCARYmaHR0cHM6Ly93
d3cuZ2xvYmFsc2lnbi5jb20vcmVwb3NpdG9yeS8wCQYDVR0TBAIwADBJBgNVHR8EQjBAMD6gPKA6
hjhodHRwOi8vY3JsLmdsb2JhbHNpZ24uY29tL2dzZ2NjcjNwZXJzb25hbHNpZ24yY2EyMDIwLmNy
bDAlBgNVHREEHjAcgRphaml0LmtoYXBhcmRlQGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEF
BQcDBDAfBgNVHSMEGDAWgBSWM9HmWBdbNHWKgVZk1b5I3qGPzzAdBgNVHQ4EFgQUPHif0ihgndR0
h7r3sANaOIu2yM8wDQYJKoZIhvcNAQELBQADggEBAAEuLXDnP0Xd2zAMpQobXLUyqbpqGMO6ycQc
Xq4H2YYlSNKVwPA+ZAVdUOzbSimBKlx8mzAEHkI3Ll1yXlYeT4UwkfWV9fioyGuQelLN1sGzi5bm
WEpaSIbR1eiJMtzxUPwpRTn19gHZVueIot2Gw0fEYgHiMJpUr6xBWv2QNXULu/E8qvbXIRh2iycq
5rWFggX/JHglO8nVqzb1ImzqzVMFnDN15h3j8ryy2MIvZ8VDQRP7l81IXaTvVwaKpWMgV6rfQOi6
aOQZuOKkad7qoCkS5N2oSsvxi+rZtDaJJNsDjs05y5JZZQtBlfAmdYS+mmvkPjZ1iaLTzk59o/Yo
fNkxggJtMIICaQIBATBrMFsxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNh
MTEwLwYDVQQDEyhHbG9iYWxTaWduIEdDQyBSMyBQZXJzb25hbFNpZ24gMiBDQSAyMDIwAgwQphPQ
U+7K4aDRwxAwDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIHp4gil5QIR3H42FWUEN
I14chqQvVUrtj3KrJRwK0vvDMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkF
MQ8XDTIyMDcyNDIzMTUwOFowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUD
BAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsG
CWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQCzFXIIGDJlDalwqrIXiT1tZy8HYUheZfzPmaNM
hRXkNBOyiPpiqrPzVoUuqafvHbbC8+BR+OPoH3VJxY5ikW9MhgD7z9N3ci3sHiOMBdGZ7ZQs3W3K
Ovy7U1IBKFmhHeRkFsrbagLqY45KJrqm5Wq9l+MiZreNjsgxkJU8ZnhfgC9M9zgjCSBNC68Iwreo
6NpbF51kw7FfSHN6zLei9ud7eDzDD5lfVq3ma4ZT2di+0o8zNXPGdYIZI7FFkTkG5DNOawUVKSqj
Rt3gGrPrmZv4BZYi8ZEcT+gjZDvt4w4d5iajcYant+i/LNszmZucbfOmO8FVG4DDeYhPOEs1yU9P
--00000000000004b2f005e4953dba--
