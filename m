Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 047CF42A59D
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 15:26:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236768AbhJLN16 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 09:27:58 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:58323 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236368AbhJLN14 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Oct 2021 09:27:56 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 2204C5C0109;
        Tue, 12 Oct 2021 09:25:55 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Tue, 12 Oct 2021 09:25:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=Mg3XhgmBtyvH1+wsHpsVdbZAeeK0upOND1RQD0QrRMw=; b=gv095P/n
        SIZs1Qk+0uwRAX1QTb1E4mtk/oHK5QyVLV6sr14SBcJdPPMK5YyGq5Xf2lO3Yvpm
        5U91/wOq3pjI4YBrcfEL4BklrhiqBA3gq1/ZA8umepNg4GMsKYI00Z3BVtxSQtRG
        26bWzVJYer1XoXjwmCAluQJjxJWj+tasCjUOXzkd34NMLGiWkAz18LXcUw/Mz5G+
        J8+sd3ojX18NdzMKpMqPg/yAUnQkWzs/NuNNXm3lmQxascO1nBoyiZr7zxWUsruX
        WOywWSaW2DLPUQ9/UllCuDaCJAd9sw+qZtDr/uVkSqkKCKMt+Y4kPhrmNwpCqM8O
        +/gcuPSwclHXRg==
X-ME-Sender: <xms:44xlYdPV1Rg2goLNTHZqjsKPZjBQTsdU98LvQVj6RMZ7ORjGem8uZw>
    <xme:44xlYf-4oRFLH8nmrHjhCmYdf9koOBYU8dSBJh3Rjvr1HB-KdBJGyKjjWkcx4a8mW
    NyExAb9hIjgKmA>
X-ME-Received: <xmr:44xlYcQ2hXIjYmu8BOwJC-waIF_fmw6zbnm1-IZVW4DAshSnNlglOStFZlXZ8wjMmOLfJUsVWlQ3pr5Uk9ke6DrhxAQsBBrUgV7iOL8x5lfv7Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrvddtkedgiedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecuvehluhhsthgvrhfuihiivgeptdenucfr
    rghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:44xlYZvVfyvI_ihfC2ys-Ri-EKfIe7Ohq13G1mhN3ByOlkDR8ImFOQ>
    <xmx:44xlYVf5fvBIHiTsND8FQC8_e7U771hXtfsMoSVCdD6z76uzPQYQfA>
    <xmx:44xlYV3wLkngXe_xpgNdTKvIjypcD8BewTlXwo7KkhIS-blChyC24A>
    <xmx:44xlYc4q4dpO7dnx5Xfd7Ko37YHG1Lela-Wn477lhJkUC34D05XGVA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 12 Oct 2021 09:25:52 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     mkubecek@suse.cz, popadrian1996@gmail.com, andrew@lunn.ch,
        mlxsw@nvidia.com, moshe@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH ethtool-next 02/14] cmis: Initialize CMIS memory map
Date:   Tue, 12 Oct 2021 16:25:13 +0300
Message-Id: <20211012132525.457323-3-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211012132525.457323-1-idosch@idosch.org>
References: <20211012132525.457323-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

The CMIS memory map [1] consists of Lower Memory and Upper Memory.

The content of the Lower Memory is fixed and can be addressed using an
offset between 0 and 127 (inclusive).

The Upper Memory is variable and optional and can be addressed by
specifying a bank number, a page number and an offset between 128 and
255 (inclusive).

Create a structure describing this memory map and initialize it with
pointers to available pages.

In the IOCTL path, the structure holds pointers to regions of the
continuous buffer passed to user space via the 'ETHTOOL_GMODULEEEPROM'
command.

In the netlink path, the structure holds pointers to individual pages
passed to user space via the 'MODULE_EEPROM_GET' message.

This structure will later allow us to consolidate the IOCTL and netlink
parsing code paths and also easily support additional EEPROM pages.

[1] CMIS Rev. 5, pag. 97, section 8.1.1, Figure 8-1

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 cmis.c | 63 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 cmis.h |  2 ++
 2 files changed, 65 insertions(+)

