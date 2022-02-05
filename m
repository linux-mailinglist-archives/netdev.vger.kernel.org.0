Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 292084AA769
	for <lists+netdev@lfdr.de>; Sat,  5 Feb 2022 08:48:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379626AbiBEHsN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Feb 2022 02:48:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379616AbiBEHsK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Feb 2022 02:48:10 -0500
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15E25C061346;
        Fri,  4 Feb 2022 23:48:10 -0800 (PST)
Received: by mail-pg1-x541.google.com with SMTP id 132so6957985pga.5;
        Fri, 04 Feb 2022 23:48:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=sFiIBBP1Guui5oRSHFXqQ0kp8WoqnfYPGN8qeO2nDPI=;
        b=DQ99ihcLC8cBdBgbZQSM0PkCxeuitr5MJsirC0PzI97NWQxdEQNzwiTQVI2FhHB4GV
         HYIEGDVOj21dMueNW+QjsgJm/PSZ2hZDBxtUfy5lGS40XA9urs082YX9APrU0wnJ0edy
         4jSWThygzinO0iFkx5RfrhBC/Gnq+sTfvn5FyRjQDu9i4/pxQ1yugnTspwB18a3jX4D5
         WnrQ1nXw5Ap0N5pVonRIksi6gWT+LzYiU16P8Ek+vBVj10Cwdy2vP3ZiO3Y+XvP5FCDr
         MEHNWdQDm41h+2b0pKl2LsIpocMqTEP35HeJh5CfOavQbjfpQI97mh9OGSY8Kqqh3/fB
         Edag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sFiIBBP1Guui5oRSHFXqQ0kp8WoqnfYPGN8qeO2nDPI=;
        b=dGn3v1T+2zOiS9JJd4D81/iNT9ArhXxFUrUOyzPdI5n2sj64TeXd+Bcf43+OW7Km+F
         Pr+/0ShK1ZcOmXHWtS5HhtjhbHw71HoFKhGH9h0ZjNsM3yzTqpAvdV62zQY9Tw1YtrZC
         Yg2jtWYnh1Rmd0RyWXYnK5OkAso0+RuCwtbcrE9kkwFB+W4QP2hffZ3nVshpE5MVAGJN
         A2mCiGjGY46w97T/x/XLbPWismHhiZ1orNVQeZuPMit+ADXXq2ZQmocIT6ccmKLb1UJd
         X3wdHAsiTKyLJ4/YEbTAwEqBWxHSAGJaRXpQtw7RJ5GVrkRsshzmajnHbOA4+J9uhXBI
         gmVQ==
X-Gm-Message-State: AOAM533qok4/FhfvdKUZgsKaX25b26GqPudnZ09H5yjK6lGvUvENlUyV
        96ZMNo0O1QnV62metb+XKQM=
X-Google-Smtp-Source: ABdhPJy6YuvWmffNaucuXUNOerDuDJ2/JIIG75tQEAluYEG2WQYH2r9XmaR4U/bZqbeTO6kazRRUcw==
X-Received: by 2002:a65:6e07:: with SMTP id bd7mr2140187pgb.457.1644047289645;
        Fri, 04 Feb 2022 23:48:09 -0800 (PST)
Received: from localhost.localdomain ([43.132.141.4])
        by smtp.gmail.com with ESMTPSA id p21sm5165844pfh.89.2022.02.04.23.48.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Feb 2022 23:48:09 -0800 (PST)
From:   menglong8.dong@gmail.com
X-Google-Original-From: imagedong@tencent.com
To:     dsahern@kernel.org, kuba@kernel.org
Cc:     rostedt@goodmis.org, mingo@redhat.com, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, pablo@netfilter.org, kadlec@netfilter.org,
        fw@strlen.de, edumazet@google.com, alobakin@pm.me, ast@kernel.org,
        imagedong@tencent.com, pabeni@redhat.com, keescook@chromium.org,
        talalahmad@google.com, haokexin@gmail.com,
        ilias.apalodimas@linaro.org, memxor@gmail.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        paulb@nvidia.com, cong.wang@bytedance.com, mengensun@tencent.com
Subject: [PATCH v4 net-next 3/7] net: ipv4: use kfree_skb_reason() in ip_rcv_core()
Date:   Sat,  5 Feb 2022 15:47:35 +0800
Message-Id: <20220205074739.543606-4-imagedong@tencent.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220205074739.543606-1-imagedong@tencent.com>
References: <20220205074739.543606-1-imagedong@tencent.com>
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

Replace kfree_skb() with kfree_skb_reason() in ip_rcv_core(). Three new
drop reasons are introduced:

SKB_DROP_REASON_OTHERHOST
SKB_DROP_REASON_IP_CSUM
SKB_DROP_REASON_IP_INHDR

Signed-off-by: Menglong Dong <imagedong@tencent.com>
---
v4:
- stop making assumptions about the value of
  SKB_DROP_REASON_NOT_SPECIFIED

