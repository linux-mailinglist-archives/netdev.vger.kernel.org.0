Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E78C4B7EF2
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 04:58:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344091AbiBPD4F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 22:56:05 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343930AbiBPDz6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 22:55:58 -0500
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AFD7CFBB1;
        Tue, 15 Feb 2022 19:55:46 -0800 (PST)
Received: by mail-pj1-x1043.google.com with SMTP id h7-20020a17090a648700b001b927560c2bso1257327pjj.1;
        Tue, 15 Feb 2022 19:55:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=NL6+oOg9BoEJhsiZNe7wPYYFUharzAidvKkvvsL+WNk=;
        b=pj5y8uwaXXcKNihB9eq1gRevxhm9wC1nPUlPIKeVQM19ITbpsXcmn/fIyT9pNe2Xvb
         Tv3rKpAuv3FXlU44gndLQ/b8xxW8E2KG22/k/jHy7cVqctZtrzpy1KI+CYTcFxKFiN24
         C1abD6uS2ZCClW77Wqjz+G2OEFumVkptmOR+pT5lubrtqqOA8aMFVy4E8qV2tL8j7ugj
         jwZppq3u8sfAbwdNMHyZ5jxolUe0aZFBRVnQnxTaZH2d936LBKmKN0tMB3Dd6GkJ2hAv
         MFiKYKliX/sbfqW99vU8CV13sNr+t3HOY7Xwq4g7saIBacwnu7BeN2hmUpylvZ58F1dz
         KNiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NL6+oOg9BoEJhsiZNe7wPYYFUharzAidvKkvvsL+WNk=;
        b=xCuvuXWnC2pnQu8cw27KO20P5AGfcDcKWQ+NJgs7xQ355hC2YgGNa4RkZJYxFjJ8Aw
         BZ0JoqQoGtLHjkaxEzj8qjZ4WThDzZxnjdQ3rnaUFoZwdfHJukATUMmrLbOuoglINvd/
         N6giuD40K+6AHFx6+1Ksl3ABfiV+OoCCp4r3/UCreReK84Sv/AY1InTzgK1tC+nGzU3J
         u89qKmooxeWJrb5zO3xXUm6SmwmXmb+ZPyz6KQrxaIaJHQ6gb8L7yTkuTMz7aQhVIEJp
         jiYzydys5QY511QasvAD15H1mm7P1O0Au/AxobjEIWOFYM30cNscQFQXuoR1ybIFwPPW
         bx2A==
X-Gm-Message-State: AOAM533/oTagTgDNAig9tf71Ga+NmARckWi8oCnyALKCtBdGGH5SNp8C
        pLvJzPEm3043QXaGdWAp/j4=
X-Google-Smtp-Source: ABdhPJwmLnHfva1jmPJbG3R2cVxrdg7+JNLclPKDQOEMR4UdldpkPVNxDyLNpyjoI+kcmnV54tiSYA==
X-Received: by 2002:a17:903:2451:b0:14d:a225:74e0 with SMTP id l17-20020a170903245100b0014da22574e0mr813732pls.84.1644983746115;
        Tue, 15 Feb 2022 19:55:46 -0800 (PST)
Received: from localhost.localdomain ([203.205.141.110])
        by smtp.gmail.com with ESMTPSA id nn16sm19099668pjb.2.2022.02.15.19.55.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Feb 2022 19:55:45 -0800 (PST)
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
Subject: [PATCH net-next 7/9] net: tcp: use tcp_drop_reason() for tcp_rcv_established()
Date:   Wed, 16 Feb 2022 11:54:24 +0800
Message-Id: <20220216035426.2233808-8-imagedong@tencent.com>
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

