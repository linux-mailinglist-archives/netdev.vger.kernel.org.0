Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D0604BB44D
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 09:34:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232764AbiBRId4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Feb 2022 03:33:56 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:38748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232608AbiBRId2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Feb 2022 03:33:28 -0500
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B8292AE26;
        Fri, 18 Feb 2022 00:33:09 -0800 (PST)
Received: by mail-pg1-x542.google.com with SMTP id s16so7216995pgs.13;
        Fri, 18 Feb 2022 00:33:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vhN6bGLbUWbV7gm+QxrfCTvNwDyT7gtYG2Niy8n6URM=;
        b=cJiqm4iS05FYDROdQbLPJvRPiOP9H4Treic7Ab6z/vSFOtEJK8fYYWvMesJMJXRsmA
         L0yu02jst1wMdzij7bwQKba+G/UbfPuQzrepNTOwVVve1W0kvW5vQhQAsZlxUwK6aTTo
         INqyKfjbR/ZldXsdVL35wZ2v8Jrjmpq0nWI6fEIZTlYrF3RvlnQ3RE+m4CyUcgbe9Obr
         lI9ESnbJxyKI4jrL5bKqSqebkXr/+DQLbRCJN+KNkOWjNSUyko+BnXHImnrBSHBn4sx1
         tEQqxah71ktCHyqANwgE5gzQjkvK9s7UAzX/rLO9SKGUoDMDDp3Kw42d0STyUJR8PhFi
         xbug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vhN6bGLbUWbV7gm+QxrfCTvNwDyT7gtYG2Niy8n6URM=;
        b=lLO/ip5F1e3V3t0S+bSfY9M9nnHSUiQZ/VjRg3SYje2TjyODUeXwbODlodacSQRpG8
         oXSMC27vHpmJr4ilWFHZbE6EcZLiiWtSLNiW6T7B7c9YFGLY00XzGngekubu2q7CILI0
         kFwNH8iKNSiD5u4KHML8Tfk9Aunef8m2BmK1Uto0FgOnG3WeoTJQDwCWvBizrr+1ck17
         znAbVi6BtPWnD3gx4VQrUgnhB4xmngGyrpZzDIxQXTb/wL4EBn9WlCuhtDiqozf6NqrV
         YXy+KMWW7Q/xgRXHf3E6O3b5INi7alFtQy071UF8+uoWOOMyb1EqMZzSxEvEzJ0ovaTF
         3nAA==
X-Gm-Message-State: AOAM530KFGwwpYkPmzC3uqdAM3mZLZqvNooElAyDnoEqbW3is60gY6Ci
        Qic/t1776iTZHZpSCt4Cwdg=
X-Google-Smtp-Source: ABdhPJwvpy9+oteNIVS+TPB9BK2QKLCnNcvdZbNLxvEmkiJUxEr7JfT6dmwe49yvvmB3EcMO9pC9kg==
X-Received: by 2002:a63:1421:0:b0:372:d575:7842 with SMTP id u33-20020a631421000000b00372d5757842mr5475718pgl.182.1645173189124;
        Fri, 18 Feb 2022 00:33:09 -0800 (PST)
Received: from localhost.localdomain ([203.205.141.113])
        by smtp.gmail.com with ESMTPSA id m23sm1963530pff.201.2022.02.18.00.33.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Feb 2022 00:33:08 -0800 (PST)
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
Subject: [PATCH net-next v2 7/9] net: tcp: use tcp_drop_reason() for tcp_rcv_established()
Date:   Fri, 18 Feb 2022 16:31:31 +0800
Message-Id: <20220218083133.18031-8-imagedong@tencent.com>
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
index f7f33c79945b..671db9f49efe 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -362,6 +362,7 @@ enum skb_drop_reason {
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
index 0a2740add404..16ee1127e25d 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -5787,6 +5787,7 @@ static bool tcp_validate_incoming(struct sock *sk, struct sk_buff *skb,
  */
 void tcp_rcv_established(struct sock *sk, struct sk_buff *skb)
 {
+	enum skb_drop_reason reason = SKB_DROP_REASON_NOT_SPECIFIED;
 	const struct tcphdr *th = (const struct tcphdr *)skb->data;
 	struct tcp_sock *tp = tcp_sk(sk);
 	unsigned int len = skb->len;
@@ -5875,6 +5876,7 @@ void tcp_rcv_established(struct sock *sk, struct sk_buff *skb)
 				tp->rcv_rtt_last_tsecr = tp->rx_opt.rcv_tsecr;
 				return;
 			} else { /* Header too small */
+				reason = SKB_DROP_REASON_PKT_TOO_SMALL;
 				TCP_INC_STATS(sock_net(sk), TCP_MIB_INERRS);
 				goto discard;
 			}
@@ -5930,8 +5932,10 @@ void tcp_rcv_established(struct sock *sk, struct sk_buff *skb)
 	if (len < (th->doff << 2) || tcp_checksum_complete(skb))
 		goto csum_error;
 
-	if (!th->ack && !th->rst && !th->syn)
+	if (!th->ack && !th->rst && !th->syn) {
+		reason = SKB_DROP_REASON_TCP_FLAGS;
 		goto discard;
+	}
 
 	/*
 	 *	Standard slow path.
@@ -5957,12 +5961,13 @@ void tcp_rcv_established(struct sock *sk, struct sk_buff *skb)
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