v3:
- add a path to SKB_DROP_REASON_PKT_TOO_SMALL

v2:
- remove unrelated cleanup
- add document for introduced drop reasons
---
 include/linux/skbuff.h     |  9 +++++++++
 include/trace/events/skb.h |  3 +++
 net/ipv4/ip_input.c        | 12 ++++++++++--
 3 files changed, 22 insertions(+), 2 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 9060159b4375..8e82130b3c52 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -321,6 +321,15 @@ enum skb_drop_reason {
 	SKB_DROP_REASON_SOCKET_FILTER,	/* dropped by socket filter */
 	SKB_DROP_REASON_UDP_CSUM,	/* UDP checksum error */
 	SKB_DROP_REASON_NETFILTER_DROP,	/* dropped by netfilter */
+	SKB_DROP_REASON_OTHERHOST,	/* packet don't belong to current
+					 * host (interface is in promisc
+					 * mode)
+					 */
+	SKB_DROP_REASON_IP_CSUM,	/* IP checksum error */
+	SKB_DROP_REASON_IP_INHDR,	/* there is something wrong with
+					 * IP header (see
+					 * IPSTATS_MIB_INHDRERRORS)
+					 */
 	SKB_DROP_REASON_MAX,
 };
 
diff --git a/include/trace/events/skb.h b/include/trace/events/skb.h
index 3d89f7b09a43..f2b1778485f0 100644
--- a/include/trace/events/skb.h
+++ b/include/trace/events/skb.h
@@ -17,6 +17,9 @@
 	EM(SKB_DROP_REASON_SOCKET_FILTER, SOCKET_FILTER)	\
 	EM(SKB_DROP_REASON_UDP_CSUM, UDP_CSUM)			\
 	EM(SKB_DROP_REASON_NETFILTER_DROP, NETFILTER_DROP)	\
+	EM(SKB_DROP_REASON_OTHERHOST, OTHERHOST)		\
+	EM(SKB_DROP_REASON_IP_CSUM, IP_CSUM)			\
+	EM(SKB_DROP_REASON_IP_INHDR, IP_INHDR)			\
 	EMe(SKB_DROP_REASON_MAX, MAX)
 
 #undef EM
diff --git a/net/ipv4/ip_input.c b/net/ipv4/ip_input.c
index 3a025c011971..7be18de32e16 100644
--- a/net/ipv4/ip_input.c
+++ b/net/ipv4/ip_input.c
@@ -436,13 +436,16 @@ static int ip_rcv_finish(struct net *net, struct sock *sk, struct sk_buff *skb)
 static struct sk_buff *ip_rcv_core(struct sk_buff *skb, struct net *net)
 {
 	const struct iphdr *iph;
+	int drop_reason;
 	u32 len;
 
 	/* When the interface is in promisc. mode, drop all the crap
 	 * that it receives, do not try to analyse it.
 	 */
-	if (skb->pkt_type == PACKET_OTHERHOST)
+	if (skb->pkt_type == PACKET_OTHERHOST) {
+		drop_reason = SKB_DROP_REASON_OTHERHOST;
 		goto drop;
+	}
 
 	__IP_UPD_PO_STATS(net, IPSTATS_MIB_IN, skb->len);
 
@@ -452,6 +455,7 @@ static struct sk_buff *ip_rcv_core(struct sk_buff *skb, struct net *net)
 		goto out;
 	}
 
+	drop_reason = SKB_DROP_REASON_NOT_SPECIFIED;
 	if (!pskb_may_pull(skb, sizeof(struct iphdr)))
 		goto inhdr_error;
 
@@ -488,6 +492,7 @@ static struct sk_buff *ip_rcv_core(struct sk_buff *skb, struct net *net)
 
 	len = ntohs(iph->tot_len);
 	if (skb->len < len) {
+		drop_reason = SKB_DROP_REASON_PKT_TOO_SMALL;
 		__IP_INC_STATS(net, IPSTATS_MIB_INTRUNCATEDPKTS);
 		goto drop;
 	} else if (len < (iph->ihl*4))
@@ -516,11 +521,14 @@ static struct sk_buff *ip_rcv_core(struct sk_buff *skb, struct net *net)
 	return skb;
 
 csum_error:
+	drop_reason = SKB_DROP_REASON_IP_CSUM;
 	__IP_INC_STATS(net, IPSTATS_MIB_CSUMERRORS);
 inhdr_error:
+	if (drop_reason == SKB_DROP_REASON_NOT_SPECIFIED)
+		drop_reason = SKB_DROP_REASON_IP_INHDR;
 	__IP_INC_STATS(net, IPSTATS_MIB_INHDRERRORS);
 drop:
-	kfree_skb(skb);
+	kfree_skb_reason(skb, drop_reason);
 out:
 	return NULL;
 }
-- 
2.34.1

