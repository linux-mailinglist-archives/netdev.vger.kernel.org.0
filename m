Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE42F4CC45E
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 18:49:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235498AbiCCRtr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 12:49:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235497AbiCCRtn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 12:49:43 -0500
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2A5E65D15;
        Thu,  3 Mar 2022 09:48:49 -0800 (PST)
Received: by mail-pj1-x1043.google.com with SMTP id ev16-20020a17090aead000b001bc3835fea8so5596105pjb.0;
        Thu, 03 Mar 2022 09:48:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=IXXy8tItDSSNPgkXBETgYqVVttiEbKcqnrza3F8IHCE=;
        b=pOrj5jl3YXlc2w/1NfpmwsvrF+hmx9DIeQniHkiOpV5W6oszyySG3oYnO357Xm3Q24
         brqM9cRWHGsUx+LoGKrvKz3TwywgbllQ3T9/cjkHjdcVbR04ReRU+40nXesEK6VxBjy/
         zVSRgM26ZIELoQC+U5YXUQnd+mDeUNnL0iUqROcATHknIMZ5Iref+0z2sHc+w+DCcMEl
         nDxa7bUtitKesIVmz90CVOIG/ylOWjsMOXIGLXgj1BsXvxk851g/X6tbkc9i72Ns8+Bx
         2WvGOGbBFT0dm7XideOVIZhzeJ2evOPwFJf1E/QScC9GQEsDsgiOozuQNVAL+OcEKffY
         UPIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IXXy8tItDSSNPgkXBETgYqVVttiEbKcqnrza3F8IHCE=;
        b=7xIxQern6jFe/wv3dUUVFNh4PPynl1Aaa8lFDf+YaK7NluCEooLR77NrTv9ieJPzPb
         DSCTuPd2JeqdE6OAMot5EsYNGY1+hJGlO2ggUJ5RbYC0u8frkjem7m/Ap6umjbQTbK/q
         hCaxjEhVv4QRrapcrdJ+sVwytgaRU7o2qKLqDcSMXoi1h6WCsYD0pjs6u59TR/2kShcF
         SZ8rKpwHScceZszFwVx+iSKi3COO2Xa0Awyts7FEF0S56/evpUZBtznt388+mxCujAQP
         D5UL9DAhyVz5AoGYpKXdKesxGblwGPlEMllO7fzZ0rSFOnVDy2O4cYvZy8TKp96N4Wnh
         SB+Q==
X-Gm-Message-State: AOAM531IpLDnwjZVw+leKl4GcAxwjTZOo/CpJvoGc8W6Ty2D/SXOD9YD
        E0XmVCh7uZf1t1HnwdGJwbU=
X-Google-Smtp-Source: ABdhPJzVfMHjCXoC86qooxkiZAIGtZZC/FFA8uzCjjU3tqADFukDqdmvC64oxouAHFXyFdtQdNEF/w==
X-Received: by 2002:a17:90a:800c:b0:1bc:6faa:623f with SMTP id b12-20020a17090a800c00b001bc6faa623fmr6574738pjn.76.1646329729201;
        Thu, 03 Mar 2022 09:48:49 -0800 (PST)
Received: from localhost.localdomain ([203.205.141.116])
        by smtp.gmail.com with ESMTPSA id a38-20020a056a001d2600b004f0f0f852a4sm3209395pfx.77.2022.03.03.09.48.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Mar 2022 09:48:48 -0800 (PST)
From:   menglong8.dong@gmail.com
X-Google-Original-From: imagedong@tencent.com
To:     dsahern@kernel.org, kuba@kernel.org
Cc:     rostedt@goodmis.org, mingo@redhat.com, davem@davemloft.net,
        ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
        john.fastabend@gmail.com, imagedong@tencent.com,
        edumazet@google.com, talalahmad@google.com, keescook@chromium.org,
        ilias.apalodimas@linaro.org, alobakin@pm.me,
        flyingpeng@tencent.com, mengensun@tencent.com, atenart@kernel.org,
        bigeasy@linutronix.de, memxor@gmail.com, arnd@arndb.de,
        pabeni@redhat.com, willemb@google.com, vvs@virtuozzo.com,
        cong.wang@bytedance.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH net-next 4/7] net: dev: use kfree_skb_reason() for enqueue_to_backlog()
