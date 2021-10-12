Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAD8942A5A3
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 15:26:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236772AbhJLN2W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 09:28:22 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:56579 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236881AbhJLN2K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Oct 2021 09:28:10 -0400
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id 98F345C01A5;
        Tue, 12 Oct 2021 09:26:07 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Tue, 12 Oct 2021 09:26:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=EiX8NZUYdSfgTgwZXMw4YfZ65jKrxBEgRWngrx0GuNk=; b=j3zh1y8D
        N1JX22/7vY+FxtX4b0owQw+ykPlsPS5cliRN80K8VWqVvoB9xZ7p+PfIKgakRY56
        upX/MlZQjutAfMQTUhr/KpPV/As7on24oS3OXvvKWIJe6PmivcoeySusrviXAxqO
        Uo0Wmz0C782F1GVHG6KKwQWvmSYBL98NUySbrtTc7XzzB48DM3c2wD0wWelk1ask
        k69fTzonY4y5PAoiyzrDUDE4v2m62N/xs73c6EDzUE8I+N3RaP5Ysudt7tN56r1H
        6L8LiDwVoKHOLrqpmIwAHSuPf1sUBAgkZVtXvWlejEWkrbEG5xVkSZIu59q6q0D+
        KXOHsHDjc+TECA==
X-ME-Sender: <xms:74xlYS6TkO59A8NFDpAghtCrAHz6UEKUvQYGOU2i_8naw37jBqzccA>
    <xme:74xlYb4aKFKmXVTE25KFOmiJFvKhETKyGWmkfYVw-wiZDrKdULXMBn_coh8La5CC9
    OMETU-2ZmpWuyQ>
X-ME-Received: <xmr:74xlYRdvomU6po6Z0PFJxSOnjgqWZXT3jV6Y-NzS7Uelsxp-SPGC7Jdbje7FXgP26ByvAlIJJAbFhEe9FCny6yeF9KolSYw8pGrhFoL0TUAm4w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrvddtkedgieduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecuvehluhhsthgvrhfuihiivgeptdenucfr
    rghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:74xlYfJiD9bLFLtfGcJxE3BUNW_SeVTtq6XaCjH9oRG-BrwqrYOklQ>
    <xmx:74xlYWJRzkbZC_Vbx-LAZihP811_wjgrOs7Fu3tCt8xfDX3SVZ8-Bw>
    <xmx:74xlYQxPNQYJtsXzS-1SBgaH_63Ps0WqQaEerr5iatFfpTW0ynCnFg>
    <xmx:74xlYbFiZJsWN8Z6PgHTWaiUkmi_f6b4XYqZMlpgIIwTWO_5t_Twxw>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 12 Oct 2021 09:26:05 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     mkubecek@suse.cz, popadrian1996@gmail.com, andrew@lunn.ch,
        mlxsw@nvidia.com, moshe@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH ethtool-next 07/14] sff-8636: Use memory map during parsing
Date:   Tue, 12 Oct 2021 16:25:18 +0300
Message-Id: <20211012132525.457323-8-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211012132525.457323-1-idosch@idosch.org>
References: <20211012132525.457323-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Instead of passing one large buffer to the individual parsing functions,
use the memory map structure from the previous patch.

This has the added benefit of checking which optional pages are actually
available and it will also allow us to consolidate the IOCTL and netlink
parsing code paths.

Tested by making sure that there are no differences in output in both
the IOCTL and netlink paths before and after the patch.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 qsfp.c | 368 +++++++++++++++++++++++++++++++--------------------------
 1 file changed, 201 insertions(+), 167 deletions(-)

diff --git a/qsfp.c b/qsfp.c
index 80000d40f6e8..354b3b1ce9ff 100644
--- a/qsfp.c
+++ b/qsfp.c
@@ -205,20 +205,21 @@ static struct sff8636_aw_flags {
 	{ NULL, 0, 0 },
 };
 
-static void sff8636_show_identifier(const __u8 *id)
+static void sff8636_show_identifier(const struct sff8636_memory_map *map)
 {
-	sff8024_show_identifier(id, SFF8636_ID_OFFSET);
+	sff8024_show_identifier(map->lower_memory, SFF8636_ID_OFFSET);
 }
 
-static void sff8636_show_ext_identifier(const __u8 *id)
+static void sff8636_show_ext_identifier(const struct sff8636_memory_map *map)
 {
 	printf("\t%-41s : 0x%02x\n", "Extended identifier",
-			id[SFF8636_EXT_ID_OFFSET]);
+	       map->page_00h[SFF8636_EXT_ID_OFFSET]);
 
 	static const char *pfx =
 		"\tExtended identifier description           :";
 
