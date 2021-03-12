Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A52EA33943D
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 18:04:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232686AbhCLRDk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 12:03:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232583AbhCLRDa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Mar 2021 12:03:30 -0500
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 120C8C061761
        for <netdev@vger.kernel.org>; Fri, 12 Mar 2021 09:03:30 -0800 (PST)
Received: by mail-wm1-x32e.google.com with SMTP id c76-20020a1c9a4f0000b029010c94499aedso16227013wme.0
        for <netdev@vger.kernel.org>; Fri, 12 Mar 2021 09:03:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=UmJ+dlfL89soFWN/JEBNsBQA5pPbGuDlfbh0AQQPANw=;
        b=ph3La2lxZ9YM8An2w7eE8l8N8kYroB/fRE4bTPlrQIMleBr2beFZDadzryFA1IDg/v
         z0WScO60gsTlYnRWXVLxOHNiOFgsGNZfRWz5Tw+wmlsRB10Pfnt+BNeWmV61aNB62Ysl
         AYrLDMueNXjOIWECzDe0X0T+pZ3Vv1BZ313OKdWfmfWcPjjYdsUuEciIUBFXuEw4qLXP
         rSlT/VMGGtD+kkIo8r2RDc34ZmdZo/riGawaiHIIfNzTIPInkQOp9ffCTTuP5k3rPbC6
         /tb/ZZBzjzM+9/V03jr/zHtlpmcQamo83QpQQxtw8v2HG8ziutZWro8nch7EVjvkYQWE
         3enw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=UmJ+dlfL89soFWN/JEBNsBQA5pPbGuDlfbh0AQQPANw=;
        b=tsjy5xr0c1qkuGjHmJtHpHtrxobyqGt87NFEnvcuzR/ziLChDFBIXIshYM68xJRTeG
         1jRExMu+8RU6m515V72DKZxD07ZBt57dUhO3PV1PzrGtBmHHSYT9k39jNE7Uc9uaOW3l
         7qFBsVrYiVIpXtPBqbx5mXSqzxkXcCUkJIYibd1yUpFEA50JyWmVlEDQ6+K7RCDFTVTe
         LH8jhNQ5pJ2SZ84au7FdGP7Qsli4aPLCBtsxp5r3fjQNyQQAN4gEDkvyfdSzT063rfFK
         r9p1isKx5WWsYccUfbosa5U0E+NREepvuH0EecUR0gX606jg6swStGPgDhfCnZDZxjgo
         gPww==
X-Gm-Message-State: AOAM5302PBX36N94IhTfwBWUq9t1TW2dVq6OGR3wikpzdTNSOdHtV8Ck
        35cO0/9CnwNFmO8x7wX0oDdNfQ==
X-Google-Smtp-Source: ABdhPJwv1TR/8z0e66rTrLmmdJhM8/AjWL+UVlEpJ0rrlNrvy7bgYmfjofMpdkr0powCNcQXk6GBKw==
X-Received: by 2002:a7b:ce06:: with SMTP id m6mr13681917wmc.38.1615568608698;
        Fri, 12 Mar 2021 09:03:28 -0800 (PST)
Received: from localhost.localdomain ([82.142.0.212])
        by smtp.gmail.com with ESMTPSA id 1sm2854681wmj.2.2021.03.12.09.03.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Mar 2021 09:03:28 -0800 (PST)
From:   Daniel Lezcano <daniel.lezcano@linaro.org>
To:     daniel.lezcano@linaro.org
Cc:     linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        lukasz.luba@arm.com, Jiri Pirko <jiri@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Zhang Rui <rui.zhang@intel.com>,
        Amit Kucheria <amitk@kernel.org>,
        netdev@vger.kernel.org (open list:MELLANOX ETHERNET SWITCH DRIVERS)
Subject: [PATCH v2 1/5] thermal/drivers/core: Use a char pointer for the cooling device name
Date:   Fri, 12 Mar 2021 18:03:12 +0100
Message-Id: <20210312170316.3138-1-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We want to have any kind of name for the cooling devices as we do no
longer want to rely on auto-numbering. Let's replace the cooling
device's fixed array by a char pointer to be allocated dynamically
when registering the cooling device, so we don't limit the length of
the name.

Rework the error path at the same time as we have to rollback the
allocations in case of error.

Tested with a dummy device having the name:
 "Llanfairpwllgwyngyllgogerychwyrndrobwllllantysiliogogogoch"

A village on the island of Anglesey (Wales), known to have the longest
name in Europe.

Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
---
 .../ethernet/mellanox/mlxsw/core_thermal.c    |  2 +-
 drivers/thermal/thermal_core.c                | 38 +++++++++++--------
 include/linux/thermal.h                       |  2 +-
 3 files changed, 24 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c b/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
