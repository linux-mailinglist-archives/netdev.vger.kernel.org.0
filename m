Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34D525E8349
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 22:15:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232834AbiIWUPp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 16:15:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232712AbiIWUOt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 16:14:49 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 895FC132FF9
        for <netdev@vger.kernel.org>; Fri, 23 Sep 2022 13:14:00 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id s14so1649373wro.0
        for <netdev@vger.kernel.org>; Fri, 23 Sep 2022 13:14:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=KWYH4wJc1huDalh4Bzcd9SpizXnsPuHEOja3imgwmJk=;
        b=I22j0v/FKbyFo0KpbY6AN8wo5WObqr/1r63dXm9m0FwOCjG8hSIIPu19VOR6ZQ6FwZ
         xJxVmDi0k65SQJ18gOwz9hTHK5bSTDQCyza/UTZhyxUzkvcQ+vAtE/0TU+Q2SVsgAYxk
         wsSoBycJPV7rwyGe+BKi87pMYYwIeM/Oe15R7azXstpwFVh/DwKiH7aQnAZGJDeW/MIT
         8Cth05h5dHev8FCpZ1jUBdM400uzfu2X9ILUjlcVQPbqzCbu06Cqd6cTpa3N5JZrIdKI
         0uZDPy1VHdo8BQa2C+w4PO9bi/w6jVH9ol9SisDbICjDpg+j/D6hzHkeUb6X3YVHbElq
         xrRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=KWYH4wJc1huDalh4Bzcd9SpizXnsPuHEOja3imgwmJk=;
        b=NMjHLlt3NbBohApGdJZ4SME7MEEJoiRLPi1G8tvIeNW7idkD/c4rBMQBLPT61eC8XU
         NNgpFVokK2jrbKUq6Ttdpt2ZmYJHJ+Oexhhm+igmmrjLAXOD9T+2sr4/IVOVY5sgz5u2
         lIftUT8dKmtdA92VhBlaMTEvyF4tvnBSkau4TNZAm7HXzM/Nfd9MpyDVms9zAoffDs9J
         2684TWGaUlVnDLR0rf6mH8xdYn0RWWTRMzYk53NfxjJ8MAFF9xwbRiiO39MxlPqkWvon
         zxl7IRHk1s7BWptHDtXCEE4jQLZm/pLsPQ//nAJq6gLVLgquvz96oegFef16xiwew4Hy
         ICWg==
X-Gm-Message-State: ACrzQf2d5gcSRLD2euW49AMnjVyeOjNgNZ5/7aTnMmoEajimexDGDT6y
        7Edxitt8g/xGw8Xc137dvPSD1w==
X-Google-Smtp-Source: AMsMyM79mkz92ooKi6EiNC2nhpngikmQVsjYzQM9s3uvYV3TA3Zq0Q293xFelCCPG7kQ38oHsUBilA==
X-Received: by 2002:adf:dfcd:0:b0:228:d923:873a with SMTP id q13-20020adfdfcd000000b00228d923873amr6440958wrn.256.1663964039655;
        Fri, 23 Sep 2022 13:13:59 -0700 (PDT)
Received: from Mindolluin.ire.aristanetworks.com ([217.173.96.166])
        by smtp.gmail.com with ESMTPSA id k11-20020a05600c0b4b00b003b492753826sm3281056wmr.43.2022.09.23.13.13.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Sep 2022 13:13:59 -0700 (PDT)
From:   Dmitry Safonov <dima@arista.com>
To:     linux-kernel@vger.kernel.org, David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>
Cc:     Dmitry Safonov <dima@arista.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Ard Biesheuvel <ardb@kernel.org>,
        Bob Gilligan <gilligan@arista.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Eric Biggers <ebiggers@kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Ivan Delalande <colona@arista.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Leonard Crestez <cdleonard@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Salam Noureddine <noureddine@arista.com>,
        Shuah Khan <shuah@kernel.org>, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org
