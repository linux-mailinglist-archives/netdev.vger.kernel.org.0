Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54CB859BC72
	for <lists+netdev@lfdr.de>; Mon, 22 Aug 2022 11:14:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234046AbiHVJNN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 05:13:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234247AbiHVJMp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 05:12:45 -0400
Received: from mail-qk1-x735.google.com (mail-qk1-x735.google.com [IPv6:2607:f8b0:4864:20::735])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 079D62FFE8;
        Mon, 22 Aug 2022 02:12:13 -0700 (PDT)
Received: by mail-qk1-x735.google.com with SMTP id j6so7369037qkl.10;
        Mon, 22 Aug 2022 02:12:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=2ea0wBQW9PkB6wUzKzt6kw1w9f7ZFMFItxwkN5Ui76I=;
        b=m1rksws9JQWcPB9p0mF6gjYGfRzBOHLQR3wkiwQMRchKOxskgKChiS+fWSRaRIIST0
         l+OJg3Ag3nY1FklQmbzzonq56gL8OoMu4foV4SYhJs57rowKEIpWwaGMYJoD2xETeNFK
         +o3N8YMF+PnVCcFlsn6yMAHQzswXOu0JgKHTkzz5kqcEQEMIMaDRefI/tRibZUZ1jSVT
         uaaho9ZolWCVIvztzk/igJLm3d0SucnKTSNa1Eeip0qK/292pOh9zdLAHBKKqHNHpqHc
         0JEc11rUtTe17oUkkCi/soQWFgii0lkE1Ek9ltBDlE5tTfj3T1rumiRY3JTs4xNAXb5r
         2cgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=2ea0wBQW9PkB6wUzKzt6kw1w9f7ZFMFItxwkN5Ui76I=;
        b=S7sO+8deN6fHLx2wn1aEgWImMT+XoaOCE8VEiT8PwOLmBhzS+XQG1CZhRWMiGfZJfW
         KjtEqwB3iT9qKuo7BuQH5nTz8G7nkjEtJGs0wsg9E4vA5OFgd57N5J6C3wDzMWEcK3jG
         jYI15AvoOrKK/Q5Z/ocZ5ZaTf/SCWhEu4gfRJNbq3kgBj6Aw1F07s79jEzi0Rsz9zTaB
         VDPztSURb+87rwlbbcBH/oLF08E755OrRInX4D59YfnXOlZsRuLSe35fIoI/K3qftS+u
         UMMnLS6fPTqb8EUss6aXMtHF6JHhzNiDyfOjGMmOJXgRc8exCTzdC1iLF1pcakFb8qlR
         /7Ig==
X-Gm-Message-State: ACgBeo0b42m4IM9g9D3Gpfj3Yk9EjsocvxvwSua/iGdZAaIbAenv87ck
        zotUiQp128kM8kRME2EWdPUsPPAprg==
X-Google-Smtp-Source: AA6agR4FiUN86wqTYFjOD1AoH2apImNQYxd/cveD5lRCMGech/b0wr3QXo5orTFFQphusFu7xjln5w==
X-Received: by 2002:a37:444f:0:b0:6bb:186e:345e with SMTP id r76-20020a37444f000000b006bb186e345emr11943251qka.105.1661159532536;
        Mon, 22 Aug 2022 02:12:12 -0700 (PDT)
Received: from bytedance.attlocal.net (ec2-52-52-7-82.us-west-1.compute.amazonaws.com. [52.52.7.82])
        by smtp.gmail.com with ESMTPSA id n16-20020ac85a10000000b00344883d3ef8sm9103416qta.84.2022.08.22.02.12.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Aug 2022 02:12:12 -0700 (PDT)
From:   Peilin Ye <yepeilin.cs@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>
Cc:     Peilin Ye <peilin.ye@bytedance.com>, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Cong Wang <cong.wang@bytedance.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Dave Taht <dave.taht@gmail.com>,
        Peilin Ye <yepeilin.cs@gmail.com>
Subject: [PATCH RFC v2 net-next 1/5] net: Introduce Qdisc backpressure infrastructure
Date:   Mon, 22 Aug 2022 02:11:44 -0700
Message-Id: <7e5bd29f232d42d6aa94ff818a778de707203406.1661158173.git.peilin.ye@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1661158173.git.peilin.ye@bytedance.com>
References: <cover.1661158173.git.peilin.ye@bytedance.com>
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

From: Peilin Ye <peilin.ye@bytedance.com>

Currently sockets (especially UDP ones) can drop a lot of traffic at TC
egress when rate limited by shaper Qdiscs like HTB.  Improve this by
introducing a Qdisc backpressure infrastructure:

  a. A new 'sock struct' field, @sk_overlimits, which keeps track of the
     number of bytes in socket send buffer that are currently
     unavailable due to TC egress congestion.  The size of an overlimit
     socket's "effective" send buffer is represented by @sk_sndbuf minus
     @sk_overlimits, with a lower limit of SOCK_MIN_SNDBUF:

     max(@sk_sndbuf - @sk_overlimits, SOCK_MIN_SNDBUF)

  b. A new (*backpressure) 'struct proto' callback, which is the
     protocol's private algorithm for Qdisc backpressure.

