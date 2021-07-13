Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D5B93C6A76
	for <lists+netdev@lfdr.de>; Tue, 13 Jul 2021 08:27:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234106AbhGMGaT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Jul 2021 02:30:19 -0400
Received: from pi.codeconstruct.com.au ([203.29.241.158]:59280 "EHLO
        codeconstruct.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233814AbhGMGaP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Jul 2021 02:30:15 -0400
Received: by codeconstruct.com.au (Postfix, from userid 10000)
        id 2FE2D2144E; Tue, 13 Jul 2021 14:21:36 +0800 (AWST)
From:   Jeremy Kerr <jk@codeconstruct.com.au>
To:     netdev@vger.kernel.org
Cc:     Matt Johnston <matt@codeconstruct.com.au>,
        Andrew Jeffery <andrew@aj.id.au>
Subject: [PATCH RFC net-next v2 04/16] mctp: Add sockaddr_mctp to uapi
Date:   Tue, 13 Jul 2021 14:20:11 +0800
Message-Id: <20210713062023.3286895-5-jk@codeconstruct.com.au>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210713062023.3286895-1-jk@codeconstruct.com.au>
References: <20210713062023.3286895-1-jk@codeconstruct.com.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This change introduces the user-visible MCTP header, containing the
protocol-specific addressing definitions.

Signed-off-by: Jeremy Kerr <jk@codeconstruct.com.au>

v2:
 - include MCTP_ADDR_NULL and MCTP_TAG_* definitions
---
 include/uapi/linux/mctp.h | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/include/uapi/linux/mctp.h b/include/uapi/linux/mctp.h
index 2640a589c14c..5c6a2e0c4e59 100644
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
+#define MCTP_TAG_MASK		GENMASK(2,0)
+#define MCTP_TAG_OWNER		BIT(3)
+
 #endif /* __UAPI_MCTP_H */
-- 
2.30.2

