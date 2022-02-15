Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64ED94B6AF6
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 12:32:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237212AbiBOLbw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 06:31:52 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:53856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237218AbiBOLbo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 06:31:44 -0500
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7575213E1A;
        Tue, 15 Feb 2022 03:31:33 -0800 (PST)
Received: by mail-pj1-x1042.google.com with SMTP id v5-20020a17090a4ec500b001b8b702df57so2491255pjl.2;
        Tue, 15 Feb 2022 03:31:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nIVdMpYcOG2OAazxLh3VIajvOaTi60GKlKehBItfkck=;
        b=bE93YG0qKCESluDpXBxMBbkJAW0D4o7MMKCbbdON7pGCQYlL2Bo2Fs0jPaS6uDxGWr
         +t/PgD5JI+7kGhW7H0nbdYVM7oSd1EJfurBlTbO5Q7MFBLfRCggEEbTNpp8kZI11d9Av
         cGd9LaI015RgClpD5sHf5Dk+i9jVa3Dj8ZGql4LQGM5ReaAvuQOekfngOzqRauvClPvC
         mknbhN3MSArrzpdbgLFKA8sFrjAQFvvAlIE/TYCcumlg3Hca1UZ+nGVBk0i8jNzzhmr7
         N7t2GW2gLakR0Zhbk3BXKxFODPsRftM0Rba4S0D73u4fsY/bbKL4xY0lOR7uocdJTDk2
         Nwmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nIVdMpYcOG2OAazxLh3VIajvOaTi60GKlKehBItfkck=;
        b=fwWDeup7IFQLzc8eU9JeRRiykXA2wv6OoLD+lc/wcqKOu23g4IKuFFQLfjgnpPmGnf
         gMIMurOyUm51aBifuR7cRasUGfS3acb4t3zKUCuy7P4ogNTXIfoBn6uJmVC9OHuJo6i6
         v24bMcO1ySW29wJi3fZDahcXWVLUJRQYUyCo9lY/XMc/nepxqKfDWIeYlfZzk53kH1PM
         cnliWg/y0YpG1slYPh0Jumo9nyq8mULiTVa67+bu1fQzdPPh7YcSkK/LANahPPW2F8CV
         FaPqjjEgbzy36HBsMo9mUIrWNJFt1dDXaCeq3bdjzMTE8y9sFFaMCA2vTPF/egfSRkkB
         kKug==
X-Gm-Message-State: AOAM533iUNSdD+7AGhcReuQ2eWDBtr/KGdOSTNKQ7yln9tqNS9VT6qhc
        Ti4X17DFLoXkn4yWx0vSrow=
X-Google-Smtp-Source: ABdhPJzQ758po3n7LRJDpYfx5y73Pwe1Ne36WKv4YAiJ+omP7a8w7ad7cTBzpTN8SZwd5PJUZJWT0A==
X-Received: by 2002:a17:902:8d96:: with SMTP id v22mr3640805plo.77.1644924692974;
        Tue, 15 Feb 2022 03:31:32 -0800 (PST)
Received: from localhost.localdomain ([203.205.141.113])
        by smtp.gmail.com with ESMTPSA id s11sm44515513pfu.58.2022.02.15.03.31.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Feb 2022 03:31:32 -0800 (PST)
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
Subject: [PATCH net-next 07/19] net: tcp: use tcp_drop_reason() for tcp_rcv_established()
Date:   Tue, 15 Feb 2022 19:28:00 +0800
Message-Id: <20220215112812.2093852-8-imagedong@tencent.com>
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

Replace tcp_drop() used in tcp_rcv_established() with tcp_drop_reason().
Following drop reasons are added:

SKB_DROP_REASON_TCP_FLAGS

Signed-off-by: Menglong Dong <imagedong@tencent.com>
---
 include/linux/skbuff.h     | 1 +
 include/trace/events/skb.h | 1 +
 net/ipv4/tcp_input.c       | 9 +++++++--
 3 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 9a4424ceb7cb..dcf9d8bd0079 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -357,6 +357,7 @@ enum skb_drop_reason {
 					 * backlog (see
 					 * LINUX_MIB_TCPBACKLOGDROP)
 					 */
+	SKB_DROP_REASON_TCP_FLAGS,	/* TCP flags invalid */
 	SKB_DROP_REASON_MAX,
 };
 
diff --git a/include/trace/events/skb.h b/include/trace/events/skb.h
index bfccd77e9071..d332e7313a61 100644
--- a/include/trace/events/skb.h
+++ b/include/trace/events/skb.h
@@ -32,6 +32,7 @@
 	   TCP_MD5UNEXPECTED)					\
 	EM(SKB_DROP_REASON_TCP_MD5FAILURE, TCP_MD5FAILURE)	\
 	EM(SKB_DROP_REASON_SOCKET_BACKLOG, SOCKET_BACKLOG)	\
+	EM(SKB_DROP_REASON_TCP_FLAGS, TCP_FLAGS)		\
 	EMe(SKB_DROP_REASON_MAX, MAX)
 
 #undef EM
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index e3811afd1756..8cb0ea34aa49 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -5790,6 +5790,7 @@ static bool tcp_validate_incoming(struct sock *sk, struct sk_buff *skb,
  */
 void tcp_rcv_established(struct sock *sk, struct sk_buff *skb)
 {
+	enum skb_drop_reason reason = SKB_DROP_REASON_NOT_SPECIFIED;
 	const struct tcphdr *th = (const struct tcphdr *)skb->data;
 	struct tcp_sock *tp = tcp_sk(sk);
 	unsigned int len = skb->len;
@@ -5878,6 +5879,7 @@ void tcp_rcv_established(struct sock *sk, struct sk_buff *skb)
 				tp->rcv_rtt_last_tsecr = tp->rx_opt.rcv_tsecr;
 				return;
 			} else { /* Header too small */
+				reason = SKB_DROP_REASON_PKT_TOO_SMALL;
 				TCP_INC_STATS(sock_net(sk), TCP_MIB_INERRS);
 				goto discard;
 			}
@@ -5933,8 +5935,10 @@ void tcp_rcv_established(struct sock *sk, struct sk_buff *skb)
 	if (len < (th->doff << 2) || tcp_checksum_complete(skb))
 		goto csum_error;
 
-	if (!th->ack && !th->rst && !th->syn)
+	if (!th->ack && !th->rst && !th->syn) {
+		reason = SKB_DROP_REASON_TCP_FLAGS;
 		goto discard;
+	}
 
 	/*
 	 *	Standard slow path.
@@ -5960,12 +5964,13 @@ void tcp_rcv_established(struct sock *sk, struct sk_buff *skb)
 	return;
 
 csum_error:
+	reason = SKB_DROP_REASON_TCP_CSUM;
 	trace_tcp_bad_csum(skb);
 	TCP_INC_STATS(sock_net(sk), TCP_MIB_CSUMERRORS);
 	TCP_INC_STATS(sock_net(sk), TCP_MIB_INERRS);
 
 discard:
-	tcp_drop(sk, skb);
+	tcp_drop_reason(sk, skb, reason);
 }
 EXPORT_SYMBOL(tcp_rcv_established);
 
-- 
2.34.1

