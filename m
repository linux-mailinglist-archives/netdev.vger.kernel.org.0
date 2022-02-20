Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 498A34BCD08
	for <lists+netdev@lfdr.de>; Sun, 20 Feb 2022 08:18:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243041AbiBTHIc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Feb 2022 02:08:32 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236524AbiBTHI1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Feb 2022 02:08:27 -0500
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 485F04D9DB;
        Sat, 19 Feb 2022 23:08:04 -0800 (PST)
Received: by mail-pg1-x543.google.com with SMTP id w37so5149855pga.7;
        Sat, 19 Feb 2022 23:08:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8u5WsBGNkZ7pT95RfoIg7CD5GpWfzFZGJFFZCp3bMAA=;
        b=qMvJ9sniefGek1IVFdhPZTpyvssbYOLVB7YbhrHr8WqHIzKrNaBC0C6S2L98Wv0Tpb
         M+jHs5tQBRFCSoEwq3N/dgEBWabtmcubYlNtxWOC1z7dlW+kFxZH1vbH8NM7ktNWFL3P
         b+P/qIw+PwSVlClCFlBx10JaHGd/j9NFR8uJ82yxU5CPXGlg66KYcn5xgb7sC8A1TdaU
         6LFwYdje4nFBqYJG3aY1Ot0xIV2GrHMyl6E00TmuML9d/o/2sUNkhX+KDwuyS6m6g8I1
         7beNLaTypmoNEKAqW6mO7pGeq+GFh6rplit+RPRqxV14Uj/dFa5FGnMsEHwcFQRKLKWy
         PrUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8u5WsBGNkZ7pT95RfoIg7CD5GpWfzFZGJFFZCp3bMAA=;
        b=lgf0q/QBPUZAkVxhv6ImuDrIlWDF6S3TX0kVKOD/wRy2kxdtroJTD5JaYRwdhIergd
         vM1iX5fVnDN5Tc68uGIfvtAhPStYAkVgI61o+83MmpU8Q7uBAwfiLpa5Q3pgELBqaDOS
         c50JcG4fLtw8R3d341Efcw48zrZSfCDrXSCIUHSSdaad5SGro5apGYOoZ5ciXPCVKTtC
         3tJuYXd66hsEPGIMiLrkewQDH3IcOiEjprWRC3ZwlQZdO6Y9Uaxl/a0tqsb0gmlv8AMr
         kJ7pt0i6MSyZ05kYmUT7FNMTH+g0i5reLPNzVuvh9mwRtDbq7exnqXb7Z19tOyj3EUaB
         WAvw==
X-Gm-Message-State: AOAM532SpIsz3xPOkGx7Suv596F0LEKY2XuzcNNxVe7T8F35lkjk+LcM
        qp9M9nOeg3EOkGALw6JzE1Y=
X-Google-Smtp-Source: ABdhPJxjp1/yZgsFZkomrtMEQ0mkh/Wclyl0cElsG13pPemp2GHsno2uQc3AQls1YV0Ayk/eAtlZsQ==
X-Received: by 2002:a05:6a00:27a7:b0:4e1:5cf4:2429 with SMTP id bd39-20020a056a0027a700b004e15cf42429mr15169090pfb.73.1645340883788;
        Sat, 19 Feb 2022 23:08:03 -0800 (PST)
Received: from localhost.localdomain ([203.205.141.114])
        by smtp.gmail.com with ESMTPSA id p1sm8351326pfo.212.2022.02.19.23.07.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Feb 2022 23:08:03 -0800 (PST)
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
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        flyingpeng@tencent.com, mengensun@tencent.com
Subject: [PATCH net-next v3 3/9] net: tcp: use kfree_skb_reason() for tcp_v6_rcv()
Date:   Sun, 20 Feb 2022 15:06:31 +0800
Message-Id: <20220220070637.162720-4-imagedong@tencent.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220220070637.162720-1-imagedong@tencent.com>
References: <20220220070637.162720-1-imagedong@tencent.com>
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

Reviewed-by: Mengen Sun <mengensun@tencent.com>
Reviewed-by: Hao Peng <flyingpeng@tencent.com>
Signed-off-by: Menglong Dong <imagedong@tencent.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
---
v2:
- let NO_SOCKET trump the XFRM failure
---
 net/ipv6/tcp_ipv6.c | 21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 0c648bf07f39..0aa17073df1a 100644
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
@@ -1779,6 +1789,7 @@ INDIRECT_CALLABLE_SCOPE int tcp_v6_rcv(struct sk_buff *skb)
 	return ret ? -1 : 0;
 
 no_tcp_socket:
+	drop_reason = SKB_DROP_REASON_NO_SOCKET;
 	if (!xfrm6_policy_check(NULL, XFRM_POLICY_IN, skb))
 		goto discard_it;
 
@@ -1786,6 +1797,7 @@ INDIRECT_CALLABLE_SCOPE int tcp_v6_rcv(struct sk_buff *skb)
 
 	if (tcp_checksum_complete(skb)) {
 csum_error:
+		drop_reason = SKB_DROP_REASON_TCP_CSUM;
 		trace_tcp_bad_csum(skb);
 		__TCP_INC_STATS(net, TCP_MIB_CSUMERRORS);
 bad_packet:
@@ -1795,7 +1807,7 @@ INDIRECT_CALLABLE_SCOPE int tcp_v6_rcv(struct sk_buff *skb)
 	}
 
 discard_it:
-	kfree_skb(skb);
+	kfree_skb_reason(skb, drop_reason);
 	return 0;
 
 discard_and_relse:
@@ -1806,6 +1818,7 @@ INDIRECT_CALLABLE_SCOPE int tcp_v6_rcv(struct sk_buff *skb)
 
 do_time_wait:
 	if (!xfrm6_policy_check(NULL, XFRM_POLICY_IN, skb)) {
+		drop_reason = SKB_DROP_REASON_XFRM_POLICY;
 		inet_twsk_put(inet_twsk(sk));
 		goto discard_it;
 	}
-- 
2.35.1

