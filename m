Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09DCE45AA36
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 18:41:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239334AbhKWRoo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 12:44:44 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:43841 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239324AbhKWRom (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Nov 2021 12:44:42 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id F24545C00FB;
        Tue, 23 Nov 2021 12:41:33 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Tue, 23 Nov 2021 12:41:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=k4htUu9E4RZwfnnpC1ceuyNpNagBCmqp0zjxl4hz/tI=; b=IOxkvrVz
        zvy+XHY86T4cCyxMreY8hvceQpMj6taoH/2uSKKAyVrtTyJTD9CaLZ3K86tGZuJH
        kKPR2swJiNrCmZzzXFnkLz09RiWkDdAC7me6QzM5RdO996hqicy2BErGrDTHZhEK
        OGL83hzTJ7HtNYbiFOzGc6yIdvY+Dpd007mCQFp/aXUfLdu3aY8Pd5Q91QTpQUyk
        kFX+72TfVHkgGXmSHAAVLVGuBDwWiOt8vMJgBfjWlyi49GI+asyOtrdYzY10Fa5T
        HuWMy3rnRAzXbiNQc9TcpIY/e2Vz7daY34Kb5Yx8bGHRKTYZczEf33kTxkNin1uM
        CvbwdAByUBdyuQ==
X-ME-Sender: <xms:zCedYQ-8hO0lZBNqMc2InRMolDmSVMNOOAKAFoWox615waEKdhhyFw>
    <xme:zCedYYuoQwrfMTLNKeQ4IaV3_Sz8TD2if3wqz6efAg9wT_xM6ruvs6bqeQX4rkW0G
    DnDi36mpvC05r0>
X-ME-Received: <xmr:zCedYWD9vwk6uUYMQJt8sxYQENYL0-IF4B87zjQfxeh70oavwepIOoJxbIL_JY1o74sSlMIkQcJBzyfCXFJ5wj60jWsT9VPlfIAuxzfW01qm6g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvuddrgeeigddutdegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecuvehluhhsthgvrhfuihiivgepudenucfr
    rghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:zCedYQeOxr0J7yWEdzVxP13xkmYPLwCEdP91KsmRcZUHW2QaZhOcaA>
    <xmx:zCedYVOH3G2NgGNux3Qoa5s-BXO7j0uUXso4E8twycL-kEVRwr_v6w>
    <xmx:zCedYanM5CP4XypgYEwY2rje3Lg--Il9vf6MNq0mNoE_IonNLGcHOA>
    <xmx:zSedYarunyApMLB6YuaE2tFdUjikqs_5AxByoCtivANq4insDaYS-w>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 23 Nov 2021 12:41:31 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     mkubecek@suse.cz, popadrian1996@gmail.com, andrew@lunn.ch,
        mlxsw@nvidia.com, moshe@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH ethtool-next 5/8] cmis: Parse and print diagnostic information
Date:   Tue, 23 Nov 2021 19:40:59 +0200
Message-Id: <20211123174102.3242294-6-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211123174102.3242294-1-idosch@idosch.org>
References: <20211123174102.3242294-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Like SFF-8636, CMIS has module-level monitors such as temperature and
voltage and channel-level monitors such as Tx optical power.

These monitors have thresholds and flags that are set when the monitors
cross the thresholds.

Print and parse these values in a similar fashion to SFF-8636.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 cmis.c | 466 +++++++++++++++++++++++++++++++++++++++++++++++++++++----
 cmis.h |  79 ++++++++++
 2 files changed, 518 insertions(+), 27 deletions(-)

diff --git a/cmis.c b/cmis.c
index 83ced4d253ae..d7b7097139b3 100644
--- a/cmis.c
+++ b/cmis.c
@@ -19,6 +19,8 @@
  * [1] CMIS Rev. 5, page. 128, section 8.4.4, Table 8-40
  */
 #define CMIS_MAX_BANKS	4
+#define CMIS_CHANNELS_PER_BANK	8
+#define CMIS_MAX_CHANNEL_NUM	(CMIS_MAX_BANKS * CMIS_CHANNELS_PER_BANK)
 
 /* We are not parsing further than Page 11h. */
 #define CMIS_MAX_PAGES	18
