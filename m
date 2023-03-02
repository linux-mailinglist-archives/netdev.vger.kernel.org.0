Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED4C46A8146
	for <lists+netdev@lfdr.de>; Thu,  2 Mar 2023 12:37:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229695AbjCBLh2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Mar 2023 06:37:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229840AbjCBLhN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Mar 2023 06:37:13 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2728F497EF
        for <netdev@vger.kernel.org>; Thu,  2 Mar 2023 03:35:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677756946;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8ei7n2l78e4NFmvUi+bOVTMUuSnDAXEzTgyerL27l10=;
        b=SiKWFQEsjux9pg7VcflKRjwXsMx2t4MEgSQjLUbocfexN4n7yUTyFIwasVmDxJk7tWjTSE
        vfsCID+KZCOf3eTyu0KKix0o1V3uCBb+3jEAvXLriy85RpzoTFSyVpP39qdFtbcuA+uTE1
        Opol4lLm/zofmnMhSnlIl8IFoZBfo68=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-100-55g2su4OPXa9UpV7IpEyng-1; Thu, 02 Mar 2023 06:35:45 -0500
X-MC-Unique: 55g2su4OPXa9UpV7IpEyng-1
Received: by mail-qt1-f197.google.com with SMTP id ga17-20020a05622a591100b003bfdf586476so6174311qtb.7
        for <netdev@vger.kernel.org>; Thu, 02 Mar 2023 03:35:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677756944;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8ei7n2l78e4NFmvUi+bOVTMUuSnDAXEzTgyerL27l10=;
        b=qBiIkSfh25xR5p8Ay+eQZbNTJpe1CWGQy5mFyck1rCwTbEGPc6aOrI3CBDYJJVdEX0
         LoTDb6sEBZ8zKlBJ2gYZrS8k8znaVTI7mJ8hnHN8/RkOGFQU0OEyhR82qH2czncuQ4c5
         OtEKWllfEq/mEFmI0BimJfzZtJG7SaMFcL/wgZzGGCOzPPlLOB1oQBhzfC8TTW64b0Zv
         gQxvkDd6TYkzj/0jfRc2IkJUSn6X2srNap03zl3nmj/lOOLdiHxIFFqBKVgRK7sXHzcb
         inu8ppu3A6nFgyX0B8h/egrqSx3j/zg13UrTj2WewGppDq/LGmbWt7IcfDRBDp5kwXu3
         ldCg==
X-Gm-Message-State: AO0yUKVMIHzMwowI0lYGY4uwh62ZpS15PZ66GQb2zfYV7BtdxEzKZ2r5
        td9UDRXxurwpB7SC7Pc7KrkhXKYBpSXg/veXP4FJIdH9egCMikZhefe/p2+r3keOmiGaEcEiNNI
        BdfyTE/GO7iIu3PPftnY/Zw==
X-Received: by 2002:a05:6214:23cc:b0:56f:796e:c3a5 with SMTP id hr12-20020a05621423cc00b0056f796ec3a5mr15695870qvb.4.1677756944507;
        Thu, 02 Mar 2023 03:35:44 -0800 (PST)
X-Google-Smtp-Source: AK7set8Ak8Ucf6C6K7kn5+/O12tTcTPMHjMyg5Hg/gChXMJzzgv24g/Sgnux1N4dFSCrO8nMsW3JDg==
X-Received: by 2002:a05:6214:23cc:b0:56f:796e:c3a5 with SMTP id hr12-20020a05621423cc00b0056f796ec3a5mr15695849qvb.4.1677756944236;
        Thu, 02 Mar 2023 03:35:44 -0800 (PST)
Received: from step1.redhat.com (c-115-213.cust-q.wadsl.it. [212.43.115.213])
        by smtp.gmail.com with ESMTPSA id m26-20020ae9e01a000000b00741d87eb5d1sm10630925qkk.105.2023.03.02.03.35.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Mar 2023 03:35:43 -0800 (PST)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     virtualization@lists.linux-foundation.org
Cc:     Andrey Zhadchenko <andrey.zhadchenko@virtuozzo.com>,
        eperezma@redhat.com, netdev@vger.kernel.org, stefanha@redhat.com,
        linux-kernel@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org,
        Stefano Garzarella <sgarzare@redhat.com>
