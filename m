Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24B15399B23
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 08:59:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229967AbhFCHBT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 03:01:19 -0400
Received: from pi.codeconstruct.com.au ([203.29.241.158]:46928 "EHLO
        codeconstruct.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229884AbhFCHBN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Jun 2021 03:01:13 -0400
Received: by codeconstruct.com.au (Postfix, from userid 10000)
        id D0D45219E9; Thu,  3 Jun 2021 14:52:29 +0800 (AWST)
From:   Jeremy Kerr <jk@codeconstruct.com.au>
To:     netdev@vger.kernel.org
Cc:     Andrew Jeffery <andrew@aj.id.au>,
        Matt Johnston <matt@codeconstruct.com.au>
Subject: [PATCH RFC net-next 04/16] mctp: Add sockaddr_mctp to uapi
Date:   Thu,  3 Jun 2021 14:52:06 +0800
Message-Id: <20210603065218.570867-5-jk@codeconstruct.com.au>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210603065218.570867-1-jk@codeconstruct.com.au>
References: <20210603065218.570867-1-jk@codeconstruct.com.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This change introduces the user-visible MCTP header, containing the
protocol-specific addressing definitions.

Signed-off-by: Jeremy Kerr <jk@codeconstruct.com.au>
---
 include/uapi/linux/mctp.h | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/include/uapi/linux/mctp.h b/include/uapi/linux/mctp.h
index eec6715143a0..a9f6c6744b27 100644
--- a/include/uapi/linux/mctp.h
+++ b/include/uapi/linux/mctp.h
@@ -9,7 +9,24 @@
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
+#define MCTP_ADDR_ANY		0xff
+
 #endif /* __UAPI_MCTP_H */
-- 
2.30.2

