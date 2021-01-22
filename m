Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29EB73007CD
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 16:52:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727262AbhAVPuw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 10:50:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729200AbhAVPsN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jan 2021 10:48:13 -0500
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 968FCC061786;
        Fri, 22 Jan 2021 07:47:32 -0800 (PST)
Received: by mail-lf1-x12d.google.com with SMTP id a8so8135613lfi.8;
        Fri, 22 Jan 2021 07:47:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rR70sbxeH3YICr0K6kn+CgDDebNkK3ZMmmvVHIwEsjU=;
        b=YRDW0rWUkEPiymncPKtxde6E4jSRmSXRFUT+KCB/jwIWjcmx4Q+DYhMkZCpNKCs5rB
         oJ7mHxRzgG8Z7Sk6crobEAXqvoudMu7VKNXDqnZbgpIadWtdEFyETOg1tvQkrUGr9whN
         jkKLX7oQihzYrII6nQ13Tva3C153xBHnbeBf8nvNpGuiVY461Kh5zYl7dJm6aSanVCcb
         eTxYWVYhFR3wlCOrSqsRxKrpW5qhQ3CwLRIhItCoIAPKxCqPCbt+mwOLEAWZYZfOH3+H
         dkNZZymrbVLcOQnQAv8WszvWvvIAgEbFjXW+0elYx1K/MpY0t4Kuj1dju+odJsH1VyO1
         xhgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rR70sbxeH3YICr0K6kn+CgDDebNkK3ZMmmvVHIwEsjU=;
        b=nEmJXonqb1ta3pyZ6lhn/pQCiZrfzxvwe3z4xygXBf3FvLk8q6DLvudEDoKE3jCDZT
         FCYN0I/Fmux1l07qA0uqn4GRmq0Bu4qTMTyTooCVI0SEwConoI+0I4KA4wpumjbvMTyw
         x6atMO8arNwpOdob9/s4tmiCa53Vsjb1Kp1XZmqGCcBD6v5XHUlD81xYwmw61I92gobs
         usJfcWMT1zVCh5al3lP63lqzo43v/N58SvltbAmkMcsJU0t+SOgAVnPf8jHDzexqUBnH
         YgCpURey9n3XwYmoUji7aEPffTmQi//PB2gBlb3tthYr5xym4SSeyxmw6dAsPaBjd4Bt
         kIVA==
X-Gm-Message-State: AOAM533UOpiMl3k4mXdIegsFuoPkOlawDQiCXwm3R+POt7MZDfWBrZXA
        tYKL/rcabDyTJOgFiq9Wryo=
X-Google-Smtp-Source: ABdhPJyDmyIdYZKBBHULa9ROT4yqdAXLVvNIzrXwCF7SPjBe42Rh6PmdwPlBKqWXoiJA4GHWKK+egA==
X-Received: by 2002:ac2:4e85:: with SMTP id o5mr161039lfr.149.1611330451118;
        Fri, 22 Jan 2021 07:47:31 -0800 (PST)
Received: from btopel-mobl.ger.intel.com (c213-102-90-208.bredband.comhem.se. [213.102.90.208])
        by smtp.gmail.com with ESMTPSA id w17sm928589lft.52.2021.01.22.07.47.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Jan 2021 07:47:30 -0800 (PST)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        magnus.karlsson@intel.com, jonathan.lemon@gmail.com,
        ciara.loftus@intel.com, weqaar.a.janjua@intel.com
Subject: [PATCH bpf-next 01/12] selftests/bpf: remove a lot of ifobject casting
Date:   Fri, 22 Jan 2021 16:47:14 +0100
Message-Id: <20210122154725.22140-2-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210122154725.22140-1-bjorn.topel@gmail.com>
References: <20210122154725.22140-1-bjorn.topel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Björn Töpel <bjorn.topel@intel.com>

Instead of passing void * all over the place, let us pass the actual
type (ifobject) and remove the void-ptr-to-type-ptr casting.

Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
---
 tools/testing/selftests/bpf/xdpxceiver.c | 88 ++++++++++++------------
 1 file changed, 43 insertions(+), 45 deletions(-)

