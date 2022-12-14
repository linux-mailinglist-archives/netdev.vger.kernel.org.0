Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7C7C64CE11
	for <lists+netdev@lfdr.de>; Wed, 14 Dec 2022 17:32:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239040AbiLNQcI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Dec 2022 11:32:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239043AbiLNQbl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Dec 2022 11:31:41 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E884862F5
        for <netdev@vger.kernel.org>; Wed, 14 Dec 2022 08:30:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671035459;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=M+wOP66zSvRhQYDjszQYz+C5vn4h5BGATu0cy0bUORc=;
        b=Q15AwZRiKDTWOvdrxLlpUxbg6A4w0hx4nX46culqdRURxGAuMPk5NJi24/Qlf0gwIgOkTG
        6LaOvuHkZCsLyBO/R2i/ntvR9YUfgx6rY5sOt6g3LlIc1fHNaVgx3DnPO/LebuwvLiJxTu
        wBVqejwmlXwT/DpKnJYgRjjCsXxKvuo=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-496-j_8JbJghN6OetsetQUtjfA-1; Wed, 14 Dec 2022 11:30:57 -0500
X-MC-Unique: j_8JbJghN6OetsetQUtjfA-1
Received: by mail-wm1-f70.google.com with SMTP id b47-20020a05600c4aaf00b003d031aeb1b6so7424717wmp.9
        for <netdev@vger.kernel.org>; Wed, 14 Dec 2022 08:30:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=M+wOP66zSvRhQYDjszQYz+C5vn4h5BGATu0cy0bUORc=;
        b=ipqQfZ67RVMA7vMz/DdhQiYB9ap5vnI3Pem5Lrc8RTUJg2uJ48UQIJIxtvWaBLq9b2
         MOHXeclS5acI1i9NrvC6c8H1dziMOBeCKloigdVTSLwyghsn84ravMjHVzhG8wuMXDuW
         MAL8ugU3gTsLukPrk5oujXreuphCBJ2BTU2zWC+0rTJT6N/V6vn04KSQloQqiAyJQsch
         XTGoCHVE3r6AxAeyi6cCwHgFQhv3OItWu/0S8Mp2lsz8uiZfrvCLevgLeTyqwh97t3qJ
         epTw7lEz5LCQ2fo+3fgjEalqCqzyJQvGfI6T8XDeSbLFoNiYQzHNtXQcsKVDxbr58WDF
         uLhQ==
X-Gm-Message-State: ANoB5pmVUwXC7/Il2EKL6eAjSc6iDc03QciD14vq4Rt+NfUQ5rVCyf16
        ANizgbGwX9Ap0FkBTl0gQKfdC0wSJIFpwGshq0q5vRHSrQRUjbgNQdWdSSPUO+VSDwWTDu+LXAk
        PbazICJPjMm+Ubt4o
X-Received: by 2002:a05:600c:3c95:b0:3d0:4af1:a36e with SMTP id bg21-20020a05600c3c9500b003d04af1a36emr19162740wmb.26.1671035456704;
        Wed, 14 Dec 2022 08:30:56 -0800 (PST)
X-Google-Smtp-Source: AA0mqf60WGqYgsSKb75OsCZF9FEfxsX89v9hIf3pvnwfZ9ScHyDYE49t9+hNy2gQ3Yhy/2cfcsbUgg==
X-Received: by 2002:a05:600c:3c95:b0:3d0:4af1:a36e with SMTP id bg21-20020a05600c3c9500b003d04af1a36emr19162723wmb.26.1671035456529;
        Wed, 14 Dec 2022 08:30:56 -0800 (PST)
Received: from step1.redhat.com (host-87-11-6-51.retail.telecomitalia.it. [87.11.6.51])
        by smtp.gmail.com with ESMTPSA id c6-20020a05600c0a4600b003d1e3b1624dsm3850323wmq.2.2022.12.14.08.30.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Dec 2022 08:30:55 -0800 (PST)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     virtualization@lists.linux-foundation.org
