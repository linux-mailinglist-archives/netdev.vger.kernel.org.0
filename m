Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A65E4B6ADF
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 12:31:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237157AbiBOLbJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 06:31:09 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233225AbiBOLbI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 06:31:08 -0500
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E22EE108579;
        Tue, 15 Feb 2022 03:30:58 -0800 (PST)
Received: by mail-pj1-x1041.google.com with SMTP id v13-20020a17090ac90d00b001b87bc106bdso2457667pjt.4;
        Tue, 15 Feb 2022 03:30:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FopBqDGN1xvSfvHr1/isUkSeSoRhL/jVtgtKDPYdFpU=;
        b=IGwbe9O7s9kGyAba/oCqEBwGzIGpdc8uyBYEv7FAL+Yv68NIULN+o5C6Ea+UY9yPz6
         akqBxoQTm22So/5zQS7MeN9XWLd5ZUQg7AvPgkAyp/WtwMyrD7nUAEBwqXlhiYzghZL3
         JYUyoYoc7y71Z6gxa0FDSM3LP1pVZMt3+9Gz4xVajJnTO/75qkBUZNARZPA+6al4wXD/
         EC4jyKUr4zDjj572P3RJoJ61+jXXp1Hd9Dtnzvu/mlrnH4VurmvAl4MLExhmKp/OU0Vj
         ecpN0VuWe4KWF/CeyQQcO7ywR5cd06aUkbRRTTqM35PAzs0CsIyEt5EbbLNv+36nvNHR
         h6qA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FopBqDGN1xvSfvHr1/isUkSeSoRhL/jVtgtKDPYdFpU=;
        b=gzQ6BGaq98kSeJJE8fyoi9l/cWHuaWwyvg9g/VGu2GRNHY3G0Za4kQOJJQf/leK2Ki
         tQQeLHZh99UxV06U5s7QxpejVIeIqUlJmAewiZxsq+jcpBluzeUSe9gSx+0PWSCk9XgZ
         Nb1y6/PXPs8mGS1Imeimsl5j6P/WP3rQP7CFcsuTqnqcdYIJoDULQxPw7T0X1w0zTvh1
         rxX5L5N/ln3Ki32knJyOV/jpc2xVkciw3YgQiVf3WZ8ODIgEg+6q+jd+1xKx4jTQvFRV
         7WwtvIfqxqtRXXwcx76a4e0cgySnWSJR5l9MxCZvyKITk3sCdIOv3vNdIdeu0Jt9kWc2
         czuA==
X-Gm-Message-State: AOAM532DUjhQkxNRHWaC0TL5Y8iVVfLSF6ayMKkLH0tdXxazeFLhpOUF
        jlZQGXCuM+EVCkLcDxepDB4=
X-Google-Smtp-Source: ABdhPJxQZIyu+PGvgF4UOkN3FfQLFh8YNePAKEznjwKiMAJtrmH4E+Qk9Cow4/Es3aS1lSqNTbRlrA==
X-Received: by 2002:a17:903:32d1:: with SMTP id i17mr3530064plr.55.1644924658483;
        Tue, 15 Feb 2022 03:30:58 -0800 (PST)
Received: from localhost.localdomain ([203.205.141.113])
        by smtp.gmail.com with ESMTPSA id s11sm44515513pfu.58.2022.02.15.03.30.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Feb 2022 03:30:58 -0800 (PST)
From:   menglong8.dong@gmail.com
X-Google-Original-From: imagedong@tencent.com
To:     dsahern@kernel.org, kuba@kernel.org
Cc:     edumazet@google.com, davem@davemloft.net, rostedt@goodmis.org,
        mingo@redhat.com, yoshfuji@linux-ipv6.org, ast@kernel.org,
        daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
        imagedong@tencent.com, talalahmad@google.com,
        keescook@chromium.org, ilias.apalodimas@linaro.org, alobakin@pm.me,
        memxor@gmail.com, atenart@kernel.org, bigeasy@linutronix.de,
        pabeni@redhat.com, linyunsheng@huawei.com, arnd@arndb.de,
        yajun.deng@linux.dev, roopa@nvidia.com, willemb@google.com,
        vvs@virtuozzo.com, cong.wang@bytedance.com,
        luiz.von.dentz@intel.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org, flyingpeng@tencent.com
Subject: [PATCH net-next 03/19] net: tcp: use kfree_skb_reason() for tcp_v6_rcv()
Date:   Tue, 15 Feb 2022 19:27:56 +0800
Message-Id: <20220215112812.2093852-4-imagedong@tencent.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220215112812.2093852-1-imagedong@tencent.com>
References: <20220215112812.2093852-1-imagedong@tencent.com>
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

From: Menglong Dong <imagedong@tencent.com>

Replace kfree_skb() used in tcp_v6_rcv() with kfree_skb_reason().

