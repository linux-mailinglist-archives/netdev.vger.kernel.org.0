Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0D2E1DAF33
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 11:48:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726851AbgETJsb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 05:48:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726835AbgETJsa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 May 2020 05:48:30 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84935C061A0E;
        Wed, 20 May 2020 02:48:30 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id f6so1195654pgm.1;
        Wed, 20 May 2020 02:48:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=VonCmuB+xYklsPqBGzAOZb7n4020/T4yIH57DB5Cs9w=;
        b=lAPWTpSZZGOBVO43F8Ev1MUdht8b5M1ntJRSHqN5ugsIjvw6Frhu1+7dD8xlA7trLU
         XzV1yfZPxvNIRu6um12HZfA0sOcu5iceC1XwrRmA5rP7HtPP2hr3YTMPbK3oEaa6Hlbw
         J7k95g0aEaQTGmqds1Fes9GdIsCyDncSV3fYaaaeJKiopTHTwXtxivrQc3TU/Ol4rBkj
         Wn+aq8qenR2neBhKMG18w+md05k8MCraWNincbTWJsoPVaOr6548pATF8HkXfuU4caxK
         e3InPUsgedfgwhdvLCL0DCE8siVF6XOA8D+CKhdlJe+lkDkob8SEISQ1M/QPzyu6dFZp
         74rA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VonCmuB+xYklsPqBGzAOZb7n4020/T4yIH57DB5Cs9w=;
        b=Vj2wOUfLRqdbMvtOrfJ+WAvG9PEQyWYs616Grrab6qXWS/AafsRIvNS0b1UCkfceRG
         iSBzRInxfLhc8UqX4KrpWaNIFTwcJMFEL7bZZ4XqZa0I/S0FXZB83K1cuXTTjy1imCfA
         LUlYB/9PcQsEVjmArxU2q9VdFAL9+/+SpQOOyzZQnp1O2rgJp73xQw3vImm+0Drj5xfF
         j7yw8iMKsgjLq7D08U/TuFSvryVoiWt18SNVKEn5jHREGzyv0dcytlwrSQ6qK5bYG7KS
         4o9JSn7Q3K+Mai+QNLADDrGpiuHvBcfkbwUvh2F6x808b1Qxv1krCpt09vSLosFgBn6q
         ag5w==
X-Gm-Message-State: AOAM530+sI0+FdoIIUpsU+mpOfb5fFXQhgdPhJ8RZBvIodC82lJ6xy13
        1NpFFT+YtPN7YlXybWTzv94=
X-Google-Smtp-Source: ABdhPJyHTOfECB50otfRrEZGzevj8VBb/mEhkpwYoYQ/fKkLqOxAQBxKCqMfwdcqxc1KykDUhgEkSw==
X-Received: by 2002:a63:1103:: with SMTP id g3mr3371653pgl.206.1589968110050;
        Wed, 20 May 2020 02:48:30 -0700 (PDT)
Received: from btopel-mobl.ger.intel.com (fmdmzpr03-ext.fm.intel.com. [192.55.54.38])
        by smtp.gmail.com with ESMTPSA id c124sm1707494pfb.187.2020.05.20.02.48.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 May 2020 02:48:29 -0700 (PDT)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, davem@davemloft.net,
        kuba@kernel.org, hawk@kernel.org, john.fastabend@gmail.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        magnus.karlsson@intel.com, jonathan.lemon@gmail.com,
        jeffrey.t.kirsher@intel.com
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        maximmi@mellanox.com, maciej.fijalkowski@intel.com
Subject: [PATCH bpf-next v4 04/15] xsk: move defines only used by AF_XDP internals to xsk.h
Date:   Wed, 20 May 2020 11:47:31 +0200
Message-Id: <20200520094742.337678-5-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200520094742.337678-1-bjorn.topel@gmail.com>
References: <20200520094742.337678-1-bjorn.topel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Björn Töpel <bjorn.topel@intel.com>

Move the XSK_NEXT_PG_CONTIG_{MASK,SHIFT}, and
XDP_UMEM_USES_NEED_WAKEUP defines from xdp_sock.h to the AF_XDP
internal xsk.h file. Also, start using the BIT{,_ULL} macro instead of
explicit shifts.

Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
---
 include/net/xdp_sock.h | 14 --------------
 net/xdp/xsk.h          | 14 ++++++++++++++
 net/xdp/xsk_queue.h    |  2 ++
 3 files changed, 16 insertions(+), 14 deletions(-)

diff --git a/include/net/xdp_sock.h b/include/net/xdp_sock.h
index 6a986dcbc336..fb7fe3060175 100644
--- a/include/net/xdp_sock.h
+++ b/include/net/xdp_sock.h
@@ -17,13 +17,6 @@ struct net_device;
 struct xsk_queue;
 struct xdp_buff;
 
-/* Masks for xdp_umem_page flags.
- * The low 12-bits of the addr will be 0 since this is the page address, so we
- * can use them for flags.
- */
-#define XSK_NEXT_PG_CONTIG_SHIFT 0
-#define XSK_NEXT_PG_CONTIG_MASK (1ULL << XSK_NEXT_PG_CONTIG_SHIFT)
-
 struct xdp_umem_page {
 	void *addr;
 	dma_addr_t dma;
@@ -35,13 +28,6 @@ struct xdp_umem_fq_reuse {
 	u64 handles[];
 };
 
-/* Flags for the umem flags field.
- *
- * The NEED_WAKEUP flag is 1 due to the reuse of the flags field for public
- * flags. See inlude/uapi/include/linux/if_xdp.h.
- */
-#define XDP_UMEM_USES_NEED_WAKEUP (1 << 1)
-
 struct xdp_umem {
 	struct xsk_queue *fq;
 	struct xsk_queue *cq;
diff --git a/net/xdp/xsk.h b/net/xdp/xsk.h
index d6a0979050e6..455ddd480f3d 100644
--- a/net/xdp/xsk.h
+++ b/net/xdp/xsk.h
@@ -4,6 +4,20 @@
 #ifndef XSK_H_
 #define XSK_H_
 
+/* Masks for xdp_umem_page flags.
+ * The low 12-bits of the addr will be 0 since this is the page address, so we
+ * can use them for flags.
+ */
+#define XSK_NEXT_PG_CONTIG_SHIFT 0
+#define XSK_NEXT_PG_CONTIG_MASK BIT_ULL(XSK_NEXT_PG_CONTIG_SHIFT)
+
+/* Flags for the umem flags field.
+ *
+ * The NEED_WAKEUP flag is 1 due to the reuse of the flags field for public
+ * flags. See inlude/uapi/include/linux/if_xdp.h.
+ */
+#define XDP_UMEM_USES_NEED_WAKEUP BIT(1)
+
 struct xdp_ring_offset_v1 {
 	__u64 producer;
 	__u64 consumer;
diff --git a/net/xdp/xsk_queue.h b/net/xdp/xsk_queue.h
index 648733ec24ac..a322a7dac58c 100644
--- a/net/xdp/xsk_queue.h
+++ b/net/xdp/xsk_queue.h
@@ -10,6 +10,8 @@
 #include <linux/if_xdp.h>
 #include <net/xdp_sock.h>
 
+#include "xsk.h"
+
 struct xdp_ring {
 	u32 producer ____cacheline_aligned_in_smp;
 	u32 consumer ____cacheline_aligned_in_smp;
-- 
2.25.1

