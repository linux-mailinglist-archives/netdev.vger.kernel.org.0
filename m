Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 852EA57F7A3
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 01:16:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232989AbiGXXPb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Jul 2022 19:15:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232185AbiGXXPR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Jul 2022 19:15:17 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EC9D764B
        for <netdev@vger.kernel.org>; Sun, 24 Jul 2022 16:15:11 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id v16-20020a17090abb9000b001f25244c65dso5407083pjr.2
        for <netdev@vger.kernel.org>; Sun, 24 Jul 2022 16:15:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version;
        bh=VwWN2uyhOFIo+1LJy7c2GXPUmZcHH9klSGT+0H4liG8=;
        b=NnWmhAQpEwOZ0q7zI/GihylAxwur3MQ1NLxQtkixfq35QGg7hgYf6+B9ohtCRWiblx
         SUnJQ2JtBGiQgTiEKuJFV/3tC3iO3CaNGvSNKg59yLqAN/+4xz/GEqHNzwhKu4eg9WGP
         tBjKxHl6ptcO/hk4MvKtieosBQj2ULUqCR3A0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=VwWN2uyhOFIo+1LJy7c2GXPUmZcHH9klSGT+0H4liG8=;
        b=zb/Ys3IpuDYzoNadIYnIuNkfBhowe+qw5p5uFxCfqpR2Bse0nURzhmz7AG6f9YK1xB
         yDprN3m6S7P0NOJ4gDgmVh0lHqt/rs06ItOatPsVYTcgUuczBUgAb7GJtS4cU/OgLgcb
         +UjSAboLPD5PeU1NBLuwyGirSL+9lzxGn1GlsOrPkI9V+9ofv+mISw5NNhXgTr5OS3wo
         aAyvSSCH8E5PFMMtq/n191eaTLl242t73gjQG7sDtxwSm6Iy2FYvCU1kOk7T3c7Ew9Tr
         rL5ZhHkU10G92qs14BWkrn9WMzk1aFbMo90lHsOEt5v2B4otpt2bgn0ivPMclLLzEOQU
         W6PQ==
X-Gm-Message-State: AJIora+gOxhi2QeJzQ0jw6l0JUYRuvmIqmam/DigFhgQH3UxPRP+Dy10
        V9HoGXr4gKLbAEIXId/cIb4FoA==
X-Google-Smtp-Source: AGRyM1sDRE84LOzexHXpCn9CVlA2lAcT/Z8deBnNzlENQbCtzDo37VkBHDQpwPHRGoH4Q+DQbrB7kQ==
X-Received: by 2002:a17:902:8543:b0:16d:66eb:8f4c with SMTP id d3-20020a170902854300b0016d66eb8f4cmr5550500plo.137.1658704510384;
        Sun, 24 Jul 2022 16:15:10 -0700 (PDT)
Received: from localhost.localdomain ([136.52.99.246])
        by smtp.gmail.com with ESMTPSA id g11-20020a170902d5cb00b0016a6cd546d6sm7661395plh.251.2022.07.24.16.15.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 Jul 2022 16:15:09 -0700 (PDT)
From:   Ajit Khaparde <ajit.khaparde@broadcom.com>
To:     michael.chan@broadcom.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org, jgg@ziepe.ca,
        selvin.xavier@broadcom.com, leon@kernel.org,
        linux-rdma@vger.kernel.org, andrew.gospodarek@broadcom.com
Subject: [PATCH 2/2] RDMA/bnxt_re: Use auxiliary driver interface
Date:   Sun, 24 Jul 2022 16:14:58 -0700
Message-Id: <20220724231458.93830-3-ajit.khaparde@broadcom.com>
X-Mailer: git-send-email 2.32.1 (Apple Git-133)
In-Reply-To: <20220724231458.93830-1-ajit.khaparde@broadcom.com>
References: <20220724231458.93830-1-ajit.khaparde@broadcom.com>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000279d3105e4953d9a"
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--000000000000279d3105e4953d9a
Content-Transfer-Encoding: 8bit

Use auxiliary driver interface for driver load, unload ROCE driver.
The driver does not need to register the interface using the netdev
notifier anymore. Removed the bnxt_re_dev_list which is not needed.
Currently probe, remove and shutdown ops have been implemented for
the auxiliary device.

BUG: DCSG01157556
Change-Id: Ice54f076c1c4fc26d4ee7e77a5dcd1ca21cf4cd0
Signed-off-by: Ajit Khaparde <ajit.khaparde@broadcom.com>
---
 drivers/infiniband/hw/bnxt_re/bnxt_re.h       |   9 +-
 drivers/infiniband/hw/bnxt_re/main.c          | 405 +++++++-----------
 drivers/net/ethernet/broadcom/bnxt/bnxt.c     |  64 ---
 drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c |  65 +++
 drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.h |   3 +
 5 files changed, 232 insertions(+), 314 deletions(-)

diff --git a/drivers/infiniband/hw/bnxt_re/bnxt_re.h b/drivers/infiniband/hw/bnxt_re/bnxt_re.h
index 79401e6c6aa9..7ca4e5482e5f 100644
--- a/drivers/infiniband/hw/bnxt_re/bnxt_re.h
+++ b/drivers/infiniband/hw/bnxt_re/bnxt_re.h
@@ -89,13 +89,6 @@ struct bnxt_re_ring_attr {
 	u8		mode;
 };
 