-	switch (id[SFF8636_EXT_ID_OFFSET] & SFF8636_EXT_ID_PWR_CLASS_MASK) {
+	switch (map->page_00h[SFF8636_EXT_ID_OFFSET] &
+		SFF8636_EXT_ID_PWR_CLASS_MASK) {
 	case SFF8636_EXT_ID_PWR_CLASS_1:
 		printf("%s 1.5W max. Power consumption\n", pfx);
 		break;
@@ -233,17 +234,18 @@ static void sff8636_show_ext_identifier(const __u8 *id)
 		break;
 	}
 
-	if (id[SFF8636_EXT_ID_OFFSET] & SFF8636_EXT_ID_CDR_TX_MASK)
+	if (map->page_00h[SFF8636_EXT_ID_OFFSET] & SFF8636_EXT_ID_CDR_TX_MASK)
 		printf("%s CDR present in TX,", pfx);
 	else
 		printf("%s No CDR in TX,", pfx);
 
-	if (id[SFF8636_EXT_ID_OFFSET] & SFF8636_EXT_ID_CDR_RX_MASK)
+	if (map->page_00h[SFF8636_EXT_ID_OFFSET] & SFF8636_EXT_ID_CDR_RX_MASK)
 		printf(" CDR present in RX\n");
 	else
 		printf(" No CDR in RX\n");
 
-	switch (id[SFF8636_EXT_ID_OFFSET] & SFF8636_EXT_ID_EPWR_CLASS_MASK) {
+	switch (map->page_00h[SFF8636_EXT_ID_OFFSET] &
+		SFF8636_EXT_ID_EPWR_CLASS_MASK) {
 	case SFF8636_EXT_ID_PWR_CLASS_LEGACY:
 		printf("%s", pfx);
 		break;
@@ -257,18 +259,19 @@ static void sff8636_show_ext_identifier(const __u8 *id)
 		printf("%s 5.0W max. Power consumption, ", pfx);
 		break;
 	}
-	if (id[SFF8636_PWR_MODE_OFFSET] & SFF8636_HIGH_PWR_ENABLE)
+	if (map->lower_memory[SFF8636_PWR_MODE_OFFSET] &
+	    SFF8636_HIGH_PWR_ENABLE)
 		printf(" High Power Class (> 3.5 W) enabled\n");
 	else
 		printf(" High Power Class (> 3.5 W) not enabled\n");
 }
 
-static void sff8636_show_connector(const __u8 *id)
+static void sff8636_show_connector(const struct sff8636_memory_map *map)
 {
-	sff8024_show_connector(id, SFF8636_CTOR_OFFSET);
+	sff8024_show_connector(map->page_00h, SFF8636_CTOR_OFFSET);
 }
 
-static void sff8636_show_transceiver(const __u8 *id)
+static void sff8636_show_transceiver(const struct sff8636_memory_map *map)
 {
 	static const char *pfx =
 		"\tTransceiver type                          :";
@@ -276,33 +279,41 @@ static void sff8636_show_transceiver(const __u8 *id)
 	printf("\t%-41s : 0x%02x 0x%02x 0x%02x " \
 			"0x%02x 0x%02x 0x%02x 0x%02x 0x%02x\n",
 			"Transceiver codes",
-			id[SFF8636_ETHERNET_COMP_OFFSET],
-			id[SFF8636_SONET_COMP_OFFSET],
-			id[SFF8636_SAS_COMP_OFFSET],
-			id[SFF8636_GIGE_COMP_OFFSET],
-			id[SFF8636_FC_LEN_OFFSET],
-			id[SFF8636_FC_TECH_OFFSET],
-			id[SFF8636_FC_TRANS_MEDIA_OFFSET],
-			id[SFF8636_FC_SPEED_OFFSET]);
+			map->page_00h[SFF8636_ETHERNET_COMP_OFFSET],
+			map->page_00h[SFF8636_SONET_COMP_OFFSET],
+			map->page_00h[SFF8636_SAS_COMP_OFFSET],
+			map->page_00h[SFF8636_GIGE_COMP_OFFSET],
+			map->page_00h[SFF8636_FC_LEN_OFFSET],
+			map->page_00h[SFF8636_FC_TECH_OFFSET],
+			map->page_00h[SFF8636_FC_TRANS_MEDIA_OFFSET],
+			map->page_00h[SFF8636_FC_SPEED_OFFSET]);
 
 	/* 10G/40G Ethernet Compliance Codes */
-	if (id[SFF8636_ETHERNET_COMP_OFFSET] & SFF8636_ETHERNET_10G_LRM)
+	if (map->page_00h[SFF8636_ETHERNET_COMP_OFFSET] &
+	    SFF8636_ETHERNET_10G_LRM)
 		printf("%s 10G Ethernet: 10G Base-LRM\n", pfx);
-	if (id[SFF8636_ETHERNET_COMP_OFFSET] & SFF8636_ETHERNET_10G_LR)
+	if (map->page_00h[SFF8636_ETHERNET_COMP_OFFSET] &
+	    SFF8636_ETHERNET_10G_LR)
 		printf("%s 10G Ethernet: 10G Base-LR\n", pfx);
-	if (id[SFF8636_ETHERNET_COMP_OFFSET] & SFF8636_ETHERNET_10G_SR)
+	if (map->page_00h[SFF8636_ETHERNET_COMP_OFFSET] &
+	    SFF8636_ETHERNET_10G_SR)
 		printf("%s 10G Ethernet: 10G Base-SR\n", pfx);
-	if (id[SFF8636_ETHERNET_COMP_OFFSET] & SFF8636_ETHERNET_40G_CR4)
+	if (map->page_00h[SFF8636_ETHERNET_COMP_OFFSET] &
+	    SFF8636_ETHERNET_40G_CR4)
 		printf("%s 40G Ethernet: 40G Base-CR4\n", pfx);
-	if (id[SFF8636_ETHERNET_COMP_OFFSET] & SFF8636_ETHERNET_40G_SR4)
+	if (map->page_00h[SFF8636_ETHERNET_COMP_OFFSET] &
+	    SFF8636_ETHERNET_40G_SR4)
 		printf("%s 40G Ethernet: 40G Base-SR4\n", pfx);
-	if (id[SFF8636_ETHERNET_COMP_OFFSET] & SFF8636_ETHERNET_40G_LR4)
+	if (map->page_00h[SFF8636_ETHERNET_COMP_OFFSET] &
+	    SFF8636_ETHERNET_40G_LR4)
 		printf("%s 40G Ethernet: 40G Base-LR4\n", pfx);
-	if (id[SFF8636_ETHERNET_COMP_OFFSET] & SFF8636_ETHERNET_40G_ACTIVE)
+	if (map->page_00h[SFF8636_ETHERNET_COMP_OFFSET] &
+	    SFF8636_ETHERNET_40G_ACTIVE)
 		printf("%s 40G Ethernet: 40G Active Cable (XLPPI)\n", pfx);
 	/* Extended Specification Compliance Codes from SFF-8024 */
-	if (id[SFF8636_ETHERNET_COMP_OFFSET] & SFF8636_ETHERNET_RSRVD) {
-		switch (id[SFF8636_OPTION_1_OFFSET]) {
+	if (map->page_00h[SFF8636_ETHERNET_COMP_OFFSET] &
+	    SFF8636_ETHERNET_RSRVD) {
+		switch (map->page_00h[SFF8636_OPTION_1_OFFSET]) {
 		case SFF8636_ETHERNET_UNSPECIFIED:
 			printf("%s (reserved or unknown)\n", pfx);
 			break;
@@ -493,113 +504,122 @@ static void sff8636_show_transceiver(const __u8 *id)
 	}
 
 	/* SONET Compliance Codes */
-	if (id[SFF8636_SONET_COMP_OFFSET] & (SFF8636_SONET_40G_OTN))
+	if (map->page_00h[SFF8636_SONET_COMP_OFFSET] &
+	    (SFF8636_SONET_40G_OTN))
 		printf("%s 40G OTN (OTU3B/OTU3C)\n", pfx);
-	if (id[SFF8636_SONET_COMP_OFFSET] & (SFF8636_SONET_OC48_LR))
+	if (map->page_00h[SFF8636_SONET_COMP_OFFSET] & (SFF8636_SONET_OC48_LR))
 		printf("%s SONET: OC-48, long reach\n", pfx);
-	if (id[SFF8636_SONET_COMP_OFFSET] & (SFF8636_SONET_OC48_IR))
+	if (map->page_00h[SFF8636_SONET_COMP_OFFSET] & (SFF8636_SONET_OC48_IR))
 		printf("%s SONET: OC-48, intermediate reach\n", pfx);
-	if (id[SFF8636_SONET_COMP_OFFSET] & (SFF8636_SONET_OC48_SR))
+	if (map->page_00h[SFF8636_SONET_COMP_OFFSET] & (SFF8636_SONET_OC48_SR))
 		printf("%s SONET: OC-48, short reach\n", pfx);
 
 	/* SAS/SATA Compliance Codes */
-	if (id[SFF8636_SAS_COMP_OFFSET] & (SFF8636_SAS_6G))
+	if (map->page_00h[SFF8636_SAS_COMP_OFFSET] & (SFF8636_SAS_6G))
 		printf("%s SAS 6.0G\n", pfx);
-	if (id[SFF8636_SAS_COMP_OFFSET] & (SFF8636_SAS_3G))
+	if (map->page_00h[SFF8636_SAS_COMP_OFFSET] & (SFF8636_SAS_3G))
 		printf("%s SAS 3.0G\n", pfx);
 
 	/* Ethernet Compliance Codes */
-	if (id[SFF8636_GIGE_COMP_OFFSET] & SFF8636_GIGE_1000_BASE_T)
+	if (map->page_00h[SFF8636_GIGE_COMP_OFFSET] & SFF8636_GIGE_1000_BASE_T)
 		printf("%s Ethernet: 1000BASE-T\n", pfx);
-	if (id[SFF8636_GIGE_COMP_OFFSET] & SFF8636_GIGE_1000_BASE_CX)
+	if (map->page_00h[SFF8636_GIGE_COMP_OFFSET] & SFF8636_GIGE_1000_BASE_CX)
 		printf("%s Ethernet: 1000BASE-CX\n", pfx);
-	if (id[SFF8636_GIGE_COMP_OFFSET] & SFF8636_GIGE_1000_BASE_LX)
+	if (map->page_00h[SFF8636_GIGE_COMP_OFFSET] & SFF8636_GIGE_1000_BASE_LX)
 		printf("%s Ethernet: 1000BASE-LX\n", pfx);
-	if (id[SFF8636_GIGE_COMP_OFFSET] & SFF8636_GIGE_1000_BASE_SX)
+	if (map->page_00h[SFF8636_GIGE_COMP_OFFSET] & SFF8636_GIGE_1000_BASE_SX)
 		printf("%s Ethernet: 1000BASE-SX\n", pfx);
 
 	/* Fibre Channel link length */
-	if (id[SFF8636_FC_LEN_OFFSET] & SFF8636_FC_LEN_VERY_LONG)
+	if (map->page_00h[SFF8636_FC_LEN_OFFSET] & SFF8636_FC_LEN_VERY_LONG)
 		printf("%s FC: very long distance (V)\n", pfx);
-	if (id[SFF8636_FC_LEN_OFFSET] & SFF8636_FC_LEN_SHORT)
+	if (map->page_00h[SFF8636_FC_LEN_OFFSET] & SFF8636_FC_LEN_SHORT)
 		printf("%s FC: short distance (S)\n", pfx);
-	if (id[SFF8636_FC_LEN_OFFSET] & SFF8636_FC_LEN_INT)
+	if (map->page_00h[SFF8636_FC_LEN_OFFSET] & SFF8636_FC_LEN_INT)
 		printf("%s FC: intermediate distance (I)\n", pfx);
-	if (id[SFF8636_FC_LEN_OFFSET] & SFF8636_FC_LEN_LONG)
+	if (map->page_00h[SFF8636_FC_LEN_OFFSET] & SFF8636_FC_LEN_LONG)
 		printf("%s FC: long distance (L)\n", pfx);
-	if (id[SFF8636_FC_LEN_OFFSET] & SFF8636_FC_LEN_MED)
+	if (map->page_00h[SFF8636_FC_LEN_OFFSET] & SFF8636_FC_LEN_MED)
 		printf("%s FC: medium distance (M)\n", pfx);
 
 	/* Fibre Channel transmitter technology */
-	if (id[SFF8636_FC_LEN_OFFSET] & SFF8636_FC_TECH_LONG_LC)
+	if (map->page_00h[SFF8636_FC_LEN_OFFSET] & SFF8636_FC_TECH_LONG_LC)
 		printf("%s FC: Longwave laser (LC)\n", pfx);
-	if (id[SFF8636_FC_LEN_OFFSET] & SFF8636_FC_TECH_ELEC_INTER)
+	if (map->page_00h[SFF8636_FC_LEN_OFFSET] & SFF8636_FC_TECH_ELEC_INTER)
 		printf("%s FC: Electrical inter-enclosure (EL)\n", pfx);
-	if (id[SFF8636_FC_TECH_OFFSET] & SFF8636_FC_TECH_ELEC_INTRA)
+	if (map->page_00h[SFF8636_FC_TECH_OFFSET] & SFF8636_FC_TECH_ELEC_INTRA)
 		printf("%s FC: Electrical intra-enclosure (EL)\n", pfx);
-	if (id[SFF8636_FC_TECH_OFFSET] & SFF8636_FC_TECH_SHORT_WO_OFC)
+	if (map->page_00h[SFF8636_FC_TECH_OFFSET] &
+	    SFF8636_FC_TECH_SHORT_WO_OFC)
 		printf("%s FC: Shortwave laser w/o OFC (SN)\n", pfx);
-	if (id[SFF8636_FC_TECH_OFFSET] & SFF8636_FC_TECH_SHORT_W_OFC)
+	if (map->page_00h[SFF8636_FC_TECH_OFFSET] & SFF8636_FC_TECH_SHORT_W_OFC)
 		printf("%s FC: Shortwave laser with OFC (SL)\n", pfx);
-	if (id[SFF8636_FC_TECH_OFFSET] & SFF8636_FC_TECH_LONG_LL)
+	if (map->page_00h[SFF8636_FC_TECH_OFFSET] & SFF8636_FC_TECH_LONG_LL)
 		printf("%s FC: Longwave laser (LL)\n", pfx);
 
 	/* Fibre Channel transmission media */
-	if (id[SFF8636_FC_TRANS_MEDIA_OFFSET] & SFF8636_FC_TRANS_MEDIA_TW)
+	if (map->page_00h[SFF8636_FC_TRANS_MEDIA_OFFSET] &
+	    SFF8636_FC_TRANS_MEDIA_TW)
 		printf("%s FC: Twin Axial Pair (TW)\n", pfx);
-	if (id[SFF8636_FC_TRANS_MEDIA_OFFSET] & SFF8636_FC_TRANS_MEDIA_TP)
+	if (map->page_00h[SFF8636_FC_TRANS_MEDIA_OFFSET] &
+	    SFF8636_FC_TRANS_MEDIA_TP)
 		printf("%s FC: Twisted Pair (TP)\n", pfx);
-	if (id[SFF8636_FC_TRANS_MEDIA_OFFSET] & SFF8636_FC_TRANS_MEDIA_MI)
+	if (map->page_00h[SFF8636_FC_TRANS_MEDIA_OFFSET] &
+	    SFF8636_FC_TRANS_MEDIA_MI)
 		printf("%s FC: Miniature Coax (MI)\n", pfx);
-	if (id[SFF8636_FC_TRANS_MEDIA_OFFSET] & SFF8636_FC_TRANS_MEDIA_TV)
+	if (map->page_00h[SFF8636_FC_TRANS_MEDIA_OFFSET] &
+	    SFF8636_FC_TRANS_MEDIA_TV)
 		printf("%s FC: Video Coax (TV)\n", pfx);
-	if (id[SFF8636_FC_TRANS_MEDIA_OFFSET] & SFF8636_FC_TRANS_MEDIA_M6)
+	if (map->page_00h[SFF8636_FC_TRANS_MEDIA_OFFSET] &
+	    SFF8636_FC_TRANS_MEDIA_M6)
 		printf("%s FC: Multimode, 62.5m (M6)\n", pfx);
-	if (id[SFF8636_FC_TRANS_MEDIA_OFFSET] & SFF8636_FC_TRANS_MEDIA_M5)
+	if (map->page_00h[SFF8636_FC_TRANS_MEDIA_OFFSET] &
+	    SFF8636_FC_TRANS_MEDIA_M5)
 		printf("%s FC: Multimode, 50m (M5)\n", pfx);
-	if (id[SFF8636_FC_TRANS_MEDIA_OFFSET] & SFF8636_FC_TRANS_MEDIA_OM3)
+	if (map->page_00h[SFF8636_FC_TRANS_MEDIA_OFFSET] &
+	    SFF8636_FC_TRANS_MEDIA_OM3)
 		printf("%s FC: Multimode, 50um (OM3)\n", pfx);
-	if (id[SFF8636_FC_TRANS_MEDIA_OFFSET] & SFF8636_FC_TRANS_MEDIA_SM)
+	if (map->page_00h[SFF8636_FC_TRANS_MEDIA_OFFSET] &
+	    SFF8636_FC_TRANS_MEDIA_SM)
 		printf("%s FC: Single Mode (SM)\n", pfx);
 
 	/* Fibre Channel speed */
-	if (id[SFF8636_FC_SPEED_OFFSET] & SFF8636_FC_SPEED_1200_MBPS)
+	if (map->page_00h[SFF8636_FC_SPEED_OFFSET] & SFF8636_FC_SPEED_1200_MBPS)
 		printf("%s FC: 1200 MBytes/sec\n", pfx);
-	if (id[SFF8636_FC_SPEED_OFFSET] & SFF8636_FC_SPEED_800_MBPS)
+	if (map->page_00h[SFF8636_FC_SPEED_OFFSET] & SFF8636_FC_SPEED_800_MBPS)
 		printf("%s FC: 800 MBytes/sec\n", pfx);
-	if (id[SFF8636_FC_SPEED_OFFSET] & SFF8636_FC_SPEED_1600_MBPS)
+	if (map->page_00h[SFF8636_FC_SPEED_OFFSET] & SFF8636_FC_SPEED_1600_MBPS)
 		printf("%s FC: 1600 MBytes/sec\n", pfx);
-	if (id[SFF8636_FC_SPEED_OFFSET] & SFF8636_FC_SPEED_400_MBPS)
+	if (map->page_00h[SFF8636_FC_SPEED_OFFSET] & SFF8636_FC_SPEED_400_MBPS)
 		printf("%s FC: 400 MBytes/sec\n", pfx);
-	if (id[SFF8636_FC_SPEED_OFFSET] & SFF8636_FC_SPEED_200_MBPS)
+	if (map->page_00h[SFF8636_FC_SPEED_OFFSET] & SFF8636_FC_SPEED_200_MBPS)
 		printf("%s FC: 200 MBytes/sec\n", pfx);
-	if (id[SFF8636_FC_SPEED_OFFSET] & SFF8636_FC_SPEED_100_MBPS)
+	if (map->page_00h[SFF8636_FC_SPEED_OFFSET] & SFF8636_FC_SPEED_100_MBPS)
 		printf("%s FC: 100 MBytes/sec\n", pfx);
 }
 
-static void sff8636_show_encoding(const __u8 *id)
+static void sff8636_show_encoding(const struct sff8636_memory_map *map)
 {
-	sff8024_show_encoding(id, SFF8636_ENCODING_OFFSET, ETH_MODULE_SFF_8636);
+	sff8024_show_encoding(map->page_00h, SFF8636_ENCODING_OFFSET,
+			      ETH_MODULE_SFF_8636);
 }
 
-static void sff8636_show_rate_identifier(const __u8 *id)
+static void sff8636_show_rate_identifier(const struct sff8636_memory_map *map)
 {
 	/* TODO: Need to fix rate select logic */
 	printf("\t%-41s : 0x%02x\n", "Rate identifier",
-			id[SFF8636_EXT_RS_OFFSET]);
+	       map->page_00h[SFF8636_EXT_RS_OFFSET]);
 }
 
-static void sff8636_show_oui(const __u8 *id, int id_offset)
-{
-	sff8024_show_oui(id, id_offset);
-}
-
-static void sff8636_show_wavelength_or_copper_compliance(const __u8 *id)
+static void
+sff8636_show_wavelength_or_copper_compliance(const struct sff8636_memory_map *map)
 {
 	printf("\t%-41s : 0x%02x", "Transmitter technology",
-		(id[SFF8636_DEVICE_TECH_OFFSET] & SFF8636_TRANS_TECH_MASK));
+	       map->page_00h[SFF8636_DEVICE_TECH_OFFSET] &
+	       SFF8636_TRANS_TECH_MASK);
 
-	switch (id[SFF8636_DEVICE_TECH_OFFSET] & SFF8636_TRANS_TECH_MASK) {
+	switch (map->page_00h[SFF8636_DEVICE_TECH_OFFSET] &
+		SFF8636_TRANS_TECH_MASK) {
 	case SFF8636_TRANS_850_VCSEL:
 		printf(" (850 nm VCSEL)\n");
 		break;
@@ -650,31 +670,26 @@ static void sff8636_show_wavelength_or_copper_compliance(const __u8 *id)
 		break;
 	}
 
-	if ((id[SFF8636_DEVICE_TECH_OFFSET] & SFF8636_TRANS_TECH_MASK)
-			>= SFF8636_TRANS_COPPER_PAS_UNEQUAL) {
+	if ((map->page_00h[SFF8636_DEVICE_TECH_OFFSET] &
+	     SFF8636_TRANS_TECH_MASK) >= SFF8636_TRANS_COPPER_PAS_UNEQUAL) {
 		printf("\t%-41s : %udb\n", "Attenuation at 2.5GHz",
-			id[SFF8636_WAVELEN_HIGH_BYTE_OFFSET]);
+			map->page_00h[SFF8636_WAVELEN_HIGH_BYTE_OFFSET]);
 		printf("\t%-41s : %udb\n", "Attenuation at 5.0GHz",
-			id[SFF8636_WAVELEN_LOW_BYTE_OFFSET]);
+			map->page_00h[SFF8636_WAVELEN_LOW_BYTE_OFFSET]);
 		printf("\t%-41s : %udb\n", "Attenuation at 7.0GHz",
-			id[SFF8636_WAVE_TOL_HIGH_BYTE_OFFSET]);
+			map->page_00h[SFF8636_WAVE_TOL_HIGH_BYTE_OFFSET]);
 		printf("\t%-41s : %udb\n", "Attenuation at 12.9GHz",
-			id[SFF8636_WAVE_TOL_LOW_BYTE_OFFSET]);
+		       map->page_00h[SFF8636_WAVE_TOL_LOW_BYTE_OFFSET]);
 	} else {
 		printf("\t%-41s : %.3lfnm\n", "Laser wavelength",
-			(((id[SFF8636_WAVELEN_HIGH_BYTE_OFFSET] << 8) |
-				id[SFF8636_WAVELEN_LOW_BYTE_OFFSET])*0.05));
+		       (((map->page_00h[SFF8636_WAVELEN_HIGH_BYTE_OFFSET] << 8) |
+			 map->page_00h[SFF8636_WAVELEN_LOW_BYTE_OFFSET]) * 0.05));
 		printf("\t%-41s : %.3lfnm\n", "Laser wavelength tolerance",
-			(((id[SFF8636_WAVE_TOL_HIGH_BYTE_OFFSET] << 8) |
-			id[SFF8636_WAVE_TOL_LOW_BYTE_OFFSET])*0.005));
+		       (((map->page_00h[SFF8636_WAVE_TOL_HIGH_BYTE_OFFSET] << 8) |
+			 map->page_00h[SFF8636_WAVE_TOL_LOW_BYTE_OFFSET]) * 0.005));
 	}
 }
 
