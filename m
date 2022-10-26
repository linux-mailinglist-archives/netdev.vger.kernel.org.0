Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52BE260E298
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 15:51:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233731AbiJZNv5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 09:51:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233390AbiJZNvf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 09:51:35 -0400
Received: from mail-qt1-x832.google.com (mail-qt1-x832.google.com [IPv6:2607:f8b0:4864:20::832])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5772FDF58
        for <netdev@vger.kernel.org>; Wed, 26 Oct 2022 06:51:34 -0700 (PDT)
Received: by mail-qt1-x832.google.com with SMTP id x3so2910771qtj.12
        for <netdev@vger.kernel.org>; Wed, 26 Oct 2022 06:51:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=I1xdt8YxtrunIbam4qK/Ubf49CiTQ9eeLUUQIjmo/H0=;
        b=FkrSUfFvmZNJK4QAMi8C2CvDv54toU0RHbwvgegMEJF9sm8VwdvAyBimSGf6eemyBP
         jvI5d4rGf3LFTI0jeZWYJ2YeZgqKWqZ4cdubJfFtRXzMRKcaIychPTtwvI33/N815LBH
         hXeAoNbwVveY7M46IQ214k4oTWF+0blfp5CgJPvwwd9haEtb54epSOEUTuzaDTRsdQIb
         C9q44p2N54knuVaicJKOGaVNBI1YMW5U/mYMg3ZCQ7VuGmQbJ0qK2WZuqshhgK2+6K6B
         cuX1ERTFWllNkDDREEOXcAktv6ad6RuHrp+Cz+vkvIWbjW+uFd8dXnLMvfVmjLChd/K2
         6SyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=I1xdt8YxtrunIbam4qK/Ubf49CiTQ9eeLUUQIjmo/H0=;
        b=KEpLfD5IEIKRDK3qnGRVjRJ0Y+pz9a5P7RmylhsCWPqn8jDxYZ63C3tWhmCt57LoFR
         1HG5g1B3Z1XgAeW6aeX7cysb+3iv6Dmf+c/lamVNKvAwbw2wXr1tQcUcodzg9Kv4CIBX
         KCuc7Pn6HwUaFXsNDqVVMc2QjcEd93YBGx8IuYp/ZhhOJeFCQvwMCm42PBqGV2oHxgpn
         5S+Ab1IFIdDaSIqt7eYEoqWMqP9X1L/c5dhhofVXTuUnE3XAP0VfHfZX8sJFa5lX68Ne
         RU7yJZjVDfOFBTRR4qbso/qJeQlRJ1turh1HDODIIQJrV0Q2GH0nTLyU+rmiuxXW/wiO
         ZzIw==
X-Gm-Message-State: ACrzQf33ZPG6srlDmBkjxpTE1FqPnpsovV7Arj4AqAy6r+4OpBrfahEx
        QVgFN9UW51ohPzxEDfGDMFw=
X-Google-Smtp-Source: AMsMyM5g55JKk9mgef3P+8zP5Z/aw5igsLqpD84zLmIh2fGXiRFIwPwcaG8qQBf4DBkNktCFDlHO3A==
X-Received: by 2002:ac8:5791:0:b0:39c:f20f:b7f5 with SMTP id v17-20020ac85791000000b0039cf20fb7f5mr35760932qta.360.1666792293335;
        Wed, 26 Oct 2022 06:51:33 -0700 (PDT)
Received: from mubashirq.c.googlers.com.com (74.206.145.34.bc.googleusercontent.com. [34.145.206.74])
        by smtp.gmail.com with ESMTPSA id b24-20020ac84f18000000b00397101ac0f2sm3211836qte.3.2022.10.26.06.51.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Oct 2022 06:51:32 -0700 (PDT)
From:   Mubashir Adnan Qureshi <mubashirmaq@gmail.com>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org,
        Mubashir Adnan Qureshi <mubashirq@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Eric Dumazet <edumazet@google.com>
Subject: [PATCH net-next 4/5] tcp: add u32 counter in tcp_sock and an SNMP counter for PLB
Date:   Wed, 26 Oct 2022 13:51:14 +0000
Message-Id: <20221026135115.3539398-5-mubashirmaq@gmail.com>
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

A u32 counter is added to tcp_sock for counting the number of PLB
triggered rehashes for a TCP connection. An SNMP counter is also
added to count overall PLB triggered rehash events for a host. These
counters are hooked up to PLB implementation for DCTCP.

TCP_NLA_REHASH is added to SCM_TIMESTAMPING_OPT_STATS that reports
the rehash attempts triggered due to PLB or timeouts. This gives
a historical view of sustained congestion or timeouts experienced
by the TCP connection.

Signed-off-by: Mubashir Adnan Qureshi <mubashirq@google.com>
Signed-off-by: Yuchung Cheng <ycheng@google.com>
Signed-off-by: Neal Cardwell <ncardwell@google.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
---
 include/linux/tcp.h       | 1 +
 include/uapi/linux/snmp.h | 1 +
 include/uapi/linux/tcp.h  | 1 +
 net/ipv4/proc.c           | 1 +
 net/ipv4/tcp.c            | 3 +++
 net/ipv4/tcp_plb.c        | 2 ++
 6 files changed, 9 insertions(+)

