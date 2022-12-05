Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BA9764394D
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 00:11:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233996AbiLEXL0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 18:11:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233987AbiLEXLB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 18:11:01 -0500
Received: from mail-qt1-x835.google.com (mail-qt1-x835.google.com [IPv6:2607:f8b0:4864:20::835])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C1AE220D3
        for <netdev@vger.kernel.org>; Mon,  5 Dec 2022 15:09:30 -0800 (PST)
Received: by mail-qt1-x835.google.com with SMTP id y15so12585352qtv.5
        for <netdev@vger.kernel.org>; Mon, 05 Dec 2022 15:09:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=DQLseRrDsuHhJKXmiFys7qH07OqzY4Hx7l1zed9yTws=;
        b=Hynz74lJMld2z9j11EU1ziNd3+JQObTszXSyCpWnltfh0nnOgB/J2zTML0yN7Oil1G
         LLmP2+HuHvVdqQEOyP0T2WnVh7Im9STjectLWxqgfaRDSfUMl/5rWkx0yR9+BG6TKObp
         j8Gwz8Ea1oHTBhQ/5Hpai4rcePH/BJT1/Lq6WIcUomZ53bdwaUkZWL2WkGbLTM6Oi0Kd
         mPpGwDYvfLB9N9OFeU7Xehc6xKQ+z3tt9hqCcMfdxatvsfx1Wx0w2kRFQ2XnEbWjjaz1
         bfkkWGHeWAHQAyUXsnaLlyeAp5WZvCTucbj7bliUKp5I5QA30+yuH1PTcmTNdqLfGlvE
         XUGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DQLseRrDsuHhJKXmiFys7qH07OqzY4Hx7l1zed9yTws=;
        b=XaYzad4UzfLJJ5ej8nl9Iuw4FEi/x9ulykvZMt6vn/jyWFINWRRL3gZXDiNdYz3USi
         w1TTZrbgMIwWXAMTaHaw6j64KaPTjw2b1hDHii/E6GNgtnldhn5ZsmDzq/ugD5syb4oM
         v4edL7/Vsxs9RT7LqQoaywMqVgloK+4fTGVtOHDvL6TS8y6WVfkN3b2Op4Y5TUaDgvaE
         hXxDNIZUrZriYpIUlOOjq+WgcoVSVhdTrHpy8K5QZ47NfL+d9zekT+FbWYc8RJ967xdi
         A+tK5BGYJRu+ptBpui04Do69VnWH7SD1zFjPwG4PqW5MKISh21EduMXYXp/dCqanfLMO
         3Tgw==
X-Gm-Message-State: ANoB5pm3ETrjR01yXk7aYo6YIic/m9g/YwqynQ3HaVrU96hvJv0ei2QF
        vHE1BAB5r+PH5eazweHhBBIOqYZhjXc=
X-Google-Smtp-Source: AA0mqf5FrR/n5f50XNi+1k+k9TSwMJt35ArNuMZ4d2bpvg2vGgEzT1V75Blo9rRpilvL9Kcg0K13LA==
X-Received: by 2002:ac8:7097:0:b0:3a6:6b05:d067 with SMTP id y23-20020ac87097000000b003a66b05d067mr45048747qto.335.1670281769011;
        Mon, 05 Dec 2022 15:09:29 -0800 (PST)
Received: from willemb.c.googlers.com.com (240.157.150.34.bc.googleusercontent.com. [34.150.157.240])
        by smtp.gmail.com with ESMTPSA id ge12-20020a05622a5c8c00b003a6a7a20575sm5172673qtb.73.2022.12.05.15.09.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Dec 2022 15:09:28 -0800 (PST)
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, soheil@google.com,
        Willem de Bruijn <willemb@google.com>
Subject: [PATCH net-next] net_tstamp: add SOF_TIMESTAMPING_OPT_ID_TCP
Date:   Mon,  5 Dec 2022 18:09:25 -0500
Message-Id: <20221205230925.3002558-1-willemdebruijn.kernel@gmail.com>
X-Mailer: git-send-email 2.39.0.rc0.267.gcb52ba06e7-goog
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

