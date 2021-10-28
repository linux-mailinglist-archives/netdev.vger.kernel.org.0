Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7121E43E26E
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 15:40:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230264AbhJ1NnJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 09:43:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230407AbhJ1NnI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Oct 2021 09:43:08 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8B9EC061570;
        Thu, 28 Oct 2021 06:40:40 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id b12so5837477wrh.4;
        Thu, 28 Oct 2021 06:40:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VKrybnnYHPP8HXbX2K+5aOS9L64qpsW4rKWfv44Odnc=;
        b=JnsaOnY7zdgkyNs7tnr70Dpp2yTvi6SqKMpfxlQjQe7QFwldmFY0lrKsQejGl2PPRf
         sBMfqDg1pepmDdSSNWUdgY5sui75Y38FwGTxXe36y2Y6TTQtifS6vTMkqrTbfbndxWPz
         i3aOWR7wFfIzFmlMGUBfpeuYZ1etVZr5u8UD+c7F/Gd8hFLWLu69kBucaAzmLyQEzc0x
         RoOwZJXtLCOIdOkk+LzKKNaekb38QVa3tkM/G/D9fV8Hl4O47W72vDdFzM4nq58vT/lx
         aENf77MzyCb/mnJWCkAdC2jsnyOyuqPOuBD1bpRodZ8SJz0iRnQafyVWnXVUZmOIxDet
         slXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VKrybnnYHPP8HXbX2K+5aOS9L64qpsW4rKWfv44Odnc=;
        b=ItdC917LBDorxrgiZMacJKeaak+wpv3I+8naDSL+j0eWgnhrBEZpU0CqMwh4Z14qG4
         mjqCG7SGgy5KsPkFGuJ9gx/iohipQ4G25wLHU2Q1tzB6BTrYuk0FzxL3EUBUpTwjBqo6
         +vR2hrUNAD+ekS7djD+OwSIDRiDNhlQPweLOoWxZ+teQfDuTG0xo1m0CAnWXsebU6+v6
         oADyXSrdOqx5FmHuC1NLtAXqLXn35tGKf161++duF2d7XHzpFl3nP8SB4l6L0D2sACAP
         pQjZDST/1QRBOvY9xp5aybblV8g0xJZIIPy/1OH4xkTd/mUIXyih52C87pUQE6j2nZjt
         tZOg==
X-Gm-Message-State: AOAM532kn9mNEcIpcBM070jBXDdHWeg0KqO6in31sDXUFlCw+ZYImdl9
        36jJ/sZwy0/YqTbnbSONXx8=
X-Google-Smtp-Source: ABdhPJxw8BOHKAWzd0j8RoT4Udl4LhMCt1zgnuc/Gh/+ue021GeVSd9wNyNtqt+S8UVGfafiYOrlDA==
X-Received: by 2002:a5d:6d07:: with SMTP id e7mr5776452wrq.425.1635428439219;
        Thu, 28 Oct 2021 06:40:39 -0700 (PDT)
Received: from localhost.localdomain ([188.149.128.194])
        by smtp.gmail.com with ESMTPSA id s3sm3090519wrm.40.2021.10.28.06.40.37
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 28 Oct 2021 06:40:38 -0700 (PDT)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com, yhs@fb.com, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org
Cc:     jonathan.lemon@gmail.com, ciara.loftus@intel.com,
        bpf@vger.kernel.org
Subject: [PATCH bpf-next] libbpf: deprecate AF_XDP support
Date:   Thu, 28 Oct 2021 15:40:03 +0200
Message-Id: <20211028134003.27160-1-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.29.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Magnus Karlsson <magnus.karlsson@intel.com>

Deprecate AF_XDP support in libbpf ([0]). This has been moved to
libxdp as it is a better fit for that library. The AF_XDP support only
uses the public libbpf functions and can therefore just use libbpf as
a library from libxdp. The libxdp APIs are exactly the same so it
should just be linking with libxdp instead of libbpf for the AF_XDP
functionality. If not, please submit a bug report. Linking with both
libraries is supported but make sure you link in the correct order so
that the new functions in libxdp are used instead of the deprecated
ones in libbpf.

