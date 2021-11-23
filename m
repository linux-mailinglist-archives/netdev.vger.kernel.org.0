Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7700F45AA37
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 18:41:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239324AbhKWRop (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 12:44:45 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:40899 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239289AbhKWRoo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Nov 2021 12:44:44 -0500
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id EF7FD5C00E2;
        Tue, 23 Nov 2021 12:41:35 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Tue, 23 Nov 2021 12:41:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=1n9MJ/pk4PtOUTC5FiG1cp9Naodq8qe0kwVsL/qt8pY=; b=j/fFh6Dt
        4F01UW03oAawQUjfOODaPjst+n9cAl7CR2Pnq6U/jBtaJ70EYpaXD3rwmzXgXV6V
        /dikPWepxzrvrLyJ5A7xpRS+uiPi7OaEJ+87FqlplyBttfVaKeSTnbDlouaK9Ixi
        TXAc2W3FlHQ7+MkW5EXBOyxImVtcYXoXIF3VMuqnDlvldct9ri4bvFE+VkhByiY6
        P3t7IAKSCi1G0TMSqw8u4vxpv/dGwYSRDLaPwaDXujCTfDNxNJ3h5GKbkcfm5f7Y
        USlGLGGDwmHhltDTqOsmjVuCHjJfjpkTrWzrQSrqSJissPRouFZvmrZGu5sRyAZ4
        OJQ6+wOa6yVo0Q==
X-ME-Sender: <xms:zyedYQ3zoqzq2HgBTLRIOmPKUbjJoF6z1rul8eAoIhx_oRpTzxE32g>
    <xme:zyedYbFGsYUrtrOn3NgHcuXRm2paaIfRZAhOte8O1TQ1NCyTiHkXya_6C4TyBtbMi
    XJEZ-udFV-wM2c>
X-ME-Received: <xmr:zyedYY53itJPFKmOC2yyImFrsL3qZJKpR1ABPIBECBXER4r3uvNm30W-M9BXPZBW8HVpCT17g_oEx9zuCIKRGCgw2hgbe-lfBc5Cc1icEhzAGw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvuddrgeeigddutdegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecuvehluhhsthgvrhfuihiivgeptdenucfr
    rghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:zyedYZ3nKayfkDOH8ULV97nUAzHNlmkr1A4Cx6Ka4E-0So4H7quM3A>
    <xmx:zyedYTFw7tpzMhSOz4Nc8f2qszzZL10LXzVvvN6HNQcUmOlJa-kpTA>
    <xmx:zyedYS9nZNwmbaaMIRZsuY9gbKIIJUqICx2OTu5B-p4zQK5cppb9mA>
    <xmx:zyedYXixttwJ_kZfAmXBlx9noLaHgi0qiSe5ANNOiye-5Eyx0jkXHQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 23 Nov 2021 12:41:34 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     mkubecek@suse.cz, popadrian1996@gmail.com, andrew@lunn.ch,
        mlxsw@nvidia.com, moshe@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH ethtool-next 6/8] cmis: Print Module State and Fault Cause
Date:   Tue, 23 Nov 2021 19:41:00 +0200
Message-Id: <20211123174102.3242294-7-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211123174102.3242294-1-idosch@idosch.org>
References: <20211123174102.3242294-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Print the CMIS Module State when dumping EEPROM contents via the '-m'
option. It can be used, for example, to test module power mode settings.

Example output:

 # ethtool -m swp11
 Identifier                                : 0x18 (QSFP-DD Double Density 8X Pluggable Transceiver (INF-8628))
 ...
 Module State                              : 0x03 (ModuleReady)

 # ethtool --set-module swp11 power-mode-policy auto

 # ethtool -m swp11
 Identifier                                : 0x18 (QSFP-DD Double Density 8X Pluggable Transceiver (INF-8628))
 ...
 Module State                              : 0x01 (ModuleLowPwr)

In case the module is in fault state, print the CMIS Module Fault Cause.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 cmis.c | 70 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 cmis.h | 16 ++++++++++++++
 2 files changed, 86 insertions(+)

diff --git a/cmis.c b/cmis.c
index d7b7097139b3..a32cc9f8b1f6 100644
--- a/cmis.c
+++ b/cmis.c
@@ -402,6 +402,74 @@ static void cmis_show_vendor_info(const struct cmis_memory_map *map)
 			       CMIS_CLEI_END_OFFSET, "CLEI code");
 }
 