Date:   Fri,  4 Mar 2022 01:47:04 +0800
Message-Id: <20220303174707.40431-5-imagedong@tencent.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220303174707.40431-1-imagedong@tencent.com>
References: <20220303174707.40431-1-imagedong@tencent.com>
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

Replace kfree_skb() used in enqueue_to_backlog() with
kfree_skb_reason(). The skb rop reason SKB_DROP_REASON_CPU_BACKLOG is
introduced for the case of failing to enqueue the skb to the per CPU
backlog queue. The further reason can be backlog queue full or RPS
flow limition, and I think we meedn't to make further distinctions.

Signed-off-by: Menglong Dong <imagedong@tencent.com>
---
 include/linux/skbuff.h     | 6 ++++++
 include/trace/events/skb.h | 1 +
 net/core/dev.c             | 6 +++++-
 3 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 62f9d15ec6ec..d2cf87ff84c2 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -402,6 +402,12 @@ enum skb_drop_reason {
 					 * outputting (failed to enqueue to
 					 * current qdisc)
 					 */
+	SKB_DROP_REASON_CPU_BACKLOG,	/* failed to enqueue the skb to
+					 * the per CPU backlog queue. This
+					 * can be caused by backlog queue
+					 * full (see netdev_max_backlog in
+					 * net.rst) or RPS flow limit
+					 */
 	SKB_DROP_REASON_MAX,
 };
 
diff --git a/include/trace/events/skb.h b/include/trace/events/skb.h
index 80fe15d175e3..29c360b5e114 100644
--- a/include/trace/events/skb.h
+++ b/include/trace/events/skb.h
@@ -47,6 +47,7 @@
 	EM(SKB_DROP_REASON_NEIGH_DEAD, NEIGH_DEAD)		\
 	EM(SKB_DROP_REASON_QDISC_EGRESS, QDISC_EGRESS)		\
 	EM(SKB_DROP_REASON_QDISC_DROP, QDISC_DROP)		\
+	EM(SKB_DROP_REASON_CPU_BACKLOG, CPU_BACKLOG)		\
 	EMe(SKB_DROP_REASON_MAX, MAX)
 
 #undef EM
diff --git a/net/core/dev.c b/net/core/dev.c
index 3280ba2502cd..373fa7a33ffa 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4541,10 +4541,12 @@ static bool skb_flow_limit(struct sk_buff *skb, unsigned int qlen)
 static int enqueue_to_backlog(struct sk_buff *skb, int cpu,
 			      unsigned int *qtail)
 {
+	enum skb_drop_reason reason;
 	struct softnet_data *sd;
 	unsigned long flags;
 	unsigned int qlen;
 
+	reason = SKB_DROP_REASON_NOT_SPECIFIED;
 	sd = &per_cpu(softnet_data, cpu);
 
 	rps_lock_irqsave(sd, &flags);
@@ -4566,6 +4568,8 @@ static int enqueue_to_backlog(struct sk_buff *skb, int cpu,
 		if (!__test_and_set_bit(NAPI_STATE_SCHED, &sd->backlog.state))
 			napi_schedule_rps(sd);
 		goto enqueue;
+	} else {
+		reason = SKB_DROP_REASON_CPU_BACKLOG;
 	}
 
 drop:
@@ -4573,7 +4577,7 @@ static int enqueue_to_backlog(struct sk_buff *skb, int cpu,
 	rps_unlock_irq_restore(sd, &flags);
 
 	atomic_long_inc(&skb->dev->rx_dropped);
-	kfree_skb(skb);
+	kfree_skb_reason(skb, reason);
 	return NET_RX_DROP;
 }
 
-- 
2.35.1

