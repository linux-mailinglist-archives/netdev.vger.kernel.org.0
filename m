Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD0D13FD7FD
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 12:49:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238280AbhIAKtA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Sep 2021 06:49:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235980AbhIAKs6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Sep 2021 06:48:58 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93738C061575;
        Wed,  1 Sep 2021 03:48:01 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id i3so1525732wmq.3;
        Wed, 01 Sep 2021 03:48:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=P+ZLmHK8o50h7H6ArsMpxYYv/GLFJ6igApJFpx/tb64=;
        b=ggfr1e8usHkjR+62Bm3lYwucrC/klMDW4+K4XvGDb5pc5PzkfvAL3W+ezD+rqVVo7V
         E6n49l7qGhx8aDdLZtaON88FR8b9HotOBZu1og+YzudtCxoN9z4Cvu/On4NEMwNRGCvx
         pwpc3xfaC9mfqYnJAtg7LRsU2vqa52iV/xR/AlHHT8oSRYqX+XC7bYb6zQ8thi0qiLyX
         /+ofRV+1sL7x3AQiW44olGwCRqhm0H+pp+WAclViXAaZ27b8HPe0HRyyk/mwSV4LaCk6
         XN+1BsEoAgB0zZTRxVA0ooJU1/67qyc9GcqvO1VU3BmSuIWyBtu8m9a9or/Rv8hwZYLf
         EtZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=P+ZLmHK8o50h7H6ArsMpxYYv/GLFJ6igApJFpx/tb64=;
        b=jxS0HHqNQ4IpCgpgzyNKVlEtAIBc/S0poXNwJEDMes1b9H2+8g1Ic0Y/DmfTk3SoRy
         Dmjy22lBXdlOTi04nP59h5gODc3jvZTbxupZtT17DsaelD8kgT1iQDFl1jhs4VNoUTJ+
         ja+vpQbQMNHG5pza9QJQnaNoBLqOI3Xha2EM5t2GITTC7px9+LFyYfxf6++LlLtfiZid
         KYUKHWczs85ekBNUFowqs515T+OhS37VuP3qhdN5fi85B8EMlkuA+ChIeI36HYn3qq6B
         c12+FEAuzeuHGy00w8RmmmlvIY4aZ3L2mCxNWHA5J8AMtm0kXUieDOdsrj6FZUHSUYIU
         Rx/Q==
X-Gm-Message-State: AOAM530FOVBy7B7a82j5jE1P5XplcFcOMAlJLmnCpDjPaWGP5N2Ttr3P
        /Rxr+ZZXGOTfqosQpnU8ZPc=
X-Google-Smtp-Source: ABdhPJwjvmIh7uzYYD5KA5JD+GBcZttOdqaF71MnS4FW3Vg9lKDEQebNRhc/a2Jbz+IbohhUp0JGXQ==
X-Received: by 2002:a1c:4682:: with SMTP id t124mr9164350wma.168.1630493280208;
        Wed, 01 Sep 2021 03:48:00 -0700 (PDT)
Received: from localhost.localdomain (h-46-59-47-246.A165.priv.bahnhof.se. [46.59.47.246])
        by smtp.gmail.com with ESMTPSA id r12sm21530843wrv.96.2021.09.01.03.47.58
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 01 Sep 2021 03:47:59 -0700 (PDT)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com
Cc:     jonathan.lemon@gmail.com, ciara.loftus@intel.com,
        bpf@vger.kernel.org, yhs@fb.com, andrii@kernel.org
Subject: [PATCH bpf-next 01/20] selftests: xsk: simplify xsk and umem arrays
Date:   Wed,  1 Sep 2021 12:47:13 +0200
Message-Id: <20210901104732.10956-2-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.29.0
In-Reply-To: <20210901104732.10956-1-magnus.karlsson@gmail.com>
References: <20210901104732.10956-1-magnus.karlsson@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Magnus Karlsson <magnus.karlsson@intel.com>

Simplify the xsk_info and umem_info allocation by allocating them
upfront in an array, instead of allocating an array of pointers to
future creations of these. Allocating them upfront also has the
advantage that configuration information can be stored in these
structures instead of relying on global variables. With the previous
structure, xsk_info and umem_info were created too late to be able to
store most configuration information. This will be used to eliminate
most global variables in later patches in this series.

Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 tools/testing/selftests/bpf/xdpxceiver.c | 78 ++++++++++--------------
 tools/testing/selftests/bpf/xdpxceiver.h |  5 +-
 2 files changed, 34 insertions(+), 49 deletions(-)