From: Willem de Bruijn <willemb@google.com>

Add an option to initialize SOF_TIMESTAMPING_OPT_ID for TCP from
write_seq sockets instead of snd_una.

Intuitively the contract is that the counter is zero after the
setsockopt, so that the next write N results in a notification for
last byte N - 1.

On idle sockets snd_una == write_seq so this holds for both. But on
sockets with data in transmission, snd_una depends on the ACK response
from the peer. A process cannot learn this in a race free manner
(ioctl SIOCOUTQ is one racy approach).

write_seq is a better starting point because based on the seqno of
data written by the process only.

But the existing behavior may already be relied upon. So make the new
behavior optional behind a flag.

The new timestamp flag necessitates increasing sk_tsflags to 32 bits.
Move the field in struct sock to avoid growing the socket (for some
common CONFIG variants). The UAPI interface so_timestamping.flags is
already int, so 32 bits wide.

Reported-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Willem de Bruijn <willemb@google.com>

---

Alternative solutions are

* make the change unconditionally: a one line change.
* make the condition a (per netns) sysctl instead of flag
* make SOF_TIMESTAMPING_OPT_ID_TCP not a modifier of, but alternative
  to SOF_TIMESTAMPING_OPT_ID. That requires also updating all existing
  code that now tests OPT_ID to test a new OPT_ID_MASK.

Weighing the variants, this seemed the best option to me.
---
 Documentation/networking/timestamping.rst | 19 +++++++++++++++++++
 include/net/sock.h                        |  6 +++---
 include/uapi/linux/net_tstamp.h           |  3 ++-
 net/core/sock.c                           |  9 ++++++++-
 net/ethtool/common.c                      |  1 +
 5 files changed, 33 insertions(+), 5 deletions(-)

diff --git a/Documentation/networking/timestamping.rst b/Documentation/networking/timestamping.rst
index be4eb1242057..578f24731be5 100644
--- a/Documentation/networking/timestamping.rst
+++ b/Documentation/networking/timestamping.rst
@@ -192,6 +192,25 @@ SOF_TIMESTAMPING_OPT_ID:
   among all possibly concurrently outstanding timestamp requests for
   that socket.
 
+SOF_TIMESTAMPING_OPT_ID_TCP:
+  Pass this modifier along with SOF_TIMESTAMPING_OPT_ID for new TCP
+  timestamping applications. SOF_TIMESTAMPING_OPT_ID defines how the
+  counter increments for stream sockets, but its starting point is
+  not entirely trivial. This modifier option changes that point.
+
+  A reasonable expectation is that the counter is reset to zero with
+  the system call, so that a subsequent write() of N bytes generates
+  a timestamp with counter N-1. SOF_TIMESTAMPING_OPT_ID_TCP
+  implements this behavior under all conditions.
+
+  SOF_TIMESTAMPING_OPT_ID without modifier often reports the same,
+  especially when the socket option is set when no data is in
+  transmission. If data is being transmitted, it may be off by the
+  length of the output queue (SIOCOUTQ) due to being based on snd_una
+  rather than write_seq. That offset depends on factors outside of
+  process control, including network RTT and peer response time. The
+  difference is subtle and unlikely to be noticed when confiugred at
+  initial socket creation. But .._OPT_ID behavior is more predictable.
 
 SOF_TIMESTAMPING_OPT_CMSG:
   Support recv() cmsg for all timestamped packets. Control messages