Libxdp can be found at https://github.com/xdp-project/xdp-tools.

[0] https://github.com/libbpf/libbpf/issues/270

Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 tools/lib/bpf/xsk.h | 90 ++++++++++++++++++++++++++-------------------
 1 file changed, 52 insertions(+), 38 deletions(-)

diff --git a/tools/lib/bpf/xsk.h b/tools/lib/bpf/xsk.h
index 01c12dca9c10..566f774e4b36 100644
--- a/tools/lib/bpf/xsk.h
+++ b/tools/lib/bpf/xsk.h
@@ -23,6 +23,12 @@
 extern "C" {
 #endif
 
+/* This whole API has been deprecated and moved to libxdp that can be found at
+ * https://github.com/xdp-project/xdp-tools. The APIs are exactly the same so
+ * it should just be linking with libxdp instead of libbpf for this set of
+ * functionality. If not, please submit a bug report on the aforementioned page.
+ */
+
 /* Load-Acquire Store-Release barriers used by the XDP socket
  * library. The following macros should *NOT* be considered part of
  * the xsk.h API, and is subject to change anytime.
@@ -245,8 +251,10 @@ static inline __u64 xsk_umem__add_offset_to_addr(__u64 addr)
 	return xsk_umem__extract_addr(addr) + xsk_umem__extract_offset(addr);
 }
 
-LIBBPF_API int xsk_umem__fd(const struct xsk_umem *umem);
-LIBBPF_API int xsk_socket__fd(const struct xsk_socket *xsk);
+LIBBPF_API LIBBPF_DEPRECATED_SINCE(0, 7, "AF_XDP support deprecated and moved to libdxp")
+int xsk_umem__fd(const struct xsk_umem *umem);
+LIBBPF_API LIBBPF_DEPRECATED_SINCE(0, 7, "AF_XDP support deprecated and moved to libdxp")
+int xsk_socket__fd(const struct xsk_socket *xsk);
 
 #define XSK_RING_CONS__DEFAULT_NUM_DESCS      2048
 #define XSK_RING_PROD__DEFAULT_NUM_DESCS      2048
@@ -263,10 +271,10 @@ struct xsk_umem_config {
 	__u32 flags;
 };
 
-LIBBPF_API int xsk_setup_xdp_prog(int ifindex,
-				  int *xsks_map_fd);
-LIBBPF_API int xsk_socket__update_xskmap(struct xsk_socket *xsk,
-					 int xsks_map_fd);
+LIBBPF_API LIBBPF_DEPRECATED_SINCE(0, 7, "AF_XDP support deprecated and moved to libdxp")
+int xsk_setup_xdp_prog(int ifindex, int *xsks_map_fd);
+LIBBPF_API LIBBPF_DEPRECATED_SINCE(0, 7, "AF_XDP support deprecated and moved to libdxp")
+int xsk_socket__update_xskmap(struct xsk_socket *xsk, int xsks_map_fd);
 
 /* Flags for the libbpf_flags field. */
 #define XSK_LIBBPF_FLAGS__INHIBIT_PROG_LOAD (1 << 0)
@@ -280,40 +288,46 @@ struct xsk_socket_config {
 };
 
 /* Set config to NULL to get the default configuration. */
-LIBBPF_API int xsk_umem__create(struct xsk_umem **umem,
-				void *umem_area, __u64 size,
-				struct xsk_ring_prod *fill,
-				struct xsk_ring_cons *comp,
-				const struct xsk_umem_config *config);
-LIBBPF_API int xsk_umem__create_v0_0_2(struct xsk_umem **umem,
-				       void *umem_area, __u64 size,
-				       struct xsk_ring_prod *fill,
-				       struct xsk_ring_cons *comp,
-				       const struct xsk_umem_config *config);
-LIBBPF_API int xsk_umem__create_v0_0_4(struct xsk_umem **umem,
-				       void *umem_area, __u64 size,
-				       struct xsk_ring_prod *fill,
-				       struct xsk_ring_cons *comp,
-				       const struct xsk_umem_config *config);
-LIBBPF_API int xsk_socket__create(struct xsk_socket **xsk,
-				  const char *ifname, __u32 queue_id,
-				  struct xsk_umem *umem,
-				  struct xsk_ring_cons *rx,
-				  struct xsk_ring_prod *tx,
-				  const struct xsk_socket_config *config);
-LIBBPF_API int
-xsk_socket__create_shared(struct xsk_socket **xsk_ptr,
-			  const char *ifname,
-			  __u32 queue_id, struct xsk_umem *umem,
-			  struct xsk_ring_cons *rx,
-			  struct xsk_ring_prod *tx,
-			  struct xsk_ring_prod *fill,
-			  struct xsk_ring_cons *comp,
-			  const struct xsk_socket_config *config);
+LIBBPF_API LIBBPF_DEPRECATED_SINCE(0, 7, "AF_XDP support deprecated and moved to libdxp")
+int xsk_umem__create(struct xsk_umem **umem,
+		     void *umem_area, __u64 size,
+		     struct xsk_ring_prod *fill,
+		     struct xsk_ring_cons *comp,
+		     const struct xsk_umem_config *config);
+LIBBPF_API LIBBPF_DEPRECATED_SINCE(0, 7, "AF_XDP support deprecated and moved to libdxp")
+int xsk_umem__create_v0_0_2(struct xsk_umem **umem,
+			    void *umem_area, __u64 size,
+			    struct xsk_ring_prod *fill,
+			    struct xsk_ring_cons *comp,
+			    const struct xsk_umem_config *config);
+LIBBPF_API LIBBPF_DEPRECATED_SINCE(0, 7, "AF_XDP support deprecated and moved to libdxp")
+int xsk_umem__create_v0_0_4(struct xsk_umem **umem,
+			    void *umem_area, __u64 size,
+			    struct xsk_ring_prod *fill,
+			    struct xsk_ring_cons *comp,
+			    const struct xsk_umem_config *config);
+LIBBPF_API LIBBPF_DEPRECATED_SINCE(0, 7, "AF_XDP support deprecated and moved to libdxp")
+int xsk_socket__create(struct xsk_socket **xsk,
+		       const char *ifname, __u32 queue_id,
+		       struct xsk_umem *umem,
+		       struct xsk_ring_cons *rx,
+		       struct xsk_ring_prod *tx,
+		       const struct xsk_socket_config *config);
+LIBBPF_API LIBBPF_DEPRECATED_SINCE(0, 7, "AF_XDP support deprecated and moved to libdxp")
+int xsk_socket__create_shared(struct xsk_socket **xsk_ptr,
+			      const char *ifname,
+			      __u32 queue_id, struct xsk_umem *umem,
+			      struct xsk_ring_cons *rx,
+			      struct xsk_ring_prod *tx,
+			      struct xsk_ring_prod *fill,
+			      struct xsk_ring_cons *comp,
+			      const struct xsk_socket_config *config);
 
 /* Returns 0 for success and -EBUSY if the umem is still in use. */
-LIBBPF_API int xsk_umem__delete(struct xsk_umem *umem);
-LIBBPF_API void xsk_socket__delete(struct xsk_socket *xsk);
+LIBBPF_API LIBBPF_DEPRECATED_SINCE(0, 7, "AF_XDP support deprecated and moved to libdxp")
+int xsk_umem__delete(struct xsk_umem *umem);
+LIBBPF_API LIBBPF_DEPRECATED_SINCE(0, 7, "AF_XDP support deprecated and moved to libdxp")
+void xsk_socket__delete(struct xsk_socket *xsk);
 
 #ifdef __cplusplus
 } /* extern "C" */

base-commit: 252c765bd764a246a8bd516fabf6d6123df4a24f
-- 
2.29.0

