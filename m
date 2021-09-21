Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C56D413752
	for <lists+netdev@lfdr.de>; Tue, 21 Sep 2021 18:19:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234872AbhIUQTY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Sep 2021 12:19:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234546AbhIUQSm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Sep 2021 12:18:42 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 681A4C061760;
        Tue, 21 Sep 2021 09:17:12 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id co2so29799531edb.8;
        Tue, 21 Sep 2021 09:17:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HG7lO2Auqog9LQbUof/KxwFt3hgNmc5olI0OW6ZVatU=;
        b=mWPnMa30UuQZFU6f2ypidGLMHP2lLlUxl7seL4ZC3pvb3IahmCoC18SugVCWMKy2dX
         0mk7JuPTEPJho06rvrZaCKZgNIYEwHe2NDoelsI36XtLjcLG2Egb/DqYCZIQXWiKVAgu
         fnaZLbjHmuK9oXxc+pgjqbIJ8avquNIhAiEJOjR2pbyrkM6KbAuZKGFnyZXJzEVYP3s6
         ybSZiONhz3gea+LoSGojAFxaEPE5MUPsWcAcVp86zsW6/m1fK/H5g55VK12N/BA0TBDM
         HahcGlJhZtVpDUYGot8imeZC0C1WUYqY2zmyxkrTmMUdnckT49Elegy1sYFT8zzDcBdu
         cvpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HG7lO2Auqog9LQbUof/KxwFt3hgNmc5olI0OW6ZVatU=;
        b=llV+L7a7DX+YucICVK5iqtPh3O0q0ssehw+QXww2zIf2WMGNRRlQy07BmE54g1uicr
         NIONheM93b7RwUUYg06E95+I07imeJ+RUnPX6a8mHLLgw+6w0xv+OvkkahedEN0grfrz
         SwnUpJV5fluYRem7MQBgqfPBZidNUC35sUUgQ69sYPGYM0cXL0aqtMs51BvucIZbuoZ5
         f4OTLyXl8qCM/OwpSY9QNHRDaDB1Y8BE9xO3HKVD49aKLM2RsUcNss4fe1DbZSMunXK0
         bbhV/0iANUtAN5pCD6Vo6dEfunee7cbl3bM0qv19W7vORI39NGouacDWUmfbbwv1GxjI
         ZxFg==
X-Gm-Message-State: AOAM531qk8LxkyfCFcaZYkJGqMghqz6dNSQ3+z7lt4gez8PEcnU8uDh7
        GEC6yEzLUh+snX8zk4K1wrQ=
X-Google-Smtp-Source: ABdhPJwzP4oBIORcv9u/AdUF7zadNt0SEGu2D3IwhLHGlIE446zoe/5qPH3XbXx6k41AsZ/PIuwRZQ==
X-Received: by 2002:a05:6402:455:: with SMTP id p21mr36203509edw.309.1632240933293;
        Tue, 21 Sep 2021 09:15:33 -0700 (PDT)
Received: from pinky.lan ([2a04:241e:502:1df0:b065:9bdf:4016:277])
        by smtp.gmail.com with ESMTPSA id kx17sm7674075ejc.51.2021.09.21.09.15.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Sep 2021 09:15:32 -0700 (PDT)
From:   Leonard Crestez <cdleonard@gmail.com>
To:     Dmitry Safonov <0x7f454c46@gmail.com>,
        David Ahern <dsahern@kernel.org>, Shuah Khan <shuah@kernel.org>
Cc:     Eric Dumazet <edumazet@google.com>,
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
        Priyaranjan Jha <priyarjha@google.com>,
        Menglong Dong <dong.menglong@zte.com.cn>,
        netdev@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 10/19] tcp: ipv6: Add AO signing for tcp_v6_send_response
Date:   Tue, 21 Sep 2021 19:14:53 +0300
Message-Id: <8e833ab5b18f35909261cbd5c117f739f2611e0d.1632240523.git.cdleonard@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1632240523.git.cdleonard@gmail.com>
References: <cover.1632240523.git.cdleonard@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a special code path for acks and resets outside of normal
connection establishment and closing.

Signed-off-by: Leonard Crestez <cdleonard@gmail.com>
---
 net/ipv6/tcp_ipv6.c | 35 +++++++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 724145ddf122..d922219af20e 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -896,13 +896,37 @@ static void tcp_v6_send_response(const struct sock *sk, struct sk_buff *skb, u32
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
+	if (static_branch_unlikely(&tcp_authopt_needed) && sk)
+	{
+		if (sk->sk_state == TCP_TIME_WAIT)
+			authopt_info = tcp_twsk(sk)->tw_authopt_info;
+		else
+			authopt_info = rcu_dereference(tcp_sk(sk)->authopt_info);
+
+		if (authopt_info) {
+			authopt_key_info = __tcp_authopt_select_key(sk, authopt_info, sk, &authopt_rnextkeyid);
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
 
@@ -955,10 +979,21 @@ static void tcp_v6_send_response(const struct sock *sk, struct sk_buff *skb, u32
 		tcp_v6_md5_hash_hdr((__u8 *)topt, key,
 				    &ipv6_hdr(skb)->saddr,
 				    &ipv6_hdr(skb)->daddr, t1);
 	}
 #endif
+#ifdef CONFIG_TCP_AUTHOPT
+	/* Compute the TCP-AO mac. Unlike in the ipv4 case we have a real SKB */
+	if (static_branch_unlikely(&tcp_authopt_needed) && authopt_key_info)
+	{
+		*topt++ = htonl((TCPOPT_AUTHOPT << 24) |
+				(TCPOLEN_AUTHOPT_OUTPUT << 16) |
+				(authopt_key_info->send_id << 8) |
+				(authopt_rnextkeyid));
+		tcp_authopt_hash((char*)topt, authopt_key_info, (struct sock*)sk, buff);
+	}
+#endif
 
 	memset(&fl6, 0, sizeof(fl6));
 	fl6.daddr = ipv6_hdr(skb)->saddr;
 	fl6.saddr = ipv6_hdr(skb)->daddr;
 	fl6.flowlabel = label;
-- 
2.25.1

