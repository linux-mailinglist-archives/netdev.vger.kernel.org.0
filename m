Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 471B51B2012
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 09:41:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727965AbgDUHlN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Apr 2020 03:41:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726018AbgDUHlM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Apr 2020 03:41:12 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F3BDC061A10
        for <netdev@vger.kernel.org>; Tue, 21 Apr 2020 00:41:12 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id d184so1857590pfd.4
        for <netdev@vger.kernel.org>; Tue, 21 Apr 2020 00:41:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=EsNcm2QyXE0JffGh+pkvc6bbJEwtWjuB0Wr2Sf2lXbY=;
        b=FpgGVn8b4GSV6n81bPJiJsBMDGJ9ltWjFEH7eGZkueRrdU/uIYWjlAa5QmDN9UcJAc
         x6hXCcj7vHjmEC4Fhh/oBMIv5Uo7SQ9l8ssUV6SVOGCYO/x6+IZqrs3eL18syMLVFuXX
         Vl48vUEOusANomqKpVSls6ToJXVO3h7cqH7soGrqEZXMkXNKLRCbuNKPvP1mF7iCcEjt
         TPM/+XVHtAoqEY+9bUX580gZoVXx+P0A2yoylCJ2r7heBeXvr7OJDzRZ+cRNlIXUyJU/
         NG5BpFSmYQLub0Y1koIYC3Cnzj/C97D8c/cSAj3V5uVOBVqziSEx+jjB0h/8UOC4IHIJ
         ci2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=EsNcm2QyXE0JffGh+pkvc6bbJEwtWjuB0Wr2Sf2lXbY=;
        b=TFUu7c5IIXra1DIya+EfjkJFKyFuJpS9eEEFXvzEVYzg8qBLmEe1foin+7MsxhfNKf
         QOmZutm+MskVWLzJB2TENZwZpAp2XmK5jgpbT2vEvcHTnRmIaDu9yN5lx0auOakn4wes
         aN9Z2bNc5ukjeh0morzkgWtj1QKACwcf1dDMJYeJop4K8dDS9ANlpk+8kZdQ7iYVBKEp
         jUKFSb2s3pn9Q7BPMk9EEApoZnjSMrlHaazFtVhcJwp0cjO5/y5OAUBua1n54URtY3dx
         5W3i6OwOUOChJqB1XEnai3whRb5bc+NUYd7J/eCzZF3k5X/lHMFNsWSYWrhp9AwvU+5X
         OoQg==
X-Gm-Message-State: AGi0PuYZTuqdp2Ow42/YCjIsUX1SMLK2jbbTxlVK4YqxnRD4foaGgoXE
        PKkPKp41sbTGI5mk/9xNvJmH
X-Google-Smtp-Source: APiQypKK7ZAxY6aQjP4/84tAUiZ60907CjmPq272+8pgw2xIDqFByoZSgiGyEnqElyLcf/TcF762lA==
X-Received: by 2002:aa7:919a:: with SMTP id x26mr20333990pfa.39.1587454871426;
        Tue, 21 Apr 2020 00:41:11 -0700 (PDT)
Received: from localhost.localdomain ([2409:4072:6289:7463:c15b:2de1:b77e:d971])
        by smtp.gmail.com with ESMTPSA id i15sm1574564pfo.195.2020.04.21.00.41.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Apr 2020 00:41:10 -0700 (PDT)
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     bjorn.andersson@linaro.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Subject: [PATCH] net: qrtr: Add tracepoint support
Date:   Tue, 21 Apr 2020 13:10:54 +0530
Message-Id: <20200421074054.23613-1-manivannan.sadhasivam@linaro.org>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add tracepoint support for QRTR with NS as the first candidate. Later on
this can be extended to core QRTR and transport drivers.

The trace_printk() used in NS has been replaced by tracepoints.

Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
---
 include/trace/events/qrtr.h | 115 ++++++++++++++++++++++++++++++++++++
 net/qrtr/ns.c               |  20 ++++---
 2 files changed, 126 insertions(+), 9 deletions(-)
 create mode 100644 include/trace/events/qrtr.h