diff --git a/tools/testing/selftests/bpf/xdpxceiver.c b/tools/testing/selftests/bpf/xdpxceiver.c
index 1e722ee76b1f..cd1dd2b7458f 100644
--- a/tools/testing/selftests/bpf/xdpxceiver.c
+++ b/tools/testing/selftests/bpf/xdpxceiver.c
@@ -224,14 +224,14 @@ static inline u16 udp_csum(u32 saddr, u32 daddr, u32 len, u8 proto, u16 *udp_pkt
 	return csum_tcpudp_magic(saddr, daddr, len, proto, csum);
 }
 
-static void gen_eth_hdr(void *data, struct ethhdr *eth_hdr)
+static void gen_eth_hdr(struct ifobject *ifobject, struct ethhdr *eth_hdr)
 {
-	memcpy(eth_hdr->h_dest, ((struct ifobject *)data)->dst_mac, ETH_ALEN);
-	memcpy(eth_hdr->h_source, ((struct ifobject *)data)->src_mac, ETH_ALEN);
+	memcpy(eth_hdr->h_dest, ifobject->dst_mac, ETH_ALEN);
+	memcpy(eth_hdr->h_source, ifobject->src_mac, ETH_ALEN);
 	eth_hdr->h_proto = htons(ETH_P_IP);
 }
 
-static void gen_ip_hdr(void *data, struct iphdr *ip_hdr)
+static void gen_ip_hdr(struct ifobject *ifobject, struct iphdr *ip_hdr)
 {
 	ip_hdr->version = IP_PKT_VER;
 	ip_hdr->ihl = 0x5;
@@ -241,15 +241,15 @@ static void gen_ip_hdr(void *data, struct iphdr *ip_hdr)
 	ip_hdr->frag_off = 0;
 	ip_hdr->ttl = IPDEFTTL;
 	ip_hdr->protocol = IPPROTO_UDP;
-	ip_hdr->saddr = ((struct ifobject *)data)->src_ip;
-	ip_hdr->daddr = ((struct ifobject *)data)->dst_ip;
+	ip_hdr->saddr = ifobject->src_ip;
+	ip_hdr->daddr = ifobject->dst_ip;
 	ip_hdr->check = 0;
 }
 
-static void gen_udp_hdr(void *data, void *arg, struct udphdr *udp_hdr)
+static void gen_udp_hdr(void *data, struct ifobject *ifobject, struct udphdr *udp_hdr)
 {
-	udp_hdr->source = htons(((struct ifobject *)arg)->src_port);
-	udp_hdr->dest = htons(((struct ifobject *)arg)->dst_port);
+	udp_hdr->source = htons(ifobject->src_port);
+	udp_hdr->dest = htons(ifobject->dst_port);
 	udp_hdr->len = htons(UDP_PKT_SIZE);
 	memset32_htonl(pkt_data + PKT_HDR_SIZE,
 		       htonl(((struct generic_data *)data)->seqnum), UDP_PKT_DATA_SIZE);
@@ -628,28 +628,27 @@ static inline int get_batch_size(int pkt_cnt)
 	return opt_pkt_count - pkt_cnt;
 }
 
-static void complete_tx_only_all(void *arg)
+static void complete_tx_only_all(struct ifobject *ifobject)
 {
 	bool pending;
 
 	do {
 		pending = false;
-		if (((struct ifobject *)arg)->xsk->outstanding_tx) {
-			complete_tx_only(((struct ifobject *)
-					  arg)->xsk, BATCH_SIZE);
-			pending = !!((struct ifobject *)arg)->xsk->outstanding_tx;
+		if (ifobject->xsk->outstanding_tx) {
+			complete_tx_only(ifobject->xsk, BATCH_SIZE);
+			pending = !!ifobject->xsk->outstanding_tx;
 		}
 	} while (pending);
 }
 
-static void tx_only_all(void *arg)
+static void tx_only_all(struct ifobject *ifobject)
 {
 	struct pollfd fds[MAX_SOCKS] = { };
 	u32 frame_nb = 0;
 	int pkt_cnt = 0;
 	int ret;
 
-	fds[0].fd = xsk_socket__fd(((struct ifobject *)arg)->xsk->xsk);
+	fds[0].fd = xsk_socket__fd(ifobject->xsk->xsk);
 	fds[0].events = POLLOUT;
 
 	while ((opt_pkt_count && pkt_cnt < opt_pkt_count) || !opt_pkt_count) {
@@ -664,12 +663,12 @@ static void tx_only_all(void *arg)
 				continue;
 		}
 
-		tx_only(((struct ifobject *)arg)->xsk, &frame_nb, batch_size);
+		tx_only(ifobject->xsk, &frame_nb, batch_size);
 		pkt_cnt += batch_size;
 	}
 
 	if (opt_pkt_count)
-		complete_tx_only_all(arg);
+		complete_tx_only_all(ifobject);
 }
 
 static void worker_pkt_dump(void)
