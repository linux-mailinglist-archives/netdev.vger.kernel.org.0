Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4029CCF01
	for <lists+netdev@lfdr.de>; Sun,  6 Oct 2019 08:35:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726268AbfJFGfY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Oct 2019 02:35:24 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:47447 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726259AbfJFGfX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Oct 2019 02:35:23 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 3EA5B20F25;
        Sun,  6 Oct 2019 02:35:23 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Sun, 06 Oct 2019 02:35:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=5w5ZZTmzyoWAwXXL805JmA2ST9w5QD2sV4mZh3PHTiQ=; b=cKrIA7rG
        elIxvPE9dnE+IE7nCH1mq1dPWX1QnpQ7Rh7mZ1LCsmgJ1TpkqAONvrKo6Zg5eMrm
        SKxmcFQ6I2gGj3Hmf2JxAVfoWCALYHMPm+WVuyHH2fYfDOECDBxn3A1qsJdt/IYT
        O/fnTlSr88IomLSWjg/2uJo2ca1xQd0nJvBbRZgBFg/CixcEiad3BOcdGQ00+LAY
        cCLjB+VZn1CcssqiQcMG4an6/pL57/Th9x8Gb9qun6OhoOk8d6yNs1qwbZXUxtrv
        WVmf5vkJZZR7IbB4aGe+g9OZLI4ESjquxzjpMjCfvGvb1wxKMWKS1pCH52yIPWtt
        8DzZrYDsLsuxZw==
X-ME-Sender: <xms:K4uZXdsW3AGrs87h_6oyvE_5YhfWhLPiB3FGYO9N_LM2OBpMcKu-Nw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrheeggdejhecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucfkphepudelfedrgeejrdduieehrddvhedunecurfgrrhgrmhepmh
    grihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhgnecuvehluhhsthgvrhfu
    ihiivgepfe
X-ME-Proxy: <xmx:K4uZXYXlEOZmMoqY88vcM8MIHW8wpkxQXnq2MbGTla90HvqeEkEPYQ>
    <xmx:K4uZXVZ0wxrInzRWc0STGLYVOJEorGt5rQC0MS_8MwYu_YSjm1W2oA>
    <xmx:K4uZXSsVb2bJZwx9vbQ1kj6wi3_mHyjA7g-WUFAvNBqoiJw-Bg1KVw>
    <xmx:K4uZXZfDf6kYFl5NrDHhAaUdvLJeWfO_rGha79uL5iCowPfjQVuCrA>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id ED4CED60057;
        Sun,  6 Oct 2019 02:35:21 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, vadimp@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 4/5] mlxsw: core: Push minor/subminor fw version check into helper
Date:   Sun,  6 Oct 2019 09:34:51 +0300
Message-Id: <20191006063452.7666-5-idosch@idosch.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191006063452.7666-1-idosch@idosch.org>
References: <20191006063452.7666-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vadim Pasternak <vadimp@mellanox.com>

Add new API for FW "minor" and "subminor" version validation for
sharing it between "spectrum" and "minimal" drivers.
Use it in "spectrum" driver.

Signed-off-by: Vadim Pasternak <vadimp@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/core.c     | 10 ++++++++++
 drivers/net/ethernet/mellanox/mlxsw/core.h     |  5 +++++
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c |  4 +---
 3 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.c b/drivers/net/ethernet/mellanox/mlxsw/core.c
index 1c29522a2af3..2b59f84b14f9 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.c
@@ -127,6 +127,16 @@ bool mlxsw_core_res_query_enabled(const struct mlxsw_core *mlxsw_core)
 }
 EXPORT_SYMBOL(mlxsw_core_res_query_enabled);
 
+bool
+mlxsw_core_fw_rev_minor_subminor_validate(const struct mlxsw_fw_rev *rev,
+					  const struct mlxsw_fw_rev *req_rev)
+{
+	return rev->minor > req_rev->minor ||
+	       (rev->minor == req_rev->minor &&
+		rev->subminor >= req_rev->subminor);
+}
+EXPORT_SYMBOL(mlxsw_core_fw_rev_minor_subminor_validate);
+
 struct mlxsw_rx_listener_item {
 	struct list_head list;
 	struct mlxsw_rx_listener rxl;
diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.h b/drivers/net/ethernet/mellanox/mlxsw/core.h
index 3377a1b39b03..f25037074e2d 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.h
@@ -24,6 +24,7 @@ struct mlxsw_core_port;
 struct mlxsw_driver;
 struct mlxsw_bus;
 struct mlxsw_bus_info;
+struct mlxsw_fw_rev;
 
 unsigned int mlxsw_core_max_ports(const struct mlxsw_core *mlxsw_core);
 
@@ -31,6 +32,10 @@ void *mlxsw_core_driver_priv(struct mlxsw_core *mlxsw_core);
 
 bool mlxsw_core_res_query_enabled(const struct mlxsw_core *mlxsw_core);
 
+bool
+mlxsw_core_fw_rev_minor_subminor_validate(const struct mlxsw_fw_rev *rev,
+					  const struct mlxsw_fw_rev *req_rev);
+
 int mlxsw_core_driver_register(struct mlxsw_driver *mlxsw_driver);
 void mlxsw_core_driver_unregister(struct mlxsw_driver *mlxsw_driver);
 
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index c91b8238c8c5..3c5154e559b2 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -409,9 +409,7 @@ static int mlxsw_sp_fw_rev_validate(struct mlxsw_sp *mlxsw_sp)
 	}
 	if (MLXSW_SP_FWREV_MINOR_TO_BRANCH(rev->minor) ==
 	    MLXSW_SP_FWREV_MINOR_TO_BRANCH(req_rev->minor) &&
-	    (rev->minor > req_rev->minor ||
-	     (rev->minor == req_rev->minor &&
-	      rev->subminor >= req_rev->subminor)))
+	    mlxsw_core_fw_rev_minor_subminor_validate(rev, req_rev))
 		return 0;
 
 	dev_info(mlxsw_sp->bus_info->dev, "The firmware version %d.%d.%d is incompatible with the driver\n",
-- 
2.21.0

