Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5A586C3703
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 17:36:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229916AbjCUQgA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 12:36:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229619AbjCUQf6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 12:35:58 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E9BB50FB3
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 09:35:56 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id h12-20020a17090aea8c00b0023d1311fab3so16506966pjz.1
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 09:35:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679416554; x=1682008554;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=F8BXBDVmR3m5xz8nITC9628BUvccl2vzUqg+HN10v24=;
        b=AohiAqe5f64V1oU2Hr3RWgT+N2wBmSWENGNZm+yGar0GC6MNJMr1bLLju1yFqFw+0j
         I3RsVyJg4wPjQjQNrXqQSOXDWtZz7xute+w9qtRERBCKw0OXPepdAYjVH/ixNS0NpnhW
         uPQKPZteH3Bl73d2JeKums8DM0HdTqaAITOiCyZoRZ4YRYVdTL3T8r59mTSoiFXeEN1Z
         e6RYloB84qKFSwXBz9QH2vOBacmAdx4TmSv5LPgYX9IeFgfhb7p+MnM+Fg+AcabF6iqw
         yFnmI99ClauBt9u+mP7fyzr6VskcG9CLVe/WdFl1i1M0+HLW2ZC4p0oFtSxsXOUihyZV
         U9zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679416554; x=1682008554;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=F8BXBDVmR3m5xz8nITC9628BUvccl2vzUqg+HN10v24=;
        b=CyYK/wQL6L2xZy9Jih4XSdYWsg43AlcIiDZYQ6Mckl38jGM6Y/7LOGuvuR4ZR+tILF
         Z2yShYbIEe7BKzc5+jCJb4P2IdiWYVIvFZPydxVajbt1vup+VU2r2UeJIoBmloIBkpFX
         FWaJssGHt/ONZVqEkYuPMKmFPIebCoGZWmmlXugOXr2VkZUaSYIaYdAdOa29UmyUO4WW
         450W1UUncdgzaK7BMhIvbEUdVJmJKOjb1ZJ/w6ZBmbx2ix8WMab6MmNXfYQY6tQdE+BL
         +qIeAtN9r41jnKHecjhYcpu+LTsrdUi9tXBXinodaAX9Y7VC/WJ3O+5DSEpaiHVxG0dz
         7uoA==
X-Gm-Message-State: AO0yUKVTuYbHq6v7u7Juf96G8weP2zvdaRJz4BC3/2Ms2pkMYxF8GtXH
        HGjICVyNYjlfIMozVIAtOi8=
X-Google-Smtp-Source: AK7set9FNp1+g+SU0W/9wvuknb/VL0uB57WmIfKO2/Vb5GYqphVJEGeP/kCFU3OZoJ8BcqUUAi6ESQ==
X-Received: by 2002:a05:6a20:6914:b0:cd:345e:5b10 with SMTP id q20-20020a056a20691400b000cd345e5b10mr2432764pzj.5.1679416553889;
        Tue, 21 Mar 2023 09:35:53 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:64a5:7098:dfcc:5633])
        by smtp.gmail.com with ESMTPSA id v22-20020a62a516000000b0058bc7453285sm8398662pfm.217.2023.03.21.09.35.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Mar 2023 09:35:53 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH v2 net-next] net: introduce a config option to tweak MAX_SKB_FRAGS
Date:   Tue, 21 Mar 2023 09:35:50 -0700
Message-Id: <20230321163550.1574254-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.40.0.rc1.284.g88254d51c5-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

Currently, MAX_SKB_FRAGS value is 17.

For standard tcp sendmsg() traffic, no big deal because tcp_sendmsg()
attempts order-3 allocations, stuffing 32768 bytes per frag.

But with zero copy, we use order-0 pages.

For BIG TCP to show its full potential, we add a config option
to be able to fit up to 45 segments per skb.

This is also needed for BIG TCP rx zerocopy, as zerocopy currently
does not support skbs with frag list.

We have used MAX_SKB_FRAGS=45 value for years at Google before
we deployed 4K MTU, with no adverse effect, other than
a recent issue in mlx4, fixed in commit 26782aad00cc
("net/mlx4: MLX4_TX_BOUNCE_BUFFER_SIZE depends on MAX_SKB_FRAGS")

Back then, goal was to be able to receive full size (64KB) GRO
packets without the frag_list overhead.

Note that /proc/sys/net/core/max_skb_frags can also be used to limit
the number of fragments TCP can use in tx packets.

By default we keep the old/legacy value of 17 until we get
more coverage for the updated values.

Sizes of struct skb_shared_info on 64bit arches

