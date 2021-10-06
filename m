Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD083423BB3
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 12:47:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238177AbhJFKtn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 06:49:43 -0400
Received: from new1-smtp.messagingengine.com ([66.111.4.221]:33343 "EHLO
        new1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238166AbhJFKtd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Oct 2021 06:49:33 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id A76815811D2;
        Wed,  6 Oct 2021 06:47:41 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Wed, 06 Oct 2021 06:47:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=QjTQVmByqXnVfU8ZezBKdv2IP0+p2sB/WLXa94HjQXE=; b=ZEBXdr/x
        Ab5eLMa1IrvjCnYdnEnYfwhKGDmU1qV19D/P4DZqunG/ARLstB8cBbKbPq1vkJnd
        v6E/3JD9i0oJpblheje/SX/kPvfAN3hEljUBTwar4lNsiypdlcxSPixFy58ZEf3F
        HpENsX/qldyg/UelxGz0C0kesmqOVvufO+OfJ6YG5CP/aq78cnpoCW8lGxO0rc8h
        QjCQ+b01JARyXn3hxfCWTkSv28wP5P6EDJ2eaSGyNAJhCSRZDIidbHmNybJWvOzY
        2bwA5/XRhgBPkM20jbzh0VefR5KDjGVGNDkqGkSH6/M+3zYeu5EPcKIV06aNLgR6
        Avuq09268Jwiqw==
X-ME-Sender: <xms:zX5dYWnfg_mkyEtAFtEjwXCCCIFCkOzFFfwcgSRAy3y6gQwz-ZSBcw>
    <xme:zX5dYd2RoALFVWAHbLmO_zBH9CMYe6rJOmnpGoGLUWuvLtAyNgIZJHYe-MTNUScE1
    yKpPczIR-G65ZU>
X-ME-Received: <xmr:zX5dYUoBh3Ys1iARcOnk2htHpSZLeVFhBSF18BdYhaoSy2TAYy-LckV5C8dwueTIIz8eHf3l8omxAUFN-pPrifdPAupsbCalx52xdHZR3Ub4eQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrudeliedgfedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecuvehluhhsthgvrhfuihiivgeptdenucfr
    rghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:zX5dYal0v2PwEC-R2f8sbmTHQsdES_SmJATQpwjP16jRJ8hf1viYMg>
    <xmx:zX5dYU1GZNHFRnUt6oYuFa-0VRj2wKKjvWqcHh1ivKfz43dnsBI2wQ>
    <xmx:zX5dYRu5vVTiT33rMKs1X42Jo6qWjrCqKzIOmoWfAm6EI_GtP0g1qg>
    <xmx:zX5dYVLQgLMpAKYIBLNxyRyRa66BGxyCRa1QTPBpxdeU7KgAh4GzKQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 6 Oct 2021 06:47:38 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        mkubecek@suse.cz, pali@kernel.org, jacob.e.keller@intel.com,
        jiri@nvidia.com, vadimp@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next v2 6/6] mlxsw: Add support for transceiver module extended state
Date:   Wed,  6 Oct 2021 13:46:47 +0300
Message-Id: <20211006104647.2357115-7-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211006104647.2357115-1-idosch@idosch.org>
References: <20211006104647.2357115-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Add support for the transceiver module extended state and sub-state
added in previous patch. The extended state is meant to describe link
issues related to transceiver modules.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c
index 7329bc84a8ee..84d4460f3dcd 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c
@@ -96,6 +96,9 @@ mlxsw_sp_link_ext_state_opcode_map[] = {
 	{1032, ETHTOOL_LINK_EXT_STATE_POWER_BUDGET_EXCEEDED, 0},
 
 	{1030, ETHTOOL_LINK_EXT_STATE_OVERHEAT, 0},
+
+	{1042, ETHTOOL_LINK_EXT_STATE_MODULE,
+	 ETHTOOL_LINK_EXT_SUBSTATE_MODULE_CMIS_NOT_READY},
 };
 
 static void
@@ -124,6 +127,10 @@ mlxsw_sp_port_set_link_ext_state(struct mlxsw_sp_ethtool_link_ext_state_opcode_m
 		link_ext_state_info->cable_issue =
 			link_ext_state_mapping.link_ext_substate;
 		break;
+	case ETHTOOL_LINK_EXT_STATE_MODULE:
+		link_ext_state_info->module =
+			link_ext_state_mapping.link_ext_substate;
+		break;
 	default:
 		break;
 	}
-- 
2.31.1

