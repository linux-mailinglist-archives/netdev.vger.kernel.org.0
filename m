Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12CB940C36C
	for <lists+netdev@lfdr.de>; Wed, 15 Sep 2021 12:13:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237449AbhIOKOv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Sep 2021 06:14:51 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:53629 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232154AbhIOKOq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Sep 2021 06:14:46 -0400
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id F0A105C0154;
        Wed, 15 Sep 2021 06:13:27 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Wed, 15 Sep 2021 06:13:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=wEKvAx8WSWJcprH2GUv40Gi2bl9k2BHZt3QEaYOr6FU=; b=Xv5KwZi6
        RB6APQdakPdgRIjioF8oCczx+C+YUcai5qhe9BKCSfwLP+Yk97GL36tPH5t9GVnB
        +4nDTPLyFpllJp50Aci7JpBfbrUPzJasZV8KoCiHG48zApLEQfUF+05cTeiiNJTh
        Uf9GLNwiSckQMqaISn5LpVEpKfLPOeo9FhhmA0p78U0y/WP6Bsu7JjTVtqawnJ+p
        55HcHq6XiCsjKX/vmoONvT9k5KtprMumkCTgC/yGZ0DW2dFkRBXYEzX7/5w5o0O5
        +n0nO4DumlWQU1cGzRFxE986BfHfQ0YRQpyN3jP+gbqI9kP+P8aSQjck4PYjhvAC
        29qkapAwhJWTvw==
X-ME-Sender: <xms:R8dBYfPZZtpAn1Lc2zHB54l3zdqXaw-JyX1Xnm3x91OWvvHD9s5h_g>
    <xme:R8dBYZ86lVP2e-8QJcrg8vFblGsmCWonshUprccKEJSY31GaDBb4sjw-yFVThzems
    3U7wuWKUF6_NVQ>
X-ME-Received: <xmr:R8dBYeQnKY0dEhg3WOpgUXnViYB65bZLigdPPNtzWZJfHp9AMOvKpR5kn8eDcCQhkz4NKiCsCT8ceouYacb5M8dThZEG1ZMpzA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrudehuddgvddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecuvehluhhsthgvrhfuihiivgeptdenucfr
    rghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:R8dBYTtAcNcxlRf0CczFq2UZOGqxK5HbqUgQv36gSHA5_rFbgVFhjg>
    <xmx:R8dBYXcfKDF0wbtAY4GAUSd5BLaPI06nKvOVSWyW3qOIwKzJgbhpUw>
    <xmx:R8dBYf3r9K5lWUIT32kyL_N-OBW7mth7pel28c1ROKL5kaSwQjbppg>
    <xmx:R8dBYYGsK1_oIclNG2x4AaWg1dQa1x1Lw3SEMjNqy3JlMue8oGrseQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 15 Sep 2021 06:13:25 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        jiri@nvidia.com, vadimp@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 01/10] mlxsw: core: Initialize switch driver last
Date:   Wed, 15 Sep 2021 13:13:05 +0300
Message-Id: <20210915101314.407476-2-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210915101314.407476-1-idosch@idosch.org>
References: <20210915101314.407476-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Commit 961cf99a074f ("mlxsw: core: Re-order initialization sequence")
changed the initialization sequence so that the switch driver (e.g.,
mlxsw_spectrum) is initialized before registration with the hwmon and
thermal subsystems.

This was done in order to avoid situations where hwmon/thermal code uses
features not supported by current firmware version, which is only
validated as part of switch driver initialization.

Later, commit b79cb787ac70 ("mlxsw: Move fw flashing code into core.c")
moved firmware validation and flashing code from the switch driver to
mlxsw_core so that it is performed before driver initialization.

Therefore, change the initialization sequence back to its original form.

In addition to being more straightforward, it will allow us to simplify
parts of the code in subsequent patches and future patchsets.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/core.c | 21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.c b/drivers/net/ethernet/mellanox/mlxsw/core.c
index 98420db90ea1..44803746ded5 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.c
@@ -1995,12 +1995,6 @@ __mlxsw_core_bus_device_register(const struct mlxsw_bus_info *mlxsw_bus_info,
 	if (err)
 		goto err_health_init;
 
-	if (mlxsw_driver->init) {
-		err = mlxsw_driver->init(mlxsw_core, mlxsw_bus_info, extack);
-		if (err)
-			goto err_driver_init;
-	}
-
 	err = mlxsw_hwmon_init(mlxsw_core, mlxsw_bus_info, &mlxsw_core->hwmon);
 	if (err)
 		goto err_hwmon_init;
@@ -2014,6 +2008,12 @@ __mlxsw_core_bus_device_register(const struct mlxsw_bus_info *mlxsw_bus_info,
 	if (err)
 		goto err_env_init;
 
+	if (mlxsw_driver->init) {
+		err = mlxsw_driver->init(mlxsw_core, mlxsw_bus_info, extack);
+		if (err)
+			goto err_driver_init;
+	}
+
 	mlxsw_core->is_initialized = true;
 	devlink_params_publish(devlink);
 
@@ -2022,14 +2022,13 @@ __mlxsw_core_bus_device_register(const struct mlxsw_bus_info *mlxsw_bus_info,
 
 	return 0;
 
+err_driver_init:
+	mlxsw_env_fini(mlxsw_core->env);
 err_env_init:
 	mlxsw_thermal_fini(mlxsw_core->thermal);
 err_thermal_init:
 	mlxsw_hwmon_fini(mlxsw_core->hwmon);
 err_hwmon_init:
-	if (mlxsw_core->driver->fini)
-		mlxsw_core->driver->fini(mlxsw_core);
-err_driver_init:
 	mlxsw_core_health_fini(mlxsw_core);
 err_health_init:
 err_fw_rev_validate:
@@ -2101,11 +2100,11 @@ void mlxsw_core_bus_device_unregister(struct mlxsw_core *mlxsw_core,
 
 	devlink_params_unpublish(devlink);
 	mlxsw_core->is_initialized = false;
+	if (mlxsw_core->driver->fini)
+		mlxsw_core->driver->fini(mlxsw_core);
 	mlxsw_env_fini(mlxsw_core->env);
 	mlxsw_thermal_fini(mlxsw_core->thermal);
 	mlxsw_hwmon_fini(mlxsw_core->hwmon);
-	if (mlxsw_core->driver->fini)
-		mlxsw_core->driver->fini(mlxsw_core);
 	mlxsw_core_health_fini(mlxsw_core);
 	if (!reload)
 		mlxsw_core_params_unregister(mlxsw_core);
-- 
2.31.1