+/* Print the current Module State. Relevant documents:
+ * [1] CMIS Rev. 5, pag. 57, section 6.3.2.2, Figure 6-3
+ * [2] CMIS Rev. 5, pag. 60, section 6.3.2.3, Figure 6-4
+ * [3] CMIS Rev. 5, pag. 107, section 8.2.2, Table 8-6
+ */
+static void cmis_show_mod_state(const struct cmis_memory_map *map)
+{
+	__u8 mod_state;
+
+	mod_state = (map->lower_memory[CMIS_MODULE_STATE_OFFSET] &
+		     CMIS_MODULE_STATE_MASK) >> 1;
+	printf("\t%-41s : 0x%02x", "Module State", mod_state);
+	switch (mod_state) {
+	case CMIS_MODULE_STATE_MODULE_LOW_PWR:
+		printf(" (ModuleLowPwr)\n");
+		break;
+	case CMIS_MODULE_STATE_MODULE_PWR_UP:
+		printf(" (ModulePwrUp)\n");
+		break;
+	case CMIS_MODULE_STATE_MODULE_READY:
+		printf(" (ModuleReady)\n");
+		break;
+	case CMIS_MODULE_STATE_MODULE_PWR_DN:
+		printf(" (ModulePwrDn)\n");
+		break;
+	case CMIS_MODULE_STATE_MODULE_FAULT:
+		printf(" (ModuleFault)\n");
+		break;
+	default:
+		printf(" (reserved or unknown)\n");
+		break;
+	}
+}
+
+/* Print the Module Fault Information. Relevant documents:
+ * [1] CMIS Rev. 5, pag. 64, section 6.3.2.12
+ * [2] CMIS Rev. 5, pag. 115, section 8.2.10, Table 8-15
+ */
+static void cmis_show_mod_fault_cause(const struct cmis_memory_map *map)
+{
+	__u8 mod_state, fault_cause;
+
+	mod_state = (map->lower_memory[CMIS_MODULE_STATE_OFFSET] &
+		     CMIS_MODULE_STATE_MASK) >> 1;
+	if (mod_state != CMIS_MODULE_STATE_MODULE_FAULT)
+		return;
+
+	fault_cause = map->lower_memory[CMIS_MODULE_FAULT_OFFSET];
+	printf("\t%-41s : 0x%02x", "Module Fault Cause", fault_cause);
+	switch (fault_cause) {
+	case CMIS_MODULE_FAULT_NO_FAULT:
+		printf(" (No fault detected / not supported)\n");
+		break;
+	case CMIS_MODULE_FAULT_TEC_RUNAWAY:
+		printf(" (TEC runaway)\n");
+		break;
+	case CMIS_MODULE_FAULT_DATA_MEM_CORRUPTED:
+		printf(" (Data memory corrupted)\n");
+		break;
+	case CMIS_MODULE_FAULT_PROG_MEM_CORRUPTED:
+		printf(" (Program memory corrupted)\n");
+		break;
+	default:
+		printf(" (reserved or unknown)\n");
+		break;
+	}
+}
+
 static void cmis_parse_dom_power_type(const struct cmis_memory_map *map,
 				      struct sff_diags *sd)
 {
@@ -775,6 +843,8 @@ static void cmis_show_all_common(const struct cmis_memory_map *map)
 	cmis_show_link_len(map);
 	cmis_show_vendor_info(map);
 	cmis_show_rev_compliance(map);
+	cmis_show_mod_state(map);
+	cmis_show_mod_fault_cause(map);
 	cmis_show_dom(map);
 }
 
diff --git a/cmis.h b/cmis.h
index 310697b0ef32..2c67ad5640ab 100644
--- a/cmis.h
+++ b/cmis.h
@@ -7,6 +7,15 @@
 #define CMIS_MEMORY_MODEL_OFFSET		0x02
 #define CMIS_MEMORY_MODEL_MASK			0x80
 
+/* Global Status Information (Page 0) */
+#define CMIS_MODULE_STATE_OFFSET		0x03
+#define CMIS_MODULE_STATE_MASK			0x0E
+#define CMIS_MODULE_STATE_MODULE_LOW_PWR	0x01
+#define CMIS_MODULE_STATE_MODULE_PWR_UP		0x02
+#define CMIS_MODULE_STATE_MODULE_READY		0x03
+#define CMIS_MODULE_STATE_MODULE_PWR_DN		0x04
+#define CMIS_MODULE_STATE_MODULE_FAULT		0x05
+
 /* Module Flags (Page 0) */
 #define CMIS_VCC_AW_OFFSET			0x09
 #define CMIS_VCC_LWARN_STATUS			0x80
@@ -27,6 +36,13 @@
 #define CMIS_CURR_TEMP_OFFSET			0x0E
 #define CMIS_CURR_VCC_OFFSET			0x10
 
+/* Module Fault Information (Page 0) */
+#define CMIS_MODULE_FAULT_OFFSET		0x29
+#define CMIS_MODULE_FAULT_NO_FAULT		0x00
+#define CMIS_MODULE_FAULT_TEC_RUNAWAY		0x01
+#define CMIS_MODULE_FAULT_DATA_MEM_CORRUPTED	0x02
+#define CMIS_MODULE_FAULT_PROG_MEM_CORRUPTED	0x03
+
 #define CMIS_CTOR_OFFSET			0xCB
 
 /* Vendor related information (Page 0) */
-- 
2.31.1

