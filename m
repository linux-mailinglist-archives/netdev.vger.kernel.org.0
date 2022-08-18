Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1C0F598D40
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 22:05:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345739AbiHRUBP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 16:01:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345552AbiHRUAh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 16:00:37 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DED6DD11E2;
        Thu, 18 Aug 2022 13:00:35 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id tl27so5216733ejc.1;
        Thu, 18 Aug 2022 13:00:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=juxRWMmohIqnqlnS/ZzKhSYhJ6v65/IvgkVTtt2FCvs=;
        b=aThkW6in+ttvgDQsUjVJl/+h66mhj7vnnrwA/X3L6fWC0nCS6pMXLz3jv7NnT45cut
         FO/cWbbbuz+NhLPae2d/RvUgCcUkSzXjFtxf0W2jZFoI8M3caFlgOT+A43IiB0/ooIQs
         iWBvB8qefWMkzzzoGRrIgvYtI9E9SaNmn8Xh5oQNGD8MXsWl0MRhjFPw00s2ITRSv/5m
         IIq+OwUeyF3a2zVs6ZQwKOUUl3Z+M9ig+fN6FyI0npv0QSfThhaIlb8BIr1Mdcl4VXGZ
         0JJ6g41dm9s8LEVvVyGSgJpOmGXxxPB5dHRj8CkUgWBr2SkKHlt+6rO6zradZ/p6vYI+
         5gQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=juxRWMmohIqnqlnS/ZzKhSYhJ6v65/IvgkVTtt2FCvs=;
        b=fE+KNlBk/u4LLN63YGmcXQcTz7nG4uoMwlR53sEauIGiqEoQvtedcesGwJ+G6MoZnf
         wRxZ3aN8G69eV/gnQGDFodNbw02oJrOBRWo0rUCpwkjDjl8qzAh9RyR9w2E7vmuEvyut
         oO2LOJVtyJqxSuyRf1r7ww4s+piNo7GX9+giPSYoxEHIzCxSvn2R1NPAOChln/u59Hr6
         e+Paw5KctzLxZC/isN7hwSr8I2GMsK+d5CuoccP7GT0UK1GiZMnbfJmzhqwUmWUcwqT1
         MaTHIwckqxfwjv1SH25dHdRe2f8Adh2hB5HYgOVKQ7QzJ5U20Ivg8bd2FTyJqcQokF0z
         Jovg==
X-Gm-Message-State: ACgBeo1bGkrPYk7hnjGC9tQGgD3EaHlPmL7VMhm+lWnObPNTojvW0/bT
        dEp6fj8H2Guoea7Azm0zIcs=
X-Google-Smtp-Source: AA6agR4JnDcVNmvs30wFum4qeaoTuSOIFlPsfKr5RK4LwouFgjHofaf/zsxqI0z76NZms3eTAsXaJw==
X-Received: by 2002:a17:907:1dd7:b0:730:8dfd:9e13 with SMTP id og23-20020a1709071dd700b007308dfd9e13mr2718641ejc.239.1660852835461;
        Thu, 18 Aug 2022 13:00:35 -0700 (PDT)
Received: from localhost.localdomain ([2a04:241e:502:a080:17c8:ba1c:b6f3:3fe0])
        by smtp.gmail.com with ESMTPSA id fw30-20020a170907501e00b00722e4bab163sm1215087ejc.200.2022.08.18.13.00.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Aug 2022 13:00:34 -0700 (PDT)
From:   Leonard Crestez <cdleonard@gmail.com>
To:     David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Philip Paeps <philip@trouble.is>
Cc:     Dmitry Safonov <0x7f454c46@gmail.com>,
        Shuah Khan <shuah@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Yuchung Cheng <ycheng@google.com>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Christoph Paasch <cpaasch@apple.com>,
        Ivan Delalande <colona@arista.com>,
        Caowangbao <caowangbao@huawei.com>,
        Priyaranjan Jha <priyarjha@google.com>, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v7 10/26] tcp: ipv6: Add AO signing for tcp_v6_send_response
Date:   Thu, 18 Aug 2022 22:59:44 +0300
Message-Id: <51c98f3663f53bf122e1d857f046dd4f279e5845.1660852705.git.cdleonard@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1660852705.git.cdleonard@gmail.com>
References: <cover.1660852705.git.cdleonard@gmail.com>
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

This is a special code path for acks and resets outside of normal
connection establishment and closing.

Signed-off-by: Leonard Crestez <cdleonard@gmail.com>
---
 net/ipv4/tcp_authopt.c |  2 ++
 net/ipv6/tcp_ipv6.c    | 60 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 62 insertions(+)