Subject: [PATCH v2 8/8] vdpa_sim: add support for user VA
Date:   Thu,  2 Mar 2023 12:34:21 +0100
Message-Id: <20230302113421.174582-9-sgarzare@redhat.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230302113421.174582-1-sgarzare@redhat.com>
References: <20230302113421.174582-1-sgarzare@redhat.com>
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

The new "use_va" module parameter (default: false) is used in
vdpa_alloc_device() to inform the vDPA framework that the device
supports VA.

vringh is initialized to use VA only when "use_va" is true and the
user's mm has been bound. So, only when the bus supports user VA
(e.g. vhost-vdpa).

vdpasim_mm_work_fn work is used to attach the kthread to the user
address space when the .bind_mm callback is invoked, and to detach
it when the .unbind_mm callback is invoked.

Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---

Notes:
    v2:
    - `use_va` set to true by default [Eugenio]
    - supported the new unbind_mm callback [Jason]
    - removed the unbind_mm call in vdpasim_do_reset() [Jason]
    - avoided to release the lock while call kthread_flush_work() since we
      are now using a mutex to protect the device state

 drivers/vdpa/vdpa_sim/vdpa_sim.h |  1 +
 drivers/vdpa/vdpa_sim/vdpa_sim.c | 98 +++++++++++++++++++++++++++++++-
 2 files changed, 97 insertions(+), 2 deletions(-)

diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim.h b/drivers/vdpa/vdpa_sim/vdpa_sim.h
index 4774292fba8c..3a42887d05d9 100644
--- a/drivers/vdpa/vdpa_sim/vdpa_sim.h
+++ b/drivers/vdpa/vdpa_sim/vdpa_sim.h
@@ -59,6 +59,7 @@ struct vdpasim {
 	struct vdpasim_virtqueue *vqs;
 	struct kthread_worker *worker;
 	struct kthread_work work;
+	struct mm_struct *mm_bound;
 	struct vdpasim_dev_attr dev_attr;
 	/* mutex to synchronize virtqueue state */
 	struct mutex mutex;
diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim.c b/drivers/vdpa/vdpa_sim/vdpa_sim.c
index a28103a67ae7..eda26bc33df5 100644
--- a/drivers/vdpa/vdpa_sim/vdpa_sim.c
+++ b/drivers/vdpa/vdpa_sim/vdpa_sim.c
@@ -35,10 +35,77 @@ module_param(max_iotlb_entries, int, 0444);
 MODULE_PARM_DESC(max_iotlb_entries,
 		 "Maximum number of iotlb entries for each address space. 0 means unlimited. (default: 2048)");
 
+static bool use_va = true;
+module_param(use_va, bool, 0444);
+MODULE_PARM_DESC(use_va, "Enable/disable the device's ability to use VA");
+
 #define VDPASIM_QUEUE_ALIGN PAGE_SIZE
 #define VDPASIM_QUEUE_MAX 256
 #define VDPASIM_VENDOR_ID 0
 
+struct vdpasim_mm_work {
+	struct kthread_work work;
+	struct mm_struct *mm;
+	bool bind;
+	int ret;
+};
+
+static void vdpasim_mm_work_fn(struct kthread_work *work)
+{
+	struct vdpasim_mm_work *mm_work =
+		container_of(work, struct vdpasim_mm_work, work);
+
+	mm_work->ret = 0;
+
+	if (mm_work->bind) {
+		kthread_use_mm(mm_work->mm);
+		//TODO: should we attach the cgroup of the mm owner?
+	} else {
+		kthread_unuse_mm(mm_work->mm);
+	}
+}
+
+static void vdpasim_worker_queue_mm(struct vdpasim *vdpasim,
+				    struct vdpasim_mm_work *mm_work)
+{
+	struct kthread_work *work = &mm_work->work;
+
+	kthread_init_work(work, vdpasim_mm_work_fn);
+	kthread_queue_work(vdpasim->worker, work);
+
+	kthread_flush_work(work);
+}
+
+static int vdpasim_worker_bind_mm(struct vdpasim *vdpasim,
+				  struct mm_struct *new_mm)
+{
+	struct vdpasim_mm_work mm_work;
+
+	mm_work.mm = new_mm;
+	mm_work.bind = true;
+
+	vdpasim_worker_queue_mm(vdpasim, &mm_work);
+
+	if (!mm_work.ret)
+		vdpasim->mm_bound = new_mm;
+
+	return mm_work.ret;
+}
+
+static void vdpasim_worker_unbind_mm(struct vdpasim *vdpasim)
+{
+	struct vdpasim_mm_work mm_work;
+
+	if (!vdpasim->mm_bound)
+		return;
+
+	mm_work.mm = vdpasim->mm_bound;
+	mm_work.bind = false;
+
+	vdpasim_worker_queue_mm(vdpasim, &mm_work);
+
+	vdpasim->mm_bound = NULL;
+}
 static struct vdpasim *vdpa_to_sim(struct vdpa_device *vdpa)
 {
 	return container_of(vdpa, struct vdpasim, vdpa);
@@ -59,8 +126,10 @@ static void vdpasim_queue_ready(struct vdpasim *vdpasim, unsigned int idx)
 {
 	struct vdpasim_virtqueue *vq = &vdpasim->vqs[idx];
 	uint16_t last_avail_idx = vq->vring.last_avail_idx;
+	bool va_enabled = use_va && vdpasim->mm_bound;
 
-	vringh_init_iotlb(&vq->vring, vdpasim->features, vq->num, true, false,
+	vringh_init_iotlb(&vq->vring, vdpasim->features, vq->num, true,
+			  va_enabled,
 			  (struct vring_desc *)(uintptr_t)vq->desc_addr,
 			  (struct vring_avail *)
 			  (uintptr_t)vq->driver_addr,
@@ -151,7 +220,7 @@ struct vdpasim *vdpasim_create(struct vdpasim_dev_attr *dev_attr,
 	vdpa = __vdpa_alloc_device(NULL, ops,
 				   dev_attr->ngroups, dev_attr->nas,
 				   dev_attr->alloc_size,
-				   dev_attr->name, false);
+				   dev_attr->name, use_va);
 	if (IS_ERR(vdpa)) {
 		ret = PTR_ERR(vdpa);
 		goto err_alloc;
@@ -571,6 +640,27 @@ static int vdpasim_set_map(struct vdpa_device *vdpa, unsigned int asid,
 	return ret;
 }
 
+static int vdpasim_bind_mm(struct vdpa_device *vdpa, struct mm_struct *mm)
+{
+	struct vdpasim *vdpasim = vdpa_to_sim(vdpa);
+	int ret;
+
+	mutex_lock(&vdpasim->mutex);
+	ret = vdpasim_worker_bind_mm(vdpasim, mm);
+	mutex_unlock(&vdpasim->mutex);
+
+	return ret;
+}
+
+static void vdpasim_unbind_mm(struct vdpa_device *vdpa)
+{
+	struct vdpasim *vdpasim = vdpa_to_sim(vdpa);
+
+	mutex_lock(&vdpasim->mutex);
+	vdpasim_worker_unbind_mm(vdpasim);
+	mutex_unlock(&vdpasim->mutex);
+}
+
 static int vdpasim_dma_map(struct vdpa_device *vdpa, unsigned int asid,
 			   u64 iova, u64 size,
 			   u64 pa, u32 perm, void *opaque)
@@ -667,6 +757,8 @@ static const struct vdpa_config_ops vdpasim_config_ops = {
 	.set_group_asid         = vdpasim_set_group_asid,
 	.dma_map                = vdpasim_dma_map,
 	.dma_unmap              = vdpasim_dma_unmap,
+	.bind_mm		= vdpasim_bind_mm,
+	.unbind_mm		= vdpasim_unbind_mm,
 	.free                   = vdpasim_free,
 };
 
@@ -701,6 +793,8 @@ static const struct vdpa_config_ops vdpasim_batch_config_ops = {
 	.get_iova_range         = vdpasim_get_iova_range,
 	.set_group_asid         = vdpasim_set_group_asid,
 	.set_map                = vdpasim_set_map,
+	.bind_mm		= vdpasim_bind_mm,
+	.unbind_mm		= vdpasim_unbind_mm,
 	.free                   = vdpasim_free,
 };
 
-- 
2.39.2

