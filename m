Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4DBA5ACBF7
	for <lists+netdev@lfdr.de>; Mon,  5 Sep 2022 09:08:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237302AbiIEHHg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Sep 2022 03:07:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236904AbiIEHGe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Sep 2022 03:06:34 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0380D3E740;
        Mon,  5 Sep 2022 00:06:31 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id fy31so15120883ejc.6;
        Mon, 05 Sep 2022 00:06:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=LtbzW1Bim8DI3OUG4KZJ5NkrxSQelcs50eoiZvptcfQ=;
        b=aaeBjEzdP7ULP6T0euXe71Ys13AAT5XD+yCuyf4Vg+s8ogF1MQRJBj1T1EAAeCFFin
         NENSDwDvBu1/b8ygrNO+SEo09xC3Sts2s7JrOEAuB+tkhcaCdnHCG6NLJLv8RTOXRC1u
         FB9b35prXgpck6kcCRhDVuIWlhB/gvwwGhAqp2WYqcHaDSD3cVSoOh3y8EK4c3dKHq5k
         rpdeMgdBBaSrg9lcHTLfVjg38CiTvvnPClHH7gc02Ew9ZmMqwLV4bxhUwr/XG5saPus4
         YcbE/LpnuKRPAZqKprKPylr1DlMSRzqhqsel00sKEOZXUU3wt+QdhJVGe5AoG34JRVEv
         A6wA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=LtbzW1Bim8DI3OUG4KZJ5NkrxSQelcs50eoiZvptcfQ=;
        b=R2AdDQSJTNBDWPU0kadfMlz5VN60fzioNCH2yLgV2NRP4/6KpALE329vcI+L8lyt5Z
         pBT6Uzxg1YuD+7ANfruIxteJbiTS7sBlFQ1wg/s+0ZxQ/lj+6EtANoJ8Q9/xOE2CGPyN
         VxAzkauRBE4njTwelZRYsC+9OBy5OmqVpWY/FRyNMbrXK9JPxaskL/llQi2zDzEWCFKx
         0M1pwGyuhM9cAOPljaI6wzpxV1LoexRqRcMQOu1bEsii2AVSbTxDlQh7ztyQRLajOr5f
         Kmgu30W5SfBLk/CS6O40NYWyO9CchXYcH1i0JQUdEeNoOac1l/s8QxDoVA+m9NkDYn/J
         br/w==
X-Gm-Message-State: ACgBeo33S7OOV2a8cFuKK/FAmh/lGt2qBuNHJ3xCv7RmL43jjpDY186Y
        9cby+OglPBxwCiz6e3iPlsJ566w82UQ=
X-Google-Smtp-Source: AA6agR4niluhhI5SMSkZnSmJhfM374RW4ScM88FLaMgEdH71h3JgqDgWucgfd1+iPESW7szkc7Y/2w==
X-Received: by 2002:a17:906:cc12:b0:741:64ed:125a with SMTP id ml18-20020a170906cc1200b0074164ed125amr26586412ejb.713.1662361590398;
        Mon, 05 Sep 2022 00:06:30 -0700 (PDT)
Received: from localhost.localdomain ([2a04:241e:502:a080:40ec:9f50:387:3cfb])
        by smtp.gmail.com with ESMTPSA id n27-20020a056402515b00b0043cf2e0ce1csm5882775edd.48.2022.09.05.00.06.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Sep 2022 00:06:29 -0700 (PDT)
From:   Leonard Crestez <cdleonard@gmail.com>
To:     David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Dmitry Safonov <0x7f454c46@gmail.com>
Cc:     Francesco Ruggeri <fruggeri@arista.com>,
        Salam Noureddine <noureddine@arista.com>,
        Philip Paeps <philip@trouble.is>,
        Shuah Khan <shuah@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Yuchung Cheng <ycheng@google.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Christoph Paasch <cpaasch@apple.com>,
        Ivan Delalande <colona@arista.com>,
        Caowangbao <caowangbao@huawei.com>,
        Priyaranjan Jha <priyarjha@google.com>, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v8 10/26] tcp: ipv6: Add AO signing for tcp_v6_send_response
Date:   Mon,  5 Sep 2022 10:05:46 +0300
Message-Id: <fa79c5a2779292949444890be6fe92194639d501.1662361354.git.cdleonard@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1662361354.git.cdleonard@gmail.com>
References: <cover.1662361354.git.cdleonard@gmail.com>
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
index 1c2039a48bf6..bb74ab96b18f 100644
--- a/net/ipv4/tcp_authopt.c
+++ b/net/ipv4/tcp_authopt.c
@@ -381,10 +381,11 @@ struct tcp_authopt_key_info *__tcp_authopt_select_key(const struct sock *sk,
 {
 	struct netns_tcp_authopt *net = sock_net_tcp_authopt(sk);
 
 	return tcp_authopt_lookup_send(net, addr_sk);
 }
+EXPORT_SYMBOL(__tcp_authopt_select_key);
 
 static struct tcp_authopt_info *__tcp_authopt_info_get_or_create(struct sock *sk)
 {
 	struct tcp_sock *tp = tcp_sk(sk);
 	struct tcp_authopt_info *info;
@@ -1206,10 +1207,11 @@ int tcp_authopt_hash(char *hash_location,
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
index 8969aee822d5..9e507fcad7cc 100644
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
@@ -853,10 +854,48 @@ const struct tcp_request_sock_ops tcp_request_sock_ipv6_ops = {
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
 				 u8 tclass, __be32 label, u32 priority, u32 txhash)
 {
@@ -868,13 +907,30 @@ static void tcp_v6_send_response(const struct sock *sk, struct sk_buff *skb, u32
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
 
@@ -926,10 +982,14 @@ static void tcp_v6_send_response(const struct sock *sk, struct sk_buff *skb, u32
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