index bf85ce9835d7..7447c2a73cbd 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
@@ -141,7 +141,7 @@ static int mlxsw_get_cooling_device_idx(struct mlxsw_thermal *thermal,
 	/* Allow mlxsw thermal zone binding to an external cooling device */
 	for (i = 0; i < ARRAY_SIZE(mlxsw_thermal_external_allowed_cdev); i++) {
 		if (strnstr(cdev->type, mlxsw_thermal_external_allowed_cdev[i],
-			    sizeof(cdev->type)))
+			    strlen(cdev->type)))
 			return 0;
 	}
 
diff --git a/drivers/thermal/thermal_core.c b/drivers/thermal/thermal_core.c
index 996c038f83a4..9ef8090eb645 100644
--- a/drivers/thermal/thermal_core.c
+++ b/drivers/thermal/thermal_core.c
@@ -960,10 +960,7 @@ __thermal_cooling_device_register(struct device_node *np,
 {
 	struct thermal_cooling_device *cdev;
 	struct thermal_zone_device *pos = NULL;
-	int result;
-
-	if (type && strlen(type) >= THERMAL_NAME_LENGTH)
-		return ERR_PTR(-EINVAL);
+	int ret;
 
 	if (!ops || !ops->get_max_state || !ops->get_cur_state ||
 	    !ops->set_cur_state)
@@ -973,14 +970,17 @@ __thermal_cooling_device_register(struct device_node *np,
 	if (!cdev)
 		return ERR_PTR(-ENOMEM);
 
-	result = ida_simple_get(&thermal_cdev_ida, 0, 0, GFP_KERNEL);
-	if (result < 0) {
-		kfree(cdev);
-		return ERR_PTR(result);
+	ret = ida_simple_get(&thermal_cdev_ida, 0, 0, GFP_KERNEL);
+	if (ret < 0)
+		goto out_kfree_cdev;
+	cdev->id = ret;
+
+	cdev->type = kstrdup(type ? type : "", GFP_KERNEL);
+	if (!cdev->type) {
+		ret = -ENOMEM;
+		goto out_ida_remove;
 	}
 
-	cdev->id = result;
-	strlcpy(cdev->type, type ? : "", sizeof(cdev->type));
 	mutex_init(&cdev->lock);
 	INIT_LIST_HEAD(&cdev->thermal_instances);
 	cdev->np = np;
@@ -990,12 +990,9 @@ __thermal_cooling_device_register(struct device_node *np,
 	cdev->devdata = devdata;
 	thermal_cooling_device_setup_sysfs(cdev);
 	dev_set_name(&cdev->device, "cooling_device%d", cdev->id);
-	result = device_register(&cdev->device);
-	if (result) {
-		ida_simple_remove(&thermal_cdev_ida, cdev->id);
-		put_device(&cdev->device);
-		return ERR_PTR(result);
-	}
+	ret = device_register(&cdev->device);
+	if (ret)
+		goto out_kfree_type;
 
 	/* Add 'this' new cdev to the global cdev list */
 	mutex_lock(&thermal_list_lock);
@@ -1013,6 +1010,14 @@ __thermal_cooling_device_register(struct device_node *np,
 	mutex_unlock(&thermal_list_lock);
 
 	return cdev;
+
+out_kfree_type:
+	kfree(cdev->type);
+	put_device(&cdev->device);
+out_ida_remove:
+	ida_simple_remove(&thermal_cdev_ida, cdev->id);
+out_kfree_cdev:
+	return ERR_PTR(ret);
 }
 
 /**
@@ -1172,6 +1177,7 @@ void thermal_cooling_device_unregister(struct thermal_cooling_device *cdev)
 	device_del(&cdev->device);
 	thermal_cooling_device_destroy_sysfs(cdev);
 	put_device(&cdev->device);
+	kfree(cdev->type);
 }
 EXPORT_SYMBOL_GPL(thermal_cooling_device_unregister);
 
diff --git a/include/linux/thermal.h b/include/linux/thermal.h
index 6ac7bb1d2b1f..169502164364 100644
--- a/include/linux/thermal.h
+++ b/include/linux/thermal.h
@@ -91,7 +91,7 @@ struct thermal_cooling_device_ops {
 
 struct thermal_cooling_device {
 	int id;
-	char type[THERMAL_NAME_LENGTH];
+	char *type;
 	struct device device;
 	struct device_node *np;
 	void *devdata;
-- 
2.17.1

