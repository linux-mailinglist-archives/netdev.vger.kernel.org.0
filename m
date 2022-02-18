Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E8874BB43F
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 09:32:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232673AbiBRIdH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Feb 2022 03:33:07 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:36514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232608AbiBRIdF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Feb 2022 03:33:05 -0500
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1352725C4C;
        Fri, 18 Feb 2022 00:32:41 -0800 (PST)
Received: by mail-pj1-x1042.google.com with SMTP id v8-20020a17090a634800b001bb78857ccdso9411562pjs.1;
        Fri, 18 Feb 2022 00:32:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1aXicT9qw5QUx4C+4Sp32SMUaBke04euNccpEFm6KM8=;
        b=AxWREr1taEu/Em4kI82NR3yADVU4HC5JmCrNMATYwZcfqZjmzX/jNtM6BOUDTjf0pf
         ckYm4VNoI/ViwsBDpGCnykAUhQPwWw5qH/DSRK0/HIqxNQUx45Y/JC2FX+z8rOBG8rNc
         ciA6ylL/rm6fqnPr0Kt3gEEyvzynmtmzhiCnKq+IrUUyR0AdbyVL40HyTxDir907uoaC
         EzWzu0mAGBh9wkhWkEjuhALmXSIjVCbNxlXKPXhI6N/7WxV74HWwp9xzGaDZLbl+3kaD
         hR4n/AzpePYLviI3asplmzv5M0sfFZ1G0DztTmvzgBQfQlrIRhN/JyoWde+qKrfvM3ud
         7fPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1aXicT9qw5QUx4C+4Sp32SMUaBke04euNccpEFm6KM8=;
        b=1ntOmv+dnX89ai7BXs1QVnwRBg2NWvmRhIbzUEYBEScGZxQVoQ1LMN7flzj+VCQJw4
         3qvrt4KHgOxhAIqXEBihW5lZGC/vwfPd7H+pf3peorqQJHA5bvk5xMxNwibnL7aLU/2S
         LndzsiUOvJkviqM/Fn77OBZn3pL29ECI7FRwSgw5XAPYHWdcD0hP4JCyxD4Mcprv0Xme
         BouSywpVKgOd+AWlsjjy8gpOoCq8xaslhnmW7WW6g4kapjhi2N1wYMgl2RJPoutHvN+P
         zgkLEfcQ56C6BX/5ULcTRrUF7Q74W3k1GB9DSac3fFwMRJMB0Q3BunWqzjT8qJvoMiZW
         hlWQ==
X-Gm-Message-State: AOAM531cLnutVoSKDnggd28JfOqxnxGwe0iPtMlDJk5Ula5OGmQ8wGG2
        7mm9ppS39Zz87GYlHmzl66SrcbI+Y6I=
X-Google-Smtp-Source: ABdhPJyElHfHGU29zw2n/hQXAdUksNN5Ta5aMaIBj6MG9qCJGwAmhVSptlDknzSjscPDr4T8ST20FQ==
X-Received: by 2002:a17:902:8bc1:b0:14c:f41b:b3b6 with SMTP id r1-20020a1709028bc100b0014cf41bb3b6mr6614828plo.168.1645173161475;
        Fri, 18 Feb 2022 00:32:41 -0800 (PST)
Received: from localhost.localdomain ([203.205.141.113])
        by smtp.gmail.com with ESMTPSA id m23sm1963530pff.201.2022.02.18.00.32.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Feb 2022 00:32:41 -0800 (PST)
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
Subject: [PATCH net-next v2 3/9] net: tcp: use kfree_skb_reason() for tcp_v6_rcv()
Date:   Fri, 18 Feb 2022 16:31:27 +0800
Message-Id: <20220218083133.18031-4-imagedong@tencent.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220218083133.18031-1-imagedong@tencent.com>
References: <20220218083133.18031-1-imagedong@tencent.com>
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
2.34.1

