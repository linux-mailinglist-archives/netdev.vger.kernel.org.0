Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B68E441E75
	for <lists+netdev@lfdr.de>; Mon,  1 Nov 2021 17:36:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233075AbhKAQik (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 12:38:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232894AbhKAQiX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Nov 2021 12:38:23 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA121C061766;
        Mon,  1 Nov 2021 09:35:49 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id g10so65999627edj.1;
        Mon, 01 Nov 2021 09:35:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=umP2OFh59XVEJqM9lQCeUEZ8yO4o1wq2PwPGkLZmIz4=;
        b=U7SwZItvMbA7EmWa3NLXPAZ938I8BphuBEAeF5vy6aczuHWvpVprmdBzZ4W0wobUpp
         undPphvAHcn7nIFimjsIP6nC6exHKcLXdFjV13HwOWaogQyYZsfsIzmIt3yTGPWQS3eA
         JQNsSs1vu3karZGx+HEumM1j3TgpmtExDt0eDi+0RFRjWEetYq1S133wNh90IQazH1rF
         RpzmEPZe9CEXXvhGr/XpgkcIzwkOT1k6MakPFBnn7H69+LsK1R8gh8ETfIqliaFEpi3U
         +kMfvyO4+KUqsXCs9dgL3ictWz5vay1je3cFRaYPjzU7OkfqhNwGtVEG6wUw2zxI8Rb7
         MVTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=umP2OFh59XVEJqM9lQCeUEZ8yO4o1wq2PwPGkLZmIz4=;
        b=toHzeueAvgeEHuptKKVYP4F3OixUXef+PPV5WYvIr2LZWOqbQkzBUKJ8GxEUVIt06o
         n9pdVu0+lkkV5h3uFM8DnaynYaE3pi69LUfeoijHN7nKLK4G5lWT5Gp/foa6nHAGQjq8
         G4juS2GWVgr78UA7AL/RGZgnQPMRPlktz+nKJhQ1/i5M0D49ecVWvEMlZFMgpnZs0sxB
         RLxOzrXXjCBuIup+LxSrWlknU8OItB6Rzes+qGm1NFqmGxEGvjS+It5DH8HbnUkojTtr
         V/E+aaSq1iBQqLCfzISDBGXoXkAEcY+Sy1qVNWeda1rNC9y04+q07PeTNfx9DwydH/PL
         Yy8g==
X-Gm-Message-State: AOAM533uCY9EQksqNbO4o6rEdguf4Qzh7XzheNrA15HL+Lq1rWbGFY1G
        Um+QWASg7uSYXwkLwM7aNFE=
X-Google-Smtp-Source: ABdhPJyQifdxYYeSAzcnjLmXyq3j/Knr275NJB5FvT5u7/AIYLEImPArYQ5sqc/z46Dgo2if6JBVlA==
X-Received: by 2002:a05:6402:510b:: with SMTP id m11mr14687483edd.215.1635784548597;
        Mon, 01 Nov 2021 09:35:48 -0700 (PDT)
Received: from ponky.lan ([2a04:241e:501:3870:f5f:2085:7f25:17c])
        by smtp.gmail.com with ESMTPSA id f25sm4124583edv.90.2021.11.01.09.35.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Nov 2021 09:35:48 -0700 (PDT)
From:   Leonard Crestez <cdleonard@gmail.com>
To:     David Ahern <dsahern@kernel.org>, Shuah Khan <shuah@kernel.org>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Yuchung Cheng <ycheng@google.com>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Christoph Paasch <cpaasch@apple.com>,
        Ivan Delalande <colona@arista.com>,
        Priyaranjan Jha <priyarjha@google.com>, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 12/25] tcp: ipv6: Add AO signing for tcp_v6_send_response
Date:   Mon,  1 Nov 2021 18:34:47 +0200
Message-Id: <f9ff27ecc4aabd8ed89d5dfe5195c9cda1e7dc9f.1635784253.git.cdleonard@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1635784253.git.cdleonard@gmail.com>
References: <cover.1635784253.git.cdleonard@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a special code path for acks and resets outside of normal
connection establishment and closing.

Signed-off-by: Leonard Crestez <cdleonard@gmail.com>
---
 net/ipv4/tcp_authopt.c |  2 ++
 net/ipv6/tcp_ipv6.c    | 38 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 40 insertions(+)

