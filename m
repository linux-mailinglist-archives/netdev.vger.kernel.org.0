Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBD5B4C61E0
	for <lists+netdev@lfdr.de>; Mon, 28 Feb 2022 04:38:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232950AbiB1DjQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Feb 2022 22:39:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232557AbiB1DjP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Feb 2022 22:39:15 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BF705A59E;
        Sun, 27 Feb 2022 19:38:36 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id v5-20020a17090ac90500b001bc40b548f9so13630873pjt.0;
        Sun, 27 Feb 2022 19:38:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rJaYPf8BDMbEWP03mwkCM3SXKYCG0//DZ94NjmFjjII=;
        b=H19SAp6TZ8pFgvgwZyy7MMhd7e1SPh8uHaUx1grxRrGoIjz4J8srPpKR1Q3tQTjlEP
         OJAZYRhW1fEwidATGZMoujt80dg8kHc56DPXTN07fk2Krx+FiipYY7Z56CiitF3wQauR
         BVXi5eG8IjQaSIYNedrPKGz1uXWCZCmpA3gZfxxCicyaNA85x5tDU9KvdEHejKMQqyie
         adnXklFwGwpG7g0UBVwpy9H/R20f/SvkABIdHSYmcjVXC1NOIiege/c3rOdPl2v+3pnH
         GWkevF0YIBA2Db3I4v7FLnD9DFu9aZxCPg2g6C0LrPdnmr6Oi7uUj81wd/ZNi8KegXnd
         jqig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rJaYPf8BDMbEWP03mwkCM3SXKYCG0//DZ94NjmFjjII=;
        b=fkM41vm+W43YoTUKXB9T8/ay3kQp6ASdk+YYdToLg1NEi1R1aMD9WQBiWSKK/blgiU
         l8Id//Ccw1RDxL62O03Arc+BmzQ4dKKwoUOSjt6P/cGSOfQP/SUCNM3tZmb6zGnfvvc3
         VsnivJ9pv0AJq0ay7qUjgvkvDnPuw4lU2CXbeO8aSW52AFgJ3Pdxp9k026pJiIjY+jOt
         IrGwLB/v0Kbx/Rg9E5ekZsNseL4uArKjV/egOvaL05E3I/fAGOtJDbDhVgPXSK9RpcRb
         n5/pjKqMMcAtUkKVwDcy4vzaSGKx0uy/Xy56zKiMginOHPzVWSxNTbsYfTN6KIQFi964
         FBjg==
X-Gm-Message-State: AOAM533AxOwGsWwz8bKZxif9OBeiuRi1WZvSiOXzFTC5fyknnBywoFLh
        xoEbyXPdcPTrBxK99xbdZJDobjA+lwIkwT+5
X-Google-Smtp-Source: ABdhPJwtdnuWD+Xmmm6+3h1S5kAIqlwgauls9sfjneSJTf5NEqjlv7+q68E/9dkCGnVR6fYz4BBPeg==
X-Received: by 2002:a17:90a:66c3:b0:1bc:cfab:86ec with SMTP id z3-20020a17090a66c300b001bccfab86ecmr14878208pjl.74.1646019515381;
        Sun, 27 Feb 2022 19:38:35 -0800 (PST)
Received: from localhost.localdomain ([157.255.44.217])
        by smtp.gmail.com with ESMTPSA id j7-20020a056a00130700b004b9f7cd94a4sm11145818pfu.56.2022.02.27.19.38.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Feb 2022 19:38:35 -0800 (PST)
From:   Harold Huang <baymaxhuang@gmail.com>
To:     netdev@vger.kernel.org
Cc:     jasowang@redhat.com, pabeni@redhat.com,
        Harold Huang <baymaxhuang@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        linux-kernel@vger.kernel.org (open list),
        bpf@vger.kernel.org (open list:XDP (eXpress Data Path))
