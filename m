Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82AD14B6B11
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 12:33:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237248AbiBOLdr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 06:33:47 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:57864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237376AbiBOLdW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 06:33:22 -0500
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0AA9220CF;
        Tue, 15 Feb 2022 03:32:48 -0800 (PST)
Received: by mail-pl1-x641.google.com with SMTP id u5so1683083ple.3;
        Tue, 15 Feb 2022 03:32:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0xCICfG2niwYOnpIcsDoi3nvIqDLrd7OmoM+8aXLBIQ=;
        b=YLAdafujTLdWUAyS3CrkvPklRpmRj/1F27/tT1Ad4Gyd/IxRPZbOxN7iCd++c8QygO
         Qa1/9rZv8to/jAP52F4m7tYRAQkktRp6f3k8rk1Rjf4Jtkp+Ob0UMcQvVNk7d3YbiBFI
         pHxYsNbPARMvssfSvptY1VQI06fImoc/C/eaAcmqlhjM0yT+RycUCHaG7PK1LzazKSZc
         dZLpkIrWC+zEJAG9ESNW4ppaD0XMP43g+kqtZtTkQIWN1irkX72RplatKcUd2oNMF8xQ
         fyuF0kTlULxix1f5X8l0ZSuxu8ux/n+cNw+egG/PfP+bL1u6PlokWAwUtM445ktqOekw
         d8MQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0xCICfG2niwYOnpIcsDoi3nvIqDLrd7OmoM+8aXLBIQ=;
        b=hdxKCcvuoe6vZRV/4XBIgV+XZ9dosIG9ZEI7G7CQ5Qk7s5D9Unsjnq/X79v8oku3M9
         8TuTP2Y7h+PUWkGBurPgC5bf9oBS15LCkuiZioON1meCvTpExyXqb+fMuTJfN7ubdj/+
         MARLziPMgL8n78UQ3iFc1yRiivDc6Or+/YtrZYJXBt7TnR1Nmhg1yHDoI+y1ispRvuq2
         AXZFk5WupYFX8NEeM41Z3PQPGBpJ2xyQOgue6mskR4oaT71kSvplj9OWotP8Wzz1Ru2c
         PNxpt3v1nqoNVTuMk4bcK9u2RV8GlXwKSt5WinR0EvANsGer9GdudIwXx22P2VMXtIl7
         PTEw==
X-Gm-Message-State: AOAM532c6oP/eXAk/G+uaoU/Z4J2Y/YyO19TcuG5bzAZt9kII85IjWfi
        pvNceGrGt1i2RJ/Yq2x2jqo=
X-Google-Smtp-Source: ABdhPJygI/OuYQVzg9zEAI+fUbZRs8BnlWX1TSrUweQX4uedw7yhyxfKKURJekNVsXqmS7rIGBIJOQ==
X-Received: by 2002:a17:902:7892:: with SMTP id q18mr3640507pll.106.1644924768343;
        Tue, 15 Feb 2022 03:32:48 -0800 (PST)
Received: from localhost.localdomain ([203.205.141.113])
        by smtp.gmail.com with ESMTPSA id s11sm44515513pfu.58.2022.02.15.03.32.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Feb 2022 03:32:47 -0800 (PST)
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
Subject: [PATCH net-next 18/19] net: dev: use kfree_skb_reason() for sch_handle_ingress()
Date:   Tue, 15 Feb 2022 19:28:11 +0800
Message-Id: <20220215112812.2093852-19-imagedong@tencent.com>
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
index 79b24d5f491d..e36e27943104 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -411,6 +411,10 @@ enum skb_drop_reason {
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
index 7bc46414a81b..96a550570dfe 100644
--- a/include/trace/events/skb.h
+++ b/include/trace/events/skb.h
@@ -47,6 +47,7 @@
 	EM(SKB_DROP_REASON_QDISC_DROP, QDISC_DROP)		\
 	EM(SKB_DROP_REASON_CPU_BACKLOG, CPU_BACKLOG)		\
 	EM(SKB_DROP_REASON_XDP, XDP)				\
+	EM(SKB_DROP_REASON_QDISC_INGRESS, QDISC_INGRESS)	\
 	EMe(SKB_DROP_REASON_MAX, MAX)
 
 #undef EM
diff --git a/net/core/dev.c b/net/core/dev.c
index a2548b7f2708..c67e3491c004 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -5006,7 +5006,7 @@ sch_handle_ingress(struct sk_buff *skb, struct packet_type **pt_prev, int *ret,
 		break;
 	case TC_ACT_SHOT:
 		mini_qdisc_qstats_cpu_drop(miniq);
-		kfree_skb(skb);
+		kfree_skb_reason(skb, SKB_DROP_REASON_QDISC_INGRESS);
 		return NULL;
 	case TC_ACT_STOLEN:
 	case TC_ACT_QUEUED:
-- 
2.34.1