diff --git a/net/ipv4/tcp_authopt.c b/net/ipv4/tcp_authopt.c
index e64b97db927e..2a216356d280 100644
--- a/net/ipv4/tcp_authopt.c
+++ b/net/ipv4/tcp_authopt.c
@@ -385,10 +385,11 @@ struct tcp_authopt_key_info *__tcp_authopt_select_key(const struct sock *sk,
 {
 	struct netns_tcp_authopt *net = sock_net_tcp_authopt(sk);
 
 	return tcp_authopt_lookup_send(net, addr_sk, -1);
 }
+EXPORT_SYMBOL(__tcp_authopt_select_key);
 
 static struct tcp_authopt_info *__tcp_authopt_info_get_or_create(struct sock *sk)
 {
 	struct tcp_sock *tp = tcp_sk(sk);
 	struct tcp_authopt_info *info;
@@ -1210,10 +1211,11 @@ int tcp_authopt_hash(char *hash_location,
 	 * try to make it obvious inside the packet.
 	 */
 	memset(hash_location, 0, TCP_AUTHOPT_MACLEN);
 	return err;
 }
+EXPORT_SYMBOL(tcp_authopt_hash);
 
 /**
  * tcp_authopt_lookup_recv - lookup key for receive
  *
  * @sk: Receive socket
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 2edfe631878e..151254345dee 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -40,10 +40,11 @@
 #include <linux/icmpv6.h>
 #include <linux/random.h>
 #include <linux/indirect_call_wrapper.h>
 
 #include <net/tcp.h>
+#include <net/tcp_authopt.h>
 #include <net/ndisc.h>
 #include <net/inet6_hashtables.h>
 #include <net/inet6_connection_sock.h>
 #include <net/ipv6.h>
 #include <net/transp_v6.h>
@@ -836,10 +837,48 @@ const struct tcp_request_sock_ops tcp_request_sock_ipv6_ops = {
 	.init_seq	=	tcp_v6_init_seq,
 	.init_ts_off	=	tcp_v6_init_ts_off,
 	.send_synack	=	tcp_v6_send_synack,
 };
 
+#ifdef CONFIG_TCP_AUTHOPT
+static int tcp_v6_send_response_init_authopt(const struct sock *sk,
+					     struct tcp_authopt_info **info,
+					     struct tcp_authopt_key_info **key,
+					     u8 *rnextkeyid)
+{
+	/* Key lookup before SKB allocation */
+	if (!(tcp_authopt_needed && sk))
+		return 0;
+	if (sk->sk_state == TCP_TIME_WAIT)
+		*info = tcp_twsk(sk)->tw_authopt_info;
+	else
+		*info = rcu_dereference(tcp_sk(sk)->authopt_info);
+	if (!*info)
+		return 0;
+	*key = __tcp_authopt_select_key(sk, *info, sk, rnextkeyid);
+	if (*key)
+		return TCPOLEN_AUTHOPT_OUTPUT;
+	return 0;
+}
+
+static void tcp_v6_send_response_sign_authopt(const struct sock *sk,
+					      struct tcp_authopt_info *info,
+					      struct tcp_authopt_key_info *key,
+					      struct sk_buff *skb,
+					      struct tcphdr_authopt *ptr,
+					      u8 rnextkeyid)
+{
+	if (!(tcp_authopt_needed && key))
+		return;
+	ptr->num = TCPOPT_AUTHOPT;
+	ptr->len = TCPOLEN_AUTHOPT_OUTPUT;
+	ptr->keyid = key->send_id;
+	ptr->rnextkeyid = rnextkeyid;
+	tcp_authopt_hash(ptr->mac, key, info, (struct sock *)sk, skb);
+}
+#endif
+
 static void tcp_v6_send_response(const struct sock *sk, struct sk_buff *skb, u32 seq,
 				 u32 ack, u32 win, u32 tsval, u32 tsecr,
 				 int oif, struct tcp_md5sig_key *key, int rst,
 				 u8 tclass, __be32 label, u32 priority)
 {
@@ -851,13 +890,30 @@ static void tcp_v6_send_response(const struct sock *sk, struct sk_buff *skb, u32
 	struct sock *ctl_sk = net->ipv6.tcp_sk;
 	unsigned int tot_len = sizeof(struct tcphdr);
 	__be32 mrst = 0, *topt;
 	struct dst_entry *dst;
 	__u32 mark = 0;
+#ifdef CONFIG_TCP_AUTHOPT
+	struct tcp_authopt_info *aoinfo;
+	struct tcp_authopt_key_info *aokey;
+	u8 aornextkeyid;
+	int aolen;
+#endif
 
 	if (tsecr)
 		tot_len += TCPOLEN_TSTAMP_ALIGNED;
+#ifdef CONFIG_TCP_AUTHOPT
+	/* Key lookup before SKB allocation */
+	aolen = tcp_v6_send_response_init_authopt(sk, &aoinfo, &aokey, &aornextkeyid);
+	if (aolen) {
+		tot_len += aolen;
+#ifdef CONFIG_TCP_MD5SIG
+		/* Don't use MD5 */
+		key = NULL;
+#endif
+	}
+#endif
 #ifdef CONFIG_TCP_MD5SIG
 	if (key)
 		tot_len += TCPOLEN_MD5SIG_ALIGNED;
 #endif
 
@@ -909,10 +965,14 @@ static void tcp_v6_send_response(const struct sock *sk, struct sk_buff *skb, u32
 		tcp_v6_md5_hash_hdr((__u8 *)topt, key,
 				    &ipv6_hdr(skb)->saddr,
 				    &ipv6_hdr(skb)->daddr, t1);
 	}
 #endif
+#ifdef CONFIG_TCP_AUTHOPT
+	tcp_v6_send_response_sign_authopt(sk, aoinfo, aokey, buff,
+					  (struct tcphdr_authopt *)topt, aornextkeyid);
+#endif
 
 	memset(&fl6, 0, sizeof(fl6));
 	fl6.daddr = ipv6_hdr(skb)->saddr;
 	fl6.saddr = ipv6_hdr(skb)->daddr;
 	fl6.flowlabel = label;
-- 
2.25.1

