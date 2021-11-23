Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FD9A45AA38
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 18:41:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239365AbhKWRor (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 12:44:47 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:50589 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239289AbhKWRoq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Nov 2021 12:44:46 -0500
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id 180BC5C00ED;
        Tue, 23 Nov 2021 12:41:38 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Tue, 23 Nov 2021 12:41:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=Q2R8lfjqyv1c6gbw6oqzJoGb3nlGMW5dkDzrXCCb3+I=; b=UNoL1XqK
        ONGVkJYAiLTEGczGNNl6QDNlZ3lWGlgZNpvZ7kEHdjzi+BpuhXfcTdAWbLIzuPLT
        W9QlBWEehABYWY1gudrYFYmkbIepN0sg1Fvvl6mxxeZpxfWpNRhAU/cTh7VUJePJ
        KQq7ASWn0vF5nyRavcW5DhjfssrwgF/DtNMuTDKVmQMIIs68RTsvj8pPKJJLt6H9
        ZCj09GPvSmfTOOM9QI6oFwiNm4BHj/P90xTClxnLZUOWqimhhmxiLvk4MZ5WibAT
        GNMFMLLKj3NI3FbtQ+xacrdSc8sbkzvXRJuAbGA/iuOgKYceAAJ84kWMsAux6PRe
        5979hjlhk/oFog==
X-ME-Sender: <xms:0iedYUoq0tcJOgrM3O-2Qd1BPN8H_b3DueAcYUTNsvZpvzbntUIcjQ>
    <xme:0iedYaqZqCY89IIAzR0P5LZYkQpexGz2gfOCfhk7vuqbabHWXRKMgMcL6-X4JvY-7
    SlOZk24-EYDRQw>
X-ME-Received: <xmr:0iedYZOB8PsTsJUTaQafPUFWGxvReQCL9kO8OjsrHGFWIsgdwNJjsag-pSUug2ng-xIeQGBeyfa3Gz5dpt9yPwyW5b6ifFDVPSA1J9lZcOF9-g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvuddrgeeigddutdegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecuvehluhhsthgvrhfuihiivgeptdenucfr
    rghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:0iedYb6pOIwD0k7bjVckYhdV4Or0BmRZln2lpHbPyaM8FLtFT5LlkA>
    <xmx:0iedYT6-DBjko7mQzdQw3NBTyDb2Y84nTPqj61QB2EwIvmGbVbpzqQ>
    <xmx:0iedYbhQZ1Y7AL01lgNxa7wYx8p6VuQIItTwQdhU2Q988tc2wRpvTw>
    <xmx:0iedYW2sevofmT3OxWbHEYcRTMNyTAV85NK0TcpNN6y3i4frBLOxTQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 23 Nov 2021 12:41:36 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     mkubecek@suse.cz, popadrian1996@gmail.com, andrew@lunn.ch,
        mlxsw@nvidia.com, moshe@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH ethtool-next 7/8] cmis: Print Module-Level Controls
Date:   Tue, 23 Nov 2021 19:41:01 +0200
Message-Id: <20211123174102.3242294-8-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211123174102.3242294-1-idosch@idosch.org>
References: <20211123174102.3242294-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Print the CMIS Module-Level Controls when dumping EEPROM contents via
the '-m' option. It can be used to understand low power mode enforcement
by the host.

