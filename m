Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 228B53F71E3
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 11:38:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239769AbhHYJiy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 05:38:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239760AbhHYJir (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Aug 2021 05:38:47 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDB0DC061757;
        Wed, 25 Aug 2021 02:38:01 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id i3so3747105wmq.3;
        Wed, 25 Aug 2021 02:38:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kgPj7G38SyrgEwWt/WKASQsH5BeWP3MgfM+9IFhFdKc=;
        b=LemYS2h1v1Gu3pghc4oyHtwh7qh7yKTV3bYJl68UYt9+eJUT1ICnUJh9LRNOjBGvlq
         zHdwI00HD56Bd98ynBbXbmXE3fNGw7fpnUCU7SshB+WJZu2A639WV6p6wlt+Jvq1jamw
         YlC/35PvbiBkvQum5Qxc6USs/3JTnT3PpI5dHu+5pUHO9Uk8IZAi9CUy4piOAiRgyVP5
         ChywfgTOTmLcfeWgiz3wV+e+/eP7gw4sBsRk3lxym33ikmzpnvOzTjRImvGUHSgMmJp3
         fgf1JUjX4jCrSCc0qO/PLzahbFyd4fbzNAzqQNsQ6v0gVbCvTpyshLs51XqL+wpCFqi4
         TqcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kgPj7G38SyrgEwWt/WKASQsH5BeWP3MgfM+9IFhFdKc=;
        b=Cipq6RLAZM72mfkgAhoK5NjJPacR5ULCUnJ2wwq7scxWnpacmT+Z2I1vPpWZNDbvJf
         5ook1wEulHkk3PaWF0LkTDk7yFOvq1MUXtFgYcgno6eMG/9pk1FL9OMPuende9i6LHMS
         gyrd4E6yYDwrmgj8e+6l+p5Lqo4f7kUPZRajQ5YLGXCStctclDpHDQijxLhpwiA5G9GJ
         9Ib96Spu5lP13nYjnTvFiI4X5sK/4iKF7V0RIOk6E5+T8JQZ9a7I0Hs0a2zwxtkjU+fo
         nJmP6Dml3jCuNISvRz0lSdIS823a427u4X0DFI4ES+SHkCe0SWDGY21QBo9oFYdJo2rG
         3HDQ==
X-Gm-Message-State: AOAM531QwIAJwjcwaXtD9b53tA+fVDZY0Ke1AD+L+m8zEJ9BngmKRKNk
        ukOfMHCpE/B9msahpCbuwBg=
X-Google-Smtp-Source: ABdhPJzwJuNeCeOPwpLiXu2rPl2uR5NsNiQ6SyUuziUNNdJ26JRT/hU/qeDW04Vz7OuKvomqxFJY6A==
X-Received: by 2002:a05:600c:2058:: with SMTP id p24mr5180185wmg.108.1629884280502;
        Wed, 25 Aug 2021 02:38:00 -0700 (PDT)
Received: from localhost.localdomain (h-46-59-47-246.A165.priv.bahnhof.se. [46.59.47.246])
        by smtp.gmail.com with ESMTPSA id k18sm4767910wmi.25.2021.08.25.02.37.59
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 25 Aug 2021 02:38:00 -0700 (PDT)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com
Cc:     jonathan.lemon@gmail.com, ciara.loftus@intel.com,
        bpf@vger.kernel.org, yhs@fb.com, andrii@kernel.org
Subject: [PATCH bpf-next v3 06/16] selftests: xsk: remove end-of-test packet
Date:   Wed, 25 Aug 2021 11:37:12 +0200
Message-Id: <20210825093722.10219-7-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.29.0
In-Reply-To: <20210825093722.10219-1-magnus.karlsson@gmail.com>
References: <20210825093722.10219-1-magnus.karlsson@gmail.com>
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
index b7d193a96083..b0fee71355bf 100644
--- a/tools/testing/selftests/bpf/xdpxceiver.c
+++ b/tools/testing/selftests/bpf/xdpxceiver.c
@@ -600,7 +600,7 @@ static void worker_pkt_dump(void)
 	void *ptr;
 
 	fprintf(stdout, "---------------------------------------\n");
-	for (int iter = 0; iter < num_frames - 1; iter++) {
+	for (int iter = 0; iter < num_frames; iter++) {
 		ptr = pkt_buf[iter]->payload;
 		ethhdr = ptr;
 		iphdr = ptr + sizeof(*ethhdr);
@@ -627,11 +627,6 @@ static void worker_pkt_dump(void)
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
@@ -694,28 +689,24 @@ static void worker_pkt_validate(void)
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
@@ -800,11 +791,7 @@ static void *worker_testapp_validate_tx(void *arg)
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
@@ -812,8 +799,7 @@ static void *worker_testapp_validate_tx(void *arg)
 		gen_eth_frame(ifobject->umem, i * XSK_UMEM__DEFAULT_FRAME_SIZE);
 	}
 
-	print_verbose("Sending %d packets on interface %s\n",
-		      (opt_pkt_count - 1), ifobject->ifname);
+	print_verbose("Sending %d packets on interface %s\n", opt_pkt_count, ifobject->ifname);
 	tx_only_all(ifobject);
 
 	testapp_cleanup_xsk_res(ifobject);
@@ -888,7 +874,7 @@ static void testapp_validate(void)
 
 	if (debug_pkt_dump && test_type != TEST_TYPE_STATS) {
 		worker_pkt_dump();
-		for (int iter = 0; iter < num_frames - 1; iter++) {
+		for (int iter = 0; iter < num_frames; iter++) {
 			free(pkt_buf[iter]->payload);
 			free(pkt_buf[iter]);
 		}
@@ -905,7 +891,6 @@ static void testapp_teardown(void)
 
 	for (i = 0; i < MAX_TEARDOWN_ITER; i++) {
 		pkt_counter = 0;
-		prev_pkt = -1;
 		sigvar = 0;
 		print_verbose("Creating socket\n");
 		testapp_validate();
@@ -933,7 +918,6 @@ static void testapp_bidi(void)
 {
 	for (int i = 0; i < MAX_BIDI_ITER; i++) {
 		pkt_counter = 0;
-		prev_pkt = -1;
 		sigvar = 0;
 		print_verbose("Creating socket\n");
 		testapp_validate();
@@ -967,7 +951,6 @@ static void testapp_bpf_res(void)
 
 	for (i = 0; i < MAX_BPF_ITER; i++) {
 		pkt_counter = 0;
-		prev_pkt = -1;
 		sigvar = 0;
 		print_verbose("Creating socket\n");
 		testapp_validate();
@@ -1043,7 +1026,6 @@ static void run_pkt_test(int mode, int type)
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