Signed-off-by: Menglong Dong <imagedong@tencent.com>
---
 net/ipv6/tcp_ipv6.c | 25 ++++++++++++++++++++-----
 1 file changed, 20 insertions(+), 5 deletions(-)

diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 0c648bf07f39..402ffbacc371 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -1627,6 +1627,7 @@ static void tcp_v6_fill_cb(struct sk_buff *skb, const struct ipv6hdr *hdr,
 
 INDIRECT_CALLABLE_SCOPE int tcp_v6_rcv(struct sk_buff *skb)
 {
+	enum skb_drop_reason drop_reason;
 	int sdif = inet6_sdif(skb);
 	int dif = inet6_iif(skb);
 	const struct tcphdr *th;
@@ -1636,6 +1637,7 @@ INDIRECT_CALLABLE_SCOPE int tcp_v6_rcv(struct sk_buff *skb)
 	int ret;
 	struct net *net = dev_net(skb->dev);
 
+	drop_reason = SKB_DROP_REASON_NOT_SPECIFIED;
 	if (skb->pkt_type != PACKET_HOST)
 		goto discard_it;
 
@@ -1649,8 +1651,10 @@ INDIRECT_CALLABLE_SCOPE int tcp_v6_rcv(struct sk_buff *skb)
 
 	th = (const struct tcphdr *)skb->data;
 
-	if (unlikely(th->doff < sizeof(struct tcphdr)/4))
+	if (unlikely(th->doff < sizeof(struct tcphdr) / 4)) {
+		drop_reason = SKB_DROP_REASON_PKT_TOO_SMALL;
 		goto bad_packet;
+	}
 	if (!pskb_may_pull(skb, th->doff*4))
 		goto discard_it;
 
@@ -1706,6 +1710,8 @@ INDIRECT_CALLABLE_SCOPE int tcp_v6_rcv(struct sk_buff *skb)
 			hdr = ipv6_hdr(skb);
 			tcp_v6_fill_cb(skb, hdr, th);
 			nsk = tcp_check_req(sk, skb, req, false, &req_stolen);
+		} else {
+			drop_reason = SKB_DROP_REASON_SOCKET_FILTER;
 		}
 		if (!nsk) {
 			reqsk_put(req);
@@ -1741,14 +1747,18 @@ INDIRECT_CALLABLE_SCOPE int tcp_v6_rcv(struct sk_buff *skb)
 		}
 	}
 
-	if (!xfrm6_policy_check(sk, XFRM_POLICY_IN, skb))
+	if (!xfrm6_policy_check(sk, XFRM_POLICY_IN, skb)) {
+		drop_reason = SKB_DROP_REASON_XFRM_POLICY;
 		goto discard_and_relse;
+	}
 
 	if (tcp_v6_inbound_md5_hash(sk, skb, dif, sdif))
 		goto discard_and_relse;
 
-	if (tcp_filter(sk, skb))
+	if (tcp_filter(sk, skb)) {
+		drop_reason = SKB_DROP_REASON_SOCKET_FILTER;
 		goto discard_and_relse;
+	}
 	th = (const struct tcphdr *)skb->data;
 	hdr = ipv6_hdr(skb);
 	tcp_v6_fill_cb(skb, hdr, th);
@@ -1779,13 +1789,17 @@ INDIRECT_CALLABLE_SCOPE int tcp_v6_rcv(struct sk_buff *skb)
 	return ret ? -1 : 0;
 
 no_tcp_socket:
-	if (!xfrm6_policy_check(NULL, XFRM_POLICY_IN, skb))
+	drop_reason = SKB_DROP_REASON_NO_SOCKET;
+	if (!xfrm6_policy_check(NULL, XFRM_POLICY_IN, skb)) {
+		drop_reason = SKB_DROP_REASON_XFRM_POLICY;
 		goto discard_it;
+	}
 
 	tcp_v6_fill_cb(skb, hdr, th);
 
 	if (tcp_checksum_complete(skb)) {
 csum_error:
+		drop_reason = SKB_DROP_REASON_TCP_CSUM;
 		trace_tcp_bad_csum(skb);
 		__TCP_INC_STATS(net, TCP_MIB_CSUMERRORS);
 bad_packet:
@@ -1795,7 +1809,7 @@ INDIRECT_CALLABLE_SCOPE int tcp_v6_rcv(struct sk_buff *skb)
 	}
 
 discard_it:
-	kfree_skb(skb);
+	kfree_skb_reason(skb, drop_reason);
 	return 0;
 
 discard_and_relse:
@@ -1806,6 +1820,7 @@ INDIRECT_CALLABLE_SCOPE int tcp_v6_rcv(struct sk_buff *skb)
 
 do_time_wait:
 	if (!xfrm6_policy_check(NULL, XFRM_POLICY_IN, skb)) {
+		drop_reason = SKB_DROP_REASON_XFRM_POLICY;
 		inet_twsk_put(inet_twsk(sk));
 		goto discard_it;
 	}
-- 
2.34.1

