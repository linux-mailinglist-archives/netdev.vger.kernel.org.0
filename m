Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FBF63D75C6
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 15:18:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236696AbhG0NSa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 09:18:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236627AbhG0NSU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Jul 2021 09:18:20 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2EF0C061757;
        Tue, 27 Jul 2021 06:18:19 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id j2so15142826wrx.9;
        Tue, 27 Jul 2021 06:18:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Wk+4pD6RIN81xKg5WXM+jVKJ2jvOv76Hf6DkK14dZfc=;
        b=fgL3GKWecJrhOcSIvVFwA+MkDnHaAZknPj/1pMTjAZC4/lAD2RYcpsQsFuBWJAxUAJ
         eLqAfNAXLYJiEKpbZNqqVlFdUMtEIGydO7vW4ABczKiEQQLTz04yIH4msgkU7eGPHMBP
         5TTH1mB/vHd/ywkdd6ZQ54oJRxZil+TSjo3V6MEivI8FZoSKhiJM4Gx0pFbBqhZ/6m+y
         mCOTfdFxV5f4PFDo8oI3WGrSx5Ym2lnzW3j7T8XjCPfPQIjNd0Hq+H4B9ayqlIwxjLUP
         2dZKQ9r3gpeATbgNHexuH2i8BV90TZ87mT73E5JhrB3LTqxu3NWfiKaUg9+EVZdfcNF+
         0mtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Wk+4pD6RIN81xKg5WXM+jVKJ2jvOv76Hf6DkK14dZfc=;
        b=IGce/qPZafNwRenDhkRHnrMVpRf+UyWxwuLnutFNdPzYITIMNzDqWYWlST7F3Nf2Fz
         R/Hrp0neSLMDLz4pU7JO4E/gFbDzk4iJcSmywdxebHbS0jBcUHyvqENHsylrOaHryAD5
         8KzsyP+yu4AmAQrfmW/AyZiPFLX7OgObbu5jUG4bepL9aBrekycWtvnXi4LaVthPDQZI
         7PrDwJhkdJkJVswiHCThWxg1iSWRS2z/SdMhXfaU7ZS4kuRUG36UFKqS8b6DnuAebTkC
         5qS73MGynXrkqY1B0f6LWMNP1PUQP9ZZgDqE7oxsApRAnRiavVZ+h79Sf0+snY2awwQS
         9Fdg==
X-Gm-Message-State: AOAM5312RjqqT1GxZi5gRsiE2pfn1wbNbsZ0fqX6xkAfiNJvojtrra7c
        Nkv11X70epJyATzZ6DZ55HPTn7bEkH8sxWWNAgt3Fw==
X-Google-Smtp-Source: ABdhPJyluaQCkxF47Qm328duZ3my2+PsSPBxnjOR934/IizNPG08H07Rcc3bN3xzlNj5WdAz2oqREA==
X-Received: by 2002:adf:d20e:: with SMTP id j14mr13726685wrh.177.1627391898411;
        Tue, 27 Jul 2021 06:18:18 -0700 (PDT)
Received: from localhost.localdomain (h-46-59-47-246.A165.priv.bahnhof.se. [46.59.47.246])
        by smtp.gmail.com with ESMTPSA id u11sm3277553wrr.44.2021.07.27.06.18.16
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 27 Jul 2021 06:18:18 -0700 (PDT)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com
Cc:     jonathan.lemon@gmail.com, ciara.loftus@intel.com,
        joamaki@gmail.com, bpf@vger.kernel.org, yhs@fb.com,
        andrii@kernel.org
Subject: [PATCH bpf-next 07/17] selftests: xsk: remove end-of-test packet
Date:   Tue, 27 Jul 2021 15:17:43 +0200
Message-Id: <20210727131753.10924-8-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.29.0
In-Reply-To: <20210727131753.10924-1-magnus.karlsson@gmail.com>
References: <20210727131753.10924-1-magnus.karlsson@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Magnus Karlsson <magnus.karlsson@intel.com>