diff --git a/cmis.c b/cmis.c
index 68c5b2d3277b..8a6788416a00 100644
--- a/cmis.c
+++ b/cmis.c
@@ -13,6 +13,15 @@
 #include "sff-common.h"
 #include "cmis.h"
 
+struct cmis_memory_map {
+	const __u8 *lower_memory;
+	const __u8 *upper_memory[1][2];	/* Bank, Page */
+#define page_00h upper_memory[0x0][0x0]
+#define page_01h upper_memory[0x0][0x1]
+};
+
+#define CMIS_PAGE_SIZE		0x80
+
 static void cmis_show_identifier(const __u8 *id)
 {
 	sff8024_show_identifier(id, CMIS_ID_OFFSET);
@@ -326,8 +335,34 @@ static void cmis_show_vendor_info(const __u8 *id)
 			       "CLEI code");
 }
 
+static void cmis_memory_map_init_buf(struct cmis_memory_map *map,
+				     const __u8 *id)
+{
+	/* Lower Memory and Page 00h are always present.
+	 *
+	 * Offset into Upper Memory is between page size and twice the page
+	 * size. Therefore, set the base address of each page to base address
+	 * plus page size multiplied by the page number.
+	 */
+	map->lower_memory = id;
+	map->page_00h = id;
+
+	/* Page 01h is only present when the module memory model is paged and
+	 * not flat.
+	 */
+	if (map->lower_memory[CMIS_MEMORY_MODEL_OFFSET] &
+	    CMIS_MEMORY_MODEL_MASK)
+		return;
+
+	map->page_01h = id + CMIS_PAGE_SIZE;
+}
+
 void cmis_show_all_ioctl(const __u8 *id)
 {
+	struct cmis_memory_map map = {};
+
+	cmis_memory_map_init_buf(&map, id);
+
 	cmis_show_identifier(id);
 	cmis_show_power_info(id);
 	cmis_show_connector(id);
@@ -340,10 +375,38 @@ void cmis_show_all_ioctl(const __u8 *id)
 	cmis_show_rev_compliance(id);
 }
 
+static void
+cmis_memory_map_init_pages(struct cmis_memory_map *map,
+			   const struct ethtool_module_eeprom *page_zero,
+			   const struct ethtool_module_eeprom *page_one)
+{
+	/* Lower Memory and Page 00h are always present.
+	 *
+	 * Offset into Upper Memory is between page size and twice the page
+	 * size. Therefore, set the base address of each page to its base
+	 * address minus page size. For Page 00h, this is the address of the
+	 * Lower Memory.
+	 */
+	map->lower_memory = page_zero->data;
+	map->page_00h = page_zero->data;
+
+	/* Page 01h is only present when the module memory model is paged and
+	 * not flat.
+	 */
+	if (map->lower_memory[CMIS_MEMORY_MODEL_OFFSET] &
+	    CMIS_MEMORY_MODEL_MASK)
+		return;
+
+	map->page_01h = page_one->data - CMIS_PAGE_SIZE;
+}
+
 void cmis_show_all_nl(const struct ethtool_module_eeprom *page_zero,
 		      const struct ethtool_module_eeprom *page_one)
 {
 	const __u8 *page_zero_data = page_zero->data;
+	struct cmis_memory_map map = {};
+
+	cmis_memory_map_init_pages(&map, page_zero, page_one);
 
 	cmis_show_identifier(page_zero_data);
 	cmis_show_power_info(page_zero_data);
diff --git a/cmis.h b/cmis.h
index 734b90f4ddb4..53cbb5f57127 100644
--- a/cmis.h
+++ b/cmis.h
@@ -4,6 +4,8 @@
 /* Identifier and revision compliance (Page 0) */
 #define CMIS_ID_OFFSET				0x00
 #define CMIS_REV_COMPLIANCE_OFFSET		0x01
+#define CMIS_MEMORY_MODEL_OFFSET		0x02
+#define CMIS_MEMORY_MODEL_MASK			0x80
 
 #define CMIS_MODULE_TYPE_OFFSET			0x55
 #define CMIS_MT_MMF				0x01
-- 
2.31.1