-struct bnxt_re_work {
-	struct work_struct	work;
-	unsigned long		event;
-	struct bnxt_re_dev      *rdev;
-	struct net_device	*vlan_dev;
-};
-
 struct bnxt_re_sqp_entries {
 	struct bnxt_qplib_sge sge;
 	u64 wrid;
@@ -132,6 +125,7 @@ struct bnxt_re_dev {
 #define BNXT_RE_FLAG_ERR_DEVICE_DETACHED       17
 #define BNXT_RE_FLAG_ISSUE_ROCE_STATS          29
 	struct net_device		*netdev;
+	struct notifier_block		nb;
 	unsigned int			version, major, minor;
 	struct bnxt_qplib_chip_ctx	*chip_ctx;
 	struct bnxt_en_dev		*en_dev;
@@ -194,5 +188,4 @@ static inline struct device *rdev_to_dev(struct bnxt_re_dev *rdev)
 		return  &rdev->ibdev.dev;
 	return NULL;
 }
-
 #endif
diff --git a/drivers/infiniband/hw/bnxt_re/main.c b/drivers/infiniband/hw/bnxt_re/main.c
index 3d6834d3d4fb..72ed8072e059 100644
--- a/drivers/infiniband/hw/bnxt_re/main.c
+++ b/drivers/infiniband/hw/bnxt_re/main.c
@@ -48,6 +48,7 @@
 #include <net/ipv6.h>
 #include <net/addrconf.h>
 #include <linux/if_ether.h>
+#include <linux/auxiliary_bus.h>
 
 #include <rdma/ib_verbs.h>
 #include <rdma/ib_user_verbs.h>
@@ -74,14 +75,14 @@ MODULE_DESCRIPTION(BNXT_RE_DESC " Driver");
 MODULE_LICENSE("Dual BSD/GPL");
 
 /* globals */
-static struct list_head bnxt_re_dev_list = LIST_HEAD_INIT(bnxt_re_dev_list);
-/* Mutex to protect the list of bnxt_re devices added */
-static DEFINE_MUTEX(bnxt_re_dev_lock);
-static struct workqueue_struct *bnxt_re_wq;
-static void bnxt_re_remove_device(struct bnxt_re_dev *rdev);
-static void bnxt_re_dealloc_driver(struct ib_device *ib_dev);
+static DEFINE_MUTEX(bnxt_re_mutex);
+
 static void bnxt_re_stop_irq(void *handle);
 static void bnxt_re_dev_stop(struct bnxt_re_dev *rdev);
+static int bnxt_re_netdev_event(struct notifier_block *notifier,
+				unsigned long event, void *ptr);
+static void bnxt_re_remove_device(struct bnxt_re_dev *rdev);
+static struct bnxt_re_dev *bnxt_re_from_netdev(struct net_device *netdev);
 
 static void bnxt_re_set_drv_mode(struct bnxt_re_dev *rdev, u8 mode)
 {
@@ -233,7 +234,6 @@ static void bnxt_re_stop(void *p)
 
 	if (!rdev)
 		return;
-	ASSERT_RTNL();
 
 	/* L2 driver invokes this callback during device error/crash or device
 	 * reset. Current RoCE driver doesn't recover the device in case of
@@ -282,16 +282,14 @@ static void bnxt_re_sriov_config(void *p, int num_vfs)
 	}
 }
 
-static void bnxt_re_shutdown(void *p)
+static void bnxt_re_shutdown(struct auxiliary_device *adev)
 {
-	struct bnxt_re_dev *rdev = p;
+	struct bnxt_re_dev *rdev = auxiliary_get_drvdata(adev);
 
 	if (!rdev)
 		return;
-	ASSERT_RTNL();
-	/* Release the MSIx vectors before queuing unregister */
-	bnxt_re_stop_irq(rdev);
-	ib_unregister_device_queued(&rdev->ibdev);
+	ib_unregister_device(&rdev->ibdev);
+	bnxt_re_remove_device(rdev);
 }
 
 static void bnxt_re_stop_irq(void *handle)
@@ -345,12 +343,27 @@ static void bnxt_re_start_irq(void *handle, struct bnxt_msix_entry *ent)
 	}
 }
 
+static void bnxt_re_async_notifier(void *handle, struct hwrm_async_event_cmpl *cmpl)
+{
+	struct net_device *netdev = (struct net_device *)handle;
+	struct bnxt_re_dev *rdev = bnxt_re_from_netdev(netdev);
+
+	u16 event_id = le16_to_cpu(cmpl->event_id);
+	u32 data1 = le32_to_cpu(cmpl->event_data1);
+	u32 data2 = le32_to_cpu(cmpl->event_data2);
+
+	if (!rdev)
+		return;
+
+	dev_dbg(rdev_to_dev(rdev), "Async event_id = %d data1 = %d data2 = %d",
+		event_id, data1, data2);
+}
+
 static struct bnxt_ulp_ops bnxt_re_ulp_ops = {
-	.ulp_async_notifier = NULL,
+	.ulp_async_notifier = bnxt_re_async_notifier,
 	.ulp_stop = bnxt_re_stop,
 	.ulp_start = bnxt_re_start,
 	.ulp_sriov_config = bnxt_re_sriov_config,
-	.ulp_shutdown = bnxt_re_shutdown,
 	.ulp_irq_stop = bnxt_re_stop_irq,
 	.ulp_irq_restart = bnxt_re_start_irq
 };
@@ -401,7 +414,6 @@ static int bnxt_re_free_msix(struct bnxt_re_dev *rdev)
 
 	en_dev = rdev->en_dev;
 
-
 	rc = en_dev->en_ops->bnxt_free_msix(rdev->en_dev, BNXT_ROCE_ULP);
 
 	return rc;