@@ -780,14 +779,14 @@ static void worker_pkt_validate(void)
 	}
 }
 
-static void thread_common_ops(void *arg, void *bufs, pthread_mutex_t *mutexptr,
+static void thread_common_ops(struct ifobject *ifobject, void *bufs, pthread_mutex_t *mutexptr,
 			      atomic_int *spinningptr)
 {
 	int ctr = 0;
 	int ret;
 
-	xsk_configure_umem((struct ifobject *)arg, bufs, num_frames * XSK_UMEM__DEFAULT_FRAME_SIZE);
-	ret = xsk_configure_socket((struct ifobject *)arg);
+	xsk_configure_umem(ifobject, bufs, num_frames * XSK_UMEM__DEFAULT_FRAME_SIZE);
+	ret = xsk_configure_socket(ifobject);
 
 	/* Retry Create Socket if it fails as xsk_socket__create()
 	 * is asynchronous
@@ -798,9 +797,8 @@ static void thread_common_ops(void *arg, void *bufs, pthread_mutex_t *mutexptr,
 	pthread_mutex_lock(mutexptr);
 	while (ret && ctr < SOCK_RECONF_CTR) {
 		atomic_store(spinningptr, 1);
-		xsk_configure_umem((struct ifobject *)arg,
-				   bufs, num_frames * XSK_UMEM__DEFAULT_FRAME_SIZE);
-		ret = xsk_configure_socket((struct ifobject *)arg);
+		xsk_configure_umem(ifobject, bufs, num_frames * XSK_UMEM__DEFAULT_FRAME_SIZE);
+		ret = xsk_configure_socket(ifobject);
 		usleep(USLEEP_MAX);
 		ctr++;
 	}
@@ -818,6 +816,7 @@ static void *worker_testapp_validate(void *arg)
 	struct generic_data *data = (struct generic_data *)malloc(sizeof(struct generic_data));
 	struct iphdr *ip_hdr = (struct iphdr *)(pkt_data + sizeof(struct ethhdr));
 	struct ethhdr *eth_hdr = (struct ethhdr *)pkt_data;
+	struct ifobject *ifobject = (struct ifobject *)arg;
 	void *bufs = NULL;
 
 	pthread_attr_setstacksize(&attr, THREAD_STACK);
@@ -828,49 +827,48 @@ static void *worker_testapp_validate(void *arg)
 		if (bufs == MAP_FAILED)
 			exit_with_error(errno);
 
-		if (strcmp(((struct ifobject *)arg)->nsname, ""))
-			switch_namespace(((struct ifobject *)arg)->ifdict_index);
+		if (strcmp(ifobject->nsname, ""))
+			switch_namespace(ifobject->ifdict_index);
 	}
 
-	if (((struct ifobject *)arg)->fv.vector == tx) {
+	if (ifobject->fv.vector == tx) {
 		int spinningrxctr = 0;
 
 		if (!bidi_pass)
-			thread_common_ops(arg, bufs, &sync_mutex_tx, &spinning_tx);
+			thread_common_ops(ifobject, bufs, &sync_mutex_tx, &spinning_tx);
 
 		while (atomic_load(&spinning_rx) && spinningrxctr < SOCK_RECONF_CTR) {
 			spinningrxctr++;
 			usleep(USLEEP_MAX);
 		}
 
-		ksft_print_msg("Interface [%s] vector [Tx]\n", ((struct ifobject *)arg)->ifname);
+		ksft_print_msg("Interface [%s] vector [Tx]\n", ifobject->ifname);
 		for (int i = 0; i < num_frames; i++) {
 			/*send EOT frame */
 			if (i == (num_frames - 1))
 				data->seqnum = -1;
 			else
 				data->seqnum = i;
-			gen_udp_hdr((void *)data, (void *)arg, udp_hdr);
-			gen_ip_hdr((void *)arg, ip_hdr);
+			gen_udp_hdr((void *)data, ifobject, udp_hdr);
+			gen_ip_hdr(ifobject, ip_hdr);
 			gen_udp_csum(udp_hdr, ip_hdr);
-			gen_eth_hdr((void *)arg, eth_hdr);
-			gen_eth_frame(((struct ifobject *)arg)->umem,
-				      i * XSK_UMEM__DEFAULT_FRAME_SIZE);
+			gen_eth_hdr(ifobject, eth_hdr);
+			gen_eth_frame(ifobject->umem, i * XSK_UMEM__DEFAULT_FRAME_SIZE);
 		}
 
 		free(data);
 		ksft_print_msg("Sending %d packets on interface %s\n",
-			       (opt_pkt_count - 1), ((struct ifobject *)arg)->ifname);
-		tx_only_all(arg);
-	} else if (((struct ifobject *)arg)->fv.vector == rx) {
+			       (opt_pkt_count - 1), ifobject->ifname);
+		tx_only_all(ifobject);
+	} else if (ifobject->fv.vector == rx) {
 		struct pollfd fds[MAX_SOCKS] = { };
 		int ret;
 
 		if (!bidi_pass)
-			thread_common_ops(arg, bufs, &sync_mutex_tx, &spinning_rx);
+			thread_common_ops(ifobject, bufs, &sync_mutex_tx, &spinning_rx);
 
-		ksft_print_msg("Interface [%s] vector [Rx]\n", ((struct ifobject *)arg)->ifname);
-		xsk_populate_fill_ring(((struct ifobject *)arg)->umem);
+		ksft_print_msg("Interface [%s] vector [Rx]\n", ifobject->ifname);
+		xsk_populate_fill_ring(ifobject->umem);
 
 		TAILQ_INIT(&head);
 		if (debug_pkt_dump) {
@@ -879,7 +877,7 @@ static void *worker_testapp_validate(void *arg)
 				exit_with_error(errno);
 		}
 
-		fds[0].fd = xsk_socket__fd(((struct ifobject *)arg)->xsk->xsk);
+		fds[0].fd = xsk_socket__fd(ifobject->xsk->xsk);
 		fds[0].events = POLLIN;
 
 		pthread_mutex_lock(&sync_mutex);
@@ -892,7 +890,7 @@ static void *worker_testapp_validate(void *arg)
 				if (ret <= 0)
 					continue;
 			}
-			rx_pkt(((struct ifobject *)arg)->xsk, fds);
+			rx_pkt(ifobject->xsk, fds);
 			worker_pkt_validate();
 
 			if (sigvar)
@@ -900,15 +898,15 @@ static void *worker_testapp_validate(void *arg)
 		}
 
 		ksft_print_msg("Received %d packets on interface %s\n",
-			       pkt_counter, ((struct ifobject *)arg)->ifname);
+			       pkt_counter, ifobject->ifname);
 
 		if (opt_teardown)
 			ksft_print_msg("Destroying socket\n");
 	}
 
 	if (!opt_bidi || (opt_bidi && bidi_pass)) {
-		xsk_socket__delete(((struct ifobject *)arg)->xsk->xsk);
-		(void)xsk_umem__delete(((struct ifobject *)arg)->umem->umem);
+		xsk_socket__delete(ifobject->xsk->xsk);
+		(void)xsk_umem__delete(ifobject->umem->umem);
 	}
 	pthread_exit(NULL);
 }
-- 
2.27.0

