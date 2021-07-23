Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27F963D36AC
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 10:30:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234501AbhGWHtP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 03:49:15 -0400
Received: from pi.codeconstruct.com.au ([203.29.241.158]:33990 "EHLO
        codeconstruct.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234381AbhGWHtO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Jul 2021 03:49:14 -0400
Received: by codeconstruct.com.au (Postfix, from userid 10000)
        id EB84C21453; Fri, 23 Jul 2021 16:29:46 +0800 (AWST)
From:   Jeremy Kerr <jk@codeconstruct.com.au>
To:     netdev@vger.kernel.org
Cc:     Matt Johnston <matt@codeconstruct.com.au>,
        Andrew Jeffery <andrew@aj.id.au>
Subject: [PATCH net-next v3 03/16] mctp: Add base packet definitions
Date:   Fri, 23 Jul 2021 16:29:19 +0800
Message-Id: <20210723082932.3570396-4-jk@codeconstruct.com.au>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210723082932.3570396-1-jk@codeconstruct.com.au>
References: <20210723082932.3570396-1-jk@codeconstruct.com.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Simple packet header format as defined by DMTF DSP0236.

Signed-off-by: Jeremy Kerr <jk@codeconstruct.com.au>

---
v2:
 - Controller -> component
---
 MAINTAINERS        |  1 +
 include/net/mctp.h | 35 +++++++++++++++++++++++++++++++++++
 2 files changed, 36 insertions(+)
 create mode 100644 include/net/mctp.h

diff --git a/MAINTAINERS b/MAINTAINERS
index aa2a51ff3aa4..72dcbf5f09b0 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -11035,6 +11035,7 @@ M:	Jeremy Kerr <jk@codeconstruct.com.au>
 M:	Matt Johnston <matt@codeconstruct.com.au>
 L:	netdev@vger.kernel.org
 S:	Maintained
+F:	include/net/mctp.h
 F:	net/mctp/
 
 MAN-PAGES: MANUAL PAGES FOR LINUX -- Sections 2, 3, 4, 5, and 7
diff --git a/include/net/mctp.h b/include/net/mctp.h
new file mode 100644
index 000000000000..4c01e083be45
--- /dev/null
+++ b/include/net/mctp.h
@@ -0,0 +1,35 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Management Component Transport Protocol (MCTP)
+ *
+ * Copyright (c) 2021 Code Construct
+ * Copyright (c) 2021 Google
+ */
+
+#ifndef __NET_MCTP_H
+#define __NET_MCTP_H
+
+#include <linux/bits.h>
+
+/* MCTP packet definitions */
+struct mctp_hdr {
+	u8	ver;
+	u8	dest;
+	u8	src;
+	u8	flags_seq_tag;
+};
+
+#define MCTP_VER_MIN	1
+#define MCTP_VER_MAX	1
+
+/* Definitions for flags_seq_tag field */
+#define MCTP_HDR_FLAG_SOM	BIT(7)
+#define MCTP_HDR_FLAG_EOM	BIT(6)
+#define MCTP_HDR_FLAG_TO	BIT(3)
+#define MCTP_HDR_FLAGS		GENMASK(5, 3)
+#define MCTP_HDR_SEQ_SHIFT	4
+#define MCTP_HDR_SEQ_MASK	GENMASK(1, 0)
+#define MCTP_HDR_TAG_SHIFT	0
+#define MCTP_HDR_TAG_MASK	GENMASK(2, 0)
+
+#endif /* __NET_MCTP_H */
-- 
2.30.2