-static void sff8636_show_revision_compliance(const __u8 *id)
-{
-	sff_show_revision_compliance(id, SFF8636_REV_COMPLIANCE_OFFSET);
-}
-
 /*
  * 2-byte internal temperature conversions:
  * First byte is a signed 8-bit integer, which is the temp decimal part
@@ -683,39 +698,65 @@ static void sff8636_show_revision_compliance(const __u8 *id)
 #define SFF8636_OFFSET_TO_TEMP(offset) ((__s16)OFFSET_TO_U16(offset))
 #define OFFSET_TO_U16_PTR(ptr, offset) (ptr[offset] << 8 | ptr[(offset) + 1])
 
-static void sff8636_dom_parse(const __u8 *id, const __u8 *page_three, struct sff_diags *sd)
+static void sff8636_dom_parse(const struct sff8636_memory_map *map,
+			      struct sff_diags *sd)
 {
+	const __u8 *id = map->lower_memory;
 	int i = 0;
 
 	/* Monitoring Thresholds for Alarms and Warnings */
 	sd->sfp_voltage[MCURR] = OFFSET_TO_U16_PTR(id, SFF8636_VCC_CURR);
-	sd->sfp_voltage[HALRM] = OFFSET_TO_U16_PTR(page_three, SFF8636_VCC_HALRM);
-	sd->sfp_voltage[LALRM] = OFFSET_TO_U16_PTR(page_three, SFF8636_VCC_LALRM);
-	sd->sfp_voltage[HWARN] = OFFSET_TO_U16_PTR(page_three, SFF8636_VCC_HWARN);
-	sd->sfp_voltage[LWARN] = OFFSET_TO_U16_PTR(page_three, SFF8636_VCC_LWARN);
-
 	sd->sfp_temp[MCURR] = SFF8636_OFFSET_TO_TEMP(SFF8636_TEMP_CURR);
