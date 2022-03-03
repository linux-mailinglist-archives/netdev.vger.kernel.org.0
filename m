Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 585EF4CC45C
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 18:49:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235499AbiCCRtt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 12:49:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235470AbiCCRtr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 12:49:47 -0500
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24FB15C86F;
        Thu,  3 Mar 2022 09:49:02 -0800 (PST)
Received: by mail-pg1-x543.google.com with SMTP id 27so5145868pgk.10;
        Thu, 03 Mar 2022 09:49:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Fnjte6kAZ17izSIaUaIdGjFx4P4niSUH+nE3s7tzWho=;
        b=Ecw71FSwoCGeKrXGC9d1uyLYUYckAoIiXkLLDDRSjaN5bse+7vkAafwMj/rs2mZACW
         BGZhGvXWMN/Yxn1m+0BV7uMyQMYx+c3zmTuYYzD31a2lPQwq4scVxpc6eKnyZOqBwLJu
         td890TNZBLAlv5Yw+Zc1L9dUhQRNTJnVXrOdUyjyq9dt/t2o1ENIou6G6NegsyA23rng
         2f/k7XimrO/nq7m5Ak7fmnIq9fkirvYdTQEI4k6ZYdNzyx8cmSVHRYKz7BSAduqCLac8
         x2wzsoKMGlXIigY3mubQXI/JuBwrQrtDNB9zcHPZmEnq7hApYt9XYeWo3q+1zf8oBP+C
         +WPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Fnjte6kAZ17izSIaUaIdGjFx4P4niSUH+nE3s7tzWho=;
        b=ShOl958FaBh99ADFSsfgv/3GVzcCOX4udU8Ah1TxPzpm244yneFNJzdPhM+llWkgtS
         oUGL+3B/6zZItril0J+JnAofCRjsGCY+54L3ATYNrTGW3XddmyzQJebLFIXx2B2Gtrdx
         YZ5Medmn7gUpquNxUvsS2oWF/AHoPdGJepawEOOSL2athbYlhItYT0KRgFETYCVi2SfI
         svrQ1rogXSOYwm3kUFVBDY6XoQcdcnMG+EDOM/1VDxVfmkxwl70zNzrHiWI+lgXcWhmI
         coC/bSQzW4MF8ucxNWUbz1uGwjDU0c/t7kZtEWHH/8af0HxW/WJp19R981QIPn4Lm2qp
         QpCA==
X-Gm-Message-State: AOAM533gPJj/d9woRamielZPcyad5q5FojZS1HUfAa9+c//GS787KYoQ
        1wfP3BJ8CWEl9y3tejmiOqs=
X-Google-Smtp-Source: ABdhPJxQTgNyldxx1uY5XEeSOV5k01ICFsEJ7XLVVQxIGf3dXzoDhbHUjrKnqn3czM1bSRfH8B+39A==
X-Received: by 2002:a63:e808:0:b0:378:b7a4:145c with SMTP id s8-20020a63e808000000b00378b7a4145cmr16698010pgh.78.1646329741424;
        Thu, 03 Mar 2022 09:49:01 -0800 (PST)
Received: from localhost.localdomain ([203.205.141.116])
        by smtp.gmail.com with ESMTPSA id a38-20020a056a001d2600b004f0f0f852a4sm3209395pfx.77.2022.03.03.09.48.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Mar 2022 09:49:00 -0800 (PST)
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
Subject: [PATCH net-next 6/7] net: dev: use kfree_skb_reason() for sch_handle_ingress()
Date:   Fri,  4 Mar 2022 01:47:06 +0800
Message-Id: <20220303174707.40431-7-imagedong@tencent.com>
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

Replace kfree_skb() used in sch_handle_ingress() with
kfree_skb_reason(). Following drop reasons are introduced:

SKB_DROP_REASON_QDISC_INGRESS

Signed-off-by: Menglong Dong <imagedong@tencent.com>
---
 include/linux/skbuff.h     | 4 ++++
 include/trace/events/skb.h | 1 +
 net/core/dev.c             | 2 +-
 3 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 23bbfcd6668b..04508d15152e 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -409,6 +409,10 @@ enum skb_drop_reason {
 					 * net.rst) or RPS flow limit
 					 */
 	SKB_DROP_REASON_XDP,		/* dropped by XDP in input path */
+	SKB_DROP_REASON_QDISC_INGRESS,	/* qdisc of type ingress check
+					 * failed (maybe an eBPF program
+					 * is tricking?)
+					 */
 	SKB_DROP_REASON_MAX,
 };
 
diff --git a/include/trace/events/skb.h b/include/trace/events/skb.h
index c117430375c0..d635951c9db8 100644
--- a/include/trace/events/skb.h
+++ b/include/trace/events/skb.h
@@ -49,6 +49,7 @@
 	EM(SKB_DROP_REASON_QDISC_DROP, QDISC_DROP)		\
 	EM(SKB_DROP_REASON_CPU_BACKLOG, CPU_BACKLOG)		\
 	EM(SKB_DROP_REASON_XDP, XDP)				\
+	EM(SKB_DROP_REASON_QDISC_INGRESS, QDISC_INGRESS)	\
 	EMe(SKB_DROP_REASON_MAX, MAX)
 
 #undef EM
diff --git a/net/core/dev.c b/net/core/dev.c
index ae85e024c7b7..429ad8265e8c 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -5013,7 +5013,7 @@ sch_handle_ingress(struct sk_buff *skb, struct packet_type **pt_prev, int *ret,
 		break;
 	case TC_ACT_SHOT:
 		mini_qdisc_qstats_cpu_drop(miniq);
-		kfree_skb(skb);
+		kfree_skb_reason(skb, SKB_DROP_REASON_QDISC_INGRESS);
 		return NULL;
 	case TC_ACT_STOLEN:
 	case TC_ACT_QUEUED:
-- 
2.35.1

