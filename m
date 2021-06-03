Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C74F0399B28
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 08:59:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230019AbhFCHBZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 03:01:25 -0400
Received: from pi.codeconstruct.com.au ([203.29.241.158]:46922 "EHLO
        codeconstruct.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229878AbhFCHBO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Jun 2021 03:01:14 -0400
Received: by codeconstruct.com.au (Postfix, from userid 10000)
        id 5D29B219E8; Thu,  3 Jun 2021 14:52:29 +0800 (AWST)
From:   Jeremy Kerr <jk@codeconstruct.com.au>
To:     netdev@vger.kernel.org
Cc:     Andrew Jeffery <andrew@aj.id.au>,
        Matt Johnston <matt@codeconstruct.com.au>
Subject: [PATCH RFC net-next 03/16] mctp: Add base packet definitions
Date:   Thu,  3 Jun 2021 14:52:05 +0800
Message-Id: <20210603065218.570867-4-jk@codeconstruct.com.au>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210603065218.570867-1-jk@codeconstruct.com.au>
References: <20210603065218.570867-1-jk@codeconstruct.com.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Simple packet header format as defined by DMTF DSP0236.

Signed-off-by: Jeremy Kerr <jk@codeconstruct.com.au>
---
 MAINTAINERS        |  1 +
 include/net/mctp.h | 35 +++++++++++++++++++++++++++++++++++
 2 files changed, 36 insertions(+)
 create mode 100644 include/net/mctp.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 5041ea78ab97..262451188c46 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -10874,6 +10874,7 @@ M:	Jeremy Kerr <jk@codeconstruct.com.au>
 M:	Matt Johnston <matt@codeconstruct.com.au>
 L:	netdev@vger.kernel.org
 S:	Maintained
+F:	include/net/mctp.h
 F:	net/mctp/
 
 MAN-PAGES: MANUAL PAGES FOR LINUX -- Sections 2, 3, 4, 5, and 7
diff --git a/include/net/mctp.h b/include/net/mctp.h
new file mode 100644
index 000000000000..757304d98c0a
--- /dev/null
+++ b/include/net/mctp.h
@@ -0,0 +1,35 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Management Controller Transport Protocol (MCTP)
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