Subject: [PATCH net-next v3] tun: support NAPI for packets received from batched XDP buffs
Date:   Mon, 28 Feb 2022 11:38:05 +0800
Message-Id: <20220228033805.1579435-1-baymaxhuang@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220224103852.311369-1-baymaxhuang@gmail.com>
References: <20220224103852.311369-1-baymaxhuang@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In tun, NAPI is supported and we can also use NAPI in the path of
batched XDP buffs to accelerate packet processing. What is more, after
we use NAPI, GRO is also supported. The iperf shows that the throughput of
single stream could be improved from 4.5Gbps to 9.2Gbps. Additionally, 9.2
Gbps nearly reachs the line speed of the phy nic and there is still about
15% idle cpu core remaining on the vhost thread.

Test topology:
[iperf server]<--->tap<--->dpdk testpmd<--->phy nic<--->[iperf client]

Iperf stream:
iperf3 -c 10.0.0.2  -i 1 -t 10

Before:
...
[  5]   5.00-6.00   sec   558 MBytes  4.68 Gbits/sec    0   1.50 MBytes
[  5]   6.00-7.00   sec   556 MBytes  4.67 Gbits/sec    1   1.35 MBytes
[  5]   7.00-8.00   sec   556 MBytes  4.67 Gbits/sec    2   1.18 MBytes
[  5]   8.00-9.00   sec   559 MBytes  4.69 Gbits/sec    0   1.48 MBytes
[  5]   9.00-10.00  sec   556 MBytes  4.67 Gbits/sec    1   1.33 MBytes
- - - - - - - - - - - - - - - - - - - - - - - - -
[ ID] Interval           Transfer     Bitrate         Retr
[  5]   0.00-10.00  sec  5.39 GBytes  4.63 Gbits/sec   72          sender
[  5]   0.00-10.04  sec  5.39 GBytes  4.61 Gbits/sec               receiver

After:
...
[  5]   5.00-6.00   sec  1.07 GBytes  9.19 Gbits/sec    0   1.55 MBytes
[  5]   6.00-7.00   sec  1.08 GBytes  9.30 Gbits/sec    0   1.63 MBytes
[  5]   7.00-8.00   sec  1.08 GBytes  9.25 Gbits/sec    0   1.72 MBytes
[  5]   8.00-9.00   sec  1.08 GBytes  9.25 Gbits/sec   77   1.31 MBytes
[  5]   9.00-10.00  sec  1.08 GBytes  9.24 Gbits/sec    0   1.48 MBytes
- - - - - - - - - - - - - - - - - - - - - - - - -
[ ID] Interval           Transfer     Bitrate         Retr
[  5]   0.00-10.00  sec  10.8 GBytes  9.28 Gbits/sec  166          sender
[  5]   0.00-10.04  sec  10.8 GBytes  9.24 Gbits/sec               receiver

