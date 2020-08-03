Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C813623A9D7
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 17:46:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727876AbgHCPqp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 11:46:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726805AbgHCPqo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 11:46:44 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 781ABC06174A
        for <netdev@vger.kernel.org>; Mon,  3 Aug 2020 08:46:43 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id f7so34696648wrw.1
        for <netdev@vger.kernel.org>; Mon, 03 Aug 2020 08:46:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=mAe+j/0nTghwHRiGTz7bqhZyukyD2wgy6XxdTQqD+v8=;
        b=xTUvy92kV/iC68uQ+3iUCYFw762jhxFi0ZeFJusm8KBAjNlum2lJSNajQc/AGGYx1p
         AXwPZFJ5wEsxen5jAXKKaPR9BaLSkm1zxDhmpTNVotk8viKJ4P7D11gFuX+IKfVCHXJA
         9m/WbBgjCOggH7IsgHuWlmYVudcEDmvNe5jEtEgU2WJqm1uBk1mttT3jDX3D9j+i/sDZ
         GD3vJGxu/q6nT/F2EZAfbpdYqK7onHIIJIpq9Xgun3ytjH6J1TImgfAfuiXPlHGqbR46
         OMz4pkFql0Of4pMjpzT9hKtmbCb/Kj9VqbyuvqzTMmusGwAsK4g2hPitdq+hFWnKX4G+
         gZbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=mAe+j/0nTghwHRiGTz7bqhZyukyD2wgy6XxdTQqD+v8=;
        b=Oc5BKxf5GbeymRkuPU/66ZQd6ag2Wg4EHDMP9WASwWXdzA8dLZrqd5oFPYWVRIhk9z
         WEgphGiVbKyoNnsdT8/q5DdKuLrjYwq//Gp5NSw4UBOmA8tsyKHP/20MZeekuQvsTzx5
         CNW4d181KrkbOzEBP+YpzvFJYBTBOrHRgxWH3oMHhUdekv5qQZlKLJSXbfhYDHHYqSBv
         +0Pw2cnGDIOjnkXLsYbLfOWqvoxPWJPKDiy5b7DXccRyp/NBB3z+uKLGngwcfVO6n/z+
         zXFWl0dZdI9RWMrLf8pFOImHru46SGkxCtqI1UJkkyZYz87KOInk4HB2wFZM3N/+UNQo
         8Jpg==
X-Gm-Message-State: AOAM531NgZ8TQuktC0jnK+ugxoMMdhbiG+URSfQNjRDiGkZIhnhwfTaF
        oovHAO/Qq36s3p18VmVSM1H3DXklPQ4=
X-Google-Smtp-Source: ABdhPJzSvVaNjEtbUdETz+zHC8qF/2LZW/M+3VRRq1dHTcQYLbwHOx/tRWC1UvAmun4IKRA0LkATcA==
X-Received: by 2002:a5d:548f:: with SMTP id h15mr15839767wrv.331.1596469602094;
        Mon, 03 Aug 2020 08:46:42 -0700 (PDT)
Received: from localhost (ip-89-176-225-97.net.upcbroadband.cz. [89.176.225.97])
        by smtp.gmail.com with ESMTPSA id z207sm26929504wmc.2.2020.08.03.08.46.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Aug 2020 08:46:41 -0700 (PDT)
Date:   Mon, 3 Aug 2020 17:46:40 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     netdev@vger.kernel.org, Jiri Pirko <jiri@mellanox.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Michael Chan <michael.chan@broadcom.com>,
        Bin Luo <luobin9@huawei.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leon@kernel.org>,
        Ido Schimmel <idosch@mellanox.com>,
        Danielle Ratson <danieller@mellanox.com>
Subject: Re: [net-next v2 1/5] devlink: convert flash_update to use params
 structure