diff --git a/tools/testing/selftests/bpf/xdpxceiver.c b/tools/testing/selftests/bpf/xdpxceiver.c
index f53ce2683f8d..9639d8da516d 100644
--- a/tools/testing/selftests/bpf/xdpxceiver.c
+++ b/tools/testing/selftests/bpf/xdpxceiver.c
@@ -235,7 +235,7 @@ static void gen_udp_csum(struct udphdr *udp_hdr, struct iphdr *ip_hdr)
 	    udp_csum(ip_hdr->saddr, ip_hdr->daddr, UDP_PKT_SIZE, IPPROTO_UDP, (u16 *)udp_hdr);
 }
 
-static void xsk_configure_umem(struct ifobject *data, void *buffer, u64 size, int idx)
+static int xsk_configure_umem(struct xsk_umem_info *umem, void *buffer, u64 size, int idx)
 {
 	struct xsk_umem_config cfg = {
 		.fill_size = XSK_RING_PROD__DEFAULT_NUM_DESCS,
@@ -244,21 +244,15 @@ static void xsk_configure_umem(struct ifobject *data, void *buffer, u64 size, in
 		.frame_headroom = frame_headroom,
 		.flags = XSK_UMEM__DEFAULT_FLAGS
 	};
-	struct xsk_umem_info *umem;
 	int ret;
 
-	umem = calloc(1, sizeof(struct xsk_umem_info));
-	if (!umem)
-		exit_with_error(errno);
-
 	ret = xsk_umem__create(&umem->umem, buffer, size,
 			       &umem->fq, &umem->cq, &cfg);
 	if (ret)
-		exit_with_error(-ret);
+		return ret;
 
 	umem->buffer = buffer;
-
-	data->umem_arr[idx] = umem;
+	return 0;
 }
 
 static void xsk_populate_fill_ring(struct xsk_umem_info *umem)
@@ -274,19 +268,14 @@ static void xsk_populate_fill_ring(struct xsk_umem_info *umem)
 	xsk_ring_prod__submit(&umem->fq, XSK_RING_PROD__DEFAULT_NUM_DESCS);
 }
 
-static int xsk_configure_socket(struct ifobject *ifobject, int idx)
+static int xsk_configure_socket(struct xsk_socket_info *xsk, struct xsk_umem_info *umem,
+				struct ifobject *ifobject, u32 qid)
 {
 	struct xsk_socket_config cfg;
-	struct xsk_socket_info *xsk;
 	struct xsk_ring_cons *rxr;
 	struct xsk_ring_prod *txr;
-	int ret;
 
-	xsk = calloc(1, sizeof(struct xsk_socket_info));
-	if (!xsk)
-		exit_with_error(errno);
-
-	xsk->umem = ifobject->umem;
+	xsk->umem = umem;
 	cfg.rx_size = rxqsize;
 	cfg.tx_size = XSK_RING_PROD__DEFAULT_NUM_DESCS;
 	cfg.libbpf_flags = 0;
@@ -301,14 +290,7 @@ static int xsk_configure_socket(struct ifobject *ifobject, int idx)
 		txr = &xsk->tx;
 	}
 
-	ret = xsk_socket__create(&xsk->xsk, ifobject->ifname, idx,
-				 ifobject->umem->umem, rxr, txr, &cfg);
-	if (ret)
-		return 1;
-
-	ifobject->xsk_arr[idx] = xsk;
-
-	return 0;
+	return xsk_socket__create(&xsk->xsk, ifobject->ifname, qid, umem->umem, rxr, txr, &cfg);
 }
 
 static struct option long_options[] = {
@@ -756,8 +738,7 @@ static void thread_common_ops(struct ifobject *ifobject, void *bufs)
 	u64 umem_sz = num_frames * XSK_UMEM__DEFAULT_FRAME_SIZE;
 	int mmap_flags = MAP_PRIVATE | MAP_ANONYMOUS | MAP_NORESERVE;
 	size_t mmap_sz = umem_sz;
-	int ctr = 0;
-	int ret;
+	int ctr = 0, ret;
 
 	ifobject->ns_fd = switch_namespace(ifobject->nsname);
 
@@ -769,31 +750,34 @@ static void thread_common_ops(struct ifobject *ifobject, void *bufs)
 		exit_with_error(errno);
 
 	while (ctr++ < SOCK_RECONF_CTR) {
-		xsk_configure_umem(ifobject, bufs, umem_sz, 0);
-		ifobject->umem = ifobject->umem_arr[0];
-		ret = xsk_configure_socket(ifobject, 0);
+		ret = xsk_configure_umem(&ifobject->umem_arr[0], bufs, umem_sz, 0);
+		if (ret)
+			exit_with_error(-ret);
+
+		ret = xsk_configure_socket(&ifobject->xsk_arr[0], &ifobject->umem_arr[0],
+					   ifobject, 0);
 		if (!ret)
 			break;
 
 		/* Retry Create Socket if it fails as xsk_socket__create() is asynchronous */
-		usleep(USLEEP_MAX);
 		if (ctr >= SOCK_RECONF_CTR)
 			exit_with_error(-ret);
+		usleep(USLEEP_MAX);
 	}
 
-	ifobject->umem = ifobject->umem_arr[0];
-	ifobject->xsk = ifobject->xsk_arr[0];
-
 	if (test_type == TEST_TYPE_BPF_RES) {
-		xsk_configure_umem(ifobject, (u8 *)bufs + umem_sz, umem_sz, 1);
-		ifobject->umem = ifobject->umem_arr[1];
-		ret = xsk_configure_socket(ifobject, 1);
+		ret = xsk_configure_umem(&ifobject->umem_arr[1], (u8 *)bufs + umem_sz, umem_sz, 1);
+		if (ret)
+			exit_with_error(-ret);
+
+		ret = xsk_configure_socket(&ifobject->xsk_arr[1], &ifobject->umem_arr[1],
+					   ifobject, 1);
+		if (ret)
+			exit_with_error(-ret);
 	}
 
-	ifobject->umem = ifobject->umem_arr[0];
-	ifobject->xsk = ifobject->xsk_arr[0];
-	print_verbose("Interface [%s] vector [%s]\n",
-		      ifobject->ifname, ifobject->fv.vector == tx ? "Tx" : "Rx");
+	ifobject->umem = &ifobject->umem_arr[0];
+	ifobject->xsk = &ifobject->xsk_arr[0];
 }
 
 static bool testapp_is_test_two_stepped(void)
