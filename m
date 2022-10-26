Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72E5260E29C
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 15:52:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234073AbiJZNw2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 09:52:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233725AbiJZNvx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 09:51:53 -0400
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DE3FF4196
        for <netdev@vger.kernel.org>; Wed, 26 Oct 2022 06:51:51 -0700 (PDT)
Received: by mail-io1-xd31.google.com with SMTP id 11so2619609iou.0
        for <netdev@vger.kernel.org>; Wed, 26 Oct 2022 06:51:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=i9mUELI+uHEMnXN+ZbGDvO355C4TAkXyiE1+PN5KvoY=;
        b=mbDvvUX6dxostTkHGjwFGMsDm09wttsrTM2gyVUZATZRL1uWVQ/BxbnxDcrqC/cU/9
         S069wquqrGedR47NgXnPIeCqgSri0X2lhY9KkB4qTli2uank/z8q5uRveIMdA2JF4I9r
         OjkAosk7QaopXo+w17ryTTi3w4iwbDJkUEAeIpCsHjOkxjA1EGARDBIQ54P/JYz4ZT6E
         GV7Yo5FGJNgaoDaXV77+R1aAjtHe8SHMhGfBV+p5TC6o1czANUoujbih9fj0h9d8GH44
         rNEGDUdkDESz76I6t9aExHsqA8JqL1YUVeOcf9kU8oV3yr1jF0YuQutQ27JkfYZgU9Yh
         qBaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=i9mUELI+uHEMnXN+ZbGDvO355C4TAkXyiE1+PN5KvoY=;
        b=A2CsAp74OP8PsQrISlQ/KsczXdJ03NqGhXCI55KCRqU6JzX1ZDI3Ky0x64smf8DFzQ
         MEvI+HkHOnN8Y0mk9JZaiabavWnRb0LTD9feGK2/511xrzWHHa+Rd7x11Ue2WohDMuz1
         AzDLalBn2Pat5svOIA+saGHF0CGS4Dnm4QdEj2RarbJGh57D5cXsDEDOfUC8+NSZTE1J
         WGdTNYvAM/7EGQ86oGN9A3Kv1S5yAaGE8zlXRvh+7ZXS7hK6AfhqDxqqZnIYDJwzGDV9
         PcWlGm/C0unNNk4yX3DDv8Rz8VLiYPDkiqDCWxDRnSpYSuyKVPAK/bvUZbwnl0Kohc2K
         K9/A==
X-Gm-Message-State: ACrzQf3Og9PbF+JI21diDc6sdMfcPvxBZpf3Cjnrs71a/TwgpPfM7e3g
        LBS27RnXERFlnIX9uXTHVeENUBsCndoAWA==
X-Google-Smtp-Source: AMsMyM5ILrTG+BLa5Itzv3o3ibFcPuNxambhU1pDe5OS/pXDLedZ7c2CZh0R5tJ0RKrn6YsSxNiBPQ==
X-Received: by 2002:a05:620a:2441:b0:6ee:b1a0:2353 with SMTP id h1-20020a05620a244100b006eeb1a02353mr29687966qkn.687.1666792289898;
        Wed, 26 Oct 2022 06:51:29 -0700 (PDT)
Received: from mubashirq.c.googlers.com.com (74.206.145.34.bc.googleusercontent.com. [34.145.206.74])
        by smtp.gmail.com with ESMTPSA id b24-20020ac84f18000000b00397101ac0f2sm3211836qte.3.2022.10.26.06.51.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Oct 2022 06:51:29 -0700 (PDT)
From:   Mubashir Adnan Qureshi <mubashirmaq@gmail.com>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org,
        Mubashir Adnan Qureshi <mubashirq@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Eric Dumazet <edumazet@google.com>
Subject: [PATCH net-next 2/5] tcp: add PLB functionality for TCP
Date:   Wed, 26 Oct 2022 13:51:12 +0000
Message-Id: <20221026135115.3539398-3-mubashirmaq@gmail.com>
X-Mailer: git-send-email 2.38.0.135.g90850a2211-goog
In-Reply-To: <20221026135115.3539398-1-mubashirmaq@gmail.com>
References: <20221026135115.3539398-1-mubashirmaq@gmail.com>
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

From: Mubashir Adnan Qureshi <mubashirq@google.com>

Congestion control algorithms track PLB state and cause the connection
to trigger a path change when either of the 2 conditions is satisfied:

- No packets are in flight and (# consecutive congested rounds >=
  sysctl_tcp_plb_idle_rehash_rounds)
