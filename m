Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACB202FBB63
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 16:40:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391601AbhASPjN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 10:39:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391544AbhASPiB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jan 2021 10:38:01 -0500
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5813C061794;
        Tue, 19 Jan 2021 07:37:20 -0800 (PST)
Received: by mail-lf1-x12c.google.com with SMTP id u25so29679057lfc.2;
        Tue, 19 Jan 2021 07:37:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rXAQKX5Rax1eJa7MI4GCTD3pP8WmeOcF3wTwT9EyL68=;
        b=uhHO0MnO5IOfg5rtA8Fudn0Gjngrq9vihih33jkmNL8UV/9k7ZGz3sZWv9lwMuiPl6
         520qXVYcFz7JE3lvUYcTCkR1OEIanGQz7Wox6mIG0bKbvyfrzFUrM9980HlGAn2Hlyak
         5bSaMCJt10yKvd+kRavXiuNEky/fFSO6Qe08h6qLgOdOdmJ/1W1/KzRzdbbK/9KzfrQy
         OxTtoB9rr/XM3FveUiHYCFVsup3OiZMUsvg8qyBTqPeaay5lAkqLFkbK+Ia+Mus9lAk8
         7/k5ZZbJDRDKbGME0UwdzEBLfC2sKzR/Q7A0LGSb6y/bezIqbYkmVNrIrQMGPlG5A2qV
         Z6lA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rXAQKX5Rax1eJa7MI4GCTD3pP8WmeOcF3wTwT9EyL68=;
        b=d6H3nW141JYcG1I9B5dvOI8WwL1M6qte9BlWVyC6oGnDU+7wnF/G+s+Vocc+T3nNH+
         gBKgptux35OntDTFV01+qSTEyze60U6HCCaTo2oViwmDM38/WyfMxEUcmUi0UhI27oUf
         dBwuC8Q5eVS/kUbwtaw6C+7hBZaT5kQkMj4v3R7CY0nj+gldHt22Fd4ZyQE5mmfQrPIg
         Rrjm0W4RVzZgHtkG9lfj5qP6uAUMyvvvgwPrhs2qFfCmlBA3mjt1u84SZSdunb0zbIh9
         2GamtU+IWL8qEewnSojdAevr23YpyLv4Iio0hqx25zHiDfdkoi4CJsOoG83xXy8qnDP8
         qY5w==
X-Gm-Message-State: AOAM530tVNmbwSVascdOLKx74ocXgZb/6BiUlTdz3mMw0OHDe2qLGBjV
        n30vR2yBXPfI6e8BgRy0j40=
X-Google-Smtp-Source: ABdhPJwQtKMLtr6+CGWZtI5pPRNdcYGM9+6IrN7nL8uI0f8mEviJrcHvft6OhivY2lEIJh/qxBjymw==
X-Received: by 2002:ac2:4e4e:: with SMTP id f14mr1549973lfr.7.1611070639474;
        Tue, 19 Jan 2021 07:37:19 -0800 (PST)
Received: from btopel-mobl.ger.intel.com (c213-102-90-208.bredband.comhem.se. [213.102.90.208])
        by smtp.gmail.com with ESMTPSA id z2sm2309075lfd.142.2021.01.19.07.37.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jan 2021 07:37:18 -0800 (PST)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        magnus.karlsson@intel.com, maciej.fijalkowski@intel.com,
        kuba@kernel.org, jonathan.lemon@gmail.com, maximmi@nvidia.com,
        davem@davemloft.net, hawk@kernel.org, john.fastabend@gmail.com,
        ciara.loftus@intel.com, weqaar.a.janjua@intel.com
Subject: [PATCH bpf-next 8/8] selftest/bpf: remove a lot of ifobject casting in xdpxceiver
Date:   Tue, 19 Jan 2021 16:36:55 +0100
Message-Id: <20210119153655.153999-9-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210119153655.153999-1-bjorn.topel@gmail.com>
References: <20210119153655.153999-1-bjorn.topel@gmail.com>
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
 tools/testing/selftests/bpf/xdpxceiver.c | 87 ++++++++++++------------
 1 file changed, 42 insertions(+), 45 deletions(-)

diff --git a/tools/testing/selftests/bpf/xdpxceiver.c b/tools/testing/selftests/bpf/xdpxceiver.c
index b88be91a6875..67f2e412ae34 100644
--- a/tools/testing/selftests/bpf/xdpxceiver.c
+++ b/tools/testing/selftests/bpf/xdpxceiver.c
@@ -225,14 +225,14 @@ static inline u16 udp_csum(u32 saddr, u32 daddr, u32 len, u8 proto, u16 *udp_pkt
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
@@ -242,15 +242,15 @@ static void gen_ip_hdr(void *data, struct iphdr *ip_hdr)
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
@@ -693,28 +693,27 @@ static inline int get_batch_size(int pkt_cnt)
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
@@ -729,12 +728,12 @@ static void tx_only_all(void *arg)
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
@@ -845,14 +844,14 @@ static void worker_pkt_validate(void)
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
@@ -863,9 +862,8 @@ static void thread_common_ops(void *arg, void *bufs, pthread_mutex_t *mutexptr,
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
@@ -894,52 +892,51 @@ static void *worker_testapp_validate(void *arg)
 		if (bufs == MAP_FAILED)
 			exit_with_error(errno);
 
-		if (strcmp(((struct ifobject *)arg)->nsname, ""))
-			switch_namespace(((struct ifobject *)arg)->ifdict_index);
+		if (strcmp(ifobject->nsname, ""))
+			switch_namespace(ifobject->ifdict_index);
 
 		if (ifobject->obj && attach_xdp_program(ifobject->ifindex, ifobject->prog_fd) < 0)
 			exit_with_error(errno);
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
@@ -948,7 +945,7 @@ static void *worker_testapp_validate(void *arg)
 				exit_with_error(errno);
 		}
 
-		fds[0].fd = xsk_socket__fd(((struct ifobject *)arg)->xsk->xsk);
+		fds[0].fd = xsk_socket__fd(ifobject->xsk->xsk);
 		fds[0].events = POLLIN;
 
 		pthread_mutex_lock(&sync_mutex);
@@ -961,7 +958,7 @@ static void *worker_testapp_validate(void *arg)
 				if (ret <= 0)
 					continue;
 			}
-			rx_pkt(((struct ifobject *)arg)->xsk, fds);
+			rx_pkt(ifobject->xsk, fds);
 			worker_pkt_validate();
 
 			if (sigvar)
@@ -969,15 +966,15 @@ static void *worker_testapp_validate(void *arg)
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