-	sd->sfp_temp[HALRM] = (__s16)OFFSET_TO_U16_PTR(page_three, SFF8636_TEMP_HALRM);
-	sd->sfp_temp[LALRM] = (__s16)OFFSET_TO_U16_PTR(page_three, SFF8636_TEMP_LALRM);
-	sd->sfp_temp[HWARN] = (__s16)OFFSET_TO_U16_PTR(page_three, SFF8636_TEMP_HWARN);
-	sd->sfp_temp[LWARN] = (__s16)OFFSET_TO_U16_PTR(page_three, SFF8636_TEMP_LWARN);
-
-	sd->bias_cur[HALRM] = OFFSET_TO_U16_PTR(page_three, SFF8636_TX_BIAS_HALRM);
-	sd->bias_cur[LALRM] = OFFSET_TO_U16_PTR(page_three, SFF8636_TX_BIAS_LALRM);
-	sd->bias_cur[HWARN] = OFFSET_TO_U16_PTR(page_three, SFF8636_TX_BIAS_HWARN);
-	sd->bias_cur[LWARN] = OFFSET_TO_U16_PTR(page_three, SFF8636_TX_BIAS_LWARN);
-
-	sd->tx_power[HALRM] = OFFSET_TO_U16_PTR(page_three, SFF8636_TX_PWR_HALRM);
-	sd->tx_power[LALRM] = OFFSET_TO_U16_PTR(page_three, SFF8636_TX_PWR_LALRM);
-	sd->tx_power[HWARN] = OFFSET_TO_U16_PTR(page_three, SFF8636_TX_PWR_HWARN);
-	sd->tx_power[LWARN] = OFFSET_TO_U16_PTR(page_three, SFF8636_TX_PWR_LWARN);
-
-	sd->rx_power[HALRM] = OFFSET_TO_U16_PTR(page_three, SFF8636_RX_PWR_HALRM);
-	sd->rx_power[LALRM] = OFFSET_TO_U16_PTR(page_three, SFF8636_RX_PWR_LALRM);
-	sd->rx_power[HWARN] = OFFSET_TO_U16_PTR(page_three, SFF8636_RX_PWR_HWARN);
-	sd->rx_power[LWARN] = OFFSET_TO_U16_PTR(page_three, SFF8636_RX_PWR_LWARN);
-
 
