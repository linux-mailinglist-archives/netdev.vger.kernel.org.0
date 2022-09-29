Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B17B25EEABB
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 03:11:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233894AbiI2BLk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 21:11:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233375AbiI2BLg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 21:11:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7A8D10D651;
        Wed, 28 Sep 2022 18:11:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 338CB614A0;
        Thu, 29 Sep 2022 01:11:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B5CAC433D7;
        Thu, 29 Sep 2022 01:11:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664413894;
        bh=K7+z9+XTaap4yCTzcuomg9ZSTHfOLcdGz3QgcGftL98=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=txIUn0c+Fbl9+roIafbJArsetHnSYhMuSpuYxJYiV9hDhbp6AIsaKW9hrxIbYWAJe
         NOBLhnN5i/2sX/tkIq0hzxYNgKNpzkZFAfICOiVczdGHtPOv5jVPA+RntZCW+Rk+su
         0B+Q8CNeolXPKgjNWcs1+aZt9NxK3NCUMerhhW1rRzx4URutEhPui1qcHx32PF2m0q
         Ng7oFt4lul9u3JHJd37pd1ZE7p9Xo18A5JJs2EQXDwj1UF+OLmZWLyRA980+5u+1XR
         HMq7jp17FzQG827Dll90w40UcDUdeEP4CSSrZEHpKlz4SZaw+Pe3C6j5zz5W+VDlg2
         1GK202I6rLwSQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        robh@kernel.org, johannes@sipsolutions.net, ecree.xilinx@gmail.com,
        stephen@networkplumber.org, sdf@google.com, f.fainelli@gmail.com,
        fw@strlen.de, linux-doc@vger.kernel.org, razor@blackwall.org,
        nicolas.dichtel@6wind.com, gnault@redhat.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 5/6] net: fou: regenerate the uAPI from the spec
Date:   Wed, 28 Sep 2022 18:11:21 -0700
Message-Id: <20220929011122.1139374-6-kuba@kernel.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220929011122.1139374-1-kuba@kernel.org>
References: <20220929011122.1139374-1-kuba@kernel.org>
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
index 87c2c9f08803..c7d90d4e1428 100644
--- a/include/uapi/linux/fou.h
+++ b/include/uapi/linux/fou.h
@@ -1,32 +1,37 @@
 /* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
-/* fou.h - FOU Interface */
+// Do not edit directly, auto-generated from:
+//	Documentation/netlink/specs/fou.yaml
+// YNL-GEN uapi header
 
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

