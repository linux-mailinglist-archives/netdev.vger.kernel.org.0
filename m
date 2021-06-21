Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65DC53AE163
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 03:39:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230274AbhFUBlO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Jun 2021 21:41:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230186AbhFUBlK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Jun 2021 21:41:10 -0400
Received: from mail-qv1-xf2a.google.com (mail-qv1-xf2a.google.com [IPv6:2607:f8b0:4864:20::f2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72CEFC061766;
        Sun, 20 Jun 2021 18:38:56 -0700 (PDT)
Received: by mail-qv1-xf2a.google.com with SMTP id dj3so6659323qvb.11;
        Sun, 20 Jun 2021 18:38:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=6OYdRpBLs7VDSwhTJfhbtTJc4ISXR6JPdRpeI95wWus=;
        b=AXPNsbR5ETPLXBRpUMaNbDdLz2uMRoOLu6y/i/p1B9nN8xMduLAEhE9ChrOq4CNCE8
         C6FYPXUhlChP+d9dQ7vhrm8yQfAqviaLT/w+Mwvb44RfZFqpCiG0uSMaylMp7oPSprtz
         0m/jtHwE3fFUAXFiPhBOs/YxZK+R6TppCYHe/LLvSDHPGFWvjQEnICfCxStWSPzVc3qr
         4l2scFNLTYuOyXd7DuJfKmz8m1TWmbeG9BqVxIClsG37YMlDkuElxH9UZlSWN8hcCNnn
         bCbwAXIidb6+hKu07xeGF2t8GjckU877PVL5DzZhDY27lmm/AereAb18lZHFckzoW1wP
         KO6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6OYdRpBLs7VDSwhTJfhbtTJc4ISXR6JPdRpeI95wWus=;
        b=fkcryEsMvln3jF/5n3sVZz2ohGUywp3gv8ix/XeZtqVce1FFp0yItoKFusv76zmROz
         uIDHmCw4DKtLFKtnu9QXcfnrRu+vuZ27sGCYBZYtV9sfr36j+kqxqHC4RTEZFc2M9+Ti
         /V27+BeE6U6L2yq/cj5kYTi4RuvsMAROV9pJBT/hO5EUE6JdNXM5tLM4lsNKy8gCRf9f
         lazbu8WylV3wXlbADV6xhtAU2gUxdPJCVyvR6kYLJO0ypdHRlceuqynU+Ubm9Lh7QAqG
         PLmP8AQ1DY5PNKK5c2KmmuaTgMnBHvD5es90tFYaCgUeRllWbUpgBoGfIXdJKWHcTR/B
         S+TA==
X-Gm-Message-State: AOAM5325Qg9/HtfjpRNa2XU9hz/rSi+xMMPzzebq9Ra+KXTbUhFnZO/F
        KRktDNLtkYK1svhIwJ5Qm/VvDGaogSwy/Q==
X-Google-Smtp-Source: ABdhPJzLTkBQQJ8UbsGRJZFlB8/vpHTeNLqpiUMh3XcGd+CPt09zDoQO5wnDjoehe8BwpKGQhmebig==
X-Received: by 2002:a0c:e18c:: with SMTP id p12mr9057333qvl.54.1624239535465;
        Sun, 20 Jun 2021 18:38:55 -0700 (PDT)
Received: from localhost (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id u18sm9710045qta.38.2021.06.20.18.38.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Jun 2021 18:38:55 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, davem@davemloft.net,
        kuba@kernel.org,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        linux-sctp@vger.kernel.org
Subject: [PATCH net-next 04/14] sctp: add the constants/variables and states and some APIs for transport
Date:   Sun, 20 Jun 2021 21:38:39 -0400
Message-Id: <b8feee9f979260dd24d563bb3f95d2c9a47a8db5.1624239422.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1624239422.git.lucien.xin@gmail.com>
References: <cover.1624239422.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These are 4 constants described in rfc8899#section-5.1.2:

  MAX_PROBES, MIN_PLPMTU, MAX_PLPMTU, BASE_PLPMTU;

And 2 variables described in rfc8899#section-5.1.3:

  PROBED_SIZE, PROBE_COUNT;

And 5 states described in rfc8899#section-5.2:

  DISABLED, BASE, SEARCH, SEARCH_COMPLETE, ERROR;

And these 4 APIs are used to reset/update PLPMTUD, check if PLPMTUD is
enabled, and calculate the additional headers length for a transport.

Note the member 'probe_high' in transport will be set to the probe
size when a probe fails with this probe size in the next patches.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 include/net/sctp/constants.h | 17 +++++++++++++
 include/net/sctp/sctp.h      | 48 +++++++++++++++++++++++++++++++++---
 include/net/sctp/structs.h   |  8 ++++++
 3 files changed, 70 insertions(+), 3 deletions(-)

diff --git a/include/net/sctp/constants.h b/include/net/sctp/constants.h
index 449cf9cb428b..85f6a105c59d 100644
--- a/include/net/sctp/constants.h
+++ b/include/net/sctp/constants.h
@@ -200,6 +200,23 @@ enum sctp_sock_state {
 	SCTP_SS_CLOSING        = TCP_CLOSE_WAIT,
 };
 
+enum sctp_plpmtud_state {
+	SCTP_PL_DISABLED,
+	SCTP_PL_BASE,
+	SCTP_PL_SEARCH,
+	SCTP_PL_COMPLETE,
+	SCTP_PL_ERROR,
+};
+
+#define	SCTP_BASE_PLPMTU	1200
+#define	SCTP_MAX_PLPMTU		9000
+#define	SCTP_MIN_PLPMTU		512
+
+#define	SCTP_MAX_PROBES		3
+
+#define SCTP_PL_BIG_STEP	32
+#define SCTP_PL_MIN_STEP	4
+
 /* These functions map various type to printable names.  */
 const char *sctp_cname(const union sctp_subtype id);	/* chunk types */
 const char *sctp_oname(const union sctp_subtype id);	/* other events */
diff --git a/include/net/sctp/sctp.h b/include/net/sctp/sctp.h
index 86f74f2fe6de..08347d3f004f 100644
--- a/include/net/sctp/sctp.h
+++ b/include/net/sctp/sctp.h
@@ -573,14 +573,15 @@ static inline struct dst_entry *sctp_transport_dst_check(struct sctp_transport *
 /* Calculate max payload size given a MTU, or the total overhead if
  * given MTU is zero
  */
-static inline __u32 sctp_mtu_payload(const struct sctp_sock *sp,
-				     __u32 mtu, __u32 extra)
+static inline __u32 __sctp_mtu_payload(const struct sctp_sock *sp,
+				       const struct sctp_transport *t,
+				       __u32 mtu, __u32 extra)
 {
 	__u32 overhead = sizeof(struct sctphdr) + extra;
 
 	if (sp) {
 		overhead += sp->pf->af->net_header_len;
-		if (sp->udp_port)
+		if (sp->udp_port && (!t || t->encap_port))
 			overhead += sizeof(struct udphdr);
 	} else {
 		overhead += sizeof(struct ipv6hdr);
@@ -592,6 +593,12 @@ static inline __u32 sctp_mtu_payload(const struct sctp_sock *sp,
 	return mtu ? mtu - overhead : overhead;
 }
 
+static inline __u32 sctp_mtu_payload(const struct sctp_sock *sp,
+				     __u32 mtu, __u32 extra)
+{
+	return __sctp_mtu_payload(sp, NULL, mtu, extra);
+}
+
 static inline __u32 sctp_dst_mtu(const struct dst_entry *dst)
 {
 	return SCTP_TRUNC4(max_t(__u32, dst_mtu(dst),
@@ -615,6 +622,41 @@ static inline __u32 sctp_min_frag_point(struct sctp_sock *sp, __u16 datasize)
 	return sctp_mtu_payload(sp, SCTP_DEFAULT_MINSEGMENT, datasize);
 }
 
+static inline int sctp_transport_pl_hlen(struct sctp_transport *t)
+{
+	return __sctp_mtu_payload(sctp_sk(t->asoc->base.sk), t, 0, 0);
+}
+
+static inline void sctp_transport_pl_reset(struct sctp_transport *t)
+{
+	if (t->probe_interval && (t->param_flags & SPP_PMTUD_ENABLE) &&
+	    (t->state == SCTP_ACTIVE || t->state == SCTP_UNKNOWN)) {
+		if (t->pl.state == SCTP_PL_DISABLED) {
+			t->pl.state = SCTP_PL_BASE;
+			t->pl.pmtu = SCTP_BASE_PLPMTU;
+			t->pl.probe_size = SCTP_BASE_PLPMTU;
+		}
+	} else {
+		if (t->pl.state != SCTP_PL_DISABLED)
+			t->pl.state = SCTP_PL_DISABLED;
+	}
+}
+
+static inline void sctp_transport_pl_update(struct sctp_transport *t)
+{
+	if (t->pl.state == SCTP_PL_DISABLED)
+		return;
+
+	t->pl.state = SCTP_PL_BASE;
+	t->pl.pmtu = SCTP_BASE_PLPMTU;
+	t->pl.probe_size = SCTP_BASE_PLPMTU;
+}
+
+static inline bool sctp_transport_pl_enabled(struct sctp_transport *t)
+{
+	return t->pl.state != SCTP_PL_DISABLED;
+}
+
 static inline bool sctp_newsk_ready(const struct sock *sk)
 {
 	return sock_flag(sk, SOCK_DEAD) || sk->sk_socket;
diff --git a/include/net/sctp/structs.h b/include/net/sctp/structs.h
index bf5d22deaefb..85d3566c2227 100644
--- a/include/net/sctp/structs.h
+++ b/include/net/sctp/structs.h
@@ -978,6 +978,14 @@ struct sctp_transport {
 		char cacc_saw_newack;
 	} cacc;
 
+	struct {
+		__u16 pmtu;
+		__u16 probe_size;
+		__u16 probe_high;
+		__u8 probe_count;
+		__u8 state;
+	} pl; /* plpmtud related */
+
 	/* 64-bit random number sent with heartbeat. */
 	__u64 hb_nonce;
 
-- 
2.27.0

