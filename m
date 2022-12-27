Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D39AD6566C7
	for <lists+netdev@lfdr.de>; Tue, 27 Dec 2022 03:26:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232633AbiL0C0t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Dec 2022 21:26:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232648AbiL0CZv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Dec 2022 21:25:51 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D27FC6355
        for <netdev@vger.kernel.org>; Mon, 26 Dec 2022 18:25:46 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id g16so2366744plq.12
        for <netdev@vger.kernel.org>; Mon, 26 Dec 2022 18:25:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=igel-co-jp.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jpD0O86+K69F9CNelaZHlDWFW4nv0NdjAuIxj3XUltA=;
        b=OYIykGkrMYyxL3uLcdOsP4Xk6Gpfj0jz4LzPxIMm/s20o3B5AkS2NObErwc5WG3zQp
         kv6hmHrvMaqfjl5qq+18eu1IcBWmLe+sFFdiBSjHnLH9akMu3DFJnjo/INnU0aTQu/HM
         4pAjUGSzUcCXgqSXo2Rt3V93viSsIb/aiR2mLIB9XUdAUYLEou8zMvCIM+grYEEcyeyO
         Dok+49SgOfWPgW02C2B+5SgSKQ+iU3TpOVjjXNyfA/qO5SLUPwEpCv88PaqlI+5A8Rn7
         bEQ7kuClfh/sVvjIb/7OUp2qaxssSR/1IKsxsxrVwteC8P13SDxtiDuBZ+nKSUlPn/Gy
         lLvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jpD0O86+K69F9CNelaZHlDWFW4nv0NdjAuIxj3XUltA=;
        b=4Ne+evAE5jsVimfFkY6FXTWHeHNcy61P2RIlEPfHRV9+/kBJnUWLonWJG2QrAcD3Jv
         Xzuk626wztuOi8f50R8g8tjmU5ToJMphcUyTxnmRGceTuldJjctqGEFOeM74oLesFEgl
         qJMzoz0tqkBfbExfGzgC+wf4DrxcfTqoMH/5NjvcuczaQcHLj01NF5Fix+qQYvMCQHhr
         6uBZRTr54rPsgMChq4g/fN/DchK/48NnRWidG9m9bLjyS4d5CGhB+RctW9QsPVg/ld5V
         qyahShXi9tov79z7a5TXxtFC25WC3TwYunZBdhOkV0mu/OIiIVrZ/EPI1Y3QVTIIMPta
         FKXQ==
X-Gm-Message-State: AFqh2krBjH15WqE7AYhTUhIakujFmqZYIQTSyry5jQiL6tDhPsiy1Tw/
        +t0MN5NhTfhGRf91j5z2gyR1RQ==
X-Google-Smtp-Source: AMrXdXsP3r515rdj3ZJe10dsPsiqh4PUp28z2P79sm4ut+qXe/m1gIHd0DJVMIAaNeFkR/MTzuWQdQ==
X-Received: by 2002:a17:902:e54f:b0:191:1e88:ea4c with SMTP id n15-20020a170902e54f00b001911e88ea4cmr29612993plf.40.1672107945681;
        Mon, 26 Dec 2022 18:25:45 -0800 (PST)
Received: from tyrell.hq.igel.co.jp (napt.igel.co.jp. [219.106.231.132])
        by smtp.gmail.com with ESMTPSA id w15-20020a1709026f0f00b001870dc3b4c0sm2465014plk.74.2022.12.26.18.25.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Dec 2022 18:25:45 -0800 (PST)
From:   Shunsuke Mie <mie@igel.co.jp>
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Shunsuke Mie <mie@igel.co.jp>
Subject: [RFC PATCH 4/9] vringh: unify the APIs for all accessors
Date:   Tue, 27 Dec 2022 11:25:26 +0900
Message-Id: <20221227022528.609839-5-mie@igel.co.jp>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221227022528.609839-1-mie@igel.co.jp>
References: <20221227022528.609839-1-mie@igel.co.jp>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Each vringh memory accessors that are for user, kern and iotlb has own
interfaces that calls common code. But some codes are duplicated and that
becomes loss extendability.

Introduce a struct vringh_ops and provide a common APIs for all accessors.
It can bee easily extended vringh code for new memory accessor and
simplified a caller code.

Signed-off-by: Shunsuke Mie <mie@igel.co.jp>
---
 drivers/vhost/vringh.c | 667 +++++++++++------------------------------
 include/linux/vringh.h | 100 +++---
 2 files changed, 225 insertions(+), 542 deletions(-)

diff --git a/drivers/vhost/vringh.c b/drivers/vhost/vringh.c
index aa3cd27d2384..ebfd3644a1a3 100644
--- a/drivers/vhost/vringh.c
+++ b/drivers/vhost/vringh.c
@@ -35,15 +35,12 @@ static __printf(1,2) __cold void vringh_bad(const char *fmt, ...)
 }
 
 /* Returns vring->num if empty, -ve on error. */