diff --git a/net/ipv4/tcp_authopt.c b/net/ipv4/tcp_authopt.c
index a48b741c83e4..c9d201d8f7a7 100644
--- a/net/ipv4/tcp_authopt.c
+++ b/net/ipv4/tcp_authopt.c
@@ -296,10 +296,11 @@ struct tcp_authopt_key_info *__tcp_authopt_select_key(const struct sock *sk,
 						      const struct sock *addr_sk,
 						      u8 *rnextkeyid)
 {
 	return tcp_authopt_lookup_send(info, addr_sk, -1);
 }
+EXPORT_SYMBOL(__tcp_authopt_select_key);
 
 static struct tcp_authopt_info *__tcp_authopt_info_get_or_create(struct sock *sk)
 {
 	struct tcp_sock *tp = tcp_sk(sk);
 	struct tcp_authopt_info *info;
@@ -1202,10 +1203,11 @@ int tcp_authopt_hash(char *hash_location,
 	 * try to make it obvious inside the packet.
 	 */
 	memset(hash_location, 0, TCP_AUTHOPT_MACLEN);
 	return err;
 }
+EXPORT_SYMBOL(tcp_authopt_hash);
 
 static struct tcp_authopt_key_info *tcp_authopt_lookup_recv(struct sock *sk,
 							    struct sk_buff *skb,
 							    struct tcp_authopt_info *info,
 							    int recv_id)
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 96a29caf56c7..68f9545e4347 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -902,13 +902,37 @@ static void tcp_v6_send_response(const struct sock *sk, struct sk_buff *skb, u32
 	struct sock *ctl_sk = net->ipv6.tcp_sk;
 	unsigned int tot_len = sizeof(struct tcphdr);
 	__be32 mrst = 0, *topt;
 	struct dst_entry *dst;
 	__u32 mark = 0;
+#ifdef CONFIG_TCP_AUTHOPT
+	struct tcp_authopt_info *authopt_info = NULL;
+	struct tcp_authopt_key_info *authopt_key_info = NULL;
+	u8 authopt_rnextkeyid;
+#endif
 
 	if (tsecr)
 		tot_len += TCPOLEN_TSTAMP_ALIGNED;
+#ifdef CONFIG_TCP_AUTHOPT
+	/* Key lookup before SKB allocation */
+	if (static_branch_unlikely(&tcp_authopt_needed) && sk) {
+		if (sk->sk_state == TCP_TIME_WAIT)
+			authopt_info = tcp_twsk(sk)->tw_authopt_info;
+		else
+			authopt_info = rcu_dereference(tcp_sk(sk)->authopt_info);
+
+		if (authopt_info) {
+			authopt_key_info = __tcp_authopt_select_key(sk, authopt_info, sk,
+								    &authopt_rnextkeyid);
+			if (authopt_key_info) {
+				tot_len += TCPOLEN_AUTHOPT_OUTPUT;
+				/* Don't use MD5 */
+				key = NULL;
+			}
+		}
+	}
+#endif
 #ifdef CONFIG_TCP_MD5SIG
 	if (key)
 		tot_len += TCPOLEN_MD5SIG_ALIGNED;
 #endif
 
@@ -961,10 +985,24 @@ static void tcp_v6_send_response(const struct sock *sk, struct sk_buff *skb, u32
 		tcp_v6_md5_hash_hdr((__u8 *)topt, key,
 				    &ipv6_hdr(skb)->saddr,
 				    &ipv6_hdr(skb)->daddr, t1);
 	}
 #endif
+#ifdef CONFIG_TCP_AUTHOPT
+	/* Compute the TCP-AO mac. Unlike in the ipv4 case we have a real SKB */
+	if (static_branch_unlikely(&tcp_authopt_needed) && authopt_key_info) {
+		*topt++ = htonl((TCPOPT_AUTHOPT << 24) |
+				(TCPOLEN_AUTHOPT_OUTPUT << 16) |
+				(authopt_key_info->send_id << 8) |
+				(authopt_rnextkeyid));
+		tcp_authopt_hash((char *)topt,
+				 authopt_key_info,
+				 authopt_info,
+				 (struct sock *)sk,
+				 buff);
+	}
+#endif
 
 	memset(&fl6, 0, sizeof(fl6));
 	fl6.daddr = ipv6_hdr(skb)->saddr;
 	fl6.saddr = ipv6_hdr(skb)->daddr;
 	fl6.flowlabel = label;
-- 
2.25.1

