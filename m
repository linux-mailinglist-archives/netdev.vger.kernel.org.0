Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C712F42A5A6
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 15:26:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236908AbhJLN2Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 09:28:25 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:46345 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236987AbhJLN2R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Oct 2021 09:28:17 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id D2EDD5C0198;
        Tue, 12 Oct 2021 09:26:15 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Tue, 12 Oct 2021 09:26:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=loTjH8WhKgdGMViGxW+Hbo/pSzI53gUxFuz5QItz2T8=; b=BurnbSVd
        UhutRYnuaKXIRaZ1mgG02QYF11jjOcOlXP2uWiYQMWfhUTu1K6SZ6QP97J2T3Vgm
        uPh36+Of01SaJj1dw/7pmp7zMOujEQiALAzF/LPdHw0ARBHsX14wsMvsGsHYPNz0
        Rs6mK/3E6wUJqXNOf5ORmaJD/Q1onE7JWVlKE0YFND+RyuonGUoujPA4F3FejE6z
        xt19N/33kkDef3fKmcXEhn5wWRt2uJQqVlMPEgMH2E+fjjj3EcdppQ1vAgbsnFiv
        emUfE1AHS4i+B9csQG6+MPwWVf1MmbKqN9cELoPzFVQZWD/I2rCmSysNBlMFQUCU
        x6DiltJTdFo2fg==
X-ME-Sender: <xms:94xlYatDJ-Ut4trhfTPs023f-EkUay0F-rOPmloPR1E9c_F-WfgG2g>
    <xme:94xlYfeNHcwqHVeYqdtCKcvXT8_EmXFuO-5pmyLN1LR8P9pIeXamE7nuhUeTjFLiT
    GHr1KO2d18ccFk>
X-ME-Received: <xmr:94xlYVy0NX_7R74X1UyzwkJ0yRZNX63LXWKx-h1QtfQVLGxXfxH8SEVl2P_jmjvO8zxmyyYYWEW4TA4uBnEijY3XEQgyddNoP2XWwqDxbvjPgA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrvddtkedgiedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecuvehluhhsthgvrhfuihiivgepudenucfr
    rghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:94xlYVPfm7su06kpdaNspYJq68mt12K4y-AbFdtr07cV9yPpzx4VPg>
    <xmx:94xlYa9sygJFLlhLc2OLMWJ3j0Uk5Hu6ByCFzt-yr5n38Dd2kGf3tg>
    <xmx:94xlYdUcEIKhCTzWVQj4-wPXaIW0QcdcyYYj0tMNbXsojmjMjPxhJQ>
    <xmx:94xlYea09Gdb0lcfVcbVsfaD6uKhRo1xXCfeHhZ51cUw7g88gwRH0g>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 12 Oct 2021 09:26:14 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     mkubecek@suse.cz, popadrian1996@gmail.com, andrew@lunn.ch,
        mlxsw@nvidia.com, moshe@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH ethtool-next 11/14] cmis: Request specific pages for parsing in netlink path
Date:   Tue, 12 Oct 2021 16:25:22 +0300
Message-Id: <20211012132525.457323-12-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211012132525.457323-1-idosch@idosch.org>
References: <20211012132525.457323-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

In the netlink path, unlike the IOCTL path, user space requests specific
EEPROM pages from the kernel. The presence of optional and banked pages
is advertised via various bits in the EEPROM contents.

Currently, for CMIS, the Lower Memory, Page 00h and the optional Page
01h are requested by the netlink code (i.e., netlink/module-eeprom.c)
and passed to the CMIS code (i.e., cmis.c) as two arguments for parsing.

This is problematic for several reasons. First, this approach is not
very scaleable as CMIS supports a lot of optional and banked pages.
Passing them as separate arguments to the CMIS code is not going to
work.

Second, the knowledge of which optional and banked pages are available
is encapsulated in the CMIS parsing code. As such, the common netlink
code has no business of fetching optional and banked pages that might be
invalid.

Instead, pass the command context to the CMIS parsing function and allow
it to fetch only valid pages via the 'MODULE_EEPROM_GET' netlink
message.

Tested by making sure that the output of 'ethtool -m' does not change
before and after the patch.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 cmis.c                  | 60 ++++++++++++++++++++++++++++++++---------
 cmis.h                  |  3 +--
 netlink/module-eeprom.c |  7 +++--
 3 files changed, 51 insertions(+), 19 deletions(-)

diff --git a/cmis.c b/cmis.c
index eb7791dd59df..4798fd4c7d68 100644
--- a/cmis.c
+++ b/cmis.c
@@ -9,9 +9,11 @@
 
 #include <stdio.h>
 #include <math.h>
+#include <errno.h>
 #include "internal.h"
 #include "sff-common.h"
 #include "cmis.h"
