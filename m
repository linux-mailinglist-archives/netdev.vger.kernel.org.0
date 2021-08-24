Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF79A3F5EA7
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 15:06:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237452AbhHXNGh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 09:06:37 -0400
Received: from new3-smtp.messagingengine.com ([66.111.4.229]:52591 "EHLO
        new3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237539AbhHXNGf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Aug 2021 09:06:35 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id AFF3C580B21;
        Tue, 24 Aug 2021 09:05:50 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Tue, 24 Aug 2021 09:05:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=DlZphT4WJkAFNXjv52U0aaeNvJwGwWQwNe2FmH2RQ7M=; b=DFGlOe4d
        sAnatNnZuqr2N1cNkXENyQtGdBQcl+BTNGYVH1SUENU6fRxXn9bGdtyB4Yojvska
        hcOWDlb1SnbhyVYQ6PQhnKaPqHM/0z4eiifj2w141TNsCHwWYXnI4itE1LZlG9fh
        ZQHaIecQrX87Quk1j/msXPi/OheB6jDPqDX2AI3xN9Lb13ps3+rhWKer1aPdE5QB
        HcxXuIdlpWFl4PdsTMdcvZI5qKjLZZCFozsXOPBZSuIKbG5+58sjSCUdWf8f9viZ
        9sB+Dre+Vl4lpY+Qi9wk/B5k3J25uHycZYgs3wRk4+LL46gQL07e4cbjUgOLdLru
        yAYj+YMRxvKbPA==
X-ME-Sender: <xms:re4kYXEii41XkJQ8GzDuJcdmufrGoIxwj4e-vPakYP1wer3v7JflVQ>
    <xme:re4kYUVMUUsvLBnlmsoqHFS5qlzn8D8miWZ4aVIg_O16-txxWITqV6_hPRqWYQLbB
    m3ujRM3KBZ6TBw>
X-ME-Received: <xmr:re4kYZLPHzlQyRFHg36l6S_kjO_nHFuLYWrG6-mzcSF-a4Pv2wbKjQ6S921181J8t4x2YZgVhPiOOJISP5JiXZtkd0HtPLQQRp8rvET5wSIFqw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddruddtjedgiedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecuvehluhhsthgvrhfuihiivgepvdenucfr
    rghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:re4kYVH5gyL_pk_p1co2KcZVUlrevW-vKRJbSRjsqmdx6xEeZTTzrw>
    <xmx:re4kYdWxH5V-3P6u1uvaG-VIu0wSzuvCl5vPNQp3nw9Btc73fXMABQ>
    <xmx:re4kYQOyhh8NTJ8OJn2vB6y17L-r96Jis-meZQGOCGMKdyqFn3zDCQ>
    <xmx:ru4kYZrAicbwM0ok3kZY05C0IWXWRhXGVxczYckF2gJo3JwY6Yk1Jg>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 24 Aug 2021 09:05:46 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        mkubecek@suse.cz, pali@kernel.org, jacob.e.keller@intel.com,
        jiri@nvidia.com, vadimp@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [RFC PATCH ethtool-next v3 4/6] ethtool: Print CMIS Module-Level Controls
Date:   Tue, 24 Aug 2021 16:05:13 +0300
Message-Id: <20210824130515.1828270-5-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210824130515.1828270-1-idosch@idosch.org>
References: <20210824130515.1828270-1-idosch@idosch.org>
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

 # ethtool --set-module swp11 power-mode-policy auto

 # ethtool -m swp11
 Identifier                                : 0x18 (QSFP-DD Double Density 8X Pluggable Transceiver (INF-8628))
 ...
 Module State                              : 0x01 (ModuleLowPwr)
 LowPwrAllowRequestHW                      : Off
 LowPwrRequestSW                           : On

 # ethtool --set-module swp11 power-mode-policy high

 # ethtool -m swp11
 Identifier                                : 0x18 (QSFP-DD Double Density 8X Pluggable Transceiver (INF-8628))
 ...
 Module State                              : 0x03 (ModuleReady)
 LowPwrAllowRequestHW                      : Off
 LowPwrRequestSW                           : Off

In the above example, the LowPwrRequestHW signal is ignored and low
power mode is controlled via software only.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 cmis.c | 16 ++++++++++++++++
 cmis.h |  5 +++++
 2 files changed, 21 insertions(+)

diff --git a/cmis.c b/cmis.c
index c5c1f02398f6..cd1c7d6e83c9 100644
--- a/cmis.c
+++ b/cmis.c
@@ -108,6 +108,20 @@ static void cmis_show_mod_fault_cause(const __u8 *id)
 	}
 }
 
+/*
+ * Print the current Module-Level Controls. Relevant documents:
+ * [1] CMIS Rev. 5, pag. 58, section 6.3.2.2, Table 6-12
+ * [2] CMIS Rev. 5, pag. 111, section 8.2.6, Table 8-10
+ */
+static void cmis_show_mod_lvl_controls(const __u8 *id)
+{
+	printf("\t%-41s : ", "LowPwrAllowRequestHW");
+	printf("%s\n", ONOFF(id[CMIS_MODULE_CONTROL_OFFSET] &
+			     CMIS_LOW_PWR_ALLOW_REQUEST_HW));
+	printf("\t%-41s : ", "LowPwrRequestSW");
+	printf("%s\n", ONOFF(id[CMIS_MODULE_CONTROL_OFFSET] &
+			     CMIS_LOW_PWR_REQUEST_SW));
+}
 
 /**
  * Print information about the device's power consumption.
@@ -405,6 +419,7 @@ void qsfp_dd_show_all(const __u8 *id)
 	cmis_show_rev_compliance(id);
 	cmis_show_mod_state(id);
 	cmis_show_mod_fault_cause(id);
+	cmis_show_mod_lvl_controls(id);
 }
 
 void cmis_show_all(const struct ethtool_module_eeprom *page_zero,
@@ -427,4 +442,5 @@ void cmis_show_all(const struct ethtool_module_eeprom *page_zero,
 	cmis_show_rev_compliance(page_zero_data);
 	cmis_show_mod_state(page_zero_data);
 	cmis_show_mod_fault_cause(page_zero_data);
+	cmis_show_mod_lvl_controls(page_zero_data);
 }
diff --git a/cmis.h b/cmis.h
index 41383132cf8e..41288d4e88bc 100644
--- a/cmis.h
+++ b/cmis.h
@@ -28,6 +28,11 @@
 #define CMIS_CURR_TEMP_OFFSET			0x0E
 #define CMIS_CURR_CURR_OFFSET			0x10
 
+/* Module-Level Controls (Page 0) */
+#define CMIS_MODULE_CONTROL_OFFSET		0x1A
+#define CMIS_LOW_PWR_ALLOW_REQUEST_HW		(1 << 6)
+#define CMIS_LOW_PWR_REQUEST_SW			(1 << 4)
+
 #define CMIS_CTOR_OFFSET			0xCB
 
 /* Vendor related information (Page 0) */
-- 
2.31.1

