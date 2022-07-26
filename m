Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E74C580B47
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 08:19:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237827AbiGZGSY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 02:18:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237683AbiGZGQs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 02:16:48 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F3ADDE9F;
        Mon, 25 Jul 2022 23:16:00 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id c12so9136565ede.3;
        Mon, 25 Jul 2022 23:16:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=EeDWES+RoYrIxklT3H3lpQ4X5nN+/sosK8cuqsDA2yw=;
        b=RyqOObi3SSW1ZZ92fGEkZqfVHmKraSS5ULlPp+8EyxPMBjiDg4FcOJ9zl2Ua//j5ck
         LQMDWWiuqwQ5Wn1qHsPRM2kM4aRuvxxhDIrrlZzhuyxoct5BCbwAOy8eB7EvD4HToiYw
         GlwuZt2QWFZdY0K3g6SAo09646WRiNySu5Cq01PQQJdGVKLHphQCxWoJDaQ9IyZho7A3
         Nlp2pcXEgFKjAuwemF+ZdQsNLnoAj7ZOj5k21p0ynGgCro3a0poMzWuSMJuw86mLWMzg
         U0IjOOP7K08kN7NEp1M0i7B3SyvNQSMyNLVjA1tZQMq4EZimHd5llKUe8d0P44lTYC19
         5OeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EeDWES+RoYrIxklT3H3lpQ4X5nN+/sosK8cuqsDA2yw=;
        b=XRMAE4hOynUvhua1WxklYXt85m8JOqnK5mx/mrmcDaGIwMnZQs3gxsiXYTn/1JAB9Y
         IeukiheQVys7h4tfC12AaFcRIwcNKOstbkis4Kp9m2xPQZz2GVJfGh9klWcLiAHMtWko
         0XCbyel01/x1yOGXZ+r087V8zbD7vqAhc/ZdR5EdAm91YVVjN2FIzAr1VIGv53RYdTvO
         ZrWR6Rvjhmhx8G6Vz+quqmjq9I8S/7jl5ZPrflDStNs2PpL3RpKsh6My8UpieLpRTahr
         gp1p6jwCVoebhn9nWJPqKtB+oGF3Ems/h9mVpbQM2hCAbx5Gg+YARQIAjZtF0TmAMZRi
         Jaqg==
X-Gm-Message-State: AJIora+RkHwE2+hIt04NFX2inMr8RkPT6t/EcwyIX89VjsMzPrhSYOrm
        1p4HUVqnnt+BdzNIb2zURgo=
X-Google-Smtp-Source: AGRyM1sJaTr+yF7nZQ9o2b05WpCv43itL3sxicyVnK/r/zKBi66HtRCuISGpTPa/rsWjyeOSsH6cdA==
X-Received: by 2002:a05:6402:4148:b0:43b:7f36:e25f with SMTP id x8-20020a056402414800b0043b7f36e25fmr16451483eda.407.1658816158871;
        Mon, 25 Jul 2022 23:15:58 -0700 (PDT)
Received: from localhost.localdomain ([2a04:241e:502:a080:2b68:36a:5a94:4ba1])
        by smtp.gmail.com with ESMTPSA id l23-20020a056402345700b0043ba7df7a42sm8133067edc.26.2022.07.25.23.15.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Jul 2022 23:15:58 -0700 (PDT)
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
Subject: [PATCH v6 11/26] tcp: ipv6: Add AO signing for tcp_v6_send_response
Date:   Tue, 26 Jul 2022 09:15:13 +0300
Message-Id: <17ba6ae3168abc1d6c37dac479925adc0ed19017.1658815925.git.cdleonard@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1658815925.git.cdleonard@gmail.com>
References: <cover.1658815925.git.cdleonard@gmail.com>
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
index 12f63ce66bcc..63fdbb181bb8 100644
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

