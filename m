Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 675EC4023FF
	for <lists+netdev@lfdr.de>; Tue,  7 Sep 2021 09:21:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239192AbhIGHVL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Sep 2021 03:21:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238850AbhIGHVD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Sep 2021 03:21:03 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D3C4C061575;
        Tue,  7 Sep 2021 00:19:57 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id q26so11982051wrc.7;
        Tue, 07 Sep 2021 00:19:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=VYemDfoFJkbmNEC9H7yRs+ZUmABQpgI96O+Pn7J+DyY=;
        b=UYRcM4jC9MGrjIAwTiTxWp/eTnMsTrh1wHN7nn26zSJmH1mXoVNqgZoqbmoy4fkJPA
         XlcLXjdz3iB29dZ5k7lVg/+kzNt/Fq+CjeTzqP1alGXpyT9m1wxuDaBYzmvNhgIak3aF
         OLEQQ06dtuomfEjHrr0ugkD2Cp5lfy3UmS0Xdv1vY+duaM0+iXor+iDqmOQHxtUZTBI5
         F4dFfPb1uelFwOd50SmauWlQ+E0DxonsIVoii/llOt9nXDSq7YHwlwx/wq9FE2dnw1z6
         FmwySNb7ACRPY5jdnCbvswCNVsVbX4sQhUnAG7lvyeEl3TdLRdSm4Ul6yfUVkbgt1KcG
         Z7Tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VYemDfoFJkbmNEC9H7yRs+ZUmABQpgI96O+Pn7J+DyY=;
        b=YXGN+dp9fz15GlvDgrMrsDcnage67O6pUz++3LQB+feeNfw8BPmLwe5QXhcqqDk4AU
         AWdykihuhkVlaAaHP55KkQb7k41yeF8ygZqmwPkGaL0a9DS+tcEvOfh1sXW7mBn0nY5U
         hxcbZPpTGFiiDumW5/R7y5DfsePqLvPR7fA3GgVXw4Z97cmP7V591slb5SOmetcKFX6+
         g9PLa8fikRgJOTVLfuFNeieWojUZbrknp8H41zXYdXGusCZ1lkshF6WOR8THkQS4tnIK
         2n0ytwzZKBsycUjn9dtBGqul5ZLFkEl2hKpZWVJqZeuen5L2w9htqUWUo2DZLIdtpMll
         bPqg==
X-Gm-Message-State: AOAM5334H7zXD7h7m1qd1j672EyxNFIrqgDJXyqlj3hedSS2dLj0K0Gk
        hrvAogHtl1XyIu6gfeJzokhcEGKC6XkBk4ZkJCE=
X-Google-Smtp-Source: ABdhPJxGfmW7sgngb/fn61PhykX/aL1AeFXBvQ25GQ0YbDrhAzdBpIHdPsp3t1g5T2liBAHxMyAEyA==
X-Received: by 2002:adf:c449:: with SMTP id a9mr17242970wrg.256.1630999195500;
        Tue, 07 Sep 2021 00:19:55 -0700 (PDT)
Received: from localhost.localdomain (h-46-59-47-246.A165.priv.bahnhof.se. [46.59.47.246])
        by smtp.gmail.com with ESMTPSA id k16sm722941wrd.47.2021.09.07.00.19.54
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 07 Sep 2021 00:19:55 -0700 (PDT)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com
Cc:     jonathan.lemon@gmail.com, ciara.loftus@intel.com,
        bpf@vger.kernel.org, yhs@fb.com, andrii@kernel.org
Subject: [PATCH bpf-next v2 04/20] selftests: xsk: move num_frames and frame_headroom to xsk_umem_info
Date:   Tue,  7 Sep 2021 09:19:12 +0200
Message-Id: <20210907071928.9750-5-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.29.0
In-Reply-To: <20210907071928.9750-1-magnus.karlsson@gmail.com>
References: <20210907071928.9750-1-magnus.karlsson@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Magnus Karlsson <magnus.karlsson@intel.com>

Move the global variables num_frames and frame_headroom to struct
xsk_umem_info. They describe properties of the umem so no reason for
them to be global.

Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 tools/testing/selftests/bpf/xdpxceiver.c | 20 ++++++++++----------
 tools/testing/selftests/bpf/xdpxceiver.h |  4 ++--
 2 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/tools/testing/selftests/bpf/xdpxceiver.c b/tools/testing/selftests/bpf/xdpxceiver.c
index a6bcc7453860..56ee03fda2b3 100644
--- a/tools/testing/selftests/bpf/xdpxceiver.c
+++ b/tools/testing/selftests/bpf/xdpxceiver.c
@@ -241,7 +241,7 @@ static int xsk_configure_umem(struct xsk_umem_info *umem, void *buffer, u64 size
 		.fill_size = XSK_RING_PROD__DEFAULT_NUM_DESCS,
 		.comp_size = XSK_RING_CONS__DEFAULT_NUM_DESCS,
 		.frame_size = XSK_UMEM__DEFAULT_FRAME_SIZE,
-		.frame_headroom = frame_headroom,
+		.frame_headroom = umem->frame_headroom,
 		.flags = XSK_UMEM__DEFAULT_FLAGS
 	};
 	int ret;
@@ -406,6 +406,7 @@ static void __test_spec_init(struct test_spec *test, struct ifobject *ifobj_tx,
 		for (j = 0; j < MAX_SOCKETS; j++) {
 			memset(&ifobj->umem_arr[j], 0, sizeof(ifobj->umem_arr[j]));
 			memset(&ifobj->xsk_arr[j], 0, sizeof(ifobj->xsk_arr[j]));
+			ifobj->umem_arr[j].num_frames = DEFAULT_PKT_CNT / 4;
 		}
 	}
 
