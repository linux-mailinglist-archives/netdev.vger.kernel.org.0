Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2C5C30AF4F
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 19:31:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232776AbhBASag (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 13:30:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232094AbhBASPU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Feb 2021 13:15:20 -0500
Received: from mail-qt1-x833.google.com (mail-qt1-x833.google.com [IPv6:2607:f8b0:4864:20::833])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5279CC061351
        for <netdev@vger.kernel.org>; Mon,  1 Feb 2021 10:14:07 -0800 (PST)
Received: by mail-qt1-x833.google.com with SMTP id t17so12971156qtq.2
        for <netdev@vger.kernel.org>; Mon, 01 Feb 2021 10:14:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=71Q5fX5KniqExiH8OTPpV5OrBVm/zGZPPSfmeB4SWUo=;
        b=cEhbMu1jtujW0JIsnP4usOSG4hC5HPOvSfx9O5kHrN/hWIvWQEq/ISZ33d3lL8JQsB
         uq4/Oz0zaw0hwSdHC9ZSnCZX06+Uhe06jlrmj0HJOAu7748R8M0JKeLE6fmHxont5bvX
         +eQCAuHmffagpryMx1TZfdkktxbhgre+FCBFvBUWQw7l98Xik3O6fPa6UQEmAiWj270F
         sSGo5XB3uUl9Q1ThA+AY2ZlrvPI8a6jI1WBStsAFIX5GTRNtfgX5e2nyo1FkIQ6vGtz/
         8sGtq7GUisuBpnrfAiOY+y37K2o8XqImAWU5RcvyfkbM6EAyel6Jkigjxq5P7MLDeatk
         24zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=71Q5fX5KniqExiH8OTPpV5OrBVm/zGZPPSfmeB4SWUo=;
        b=EWRHNK3EHdhMgjjcvHS2GJ0V5NKRaXylpHVSu5XC/Qu0nKDYgbNPEvHxkNY/bpEXDf
         k7r5+nEZVCeir72Ne/fEdYZLV53XaBzYoU7KSMNDbiYo8thPMU3c5GvfPbp8YzjQCLO6
         M3dmUC7SnglxFz+mgQwY1Kis1FiJ1oH9SLSge+9X0nm+5z3lwp4K7wAFDMJjgruczSXJ
         QNQV8hfWlqxK1VQYT6Y4ppHEvE3tk4oxX4Y1JmgEsM/VBuTZP5mDKxJGS0Eu/cpN3FTJ
         xePsg6B+P++bK+uPKrocN3tzXI4L9h0LlfS6widmVGGBdmwJ/qCj00dSQhAtmY+2ZH1C
         F+TA==
X-Gm-Message-State: AOAM532QE+PMr5woYVQZ40AyxQVGrbSxSr8/eGpEnA4rGX5l8d8JtWm8
        OUrDnSkjIwSJGZHGxHB6fUK2DlcTlVMYBA==
X-Google-Smtp-Source: ABdhPJwNKAGnYW3UCNHpJtHSFhqjmcHZig/Sb2mCBadMO2L4VWtN9j1wsA98dbgELhn4Oq1tmfSD3w==
X-Received: by 2002:aed:2802:: with SMTP id r2mr16655468qtd.76.1612203246452;
        Mon, 01 Feb 2021 10:14:06 -0800 (PST)
Received: from horizon.localdomain ([177.220.174.167])
        by smtp.gmail.com with ESMTPSA id a21sm15158866qkb.124.2021.02.01.10.14.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Feb 2021 10:14:05 -0800 (PST)
Received: by horizon.localdomain (Postfix, from userid 1000)
        id D93EAC0782; Mon,  1 Feb 2021 15:14:02 -0300 (-03)
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Subject: [PATCH RESEND net-next] netlink: add tracepoint at NL_SET_ERR_MSG
Date:   Mon,  1 Feb 2021 15:12:19 -0300
Message-Id: <fb6e25a4833e6a0e055633092b05bae3c6e1c0d3.1611934253.git.marcelo.leitner@gmail.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Often userspace won't request the extack information, or they don't log it
because of log level or so, and even when they do, sometimes it's not
enough to know exactly what caused the error.

Netlink extack is the standard way of reporting erros with descriptive
error messages. With a trace point on it, we then can know exactly where
the error happened, regardless of userspace app. Also, we can even see if
the err msg was overwritten.

The wrapper do_trace_netlink_extack() is because trace points shouldn't be
called from .h files, as trace points are not that small, and the function
call to do_trace_netlink_extack() on the macros is not protected by
tracepoint_enabled() because the macros are called from modules, and this
would require exporting some trace structs. As this is error path, it's
better to export just the wrapper instead.

Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
---
 include/linux/netlink.h        |  8 ++++++++
 include/trace/events/netlink.h | 29 +++++++++++++++++++++++++++++
 net/netlink/af_netlink.c       |  8 ++++++++
 3 files changed, 45 insertions(+)
 create mode 100644 include/trace/events/netlink.h

diff --git a/include/linux/netlink.h b/include/linux/netlink.h
index 9f118771e24808623287d46157046749ec96a2b5..fe77f30aabfdde8882f6de99ecf633b79e903b77 100644
--- a/include/linux/netlink.h
+++ b/include/linux/netlink.h
@@ -6,11 +6,15 @@
 #include <linux/capability.h>
 #include <linux/skbuff.h>
 #include <linux/export.h>
+#include <linux/tracepoint.h>
 #include <net/scm.h>
 #include <uapi/linux/netlink.h>
 
 struct net;
 
+DECLARE_TRACEPOINT(netlink_extack);
+void do_trace_netlink_extack(const char *msg);
+
 static inline struct nlmsghdr *nlmsg_hdr(const struct sk_buff *skb)
 {
 	return (struct nlmsghdr *)skb->data;
@@ -90,6 +94,8 @@ struct netlink_ext_ack {
 	static const char __msg[] = msg;		\
 	struct netlink_ext_ack *__extack = (extack);	\
 							\
+	do_trace_netlink_extack(__msg);			\
+							\
 	if (__extack)					\
 		__extack->_msg = __msg;			\
 } while (0)
@@ -110,6 +116,8 @@ struct netlink_ext_ack {
 	static const char __msg[] = msg;			\
 	struct netlink_ext_ack *__extack = (extack);		\
 								\
+	do_trace_netlink_extack(__msg);				\
+								\
 	if (__extack) {						\
 		__extack->_msg = __msg;				\
 		__extack->bad_attr = (attr);			\
diff --git a/include/trace/events/netlink.h b/include/trace/events/netlink.h
new file mode 100644
index 0000000000000000000000000000000000000000..3b7be3b386a4f3976738a107fe4b7e0915ae58bb
--- /dev/null
+++ b/include/trace/events/netlink.h
@@ -0,0 +1,29 @@
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM netlink
+
+#if !defined(_TRACE_NETLINK_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_NETLINK_H
+
+#include <linux/tracepoint.h>
+
+TRACE_EVENT(netlink_extack,
+
+	TP_PROTO(const char *msg),
+
+	TP_ARGS(msg),
+
+	TP_STRUCT__entry(
+		__string(	msg,	msg	)
+	),
+
+	TP_fast_assign(
+		__assign_str(msg, msg);
+	),
+
+	TP_printk("msg=%s", __get_str(msg))
+);
+
+#endif /* _TRACE_NETLINK_H */
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index daca50d6bb1283f3b04b585217f2aea6ba279b8b..dd488938447f9735daf1fb727c339a9874bab38b 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -67,6 +67,8 @@
 #include <net/sock.h>
 #include <net/scm.h>
 #include <net/netlink.h>
+#define CREATE_TRACE_POINTS
+#include <trace/events/netlink.h>
 
 #include "af_netlink.h"
 
@@ -147,6 +149,12 @@ static BLOCKING_NOTIFIER_HEAD(netlink_chain);
 
 static const struct rhashtable_params netlink_rhashtable_params;
 
+void do_trace_netlink_extack(const char *msg)
+{
+	trace_netlink_extack(msg);
+}
+EXPORT_SYMBOL(do_trace_netlink_extack);
+
 static inline u32 netlink_group_mask(u32 group)
 {
 	return group ? 1 << (group - 1) : 0;
-- 
2.29.2

