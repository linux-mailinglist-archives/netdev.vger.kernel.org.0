Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27D5C39F70B
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 14:45:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232771AbhFHMqw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 08:46:52 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:33677 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232757AbhFHMqu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Jun 2021 08:46:50 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id C6A2F5C0135;
        Tue,  8 Jun 2021 08:44:57 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Tue, 08 Jun 2021 08:44:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=y6iLRgrpQXw8+CLeMQdIjI9FKTETZHfBwyEtv7m0VBk=; b=up9jPjVC
        EL4RTINO8tdBDHR81elSi8deIPxTpzHH8RBu17LvEMANpjAAmNEfmOsCG5tIOS5S
        xPG0Krk13IyRsrn1hn8rPqw5NeN3zbgURQLCtbQ3vsr6re2G/Bkjgo/64wUF61jl
        KO1XlhA4RxjnvOyXkI4vnIlWUx4enC/Z/wrs4mWzz9lyHjfUdTgSewJs/VJGo0Gf
        LAf2eJoOdOa5SN0kiotgRtUFyj4jzKyUVY+djetrwAcmTNybww5nPoJNGZHKwCWM
        +SptZke9xlBUNh7h2jBD82kSrJhxh4vvfyyC/ze1etRDPG1XTAMlLZmmeCzVrvzN
        F9xPkAK3TqR/yA==
X-ME-Sender: <xms:SWa_YFBD4fdRg5wMhNu4DYsySdDRyOx1gadZ3F9BLdOe62TxNbX6jQ>
    <xme:SWa_YDilGaMGiG_-rNDwAsRbI3CBJeWJjbnhO4SMEh3R9dIRu0wrAo3cAz9YrGGdK
    3ENBIcJRvmrBVA>
X-ME-Received: <xmr:SWa_YAkBXFMxPYa-pxu5cZWrwD6c0T4vyaRt13OPuw0GhcJINfoWrdzKpf-Y7CYRMb_UhMEWxQTve0zyXDXOjFB83AFfIywgdeOWLUvKnzgAuQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfedtledggedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecuvehluhhsthgvrhfuihiivgepvdenucfr
    rghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:SWa_YPzySS4GPJaOOKDXgSMgd6inPp4HnYv1H-d6m9WnIMGWmMBiow>
    <xmx:SWa_YKShXuqzej6vafx9_S2qd7Noqs70Kyl-Kmqic8MLKY3NQYaniA>
    <xmx:SWa_YCbHmotWN4QVElBFayNrzOVpWMsP_fvP6mzfKQxOKjvnSsykRA>
    <xmx:SWa_YHTtlmyvgVgXIHvb-aKctUrB_8pA2-stPeSY_DHd270Z4jspxg>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 8 Jun 2021 08:44:55 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        petrm@nvidia.com, amcohen@nvidia.com, vadimp@nvidia.com,
        c_mykolak@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 7/8] mlxsw: thermal: Add function for reading module temperature and thresholds
Date:   Tue,  8 Jun 2021 15:44:13 +0300
Message-Id: <20210608124414.1664294-8-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210608124414.1664294-1-idosch@idosch.org>
References: <20210608124414.1664294-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mykola Kostenok <c_mykolak@nvidia.com>

Provide new function mlxsw_thermal_module_temp_and_thresholds_get() for
reading temperature and temperature thresholds by a single operation.
The motivation is to reduce the number of transactions with the device
which is important when operating over a slow bus such as I2C.

Currently, the sole caller of the function is only using it to read the
module's temperature. The next patch will also use it to query the
module's temperature thresholds.

Signed-off-by: Mykola Kostenok <c_mykolak@nvidia.com>
Acked-by: Vadim Pasternak <vadimp@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../ethernet/mellanox/mlxsw/core_thermal.c    | 50 +++++++++++++------
 1 file changed, 35 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c b/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
index 8d844d3c2e40..e1ef913c81ef 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
@@ -420,29 +420,49 @@ static int mlxsw_thermal_module_unbind(struct thermal_zone_device *tzdev,
 	return err;
 }
 
+static void
+mlxsw_thermal_module_temp_and_thresholds_get(struct mlxsw_core *core,
+					     u16 sensor_index, int *p_temp,
+					     int *p_crit_temp,
+					     int *p_emerg_temp)
+{
+	char mtmp_pl[MLXSW_REG_MTMP_LEN];
+	int err;
+
+	/* Read module temperature and thresholds. */
+	mlxsw_reg_mtmp_pack(mtmp_pl, sensor_index, false, false);
+	err = mlxsw_reg_query(core, MLXSW_REG(mtmp), mtmp_pl);
+	if (err) {
+		/* Set temperature and thresholds to zero to avoid passing
+		 * uninitialized data back to the caller.
+		 */
+		*p_temp = 0;
+		*p_crit_temp = 0;
+		*p_emerg_temp = 0;
+
+		return;
+	}
+	mlxsw_reg_mtmp_unpack(mtmp_pl, p_temp, NULL, p_crit_temp, p_emerg_temp,
+			      NULL);
+}
+
 static int mlxsw_thermal_module_temp_get(struct thermal_zone_device *tzdev,
 					 int *p_temp)
 {
 	struct mlxsw_thermal_module *tz = tzdev->devdata;
 	struct mlxsw_thermal *thermal = tz->parent;
-	struct device *dev = thermal->bus_info->dev;
-	char mtmp_pl[MLXSW_REG_MTMP_LEN];
+	struct device *dev;
+	u16 sensor_index;
 	int temp;
 	int err;
 
-	/* Read module temperature. */
-	mlxsw_reg_mtmp_pack(mtmp_pl, MLXSW_REG_MTMP_MODULE_INDEX_MIN +
-			    tz->module, false, false);
-	err = mlxsw_reg_query(thermal->core, MLXSW_REG(mtmp), mtmp_pl);
-	if (err) {
-		/* Do not return error - in case of broken module's sensor
-		 * it will cause error message flooding.
-		 */
-		temp = 0;
-		*p_temp = (int) temp;
-		return 0;
-	}
-	mlxsw_reg_mtmp_unpack(mtmp_pl, &temp, NULL, NULL, NULL, NULL);
+	dev = thermal->bus_info->dev;
+	sensor_index = MLXSW_REG_MTMP_MODULE_INDEX_MIN + tz->module;
+
+	/* Read module temperature and thresholds. */
+	mlxsw_thermal_module_temp_and_thresholds_get(thermal->core,
+						     sensor_index, &temp, NULL,
+						     NULL);
 	*p_temp = temp;
 
 	if (!temp)
-- 
2.31.1