MAX_SKB_FRAGS | sizeof(struct skb_shared_info):
==============================================
         17     320
         21     320+64  = 384
         25     320+128 = 448
         29     320+192 = 512
         33     320+256 = 576
         37     320+320 = 640
         41     320+384 = 704
         45     320+448 = 768

This inflation might cause problems for drivers assuming they could pack
both the incoming packet and skb_shared_info in half a page, using build_skb().

v2: fix two build errors assuming MAX_SKB_FRAGS was "unsigned long"

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 drivers/scsi/cxgbi/libcxgbi.c |  4 ++--
 include/linux/skbuff.h        | 14 ++------------
 net/Kconfig                   | 12 ++++++++++++
 net/packet/af_packet.c        |  4 ++--
 4 files changed, 18 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/cxgbi/libcxgbi.c b/drivers/scsi/cxgbi/libcxgbi.c
index af281e271f886041b397ea881e2ce7be00eff625..3e1de4c842cc6102e25a5972d6b11e05c3e4c060 100644
--- a/drivers/scsi/cxgbi/libcxgbi.c
+++ b/drivers/scsi/cxgbi/libcxgbi.c
@@ -2314,9 +2314,9 @@ static int cxgbi_sock_tx_queue_up(struct cxgbi_sock *csk, struct sk_buff *skb)
 		frags++;
 
 	if (frags >= SKB_WR_LIST_SIZE) {
-		pr_err("csk 0x%p, frags %u, %u,%u >%lu.\n",
+		pr_err("csk 0x%p, frags %u, %u,%u >%u.\n",
 		       csk, skb_shinfo(skb)->nr_frags, skb->len,
-		       skb->data_len, SKB_WR_LIST_SIZE);
+		       skb->data_len, (unsigned int)SKB_WR_LIST_SIZE);
 		return -EINVAL;
 	}
 
diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index fe661011644b8f468ff5e92075a6624f0557584c..43726ca7d20f232461a4d2e5b984032806e9c13e 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -345,18 +345,8 @@ struct sk_buff_head {
 
 struct sk_buff;
 
-/* To allow 64K frame to be packed as single skb without frag_list we
- * require 64K/PAGE_SIZE pages plus 1 additional page to allow for
- * buffers which do not start on a page boundary.
- *
- * Since GRO uses frags we allocate at least 16 regardless of page
- * size.
- */
-#if (65536/PAGE_SIZE + 1) < 16
-#define MAX_SKB_FRAGS 16UL
-#else
-#define MAX_SKB_FRAGS (65536/PAGE_SIZE + 1)
-#endif
+#define MAX_SKB_FRAGS CONFIG_MAX_SKB_FRAGS
+
 extern int sysctl_max_skb_frags;
 
 /* Set skb_shinfo(skb)->gso_size to this in case you want skb_segment to
diff --git a/net/Kconfig b/net/Kconfig
index 48c33c2221999e575c83a409ab773b9cc3656eab..f806722bccf450c62e07bfdb245e5195ac4a156d 100644
--- a/net/Kconfig
+++ b/net/Kconfig
@@ -251,6 +251,18 @@ config PCPU_DEV_REFCNT
 	  network device refcount are using per cpu variables if this option is set.
 	  This can be forced to N to detect underflows (with a performance drop).
 
+config MAX_SKB_FRAGS
+	int "Maximum number of fragments per skb_shared_info"
+	range 17 45
+	default 17
+	help
+	  Having more fragments per skb_shared_info can help GRO efficiency.
+	  This helps BIG TCP workloads, but might expose bugs in some
+	  legacy drivers.
+	  This also increases memory overhead of small packets,
+	  and in drivers using build_skb().
+	  If unsure, say 17.
+
 config RPS
 	bool
 	depends on SMP && SYSFS
diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index 497193f73030c385a2d33b71dfbc299fbf9b763d..568f8d76e3c124f3b322a8d88dc3dcfbc45e7c0e 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -2622,8 +2622,8 @@ static int tpacket_fill_skb(struct packet_sock *po, struct sk_buff *skb,
 		nr_frags = skb_shinfo(skb)->nr_frags;
 
 		if (unlikely(nr_frags >= MAX_SKB_FRAGS)) {
-			pr_err("Packet exceed the number of skb frags(%lu)\n",
-			       MAX_SKB_FRAGS);
+			pr_err("Packet exceed the number of skb frags(%u)\n",
+			       (unsigned int)MAX_SKB_FRAGS);
 			return -EFAULT;
 		}
 
-- 
2.40.0.rc1.284.g88254d51c5-goog

