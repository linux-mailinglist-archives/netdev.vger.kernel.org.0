Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C4815E8348
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 22:15:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232818AbiIWUPl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 16:15:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232846AbiIWUOt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 16:14:49 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C50D9132FD9
        for <netdev@vger.kernel.org>; Fri, 23 Sep 2022 13:13:58 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id r7so1598441wrm.2
        for <netdev@vger.kernel.org>; Fri, 23 Sep 2022 13:13:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=lM/d47NGasL5ujBHtjhpp6KRTRTH1w/8EXNSZdJeCCQ=;
        b=P8/kmovQKZJfCOxtSJmxYP0aVSLqWHDbN2LTT6dNMFjKVIV23zJeg854voKkv5+5kG
         wheuQ8SgKH81dhS1DYV2/S4LpllGKAkgRxs0j614R9xOtp1OOSDwgoVHQxVC03q7pUzb
         MILJdQEP2ncBHbv6axjixtG2GEAVWOsNdtcd+aDZoRaaR+sqCwqgkcqc8CgZdy0hlbGl
         3XHfUVXeF1PG1uDlJ1v6GqVFoZnSe5CEDcHHoY/Qy+B+2tunxgpbUPsrMqBaAW8geFUD
         dnZ4eKhilDIGzoeh1JHwtgXFbOArmgDj/cY5pqoPDclXQfy5WXL+KJRls4vmOTMN49oV
         LjdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=lM/d47NGasL5ujBHtjhpp6KRTRTH1w/8EXNSZdJeCCQ=;
        b=cXlTihqaG2+yQpVaStV0FMSvArY/OK88Q2RK2G4dQx9rac2XmvQrW1mIWvGujimIF5
         9L3lywl+qstGDcQdIbajHKKY6m0Yfl6JFJRQEwejcUz4TqypyxxddHOJiu36ddx3eePI
         0A9uHe26ESP4mzatid3/QKpPzSrrPte0w0J7AqO/24t0M7tHFDC+KHjHCzGMBqHqZF78
         zHpsQf35R/z0bOpwjYfCznYghJtJzKWD3gswmSWQ3D0DJeK8VwakQ+QPsKnBAdY37hns
         aJeUWbke+/dVf/FXsuFUHdDyqTBWtvXA+Bwh6dzDRLuLt3c8riQiXo0qZGysRD7tbc89
         Jrrg==
X-Gm-Message-State: ACrzQf0OBGNKqKpX3w8z/vmkQ3y9LnP3W88jzc7EXsEXCP7ubZEb2t7y
        u7CKWYuIkKesBujV25dVXtX/1w==
X-Google-Smtp-Source: AMsMyM7kG5clUKFIezHnYkkVoIPHd5uuDg6thXrBPaIGK//QhBdQLzLK+X8cplINNywRba8np8sQrw==
X-Received: by 2002:a05:6000:144c:b0:22b:dda:eeb0 with SMTP id v12-20020a056000144c00b0022b0ddaeeb0mr6510410wrx.335.1663964038106;
        Fri, 23 Sep 2022 13:13:58 -0700 (PDT)
Received: from Mindolluin.ire.aristanetworks.com ([217.173.96.166])
        by smtp.gmail.com with ESMTPSA id k11-20020a05600c0b4b00b003b492753826sm3281056wmr.43.2022.09.23.13.13.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Sep 2022 13:13:57 -0700 (PDT)
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
Subject: [PATCH v2 20/35] net/tcp: Add tcp_hash_fail() ratelimited logs
Date:   Fri, 23 Sep 2022 21:13:04 +0100
Message-Id: <20220923201319.493208-21-dima@arista.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220923201319.493208-1-dima@arista.com>
References: <20220923201319.493208-1-dima@arista.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a helper for logging connection-detailed messages for failed TCP
hash verification (both MD5 and AO).

