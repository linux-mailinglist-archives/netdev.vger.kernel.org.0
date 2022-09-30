Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E548B5F02D6
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 04:34:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229954AbiI3Cek (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 22:34:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229889AbiI3Cea (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 22:34:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1724C12262F;
        Thu, 29 Sep 2022 19:34:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A84486220F;
        Fri, 30 Sep 2022 02:34:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70620C43141;
        Fri, 30 Sep 2022 02:34:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664505268;
        bh=/Yqcru/FuIfI2NvtauIUfLKOXV0doMrJFIiI9ToVLNs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jhn9CtRXuM8GLTWS7HivvDFND9dWJ6fYgakg05yF2MZ76ZPA4BgdlmkSqFGu58Jgb
         UkaR6GgrK0qJFkpHZavio80cPXSup66VCDH3EeY+ZXXWASbM56Rp2PN/2UebS/Vj+m
         oU6+jNkYdZX8+OrIJTFqrEhHn4b/fkEWCWuaeYZP1oxyu8Ml7CMOL5wQutS5dy1+T+
         MAwAZbPxoTtrQllVCSZXWCTT9fkHWesSft7fyb76M1tiEvbubkt+dREZA5wSi9p0Ms
         s6a54oT7+i6gFiBXkx8IRwGSLISM0k+tb6z0FHSQOajlL6qkudhF0kT4+HP2kTu4rP
         myOdxS3wkjsVg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        robh@kernel.org, johannes@sipsolutions.net, ecree.xilinx@gmail.com,
        stephen@networkplumber.org, sdf@google.com, f.fainelli@gmail.com,
        fw@strlen.de, linux-doc@vger.kernel.org, razor@blackwall.org,
        nicolas.dichtel@6wind.com, gnault@redhat.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v2 5/7] net: fou: regenerate the uAPI from the spec
Date:   Thu, 29 Sep 2022 19:34:16 -0700
Message-Id: <20220930023418.1346263-6-kuba@kernel.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220930023418.1346263-1-kuba@kernel.org>
References: <20220930023418.1346263-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,UPPERCASE_50_75 autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Regenerate the FOU uAPI header from the YAML spec.

The flags now come before attributes which use them,
and the comments for type disappear (coders should look
at the spec instead).

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
2.37.3

