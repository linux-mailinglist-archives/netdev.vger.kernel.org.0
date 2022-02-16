Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6C444B7EFB
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 04:58:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344015AbiBPD4C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 22:56:02 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:50944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245319AbiBPDzo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 22:55:44 -0500
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 781261017C8;
        Tue, 15 Feb 2022 19:55:32 -0800 (PST)
Received: by mail-pj1-x1044.google.com with SMTP id v5-20020a17090a4ec500b001b8b702df57so5311018pjl.2;
        Tue, 15 Feb 2022 19:55:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4mL7mLVT3JQWo1KYz/axuOVYLZG4n3zDx8r/aWnHrQ8=;
        b=TuzNJxPTntiryRaC5zi2FWYSofCaGhb4t+UPTdCzppSs0nwnhzDpNQnqfNhhyzaHUE
         wsJjaIpkuY9TFM+VpAg7et2ocfguDNxPYvNU/OocH8AzJ4YRt/7WHtA1Z+xWnSN/uRid
         GNhN1n/R6nEaKOeC5yHbCERZ2rrq5irFAb5T1DtVVd2lP5X63AS3o9Z/Tahl+ObGjbdY
         7mLhlWb3nkYQ7nb28gESR1F4BrGTogQsCCMKq/Hqu+WczrDfr2i5E70I3ON9dpmB3U6O
         ur1To67/K4HqIjsNjxmPKzYIaCYLG/WnHz96+1BbZivJqeXxl8/MN3Yc9cNoxW0AlO3T
         qWcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4mL7mLVT3JQWo1KYz/axuOVYLZG4n3zDx8r/aWnHrQ8=;
        b=wwJdmrp1pjVAt9NpdP39x/hub5KqpW/GEIDSJD/0cNYGZwBiEetNU99Fgn+WXDMNZ1
         zP98qNg4y2vgPOzEZQJ8ung9MAMMzo6oyojRctwjUfKUk1fOz6FcuXIFbPx/YCpl5Dra
         zfqx8CC0r0GC3Jp6O52YFH42BAGfMx03VCegmwow/suwXj3rZyhfD1FbvfGkMS5IZWBp
         x1ymI1w2IUtDsvjnEs5ym81uZHM84xF+kS9MdbYdzPqE421y6wii7xDpnoIxCb/efDgF
         AnxfqB+72HuOxjyvD8DS5TManSn9GwDBMlz6ws4Fx9rcizPyXkv7aKYhNDLxv+BiCqLQ
         urfg==
X-Gm-Message-State: AOAM531tsxH7pZXJFBTdpHf0IGnlk3Uqh/YuhQOcTU9NpQC6Epd/GfJa
        23k7h21IN+JuTFHYUE0lS9A=
X-Google-Smtp-Source: ABdhPJzSs38yFrs33E86V/4NEJivw8B/kHbicdjOTPv9wIuhQaFDOevHDZJw/oQSu5LFkueGCQdzzg==
X-Received: by 2002:a17:90a:8591:b0:1b9:da10:2127 with SMTP id m17-20020a17090a859100b001b9da102127mr7942075pjn.13.1644983732021;
        Tue, 15 Feb 2022 19:55:32 -0800 (PST)
Received: from localhost.localdomain ([203.205.141.110])
        by smtp.gmail.com with ESMTPSA id nn16sm19099668pjb.2.2022.02.15.19.55.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Feb 2022 19:55:31 -0800 (PST)
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
Subject: [PATCH net-next 5/9] net: tcp: add skb drop reasons to tcp_add_backlog()
Date:   Wed, 16 Feb 2022 11:54:22 +0800
Message-Id: <20220216035426.2233808-6-imagedong@tencent.com>
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

Pass the address of drop_reason to tcp_add_backlog() to store the
reasons for skb drops when fails. Following drop reasons are
introduced:

SKB_DROP_REASON_SOCKET_BACKLOG

