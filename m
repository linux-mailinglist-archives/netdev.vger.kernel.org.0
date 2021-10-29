Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E02A243F955
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 11:01:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231343AbhJ2JEE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Oct 2021 05:04:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229844AbhJ2JEE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Oct 2021 05:04:04 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3B85C061570;
        Fri, 29 Oct 2021 02:01:35 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id s13so7944903wrb.3;
        Fri, 29 Oct 2021 02:01:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=WA/6Xqdu/lY3k5mObuDlvl/BcJnZz1vPm2VJ5v5puSA=;
        b=EW4Y6dEIpJAICfNYqhmSZWO2ku7ISrDMw5OQnbH1p2e0DVkhoa8NMiT5c+pa347AuH
         8YmuTxilu4KsmbsadyK9wkPJe0N9LFMD4yN1QPDBifk8cqy1IbFW+4WqInheK3zx09a3
         b827VXZU8+Ln+R0hEhHnyUGjI/UyJX/RmoGfDieb6n6CQNxDqU3LWhca0cXwDnQiQ28Q
         Rt7ROwASYn8Y0TggSdE5E9/LPNcKoO0F7uYNnApl863L5y2Un/i/p2hKlQgltbKq+WgP
         CE++MCuqK1MneqyvexFtVpeOS1PtCl5f6dBSc57kDXQXowIXAkMpc86urL0sUiTiRzcz
         jkUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=WA/6Xqdu/lY3k5mObuDlvl/BcJnZz1vPm2VJ5v5puSA=;
        b=ukm3XuTdF1VkK9Ki1VsMPD3ti1HK8V6ZY47qto8HW4FDTpUIsCVgnY1Ra6cXJx/t/L
         tsRHkvgJq5+XuWYjggOFha7o3SysjbvYMr3+OoS9puquLWcaEFtaKGemvbIKfynww01x
         NmfV9tnof+xKn6gPfSyVx26CzbScjA7dJd2eKcdasshOQe/T/IJojeiVDVPG6ePcSTiY
         D3uxf87FtUkRKfJTgI+joUAmBtaUoyzejcsV2awyu0yu1jS3Snd4uK+0pmblP1HYpMVs
         3p9uC7+qoJHhavizqJftXDlVVH0ovtwbG63vMMYRWXj+f3VMIUrSxWEKwJhSwZoT6KOG
         TgjA==
X-Gm-Message-State: AOAM531E2XK+nz50jus8MsIlrDlbA9tYLV2IeRhx1BoYS1WKe3QK7Xxr
        JxNDPmQid6EUIfyzgqjkntU=
X-Google-Smtp-Source: ABdhPJy/6MeXiLkIj5cy3BgJk0e6X7/iQBWkDdIdng9uo6aBa83y/FtaH3Eurdar6nmvch4uhaqPjw==
X-Received: by 2002:a05:6000:1107:: with SMTP id z7mr12606302wrw.370.1635498094313;
        Fri, 29 Oct 2021 02:01:34 -0700 (PDT)
Received: from localhost.localdomain ([188.149.128.194])
        by smtp.gmail.com with ESMTPSA id p12sm5699421wrr.67.2021.10.29.02.01.32
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 29 Oct 2021 02:01:33 -0700 (PDT)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com, yhs@fb.com, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org
Cc:     jonathan.lemon@gmail.com, bpf@vger.kernel.org
Subject: [PATCH bpf-next v2] libbpf: deprecate AF_XDP support
Date:   Fri, 29 Oct 2021 11:01:11 +0200
Message-Id: <20211029090111.4733-1-magnus.karlsson@gmail.com>
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

v1 -> v2: Corrected spelling error

Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 tools/lib/bpf/xsk.h | 90 ++++++++++++++++++++++++++-------------------
 1 file changed, 52 insertions(+), 38 deletions(-)

diff --git a/tools/lib/bpf/xsk.h b/tools/lib/bpf/xsk.h
index 01c12dca9c10..64e9c57fd792 100644
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
+LIBBPF_API LIBBPF_DEPRECATED_SINCE(0, 7, "AF_XDP support deprecated and moved to libxdp")
+int xsk_umem__fd(const struct xsk_umem *umem);
+LIBBPF_API LIBBPF_DEPRECATED_SINCE(0, 7, "AF_XDP support deprecated and moved to libxdp")
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
+LIBBPF_API LIBBPF_DEPRECATED_SINCE(0, 7, "AF_XDP support deprecated and moved to libxdp")
+int xsk_setup_xdp_prog(int ifindex, int *xsks_map_fd);
+LIBBPF_API LIBBPF_DEPRECATED_SINCE(0, 7, "AF_XDP support deprecated and moved to libxdp")
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
+LIBBPF_API LIBBPF_DEPRECATED_SINCE(0, 7, "AF_XDP support deprecated and moved to libxdp")
+int xsk_umem__create(struct xsk_umem **umem,
+		     void *umem_area, __u64 size,
+		     struct xsk_ring_prod *fill,
+		     struct xsk_ring_cons *comp,
+		     const struct xsk_umem_config *config);
+LIBBPF_API LIBBPF_DEPRECATED_SINCE(0, 7, "AF_XDP support deprecated and moved to libxdp")
+int xsk_umem__create_v0_0_2(struct xsk_umem **umem,
+			    void *umem_area, __u64 size,
+			    struct xsk_ring_prod *fill,
+			    struct xsk_ring_cons *comp,
+			    const struct xsk_umem_config *config);
+LIBBPF_API LIBBPF_DEPRECATED_SINCE(0, 7, "AF_XDP support deprecated and moved to libxdp")
+int xsk_umem__create_v0_0_4(struct xsk_umem **umem,
+			    void *umem_area, __u64 size,
+			    struct xsk_ring_prod *fill,
+			    struct xsk_ring_cons *comp,
+			    const struct xsk_umem_config *config);
+LIBBPF_API LIBBPF_DEPRECATED_SINCE(0, 7, "AF_XDP support deprecated and moved to libxdp")
+int xsk_socket__create(struct xsk_socket **xsk,
+		       const char *ifname, __u32 queue_id,
+		       struct xsk_umem *umem,
+		       struct xsk_ring_cons *rx,
+		       struct xsk_ring_prod *tx,
+		       const struct xsk_socket_config *config);
+LIBBPF_API LIBBPF_DEPRECATED_SINCE(0, 7, "AF_XDP support deprecated and moved to libxdp")
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
+LIBBPF_API LIBBPF_DEPRECATED_SINCE(0, 7, "AF_XDP support deprecated and moved to libxdp")
+int xsk_umem__delete(struct xsk_umem *umem);
+LIBBPF_API LIBBPF_DEPRECATED_SINCE(0, 7, "AF_XDP support deprecated and moved to libxdp")
+void xsk_socket__delete(struct xsk_socket *xsk);
 
 #ifdef __cplusplus
 } /* extern "C" */

base-commit: b9989b59123b3ced5387a5360c05a7bb2fb92d94
-- 
2.29.0

