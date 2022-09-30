Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A5C85F03F7
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 06:56:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230507AbiI3Ezm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 00:55:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230193AbiI3Ez3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 00:55:29 -0400
Received: from mail-qk1-x72e.google.com (mail-qk1-x72e.google.com [IPv6:2607:f8b0:4864:20::72e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E06B115BDE
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 21:55:07 -0700 (PDT)
Received: by mail-qk1-x72e.google.com with SMTP id i17so2167360qkk.12
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 21:55:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=bc+iFbFWXwF9CHw32ftfzShfDEeqnlGNgX0fMuKNr/k=;
        b=gVBjV19gqR0nBEFrgldD/UjuPKw/7T3Bkq4W4ur1WaYob+4c9NqKvO3iv78yhAsxbj
         G5LDFaiQ8401+obQhmWMqUkqCxEHFMyJf6qtv9Aqh5KptWPMrFvpLROwW66wb7DQlDG9
         uijFF3fK4Ln6f5H91ajcuoZpRnVuLOgMGUz7J3g5S680sU48W41AEJNzrKrhzHTZ/PJw
         gftJ8wUVBnV5guPLcubvR4Rn2Oay5khpAUHfjganIUyM5SJhN3GB+PhAM+ykkCj4SHLR
         N+iU2ILSJ8BKCxzYtUdK7CpNVIr1hw6BFTAuDqF+W6MYIGKof1y3/JsRJHnPqJFKMtMv
         KxMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=bc+iFbFWXwF9CHw32ftfzShfDEeqnlGNgX0fMuKNr/k=;
        b=4oBvW0ElFcV1+aoRTmUUYIZ32/oBg8dhSRS4NhT+9lPd2nD0VPXOq8eWUE8cS+CPbG
         uqh173E8EYa4E0rdPeo+iLgn6UMVGcf1Q7y5PuHXIhmsiQnLDPPnDlPFtGiXrmcMnX9y
         WIpMxA7TNFkk1ki7ix+orT3//Df2W8xz5tj7Y3amKCZz7z+APItDt+MPbQ0AyrMFhWe8
         eg7tFmEBfnwSFn5mC2OtoH5G2a9RrEB/v2VoP7qUMP8CdU/C3UdCkw4kmMR4wqgHJqx1
         dBjnUsJPPX7wLFbEw1HCM14O4e/z335sBYl3Ti8XTOINE/7YyHTIPNkJhDaW9BijiX4C
         t5oQ==
X-Gm-Message-State: ACrzQf0RDRwFg4bM//p3bHojWUIgNtkb0LL00kgtV2bWo0d2KfpNfBhy
        sborVBlA4Kn+VielhnlnTqI=
X-Google-Smtp-Source: AMsMyM6gOoa0Df/hfET+CznaLC1kv8anmVQ/M69K9cT95Au92Puh82Yd7HbcISK1Y7uqFVMqGGFBrQ==
X-Received: by 2002:a05:620a:4013:b0:6ce:a0ff:13da with SMTP id h19-20020a05620a401300b006cea0ff13damr4776600qko.530.1664513636032;
        Thu, 29 Sep 2022 21:53:56 -0700 (PDT)
Received: from mubashirq.c.googlers.com.com (74.206.145.34.bc.googleusercontent.com. [34.145.206.74])
        by smtp.gmail.com with ESMTPSA id de9-20020a05620a370900b006bb82221013sm1550059qkb.0.2022.09.29.21.53.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Sep 2022 21:53:55 -0700 (PDT)
From:   Mubashir Adnan Qureshi <mubashirmaq@gmail.com>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, kuba@kernel.org,
        Mubashir Adnan Qureshi <mubashirq@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Eric Dumazet <edumazet@google.com>
Subject: [PATCH net-next v2 4/5] tcp: add u32 counter in tcp_sock and an SNMP counter for PLB
Date:   Fri, 30 Sep 2022 04:53:19 +0000
Message-Id: <20220930045320.5252-5-mubashirmaq@gmail.com>
X-Mailer: git-send-email 2.38.0.rc1.362.ged0d419d3c-goog
In-Reply-To: <20220930045320.5252-1-mubashirmaq@gmail.com>
References: <20220929142447.3821638-1-mubashirmaq@gmail.com>
 <20220930045320.5252-1-mubashirmaq@gmail.com>
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
index a9fbe22732c3..332870bb09fc 100644
--- a/include/linux/tcp.h
+++ b/include/linux/tcp.h
@@ -417,6 +417,7 @@ struct tcp_sock {
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
index 648b5c54bb32..685c06c6d33f 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -3173,6 +3173,7 @@ int tcp_disconnect(struct sock *sk, int flags)
 	tp->sacked_out = 0;
 	tp->tlp_high_seq = 0;
 	tp->last_oow_ack_time = 0;
+	tp->plb_rehash = 0;
 	/* There's a bubble in the pipe until at least the first ACK. */
 	tp->app_limited = ~0U;
 	tp->rack.mstamp = 0;
@@ -3969,6 +3970,7 @@ static size_t tcp_opt_stats_get_size(void)
 		nla_total_size(sizeof(u32)) + /* TCP_NLA_BYTES_NOTSENT */
 		nla_total_size_64bit(sizeof(u64)) + /* TCP_NLA_EDT */
 		nla_total_size(sizeof(u8)) + /* TCP_NLA_TTL */
+		nla_total_size(sizeof(u32)) + /* TCP_NLA_REHASH */
 		0;
 }
 
@@ -4045,6 +4047,7 @@ struct sk_buff *tcp_get_timestamping_opt_stats(const struct sock *sk,
 		nla_put_u8(stats, TCP_NLA_TTL,
 			   tcp_skb_ttl_or_hop_limit(ack_skb));
 
+	nla_put_u32(stats, TCP_NLA_REHASH, tp->plb_rehash + tp->timeout_rehash);
 	return stats;
 }
 
diff --git a/net/ipv4/tcp_plb.c b/net/ipv4/tcp_plb.c
index 26ffc5a45f53..04f4cac8645b 100644
--- a/net/ipv4/tcp_plb.c
+++ b/net/ipv4/tcp_plb.c
@@ -73,6 +73,8 @@ void tcp_plb_check_rehash(struct sock *sk, struct tcp_plb_state *plb)
 	if (!plb->pause_until && (can_idle_rehash || can_force_rehash)) {
 		sk_rethink_txhash(sk);
 		plb->consec_cong_rounds = 0;
+		tcp_sk(sk)->plb_rehash++;
+		NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPPLBREHASH);
 	}
 }
 EXPORT_SYMBOL_GPL(tcp_plb_check_rehash);
-- 
2.38.0.rc1.362.ged0d419d3c-goog