diff --git a/include/linux/tcp.h b/include/linux/tcp.h
index 41b1da621a45..ca7f05a130d2 100644
--- a/include/linux/tcp.h
+++ b/include/linux/tcp.h
@@ -423,6 +423,7 @@ struct tcp_sock {
 		u32		  probe_seq_start;
 		u32		  probe_seq_end;
 	} mtu_probe;
+	u32     plb_rehash;     /* PLB-triggered rehash attempts */
 	u32	mtu_info; /* We received an ICMP_FRAG_NEEDED / ICMPV6_PKT_TOOBIG
 			   * while socket was owned by user.
 			   */
diff --git a/include/uapi/linux/snmp.h b/include/uapi/linux/snmp.h
index 4d7470036a8b..6600cb0164c2 100644
--- a/include/uapi/linux/snmp.h
+++ b/include/uapi/linux/snmp.h
@@ -292,6 +292,7 @@ enum
 	LINUX_MIB_TCPDSACKIGNOREDDUBIOUS,	/* TCPDSACKIgnoredDubious */
 	LINUX_MIB_TCPMIGRATEREQSUCCESS,		/* TCPMigrateReqSuccess */
 	LINUX_MIB_TCPMIGRATEREQFAILURE,		/* TCPMigrateReqFailure */
+	LINUX_MIB_TCPPLBREHASH,			/* TCPPLBRehash */
 	__LINUX_MIB_MAX
 };
 
diff --git a/include/uapi/linux/tcp.h b/include/uapi/linux/tcp.h
index 8fc09e8638b3..c9abe86eda5f 100644
--- a/include/uapi/linux/tcp.h
+++ b/include/uapi/linux/tcp.h
@@ -315,6 +315,7 @@ enum {
 	TCP_NLA_BYTES_NOTSENT,	/* Bytes in write queue not yet sent */
 	TCP_NLA_EDT,		/* Earliest departure time (CLOCK_MONOTONIC) */
 	TCP_NLA_TTL,		/* TTL or hop limit of a packet received */
+	TCP_NLA_REHASH,         /* PLB and timeout triggered rehash attempts */
 };
 
 /* for TCP_MD5SIG socket option */
diff --git a/net/ipv4/proc.c b/net/ipv4/proc.c
index 5386f460bd20..f88daace9de3 100644
--- a/net/ipv4/proc.c
+++ b/net/ipv4/proc.c
@@ -297,6 +297,7 @@ static const struct snmp_mib snmp4_net_list[] = {
 	SNMP_MIB_ITEM("TCPDSACKIgnoredDubious", LINUX_MIB_TCPDSACKIGNOREDDUBIOUS),
 	SNMP_MIB_ITEM("TCPMigrateReqSuccess", LINUX_MIB_TCPMIGRATEREQSUCCESS),
 	SNMP_MIB_ITEM("TCPMigrateReqFailure", LINUX_MIB_TCPMIGRATEREQFAILURE),
+	SNMP_MIB_ITEM("TCPPLBRehash", LINUX_MIB_TCPPLBREHASH),
 	SNMP_MIB_SENTINEL
 };
 
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index ef14efa1fb70..1da7c53b6cb5 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -3176,6 +3176,7 @@ int tcp_disconnect(struct sock *sk, int flags)
 	tp->sacked_out = 0;
 	tp->tlp_high_seq = 0;
 	tp->last_oow_ack_time = 0;
+	tp->plb_rehash = 0;
 	/* There's a bubble in the pipe until at least the first ACK. */
 	tp->app_limited = ~0U;
 	tp->rack.mstamp = 0;
@@ -3973,6 +3974,7 @@ static size_t tcp_opt_stats_get_size(void)
 		nla_total_size(sizeof(u32)) + /* TCP_NLA_BYTES_NOTSENT */
 		nla_total_size_64bit(sizeof(u64)) + /* TCP_NLA_EDT */
 		nla_total_size(sizeof(u8)) + /* TCP_NLA_TTL */
+		nla_total_size(sizeof(u32)) + /* TCP_NLA_REHASH */
 		0;
 }
 
@@ -4049,6 +4051,7 @@ struct sk_buff *tcp_get_timestamping_opt_stats(const struct sock *sk,
 		nla_put_u8(stats, TCP_NLA_TTL,
 			   tcp_skb_ttl_or_hop_limit(ack_skb));
 
+	nla_put_u32(stats, TCP_NLA_REHASH, tp->plb_rehash + tp->timeout_rehash);
 	return stats;
 }
 
diff --git a/net/ipv4/tcp_plb.c b/net/ipv4/tcp_plb.c
index f4ced370acad..bb1a08fda113 100644
--- a/net/ipv4/tcp_plb.c
+++ b/net/ipv4/tcp_plb.c
@@ -79,6 +79,8 @@ void tcp_plb_check_rehash(struct sock *sk, struct tcp_plb_state *plb)
 
 	sk_rethink_txhash(sk);
 	plb->consec_cong_rounds = 0;
+	tcp_sk(sk)->plb_rehash++;
+	NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPPLBREHASH);
 }
 EXPORT_SYMBOL_GPL(tcp_plb_check_rehash);
 
-- 
2.38.0.135.g90850a2211-goog