Signed-off-by: Menglong Dong <imagedong@tencent.com>
---
 include/linux/skbuff.h     | 4 ++++
 include/net/tcp.h          | 3 ++-
 include/trace/events/skb.h | 1 +
 net/ipv4/tcp_ipv4.c        | 7 +++++--
 net/ipv6/tcp_ipv6.c        | 2 +-
 5 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index aea46b38cffa..9a4424ceb7cb 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -353,6 +353,10 @@ enum skb_drop_reason {
 						 * expecting one
 						 */
 	SKB_DROP_REASON_TCP_MD5FAILURE,	/* MD5 hash and its wrong */
+	SKB_DROP_REASON_SOCKET_BACKLOG,	/* failed to add skb to socket
+					 * backlog (see
+					 * LINUX_MIB_TCPBACKLOGDROP)
+					 */
 	SKB_DROP_REASON_MAX,
 };
 
diff --git a/include/net/tcp.h b/include/net/tcp.h
index eff2487d972d..04f4650e0ff0 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -1367,7 +1367,8 @@ static inline bool tcp_checksum_complete(struct sk_buff *skb)
 		__skb_checksum_complete(skb);
 }
 
-bool tcp_add_backlog(struct sock *sk, struct sk_buff *skb);
+bool tcp_add_backlog(struct sock *sk, struct sk_buff *skb,
+		     enum skb_drop_reason *reason);
 
 #ifdef CONFIG_INET
 void __sk_defer_free_flush(struct sock *sk);
diff --git a/include/trace/events/skb.h b/include/trace/events/skb.h
index 46c06b0be850..bfccd77e9071 100644
--- a/include/trace/events/skb.h
+++ b/include/trace/events/skb.h
@@ -31,6 +31,7 @@
 	EM(SKB_DROP_REASON_TCP_MD5UNEXPECTED,			\
 	   TCP_MD5UNEXPECTED)					\
 	EM(SKB_DROP_REASON_TCP_MD5FAILURE, TCP_MD5FAILURE)	\
+	EM(SKB_DROP_REASON_SOCKET_BACKLOG, SOCKET_BACKLOG)	\
 	EMe(SKB_DROP_REASON_MAX, MAX)
 
 #undef EM
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 3e7ab605dddc..15ef1bcff84f 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -1811,7 +1811,8 @@ int tcp_v4_early_demux(struct sk_buff *skb)
 	return 0;
 }
 
-bool tcp_add_backlog(struct sock *sk, struct sk_buff *skb)
+bool tcp_add_backlog(struct sock *sk, struct sk_buff *skb,
+		     enum skb_drop_reason *reason)
 {
 	u32 limit, tail_gso_size, tail_gso_segs;
 	struct skb_shared_info *shinfo;
@@ -1837,6 +1838,7 @@ bool tcp_add_backlog(struct sock *sk, struct sk_buff *skb)
 	if (unlikely(tcp_checksum_complete(skb))) {
 		bh_unlock_sock(sk);
 		trace_tcp_bad_csum(skb);
+		*reason = SKB_DROP_REASON_TCP_CSUM;
 		__TCP_INC_STATS(sock_net(sk), TCP_MIB_CSUMERRORS);
 		__TCP_INC_STATS(sock_net(sk), TCP_MIB_INERRS);
 		return true;
@@ -1925,6 +1927,7 @@ bool tcp_add_backlog(struct sock *sk, struct sk_buff *skb)
 
 	if (unlikely(sk_add_backlog(sk, skb, limit))) {
 		bh_unlock_sock(sk);
+		*reason = SKB_DROP_REASON_SOCKET_BACKLOG;
 		__NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPBACKLOGDROP);
 		return true;
 	}
@@ -2133,7 +2136,7 @@ int tcp_v4_rcv(struct sk_buff *skb)
 	if (!sock_owned_by_user(sk)) {
 		ret = tcp_v4_do_rcv(sk, skb);
 	} else {
-		if (tcp_add_backlog(sk, skb))
+		if (tcp_add_backlog(sk, skb, &drop_reason))
 			goto discard_and_relse;
 	}
 	bh_unlock_sock(sk);
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index dfefbc1eac5d..15090fe5af90 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -1784,7 +1784,7 @@ INDIRECT_CALLABLE_SCOPE int tcp_v6_rcv(struct sk_buff *skb)
 	if (!sock_owned_by_user(sk)) {
 		ret = tcp_v6_do_rcv(sk, skb);
 	} else {
-		if (tcp_add_backlog(sk, skb))
+		if (tcp_add_backlog(sk, skb, &drop_reason))
 			goto discard_and_relse;
 	}
 	bh_unlock_sock(sk);
-- 
2.34.1

