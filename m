Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 223CB4600B0
	for <lists+netdev@lfdr.de>; Sat, 27 Nov 2021 18:48:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355831AbhK0RvV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Nov 2021 12:51:21 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:39081 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233245AbhK0RtU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Nov 2021 12:49:20 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id D83EC5C00A8;
        Sat, 27 Nov 2021 12:46:05 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Sat, 27 Nov 2021 12:46:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=H/xj1pYq09AMTDZILmb+00B//zizBsuRqfNd0TmQskM=; b=KpynZHDe
        igRUPtjMLS5ho4WeO1V7LTOCO9agx4mEaXQVXM3NIicFU0X0vsXCXkNezhXVIH1V
        g5VpaE9Vp9MDxIcRGfTXRni/tGW29QJ1Mqav7x/py15lGGFtmXVnhVbYGVEd1NM7
        6ozcbBFgrMXUq01+OVY5jjoRkIlwGqHbkPlVdB/XApvDdEhuNnf7OojJKfi2Jq8X
        4DFy63h0H+oWZgKKTgUxyaiowlxqDhgR1JprwH6fTU2bTwRD4cQ6RJ3EL0SVhMY7
        /atpLHK0bPxAq/Tkh2lxHMHzhBAHK6kDmpo72FxJtwXZgwkE7DpBnCSqB5RsnFuk
        Dq399PlAZ5JPxA==
X-ME-Sender: <xms:3W6iYc5xNdsVgbRYUFNgjgWrXimfyx6O0k3Xupi59vHg5JQyJLBt8w>
    <xme:3W6iYd6k3i8vANeMOal7oE9QDxFsVjAtn2adfSB8ZCUn8RbroCDTBRIlmeIGnEAJm
    xipv_yIDtLvk_s>
X-ME-Received: <xmr:3W6iYbf-8-FhAQZIbgktd7Bsne6wfMQZ2N_alEVKGLHbosEkFAU8VLsygBimdumIrTo304mg05YTQODQVymrtKigsYO7ebB0iw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvuddrheeggdejlecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhfekhe
    fgtdfftefhledvjefggfehgfevjeekhfenucevlhhushhtvghrufhiiigvpedtnecurfgr
    rhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:3W6iYRJKUzOYiO1xuX6qFl32fHfZvgkR7NksnpBxvuSWEXffxcF0HQ>
    <xmx:3W6iYQJ63s9-R_QxgprR1uh56cENw07vsumUzUqlrhDIKFjABebx4Q>
    <xmx:3W6iYSxbFho6sdEE7QGjdKHPBVZd9I_GENkDpCtUEQOitt3kZCFBjw>
    <xmx:3W6iYZoi08tuCKJjzT2RVZ1N7SPoADQfOfFDGvaX6eGbRNycGa0oWw>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sat,
 27 Nov 2021 12:46:02 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        mkubecek@suse.cz, pali@kernel.org, jacob.e.keller@intel.com,
        vadimp@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [RFC PATCH net-next 2/4] netdevsim: Implement support for ethtool_ops::get_module_fw_info
Date:   Sat, 27 Nov 2021 19:45:28 +0200
Message-Id: <20211127174530.3600237-3-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211127174530.3600237-1-idosch@idosch.org>
References: <20211127174530.3600237-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

For RFC purposes only, implement support for
ethtool_ops::get_module_fw_info.

A real implementation is expected to call CMIS common code (WIP) that
can be shared across all MAC drivers.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/netdevsim/ethtool.c | 35 +++++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

diff --git a/drivers/net/netdevsim/ethtool.c b/drivers/net/netdevsim/ethtool.c
index 2b84169bf3a2..690cd12a4245 100644
--- a/drivers/net/netdevsim/ethtool.c
+++ b/drivers/net/netdevsim/ethtool.c
@@ -137,6 +137,40 @@ nsim_set_fecparam(struct net_device *dev, struct ethtool_fecparam *fecparam)
 	return 0;
 }
 
+static int nsim_get_module_fw_info(struct net_device *dev,
+				   struct ethtool_module_fw_info *info,
+				   struct netlink_ext_ack *extack)
+{
+	info->type = ETHTOOL_MODULE_FW_INFO_TYPE_CMIS;
+
+	info->cmis.a_present = true;
+	info->cmis.a.running = true;
+	info->cmis.a.committed = true;
+	info->cmis.a.valid = true;
+	info->cmis.a.ver_major = 1;
+	info->cmis.a.ver_minor = 2;
+	info->cmis.a.ver_build = 3;
+	strcpy(info->cmis.a.ver_extra_str, "test");
+
+	info->cmis.b_present = true;
+	info->cmis.b.running = false;
+	info->cmis.b.committed = false;
+	info->cmis.b.valid = true;
+	info->cmis.b.ver_major = 5;
+	info->cmis.b.ver_minor = 6;
+	info->cmis.b.ver_build = 7;
+
+	info->cmis.factory_present = true;
+	info->cmis.factory.running = false;
+	info->cmis.factory.committed = false;
+	info->cmis.factory.valid = true;
+	info->cmis.factory.ver_major = 11;
+	info->cmis.factory.ver_minor = 12;
+	info->cmis.factory.ver_build = 13;
+
+	return 0;
+}
+
 static const struct ethtool_ops nsim_ethtool_ops = {
 	.supported_coalesce_params	= ETHTOOL_COALESCE_ALL_PARAMS,
 	.get_pause_stats	        = nsim_get_pause_stats,
@@ -150,6 +184,7 @@ static const struct ethtool_ops nsim_ethtool_ops = {
 	.set_channels			= nsim_set_channels,
 	.get_fecparam			= nsim_get_fecparam,
 	.set_fecparam			= nsim_set_fecparam,
+	.get_module_fw_info		= nsim_get_module_fw_info,
 };
 
 static void nsim_ethtool_ring_init(struct netdevsim *ns)
-- 
2.31.1