Working together:

  1. When a shaper Qdisc (TBF, HTB, CBQ, etc.) drops a packet that
     belongs to a local socket, it calls qdisc_backpressure().

  2. qdisc_backpressure() eventually invokes the socket protocol's
     (*backpressure) callback, which should increase @sk_overlimits.

  3. The transport layer then sees a smaller "effective" send buffer and
     will send slower.

  4. It is the per-protocol (*backpressure) implementation's
     responsibility to decrease @sk_overlimits when TC egress becomes
     idle again, potentially by using a timer.

Suggested-by: Cong Wang <cong.wang@bytedance.com>
Signed-off-by: Peilin Ye <peilin.ye@bytedance.com>
---
 include/net/sch_generic.h | 11 +++++++++++
 include/net/sock.h        | 21 +++++++++++++++++++++
 net/core/sock.c           |  1 +
 3 files changed, 33 insertions(+)

diff --git a/include/net/sch_generic.h b/include/net/sch_generic.h
index ec693fe7c553..afdf4bf64936 100644
--- a/include/net/sch_generic.h
+++ b/include/net/sch_generic.h
@@ -19,6 +19,7 @@
 #include <net/gen_stats.h>
 #include <net/rtnetlink.h>
 #include <net/flow_offload.h>
+#include <net/sock.h>
 
 struct Qdisc_ops;
 struct qdisc_walker;
@@ -1188,6 +1189,16 @@ static inline int qdisc_drop_all(struct sk_buff *skb, struct Qdisc *sch,
 	return NET_XMIT_DROP;
 }
 
+static inline void qdisc_backpressure(struct sk_buff *skb)
+{
+	struct sock *sk = skb->sk;
+
+	if (!sk || !sk_fullsock(sk))
+		return;
+
+	sk_backpressure(sk);
+}
+
 /* Length to Time (L2T) lookup in a qdisc_rate_table, to determine how
    long it will take to send a packet given its size.
  */
diff --git a/include/net/sock.h b/include/net/sock.h
index 05a1bbdf5805..ef10ca66cf26 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -277,6 +277,7 @@ struct sk_filter;
   *	@sk_pacing_status: Pacing status (requested, handled by sch_fq)
   *	@sk_max_pacing_rate: Maximum pacing rate (%SO_MAX_PACING_RATE)
   *	@sk_sndbuf: size of send buffer in bytes
+  *	@sk_overlimits: size of temporarily unavailable send buffer in bytes
   *	@__sk_flags_offset: empty field used to determine location of bitfield
   *	@sk_padding: unused element for alignment
   *	@sk_no_check_tx: %SO_NO_CHECK setting, set checksum in TX packets
@@ -439,6 +440,7 @@ struct sock {
 	struct dst_entry __rcu	*sk_dst_cache;
 	atomic_t		sk_omem_alloc;
 	int			sk_sndbuf;
+	int			sk_overlimits;
 
 	/* ===== cache line for TX ===== */
 	int			sk_wmem_queued;
@@ -1264,6 +1266,7 @@ struct proto {
 
 	bool			(*stream_memory_free)(const struct sock *sk, int wake);
 	bool			(*sock_is_readable)(struct sock *sk);
+	void			(*backpressure)(struct sock *sk);
 	/* Memory pressure */
 	void			(*enter_memory_pressure)(struct sock *sk);
 	void			(*leave_memory_pressure)(struct sock *sk);
@@ -2499,6 +2502,24 @@ static inline void sk_stream_moderate_sndbuf(struct sock *sk)
 	WRITE_ONCE(sk->sk_sndbuf, max_t(u32, val, SOCK_MIN_SNDBUF));
 }
 
+static inline int sk_sndbuf_avail(struct sock *sk)
+{
+	int overlimits, sndbuf = READ_ONCE(sk->sk_sndbuf);
+
+	if (!sk->sk_prot->backpressure)
+		return sndbuf;
+
+	overlimits = READ_ONCE(sk->sk_overlimits);
+
+	return max_t(int, sndbuf - overlimits, SOCK_MIN_SNDBUF);
+}
+
+static inline void sk_backpressure(struct sock *sk)
+{
+	if (sk->sk_prot->backpressure)
+		sk->sk_prot->backpressure(sk);
+}
+
 /**
  * sk_page_frag - return an appropriate page_frag
  * @sk: socket
diff --git a/net/core/sock.c b/net/core/sock.c
index 4cb957d934a2..167d471b176f 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -2194,6 +2194,7 @@ struct sock *sk_clone_lock(const struct sock *sk, const gfp_t priority)
 
 	/* sk_wmem_alloc set to one (see sk_free() and sock_wfree()) */
 	refcount_set(&newsk->sk_wmem_alloc, 1);
+	newsk->sk_overlimits	= 0;
 
 	atomic_set(&newsk->sk_omem_alloc, 0);
 	sk_init_common(newsk);
-- 
2.20.1

