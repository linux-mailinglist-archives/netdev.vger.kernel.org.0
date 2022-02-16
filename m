Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82F454B7EFD
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 04:58:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245334AbiBPDzb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 22:55:31 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:50472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237587AbiBPDz3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 22:55:29 -0500
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47AA5F68C1;
        Tue, 15 Feb 2022 19:55:18 -0800 (PST)
Received: by mail-pj1-x1042.google.com with SMTP id n19-20020a17090ade9300b001b9892a7bf9so5270416pjv.5;
        Tue, 15 Feb 2022 19:55:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FopBqDGN1xvSfvHr1/isUkSeSoRhL/jVtgtKDPYdFpU=;
        b=CYVNGMa8rDwkhf7bAgvaLIinbioqCYjgemaj4yyS0OXyzdWILVe4owz3oI0pLlckSY
         mEb1MJdZGFDRV4prg82yBQw5+f16MhiEC6oSiehKrLemdaQ5LTuCwQfZ8ZcUPXmLER7u
         0s0f+llVp/lJRwCNX3wembmUEroNGoKjTl5UEJ5OEC5ktsgNOslNiZ3+N0jC+F08agE5
         Eu9Y4AsmnufaRWUQkkPwuosBZBGaqQxbMAIKpOKU5Le2ON+3i6BSqjreQgiy/4N+MAga
         dVYyK0KgfdMfr85a8eKp+x8GNZ497kHo3FUUmqDPPxW39XS1HIhMZ1uZKf48pjcVuZZq
         Wq5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FopBqDGN1xvSfvHr1/isUkSeSoRhL/jVtgtKDPYdFpU=;
        b=tcBZ4hbSIRCPa586Sz4uWIlLMdDnTR4pB2DTuC38IJIewsEqtxD7zsWDoBBsWaYHl3
         RApzmhC66/ZYwCZ219MXqKcE9RVmW/KydsRLqdCSLYF7Pvsm5rVpjF/VOJLxMBh/dbHF
         5wQzG2Jhj83HOv/vFFaM4xt5KIKHapJxw3LYl+lztajjp6T5a4WK2ZTQRorE1gch6byv
         crHpzJ5JojrnOQ5LMO0QwI3Po00vulwZ4izMGJT4O1BBKrWD7TFMftbliCBYS+OdCP+C
         8t10aTMzuaPVvyKN3ANKkScDfRuqsLAg8nom2QysOquM3wCC6tNL1ZqUkCl2h4elGi6C
         FxxA==
X-Gm-Message-State: AOAM531J26jKD499oQC7KXMVRDe9ISnCK7u20DCkvN+awXdGPZn5ZlA7
        kFVCF7tK5h7QAFooGQ2SZBY=
X-Google-Smtp-Source: ABdhPJxVxw7qFEjG4EejSaTzDq5m9WoyT3km2NahQju/FMrU285HmaSfJJXLJW3r3hIpZO7mhUwU0w==
X-Received: by 2002:a17:90a:7e16:b0:1b8:2c11:73da with SMTP id i22-20020a17090a7e1600b001b82c1173damr752883pjl.156.1644983717901;
        Tue, 15 Feb 2022 19:55:17 -0800 (PST)
Received: from localhost.localdomain ([203.205.141.110])
        by smtp.gmail.com with ESMTPSA id nn16sm19099668pjb.2.2022.02.15.19.55.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Feb 2022 19:55:17 -0800 (PST)
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
Subject: [PATCH net-next 3/9] net: tcp: use kfree_skb_reason() for tcp_v6_rcv()
Date:   Wed, 16 Feb 2022 11:54:20 +0800
Message-Id: <20220216035426.2233808-4-imagedong@tencent.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220216035426.2233808-1-imagedong@tencent.com>
References: <20220216035426.2233808-1-imagedong@tencent.com>
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