Cc:     Jason Wang <jasowang@redhat.com>,
        Andrey Zhadchenko <andrey.zhadchenko@virtuozzo.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>, eperezma@redhat.com,
        stefanha@redhat.com, netdev@vger.kernel.org,
        Stefano Garzarella <sgarzare@redhat.com>
Subject: [RFC PATCH 4/6] vdpa_sim: make devices agnostic for work management
Date:   Wed, 14 Dec 2022 17:30:23 +0100
Message-Id: <20221214163025.103075-5-sgarzare@redhat.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221214163025.103075-1-sgarzare@redhat.com>
References: <20221214163025.103075-1-sgarzare@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Let's move work management inside the vdpa_sim core.
This way we can easily change how we manage the works, without
having to change the devices each time.

Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
 drivers/vdpa/vdpa_sim/vdpa_sim.h     |  3 ++-
 drivers/vdpa/vdpa_sim/vdpa_sim.c     | 17 +++++++++++++++--
 drivers/vdpa/vdpa_sim/vdpa_sim_blk.c |  6 ++----
 drivers/vdpa/vdpa_sim/vdpa_sim_net.c |  6 ++----
 4 files changed, 21 insertions(+), 11 deletions(-)

diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim.h b/drivers/vdpa/vdpa_sim/vdpa_sim.h
index 0e78737dcc16..7e6dd366856f 100644
--- a/drivers/vdpa/vdpa_sim/vdpa_sim.h
+++ b/drivers/vdpa/vdpa_sim/vdpa_sim.h
@@ -44,7 +44,7 @@ struct vdpasim_dev_attr {
 	u32 ngroups;
 	u32 nas;
 
-	work_func_t work_fn;
+	void (*work_fn)(struct vdpasim *vdpasim);
 	void (*get_config)(struct vdpasim *vdpasim, void *config);
 	void (*set_config)(struct vdpasim *vdpasim, const void *config);
 };
