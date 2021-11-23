Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CA6245AA34
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 18:41:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239301AbhKWRoi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 12:44:38 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:50905 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233491AbhKWRoi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Nov 2021 12:44:38 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 7CE4B5C00F4;
        Tue, 23 Nov 2021 12:41:29 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Tue, 23 Nov 2021 12:41:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=zHGroaHsxmqyA4dOOzMmE/qfyjyRVRpxFoUila5riVk=; b=JeV4grM0
        gnIL6UJg+8rsszIukHWfQDISAyVj5CFLX3uNfsGGCAterHUdpKIrgKGb7OIKHQ7R
        wV8Niw1pkdiJo6eSUGiK+gfITpIAM2svh8C41MiOJs1qr0GA0BPzldPWEIX7jW+T
        wUUHXjfqR8E7WiWDXekDwy3DPcaJDY54WEfeRHVdsDFCa2bvazzs5DqXotPHIZLI
        a3ilIZtB9I+N8nfKO/1wOzlyzq/wbrwcyoB55vLbJ0/w6uxb8e3TEY3Omrmw9D6r
        LbXKmmjjOSk0zoQfSyn3MA3TYapBz+LVX4CLTsEzOMnQDh/5exIKUFSBNTnWzeWv
        ydmu/gJPRDKbdg==
X-ME-Sender: <xms:ySedYaO4Oli3-4ASg3fchTw-_aqqwYfB9a021HKJVI_TNwjYF73kvw>
    <xme:ySedYY8rHSsm8SHnuLrHrQFZK0558wrXELuAXJaTaHwyBCqVQkl6DMf8cmicVuzgd
    M5fQZ3rHo3Ufbs>
X-ME-Received: <xmr:ySedYRRewrEEB2hSAO6jVqRdZEQn8oTK_JBzTr8YLqN44TEbBUxYa8tybG8wOdTOqn7u_RKxdiMq8WHhSbGYG2XF_GNkT6Xhmx0xbH8QcHq7Fw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvuddrgeeigddutdegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecuvehluhhsthgvrhfuihiivgeptdenucfr
    rghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:ySedYatym6d0wuom9LpdmUf_3K5rby18nVsnCkblkF9YRDBhqOLyeA>
    <xmx:ySedYSc5HUJFdb1Tw9m-2or-IHyAmf2kv7rUMP_o6ym3IlJUuIfCgQ>
    <xmx:ySedYe37pGqOTSveIITwEPAClZQ5SnlsLgPxniNPCtPVDYO5P-HrXg>
    <xmx:ySedYR6xBr_0y0UFaTLvTuGYns-ZTktKs8vckQWvG_SjxVGmm0H98g>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 23 Nov 2021 12:41:27 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     mkubecek@suse.cz, popadrian1996@gmail.com, andrew@lunn.ch,
        mlxsw@nvidia.com, moshe@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH ethtool-next 3/8] cmis: Initialize Page 02h in memory map
Date:   Tue, 23 Nov 2021 19:40:57 +0200
Message-Id: <20211123174102.3242294-4-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211123174102.3242294-1-idosch@idosch.org>
References: <20211123174102.3242294-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Page 02h stores module and lane thresholds that are going to be parsed
and displayed in subsequent patches.

Request it via the 'MODULE_EEPROM_GET' netlink message and initialize it
in the memory map.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 cmis.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/cmis.c b/cmis.c
index 4798fd4c7d68..55b9d1b959cd 100644
--- a/cmis.c
+++ b/cmis.c
@@ -17,9 +17,10 @@
 
 struct cmis_memory_map {
 	const __u8 *lower_memory;
-	const __u8 *upper_memory[1][2];	/* Bank, Page */
+	const __u8 *upper_memory[1][3];	/* Bank, Page */
 #define page_00h upper_memory[0x0][0x0]
 #define page_01h upper_memory[0x0][0x1]
+#define page_02h upper_memory[0x0][0x2]
 };
 
 #define CMIS_PAGE_SIZE		0x80
@@ -423,8 +424,8 @@ cmis_memory_map_init_pages(struct cmd_context *ctx,
 		return ret;
 	map->page_00h = request.data - CMIS_PAGE_SIZE;
 
-	/* Page 01h is only present when the module memory model is paged and
-	 * not flat.
+	/* Pages 01h and 02h are only present when the module memory model is
+	 * paged and not flat.
 	 */
 	if (map->lower_memory[CMIS_MEMORY_MODEL_OFFSET] &
 	    CMIS_MEMORY_MODEL_MASK)
@@ -436,6 +437,12 @@ cmis_memory_map_init_pages(struct cmd_context *ctx,
 		return ret;
 	map->page_01h = request.data - CMIS_PAGE_SIZE;
 
+	cmis_request_init(&request, 0, 0x2, CMIS_PAGE_SIZE);
+	ret = nl_get_eeprom_page(ctx, &request);
+	if (ret < 0)
+		return ret;
+	map->page_02h = request.data - CMIS_PAGE_SIZE;
+
 	return 0;
 }
 
-- 
2.31.1