Subject: [PATCH v2 21/35] net/tcp: Ignore specific ICMPs for TCP-AO connections
Date:   Fri, 23 Sep 2022 21:13:05 +0100
Message-Id: <20220923201319.493208-22-dima@arista.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220923201319.493208-1-dima@arista.com>
References: <20220923201319.493208-1-dima@arista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Similarly to IPsec, RFC5925 prescribes:
  ">> A TCP-AO implementation MUST default to ignore incoming ICMPv4
  messages of Type 3 (destination unreachable), Codes 2-4 (protocol
  unreachable, port unreachable, and fragmentation needed -- ’hard
  errors’), and ICMPv6 Type 1 (destination unreachable), Code 1
  (administratively prohibited) and Code 4 (port unreachable) intended
  for connections in synchronized states (ESTABLISHED, FIN-WAIT-1, FIN-
  WAIT-2, CLOSE-WAIT, CLOSING, LAST-ACK, TIME-WAIT) that match MKTs."

A selftest (later in patch series) verifies that this attack is not
possible in this TCP-AO implementation.

Co-developed-by: Francesco Ruggeri <fruggeri@arista.com>
Signed-off-by: Francesco Ruggeri <fruggeri@arista.com>
Co-developed-by: Salam Noureddine <noureddine@arista.com>
Signed-off-by: Salam Noureddine <noureddine@arista.com>
Signed-off-by: Dmitry Safonov <dima@arista.com>
---
 include/net/tcp_ao.h      |  9 +++++
 include/uapi/linux/snmp.h |  1 +
 include/uapi/linux/tcp.h  |  1 +
 net/ipv4/proc.c           |  1 +
 net/ipv4/tcp_ao.c         | 70 ++++++++++++++++++++++++++++++++++++++-
 net/ipv4/tcp_ipv4.c       |  5 +++
 net/ipv6/tcp_ipv6.c       |  4 +++
 7 files changed, 90 insertions(+), 1 deletion(-)

diff --git a/include/net/tcp_ao.h b/include/net/tcp_ao.h
index e99c8f300a5a..743a910ba508 100644
--- a/include/net/tcp_ao.h
+++ b/include/net/tcp_ao.h
@@ -25,6 +25,7 @@ struct tcp_ao_counters {
 	atomic64_t	pkt_bad;
 	atomic64_t	key_not_found;
 	atomic64_t	ao_required;
+	atomic64_t	dropped_icmp;
 };
 
 struct tcp_ao_key {
@@ -77,6 +78,9 @@ static inline unsigned int tcp_ao_digest_size(struct tcp_ao_key *key)
 	return key->digest_size;
 }
 