@@ -433,7 +434,7 @@ static struct pkt *pkt_stream_get_pkt(struct pkt_stream *pkt_stream, u32 pkt_nb)
 	return &pkt_stream->pkts[pkt_nb];
 }
 
-static struct pkt_stream *pkt_stream_generate(u32 nb_pkts, u32 pkt_len)
+static struct pkt_stream *pkt_stream_generate(struct xsk_umem_info *umem, u32 nb_pkts, u32 pkt_len)
 {
 	struct pkt_stream *pkt_stream;
 	u32 i;
@@ -448,7 +449,7 @@ static struct pkt_stream *pkt_stream_generate(u32 nb_pkts, u32 pkt_len)
 
 	pkt_stream->nb_pkts = nb_pkts;
 	for (i = 0; i < nb_pkts; i++) {
-		pkt_stream->pkts[i].addr = (i % num_frames) * XSK_UMEM__DEFAULT_FRAME_SIZE;
+		pkt_stream->pkts[i].addr = (i % umem->num_frames) * XSK_UMEM__DEFAULT_FRAME_SIZE;
 		pkt_stream->pkts[i].len = pkt_len;
 		pkt_stream->pkts[i].payload = i;
 	}
@@ -766,7 +767,7 @@ static void tx_stats_validate(struct ifobject *ifobject)
 
 static void thread_common_ops(struct ifobject *ifobject, void *bufs)
 {
-	u64 umem_sz = num_frames * XSK_UMEM__DEFAULT_FRAME_SIZE;
+	u64 umem_sz = ifobject->umem->num_frames * XSK_UMEM__DEFAULT_FRAME_SIZE;
 	int mmap_flags = MAP_PRIVATE | MAP_ANONYMOUS | MAP_NORESERVE;
 	size_t mmap_sz = umem_sz;
 	int ctr = 0, ret;
@@ -885,9 +886,10 @@ static void testapp_validate_traffic(struct test_spec *test)
 		exit_with_error(errno);
 
 	if (stat_test_type == STAT_TEST_TX_INVALID)
-		pkt_stream = pkt_stream_generate(DEFAULT_PKT_CNT, XSK_UMEM__INVALID_FRAME_SIZE);
+		pkt_stream = pkt_stream_generate(test->ifobj_tx->umem, DEFAULT_PKT_CNT,
+						 XSK_UMEM__INVALID_FRAME_SIZE);
 	else
-		pkt_stream = pkt_stream_generate(DEFAULT_PKT_CNT, PKT_SIZE);
+		pkt_stream = pkt_stream_generate(test->ifobj_tx->umem, DEFAULT_PKT_CNT, PKT_SIZE);
 	ifobj_tx->pkt_stream = pkt_stream;
 	ifobj_rx->pkt_stream = pkt_stream;
 
@@ -988,12 +990,11 @@ static void testapp_stats(struct test_spec *test)
 
 		/* reset defaults */
 		rxqsize = XSK_RING_CONS__DEFAULT_NUM_DESCS;
-		frame_headroom = XSK_UMEM__DEFAULT_FRAME_HEADROOM;
 
 		switch (stat_test_type) {
 		case STAT_TEST_RX_DROPPED:
-			frame_headroom = XSK_UMEM__DEFAULT_FRAME_SIZE -
-						XDP_PACKET_HEADROOM - 1;
+			test->ifobj_rx->umem->frame_headroom = XSK_UMEM__DEFAULT_FRAME_SIZE -
+				XDP_PACKET_HEADROOM - 1;
 			break;
 		case STAT_TEST_RX_FULL:
 			rxqsize = RX_FULL_RXQSIZE;
@@ -1040,7 +1041,6 @@ static void run_pkt_test(struct test_spec *test, int mode, int type)
 	second_step = 0;
 	stat_test_type = -1;
 	rxqsize = XSK_RING_CONS__DEFAULT_NUM_DESCS;
-	frame_headroom = XSK_UMEM__DEFAULT_FRAME_HEADROOM;
 
 	configured_mode = mode;
 
diff --git a/tools/testing/selftests/bpf/xdpxceiver.h b/tools/testing/selftests/bpf/xdpxceiver.h
index e279aa893438..0d93a9e6c4f3 100644
--- a/tools/testing/selftests/bpf/xdpxceiver.h
+++ b/tools/testing/selftests/bpf/xdpxceiver.h
@@ -71,7 +71,6 @@ enum stat_test_type {
 
 static int configured_mode;
 static bool opt_pkt_dump;
-static u32 num_frames = DEFAULT_PKT_CNT / 4;
 static bool second_step;
 static int test_type;
 
@@ -81,12 +80,13 @@ static u32 xdp_flags = XDP_FLAGS_UPDATE_IF_NOEXIST;
 static u32 xdp_bind_flags = XDP_USE_NEED_WAKEUP | XDP_COPY;
 static int stat_test_type;
 static u32 rxqsize;
-static u32 frame_headroom;
 
 struct xsk_umem_info {
 	struct xsk_ring_prod fq;
 	struct xsk_ring_cons cq;
 	struct xsk_umem *umem;
+	u32 num_frames;
+	u32 frame_headroom;
 	void *buffer;
 };
 
-- 
2.29.0

