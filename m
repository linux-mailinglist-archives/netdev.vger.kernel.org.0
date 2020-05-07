Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 635861C8716
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 12:43:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726907AbgEGKna (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 06:43:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725900AbgEGKn3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 May 2020 06:43:29 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A95DC061A10;
        Thu,  7 May 2020 03:43:28 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id x77so2836452pfc.0;
        Thu, 07 May 2020 03:43:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=VonCmuB+xYklsPqBGzAOZb7n4020/T4yIH57DB5Cs9w=;
        b=od+mtmvdAsXI8OCKVwJcI+srVwqT4Bsb0tIXdCxjK46O5ShGOayowzcyUtOFDfQmJr
         FmO6sP6l/Xnn0t6GoYSQ2T56oQ6iuH59sWLrrq1ENjszYKQx7ttWZTpOZDypgsamhurq
         Y7IhmHtFqTy9S1UixZ7knjnY5arQbqZhwn6l2v7ay7Mk+1J8HHVr77FtYQ164bvc24oK
         o9Y9PwJSCGgO3XBIZDdOAUCopMkxJ1L6m+Onl+udDKsJ/3viwVCrxhhETnnu8q6HCaye
         8E5xRoHiaIMAxAmzHb84c/kM9nIcXn7YXnhsBcvuf1cZyUQgvkYKj3dEgQcPIpSPMhwD
         /gSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VonCmuB+xYklsPqBGzAOZb7n4020/T4yIH57DB5Cs9w=;
        b=Tn4bPfSRoNGqxubmKhPfjdK3aWlNn1TkDOns2/4rRnZgy4CgpDEOQLeUYqu7TZZb4i
         QOiSnmABA220ykYM0gOLyCEVbGn5ST07D8J2bQ+RjVY4mHMTtobRU1WC0Lxi3qhRlF04
         XVAEN9vAiqgCwxoizN+LwB1J7ACRUfyKpp+Fc52vZJomCsu9otoFCSlZD5Tgf5glJYFZ
         Cz3IaHmgcfWBq21AHgLG9RsgMF3pMSbGetK9wqOmwkcKPlGOgvFa+nFk2fNrcf2xolYv
         0iV8ZS/NAzyJ9Gyu27Bag4SMrI7rvzvUww7FKycHxibZmL0siffjBSRZyNRNrfEjoqQ4
         b6EQ==
X-Gm-Message-State: AGi0PuY1bwNmgG+XNgBwxCGQzxS3+yY/GdAyxRUyzWBv+CYW8BEoXgHh
        4ZroXxCXrqlkE5wAkCVC0+M=
X-Google-Smtp-Source: APiQypI7KxKoihDoYizu8fw72iUe+o6pk4V/OIu8c6eutyjNHD45kDItFLOzTyfexx8Sbyy7CdWUmw==
X-Received: by 2002:a63:d74a:: with SMTP id w10mr4266837pgi.417.1588848207872;
        Thu, 07 May 2020 03:43:27 -0700 (PDT)
Received: from btopel-mobl.ger.intel.com ([192.55.55.43])
        by smtp.gmail.com with ESMTPSA id j14sm7450673pjm.27.2020.05.07.03.43.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 May 2020 03:43:27 -0700 (PDT)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, davem@davemloft.net,
        kuba@kernel.org, hawk@kernel.org, john.fastabend@gmail.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        magnus.karlsson@intel.com, jonathan.lemon@gmail.com,
        jeffrey.t.kirsher@intel.com
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        maximmi@mellanox.com, maciej.fijalkowski@intel.com
Subject: [PATCH bpf-next 03/14] xsk: move defines only used by AF_XDP internals to xsk.h
Date:   Thu,  7 May 2020 12:42:41 +0200
Message-Id: <20200507104252.544114-4-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200507104252.544114-1-bjorn.topel@gmail.com>
References: <20200507104252.544114-1-bjorn.topel@gmail.com>
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

