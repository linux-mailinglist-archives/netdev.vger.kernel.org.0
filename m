Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9523660D5E
	for <lists+netdev@lfdr.de>; Sat,  7 Jan 2023 10:49:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229602AbjAGJtk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Jan 2023 04:49:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231550AbjAGJtS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Jan 2023 04:49:18 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02C3B7FEF0
        for <netdev@vger.kernel.org>; Sat,  7 Jan 2023 01:49:17 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id o13so387377pjg.2
        for <netdev@vger.kernel.org>; Sat, 07 Jan 2023 01:49:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vlXI/Z+NskEsmYaLOBvsbuyyifpvV6/dMP1Ffx0qG+8=;
        b=z3x3sB0VtiFo9ukM1Tc1eMSMC5XrqLeqwpB+LruINTxxQGHkf85VA4nlUmmieHqSOG
         01B71YbHO6P0PbfBJn6ZxS9FiE5V/w4nYQdw7qKCN0ToVKi+5L13DirwoRUpUQMFFQJU
         tgS7pXSP3HP8PJgrVj0MoOdmu9W7PF8BLoNj18A3u22CacMS3JUhGjhaQdtD4oRxiwC0
         y1zL8z6QY4PcBmN+nK8bidK7MVXrjN5803bI3HcnP/2x4KWcssbNMjtuR8m3Vx+w/pLh
         nWt28nAhGLWfmebACoJ56eaImivNpO9NZ52GldyD8+cANFgfPt6Ry6hBxvyd5eSPwRLV
         5ELA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vlXI/Z+NskEsmYaLOBvsbuyyifpvV6/dMP1Ffx0qG+8=;
        b=rhgYRLy6Xwk+63pRyFjI5kg7l2TKhdTDqNpv9m9suUFdOaQMcndeUeg5cjn1Uc7bas
         9h5kZVrf84h+Hn5foNHbatF2WOdf8FY9u9BAYC35jHCr1sNnKBTO+KaZWHp4vZzR/L63
         DxTTVyRsHK+hYnlchKVzitpjCE3+2sFalw78qCgBVLktDTyFOcQY53olTJkVzFK2MTnq
         E56kzDXSMqciAcERD9igZbSCC/ZDrUXjgh9DRuva+dLv+21tjJJisrGIntv4xbm8McRg
         92F/4LwWSrF3PjJ7BPSaf8at+TKh0a17z1MU3bHRe5kpdV9Fq3C7jnqgCXqS8dS0FpDn
         DGsg==
X-Gm-Message-State: AFqh2koGvCP/TzuEdcu87E6mLaA631y5N+/Oortk5DuvkUxW1Uucshc9
        a1/e7lZPWGUOTnONuWWH0LvzPeGjSr1bsIGLiqnUrw==
X-Google-Smtp-Source: AMrXdXurC6LwJLNXoccfjpC2B2UrY/Y7FiFl1LXgjN0APvOw1DqSF6ZsrbeZB6KuD7t4rJw1CmVE4A==
X-Received: by 2002:a05:6a20:9592:b0:ad:394e:ac95 with SMTP id iu18-20020a056a20959200b000ad394eac95mr84874706pzb.24.1673084956533;
        Sat, 07 Jan 2023 01:49:16 -0800 (PST)
Received: from localhost (thunderhill.nvidia.com. [216.228.112.22])
        by smtp.gmail.com with ESMTPSA id gb3-20020a17090b060300b0020a11217682sm2183775pjb.27.2023.01.07.01.49.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Jan 2023 01:49:16 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, michael.chan@broadcom.com,
        yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        tariqt@nvidia.com, saeedm@nvidia.com, leon@kernel.org,
        idosch@nvidia.com, petrm@nvidia.com, mailhol.vincent@wanadoo.fr,
        jacob.e.keller@intel.com, maximmi@nvidia.com, gal@nvidia.com
Subject: [patch net-next 1/8] devlink: remove devlink features
Date:   Sat,  7 Jan 2023 10:49:02 +0100
Message-Id: <20230107094909.530239-2-jiri@resnulli.us>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230107094909.530239-1-jiri@resnulli.us>
References: <20230107094909.530239-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

Devlink features were introduced to disallow devlink reload calls of
userspace before the devlink was fully initialized. The reason for this
workaround was the fact that devlink reload was originally called
without devlink instance lock held.

However, with recent changes that converted devlink reload to be
performed under devlink instance lock, this is redundant so remove
devlink features entirely.

