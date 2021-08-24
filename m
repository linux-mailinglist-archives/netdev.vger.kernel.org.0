Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74D093F5EA0
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 15:05:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237495AbhHXNFi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 09:05:38 -0400
Received: from new3-smtp.messagingengine.com ([66.111.4.229]:48389 "EHLO
        new3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237470AbhHXNFe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Aug 2021 09:05:34 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id C99515803E9;
        Tue, 24 Aug 2021 09:04:49 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Tue, 24 Aug 2021 09:04:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=PF6mVx16rimKKOC+b+uNYjnoT9ynubRMQrM0kk6CEOI=; b=rbeeLRiD
        8gjPHNceCKVsY/53eoDyThzIhd98xYvpCRGge9IuebMX4XGZSsSgQH9FbyZkjO9k
        TS7zeor5u/6u0VT5zFNLIk75Wa2rKstGTDXBBVsnsf/t31ywByhkL/YYhdwJbZeP
        XnTnq9Hs3hcpR3/e1z9fp+EPR5FpFFro0GaaOpAIzTUEHx2gQ0T0p7YplfZiNgeI
        yk9zL7XpQ3hgorNf6jKrB1F6CwwWVewz3gP2arlJVAQzNyZ0iF9e1QKyYFKZZPR8
        8yybcxN9zbDYcRKhYViPVvOPPmS+lgrh8bT7KMfgSnK3lsKs6wFjMvaUv7fYSBpp
        HmNkvfbWt9E4dA==
X-ME-Sender: <xms:cO4kYVKmERqRqcATG20CZK_A_ajH812IjwVg-B4fo-X_9opEQVZk8g>
    <xme:cO4kYRKZf6ypakAxw8_2Fgw1l3fJjveSafPXdSmsHdMNv3pYPfiNGA6ML4QIanT4w
    x4U1VYdMdWHawc>
X-ME-Received: <xmr:cO4kYduw0sXQkMIDKIHAVAbjbr1KRkNN8rKq5INwwjKkNfJEUQ5meoo8yGJd6X6v3QoVB85RtZf7M55VD1xWNN-2g6Lj0A-RsXXTAHGLy6UBZw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddruddtjedgiedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecuvehluhhsthgvrhfuihiivgeptdenucfr
    rghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:cO4kYWZ7Yb6o7OImvGpFDmYLuxloeb7TDg1ZLlChtz8iAs2m-r0sGA>
    <xmx:cO4kYcbyqhZOatq-GOh9s68WNkkXRgbTwB_wGqXj_0_mlXdT04Fj5Q>
    <xmx:cO4kYaDeVUBkJeS2MeYXpAL0jyYtVi_RPse5KXKgtriKM8PPmztuYQ>
    <xmx:ce4kYSOGy1pTGy99zvTIqMjSj80YzlGyC7dMxMIXojU64JwYQQrSQg>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 24 Aug 2021 09:04:45 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        mkubecek@suse.cz, pali@kernel.org, jacob.e.keller@intel.com,
        jiri@nvidia.com, vadimp@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [RFC PATCH net-next v3 5/6] ethtool: Add transceiver module extended states
Date:   Tue, 24 Aug 2021 16:03:43 +0300
Message-Id: <20210824130344.1828076-6-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210824130344.1828076-1-idosch@idosch.org>
References: <20210824130344.1828076-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Add an extended state and two extended sub-states to describe link
issues related to transceiver modules.

The first, 'ETHTOOL_LINK_EXT_SUBSTATE_MODULE_LOW_POWER_MODE', tells user
space that port is unable to gain a carrier because the associated
transceiver module is in low power mode where the data path is
deactivated. This is applicable to both SFF-8636 and CMIS modules.
Currently, user space cannot force a module to stay in low power mode
while putting the associated port administratively up, so the extended
sub-state is indicative of a problem in the module/driver.

The second, 'ETHTOOL_LINK_EXT_SUBSTATE_MODULE_CMIS_NOT_READY', tells
user space that port is unable to gain a carrier because the CMIS Module
State Machine did not reach the ModuleReady (Fully Operational) state.
For example, if the module is stuck at ModuleFault state. In which case,
user space can read the fault reason from the module's EEPROM and
potentially reset it.

For CMIS modules, the first extended sub-state is contained in the
second, but has the added advantage of being applicable to more module
types and being more specific about the nature of the problem.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 Documentation/networking/ethtool-netlink.rst | 12 ++++++++++++
 include/linux/ethtool.h                      |  1 +
 include/uapi/linux/ethtool.h                 |  7 +++++++
 3 files changed, 20 insertions(+)

diff --git a/Documentation/networking/ethtool-netlink.rst b/Documentation/networking/ethtool-netlink.rst
index 245ce2eab9a5..c258b3f30a2e 100644
--- a/Documentation/networking/ethtool-netlink.rst
+++ b/Documentation/networking/ethtool-netlink.rst
@@ -523,6 +523,8 @@ Link extended states:
                                                         power required from cable or module
 
   ``ETHTOOL_LINK_EXT_STATE_OVERHEAT``                   The module is overheated
+
+  ``ETHTOOL_LINK_EXT_STATE_MODULE``                     Transceiver module issue
   ================================================      ============================================
 
 Link extended substates:
@@ -616,6 +618,16 @@ Link extended substates:
   ``ETHTOOL_LINK_EXT_SUBSTATE_CI_CABLE_TEST_FAILURE``   Cable test failure
   ===================================================   ============================================
 
+  Transceiver module issue substates:
+
+  ===================================================   ============================================
+  ``ETHTOOL_LINK_EXT_SUBSTATE_MODULE_LOW_POWER_MODE``   The transceiver module is in low power mode
+
+  ``ETHTOOL_LINK_EXT_SUBSTATE_MODULE_CMIS_NOT_READY``   The CMIS Module State Machine did not reach
+                                                        the ModuleReady state. For example, if the
+                                                        module is stuck at ModuleFault state
+  ===================================================   ============================================
+
 DEBUG_GET
 =========
 
diff --git a/include/linux/ethtool.h b/include/linux/ethtool.h
index 07d40dc20ca4..1f71293011ca 100644
--- a/include/linux/ethtool.h
+++ b/include/linux/ethtool.h
@@ -93,6 +93,7 @@ struct ethtool_link_ext_state_info {
 		enum ethtool_link_ext_substate_link_logical_mismatch link_logical_mismatch;
 		enum ethtool_link_ext_substate_bad_signal_integrity bad_signal_integrity;
 		enum ethtool_link_ext_substate_cable_issue cable_issue;
+		enum ethtool_link_ext_substate_module module;
 		u8 __link_ext_substate;
 	};
 };
