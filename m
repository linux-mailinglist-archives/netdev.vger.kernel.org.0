Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2726242007E
	for <lists+netdev@lfdr.de>; Sun,  3 Oct 2021 09:34:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229949AbhJCHgE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Oct 2021 03:36:04 -0400
Received: from new2-smtp.messagingengine.com ([66.111.4.224]:37911 "EHLO
        new2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229924AbhJCHfy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Oct 2021 03:35:54 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id AF1CB580E43;
        Sun,  3 Oct 2021 03:34:05 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Sun, 03 Oct 2021 03:34:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=QjTQVmByqXnVfU8ZezBKdv2IP0+p2sB/WLXa94HjQXE=; b=Z+Swm6RQ
        xdP8izaWEtvkKnNHhanlNrk7ef6HbwhpWnf6h3G8eQWwN2pw6JA6jkvwdz0aVjBn
        5jgom4PWdlYEim3KrTidotKOoIYSrKFNa/thbfkPs5txB2ryRwuxr96APkzENFgV
        JXsXQA9tmt8Ft3YYXJN7/zwDir8Tn5j53eDPQKfpjH9fWEKuy09lwo+qItwdqF5s
        HBuX1pcfronFwDShTQEa85UAclQpNYDP/DdAmoBIjM4g63JgDjFSIusjNeASt4wf
        dJjLmvKF/m1pk2480elAHoeRUJZwrNgYvHxtaDJqJkP88bG7/GpjE1HQQfyPw6js
        nuMjQbRYNG38TA==
X-ME-Sender: <xms:7VxZYXAj5mIwIvJoRgPGztEUf6gPbozCzgEhEaHtQaAArCBhX7fbfQ>
    <xme:7VxZYdjSCfPr2JZMLd1r0IyFK7i-WUe-DaP6rGRXK_P7v2H2dSu_Pz1YGal0n3VUB
    x7398V7M_v5sIs>
X-ME-Received: <xmr:7VxZYSkuHfVkqF-jYe0ZezF3-UiGYXdTz7GjKcqQS6htA6rLlS2hiAf7beO1Ha_gu3OZ-vpXKw6iUGDO-tromOLJZAT0In7N6rI3lRpRPPb_-A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrudekledguddulecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhf
    ekhefgtdfftefhledvjefggfehgfevjeekhfenucevlhhushhtvghrufhiiigvpedvnecu
    rfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:7VxZYZzplPXGr_gnRmiwRYtttHehUlaC-OYbGKaZPVhmMCf7_yDfcA>
    <xmx:7VxZYcRjXTrU4_4wk69EZ_QYh7b7rRsjgjqBjUXdmFYfY_aNZ9-Y4w>
    <xmx:7VxZYcYu_DIiipfuyi-7gKX5QbH5Y6Q5antBrhb1eDv2hybBEDV83A>
    <xmx:7VxZYfHyB_l0CVV5zHR8jEqs2hN3_muGtQ3sO_5Bdx6m6w6bRmvkNA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 3 Oct 2021 03:34:02 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        mkubecek@suse.cz, pali@kernel.org, jacob.e.keller@intel.com,
        jiri@nvidia.com, vadimp@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 6/6] mlxsw: Add support for transceiver module extended state
Date:   Sun,  3 Oct 2021 10:32:19 +0300
Message-Id: <20211003073219.1631064-7-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211003073219.1631064-1-idosch@idosch.org>
References: <20211003073219.1631064-1-idosch@idosch.org>
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