- (# consecutive congested rounds >= sysctl_tcp_plb_rehash_rounds)

A round (RTT) is marked as congested when congestion signal
(ECN ce_ratio) over an RTT is greater than sysctl_tcp_plb_cong_thresh.
In the event of RTO, PLB (via tcp_write_timeout()) triggers a path
change and disables congestion-triggered path changes for random time
between (sysctl_tcp_plb_suspend_rto_sec, 2*sysctl_tcp_plb_suspend_rto_sec)
to avoid hopping onto the "connectivity blackhole". RTO-triggered
path changes can still happen during this cool-off period.

Signed-off-by: Mubashir Adnan Qureshi <mubashirq@google.com>
Signed-off-by: Yuchung Cheng <ycheng@google.com>
Signed-off-by: Neal Cardwell <ncardwell@google.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
---
 include/net/tcp.h   |  28 ++++++++++++
 net/ipv4/Makefile   |   2 +-
 net/ipv4/tcp_ipv4.c |   2 +-
 net/ipv4/tcp_plb.c  | 107 ++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 137 insertions(+), 2 deletions(-)
 create mode 100644 net/ipv4/tcp_plb.c

diff --git a/include/net/tcp.h b/include/net/tcp.h
index 14d45661a84d..6b814e788f00 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -2140,6 +2140,34 @@ extern void tcp_rack_advance(struct tcp_sock *tp, u8 sacked, u32 end_seq,
 extern void tcp_rack_reo_timeout(struct sock *sk);
 extern void tcp_rack_update_reo_wnd(struct sock *sk, struct rate_sample *rs);
 
+/* tcp_plb.c */
+
+/*
+ * Scaling factor for fractions in PLB. For example, tcp_plb_update_state
+ * expects cong_ratio which represents fraction of traffic that experienced
+ * congestion over a single RTT. In order to avoid floating point operations,
+ * this fraction should be mapped to (1 << TCP_PLB_SCALE) and passed in.
+ */
+#define TCP_PLB_SCALE 8
+
+/* State for PLB (Protective Load Balancing) for a single TCP connection. */
+struct tcp_plb_state {
+	u8	consec_cong_rounds:5, /* consecutive congested rounds */
+		unused:3;
+	u32	pause_until; /* jiffies32 when PLB can resume rerouting */
+};
+
+static inline void tcp_plb_init(const struct sock *sk,
+				struct tcp_plb_state *plb)
+{
+	plb->consec_cong_rounds = 0;
+	plb->pause_until = 0;
+}
+void tcp_plb_update_state(const struct sock *sk, struct tcp_plb_state *plb,
+			  const int cong_ratio);
+void tcp_plb_check_rehash(struct sock *sk, struct tcp_plb_state *plb);
+void tcp_plb_update_state_upon_rto(struct sock *sk, struct tcp_plb_state *plb);
+
 /* At how many usecs into the future should the RTO fire? */
 static inline s64 tcp_rto_delta_us(const struct sock *sk)
 {
diff --git a/net/ipv4/Makefile b/net/ipv4/Makefile
index bbdd9c44f14e..af7d2cf490fb 100644
--- a/net/ipv4/Makefile
+++ b/net/ipv4/Makefile
@@ -10,7 +10,7 @@ obj-y     := route.o inetpeer.o protocol.o \
 	     tcp.o tcp_input.o tcp_output.o tcp_timer.o tcp_ipv4.o \
 	     tcp_minisocks.o tcp_cong.o tcp_metrics.o tcp_fastopen.o \
 	     tcp_rate.o tcp_recovery.o tcp_ulp.o \
-	     tcp_offload.o datagram.o raw.o udp.o udplite.o \
+	     tcp_offload.o tcp_plb.o datagram.o raw.o udp.o udplite.o \
 	     udp_offload.o arp.o icmp.o devinet.o af_inet.o igmp.o \
 	     fib_frontend.o fib_semantics.o fib_trie.o fib_notifier.o \
 	     inet_fragment.o ping.o ip_tunnel_core.o gre_offload.o \
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 58b838b56c7f..ebab9e8b184c 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -3224,7 +3224,7 @@ static int __net_init tcp_sk_init(struct net *net)
 	net->ipv4.sysctl_tcp_plb_rehash_rounds = 12;
 	net->ipv4.sysctl_tcp_plb_suspend_rto_sec = 60;
 	/* Default congestion threshold for PLB to mark a round is 50% */
-	net->ipv4.sysctl_tcp_plb_cong_thresh = 128;
+	net->ipv4.sysctl_tcp_plb_cong_thresh = (1 << TCP_PLB_SCALE) / 2;
 
 	/* Reno is always built in */
 	if (!net_eq(net, &init_net) &&
diff --git a/net/ipv4/tcp_plb.c b/net/ipv4/tcp_plb.c
new file mode 100644
index 000000000000..f4ced370acad
--- /dev/null
+++ b/net/ipv4/tcp_plb.c
@@ -0,0 +1,107 @@
+/* Protective Load Balancing (PLB)
+ *
+ * PLB was designed to reduce link load imbalance across datacenter
+ * switches. PLB is a host-based optimization; it leverages congestion
+ * signals from the transport layer to randomly change the path of the
+ * connection experiencing sustained congestion. PLB prefers to repath
+ * after idle periods to minimize packet reordering. It repaths by
+ * changing the IPv6 Flow Label on the packets of a connection, which
+ * datacenter switches include as part of ECMP/WCMP hashing.
+ *
+ * PLB is described in detail in:
+ *
+ *	Mubashir Adnan Qureshi, Yuchung Cheng, Qianwen Yin, Qiaobin Fu,
+ *	Gautam Kumar, Masoud Moshref, Junhua Yan, Van Jacobson,
+ *	David Wetherall,Abdul Kabbani:
+ *	"PLB: Congestion Signals are Simple and Effective for
+ *	 Network Load Balancing"
+ *	In ACM SIGCOMM 2022, Amsterdam Netherlands.
+ *
+ */
+
+#include <net/tcp.h>
+
+/* Called once per round-trip to update PLB state for a connection. */
+void tcp_plb_update_state(const struct sock *sk, struct tcp_plb_state *plb,
+			  const int cong_ratio)
+{
+	struct net *net = sock_net(sk);
+
+	if (!READ_ONCE(net->ipv4.sysctl_tcp_plb_enabled))
+		return;
+
+	if (cong_ratio >= 0) {
+		if (cong_ratio < READ_ONCE(net->ipv4.sysctl_tcp_plb_cong_thresh))
+			plb->consec_cong_rounds = 0;
+		else if (plb->consec_cong_rounds <
+			 READ_ONCE(net->ipv4.sysctl_tcp_plb_rehash_rounds))
+			plb->consec_cong_rounds++;
+	}
+}
+EXPORT_SYMBOL_GPL(tcp_plb_update_state);
+
+/* Check whether recent congestion has been persistent enough to warrant
+ * a load balancing decision that switches the connection to another path.
+ */
+void tcp_plb_check_rehash(struct sock *sk, struct tcp_plb_state *plb)
+{
+	struct net *net = sock_net(sk);
+	u32 max_suspend;
+	bool forced_rehash = false, idle_rehash = false;
+
+	if (!READ_ONCE(net->ipv4.sysctl_tcp_plb_enabled))
+		return;
+
+	forced_rehash = plb->consec_cong_rounds >=
+			READ_ONCE(net->ipv4.sysctl_tcp_plb_rehash_rounds);
+	/* If sender goes idle then we check whether to rehash. */
+	idle_rehash = READ_ONCE(net->ipv4.sysctl_tcp_plb_idle_rehash_rounds) &&
+		      !tcp_sk(sk)->packets_out &&
+		      plb->consec_cong_rounds >=
+		      READ_ONCE(net->ipv4.sysctl_tcp_plb_idle_rehash_rounds);
+
+	if (!forced_rehash && !idle_rehash)
+		return;
+
+	/* Note that tcp_jiffies32 can wrap; we detect wraps by checking for
+	 * cases where the max suspension end is before the actual suspension
+	 * end. We clear pause_until to 0 to indicate there is no recent
+	 * RTO event that constrains PLB rehashing.
+	 */
+	max_suspend = 2 * READ_ONCE(net->ipv4.sysctl_tcp_plb_suspend_rto_sec) * HZ;
+	if (plb->pause_until &&
+	    (!before(tcp_jiffies32, plb->pause_until) ||
+	     before(tcp_jiffies32 + max_suspend, plb->pause_until)))
+		plb->pause_until = 0;
+
+	if (plb->pause_until)
+		return;
+
+	sk_rethink_txhash(sk);
+	plb->consec_cong_rounds = 0;
+}
+EXPORT_SYMBOL_GPL(tcp_plb_check_rehash);
+
+/* Upon RTO, disallow load balancing for a while, to avoid having load
+ * balancing decisions switch traffic to a black-holed path that was
+ * previously avoided with a sk_rethink_txhash() call at RTO time.
+ */
+void tcp_plb_update_state_upon_rto(struct sock *sk, struct tcp_plb_state *plb)
+{
+	struct net *net = sock_net(sk);
+	u32 pause;
+
+	if (!READ_ONCE(net->ipv4.sysctl_tcp_plb_enabled))
+		return;
+
+	pause = READ_ONCE(net->ipv4.sysctl_tcp_plb_suspend_rto_sec) * HZ;
+	pause += prandom_u32_max(pause);
+	plb->pause_until = tcp_jiffies32 + pause;
+
+	/* Reset PLB state upon RTO, since an RTO causes a sk_rethink_txhash() call
+	 * that may switch this connection to a path with completely different
+	 * congestion characteristics.
+	 */
+	plb->consec_cong_rounds = 0;
+}
+EXPORT_SYMBOL_GPL(tcp_plb_update_state_upon_rto);
-- 
2.38.0.135.g90850a2211-goog

