Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36939231ECA
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 14:49:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726772AbgG2Mty (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 08:49:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726353AbgG2Mtx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jul 2020 08:49:53 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56A16C061794
        for <netdev@vger.kernel.org>; Wed, 29 Jul 2020 05:49:53 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id 88so21513723wrh.3
        for <netdev@vger.kernel.org>; Wed, 29 Jul 2020 05:49:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=SvqfzI3dcFvTUskVhpUZMUSlodMjNNFCGulVlLRHszE=;
        b=zivr2/68v19gWeogM8LaiAyPgwFzpVTIaSZnnALx/kf4DAxsoT9WhOK7PfYJGfqlqe
         TpnOyUfZP4HMusT+cVk+YAqMrjYgf9LUdWTuHpo90RL7PAAK4FemElJClSoa5kqIsxcK
         pFDApoitmisLo3rK3j3jK+GLeHT+8s0qDEe9BDOqRTaAj4rWrlhNw3XJ5TspBXlKwD9h
         h4LDBcLW9ZZz/vRUY9/x4GAg52JkguGcVMQymN/RvZWdD3Jpp0nercE1LS6CzDa/xx04
         rIrFLVIdVM24KUopByFYuQ+HtM+ipb1S4UHx5fXII9rhXRBd90MPPKoapSjB3LvJbBV8
         0WBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=SvqfzI3dcFvTUskVhpUZMUSlodMjNNFCGulVlLRHszE=;
        b=sY8myEag5S1FG2corQRxVXG9tP34y9vYFIUwtUw8TaawvOgszm+udMryUd23bUD5eE
         2T/vg1JON3EimWPiOTYUGHai7P3wBdxHCbMxSQkhVlWB+nSU3mAnpqJetD+T+NQhifZx
         hgwkun28RWWgWzb3hM2zhy4UdOP32gnuSY4Lo6OFmGTl+qqEelPspCkeJwCNXGQuOsc3
         1AE1UbhI871Iw4yk8EPaG6UvndDb7Vv0rb8WwgqPsSitBTtno3KUbdZLP44hCtCXPMJv
         A4J/IvPlNv1J7bhS3Mis3UeJZFlP1TBQMVf6d6SLio3X6rXvcCTBaB+5dGn0m3pS3z+c
         aFVA==
X-Gm-Message-State: AOAM531Qh+Im5mKLX8RCYTSki6YbBLPHfqYccXpi2vCTKNZOKkJ5IkXn
        y7Y7o6ANFcSF1cUnE3E6JgJ5JOAjSBg=
X-Google-Smtp-Source: ABdhPJwb5GIvOMpoiNjTvwfu+3RJVJ1c1B59YNhEBir8rqHQHAwhCOX/5DNF8XocJGzcXbkBmQTysw==
X-Received: by 2002:adf:8024:: with SMTP id 33mr31745155wrk.117.1596026990352;
        Wed, 29 Jul 2020 05:49:50 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id k184sm5184246wme.1.2020.07.29.05.49.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jul 2020 05:49:49 -0700 (PDT)
Date:   Wed, 29 Jul 2020 14:49:49 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Igor Russkikh <irusskikh@marvell.com>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ariel Elior <aelior@marvell.com>,
        Michal Kalderon <mkalderon@marvell.com>,
        Alexander Lobakin <alobakin@marvell.com>,
        Michal Kalderon <michal.kalderon@marvell.com>
Subject: Re: [PATCH v3 net-next 02/11] qed/qede: make devlink survive recovery
Message-ID: <20200729124949.GB2204@nanopsycho>
References: <20200729113846.1551-1-irusskikh@marvell.com>
 <20200729113846.1551-3-irusskikh@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200729113846.1551-3-irusskikh@marvell.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Jul 29, 2020 at 01:38:37PM CEST, irusskikh@marvell.com wrote:
>Before that, devlink instance lifecycle was linked to qed_dev object,

Before what?


>that causes devlink to be recreated on each recovery.
>
>Changing it by making higher level driver (qede) responsible for its
>life. This way devlink will survive recoveries.
>
>qede will store devlink structure pointer as a part of its device
>object, devlink private data contains a linkage structure, it'll
>contain extra devlink related content in following patches.
>
>The same lifecycle should be applied to storage drivers (qedf/qedi) later.

From this, one can't really tell if you are talking about existing state
or about the matter of this patch. In the patch description, you should
be imperative to the codebase telling it what to do. Could you please do
that?


>
>Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
>Signed-off-by: Alexander Lobakin <alobakin@marvell.com>
>Signed-off-by: Michal Kalderon <michal.kalderon@marvell.com>
>---
> drivers/net/ethernet/qlogic/qed/qed.h         |  1 -
> drivers/net/ethernet/qlogic/qed/qed_devlink.c | 40 ++++++++-----------
> drivers/net/ethernet/qlogic/qed/qed_devlink.h |  4 +-
> drivers/net/ethernet/qlogic/qed/qed_main.c    | 10 +----
> drivers/net/ethernet/qlogic/qede/qede.h       |  1 +
> drivers/net/ethernet/qlogic/qede/qede_main.c  | 18 +++++++++
> include/linux/qed/qed_if.h                    |  9 +++++
> 7 files changed, 48 insertions(+), 35 deletions(-)
>
>diff --git a/drivers/net/ethernet/qlogic/qed/qed.h b/drivers/net/ethernet/qlogic/qed/qed.h
>index b2a7b53ee760..b6ce1488abcc 100644
>--- a/drivers/net/ethernet/qlogic/qed/qed.h
>+++ b/drivers/net/ethernet/qlogic/qed/qed.h
>@@ -849,7 +849,6 @@ struct qed_dev {
> 	u32 rdma_max_srq_sge;
> 	u16 tunn_feature_mask;
> 
>-	struct devlink			*dl;
> 	bool				iwarp_cmt;
> };
> 
>diff --git a/drivers/net/ethernet/qlogic/qed/qed_devlink.c b/drivers/net/ethernet/qlogic/qed/qed_devlink.c
>index eb693787c99e..a62c47c61edf 100644
>--- a/drivers/net/ethernet/qlogic/qed/qed_devlink.c
>+++ b/drivers/net/ethernet/qlogic/qed/qed_devlink.c
>@@ -5,6 +5,7 @@
>  */
> 
> #include <linux/kernel.h>
>+#include <linux/qed/qed_if.h>
> #include "qed.h"
> #include "qed_devlink.h"
> 
>@@ -13,17 +14,12 @@ enum qed_devlink_param_id {
> 	QED_DEVLINK_PARAM_ID_IWARP_CMT,
> };
> 
>-struct qed_devlink {
>-	struct qed_dev *cdev;
>-};
>-
> static int qed_dl_param_get(struct devlink *dl, u32 id,
> 			    struct devlink_param_gset_ctx *ctx)
> {
>-	struct qed_devlink *qed_dl;
>+	struct qed_devlink *qed_dl = devlink_priv(dl);
> 	struct qed_dev *cdev;
> 
>-	qed_dl = devlink_priv(dl);
> 	cdev = qed_dl->cdev;
> 	ctx->val.vbool = cdev->iwarp_cmt;
> 
>@@ -33,10 +29,9 @@ static int qed_dl_param_get(struct devlink *dl, u32 id,
> static int qed_dl_param_set(struct devlink *dl, u32 id,
> 			    struct devlink_param_gset_ctx *ctx)
> {
>-	struct qed_devlink *qed_dl;
>+	struct qed_devlink *qed_dl = devlink_priv(dl);
> 	struct qed_dev *cdev;
> 
>-	qed_dl = devlink_priv(dl);
> 	cdev = qed_dl->cdev;
> 	cdev->iwarp_cmt = ctx->val.vbool;
> 
>@@ -52,21 +47,19 @@ static const struct devlink_param qed_devlink_params[] = {
> 
> static const struct devlink_ops qed_dl_ops;
> 
>-int qed_devlink_register(struct qed_dev *cdev)
>+struct devlink *qed_devlink_register(struct qed_dev *cdev)
> {
> 	union devlink_param_value value;
>-	struct qed_devlink *qed_dl;
>+	struct qed_devlink *qdevlink;
> 	struct devlink *dl;
> 	int rc;
> 
>-	dl = devlink_alloc(&qed_dl_ops, sizeof(*qed_dl));
>+	dl = devlink_alloc(&qed_dl_ops, sizeof(struct qed_devlink));

Do "sizeof(*qdevlink)" instead.


> 	if (!dl)
>-		return -ENOMEM;
>+		return ERR_PTR(-ENOMEM);
> 
>-	qed_dl = devlink_priv(dl);
>-
>-	cdev->dl = dl;
>-	qed_dl->cdev = cdev;
>+	qdevlink = devlink_priv(dl);
>+	qdevlink->cdev = cdev;
> 
> 	rc = devlink_register(dl, &cdev->pdev->dev);
> 	if (rc)
>@@ -85,26 +78,25 @@ int qed_devlink_register(struct qed_dev *cdev)
> 	devlink_params_publish(dl);
> 	cdev->iwarp_cmt = false;
> 
>-	return 0;
>+	return dl;
> 
> err_unregister:
> 	devlink_unregister(dl);
> 
> err_free:
>-	cdev->dl = NULL;
> 	devlink_free(dl);
> 
>-	return rc;
>+	return ERR_PTR(rc);
> }
> 
>-void qed_devlink_unregister(struct qed_dev *cdev)
>+void qed_devlink_unregister(struct devlink *devlink)
> {
>-	if (!cdev->dl)
>+	if (!devlink)
> 		return;
> 
>-	devlink_params_unregister(cdev->dl, qed_devlink_params,
>+	devlink_params_unregister(devlink, qed_devlink_params,
> 				  ARRAY_SIZE(qed_devlink_params));
> 
>-	devlink_unregister(cdev->dl);
>-	devlink_free(cdev->dl);
>+	devlink_unregister(devlink);
>+	devlink_free(devlink);
> }
>diff --git a/drivers/net/ethernet/qlogic/qed/qed_devlink.h b/drivers/net/ethernet/qlogic/qed/qed_devlink.h
>index b94c40e9b7c1..c79dc6bfa194 100644
>--- a/drivers/net/ethernet/qlogic/qed/qed_devlink.h
>+++ b/drivers/net/ethernet/qlogic/qed/qed_devlink.h
>@@ -9,7 +9,7 @@
> #include <linux/qed/qed_if.h>
> #include <net/devlink.h>
> 
>-int qed_devlink_register(struct qed_dev *cdev);
>-void qed_devlink_unregister(struct qed_dev *cdev);
>+struct devlink *qed_devlink_register(struct qed_dev *cdev);
>+void qed_devlink_unregister(struct devlink *devlink);
> 
> #endif
>diff --git a/drivers/net/ethernet/qlogic/qed/qed_main.c b/drivers/net/ethernet/qlogic/qed/qed_main.c
>index 8751355d9ef7..d6f76421379b 100644
>--- a/drivers/net/ethernet/qlogic/qed/qed_main.c
>+++ b/drivers/net/ethernet/qlogic/qed/qed_main.c
>@@ -539,12 +539,6 @@ static struct qed_dev *qed_probe(struct pci_dev *pdev,
> 	}
> 	DP_INFO(cdev, "PCI init completed successfully\n");
> 
>-	rc = qed_devlink_register(cdev);
>-	if (rc) {
>-		DP_INFO(cdev, "Failed to register devlink.\n");
>-		goto err2;
>-	}
>-
> 	rc = qed_hw_prepare(cdev, QED_PCI_DEFAULT);
> 	if (rc) {
> 		DP_ERR(cdev, "hw prepare failed\n");
>@@ -574,8 +568,6 @@ static void qed_remove(struct qed_dev *cdev)
> 
> 	qed_set_power_state(cdev, PCI_D3hot);
> 
>-	qed_devlink_unregister(cdev);
>-
> 	qed_free_cdev(cdev);
> }
> 
>@@ -3012,6 +3004,8 @@ const struct qed_common_ops qed_common_ops_pass = {
> 	.get_link = &qed_get_current_link,
> 	.drain = &qed_drain,
> 	.update_msglvl = &qed_init_dp,
>+	.devlink_register = qed_devlink_register,
>+	.devlink_unregister = qed_devlink_unregister,
> 	.dbg_all_data = &qed_dbg_all_data,
> 	.dbg_all_data_size = &qed_dbg_all_data_size,
> 	.chain_alloc = &qed_chain_alloc,
>diff --git a/drivers/net/ethernet/qlogic/qede/qede.h b/drivers/net/ethernet/qlogic/qede/qede.h
>index 803c1fcca8ad..1f0e7505a973 100644
>--- a/drivers/net/ethernet/qlogic/qede/qede.h
>+++ b/drivers/net/ethernet/qlogic/qede/qede.h
>@@ -172,6 +172,7 @@ struct qede_dev {
> 	struct qed_dev			*cdev;
> 	struct net_device		*ndev;
> 	struct pci_dev			*pdev;
>+	struct devlink			*devlink;
> 
> 	u32				dp_module;
> 	u8				dp_level;
>diff --git a/drivers/net/ethernet/qlogic/qede/qede_main.c b/drivers/net/ethernet/qlogic/qede/qede_main.c
>index 1aaae3203f5a..7c2d948b2035 100644
>--- a/drivers/net/ethernet/qlogic/qede/qede_main.c
>+++ b/drivers/net/ethernet/qlogic/qede/qede_main.c
>@@ -1172,10 +1172,23 @@ static int __qede_probe(struct pci_dev *pdev, u32 dp_module, u8 dp_level,
> 			rc = -ENOMEM;
> 			goto err2;
> 		}
>+
>+		edev->devlink = qed_ops->common->devlink_register(cdev);
>+		if (IS_ERR(edev->devlink)) {
>+			DP_NOTICE(edev, "Cannot register devlink\n");
>+			edev->devlink = NULL;
>+			/* Go on, we can live without devlink */

Interesting. Why? This can happen only very pressing memory
circumstances. In that case, you should just fail to init. 


>+		}
> 	} else {
> 		struct net_device *ndev = pci_get_drvdata(pdev);
> 
> 		edev = netdev_priv(ndev);
>+
>+		if (edev && edev->devlink) {
>+			struct qed_devlink *qdl = devlink_priv(edev->devlink);
>+
>+			qdl->cdev = cdev;
>+		}
> 		edev->cdev = cdev;
> 		memset(&edev->stats, 0, sizeof(edev->stats));
> 		memcpy(&edev->dev_info, &dev_info, sizeof(dev_info));
>@@ -1298,6 +1311,11 @@ static void __qede_remove(struct pci_dev *pdev, enum qede_remove_mode mode)
> 	qed_ops->common->slowpath_stop(cdev);
> 	if (system_state == SYSTEM_POWER_OFF)
> 		return;
>+
>+	if (mode != QEDE_REMOVE_RECOVERY && edev->devlink) {
>+		qed_ops->common->devlink_unregister(edev->devlink);
>+		edev->devlink = NULL;
>+	}
> 	qed_ops->common->remove(cdev);
> 	edev->cdev = NULL;
> 
>diff --git a/include/linux/qed/qed_if.h b/include/linux/qed/qed_if.h
>index cd6a5c7e56eb..d8368e1770df 100644
>--- a/include/linux/qed/qed_if.h
>+++ b/include/linux/qed/qed_if.h
>@@ -21,6 +21,7 @@
> #include <linux/qed/common_hsi.h>
> #include <linux/qed/qed_chain.h>
> #include <linux/io-64-nonatomic-lo-hi.h>
>+#include <net/devlink.h>
> 
> enum dcbx_protocol_type {
> 	DCBX_PROTOCOL_ISCSI,
>@@ -779,6 +780,10 @@ enum qed_nvm_flash_cmd {
> 	QED_NVM_FLASH_CMD_NVM_MAX,
> };
> 
>+struct qed_devlink {
>+	struct qed_dev *cdev;
>+};
>+
> struct qed_common_cb_ops {
> 	void (*arfs_filter_op)(void *dev, void *fltr, u8 fw_rc);
> 	void (*link_update)(void *dev, struct qed_link_output *link);
>@@ -1137,6 +1142,10 @@ struct qed_common_ops {
>  *
>  */
> 	int (*set_grc_config)(struct qed_dev *cdev, u32 cfg_id, u32 val);
>+
>+	struct devlink* (*devlink_register)(struct qed_dev *cdev);
>+
>+	void (*devlink_unregister)(struct devlink *devlink);
> };
> 
> #define MASK_FIELD(_name, _value) \
>-- 
>2.17.1
>
