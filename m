Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAA7D46B764
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 10:35:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234299AbhLGJi2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 04:38:28 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:48787 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234259AbhLGJiQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 04:38:16 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id D5A595C025B;
        Tue,  7 Dec 2021 04:34:45 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Tue, 07 Dec 2021 04:34:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=zq8/4jCwf7+7JHJx8ljVMlaBUmWZXGFgi4+dtfPVQY8=; b=Ua92MmwL
        MjTXH5ysfqIk9CT6ax2ciJ4klW7vzkeLjRRW+Zw7UPM7b1A2KkJ4ycMpnhoC/9ER
        gmCWPRTn0hI/HsjlAARCNb2KVH28rOjtRx3leBUfVEWB9MelIaHUv1y56wGGNsyq
        VuUa1cKQLF4SZyKAd2DD9+scet7/PtiAOKRo0WnZqPxDhW+I6eadHDoi4w4OTK34
        Doqfe57dH71UVmeMy1/FmLpkMM3RgG8X2yDcKXoWAmIHe9eMYHKQRO7kk9ROLA7L
        fpGrdyc2BTKJ2V+SkVeNYd1NEQbOOmcUYBi0zqKJHsgLyw3oqi7F7lYyUXTBKMGF
        68BXRR1/MirFdA==
X-ME-Sender: <xms:tSqvYcSJwzbUi569Iej_JBCsxcY-eWxFtjU0IjNB2y2r93w2OFTSVQ>
    <xme:tSqvYZzcrT-NAyVkkEl2EegYqhwKD1p04I7wm-bty-QXBEYZPgRsNkzKgw3qNxIPi
    I2DF6A2_LHPJ_Y>
X-ME-Received: <xmr:tSqvYZ1ua_DciUIwFNyeVE4yZNJVH2fV3M2Hhoigw-i-YkvLfTbmQxxGAdkJAqygx8xzOBUDivjp-Q8Hh8MmYYz0Gtcj3iXdYw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvuddrjeehgddtiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhfekhe
    fgtdfftefhledvjefggfehgfevjeekhfenucevlhhushhtvghrufhiiigvpedtnecurfgr
    rhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:tSqvYQCTvkb6mB8ZN71Ks15WwkTGC1ti6aDI_iWKPJaQdJAVfxDldA>
    <xmx:tSqvYVhbehew1G8O-xvCgkvJHWzrl8V5Uvb5XDVu11GAMYUpIJZoWg>
    <xmx:tSqvYcqQMPMdvfrEC43VlabRROXQAfsCUHQYl8jnetrIhC4z_hUnLw>
    <xmx:tSqvYYt7BJ6VVlqSCUPIlZTMKlJxjQqXgAUQWkUQ-G_JfRJS24EtOQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 7 Dec 2021 04:34:44 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     mkubecek@suse.cz, vadimp@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH ethtool-next 3/3] ethtool: Add transceiver module extended state
Date:   Tue,  7 Dec 2021 11:33:59 +0200
Message-Id: <20211207093359.69974-4-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211207093359.69974-1-idosch@idosch.org>
References: <20211207093359.69974-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Add support for an extended state and an extended sub-state to describe
link issues related to transceiver modules.

In case "CMIS transceiver module is not in ModuleReady state" and the
module is in ModuleFault state, it is possible to read the fault reason
from the EEPROM dump.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 netlink/settings.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/netlink/settings.c b/netlink/settings.c
index ff1e783d099c..3cf816f06299 100644
--- a/netlink/settings.c
+++ b/netlink/settings.c
@@ -593,6 +593,7 @@ static const char *const names_link_ext_state[] = {
 	[ETHTOOL_LINK_EXT_STATE_CALIBRATION_FAILURE]	= "Calibration failure",
 	[ETHTOOL_LINK_EXT_STATE_POWER_BUDGET_EXCEEDED]	= "Power budget exceeded",
 	[ETHTOOL_LINK_EXT_STATE_OVERHEAT]		= "Overheat",
+	[ETHTOOL_LINK_EXT_STATE_MODULE]			= "Module",
 };
 
 static const char *const names_autoneg_link_ext_substate[] = {
@@ -652,6 +653,11 @@ static const char *const names_cable_issue_link_ext_substate[] = {
 		"Cable test failure",
 };
 
+static const char *const names_module_link_ext_substate[] = {
+	[ETHTOOL_LINK_EXT_SUBSTATE_MODULE_CMIS_NOT_READY]	=
+		"CMIS module is not in ModuleReady state",
+};
+
 static const char *link_ext_substate_get(uint8_t link_ext_state_val, uint8_t link_ext_substate_val)
 {
 	switch (link_ext_state_val) {
@@ -675,6 +681,10 @@ static const char *link_ext_substate_get(uint8_t link_ext_state_val, uint8_t lin
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