Get rid of the end-of-test packet and just count the number of packets
received and quit when the expected number as been
received. Simplifies the code.

Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 tools/testing/selftests/bpf/xdpxceiver.c | 42 +++++++-----------------
 tools/testing/selftests/bpf/xdpxceiver.h |  2 --
 2 files changed, 12 insertions(+), 32 deletions(-)

diff --git a/tools/testing/selftests/bpf/xdpxceiver.c b/tools/testing/selftests/bpf/xdpxceiver.c
index dcde73db7b29..b77ee9bb91e1 100644
--- a/tools/testing/selftests/bpf/xdpxceiver.c
+++ b/tools/testing/selftests/bpf/xdpxceiver.c
@@ -605,7 +605,7 @@ static void worker_pkt_dump(void)
 	void *ptr;
 
 	fprintf(stdout, "---------------------------------------\n");
-	for (int iter = 0; iter < num_frames - 1; iter++) {
+	for (int iter = 0; iter < num_frames; iter++) {
 		ptr = pkt_buf[iter]->payload;
 		ethhdr = ptr;
 		iphdr = ptr + sizeof(*ethhdr);
@@ -632,11 +632,6 @@ static void worker_pkt_dump(void)
 		/*extract L5 frame */
 		payload = *((uint32_t *)(ptr + PKT_HDR_SIZE));
 
-		if (payload == EOT) {
-			print_verbose("End-of-transmission frame received\n");
-			fprintf(stdout, "---------------------------------------\n");
-			break;
-		}
 		fprintf(stdout, "DEBUG>> L5: payload: %d\n", payload);
 		fprintf(stdout, "---------------------------------------\n");
 	}
@@ -699,28 +694,24 @@ static void worker_pkt_validate(void)
 		/*do not increment pktcounter if !(tos=0x9 and ipv4) */
 		if (iphdr->version == IP_PKT_VER && iphdr->tos == IP_PKT_TOS) {
 			payloadseqnum = *((uint32_t *)(pkt_node_rx_q->pkt_frame + PKT_HDR_SIZE));
-			if (debug_pkt_dump && payloadseqnum != EOT) {
+			if (debug_pkt_dump) {
 				pkt_obj = malloc(sizeof(*pkt_obj));
 				pkt_obj->payload = malloc(PKT_SIZE);
 				memcpy(pkt_obj->payload, pkt_node_rx_q->pkt_frame, PKT_SIZE);
 				pkt_buf[payloadseqnum] = pkt_obj;
 			}
 
-			if (payloadseqnum == EOT) {
-				print_verbose("End-of-transmission frame received: PASS\n");
-				sigvar = 1;
-				break;
-			}
-
-			if (prev_pkt + 1 != payloadseqnum) {
+			if (pkt_counter % num_frames != payloadseqnum) {
 				ksft_test_result_fail
-				    ("ERROR: [%s] prev_pkt [%d], payloadseqnum [%d]\n",
-				     __func__, prev_pkt, payloadseqnum);
+				    ("ERROR: [%s] expected counter [%d], payloadseqnum [%d]\n",
+				     __func__, pkt_counter, payloadseqnum);
 				ksft_exit_xfail();
 			}
 
-			prev_pkt = payloadseqnum;
-			pkt_counter++;
+			if (++pkt_counter == opt_pkt_count) {
+				sigvar = 1;
+				break;
+			}
 		} else {
 			ksft_print_msg("Invalid frame received: ");
 			ksft_print_msg("[IP_PKT_VER: %02X], [IP_PKT_TOS: %02X]\n", iphdr->version,
@@ -805,11 +796,7 @@ static void *worker_testapp_validate_tx(void *arg)
 		thread_common_ops(ifobject, bufs);
 
 	for (int i = 0; i < num_frames; i++) {
-		/*send EOT frame */
-		if (i == (num_frames - 1))
-			data.seqnum = -1;
-		else
-			data.seqnum = i;
+		data.seqnum = i;
 		gen_udp_hdr(&data, ifobject, udp_hdr);
 		gen_ip_hdr(ifobject, ip_hdr);
 		gen_udp_csum(udp_hdr, ip_hdr);
@@ -817,8 +804,7 @@ static void *worker_testapp_validate_tx(void *arg)
 		gen_eth_frame(ifobject->umem, i * XSK_UMEM__DEFAULT_FRAME_SIZE);
 	}
 
-	print_verbose("Sending %d packets on interface %s\n",
-		      (opt_pkt_count - 1), ifobject->ifname);
+	print_verbose("Sending %d packets on interface %s\n", opt_pkt_count, ifobject->ifname);
 	tx_only_all(ifobject);
 
 	testapp_cleanup_xsk_res(ifobject);
@@ -893,7 +879,7 @@ static void testapp_validate(void)
 
 	if (debug_pkt_dump && test_type != TEST_TYPE_STATS) {
 		worker_pkt_dump();
-		for (int iter = 0; iter < num_frames - 1; iter++) {
+		for (int iter = 0; iter < num_frames; iter++) {
 			free(pkt_buf[iter]->payload);
 			free(pkt_buf[iter]);
 		}
@@ -910,7 +896,6 @@ static void testapp_teardown(void)
 
 	for (i = 0; i < MAX_TEARDOWN_ITER; i++) {
 		pkt_counter = 0;
-		prev_pkt = -1;
 		sigvar = 0;
 		print_verbose("Creating socket\n");
 		testapp_validate();
@@ -938,7 +923,6 @@ static void testapp_bidi(void)
 {
 	for (int i = 0; i < MAX_BIDI_ITER; i++) {
 		pkt_counter = 0;
-		prev_pkt = -1;
 		sigvar = 0;
 		print_verbose("Creating socket\n");
 		testapp_validate();
@@ -972,7 +956,6 @@ static void testapp_bpf_res(void)
 
 	for (i = 0; i < MAX_BPF_ITER; i++) {
 		pkt_counter = 0;
-		prev_pkt = -1;
 		sigvar = 0;
 		print_verbose("Creating socket\n");
 		testapp_validate();
@@ -1048,7 +1031,6 @@ static void run_pkt_test(int mode, int type)
 	xdp_flags = XDP_FLAGS_UPDATE_IF_NOEXIST;
 	pkt_counter = 0;
 	second_step = 0;
-	prev_pkt = -1;
 	sigvar = 0;
 	stat_test_type = -1;
 	rxqsize = XSK_RING_CONS__DEFAULT_NUM_DESCS;
diff --git a/tools/testing/selftests/bpf/xdpxceiver.h b/tools/testing/selftests/bpf/xdpxceiver.h
index 1c94230c351a..a4371d9e2798 100644
--- a/tools/testing/selftests/bpf/xdpxceiver.h
+++ b/tools/testing/selftests/bpf/xdpxceiver.h
@@ -34,7 +34,6 @@
 #define IP_PKT_TOS 0x9
 #define UDP_PKT_SIZE (IP_PKT_SIZE - sizeof(struct iphdr))
 #define UDP_PKT_DATA_SIZE (UDP_PKT_SIZE - sizeof(struct udphdr))
-#define EOT (-1)
 #define USLEEP_MAX 10000
 #define SOCK_RECONF_CTR 10
 #define BATCH_SIZE 64
@@ -82,7 +81,6 @@ static u32 xdp_flags = XDP_FLAGS_UPDATE_IF_NOEXIST;
 static u32 xdp_bind_flags = XDP_USE_NEED_WAKEUP | XDP_COPY;
 static u8 pkt_data[XSK_UMEM__DEFAULT_FRAME_SIZE];
 static u32 pkt_counter;
-static long prev_pkt = -1;
 static int sigvar;
 static int stat_test_type;
 static u32 rxqsize;
-- 
2.29.0