Example output:

 # ethtool -m swp11
 Identifier                                : 0x18 (QSFP-DD Double Density 8X Pluggable Transceiver (INF-8628))
 ...
 Module State                              : 0x03 (ModuleReady)
 LowPwrAllowRequestHW                      : Off
 LowPwrRequestSW                           : Off
 ...
 Transmit avg optical power (Channel 1)    : 1.3222 mW / 1.21 dBm
 Transmit avg optical power (Channel 2)    : 1.2666 mW / 1.03 dBm
 Transmit avg optical power (Channel 3)    : 1.2860 mW / 1.09 dBm
 Transmit avg optical power (Channel 4)    : 1.2988 mW / 1.14 dBm
 Transmit avg optical power (Channel 5)    : 1.2828 mW / 1.08 dBm
 Transmit avg optical power (Channel 6)    : 1.2913 mW / 1.11 dBm
 Transmit avg optical power (Channel 7)    : 1.2636 mW / 1.02 dBm
 Transmit avg optical power (Channel 8)    : 1.3408 mW / 1.27 dBm
 Transmit avg optical power (Channel 9)    : 1.3222 mW / 1.21 dBm
 Transmit avg optical power (Channel 10)   : 1.2666 mW / 1.03 dBm
 Transmit avg optical power (Channel 11)   : 1.2860 mW / 1.09 dBm
 Transmit avg optical power (Channel 12)   : 1.2988 mW / 1.14 dBm
 Transmit avg optical power (Channel 13)   : 1.2828 mW / 1.08 dBm
 Transmit avg optical power (Channel 14)   : 1.2913 mW / 1.11 dBm
 Transmit avg optical power (Channel 15)   : 1.2636 mW / 1.02 dBm
 Transmit avg optical power (Channel 16)   : 1.3408 mW / 1.27 dBm
 Rcvr signal avg optical power (Channel 1) : 1.1351 mW / 0.55 dBm
 Rcvr signal avg optical power (Channel 2) : 1.1603 mW / 0.65 dBm
 Rcvr signal avg optical power (Channel 3) : 1.1529 mW / 0.62 dBm
 Rcvr signal avg optical power (Channel 4) : 1.1670 mW / 0.67 dBm
 Rcvr signal avg optical power (Channel 5) : 1.1759 mW / 0.70 dBm
 Rcvr signal avg optical power (Channel 6) : 1.1744 mW / 0.70 dBm
 Rcvr signal avg optical power (Channel 7) : 1.1188 mW / 0.49 dBm
 Rcvr signal avg optical power (Channel 8) : 1.1640 mW / 0.66 dBm
 Rcvr signal avg optical power (Channel 9) : 1.1351 mW / 0.55 dBm
 Rcvr signal avg optical power (Channel 10) : 1.1603 mW / 0.65 dBm
 Rcvr signal avg optical power (Channel 11) : 1.1529 mW / 0.62 dBm
 Rcvr signal avg optical power (Channel 12) : 1.1670 mW / 0.67 dBm
 Rcvr signal avg optical power (Channel 13) : 1.1759 mW / 0.70 dBm
 Rcvr signal avg optical power (Channel 14) : 1.1744 mW / 0.70 dBm
 Rcvr signal avg optical power (Channel 15) : 1.1188 mW / 0.49 dBm
 Rcvr signal avg optical power (Channel 16) : 1.1640 mW / 0.66 dBm

 # ethtool --set-module swp11 power-mode-policy auto

 # ethtool -m swp11
 Identifier                                : 0x18 (QSFP-DD Double Density 8X Pluggable Transceiver (INF-8628))
 ...
 Module State                              : 0x01 (ModuleLowPwr)
 LowPwrAllowRequestHW                      : Off
 LowPwrRequestSW                           : On
 ...
 Transmit avg optical power (Channel 1)    : 0.0001 mW / -40.00 dBm
 Transmit avg optical power (Channel 2)    : 0.0001 mW / -40.00 dBm
 Transmit avg optical power (Channel 3)    : 0.0001 mW / -40.00 dBm
 Transmit avg optical power (Channel 4)    : 0.0001 mW / -40.00 dBm
 Transmit avg optical power (Channel 5)    : 0.0001 mW / -40.00 dBm
 Transmit avg optical power (Channel 6)    : 0.0001 mW / -40.00 dBm
 Transmit avg optical power (Channel 7)    : 0.0001 mW / -40.00 dBm
 Transmit avg optical power (Channel 8)    : 0.0001 mW / -40.00 dBm
 Transmit avg optical power (Channel 9)    : 0.0001 mW / -40.00 dBm
 Transmit avg optical power (Channel 10)   : 0.0001 mW / -40.00 dBm
 Transmit avg optical power (Channel 11)   : 0.0001 mW / -40.00 dBm
 Transmit avg optical power (Channel 12)   : 0.0001 mW / -40.00 dBm
 Transmit avg optical power (Channel 13)   : 0.0001 mW / -40.00 dBm
 Transmit avg optical power (Channel 14)   : 0.0001 mW / -40.00 dBm
 Transmit avg optical power (Channel 15)   : 0.0001 mW / -40.00 dBm
 Transmit avg optical power (Channel 16)   : 0.0001 mW / -40.00 dBm
 Rcvr signal avg optical power (Channel 1) : 0.0001 mW / -40.00 dBm
 Rcvr signal avg optical power (Channel 2) : 0.0001 mW / -40.00 dBm
 Rcvr signal avg optical power (Channel 3) : 0.0001 mW / -40.00 dBm
 Rcvr signal avg optical power (Channel 4) : 0.0001 mW / -40.00 dBm
 Rcvr signal avg optical power (Channel 5) : 0.0001 mW / -40.00 dBm
 Rcvr signal avg optical power (Channel 6) : 0.0001 mW / -40.00 dBm
 Rcvr signal avg optical power (Channel 7) : 0.0001 mW / -40.00 dBm
 Rcvr signal avg optical power (Channel 8) : 0.0001 mW / -40.00 dBm
 Rcvr signal avg optical power (Channel 9) : 0.0001 mW / -40.00 dBm
 Rcvr signal avg optical power (Channel 10) : 0.0001 mW / -40.00 dBm
 Rcvr signal avg optical power (Channel 11) : 0.0001 mW / -40.00 dBm
 Rcvr signal avg optical power (Channel 12) : 0.0001 mW / -40.00 dBm
 Rcvr signal avg optical power (Channel 13) : 0.0001 mW / -40.00 dBm
 Rcvr signal avg optical power (Channel 14) : 0.0001 mW / -40.00 dBm
 Rcvr signal avg optical power (Channel 15) : 0.0001 mW / -40.00 dBm
 Rcvr signal avg optical power (Channel 16) : 0.0001 mW / -40.00 dBm

 # ethtool --set-module swp11 power-mode-policy high

 # ethtool -m swp11
 Identifier                                : 0x18 (QSFP-DD Double Density 8X Pluggable Transceiver (INF-8628))
 ...
 Module State                              : 0x03 (ModuleReady)
 LowPwrAllowRequestHW                      : Off
 LowPwrRequestSW                           : Off
 ...
 Transmit avg optical power (Channel 1)    : 1.3690 mW / 1.36 dBm
 Transmit avg optical power (Channel 2)    : 1.3036 mW / 1.15 dBm
 Transmit avg optical power (Channel 3)    : 1.3358 mW / 1.26 dBm
 Transmit avg optical power (Channel 4)    : 1.3509 mW / 1.31 dBm
 Transmit avg optical power (Channel 5)    : 1.3193 mW / 1.20 dBm
 Transmit avg optical power (Channel 6)    : 1.3314 mW / 1.24 dBm
 Transmit avg optical power (Channel 7)    : 1.3042 mW / 1.15 dBm
 Transmit avg optical power (Channel 8)    : 1.3919 mW / 1.44 dBm
 Transmit avg optical power (Channel 9)    : 1.3690 mW / 1.36 dBm
 Transmit avg optical power (Channel 10)   : 1.3036 mW / 1.15 dBm
 Transmit avg optical power (Channel 11)   : 1.3358 mW / 1.26 dBm
 Transmit avg optical power (Channel 12)   : 1.3509 mW / 1.31 dBm
 Transmit avg optical power (Channel 13)   : 1.3193 mW / 1.20 dBm
 Transmit avg optical power (Channel 14)   : 1.3314 mW / 1.24 dBm
 Transmit avg optical power (Channel 15)   : 1.3042 mW / 1.15 dBm
 Transmit avg optical power (Channel 16)   : 1.3919 mW / 1.44 dBm
 Rcvr signal avg optical power (Channel 1) : 1.1299 mW / 0.53 dBm
 Rcvr signal avg optical power (Channel 2) : 1.1566 mW / 0.63 dBm
 Rcvr signal avg optical power (Channel 3) : 1.1484 mW / 0.60 dBm
 Rcvr signal avg optical power (Channel 4) : 1.1655 mW / 0.67 dBm
 Rcvr signal avg optical power (Channel 5) : 1.1751 mW / 0.70 dBm
 Rcvr signal avg optical power (Channel 6) : 1.1595 mW / 0.64 dBm
 Rcvr signal avg optical power (Channel 7) : 1.1158 mW / 0.48 dBm
 Rcvr signal avg optical power (Channel 8) : 1.1595 mW / 0.64 dBm
 Rcvr signal avg optical power (Channel 9) : 1.1299 mW / 0.53 dBm
 Rcvr signal avg optical power (Channel 10) : 1.1566 mW / 0.63 dBm
 Rcvr signal avg optical power (Channel 11) : 1.1484 mW / 0.60 dBm
 Rcvr signal avg optical power (Channel 12) : 1.1655 mW / 0.67 dBm
 Rcvr signal avg optical power (Channel 13) : 1.1751 mW / 0.70 dBm
 Rcvr signal avg optical power (Channel 14) : 1.1595 mW / 0.64 dBm
 Rcvr signal avg optical power (Channel 15) : 1.1158 mW / 0.48 dBm
 Rcvr signal avg optical power (Channel 16) : 1.1595 mW / 0.64 dBm

