Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9B4B3122B7
	for <lists+netdev@lfdr.de>; Sun,  7 Feb 2021 09:31:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230208AbhBGIai (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Feb 2021 03:30:38 -0500
Received: from new3-smtp.messagingengine.com ([66.111.4.229]:45475 "EHLO
        new3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230094AbhBGI11 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Feb 2021 03:27:27 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id 553E35801DF;
        Sun,  7 Feb 2021 03:23:50 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Sun, 07 Feb 2021 03:23:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=RtFLUJuEFOTzvMMmE/OWTMRcPlK9a50I0TAFxk/m1mA=; b=CIUe9BVj
        R4wHbxOxJj9Nwux9q+bfVJH+pKdmuSv+qDJtWLcIQR053EjaVu0fBHd1Wh2UJqmn
        FrNJXNlyQ8VrFddKnUScogoT/geKQm5vtyKOspEFPdogjRovTnR3CJGT3GHKOndY
        HsiYWd1q4AW1qldeQHWsqamniEkmIOd9cPZwTXkDrTMd16Gv2l7QwdqJSfS68kd4
        t00u57KT7JdwiOyGyHoMaC8J/VDBJn/ck2/1CnvxRdmZUylJ/P8rt6yDzpS3WwQW
        0uZxiER933waFAVi+MV4abJ33/cB6yRA6o9HIM5LcxpaA9Yt4pSPABok1wSdDQTD
        GYk4+aZn+fiI/w==
X-ME-Sender: <xms:lqMfYP57sMcvggJFG4in4EGnIM3MI9FycNNDgSIwraEYc4ZM3t7MMA>
    <xme:lqMfYE4bqW-oMoP46hJkvZi2n6mW2l6DNcppnpFmaqyrJXjopKNaevvclv_zFoh_c
    qFN2iYRTnOapOo>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrhedtgddvjecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhfekhe
    fgtdfftefhledvjefggfehgfevjeekhfenucfkphepkeegrddvvdelrdduheefrdeggeen
    ucevlhhushhtvghrufhiiigvpeeinecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughosh
    gthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:lqMfYGcM0UADTuHr6_y-I5N4ABl-3ok73S4Zfg-dI9FS40c3a_ZC2w>
    <xmx:lqMfYAI-_m9VimEf6D3lYYzZe76Ic-VJb4HKidPdNXo8KpTpMAI2yw>
    <xmx:lqMfYDL3ET2t1fgZp0m_e2fcy0s4DU1tDIg7Onm5p5dWMbiTB4R4YQ>
    <xmx:lqMfYK_ch43qw1XXVYagCL6Xo69DSkBizLNVFKlROE6_7xPsWDnh5Q>
Received: from shredder.lan (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id 4F4F21080057;
        Sun,  7 Feb 2021 03:23:48 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, dsahern@gmail.com,
        jiri@nvidia.com, yoshfuji@linux-ipv6.org, amcohen@nvidia.com,
        roopa@nvidia.com, bpoirier@nvidia.com, sharpd@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 07/10] netdevsim: dev: Initialize FIB module after debugfs
Date:   Sun,  7 Feb 2021 10:22:55 +0200
Message-Id: <20210207082258.3872086-8-idosch@idosch.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210207082258.3872086-1-idosch@idosch.org>
References: <20210207082258.3872086-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Initialize the dummy FIB offload module after debugfs, so that the FIB
module could create its own directory there.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/netdevsim/dev.c | 40 +++++++++++++++++++------------------
 1 file changed, 21 insertions(+), 19 deletions(-)

diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index 816af1f55e2c..dbeb29fa16e8 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -1012,23 +1012,25 @@ static int nsim_dev_reload_create(struct nsim_dev *nsim_dev,
 	nsim_dev->fw_update_status = true;
 	nsim_dev->fw_update_overwrite_mask = 0;
 
-	nsim_dev->fib_data = nsim_fib_create(devlink, extack);
-	if (IS_ERR(nsim_dev->fib_data))
-		return PTR_ERR(nsim_dev->fib_data);
-
 	nsim_devlink_param_load_driverinit_values(devlink);
 
 	err = nsim_dev_dummy_region_init(nsim_dev, devlink);
 	if (err)
-		goto err_fib_destroy;
+		return err;
 
 	err = nsim_dev_traps_init(devlink);
 	if (err)
 		goto err_dummy_region_exit;
 
+	nsim_dev->fib_data = nsim_fib_create(devlink, extack);
+	if (IS_ERR(nsim_dev->fib_data)) {
+		err = PTR_ERR(nsim_dev->fib_data);
+		goto err_traps_exit;
+	}
+
 	err = nsim_dev_health_init(nsim_dev, devlink);
 	if (err)
-		goto err_traps_exit;
+		goto err_fib_destroy;
 
 	err = nsim_dev_port_add_all(nsim_dev, nsim_bus_dev->port_count);
 	if (err)
@@ -1043,12 +1045,12 @@ static int nsim_dev_reload_create(struct nsim_dev *nsim_dev,
 
 err_health_exit:
 	nsim_dev_health_exit(nsim_dev);
+err_fib_destroy:
+	nsim_fib_destroy(devlink, nsim_dev->fib_data);
 err_traps_exit:
 	nsim_dev_traps_exit(devlink);
 err_dummy_region_exit:
 	nsim_dev_dummy_region_exit(nsim_dev);
-err_fib_destroy:
-	nsim_fib_destroy(devlink, nsim_dev->fib_data);
 	return err;
 }
 
@@ -1080,15 +1082,9 @@ int nsim_dev_probe(struct nsim_bus_dev *nsim_bus_dev)
 	if (err)
 		goto err_devlink_free;
 
-	nsim_dev->fib_data = nsim_fib_create(devlink, NULL);
-	if (IS_ERR(nsim_dev->fib_data)) {
-		err = PTR_ERR(nsim_dev->fib_data);
-		goto err_resources_unregister;
-	}
-
 	err = devlink_register(devlink, &nsim_bus_dev->dev);
 	if (err)
-		goto err_fib_destroy;
+		goto err_resources_unregister;
 
 	err = devlink_params_register(devlink, nsim_devlink_params,
 				      ARRAY_SIZE(nsim_devlink_params));
@@ -1108,9 +1104,15 @@ int nsim_dev_probe(struct nsim_bus_dev *nsim_bus_dev)
 	if (err)
 		goto err_traps_exit;
 
+	nsim_dev->fib_data = nsim_fib_create(devlink, NULL);
+	if (IS_ERR(nsim_dev->fib_data)) {
+		err = PTR_ERR(nsim_dev->fib_data);
+		goto err_debugfs_exit;
+	}
+
 	err = nsim_dev_health_init(nsim_dev, devlink);
 	if (err)
-		goto err_debugfs_exit;
+		goto err_fib_destroy;
 
 	err = nsim_bpf_dev_init(nsim_dev);
 	if (err)
@@ -1128,6 +1130,8 @@ int nsim_dev_probe(struct nsim_bus_dev *nsim_bus_dev)
 	nsim_bpf_dev_exit(nsim_dev);
 err_health_exit:
 	nsim_dev_health_exit(nsim_dev);
+err_fib_destroy:
+	nsim_fib_destroy(devlink, nsim_dev->fib_data);
 err_debugfs_exit:
 	nsim_dev_debugfs_exit(nsim_dev);
 err_traps_exit:
@@ -1139,8 +1143,6 @@ int nsim_dev_probe(struct nsim_bus_dev *nsim_bus_dev)
 				  ARRAY_SIZE(nsim_devlink_params));
 err_dl_unregister:
 	devlink_unregister(devlink);
-err_fib_destroy:
-	nsim_fib_destroy(devlink, nsim_dev->fib_data);
 err_resources_unregister:
 	devlink_resources_unregister(devlink, NULL);
 err_devlink_free:
@@ -1157,10 +1159,10 @@ static void nsim_dev_reload_destroy(struct nsim_dev *nsim_dev)
 	debugfs_remove(nsim_dev->take_snapshot);
 	nsim_dev_port_del_all(nsim_dev);
 	nsim_dev_health_exit(nsim_dev);
+	nsim_fib_destroy(devlink, nsim_dev->fib_data);
 	nsim_dev_traps_exit(devlink);
 	nsim_dev_dummy_region_exit(nsim_dev);
 	mutex_destroy(&nsim_dev->port_list_lock);
-	nsim_fib_destroy(devlink, nsim_dev->fib_data);
 }
 
 void nsim_dev_remove(struct nsim_bus_dev *nsim_bus_dev)
-- 
2.29.2