Note that mlx5 used this to enable devlink reload conditionally only
when device didn't act as multi port slave. Move the multi port check
into mlx5_devlink_reload_down() callback alongside with the other
checks preventing the device from reload in certain states.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
 .../net/ethernet/broadcom/bnxt/bnxt_devlink.c |  1 -
 .../hisilicon/hns3/hns3pf/hclge_devlink.c     |  1 -
 .../hisilicon/hns3/hns3vf/hclgevf_devlink.c   |  1 -
 drivers/net/ethernet/intel/ice/ice_devlink.c  |  1 -
 drivers/net/ethernet/mellanox/mlx4/main.c     |  1 -
 .../net/ethernet/mellanox/mlx5/core/devlink.c |  9 +++++----
 drivers/net/ethernet/mellanox/mlxsw/core.c    |  1 -
 drivers/net/netdevsim/dev.c                   |  1 -
 net/devlink/core.c                            | 19 -------------------
 net/devlink/devl_internal.h                   |  1 -
 net/devlink/leftover.c                        |  3 ---
 11 files changed, 5 insertions(+), 34 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
index 26913dc816d3..8b3e7697390f 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
@@ -1303,7 +1303,6 @@ int bnxt_dl_register(struct bnxt *bp)
 	if (rc)
 		goto err_dl_port_unreg;
 
-	devlink_set_features(dl, DEVLINK_F_RELOAD);
 out:
 	devlink_register(dl);
 	return 0;
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_devlink.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_devlink.c
index 3d3b69605423..9a939c0b217f 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_devlink.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_devlink.c
@@ -114,7 +114,6 @@ int hclge_devlink_init(struct hclge_dev *hdev)
 	priv->hdev = hdev;
 	hdev->devlink = devlink;
 
-	devlink_set_features(devlink, DEVLINK_F_RELOAD);
 	devlink_register(devlink);
 	return 0;
 }
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_devlink.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_devlink.c
index a6c3c5e8f0ab..1b535142c65a 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_devlink.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_devlink.c
@@ -116,7 +116,6 @@ int hclgevf_devlink_init(struct hclgevf_dev *hdev)
 	priv->hdev = hdev;
 	hdev->devlink = devlink;
 
-	devlink_set_features(devlink, DEVLINK_F_RELOAD);
 	devlink_register(devlink);
 	return 0;
 }