-static inline int __vringh_get_head(const struct vringh *vrh,
-				    int (*getu16)(const struct vringh *vrh,
-						  u16 *val, const __virtio16 *p),
-				    u16 *last_avail_idx)
+static inline int __vringh_get_head(const struct vringh *vrh, u16 *last_avail_idx)
 {
 	u16 avail_idx, i, head;
 	int err;
 
-	err = getu16(vrh, &avail_idx, &vrh->vring.avail->idx);
+	err = vrh->ops.getu16(vrh, &avail_idx, &vrh->vring.avail->idx);
 	if (err) {
 		vringh_bad("Failed to access avail idx at %p",
 			   &vrh->vring.avail->idx);
@@ -58,7 +55,7 @@ static inline int __vringh_get_head(const struct vringh *vrh,
 
 	i = *last_avail_idx & (vrh->vring.num - 1);
 
-	err = getu16(vrh, &head, &vrh->vring.avail->ring[i]);
+	err = vrh->ops.getu16(vrh, &head, &vrh->vring.avail->ring[i]);
 	if (err) {
 		vringh_bad("Failed to read head: idx %d address %p",
 			   *last_avail_idx, &vrh->vring.avail->ring[i]);
@@ -131,12 +128,10 @@ static inline ssize_t vringh_iov_xfer(struct vringh *vrh,
 
 /* May reduce *len if range is shorter. */
 static inline bool range_check(struct vringh *vrh, u64 addr, size_t *len,
-			       struct vringh_range *range,
-			       bool (*getrange)(struct vringh *,
-						u64, struct vringh_range *))
+			       struct vringh_range *range)
 {
 	if (addr < range->start || addr > range->end_incl) {
-		if (!getrange(vrh, addr, range))
+		if (!vrh->ops.getrange(vrh, addr, range))
 			return false;
 	}
 	BUG_ON(addr < range->start || addr > range->end_incl);
@@ -165,9 +160,7 @@ static inline bool range_check(struct vringh *vrh, u64 addr, size_t *len,
 }
 
 static inline bool no_range_check(struct vringh *vrh, u64 addr, size_t *len,
-				  struct vringh_range *range,
-				  bool (*getrange)(struct vringh *,
-						   u64, struct vringh_range *))
+				  struct vringh_range *range)
 {
 	return true;
 }
@@ -244,17 +237,7 @@ static u16 __cold return_from_indirect(const struct vringh *vrh, int *up_next,
 }
 
 static int slow_copy(struct vringh *vrh, void *dst, const void *src,
-		     bool (*rcheck)(struct vringh *vrh, u64 addr, size_t *len,
-				    struct vringh_range *range,
-				    bool (*getrange)(struct vringh *vrh,
-						     u64,
-						     struct vringh_range *)),
-		     bool (*getrange)(struct vringh *vrh,
-				      u64 addr,
-				      struct vringh_range *r),
-		     struct vringh_range *range,
-		     int (*copy)(const struct vringh *vrh,
-				 void *dst, const void *src, size_t len))
+		     struct vringh_range *range)
 {
 	size_t part, len = sizeof(struct vring_desc);
 
@@ -265,10 +248,10 @@ static int slow_copy(struct vringh *vrh, void *dst, const void *src,
 		part = len;
 		addr = (u64)(unsigned long)src - range->offset;
 
-		if (!rcheck(vrh, addr, &part, range, getrange))
+		if (!vrh->ops.range_check(vrh, addr, &part, range))
 			return -EINVAL;
 
-		err = copy(vrh, dst, src, part);
+		err = vrh->ops.copydesc(vrh, dst, src, part);
 		if (err)
 			return err;
 
@@ -279,18 +262,35 @@ static int slow_copy(struct vringh *vrh, void *dst, const void *src,
 	return 0;
 }
 
+static int __vringh_init(struct vringh *vrh, u64 features, unsigned int num,
+			 bool weak_barriers, gfp_t gfp, struct vring_desc *desc,
+			 struct vring_avail *avail, struct vring_used *used)
+{
+	/* Sane power of 2 please! */
+	if (!num || num > 0xffff || (num & (num - 1))) {
+		vringh_bad("Bad ring size %u", num);
+		return -EINVAL;
+	}
+
+	vrh->little_endian = (features & (1ULL << VIRTIO_F_VERSION_1));
+	vrh->event_indices = (features & (1 << VIRTIO_RING_F_EVENT_IDX));
+	vrh->weak_barriers = weak_barriers;
+	vrh->completed = 0;
+	vrh->last_avail_idx = 0;
+	vrh->last_used_idx = 0;
+	vrh->vring.num = num;
+	vrh->vring.desc = desc;
+	vrh->vring.avail = avail;
+	vrh->vring.used = used;
+	vrh->desc_gfp = gfp;
+
+	return 0;
+}
+
 static inline int
 __vringh_iov(struct vringh *vrh, u16 i,
 	     struct vringh_kiov *riov,
-	     struct vringh_kiov *wiov,
-	     bool (*rcheck)(struct vringh *vrh, u64 addr, size_t *len,
-			    struct vringh_range *range,
-			    bool (*getrange)(struct vringh *, u64,
-					     struct vringh_range *)),
-	     bool (*getrange)(struct vringh *, u64, struct vringh_range *),
-	     gfp_t gfp,
-	     int (*copy)(const struct vringh *vrh,
-			 void *dst, const void *src, size_t len))
+	     struct vringh_kiov *wiov, gfp_t gfp)
 {
 	int err, count = 0, indirect_count = 0, up_next, desc_max;
 	struct vring_desc desc, *descs;
@@ -317,10 +317,9 @@ __vringh_iov(struct vringh *vrh, u16 i,
 		size_t len;
 
 		if (unlikely(slow))
-			err = slow_copy(vrh, &desc, &descs[i], rcheck, getrange,
-					&slowrange, copy);
+			err = slow_copy(vrh, &desc, &descs[i], &slowrange);
 		else
-			err = copy(vrh, &desc, &descs[i], sizeof(desc));
+			err = vrh->ops.copydesc(vrh, &desc, &descs[i], sizeof(desc));
 		if (unlikely(err))
 			goto fail;
 
@@ -330,7 +329,7 @@ __vringh_iov(struct vringh *vrh, u16 i,
 
 			/* Make sure it's OK, and get offset. */
 			len = vringh32_to_cpu(vrh, desc.len);
-			if (!rcheck(vrh, a, &len, &range, getrange)) {
+			if (!vrh->ops.range_check(vrh, a, &len, &range)) {
 				err = -EINVAL;
 				goto fail;
 			}
@@ -382,8 +381,7 @@ __vringh_iov(struct vringh *vrh, u16 i,
 	again:
 		/* Make sure it's OK, and get offset. */
 		len = vringh32_to_cpu(vrh, desc.len);
-		if (!rcheck(vrh, vringh64_to_cpu(vrh, desc.addr), &len, &range,
-			    getrange)) {
+		if (!vrh->ops.range_check(vrh, vringh64_to_cpu(vrh, desc.addr), &len, &range)) {
 			err = -EINVAL;
 			goto fail;
 		}
@@ -436,13 +434,7 @@ __vringh_iov(struct vringh *vrh, u16 i,
 
 static inline int __vringh_complete(struct vringh *vrh,
 				    const struct vring_used_elem *used,
-				    unsigned int num_used,
-				    int (*putu16)(const struct vringh *vrh,
-						  __virtio16 *p, u16 val),
-				    int (*putused)(const struct vringh *vrh,
-						   struct vring_used_elem *dst,
-						   const struct vring_used_elem
-						   *src, unsigned num))
+				    unsigned int num_used)
 {
 	struct vring_used *used_ring;
 	int err;
@@ -456,12 +448,12 @@ static inline int __vringh_complete(struct vringh *vrh,
 	/* Compiler knows num_used == 1 sometimes, hence extra check */
 	if (num_used > 1 && unlikely(off + num_used >= vrh->vring.num)) {
 		u16 part = vrh->vring.num - off;
-		err = putused(vrh, &used_ring->ring[off], used, part);
+		err = vrh->ops.putused(vrh, &used_ring->ring[off], used, part);
 		if (!err)
-			err = putused(vrh, &used_ring->ring[0], used + part,
+			err = vrh->ops.putused(vrh, &used_ring->ring[0], used + part,
 				      num_used - part);
 	} else
-		err = putused(vrh, &used_ring->ring[off], used, num_used);
+		err = vrh->ops.putused(vrh, &used_ring->ring[off], used, num_used);
 
 	if (err) {
 		vringh_bad("Failed to write %u used entries %u at %p",
@@ -472,7 +464,7 @@ static inline int __vringh_complete(struct vringh *vrh,
 	/* Make sure buffer is written before we update index. */
 	virtio_wmb(vrh->weak_barriers);
 
-	err = putu16(vrh, &vrh->vring.used->idx, used_idx + num_used);
+	err = vrh->ops.putu16(vrh, &vrh->vring.used->idx, used_idx + num_used);
 	if (err) {
 		vringh_bad("Failed to update used index at %p",
 			   &vrh->vring.used->idx);
@@ -483,11 +475,13 @@ static inline int __vringh_complete(struct vringh *vrh,
 	return 0;
 }
 
-
-static inline int __vringh_need_notify(struct vringh *vrh,
-				       int (*getu16)(const struct vringh *vrh,
-						     u16 *val,
-						     const __virtio16 *p))
+/**
+ * vringh_need_notify - must we tell the other side about used buffers?
+ * @vrh: the vring we've called vringh_complete() on.
+ *
+ * Returns -errno or 0 if we don't need to tell the other side, 1 if we do.
+ */
+int vringh_need_notify(struct vringh *vrh)
 {
 	bool notify;
 	u16 used_event;
@@ -501,7 +495,7 @@ static inline int __vringh_need_notify(struct vringh *vrh,
 	/* Old-style, without event indices. */
 	if (!vrh->event_indices) {
 		u16 flags;
-		err = getu16(vrh, &flags, &vrh->vring.avail->flags);
+		err = vrh->ops.getu16(vrh, &flags, &vrh->vring.avail->flags);
 		if (err) {
 			vringh_bad("Failed to get flags at %p",
 				   &vrh->vring.avail->flags);
@@ -511,7 +505,7 @@ static inline int __vringh_need_notify(struct vringh *vrh,
 	}
 
 	/* Modern: we know when other side wants to know. */
-	err = getu16(vrh, &used_event, &vring_used_event(&vrh->vring));
+	err = vrh->ops.getu16(vrh, &used_event, &vring_used_event(&vrh->vring));
 	if (err) {
 		vringh_bad("Failed to get used event idx at %p",
 			   &vring_used_event(&vrh->vring));
@@ -530,24 +524,28 @@ static inline int __vringh_need_notify(struct vringh *vrh,
 	vrh->completed = 0;
 	return notify;
 }
+EXPORT_SYMBOL(vringh_need_notify);
 
-static inline bool __vringh_notify_enable(struct vringh *vrh,
-					  int (*getu16)(const struct vringh *vrh,
-							u16 *val, const __virtio16 *p),
-					  int (*putu16)(const struct vringh *vrh,
-							__virtio16 *p, u16 val))
+/**
+ * vringh_notify_enable - we want to know if something changes.
+ * @vrh: the vring.
+ *
+ * This always enables notifications, but returns false if there are
+ * now more buffers available in the vring.
+ */
+bool vringh_notify_enable(struct vringh *vrh)
 {
 	u16 avail;
 
 	if (!vrh->event_indices) {
 		/* Old-school; update flags. */
-		if (putu16(vrh, &vrh->vring.used->flags, 0) != 0) {
+		if (vrh->ops.putu16(vrh, &vrh->vring.used->flags, 0) != 0) {
 			vringh_bad("Clearing used flags %p",
 				   &vrh->vring.used->flags);
 			return true;
 		}
 	} else {
-		if (putu16(vrh, &vring_avail_event(&vrh->vring),
+		if (vrh->ops.putu16(vrh, &vring_avail_event(&vrh->vring),
 			   vrh->last_avail_idx) != 0) {
 			vringh_bad("Updating avail event index %p",
 				   &vring_avail_event(&vrh->vring));
@@ -559,7 +557,7 @@ static inline bool __vringh_notify_enable(struct vringh *vrh,
 	 * sure it's written, then check again. */
 	virtio_mb(vrh->weak_barriers);
 
-	if (getu16(vrh, &avail, &vrh->vring.avail->idx) != 0) {
+	if (vrh->ops.getu16(vrh, &avail, &vrh->vring.avail->idx) != 0) {
 		vringh_bad("Failed to check avail idx at %p",
 			   &vrh->vring.avail->idx);
 		return true;
@@ -570,20 +568,27 @@ static inline bool __vringh_notify_enable(struct vringh *vrh,
 	 * notification anyway). */
 	return avail == vrh->last_avail_idx;
 }
+EXPORT_SYMBOL(vringh_notify_enable);
 
-static inline void __vringh_notify_disable(struct vringh *vrh,
-					   int (*putu16)(const struct vringh *vrh,
-							 __virtio16 *p, u16 val))
+/**
+ * vringh_notify_disable - don't tell us if something changes.
+ * @vrh: the vring.
+ *
+ * This is our normal running state: we disable and then only enable when
+ * we're going to sleep.
+ */
+void vringh_notify_disable(struct vringh *vrh)
 {
 	if (!vrh->event_indices) {
 		/* Old-school; update flags. */
-		if (putu16(vrh, &vrh->vring.used->flags,
+		if (vrh->ops.putu16(vrh, &vrh->vring.used->flags,
 			   VRING_USED_F_NO_NOTIFY)) {
 			vringh_bad("Setting used flags %p",
 				   &vrh->vring.used->flags);
 		}
 	}
 }
+EXPORT_SYMBOL(vringh_notify_disable);
 
 /* Userspace access helpers: in this case, addresses are really userspace. */
 static inline int getu16_user(const struct vringh *vrh, u16 *val, const __virtio16 *p)
@@ -630,6 +635,16 @@ static inline int xfer_to_user(const struct vringh *vrh,
 		-EFAULT : 0;
 }
 
+static struct vringh_ops user_vringh_ops = {
+	.getu16 = getu16_user,
+	.putu16 = putu16_user,
+	.xfer_from = xfer_from_user,
+	.xfer_to = xfer_to_user,
+	.putused = putused_user,
+	.copydesc = copydesc_user,
+	.range_check = range_check,
+};
+
 /**
  * vringh_init_user - initialize a vringh for a userspace vring.
  * @vrh: the vringh to initialize.
@@ -639,6 +654,7 @@ static inline int xfer_to_user(const struct vringh *vrh,
  * @desc: the userpace descriptor pointer.
  * @avail: the userpace avail pointer.
  * @used: the userpace used pointer.
+ * @getrange: a function that return a range that vring can access.
  *
  * Returns an error if num is invalid: you should check pointers
  * yourself!
@@ -647,36 +663,32 @@ int vringh_init_user(struct vringh *vrh, u64 features,
 		     unsigned int num, bool weak_barriers,
 		     vring_desc_t __user *desc,
 		     vring_avail_t __user *avail,
-		     vring_used_t __user *used)
+		     vring_used_t __user *used,
+			 bool (*getrange)(struct vringh *vrh, u64 addr, struct vringh_range *r))
 {
-	/* Sane power of 2 please! */
-	if (!num || num > 0xffff || (num & (num - 1))) {
-		vringh_bad("Bad ring size %u", num);
-		return -EINVAL;
-	}
+	int err;
+
+	err = __vringh_init(vrh, features, num, weak_barriers, GFP_KERNEL,
+			(__force struct vring_desc *)desc,
+			(__force struct vring_avail *)avail,
+			(__force struct vring_used *)used);
+	if (err)
+		return err;
+
+	memcpy(&vrh->ops, &user_vringh_ops, sizeof(user_vringh_ops));
+	vrh->ops.getrange = getrange;
 
-	vrh->little_endian = (features & (1ULL << VIRTIO_F_VERSION_1));
-	vrh->event_indices = (features & (1 << VIRTIO_RING_F_EVENT_IDX));
-	vrh->weak_barriers = weak_barriers;
-	vrh->completed = 0;
-	vrh->last_avail_idx = 0;
-	vrh->last_used_idx = 0;
-	vrh->vring.num = num;
-	/* vring expects kernel addresses, but only used via accessors. */
-	vrh->vring.desc = (__force struct vring_desc *)desc;
-	vrh->vring.avail = (__force struct vring_avail *)avail;
-	vrh->vring.used = (__force struct vring_used *)used;
 	return 0;
 }
 EXPORT_SYMBOL(vringh_init_user);
 
 /**
- * vringh_getdesc_user - get next available descriptor from userspace ring.
- * @vrh: the userspace vring.
+ * vringh_getdesc - get next available descriptor from ring.
+ * @vrh: the vringh to get desc.
  * @riov: where to put the readable descriptors (or NULL)
  * @wiov: where to put the writable descriptors (or NULL)
  * @getrange: function to call to check ranges.
- * @head: head index we received, for passing to vringh_complete_user().
+ * @head: head index we received, for passing to vringh_complete().
  *
  * Returns 0 if there was no descriptor, 1 if there was, or -errno.
  *
@@ -690,17 +702,15 @@ EXPORT_SYMBOL(vringh_init_user);
  * When you don't have to use riov and wiov anymore, you should clean up them
  * calling vringh_iov_cleanup() to release the memory, even on error!
  */
-int vringh_getdesc_user(struct vringh *vrh,
+int vringh_getdesc(struct vringh *vrh,
 			struct vringh_kiov *riov,
 			struct vringh_kiov *wiov,
-			bool (*getrange)(struct vringh *vrh,
-					 u64 addr, struct vringh_range *r),
 			u16 *head)
 {
 	int err;
 
 	*head = vrh->vring.num;
-	err = __vringh_get_head(vrh, getu16_user, &vrh->last_avail_idx);
+	err = __vringh_get_head(vrh, &vrh->last_avail_idx);
 	if (err < 0)
 		return err;
 
@@ -709,137 +719,100 @@ int vringh_getdesc_user(struct vringh *vrh,
 		return 0;
 
 	*head = err;
-	err = __vringh_iov(vrh, *head, (struct vringh_kiov *)riov,
-			   (struct vringh_kiov *)wiov,
-			   range_check, getrange, GFP_KERNEL, copydesc_user);
+	err = __vringh_iov(vrh, *head, riov, wiov, GFP_KERNEL);
 	if (err)
 		return err;
 
 	return 1;
 }
-EXPORT_SYMBOL(vringh_getdesc_user);
+EXPORT_SYMBOL(vringh_getdesc);
 
 /**
- * vringh_iov_pull_user - copy bytes from vring_kiov.
- * @riov: the riov as passed to vringh_getdesc_user() (updated as we consume)
+ * vringh_iov_pull - copy bytes from vring_kiov.
+ * @vrh: the vringh to load data.
+ * @riov: the riov as passed to vringh_getdesc() (updated as we consume)
  * @dst: the place to copy.
  * @len: the maximum length to copy.
  *
  * Returns the bytes copied <= len or a negative errno.
  */
-ssize_t vringh_iov_pull_user(struct vringh_kiov *riov, void *dst, size_t len)
+ssize_t vringh_iov_pull(struct vringh *vrh, struct vringh_kiov *riov, void *dst, size_t len)
 {
 	return vringh_iov_xfer(NULL, (struct vringh_kiov *)riov,
-			       dst, len, xfer_from_user);
+			       dst, len, vrh->ops.xfer_from);
 }
-EXPORT_SYMBOL(vringh_iov_pull_user);
+EXPORT_SYMBOL(vringh_iov_pull);
 
 /**
- * vringh_iov_push_user - copy bytes into vring_kiov.
- * @wiov: the wiov as passed to vringh_getdesc_user() (updated as we consume)
+ * vringh_iov_push - copy bytes into vring_kiov.
+ * @vrh: the vringh to store data.
+ * @wiov: the wiov as passed to vringh_getdesc() (updated as we consume)
  * @src: the place to copy from.
  * @len: the maximum length to copy.
  *
  * Returns the bytes copied <= len or a negative errno.
  */
-ssize_t vringh_iov_push_user(struct vringh_kiov *wiov,
+ssize_t vringh_iov_push(struct vringh *vrh, struct vringh_kiov *wiov,
 			     const void *src, size_t len)
 {
 	return vringh_iov_xfer(NULL, (struct vringh_kiov *)wiov,
-			       (void *)src, len, xfer_to_user);
+			       (void *)src, len, vrh->ops.xfer_to);
 }
-EXPORT_SYMBOL(vringh_iov_push_user);
+EXPORT_SYMBOL(vringh_iov_push);
 
 /**
- * vringh_abandon_user - we've decided not to handle the descriptor(s).
+ * vringh_abandon - we've decided not to handle the descriptor(s).
  * @vrh: the vring.
  * @num: the number of descriptors to put back (ie. num
  *	 vringh_get_user() to undo).
  *
  * The next vringh_get_user() will return the old descriptor(s) again.
  */
-void vringh_abandon_user(struct vringh *vrh, unsigned int num)
+void vringh_abandon(struct vringh *vrh, unsigned int num)
 {
 	/* We only update vring_avail_event(vr) when we want to be notified,
 	 * so we haven't changed that yet. */
 	vrh->last_avail_idx -= num;
 }
-EXPORT_SYMBOL(vringh_abandon_user);
+EXPORT_SYMBOL(vringh_abandon);
 
 /**
- * vringh_complete_user - we've finished with descriptor, publish it.
+ * vringh_complete - we've finished with descriptor, publish it.
  * @vrh: the vring.
- * @head: the head as filled in by vringh_getdesc_user.
+ * @head: the head as filled in by vringh_getdesc.
  * @len: the length of data we have written.
  *
- * You should check vringh_need_notify_user() after one or more calls
+ * You should check vringh_need_notify() after one or more calls
  * to this function.
  */
-int vringh_complete_user(struct vringh *vrh, u16 head, u32 len)
+int vringh_complete(struct vringh *vrh, u16 head, u32 len)
 {
 	struct vring_used_elem used;
 
 	used.id = cpu_to_vringh32(vrh, head);
 	used.len = cpu_to_vringh32(vrh, len);
-	return __vringh_complete(vrh, &used, 1, putu16_user, putused_user);
+	return __vringh_complete(vrh, &used, 1);
 }
-EXPORT_SYMBOL(vringh_complete_user);
+EXPORT_SYMBOL(vringh_complete);
 
 /**
- * vringh_complete_multi_user - we've finished with many descriptors.
+ * vringh_complete_multi - we've finished with many descriptors.
  * @vrh: the vring.
  * @used: the head, length pairs.
  * @num_used: the number of used elements.
  *
- * You should check vringh_need_notify_user() after one or more calls
+ * You should check vringh_need_notify() after one or more calls
  * to this function.
  */
-int vringh_complete_multi_user(struct vringh *vrh,
+int vringh_complete_multi(struct vringh *vrh,
 			       const struct vring_used_elem used[],
 			       unsigned num_used)
 {
-	return __vringh_complete(vrh, used, num_used,
-				 putu16_user, putused_user);
-}
-EXPORT_SYMBOL(vringh_complete_multi_user);
-
-/**
- * vringh_notify_enable_user - we want to know if something changes.
- * @vrh: the vring.
- *
- * This always enables notifications, but returns false if there are
- * now more buffers available in the vring.
- */
-bool vringh_notify_enable_user(struct vringh *vrh)
-{
-	return __vringh_notify_enable(vrh, getu16_user, putu16_user);
+	return __vringh_complete(vrh, used, num_used);
 }
-EXPORT_SYMBOL(vringh_notify_enable_user);
+EXPORT_SYMBOL(vringh_complete_multi);
 
-/**
- * vringh_notify_disable_user - don't tell us if something changes.
- * @vrh: the vring.
- *
- * This is our normal running state: we disable and then only enable when
- * we're going to sleep.
- */
-void vringh_notify_disable_user(struct vringh *vrh)
-{
-	__vringh_notify_disable(vrh, putu16_user);
-}
-EXPORT_SYMBOL(vringh_notify_disable_user);
 
-/**
- * vringh_need_notify_user - must we tell the other side about used buffers?
- * @vrh: the vring we've called vringh_complete_user() on.
- *
- * Returns -errno or 0 if we don't need to tell the other side, 1 if we do.
- */
-int vringh_need_notify_user(struct vringh *vrh)
-{
-	return __vringh_need_notify(vrh, getu16_user);
-}
-EXPORT_SYMBOL(vringh_need_notify_user);
 
 /* Kernelspace access helpers. */
 static inline int getu16_kern(const struct vringh *vrh,
@@ -885,6 +858,17 @@ static inline int kern_xfer(const struct vringh *vrh, void *dst,
 	return 0;
 }
 
+static const struct vringh_ops kern_vringh_ops = {
+	.getu16 = getu16_kern,
+	.putu16 = putu16_kern,
+	.xfer_from = xfer_kern,
+	.xfer_to = xfer_kern,
+	.putused = putused_kern,
+	.copydesc = copydesc_kern,
+	.range_check = no_range_check,
+	.getrange = NULL,
+};
+
 /**
  * vringh_init_kern - initialize a vringh for a kernelspace vring.
  * @vrh: the vringh to initialize.
@@ -898,179 +882,22 @@ static inline int kern_xfer(const struct vringh *vrh, void *dst,
  * Returns an error if num is invalid.
  */
 int vringh_init_kern(struct vringh *vrh, u64 features,
-		     unsigned int num, bool weak_barriers,
+		     unsigned int num, bool weak_barriers, gfp_t gfp,
 		     struct vring_desc *desc,
 		     struct vring_avail *avail,
 		     struct vring_used *used)
-{
-	/* Sane power of 2 please! */
-	if (!num || num > 0xffff || (num & (num - 1))) {
-		vringh_bad("Bad ring size %u", num);
-		return -EINVAL;
-	}
-
-	vrh->little_endian = (features & (1ULL << VIRTIO_F_VERSION_1));
-	vrh->event_indices = (features & (1 << VIRTIO_RING_F_EVENT_IDX));
-	vrh->weak_barriers = weak_barriers;
-	vrh->completed = 0;
-	vrh->last_avail_idx = 0;
-	vrh->last_used_idx = 0;
-	vrh->vring.num = num;
-	vrh->vring.desc = desc;
-	vrh->vring.avail = avail;
-	vrh->vring.used = used;
-	return 0;
-}
-EXPORT_SYMBOL(vringh_init_kern);
-
-/**
- * vringh_getdesc_kern - get next available descriptor from kernelspace ring.
- * @vrh: the kernelspace vring.
- * @riov: where to put the readable descriptors (or NULL)
- * @wiov: where to put the writable descriptors (or NULL)
- * @head: head index we received, for passing to vringh_complete_kern().
- * @gfp: flags for allocating larger riov/wiov.
- *
- * Returns 0 if there was no descriptor, 1 if there was, or -errno.
- *
- * Note that on error return, you can tell the difference between an
- * invalid ring and a single invalid descriptor: in the former case,
- * *head will be vrh->vring.num.  You may be able to ignore an invalid
- * descriptor, but there's not much you can do with an invalid ring.
- *
- * Note that you can reuse riov and wiov with subsequent calls. Content is
- * overwritten and memory reallocated if more space is needed.
- * When you don't have to use riov and wiov anymore, you should clean up them
- * calling vringh_kiov_cleanup() to release the memory, even on error!
- */
-int vringh_getdesc_kern(struct vringh *vrh,
-			struct vringh_kiov *riov,
-			struct vringh_kiov *wiov,
-			u16 *head,
-			gfp_t gfp)
 {
 	int err;
 
-	err = __vringh_get_head(vrh, getu16_kern, &vrh->last_avail_idx);
-	if (err < 0)
-		return err;
-
-	/* Empty... */
-	if (err == vrh->vring.num)
-		return 0;
-
-	*head = err;
-	err = __vringh_iov(vrh, *head, riov, wiov, no_range_check, NULL,
-			   gfp, copydesc_kern);
+	err = __vringh_init(vrh, features, num, weak_barriers, gfp, desc, avail, used);
 	if (err)
 		return err;
 
-	return 1;
-}
-EXPORT_SYMBOL(vringh_getdesc_kern);
-
-/**
- * vringh_iov_pull_kern - copy bytes from vring_iov.
- * @riov: the riov as passed to vringh_getdesc_kern() (updated as we consume)
- * @dst: the place to copy.
- * @len: the maximum length to copy.
- *
- * Returns the bytes copied <= len or a negative errno.
- */
-ssize_t vringh_iov_pull_kern(struct vringh_kiov *riov, void *dst, size_t len)
-{
-	return vringh_iov_xfer(NULL, riov, dst, len, xfer_kern);
-}
-EXPORT_SYMBOL(vringh_iov_pull_kern);
-
-/**
- * vringh_iov_push_kern - copy bytes into vring_iov.
- * @wiov: the wiov as passed to vringh_getdesc_kern() (updated as we consume)
- * @src: the place to copy from.
- * @len: the maximum length to copy.
- *
- * Returns the bytes copied <= len or a negative errno.
- */
-ssize_t vringh_iov_push_kern(struct vringh_kiov *wiov,
-			     const void *src, size_t len)
-{
-	return vringh_iov_xfer(NULL, wiov, (void *)src, len, kern_xfer);
-}
-EXPORT_SYMBOL(vringh_iov_push_kern);
+	memcpy(&vrh->ops, &kern_vringh_ops, sizeof(kern_vringh_ops));
 
-/**
- * vringh_abandon_kern - we've decided not to handle the descriptor(s).
- * @vrh: the vring.
- * @num: the number of descriptors to put back (ie. num
- *	 vringh_get_kern() to undo).
- *
- * The next vringh_get_kern() will return the old descriptor(s) again.
- */
-void vringh_abandon_kern(struct vringh *vrh, unsigned int num)
-{
-	/* We only update vring_avail_event(vr) when we want to be notified,
-	 * so we haven't changed that yet. */
-	vrh->last_avail_idx -= num;
-}
-EXPORT_SYMBOL(vringh_abandon_kern);
-
-/**
- * vringh_complete_kern - we've finished with descriptor, publish it.
- * @vrh: the vring.
- * @head: the head as filled in by vringh_getdesc_kern.
- * @len: the length of data we have written.
- *
- * You should check vringh_need_notify_kern() after one or more calls
- * to this function.
- */
-int vringh_complete_kern(struct vringh *vrh, u16 head, u32 len)
-{
-	struct vring_used_elem used;
-
-	used.id = cpu_to_vringh32(vrh, head);
-	used.len = cpu_to_vringh32(vrh, len);
-
-	return __vringh_complete(vrh, &used, 1, putu16_kern, putused_kern);
-}
-EXPORT_SYMBOL(vringh_complete_kern);
-
-/**
- * vringh_notify_enable_kern - we want to know if something changes.
- * @vrh: the vring.
- *
- * This always enables notifications, but returns false if there are
- * now more buffers available in the vring.
- */
-bool vringh_notify_enable_kern(struct vringh *vrh)
-{
-	return __vringh_notify_enable(vrh, getu16_kern, putu16_kern);
-}
-EXPORT_SYMBOL(vringh_notify_enable_kern);
-
-/**
- * vringh_notify_disable_kern - don't tell us if something changes.
- * @vrh: the vring.
- *
- * This is our normal running state: we disable and then only enable when
- * we're going to sleep.
- */
-void vringh_notify_disable_kern(struct vringh *vrh)
-{
-	__vringh_notify_disable(vrh, putu16_kern);
-}
-EXPORT_SYMBOL(vringh_notify_disable_kern);
-
-/**
- * vringh_need_notify_kern - must we tell the other side about used buffers?
- * @vrh: the vring we've called vringh_complete_kern() on.
- *
- * Returns -errno or 0 if we don't need to tell the other side, 1 if we do.
- */
-int vringh_need_notify_kern(struct vringh *vrh)
-{
-	return __vringh_need_notify(vrh, getu16_kern);
+	return 0;
 }
-EXPORT_SYMBOL(vringh_need_notify_kern);
+EXPORT_SYMBOL(vringh_init_kern);
 
 #if IS_REACHABLE(CONFIG_VHOST_IOTLB)
 
@@ -1122,7 +949,7 @@ static int iotlb_translate(const struct vringh *vrh,
 	return ret;
 }
 
-static inline int copy_from_iotlb(const struct vringh *vrh, void *dst,
+static int copy_from_iotlb(const struct vringh *vrh, void *dst,
 				  void *src, size_t len)
 {
 	u64 total_translated = 0;
@@ -1155,7 +982,7 @@ static inline int copy_from_iotlb(const struct vringh *vrh, void *dst,
 	return total_translated;
 }
 
-static inline int copy_to_iotlb(const struct vringh *vrh, void *dst,
+static int copy_to_iotlb(const struct vringh *vrh, void *dst,
 				void *src, size_t len)
 {
 	u64 total_translated = 0;
@@ -1188,7 +1015,7 @@ static inline int copy_to_iotlb(const struct vringh *vrh, void *dst,
 	return total_translated;
 }
 
-static inline int getu16_iotlb(const struct vringh *vrh,
+static int getu16_iotlb(const struct vringh *vrh,
 			       u16 *val, const __virtio16 *p)
 {
 	struct bio_vec iov;
@@ -1209,7 +1036,7 @@ static inline int getu16_iotlb(const struct vringh *vrh,
 	return 0;
 }
 
-static inline int putu16_iotlb(const struct vringh *vrh,
+static int putu16_iotlb(const struct vringh *vrh,
 			       __virtio16 *p, u16 val)
 {
 	struct bio_vec iov;
@@ -1230,7 +1057,7 @@ static inline int putu16_iotlb(const struct vringh *vrh,
 	return 0;
 }
 
-static inline int copydesc_iotlb(const struct vringh *vrh,
+static int copydesc_iotlb(const struct vringh *vrh,
 				 void *dst, const void *src, size_t len)
 {
 	int ret;
@@ -1242,7 +1069,7 @@ static inline int copydesc_iotlb(const struct vringh *vrh,
 	return 0;
 }
 
-static inline int xfer_from_iotlb(const struct vringh *vrh, void *src,
+static int xfer_from_iotlb(const struct vringh *vrh, void *src,
 				  void *dst, size_t len)
 {
 	int ret;
@@ -1254,7 +1081,7 @@ static inline int xfer_from_iotlb(const struct vringh *vrh, void *src,
 	return 0;
 }
 
-static inline int xfer_to_iotlb(const struct vringh *vrh,
+static int xfer_to_iotlb(const struct vringh *vrh,
 			       void *dst, void *src, size_t len)
 {
 	int ret;
@@ -1266,7 +1093,7 @@ static inline int xfer_to_iotlb(const struct vringh *vrh,
 	return 0;
 }
 
-static inline int putused_iotlb(const struct vringh *vrh,
+static int putused_iotlb(const struct vringh *vrh,
 				struct vring_used_elem *dst,
 				const struct vring_used_elem *src,
 				unsigned int num)
@@ -1281,6 +1108,17 @@ static inline int putused_iotlb(const struct vringh *vrh,
 	return 0;
 }
 
+static const struct vringh_ops iotlb_vringh_ops = {
+	.getu16 = getu16_iotlb,
+	.putu16 = putu16_iotlb,
+	.xfer_from = xfer_from_iotlb,
+	.xfer_to = xfer_to_iotlb,
+	.putused = putused_iotlb,
+	.copydesc = copydesc_iotlb,
+	.range_check = no_range_check,
+	.getrange = NULL,
+};
+
 /**
  * vringh_init_iotlb - initialize a vringh for a ring with IOTLB.
  * @vrh: the vringh to initialize.
@@ -1294,13 +1132,20 @@ static inline int putused_iotlb(const struct vringh *vrh,
  * Returns an error if num is invalid.
  */
 int vringh_init_iotlb(struct vringh *vrh, u64 features,
-		      unsigned int num, bool weak_barriers,
+		      unsigned int num, bool weak_barriers, gfp_t gfp,
 		      struct vring_desc *desc,
 		      struct vring_avail *avail,
 		      struct vring_used *used)
 {
-	return vringh_init_kern(vrh, features, num, weak_barriers,
-				desc, avail, used);
+	int err;
+
+	err = __vringh_init(vrh, features, num, weak_barriers, gfp, desc, avail, used);
+	if (err)
+		return err;
+
+	memcpy(&vrh->ops, &iotlb_vringh_ops, sizeof(iotlb_vringh_ops));
+
+	return 0;
 }
 EXPORT_SYMBOL(vringh_init_iotlb);
 
@@ -1318,162 +1163,6 @@ void vringh_set_iotlb(struct vringh *vrh, struct vhost_iotlb *iotlb,
 }
 EXPORT_SYMBOL(vringh_set_iotlb);
 
-/**
- * vringh_getdesc_iotlb - get next available descriptor from ring with
- * IOTLB.
- * @vrh: the kernelspace vring.
- * @riov: where to put the readable descriptors (or NULL)
- * @wiov: where to put the writable descriptors (or NULL)
- * @head: head index we received, for passing to vringh_complete_iotlb().
- * @gfp: flags for allocating larger riov/wiov.
- *
- * Returns 0 if there was no descriptor, 1 if there was, or -errno.
- *
- * Note that on error return, you can tell the difference between an
- * invalid ring and a single invalid descriptor: in the former case,
- * *head will be vrh->vring.num.  You may be able to ignore an invalid
- * descriptor, but there's not much you can do with an invalid ring.
- *
- * Note that you can reuse riov and wiov with subsequent calls. Content is
- * overwritten and memory reallocated if more space is needed.
- * When you don't have to use riov and wiov anymore, you should clean up them
- * calling vringh_kiov_cleanup() to release the memory, even on error!
- */
-int vringh_getdesc_iotlb(struct vringh *vrh,
-			 struct vringh_kiov *riov,
-			 struct vringh_kiov *wiov,
-			 u16 *head,
-			 gfp_t gfp)
-{
-	int err;
-
-	err = __vringh_get_head(vrh, getu16_iotlb, &vrh->last_avail_idx);
-	if (err < 0)
-		return err;
-
-	/* Empty... */
-	if (err == vrh->vring.num)
-		return 0;
-
-	*head = err;
-	err = __vringh_iov(vrh, *head, riov, wiov, no_range_check, NULL,
-			   gfp, copydesc_iotlb);
-	if (err)
-		return err;
-
-	return 1;
-}
-EXPORT_SYMBOL(vringh_getdesc_iotlb);
-
-/**
- * vringh_iov_pull_iotlb - copy bytes from vring_iov.
- * @vrh: the vring.
- * @riov: the riov as passed to vringh_getdesc_iotlb() (updated as we consume)
- * @dst: the place to copy.
- * @len: the maximum length to copy.
- *
- * Returns the bytes copied <= len or a negative errno.
- */
-ssize_t vringh_iov_pull_iotlb(struct vringh *vrh,
-			      struct vringh_kiov *riov,
-			      void *dst, size_t len)
-{
-	return vringh_iov_xfer(vrh, riov, dst, len, xfer_from_iotlb);
-}
-EXPORT_SYMBOL(vringh_iov_pull_iotlb);
-
-/**
- * vringh_iov_push_iotlb - copy bytes into vring_iov.
- * @vrh: the vring.
- * @wiov: the wiov as passed to vringh_getdesc_iotlb() (updated as we consume)
- * @src: the place to copy from.
- * @len: the maximum length to copy.
- *
- * Returns the bytes copied <= len or a negative errno.
- */
-ssize_t vringh_iov_push_iotlb(struct vringh *vrh,
-			      struct vringh_kiov *wiov,
-			      const void *src, size_t len)
-{
-	return vringh_iov_xfer(vrh, wiov, (void *)src, len, xfer_to_iotlb);
-}
-EXPORT_SYMBOL(vringh_iov_push_iotlb);
-
-/**
- * vringh_abandon_iotlb - we've decided not to handle the descriptor(s).
- * @vrh: the vring.
- * @num: the number of descriptors to put back (ie. num
- *	 vringh_get_iotlb() to undo).
- *
- * The next vringh_get_iotlb() will return the old descriptor(s) again.
- */
-void vringh_abandon_iotlb(struct vringh *vrh, unsigned int num)
-{
-	/* We only update vring_avail_event(vr) when we want to be notified,
-	 * so we haven't changed that yet.
-	 */
-	vrh->last_avail_idx -= num;
-}
-EXPORT_SYMBOL(vringh_abandon_iotlb);
-
-/**
- * vringh_complete_iotlb - we've finished with descriptor, publish it.
- * @vrh: the vring.
- * @head: the head as filled in by vringh_getdesc_iotlb.
- * @len: the length of data we have written.
- *
- * You should check vringh_need_notify_iotlb() after one or more calls
- * to this function.
- */
-int vringh_complete_iotlb(struct vringh *vrh, u16 head, u32 len)
-{
-	struct vring_used_elem used;
-
-	used.id = cpu_to_vringh32(vrh, head);
-	used.len = cpu_to_vringh32(vrh, len);
-
-	return __vringh_complete(vrh, &used, 1, putu16_iotlb, putused_iotlb);
-}
-EXPORT_SYMBOL(vringh_complete_iotlb);
-
-/**
- * vringh_notify_enable_iotlb - we want to know if something changes.
- * @vrh: the vring.
- *
- * This always enables notifications, but returns false if there are
- * now more buffers available in the vring.
- */
-bool vringh_notify_enable_iotlb(struct vringh *vrh)
-{
-	return __vringh_notify_enable(vrh, getu16_iotlb, putu16_iotlb);
-}
-EXPORT_SYMBOL(vringh_notify_enable_iotlb);
-
-/**
- * vringh_notify_disable_iotlb - don't tell us if something changes.
- * @vrh: the vring.
- *
- * This is our normal running state: we disable and then only enable when
- * we're going to sleep.
- */
-void vringh_notify_disable_iotlb(struct vringh *vrh)
-{
-	__vringh_notify_disable(vrh, putu16_iotlb);
-}
-EXPORT_SYMBOL(vringh_notify_disable_iotlb);
-
-/**
- * vringh_need_notify_iotlb - must we tell the other side about used buffers?
- * @vrh: the vring we've called vringh_complete_iotlb() on.
- *
- * Returns -errno or 0 if we don't need to tell the other side, 1 if we do.
- */
-int vringh_need_notify_iotlb(struct vringh *vrh)
-{
-	return __vringh_need_notify(vrh, getu16_iotlb);
-}
-EXPORT_SYMBOL(vringh_need_notify_iotlb);
-
 #endif
 
 MODULE_LICENSE("GPL");
diff --git a/include/linux/vringh.h b/include/linux/vringh.h
index 733d948e8123..89c73605c85f 100644
--- a/include/linux/vringh.h
+++ b/include/linux/vringh.h
@@ -21,6 +21,36 @@
 #endif
 #include <asm/barrier.h>
 
+struct vringh;
+struct vringh_range;
+
+/**
+ * struct vringh_ops - ops for accessing a vring and checking to access range.
+ * @getu16: read u16 value from pointer
+ * @putu16: write u16 value to pointer
+ * @xfer_from: copy memory range from specified address to local virtual address
+ * @xfer_tio: copy memory range from local virtual address to specified address
+ * @putused: update vring used descriptor
+ * @copydesc: copy desiptor from target to local virtual address
+ * @range_check: check if the region is accessible
+ * @getrange: return a range that vring can access
+ */
+struct vringh_ops {
+	int (*getu16)(const struct vringh *vrh, u16 *val, const __virtio16 *p);
+	int (*putu16)(const struct vringh *vrh, __virtio16 *p, u16 val);
+	int (*xfer_from)(const struct vringh *vrh, void *src, void *dst,
+			 size_t len);
+	int (*xfer_to)(const struct vringh *vrh, void *dst, void *src,
+		       size_t len);
+	int (*putused)(const struct vringh *vrh, struct vring_used_elem *dst,
+		       const struct vring_used_elem *src, unsigned int num);
+	int (*copydesc)(const struct vringh *vrh, void *dst, const void *src,
+			size_t len);
+	bool (*range_check)(struct vringh *vrh, u64 addr, size_t *len,
+			    struct vringh_range *range);
+	bool (*getrange)(struct vringh *vrh, u64 addr, struct vringh_range *r);
+};
+
 /* virtio_ring with information needed for host access. */
 struct vringh {
 	/* Everything is little endian */
@@ -52,6 +82,10 @@ struct vringh {
 
 	/* The function to call to notify the guest about added buffers */
 	void (*notify)(struct vringh *);
+
+	struct vringh_ops ops;
+
+	gfp_t desc_gfp;
 };
 
 /**
@@ -99,41 +133,40 @@ int vringh_init_user(struct vringh *vrh, u64 features,
 		     unsigned int num, bool weak_barriers,
 		     vring_desc_t __user *desc,
 		     vring_avail_t __user *avail,
-		     vring_used_t __user *used);
+		     vring_used_t __user *used,
+			 bool (*getrange)(struct vringh *vrh, u64 addr, struct vringh_range *r));
 
 /* Convert a descriptor into iovecs. */
-int vringh_getdesc_user(struct vringh *vrh,
+int vringh_getdesc(struct vringh *vrh,
 			struct vringh_kiov *riov,
 			struct vringh_kiov *wiov,
-			bool (*getrange)(struct vringh *vrh,
-					 u64 addr, struct vringh_range *r),
 			u16 *head);
 
 /* Copy bytes from readable vsg, consuming it (and incrementing wiov->i). */
-ssize_t vringh_iov_pull_user(struct vringh_kiov *riov, void *dst, size_t len);
+ssize_t vringh_iov_pull(struct vringh *vrh, struct vringh_kiov *riov, void *dst, size_t len);
 
 /* Copy bytes into writable vsg, consuming it (and incrementing wiov->i). */
-ssize_t vringh_iov_push_user(struct vringh_kiov *wiov,
+ssize_t vringh_iov_push(struct vringh *vrh, struct vringh_kiov *wiov,
 			     const void *src, size_t len);
 
 /* Mark a descriptor as used. */
-int vringh_complete_user(struct vringh *vrh, u16 head, u32 len);
-int vringh_complete_multi_user(struct vringh *vrh,
+int vringh_complete(struct vringh *vrh, u16 head, u32 len);
+int vringh_complete_multi(struct vringh *vrh,
 			       const struct vring_used_elem used[],
 			       unsigned num_used);
 
 /* Pretend we've never seen descriptor (for easy error handling). */
-void vringh_abandon_user(struct vringh *vrh, unsigned int num);
+void vringh_abandon(struct vringh *vrh, unsigned int num);
 
 /* Do we need to fire the eventfd to notify the other side? */
-int vringh_need_notify_user(struct vringh *vrh);
+int vringh_need_notify(struct vringh *vrh);
 
-bool vringh_notify_enable_user(struct vringh *vrh);
-void vringh_notify_disable_user(struct vringh *vrh);
+bool vringh_notify_enable(struct vringh *vrh);
+void vringh_notify_disable(struct vringh *vrh);
 
 /* Helpers for kernelspace vrings. */
 int vringh_init_kern(struct vringh *vrh, u64 features,
-		     unsigned int num, bool weak_barriers,
+		     unsigned int num, bool weak_barriers, gfp_t gfp,
 		     struct vring_desc *desc,
 		     struct vring_avail *avail,
 		     struct vring_used *used);
@@ -176,23 +209,6 @@ static inline size_t vringh_kiov_length(struct vringh_kiov *kiov)
 
 void vringh_kiov_advance(struct vringh_kiov *kiov, size_t len);
 
-int vringh_getdesc_kern(struct vringh *vrh,
-			struct vringh_kiov *riov,
-			struct vringh_kiov *wiov,
-			u16 *head,
-			gfp_t gfp);
-
-ssize_t vringh_iov_pull_kern(struct vringh_kiov *riov, void *dst, size_t len);
-ssize_t vringh_iov_push_kern(struct vringh_kiov *wiov,
-			     const void *src, size_t len);
-void vringh_abandon_kern(struct vringh *vrh, unsigned int num);
-int vringh_complete_kern(struct vringh *vrh, u16 head, u32 len);
-
-bool vringh_notify_enable_kern(struct vringh *vrh);
-void vringh_notify_disable_kern(struct vringh *vrh);
-
-int vringh_need_notify_kern(struct vringh *vrh);
-
 /* Notify the guest about buffers added to the used ring */
 static inline void vringh_notify(struct vringh *vrh)
 {
@@ -242,33 +258,11 @@ void vringh_set_iotlb(struct vringh *vrh, struct vhost_iotlb *iotlb,
 		      spinlock_t *iotlb_lock);
 
 int vringh_init_iotlb(struct vringh *vrh, u64 features,
-		      unsigned int num, bool weak_barriers,
+		      unsigned int num, bool weak_barriers, gfp_t gfp,
 		      struct vring_desc *desc,
 		      struct vring_avail *avail,
 		      struct vring_used *used);
 
-int vringh_getdesc_iotlb(struct vringh *vrh,
-			 struct vringh_kiov *riov,
-			 struct vringh_kiov *wiov,
-			 u16 *head,
-			 gfp_t gfp);
-
-ssize_t vringh_iov_pull_iotlb(struct vringh *vrh,
-			      struct vringh_kiov *riov,
-			      void *dst, size_t len);
-ssize_t vringh_iov_push_iotlb(struct vringh *vrh,
-			      struct vringh_kiov *wiov,
-			      const void *src, size_t len);
-
-void vringh_abandon_iotlb(struct vringh *vrh, unsigned int num);
-
-int vringh_complete_iotlb(struct vringh *vrh, u16 head, u32 len);
-
-bool vringh_notify_enable_iotlb(struct vringh *vrh);
-void vringh_notify_disable_iotlb(struct vringh *vrh);
-
-int vringh_need_notify_iotlb(struct vringh *vrh);
-
 #endif /* CONFIG_VHOST_IOTLB */
 
 #endif /* _LINUX_VRINGH_H */
-- 
2.25.1

