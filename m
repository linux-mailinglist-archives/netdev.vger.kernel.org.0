Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E7B0675C19
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 18:51:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230459AbjATRvU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 12:51:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230440AbjATRvR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 12:51:17 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2E4CC13CD;
        Fri, 20 Jan 2023 09:50:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id CE82CCE2A38;
        Fri, 20 Jan 2023 17:50:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47339C4339E;
        Fri, 20 Jan 2023 17:50:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674237053;
        bh=viGWj/eMibR9ySLKdFXKs0r6jMdgru2yeaGh7QvU0r4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oqC7QmpykWTnEawRe59DTf/XmQ5VuTksNqUkohONXZC+ZdDGDBH0VeSHBcXatS3D7
         jn9z77JvUVA+YyLBfOQ+NgIU0UZr05Vj/3Yr1CUTwaPFtU1VwKS6TWCE+H0XA0ZAtG
         imIc0hdqNTiqGY7eUwlZbSYPahLRiFniiTWBnIF0dN3kA26bPPMyJz3DxBZdVSACgL
         5Vhx15vEJ5IpUDOjAfHkXbedmdvDKg4pYM0nTYTA6wK5sQP9Is3n0EGKlSafEkXwY+
         RmmeoOE2e7e+2UnqHmH7ZAc24Z3oVPMAXPoA7wqqadIx10Fruf0hsFfndjd3s7AkT6
         ypykZJdmnhpUg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        robh@kernel.org, johannes@sipsolutions.net,
        stephen@networkplumber.org, ecree.xilinx@gmail.com, sdf@google.com,
        f.fainelli@gmail.com, fw@strlen.de, linux-doc@vger.kernel.org,
        razor@blackwall.org, nicolas.dichtel@6wind.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v4 5/8] net: fou: regenerate the uAPI from the spec
Date:   Fri, 20 Jan 2023 09:50:38 -0800
Message-Id: <20230120175041.342573-6-kuba@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230120175041.342573-1-kuba@kernel.org>
References: <20230120175041.342573-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Regenerate the FOU uAPI header from the YAML spec.

The flags now come before attributes which use them,
and the comments for type disappear (coders should look
at the spec instead).

Acked-by: Stanislav Fomichev <sdf@google.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 include/uapi/linux/fou.h | 54 +++++++++++++++++++---------------------
 1 file changed, 26 insertions(+), 28 deletions(-)

diff --git a/include/uapi/linux/fou.h b/include/uapi/linux/fou.h
index 87c2c9f08803..19ebbef41a63 100644
--- a/include/uapi/linux/fou.h
+++ b/include/uapi/linux/fou.h
@@ -1,32 +1,37 @@
 /* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
-/* fou.h - FOU Interface */
+/* Do not edit directly, auto-generated from: */
+/*	Documentation/netlink/specs/fou.yaml */
+/* YNL-GEN uapi header */
 
 #ifndef _UAPI_LINUX_FOU_H
 #define _UAPI_LINUX_FOU_H
 
-/* NETLINK_GENERIC related info
- */
 #define FOU_GENL_NAME		"fou"
-#define FOU_GENL_VERSION	0x1
+#define FOU_GENL_VERSION	1
 
 enum {
-	FOU_ATTR_UNSPEC,
-	FOU_ATTR_PORT,				/* u16 */
-	FOU_ATTR_AF,				/* u8 */
-	FOU_ATTR_IPPROTO,			/* u8 */
-	FOU_ATTR_TYPE,				/* u8 */
-	FOU_ATTR_REMCSUM_NOPARTIAL,		/* flag */
-	FOU_ATTR_LOCAL_V4,			/* u32 */
-	FOU_ATTR_LOCAL_V6,			/* in6_addr */
-	FOU_ATTR_PEER_V4,			/* u32 */
-	FOU_ATTR_PEER_V6,			/* in6_addr */
-	FOU_ATTR_PEER_PORT,			/* u16 */
-	FOU_ATTR_IFINDEX,			/* s32 */
-
-	__FOU_ATTR_MAX,
+	FOU_ENCAP_UNSPEC,
+	FOU_ENCAP_DIRECT,
+	FOU_ENCAP_GUE,
 };
 
-#define FOU_ATTR_MAX		(__FOU_ATTR_MAX - 1)
+enum {
+	FOU_ATTR_UNSPEC,
+	FOU_ATTR_PORT,
+	FOU_ATTR_AF,
+	FOU_ATTR_IPPROTO,
+	FOU_ATTR_TYPE,
+	FOU_ATTR_REMCSUM_NOPARTIAL,
+	FOU_ATTR_LOCAL_V4,
+	FOU_ATTR_LOCAL_V6,
+	FOU_ATTR_PEER_V4,
+	FOU_ATTR_PEER_V6,
+	FOU_ATTR_PEER_PORT,
+	FOU_ATTR_IFINDEX,
+
+	__FOU_ATTR_MAX
+};
+#define FOU_ATTR_MAX (__FOU_ATTR_MAX - 1)
 
 enum {
 	FOU_CMD_UNSPEC,
@@ -34,15 +39,8 @@ enum {
 	FOU_CMD_DEL,
 	FOU_CMD_GET,
 
-	__FOU_CMD_MAX,
+	__FOU_CMD_MAX
 };
-
-enum {
-	FOU_ENCAP_UNSPEC,
-	FOU_ENCAP_DIRECT,
-	FOU_ENCAP_GUE,
-};
-
-#define FOU_CMD_MAX	(__FOU_CMD_MAX - 1)
+#define FOU_CMD_MAX (__FOU_CMD_MAX - 1)
 
 #endif /* _UAPI_LINUX_FOU_H */
-- 
2.39.0

