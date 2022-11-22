Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9B4C63440F
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 19:56:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234628AbiKVS4C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 13:56:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234614AbiKVSzu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 13:55:50 -0500
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A73C8C4A0
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 10:55:49 -0800 (PST)
Received: by mail-wm1-x334.google.com with SMTP id v7so11429373wmn.0
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 10:55:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JPghztDyNLrGZj1mqaJMElT+/qfziwsQcb93YPm7Lak=;
        b=dO73XNvLNUxhRWlOwGNlJpCjt4PXa88+Qjbo4PFwSZnzShYdiUS0WwRSvALrE/jBfQ
         CgWtYXSTCk0GPD2GmPJTp0jvNFCTo2S8Ymz98NFuvFl7RpSXRtjYibGjf76lrTRaucfa
         AKO1xsNMoULLDmXtifVslscIuTs30JbOq4ZE8eB5F2f0mYhoV6dNlcFZJOz0psyyTPZS
         Gx7CaYT1oMxBcO7PtxUttbLYOrW7lqwGDFbKGlEC9PBtEB7EPdtM9paGiOYWOL0ieG51
         YlfjrdaCorVbWzKheC88eTN2505iTCOvKaN6Dkqqsi9gFaShSA+x0/SabPvsbYt1utsc
         gppA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JPghztDyNLrGZj1mqaJMElT+/qfziwsQcb93YPm7Lak=;
        b=IAZQjM3d1Qpz1a/qQxj0Ugk8LirZ+krGV9CNrSX//YD14p8jdFvJtDQvbtlhhvGlKJ
         RI2OwC6IhHUVtMPAHVn085BCY7IeruMHjcqh7rAsole12xYGxO3U/GwiOfnfkJg0vb2b
         HIXquW1hwF2B0/ii/qiQIT2fBmvS18eG4t77MoUaoEQbmagR6BYjvKNbAsVq1huOLf3X
         J8BIdNBZEu1KarUP8Rg/2rzNMbYalzASJgh8q5GbBFHPgncvvKldowcRh9NxnDTH/v+E
         UVxw8sM8MrmWOSL4pKx2+OzIv1zz3sYPMWYAhVnqn9PEppg6ti1vWXOcTP+cO5at+1F9
         Gh/A==
X-Gm-Message-State: ANoB5pm0VQ+zYakTlfpFuI/PwiZ6tJ+FhHl+v4N21QNDtZiBVK6SjYf1
        2lIHWQK71OkExdy6jo24HYvSWg==
X-Google-Smtp-Source: AA0mqf7GN7b0ubP0erqtiVeGiIvEiAPWeOgyxmeOqIJg0KPRqKFVYwrI9eWZOiIQR1aFEWiXhoJE/g==
X-Received: by 2002:a05:600c:3d0c:b0:3cf:f66c:9246 with SMTP id bh12-20020a05600c3d0c00b003cff66c9246mr5429143wmb.27.1669143348802;
        Tue, 22 Nov 2022 10:55:48 -0800 (PST)
Received: from Mindolluin.ire.aristanetworks.com ([217.173.96.166])
        by smtp.gmail.com with ESMTPSA id c18-20020adffb12000000b002365730eae8sm14478044wrr.55.2022.11.22.10.55.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Nov 2022 10:55:48 -0800 (PST)
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
Subject: [PATCH v5 5/5] net/tcp: Separate initialization of twsk
Date:   Tue, 22 Nov 2022 18:55:34 +0000
Message-Id: <20221122185534.308643-6-dima@arista.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221122185534.308643-1-dima@arista.com>
References: <20221122185534.308643-1-dima@arista.com>
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
index 50f91c10eb7b..1cfafad9ba29 100644
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
+		if (!static_key_fast_inc_not_negative(&tcp_md5_needed.key.key))
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
-					if (!static_key_fast_inc_not_negative(&tcp_md5_needed.key.key)) {
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