@@ -941,10 +925,10 @@ static void swap_xsk_res(void)
 	xsk_umem__delete(ifdict_tx->umem->umem);
 	xsk_socket__delete(ifdict_rx->xsk->xsk);
 	xsk_umem__delete(ifdict_rx->umem->umem);
-	ifdict_tx->umem = ifdict_tx->umem_arr[1];
-	ifdict_tx->xsk = ifdict_tx->xsk_arr[1];
-	ifdict_rx->umem = ifdict_rx->umem_arr[1];
-	ifdict_rx->xsk = ifdict_rx->xsk_arr[1];
+	ifdict_tx->umem = &ifdict_tx->umem_arr[1];
+	ifdict_tx->xsk = &ifdict_tx->xsk_arr[1];
+	ifdict_rx->umem = &ifdict_rx->umem_arr[1];
+	ifdict_rx->xsk = &ifdict_rx->xsk_arr[1];
 }
 
 static void testapp_bpf_res(void)
@@ -1071,11 +1055,11 @@ static struct ifobject *ifobject_create(void)
 	if (!ifobj)
 		return NULL;
 
-	ifobj->xsk_arr = calloc(2, sizeof(struct xsk_socket_info *));
+	ifobj->xsk_arr = calloc(MAX_SOCKETS, sizeof(*ifobj->xsk_arr));
 	if (!ifobj->xsk_arr)
 		goto out_xsk_arr;
 
-	ifobj->umem_arr = calloc(2, sizeof(struct xsk_umem_info *));
+	ifobj->umem_arr = calloc(MAX_SOCKETS, sizeof(*ifobj->umem_arr));
 	if (!ifobj->umem_arr)
 		goto out_umem_arr;
 
diff --git a/tools/testing/selftests/bpf/xdpxceiver.h b/tools/testing/selftests/bpf/xdpxceiver.h
index 7e49b9fbe25e..de80516ac6c2 100644
--- a/tools/testing/selftests/bpf/xdpxceiver.h
+++ b/tools/testing/selftests/bpf/xdpxceiver.h
@@ -21,6 +21,7 @@
 #define MAX_INTERFACE_NAME_CHARS 7
 #define MAX_INTERFACES_NAMESPACE_CHARS 10
 #define MAX_SOCKS 1
+#define MAX_SOCKETS 2
 #define MAX_TEARDOWN_ITER 10
 #define MAX_BIDI_ITER 2
 #define MAX_BPF_ITER 2
@@ -119,9 +120,9 @@ struct ifobject {
 	char ifname[MAX_INTERFACE_NAME_CHARS];
 	char nsname[MAX_INTERFACES_NAMESPACE_CHARS];
 	struct xsk_socket_info *xsk;
-	struct xsk_socket_info **xsk_arr;
-	struct xsk_umem_info **umem_arr;
+	struct xsk_socket_info *xsk_arr;
 	struct xsk_umem_info *umem;
+	struct xsk_umem_info *umem_arr;
 	void *(*func_ptr)(void *arg);
 	struct flow_vector fv;
 	struct pkt_stream *pkt_stream;
-- 
2.29.0

