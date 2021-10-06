Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D54CA423BB2
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 12:47:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238161AbhJFKtg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 06:49:36 -0400
Received: from new1-smtp.messagingengine.com ([66.111.4.221]:50273 "EHLO
        new1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229824AbhJFKta (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Oct 2021 06:49:30 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailnew.nyi.internal (Postfix) with ESMTP id CC75258119B;
        Wed,  6 Oct 2021 06:47:38 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Wed, 06 Oct 2021 06:47:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=2x9/eqTxRAOHFh2iY4pvaKVlAqL/hX0eLZ0ij2Z0brU=; b=IfDwjTLR
        /BCgNB5uIkQ+UpZNOh7oi46ZliNA2MoCUFBoURV7XIAtF36+gK2Eo71kc7EpXwb5
        ea4FaCxXLD2pXtbkmuH/OJLOsYz16pZCuJ49Y6qh8Yw5tnPbHkQR22bvt2w6p7Du
        avjGwnxKAd0rDBeuhJVkpMyDvAdQYlnU5HIE/7yD/qB/Unm2g19KkwTPxGbvjdwO
        RctHRWfihHHhbeOPPF5WqNArFNlEBnqV+XRCn3NxKrdIbd2fIuYyQcfO7ho31sWw
        xiV4E5FdfABSwOYjLcsHgXAED+ArjZ/OHI7o12/aQDQki6FkKwCXl3VvZOf3UbC/
        0TCv3WMntsVKzg==
X-ME-Sender: <xms:yn5dYQH2Bbj6o13wrKC5R8Hy5MIjk1BkkzMr_-rK6lYX_iADqEPESA>
    <xme:yn5dYZXAcKS1Og77Wv-OydAQQm74SQJRbckGE8gGcmUAGXHsQemVpSf49f0u-cC4u
    _yJy81n6-WdRSc>
X-ME-Received: <xmr:yn5dYaI1xAeSk_t1U774_TRsqj7lYFo5YS9f6hQUkZMUglClk1uCO7AEyVSEDmdA0fCsUDHKzK7dgiKwIohWq_JLEwqOXO6WwOZI1uk2WnNAsw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrudeliedgfedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecuvehluhhsthgvrhfuihiivgepvdenucfr
    rghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:yn5dYSHO9ciG-TSssNQdj5wL844sAtYvo6GKZ2SjUuT8vknl2gQ9VA>
    <xmx:yn5dYWUuikgS1fvSZzw-JsskySuiejw_LmOL3whg9duP4PDiX65pJQ>
    <xmx:yn5dYVMbh-QTSEu4J8mxFxvPswiPURcBklMaPK8CAs92j7pwGWGTDQ>
    <xmx:yn5dYarKU8aBJcDQ70HWcm5N4fTCz8OkKUfd-i_3CGxwRCJZdl4y8Q>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 6 Oct 2021 06:47:36 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        mkubecek@suse.cz, pali@kernel.org, jacob.e.keller@intel.com,
        jiri@nvidia.com, vadimp@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next v2 5/6] ethtool: Add transceiver module extended state
Date:   Wed,  6 Oct 2021 13:46:46 +0300
Message-Id: <20211006104647.2357115-6-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211006104647.2357115-1-idosch@idosch.org>
References: <20211006104647.2357115-1-idosch@idosch.org>
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
index 6de61d53ca5d..a2223b685451 100644
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

