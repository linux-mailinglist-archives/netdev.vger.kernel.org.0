Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B98142A5A7
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 15:26:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236760AbhJLN23 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 09:28:29 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:51453 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237027AbhJLN2T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Oct 2021 09:28:19 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id B9D835C0189;
        Tue, 12 Oct 2021 09:26:17 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Tue, 12 Oct 2021 09:26:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=PxeR2bB54Lo4z2ysBnMmKkO/xgafhQqAvjGV5o9tIAA=; b=Op5ZyONk
        t48rSZXd2iW27PxXbZaV3d7KCnI/WRQqCdThWnV5curKQrXSpzrm+WxXX23Z69xj
        JsvXO7Ximvy4oI5P5UBcGzamyAQgl7Rb5oy5WdGhL5ATEXPzzs3z4vDbjG/6EYPV
        1MLz2hdcSIuG/ijl8Y57rDU/Ssoqi7NZ2+z5Db73+H4FGnpuwuttPsXt/Vr5u4CH
        bOttlpzUMQcBzNPTZX14zczuvHy2QOA8DjaS3LTH5MhTbGN6j/y7LnAXE/Cm8svS
        PcHluHFILsPc8SLaZbroLZurhI38SsrRH5EZz2xMW4fQ9KGguP14VEDN8o0/8nRq
        fIZgV+QHgWyVnw==
X-ME-Sender: <xms:-YxlYRQvTI-9rvIPMV5VPjS_vpGqsbRgmznD1-SJex4syNiVX_-NzQ>
    <xme:-YxlYawfInzKFCgLEsGU6Zjw0xd1HSBlgTeEM0MDOR1VWDS18kJW7q4UJDfECPESb
    jJ78G0WJccAJNM>
X-ME-Received: <xmr:-YxlYW1c7NQu0BUvD6yUexdYBP5OsOgM6Dwpzj7luBhq5qHTAYNVXcBcNNUKIbjRqu_UsWeZy-okM6wIdUkMgWLCDJUY9RQtEvo-l4bO5dL9fQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrvddtkedgiedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecuvehluhhsthgvrhfuihiivgepudenucfr
    rghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:-YxlYZC0DAPH_XQP-G4chBKKVTlzPhGwBvrFGfnhDlpXVWZAnEJgwQ>
    <xmx:-YxlYagFpkfcGEQQK7RfdpkMUFoqLTXV6uhOYTmK8JQOHyJJeXp-yA>
    <xmx:-YxlYdr0ixK4cl61uF-KBStty9JvMgCDakvr7MY7yil_BmTH2LbGvA>
    <xmx:-YxlYSewMLTmjn3hEQR5SSzse5Un_MDf2cXp_-MvO5fB6ra65lAWAA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 12 Oct 2021 09:26:16 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     mkubecek@suse.cz, popadrian1996@gmail.com, andrew@lunn.ch,
        mlxsw@nvidia.com, moshe@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH ethtool-next 12/14] sff-8636: Request specific pages for parsing in netlink path
Date:   Tue, 12 Oct 2021 16:25:23 +0300
Message-Id: <20211012132525.457323-13-idosch@idosch.org>
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
EEPROM pages from the kernel. The presence of optional pages is
advertised via various bits in the EEPROM contents.

Currently, for SFF-8636, the Lower Memory, Page 00h and the optional
Page 03h are requested by the netlink code (i.e.,
netlink/module-eeprom.c) and passed to the SFF-8636 code (i.e., qsfp.c)
as two arguments for parsing.

This is problematic for several reasons. First, this approach is not
very scaleable as SFF-8636 supports a lot of optional pages. Passing
them as separate arguments to the SFF-8636 code is not going to work.

Second, the knowledge of which optional pages are available is
encapsulated in the SFF-8636 parsing code. As such, the common netlink
code has no business of fetching optional pages that might be invalid.

Instead, pass the command context to the SFF-8636 parsing function and
allow it to fetch only valid pages via the 'MODULE_EEPROM_GET' netlink
message.

Tested by making sure that the output of 'ethtool -m' does not change
before and after the patch.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 internal.h              |  3 +--
 netlink/module-eeprom.c |  3 +--
 qsfp.c                  | 60 ++++++++++++++++++++++++++++++++---------
 3 files changed, 49 insertions(+), 17 deletions(-)

diff --git a/internal.h b/internal.h
index a77efd385698..2407d3c223fa 100644
--- a/internal.h
+++ b/internal.h
@@ -392,8 +392,7 @@ void sff8472_show_all(const __u8 *id);
 
 /* QSFP Optics diagnostics */
 void sff8636_show_all_ioctl(const __u8 *id, __u32 eeprom_len);
