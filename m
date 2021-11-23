Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A226C45AA35
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 18:41:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239317AbhKWRok (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 12:44:40 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:44955 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239305AbhKWRoj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Nov 2021 12:44:39 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 408B45C00CB;
        Tue, 23 Nov 2021 12:41:31 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Tue, 23 Nov 2021 12:41:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=UisYoqP0W0o2AFCQ0Ss1mNbGs7BbEm3yHju4sKD7Htc=; b=ky7qvPbX
        qlaFxGtRxevX5MDf+CzyUnv8BYp69nXA2Gok6wHDGafrgvcysY+YGWiFudNLODAb
        IIPsN8CqWF6tyjDehL2EFiNg5/hVAKOKX2WsLXQIQn2Zi9OIeDzcKMYbLotTpHw9
        KM+4WjFGZtht5GDGg4Q4lPtc+6OpZZx0VC5wndlKmv6hgodphYrjZ0RJXBNu8HEq
        EI54Kd+m1YMbTsLrgNy3o+O2kogFa8JbrOijDy/pJXDjz6Dn+wCp+KeDRSvbM79A
        mFuOln8fmKAodWFMkcad+thE5I/T3zwvbfwSXTjxrpUsbmlTE0VwRUScE5yuyjWV
        t/NgALIPcis7nA==
X-ME-Sender: <xms:yyedYejWWqiFMSC5w2UwsDkSXT0dLF0SANCX9Jaou1N1og2k75o_ag>
    <xme:yyedYfAMmOGdnUxmXipdKvdehsTarhZiy_XeaKR1J3rurpa7_CtP5YVyzVtVDn9-m
    v3OmH1pUcy0s9c>
X-ME-Received: <xmr:yyedYWF6_a1N_gJDH2VXdw_afSl5H3_CVPmnYvxUCkFOVk3u5X3pka54XYrIr26H_CDj2x3UcJ_m5_QvUtaLZ7YGTDRiXwkUSVNEfO1bWhwa_A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvuddrgeeigddutdegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecuvehluhhsthgvrhfuihiivgepudenucfr
    rghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:yyedYXStLwV8i8qHsfy2E_zx2AfKo7skUwE0Fm-NMUSwqbzeaFfZPw>
    <xmx:yyedYbzWVsa4q3HLSyp5X8Op4jYmGvHgwp_pl2NHarr4AZAQmR1ttg>
    <xmx:yyedYV7yHPbggrWT-XvHaMUl6kWUbyIAqqAMkfX2TnAZOj2cVL_Hwg>
    <xmx:yyedYdurLRYylw5ebHAjFp2JYAv4mACK8AGbMM1YFuh4PLuNSalgSQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 23 Nov 2021 12:41:29 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     mkubecek@suse.cz, popadrian1996@gmail.com, andrew@lunn.ch,
        mlxsw@nvidia.com, moshe@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH ethtool-next 4/8] cmis: Initialize Banked Page 11h in memory map
Date:   Tue, 23 Nov 2021 19:40:58 +0200
Message-Id: <20211123174102.3242294-5-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211123174102.3242294-1-idosch@idosch.org>
References: <20211123174102.3242294-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Banked Page 11h stores, among other things, lane-specific flags and
monitors that are going to be parsed and displayed in subsequent
patches.

Request it via the 'MODULE_EEPROM_GET' netlink message and initialize it
in the memory map.

Only initialize it in supported Banks.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 cmis.c | 49 +++++++++++++++++++++++++++++++++++++++++++++++--
 cmis.h |  7 +++++++
 2 files changed, 54 insertions(+), 2 deletions(-)

diff --git a/cmis.c b/cmis.c
index 55b9d1b959cd..83ced4d253ae 100644
--- a/cmis.c
+++ b/cmis.c
@@ -15,9 +15,17 @@
 #include "cmis.h"
 #include "netlink/extapi.h"
 
+/* The maximum number of supported Banks. Relevant documents:
+ * [1] CMIS Rev. 5, page. 128, section 8.4.4, Table 8-40
+ */
+#define CMIS_MAX_BANKS	4
+
+/* We are not parsing further than Page 11h. */
+#define CMIS_MAX_PAGES	18
+
 struct cmis_memory_map {
 	const __u8 *lower_memory;
-	const __u8 *upper_memory[1][3];	/* Bank, Page */
+	const __u8 *upper_memory[CMIS_MAX_BANKS][CMIS_MAX_PAGES];
 #define page_00h upper_memory[0x0][0x0]
 #define page_01h upper_memory[0x0][0x1]
 #define page_02h upper_memory[0x0][0x2]
@@ -399,12 +407,33 @@ static void cmis_request_init(struct ethtool_module_eeprom *request, u8 bank,
 	request->data = NULL;
 }
 
+static int cmis_num_banks_get(const struct cmis_memory_map *map,
+			      int *p_num_banks)
+{
+	switch (map->page_01h[CMIS_PAGES_ADVER_OFFSET] &
+		CMIS_BANKS_SUPPORTED_MASK) {
+	case CMIS_BANK_0_SUPPORTED:
+		*p_num_banks = 1;
+		break;
+	case CMIS_BANK_0_1_SUPPORTED:
+		*p_num_banks = 2;
+		break;
+	case CMIS_BANK_0_3_SUPPORTED:
+		*p_num_banks = 4;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 static int
 cmis_memory_map_init_pages(struct cmd_context *ctx,
 			   struct cmis_memory_map *map)
 {
 	struct ethtool_module_eeprom request;
-	int ret;
+	int num_banks, i, ret;
 
 	/* Lower Memory and Page 00h are always present.
 	 *
@@ -443,6 +472,22 @@ cmis_memory_map_init_pages(struct cmd_context *ctx,
 		return ret;
 	map->page_02h = request.data - CMIS_PAGE_SIZE;
 
+	/* Bank 0 of Page 11h provides lane-specific registers for the first 8
+	 * lanes, and each additional Banks provides support for an additional
+	 * 8 lanes. Only initialize supported Banks.
+	 */
+	ret = cmis_num_banks_get(map, &num_banks);
+	if (ret < 0)
+		return ret;
+
+	for (i = 0; i < num_banks; i++) {
+		cmis_request_init(&request, i, 0x11, CMIS_PAGE_SIZE);
+		ret = nl_get_eeprom_page(ctx, &request);
+		if (ret < 0)
+			return ret;
+		map->upper_memory[i][0x11] = request.data - CMIS_PAGE_SIZE;
+	}
+
 	return 0;
 }
 
diff --git a/cmis.h b/cmis.h
index 911491dc5c8f..8d90a04756ad 100644
--- a/cmis.h
+++ b/cmis.h
@@ -114,6 +114,13 @@
 #define CMIS_WAVELENGTH_TOL_MSB			0x8C
 #define CMIS_WAVELENGTH_TOL_LSB			0x8D
 
+/* Supported Pages Advertising (Page 1) */
+#define CMIS_PAGES_ADVER_OFFSET			0x8E
+#define CMIS_BANKS_SUPPORTED_MASK		0x03
+#define CMIS_BANK_0_SUPPORTED			0x00
+#define CMIS_BANK_0_1_SUPPORTED			0x01
+#define CMIS_BANK_0_3_SUPPORTED			0x02
+
 /* Signal integrity controls */
 #define CMIS_SIG_INTEG_TX_OFFSET		0xA1
 #define CMIS_SIG_INTEG_RX_OFFSET		0xA2
-- 
2.31.1