diff --git a/include/net/sock.h b/include/net/sock.h
index 6d207e7c4ad0..ecea3dcc2217 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -503,10 +503,10 @@ struct sock {
 #if BITS_PER_LONG==32
 	seqlock_t		sk_stamp_seq;
 #endif
-	u16			sk_tsflags;
-	u8			sk_shutdown;
 	atomic_t		sk_tskey;
 	atomic_t		sk_zckey;
+	u32			sk_tsflags;
+	u8			sk_shutdown;
 
 	u8			sk_clockid;
 	u8			sk_txtime_deadline_mode : 1,
@@ -1899,7 +1899,7 @@ static inline void sock_replace_proto(struct sock *sk, struct proto *proto)
 struct sockcm_cookie {
 	u64 transmit_time;
 	u32 mark;
-	u16 tsflags;
+	u32 tsflags;
 };
 
 static inline void sockcm_init(struct sockcm_cookie *sockc,
diff --git a/include/uapi/linux/net_tstamp.h b/include/uapi/linux/net_tstamp.h
index 55501e5e7ac8..a2c66b3d7f0f 100644
--- a/include/uapi/linux/net_tstamp.h
+++ b/include/uapi/linux/net_tstamp.h
@@ -31,8 +31,9 @@ enum {
 	SOF_TIMESTAMPING_OPT_PKTINFO = (1<<13),
 	SOF_TIMESTAMPING_OPT_TX_SWHW = (1<<14),
 	SOF_TIMESTAMPING_BIND_PHC = (1 << 15),
+	SOF_TIMESTAMPING_OPT_ID_TCP = (1 << 16),
 
-	SOF_TIMESTAMPING_LAST = SOF_TIMESTAMPING_BIND_PHC,
+	SOF_TIMESTAMPING_LAST = SOF_TIMESTAMPING_OPT_ID_TCP,
 	SOF_TIMESTAMPING_MASK = (SOF_TIMESTAMPING_LAST - 1) |
 				 SOF_TIMESTAMPING_LAST
 };
diff --git a/net/core/sock.c b/net/core/sock.c
index 4571914a4aa8..b0ab841e0aed 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -901,13 +901,20 @@ int sock_set_timestamping(struct sock *sk, int optname,
 	if (val & ~SOF_TIMESTAMPING_MASK)
 		return -EINVAL;
 
+	if (val & SOF_TIMESTAMPING_OPT_ID_TCP &&
+	    !(val & SOF_TIMESTAMPING_OPT_ID))
+		return -EINVAL;
+
 	if (val & SOF_TIMESTAMPING_OPT_ID &&
 	    !(sk->sk_tsflags & SOF_TIMESTAMPING_OPT_ID)) {
 		if (sk_is_tcp(sk)) {
 			if ((1 << sk->sk_state) &
 			    (TCPF_CLOSE | TCPF_LISTEN))
 				return -EINVAL;
-			atomic_set(&sk->sk_tskey, tcp_sk(sk)->snd_una);
+			if (val & SOF_TIMESTAMPING_OPT_ID_TCP)
+				atomic_set(&sk->sk_tskey, tcp_sk(sk)->write_seq);
+			else
+				atomic_set(&sk->sk_tskey, tcp_sk(sk)->snd_una);
 		} else {
 			atomic_set(&sk->sk_tskey, 0);
 		}
diff --git a/net/ethtool/common.c b/net/ethtool/common.c
index 21cfe8557205..6f399afc2ff2 100644
--- a/net/ethtool/common.c
+++ b/net/ethtool/common.c
@@ -417,6 +417,7 @@ const char sof_timestamping_names[][ETH_GSTRING_LEN] = {
 	[const_ilog2(SOF_TIMESTAMPING_OPT_PKTINFO)]  = "option-pktinfo",
 	[const_ilog2(SOF_TIMESTAMPING_OPT_TX_SWHW)]  = "option-tx-swhw",
 	[const_ilog2(SOF_TIMESTAMPING_BIND_PHC)]     = "bind-phc",
+	[const_ilog2(SOF_TIMESTAMPING_OPT_ID_TCP)]   = "option-id-tcp",
 };
 static_assert(ARRAY_SIZE(sof_timestamping_names) == __SOF_TIMESTAMPING_CNT);
 
-- 
2.39.0.rc0.267.gcb52ba06e7-goog