+	if (!map->page_03h)
+		goto out;
+
+	sd->sfp_voltage[HALRM] = OFFSET_TO_U16_PTR(map->page_03h,
+						   SFF8636_VCC_HALRM);
+	sd->sfp_voltage[LALRM] = OFFSET_TO_U16_PTR(map->page_03h,
+						   SFF8636_VCC_LALRM);
+	sd->sfp_voltage[HWARN] = OFFSET_TO_U16_PTR(map->page_03h,
+						   SFF8636_VCC_HWARN);
+	sd->sfp_voltage[LWARN] = OFFSET_TO_U16_PTR(map->page_03h,
+						   SFF8636_VCC_LWARN);
+
+	sd->sfp_temp[HALRM] = (__s16)OFFSET_TO_U16_PTR(map->page_03h,
+						       SFF8636_TEMP_HALRM);
+	sd->sfp_temp[LALRM] = (__s16)OFFSET_TO_U16_PTR(map->page_03h,
+						       SFF8636_TEMP_LALRM);
+	sd->sfp_temp[HWARN] = (__s16)OFFSET_TO_U16_PTR(map->page_03h,
+						       SFF8636_TEMP_HWARN);
+	sd->sfp_temp[LWARN] = (__s16)OFFSET_TO_U16_PTR(map->page_03h,
+						       SFF8636_TEMP_LWARN);
+
+	sd->bias_cur[HALRM] = OFFSET_TO_U16_PTR(map->page_03h,
+						SFF8636_TX_BIAS_HALRM);
+	sd->bias_cur[LALRM] = OFFSET_TO_U16_PTR(map->page_03h,
+						SFF8636_TX_BIAS_LALRM);
+	sd->bias_cur[HWARN] = OFFSET_TO_U16_PTR(map->page_03h,
+						SFF8636_TX_BIAS_HWARN);
+	sd->bias_cur[LWARN] = OFFSET_TO_U16_PTR(map->page_03h,
+						SFF8636_TX_BIAS_LWARN);
+
+	sd->tx_power[HALRM] = OFFSET_TO_U16_PTR(map->page_03h,
+						SFF8636_TX_PWR_HALRM);
+	sd->tx_power[LALRM] = OFFSET_TO_U16_PTR(map->page_03h,
+						SFF8636_TX_PWR_LALRM);
+	sd->tx_power[HWARN] = OFFSET_TO_U16_PTR(map->page_03h,
+						SFF8636_TX_PWR_HWARN);
+	sd->tx_power[LWARN] = OFFSET_TO_U16_PTR(map->page_03h,
+						SFF8636_TX_PWR_LWARN);
+
+	sd->rx_power[HALRM] = OFFSET_TO_U16_PTR(map->page_03h,
+						SFF8636_RX_PWR_HALRM);
+	sd->rx_power[LALRM] = OFFSET_TO_U16_PTR(map->page_03h,
+						SFF8636_RX_PWR_LALRM);
+	sd->rx_power[HWARN] = OFFSET_TO_U16_PTR(map->page_03h,
+						SFF8636_RX_PWR_HWARN);
+	sd->rx_power[LWARN] = OFFSET_TO_U16_PTR(map->page_03h,
+						SFF8636_RX_PWR_LWARN);
+
+out:
 	/* Channel Specific Data */
 	for (i = 0; i < MAX_CHANNEL_NUM; i++) {
 		u8 rx_power_offset, tx_bias_offset;
@@ -749,7 +790,7 @@ static void sff8636_dom_parse(const __u8 *id, const __u8 *page_three, struct sff
 	}
 }
 
