Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FECD3D9BA2
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 04:21:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233459AbhG2CVL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 22:21:11 -0400
Received: from pi.codeconstruct.com.au ([203.29.241.158]:35834 "EHLO
        codeconstruct.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233324AbhG2CVK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Jul 2021 22:21:10 -0400
Received: by codeconstruct.com.au (Postfix, from userid 10000)
        id 276F621413; Thu, 29 Jul 2021 10:21:05 +0800 (AWST)
From:   Jeremy Kerr <jk@codeconstruct.com.au>
To:     netdev@vger.kernel.org
Cc:     Matt Johnston <matt@codeconstruct.com.au>,
        Andrew Jeffery <andrew@aj.id.au>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH net-next v4 03/15] mctp: Add base packet definitions
Date:   Thu, 29 Jul 2021 10:20:41 +0800
Message-Id: <20210729022053.134453-4-jk@codeconstruct.com.au>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210729022053.134453-1-jk@codeconstruct.com.au>
References: <20210729022053.134453-1-jk@codeconstruct.com.au>
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
index 22a1ff9afd9d..770b986d10f0 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -11037,6 +11037,7 @@ M:	Jeremy Kerr <jk@codeconstruct.com.au>
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

