Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 854D14B6B21
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 12:33:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236557AbiBOLdY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 06:33:24 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:57404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237366AbiBOLdG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 06:33:06 -0500
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C4161EC7C;
        Tue, 15 Feb 2022 03:32:35 -0800 (PST)
Received: by mail-pf1-x444.google.com with SMTP id d187so34352189pfa.10;
        Tue, 15 Feb 2022 03:32:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hCin9VBadiO8qQl5cVgIoA5kDmxwQm+XKqBpptXE5CA=;
        b=AesnmJ+XdfuOD2K+xgFhtvTjQ7ZNs2+YlTYrTQAEBM4qVCJF2QdgJaa6tLILBwfozH
         vAvMcpT0wSl3LbkiD34Z2j0+FlnT7A4lXLCeh0kh30GyhlslXo/WEivhiobN/lTDIjWc
         QNq4l0L5znk2JtoH1kaPAkyFehtLWwKzh6nlI2qfe4W2FaUE72n7M6g1gngEsiF4ginO
         Yf+/FFfLtoh869q/hMYkHENzOleXmrN3FcW0PSh18SJvgsBCH0XqheIzlaHzh1xYGOH/
         cVKVFxv23jww3lrFpaC2zTm+x+5CLBVWpzRq3M+L7F9RSAz+smWP+PK64QQ9ufUX1bln
         fPbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hCin9VBadiO8qQl5cVgIoA5kDmxwQm+XKqBpptXE5CA=;
        b=yYBXKXowGctWTrycoYpBK7CLzjoW7YbCpetMVBAi5LGXsI1BBJYMPtIWei6LIbuV4Z
         4q3YhnVBNU8bx8qsNqDLQ0bL8ZH5pEd19sgOlcaWxLdjyuO8eDgZXHwJIb6EFEuMdyUT
         EYaqxo8ppTrA9s+WMhPz+tQPwrQifmH9Y3u8EJa0wL/SgVB0RNZQcAFgKvJqS7VxFhPC
         kAKLKege9BJgCE+fzHFd1xsVbhe3RlkwEGjHiGVzVNrkRm9Kn2zzlPTMgplsjvWrALeC
         gpS+SuhhwGPN+YezsKmWs5+YA7NebyDmlDLIkJIYQQ30SL4XSOtigqrT5uv+FLADxOMg
         FXcw==
X-Gm-Message-State: AOAM531qAYtUzr/6VlHG5/DFW0zcp2BKluNBgSkhnkmQ+DdNmqcVkVuZ
        EUMAi1sf7vsdb43ED41Svu4=
X-Google-Smtp-Source: ABdhPJxauvFZJwsAuhYpar96BWNRoHG7lqOaMigdjq/aYICVBDl+UJqOHnHXJpNrJlRXtyZvqPn7qg==
X-Received: by 2002:a63:2bc5:: with SMTP id r188mr3146784pgr.363.1644924754663;
        Tue, 15 Feb 2022 03:32:34 -0800 (PST)
Received: from localhost.localdomain ([203.205.141.113])
        by smtp.gmail.com with ESMTPSA id s11sm44515513pfu.58.2022.02.15.03.32.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Feb 2022 03:32:34 -0800 (PST)
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
Subject: [PATCH net-next 16/19] net: dev: use kfree_skb_reason() for enqueue_to_backlog()
Date:   Tue, 15 Feb 2022 19:28:09 +0800
Message-Id: <20220215112812.2093852-17-imagedong@tencent.com>
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

Replace kfree_skb() used in enqueue_to_backlog() with
kfree_skb_reason(). The skb drop reason SKB_DROP_REASON_CPU_BACKLOG is
introduced for the case of failing to enqueue the skb to the per CPU
backlog queue. The further reason can be backlog queue full or RPS
flow limition, and I think we needn't to make further distinctions.

Signed-off-by: Menglong Dong <imagedong@tencent.com>
---
 include/linux/skbuff.h     | 6 ++++++
 include/trace/events/skb.h | 1 +
 net/core/dev.c             | 6 +++++-
 3 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 0f7e5177dbaf..d59fdcd98278 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -404,6 +404,12 @@ enum skb_drop_reason {
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
index 356bea7567b5..a1c235daf23b 100644
--- a/include/trace/events/skb.h
+++ b/include/trace/events/skb.h
@@ -45,6 +45,7 @@
 	EM(SKB_DROP_REASON_NEIGH_QUEUEFULL, NEIGH_QUEUEFULL)	\
 	EM(SKB_DROP_REASON_QDISC_EGRESS, QDISC_EGRESS)		\
 	EM(SKB_DROP_REASON_QDISC_DROP, QDISC_DROP)		\
+	EM(SKB_DROP_REASON_CPU_BACKLOG, CPU_BACKLOG)		\
 	EMe(SKB_DROP_REASON_MAX, MAX)
 
 #undef EM
diff --git a/net/core/dev.c b/net/core/dev.c
index 55e890964fe2..8fee7adfca88 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4520,10 +4520,12 @@ static bool skb_flow_limit(struct sk_buff *skb, unsigned int qlen)
 static int enqueue_to_backlog(struct sk_buff *skb, int cpu,
 			      unsigned int *qtail)
 {
+	enum skb_drop_reason reason;
 	struct softnet_data *sd;
 	unsigned long flags;
 	unsigned int qlen;
 
+	reason = SKB_DROP_REASON_NOT_SPECIFIED;
 	sd = &per_cpu(softnet_data, cpu);
 
 	local_irq_save(flags);
@@ -4550,6 +4552,8 @@ static int enqueue_to_backlog(struct sk_buff *skb, int cpu,
 				____napi_schedule(sd, &sd->backlog);
 		}
 		goto enqueue;
+	} else {
+		reason = SKB_DROP_REASON_CPU_BACKLOG;
 	}
 
 drop:
@@ -4559,7 +4563,7 @@ static int enqueue_to_backlog(struct sk_buff *skb, int cpu,
 	local_irq_restore(flags);
 
 	atomic_long_inc(&skb->dev->rx_dropped);
-	kfree_skb(skb);
+	kfree_skb_reason(skb, reason);
 	return NET_RX_DROP;
 }
 
-- 
2.34.1

