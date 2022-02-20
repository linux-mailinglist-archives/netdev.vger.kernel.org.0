Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B58BD4BCD03
	for <lists+netdev@lfdr.de>; Sun, 20 Feb 2022 08:18:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243497AbiBTHJM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Feb 2022 02:09:12 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:44004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243512AbiBTHJE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Feb 2022 02:09:04 -0500
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6917B55499;
        Sat, 19 Feb 2022 23:08:32 -0800 (PST)
Received: by mail-pg1-x543.google.com with SMTP id 75so11537597pgb.4;
        Sat, 19 Feb 2022 23:08:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9Rso53u3lwifpD1f+9rlf58ETpRb1/NXtpda3rm+9ro=;
        b=DrYu/2vGN/cz2HQ3ThVdBXdR5zlZ/triJpgBZW9glj87iJnKKNKOqtU+FQoLIg3Up6
         qGmMXpqtthvga/ZbKb4rs5AYhh7+lQSn5HBu2rsUCLUTqq4Elip8JQYX5hHL1RSKgXZw
         VPr+2A5ZFJ7IU+zbvEcTd/OiFPeDs+gkC/A0X7F9S+3TmgbT20eSD8BJ9q09nOFdMlac
         OrvHY7+HCGnyZ0siee3+CPf2mT/yA4oN9GK6cnl13Rc1DtWpgNhveAUBegdRT9KMS3xY
         pe1xPM8wyq6ffSUYv+1hbY/D4UxHuUFZvEIVi30uHg+3ZdSD3kyxXJEROR957At6f5JQ
         AElg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9Rso53u3lwifpD1f+9rlf58ETpRb1/NXtpda3rm+9ro=;
        b=ZPyh3CfRfEMWkFf5LmAsgz/ZxpDeJN+63QC187xvOdWba14IRBDXLmLPV0UcX4ipY3
         44zO4GRT3oyd6da8dDzuo9oiH2+2S07KuAIedKhQB4TQOVnMWZ79uy7bnlx9Wm4yrqPO
         1wuuw37hLUjG/dWlRVb/mT5XlNFNRMWMUXhS4/+4Pk8z+GMtredONhlSwSGC6BVQi8Fy
         vb8yheio3uaCjWmkvc3Adb3c07OA5t3TFe8k7mEfyzUBR96UZuON/aRlrh+92T+Z7FdT
         fz3gcY9c14z9l/3AucK9r229dofn3pfeobLIKk2njwbfY0/GKBeLKJJei9RSNJOftdVa
         H1/A==
X-Gm-Message-State: AOAM530JopVK3I9/dYVd/ICUFJLMj+Nnbjz7OD9UevhzLobUFdYXULjS
        9XUe2P1hsBqw9FllIZTCozM=
X-Google-Smtp-Source: ABdhPJz7Npz9xUYfeqYjhQnyu+jq2XiIxpzttji/ZprmbKrHablxHcizfHcBVRh6VlwSn04IhxuCyw==
X-Received: by 2002:aa7:8890:0:b0:4e1:b25b:634c with SMTP id z16-20020aa78890000000b004e1b25b634cmr15181326pfe.31.1645340911972;
        Sat, 19 Feb 2022 23:08:31 -0800 (PST)
Received: from localhost.localdomain ([203.205.141.114])
        by smtp.gmail.com with ESMTPSA id p1sm8351326pfo.212.2022.02.19.23.08.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Feb 2022 23:08:31 -0800 (PST)
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
Subject: [PATCH net-next v3 7/9] net: tcp: use tcp_drop_reason() for tcp_rcv_established()
Date:   Sun, 20 Feb 2022 15:06:35 +0800
Message-Id: <20220220070637.162720-8-imagedong@tencent.com>
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

Replace tcp_drop() used in tcp_rcv_established() with tcp_drop_reason().
Following drop reasons are added:

SKB_DROP_REASON_TCP_FLAGS

Reviewed-by: Mengen Sun <mengensun@tencent.com>
Reviewed-by: Hao Peng <flyingpeng@tencent.com>
Signed-off-by: Menglong Dong <imagedong@tencent.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
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
index 2bcbefa4322a..1899388e384a 100644
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
2.35.1

