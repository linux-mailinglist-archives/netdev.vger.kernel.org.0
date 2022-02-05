Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE5DA4AA772
	for <lists+netdev@lfdr.de>; Sat,  5 Feb 2022 08:48:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379623AbiBEHsj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Feb 2022 02:48:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379675AbiBEHsc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Feb 2022 02:48:32 -0500
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0016DC043181;
        Fri,  4 Feb 2022 23:48:27 -0800 (PST)
Received: by mail-pg1-x541.google.com with SMTP id d186so6942900pgc.9;
        Fri, 04 Feb 2022 23:48:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vuMg5gP1AvDBwmfdMA51t/vA+B/PiJBXh2REFxOfw54=;
        b=lOqSxAbSrVgG5tb3MddjDKLiXN5VTHlx11l34pBRQGCCdeJdTRCngGVEHOPp06IISc
         lfx0brfLsrYFF5KB+jvPjgQbaW3HHY9RB1xy/Ko4TQWNpGt7w2Z2jVc490rInD3gVU8X
         lQ0rLRl1n7C3oX+fBYjP23RiLGd+snvhYoZr1y1+phZWWB5DCrhg0yKVjNirxK8XYvmt
         XZDyx5LBpg3VAYuu9k9TNva6ExU4JjjvVtxIFSEBk1cxI0lXXT6mtzAi9A3qby0nV1K+
         aWnjA9XAMGCK1gYBN8roX+e+Yo3kAlzCGA08mgM5DiUwcuJMS3iii2Ug2afE3HMkRetA
         R9mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vuMg5gP1AvDBwmfdMA51t/vA+B/PiJBXh2REFxOfw54=;
        b=AywERpslPmBFYHF8q9twZpkwytovfP7NOyuneaV1TA5vBKz4m8EuGreCfNSb/DcvCF
         qFS8YosCfpAgjxzlQOu1iKS8+AfGrOGSmzzKSuKG5UWyMJ+hRYbddYSIfMLzK8xIIn7E
         2W1qa9DS/pdXbsXh98emOSqg4xC4P3P/+6KsLSyQ5eENW/atcGGyDdMyDo4WojWTzQ7H
         el2FacAa80tAddSXM+iziTn8fZCBt5ZffneqOTvYUWfwLEHMGRAbOFHt6+k8OeLtMnsa
         tmeT6Vc89YNjgJfH34TD/THbnHPHovR8dz3O7JlgCM7G5bkGADOpb/TlZPE0UlWR6fiQ
         upyg==
X-Gm-Message-State: AOAM532nCpnP38izuFLlhcC1TYYkBLAxqRfU8yF06g+tnSETlOYxgrUb
        wPswEmLy4Xkh8ULOu+6+apk=
X-Google-Smtp-Source: ABdhPJyAEWQL3GK2BBmvcFJucPpj4coI+RHrzYxEplUC57XpedYMnAhKgn7wVRPS+nkK7nG2mdbPQA==
X-Received: by 2002:a63:e302:: with SMTP id f2mr2142691pgh.451.1644047307553;
        Fri, 04 Feb 2022 23:48:27 -0800 (PST)
Received: from localhost.localdomain ([43.132.141.4])
        by smtp.gmail.com with ESMTPSA id p21sm5165844pfh.89.2022.02.04.23.48.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Feb 2022 23:48:26 -0800 (PST)
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
Subject: [PATCH v4 net-next 6/7] net: udp: use kfree_skb_reason() in udp_queue_rcv_one_skb()
Date:   Sat,  5 Feb 2022 15:47:38 +0800
Message-Id: <20220205074739.543606-7-imagedong@tencent.com>
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

Replace kfree_skb() with kfree_skb_reason() in udp_queue_rcv_one_skb().

Signed-off-by: Menglong Dong <imagedong@tencent.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
---
v2:
- use SKB_DROP_REASON_SOCKET_FILTER instead of
  SKB_DROP_REASON_UDP_FILTER
---
 net/ipv4/udp.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 090360939401..952f5bf108a5 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -2120,14 +2120,17 @@ static int __udp_queue_rcv_skb(struct sock *sk, struct sk_buff *skb)
  */
 static int udp_queue_rcv_one_skb(struct sock *sk, struct sk_buff *skb)
 {
+	int drop_reason = SKB_DROP_REASON_NOT_SPECIFIED;
 	struct udp_sock *up = udp_sk(sk);
 	int is_udplite = IS_UDPLITE(sk);
 
 	/*
 	 *	Charge it to the socket, dropping if the queue is full.
 	 */
-	if (!xfrm4_policy_check(sk, XFRM_POLICY_IN, skb))
+	if (!xfrm4_policy_check(sk, XFRM_POLICY_IN, skb)) {
+		drop_reason = SKB_DROP_REASON_XFRM_POLICY;
 		goto drop;
+	}
 	nf_reset_ct(skb);
 
 	if (static_branch_unlikely(&udp_encap_needed_key) && up->encap_type) {
@@ -2204,8 +2207,10 @@ static int udp_queue_rcv_one_skb(struct sock *sk, struct sk_buff *skb)
 	    udp_lib_checksum_complete(skb))
 			goto csum_error;
 
-	if (sk_filter_trim_cap(sk, skb, sizeof(struct udphdr)))
+	if (sk_filter_trim_cap(sk, skb, sizeof(struct udphdr))) {
+		drop_reason = SKB_DROP_REASON_SOCKET_FILTER;
 		goto drop;
+	}
 
 	udp_csum_pull_header(skb);
 
@@ -2213,11 +2218,12 @@ static int udp_queue_rcv_one_skb(struct sock *sk, struct sk_buff *skb)
 	return __udp_queue_rcv_skb(sk, skb);
 
 csum_error:
+	drop_reason = SKB_DROP_REASON_UDP_CSUM;
 	__UDP_INC_STATS(sock_net(sk), UDP_MIB_CSUMERRORS, is_udplite);
 drop:
 	__UDP_INC_STATS(sock_net(sk), UDP_MIB_INERRORS, is_udplite);
 	atomic_inc(&sk->sk_drops);
-	kfree_skb(skb);
+	kfree_skb_reason(skb, drop_reason);
 	return -1;
 }
 
-- 
2.34.1

