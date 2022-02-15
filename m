Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7DAD4B6AE9
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 12:31:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229704AbiBOLbp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 06:31:45 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:52962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237204AbiBOLbh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 06:31:37 -0500
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88A3813F;
        Tue, 15 Feb 2022 03:31:26 -0800 (PST)
Received: by mail-pl1-x641.google.com with SMTP id i10so5248819plr.2;
        Tue, 15 Feb 2022 03:31:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=EZoukMGiWXk1HvbuQEBDTM8Ki/Xg0Kqyx/8NN8gbO9E=;
        b=hITaZk4Unk8D0kGzc2FEh+66ftm2EDL6Q+hY+NAZC9kemR0U6vIlv5uJfZI5mEmYIH
         VX9UuhFDNGLrtiAJxx3kb1IrDSMW1gwp+H8A5ZBalvcbiwc5LezWhT3zyJBgWQfy96PP
         +Hy9ZMqVOOgyEIYwCM7DV2N6hVsXp2ZGnQqqcgSt1Cu82VwBAaKBbada4x3H4IpB29xZ
         otszGo2K0QxfmVWpwtDXk914od2VxdWoytjymxYlpL3HnA0nOpzY/6Dzv5P1O4l/JHXP
         U2CnppXpmh33KM03L/CMjDZF8bdKR+4UNCF7rbWL3UhOGjRTyhbtA3h80QqcmLpE3tjU
         dPDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EZoukMGiWXk1HvbuQEBDTM8Ki/Xg0Kqyx/8NN8gbO9E=;
        b=Aplan3ysn5X4MNFeRN0YtdmpmS5qE6TxsOu4Sl272Rwx1tRdvTYKqWLUDQz2+yyUJe
         zYmTjtggsnN6Qm/3P8LWW/A4XNRko9RKq5GM0yJD58kfXQ27lpMGLaUWjZXDB9P2SaME
         KZM14YaWww91HJihoeJ9w8M0Reqr1j3CaIKt59fD8Vttbp6gIjEnilwHA3c2ndpgZFCM
         kY8PZfZbqY+b9HtriDd/CBeEVm1Kz1WJ8W6msCy9yRN4+t68R5CCRGor1gg8Y0izqDgT
         TlcU8/FpS8wsbWY8I51b4NmcojAPuZJcc/nUicYHn3D2HtRz+IaA52ibWWcd82svZ+FR
         Me/w==
X-Gm-Message-State: AOAM531I1WfWO0ktHP/qJvHstLp0G7LdzOoJSFFaF1UHWJuvaaI0GqRM
        raPst0GtWCAM6aBYucPN/NU=
X-Google-Smtp-Source: ABdhPJy9XPJ8vzb9sMMuNQpiDeLO/lvBwFzcUjikL+vVFLrUTRnmnbM3gnS9Hfq141ut/G2lGSyMcA==
X-Received: by 2002:a17:90b:38ce:b0:1b9:e0dd:50ec with SMTP id nn14-20020a17090b38ce00b001b9e0dd50ecmr3778623pjb.163.1644924686104;
        Tue, 15 Feb 2022 03:31:26 -0800 (PST)
Received: from localhost.localdomain ([203.205.141.113])
        by smtp.gmail.com with ESMTPSA id s11sm44515513pfu.58.2022.02.15.03.31.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Feb 2022 03:31:25 -0800 (PST)
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
Subject: [PATCH net-next 06/19] net: tcp: use kfree_skb_reason() for tcp_v{4,6}_do_rcv()
Date:   Tue, 15 Feb 2022 19:27:59 +0800
Message-Id: <20220215112812.2093852-7-imagedong@tencent.com>
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

Replace kfree_skb() used in tcp_v4_do_rcv() and tcp_v6_do_rcv() with
kfree_skb_reason().

Signed-off-by: Menglong Dong <imagedong@tencent.com>
---
 net/ipv4/tcp_ipv4.c | 5 ++++-
 net/ipv6/tcp_ipv6.c | 4 +++-
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 15ef1bcff84f..036b855c1b14 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -1708,6 +1708,7 @@ INDIRECT_CALLABLE_DECLARE(struct dst_entry *ipv4_dst_check(struct dst_entry *,
  */
 int tcp_v4_do_rcv(struct sock *sk, struct sk_buff *skb)
 {
+	enum skb_drop_reason reason;
 	struct sock *rsk;
 
 	if (sk->sk_state == TCP_ESTABLISHED) { /* Fast path */
@@ -1730,6 +1731,7 @@ int tcp_v4_do_rcv(struct sock *sk, struct sk_buff *skb)
 		return 0;
 	}
 
+	reason = SKB_DROP_REASON_NOT_SPECIFIED;
 	if (tcp_checksum_complete(skb))
 		goto csum_err;
 
@@ -1757,7 +1759,7 @@ int tcp_v4_do_rcv(struct sock *sk, struct sk_buff *skb)
 reset:
 	tcp_v4_send_reset(rsk, skb);
 discard:
-	kfree_skb(skb);
+	kfree_skb_reason(skb, reason);
 	/* Be careful here. If this function gets more complicated and
 	 * gcc suffers from register pressure on the x86, sk (in %ebx)
 	 * might be destroyed here. This current version compiles correctly,
@@ -1766,6 +1768,7 @@ int tcp_v4_do_rcv(struct sock *sk, struct sk_buff *skb)
 	return 0;
 
 csum_err:
+	reason = SKB_DROP_REASON_TCP_CSUM;
 	trace_tcp_bad_csum(skb);
 	TCP_INC_STATS(sock_net(sk), TCP_MIB_CSUMERRORS);
 	TCP_INC_STATS(sock_net(sk), TCP_MIB_INERRS);
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 15090fe5af90..4d4af9b15c83 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -1476,6 +1476,7 @@ int tcp_v6_do_rcv(struct sock *sk, struct sk_buff *skb)
 {
 	struct ipv6_pinfo *np = tcp_inet6_sk(sk);
 	struct sk_buff *opt_skb = NULL;
+	enum skb_drop_reason reason;
 	struct tcp_sock *tp;
 
 	/* Imagine: socket is IPv6. IPv4 packet arrives,
@@ -1563,9 +1564,10 @@ int tcp_v6_do_rcv(struct sock *sk, struct sk_buff *skb)
 discard:
 	if (opt_skb)
 		__kfree_skb(opt_skb);
-	kfree_skb(skb);
+	kfree_skb_reason(skb, reason);
 	return 0;
 csum_err:
+	reason = SKB_DROP_REASON_TCP_CSUM;
 	trace_tcp_bad_csum(skb);
 	TCP_INC_STATS(sock_net(sk), TCP_MIB_CSUMERRORS);
 	TCP_INC_STATS(sock_net(sk), TCP_MIB_INERRS);
-- 
2.34.1

