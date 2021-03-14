Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6566333A476
	for <lists+netdev@lfdr.de>; Sun, 14 Mar 2021 12:14:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235281AbhCNLOQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Mar 2021 07:14:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235230AbhCNLOH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Mar 2021 07:14:07 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 826A4C061574
        for <netdev@vger.kernel.org>; Sun, 14 Mar 2021 04:13:55 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id u16so7177802wrt.1
        for <netdev@vger.kernel.org>; Sun, 14 Mar 2021 04:13:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=8xPAvMxHmY9pOZ0ZnygmV1N99XR+BZf8XBmni53ESgY=;
        b=z6J3QWAUD5nKc3yZCQ4Wg8qGFur7mKvRy0vsI5FRjSEuyhyNqQIBJpbVYu5BNT44dG
         hYVy3cZLFtt0f/aCvRmDJYchM9tg3u4qmGNJzekJrznushNnni1o/7434/rXMTAw5tYw
         fGVKjU8u1OPfVb4G+oq98lIeH6fZ2FxBY/Ox4e+fDhNRC2DOFI0yXtsjQAfEaKaekLXx
         oLdQVlc1HKIts44VvP3L+zYHe55HYCRpKslJV0cVpFL7Z2ShTjgeR5BRV54A4qTJvQjM
         vDZaJxxohTSGC5WEvgv5I+yPj1WGByZsK1u/os2O2uuE/ZDXVZQSFAIzT+UXpY29URqC
         Hyrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=8xPAvMxHmY9pOZ0ZnygmV1N99XR+BZf8XBmni53ESgY=;
        b=NGeYVOKLWMbvVZnJlmx4FCjx5A4jAlyUDgvTDujPyZ85MdEWaN0lm41SfIcIEZWT80
         OB0okQVHy8Hkj3sjxaAO02ex1FaRezDTtzxC1IRF3RLn+1I0L9i+7Qc1mASkOcvY1CVi
         UuD8oHdxOJSboc73//zlxDsxlY/VgDhtGb73bSs61EVAg7UzjVVUzi75i0ZyOANNqoyz
         amH32E2P/vj/aerW9uN8B6b7AgI2kFC8QZh1U+0XRQCkNwHGRScvKvat5Xw8fhPq+Or4
         Ky7Quq8S6GIm5M8lP0iO+5dBxsZYdzcBEdym2iW/q0JE93zDE88r862j93v6sIkpIDkJ
         q/nQ==
X-Gm-Message-State: AOAM530CejrqTEJ1EsiP+9O2Q6kFusgF63X1Z16LGX4MyCvyiHAhgJfa
        qsmLy+02EsJIqMHPRZWl+URONw==
X-Google-Smtp-Source: ABdhPJwf29Ewk1BVqDqe5JiILemCbN7mEXaTAvkXzrCUuuRmVGP5nkSSndWDQxXhgoQj0SHkx0lF1g==
X-Received: by 2002:adf:e84f:: with SMTP id d15mr22660387wrn.394.1615720434029;
        Sun, 14 Mar 2021 04:13:54 -0700 (PDT)
Received: from localhost.localdomain ([82.142.0.212])
        by smtp.gmail.com with ESMTPSA id i8sm16828330wry.90.2021.03.14.04.13.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Mar 2021 04:13:53 -0700 (PDT)
From:   Daniel Lezcano <daniel.lezcano@linaro.org>
To:     daniel.lezcano@linaro.org, rui.zhang@intel.com
Cc:     linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        lukasz.luba@arm.com, Jiri Pirko <jiri@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Amit Kucheria <amitk@kernel.org>,
        netdev@vger.kernel.org (open list:MELLANOX ETHERNET SWITCH DRIVERS)
Subject: [PATCH v3 1/5] thermal/drivers/core: Use a char pointer for the cooling device name
Date:   Sun, 14 Mar 2021 12:13:29 +0100
Message-Id: <20210314111333.16551-1-daniel.lezcano@linaro.org>
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
Reviewed-by: Lukasz Luba <lukasz.luba@arm.com>
---
V3:
  - Inverted kfree() and put_device() when unregistering the cooling device
    (Reported by Ido Schimmel)
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
index 996c038f83a4..c8d4010940ef 100644
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
@@ -1171,6 +1176,7 @@ void thermal_cooling_device_unregister(struct thermal_cooling_device *cdev)
 	ida_simple_remove(&thermal_cdev_ida, cdev->id);
 	device_del(&cdev->device);
 	thermal_cooling_device_destroy_sysfs(cdev);
+	kfree(cdev->type);
 	put_device(&cdev->device);
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