@@ -458,12 +470,17 @@ static void bnxt_re_fill_fw_msg(struct bnxt_fw_msg *fw_msg, void *msg,
 static int bnxt_re_net_ring_free(struct bnxt_re_dev *rdev,
 				 u16 fw_ring_id, int type)
 {
-	struct bnxt_en_dev *en_dev = rdev->en_dev;
+	struct bnxt_en_dev *en_dev;
 	struct hwrm_ring_free_input req = {0};
 	struct hwrm_ring_free_output resp;
 	struct bnxt_fw_msg fw_msg;
 	int rc = -EINVAL;
 
+	if (!rdev)
+		return rc;
+
+	en_dev = rdev->en_dev;
+
 	if (!en_dev)
 		return rc;
 
@@ -584,21 +601,6 @@ static int bnxt_re_net_stats_ctx_alloc(struct bnxt_re_dev *rdev,
 
 /* Device */
 
-static bool is_bnxt_re_dev(struct net_device *netdev)
-{
-	struct ethtool_drvinfo drvinfo;
-
-	if (netdev->ethtool_ops && netdev->ethtool_ops->get_drvinfo) {
-		memset(&drvinfo, 0, sizeof(drvinfo));
-		netdev->ethtool_ops->get_drvinfo(netdev, &drvinfo);
-
-		if (strcmp(drvinfo.driver, "bnxt_en"))
-			return false;
-		return true;
-	}
-	return false;
-}
-
 static struct bnxt_re_dev *bnxt_re_from_netdev(struct net_device *netdev)
 {
 	struct ib_device *ibdev =
@@ -609,27 +611,22 @@ static struct bnxt_re_dev *bnxt_re_from_netdev(struct net_device *netdev)
 	return container_of(ibdev, struct bnxt_re_dev, ibdev);
 }
 
-static struct bnxt_en_dev *bnxt_re_dev_probe(struct net_device *netdev)
+static struct bnxt_en_dev *bnxt_re_dev_probe(struct auxiliary_device *adev)
 {
-	struct bnxt_en_dev *en_dev;
+	struct bnxt_aux_dev *aux_dev =
+		container_of(adev, struct bnxt_aux_dev, aux_dev);
+	struct bnxt_en_dev *en_dev = NULL;
 	struct pci_dev *pdev;
 
-	en_dev = bnxt_ulp_probe(netdev);
-	if (IS_ERR(en_dev))
-		return en_dev;
+	if (aux_dev)
+		en_dev = aux_dev->edev;
+
+	if (!en_dev)
+		return NULL;
 
 	pdev = en_dev->pdev;
 	if (!pdev)
-		return ERR_PTR(-EINVAL);
-
-	if (!(en_dev->flags & BNXT_EN_FLAG_ROCE_CAP)) {
-		dev_info(&pdev->dev,
-			"%s: probe error: RoCE is not supported on this device",
-			ROCE_DRV_MODULE_NAME);
-		return ERR_PTR(-ENODEV);
-	}
-
-	dev_hold(netdev);
+		return NULL;
 
 	return en_dev;
 }
@@ -679,7 +676,6 @@ static const struct ib_device_ops bnxt_re_dev_ops = {
 	.create_qp = bnxt_re_create_qp,
 	.create_srq = bnxt_re_create_srq,
 	.create_user_ah = bnxt_re_create_ah,
-	.dealloc_driver = bnxt_re_dealloc_driver,
 	.dealloc_pd = bnxt_re_dealloc_pd,
 	.dealloc_ucontext = bnxt_re_dealloc_ucontext,
 	.del_gid = bnxt_re_del_gid,
@@ -744,18 +740,7 @@ static int bnxt_re_register_ib(struct bnxt_re_dev *rdev)
 	return ib_register_device(ibdev, "bnxt_re%d", &rdev->en_dev->pdev->dev);
 }
 
-static void bnxt_re_dev_remove(struct bnxt_re_dev *rdev)
-{
-	dev_put(rdev->netdev);
-	rdev->netdev = NULL;
-	mutex_lock(&bnxt_re_dev_lock);
-	list_del_rcu(&rdev->list);
-	mutex_unlock(&bnxt_re_dev_lock);
-
-	synchronize_rcu();
-}
-
-static struct bnxt_re_dev *bnxt_re_dev_add(struct net_device *netdev,
+static struct bnxt_re_dev *bnxt_re_dev_add(struct bnxt_aux_dev *aux_dev,
 					   struct bnxt_en_dev *en_dev)
 {
 	struct bnxt_re_dev *rdev;
@@ -768,8 +753,8 @@ static struct bnxt_re_dev *bnxt_re_dev_add(struct net_device *netdev,
 		return NULL;
 	}
 	/* Default values */
-	rdev->netdev = netdev;
-	dev_hold(rdev->netdev);
+	rdev->nb.notifier_call = NULL;
+	rdev->netdev = en_dev->net;
 	rdev->en_dev = en_dev;
 	rdev->id = rdev->en_dev->pdev->devfn;
 	INIT_LIST_HEAD(&rdev->qp_list);
@@ -784,9 +769,6 @@ static struct bnxt_re_dev *bnxt_re_dev_add(struct net_device *netdev,
 	rdev->cosq[0] = 0xFFFF;
 	rdev->cosq[1] = 0xFFFF;
 
-	mutex_lock(&bnxt_re_dev_lock);
-	list_add_tail_rcu(&rdev->list, &bnxt_re_dev_list);
-	mutex_unlock(&bnxt_re_dev_lock);
 	return rdev;
 }
 
@@ -1147,6 +1129,9 @@ static void bnxt_re_dev_stop(struct bnxt_re_dev *rdev)
 	struct ib_qp_attr qp_attr;
 	struct bnxt_re_qp *qp;
 
+	if (!rdev)
+		return;
+
 	qp_attr.qp_state = IB_QPS_ERR;
 	mutex_lock(&rdev->qp_lock);
 	list_for_each_entry(qp, &rdev->qp_list, list) {
@@ -1323,7 +1308,7 @@ static int bnxt_re_ib_init(struct bnxt_re_dev *rdev)
 		pr_err("Failed to register with IB: %#x\n", rc);
 		return rc;
 	}
-	dev_info(rdev_to_dev(rdev), "Device registered successfully");
+	dev_info(rdev_to_dev(rdev), "Device registered with IB successfully");
 	ib_get_eth_speed(&rdev->ibdev, 1, &rdev->active_speed,
 			 &rdev->active_width);
 	set_bit(BNXT_RE_FLAG_ISSUE_ROCE_STATS, &rdev->flags);
@@ -1341,6 +1326,7 @@ static void bnxt_re_dev_uninit(struct bnxt_re_dev *rdev)
 	u8 type;
 	int rc;
 
+	rdev->en_dev->flags |= BNXT_EN_FLAG_ULP_STOPPED;
 	if (test_and_clear_bit(BNXT_RE_FLAG_QOS_WORK_REG, &rdev->flags))
 		cancel_delayed_work_sync(&rdev->worker);
 
@@ -1541,135 +1527,49 @@ static int bnxt_re_dev_init(struct bnxt_re_dev *rdev, u8 wqe_mode)
 	return rc;
 }
 
-static void bnxt_re_dev_unreg(struct bnxt_re_dev *rdev)
+static void bnxt_re_remove_device(struct bnxt_re_dev *rdev)
 {
-	struct net_device *netdev = rdev->netdev;
-
-	bnxt_re_dev_remove(rdev);
-
-	if (netdev)
-		dev_put(netdev);
+	bnxt_re_dev_uninit(rdev);
 }
 
-static int bnxt_re_dev_reg(struct bnxt_re_dev **rdev, struct net_device *netdev)
+static int bnxt_re_add_device(struct auxiliary_device *adev, u8 wqe_mode)
 {
+	struct bnxt_aux_dev *aux_dev =
+		container_of(adev, struct bnxt_aux_dev, aux_dev);
 	struct bnxt_en_dev *en_dev;
+	struct bnxt_re_dev *rdev;
 	int rc = 0;
 
-	if (!is_bnxt_re_dev(netdev))
+	en_dev = bnxt_re_dev_probe(adev);
+	if (!en_dev)
 		return -ENODEV;
 
-	en_dev = bnxt_re_dev_probe(netdev);
-	if (IS_ERR(en_dev)) {
-		if (en_dev != ERR_PTR(-ENODEV))
-			ibdev_err(&(*rdev)->ibdev, "%s: Failed to probe\n",
-				  ROCE_DRV_MODULE_NAME);
-		rc = PTR_ERR(en_dev);
-		goto exit;
-	}
-	*rdev = bnxt_re_dev_add(netdev, en_dev);
-	if (!*rdev) {
+	rdev = bnxt_re_dev_add(aux_dev, en_dev);
+	if (!rdev || !rdev_to_dev(rdev)) {
 		rc = -ENOMEM;
-		dev_put(netdev);
 		goto exit;
 	}
-exit:
-	return rc;
-}
-
-static void bnxt_re_remove_device(struct bnxt_re_dev *rdev)
-{
-	bnxt_re_dev_uninit(rdev);
-	pci_dev_put(rdev->en_dev->pdev);
-	bnxt_re_dev_unreg(rdev);
-}
 
-static int bnxt_re_add_device(struct bnxt_re_dev **rdev,
-			      struct net_device *netdev, u8 wqe_mode)
-{
-	int rc;
-
-	rc = bnxt_re_dev_reg(rdev, netdev);
-	if (rc == -ENODEV)
-		return rc;
-	if (rc) {
-		pr_err("Failed to register with the device %s: %#x\n",
-		       netdev->name, rc);
-		return rc;
-	}
+	rc = bnxt_re_dev_init(rdev, wqe_mode);
+	if (rc)
+		goto re_dev_dealloc;
 
-	pci_dev_get((*rdev)->en_dev->pdev);
-	rc = bnxt_re_dev_init(*rdev, wqe_mode);
+	rc = bnxt_re_ib_init(rdev);
 	if (rc) {
-		pci_dev_put((*rdev)->en_dev->pdev);
-		bnxt_re_dev_unreg(*rdev);
+		pr_err("Failed to register with IB: %s",
+			aux_dev->aux_dev.name);
+		goto re_dev_uninit;
 	}
+	auxiliary_set_drvdata(adev, rdev);
 
-	return rc;
-}
-
-static void bnxt_re_dealloc_driver(struct ib_device *ib_dev)
-{
-	struct bnxt_re_dev *rdev =
-		container_of(ib_dev, struct bnxt_re_dev, ibdev);
-
-	dev_info(rdev_to_dev(rdev), "Unregistering Device");
-
-	rtnl_lock();
-	bnxt_re_remove_device(rdev);
-	rtnl_unlock();
-}
-
-/* Handle all deferred netevents tasks */
-static void bnxt_re_task(struct work_struct *work)
-{
-	struct bnxt_re_work *re_work;
-	struct bnxt_re_dev *rdev;
-	int rc = 0;
-
-	re_work = container_of(work, struct bnxt_re_work, work);
-	rdev = re_work->rdev;
-
-	if (re_work->event == NETDEV_REGISTER) {
-		rc = bnxt_re_ib_init(rdev);
-		if (rc) {
-			ibdev_err(&rdev->ibdev,
-				  "Failed to register with IB: %#x", rc);
-			rtnl_lock();
-			bnxt_re_remove_device(rdev);
-			rtnl_unlock();
-			goto exit;
-		}
-		goto exit;
-	}
-
-	if (!ib_device_try_get(&rdev->ibdev))
-		goto exit;
+	return 0;
 
-	switch (re_work->event) {
-	case NETDEV_UP:
-		bnxt_re_dispatch_event(&rdev->ibdev, NULL, 1,
-				       IB_EVENT_PORT_ACTIVE);
-		break;
-	case NETDEV_DOWN:
-		bnxt_re_dev_stop(rdev);
-		break;
-	case NETDEV_CHANGE:
-		if (!netif_carrier_ok(rdev->netdev))
-			bnxt_re_dev_stop(rdev);
-		else if (netif_carrier_ok(rdev->netdev))
-			bnxt_re_dispatch_event(&rdev->ibdev, NULL, 1,
-					       IB_EVENT_PORT_ACTIVE);
-		ib_get_eth_speed(&rdev->ibdev, 1, &rdev->active_speed,
-				 &rdev->active_width);
-		break;
-	default:
-		break;
-	}
-	ib_device_put(&rdev->ibdev);
+re_dev_uninit:
+	bnxt_re_dev_uninit(rdev);
+re_dev_dealloc:
+	ib_dealloc_device(&rdev->ibdev);
 exit:
-	put_device(&rdev->ibdev.dev);
-	kfree(re_work);
+	return rc;
 }
 
 /*
@@ -1690,109 +1590,130 @@ static int bnxt_re_netdev_event(struct notifier_block *notifier,
 				unsigned long event, void *ptr)
 {
 	struct net_device *real_dev, *netdev = netdev_notifier_info_to_dev(ptr);
-	struct bnxt_re_work *re_work;
 	struct bnxt_re_dev *rdev;
-	int rc = 0;
-	bool sch_work = false;
-	bool release = true;
 
 	real_dev = rdma_vlan_dev_real_dev(netdev);
 	if (!real_dev)
 		real_dev = netdev;
 
-	rdev = bnxt_re_from_netdev(real_dev);
-	if (!rdev && event != NETDEV_REGISTER)
-		return NOTIFY_OK;
-
 	if (real_dev != netdev)
 		goto exit;
 
-	switch (event) {
-	case NETDEV_REGISTER:
-		if (rdev)
-			break;
-		rc = bnxt_re_add_device(&rdev, real_dev,
-					BNXT_QPLIB_WQE_MODE_STATIC);
-		if (!rc)
-			sch_work = true;
-		release = false;
-		break;
+	rdev = bnxt_re_from_netdev(real_dev);
+	if (!rdev)
+		return NOTIFY_DONE;
 
-	case NETDEV_UNREGISTER:
-		ib_unregister_device_queued(&rdev->ibdev);
-		break;
 
+	switch (event) {
+	case NETDEV_UP:
+	case NETDEV_DOWN:
+	case NETDEV_CHANGE:
+		bnxt_re_dispatch_event(&rdev->ibdev, NULL, 1,
+					netif_carrier_ok(real_dev) ?
+					IB_EVENT_PORT_ACTIVE :
+					IB_EVENT_PORT_ERR);
+		break;
 	default:
-		sch_work = true;
 		break;
 	}
-	if (sch_work) {
-		/* Allocate for the deferred task */
-		re_work = kzalloc(sizeof(*re_work), GFP_KERNEL);
-		if (re_work) {
-			get_device(&rdev->ibdev.dev);
-			re_work->rdev = rdev;
-			re_work->event = event;
-			re_work->vlan_dev = (real_dev == netdev ?
-					     NULL : netdev);
-			INIT_WORK(&re_work->work, bnxt_re_task);
-			queue_work(bnxt_re_wq, &re_work->work);
-		}
-	}
-
+	ib_device_put(&rdev->ibdev);
 exit:
-	if (rdev && release)
-		ib_device_put(&rdev->ibdev);
 	return NOTIFY_DONE;
 }
 
-static struct notifier_block bnxt_re_netdev_notifier = {
-	.notifier_call = bnxt_re_netdev_event
-};
+#define BNXT_ADEV_NAME "bnxt_en"
 
-static int __init bnxt_re_mod_init(void)
+static void bnxt_re_remove(struct auxiliary_device *adev)
 {
-	int rc = 0;
+	struct bnxt_re_dev *rdev = auxiliary_get_drvdata(adev);
 
-	pr_info("%s: %s", ROCE_DRV_MODULE_NAME, version);
+	if (!rdev)
+		return;
 
-	bnxt_re_wq = create_singlethread_workqueue("bnxt_re");
-	if (!bnxt_re_wq)
-		return -ENOMEM;
+	mutex_lock(&bnxt_re_mutex);
+	if (rdev->nb.notifier_call) {
+		unregister_netdevice_notifier(&rdev->nb);
+		rdev->nb.notifier_call = NULL;
+	} else {
+		/* If notifier is null, we should have already done a
+		 * clean up before coming here.
+		 */
+		goto skip_remove;
+	}
+
+	ib_unregister_device(&rdev->ibdev);
+	ib_dealloc_device(&rdev->ibdev);
+	bnxt_re_remove_device(rdev);
+skip_remove:
+	mutex_unlock(&bnxt_re_mutex);
+}
+
+static int bnxt_re_probe(struct auxiliary_device *adev,
+			 const struct auxiliary_device_id *id)
+{
+	struct bnxt_re_dev *rdev;
+	int rc;
+
+	mutex_lock(&bnxt_re_mutex);
+	rc = bnxt_re_add_device(adev, BNXT_QPLIB_WQE_MODE_STATIC);
+	if (rc) {
+		mutex_unlock(&bnxt_re_mutex);
+		return rc;
+	}
 
-	INIT_LIST_HEAD(&bnxt_re_dev_list);
+	rdev = auxiliary_get_drvdata(adev);
 
-	rc = register_netdevice_notifier(&bnxt_re_netdev_notifier);
+	rdev->nb.notifier_call = bnxt_re_netdev_event;
+	rc = register_netdevice_notifier(&rdev->nb);
 	if (rc) {
+		rdev->nb.notifier_call = NULL;
 		pr_err("%s: Cannot register to netdevice_notifier",
 		       ROCE_DRV_MODULE_NAME);
-		goto err_netdev;
+		goto err;
 	}
+
+	mutex_unlock(&bnxt_re_mutex);
 	return 0;
 
-err_netdev:
-	destroy_workqueue(bnxt_re_wq);
+err:
+	mutex_unlock(&bnxt_re_mutex);
+	bnxt_re_remove(adev);
 
 	return rc;
 }
 
-static void __exit bnxt_re_mod_exit(void)
+static const struct auxiliary_device_id bnxt_re_id_table[] = {
+	{ .name = BNXT_ADEV_NAME ".rdma", },
+	{},
+};
+
+MODULE_DEVICE_TABLE(auxiliary, bnxt_re_id_table);
+
+static struct auxiliary_driver bnxt_re_driver = {
+	.name = "rdma",
+	.probe = bnxt_re_probe,
+	.remove = bnxt_re_remove,
+	.shutdown = bnxt_re_shutdown,
+	.id_table = bnxt_re_id_table,
+};
+
+static int __init bnxt_re_mod_init(void)
 {
-	struct bnxt_re_dev *rdev;
+	int rc = 0;
 
-	unregister_netdevice_notifier(&bnxt_re_netdev_notifier);
-	if (bnxt_re_wq)
-		destroy_workqueue(bnxt_re_wq);
-	list_for_each_entry(rdev, &bnxt_re_dev_list, list) {
-		/* VF device removal should be called before the removal
-		 * of PF device. Queue VFs unregister first, so that VFs
-		 * shall be removed before the PF during the call of
-		 * ib_unregister_driver.
-		 */
-		if (rdev->is_virtfn)
-			ib_unregister_device(&rdev->ibdev);
+	pr_info("%s: %s", ROCE_DRV_MODULE_NAME, version);
+	rc = auxiliary_driver_register(&bnxt_re_driver);
+	if (rc) {
+		pr_err("%s: Failed to register auxiliary driver\n",
+			ROCE_DRV_MODULE_NAME);
+		return rc;
 	}
-	ib_unregister_driver(RDMA_DRIVER_BNXT_RE);
+	return 0;
+}
+
+static void __exit bnxt_re_mod_exit(void)
+{
+	auxiliary_driver_unregister(&bnxt_re_driver);
 }
 
 module_init(bnxt_re_mod_init);
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 98d5884a8418..32a6c0e52cee 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -79,8 +79,6 @@
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Broadcom BCM573xx network driver");
 
-static DEFINE_IDA(bnxt_aux_dev_ids);
-
 #define BNXT_RX_OFFSET (NET_SKB_PAD + NET_IP_ALIGN)
 #define BNXT_RX_DMA_OFFSET NET_SKB_PAD
 #define BNXT_RX_COPY_THRESH 256
@@ -213,68 +211,6 @@ static const struct pci_device_id bnxt_pci_tbl[] = {
 
 MODULE_DEVICE_TABLE(pci, bnxt_pci_tbl);
 
-static void bnxt_aux_dev_free(struct bnxt *bp)
-{
-	kfree(bp->aux_dev);
-	bp->aux_dev = NULL;
-}
-
-static struct bnxt_aux_dev *bnxt_aux_dev_init(struct bnxt *bp)
-{
-	struct bnxt_aux_dev *bnxt_adev;
-
-	bnxt_adev =  kzalloc(sizeof(*bnxt_adev), GFP_KERNEL);
-	if (!bnxt_adev)
-		return ERR_PTR(-ENOMEM);
-
-	return bnxt_adev;
-}
-
-static void bnxt_aux_device_uninit(struct bnxt_aux_dev *bnxt_adev)
-{
-	struct auxiliary_device *adev;
-
-	if (IS_ERR_OR_NULL(bnxt_adev))
-		return;
-
-	adev = &bnxt_adev->aux_dev;
-	auxiliary_device_delete(adev);
-	auxiliary_device_uninit(adev);
-	if (bnxt_adev->id >= 0)
-		ida_free(&bnxt_aux_dev_ids, bnxt_adev->id);
-}
-
-static void bnxt_rdma_aux_device_init(struct bnxt *bp)
-{
-	struct net_device *dev = bp->dev;
-	int rc;
-
-	if (bp->flags & BNXT_FLAG_ROCE_CAP) {
-		bp->aux_dev = bnxt_aux_dev_init(bp);
-		if (IS_ERR_OR_NULL(bp->aux_dev)) {
-			netdev_warn(dev, "Failed to init auxiliary device for ROCE\n");
-			goto skip_aux_init;
-		}
-
-		bp->aux_dev->id = ida_alloc(&bnxt_aux_dev_ids, GFP_KERNEL);
-		if (bp->aux_dev->id < 0) {
-			netdev_warn(dev, "ida alloc failed for ROCE auxiliary device\n");
-			bnxt_aux_dev_free(bp);
-			goto skip_aux_init;
-		}
-
-		/* If aux bus init fails, continue with netdev init. */
-		rc = bnxt_rdma_aux_device_add(bp);
-		if (rc) {
-			netdev_warn(dev, "Failed to add auxiliary device for ROCE\n");
-			ida_free(&bnxt_aux_dev_ids, bp->aux_dev->id);
-			bnxt_aux_dev_free(bp);
-		}
-	}
-skip_aux_init:
-	return;
-}
-
 static const u16 bnxt_vf_req_snif[] = {
 	HWRM_FUNC_CFG,
 	HWRM_FUNC_VF_CFG,
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c
index a21f40e1e57c..49365a3724a7 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c
@@ -19,12 +19,15 @@
 #include <linux/irq.h>
 #include <asm/byteorder.h>
 #include <linux/bitmap.h>
+#include <linux/auxiliary_bus.h>
 
 #include "bnxt_hsi.h"
 #include "bnxt.h"
 #include "bnxt_hwrm.h"
 #include "bnxt_ulp.h"
 
+static DEFINE_IDA(bnxt_aux_dev_ids);
+
 static int bnxt_register_dev(struct bnxt_en_dev *edev, unsigned int ulp_id,
 			     struct bnxt_ulp_ops *ulp_ops, void *handle)
 {
@@ -478,6 +481,68 @@ static const struct bnxt_en_ops bnxt_en_ops_tbl = {
 	.bnxt_register_fw_async_events	= bnxt_register_async_events,
 };
 
+void bnxt_aux_dev_free(struct bnxt *bp)
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
+void bnxt_aux_device_uninit(struct bnxt_aux_dev *bnxt_adev)
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
+void bnxt_rdma_aux_device_init(struct bnxt *bp)
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
 void bnxt_aux_dev_release(struct device *dev)
 {
 	struct bnxt_aux_dev *bnxt_adev =
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.h b/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.h
index db0d477045fc..d6d6967664a7 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.h
@@ -109,4 +109,7 @@ void bnxt_ulp_async_events(struct bnxt *bp, struct hwrm_async_event_cmpl *cmpl);
 void bnxt_aux_dev_release(struct device *dev);
 int bnxt_rdma_aux_device_add(struct bnxt *bp);
 
+void bnxt_aux_device_uninit(struct bnxt_aux_dev *bnxt_adev);
+void bnxt_rdma_aux_device_init(struct bnxt *bp);
+void bnxt_aux_dev_free(struct bnxt *bp);
 #endif
-- 
2.32.1 (Apple Git-133)


--000000000000279d3105e4953d9a
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIIQdgYJKoZIhvcNAQcCoIIQZzCCEGMCAQExDzANBglghkgBZQMEAgEFADALBgkqhkiG9w0BBwGg
gg3NMIIFDTCCA/WgAwIBAgIQeEqpED+lv77edQixNJMdADANBgkqhkiG9w0BAQsFADBMMSAwHgYD
VQQLExdHbG9iYWxTaWduIFJvb3QgQ0EgLSBSMzETMBEGA1UEChMKR2xvYmFsU2lnbjETMBEGA1UE
AxMKR2xvYmFsU2lnbjAeFw0yMDA5MTYwMDAwMDBaFw0yODA5MTYwMDAwMDBaMFsxCzAJBgNVBAYT
AkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTEwLwYDVQQDEyhHbG9iYWxTaWduIEdDQyBS
MyBQZXJzb25hbFNpZ24gMiBDQSAyMDIwMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA
vbCmXCcsbZ/a0fRIQMBxp4gJnnyeneFYpEtNydrZZ+GeKSMdHiDgXD1UnRSIudKo+moQ6YlCOu4t
rVWO/EiXfYnK7zeop26ry1RpKtogB7/O115zultAz64ydQYLe+a1e/czkALg3sgTcOOcFZTXk38e
aqsXsipoX1vsNurqPtnC27TWsA7pk4uKXscFjkeUE8JZu9BDKaswZygxBOPBQBwrA5+20Wxlk6k1
e6EKaaNaNZUy30q3ArEf30ZDpXyfCtiXnupjSK8WU2cK4qsEtj09JS4+mhi0CTCrCnXAzum3tgcH
cHRg0prcSzzEUDQWoFxyuqwiwhHu3sPQNmFOMwIDAQABo4IB2jCCAdYwDgYDVR0PAQH/BAQDAgGG
MGAGA1UdJQRZMFcGCCsGAQUFBwMCBggrBgEFBQcDBAYKKwYBBAGCNxQCAgYKKwYBBAGCNwoDBAYJ
KwYBBAGCNxUGBgorBgEEAYI3CgMMBggrBgEFBQcDBwYIKwYBBQUHAxEwEgYDVR0TAQH/BAgwBgEB
/wIBADAdBgNVHQ4EFgQUljPR5lgXWzR1ioFWZNW+SN6hj88wHwYDVR0jBBgwFoAUj/BLf6guRSSu
TVD6Y5qL3uLdG7wwegYIKwYBBQUHAQEEbjBsMC0GCCsGAQUFBzABhiFodHRwOi8vb2NzcC5nbG9i
YWxzaWduLmNvbS9yb290cjMwOwYIKwYBBQUHMAKGL2h0dHA6Ly9zZWN1cmUuZ2xvYmFsc2lnbi5j
b20vY2FjZXJ0L3Jvb3QtcjMuY3J0MDYGA1UdHwQvMC0wK6ApoCeGJWh0dHA6Ly9jcmwuZ2xvYmFs
c2lnbi5jb20vcm9vdC1yMy5jcmwwWgYDVR0gBFMwUTALBgkrBgEEAaAyASgwQgYKKwYBBAGgMgEo
CjA0MDIGCCsGAQUFBwIBFiZodHRwczovL3d3dy5nbG9iYWxzaWduLmNvbS9yZXBvc2l0b3J5LzAN
BgkqhkiG9w0BAQsFAAOCAQEAdAXk/XCnDeAOd9nNEUvWPxblOQ/5o/q6OIeTYvoEvUUi2qHUOtbf
jBGdTptFsXXe4RgjVF9b6DuizgYfy+cILmvi5hfk3Iq8MAZsgtW+A/otQsJvK2wRatLE61RbzkX8
9/OXEZ1zT7t/q2RiJqzpvV8NChxIj+P7WTtepPm9AIj0Keue+gS2qvzAZAY34ZZeRHgA7g5O4TPJ
/oTd+4rgiU++wLDlcZYd/slFkaT3xg4qWDepEMjT4T1qFOQIL+ijUArYS4owpPg9NISTKa1qqKWJ
jFoyms0d0GwOniIIbBvhI2MJ7BSY9MYtWVT5jJO3tsVHwj4cp92CSFuGwunFMzCCA18wggJHoAMC
AQICCwQAAAAAASFYUwiiMA0GCSqGSIb3DQEBCwUAMEwxIDAeBgNVBAsTF0dsb2JhbFNpZ24gUm9v
dCBDQSAtIFIzMRMwEQYDVQQKEwpHbG9iYWxTaWduMRMwEQYDVQQDEwpHbG9iYWxTaWduMB4XDTA5
MDMxODEwMDAwMFoXDTI5MDMxODEwMDAwMFowTDEgMB4GA1UECxMXR2xvYmFsU2lnbiBSb290IENB
IC0gUjMxEzARBgNVBAoTCkdsb2JhbFNpZ24xEzARBgNVBAMTCkdsb2JhbFNpZ24wggEiMA0GCSqG
SIb3DQEBAQUAA4IBDwAwggEKAoIBAQDMJXaQeQZ4Ihb1wIO2hMoonv0FdhHFrYhy/EYCQ8eyip0E
XyTLLkvhYIJG4VKrDIFHcGzdZNHr9SyjD4I9DCuul9e2FIYQebs7E4B3jAjhSdJqYi8fXvqWaN+J
J5U4nwbXPsnLJlkNc96wyOkmDoMVxu9bi9IEYMpJpij2aTv2y8gokeWdimFXN6x0FNx04Druci8u
nPvQu7/1PQDhBjPogiuuU6Y6FnOM3UEOIDrAtKeh6bJPkC4yYOlXy7kEkmho5TgmYHWyn3f/kRTv
riBJ/K1AFUjRAjFhGV64l++td7dkmnq/X8ET75ti+w1s4FRpFqkD2m7pg5NxdsZphYIXAgMBAAGj
QjBAMA4GA1UdDwEB/wQEAwIBBjAPBgNVHRMBAf8EBTADAQH/MB0GA1UdDgQWBBSP8Et/qC5FJK5N
UPpjmove4t0bvDANBgkqhkiG9w0BAQsFAAOCAQEAS0DbwFCq/sgM7/eWVEVJu5YACUGssxOGhigH
M8pr5nS5ugAtrqQK0/Xx8Q+Kv3NnSoPHRHt44K9ubG8DKY4zOUXDjuS5V2yq/BKW7FPGLeQkbLmU
Y/vcU2hnVj6DuM81IcPJaP7O2sJTqsyQiunwXUaMld16WCgaLx3ezQA3QY/tRG3XUyiXfvNnBB4V
14qWtNPeTCekTBtzc3b0F5nCH3oO4y0IrQocLP88q1UOD5F+NuvDV0m+4S4tfGCLw0FREyOdzvcy
a5QBqJnnLDMfOjsl0oZAzjsshnjJYS8Uuu7bVW/fhO4FCU29KNhyztNiUGUe65KXgzHZs7XKR1g/
XzCCBVUwggQ9oAMCAQICDBCmE9BT7srhoNHDEDANBgkqhkiG9w0BAQsFADBbMQswCQYDVQQGEwJC
RTEZMBcGA1UEChMQR2xvYmFsU2lnbiBudi1zYTExMC8GA1UEAxMoR2xvYmFsU2lnbiBHQ0MgUjMg
UGVyc29uYWxTaWduIDIgQ0EgMjAyMDAeFw0yMTAyMjIxNDE4MjdaFw0yMjA5MjIxNDUxNDlaMIGW
MQswCQYDVQQGEwJJTjESMBAGA1UECBMJS2FybmF0YWthMRIwEAYDVQQHEwlCYW5nYWxvcmUxFjAU
BgNVBAoTDUJyb2FkY29tIEluYy4xHDAaBgNVBAMTE0FqaXQgS3VtYXIgS2hhcGFyZGUxKTAnBgkq
hkiG9w0BCQEWGmFqaXQua2hhcGFyZGVAYnJvYWRjb20uY29tMIIBIjANBgkqhkiG9w0BAQEFAAOC
AQ8AMIIBCgKCAQEAwXsxfYF9jpj9zve1vXxD491SrWDVlcmLMdnOS1c7POMC8lbbgvp1o2kIu/3n
xCVFTai5H6rHZgrFItNNVZ+XaJW9Ob9eiSuXdnAu5gVdTb+IFAf4S/PT2LXzpP07M7vyvm/yvA+8
HtVfapzqqTNYdNVUpq28MYsKEWbnyK94x5+C3oCAV4bpNnMoPNtKrMhvOdpTREQRyew8hyy3/Mz7
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
U+7K4aDRwxAwDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIH4VFwIWtxPaX1p46uCx
/hApoQeji6ErH4TGgNsYh+AIMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkF
MQ8XDTIyMDcyNDIzMTUxMFowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUD
BAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsG
CWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQCxRWi6xOZoe/YUV2DNb/Q2VB+jGEjkWRYV7VPz
ljnppVdC+WImeOehu3bj8FobE4YEaExEVD/dRRKWq75Ki596cGMYgVyWqN0d5Je+2sSvZKZQomRy
SrRofEo2ooh3akjl9gOLSR+Sf5TqBqptOz3NkzZRy+pCAN7nmSwnr7IFdVAMnxAX2RAQvvP5ZkMR
KQjYXJ9ptK2rSj/nK5/cnly3AASa1tSPsiSpwzGDK+vcRb4Jv4Xf0tHlH3PITEpuGJVRgNCGJeG4
MseYw5gGftlz5SdkXLBQR2HQluLuzHSp9nKlkMmiwdI1meSEIiA0uE/+djHG0pc2Q40OJHM06gCA
--000000000000279d3105e4953d9a--
