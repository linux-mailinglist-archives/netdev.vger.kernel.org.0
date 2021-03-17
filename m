Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1717B33E690
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 03:07:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230029AbhCQCHK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 22:07:10 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:45449 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229937AbhCQCGi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 22:06:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615946798;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=I/H51ZCFHZS4q47pvUPfoxWmSgmekB/m7nAflPau0LA=;
        b=AjwAlrvQEk9IGNbIHZZHH4nNRHiHYK38QcWM1igDzDjCUjSnx81S+Ne4E6g3mlJU2eI1uZ
        U+3jtc6efmjxpwzMyIkOFMst0yzrUNVsC/aU5BOWUpYPfBTTi/5oAOOAFsBN33Je5y3+Jz
        IqiKCmvCl+xsONjZ4udYzQc8jPSU+O0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-104-HctoX04fP_-WEzarwKVwnw-1; Tue, 16 Mar 2021 22:06:33 -0400
X-MC-Unique: HctoX04fP_-WEzarwKVwnw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1B49818D6A36;
        Wed, 17 Mar 2021 02:06:32 +0000 (UTC)
Received: from fenrir.redhat.com (ovpn-118-76.rdu2.redhat.com [10.10.118.76])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E06885C1A1;
        Wed, 17 Mar 2021 02:06:30 +0000 (UTC)
From:   jmaloy@redhat.com
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     tipc-discussion@lists.sourceforge.net,
        tung.q.nguyen@dektech.com.au, hoang.h.le@dektech.com.au,
        tuong.t.lien@dektech.com.au, jmaloy@redhat.com, maloy@donjonn.com,
        xinl@redhat.com, ying.xue@windriver.com,
        parthasarathy.bhuvaragan@gmail.com
Subject: [net-next 03/16] tipc: introduce new unified address type for internal use
Date:   Tue, 16 Mar 2021 22:06:10 -0400
Message-Id: <20210317020623.1258298-4-jmaloy@redhat.com>
In-Reply-To: <20210317020623.1258298-1-jmaloy@redhat.com>
References: <20210317020623.1258298-1-jmaloy@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jon Maloy <jmaloy@redhat.com>

We introduce a simplified version of struct sockaddr_tipc, using
anonymous unions and structures. Apart from being nicer to work with,
this struct will come in handy when we in a later commit add another
address type.

Signed-off-by: Jon Maloy <jmaloy@redhat.com>
Acked-by: Ying Xue <ying.xue@windriver.com>
Acked-by: Hoang Le <hoang.h.le@dektech.com.au>
Acked-by: Tung Nguyen <tung.q.nguyen@dektech.com.au>
Acked-by: Xin Long <lucien.xin@gmail.com>
---
 net/tipc/addr.c |  1 +
 net/tipc/addr.h | 46 +++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 46 insertions(+), 1 deletion(-)

diff --git a/net/tipc/addr.c b/net/tipc/addr.c
index abe29d1aa23a..fd0796269eed 100644
--- a/net/tipc/addr.c
+++ b/net/tipc/addr.c
@@ -3,6 +3,7 @@
  *
  * Copyright (c) 2000-2006, 2018, Ericsson AB
  * Copyright (c) 2004-2005, 2010-2011, Wind River Systems
+ * Copyright (c) 2020-2021, Red Hat Inc
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/net/tipc/addr.h b/net/tipc/addr.h
index 1a11831bef62..0772cfadaa0d 100644
--- a/net/tipc/addr.h
+++ b/net/tipc/addr.h
@@ -3,7 +3,7 @@
  *
  * Copyright (c) 2000-2006, 2018, Ericsson AB
  * Copyright (c) 2004-2005, Wind River Systems
- * Copyright (c) 2020, Red Hat Inc
+ * Copyright (c) 2020-2021, Red Hat Inc
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -44,6 +44,50 @@
 #include <net/netns/generic.h>
 #include "core.h"
 
+/* Struct tipc_uaddr: internal version of struct sockaddr_tipc.
+ * Must be kept aligned both regarding field positions and size.
+ */
+struct tipc_uaddr {
+	unsigned short family;
+	unsigned char addrtype;
+	signed char scope;
+	union {
+		struct {
+			struct tipc_service_addr sa;
+			u32 lookup_node;
+		};
+		struct tipc_service_range sr;
+		struct tipc_socket_addr sk;
+	};
+};
+
+static inline void tipc_uaddr(struct tipc_uaddr *ua, u32 atype, u32 scope,
+			      u32 type, u32 lower, u32 upper)
+{
+	ua->family = AF_TIPC;
+	ua->addrtype = atype;
+	ua->scope = scope;
+	ua->sr.type = type;
+	ua->sr.lower = lower;
+	ua->sr.upper = upper;
+}
+
+static inline bool tipc_uaddr_valid(struct tipc_uaddr *ua, int len)
+{
+	u32 atype;
+
+	if (len < sizeof(struct sockaddr_tipc))
+		return false;
+	atype = ua->addrtype;
+	if (ua->family != AF_TIPC)
+		return false;
+	if (atype == TIPC_SERVICE_ADDR || atype == TIPC_SOCKET_ADDR)
+		return true;
+	if (atype == TIPC_SERVICE_RANGE)
+		return ua->sr.upper >= ua->sr.lower;
+	return false;
+}
+
 static inline u32 tipc_own_addr(struct net *net)
 {
 	return tipc_net(net)->node_addr;
-- 
2.29.2