Reported-at: https://lore.kernel.org/all/CACGkMEvTLG0Ayg+TtbN4q4pPW-ycgCCs3sC3-TF8cuRTf7Pp1A@mail.gmail.com
Signed-off-by: Harold Huang <baymaxhuang@gmail.com>
---
v2 -> v3
 - return the queued NAPI packet from tun_xdp_one

 drivers/net/tun.c | 43 ++++++++++++++++++++++++++++++-------------
 1 file changed, 30 insertions(+), 13 deletions(-)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index fed85447701a..969ea69fd29d 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -2388,9 +2388,10 @@ static int tun_xdp_one(struct tun_struct *tun,
 	struct virtio_net_hdr *gso = &hdr->gso;
 	struct bpf_prog *xdp_prog;
 	struct sk_buff *skb = NULL;
+	struct sk_buff_head *queue;
 	u32 rxhash = 0, act;
 	int buflen = hdr->buflen;
-	int err = 0;
+	int ret = 0;
 	bool skb_xdp = false;
 	struct page *page;
 
@@ -2405,13 +2406,13 @@ static int tun_xdp_one(struct tun_struct *tun,
 		xdp_set_data_meta_invalid(xdp);
 
 		act = bpf_prog_run_xdp(xdp_prog, xdp);
-		err = tun_xdp_act(tun, xdp_prog, xdp, act);
-		if (err < 0) {
+		ret = tun_xdp_act(tun, xdp_prog, xdp, act);
+		if (ret < 0) {
 			put_page(virt_to_head_page(xdp->data));
-			return err;
+			return ret;
 		}
 
-		switch (err) {
+		switch (ret) {
 		case XDP_REDIRECT:
 			*flush = true;
 			fallthrough;
@@ -2435,7 +2436,7 @@ static int tun_xdp_one(struct tun_struct *tun,
 build:
 	skb = build_skb(xdp->data_hard_start, buflen);
 	if (!skb) {
-		err = -ENOMEM;
+		ret = -ENOMEM;
 		goto out;
 	}
 
@@ -2445,7 +2446,7 @@ static int tun_xdp_one(struct tun_struct *tun,
 	if (virtio_net_hdr_to_skb(skb, gso, tun_is_little_endian(tun))) {
 		atomic_long_inc(&tun->rx_frame_errors);
 		kfree_skb(skb);
-		err = -EINVAL;
+		ret = -EINVAL;
 		goto out;
 	}
 
@@ -2455,16 +2456,27 @@ static int tun_xdp_one(struct tun_struct *tun,
 	skb_record_rx_queue(skb, tfile->queue_index);
 
 	if (skb_xdp) {
-		err = do_xdp_generic(xdp_prog, skb);
-		if (err != XDP_PASS)
+		ret = do_xdp_generic(xdp_prog, skb);
+		if (ret != XDP_PASS) {
+			ret = 0;
 			goto out;
+		}
 	}
 
 	if (!rcu_dereference(tun->steering_prog) && tun->numqueues > 1 &&
 	    !tfile->detached)
 		rxhash = __skb_get_hash_symmetric(skb);
 
-	netif_receive_skb(skb);
+	if (tfile->napi_enabled) {
+		queue = &tfile->sk.sk_write_queue;
+		spin_lock(&queue->lock);
+		__skb_queue_tail(queue, skb);
+		spin_unlock(&queue->lock);
+		ret = 1;
+	} else {
+		netif_receive_skb(skb);
+		ret = 0;
+	}
 
 	/* No need to disable preemption here since this function is
 	 * always called with bh disabled
@@ -2475,7 +2487,7 @@ static int tun_xdp_one(struct tun_struct *tun,
 		tun_flow_update(tun, rxhash, tfile);
 
 out:
-	return err;
+	return ret;
 }
 
 static int tun_sendmsg(struct socket *sock, struct msghdr *m, size_t total_len)
@@ -2492,7 +2504,7 @@ static int tun_sendmsg(struct socket *sock, struct msghdr *m, size_t total_len)
 	if (ctl && (ctl->type == TUN_MSG_PTR)) {
 		struct tun_page tpage;
 		int n = ctl->num;
-		int flush = 0;
+		int flush = 0, queued = 0;
 
 		memset(&tpage, 0, sizeof(tpage));
 
@@ -2501,12 +2513,17 @@ static int tun_sendmsg(struct socket *sock, struct msghdr *m, size_t total_len)
 
 		for (i = 0; i < n; i++) {
 			xdp = &((struct xdp_buff *)ctl->ptr)[i];
-			tun_xdp_one(tun, tfile, xdp, &flush, &tpage);
+			ret = tun_xdp_one(tun, tfile, xdp, &flush, &tpage);
+			if (ret > 0)
+				queued += ret;
 		}
 
 		if (flush)
 			xdp_do_flush();
 
+		if (tfile->napi_enabled && queued > 0)
+			napi_schedule(&tfile->napi);
+
 		rcu_read_unlock();
 		local_bh_enable();
 
-- 
2.27.0

