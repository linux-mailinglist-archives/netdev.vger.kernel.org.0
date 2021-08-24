Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 215C63F5EAA
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 15:06:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237522AbhHXNGo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 09:06:44 -0400
Received: from new3-smtp.messagingengine.com ([66.111.4.229]:35137 "EHLO
        new3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237535AbhHXNGm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Aug 2021 09:06:42 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id 55C3B580B17;
        Tue, 24 Aug 2021 09:05:58 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Tue, 24 Aug 2021 09:05:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=GvFQ9hoooGgfsBfqutyn9AFFOLnjnbBbsrHhXSsgdoo=; b=gPKtLvJd
        PeOAOMAVoBeBpusi+2L0Yuga1MQ/k8NwHVwnEYsuPohiOVUJ292pVlxX1KLCJAyi
        pND+viD1ZericJgv5XmgAOrPqK8F0OI6WHus9lx0Mm7HMUGt/VnJ7gWPmDVLyiVs
        DB9ze4Wq7nmJgUCEeC3x/WPeMzxJSuFGPPxQd57ExPuRsp+7ba/DmE2Rpm6lpmen
        6Y5lVG8qW2apUbYrlvUrytKFg/iZQLNIWaI8VZkO3cwNuu27udfcSWXiEfPug3LZ
        IiBwB8Pky7XcmWkpMoOFtYdGHNxAVXXncnEixuztwJ0YMkBO5c7qxiw+basZz81s
        xZWohFF/V/ZmaA==
X-ME-Sender: <xms:tu4kYe7x9PPYEW2pUtLunJlnM1sE4rioHKgn0ZdQeRzmny5T1Ny8uQ>
    <xme:tu4kYX7yBKTJu89YB_a3f1sB-OjNP01dBlkFDr1eheGhUJn5RhqVit5FWzMNzgNl7
    wbP-T6vE-kf3sE>
X-ME-Received: <xmr:tu4kYdfLgA_tAjWf-_zV7pavuwkGL1eZSrhC8vJs48wF2rnRO92uJEaE9-JzM1ekaFvMTW1hzqO1cefRxh5x8h6dIVbGjKk_jaQ7AwwXJ6EpeA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddruddtjedgiedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecuvehluhhsthgvrhfuihiivgepfeenucfr
    rghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:tu4kYbJgEfLaUbIyB0sAg8J-92S7c3h1bc28KWdrbOx0ZUIbzvpQPw>
    <xmx:tu4kYSLcoWo_Q9vRFaLCqqsNKgk8mh6BeAFE0m8tFT9ZTabUujDJDw>
    <xmx:tu4kYczi776rm0FScAYWKu7S5f8v-hsIWFQmNSrx_j8zA0DCKP0fvw>
    <xmx:tu4kYR9YZiZu1NPDEJFzrbH9dd5Q6LEXBkw7xpqh4U2ZfDSP9okL0w>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 24 Aug 2021 09:05:55 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        mkubecek@suse.cz, pali@kernel.org, jacob.e.keller@intel.com,
        jiri@nvidia.com, vadimp@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [RFC PATCH ethtool-next v3 6/6] ethtool: Add transceiver module extended states
Date:   Tue, 24 Aug 2021 16:05:15 +0300
Message-Id: <20210824130515.1828270-7-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210824130515.1828270-1-idosch@idosch.org>
References: <20210824130515.1828270-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Add support for an extended state and two extended sub-states to
describe link issues related to transceiver modules.

In case "CMIS transceiver module is not in ModuleReady state" and the
module is in ModuleFault state, it is possible to read the fault reason
from the EEPROM dump.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 netlink/settings.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/netlink/settings.c b/netlink/settings.c
index e47a38f3058f..515b9302c09d 100644
--- a/netlink/settings.c
+++ b/netlink/settings.c
@@ -593,6 +593,7 @@ static const char *const names_link_ext_state[] = {
 	[ETHTOOL_LINK_EXT_STATE_CALIBRATION_FAILURE]	= "Calibration failure",
 	[ETHTOOL_LINK_EXT_STATE_POWER_BUDGET_EXCEEDED]	= "Power budget exceeded",
 	[ETHTOOL_LINK_EXT_STATE_OVERHEAT]		= "Overheat",
+	[ETHTOOL_LINK_EXT_STATE_MODULE]			= "Module",
 };
 
 static const char *const names_autoneg_link_ext_substate[] = {
@@ -648,6 +649,13 @@ static const char *const names_cable_issue_link_ext_substate[] = {
 		"Cable test failure",
 };
 
+static const char *const names_module_link_ext_substate[] = {
+	[ETHTOOL_LINK_EXT_SUBSTATE_MODULE_LOW_POWER_MODE]	=
+		"Module is in low power mode",
+	[ETHTOOL_LINK_EXT_SUBSTATE_MODULE_CMIS_NOT_READY]	=
+		"CMIS module is not in ModuleReady state",
+};
+
 static const char *link_ext_substate_get(uint8_t link_ext_state_val, uint8_t link_ext_substate_val)
 {
 	switch (link_ext_state_val) {
@@ -671,6 +679,10 @@ static const char *link_ext_substate_get(uint8_t link_ext_state_val, uint8_t lin
 		return get_enum_string(names_cable_issue_link_ext_substate,
 				       ARRAY_SIZE(names_cable_issue_link_ext_substate),
 				       link_ext_substate_val);
+	case ETHTOOL_LINK_EXT_STATE_MODULE:
+		return get_enum_string(names_module_link_ext_substate,
+				       ARRAY_SIZE(names_module_link_ext_substate),
+				       link_ext_substate_val);
 	default:
 		return NULL;
 	}
-- 
2.31.1