Co-developed-by: Francesco Ruggeri <fruggeri@arista.com>
Signed-off-by: Francesco Ruggeri <fruggeri@arista.com>
Co-developed-by: Salam Noureddine <noureddine@arista.com>
Signed-off-by: Salam Noureddine <noureddine@arista.com>
Signed-off-by: Dmitry Safonov <dima@arista.com>
---
 include/net/tcp.h    | 14 ++++++++++++--
 include/net/tcp_ao.h | 27 +++++++++++++++++++++++++++
 net/ipv4/tcp.c       | 23 +++++++++++++----------
 net/ipv4/tcp_ao.c    |  7 +++++++
 4 files changed, 59 insertions(+), 12 deletions(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index 94573219f58d..896db7ba0670 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -2517,12 +2517,19 @@ tcp_inbound_hash(struct sock *sk, const struct request_sock *req,
 	int l3index;
 
 	/* Invalid option or two times meet any of auth options */
-	if (tcp_parse_auth_options(th, &md5_location, &aoh))
+	if (tcp_parse_auth_options(th, &md5_location, &aoh)) {
+		tcp_hash_fail("TCP segment has incorrect auth options set",
+				family, skb, "");
 		return SKB_DROP_REASON_TCP_AUTH_HDR;
+	}
 
 	if (req) {
-		if (tcp_rsk_used_ao(req) != !!aoh)
+		if (tcp_rsk_used_ao(req) != !!aoh) {
+			tcp_hash_fail("TCP connection can't start/end using TCP-AO",
+					family, skb, " %s",
+					!aoh ? "missing AO" : "AO signed");
 			return SKB_DROP_REASON_TCP_AOFAILURE;
+		}
 	}
 
 	/* sdif set, means packet ingressed via a device
@@ -2545,11 +2552,14 @@ tcp_inbound_hash(struct sock *sk, const struct request_sock *req,
 					lockdep_sock_is_held(sk));
 			NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPAOREQUIRED);
 			atomic64_inc(&ao_info->counters.ao_required);
+			tcp_hash_fail("AO hash is required, but not found",
+					family, skb, "");
 			return SKB_DROP_REASON_TCP_AONOTFOUND;
 		}
 #endif
 		if (unlikely(tcp_md5_do_lookup(sk, l3index, saddr, family))) {
 			NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPMD5NOTFOUND);
+			tcp_hash_fail("MD5 Hash not found", family, skb, "");
 			return SKB_DROP_REASON_TCP_MD5NOTFOUND;
 		}
 		return SKB_NOT_DROPPED_YET;
diff --git a/include/net/tcp_ao.h b/include/net/tcp_ao.h
index dbeaa7d4e212..e99c8f300a5a 100644
--- a/include/net/tcp_ao.h
+++ b/include/net/tcp_ao.h
@@ -101,6 +101,33 @@ struct tcp_ao_info {
 int tcp_do_parse_auth_options(const struct tcphdr *th,
 			      const u8 **md5_hash, const u8 **ao_hash);
 
+#define tcp_hash_fail(msg, family, skb, fmt, ...)			\
+do {									\
+	const struct tcphdr *th = tcp_hdr(skb);				\
+	char hdr_flags[5] = {};						\
+	char *f = hdr_flags;						\
+									\
+	if (th->fin)							\
+		*f++ = 'F';						\
+	if (th->syn)							\
+		*f++ = 'S';						\
+	if (th->rst)							\
+		*f++ = 'R';						\
+	if (th->ack)							\
+		*f = 'A';						\
+	if (family == AF_INET) {					\
+		net_info_ratelimited("%s for (%pI4, %d)->(%pI4, %d) %s" fmt "\n", \
+				msg, &ip_hdr(skb)->saddr, ntohs(th->source), \
+				&ip_hdr(skb)->daddr, ntohs(th->dest),	\
+				hdr_flags, ##__VA_ARGS__);		\
+	} else {							\
+		net_info_ratelimited("%s for [%pI6c]:%u->[%pI6c]:%u %s" fmt "\n", \
+				msg, &ipv6_hdr(skb)->saddr, ntohs(th->source), \
+				&ipv6_hdr(skb)->daddr, ntohs(th->dest),	\
+				hdr_flags, ##__VA_ARGS__);		\
+	}								\
+} while (0)
+
 #ifdef CONFIG_TCP_AO
 /* TCP-AO structures and functions */
 
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 7c8341419a7a..f7ad4443c350 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -4517,7 +4517,6 @@ tcp_inbound_md5_hash(const struct sock *sk, const struct sk_buff *skb,
 	 * o MD5 hash and we're not expecting one.
 	 * o MD5 hash and its wrong.
 	 */
-	const struct tcphdr *th = tcp_hdr(skb);
 	struct tcp_sock *tp = tcp_sk(sk);
 	struct tcp_md5sig_key *key;
 	int genhash;
@@ -4527,6 +4526,7 @@ tcp_inbound_md5_hash(const struct sock *sk, const struct sk_buff *skb,
 
 	if (!key && hash_location) {
 		NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPMD5UNEXPECTED);
+		tcp_hash_fail("Unexpected MD5 Hash found", family, skb, "");
 		return SKB_DROP_REASON_TCP_MD5UNEXPECTED;
 	}
 
@@ -4542,16 +4542,19 @@ tcp_inbound_md5_hash(const struct sock *sk, const struct sk_buff *skb,
 	if (genhash || memcmp(hash_location, newhash, 16) != 0) {
 		NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPMD5FAILURE);
 		if (family == AF_INET) {
-			net_info_ratelimited("MD5 Hash failed for (%pI4, %d)->(%pI4, %d)%s L3 index %d\n",
-					saddr, ntohs(th->source),
-					daddr, ntohs(th->dest),
-					genhash ? " tcp_v4_calc_md5_hash failed"
-					: "", l3index);
+			tcp_hash_fail("MD5 Hash failed", AF_INET, skb, "%s L3 index %d",
+				      genhash ? " tcp_v4_calc_md5_hash failed"
+				      : "", l3index);
 		} else {
-			net_info_ratelimited("MD5 Hash %s for [%pI6c]:%u->[%pI6c]:%u L3 index %d\n",
-					genhash ? "failed" : "mismatch",
-					saddr, ntohs(th->source),
-					daddr, ntohs(th->dest), l3index);
+			if (genhash) {
+				tcp_hash_fail("MD5 Hash failed",
+					      AF_INET6, skb, " L3 index %d",
+					      l3index);
+			} else {
+				tcp_hash_fail("MD5 Hash mismatch",
+					      AF_INET6, skb, " L3 index %d",
+					      l3index);
+			}
 		}
 		return SKB_DROP_REASON_TCP_MD5FAILURE;
 	}
diff --git a/net/ipv4/tcp_ao.c b/net/ipv4/tcp_ao.c
index ba94c9ad7037..700e9a8bc983 100644
--- a/net/ipv4/tcp_ao.c
+++ b/net/ipv4/tcp_ao.c
@@ -679,6 +679,8 @@ tcp_ao_verify_hash(const struct sock *sk, const struct sk_buff *skb,
 		NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPAOBAD);
 		atomic64_inc(&info->counters.pkt_bad);
 		atomic64_inc(&key->pkt_bad);
+		tcp_hash_fail("AO hash wrong length", family, skb,
+			      " %u != %d", maclen, tcp_ao_maclen(key));
 		return SKB_DROP_REASON_TCP_AOFAILURE;
 	}
 
@@ -689,6 +691,7 @@ tcp_ao_verify_hash(const struct sock *sk, const struct sk_buff *skb,
 		NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPAOBAD);
 		atomic64_inc(&info->counters.pkt_bad);
 		atomic64_inc(&key->pkt_bad);
+		tcp_hash_fail("AO hash mismatch", family, skb, "");
 		return SKB_DROP_REASON_TCP_AOFAILURE;
 	}
 	NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPAOGOOD);
@@ -715,6 +718,8 @@ tcp_inbound_ao_hash(struct sock *sk, const struct sk_buff *skb,
 	info = rcu_dereference(tcp_sk(sk)->ao_info);
 	if (!info) {
 		NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPAOKEYNOTFOUND);
+		tcp_hash_fail("AO key not found", family, skb,
+			      " keyid: %u", aoh->keyid);
 		return SKB_DROP_REASON_TCP_AOUNEXPECTED;
 	}
 
@@ -797,6 +802,8 @@ tcp_inbound_ao_hash(struct sock *sk, const struct sk_buff *skb,
 key_not_found:
 	NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPAOKEYNOTFOUND);
 	atomic64_inc(&info->counters.key_not_found);
+	tcp_hash_fail("Requested by the peer AO key id not found",
+		      family, skb, "");
 	return SKB_DROP_REASON_TCP_AOKEYNOTFOUND;
 }
 
-- 
2.37.2