Message-ID: <20200803154640.GE2290@nanopsycho>
References: <20200801002159.3300425-1-jacob.e.keller@intel.com>
 <20200801002159.3300425-2-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200801002159.3300425-2-jacob.e.keller@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sat, Aug 01, 2020 at 02:21:55AM CEST, jacob.e.keller@intel.com wrote:
>A future change is going to introduce a new parameter for specifying how
>devices should handle overwrite behavior when updating the flash. This
>will introduce a new argument specifying a bitmask of component
>subsections to allow overwriting behavior.
>
>Prepare for this by converting flash_update to use a new
>devlink_flash_update_params structure. For now this just holds the
>file_name and component, but this enables more easily extending the
>function with new parameters in the future.
>
>To avoid the need for modifying every driver when a new parameter is
>introduced, the supported_flash_update_params field is added to

This is not direstly related to the "params" introduction.
Please split at least to 2 patches.


>devlink_ops. Drivers must opt-in to supported parameters by setting the
>appropriate bits in this field. This allows dropping the check in each
>driver that doesn't support component updates.
>
>Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
>Cc: Jiri Pirko <jiri@mellanox.com>
>Cc: Jakub Kicinski <kuba@kernel.org>
>Cc: Jonathan Corbet <corbet@lwn.net>
>Cc: Michael Chan <michael.chan@broadcom.com>
>Cc: Bin Luo <luobin9@huawei.com>
>Cc: Saeed Mahameed <saeedm@mellanox.com>
>Cc: Leon Romanovsky <leon@kernel.org>
>Cc: Ido Schimmel <idosch@mellanox.com>
>Cc: Danielle Ratson <danieller@mellanox.com>
>---
>
>Changes since v1
>* Add supported_flash_update_params field, to allow drivers to opt-in to the
>  set of supported parameters. This is similar to supported_coalesc_params
>  and was suggested by Jakub. This also makes adding future parameters
>  easier by reducing the need to modify existing drivers! Due to this, the
>  boilerplate check for component is simply removed.
>
>* netdevsim is modified to support the component parameter, and a new simple
>  selftest is added to verify that this works.
>
> .../net/ethernet/broadcom/bnxt/bnxt_devlink.c | 19 ++++-------
> .../net/ethernet/huawei/hinic/hinic_devlink.c |  8 ++---
> drivers/net/ethernet/intel/ice/ice_devlink.c  | 18 ++++------
> .../net/ethernet/mellanox/mlx5/core/devlink.c |  8 ++---
> drivers/net/ethernet/mellanox/mlxsw/core.c    |  6 ++--
> drivers/net/ethernet/mellanox/mlxsw/core.h    |  2 +-
> .../net/ethernet/mellanox/mlxsw/spectrum.c    |  7 ++--
> .../net/ethernet/netronome/nfp/nfp_devlink.c  |  9 +++--
> drivers/net/netdevsim/dev.c                   | 13 ++++----
> include/net/devlink.h                         | 33 +++++++++++++++++--
> net/core/devlink.c                            | 25 ++++++++++----
> .../drivers/net/netdevsim/devlink.sh          |  3 ++
> 12 files changed, 87 insertions(+), 64 deletions(-)
>
>diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
>index 3a854195d5b0..d436134bdc40 100644
>--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
>+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
>@@ -17,15 +17,13 @@
> #include "bnxt_ethtool.h"
> 
> static int
>-bnxt_dl_flash_update(struct devlink *dl, const char *filename,
>-		     const char *region, struct netlink_ext_ack *extack)
>+bnxt_dl_flash_update(struct devlink *dl,
>+		     struct devlink_flash_update_params *params,
>+		     struct netlink_ext_ack *extack)
> {
> 	struct bnxt *bp = bnxt_get_bp_from_dl(dl);
> 	int rc;
> 
>-	if (region)
>-		return -EOPNOTSUPP;
>-
> 	if (!BNXT_PF(bp)) {
> 		NL_SET_ERR_MSG_MOD(extack,
> 				   "flash update not supported from a VF");
>@@ -33,15 +31,12 @@ bnxt_dl_flash_update(struct devlink *dl, const char *filename,
> 	}
> 
> 	devlink_flash_update_begin_notify(dl);
>-	devlink_flash_update_status_notify(dl, "Preparing to flash", region, 0,
>-					   0);
>-	rc = bnxt_flash_package_from_file(bp->dev, filename, 0);
>+	devlink_flash_update_status_notify(dl, "Preparing to flash", NULL, 0, 0);
>+	rc = bnxt_flash_package_from_file(bp->dev, params->file_name, 0);
> 	if (!rc)
>-		devlink_flash_update_status_notify(dl, "Flashing done", region,
>-						   0, 0);
>+		devlink_flash_update_status_notify(dl, "Flashing done", NULL, 0, 0);
> 	else
>-		devlink_flash_update_status_notify(dl, "Flashing failed",
>-						   region, 0, 0);
>+		devlink_flash_update_status_notify(dl, "Flashing failed", NULL, 0, 0);
> 	devlink_flash_update_end_notify(dl);
> 	return rc;
> }
>diff --git a/drivers/net/ethernet/huawei/hinic/hinic_devlink.c b/drivers/net/ethernet/huawei/hinic/hinic_devlink.c
>index c6adc776f3c8..1f45766107e4 100644
>--- a/drivers/net/ethernet/huawei/hinic/hinic_devlink.c
>+++ b/drivers/net/ethernet/huawei/hinic/hinic_devlink.c
>@@ -281,18 +281,14 @@ static int hinic_firmware_update(struct hinic_devlink_priv *priv,
> }
> 
> static int hinic_devlink_flash_update(struct devlink *devlink,
>-				      const char *file_name,
>-				      const char *component,
>+				      struct devlink_flash_update_params *params,
> 				      struct netlink_ext_ack *extack)
> {
> 	struct hinic_devlink_priv *priv = devlink_priv(devlink);
> 	const struct firmware *fw;
> 	int err;
> 
>-	if (component)
>-		return -EOPNOTSUPP;
>-
>-	err = request_firmware_direct(&fw, file_name,
>+	err = request_firmware_direct(&fw, params->file_name,
> 				      &priv->hwdev->hwif->pdev->dev);
> 	if (err)
> 		return err;
>diff --git a/drivers/net/ethernet/intel/ice/ice_devlink.c b/drivers/net/ethernet/intel/ice/ice_devlink.c
>index dbbd8b6f9d1a..c8255235f7c4 100644
>--- a/drivers/net/ethernet/intel/ice/ice_devlink.c
>+++ b/drivers/net/ethernet/intel/ice/ice_devlink.c
>@@ -233,8 +233,7 @@ static int ice_devlink_info_get(struct devlink *devlink,
> /**
>  * ice_devlink_flash_update - Update firmware stored in flash on the device
>  * @devlink: pointer to devlink associated with device to update
>- * @path: the path of the firmware file to use via request_firmware
>- * @component: name of the component to update, or NULL
>+ * @params: flash update parameters
>  * @extack: netlink extended ACK structure
>  *
>  * Perform a device flash update. The bulk of the update logic is contained
>@@ -243,8 +242,9 @@ static int ice_devlink_info_get(struct devlink *devlink,
>  * Returns: zero on success, or an error code on failure.
>  */
> static int
>-ice_devlink_flash_update(struct devlink *devlink, const char *path,
>-			 const char *component, struct netlink_ext_ack *extack)
>+ice_devlink_flash_update(struct devlink *devlink,
>+			 struct devlink_flash_update_params *params,
>+			 struct netlink_ext_ack *extack)
> {
> 	struct ice_pf *pf = devlink_priv(devlink);
> 	struct device *dev = &pf->pdev->dev;
>@@ -252,20 +252,16 @@ ice_devlink_flash_update(struct devlink *devlink, const char *path,
> 	const struct firmware *fw;
> 	int err;
> 
>-	/* individual component update is not yet supported */
>-	if (component)
>-		return -EOPNOTSUPP;
>-
> 	if (!hw->dev_caps.common_cap.nvm_unified_update) {
> 		NL_SET_ERR_MSG_MOD(extack, "Current firmware does not support unified update");
> 		return -EOPNOTSUPP;
> 	}
> 
>-	err = ice_check_for_pending_update(pf, component, extack);
>+	err = ice_check_for_pending_update(pf, NULL, extack);
> 	if (err)
> 		return err;
> 
>-	err = request_firmware(&fw, path, dev);
>+	err = request_firmware(&fw, params->file_name, dev);
> 	if (err) {
> 		NL_SET_ERR_MSG_MOD(extack, "Unable to read file from disk");
> 		return err;
>@@ -273,7 +269,7 @@ ice_devlink_flash_update(struct devlink *devlink, const char *path,
> 
> 	devlink_flash_update_begin_notify(devlink);
> 	devlink_flash_update_status_notify(devlink, "Preparing to flash",
>-					   component, 0, 0);
>+					   NULL, 0, 0);
> 	err = ice_flash_pldm_image(pf, fw, extack);
> 	devlink_flash_update_end_notify(devlink);
> 
>diff --git a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
>index c709e9a385f6..9b14e3f805a2 100644
>--- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
>+++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
>@@ -8,18 +8,14 @@
> #include "eswitch.h"
> 
> static int mlx5_devlink_flash_update(struct devlink *devlink,
>-				     const char *file_name,
>-				     const char *component,
>+				     struct devlink_flash_update_params *params,
> 				     struct netlink_ext_ack *extack)
> {
> 	struct mlx5_core_dev *dev = devlink_priv(devlink);
> 	const struct firmware *fw;
> 	int err;
> 
>-	if (component)
>-		return -EOPNOTSUPP;
>-
>-	err = request_firmware_direct(&fw, file_name, &dev->pdev->dev);
>+	err = request_firmware_direct(&fw, params->file_name, &dev->pdev->dev);
> 	if (err)
> 		return err;
> 
>diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.c b/drivers/net/ethernet/mellanox/mlxsw/core.c
>index b01f8f2fab63..6db938708a0d 100644
>--- a/drivers/net/ethernet/mellanox/mlxsw/core.c
>+++ b/drivers/net/ethernet/mellanox/mlxsw/core.c
>@@ -1138,8 +1138,7 @@ mlxsw_devlink_core_bus_device_reload_up(struct devlink *devlink,
> }
> 
> static int mlxsw_devlink_flash_update(struct devlink *devlink,
>-				      const char *file_name,
>-				      const char *component,
>+				      struct devlink_flash_update_params *params,
> 				      struct netlink_ext_ack *extack)
> {
> 	struct mlxsw_core *mlxsw_core = devlink_priv(devlink);
>@@ -1147,8 +1146,7 @@ static int mlxsw_devlink_flash_update(struct devlink *devlink,
> 
> 	if (!mlxsw_driver->flash_update)
> 		return -EOPNOTSUPP;
>-	return mlxsw_driver->flash_update(mlxsw_core, file_name,
>-					  component, extack);
>+	return mlxsw_driver->flash_update(mlxsw_core, params, extack);
> }
> 
> static int mlxsw_devlink_trap_init(struct devlink *devlink,
>diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.h b/drivers/net/ethernet/mellanox/mlxsw/core.h
>index c1c1e039323a..b6e3faf38305 100644
>--- a/drivers/net/ethernet/mellanox/mlxsw/core.h
>+++ b/drivers/net/ethernet/mellanox/mlxsw/core.h
>@@ -318,7 +318,7 @@ struct mlxsw_driver {
> 				       enum devlink_sb_pool_type pool_type,
> 				       u32 *p_cur, u32 *p_max);
> 	int (*flash_update)(struct mlxsw_core *mlxsw_core,
>-			    const char *file_name, const char *component,
>+			    struct devlink_flash_update_params *params,
> 			    struct netlink_ext_ack *extack);
> 	int (*trap_init)(struct mlxsw_core *mlxsw_core,
> 			 const struct devlink_trap *trap, void *trap_ctx);
>diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
>index 519eb44e4097..6bbf0ab7794c 100644
>--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
>+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
>@@ -418,17 +418,14 @@ static int mlxsw_sp_fw_rev_validate(struct mlxsw_sp *mlxsw_sp)
> }
> 
> static int mlxsw_sp_flash_update(struct mlxsw_core *mlxsw_core,
>-				 const char *file_name, const char *component,
>+				 struct devlink_flash_update_params *params,
> 				 struct netlink_ext_ack *extack)
> {
> 	struct mlxsw_sp *mlxsw_sp = mlxsw_core_driver_priv(mlxsw_core);
> 	const struct firmware *firmware;
> 	int err;
> 
>-	if (component)
>-		return -EOPNOTSUPP;
>-
>-	err = request_firmware_direct(&firmware, file_name,
>+	err = request_firmware_direct(&firmware, params->file_name,
> 				      mlxsw_sp->bus_info->dev);
> 	if (err)
> 		return err;
>diff --git a/drivers/net/ethernet/netronome/nfp/nfp_devlink.c b/drivers/net/ethernet/netronome/nfp/nfp_devlink.c
>index be52510d446b..97d2b03208de 100644
>--- a/drivers/net/ethernet/netronome/nfp/nfp_devlink.c
>+++ b/drivers/net/ethernet/netronome/nfp/nfp_devlink.c
>@@ -329,12 +329,11 @@ nfp_devlink_info_get(struct devlink *devlink, struct devlink_info_req *req,
> }
> 
> static int
>-nfp_devlink_flash_update(struct devlink *devlink, const char *path,
>-			 const char *component, struct netlink_ext_ack *extack)
>+nfp_devlink_flash_update(struct devlink *devlink,
>+			 struct devlink_flash_update_params *params,
>+			 struct netlink_ext_ack *extack)
> {
>-	if (component)
>-		return -EOPNOTSUPP;
>-	return nfp_flash_update_common(devlink_priv(devlink), path, extack);
>+	return nfp_flash_update_common(devlink_priv(devlink), params->file_name, extack);
> }
> 
> const struct devlink_ops nfp_devlink_ops = {
>diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
>index ce719c830a77..29bb25f0f069 100644
>--- a/drivers/net/netdevsim/dev.c
>+++ b/drivers/net/netdevsim/dev.c
>@@ -740,8 +740,8 @@ static int nsim_dev_info_get(struct devlink *devlink,
> #define NSIM_DEV_FLASH_CHUNK_SIZE 1000
> #define NSIM_DEV_FLASH_CHUNK_TIME_MS 10
> 
>-static int nsim_dev_flash_update(struct devlink *devlink, const char *file_name,
>-				 const char *component,
>+static int nsim_dev_flash_update(struct devlink *devlink,
>+				 struct devlink_flash_update_params *params,
> 				 struct netlink_ext_ack *extack)
> {
> 	struct nsim_dev *nsim_dev = devlink_priv(devlink);
>@@ -751,13 +751,13 @@ static int nsim_dev_flash_update(struct devlink *devlink, const char *file_name,
> 		devlink_flash_update_begin_notify(devlink);
> 		devlink_flash_update_status_notify(devlink,
> 						   "Preparing to flash",
>-						   component, 0, 0);
>+						   params->component, 0, 0);
> 	}
> 
> 	for (i = 0; i < NSIM_DEV_FLASH_SIZE / NSIM_DEV_FLASH_CHUNK_SIZE; i++) {
> 		if (nsim_dev->fw_update_status)
> 			devlink_flash_update_status_notify(devlink, "Flashing",
>-							   component,
>+							   params->component,
> 							   i * NSIM_DEV_FLASH_CHUNK_SIZE,
> 							   NSIM_DEV_FLASH_SIZE);
> 		msleep(NSIM_DEV_FLASH_CHUNK_TIME_MS);
>@@ -765,11 +765,11 @@ static int nsim_dev_flash_update(struct devlink *devlink, const char *file_name,
> 
> 	if (nsim_dev->fw_update_status) {
> 		devlink_flash_update_status_notify(devlink, "Flashing",
>-						   component,
>+						   params->component,
> 						   NSIM_DEV_FLASH_SIZE,
> 						   NSIM_DEV_FLASH_SIZE);
> 		devlink_flash_update_status_notify(devlink, "Flashing done",
>-						   component, 0, 0);
>+						   params->component, 0, 0);
> 		devlink_flash_update_end_notify(devlink);
> 	}
> 
>@@ -873,6 +873,7 @@ nsim_dev_devlink_trap_policer_counter_get(struct devlink *devlink,
> }
> 
> static const struct devlink_ops nsim_dev_devlink_ops = {
>+	.supported_flash_update_params = DEVLINK_SUPPORT_FLASH_UPDATE_COMPONENT,
> 	.reload_down = nsim_dev_reload_down,
> 	.reload_up = nsim_dev_reload_up,
> 	.info_get = nsim_dev_info_get,
>diff --git a/include/net/devlink.h b/include/net/devlink.h
>index 19d990c8edcc..192a2c5b6e82 100644
>--- a/include/net/devlink.h
>+++ b/include/net/devlink.h
>@@ -511,6 +511,22 @@ enum devlink_param_generic_id {
> /* Firmware bundle identifier */
> #define DEVLINK_INFO_VERSION_GENERIC_FW_BUNDLE_ID	"fw.bundle_id"
> 
>+/**
>+ * struct devlink_flash_update_params - Flash Update parameters
>+ * @file_name: the name of the flash firmware file to update from
>+ * @component: the flash component to update
>+ *
>+ * With the exception of file_name, drivers must opt-in to parameters by
>+ * setting the appropriate bit in the supported_flash_update_params field in
>+ * their devlink_ops structure.
>+ */
>+struct devlink_flash_update_params {
>+	const char *file_name;
>+	const char *component;
>+};
>+
>+#define DEVLINK_SUPPORT_FLASH_UPDATE_COMPONENT	BIT(0)
>+
> struct devlink_region;
> struct devlink_info_req;
> 
>@@ -985,6 +1001,12 @@ enum devlink_trap_group_generic_id {
> 	}
> 
> struct devlink_ops {
>+	/**
>+	 * @supported_flash_update_params:
>+	 * mask of parameters supported by the driver's .flash_update
>+	 * implemementation.
>+	 */
>+	u32 supported_flash_update_params;
> 	int (*reload_down)(struct devlink *devlink, bool netns_change,
> 			   struct netlink_ext_ack *extack);
> 	int (*reload_up)(struct devlink *devlink,
>@@ -1045,8 +1067,15 @@ struct devlink_ops {
> 				      struct netlink_ext_ack *extack);
> 	int (*info_get)(struct devlink *devlink, struct devlink_info_req *req,
> 			struct netlink_ext_ack *extack);
>-	int (*flash_update)(struct devlink *devlink, const char *file_name,
>-			    const char *component,
>+	/**
>+	 * @flash_update: Device flash update function
>+	 *
>+	 * Used to perform a flash update for the device. The set of
>+	 * parameters supported by the driver should be set in
>+	 * supported_flash_update_params.
>+	 */
>+	int (*flash_update)(struct devlink *devlink,
>+			    struct devlink_flash_update_params *params,
> 			    struct netlink_ext_ack *extack);
> 	/**
> 	 * @trap_init: Trap initialization function.
>diff --git a/net/core/devlink.c b/net/core/devlink.c
>index 0ca89196a367..3ccba85f85c7 100644
>--- a/net/core/devlink.c
>+++ b/net/core/devlink.c
>@@ -3113,22 +3113,32 @@ EXPORT_SYMBOL_GPL(devlink_flash_update_status_notify);
> static int devlink_nl_cmd_flash_update(struct sk_buff *skb,
> 				       struct genl_info *info)
> {
>+	struct devlink_flash_update_params params = {};
> 	struct devlink *devlink = info->user_ptr[0];
>-	const char *file_name, *component;
> 	struct nlattr *nla_component;
>+	u32 supported_params;
> 
> 	if (!devlink->ops->flash_update)
> 		return -EOPNOTSUPP;
> 
> 	if (!info->attrs[DEVLINK_ATTR_FLASH_UPDATE_FILE_NAME])
> 		return -EINVAL;
>-	file_name = nla_data(info->attrs[DEVLINK_ATTR_FLASH_UPDATE_FILE_NAME]);
>+
>+	supported_params = devlink->ops->supported_flash_update_params;

It is a bit odd to have this "flash_update" specific. Perhaps better to
have it as generic devlink "cap"? I can easily imagine this being handy
for other ops too.



>+
>+	params.file_name = nla_data(info->attrs[DEVLINK_ATTR_FLASH_UPDATE_FILE_NAME]);
> 
> 	nla_component = info->attrs[DEVLINK_ATTR_FLASH_UPDATE_COMPONENT];
>-	component = nla_component ? nla_data(nla_component) : NULL;
>+	if (nla_component) {
>+		if (!(supported_params & DEVLINK_SUPPORT_FLASH_UPDATE_COMPONENT)) {
>+			NL_SET_ERR_MSG_ATTR(info->extack, nla_component,
>+					    "component update is not supported");
>+			return -EOPNOTSUPP;
>+		}
>+		params.component = nla_data(nla_component);
>+	}
> 
>-	return devlink->ops->flash_update(devlink, file_name, component,
>-					  info->extack);
>+	return devlink->ops->flash_update(devlink, &params, info->extack);
> }
> 
> static const struct devlink_param devlink_param_generic[] = {
>@@ -9527,6 +9537,7 @@ void devlink_compat_running_version(struct net_device *dev,
> 
> int devlink_compat_flash_update(struct net_device *dev, const char *file_name)
> {
>+	struct devlink_flash_update_params params = {};
> 	struct devlink *devlink;
> 	int ret;
> 
>@@ -9539,8 +9550,10 @@ int devlink_compat_flash_update(struct net_device *dev, const char *file_name)
> 		goto out;
> 	}
> 
>+	params.file_name = file_name;
>+
> 	mutex_lock(&devlink->lock);
>-	ret = devlink->ops->flash_update(devlink, file_name, NULL, NULL);
>+	ret = devlink->ops->flash_update(devlink, &params, NULL);
> 	mutex_unlock(&devlink->lock);
> 
> out:
>diff --git a/tools/testing/selftests/drivers/net/netdevsim/devlink.sh b/tools/testing/selftests/drivers/net/netdevsim/devlink.sh
>index de4b32fc4223..1e7541688978 100755
>--- a/tools/testing/selftests/drivers/net/netdevsim/devlink.sh
>+++ b/tools/testing/selftests/drivers/net/netdevsim/devlink.sh
>@@ -23,6 +23,9 @@ fw_flash_test()
> 	devlink dev flash $DL_HANDLE file dummy
> 	check_err $? "Failed to flash with status updates on"
> 
>+	devlink dev flash $DL_HANDLE file dummy component fw.mgmt

Perhaps you can rather use something made up instead of "fw.mgmt" which
is looking legit and therefor confusing.


>+	check_err $? "Failed to flash with component attribute"
>+
> 	echo "n"> $DEBUGFS_DIR/fw_update_status
> 	check_err $? "Failed to disable status updates"
> 
>-- 
>2.28.0.163.g6104cc2f0b60
>
