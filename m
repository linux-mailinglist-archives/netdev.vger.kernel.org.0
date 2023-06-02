Return-Path: <netdev+bounces-7313-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D713771F9CC
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 07:52:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 119E51C21174
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 05:52:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 01AFE46A7;
	Fri,  2 Jun 2023 05:52:24 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E412E4406
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 05:52:23 +0000 (UTC)
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27E1C19A
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 22:52:22 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id d9443c01a7336-1b04949e5baso14899045ad.0
        for <netdev@vger.kernel.org>; Thu, 01 Jun 2023 22:52:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=igel-co-jp.20221208.gappssmtp.com; s=20221208; t=1685685141; x=1688277141;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5GCePBdWXtBGYcoJipdFjk82+G+HbJP6dJaNoy4y9gA=;
        b=gRIQO7hFIR2EHATIAzCy8elrkjY2wVObzk1CLTouTOp5DBamLY/rb6kTRRrRJ+G+6I
         5+PAF4ir/ymf0aIMnBLojlAI5IcHGJ+sVlrqKxP6lntkskwUPgUDIYepgTtc65RiYPwp
         c1wqNPRiTCTaoN+QPdph574zcMnaZB/r8/WOJWsVE8FrtuOhscvQ8b4lXu0gVsLAvnEB
         WEVD+HcMd5dLA2wPEIVbM/ZiDFL1+Ga1Mo85yh8sbpJxcAIp4U1MMQms7GvaOid4mRhR
         pAC81zeHTH+9HZUvNhVL/a4QzngtVYANaDMM/nuvyDPTrj+WD4f7IihUSLz3KS3MjRH4
         I8Xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685685141; x=1688277141;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5GCePBdWXtBGYcoJipdFjk82+G+HbJP6dJaNoy4y9gA=;
        b=RPZSFjMLnxs9ElbvcM0azAY5x6H5zvXlWpstkcuGq3KqVD3bdxo34Z+PTS3L5gwuYY
         j3hTdaDTr3yhjiVqPqzyibDy7m3Vg6tNrt9dvu63Ejxcth1WyEYoeslq+SqGcPet6VAO
         G7SQ7sw8a7yht97GNdOdpGm47o8d/u/E1DhGG71H7iGEkgwVakUSBTIMX7poEBriSgI9
         yWBU5WC5+vrTTmgHa5gkrzhs5dAm/NixLFw4SmLRx1nHgRZ4cZNzEBrDuVsPcB0Mzh64
         /NjUtMmJZszuZWEKGSjAXE+kH/jxFVMmSF9M4rEpf1tb9FJ+79hVbAMoXvNAy9sNd5AM
         sxAw==
X-Gm-Message-State: AC+VfDyUTd8iB4ssdOCO2k3txEKni0JgwqmDI9q/gYuC8k22TMp1/7E0
	lfGGE4Hbi+kbtnvj6L7xHifFqOt226wLV1IS+QU=
X-Google-Smtp-Source: ACHHUZ4btD8YOS/GYYUL0u3559LorSX3J9Z5RMRNRkl3EcWjjogZGHn1C/BXLyfF3WHO28zgQEytSg==
X-Received: by 2002:a17:902:b702:b0:1af:b682:7a78 with SMTP id d2-20020a170902b70200b001afb6827a78mr1234001pls.52.1685685141624;
        Thu, 01 Jun 2023 22:52:21 -0700 (PDT)
Received: from tyrell.hq.igel.co.jp (napt.igel.co.jp. [219.106.231.132])
        by smtp.gmail.com with ESMTPSA id c11-20020a170902d48b00b0019e60c645b1sm358789plg.305.2023.06.01.22.52.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Jun 2023 22:52:21 -0700 (PDT)
From: Shunsuke Mie <mie@igel.co.jp>
To: "Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Rusty Russell <rusty@rustcorp.com.au>
Cc: kvm@vger.kernel.org,
	virtualization@lists.linux-foundation.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Shunsuke Mie <mie@igel.co.jp>
Subject: [PATCH v4 1/1] vringh: IOMEM support
Date: Fri,  2 Jun 2023 14:52:11 +0900
Message-Id: <20230602055211.309960-2-mie@igel.co.jp>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230602055211.309960-1-mie@igel.co.jp>
References: <20230602055211.309960-1-mie@igel.co.jp>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Introduce a new memory accessor for vringh. It is able to use vringh to
virtio rings located on io-memory region.

Signed-off-by: Shunsuke Mie <mie@igel.co.jp>
---
 drivers/vhost/vringh.c | 201 +++++++++++++++++++++++++++++++++++++++++
 include/linux/vringh.h |  32 +++++++
 2 files changed, 233 insertions(+)

