Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 985533F0899
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 17:55:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240217AbhHRP4O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 11:56:14 -0400
Received: from new1-smtp.messagingengine.com ([66.111.4.221]:41027 "EHLO
        new1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239949AbhHRPyL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Aug 2021 11:54:11 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailnew.nyi.internal (Postfix) with ESMTP id 18549583009;
        Wed, 18 Aug 2021 11:53:36 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Wed, 18 Aug 2021 11:53:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=cBUUfoCrOivPh/vUS9TR87zPyMogoA73h5QwCRBB6j0=; b=U1RgdVWk
        ecq8DCIVjN59ORQ9ho4PxTiGLcn6t184AYIOgkF0yuqFxA5iRQyPRnpahWhCcM2d
        Nza0qMS1LlRo42GGkY6V1Efjw/mPHLMOy1kQ2cYL81+44tlmuZn2sL5M7hBaSEsx
        +LWUKMP+lbqGL1miyiDjRaBANeSZ5XRBDnth7OtnH9PLKXC6DRd+9hDEiJqwGeGg
        svLuaR4p8euPaO5t0YziEO34M/RVHf5gY7Ck3LMUA9FqA3e3XWV7Z9ZQFJ9BANcm
        QSv4xbOiXNmHJqHUhlLdaG6aAgqEWvN1YTTIDsJOVl3955wnZkcIWLLxIvBeum2V
        GfviX7DrqKAeyg==
X-ME-Sender: <xms:_ywdYYiF9_eQDbc59vSt8oE2-f8Lz3y-D3lKKjLhNBXFRl8Q8YjZ2A>
    <xme:_ywdYRAnskdNZ1Fk7IM_FbGOg4P1dA_75Hp3974vHMhdD1t3_eyC3524cnu0CjD9T
    3ijpDLlKidgwkA>
X-ME-Received: <xmr:_ywdYQFaE3CmQkZG1c6niTx9RM66HkcHRMUJpXBCjxJ1YjSxNjlsjpOAYl6fKJY4JF-aJP-7I9b3B_lMJOMgkAytFjAMgl2b41TrnjCcqs9nyQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrleehgdelfecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhfekhe
    fgtdfftefhledvjefggfehgfevjeekhfenucevlhhushhtvghrufhiiigvpedtnecurfgr
    rhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:_ywdYZSk6TYpgeClzQh-dfSiEky2V1hKQbC9-37x-2BqTsvemvdc0g>
    <xmx:_ywdYVzPC5hHfc1Ck385XlrzuKFDt4c7SVkEZEZ6ElwyfDagN4usZw>
    <xmx:_ywdYX6OCsu8EPzn0LBjZHVy3ZcMioytO9Pej4sK3X57b1h4HKu2Xg>
    <xmx:AC0dYcnEwPtZ9-NVh-FpqYeWb37fV8K-dnffDGG2hdnbj0yqxmlafA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 18 Aug 2021 11:53:32 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        mkubecek@suse.cz, pali@kernel.org, jacob.e.keller@intel.com,
        jiri@nvidia.com, vadimp@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [RFC PATCH ethtool-next v2 4/6] ethtool: Print CMIS Module-Level Controls
Date:   Wed, 18 Aug 2021 18:53:04 +0300
Message-Id: <20210818155306.1278356-5-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210818155306.1278356-1-idosch@idosch.org>
References: <20210818155306.1278356-1-idosch@idosch.org>
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

 # ethtool --set-module swp11 power-mode-policy low

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