diff --git a/drivers/net/ethernet/intel/ice/ice_devlink.c b/drivers/net/ethernet/intel/ice/ice_devlink.c
index 8286e47b4bae..026f65a4e4ca 100644
--- a/drivers/net/ethernet/intel/ice/ice_devlink.c
+++ b/drivers/net/ethernet/intel/ice/ice_devlink.c
@@ -1376,7 +1376,6 @@ void ice_devlink_register(struct ice_pf *pf)
 {
 	struct devlink *devlink = priv_to_devlink(pf);
 
-	devlink_set_features(devlink, DEVLINK_F_RELOAD);
 	devlink_register(devlink);
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx4/main.c b/drivers/net/ethernet/mellanox/mlx4/main.c
index 3ae246391549..5e7736be2091 100644
--- a/drivers/net/ethernet/mellanox/mlx4/main.c
+++ b/drivers/net/ethernet/mellanox/mlx4/main.c
@@ -4031,7 +4031,6 @@ static int mlx4_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 		goto err_params_unregister;
 
 	pci_save_state(pdev);
-	devlink_set_features(devlink, DEVLINK_F_RELOAD);
 	devl_unlock(devlink);
 	devlink_register(devlink);
 	return 0;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
index 5bd83c0275f8..67bc3ade273a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
@@ -156,6 +156,11 @@ static int mlx5_devlink_reload_down(struct devlink *devlink, bool netns_change,
 		return -EOPNOTSUPP;
 	}
 
+	if (mlx5_core_is_mp_slave(dev)) {
+		NL_SET_ERR_MSG_MOD(extack, "reload is unsupported for multi port slave");
+		return -EOPNOTSUPP;
+	}
+
 	if (pci_num_vf(pdev)) {
 		NL_SET_ERR_MSG_MOD(extack, "reload while VFs are present is unfavorable");
 	}
@@ -871,7 +876,6 @@ void mlx5_devlink_traps_unregister(struct devlink *devlink)
 
 int mlx5_devlink_register(struct devlink *devlink)
 {
-	struct mlx5_core_dev *dev = devlink_priv(devlink);
 	int err;
 
 	err = devlink_params_register(devlink, mlx5_devlink_params,
@@ -889,9 +893,6 @@ int mlx5_devlink_register(struct devlink *devlink)
 	if (err)
 		goto max_uc_list_err;
 
-	if (!mlx5_core_is_mp_slave(dev))
-		devlink_set_features(devlink, DEVLINK_F_RELOAD);
-
 	return 0;
 
 max_uc_list_err:
diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.c b/drivers/net/ethernet/mellanox/mlxsw/core.c
index a0a06e2eff82..0b791706a9c1 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.c
@@ -2211,7 +2211,6 @@ __mlxsw_core_bus_device_register(const struct mlxsw_bus_info *mlxsw_bus_info,
 	}
 
 	if (!reload) {
-		devlink_set_features(devlink, DEVLINK_F_RELOAD);
 		devl_unlock(devlink);
 		devlink_register(devlink);
 	}
diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index 738784fda117..35a0fb683801 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -1609,7 +1609,6 @@ int nsim_drv_probe(struct nsim_bus_dev *nsim_bus_dev)
 		goto err_hwstats_exit;
 
 	nsim_dev->esw_mode = DEVLINK_ESWITCH_MODE_LEGACY;
-	devlink_set_features(devlink, DEVLINK_F_RELOAD);
 	devl_unlock(devlink);
 	return 0;
 
diff --git a/net/devlink/core.c b/net/devlink/core.c
index a31a317626d7..4014a01c8f3d 100644
--- a/net/devlink/core.c
+++ b/net/devlink/core.c
@@ -114,23 +114,6 @@ struct devlink *devlinks_xa_find_get(struct net *net, unsigned long *indexp)
 	goto retry;
 }
 
-/**
- *	devlink_set_features - Set devlink supported features
- *
- *	@devlink: devlink
- *	@features: devlink support features
- *
- *	This interface allows us to set reload ops separatelly from
- *	the devlink_alloc.
- */
-void devlink_set_features(struct devlink *devlink, u64 features)
-{
-	WARN_ON(features & DEVLINK_F_RELOAD &&
-		!devlink_reload_supported(devlink->ops));
-	devlink->features = features;
-}
-EXPORT_SYMBOL_GPL(devlink_set_features);
-
 /**
  * devl_register - Register devlink instance
  * @devlink: devlink
@@ -297,7 +280,6 @@ static void __net_exit devlink_pernet_pre_exit(struct net *net)
 	 * all devlink instances from this namespace into init_net.
 	 */
 	devlinks_xa_for_each_registered_get(net, index, devlink) {
-		WARN_ON(!(devlink->features & DEVLINK_F_RELOAD));
 		devl_lock(devlink);
 		err = 0;
 		if (devl_is_registered(devlink))
@@ -307,7 +289,6 @@ static void __net_exit devlink_pernet_pre_exit(struct net *net)
 					     &actions_performed, NULL);
 		devl_unlock(devlink);
 		devlink_put(devlink);
-
 		if (err && err != -EOPNOTSUPP)
 			pr_warn("Failed to reload devlink instance into init_net\n");
 	}
diff --git a/net/devlink/devl_internal.h b/net/devlink/devl_internal.h
index 5d2bbe295659..82268c4579a3 100644
--- a/net/devlink/devl_internal.h
+++ b/net/devlink/devl_internal.h
@@ -39,7 +39,6 @@ struct devlink {
 	struct list_head linecard_list;
 	struct mutex linecards_lock; /* protects linecard_list */
 	const struct devlink_ops *ops;
-	u64 features;
 	struct xarray snapshot_ids;
 	struct devlink_dev_stats stats;
 	struct device *dev;
diff --git a/net/devlink/leftover.c b/net/devlink/leftover.c
index 1e23b2da78cc..478b81b85f03 100644
--- a/net/devlink/leftover.c
+++ b/net/devlink/leftover.c
@@ -4429,9 +4429,6 @@ static int devlink_nl_cmd_reload(struct sk_buff *skb, struct genl_info *info)
 	u32 actions_performed;
 	int err;
 
-	if (!(devlink->features & DEVLINK_F_RELOAD))
-		return -EOPNOTSUPP;
-
 	err = devlink_resources_validate(devlink, NULL, info);
 	if (err) {
 		NL_SET_ERR_MSG_MOD(info->extack, "resources size validation failed");
-- 
2.39.0