@@ -34,6 +36,80 @@ struct cmis_memory_map {
 #define CMIS_PAGE_SIZE		0x80
 #define CMIS_I2C_ADDRESS	0x50
 
+static struct {
+	const char *str;
+	int offset;
+	__u8 value;	/* Alarm is on if (offset & value) != 0. */
+} cmis_aw_mod_flags[] = {
+	{ "Module temperature high alarm",
+	  CMIS_TEMP_AW_OFFSET, CMIS_TEMP_HALARM_STATUS },
+	{ "Module temperature low alarm",
+	  CMIS_TEMP_AW_OFFSET, CMIS_TEMP_LALARM_STATUS },
+	{ "Module temperature high warning",
+	  CMIS_TEMP_AW_OFFSET, CMIS_TEMP_HWARN_STATUS },
+	{ "Module temperature low warning",
+	  CMIS_TEMP_AW_OFFSET, CMIS_TEMP_LWARN_STATUS },
+
+	{ "Module voltage high alarm",
+	  CMIS_VCC_AW_OFFSET, CMIS_VCC_HALARM_STATUS },
+	{ "Module voltage low alarm",
+	  CMIS_VCC_AW_OFFSET, CMIS_VCC_LALARM_STATUS },
+	{ "Module voltage high warning",
+	  CMIS_VCC_AW_OFFSET, CMIS_VCC_HWARN_STATUS },
+	{ "Module voltage low warning",
+	  CMIS_VCC_AW_OFFSET, CMIS_VCC_LWARN_STATUS },
+
+	{ NULL, 0, 0 },
+};
+
+static struct {
+	const char *fmt_str;
+	int offset;
+	int adver_offset;	/* In Page 01h. */
+	__u8 adver_value;	/* Supported if (offset & value) != 0. */
+} cmis_aw_chan_flags[] = {
+	{ "Laser bias current high alarm   (Chan %d)",
+	  CMIS_TX_BIAS_AW_HALARM_OFFSET,
+	  CMIS_DIAG_CHAN_ADVER_OFFSET, CMIS_TX_BIAS_MON_MASK },
+	{ "Laser bias current low alarm    (Chan %d)",
+	  CMIS_TX_BIAS_AW_LALARM_OFFSET,
+	  CMIS_DIAG_CHAN_ADVER_OFFSET, CMIS_TX_BIAS_MON_MASK },
+	{ "Laser bias current high warning (Chan %d)",
+	  CMIS_TX_BIAS_AW_HWARN_OFFSET,
+	  CMIS_DIAG_CHAN_ADVER_OFFSET, CMIS_TX_BIAS_MON_MASK },
+	{ "Laser bias current low warning  (Chan %d)",
+	  CMIS_TX_BIAS_AW_LWARN_OFFSET,
+	  CMIS_DIAG_CHAN_ADVER_OFFSET, CMIS_TX_BIAS_MON_MASK },
+
+	{ "Laser tx power high alarm   (Channel %d)",
+	  CMIS_TX_PWR_AW_HALARM_OFFSET,
+	  CMIS_DIAG_CHAN_ADVER_OFFSET, CMIS_TX_PWR_MON_MASK },
+	{ "Laser tx power low alarm    (Channel %d)",
+	  CMIS_TX_PWR_AW_LALARM_OFFSET,
+	  CMIS_DIAG_CHAN_ADVER_OFFSET, CMIS_TX_PWR_MON_MASK },
+	{ "Laser tx power high warning (Channel %d)",
+	  CMIS_TX_PWR_AW_HWARN_OFFSET,
+	  CMIS_DIAG_CHAN_ADVER_OFFSET, CMIS_TX_PWR_MON_MASK },
+	{ "Laser tx power low warning  (Channel %d)",
+	  CMIS_TX_PWR_AW_LWARN_OFFSET,
+	  CMIS_DIAG_CHAN_ADVER_OFFSET, CMIS_TX_PWR_MON_MASK },
+
+	{ "Laser rx power high alarm   (Channel %d)",
+	  CMIS_RX_PWR_AW_HALARM_OFFSET,
+	  CMIS_DIAG_CHAN_ADVER_OFFSET, CMIS_RX_PWR_MON_MASK },
+	{ "Laser rx power low alarm    (Channel %d)",
+	  CMIS_RX_PWR_AW_LALARM_OFFSET,
+	  CMIS_DIAG_CHAN_ADVER_OFFSET, CMIS_RX_PWR_MON_MASK },
+	{ "Laser rx power high warning (Channel %d)",
+	  CMIS_RX_PWR_AW_HWARN_OFFSET,
+	  CMIS_DIAG_CHAN_ADVER_OFFSET, CMIS_RX_PWR_MON_MASK },
+	{ "Laser rx power low warning  (Channel %d)",
+	  CMIS_RX_PWR_AW_LWARN_OFFSET,
+	  CMIS_DIAG_CHAN_ADVER_OFFSET, CMIS_RX_PWR_MON_MASK },
+
+	{ NULL, 0, 0, 0 },
+};
+
 static void cmis_show_identifier(const struct cmis_memory_map *map)
 {
 	sff8024_show_identifier(map->lower_memory, CMIS_ID_OFFSET);
@@ -277,32 +353,6 @@ static void cmis_show_mit_compliance(const struct cmis_memory_map *map)
 	}
 }
 
