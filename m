Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4716C3F5EA6
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 15:06:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237519AbhHXNGb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 09:06:31 -0400
Received: from new3-smtp.messagingengine.com ([66.111.4.229]:49537 "EHLO
        new3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237498AbhHXNGa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Aug 2021 09:06:30 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id 5B8CE580B17;
        Tue, 24 Aug 2021 09:05:46 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Tue, 24 Aug 2021 09:05:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=zLN9E2Ij/fcGwBqvIyta14tzyMxSpfSl6+HaIZNc0kI=; b=KVsxxgII
        k6INBkLAKGzdhnzdbppeXTkQnZHfLJBo5QnDOJbJNIHb7aOFVda5agACCXuZbJdw
        SVhhuHyieVVJJxks02EsiDzZMp7cSJxXrIjbPbp2picGAzLnqdDRhEbGqIh+7nYS
        2Idqn08TagHjjpU349eCuQ4wxw+RV1YAnWUCKjLY2N22u+8Iytg4+vPtshhFOvJ8
        Si5QHxGKkGbAleCyuzS3fHs21N8n4jyiKntLZpkwLOsSYGs7hKVWlu44auSaMbq7
        jk0HRr4gtkovm422Bobfxw08b6A2OX8StdQI/qQkM9WtOnCoFreCaF5IARNTvcuI
        azNGNHT9a0BFlQ==
X-ME-Sender: <xms:qu4kYXmLhLhgHApLAAZJUAD_cKrM72wq2FElcUGVrmTHts_G81akYg>
    <xme:qu4kYa00QG_OYj_kVPPLTM_s6ZmwJiKDOZCL0cSlbM26iQ_tkf3hqAYan3P9qoQm5
    nTjwX1nJMpIN8I>
X-ME-Received: <xmr:qu4kYdozhpqebrI_izHytLe-OGjltaLpLxaBayIUvPz0UEWwQ6uDzwAwtnQvPsY181YVsyWADKaGzf5IKZVJj_2JDTO4kfTkhSCgV1gy6a4h8A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddruddtjedgiedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecuvehluhhsthgvrhfuihiivgepvdenucfr
    rghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:qu4kYflblXt0movVY5pGmwfBu04xK1UVDV80ZNaUs8788NmyJ4317Q>
    <xmx:qu4kYV2jCcOchSq7aZ-pBJVGoiMu3YlzwBczegvH2yh6OGkV09YaFQ>
    <xmx:qu4kYeu4gnRpJoHyUwi4dvY1B9RjDKqNLw8cFqz2hqN_t5Dpcpza6w>
    <xmx:qu4kYeLG8b4IskXG1mFsmTc4pvXMLIG_-8l_03a1CxKkFNs7ddAcFw>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 24 Aug 2021 09:05:43 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        mkubecek@suse.cz, pali@kernel.org, jacob.e.keller@intel.com,
        jiri@nvidia.com, vadimp@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [RFC PATCH ethtool-next v3 3/6] ethtool: Print CMIS Module State
Date:   Tue, 24 Aug 2021 16:05:12 +0300
Message-Id: <20210824130515.1828270-4-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210824130515.1828270-1-idosch@idosch.org>
References: <20210824130515.1828270-1-idosch@idosch.org>
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
 cmis.c | 71 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 cmis.h | 15 +++++++++++++
 2 files changed, 86 insertions(+)

diff --git a/cmis.c b/cmis.c
index 361b721f332f..c5c1f02398f6 100644
--- a/cmis.c
+++ b/cmis.c
@@ -42,6 +42,73 @@ static void cmis_show_rev_compliance(const __u8 *id)
 	printf("\t%-41s : Rev. %d.%d\n", "Revision compliance", major, minor);
 }
 
+/**
+ * Print the current Module State. Relevant documents:
+ * [1] CMIS Rev. 5, pag. 57, section 6.3.2.2, Figure 6-3
+ * [2] CMIS Rev. 5, pag. 60, section 6.3.2.3, Figure 6-4
+ * [3] CMIS Rev. 5, pag. 107, section 8.2.2, Table 8-6
+ */
+static void cmis_show_mod_state(const __u8 *id)
+{
+	__u8 mod_state = (id[CMIS_MODULE_STATE_OFFSET] >> 1) & 0x07;
+
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
+/**
+ * Print the Module Fault Information. Relevant documents:
+ * [1] CMIS Rev. 5, pag. 64, section 6.3.2.12
+ * [2] CMIS Rev. 5, pag. 115, section 8.2.10, Table 8-15
+ */
+static void cmis_show_mod_fault_cause(const __u8 *id)
+{
+	__u8 mod_state = (id[CMIS_MODULE_STATE_OFFSET] >> 1) & 0x07;
+	__u8 fault_cause = id[CMIS_MODULE_FAULT_OFFSET];
+
+	if (mod_state != CMIS_MODULE_STATE_MODULE_FAULT)
+		return;
+
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
+
 /**
  * Print information about the device's power consumption.
  * Relevant documents:
@@ -336,6 +403,8 @@ void qsfp_dd_show_all(const __u8 *id)
 	cmis_show_link_len(id);
 	cmis_show_vendor_info(id);
 	cmis_show_rev_compliance(id);
+	cmis_show_mod_state(id);
+	cmis_show_mod_fault_cause(id);
 }
 
 void cmis_show_all(const struct ethtool_module_eeprom *page_zero,
@@ -356,4 +425,6 @@ void cmis_show_all(const struct ethtool_module_eeprom *page_zero,
 
 	cmis_show_vendor_info(page_zero_data);
 	cmis_show_rev_compliance(page_zero_data);
+	cmis_show_mod_state(page_zero_data);
+	cmis_show_mod_fault_cause(page_zero_data);
 }
diff --git a/cmis.h b/cmis.h
index 78ee1495bc33..41383132cf8e 100644
--- a/cmis.h
+++ b/cmis.h
@@ -5,6 +5,21 @@
 #define CMIS_ID_OFFSET				0x00
 #define CMIS_REV_COMPLIANCE_OFFSET		0x01
 
+/* Module State (Page 0) */
+#define CMIS_MODULE_STATE_OFFSET		0x03
+#define CMIS_MODULE_STATE_MODULE_LOW_PWR	0x01
+#define CMIS_MODULE_STATE_MODULE_PWR_UP		0x02
+#define CMIS_MODULE_STATE_MODULE_READY		0x03
+#define CMIS_MODULE_STATE_MODULE_PWR_DN		0x04
+#define CMIS_MODULE_STATE_MODULE_FAULT		0x05
+
+/* Module Fault Information (Page 0) */
+#define CMIS_MODULE_FAULT_OFFSET		0x29
+#define CMIS_MODULE_FAULT_NO_FAULT		0
+#define CMIS_MODULE_FAULT_TEC_RUNAWAY		1
+#define CMIS_MODULE_FAULT_DATA_MEM_CORRUPTED	2
+#define CMIS_MODULE_FAULT_PROG_MEM_CORRUPTED	3
+
 #define CMIS_MODULE_TYPE_OFFSET			0x55
 #define CMIS_MT_MMF				0x01
 #define CMIS_MT_SMF				0x02
-- 
2.31.1

