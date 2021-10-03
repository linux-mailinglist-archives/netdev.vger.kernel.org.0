Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 200A442007C
	for <lists+netdev@lfdr.de>; Sun,  3 Oct 2021 09:34:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229939AbhJCHgC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Oct 2021 03:36:02 -0400
Received: from new2-smtp.messagingengine.com ([66.111.4.224]:41911 "EHLO
        new2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229914AbhJCHft (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Oct 2021 03:35:49 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id 94E99580E3F;
        Sun,  3 Oct 2021 03:34:02 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sun, 03 Oct 2021 03:34:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=ThklMO8SG7PEU6n5YuJBmvEtglgUEieU7AhvsApRfeE=; b=SkoQvBKB
        BIKmHnD7AQCZlG7sJb3LgT2BAAzh8Xi2+qa6WZEuDHYaAE9ctPRT3JVlpNBOkAZl
        hKbJSgA/i0bQX1xwX894vRDoDuZBdzEpUXd8SGTHWt13YhgwRT75/qJjWHyziTdK
        rRToiZlH9ILeerC8DmAl9JlxwgHg+LU8ncR6biP5d6Tmz9GL3H84cH9/OEl2rSzZ
        TnZwrfunL6zOzQcSjwLfQ/6q8WmM6epYdD2/07kmloIIb/r12qTve4MklNDJHs1w
        H1/7mdTIiHoSz7tiAAgGN/oBs5sViMnyQw9mxY61WrdYUkhBX9IxqNkzKhH5n3mV
        Oun0jKfmoEphVQ==
X-ME-Sender: <xms:6lxZYe58s60wSG_vm7WIGgUNN5eq7IBW6i5u32lGZDVc4wr5utQ5Jg>
    <xme:6lxZYX4hCA__SeRjjy391ZFb2DmE0ykzsy1cVHVyX24JNsIqjTNWQZgnX1pWpkVnN
    H0nQorcAb4mC0M>
X-ME-Received: <xmr:6lxZYdfOFdBUArz421eHp4xYyPxTgmjQQgdvjvPYbYm1VB3kYmALsKF5sHkF73OQzpQpAtSiuBTKB0gd8YIeMNOkeafqCFROSp99fKE_5vqQbA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrudekledguddulecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhf
    ekhefgtdfftefhledvjefggfehgfevjeekhfenucevlhhushhtvghrufhiiigvpedunecu
    rfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:6lxZYbKnNZZR1KrUOA3ToRUtjxqiGZiNnEMJSudDOfy26gTu7wF0YQ>
    <xmx:6lxZYSIX3llCnK5gM5izD1jBW7foQwKaF49IDgc0KLqe1i_v8C4h3w>
    <xmx:6lxZYcwBlxwlZekhUobnrXdOVJRr_k98cYD-LAGLgXGlEUPijgSHSQ>
    <xmx:6lxZYR8bQpLEpM7Hlju15fq3EGjaboaPlcDY1mo4V5bJD3DhgVMuTA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 3 Oct 2021 03:33:59 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        mkubecek@suse.cz, pali@kernel.org, jacob.e.keller@intel.com,
        jiri@nvidia.com, vadimp@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 5/6] ethtool: Add transceiver module extended state
Date:   Sun,  3 Oct 2021 10:32:18 +0300
Message-Id: <20211003073219.1631064-6-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211003073219.1631064-1-idosch@idosch.org>
References: <20211003073219.1631064-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Add an extended state and sub-state to describe link issues related to
transceiver modules.

The 'ETHTOOL_LINK_EXT_SUBSTATE_MODULE_CMIS_NOT_READY' extended sub-state
tells user space that port is unable to gain a carrier because the CMIS
Module State Machine did not reach the ModuleReady (Fully Operational)
state. For example, if the module is stuck at ModuleLowPwr or
ModuleFault state. In case of the latter, user space can read the fault
reason from the module's EEPROM and potentially reset it.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 Documentation/networking/ethtool-netlink.rst | 10 ++++++++++
 include/linux/ethtool.h                      |  1 +
 include/uapi/linux/ethtool.h                 |  6 ++++++
 3 files changed, 17 insertions(+)

diff --git a/Documentation/networking/ethtool-netlink.rst b/Documentation/networking/ethtool-netlink.rst
index d6fd4b2e243c..7b598c7e3912 100644
--- a/Documentation/networking/ethtool-netlink.rst
+++ b/Documentation/networking/ethtool-netlink.rst
@@ -528,6 +528,8 @@ Link extended states:
                                                         power required from cable or module
 
   ``ETHTOOL_LINK_EXT_STATE_OVERHEAT``                   The module is overheated
+
+  ``ETHTOOL_LINK_EXT_STATE_MODULE``                     Transceiver module issue
   ================================================      ============================================
 
 Link extended substates:
@@ -621,6 +623,14 @@ Link extended substates:
   ``ETHTOOL_LINK_EXT_SUBSTATE_CI_CABLE_TEST_FAILURE``   Cable test failure
   ===================================================   ============================================
 
+  Transceiver module issue substates:
+
+  ===================================================   ============================================
+  ``ETHTOOL_LINK_EXT_SUBSTATE_MODULE_CMIS_NOT_READY``   The CMIS Module State Machine did not reach
+                                                        the ModuleReady state. For example, if the
+                                                        module is stuck at ModuleFault state
+  ===================================================   ============================================
+
 DEBUG_GET
 =========
 
diff --git a/include/linux/ethtool.h b/include/linux/ethtool.h
index 9adf8d2c3144..845a0ffc16ee 100644
--- a/include/linux/ethtool.h
+++ b/include/linux/ethtool.h
@@ -94,6 +94,7 @@ struct ethtool_link_ext_state_info {
 		enum ethtool_link_ext_substate_link_logical_mismatch link_logical_mismatch;
 		enum ethtool_link_ext_substate_bad_signal_integrity bad_signal_integrity;
 		enum ethtool_link_ext_substate_cable_issue cable_issue;
+		enum ethtool_link_ext_substate_module module;
 		u8 __link_ext_substate;
 	};
 };
diff --git a/include/uapi/linux/ethtool.h b/include/uapi/linux/ethtool.h
index a3e763ad1666..1b126e8b5269 100644
--- a/include/uapi/linux/ethtool.h
+++ b/include/uapi/linux/ethtool.h
@@ -603,6 +603,7 @@ enum ethtool_link_ext_state {
 	ETHTOOL_LINK_EXT_STATE_CALIBRATION_FAILURE,
 	ETHTOOL_LINK_EXT_STATE_POWER_BUDGET_EXCEEDED,
 	ETHTOOL_LINK_EXT_STATE_OVERHEAT,
+	ETHTOOL_LINK_EXT_STATE_MODULE,
 };
 
 /* More information in addition to ETHTOOL_LINK_EXT_STATE_AUTONEG. */
@@ -649,6 +650,11 @@ enum ethtool_link_ext_substate_cable_issue {
 	ETHTOOL_LINK_EXT_SUBSTATE_CI_CABLE_TEST_FAILURE,
 };
 
+/* More information in addition to ETHTOOL_LINK_EXT_STATE_MODULE. */
+enum ethtool_link_ext_substate_module {
+	ETHTOOL_LINK_EXT_SUBSTATE_MODULE_CMIS_NOT_READY = 1,
+};
+
 #define ETH_GSTRING_LEN		32
 
 /**
-- 
2.31.1