diff --git a/drivers/vhost/vringh.c b/drivers/vhost/vringh.c
index 955d938eb663..6e89dcd871b4 100644
--- a/drivers/vhost/vringh.c
+++ b/drivers/vhost/vringh.c
@@ -1604,4 +1604,205 @@ EXPORT_SYMBOL(vringh_need_notify_iotlb);
 
 #endif
 
+static inline int getu16_iomem(const struct vringh *vrh, u16 *val,
+			       const __virtio16 *p)
+{
+	*val = vringh16_to_cpu(vrh, ioread16(p));
+	return 0;
+}
+
+static inline int putu16_iomem(const struct vringh *vrh, __virtio16 *p, u16 val)
+{
+	iowrite16(cpu_to_vringh16(vrh, val), p);
+	return 0;
+}
+
+static inline int copydesc_iomem(const struct vringh *vrh, void *dst,
+				 const void *src, size_t len)
+{
+	memcpy_fromio(dst, src, len);
+	return 0;
+}
+
+static int putused_iomem(const struct vringh *vrh, struct vring_used_elem *dst,
+			 const struct vring_used_elem *src, unsigned int num)
+{
+	memcpy_toio(dst, src, num * sizeof(*dst));
+	return 0;
+}
+
+static inline int xfer_from_iomem(const struct vringh *vrh, void *src,
+				  void *dst, size_t len)
+{
+	memcpy_fromio(dst, src, len);
+	return 0;
+}
+
+static inline int xfer_to_iomem(const struct vringh *vrh, void *dst, void *src,
+				size_t len)
+{
+	memcpy_toio(dst, src, len);
+	return 0;
+}
+
+/**
+ * vringh_init_iomem - initialize a vringh for a vring on io-memory.
+ * @vrh: the vringh to initialize.
+ * @features: the feature bits for this ring.
+ * @num: the number of elements.
+ * @weak_barriers: true if we only need memory barriers, not I/O.
+ * @desc: the userspace descriptor pointer.
+ * @avail: the userspace avail pointer.
+ * @used: the userspace used pointer.
+ *
+ * Returns an error if num is invalid: you should check pointers
+ * yourself!
+ */
+int vringh_init_iomem(struct vringh *vrh, u64 features, unsigned int num,
+		      bool weak_barriers, struct vring_desc *desc,
+		      struct vring_avail *avail, struct vring_used *used)
+{
+	return vringh_init_kern(vrh, features, num, weak_barriers, desc, avail,
+				used);
+}
+EXPORT_SYMBOL(vringh_init_iomem);
+
+/**
+ * vringh_getdesc_iomem - get next available descriptor from vring on io-memory.
+ * @vrh: the vring on io-memory.
+ * @riov: where to put the readable descriptors (or NULL)
+ * @wiov: where to put the writable descriptors (or NULL)
+ * @head: head index we received, for passing to vringh_complete_iomem().
+ * @gfp: flags for allocating larger riov/wiov.
+ *
+ * Returns 0 if there was no descriptor, 1 if there was, or -errno.
+ *
+ * There some notes, and those are same with vringh_getdesc_kern(). Please see
+ * it.
+ */
+int vringh_getdesc_iomem(struct vringh *vrh, struct vringh_kiov *riov,
+			 struct vringh_kiov *wiov, u16 *head, gfp_t gfp)
+{
+	int err;
+
+	err = __vringh_get_head(vrh, getu16_iomem, &vrh->last_avail_idx);
+	if (err < 0)
+		return err;
+
+	/* Empty... */
+	if (err == vrh->vring.num)
+		return 0;
+
+	*head = err;
+	err = __vringh_iov(vrh, *head, riov, wiov, no_range_check, NULL, gfp,
+			   copydesc_iomem);
+	if (err)
+		return err;
+
+	return 1;
+}
+EXPORT_SYMBOL(vringh_getdesc_iomem);
+
+/**
+ * vringh_iov_pull_iomem - copy bytes from vring_iov.
+ * @riov: the riov as passed to vringh_getdesc_iomem() (updated as we consume)
+ * @dst: the place to copy.
+ * @len: the maximum length to copy.
+ *
+ * Returns the bytes copied <= len or a negative errno.
+ */
+ssize_t vringh_iov_pull_iomem(struct vringh *vrh, struct vringh_kiov *riov,
+			      void *dst, size_t len)
+{
+	return vringh_iov_xfer(vrh, riov, dst, len, xfer_from_iomem);
+}
+EXPORT_SYMBOL(vringh_iov_pull_iomem);
+
+/**
+ * vringh_iov_push_iomem - copy bytes into vring_iov.
+ * @wiov: the wiov as passed to vringh_getdesc_iomem() (updated as we consume)
+ * @src: the place to copy from.
+ * @len: the maximum length to copy.
+ *
+ * Returns the bytes copied <= len or a negative errno.
+ */
+ssize_t vringh_iov_push_iomem(struct vringh *vrh, struct vringh_kiov *wiov,
+			      const void *src, size_t len)
+{
+	return vringh_iov_xfer(vrh, wiov, (void *)src, len, xfer_to_iomem);
+}
+EXPORT_SYMBOL(vringh_iov_push_iomem);
+
+/**
+ * vringh_abandon_iomem - we've decided not to handle the descriptor(s).
+ * @vrh: the vring.
+ * @num: the number of descriptors to put back (ie. num
+ *	 vringh_getdesc_iomem() to undo).
+ *
+ * The next vringh_get_kern() will return the old descriptor(s) again.
+ */
+void vringh_abandon_iomem(struct vringh *vrh, unsigned int num)
+{
+	vringh_abandon_kern(vrh, num);
+}
+EXPORT_SYMBOL(vringh_abandon_iomem);
+
+/**
+ * vringh_complete_iomem - we've finished with descriptor, publish it.
+ * @vrh: the vring.
+ * @head: the head as filled in by vringh_getdesc_iomem().
+ * @len: the length of data we have written.
+ *
+ * You should check vringh_need_notify_iomem() after one or more calls
+ * to this function.
+ */
+int vringh_complete_iomem(struct vringh *vrh, u16 head, u32 len)
+{
+	struct vring_used_elem used;
+
+	used.id = cpu_to_vringh32(vrh, head);
+	used.len = cpu_to_vringh32(vrh, len);
+
+	return __vringh_complete(vrh, &used, 1, putu16_iomem, putused_iomem);
+}
+EXPORT_SYMBOL(vringh_complete_iomem);
+
+/**
+ * vringh_notify_enable_iomem - we want to know if something changes.
+ * @vrh: the vring.
+ *
+ * This always enables notifications, but returns false if there are
+ * now more buffers available in the vring.
+ */
+bool vringh_notify_enable_iomem(struct vringh *vrh)
+{
+	return __vringh_notify_enable(vrh, getu16_iomem, putu16_iomem);
+}
+EXPORT_SYMBOL(vringh_notify_enable_iomem);
+
+/**
+ * vringh_notify_disable_iomem - don't tell us if something changes.
+ * @vrh: the vring.
+ *
+ * This is our normal running state: we disable and then only enable when
+ * we're going to sleep.
+ */
+void vringh_notify_disable_iomem(struct vringh *vrh)
+{
+	__vringh_notify_disable(vrh, putu16_iomem);
+}
+EXPORT_SYMBOL(vringh_notify_disable_iomem);
+
+/**
+ * vringh_need_notify_iomem - must we tell the other side about used buffers?
+ * @vrh: the vring we've called vringh_complete_iomem() on.
+ *
+ * Returns -errno or 0 if we don't need to tell the other side, 1 if we do.
+ */
+int vringh_need_notify_iomem(struct vringh *vrh)
+{
+	return __vringh_need_notify(vrh, getu16_iomem);
+}
+EXPORT_SYMBOL(vringh_need_notify_iomem);
+
 MODULE_LICENSE("GPL");
