Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB7971D2A44
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 10:37:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726059AbgENIhj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 04:37:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725878AbgENIhi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 04:37:38 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 562D2C061A0C;
        Thu, 14 May 2020 01:37:38 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id u15so918994plm.2;
        Thu, 14 May 2020 01:37:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=VonCmuB+xYklsPqBGzAOZb7n4020/T4yIH57DB5Cs9w=;
        b=OynCyAGrBeME/3Z789+0sHs8e3kxd1LWGDLDppZNvlUmSNTq74vj1u+KExeuyhuAjH
         BxYbBnJG1GLo1CvOA755vQ67UpL1w9BBWePapUzrZdvIkQO8L6rrQqiBh3PZY8ajOZL8
         pc5Fkl9pnSwX4TMHRIUlNKNIrgUI/wxBVg2yDkdLHkoSpti/H7R2QEZaUKdNyTGA3vlC
         h8CH4KCoWoi0B9RukYb+52eMcajOjF8SFxjAzWCttZR5YcQV827Xjw6lKlO50s7CDbul
         oHch0Mdwh356LNg1BnCeIlldloEJR36QGATddItK/2HZmyJxmKyvJOKZzXrLdILUNuen
         NF+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VonCmuB+xYklsPqBGzAOZb7n4020/T4yIH57DB5Cs9w=;
        b=J+tta1PcM7xCqnrwHqILzgw/EAl3XS/9bHWF51E95Xn9jAh2DAfpsn8Ma77gTzOrTx
         rERzTumQXA19JwOJmV7tjoe/F5NVJv2p6Rcqj2XFCEHQJusGvqYjiexTSRLktbTNnbzA
         oWkY6FuDAh8kiNqoIeC2nyORmasn7q71v9q+LT6rV8O2rQDA1so7aw/F/TV7XMKXM6xq
         bG8z9PmFyBMidAAKnSiSWHBkfrXVj0r/bTaxshUhGoBkD3cUKk68JwpDfH0fdqmppe7o
         6v9wJjPt1leQVeJJhqKowDw9uLQfxLJ3XI9KMUsOpVGwucVbEljuZX5i3inbNbfhrcP9
         laYQ==
X-Gm-Message-State: AOAM532k8PS8Z1Bd5kqB7RDlRY2EEz2RSe/xL3pbd2g5sInwvC2o1O3q
        wAKrdIHTPcXD5HbPjfiQg10=
X-Google-Smtp-Source: ABdhPJzRCxBc+srcf9zKWn7GmElk9uk2uXzp4BauRbeftkC9RIrGK3Qv0Fa9Q2oVHkKBGohXEsVCPw==
X-Received: by 2002:a17:90a:202c:: with SMTP id n41mr7699127pjc.208.1589445457889;
        Thu, 14 May 2020 01:37:37 -0700 (PDT)
Received: from btopel-mobl.ger.intel.com ([192.55.54.42])
        by smtp.gmail.com with ESMTPSA id k4sm1608058pgg.88.2020.05.14.01.37.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 May 2020 01:37:37 -0700 (PDT)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, davem@davemloft.net,
        kuba@kernel.org, hawk@kernel.org, john.fastabend@gmail.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        magnus.karlsson@intel.com, jonathan.lemon@gmail.com,
        jeffrey.t.kirsher@intel.com
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        maximmi@mellanox.com, maciej.fijalkowski@intel.com
Subject: [PATCH bpf-next v2 03/14] xsk: move defines only used by AF_XDP internals to xsk.h
Date:   Thu, 14 May 2020 10:36:59 +0200
Message-Id: <20200514083710.143394-4-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200514083710.143394-1-bjorn.topel@gmail.com>
References: <20200514083710.143394-1-bjorn.topel@gmail.com>
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