-/*
- * 2-byte internal temperature conversions:
- * First byte is a signed 8-bit integer, which is the temp decimal part
- * Second byte is a multiple of 1/256th of a degree, which is added to
- * the dec part.
- */
-#define OFFSET_TO_TEMP(offset) ((__s16)OFFSET_TO_U16(offset))
-
-/**
- * Print relevant module level monitoring values. Relevant documents:
- * [1] CMIS Rev. 3:
- * --> pag. 50, section 1.7.2.4, Table 22
- *
- * [2] CMIS Rev. 4:
- * --> pag. 84, section 8.2.4, Table 8-6
- */
-static void cmis_show_mod_lvl_monitors(const struct cmis_memory_map *map)
-{
-	const __u8 *id = map->lower_memory;
-
-	PRINT_TEMP("Module temperature",
-		   OFFSET_TO_TEMP(CMIS_CURR_TEMP_OFFSET));
-	PRINT_VCC("Module voltage",
-		  OFFSET_TO_U16(CMIS_CURR_VCC_OFFSET));
-}
-
 /**
  * Print relevant info about the maximum supported fiber media length
  * for each type of fiber media at the maximum module-supported bit rate.
@@ -352,6 +402,368 @@ static void cmis_show_vendor_info(const struct cmis_memory_map *map)
 			       CMIS_CLEI_END_OFFSET, "CLEI code");
 }
 
+static void cmis_parse_dom_power_type(const struct cmis_memory_map *map,
+				      struct sff_diags *sd)
+{
+	sd->rx_power_type = map->page_01h[CMIS_DIAG_TYPE_OFFSET] &
+			    CMIS_RX_PWR_TYPE_MASK;
+	sd->tx_power_type = map->page_01h[CMIS_DIAG_CHAN_ADVER_OFFSET] &
+			    CMIS_TX_PWR_MON_MASK;
+}
+
+static void cmis_parse_dom_mod_lvl_monitors(const struct cmis_memory_map *map,
+					    struct sff_diags *sd)
+{
+	sd->sfp_voltage[MCURR] = OFFSET_TO_U16_PTR(map->lower_memory,
+						   CMIS_CURR_VCC_OFFSET);
+	sd->sfp_temp[MCURR] = (__s16)OFFSET_TO_U16_PTR(map->lower_memory,
+						       CMIS_CURR_TEMP_OFFSET);
+}
+
+static void cmis_parse_dom_mod_lvl_thresh(const struct cmis_memory_map *map,
+					  struct sff_diags *sd)
+{
+	/* Page is not present in IOCTL path. */
+	if (!map->page_02h)
+		return;
+	sd->supports_alarms = 1;
+
+	sd->sfp_voltage[HALRM] = OFFSET_TO_U16_PTR(map->page_02h,
+						   CMIS_VCC_HALRM_OFFSET);
+	sd->sfp_voltage[LALRM] = OFFSET_TO_U16_PTR(map->page_02h,
+						   CMIS_VCC_LALRM_OFFSET);
+	sd->sfp_voltage[HWARN] = OFFSET_TO_U16_PTR(map->page_02h,
+						   CMIS_VCC_HWARN_OFFSET);
+	sd->sfp_voltage[LWARN] = OFFSET_TO_U16_PTR(map->page_02h,
+						   CMIS_VCC_LWARN_OFFSET);
+
+	sd->sfp_temp[HALRM] = (__s16)OFFSET_TO_U16_PTR(map->page_02h,
+						       CMIS_TEMP_HALRM_OFFSET);
+	sd->sfp_temp[LALRM] = (__s16)OFFSET_TO_U16_PTR(map->page_02h,
+						       CMIS_TEMP_LALRM_OFFSET);
+	sd->sfp_temp[HWARN] = (__s16)OFFSET_TO_U16_PTR(map->page_02h,
+						       CMIS_TEMP_HWARN_OFFSET);
+	sd->sfp_temp[LWARN] = (__s16)OFFSET_TO_U16_PTR(map->page_02h,
+						       CMIS_TEMP_LWARN_OFFSET);
+}
+
+static __u8 cmis_tx_bias_mul(const struct cmis_memory_map *map)
+{
+	switch (map->page_01h[CMIS_DIAG_CHAN_ADVER_OFFSET] &
+		CMIS_TX_BIAS_MUL_MASK) {
+	case CMIS_TX_BIAS_MUL_1:
+		return 0;
+	case CMIS_TX_BIAS_MUL_2:
+		return 1;
+	case CMIS_TX_BIAS_MUL_4:
+		return 2;
+	}
+
+	return 0;
+}
+
+static void
+cmis_parse_dom_chan_lvl_monitors_bank(const struct cmis_memory_map *map,
+				      struct sff_diags *sd, int bank)
+{
+	const __u8 *page_11h = map->upper_memory[bank][0x11];
+	int i;
+
+	if (!page_11h)
+		return;
+
+	for (i = 0; i < CMIS_CHANNELS_PER_BANK; i++) {
+		__u8 tx_bias_offset, rx_power_offset, tx_power_offset;
+		int chan = bank * CMIS_CHANNELS_PER_BANK + i;
+		__u8 bias_mul = cmis_tx_bias_mul(map);
+
+		tx_bias_offset = CMIS_TX_BIAS_OFFSET + i * sizeof(__u16);
+		rx_power_offset = CMIS_RX_PWR_OFFSET + i * sizeof(__u16);
+		tx_power_offset = CMIS_TX_PWR_OFFSET + i * sizeof(__u16);
+
+		sd->scd[chan].bias_cur = OFFSET_TO_U16_PTR(page_11h,
+							   tx_bias_offset);
+		sd->scd[chan].bias_cur >>= bias_mul;
+		sd->scd[chan].rx_power = OFFSET_TO_U16_PTR(page_11h,
+							   rx_power_offset);
+		sd->scd[chan].tx_power = OFFSET_TO_U16_PTR(page_11h,
+							   tx_power_offset);
+	}
+}
+
+static void cmis_parse_dom_chan_lvl_monitors(const struct cmis_memory_map *map,
+					     struct sff_diags *sd)
+{
+	int i;
+
+	for (i = 0; i < CMIS_MAX_BANKS; i++)
+		cmis_parse_dom_chan_lvl_monitors_bank(map, sd, i);
+}
+
+static void cmis_parse_dom_chan_lvl_thresh(const struct cmis_memory_map *map,
+					   struct sff_diags *sd)
+{
+	__u8 bias_mul = cmis_tx_bias_mul(map);
+
+	if (!map->page_02h)
+		return;
+
+	sd->bias_cur[HALRM] = OFFSET_TO_U16_PTR(map->page_02h,
+						CMIS_TX_BIAS_HALRM_OFFSET);
+	sd->bias_cur[HALRM] >>= bias_mul;
+	sd->bias_cur[LALRM] = OFFSET_TO_U16_PTR(map->page_02h,
+						CMIS_TX_BIAS_LALRM_OFFSET);
+	sd->bias_cur[LALRM] >>= bias_mul;
+	sd->bias_cur[HWARN] = OFFSET_TO_U16_PTR(map->page_02h,
+						CMIS_TX_BIAS_HWARN_OFFSET);
+	sd->bias_cur[HWARN] >>= bias_mul;
+	sd->bias_cur[LWARN] = OFFSET_TO_U16_PTR(map->page_02h,
+						CMIS_TX_BIAS_LWARN_OFFSET);
+	sd->bias_cur[LWARN] >>= bias_mul;
+
+	sd->tx_power[HALRM] = OFFSET_TO_U16_PTR(map->page_02h,
+						CMIS_TX_PWR_HALRM_OFFSET);
+	sd->tx_power[LALRM] = OFFSET_TO_U16_PTR(map->page_02h,
+						CMIS_TX_PWR_LALRM_OFFSET);
+	sd->tx_power[HWARN] = OFFSET_TO_U16_PTR(map->page_02h,
+						CMIS_TX_PWR_HWARN_OFFSET);
+	sd->tx_power[LWARN] = OFFSET_TO_U16_PTR(map->page_02h,
+						CMIS_TX_PWR_LWARN_OFFSET);
+
+	sd->rx_power[HALRM] = OFFSET_TO_U16_PTR(map->page_02h,
+						CMIS_RX_PWR_HALRM_OFFSET);
+	sd->rx_power[LALRM] = OFFSET_TO_U16_PTR(map->page_02h,
+						CMIS_RX_PWR_LALRM_OFFSET);
+	sd->rx_power[HWARN] = OFFSET_TO_U16_PTR(map->page_02h,
+						CMIS_RX_PWR_HWARN_OFFSET);
+	sd->rx_power[LWARN] = OFFSET_TO_U16_PTR(map->page_02h,
+						CMIS_RX_PWR_LWARN_OFFSET);
+}
+
+static void cmis_parse_dom(const struct cmis_memory_map *map,
+			   struct sff_diags *sd)
+{
+	cmis_parse_dom_power_type(map, sd);
+	cmis_parse_dom_mod_lvl_monitors(map, sd);
+	cmis_parse_dom_mod_lvl_thresh(map, sd);
+	cmis_parse_dom_chan_lvl_monitors(map, sd);
+	cmis_parse_dom_chan_lvl_thresh(map, sd);
+}
+
+/* Print module-level monitoring values. Relevant documents:
+ * [1] CMIS Rev. 5, page 110, section 8.2.5, Table 8-9
+ */
+static void cmis_show_dom_mod_lvl_monitors(const struct sff_diags *sd)
+{
+	PRINT_TEMP("Module temperature", sd->sfp_temp[MCURR]);
+	PRINT_VCC("Module voltage", sd->sfp_voltage[MCURR]);
+}
+
+/* Print channel Tx laser bias current. Relevant documents:
+ * [1] CMIS Rev. 5, page 165, section 8.9.4, Table 8-79
+ */
+static void
+cmis_show_dom_chan_lvl_tx_bias_bank(const struct cmis_memory_map *map,
+				    const struct sff_diags *sd, int bank)
+{
+	const __u8 *page_11h = map->upper_memory[bank][0x11];
+	int i;
+
+	if (!page_11h)
+		return;
+
+	for (i = 0; i < CMIS_CHANNELS_PER_BANK; i++) {
+		int chan = bank * CMIS_CHANNELS_PER_BANK + i;
+		char fmt_str[80];
+
+		snprintf(fmt_str, 80, "%s (Channel %d)",
+			 "Laser tx bias current", chan + 1);
+		PRINT_BIAS(fmt_str, sd->scd[chan].bias_cur);
+	}
+}
+
+static void cmis_show_dom_chan_lvl_tx_bias(const struct cmis_memory_map *map,
+					   const struct sff_diags *sd)
+{
+	int i;
+
+	if(!(map->page_01h[CMIS_DIAG_CHAN_ADVER_OFFSET] &
+	     CMIS_TX_BIAS_MON_MASK))
+		return;
+
+	for (i = 0; i < CMIS_MAX_BANKS; i++)
+		cmis_show_dom_chan_lvl_tx_bias_bank(map, sd, i);
+}
+
+/* Print channel Tx average optical power. Relevant documents:
+ * [1] CMIS Rev. 5, page 165, section 8.9.4, Table 8-79
+ */
+static void
+cmis_show_dom_chan_lvl_tx_power_bank(const struct cmis_memory_map *map,
+				     const struct sff_diags *sd, int bank)
+{
+	const __u8 *page_11h = map->upper_memory[bank][0x11];
+	int i;
+
+	if (!page_11h)
+		return;
+
+	for (i = 0; i < CMIS_CHANNELS_PER_BANK; i++) {
+		int chan = bank * CMIS_CHANNELS_PER_BANK + i;
+		char fmt_str[80];
+
+		snprintf(fmt_str, 80, "%s (Channel %d)",
+			 "Transmit avg optical power", chan + 1);
+		PRINT_xX_PWR(fmt_str, sd->scd[chan].tx_power);
+	}
+}
+
+static void cmis_show_dom_chan_lvl_tx_power(const struct cmis_memory_map *map,
+					    const struct sff_diags *sd)
+{
+	int i;
+
+	if (!sd->tx_power_type)
+		return;
+
+	for (i = 0; i < CMIS_MAX_BANKS; i++)
+		cmis_show_dom_chan_lvl_tx_power_bank(map, sd, i);
+}
+
+/* Print channel Rx input optical power. Relevant documents:
+ * [1] CMIS Rev. 5, page 165, section 8.9.4, Table 8-79
+ */
+static void
+cmis_show_dom_chan_lvl_rx_power_bank(const struct cmis_memory_map *map,
+				     const struct sff_diags *sd, int bank)
+{
+	const __u8 *page_11h = map->upper_memory[bank][0x11];
+	int i;
+
+	if (!page_11h)
+		return;
+
+	for (i = 0; i < CMIS_CHANNELS_PER_BANK; i++) {
+		int chan = bank * CMIS_CHANNELS_PER_BANK + i;
+		char *rx_power_str;
+		char fmt_str[80];
+
+		if (!sd->rx_power_type)
+			rx_power_str = "Receiver signal OMA";
+		else
+			rx_power_str = "Rcvr signal avg optical power";
+
+		snprintf(fmt_str, 80, "%s (Channel %d)", rx_power_str,
+			 chan + 1);
+		PRINT_xX_PWR(fmt_str, sd->scd[chan].rx_power);
+	}
+}
+
+static void cmis_show_dom_chan_lvl_rx_power(const struct cmis_memory_map *map,
+					    const struct sff_diags *sd)
+{
+	int i;
+
+	if(!(map->page_01h[CMIS_DIAG_CHAN_ADVER_OFFSET] & CMIS_RX_PWR_MON_MASK))
+		return;
+
+	for (i = 0; i < CMIS_MAX_BANKS; i++)
+		cmis_show_dom_chan_lvl_rx_power_bank(map, sd, i);
+}
+
+static void cmis_show_dom_chan_lvl_monitors(const struct cmis_memory_map *map,
+					    const struct sff_diags *sd)
+{
+	cmis_show_dom_chan_lvl_tx_bias(map, sd);
+	cmis_show_dom_chan_lvl_tx_power(map, sd);
+	cmis_show_dom_chan_lvl_rx_power(map, sd);
+}
+
+/* Print module-level flags. Relevant documents:
+ * [1] CMIS Rev. 5, page 109, section 8.2.4, Table 8-8
+ */
+static void cmis_show_dom_mod_lvl_flags(const struct cmis_memory_map *map)
+{
+	int i;
+
+	for (i = 0; cmis_aw_mod_flags[i].str; i++) {
+		printf("\t%-41s : %s\n", cmis_aw_mod_flags[i].str,
+		       map->lower_memory[cmis_aw_mod_flags[i].offset] &
+		       cmis_aw_mod_flags[i].value ? "On" : "Off");
+	}
+}
+
+/* Print channel-level flags. Relevant documents:
+ * [1] CMIS Rev. 5, page 162, section 8.9.3, Table 8-77
+ * [1] CMIS Rev. 5, page 164, section 8.9.3, Table 8-78
+ */
+static void cmis_show_dom_chan_lvl_flags_chan(const struct cmis_memory_map *map,
+					      int bank, int chan)
+{
+	const __u8 *page_11h = map->upper_memory[bank][0x11];
+	int i;
+
+	for (i = 0; cmis_aw_chan_flags[i].fmt_str; i++) {
+		char str[80];
+
+		if (!(map->page_01h[cmis_aw_chan_flags[i].adver_offset] &
+		      cmis_aw_chan_flags[i].adver_value))
+			continue;
+
+		snprintf(str, 80, cmis_aw_chan_flags[i].fmt_str, chan + 1);
+		printf("\t%-41s : %s\n", str,
+		       page_11h[cmis_aw_chan_flags[i].offset] & chan ?
+		       "On" : "Off");
+	}
+}
+
+static void
+cmis_show_dom_chan_lvl_flags_bank(const struct cmis_memory_map *map,
+				  int bank)
+{
+	const __u8 *page_11h = map->upper_memory[bank][0x11];
+	int i;
+
+	if (!page_11h)
+		return;
+
+	for (i = 0; i < CMIS_CHANNELS_PER_BANK; i++) {
+		int chan = bank * CMIS_CHANNELS_PER_BANK + i;
+
+		cmis_show_dom_chan_lvl_flags_chan(map, bank, chan);
+	}
+}
+
+static void cmis_show_dom_chan_lvl_flags(const struct cmis_memory_map *map)
+{
+	int i;
+
+	for (i = 0; i < CMIS_MAX_BANKS; i++)
+		cmis_show_dom_chan_lvl_flags_bank(map, i);
+}
+
+
+static void cmis_show_dom(const struct cmis_memory_map *map)
+{
+	struct sff_diags sd = {};
+
+	/* Diagnostic information is only relevant when the module memory
+	 * model is paged and not flat.
+	 */
+	if (map->lower_memory[CMIS_MEMORY_MODEL_OFFSET] &
+	    CMIS_MEMORY_MODEL_MASK)
+		return;
+
+	cmis_parse_dom(map, &sd);
+
+	cmis_show_dom_mod_lvl_monitors(&sd);
+	cmis_show_dom_chan_lvl_monitors(map, &sd);
+	cmis_show_dom_mod_lvl_flags(map);
+	cmis_show_dom_chan_lvl_flags(map);
+	if (sd.supports_alarms)
+		sff_show_thresholds(sd);
+}
+
 static void cmis_show_all_common(const struct cmis_memory_map *map)
 {
 	cmis_show_identifier(map);
@@ -360,10 +772,10 @@ static void cmis_show_all_common(const struct cmis_memory_map *map)
 	cmis_show_cbl_asm_len(map);
 	cmis_show_sig_integrity(map);
 	cmis_show_mit_compliance(map);
-	cmis_show_mod_lvl_monitors(map);
 	cmis_show_link_len(map);
 	cmis_show_vendor_info(map);
 	cmis_show_rev_compliance(map);
+	cmis_show_dom(map);
 }
 
 static void cmis_memory_map_init_buf(struct cmis_memory_map *map,
diff --git a/cmis.h b/cmis.h
index 8d90a04756ad..310697b0ef32 100644
--- a/cmis.h
+++ b/cmis.h
@@ -7,6 +7,18 @@
 #define CMIS_MEMORY_MODEL_OFFSET		0x02
 #define CMIS_MEMORY_MODEL_MASK			0x80
 
+/* Module Flags (Page 0) */
+#define CMIS_VCC_AW_OFFSET			0x09
+#define CMIS_VCC_LWARN_STATUS			0x80
+#define CMIS_VCC_HWARN_STATUS			0x40
+#define CMIS_VCC_LALARM_STATUS			0x20
+#define CMIS_VCC_HALARM_STATUS			0x10
+#define CMIS_TEMP_AW_OFFSET			0x09
+#define CMIS_TEMP_LWARN_STATUS			0x08
+#define CMIS_TEMP_HWARN_STATUS			0x04
+#define CMIS_TEMP_LALARM_STATUS			0x02
+#define CMIS_TEMP_HALARM_STATUS			0x01
+
 #define CMIS_MODULE_TYPE_OFFSET			0x55
 #define CMIS_MT_MMF				0x01
 #define CMIS_MT_SMF				0x02
@@ -121,10 +133,77 @@
 #define CMIS_BANK_0_1_SUPPORTED			0x01
 #define CMIS_BANK_0_3_SUPPORTED			0x02
 
+/* Module Characteristics Advertising (Page 1) */
+#define CMIS_DIAG_TYPE_OFFSET			0x97
+#define CMIS_RX_PWR_TYPE_MASK			0x10
+
+/* Supported Monitors Advertisement (Page 1) */
+#define CMIS_DIAG_CHAN_ADVER_OFFSET		0xA0
+#define CMIS_TX_BIAS_MON_MASK			0x01
+#define CMIS_TX_PWR_MON_MASK			0x02
+#define CMIS_RX_PWR_MON_MASK			0x04
+#define CMIS_TX_BIAS_MUL_MASK			0x18
+#define CMIS_TX_BIAS_MUL_1			0x00
+#define CMIS_TX_BIAS_MUL_2			0x08
+#define CMIS_TX_BIAS_MUL_4			0x10
+
 /* Signal integrity controls */
 #define CMIS_SIG_INTEG_TX_OFFSET		0xA1
 #define CMIS_SIG_INTEG_RX_OFFSET		0xA2
 
+/*-----------------------------------------------------------------------
+ * Upper Memory Page 0x02: Optional Page that informs about module-defined
+ * thresholds for module-level and lane-specific threshold crossing monitors.
+ */
+
+/* Module-Level Monitor Thresholds (Page 2) */
+#define CMIS_TEMP_HALRM_OFFSET			0x80
+#define CMIS_TEMP_LALRM_OFFSET			0x82
+#define CMIS_TEMP_HWARN_OFFSET			0x84
+#define CMIS_TEMP_LWARN_OFFSET			0x86
+#define CMIS_VCC_HALRM_OFFSET			0x88
+#define CMIS_VCC_LALRM_OFFSET			0x8A
+#define CMIS_VCC_HWARN_OFFSET			0x8C
+#define CMIS_VCC_LWARN_OFFSET			0x8E
+
+/* Lane-Related Monitor Thresholds (Page 2) */
+#define CMIS_TX_PWR_HALRM_OFFSET		0xB0
+#define CMIS_TX_PWR_LALRM_OFFSET		0xB2
+#define CMIS_TX_PWR_HWARN_OFFSET		0xB4
+#define CMIS_TX_PWR_LWARN_OFFSET		0xB6
+#define CMIS_TX_BIAS_HALRM_OFFSET		0xB8
+#define CMIS_TX_BIAS_LALRM_OFFSET		0xBA
+#define CMIS_TX_BIAS_HWARN_OFFSET		0xBC
+#define CMIS_TX_BIAS_LWARN_OFFSET		0xBE
+#define CMIS_RX_PWR_HALRM_OFFSET		0xC0
+#define CMIS_RX_PWR_LALRM_OFFSET		0xC2
+#define CMIS_RX_PWR_HWARN_OFFSET		0xC4
+#define CMIS_RX_PWR_LWARN_OFFSET		0xC6
+
+/*-----------------------------------------------------------------------
+ * Upper Memory Page 0x11: Optional Page that contains lane dynamic status
+ * bytes.
+ */
+
+/* Media Lane-Specific Flags (Page 0x11) */
+#define CMIS_TX_PWR_AW_HALARM_OFFSET		0x8B
+#define CMIS_TX_PWR_AW_LALARM_OFFSET		0x8C
+#define CMIS_TX_PWR_AW_HWARN_OFFSET		0x8D
+#define CMIS_TX_PWR_AW_LWARN_OFFSET		0x8E
+#define CMIS_TX_BIAS_AW_HALARM_OFFSET		0x8F
+#define CMIS_TX_BIAS_AW_LALARM_OFFSET		0x90
+#define CMIS_TX_BIAS_AW_HWARN_OFFSET		0x91
+#define CMIS_TX_BIAS_AW_LWARN_OFFSET		0x92
+#define CMIS_RX_PWR_AW_HALARM_OFFSET		0x95
+#define CMIS_RX_PWR_AW_LALARM_OFFSET		0x96
+#define CMIS_RX_PWR_AW_HWARN_OFFSET		0x97
+#define CMIS_RX_PWR_AW_LWARN_OFFSET		0x98
+
+/* Media Lane-Specific Monitors (Page 0x11) */
+#define CMIS_TX_PWR_OFFSET			0x9A
+#define CMIS_TX_BIAS_OFFSET			0xAA
+#define CMIS_RX_PWR_OFFSET			0xBA
+
 #define YESNO(x) (((x) != 0) ? "Yes" : "No")
 #define ONOFF(x) (((x) != 0) ? "On" : "Off")
 
-- 
2.31.1

