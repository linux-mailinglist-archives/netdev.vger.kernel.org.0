Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCB7D1C3857
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 13:38:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728675AbgEDLiH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 07:38:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728665AbgEDLiG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 07:38:06 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC423C061A0E;
        Mon,  4 May 2020 04:38:05 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id f15so6658098plr.3;
        Mon, 04 May 2020 04:38:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qfFMz/xOczB9mHSUMm0XJ+8WPTjM0ssFIXbWiqAp3fY=;
        b=NUB6PQkPNyNjyTB70bUl+I2KbZSkzLyGev4kk5EhU12sdQzElKhIqYU+pn6ws5fgzi
         yxM4qb9VXnVKKv3QYxSEC3P7630UapSyULfL3n66AawyDkmNAspw/rcaw4povcXVBL4/
         08TRhuw2Pk639+4ykMRutlgnCI/tjd83Q5lM/5M+CJA6A3mWF/rnch1/iSxpW9FV41IZ
         KpOaZqeEgvcD3cXWCvIvpCbqJpWW2hYQCs4Tsbd3Ry6H/+6ydE2hMYQdTkG6biyaRhHF
         D3iX4PNSwEep59dsqlLLTEXU1nifcIEzla44HOyhAJGhFu9DH6ApRP7bpBlhKrbvUx6N
         wqbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qfFMz/xOczB9mHSUMm0XJ+8WPTjM0ssFIXbWiqAp3fY=;
        b=q7sdQ7HMpJz+jheUfzh7zQMeihTmtRBHSsPj9kGfVsvQ5T1pfm1Y9WAcvVkuhRo8T4
         /maP7UjE4cvEMqXAwxNIVPVn8woINRU2DxdJcPpZiMIy16ns9uT+p85gh3uy0ZXNocgq
         3iuwwQF5CASnpp4QFnPTe/nYn3nJ97Nxoh33nuEr8DKYO1Fss4kmo1xudjoyIY+BanpX
         gelkkM5WfonuvJHEwRDs2kbt9TAlfvOBr++kTbWt5LnLEbt2ZXT5Me7L+7fvC+b/0wtJ
         TXwtK6sgVtDhQKPPMU3DRO7hEfjVaHcRIbLRy0V+/p+2NFAOSi6Dpky3+HuyVSfXmPl6
         P4kg==
X-Gm-Message-State: AGi0PuYg+8zaWb/feNuhb84Xb0td0RVZB5W0iXhDiuzoAoeNSFy/ru/5
        OZQ8BUhRjjTELiw3JhJIq3c=
X-Google-Smtp-Source: APiQypLw9H4W2RTTComf6VO8GmdU7MUgk3G1ZQKDwNTfFa/OFI9kek0Kj1PaO2wokBqnYqDo3v7kbA==
X-Received: by 2002:a17:90a:3266:: with SMTP id k93mr18018934pjb.118.1588592285432;
        Mon, 04 May 2020 04:38:05 -0700 (PDT)
Received: from btopel-mobl.ger.intel.com ([192.55.55.41])
        by smtp.gmail.com with ESMTPSA id x185sm8650789pfx.155.2020.05.04.04.38.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 May 2020 04:38:04 -0700 (PDT)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, davem@davemloft.net,
        kuba@kernel.org, hawk@kernel.org, john.fastabend@gmail.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        magnus.karlsson@intel.com, jonathan.lemon@gmail.com
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        maximmi@mellanox.com, maciej.fijalkowski@intel.com
Subject: [RFC PATCH bpf-next 03/13] xsk: move defines only used by AF_XDP internals to xsk.h
Date:   Mon,  4 May 2020 13:37:05 +0200
Message-Id: <20200504113716.7930-4-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200504113716.7930-1-bjorn.topel@gmail.com>
References: <20200504113716.7930-1-bjorn.topel@gmail.com>
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
index 62eedd5a36c7..425a42c54b95 100644
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
index b50bb5c76da5..aa3dd35cbfb6 100644
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

