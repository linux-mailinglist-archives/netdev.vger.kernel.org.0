Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5FDCEF934D
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 15:52:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727698AbfKLOwo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 09:52:44 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:44340 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727674AbfKLOw1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 09:52:27 -0500
Received: from Internal Mail-Server by MTLPINE1 (envelope-from roid@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 12 Nov 2019 16:52:21 +0200
Received: from mtr-vdi-191.wap.labs.mlnx. (mtr-vdi-191.wap.labs.mlnx [10.209.100.28])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id xACEqKxC020273;
        Tue, 12 Nov 2019 16:52:21 +0200
From:   Roi Dayan <roid@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Eli Britstein <elibr@mellanox.com>,
        Roi Dayan <roid@mellanox.com>
Subject: [PATCH iproute2-next 7/8] tc_util: add functions for big endian masked numbers
Date:   Tue, 12 Nov 2019 16:51:53 +0200
Message-Id: <20191112145154.145289-8-roid@mellanox.com>
X-Mailer: git-send-email 2.8.4
In-Reply-To: <20191112145154.145289-1-roid@mellanox.com>
References: <20191112145154.145289-1-roid@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eli Britstein <elibr@mellanox.com>

Add functions for big endian masked numbers as a pre-step towards masked
port numbers.

Signed-off-by: Eli Britstein <elibr@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 tc/tc_util.c | 12 ++++++++++++
 tc/tc_util.h |  2 ++
 2 files changed, 14 insertions(+)

diff --git a/tc/tc_util.c b/tc/tc_util.c
index 13834234665f..b58e6cb8b32c 100644
--- a/tc/tc_util.c
+++ b/tc/tc_util.c
@@ -982,3 +982,15 @@ void print_masked_u8(const char *name, struct rtattr *attr,
 	print_masked_type(UINT8_MAX,  __rta_getattr_u8_u32, name, attr,
 			  mask_attr, newline);
 }
+
+static __u32 __rta_getattr_be16_u32(const struct rtattr *attr)
+{
+	return rta_getattr_be16(attr);
+}
+
+void print_masked_be16(const char *name, struct rtattr *attr,
+		       struct rtattr *mask_attr, bool newline)
+{
+	print_masked_type(UINT16_MAX, __rta_getattr_be16_u32, name, attr,
+			  mask_attr, newline);
+}
diff --git a/tc/tc_util.h b/tc/tc_util.h
index 9adf2ab42138..edc3913889b9 100644
--- a/tc/tc_util.h
+++ b/tc/tc_util.h
@@ -133,4 +133,6 @@ void print_masked_u16(const char *name, struct rtattr *attr,
 		      struct rtattr *mask_attr, bool newline);
 void print_masked_u8(const char *name, struct rtattr *attr,
 		     struct rtattr *mask_attr, bool newline);
+void print_masked_be16(const char *name, struct rtattr *attr,
+		       struct rtattr *mask_attr, bool newline);
 #endif
-- 
2.8.4

