Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BB233D36AF
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 10:30:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234540AbhGWHtW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 03:49:22 -0400
Received: from pi.codeconstruct.com.au ([203.29.241.158]:33998 "EHLO
        codeconstruct.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234384AbhGWHtO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Jul 2021 03:49:14 -0400
Received: by codeconstruct.com.au (Postfix, from userid 10000)
        id 47A2521457; Fri, 23 Jul 2021 16:29:47 +0800 (AWST)
From:   Jeremy Kerr <jk@codeconstruct.com.au>
To:     netdev@vger.kernel.org
Cc:     Matt Johnston <matt@codeconstruct.com.au>,
        Andrew Jeffery <andrew@aj.id.au>
Subject: [PATCH net-next v3 04/16] mctp: Add sockaddr_mctp to uapi
Date:   Fri, 23 Jul 2021 16:29:20 +0800
Message-Id: <20210723082932.3570396-5-jk@codeconstruct.com.au>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210723082932.3570396-1-jk@codeconstruct.com.au>
References: <20210723082932.3570396-1-jk@codeconstruct.com.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This change introduces the user-visible MCTP header, containing the
protocol-specific addressing definitions.

Signed-off-by: Jeremy Kerr <jk@codeconstruct.com.au>

---
v2:
 - include MCTP_ADDR_NULL and MCTP_TAG_* definitions
v3:
 - don't use GENMASK/BIT in uapi
---
 include/uapi/linux/mctp.h | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/include/uapi/linux/mctp.h b/include/uapi/linux/mctp.h
index 2640a589c14c..52b54d13f385 100644
--- a/include/uapi/linux/mctp.h
+++ b/include/uapi/linux/mctp.h
@@ -9,7 +9,28 @@
 #ifndef __UAPI_MCTP_H
 #define __UAPI_MCTP_H
 
+#include <linux/types.h>
+
+typedef __u8			mctp_eid_t;
+
+struct mctp_addr {
+	mctp_eid_t		s_addr;
+};
+
 struct sockaddr_mctp {
+	unsigned short int	smctp_family;
+	int			smctp_network;
+	struct mctp_addr	smctp_addr;
+	__u8			smctp_type;
+	__u8			smctp_tag;
 };
 
+#define MCTP_NET_ANY		0x0
+
+#define MCTP_ADDR_NULL		0x00
+#define MCTP_ADDR_ANY		0xff
+
+#define MCTP_TAG_MASK		0x07
+#define MCTP_TAG_OWNER		0x08
+
 #endif /* __UAPI_MCTP_H */
-- 
2.30.2

