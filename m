Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5AF40177460
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 11:36:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728882AbgCCKgf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 05:36:35 -0500
Received: from relay11.mail.gandi.net ([217.70.178.231]:46073 "EHLO
        relay11.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728877AbgCCKgd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Mar 2020 05:36:33 -0500
Received: from localhost (lfbn-tou-1-1473-158.w90-89.abo.wanadoo.fr [90.89.41.158])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay11.mail.gandi.net (Postfix) with ESMTPSA id 2E699100018;
        Tue,  3 Mar 2020 10:36:30 +0000 (UTC)
From:   Antoine Tenart <antoine.tenart@bootlin.com>
To:     dsahern@gmail.com, sd@queasysnail.net
Cc:     Antoine Tenart <antoine.tenart@bootlin.com>, netdev@vger.kernel.org
Subject: [PATCH iproute2-next v2 4/4] macsec: add an accessor for validate_str
Date:   Tue,  3 Mar 2020 11:36:19 +0100
Message-Id: <20200303103619.818985-5-antoine.tenart@bootlin.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200303103619.818985-1-antoine.tenart@bootlin.com>
References: <20200303103619.818985-1-antoine.tenart@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds an accessor for the validate_str array, to handle future
changes adding a member.

Signed-off-by: Antoine Tenart <antoine.tenart@bootlin.com>
---
 ip/ipmacsec.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/ip/ipmacsec.c b/ip/ipmacsec.c
index 6104a3a5523d..4e500e4e4825 100644
--- a/ip/ipmacsec.c
+++ b/ip/ipmacsec.c
@@ -653,6 +653,14 @@ static const char *cs_id_to_name(__u64 cid)
 	}
 }
 
+static const char *validate_to_str(__u8 validate)
+{
+	if (validate >= ARRAY_SIZE(validate_str))
+		return "(unknown)";
+
+	return validate_str[validate];
+}
+
 static const char *offload_to_str(__u8 offload)
 {
 	if (offload >= ARRAY_SIZE(offload_str))
@@ -669,7 +677,7 @@ static void print_attrs(struct rtattr *attrs[])
 		__u8 val = rta_getattr_u8(attrs[MACSEC_SECY_ATTR_VALIDATE]);
 
 		print_string(PRINT_ANY, "validate",
-			     "validate %s ", validate_str[val]);
+			     "validate %s ", validate_to_str(val));
 	}
 
 	print_flag(attrs, "sc", MACSEC_RXSC_ATTR_ACTIVE);
@@ -1208,7 +1216,7 @@ static void macsec_print_opt(struct link_util *lu, FILE *f, struct rtattr *tb[])
 		print_string(PRINT_ANY,
 			     "validation",
 			     "validate %s ",
-			     validate_str[val]);
+			     validate_to_str(val));
 	}
 
 	const char *inc_sci, *es, *replay;
-- 
2.24.1