+#include "netlink/extapi.h"
 
 struct cmis_memory_map {
 	const __u8 *lower_memory;
@@ -21,6 +23,7 @@ struct cmis_memory_map {
 };
 
 #define CMIS_PAGE_SIZE		0x80
+#define CMIS_I2C_ADDRESS	0x50
 
 static void cmis_show_identifier(const struct cmis_memory_map *map)
 {
@@ -384,36 +387,67 @@ void cmis_show_all_ioctl(const __u8 *id)
 	cmis_show_all_common(&map);
 }
 
-static void
-cmis_memory_map_init_pages(struct cmis_memory_map *map,
-			   const struct ethtool_module_eeprom *page_zero,
-			   const struct ethtool_module_eeprom *page_one)
+static void cmis_request_init(struct ethtool_module_eeprom *request, u8 bank,
+			      u8 page, u32 offset)
 {
+	request->offset = offset;
+	request->length = CMIS_PAGE_SIZE;
+	request->page = page;
+	request->bank = bank;
+	request->i2c_address = CMIS_I2C_ADDRESS;
+	request->data = NULL;
+}
+
+static int
+cmis_memory_map_init_pages(struct cmd_context *ctx,
+			   struct cmis_memory_map *map)
+{
+	struct ethtool_module_eeprom request;
+	int ret;
+
 	/* Lower Memory and Page 00h are always present.
 	 *
 	 * Offset into Upper Memory is between page size and twice the page
 	 * size. Therefore, set the base address of each page to its base
-	 * address minus page size. For Page 00h, this is the address of the
-	 * Lower Memory.
+	 * address minus page size.
 	 */
-	map->lower_memory = page_zero->data;
-	map->page_00h = page_zero->data;
+	cmis_request_init(&request, 0, 0x0, 0);
+	ret = nl_get_eeprom_page(ctx, &request);
+	if (ret < 0)
+		return ret;
+	map->lower_memory = request.data;
+
+	cmis_request_init(&request, 0, 0x0, CMIS_PAGE_SIZE);
+	ret = nl_get_eeprom_page(ctx, &request);
+	if (ret < 0)
+		return ret;
+	map->page_00h = request.data - CMIS_PAGE_SIZE;
 
 	/* Page 01h is only present when the module memory model is paged and
 	 * not flat.
 	 */
 	if (map->lower_memory[CMIS_MEMORY_MODEL_OFFSET] &
 	    CMIS_MEMORY_MODEL_MASK)
-		return;
+		return 0;
+
+	cmis_request_init(&request, 0, 0x1, CMIS_PAGE_SIZE);
+	ret = nl_get_eeprom_page(ctx, &request);
+	if (ret < 0)
+		return ret;
+	map->page_01h = request.data - CMIS_PAGE_SIZE;
 
-	map->page_01h = page_one->data - CMIS_PAGE_SIZE;
+	return 0;
 }
 
-void cmis_show_all_nl(const struct ethtool_module_eeprom *page_zero,
-		      const struct ethtool_module_eeprom *page_one)
+int cmis_show_all_nl(struct cmd_context *ctx)
 {
 	struct cmis_memory_map map = {};
+	int ret;
 
-	cmis_memory_map_init_pages(&map, page_zero, page_one);
+	ret = cmis_memory_map_init_pages(ctx, &map);
+	if (ret < 0)
+		return ret;
 	cmis_show_all_common(&map);
+
+	return 0;
 }
diff --git a/cmis.h b/cmis.h
index c878e3bc5afd..911491dc5c8f 100644
--- a/cmis.h
+++ b/cmis.h
@@ -123,7 +123,6 @@
 
 void cmis_show_all_ioctl(const __u8 *id);
 
-void cmis_show_all_nl(const struct ethtool_module_eeprom *page_zero,
-		      const struct ethtool_module_eeprom *page_one);
+int cmis_show_all_nl(struct cmd_context *ctx);
 
 #endif /* CMIS_H__ */
diff --git a/netlink/module-eeprom.c b/netlink/module-eeprom.c
index ee5508840157..a8e2662e0b8c 100644
--- a/netlink/module-eeprom.c
+++ b/netlink/module-eeprom.c
@@ -314,11 +314,10 @@ static int decoder_prefetch(struct nl_context *nlctx)
 	return page_fetch(nlctx, &request);
 }
 
-static void decoder_print(void)
+static void decoder_print(struct cmd_context *ctx)
 {
 	struct ethtool_module_eeprom *page_three = cache_get(3, 0, ETH_I2C_ADDRESS_LOW);
 	struct ethtool_module_eeprom *page_zero = cache_get(0, 0, ETH_I2C_ADDRESS_LOW);
-	struct ethtool_module_eeprom *page_one = cache_get(1, 0, ETH_I2C_ADDRESS_LOW);
 	u8 module_id = page_zero->data[SFF8636_ID_OFFSET];
 
 	switch (module_id) {
@@ -332,7 +331,7 @@ static void decoder_print(void)
 		break;
 	case SFF8024_ID_QSFP_DD:
 	case SFF8024_ID_DSFP:
-		cmis_show_all_nl(page_zero, page_one);
+		cmis_show_all_nl(ctx);
 		break;
 	default:
 		dump_hex(stdout, page_zero->data, page_zero->length, page_zero->offset);
@@ -524,7 +523,7 @@ int nl_getmodule(struct cmd_context *ctx)
 		ret = decoder_prefetch(nlctx);
 		if (ret)
 			goto cleanup;
-		decoder_print();
+		decoder_print(ctx);
 #endif
 	}
 
-- 
2.31.1

