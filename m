Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEA783E43E2
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 12:24:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234994AbhHIKYC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 06:24:02 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:55913 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234525AbhHIKXs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Aug 2021 06:23:48 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 44D6B5C0105;
        Mon,  9 Aug 2021 06:23:28 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Mon, 09 Aug 2021 06:23:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=IjZT1SsqOGtJZGxhg70Y1bsEMn6b+m15ceItbCbyreU=; b=iiWNkk3/
        1Jo+bCLIXTOhI0z84CDRlfiPlp+RWrfZYvfI9hzqXPHVU42zI4mtQRbtWY0U2v85
        wosCUDz5TS37n1nlbiJWq5TKQn02R3EUBXp6a1NW40La/WkWFphAzvpjhI4GJXS3
        nsqLkdBpbO1IIWhz9bM0XvWZ+LyIVC2wfp+wZ2k4ILywdb6ZUT0YY1NKZ300r3zn
        ecJjO8D5mbQkBGJMALfdbALQOUimLUrsR413niJSSTv8/HJ0xQXtahK4UIjSb2uE
        PFU5uAZTfvJiIb1CI8HZZGKGp16k+SumolYFbA+P0F5wg9bRyq/2ijJNPYngdcV1
        BKFlGTSH7kXvVw==
X-ME-Sender: <xms:IAIRYZuxvpAsQjWAzofUKn7w1wHoOXkokBZvO5aY5CTUc05Y7msMFw>
    <xme:IAIRYSf9nGERDBrG9UcrZ64ooGOJN6U9doeg7NZFOLUNk3eDqguhz5QvxsBv_dMWw
    gOVjGSGEKPTx84>
X-ME-Received: <xmr:IAIRYcwrncSmj67menxADMMeWwuWX0FiGW5L7U2AsDlmIjsLlN9JdavxXYZ7G6MWr7KhvIX9CUyJYoTIqqLOFgmHq2FbYloa7F9Xjwtb-SsJ0w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrjeejgddvkecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhfekhe
    fgtdfftefhledvjefggfehgfevjeekhfenucevlhhushhtvghrufhiiigvpedvnecurfgr
    rhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:IAIRYQNaOHmJ785856cyRtUpX0P4Ma6XVTqAUa6DPzDAwbXHyq_y2w>
    <xmx:IAIRYZ_J5A4GEe4nLQ77pZmYPrme6Ht5PdZUYhCycBp3iIjnBuoQ-Q>
    <xmx:IAIRYQVPCSaVgG1IeU6DLLQbiNFhCljfPkoZ1Go0Zr23MAFlYbym7g>
    <xmx:IAIRYZyzd4P39TV2x5dBjGkiyp-1lOnAQUARcIeHOHHCYwg6NN9KYw>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 9 Aug 2021 06:23:25 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        mkubecek@suse.cz, pali@kernel.org, vadimp@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [RFC PATCH ethtool-next 3/6] ethtool: Print CMIS Module State
Date:   Mon,  9 Aug 2021 13:22:53 +0300
Message-Id: <20210809102256.720119-4-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210809102256.720119-1-idosch@idosch.org>
References: <20210809102256.720119-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Print the CMIS Module State when dumping EEPROM contents via the '-m'
option. It can be used, for example, to test module low power mode
settings.

Example output:

 # ethtool -m swp11
 Identifier                                : 0x18 (QSFP-DD Double Density 8X Pluggable Transceiver (INF-8628))
 ...
 Module State                              : 0x03 (ModuleReady)

 # ethtool --set-module swp11 low-power on

 # ethtool -m swp11
 Identifier                                : 0x18 (QSFP-DD Double Density 8X Pluggable Transceiver (INF-8628))
 ...
 Module State                              : 0x01 (ModuleLowPwr)

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 cmis.c | 35 +++++++++++++++++++++++++++++++++++
 cmis.h |  8 ++++++++
 2 files changed, 43 insertions(+)

diff --git a/cmis.c b/cmis.c
index 361b721f332f..f09219fd889d 100644
--- a/cmis.c
+++ b/cmis.c
@@ -42,6 +42,39 @@ static void cmis_show_rev_compliance(const __u8 *id)
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
 /**
  * Print information about the device's power consumption.
  * Relevant documents:
@@ -336,6 +369,7 @@ void qsfp_dd_show_all(const __u8 *id)
 	cmis_show_link_len(id);
 	cmis_show_vendor_info(id);
 	cmis_show_rev_compliance(id);
+	cmis_show_mod_state(id);
 }
 
 void cmis_show_all(const struct ethtool_module_eeprom *page_zero,
@@ -356,4 +390,5 @@ void cmis_show_all(const struct ethtool_module_eeprom *page_zero,
 
 	cmis_show_vendor_info(page_zero_data);
 	cmis_show_rev_compliance(page_zero_data);
+	cmis_show_mod_state(page_zero_data);
 }
diff --git a/cmis.h b/cmis.h
index 78ee1495bc33..197b70a2034d 100644
--- a/cmis.h
+++ b/cmis.h
@@ -5,6 +5,14 @@
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
 #define CMIS_MODULE_TYPE_OFFSET			0x55
 #define CMIS_MT_MMF				0x01
 #define CMIS_MT_SMF				0x02
-- 
2.31.1