+/* bits in 'ao_flags' */
+#define AO_ACCEPT_ICMPS		BIT(0)
+
 struct tcp_ao_info {
 	struct hlist_head	head;
 	struct rcu_head		rcu;
@@ -169,6 +173,7 @@ u32 tcp_ao_compute_sne(u32 sne, u32 seq, u32 new_seq);
 void tcp_ao_time_wait(struct tcp_timewait_sock *tcptw, struct tcp_sock *tp);
 int tcp_ao_cache_traffic_keys(const struct sock *sk, struct tcp_ao_info *ao,
 			      struct tcp_ao_key *ao_key);
+bool tcp_ao_ignore_icmp(struct sock *sk, int type, int code);
 enum skb_drop_reason tcp_inbound_ao_hash(struct sock *sk,
 			const struct sk_buff *skb, unsigned short int family,
 			const struct request_sock *req,
@@ -239,6 +244,10 @@ void tcp_ao_connect_init(struct sock *sk);
 
 #else /* CONFIG_TCP_AO */
 
+static inline bool tcp_ao_ignore_icmp(struct sock *sk, int type, int code)
+{
+	return false;
+}
 static inline enum skb_drop_reason tcp_inbound_ao_hash(struct sock *sk,
 		const struct sk_buff *skb, unsigned short int family,
 		const struct request_sock *req, const struct tcp_ao_hdr *aoh)
diff --git a/include/uapi/linux/snmp.h b/include/uapi/linux/snmp.h
index f09119db8b40..bc7655394e9a 100644
--- a/include/uapi/linux/snmp.h
+++ b/include/uapi/linux/snmp.h
@@ -296,6 +296,7 @@ enum
 	LINUX_MIB_TCPAOBAD,			/* TCPAOBad */
 	LINUX_MIB_TCPAOKEYNOTFOUND,		/* TCPAOKeyNotFound */
 	LINUX_MIB_TCPAOGOOD,			/* TCPAOGood */
+	LINUX_MIB_TCPAODROPPEDICMPS,		/* TCPAODroppedIcmps */
 	__LINUX_MIB_MAX
 };
 
diff --git a/include/uapi/linux/tcp.h b/include/uapi/linux/tcp.h
index 5369458ae89f..508bedbc6ad8 100644
--- a/include/uapi/linux/tcp.h
+++ b/include/uapi/linux/tcp.h
@@ -349,6 +349,7 @@ struct tcp_diag_md5sig {
 
 #define TCP_AO_CMDF_CURR	(1 << 0)	/* Only checks field sndid */
 #define TCP_AO_CMDF_NEXT	(1 << 1)	/* Only checks field rcvid */
+#define TCP_AO_CMDF_ACCEPT_ICMP	(1 << 2)	/* Accept incoming ICMPs */
 
 struct tcp_ao { /* setsockopt(TCP_AO) */
 	struct __kernel_sockaddr_storage tcpa_addr;
diff --git a/net/ipv4/proc.c b/net/ipv4/proc.c
index 1b5a078adcf1..ccfb7f51e82f 100644
--- a/net/ipv4/proc.c
+++ b/net/ipv4/proc.c
@@ -301,6 +301,7 @@ static const struct snmp_mib snmp4_net_list[] = {
 	SNMP_MIB_ITEM("TCPAOBad", LINUX_MIB_TCPAOBAD),
 	SNMP_MIB_ITEM("TCPAOKeyNotFound", LINUX_MIB_TCPAOKEYNOTFOUND),
 	SNMP_MIB_ITEM("TCPAOGood", LINUX_MIB_TCPAOGOOD),
+	SNMP_MIB_ITEM("TCPAODroppedIcmps", LINUX_MIB_TCPAODROPPEDICMPS),
 	SNMP_MIB_SENTINEL
 };
 
diff --git a/net/ipv4/tcp_ao.c b/net/ipv4/tcp_ao.c
index 700e9a8bc983..5fb36863810d 100644
--- a/net/ipv4/tcp_ao.c
+++ b/net/ipv4/tcp_ao.c
@@ -15,6 +15,7 @@
 
 #include <net/tcp.h>
 #include <net/ipv6.h>
+#include <net/icmp.h>
 
 int tcp_ao_calc_traffic_key(struct tcp_ao_key *mkt, u8 *key, void *ctx,
 			    unsigned int len)
@@ -52,6 +53,63 @@ int tcp_ao_calc_traffic_key(struct tcp_ao_key *mkt, u8 *key, void *ctx,
 	return 1;
 }
 
+bool tcp_ao_ignore_icmp(struct sock *sk, int type, int code)
+{
+	struct tcp_ao_info *ao;
+	bool ignore_icmp = false;
+
+	/* RFC5925, 7.8:
+	 * >> A TCP-AO implementation MUST default to ignore incoming ICMPv4
+	 * messages of Type 3 (destination unreachable), Codes 2-4 (protocol
+	 * unreachable, port unreachable, and fragmentation needed -- ’hard
+	 * errors’), and ICMPv6 Type 1 (destination unreachable), Code 1
+	 * (administratively prohibited) and Code 4 (port unreachable) intended
+	 * for connections in synchronized states (ESTABLISHED, FIN-WAIT-1, FIN-
+	 * WAIT-2, CLOSE-WAIT, CLOSING, LAST-ACK, TIME-WAIT) that match MKTs.
+	 */
+	if (sk->sk_family == AF_INET) {
+		if (type != ICMP_DEST_UNREACH)
+			return false;
+		if (code < ICMP_PROT_UNREACH || code > ICMP_FRAG_NEEDED)
+			return false;
+	} else if (sk->sk_family == AF_INET6) {
+		if (type != ICMPV6_DEST_UNREACH)
+			return false;
+		if (code != ICMPV6_ADM_PROHIBITED && code != ICMPV6_PORT_UNREACH)
+			return false;
+	} else {
+		WARN_ON_ONCE(1);
+		return false;
+	}
+
+	rcu_read_lock();
+	switch (sk->sk_state) {
+	case TCP_TIME_WAIT:
+		ao = rcu_dereference(tcp_twsk(sk)->ao_info);
+		break;
+	case TCP_SYN_SENT:
+	case TCP_SYN_RECV:
+	case TCP_LISTEN:
+	case TCP_NEW_SYN_RECV:
+		/* RFC5925 specifies to ignore ICMPs *only* on connections
+		 * in synchronized states.
+		 */
+		rcu_read_unlock();
+		return false;
+	default:
+		ao = rcu_dereference(tcp_sk(sk)->ao_info);
+	}
+
+	if (ao && !(ao->ao_flags & AO_ACCEPT_ICMPS)) {
+		ignore_icmp = true;
+		__NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPAODROPPEDICMPS);
+		atomic64_inc(&ao->counters.dropped_icmp);
+	}
+	rcu_read_unlock();
+
+	return ignore_icmp;
+}
+
 struct tcp_ao_key *tcp_ao_do_lookup_keyid(struct tcp_ao_info *ao,
 					  int sndid, int rcvid)
 {
@@ -1399,7 +1457,7 @@ static inline bool tcp_ao_mkt_overlap_v6(struct tcp_ao *cmd,
 
 #define TCP_AO_KEYF_ALL		(0)
 #define TCP_AO_CMDF_ADDMOD_VALID					\
-	(TCP_AO_CMDF_CURR | TCP_AO_CMDF_NEXT)
+	(TCP_AO_CMDF_CURR | TCP_AO_CMDF_NEXT | TCP_AO_CMDF_ACCEPT_ICMP)
 #define TCP_AO_CMDF_DEL_VALID						\
 	(TCP_AO_CMDF_CURR | TCP_AO_CMDF_NEXT)
 
@@ -1482,6 +1540,11 @@ static int tcp_ao_add_cmd(struct sock *sk, unsigned short int family,
 	atomic64_set(&key->pkt_good, 0);
 	atomic64_set(&key->pkt_bad, 0);
 
+	if (cmd.tcpa_flags & TCP_AO_CMDF_ACCEPT_ICMP)
+		ao_info->ao_flags |= AO_ACCEPT_ICMPS;
+	else
+		ao_info->ao_flags &= ~AO_ACCEPT_ICMPS;
+
 	ret = tcp_ao_parse_crypto(&cmd, key);
 	if (ret < 0)
 		goto err_free_sock;
@@ -1640,6 +1703,11 @@ static int tcp_ao_mod_cmd(struct sock *sk, unsigned short int family,
 	if (!ao_info)
 		return -ENOENT;
 	/* TODO: make tcp_ao_current_rnext() and flags set atomic */
+	if (cmd.tcpa_flags & TCP_AO_CMDF_ACCEPT_ICMP)
+		ao_info->ao_flags |= AO_ACCEPT_ICMPS;
+	else
+		ao_info->ao_flags &= ~AO_ACCEPT_ICMPS;
+
 	return tcp_ao_current_rnext(sk, cmd.tcpa_flags,
 			cmd.tcpa_current, cmd.tcpa_rnext);
 }
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index ca4c6be886b7..372fbca343af 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -484,6 +484,8 @@ int tcp_v4_err(struct sk_buff *skb, u32 info)
 		return -ENOENT;
 	}
 	if (sk->sk_state == TCP_TIME_WAIT) {
+		/* To increase the counter of ignored icmps for TCP-AO */
+		tcp_ao_ignore_icmp(sk, type, code);
 		inet_twsk_put(inet_twsk(sk));
 		return 0;
 	}
@@ -498,6 +500,9 @@ int tcp_v4_err(struct sk_buff *skb, u32 info)
 	}
 
 	bh_lock_sock(sk);
+	if (tcp_ao_ignore_icmp(sk, type, code))
+		goto out;
+
 	/* If too many ICMPs get dropped on busy
 	 * servers this needs to be solved differently.
 	 * We do take care of PMTU discovery (RFC1191) special case :
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 8a27408549cd..78994d1cbc45 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -399,6 +399,8 @@ static int tcp_v6_err(struct sk_buff *skb, struct inet6_skb_parm *opt,
 	}
 
 	if (sk->sk_state == TCP_TIME_WAIT) {
+		/* To increase the counter of ignored icmps for TCP-AO */
+		tcp_ao_ignore_icmp(sk, type, code);
 		inet_twsk_put(inet_twsk(sk));
 		return 0;
 	}
@@ -410,6 +412,8 @@ static int tcp_v6_err(struct sk_buff *skb, struct inet6_skb_parm *opt,
 	}
 
 	bh_lock_sock(sk);
+	if (tcp_ao_ignore_icmp(sk, type, code))
+		goto out;
 	if (sock_owned_by_user(sk) && type != ICMPV6_PKT_TOOBIG)
 		__NET_INC_STATS(net, LINUX_MIB_LOCKDROPPEDICMPS);
 
-- 
2.37.2

