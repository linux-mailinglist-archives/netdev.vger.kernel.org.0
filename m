Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 612BA44D750
	for <lists+netdev@lfdr.de>; Thu, 11 Nov 2021 14:36:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233459AbhKKNiv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Nov 2021 08:38:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233443AbhKKNiv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Nov 2021 08:38:51 -0500
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D838C0613F5;
        Thu, 11 Nov 2021 05:36:02 -0800 (PST)
Received: by mail-pl1-x641.google.com with SMTP id n8so5798636plf.4;
        Thu, 11 Nov 2021 05:36:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nW50W/gY+PhyipbQ0/I2DOG78zwFRgKM+rDwCH8t4ZI=;
        b=GrosffiGbGe/LY+RNVo//1aJ9szoLAQiZICoDfag4Ax5gXrJfOdaHU9YYwZHf4kUFk
         WOTB7pOkwPHB0+rRDz8AKflLp2/JDzNN74FDWTWrsJNQzb9W8whY1ZIKJTMo3uzXF/9O
         zYmj0+oWf9xh+MTWtmUpEz3/RoaKsZp8NT4rYU83rr1ADCqAd13D/nIL5X8MFaQ/83SY
         7OP54KflPNNaK9RO1Q/juXA2QIYqhKxPIDD0kuADkGy2PkPMQ5NJcS5VXA8uwqQ0IFI3
         R+00L0vcCK4VUAbUfJpddUvL+OU8jG1Z2Zt0ARr/9m0e8DGmzM1GzA659GcKQWw4nycn
         x8pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nW50W/gY+PhyipbQ0/I2DOG78zwFRgKM+rDwCH8t4ZI=;
        b=KmymvYGKRfTe61x61RS02aWRhJkYrdcgPjC9ivGdLiA/M/eji0V+PoS0jmhKsx5qLH
         GeWr9cYNrnkUWGbeTVgdvObnOSg3/pTUK1g/re5RRo0IzEbCNqaq86fbB7VcKvAcsjNB
         O0kGqnl20MFO9rtlD6v9AqVnrsqQqrXPV2RjvHTxuJ2pUchRdf8NiM1zSDVd0q0qTGwV
         u0i4E0dsnx4GbJa1CP1q1ncYL7Xx9D4l2ECI6CoUjJZYjiWrUxH9wCVeyiCwBmvRR0R9
         IDsCoag9cxYwH/zAiDVwqlDJl9rWcJhRQtK0a2a99gyk6GjM+RHd4ZDD9ORSwdNBV9zQ
         hvXA==
X-Gm-Message-State: AOAM530/TLbnoW7eTK7ihhqOUp/zGkon514+m3dICkTC7mq4u7zx4qVk
        FQ+mAoQZIlZ9ciAoMFWHZLM=
X-Google-Smtp-Source: ABdhPJzWJkWMW1dSCSZnE+ZbZhujXIZUfjdulVSwQVpaQ8yKdZnVP0qx4pUVwpG8awNfseEung4STg==
X-Received: by 2002:a17:902:e547:b0:141:ddbc:a8d6 with SMTP id n7-20020a170902e54700b00141ddbca8d6mr8133406plf.27.1636637761738;
        Thu, 11 Nov 2021 05:36:01 -0800 (PST)
Received: from desktop.cluster.local ([43.132.141.4])
        by smtp.gmail.com with ESMTPSA id l11sm3291342pfu.129.2021.11.11.05.35.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Nov 2021 05:36:01 -0800 (PST)
From:   menglong8.dong@gmail.com
X-Google-Original-From: imagedong@tencent.com
To:     kuba@kernel.org
Cc:     davem@davemloft.net, rostedt@goodmis.org, mingo@redhat.com,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, imagedong@tencent.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH net-next 1/2] net: snmp: add tracepoint support for snmp
Date:   Thu, 11 Nov 2021 21:35:29 +0800
Message-Id: <20211111133530.2156478-2-imagedong@tencent.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211111133530.2156478-1-imagedong@tencent.com>
References: <20211111133530.2156478-1-imagedong@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Menglong Dong <imagedong@tencent.com>

snmp is the network package statistics module in kernel, and it is
useful in network issue diagnosis, such as packet drop.

However, it is hard to get the detail information about the packet.
For example, we can know that there is something wrong with the
checksum of udp packet though 'InCsumErrors' of UDP protocol in
/proc/net/snmp, but we can't figure out the ip and port of the packet
that this error is happening on.

Add tracepoint for snmp. Therefor, users can use some tools (such as
eBPF) to get the information of the exceptional packet.

Signed-off-by: Menglong Dong <imagedong@tencent.com>
---
 include/trace/events/snmp.h | 45 +++++++++++++++++++++++++++++++++++++
 net/core/net-traces.c       |  1 +
 2 files changed, 46 insertions(+)
 create mode 100644 include/trace/events/snmp.h

diff --git a/include/trace/events/snmp.h b/include/trace/events/snmp.h
new file mode 100644
index 000000000000..9dbd630306dd
--- /dev/null
+++ b/include/trace/events/snmp.h
@@ -0,0 +1,45 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM snmp
+
+#if !defined(_TRACE_SNMP_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_SNMP_H
+
+#include <linux/tracepoint.h>
+#include <linux/skbuff.h>
+#include <linux/snmp.h>
+
+DECLARE_EVENT_CLASS(snmp_template,
+
+	TP_PROTO(struct sk_buff *skb, int field, int val),
+
+	TP_ARGS(skb, field, val),
+
+	TP_STRUCT__entry(
+		__field(void *, skbaddr)
+		__field(int, field)
+		__field(int, val)
+	),
+
+	TP_fast_assign(
+		__entry->skbaddr = skb;
+		__entry->field = field;
+		__entry->val = val;
+	),
+
+	TP_printk("skbaddr=%p, field=%d, val=%d", __entry->skbaddr,
+		  __entry->field, __entry->val)
+);
+
+#define DEFINE_SNMP_EVENT(proto)				\
+DEFINE_EVENT(snmp_template, snmp_##proto,			\
+	TP_PROTO(struct sk_buff *skb, int field, int val),	\
+	TP_ARGS(skb, field, val)				\
+)
+
+#define TRACE_SNMP(skb, proto, field, val) \
+	trace_snmp_##proto(skb, field, val)
+
+#endif
+
+#include <trace/define_trace.h>
diff --git a/net/core/net-traces.c b/net/core/net-traces.c
index c40cd8dd75c7..15ff40b83ca7 100644
--- a/net/core/net-traces.c
+++ b/net/core/net-traces.c
@@ -35,6 +35,7 @@
 #include <trace/events/tcp.h>
 #include <trace/events/fib.h>
 #include <trace/events/qdisc.h>
+#include <trace/events/snmp.h>
 #if IS_ENABLED(CONFIG_BRIDGE)
 #include <trace/events/bridge.h>
 EXPORT_TRACEPOINT_SYMBOL_GPL(br_fdb_add);
-- 
2.27.0