diff --git a/include/trace/events/qrtr.h b/include/trace/events/qrtr.h
new file mode 100644
index 000000000000..b1de14c3bb93
--- /dev/null
+++ b/include/trace/events/qrtr.h
@@ -0,0 +1,115 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM qrtr
+
+#if !defined(_TRACE_QRTR_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_QRTR_H
+
+#include <linux/qrtr.h>
+#include <linux/tracepoint.h>
+
+TRACE_EVENT(qrtr_ns_service_announce_new,
+
+	TP_PROTO(__le32 service, __le32 instance, __le32 node, __le32 port),
+
+	TP_ARGS(service, instance, node, port),
+
+	TP_STRUCT__entry(
+		__field(__le32, service)
+		__field(__le32, instance)
+		__field(__le32, node)
+		__field(__le32, port)
+	),
+
+	TP_fast_assign(
+		__entry->service = service;
+		__entry->instance = instance;
+		__entry->node = node;
+		__entry->port = port;
+	),
+
+	TP_printk("advertising new server [%d:%x]@[%d:%d]",
+		  __entry->service, __entry->instance, __entry->node,
+		  __entry->port
+	)
+);
+
+TRACE_EVENT(qrtr_ns_service_announce_del,
+
+	TP_PROTO(__le32 service, __le32 instance, __le32 node, __le32 port),
+
+	TP_ARGS(service, instance, node, port),
+
+	TP_STRUCT__entry(
+		__field(__le32, service)
+		__field(__le32, instance)
+		__field(__le32, node)
+		__field(__le32, port)
+	),
+
+	TP_fast_assign(
+		__entry->service = service;
+		__entry->instance = instance;
+		__entry->node = node;
+		__entry->port = port;
+	),
+
+	TP_printk("advertising removal of server [%d:%x]@[%d:%d]",
+		  __entry->service, __entry->instance, __entry->node,
+		  __entry->port
+	)
+);
+
+TRACE_EVENT(qrtr_ns_server_add,
+
+	TP_PROTO(__le32 service, __le32 instance, __le32 node, __le32 port),
+
+	TP_ARGS(service, instance, node, port),
+
+	TP_STRUCT__entry(
+		__field(__le32, service)
+		__field(__le32, instance)
+		__field(__le32, node)
+		__field(__le32, port)
+	),
+
+	TP_fast_assign(
+		__entry->service = service;
+		__entry->instance = instance;
+		__entry->node = node;
+		__entry->port = port;
+	),
+
+	TP_printk("add server [%d:%x]@[%d:%d]",
+		  __entry->service, __entry->instance, __entry->node,
+		  __entry->port
+	)
+);
+
+TRACE_EVENT(qrtr_ns_message,
+
+	TP_PROTO(const char * const ctrl_pkt_str, __u32 sq_node, __u32 sq_port),
+
+	TP_ARGS(ctrl_pkt_str, sq_node, sq_port),
+
+	TP_STRUCT__entry(
+		__string(ctrl_pkt_str, ctrl_pkt_str)
+		__field(__u32, sq_node)
+		__field(__u32, sq_port)
+	),
+
+	TP_fast_assign(
+		__assign_str(ctrl_pkt_str, ctrl_pkt_str);
+		__entry->sq_node = sq_node;
+		__entry->sq_port = sq_port;
+	),
+
+	TP_printk("%s from %d:%d",
+		  __get_str(ctrl_pkt_str), __entry->sq_node, __entry->sq_port
+	)
+);
+
+#endif /* _TRACE_QRTR_H */
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
diff --git a/net/qrtr/ns.c b/net/qrtr/ns.c
index a703d4fbdedf..4b0cffdcfed1 100644
--- a/net/qrtr/ns.c
+++ b/net/qrtr/ns.c
@@ -12,6 +12,9 @@
 
 #include "qrtr.h"
 
+#define CREATE_TRACE_POINTS
+#include <trace/events/qrtr.h>
+
 static RADIX_TREE(nodes, GFP_KERNEL);
 
 static struct {
@@ -105,8 +108,8 @@ static int service_announce_new(struct sockaddr_qrtr *dest,
 	struct msghdr msg = { };
 	struct kvec iv;
 
-	trace_printk("advertising new server [%d:%x]@[%d:%d]\n",
-		     srv->service, srv->instance, srv->node, srv->port);
+	trace_qrtr_ns_service_announce_new(srv->service, srv->instance,
+					   srv->node, srv->port);
 
 	iv.iov_base = &pkt;
 	iv.iov_len = sizeof(pkt);
@@ -132,8 +135,8 @@ static int service_announce_del(struct sockaddr_qrtr *dest,
 	struct kvec iv;
 	int ret;
 
-	trace_printk("advertising removal of server [%d:%x]@[%d:%d]\n",
-		     srv->service, srv->instance, srv->node, srv->port);
+	trace_qrtr_ns_service_announce_del(srv->service, srv->instance,
+					   srv->node, srv->port);
 
 	iv.iov_base = &pkt;
 	iv.iov_len = sizeof(pkt);
@@ -244,8 +247,8 @@ static struct qrtr_server *server_add(unsigned int service,
 
 	radix_tree_insert(&node->servers, port, srv);
 
-	trace_printk("add server [%d:%x]@[%d:%d]\n", srv->service,
-		     srv->instance, srv->node, srv->port);
+	trace_qrtr_ns_server_add(srv->service, srv->instance,
+				 srv->node, srv->port);
 
 	return srv;
 
@@ -633,9 +636,8 @@ static void qrtr_ns_worker(struct work_struct *work)
 		cmd = le32_to_cpu(pkt->cmd);
 		if (cmd < ARRAY_SIZE(qrtr_ctrl_pkt_strings) &&
 		    qrtr_ctrl_pkt_strings[cmd])
-			trace_printk("%s from %d:%d\n",
-				     qrtr_ctrl_pkt_strings[cmd], sq.sq_node,
-				     sq.sq_port);
+			trace_qrtr_ns_message(qrtr_ctrl_pkt_strings[cmd],
+					      sq.sq_node, sq.sq_port);
 
 		ret = 0;
 		switch (cmd) {
-- 
2.17.1

