Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 439596C6D79
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 17:28:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231613AbjCWQ24 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 12:28:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231389AbjCWQ2w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 12:28:52 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A54620050
        for <netdev@vger.kernel.org>; Thu, 23 Mar 2023 09:28:47 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id om3-20020a17090b3a8300b0023efab0e3bfso2478153pjb.3
        for <netdev@vger.kernel.org>; Thu, 23 Mar 2023 09:28:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679588926; x=1682180926;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=nMDJZZ9ajvgiBQdmQu2zFXlqrPDeZj/tU7VgCS9360c=;
        b=YvsuetxyO89bTmuc1sOBc3uCxwym0ODyB4FILamo9PWKnuXxHt4aT11fe8j1bfw95K
         CqBEPgIGx2qwIY3eKjkTqJlvpau/M5nGzexp78zgy80lKbf+FxdXJXq9jxCBII1XthPm
         wX1fQR64soU9scXTDeUHyJxIabPqei7c2pHPis9t/NtLctqcEM0KCaBa24F5EyhmDh7h
         VnznhQjAZPBxEszL9M4FjxKnVZ3L7UgKebZmz7CDXpvoqMwY+nJRMYBRIwnuq3iYe/a+
         f+vWkCUCu2R64EIjYFL2o/RMu5UOvy7+zoc0HDGvOLO6D7bM5ju50nrxt5kJX9P/6U7r
         4ZCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679588926; x=1682180926;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nMDJZZ9ajvgiBQdmQu2zFXlqrPDeZj/tU7VgCS9360c=;
        b=AixfZznne3ImW2IOHAKcCzTh70FLFkILaJ01Tjp+XYz+ddFcSfz5qbjTOyGduNL5ng
         3OgJhDB8f5wNpNmtd5UtVYfM/dWVTZCe55f4XGlRTVwGGWakv9Z7BgOYg98Qg/A/+Sv7
         ZWHc6nOtx50pgiX8/jZYj4bYzyLEcFpEplJFTmsq41FkZQGJmNxacONnzf226Z7kgswe
         D2ZejGRZWztRbj89Rgm33PXMR7dnfA620ETo7E5JItRpnlMnu8t9vF+ASMMjzzixlFmN
         fIHA7lspzt6HIQ/E62uMZsXSQRXIGn4hffoDxp1PDYkJaa7qETUywv9vVbAZBNDwAuz1
         ulVw==
X-Gm-Message-State: AO0yUKVoydJJl/7ey1kJu4apNiGQVnIhSEhjpgtGQ5JWGSGXNiiG38Gv
        xK23Dkhu4QgeQ44dqnR7y7c=
X-Google-Smtp-Source: AK7set9hUJPwcyK3zXcMdiqbipdA1oA9IFXrP3grdi8z7Rua4MVy9SNFowiyS9mMfDTXliaT/bb0bg==
X-Received: by 2002:a05:6a20:748c:b0:dc:e387:5661 with SMTP id p12-20020a056a20748c00b000dce3875661mr147658pzd.6.1679588926147;
        Thu, 23 Mar 2023 09:28:46 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:48f:b890:d499:3b10])
        by smtp.gmail.com with ESMTPSA id v20-20020aa78094000000b006089fb79f1esm12497412pff.96.2023.03.23.09.28.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Mar 2023 09:28:45 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Nikolay Aleksandrov <razor@blackwall.org>
Subject: [PATCH v3 net-next] net: introduce a config option to tweak MAX_SKB_FRAGS
Date:   Thu, 23 Mar 2023 09:28:42 -0700
Message-Id: <20230323162842.1935061-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.40.0.rc1.284.g88254d51c5-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
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
both the incoming packet (for MTU=1500) and skb_shared_info in half a page,
using build_skb().

v3: fix build error when CONFIG_NET=n
v2: fix two build errors assuming MAX_SKB_FRAGS was "unsigned long"

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Nikolay Aleksandrov <razor@blackwall.org>
---
 drivers/scsi/cxgbi/libcxgbi.c |  4 ++--
 include/linux/skbuff.h        | 16 +++++-----------
 net/Kconfig                   | 12 ++++++++++++
 net/packet/af_packet.c        |  4 ++--
 4 files changed, 21 insertions(+), 15 deletions(-)

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
index fe661011644b8f468ff5e92075a6624f0557584c..82511b2f61ea2bc5d587b58f0901e50e64729e4f 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -345,18 +345,12 @@ struct sk_buff_head {
 
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
+#ifndef CONFIG_MAX_SKB_FRAGS
+# define CONFIG_MAX_SKB_FRAGS 17
 #endif
+
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

