Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE2EC3F0887
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 17:53:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240196AbhHRPy1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 11:54:27 -0400
Received: from new1-smtp.messagingengine.com ([66.111.4.221]:46199 "EHLO
        new1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238409AbhHRPyQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Aug 2021 11:54:16 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailnew.nyi.internal (Postfix) with ESMTP id F0763582FDE;
        Wed, 18 Aug 2021 11:53:41 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Wed, 18 Aug 2021 11:53:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=jdzr8t+d/pCuUNt75MhYyRWE8O0L2MvzUoMKnJvqODE=; b=musKBm5b
        mS/2Ymg63EOeQlh/OBd0085H05stoIyq4aoS17caTnN/0T2r69zY/K4x4SiMj9pt
        +eoW4P5FzMTvZYCy9ylJkMTZsq7TILbdligzxcpV3AoCdV1gJ4We6j6aei68gjMF
        /Mun2cF2U4KE6b5PcU1RFEIPklQmQkbVTJHjvQ3oyGlXRAwOevT85JiJKFwO5nZa
        KE8keNZ4/9js+e5i+US41nQvFcDWwJzeYMClAeeVdyEoqSidexqsi62///uj47cL
        AeoT6LJnVE6hHgmawTSuVDIT+BbP4l+EZ4J3ZVuYFoXM+jD/c89EgmE7N3sZVhMI
        vIOHEypHwwQRLQ==
X-ME-Sender: <xms:BS0dYYHuMH-g5WPnm8RwsMQo-TFtSMySu1Xj0Xfao0TvwW1UCFFOlg>
    <xme:BS0dYRWP_yLl45WcsbNGbocdJX43yAJc-9JfmSAPF2I9Ei7YOINLQHzgMH4U0Bw_C
    GB51S-hBMiBxpI>
X-ME-Received: <xmr:BS0dYSIiGZZ6uNfcpICWIbXEHLmViLzpj0kZrfIuiTlpcOG_JL1NSp7935o3XfuxEl4IcsxaBaNeKt8cYbHIduNH2dH3zvluzSEdWXOoolK9Wg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrleehgdelfecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhfekhe
    fgtdfftefhledvjefggfehgfevjeekhfenucevlhhushhtvghrufhiiigvpeefnecurfgr
    rhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:BS0dYaGAmbXvbD2JrN2EkwlttbRGDl9CQcHur38qTUXqsnDqDZm4Ww>
    <xmx:BS0dYeUunKpqSw-jw7Tm44UdEk6PQIIkkky5en6SgUZMOsC1clbcag>
    <xmx:BS0dYdNRpEjlTauRLEALdzBm3VXFdNkfKcwBrlqYR5EauvcnQSI77A>
    <xmx:BS0dYSrXvL1gvTS0gI-aG60ibLj3gHzYrBI9axBLjPkm-E7TZR9Uhg>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 18 Aug 2021 11:53:38 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        mkubecek@suse.cz, pali@kernel.org, jacob.e.keller@intel.com,
        jiri@nvidia.com, vadimp@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [RFC PATCH ethtool-next v2 6/6] ethtool: Add transceiver module extended states
Date:   Wed, 18 Aug 2021 18:53:06 +0300
Message-Id: <20210818155306.1278356-7-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210818155306.1278356-1-idosch@idosch.org>
References: <20210818155306.1278356-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Add support for an extended state and two extended sub-states to
describe link issues related to transceiver modules.

Output example:

 $ ethtool swp13
 ...
 Link detected: no (Module, Module is in low power mode)

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

