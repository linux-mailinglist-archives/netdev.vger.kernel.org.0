Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 178753B0C77
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 20:08:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232592AbhFVSK7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 14:10:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232482AbhFVSK4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Jun 2021 14:10:56 -0400
Received: from mail-qk1-x735.google.com (mail-qk1-x735.google.com [IPv6:2607:f8b0:4864:20::735])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D9A5C09B04C;
        Tue, 22 Jun 2021 11:05:06 -0700 (PDT)
Received: by mail-qk1-x735.google.com with SMTP id g4so40614245qkl.1;
        Tue, 22 Jun 2021 11:05:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=7qDMDjdLnVAw3SW8RntWwWg7To6cwW6aaie2zIIbJsg=;
        b=RSFEEUexiPgF92aTI5REC/W/j1yhdkvwmUxZ73QCCRtd/y6l8qKurbVKMr66sUUOTD
         AuECr0r1ajtEzwclRDsqRp1n6Sl5uKo6u51ee9BBgDRHSJlXhoZAkSOO+ha5QBNMKkEN
         M3bve7oemMPSgjrOuSYvPjSmO3qjNFqdmYeAO35PNoM3S0R+scqY+nzbCPsPQVeHxuhV
         CYM/K2EvIhJwuv+zoK5NmksoGlPExZEg79O8bIzq/1n8QvpBu1LsA3e9D8TAQdoLgxye
         VGybJ6nw0TV89PwtHjug8BkFPND5f3MEJUoH8J5MGebpfsBzpwbddykOOLxEV9eL3QX8
         AkJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7qDMDjdLnVAw3SW8RntWwWg7To6cwW6aaie2zIIbJsg=;
        b=X4FGhe/wk7gPRXPas6xhRNbRif49Js60CU+WbogswmgBjwVkvoMA1NLUT6FnVbaAoW
         qPk3tNuKllHzhRvnIir+iHnwFE8kdOXxnqp5OciqjBQgGmU2ulbX5hdSWtRWnt9qqYIk
         5p2d+VHjR9wF6eB+uieK7p2VRBIhP4LTtS49Q6XtQM2zvKEuVNOJufAVTi+/GAEq+hcu
         nY67pgHUFQ8sg5MDVzpUQUunDuYL82EfwzYqT4OfD30y+3SjLH9tT/qyqwNob2c0YgK0
         e7QB3wS0qMiQDLfjEei1G17fAcXFmyzNSO7ippufF4UYSt2fKjflpitczhZGHN321jRF
         Bfzw==
X-Gm-Message-State: AOAM530oE+K8AXhB3rwGu/qp8M9v8uUHcLAopA0QiGpr1Nr26xh5DkTE
        N+79jPwR+JQYv4J1Qt8i8RdBZKkmmMFh4Q==
X-Google-Smtp-Source: ABdhPJybTu9RLDSPFVAwshAEkiD7MHNhn4lxNRJPPXKXa1YPZd9WCtAk995LSvdv9/xwDzMI97qyWg==
X-Received: by 2002:a37:4392:: with SMTP id q140mr5831845qka.49.1624385105626;
        Tue, 22 Jun 2021 11:05:05 -0700 (PDT)
Received: from localhost (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id m199sm13665097qke.71.2021.06.22.11.05.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Jun 2021 11:05:05 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, davem@davemloft.net,
        kuba@kernel.org,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        linux-sctp@vger.kernel.org
Subject: [PATCHv2 net-next 04/14] sctp: add the constants/variables and states and some APIs for transport
Date:   Tue, 22 Jun 2021 14:04:50 -0400
Message-Id: <35adbcfcbf2067f01a72dee42ea34a7293565b3d.1624384990.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1624384990.git.lucien.xin@gmail.com>
References: <cover.1624384990.git.lucien.xin@gmail.com>
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
Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
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

