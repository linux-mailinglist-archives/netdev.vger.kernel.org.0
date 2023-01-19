Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11E0D672D75
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 01:36:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229741AbjASAgZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 19:36:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229749AbjASAgX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 19:36:23 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2284259240;
        Wed, 18 Jan 2023 16:36:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 77E4261B05;
        Thu, 19 Jan 2023 00:36:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2755C43392;
        Thu, 19 Jan 2023 00:36:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674088582;
        bh=KdQ6PdoT/RGnSJLqUFL++Ra6rTYXpx4eFmFmlTmavjk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sVW70mh5tc6gpNZ+e5ZwhlBR++6VfkxN3U+cGAMzEC/9gBRXLvu9QmqXNGgQJ9QCX
         xoiqc7JML6wvfnh16cJNG1AH8e+s0yJRuypqlZNsztC6F2cqdo2gX2cS6XAfn5VAdD
         iiEnPpzZZFcEblbyfRIY12CPzGzlXEBfHHWhaT80TEejtHCn4g84fiTnKUzJhXhgdy
         iHVFf4r2FW19iylKRa2W+0l77PhJPBeIrt5EVhMhMF14XUbQGPUcktEqVSFvibu19A
         +sBd4u5wanIKr+XUCGgDpEh4CU9OLcYAc1kfhtRzqicSUHPdSc2pDBsnfTrlPkRVt+
         6NbP0VYqT8iHA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        robh@kernel.org, johannes@sipsolutions.net,
        stephen@networkplumber.org, ecree.xilinx@gmail.com, sdf@google.com,
        f.fainelli@gmail.com, fw@strlen.de, linux-doc@vger.kernel.org,
        razor@blackwall.org, nicolas.dichtel@6wind.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v3 5/8] net: fou: regenerate the uAPI from the spec
Date:   Wed, 18 Jan 2023 16:36:10 -0800
Message-Id: <20230119003613.111778-6-kuba@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230119003613.111778-1-kuba@kernel.org>
References: <20230119003613.111778-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
2.39.0

