Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 569C33F087E
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 17:53:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240199AbhHRPxr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 11:53:47 -0400
Received: from new1-smtp.messagingengine.com ([66.111.4.221]:37745 "EHLO
        new1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240230AbhHRPx3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Aug 2021 11:53:29 -0400
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailnew.nyi.internal (Postfix) with ESMTP id 37416582FD7;
        Wed, 18 Aug 2021 11:52:54 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Wed, 18 Aug 2021 11:52:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=XBGo4GBrYTmE2bNIhoYhVhdFTYvw+rt1WFuSE824Yrs=; b=TJjUfEkG
        GPVSQFvfWnQU+0YPe/mwOonOW6uiH0JzGmLHmUpV2IkNzrf1fEhv/mW5XzlVNqao
        b47WavSFMT0VWd4OL01rVGBLO56RX3qJ6wXf+RkUO379Uj4hxYECJWcHG0NMrGIE
        cafeexRdkN6Q5WCxNLhVfR/qK4Zy8spGtEgl1dvw7hpY/TVP77xtxtg4bVsts7I0
        WEoxFDH/Qcz2pwTTilZMgPfyRVtsfq23QOS+1EWCzIMqNWF8774mARqaPvjU31lY
        9oZTBP0umTKoM6SYK8sa96p9FwrfenbETorYXwkpGhaiB7zn+FweIwYNRhpYQbRg
        5j6xN04e/GbQfQ==
X-ME-Sender: <xms:1iwdYQLwtaxrsB43mzfcy4AzrB01t-rc7FP8gEsyLWswKYxBG5yKNA>
    <xme:1iwdYQIZ50SkSS8224DhGwIhyJjb8PYa046aVAsYp8fyRt5DN0P0NhwnOisizg_MH
    lRzsKxrrSWlOCQ>
X-ME-Received: <xmr:1iwdYQvKFbh_YkNBxBTKTdMN6QangLUlHPNDFVt5W2avNR3E9HoVy6jOCfINjDGhjsG5PjuWE5d6VDwkLOgDidLMPWDvyHHwXCA-2_Q4uggswQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrleehgdelfecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhfekhe
    fgtdfftefhledvjefggfehgfevjeekhfenucevlhhushhtvghrufhiiigvpedunecurfgr
    rhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:1iwdYdZU1AV4B8w9zJq3jpqLRe5fLalt2ZnkT_L9bnbhvz5TctAYDA>
    <xmx:1iwdYXYnLEUO4fA_Oor3fQ85rPMvqh2kQY7r6L6Gc7USCt0ou-x9OA>
    <xmx:1iwdYZBt71TTq_GRe8SGT0Pf6sd8mopoJ7B5z-yrRFLBPvfKzzk4tA>
    <xmx:1iwdYVNLx81JpiPV3PM54HXky-_KxY6DsTHGEtonWJD6xCNn4zX0NA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 18 Aug 2021 11:52:51 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        mkubecek@suse.cz, pali@kernel.org, jacob.e.keller@intel.com,
        jiri@nvidia.com, vadimp@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [RFC PATCH net-next v2 5/6] ethtool: Add transceiver module extended states
Date:   Wed, 18 Aug 2021 18:52:01 +0300
Message-Id: <20210818155202.1278177-6-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210818155202.1278177-1-idosch@idosch.org>
References: <20210818155202.1278177-1-idosch@idosch.org>
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

Example:

 # ethtool --set-module swp13 power-mode-policy low

 # ip link set dev swp13 up

 $ ethtool swp13
 ...
 Link detected: no (Module, Module is in low power mode)

 # ip link set dev swp13 down

 # ethtool --set-module swp13 power-mode-policy high-on-up

 # ip link set dev swp13 up

 $ ethtool swp13
 ...
 Link detected: yes

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
index 54a704370bfc..2dcf3d4e4dd4 100644
--- a/Documentation/networking/ethtool-netlink.rst
+++ b/Documentation/networking/ethtool-netlink.rst
@@ -523,6 +523,8 @@ Link extended states:
                                                         power required from cable or module
 
   ``ETHTOOL_LINK_EXT_STATE_OVERHEAT``                   The module is overheated
+
+  ``ETHTOOL_LINK_EXT_STATE_MODULE``                     Transceiver module issue
   ================================================      ============================================
 
 Link extended substates:
@@ -608,6 +610,16 @@ Link extended substates:
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
index 0a52ee560c3a..ec2518e9d4e3 100644
--- a/include/uapi/linux/ethtool.h
+++ b/include/uapi/linux/ethtool.h
@@ -603,6 +603,7 @@ enum ethtool_link_ext_state {
 	ETHTOOL_LINK_EXT_STATE_CALIBRATION_FAILURE,
 	ETHTOOL_LINK_EXT_STATE_POWER_BUDGET_EXCEEDED,
 	ETHTOOL_LINK_EXT_STATE_OVERHEAT,
+	ETHTOOL_LINK_EXT_STATE_MODULE,
 };
 
 /* More information in addition to ETHTOOL_LINK_EXT_STATE_AUTONEG. */
@@ -647,6 +648,12 @@ enum ethtool_link_ext_substate_cable_issue {
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

