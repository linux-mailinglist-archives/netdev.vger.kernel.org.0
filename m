Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 387DB371E1A
	for <lists+netdev@lfdr.de>; Mon,  3 May 2021 19:11:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234940AbhECRKm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 May 2021 13:10:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234647AbhECRId (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 May 2021 13:08:33 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BBBFC0611C5;
        Mon,  3 May 2021 10:03:18 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id v13so3159091ple.9;
        Mon, 03 May 2021 10:03:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=thS6ndoj0noR+neEiHTdxxqCnhRUvAsfo5u9ppo6dyU=;
        b=WX7VbMEUSPf2+kDLLqaWJ1uI4LmljVvxO+QSaTmOo5WcqclIzR8jhpcupucHiAjwFh
         M20VnIN+9vUFL0qnIwz0plZGPzyGGov73MQ8xidR7/dHggS8BYsqcdEFAEFN55p5lQ2w
         eVQeoapNsrAWrkw3BUaQ57WLmMRGHb3LCmxsXrV3qxkwL37R4mm/kTjNQAirjW3+NqEJ
         1Bb5RthtPH4gCY2xMk4mzvxtKyDJNtFiUlsKK0D/J6iEqjdHQ+pm3IFBfDl+dBcwndwe
         /NfGUBFTtKokH6H7ORUdv5N2PUpdAHDyqVsNqggbPwVspGEj1P61o6+pklbdA3jiZjg4
         Cmxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=thS6ndoj0noR+neEiHTdxxqCnhRUvAsfo5u9ppo6dyU=;
        b=s2j5KsJh0g8rOX7wnh+y5A0T9/zpihq8kn2V+dSK42MM2Iwe0bmEJ+fE9O38ZOKemg
         kC4E5+Bxl0NnTjBk8NqyrV3vlfohdQh6KNc0F5WZWOrKfZacA4sbG5f9qqVcbOcxCH+E
         2PCSYWPZ8etEiIWtd0gSajL4xMm/LDuBfZ0BuL2mah47FW47pooiOo7StnfMcOVeoMKj
         Rox2QFyOOGSC0pahXJM4N6Q2ye+hsa67wynFve/WrNB9dPDYc5owoqPD0u261MGxZ3U1
         W4yn2YtXV+/R30jcT5IMvhTISNuaz4VWG2AvJZH5CUdnzVkEq70+k+04pYfuqp1J9O5D
         fFmQ==
X-Gm-Message-State: AOAM531BzWEl+N2f0Sftsr50zoiYcf0pCQpC3oTszFIFPeobf6ihx1sy
        gqpzf9hXDPklCz7ganpVYmU=
X-Google-Smtp-Source: ABdhPJzpVuqbVFTV7qY2OGCZtymeAdI6jHs68knYvjB4cM1F4MHHLnADIkcixvBHuqGWVSCamnuh8A==
X-Received: by 2002:a17:902:c407:b029:ec:aeb7:667f with SMTP id k7-20020a170902c407b02900ecaeb7667fmr21521208plk.9.1620061398266;
        Mon, 03 May 2021 10:03:18 -0700 (PDT)
Received: from localhost ([157.45.29.210])
        by smtp.gmail.com with ESMTPSA id z29sm122686pga.52.2021.05.03.10.03.17
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 03 May 2021 10:03:17 -0700 (PDT)
Date:   Mon, 3 May 2021 22:33:09 +0530
From:   Shubhankar Kuranagatti <shubhankarvk@gmail.com>
To:     davem@davemloft.net
Cc:     kuba@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, willemb@google.com,
        xie.he.0141@gmail.com, edumazet@google.com,
        john.ogness@linutronix.de, eyal.birger@gmail.com,
        wanghai38@huawei.com, colin.king@canonical.com,
        shubhankarvk@gmail.com, tannerlove@google.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH] net: packet: af_packet.c: Add new line after declaration
Message-ID: <20210503170309.63r2mtupzn5ne6zt@kewl-virtual-machine>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: NeoMutt/20171215
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

New line added after declaration
Tabs have been used instead of spaces for indentation
Each subsequent line of block commment start with a *
This is done to maintain code uniformity

Signed-off-by: Shubhankar Kuranagatti <shubhankarvk@gmail.com>
---
 net/packet/af_packet.c | 43 +++++++++++++++++++++++++-----------------
 1 file changed, 26 insertions(+), 17 deletions(-)

diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index e24b2841c643..8b6417afb12a 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -93,20 +93,20 @@
 #include "internal.h"
 
 /*
-   Assumptions:
-   - If the device has no dev->header_ops->create, there is no LL header
-     visible above the device. In this case, its hard_header_len should be 0.
-     The device may prepend its own header internally. In this case, its
-     needed_headroom should be set to the space needed for it to add its
-     internal header.
-     For example, a WiFi driver pretending to be an Ethernet driver should
-     set its hard_header_len to be the Ethernet header length, and set its
-     needed_headroom to be (the real WiFi header length - the fake Ethernet
-     header length).
-   - packet socket receives packets with pulled ll header,
-     so that SOCK_RAW should push it back.
-
-On receive:
+ * Assumptions:
+ * - If the device has no dev->header_ops->create, there is no LL header
+ *   visible above the device. In this case, its hard_header_len should be 0.
+ *   The device may prepend its own header internally. In this case, its
+ *   needed_headroom should be set to the space needed for it to add its
+ *   internal header.
+ *   For example, a WiFi driver pretending to be an Ethernet driver should
+ *   set its hard_header_len to be the Ethernet header length, and set its
+ *   needed_headroom to be (the real WiFi header length - the fake Ethernet
+ *   header length).
+ * - packet socket receives packets with pulled ll header,
+ *   so that SOCK_RAW should push it back.
+
+ On receive:
 -----------
 
 Incoming, dev_has_header(dev) == true
@@ -781,6 +781,7 @@ static void prb_close_block(struct tpacket_kbdq_core *pkc1,
 		 * blocks. See prb_retire_rx_blk_timer_expired().
 		 */
 		struct timespec64 ts;
+
 		ktime_get_real_ts64(&ts);
 		h1->ts_last_pkt.ts_sec = ts.tv_sec;
 		h1->ts_last_pkt.ts_nsec	= ts.tv_nsec;
@@ -1075,6 +1076,7 @@ static void *packet_current_rx_frame(struct packet_sock *po,
 					    int status, unsigned int len)
 {
 	char *curr = NULL;
+
 	switch (po->tp_version) {
 	case TPACKET_V1:
 	case TPACKET_V2:
@@ -1106,6 +1108,7 @@ static void *prb_lookup_block(const struct packet_sock *po,
 static int prb_previous_blk_num(struct packet_ring_buffer *rb)
 {
 	unsigned int prev;
+
 	if (rb->prb_bdqc.kactive_blk_num)
 		prev = rb->prb_bdqc.kactive_blk_num-1;
 	else
@@ -1119,6 +1122,7 @@ static void *__prb_previous_block(struct packet_sock *po,
 					 int status)
 {
 	unsigned int previous = prb_previous_blk_num(rb);
+
 	return prb_lookup_block(po, rb, previous, status);
 }
 
@@ -1152,6 +1156,7 @@ static void *packet_previous_frame(struct packet_sock *po,
 		int status)
 {
 	unsigned int previous = rb->head ? rb->head - 1 : rb->frame_max;
+
 	return packet_lookup_frame(po, rb, previous, status);
 }
 
@@ -2112,6 +2117,7 @@ static int packet_rcv(struct sk_buff *skb, struct net_device *dev,
 
 	if (skb_shared(skb)) {
 		struct sk_buff *nskb = skb_clone(skb, GFP_ATOMIC);
+
 		if (nskb == NULL)
 			goto drop_n_acct;
 
@@ -2248,6 +2254,7 @@ static int tpacket_rcv(struct sk_buff *skb, struct net_device *dev,
 				  po->tp_reserve;
 	} else {
 		unsigned int maclen = skb_network_offset(skb);
+
 		netoff = TPACKET_ALIGN(po->tp_hdrlen +
 				       (maclen < 16 ? 16 : maclen)) +
 				       po->tp_reserve;
@@ -2841,9 +2848,9 @@ static int tpacket_snd(struct packet_sock *po, struct msghdr *msg)
 }
 
 static struct sk_buff *packet_alloc_skb(struct sock *sk, size_t prepad,
-				        size_t reserve, size_t len,
-				        size_t linear, int noblock,
-				        int *err)
+					size_t reserve, size_t len,
+					size_t linear, int noblock,
+					int *err)
 {
 	struct sk_buff *skb;
 
@@ -3695,6 +3702,7 @@ packet_setsockopt(struct socket *sock, int level, int optname, sockptr_t optval,
 	{
 		struct packet_mreq_max mreq;
 		int len = optlen;
+
 		memset(&mreq, 0, sizeof(mreq));
 		if (len < sizeof(struct packet_mreq))
 			return -EINVAL;
@@ -4583,6 +4591,7 @@ static void *packet_seq_start(struct seq_file *seq, loff_t *pos)
 static void *packet_seq_next(struct seq_file *seq, void *v, loff_t *pos)
 {
 	struct net *net = seq_file_net(seq);
+
 	return seq_hlist_next_rcu(v, &net->packet.sklist, pos);
 }
 
-- 
2.17.1

