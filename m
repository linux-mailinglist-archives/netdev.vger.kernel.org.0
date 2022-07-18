Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD834578779
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 18:35:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234117AbiGRQfz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 12:35:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234540AbiGRQfY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 12:35:24 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CF082AC6F
        for <netdev@vger.kernel.org>; Mon, 18 Jul 2022 09:35:23 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id 70so11126092pfx.1
        for <netdev@vger.kernel.org>; Mon, 18 Jul 2022 09:35:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=j36PIs7ePGaN2Ypkzr6FkZpry1LtFILVuyGUJ38gdb0=;
        b=kF0WJtGRE7kT9WsX/cTBeRw5NEnzq3qwrmKk8Qhadvf4VqiBjQc6p2pGVxpwq/1Jq6
         /utzygJj+OruqHCtL8JVsP2s7G1aYemkeP43xRzWDFMeMXAxx4KQKFS8puoAdm5B20iB
         Ru2QRwYn1qZhkZeJ9S9PU2A1MAtICN38G1NxYTDSLkWj7m7YZBcn7ghhuPRzPnIRntvY
         +nYhI/ZCFB71+oJ9xNZYLgwGlQePkqm9q64nZVNYkQ2T1D4aqbbU3yVGV1P52wCVuD+S
         COmg4NMtVLlecQO+rDpAfcP+v8J5TKoDWvIoHKwya8lH1n6991voc/Cyr91WQoXs+SJV
         lAwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=j36PIs7ePGaN2Ypkzr6FkZpry1LtFILVuyGUJ38gdb0=;
        b=JjXQXbWVFZg/i7yYCC1RioHRCBA8YZj5VxWaSmVZ6oI/ikefT/oawQfmgy8z+NcKNh
         PBavD86JVaeluP+m5gjt1ArXuoXi+zzWGpmSGGX5m1LgT5sGo3DIAUgDDZ/T1xSOJDNY
         Uwz0DEJGrq3yj1iBeq68VPadMeJ1/QNo1F6amqGOwJpkWYjriKzeoqQ+Aqdpb+fcJ15l
         XjqeGAdmvDwac0mQUPrHkltwtXrDRHQferqx4YQpjlnKP99vNy2owArlNW8WZiQXUFE5
         1RPqhD90L3cjlx+ZTUsMEOo4LHshgE3ib7AiyGcrcSHc5d1o3e0lDzVlCAKZjVlSN3EI
         tWbw==
X-Gm-Message-State: AJIora+lFm+iGLYZvn5OCQlJ/kvi1kBHEPVe/V6T+HhNYYOAK2XaVOwo
        67/kakjny0WqyZx+cN7xeR2RG9cZc+t3jg==
X-Google-Smtp-Source: AGRyM1v5FE07AeZNbGkVo1q+qHJ5IOtNwbkKZlUyAa8QNaWDTv6vWBvTxZGc14ndVH2oyL6uc2Flfg==
X-Received: by 2002:a63:d94a:0:b0:412:6e04:dc26 with SMTP id e10-20020a63d94a000000b004126e04dc26mr25544117pgj.539.1658162122799;
        Mon, 18 Jul 2022 09:35:22 -0700 (PDT)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id ij14-20020a170902ab4e00b0016d02b0fa25sm50436plb.164.2022.07.18.09.35.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jul 2022 09:35:20 -0700 (PDT)
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     elic@nvidia.com
Cc:     netdev@vger.kernel.org,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH iproute2] uapi: add virtio_ring.h
Date:   Mon, 18 Jul 2022 09:35:13 -0700
Message-Id: <20220718163513.12441-1-stephen@networkplumber.org>
X-Mailer: git-send-email 2.35.1
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

When vdpa was updated, it included linux/virtio_ring.h but that
sanitized header file was not added.

Fixes: bd91c7647189 ("vdpa: Allow for printing negotiated features of a device")
Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
---
 include/uapi/linux/virtio_ring.h | 242 +++++++++++++++++++++++++++++++
 1 file changed, 242 insertions(+)
 create mode 100644 include/uapi/linux/virtio_ring.h

