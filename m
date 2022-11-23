Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B379163676A
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 18:39:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239171AbiKWRjz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 12:39:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238819AbiKWRjW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 12:39:22 -0500
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDF33B972B
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 09:39:15 -0800 (PST)
Received: by mail-wm1-x330.google.com with SMTP id r9-20020a1c4409000000b003d02dd48c45so1692428wma.0
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 09:39:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=B6YByZGXcPaxVAwfhLuLTeQPsdnWRNfeeMbhOwZgWvo=;
        b=JPBm03qP/4/EIPZVSZlhAkYt210/IaMdI4rETETcBPQ1Ry1KY1ZIObqQaEOP5XKoYb
         RgX98xIjbhsZm7VIgN1F4l6nP7POFydPt/LNkg0DaPPceR4UXQIEw3cvxqU6qeClZyh8
         DR2RPbUIwhrmKi6S1H6Taf938/zIIGQ03P57vklgYI0K4RNjT5OGR+bK63++sVupcIfp
         zaqWqpohktUIk5JCmdRqzCBRNd6E7Bc/d3n2FtU1Fj40dTLGaUsmQaEB4LT3vqyg2I3p
         1WyyrbhxFuaKNJXtJ7iiDY0Qe4fcv/AVtneQx8TRHgjPNKv2LX5FFdPFRugZ6bkQIS+M
         fqkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=B6YByZGXcPaxVAwfhLuLTeQPsdnWRNfeeMbhOwZgWvo=;
        b=hQviiH6WRMXV4E7TEqGvVVT5LQ9VBvWAv1I25fqaPJEBEDIAp5TFEwNwlJyszt79hu
         v3BnFIVLD/9JtNDaimfhmksAun9B7adMmb2s0pTMRGjh5SREp/uy5IDjGItR/yiaSAmu
         TBI9pPP/FyUSAKb8NBsIVyt1/APRykvD9LGR0KoxYNDPK5uMUvTmr0zQoBbINJjbWnPX
         qWFxsNiMWTNp/NYKThb52xak8RDbtTfbBbTA2HTc5/32szwNB6Bc5t11gzo70RoKOj7e
         9C01PndcoVzO5HTkrmvuq0X7gnfIimqCHICRZI12iCRfURirCG03IRbyVXA04L816gCp
         CpLg==
X-Gm-Message-State: ANoB5pnLKQERnp91FmJzfldHYzoZliqhmZVx6eA0veAaBFXYxzRptSn8
        qn3cX8IWnkK97F/86cKK96Qfjw==
X-Google-Smtp-Source: AA0mqf4iPA2Zbe25WnFk0phcy+nscdWNKfFtwgtbqx9FmzFG85JuMQP0IrrAznNC588KVkAzDvdG1A==
X-Received: by 2002:a1c:4b12:0:b0:3cf:5237:c0be with SMTP id y18-20020a1c4b12000000b003cf5237c0bemr20405557wma.163.1669225154298;
        Wed, 23 Nov 2022 09:39:14 -0800 (PST)
Received: from Mindolluin.ire.aristanetworks.com ([217.173.96.166])
        by smtp.gmail.com with ESMTPSA id v10-20020adfe28a000000b0023647841c5bsm17464636wri.60.2022.11.23.09.39.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Nov 2022 09:39:13 -0800 (PST)
From:   Dmitry Safonov <dima@arista.com>
To:     linux-kernel@vger.kernel.org, David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc:     Dmitry Safonov <dima@arista.com>, Ard Biesheuvel <ardb@kernel.org>,
        Bob Gilligan <gilligan@arista.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Jason Baron <jbaron@akamai.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Salam Noureddine <noureddine@arista.com>,
        Steven Rostedt <rostedt@goodmis.org>, netdev@vger.kernel.org