@@ -73,6 +73,7 @@ struct vdpasim {
 
 struct vdpasim *vdpasim_create(struct vdpasim_dev_attr *attr,
 			       const struct vdpa_dev_set_config *config);
+void vdpasim_schedule_work(struct vdpasim *vdpasim);
 
 /* TODO: cross-endian support */
 static inline bool vdpasim_is_little_endian(struct vdpasim *vdpasim)
diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim.c b/drivers/vdpa/vdpa_sim/vdpa_sim.c
index 2e0ee7280aa8..9bde33e38e27 100644
--- a/drivers/vdpa/vdpa_sim/vdpa_sim.c
+++ b/drivers/vdpa/vdpa_sim/vdpa_sim.c
@@ -245,6 +245,13 @@ static const struct dma_map_ops vdpasim_dma_ops = {
 static const struct vdpa_config_ops vdpasim_config_ops;
 static const struct vdpa_config_ops vdpasim_batch_config_ops;
 
+static void vdpasim_work_fn(struct work_struct *work)
+{
+	struct vdpasim *vdpasim = container_of(work, struct vdpasim, work);
+
+	vdpasim->dev_attr.work_fn(vdpasim);
+}
+
 struct vdpasim *vdpasim_create(struct vdpasim_dev_attr *dev_attr,
 			       const struct vdpa_dev_set_config *config)
 {
@@ -275,7 +282,7 @@ struct vdpasim *vdpasim_create(struct vdpasim_dev_attr *dev_attr,
 	}
 
 	vdpasim->dev_attr = *dev_attr;
-	INIT_WORK(&vdpasim->work, dev_attr->work_fn);
+	INIT_WORK(&vdpasim->work, vdpasim_work_fn);
 	spin_lock_init(&vdpasim->lock);
 	spin_lock_init(&vdpasim->iommu_lock);
 
@@ -329,6 +336,12 @@ struct vdpasim *vdpasim_create(struct vdpasim_dev_attr *dev_attr,
 }
 EXPORT_SYMBOL_GPL(vdpasim_create);
 
+void vdpasim_schedule_work(struct vdpasim *vdpasim)
+{
+	schedule_work(&vdpasim->work);
+}
+EXPORT_SYMBOL_GPL(vdpasim_schedule_work);
+
 static int vdpasim_set_vq_address(struct vdpa_device *vdpa, u16 idx,
 				  u64 desc_area, u64 driver_area,
 				  u64 device_area)
@@ -357,7 +370,7 @@ static void vdpasim_kick_vq(struct vdpa_device *vdpa, u16 idx)
 	struct vdpasim_virtqueue *vq = &vdpasim->vqs[idx];
 
 	if (vq->ready)
-		schedule_work(&vdpasim->work);
+		vdpasim_schedule_work(vdpasim);
 }
 
 static void vdpasim_set_vq_cb(struct vdpa_device *vdpa, u16 idx,
diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim_blk.c b/drivers/vdpa/vdpa_sim/vdpa_sim_blk.c
index c6db1a1baf76..ae2309411acd 100644
--- a/drivers/vdpa/vdpa_sim/vdpa_sim_blk.c
+++ b/drivers/vdpa/vdpa_sim/vdpa_sim_blk.c
@@ -11,7 +11,6 @@
 #include <linux/module.h>
 #include <linux/device.h>
 #include <linux/kernel.h>
-#include <linux/sched.h>
 #include <linux/blkdev.h>
 #include <linux/vringh.h>
 #include <linux/vdpa.h>
@@ -286,9 +285,8 @@ static bool vdpasim_blk_handle_req(struct vdpasim *vdpasim,
 	return handled;
 }
 
-static void vdpasim_blk_work(struct work_struct *work)
+static void vdpasim_blk_work(struct vdpasim *vdpasim)
 {
-	struct vdpasim *vdpasim = container_of(work, struct vdpasim, work);
 	bool reschedule = false;
 	int i;
 
@@ -326,7 +324,7 @@ static void vdpasim_blk_work(struct work_struct *work)
 	spin_unlock(&vdpasim->lock);
 
 	if (reschedule)
-		schedule_work(&vdpasim->work);
+		vdpasim_schedule_work(vdpasim);
 }
 
 static void vdpasim_blk_get_config(struct vdpasim *vdpasim, void *config)
diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim_net.c b/drivers/vdpa/vdpa_sim/vdpa_sim_net.c
index c3cb225ea469..a209df365158 100644
--- a/drivers/vdpa/vdpa_sim/vdpa_sim_net.c
+++ b/drivers/vdpa/vdpa_sim/vdpa_sim_net.c
@@ -11,7 +11,6 @@
 #include <linux/module.h>
 #include <linux/device.h>
 #include <linux/kernel.h>
-#include <linux/sched.h>
 #include <linux/etherdevice.h>
 #include <linux/vringh.h>
 #include <linux/vdpa.h>
@@ -143,9 +142,8 @@ static void vdpasim_handle_cvq(struct vdpasim *vdpasim)
 	}
 }
 
-static void vdpasim_net_work(struct work_struct *work)
+static void vdpasim_net_work(struct vdpasim *vdpasim)
 {
-	struct vdpasim *vdpasim = container_of(work, struct vdpasim, work);
 	struct vdpasim_virtqueue *txq = &vdpasim->vqs[1];
 	struct vdpasim_virtqueue *rxq = &vdpasim->vqs[0];
 	ssize_t read, write;
@@ -196,7 +194,7 @@ static void vdpasim_net_work(struct work_struct *work)
 		vdpasim_net_complete(rxq, write);
 
 		if (++pkts > 4) {
-			schedule_work(&vdpasim->work);
+			vdpasim_schedule_work(vdpasim);
 			goto out;
 		}
 	}
-- 
2.38.1