diff --git a/include/uapi/linux/virtio_ring.h b/include/uapi/linux/virtio_ring.h
new file mode 100644
index 000000000000..010483437e54
--- /dev/null
+++ b/include/uapi/linux/virtio_ring.h
@@ -0,0 +1,242 @@
+#ifndef _LINUX_VIRTIO_RING_H
+#define _LINUX_VIRTIO_RING_H
+/* An interface for efficient virtio implementation, currently for use by KVM,
+ * but hopefully others soon.  Do NOT change this since it will
+ * break existing servers and clients.
+ *
+ * This header is BSD licensed so anyone can use the definitions to implement
+ * compatible drivers/servers.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ * 1. Redistributions of source code must retain the above copyright
+ *    notice, this list of conditions and the following disclaimer.
+ * 2. Redistributions in binary form must reproduce the above copyright
+ *    notice, this list of conditions and the following disclaimer in the
+ *    documentation and/or other materials provided with the distribution.
+ * 3. Neither the name of IBM nor the names of its contributors
+ *    may be used to endorse or promote products derived from this software
+ *    without specific prior written permission.
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS ``AS IS'' AND
+ * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
+ * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
+ * ARE DISCLAIMED.  IN NO EVENT SHALL IBM OR CONTRIBUTORS BE LIABLE
+ * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
+ * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
+ * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
+ * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
+ * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
+ * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
+ * SUCH DAMAGE.
+ *
+ * Copyright Rusty Russell IBM Corporation 2007. */
+#include <stdint.h>
+#include <linux/types.h>
+#include <linux/virtio_types.h>
+
+/* This marks a buffer as continuing via the next field. */
+#define VRING_DESC_F_NEXT	1
+/* This marks a buffer as write-only (otherwise read-only). */
+#define VRING_DESC_F_WRITE	2
+/* This means the buffer contains a list of buffer descriptors. */
+#define VRING_DESC_F_INDIRECT	4
+
+/*
+ * Mark a descriptor as available or used in packed ring.
+ * Notice: they are defined as shifts instead of shifted values.
+ */
+#define VRING_PACKED_DESC_F_AVAIL	7
+#define VRING_PACKED_DESC_F_USED	15
+
+/* The Host uses this in used->flags to advise the Guest: don't kick me when
+ * you add a buffer.  It's unreliable, so it's simply an optimization.  Guest
+ * will still kick if it's out of buffers. */
+#define VRING_USED_F_NO_NOTIFY	1
+/* The Guest uses this in avail->flags to advise the Host: don't interrupt me
+ * when you consume a buffer.  It's unreliable, so it's simply an
+ * optimization.  */
+#define VRING_AVAIL_F_NO_INTERRUPT	1
+
+/* Enable events in packed ring. */
+#define VRING_PACKED_EVENT_FLAG_ENABLE	0x0
+/* Disable events in packed ring. */
+#define VRING_PACKED_EVENT_FLAG_DISABLE	0x1
+/*
+ * Enable events for a specific descriptor in packed ring.
+ * (as specified by Descriptor Ring Change Event Offset/Wrap Counter).
+ * Only valid if VIRTIO_RING_F_EVENT_IDX has been negotiated.
+ */
+#define VRING_PACKED_EVENT_FLAG_DESC	0x2
+
+/*
+ * Wrap counter bit shift in event suppression structure
+ * of packed ring.
+ */
+#define VRING_PACKED_EVENT_F_WRAP_CTR	15
+
+/* We support indirect buffer descriptors */
+#define VIRTIO_RING_F_INDIRECT_DESC	28
+
+/* The Guest publishes the used index for which it expects an interrupt
+ * at the end of the avail ring. Host should ignore the avail->flags field. */
+/* The Host publishes the avail index for which it expects a kick
+ * at the end of the used ring. Guest should ignore the used->flags field. */
+#define VIRTIO_RING_F_EVENT_IDX		29
+
+/* Alignment requirements for vring elements.
+ * When using pre-virtio 1.0 layout, these fall out naturally.
+ */
+#define VRING_AVAIL_ALIGN_SIZE 2
+#define VRING_USED_ALIGN_SIZE 4
+#define VRING_DESC_ALIGN_SIZE 16
+
+/* Virtio ring descriptors: 16 bytes.  These can chain together via "next". */
+struct vring_desc {
+	/* Address (guest-physical). */
+	__virtio64 addr;
+	/* Length. */
+	__virtio32 len;
+	/* The flags as indicated above. */
+	__virtio16 flags;
+	/* We chain unused descriptors via this, too */
+	__virtio16 next;
+};
+
+struct vring_avail {
+	__virtio16 flags;
+	__virtio16 idx;
+	__virtio16 ring[];
+};
+
+/* u32 is used here for ids for padding reasons. */
+struct vring_used_elem {
+	/* Index of start of used descriptor chain. */
+	__virtio32 id;
+	/* Total length of the descriptor chain which was used (written to) */
+	__virtio32 len;
+};
+
+typedef struct vring_used_elem __attribute__((aligned(VRING_USED_ALIGN_SIZE)))
+	vring_used_elem_t;
+
+struct vring_used {
+	__virtio16 flags;
+	__virtio16 idx;
+	vring_used_elem_t ring[];
+};
+
+/*
+ * The ring element addresses are passed between components with different
+ * alignments assumptions. Thus, we might need to decrease the compiler-selected
+ * alignment, and so must use a typedef to make sure the aligned attribute
+ * actually takes hold:
+ *
+ * https://gcc.gnu.org/onlinedocs//gcc/Common-Type-Attributes.html#Common-Type-Attributes
+ *
+ * When used on a struct, or struct member, the aligned attribute can only
+ * increase the alignment; in order to decrease it, the packed attribute must
+ * be specified as well. When used as part of a typedef, the aligned attribute
+ * can both increase and decrease alignment, and specifying the packed
+ * attribute generates a warning.
+ */
+typedef struct vring_desc __attribute__((aligned(VRING_DESC_ALIGN_SIZE)))
+	vring_desc_t;
+typedef struct vring_avail __attribute__((aligned(VRING_AVAIL_ALIGN_SIZE)))
+	vring_avail_t;
+typedef struct vring_used __attribute__((aligned(VRING_USED_ALIGN_SIZE)))
+	vring_used_t;
+
+struct vring {
+	unsigned int num;
+
+	vring_desc_t *desc;
+
+	vring_avail_t *avail;
+
+	vring_used_t *used;
+};
+
+#ifndef VIRTIO_RING_NO_LEGACY
+
+/* The standard layout for the ring is a continuous chunk of memory which looks
+ * like this.  We assume num is a power of 2.
+ *
+ * struct vring
+ * {
+ *	// The actual descriptors (16 bytes each)
+ *	struct vring_desc desc[num];
+ *
+ *	// A ring of available descriptor heads with free-running index.
+ *	__virtio16 avail_flags;
+ *	__virtio16 avail_idx;
+ *	__virtio16 available[num];
+ *	__virtio16 used_event_idx;
+ *
+ *	// Padding to the next align boundary.
+ *	char pad[];
+ *
+ *	// A ring of used descriptor heads with free-running index.
+ *	__virtio16 used_flags;
+ *	__virtio16 used_idx;
+ *	struct vring_used_elem used[num];
+ *	__virtio16 avail_event_idx;
+ * };
+ */
+/* We publish the used event index at the end of the available ring, and vice
+ * versa. They are at the end for backwards compatibility. */
+#define vring_used_event(vr) ((vr)->avail->ring[(vr)->num])
+#define vring_avail_event(vr) (*(__virtio16 *)&(vr)->used->ring[(vr)->num])
+
+static __inline__ void vring_init(struct vring *vr, unsigned int num, void *p,
+			      unsigned long align)
+{
+	vr->num = num;
+	vr->desc = p;
+	vr->avail = (struct vring_avail *)((char *)p + num * sizeof(struct vring_desc));
+	vr->used = (void *)(((uintptr_t)&vr->avail->ring[num] + sizeof(__virtio16)
+		+ align-1) & ~(align - 1));
+}
+
+static __inline__ unsigned vring_size(unsigned int num, unsigned long align)
+{
+	return ((sizeof(struct vring_desc) * num + sizeof(__virtio16) * (3 + num)
+		 + align - 1) & ~(align - 1))
+		+ sizeof(__virtio16) * 3 + sizeof(struct vring_used_elem) * num;
+}
+
+#endif /* VIRTIO_RING_NO_LEGACY */
+
+/* The following is used with USED_EVENT_IDX and AVAIL_EVENT_IDX */
+/* Assuming a given event_idx value from the other side, if
+ * we have just incremented index from old to new_idx,
+ * should we trigger an event? */
+static __inline__ int vring_need_event(__u16 event_idx, __u16 new_idx, __u16 old)
+{
+	/* Note: Xen has similar logic for notification hold-off
+	 * in include/xen/interface/io/ring.h with req_event and req_prod
+	 * corresponding to event_idx + 1 and new_idx respectively.
+	 * Note also that req_event and req_prod in Xen start at 1,
+	 * event indexes in virtio start at 0. */
+	return (__u16)(new_idx - event_idx - 1) < (__u16)(new_idx - old);
+}
+
+struct vring_packed_desc_event {
+	/* Descriptor Ring Change Event Offset/Wrap Counter. */
+	__le16 off_wrap;
+	/* Descriptor Ring Change Event Flags. */
+	__le16 flags;
+};
+
+struct vring_packed_desc {
+	/* Buffer Address. */
+	__le64 addr;
+	/* Buffer Length. */
+	__le32 len;
+	/* Buffer ID. */
+	__le16 id;
+	/* The flags depending on descriptor type. */
+	__le16 flags;
+};
+
+#endif /* _LINUX_VIRTIO_RING_H */
-- 
2.35.1

