Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8462542A5A1
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 15:26:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237046AbhJLN2U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 09:28:20 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:40983 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236830AbhJLN2G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Oct 2021 09:28:06 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 366C15C01B6;
        Tue, 12 Oct 2021 09:26:05 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Tue, 12 Oct 2021 09:26:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=mB0u3E5gEnD8O8Pked8RUKNevJajqYBzbZFmnWbbeM8=; b=BiIYS20H
        a9/KpyjyfIPpz/zhPeDsvEXlXJ178V/hib0F/s7Wz7E+W1hEeZqzDFXTttLr2c2g
        uoAfFhn7szdR2TqqoAQXJGcWUjeQi5VI41dtPHOIoG7jBnpS0cg8A41VGc9ic2sb
        U8i8ddDJu0hNFocwvVCRqWcOrM/Nmcn0xF1qmZWlWTGPFTZVtpFi3u2zp5ei3x33
        EkHSyhzUJRR1A/h747tuzr8sWBe0uIqu6+4enVGGvbUJtoc2hQPt+aanVYV+NwuF
        FnwS7gd8iY4YVozZ+cUgwv2HPRKtrATVzaQc2alGfzY2GLoZWNq2yluzGTIhuSFo
        5waZrt+8CWGzNQ==
X-ME-Sender: <xms:7YxlYf1NNu5aPPHp9_vkgNMeaZ8kPstVk5kpSa70awggYy5MGL-UGQ>
    <xme:7YxlYeGeYsrwX6JqlRBKgRSklp3_LTfE1wz5D1jB9EIuYpDkYtwtP0a8xOM2cwouL
    aCTmjyVtp0SXPg>
X-ME-Received: <xmr:7YxlYf4jiFOmLXZS28fdiqp6COe1kN166nEkekve69Bhtoxm8tQCiOGs9qKj98i7wGR_rXEGh_yM7m50nu67bb9mcSsXpkQRKSI7OXKh7RNfYQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrvddtkedgiedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecuvehluhhsthgvrhfuihiivgeptdenucfr
    rghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:7YxlYU3zWJjwJawx19m7bPBiBaeC_WyfuX6-5rJ0hU8VOzsRCKUE8A>
    <xmx:7YxlYSGKthVoHj6-904ZibQnNhgCuLkcZx2EADM7mpWlW8PxkKiASQ>
    <xmx:7YxlYV8SJbSrBW9WEWmG_YJ3NzeH_bIW6bwwlfInFEk_e2RP3zRhYg>
    <xmx:7YxlYeiy3-FN4RTXOsgoJ66s14-C3wDwtCQKMqZGTYF1YQykAW_Lmg>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 12 Oct 2021 09:26:03 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     mkubecek@suse.cz, popadrian1996@gmail.com, andrew@lunn.ch,
        mlxsw@nvidia.com, moshe@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH ethtool-next 06/14] sff-8636: Initialize SFF-8636 memory map
Date:   Tue, 12 Oct 2021 16:25:17 +0300
Message-Id: <20211012132525.457323-7-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211012132525.457323-1-idosch@idosch.org>
References: <20211012132525.457323-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

The SFF-8636 memory map [1] consists of Lower Memory and Upper Memory.

The content of the Lower Memory is fixed and can be addressed using an
offset between 0 and 127 (inclusive).

The Upper Memory is variable and optional and can be addressed by
specifying a page number and an offset between 128 and 255 (inclusive).

Create a structure describing this memory map and initialize it with
pointers to available pages.

In the IOCTL path, the structure holds pointers to regions of the
continuous buffer passed to user space via the 'ETHTOOL_GMODULEEEPROM'
command.

In the netlink path, the structure holds pointers to individual pages
passed to user space via the 'MODULE_EEPROM_GET' message.

This structure will later allow us to consolidate the IOCTL and netlink
parsing code paths and also easily support additional EEPROM pages, when
needed.

[1] SFF-8636 Rev. 2.10a, pag. 30, section 6.1, Figure 6-1

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 qsfp.c | 65 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 65 insertions(+)

diff --git a/qsfp.c b/qsfp.c
index dc6407d3ef6f..80000d40f6e8 100644
--- a/qsfp.c
+++ b/qsfp.c
@@ -60,6 +60,15 @@
 #include "qsfp.h"
 #include "cmis.h"
 
+struct sff8636_memory_map {
+	const __u8 *lower_memory;
+	const __u8 *upper_memory[4];
+#define page_00h upper_memory[0x0]
+#define page_03h upper_memory[0x3]
+};
+
+#define SFF8636_PAGE_SIZE	0x80
+
 #define MAX_DESC_SIZE	42
 
 static struct sff8636_aw_flags {
@@ -853,13 +862,40 @@ static void sff8636_show_page_zero(const __u8 *id)
 
 }
 
+static void sff8636_memory_map_init_buf(struct sff8636_memory_map *map,
+					const __u8 *id, __u32 eeprom_len)
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
+	/* Page 03h is only present when the module memory model is paged and
+	 * not flat and when we got a big enough buffer from the kernel.
+	 */
+	if (map->lower_memory[SFF8636_STATUS_2_OFFSET] &
+	    SFF8636_STATUS_PAGE_3_PRESENT ||
+	    eeprom_len != ETH_MODULE_SFF_8636_MAX_LEN)
+		return;
+
+	map->page_03h = id + 3 * SFF8636_PAGE_SIZE;
+}
+
 void sff8636_show_all_ioctl(const __u8 *id, __u32 eeprom_len)
 {
+	struct sff8636_memory_map map = {};
+
 	if (id[SFF8636_ID_OFFSET] == SFF8024_ID_QSFP_DD) {
 		cmis_show_all_ioctl(id);
 		return;
 	}
 
+	sff8636_memory_map_init_buf(&map, id, eeprom_len);
+
 	sff8636_show_identifier(id);
 	switch (id[SFF8636_ID_OFFSET]) {
 	case SFF8024_ID_QSFP:
@@ -871,9 +907,38 @@ void sff8636_show_all_ioctl(const __u8 *id, __u32 eeprom_len)
 	}
 }
 
+static void
+sff8636_memory_map_init_pages(struct sff8636_memory_map *map,
+			      const struct ethtool_module_eeprom *page_zero,
+			      const struct ethtool_module_eeprom *page_three)
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
+	/* Page 03h is only present when the module memory model is paged and
+	 * not flat.
+	 */
+	if (map->lower_memory[SFF8636_STATUS_2_OFFSET] &
+	    SFF8636_STATUS_PAGE_3_PRESENT)
+		return;
+
+	map->page_03h = page_three->data - SFF8636_PAGE_SIZE;
+}
+
 void sff8636_show_all_nl(const struct ethtool_module_eeprom *page_zero,
 			 const struct ethtool_module_eeprom *page_three)
 {
+	struct sff8636_memory_map map = {};
+
+	sff8636_memory_map_init_pages(&map, page_zero, page_three);
+
 	sff8636_show_identifier(page_zero->data);
 	sff8636_show_page_zero(page_zero->data);
 	if (page_three)
-- 
2.31.1

