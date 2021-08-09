Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C41A3E43E4
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 12:24:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235031AbhHIKYN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 06:24:13 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:42387 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234952AbhHIKXv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Aug 2021 06:23:51 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id D367F5C00DC;
        Mon,  9 Aug 2021 06:23:30 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 09 Aug 2021 06:23:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=C6Q9o8UsvFAF2AjFF9MWegxvzWIjheShEtj9ZibZ9dM=; b=eWHVHCrO
        qL+/bYfVFCtqYcXOD03vm8GnDhF0V5MFUMZhmL2voB0jALJJvts6lJgrAMEc+vp/
        vy2zKRdg61tEExOrKWuOT86aacldQCcQYD/eDBjmjC9RUo0nUrqd/U2fVfEEFKXE
        FlOHksXUrZmp0DQu+hlIdzuhZU0SiTqorJ6Ff4g0nlIUwdJzpIzNhtaGRy+qcFrf
        jc+F9Ydp6coYhWquzxqQY4q/MBvp0BCxgbWqISuw0FhmybH32J8dybHbGtYbl5jF
        uYlhBud55ni9QdHUkoz9OU/VBgYi0XbXE1iHeOO5f80XJcu5wwq4nUOAX+UcI7vO
        SoezvKR2kzJHxw==
X-ME-Sender: <xms:IgIRYTWDLSoV6sW24WlLauAO2qzRgX9KRacCipiGJb54xJtu2TIndQ>
    <xme:IgIRYbmXFAzcL07SvNVLAz29BIFR1aDWpYdn3HD7BX2505_JBT8rFmxxdpG3nl5Zr
    yqI8IlMS2A2qm4>
X-ME-Received: <xmr:IgIRYfYnAenwzGII21CMUKT3U_YnV0E9hxv4T_c0A49-ZBpAS87V60OYJZA4WrdgnPoror4EUgq_yjDVfqbZnlf7u0G9U5xzKGoK_WzY7oN52g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrjeejgddvkecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhfekhe
    fgtdfftefhledvjefggfehgfevjeekhfenucevlhhushhtvghrufhiiigvpedvnecurfgr
    rhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:IgIRYeVzEK-PKRvjOScVAxq6i75Udo-HAVjU5bLHcRKjmK_vas7gnA>
    <xmx:IgIRYdnagPuK_NapC_vCfl1z5z-F9KyFzuMWQu5u2Wj2wFvIw3182g>
    <xmx:IgIRYbfAbklRVe0dX4E5KG8UE8kEIWQqFhHpC6WnO60hL4ASoGp3Zg>
    <xmx:IgIRYbYfBhD_KnyiL9MdVuhyqHjlC-y2Z_tCOoKecsu98ezhE7fZJw>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 9 Aug 2021 06:23:28 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        mkubecek@suse.cz, pali@kernel.org, vadimp@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [RFC PATCH ethtool-next 4/6] ethtool: Print CMIS Module-Level Controls
Date:   Mon,  9 Aug 2021 13:22:54 +0300
Message-Id: <20210809102256.720119-5-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210809102256.720119-1-idosch@idosch.org>
References: <20210809102256.720119-1-idosch@idosch.org>
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

 # ethtool --set-module swp11 low-power on

 # ethtool -m swp11
 Identifier                                : 0x18 (QSFP-DD Double Density 8X Pluggable Transceiver (INF-8628))
 ...
 Module State                              : 0x01 (ModuleLowPwr)
 LowPwrAllowRequestHW                      : Off
 LowPwrRequestSW                           : On

 # ethtool --set-module swp11 low-power off

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
 cmis.c | 17 +++++++++++++++++
 cmis.h |  5 +++++
 2 files changed, 22 insertions(+)

diff --git a/cmis.c b/cmis.c
index f09219fd889d..f9b4720e6c2c 100644
--- a/cmis.c
+++ b/cmis.c
@@ -75,6 +75,21 @@ static void cmis_show_mod_state(const __u8 *id)
 	}
 }
 
+/**
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
+
 /**
  * Print information about the device's power consumption.
  * Relevant documents:
@@ -370,6 +385,7 @@ void qsfp_dd_show_all(const __u8 *id)
 	cmis_show_vendor_info(id);
 	cmis_show_rev_compliance(id);
 	cmis_show_mod_state(id);
+	cmis_show_mod_lvl_controls(id);
 }
 
 void cmis_show_all(const struct ethtool_module_eeprom *page_zero,
@@ -391,4 +407,5 @@ void cmis_show_all(const struct ethtool_module_eeprom *page_zero,
 	cmis_show_vendor_info(page_zero_data);
 	cmis_show_rev_compliance(page_zero_data);
 	cmis_show_mod_state(page_zero_data);
+	cmis_show_mod_lvl_controls(page_zero_data);
 }
diff --git a/cmis.h b/cmis.h
index 197b70a2034d..5a314340eff0 100644
--- a/cmis.h
+++ b/cmis.h
@@ -21,6 +21,11 @@
 #define CMIS_CURR_TEMP_OFFSET			0x0E
 #define CMIS_CURR_CURR_OFFSET			0x10
 
+/* Module-Level Controls (Page 0) */
+#define CMIS_MODULE_CONTROL_OFFSET		0x1A
+#define	 CMIS_LOW_PWR_ALLOW_REQUEST_HW		(1 << 6)
+#define	 CMIS_LOW_PWR_REQUEST_SW		(1 << 4)
+
 #define CMIS_CTOR_OFFSET			0xCB
 
 /* Vendor related information (Page 0) */
-- 
2.31.1

