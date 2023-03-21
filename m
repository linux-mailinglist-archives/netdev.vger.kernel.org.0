Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFC226C28A3
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 04:37:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229635AbjCUDhN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 23:37:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229550AbjCUDhL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 23:37:11 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 407546A67
        for <netdev@vger.kernel.org>; Mon, 20 Mar 2023 20:37:10 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id qe8-20020a17090b4f8800b0023f07253a2cso14601550pjb.3
        for <netdev@vger.kernel.org>; Mon, 20 Mar 2023 20:37:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679369830;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=juYprQVnhl9cr1iSUfES48dSKycc6bswSqv66d1dw/A=;
        b=YJk37s7ICkbCsGQys6faM983RNr0V/DEK5464MzIYidYOYSPBs/KNeVHV5nLOBbSSp
         oNN193b5u9bevlnOiI36phGD1bJt3OO5nBdHbHmfiw/bWjAkx3SCSRYQvNxum0U/u+4A
         CxUK1bRzqDcmROZ7GWxW5/yml8hnpgdNiDM+t5n2/c9/+TLKA1iq8amcDtC8FdIze3gq
         /60JSbYqlZziuDBVM0VE8cX3Myc6ZKTfIDVVoV7GcA/N1FNPfxw3YfFc2AU5gAVV1JF6
         gzIPPzAWM91ocpnFCe2jhi0fLbTc/30iF395Hyx4pSO1W1XLE8n4RQOa1B2Oxkeo0GzG
         ZDZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679369830;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=juYprQVnhl9cr1iSUfES48dSKycc6bswSqv66d1dw/A=;
        b=ifynTzLVJ+Z3FS3JazyrJBgzA17Oc82YTLHoWDIiYn5C9zHoxnSR65gALuOkym9dAO
         xQOgjJVERqHgd46SspnkMLyCvz6dX5LK3XIUjN/OvwLa60S+1PXS/PUthskw35T8WDEN
         ld5eBQOJkrMdrJi0c9UVVB0gtmEYOzffRRXuy1A2683h/fjPz2oyK8Vb43Iksw5PsNgt
         mRNl4Fx8LD1rwVtZLub6peeWosMQgDIjMFvI61zXFK2mw3s8UFV0lVEZ/GS0VPUvRGIm
         sD1VHnRQmurbvsLbzIU3SbunB4FaNzgQ5topOWKPBDwkWUNOYophonoudqSEB+U8AQIT
         hIkQ==
X-Gm-Message-State: AO0yUKUjWlnCKr8hycrpgA+PHqMlD18ymXBZAKa4x5w/ygk/HJ+wGMEu
        dl5wBRldCK4GVjKB2QbV9xw=
X-Google-Smtp-Source: AK7set9PBcsyVllOEdHhVqkXWywWVWpQaGOD3NXgS3UQ9ELl22FX7lqSJ0+iKt4LeEb3LdLsnjFWmA==
X-Received: by 2002:a17:90a:e297:b0:23f:3b90:8bd7 with SMTP id d23-20020a17090ae29700b0023f3b908bd7mr1265582pjz.1.1679369829712;
        Mon, 20 Mar 2023 20:37:09 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:87e8:a5ed:1a5:115e])
        by smtp.gmail.com with ESMTPSA id gq21-20020a17090b105500b002342ccc8280sm6967450pjb.6.2023.03.20.20.37.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Mar 2023 20:37:09 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next] net: introduce a config option to tweak MAX_SKB_FRAGS
Date:   Mon, 20 Mar 2023 20:37:04 -0700
Message-Id: <20230321033704.936685-1-eric.dumazet@gmail.com>
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

We have used MAX_SKB_FRAGS=45 value for years [1] at Google before
we deployed 4K MTU, with no adverse effect, other than
a recent issue in mlx4, fixed in commit 26782aad00cc
("net/mlx4: MLX4_TX_BOUNCE_BUFFER_SIZE depends on MAX_SKB_FRAGS")

[1] Back then, goal was to be able to receive full size (64KB) GRO
packets without the frag_list overhead.

By default we keep the old/legacy value of 17 until we get
more coverage for the updated values.

Sizes of struct skb_shared_info on 64bit arches:

MAX_SKB_FRAGS | sizeof(struct skb_shared_info)
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

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/linux/skbuff.h | 14 ++------------
 net/Kconfig            | 12 ++++++++++++
 2 files changed, 14 insertions(+), 12 deletions(-)

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
-- 
2.40.0.rc1.284.g88254d51c5-goog

