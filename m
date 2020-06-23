Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A32FB205B8F
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 21:14:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387520AbgFWTOX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 15:14:23 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:50215 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387504AbgFWTOW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 15:14:22 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 3211C5C0148;
        Tue, 23 Jun 2020 15:14:21 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Tue, 23 Jun 2020 15:14:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=fK1P38bTUSDWN0VYd+cHmPRbhZOiOKVa59W615MEhXA=; b=MQvqtuvN
        P5KY+APnk1EeT9McU+3vf8RTs4Eei+SwmkhY0u0rAipu2CxJ+YXo0VDWpSpRGGwn
        +jJsmFOFVWTNIuilwJLSPMhAOWc9sGXsXaae1H0JTz1qOBpA8/Vyiu+w+rt3navp
        4QDqokw8SffP9c2sl1YUBSnaBOuOhqiyMK6WFuY3AijMXXKBAw6FKJ36reurfTYq
        surU1rMBd+drPuaYKg9W/7oU+FGuegCp0R2E0bomBMrLLYMfT8lADNrML9xOQTAB
        GjY/RrcK9AqbtEXQH2mPAoaOdwUzrNAwRMAIPRQIlZbdoNVis3meNCwrk29VdviV
        ntxVweWDMkce2w==
X-ME-Sender: <xms:jVTyXlVbCXQXSUBH5T1kfhTET49cZrMPiUE70LSlQluU3DXeh2ufKA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudekhedguddtjecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhf
    ekhefgtdfftefhledvjefggfehgfevjeekhfenucfkphepjeelrddukeefrdeihedrkeej
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:jVTyXlldXAA6CLTCI-wrF5vddE1P9DTgnDPhg1-Egh7bNQHqEI2osQ>
    <xmx:jVTyXhYNnlYWXLWfr8Hp-D5fXgXr806xGDuKsQnSPQNEMEW4tqtWlg>
    <xmx:jVTyXoXCOErqRWLdMku6maRAl3LfBe0-oeGbL16XweqbovBY3nX01A>
    <xmx:jVTyXkxoX6LcrNEwT078pw4cKl6IHeO_g2vAFuhsIZUYLKS1y_wsTw>
Received: from shredder.mtl.com (bzq-79-183-65-87.red.bezeqint.net [79.183.65.87])
        by mail.messagingengine.com (Postfix) with ESMTPA id BAF43328005A;
        Tue, 23 Jun 2020 15:14:19 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, petrm@mellanox.com,
        jiri@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 2/2] mlxsw: Enforce firmware version for Spectrum-3
Date:   Tue, 23 Jun 2020 22:13:46 +0300
Message-Id: <20200623191346.75121-3-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200623191346.75121-1-idosch@idosch.org>
References: <20200623191346.75121-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@mellanox.com>

In a fashion similar to the other Spectrum systems, enforce a specific
firmware version for Spectrum-3 so that the driver and firmware are
always in sync with regards to new features.

Signed-off-by: Petr Machata <petrm@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 371c1ae0afb4..f600e5c6b60d 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -76,6 +76,21 @@ static const struct mlxsw_fw_rev mlxsw_sp2_fw_rev = {
 	"." __stringify(MLXSW_SP2_FWREV_MINOR) \
 	"." __stringify(MLXSW_SP2_FWREV_SUBMINOR) ".mfa2"
 
+#define MLXSW_SP3_FWREV_MAJOR 30
+#define MLXSW_SP3_FWREV_MINOR 2007
+#define MLXSW_SP3_FWREV_SUBMINOR 1168
+
+static const struct mlxsw_fw_rev mlxsw_sp3_fw_rev = {
+	.major = MLXSW_SP3_FWREV_MAJOR,
+	.minor = MLXSW_SP3_FWREV_MINOR,
+	.subminor = MLXSW_SP3_FWREV_SUBMINOR,
+};
+
+#define MLXSW_SP3_FW_FILENAME \
+	"mellanox/mlxsw_spectrum3-" __stringify(MLXSW_SP3_FWREV_MAJOR) \
+	"." __stringify(MLXSW_SP3_FWREV_MINOR) \
+	"." __stringify(MLXSW_SP3_FWREV_SUBMINOR) ".mfa2"
+
 static const char mlxsw_sp1_driver_name[] = "mlxsw_spectrum";
 static const char mlxsw_sp2_driver_name[] = "mlxsw_spectrum2";
 static const char mlxsw_sp3_driver_name[] = "mlxsw_spectrum3";
@@ -4642,6 +4657,8 @@ static int mlxsw_sp3_init(struct mlxsw_core *mlxsw_core,
 {
 	struct mlxsw_sp *mlxsw_sp = mlxsw_core_driver_priv(mlxsw_core);
 
+	mlxsw_sp->req_rev = &mlxsw_sp3_fw_rev;
+	mlxsw_sp->fw_filename = MLXSW_SP3_FW_FILENAME;
 	mlxsw_sp->kvdl_ops = &mlxsw_sp2_kvdl_ops;
 	mlxsw_sp->afa_ops = &mlxsw_sp2_act_afa_ops;
 	mlxsw_sp->afk_ops = &mlxsw_sp2_afk_ops;
@@ -6333,3 +6350,4 @@ MODULE_DEVICE_TABLE(pci, mlxsw_sp2_pci_id_table);
 MODULE_DEVICE_TABLE(pci, mlxsw_sp3_pci_id_table);
 MODULE_FIRMWARE(MLXSW_SP1_FW_FILENAME);
 MODULE_FIRMWARE(MLXSW_SP2_FW_FILENAME);
+MODULE_FIRMWARE(MLXSW_SP3_FW_FILENAME);
-- 
2.26.2