diff --git a/include/uapi/linux/ethtool.h b/include/uapi/linux/ethtool.h
index 8cc79811ee5d..7d453f0e993b 100644
--- a/include/uapi/linux/ethtool.h
+++ b/include/uapi/linux/ethtool.h
@@ -603,6 +603,7 @@ enum ethtool_link_ext_state {
 	ETHTOOL_LINK_EXT_STATE_CALIBRATION_FAILURE,
 	ETHTOOL_LINK_EXT_STATE_POWER_BUDGET_EXCEEDED,
 	ETHTOOL_LINK_EXT_STATE_OVERHEAT,
+	ETHTOOL_LINK_EXT_STATE_MODULE,
 };
 
 /* More information in addition to ETHTOOL_LINK_EXT_STATE_AUTONEG. */
@@ -649,6 +650,12 @@ enum ethtool_link_ext_substate_cable_issue {
 	ETHTOOL_LINK_EXT_SUBSTATE_CI_CABLE_TEST_FAILURE,
 };
 
+/* More information in addition to ETHTOOL_LINK_EXT_STATE_MODULE. */
+enum ethtool_link_ext_substate_module {
+	ETHTOOL_LINK_EXT_SUBSTATE_MODULE_LOW_POWER_MODE = 1,
+	ETHTOOL_LINK_EXT_SUBSTATE_MODULE_CMIS_NOT_READY,
+};
+
 #define ETH_GSTRING_LEN		32
 
 /**
-- 
2.31.1