In the above example, the LowPwrRequestHW signal is ignored and low
power mode is controlled via software only.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 cmis.c | 15 +++++++++++++++
 cmis.h |  5 +++++
 2 files changed, 20 insertions(+)

diff --git a/cmis.c b/cmis.c
index a32cc9f8b1f6..d0b62728e998 100644
--- a/cmis.c
+++ b/cmis.c
@@ -470,6 +470,20 @@ static void cmis_show_mod_fault_cause(const struct cmis_memory_map *map)
 	}
 }
 
+/* Print the current Module-Level Controls. Relevant documents:
+ * [1] CMIS Rev. 5, pag. 58, section 6.3.2.2, Table 6-12
+ * [2] CMIS Rev. 5, pag. 111, section 8.2.6, Table 8-10
+ */
+static void cmis_show_mod_lvl_controls(const struct cmis_memory_map *map)
+{
+	printf("\t%-41s : ", "LowPwrAllowRequestHW");
+	printf("%s\n", ONOFF(map->lower_memory[CMIS_MODULE_CONTROL_OFFSET] &
+			     CMIS_LOW_PWR_ALLOW_REQUEST_HW_MASK));
+	printf("\t%-41s : ", "LowPwrRequestSW");
+	printf("%s\n", ONOFF(map->lower_memory[CMIS_MODULE_CONTROL_OFFSET] &
+			     CMIS_LOW_PWR_REQUEST_SW_MASK));
+}
+
 static void cmis_parse_dom_power_type(const struct cmis_memory_map *map,
 				      struct sff_diags *sd)
 {
@@ -845,6 +859,7 @@ static void cmis_show_all_common(const struct cmis_memory_map *map)
 	cmis_show_rev_compliance(map);
 	cmis_show_mod_state(map);
 	cmis_show_mod_fault_cause(map);
+	cmis_show_mod_lvl_controls(map);
 	cmis_show_dom(map);
 }
 
diff --git a/cmis.h b/cmis.h
index 2c67ad5640ab..46797081f13c 100644
--- a/cmis.h
+++ b/cmis.h
@@ -36,6 +36,11 @@
 #define CMIS_CURR_TEMP_OFFSET			0x0E
 #define CMIS_CURR_VCC_OFFSET			0x10
 
+/* Module Global Controls (Page 0) */
+#define CMIS_MODULE_CONTROL_OFFSET		0x1A
+#define CMIS_LOW_PWR_ALLOW_REQUEST_HW_MASK	0x40
+#define CMIS_LOW_PWR_REQUEST_SW_MASK		0x10
+
 /* Module Fault Information (Page 0) */
 #define CMIS_MODULE_FAULT_OFFSET		0x29
 #define CMIS_MODULE_FAULT_NO_FAULT		0x00
-- 
2.31.1

