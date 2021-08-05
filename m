Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CFB13E1BD2
	for <lists+netdev@lfdr.de>; Thu,  5 Aug 2021 20:58:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241865AbhHES6L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 14:58:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241061AbhHES6L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Aug 2021 14:58:11 -0400
Received: from mail-ot1-x334.google.com (mail-ot1-x334.google.com [IPv6:2607:f8b0:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0BF8C061765
        for <netdev@vger.kernel.org>; Thu,  5 Aug 2021 11:57:55 -0700 (PDT)
Received: by mail-ot1-x334.google.com with SMTP id z6-20020a0568302906b02904f268d34f86so5870043otu.2
        for <netdev@vger.kernel.org>; Thu, 05 Aug 2021 11:57:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nsRwK3nV8f5bjMv6jFFTlnHRWwO4N1j6c3q+aaDgWjk=;
        b=p+ctxhe6pqTDt9ZQSPT3CZnCK6CrfSZprtQEPUW/kodux9lPWnH7DAfaGd657mnrJi
         GOpHV+U69K/yv1apyLzSsRIoQ/Mab00jWhkNNdrFyGqPpelHfYgZ2dbBXaClDhXWpOyc
         bKiowGgzyphVJTovVSeahTDch4RvM4ZzOf3bBy0HdA5jRoDxCuElVB9ks9fjOFKoDXRN
         AEPI5jqHoKV5FWzTdll1Aj4nx7vztdGsWAnKiWAPUx5jZBCnSjJBCC7Si9eED1i/JVaG
         o1qJUkDjU7iUItc7KcdKAEG7q+nBlV6l3k0ise0+wD6IQa90uH63jF+O6G+snNWnlm0t
         TlSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nsRwK3nV8f5bjMv6jFFTlnHRWwO4N1j6c3q+aaDgWjk=;
        b=mhZLdcZLvb1mfa52aCJFV3KVIFnhKhxqN4EgzgMmQhGbLc+rW9HKaH2wAXmQn096Fd
         Nh0+5D0owoFkVHFh96wlfcGwP0FcZMqNhb9z2lbDHaUItys14rol8sa8JXFEmZQPtaGw
         YUYXUhg610lZgkNQW7vx5YxVk/y1tnWlYvvz2p9kD4c5CABK8D1msRyFG8Wdu6brCzk8
         iQZ1UZ/Q0TMwvloBFrMCqLtvvdhpFIaKBwzIneUz+zdGNBAvHiWNj39qttyWMex12I76
         IDGXMAoJkRPNaa5V/hMUqLO7Y3wry5N8c1tgjgQZu6/iGuLf55/4n9u2c+JC/KzVDbIc
         Rryg==
X-Gm-Message-State: AOAM532j6G5ENpNGwmjUzFbLLRDLOMgpARu2WyDwILX073MXscHvytmH
        qVMH5DbBN39KuxYG5iSEDdGRRX536VY=
X-Google-Smtp-Source: ABdhPJwWMz7ODnEKth7YEYpAajCchjvEm7Xfu80AQG3RqGFVusPeNXFhd4sbAtw0KbEU7pfCNiM8xA==
X-Received: by 2002:a9d:206c:: with SMTP id n99mr4717411ota.64.1628189874108;
        Thu, 05 Aug 2021 11:57:54 -0700 (PDT)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:c64b:2366:2e53:c024])
        by smtp.gmail.com with ESMTPSA id r5sm358678otk.71.2021.08.05.11.57.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Aug 2021 11:57:53 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Qitao Xu <qitao.xu@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>
Subject: [Patch net-next 01/13] net: introduce a new header file include/trace/events/ip.h
Date:   Thu,  5 Aug 2021 11:57:38 -0700
Message-Id: <20210805185750.4522-2-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210805185750.4522-1-xiyou.wangcong@gmail.com>
References: <20210805185750.4522-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Qitao Xu <qitao.xu@bytedance.com>

Header file include/trace/events/ip.h is introduced to define
IP/IPv6 layer tracepoints.

Reviewed-by: Cong Wang <cong.wang@bytedance.com>
Signed-off-by: Qitao Xu <qitao.xu@bytedance.com>
---
 include/trace/events/ip.h | 47 +++++++++++++++++++++++++++++++++++++++
 net/core/net-traces.c     |  1 +
 2 files changed, 48 insertions(+)
 create mode 100644 include/trace/events/ip.h

diff --git a/include/trace/events/ip.h b/include/trace/events/ip.h
new file mode 100644
index 000000000000..008f821ebc50
--- /dev/null
+++ b/include/trace/events/ip.h
@@ -0,0 +1,47 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM ip
+
+#if !defined(_TRACE_IP_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_IP_H
+
+#include <linux/ipv6.h>
+#include <linux/tcp.h>
+#include <linux/tracepoint.h>
+#include <net/ipv6.h>
+#include <net/tcp.h>
+#include <linux/sock_diag.h>
+
+#define TP_STORE_V4MAPPED(__entry, saddr, daddr)		\
+	do {							\
+		struct in6_addr *pin6;				\
+								\
+		pin6 = (struct in6_addr *)__entry->saddr_v6;	\
+		ipv6_addr_set_v4mapped(saddr, pin6);		\
+		pin6 = (struct in6_addr *)__entry->daddr_v6;	\
+		ipv6_addr_set_v4mapped(daddr, pin6);		\
+	} while (0)
+
+#if IS_ENABLED(CONFIG_IPV6)
+#define TP_STORE_ADDRS(__entry, saddr, daddr, saddr6, daddr6)		\
+	do {								\
+		if (sk->sk_family == AF_INET6) {			\
+			struct in6_addr *pin6;				\
+									\
+			pin6 = (struct in6_addr *)__entry->saddr_v6;	\
+			*pin6 = saddr6;					\
+			pin6 = (struct in6_addr *)__entry->daddr_v6;	\
+			*pin6 = daddr6;					\
+		} else {						\
+			TP_STORE_V4MAPPED(__entry, saddr, daddr);	\
+		}							\
+	} while (0)
+#else
+#define TP_STORE_ADDRS(__entry, saddr, daddr, saddr6, daddr6)	\
+	TP_STORE_V4MAPPED(__entry, saddr, daddr)
+#endif
+
+#endif /* _TRACE_IP_H */
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
diff --git a/net/core/net-traces.c b/net/core/net-traces.c
index c40cd8dd75c7..e1bd46076ad0 100644
--- a/net/core/net-traces.c
+++ b/net/core/net-traces.c
@@ -35,6 +35,7 @@
 #include <trace/events/tcp.h>
 #include <trace/events/fib.h>
 #include <trace/events/qdisc.h>
+#include <trace/events/ip.h>
 #if IS_ENABLED(CONFIG_BRIDGE)
 #include <trace/events/bridge.h>
 EXPORT_TRACEPOINT_SYMBOL_GPL(br_fdb_add);
-- 
2.27.0