Subject: [PATCH v6 5/5] net/tcp: Separate initialization of twsk
Date:   Wed, 23 Nov 2022 17:38:59 +0000
Message-Id: <20221123173859.473629-6-dima@arista.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123173859.473629-1-dima@arista.com>
References: <20221123173859.473629-1-dima@arista.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert BUG_ON() to WARN_ON_ONCE() and warn as well for unlikely
static key int overflow error-path.

Signed-off-by: Dmitry Safonov <dima@arista.com>
Acked-by: Jakub Kicinski <kuba@kernel.org>
---
 net/ipv4/tcp_minisocks.c | 61 +++++++++++++++++++++++-----------------
 1 file changed, 35 insertions(+), 26 deletions(-)

diff --git a/net/ipv4/tcp_minisocks.c b/net/ipv4/tcp_minisocks.c
index 6908812d50d3..e002f2e1d4f2 100644
--- a/net/ipv4/tcp_minisocks.c
+++ b/net/ipv4/tcp_minisocks.c
@@ -240,6 +240,40 @@ tcp_timewait_state_process(struct inet_timewait_sock *tw, struct sk_buff *skb,
 }
 EXPORT_SYMBOL(tcp_timewait_state_process);
 
+static void tcp_time_wait_init(struct sock *sk, struct tcp_timewait_sock *tcptw)
+{
+#ifdef CONFIG_TCP_MD5SIG
+	const struct tcp_sock *tp = tcp_sk(sk);
+	struct tcp_md5sig_key *key;
+
+	/*
+	 * The timewait bucket does not have the key DB from the
+	 * sock structure. We just make a quick copy of the
+	 * md5 key being used (if indeed we are using one)
+	 * so the timewait ack generating code has the key.
+	 */
+	tcptw->tw_md5_key = NULL;
+	if (!static_branch_unlikely(&tcp_md5_needed.key))
+		return;
+
+	key = tp->af_specific->md5_lookup(sk, sk);
+	if (key) {
+		tcptw->tw_md5_key = kmemdup(key, sizeof(*key), GFP_ATOMIC);
+		if (!tcptw->tw_md5_key)
+			return;
+		if (!tcp_alloc_md5sig_pool())
+			goto out_free;
+		if (!static_key_fast_inc_not_disabled(&tcp_md5_needed.key.key))
+			goto out_free;
+	}
+	return;
+out_free:
+	WARN_ON_ONCE(1);
+	kfree(tcptw->tw_md5_key);
+	tcptw->tw_md5_key = NULL;
+#endif
+}
+
 /*
  * Move a socket to time-wait or dead fin-wait-2 state.
  */
@@ -282,32 +316,7 @@ void tcp_time_wait(struct sock *sk, int state, int timeo)
 		}
 #endif
 
-#ifdef CONFIG_TCP_MD5SIG
-		/*
-		 * The timewait bucket does not have the key DB from the
-		 * sock structure. We just make a quick copy of the
-		 * md5 key being used (if indeed we are using one)
-		 * so the timewait ack generating code has the key.
-		 */
-		do {
-			tcptw->tw_md5_key = NULL;
-			if (static_branch_unlikely(&tcp_md5_needed.key)) {
-				struct tcp_md5sig_key *key;
-
-				key = tp->af_specific->md5_lookup(sk, sk);
-				if (key) {
-					tcptw->tw_md5_key = kmemdup(key, sizeof(*key), GFP_ATOMIC);
-					if (!tcptw->tw_md5_key)
-						break;
-					BUG_ON(!tcp_alloc_md5sig_pool());
-					if (!static_key_fast_inc_not_disabled(&tcp_md5_needed.key.key)) {
-						kfree(tcptw->tw_md5_key);
-						tcptw->tw_md5_key = NULL;
-					}
-				}
-			}
-		} while (0);
-#endif
+		tcp_time_wait_init(sk, tcptw);
 
 		/* Get the TIME_WAIT timeout firing. */
 		if (timeo < rto)
-- 
2.38.1

