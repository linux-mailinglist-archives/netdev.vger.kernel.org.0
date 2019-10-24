Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E9CD4E35FE
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 16:52:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409528AbfJXOwg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 10:52:36 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:36213 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2409522AbfJXOwe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Oct 2019 10:52:34 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 7A74521FFD;
        Thu, 24 Oct 2019 10:52:33 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Thu, 24 Oct 2019 10:52:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=Gk8RA+BKrayVDsXKxOQqJqan7U2g5Qt8f3D+tJr1kJA=; b=LNwD4iav
        jvEwkJn+J8naEN/1zTFSkgQ2BLENKVWeYPP+qoV97lzWetHE3JL1dy+BA0yWEVTu
        BWk+S9BrcWxbMxUzgZ3G5RqXiJfFo1uejGVAsVV88zC9lUYzBfxs63CZHetcZK7C
        qsiUvto2UWPoRKZWQ2KWpR1Jfeyp93l8r6Mr3NSr4AZxoFDU+tVgEjCUih3NTXNd
        x98tN6UZVJOezXeqTBSXMAmIjY9BY0OPcg/DyyWiVzoYWs3OKjDui4KzjPhxMvm+
        XNsAFfw84d4LhqEJWbNuNlv64A61IiKs/8d5ONkHCQV5goIktaymSrnLbBF7q1ZJ
        adhchx2PldT9zQ==
X-ME-Sender: <xms:sbqxXaaLjzS40z3Et5ZvY3M8GlIXzUPVVdPCfcFkm2fkBAAvlCXROA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrledugdekudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucfkphepudelfedrgeejrdduieehrddvhedunecurfgrrhgrmhepmh
    grihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhgnecuvehluhhsthgvrhfu
    ihiivgeptd
X-ME-Proxy: <xmx:sbqxXX3o3TxuMMNdMNyUZ916Pf6VQbkmdxnx4gNaUx4hCu99bsqc-g>
    <xmx:sbqxXVZ5wSPUCr74MEK6503fs6oaE8GEnKEBTKUFV7jUjQro6PdKMw>
    <xmx:sbqxXe2n9K_4bE1eDTYFf-dL57rIhHqfTECVhT1DNf89lsjgV2MFkg>
    <xmx:sbqxXf25GaoDTdHTLTVW9oMZlpQ0hug5onM_5lda07NG9YkjLOnoDQ>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 1ADB480059;
        Thu, 24 Oct 2019 10:52:31 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, petrm@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 3/3] mlxsw: Enforce firmware version for Spectrum-2
Date:   Thu, 24 Oct 2019 17:51:49 +0300
Message-Id: <20191024145149.6417-4-idosch@idosch.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191024145149.6417-1-idosch@idosch.org>
References: <20191024145149.6417-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

In a similar fashion to Spectrum-1, enforce a specific firmware version
for Spectrum-2 so that the driver and firmware are always in sync with
regards to new features.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Reviewed-by: Petr Machata <petrm@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 8a797fad2d56..97be4bc9a02f 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -63,6 +63,21 @@ static const struct mlxsw_fw_rev mlxsw_sp1_fw_rev = {
 	"." __stringify(MLXSW_SP1_FWREV_MINOR) \
 	"." __stringify(MLXSW_SP1_FWREV_SUBMINOR) ".mfa2"
 
+#define MLXSW_SP2_FWREV_MAJOR 29
+#define MLXSW_SP2_FWREV_MINOR 2000
+#define MLXSW_SP2_FWREV_SUBMINOR 2308
+
+static const struct mlxsw_fw_rev mlxsw_sp2_fw_rev = {
+	.major = MLXSW_SP2_FWREV_MAJOR,
+	.minor = MLXSW_SP2_FWREV_MINOR,
+	.subminor = MLXSW_SP2_FWREV_SUBMINOR,
+};
+
+#define MLXSW_SP2_FW_FILENAME \
+	"mellanox/mlxsw_spectrum2-" __stringify(MLXSW_SP2_FWREV_MAJOR) \
+	"." __stringify(MLXSW_SP2_FWREV_MINOR) \
+	"." __stringify(MLXSW_SP2_FWREV_SUBMINOR) ".mfa2"
+
 static const char mlxsw_sp1_driver_name[] = "mlxsw_spectrum";
 static const char mlxsw_sp2_driver_name[] = "mlxsw_spectrum2";
 static const char mlxsw_sp3_driver_name[] = "mlxsw_spectrum3";
@@ -4988,6 +5003,8 @@ static int mlxsw_sp2_init(struct mlxsw_core *mlxsw_core,
 {
 	struct mlxsw_sp *mlxsw_sp = mlxsw_core_driver_priv(mlxsw_core);
 
+	mlxsw_sp->req_rev = &mlxsw_sp2_fw_rev;
+	mlxsw_sp->fw_filename = MLXSW_SP2_FW_FILENAME;
 	mlxsw_sp->kvdl_ops = &mlxsw_sp2_kvdl_ops;
 	mlxsw_sp->afa_ops = &mlxsw_sp2_act_afa_ops;
 	mlxsw_sp->afk_ops = &mlxsw_sp2_afk_ops;
@@ -6649,3 +6666,4 @@ MODULE_DEVICE_TABLE(pci, mlxsw_sp1_pci_id_table);
 MODULE_DEVICE_TABLE(pci, mlxsw_sp2_pci_id_table);
 MODULE_DEVICE_TABLE(pci, mlxsw_sp3_pci_id_table);
 MODULE_FIRMWARE(MLXSW_SP1_FW_FILENAME);
+MODULE_FIRMWARE(MLXSW_SP2_FW_FILENAME);
-- 
2.21.0