diff --git a/include/linux/vringh.h b/include/linux/vringh.h
index c3a8117dabe8..4130e5302ee6 100644
--- a/include/linux/vringh.h
+++ b/include/linux/vringh.h
@@ -330,4 +330,36 @@ int vringh_need_notify_iotlb(struct vringh *vrh);
 
 #endif /* CONFIG_VHOST_IOTLB */
 
+#if IS_REACHABLE(CONFIG_VHOST_RING_IOMEM)
+
+int vringh_init_iomem(struct vringh *vrh, u64 features,
+		      unsigned int num, bool weak_barriers,
+		      struct vring_desc *desc,
+		      struct vring_avail *avail,
+		      struct vring_used *used);
+
+int vringh_getdesc_iomem(struct vringh *vrh,
+			 struct vringh_kiov *riov,
+			 struct vringh_kiov *wiov,
+			 u16 *head,
+			 gfp_t gfp);
+
+ssize_t vringh_iov_pull_iomem(struct vringh *vrh,
+			      struct vringh_kiov *riov,
+			      void *dst, size_t len);
+ssize_t vringh_iov_push_iomem(struct vringh *vrh,
+			      struct vringh_kiov *wiov,
+			      const void *src, size_t len);
+
+void vringh_abandon_iomem(struct vringh *vrh, unsigned int num);
+
+int vringh_complete_iomem(struct vringh *vrh, u16 head, u32 len);
+
+bool vringh_notify_enable_iomem(struct vringh *vrh);
+void vringh_notify_disable_iomem(struct vringh *vrh);
+
+int vringh_need_notify_iomem(struct vringh *vrh);
+
+#endif /* CONFIG_VHOST_RING_IOMEM */
+
 #endif /* _LINUX_VRINGH_H */
-- 
2.25.1