-static void sff8636_show_dom(const __u8 *id, const __u8 *page_three, __u32 eeprom_len)
+static void sff8636_show_dom(const struct sff8636_memory_map *map)
 {
 	struct sff_diags sd = {0};
 	char *rx_power_string = NULL;
@@ -763,20 +804,15 @@ static void sff8636_show_dom(const __u8 *id, const __u8 *page_three, __u32 eepro
 	 * and thresholds
 	 * If pagging support exists, then supports_alarms is marked as 1
 	 */
+	if (map->page_03h)
+		sd.supports_alarms = 1;
 
-	if (eeprom_len == ETH_MODULE_SFF_8636_MAX_LEN) {
-		if (!(id[SFF8636_STATUS_2_OFFSET] &
-					SFF8636_STATUS_PAGE_3_PRESENT)) {
-			sd.supports_alarms = 1;
-		}
-	}
+	sd.rx_power_type = map->page_00h[SFF8636_DIAG_TYPE_OFFSET] &
+			   SFF8636_RX_PWR_TYPE_MASK;
+	sd.tx_power_type = map->page_00h[SFF8636_DIAG_TYPE_OFFSET] &
+			   SFF8636_RX_PWR_TYPE_MASK;
 
-	sd.rx_power_type = id[SFF8636_DIAG_TYPE_OFFSET] &
-						SFF8636_RX_PWR_TYPE_MASK;
-	sd.tx_power_type = id[SFF8636_DIAG_TYPE_OFFSET] &
-						SFF8636_RX_PWR_TYPE_MASK;
-
-	sff8636_dom_parse(id, page_three, &sd);
+	sff8636_dom_parse(map, &sd);
 
 	PRINT_TEMP("Module temperature", sd.sfp_temp[MCURR]);
 	PRINT_VCC("Module voltage", sd.sfp_voltage[MCURR]);
@@ -819,7 +855,7 @@ static void sff8636_show_dom(const __u8 *id, const __u8 *page_three, __u32 eepro
 	if (sd.supports_alarms) {
 		for (i = 0; sff8636_aw_flags[i].str; ++i) {
 			printf("\t%-41s : %s\n", sff8636_aw_flags[i].str,
-			       id[sff8636_aw_flags[i].offset]
+			       map->lower_memory[sff8636_aw_flags[i].offset]
 			       & sff8636_aw_flags[i].value ? "On" : "Off");
 		}
 
@@ -827,39 +863,39 @@ static void sff8636_show_dom(const __u8 *id, const __u8 *page_three, __u32 eepro
 	}
 }
 
-static void sff8636_show_page_zero(const __u8 *id)
+static void sff8636_show_page_zero(const struct sff8636_memory_map *map)
 {
-	sff8636_show_ext_identifier(id);
-	sff8636_show_connector(id);
-	sff8636_show_transceiver(id);
-	sff8636_show_encoding(id);
-	sff_show_value_with_unit(id, SFF8636_BR_NOMINAL_OFFSET,
-			"BR, Nominal", 100, "Mbps");
-	sff8636_show_rate_identifier(id);
-	sff_show_value_with_unit(id, SFF8636_SM_LEN_OFFSET,
-		     "Length (SMF,km)", 1, "km");
-	sff_show_value_with_unit(id, SFF8636_OM3_LEN_OFFSET,
-			"Length (OM3 50um)", 2, "m");
-	sff_show_value_with_unit(id, SFF8636_OM2_LEN_OFFSET,
-			"Length (OM2 50um)", 1, "m");
-	sff_show_value_with_unit(id, SFF8636_OM1_LEN_OFFSET,
-		     "Length (OM1 62.5um)", 1, "m");
-	sff_show_value_with_unit(id, SFF8636_CBL_LEN_OFFSET,
-		     "Length (Copper or Active cable)", 1, "m");
-	sff8636_show_wavelength_or_copper_compliance(id);
-	sff_show_ascii(id, SFF8636_VENDOR_NAME_START_OFFSET,
+	sff8636_show_ext_identifier(map);
+	sff8636_show_connector(map);
+	sff8636_show_transceiver(map);
+	sff8636_show_encoding(map);
+	sff_show_value_with_unit(map->page_00h, SFF8636_BR_NOMINAL_OFFSET,
+				 "BR, Nominal", 100, "Mbps");
+	sff8636_show_rate_identifier(map);
+	sff_show_value_with_unit(map->page_00h, SFF8636_SM_LEN_OFFSET,
+				 "Length (SMF,km)", 1, "km");
+	sff_show_value_with_unit(map->page_00h, SFF8636_OM3_LEN_OFFSET,
+				 "Length (OM3 50um)", 2, "m");
+	sff_show_value_with_unit(map->page_00h, SFF8636_OM2_LEN_OFFSET,
+				 "Length (OM2 50um)", 1, "m");
+	sff_show_value_with_unit(map->page_00h, SFF8636_OM1_LEN_OFFSET,
+				 "Length (OM1 62.5um)", 1, "m");
+	sff_show_value_with_unit(map->page_00h, SFF8636_CBL_LEN_OFFSET,
+				 "Length (Copper or Active cable)", 1, "m");
+	sff8636_show_wavelength_or_copper_compliance(map);
+	sff_show_ascii(map->page_00h, SFF8636_VENDOR_NAME_START_OFFSET,
 		       SFF8636_VENDOR_NAME_END_OFFSET, "Vendor name");
-	sff8636_show_oui(id, SFF8636_VENDOR_OUI_OFFSET);
-	sff_show_ascii(id, SFF8636_VENDOR_PN_START_OFFSET,
+	sff8024_show_oui(map->page_00h, SFF8636_VENDOR_OUI_OFFSET);
+	sff_show_ascii(map->page_00h, SFF8636_VENDOR_PN_START_OFFSET,
 		       SFF8636_VENDOR_PN_END_OFFSET, "Vendor PN");
-	sff_show_ascii(id, SFF8636_VENDOR_REV_START_OFFSET,
+	sff_show_ascii(map->page_00h, SFF8636_VENDOR_REV_START_OFFSET,
 		       SFF8636_VENDOR_REV_END_OFFSET, "Vendor rev");
-	sff_show_ascii(id, SFF8636_VENDOR_SN_START_OFFSET,
+	sff_show_ascii(map->page_00h, SFF8636_VENDOR_SN_START_OFFSET,
 		       SFF8636_VENDOR_SN_END_OFFSET, "Vendor SN");
-	sff_show_ascii(id, SFF8636_DATE_YEAR_OFFSET,
+	sff_show_ascii(map->page_00h, SFF8636_DATE_YEAR_OFFSET,
 		       SFF8636_DATE_VENDOR_LOT_OFFSET + 1, "Date code");
-	sff8636_show_revision_compliance(id);
-
+	sff_show_revision_compliance(map->lower_memory,
+				     SFF8636_REV_COMPLIANCE_OFFSET);
 }
 
 static void sff8636_memory_map_init_buf(struct sff8636_memory_map *map,
@@ -896,13 +932,13 @@ void sff8636_show_all_ioctl(const __u8 *id, __u32 eeprom_len)
 
 	sff8636_memory_map_init_buf(&map, id, eeprom_len);
 
-	sff8636_show_identifier(id);
-	switch (id[SFF8636_ID_OFFSET]) {
+	sff8636_show_identifier(&map);
+	switch (map.lower_memory[SFF8636_ID_OFFSET]) {
 	case SFF8024_ID_QSFP:
 	case SFF8024_ID_QSFP_PLUS:
 	case SFF8024_ID_QSFP28:
-		sff8636_show_page_zero(id);
-		sff8636_show_dom(id, id + 3 * 0x80, eeprom_len);
+		sff8636_show_page_zero(&map);
+		sff8636_show_dom(&map);
 		break;
 	}
 }
@@ -939,9 +975,7 @@ void sff8636_show_all_nl(const struct ethtool_module_eeprom *page_zero,
 
 	sff8636_memory_map_init_pages(&map, page_zero, page_three);
 
-	sff8636_show_identifier(page_zero->data);
-	sff8636_show_page_zero(page_zero->data);
-	if (page_three)
-		sff8636_show_dom(page_zero->data, page_three->data - 0x80,
-				 ETH_MODULE_SFF_8636_MAX_LEN);
+	sff8636_show_identifier(&map);
+	sff8636_show_page_zero(&map);
+	sff8636_show_dom(&map);
 }
-- 
2.31.1