-void sff8636_show_all_nl(const struct ethtool_module_eeprom *page_zero,
-			 const struct ethtool_module_eeprom *page_three);
+int sff8636_show_all_nl(struct cmd_context *ctx);
 
 /* FUJITSU Extended Socket network device */
 int fjes_dump_regs(struct ethtool_drvinfo *info, struct ethtool_regs *regs);
diff --git a/netlink/module-eeprom.c b/netlink/module-eeprom.c
index a8e2662e0b8c..f04f8e134223 100644
--- a/netlink/module-eeprom.c
+++ b/netlink/module-eeprom.c
@@ -316,7 +316,6 @@ static int decoder_prefetch(struct nl_context *nlctx)
 
 static void decoder_print(struct cmd_context *ctx)
 {
-	struct ethtool_module_eeprom *page_three = cache_get(3, 0, ETH_I2C_ADDRESS_LOW);
 	struct ethtool_module_eeprom *page_zero = cache_get(0, 0, ETH_I2C_ADDRESS_LOW);
 	u8 module_id = page_zero->data[SFF8636_ID_OFFSET];
 
@@ -327,7 +326,7 @@ static void decoder_print(struct cmd_context *ctx)
 	case SFF8024_ID_QSFP:
 	case SFF8024_ID_QSFP28:
 	case SFF8024_ID_QSFP_PLUS:
-		sff8636_show_all_nl(page_zero, page_three);
+		sff8636_show_all_nl(ctx);
 		break;
 	case SFF8024_ID_QSFP_DD:
 	case SFF8024_ID_DSFP:
diff --git a/qsfp.c b/qsfp.c
index 4aa49351e6b7..e7c2f51cd9c6 100644
--- a/qsfp.c
+++ b/qsfp.c
@@ -55,10 +55,12 @@
  **/
 #include <stdio.h>
 #include <math.h>
+#include <errno.h>
 #include "internal.h"
 #include "sff-common.h"
 #include "qsfp.h"
 #include "cmis.h"
+#include "netlink/extapi.h"
 
 struct sff8636_memory_map {
 	const __u8 *lower_memory;
@@ -68,6 +70,7 @@ struct sff8636_memory_map {
 };
 
 #define SFF8636_PAGE_SIZE	0x80
+#define SFF8636_I2C_ADDRESS	0x50
 
 #define MAX_DESC_SIZE	42
 
@@ -947,36 +950,67 @@ void sff8636_show_all_ioctl(const __u8 *id, __u32 eeprom_len)
 	sff8636_show_all_common(&map);
 }
 
-static void
-sff8636_memory_map_init_pages(struct sff8636_memory_map *map,
-			      const struct ethtool_module_eeprom *page_zero,
-			      const struct ethtool_module_eeprom *page_three)
+static void sff8636_request_init(struct ethtool_module_eeprom *request, u8 page,
+				 u32 offset)
+{
+	request->offset = offset;
+	request->length = SFF8636_PAGE_SIZE;
+	request->page = page;
+	request->bank = 0;
+	request->i2c_address = SFF8636_I2C_ADDRESS;
+	request->data = NULL;
+}
+
+static int
+sff8636_memory_map_init_pages(struct cmd_context *ctx,
+			      struct sff8636_memory_map *map)
 {
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
+	sff8636_request_init(&request, 0x0, 0);
+	ret = nl_get_eeprom_page(ctx, &request);
+	if (ret < 0)
+		return ret;
+	map->lower_memory = request.data;
+
+	sff8636_request_init(&request, 0x0, SFF8636_PAGE_SIZE);
+	ret = nl_get_eeprom_page(ctx, &request);
+	if (ret < 0)
+		return ret;
+	map->page_00h = request.data - SFF8636_PAGE_SIZE;
 
 	/* Page 03h is only present when the module memory model is paged and
 	 * not flat.
 	 */
 	if (map->lower_memory[SFF8636_STATUS_2_OFFSET] &
 	    SFF8636_STATUS_PAGE_3_PRESENT)
-		return;
+		return 0;
 
-	map->page_03h = page_three->data - SFF8636_PAGE_SIZE;
+	sff8636_request_init(&request, 0x3, SFF8636_PAGE_SIZE);
+	ret = nl_get_eeprom_page(ctx, &request);
+	if (ret < 0)
+		return ret;
+	map->page_03h = request.data - SFF8636_PAGE_SIZE;
+
+	return 0;
 }
 
-void sff8636_show_all_nl(const struct ethtool_module_eeprom *page_zero,
-			 const struct ethtool_module_eeprom *page_three)
+int sff8636_show_all_nl(struct cmd_context *ctx)
 {
 	struct sff8636_memory_map map = {};
+	int ret;
 
-	sff8636_memory_map_init_pages(&map, page_zero, page_three);
+	ret = sff8636_memory_map_init_pages(ctx, &map);
+	if (ret < 0)
+		return ret;
 	sff8636_show_all_common(&map);
+
+	return 0;
 }
-- 
2.31.1

