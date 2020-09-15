Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA75626A11C
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 10:42:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726303AbgIOIlz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 04:41:55 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:46371 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726185AbgIOIls (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Sep 2020 04:41:48 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id F11755C013E;
        Tue, 15 Sep 2020 04:41:45 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Tue, 15 Sep 2020 04:41:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=gJQbDLcH3AsaJ/eybp4IunDPP875nK8e3LbB660peb4=; b=bS+absek
        xUG6qt2zLVo62f0AQDrLhAz9hqe/r5QTgR+yW7tlm2sakY/4D/zHI5KoLrVSlszr
        U8+QpEe1CzQwEovz8qsqrwu54dFMDJ3uVdXO+Z7JFzM26iOqRviFzNV5TTmiEjH5
        FT48LHGnnZ+be5N0UEsK2j0dLazkHTvHVtQAw9XKzGxKf09WBK/I7W4uuYevez3C
        MQfunIjwsCIxwLuI494t3YW8yupkefhHZMvAvs6p4L9jZ5QEBkB3WHHuvZrJGbnO
        fS1gIQgxshS3VrkmVRxcJPqI+vAPHejvsefQyvFf1LoLYvSe2sQhMUgXuyMYmlg9
        TUv/kfWhRh5rkA==
X-ME-Sender: <xms:SX5gX2bmaV-pRTeLEE-lFJPCeHn4ctUuj0l0cW9wjT4CDXfdEV4IYQ>
    <xme:SX5gX5bZFOfLh0jkEcZGMxo98HxfdhzSSkqymuryExKNKZAUTRua4W1vOp4z_T5RA
    hXMuimYrR-lNx8>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrudeikedgtdejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrfeeirdekvden
    ucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughosh
    gthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:SX5gXw_BBcG5F55qGBO5FLc058FJ76Ko-DP6ZUx2pFfiSKZzjD5tMw>
    <xmx:SX5gX4oZnpt48CN2V7CsvAPSxEyFjAPZYfnBjSi99NwwG6s6vYQanw>
    <xmx:SX5gXxqgvsA5XgAzOW8jseGIhO7_q3OMSeogTaheDZXlnWhuGEQ5XA>
    <xmx:SX5gX43Wj0QDxBKecrcqrhtl5_bn0e3IVvlZTQkW54n5OXypurevIQ>
Received: from shredder.mtl.com (igld-84-229-36-82.inter.net.il [84.229.36.82])
        by mail.messagingengine.com (Postfix) with ESMTPA id 014FD306467E;
        Tue, 15 Sep 2020 04:41:43 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 2/8] mlxsw: Move fw flashing code into core.c
Date:   Tue, 15 Sep 2020 11:40:52 +0300
Message-Id: <20200915084058.18555-3-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200915084058.18555-1-idosch@idosch.org>
References: <20200915084058.18555-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

As the firmware flashing is not specific to Spectrum, move the code to
core.c and avoid one op call and 2 exported symbols. Also, this allows
to do flash before call of driver->init function and possibly do other
core calls in between.

Do some small renaming here and there on the way to be consistent with
the rest of core.c code.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/core.c    | 277 +++++++++++++++--
 drivers/net/ethernet/mellanox/mlxsw/core.h    |   8 +-
 .../net/ethernet/mellanox/mlxsw/spectrum.c    | 288 +-----------------
 .../net/ethernet/mellanox/mlxsw/spectrum.h    |   2 -
 4 files changed, 268 insertions(+), 307 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.c b/drivers/net/ethernet/mellanox/mlxsw/core.c
index ec45a03140d7..fa892e3cd6f9 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.c
@@ -20,6 +20,7 @@
 #include <linux/rcupdate.h>
 #include <linux/slab.h>
 #include <linux/workqueue.h>
+#include <linux/firmware.h>
 #include <asm/byteorder.h>
 #include <net/devlink.h>
 #include <trace/events/devlink.h>
@@ -32,6 +33,7 @@
 #include "emad.h"
 #include "reg.h"
 #include "resources.h"
+#include "../mlxfw/mlxfw.h"
 
 static LIST_HEAD(mlxsw_core_driver_list);
 static DEFINE_SPINLOCK(mlxsw_core_driver_list_lock);
@@ -864,6 +866,257 @@ static struct mlxsw_driver *mlxsw_core_driver_get(const char *kind)
 	return mlxsw_driver;
 }
 
+struct mlxsw_core_fw_info {
+	struct mlxfw_dev mlxfw_dev;
+	struct mlxsw_core *mlxsw_core;
+};
+
+static int mlxsw_core_fw_component_query(struct mlxfw_dev *mlxfw_dev,
+					 u16 component_index, u32 *p_max_size,
+					 u8 *p_align_bits, u16 *p_max_write_size)
+{
+	struct mlxsw_core_fw_info *mlxsw_core_fw_info =
+		container_of(mlxfw_dev, struct mlxsw_core_fw_info, mlxfw_dev);
+	struct mlxsw_core *mlxsw_core = mlxsw_core_fw_info->mlxsw_core;
+	char mcqi_pl[MLXSW_REG_MCQI_LEN];
+	int err;
+
+	mlxsw_reg_mcqi_pack(mcqi_pl, component_index);
+	err = mlxsw_reg_query(mlxsw_core, MLXSW_REG(mcqi), mcqi_pl);
+	if (err)
+		return err;
+	mlxsw_reg_mcqi_unpack(mcqi_pl, p_max_size, p_align_bits, p_max_write_size);
+
+	*p_align_bits = max_t(u8, *p_align_bits, 2);
+	*p_max_write_size = min_t(u16, *p_max_write_size, MLXSW_REG_MCDA_MAX_DATA_LEN);
+	return 0;
+}
+
+static int mlxsw_core_fw_fsm_lock(struct mlxfw_dev *mlxfw_dev, u32 *fwhandle)
+{
+	struct mlxsw_core_fw_info *mlxsw_core_fw_info =
+		container_of(mlxfw_dev, struct mlxsw_core_fw_info, mlxfw_dev);
+	struct mlxsw_core *mlxsw_core = mlxsw_core_fw_info->mlxsw_core;
+	char mcc_pl[MLXSW_REG_MCC_LEN];
+	u8 control_state;
+	int err;
+
+	mlxsw_reg_mcc_pack(mcc_pl, 0, 0, 0, 0);
+	err = mlxsw_reg_query(mlxsw_core, MLXSW_REG(mcc), mcc_pl);
+	if (err)
+		return err;
+
+	mlxsw_reg_mcc_unpack(mcc_pl, fwhandle, NULL, &control_state);
+	if (control_state != MLXFW_FSM_STATE_IDLE)
+		return -EBUSY;
+
+	mlxsw_reg_mcc_pack(mcc_pl, MLXSW_REG_MCC_INSTRUCTION_LOCK_UPDATE_HANDLE, 0, *fwhandle, 0);
+	return mlxsw_reg_write(mlxsw_core, MLXSW_REG(mcc), mcc_pl);
+}
+
+static int mlxsw_core_fw_fsm_component_update(struct mlxfw_dev *mlxfw_dev, u32 fwhandle,
+					      u16 component_index, u32 component_size)
+{
+	struct mlxsw_core_fw_info *mlxsw_core_fw_info =
+		container_of(mlxfw_dev, struct mlxsw_core_fw_info, mlxfw_dev);
+	struct mlxsw_core *mlxsw_core = mlxsw_core_fw_info->mlxsw_core;
+	char mcc_pl[MLXSW_REG_MCC_LEN];
+
+	mlxsw_reg_mcc_pack(mcc_pl, MLXSW_REG_MCC_INSTRUCTION_UPDATE_COMPONENT,
+			   component_index, fwhandle, component_size);
+	return mlxsw_reg_write(mlxsw_core, MLXSW_REG(mcc), mcc_pl);
+}
+
+static int mlxsw_core_fw_fsm_block_download(struct mlxfw_dev *mlxfw_dev, u32 fwhandle,
+					    u8 *data, u16 size, u32 offset)
+{
+	struct mlxsw_core_fw_info *mlxsw_core_fw_info =
+		container_of(mlxfw_dev, struct mlxsw_core_fw_info, mlxfw_dev);
+	struct mlxsw_core *mlxsw_core = mlxsw_core_fw_info->mlxsw_core;
+	char mcda_pl[MLXSW_REG_MCDA_LEN];
+
+	mlxsw_reg_mcda_pack(mcda_pl, fwhandle, offset, size, data);
+	return mlxsw_reg_write(mlxsw_core, MLXSW_REG(mcda), mcda_pl);
+}
+
+static int mlxsw_core_fw_fsm_component_verify(struct mlxfw_dev *mlxfw_dev, u32 fwhandle,
+					      u16 component_index)
+{
+	struct mlxsw_core_fw_info *mlxsw_core_fw_info =
+		container_of(mlxfw_dev, struct mlxsw_core_fw_info, mlxfw_dev);
+	struct mlxsw_core *mlxsw_core = mlxsw_core_fw_info->mlxsw_core;
+	char mcc_pl[MLXSW_REG_MCC_LEN];
+
+	mlxsw_reg_mcc_pack(mcc_pl, MLXSW_REG_MCC_INSTRUCTION_VERIFY_COMPONENT,
+			   component_index, fwhandle, 0);
+	return mlxsw_reg_write(mlxsw_core, MLXSW_REG(mcc), mcc_pl);
+}
+
+static int mlxsw_core_fw_fsm_activate(struct mlxfw_dev *mlxfw_dev, u32 fwhandle)
+{
+	struct mlxsw_core_fw_info *mlxsw_core_fw_info =
+		container_of(mlxfw_dev, struct mlxsw_core_fw_info, mlxfw_dev);
+	struct mlxsw_core *mlxsw_core = mlxsw_core_fw_info->mlxsw_core;
+	char mcc_pl[MLXSW_REG_MCC_LEN];
+
+	mlxsw_reg_mcc_pack(mcc_pl, MLXSW_REG_MCC_INSTRUCTION_ACTIVATE, 0, fwhandle, 0);
+	return mlxsw_reg_write(mlxsw_core, MLXSW_REG(mcc), mcc_pl);
+}
+
+static int mlxsw_core_fw_fsm_query_state(struct mlxfw_dev *mlxfw_dev, u32 fwhandle,
+					 enum mlxfw_fsm_state *fsm_state,
+					 enum mlxfw_fsm_state_err *fsm_state_err)
+{
+	struct mlxsw_core_fw_info *mlxsw_core_fw_info =
+		container_of(mlxfw_dev, struct mlxsw_core_fw_info, mlxfw_dev);
+	struct mlxsw_core *mlxsw_core = mlxsw_core_fw_info->mlxsw_core;
+	char mcc_pl[MLXSW_REG_MCC_LEN];
+	u8 control_state;
+	u8 error_code;
+	int err;
+
+	mlxsw_reg_mcc_pack(mcc_pl, 0, 0, fwhandle, 0);
+	err = mlxsw_reg_query(mlxsw_core, MLXSW_REG(mcc), mcc_pl);
+	if (err)
+		return err;
+
+	mlxsw_reg_mcc_unpack(mcc_pl, NULL, &error_code, &control_state);
+	*fsm_state = control_state;
+	*fsm_state_err = min_t(enum mlxfw_fsm_state_err, error_code, MLXFW_FSM_STATE_ERR_MAX);
+	return 0;
+}
+
+static void mlxsw_core_fw_fsm_cancel(struct mlxfw_dev *mlxfw_dev, u32 fwhandle)
+{
+	struct mlxsw_core_fw_info *mlxsw_core_fw_info =
+		container_of(mlxfw_dev, struct mlxsw_core_fw_info, mlxfw_dev);
+	struct mlxsw_core *mlxsw_core = mlxsw_core_fw_info->mlxsw_core;
+	char mcc_pl[MLXSW_REG_MCC_LEN];
+
+	mlxsw_reg_mcc_pack(mcc_pl, MLXSW_REG_MCC_INSTRUCTION_CANCEL, 0, fwhandle, 0);
+	mlxsw_reg_write(mlxsw_core, MLXSW_REG(mcc), mcc_pl);
+}
+
+static void mlxsw_core_fw_fsm_release(struct mlxfw_dev *mlxfw_dev, u32 fwhandle)
+{
+	struct mlxsw_core_fw_info *mlxsw_core_fw_info =
+		container_of(mlxfw_dev, struct mlxsw_core_fw_info, mlxfw_dev);
+	struct mlxsw_core *mlxsw_core = mlxsw_core_fw_info->mlxsw_core;
+	char mcc_pl[MLXSW_REG_MCC_LEN];
+
+	mlxsw_reg_mcc_pack(mcc_pl, MLXSW_REG_MCC_INSTRUCTION_RELEASE_UPDATE_HANDLE, 0, fwhandle, 0);
+	mlxsw_reg_write(mlxsw_core, MLXSW_REG(mcc), mcc_pl);
+}
+
+static const struct mlxfw_dev_ops mlxsw_core_fw_mlxsw_dev_ops = {
+	.component_query	= mlxsw_core_fw_component_query,
+	.fsm_lock		= mlxsw_core_fw_fsm_lock,
+	.fsm_component_update	= mlxsw_core_fw_fsm_component_update,
+	.fsm_block_download	= mlxsw_core_fw_fsm_block_download,
+	.fsm_component_verify	= mlxsw_core_fw_fsm_component_verify,
+	.fsm_activate		= mlxsw_core_fw_fsm_activate,
+	.fsm_query_state	= mlxsw_core_fw_fsm_query_state,
+	.fsm_cancel		= mlxsw_core_fw_fsm_cancel,
+	.fsm_release		= mlxsw_core_fw_fsm_release,
+};
+
+static int mlxsw_core_fw_flash(struct mlxsw_core *mlxsw_core, const struct firmware *firmware,
+			       struct netlink_ext_ack *extack)
+{
+	struct mlxsw_core_fw_info mlxsw_core_fw_info = {
+		.mlxfw_dev = {
+			.ops = &mlxsw_core_fw_mlxsw_dev_ops,
+			.psid = mlxsw_core->bus_info->psid,
+			.psid_size = strlen(mlxsw_core->bus_info->psid),
+			.devlink = priv_to_devlink(mlxsw_core),
+		},
+		.mlxsw_core = mlxsw_core
+	};
+	int err;
+
+	mlxsw_core->fw_flash_in_progress = true;
+	err = mlxfw_firmware_flash(&mlxsw_core_fw_info.mlxfw_dev, firmware, extack);
+	mlxsw_core->fw_flash_in_progress = false;
+
+	return err;
+}
+
+static int mlxsw_core_fw_rev_validate(struct mlxsw_core *mlxsw_core,
+				      const struct mlxsw_bus_info *mlxsw_bus_info,
+				      const struct mlxsw_fw_rev *req_rev,
+				      const char *filename)
+{
+	const struct mlxsw_fw_rev *rev = &mlxsw_bus_info->fw_rev;
+	union devlink_param_value value;
+	const struct firmware *firmware;
+	int err;
+
+	/* Don't check if driver does not require it */
+	if (!req_rev || !filename)
+		return 0;
+
+	/* Don't check if devlink 'fw_load_policy' param is 'flash' */
+	err = devlink_param_driverinit_value_get(priv_to_devlink(mlxsw_core),
+						 DEVLINK_PARAM_GENERIC_ID_FW_LOAD_POLICY,
+						 &value);
+	if (err)
+		return err;
+	if (value.vu8 == DEVLINK_PARAM_FW_LOAD_POLICY_VALUE_FLASH)
+		return 0;
+
+	/* Validate driver & FW are compatible */
+	if (rev->major != req_rev->major) {
+		WARN(1, "Mismatch in major FW version [%d:%d] is never expected; Please contact support\n",
+		     rev->major, req_rev->major);
+		return -EINVAL;
+	}
+	if (mlxsw_core_fw_rev_minor_subminor_validate(rev, req_rev))
+		return 0;
+
+	dev_err(mlxsw_bus_info->dev, "The firmware version %d.%d.%d is incompatible with the driver (required >= %d.%d.%d)\n",
+		rev->major, rev->minor, rev->subminor, req_rev->major,
+		req_rev->minor, req_rev->subminor);
+	dev_info(mlxsw_bus_info->dev, "Flashing firmware using file %s\n", filename);
+
+	err = request_firmware_direct(&firmware, filename, mlxsw_bus_info->dev);
+	if (err) {
+		dev_err(mlxsw_bus_info->dev, "Could not request firmware file %s\n", filename);
+		return err;
+	}
+
+	err = mlxsw_core_fw_flash(mlxsw_core, firmware, NULL);
+	release_firmware(firmware);
+	if (err)
+		dev_err(mlxsw_bus_info->dev, "Could not upgrade firmware\n");
+
+	/* On FW flash success, tell the caller FW reset is needed
+	 * if current FW supports it.
+	 */
+	if (rev->minor >= req_rev->can_reset_minor)
+		return err ? err : -EAGAIN;
+	else
+		return 0;
+}
+
+static int mlxsw_core_fw_flash_update(struct mlxsw_core *mlxsw_core,
+				      const char *file_name, const char *component,
+				      struct netlink_ext_ack *extack)
+{
+	const struct firmware *firmware;
+	int err;
+
+	if (component)
+		return -EOPNOTSUPP;
+
+	err = request_firmware_direct(&firmware, file_name, mlxsw_core->bus_info->dev);
+	if (err)
+		return err;
+	err = mlxsw_core_fw_flash(mlxsw_core, firmware, extack);
+	release_firmware(firmware);
+
+	return err;
+}
+
 static int mlxsw_devlink_port_split(struct devlink *devlink,
 				    unsigned int port_index,
 				    unsigned int count,
@@ -1143,12 +1396,8 @@ static int mlxsw_devlink_flash_update(struct devlink *devlink,
 				      struct netlink_ext_ack *extack)
 {
 	struct mlxsw_core *mlxsw_core = devlink_priv(devlink);
-	struct mlxsw_driver *mlxsw_driver = mlxsw_core->driver;
 
-	if (!mlxsw_driver->flash_update)
-		return -EOPNOTSUPP;
-	return mlxsw_driver->flash_update(mlxsw_core, file_name,
-					  component, extack);
+	return mlxsw_core_fw_flash_update(mlxsw_core, file_name, component, extack);
 }
 
 static int mlxsw_devlink_trap_init(struct devlink *devlink,
@@ -1374,6 +1623,11 @@ __mlxsw_core_bus_device_register(const struct mlxsw_bus_info *mlxsw_bus_info,
 			goto err_register_params;
 	}
 
+	err = mlxsw_core_fw_rev_validate(mlxsw_core, mlxsw_bus_info, mlxsw_driver->fw_req_rev,
+					 mlxsw_driver->fw_filename);
+	if (err)
+		goto err_fw_rev_validate;
+
 	if (mlxsw_driver->init) {
 		err = mlxsw_driver->init(mlxsw_core, mlxsw_bus_info, extack);
 		if (err)
@@ -1403,6 +1657,7 @@ __mlxsw_core_bus_device_register(const struct mlxsw_bus_info *mlxsw_bus_info,
 	if (mlxsw_core->driver->fini)
 		mlxsw_core->driver->fini(mlxsw_core);
 err_driver_init:
+err_fw_rev_validate:
 	if (mlxsw_driver->params_unregister && !reload)
 		mlxsw_driver->params_unregister(mlxsw_core);
 err_register_params:
@@ -2410,18 +2665,6 @@ int mlxsw_core_kvd_sizes_get(struct mlxsw_core *mlxsw_core,
 }
 EXPORT_SYMBOL(mlxsw_core_kvd_sizes_get);
 
-void mlxsw_core_fw_flash_start(struct mlxsw_core *mlxsw_core)
-{
-	mlxsw_core->fw_flash_in_progress = true;
-}
-EXPORT_SYMBOL(mlxsw_core_fw_flash_start);
-
-void mlxsw_core_fw_flash_end(struct mlxsw_core *mlxsw_core)
-{
-	mlxsw_core->fw_flash_in_progress = false;
-}
-EXPORT_SYMBOL(mlxsw_core_fw_flash_end);
-
 int mlxsw_core_resources_query(struct mlxsw_core *mlxsw_core, char *mbox,
 			       struct mlxsw_res *res)
 {
diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.h b/drivers/net/ethernet/mellanox/mlxsw/core.h
index 11af3308f8cc..6ec769906637 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.h
@@ -280,6 +280,8 @@ struct mlxsw_driver {
 	struct list_head list;
 	const char *kind;
 	size_t priv_size;
+	const struct mlxsw_fw_rev *fw_req_rev;
+	const char *fw_filename;
 	int (*init)(struct mlxsw_core *mlxsw_core,
 		    const struct mlxsw_bus_info *mlxsw_bus_info,
 		    struct netlink_ext_ack *extack);
@@ -324,9 +326,6 @@ struct mlxsw_driver {
 				       unsigned int sb_index, u16 tc_index,
 				       enum devlink_sb_pool_type pool_type,
 				       u32 *p_cur, u32 *p_max);
-	int (*flash_update)(struct mlxsw_core *mlxsw_core,
-			    const char *file_name, const char *component,
-			    struct netlink_ext_ack *extack);
 	int (*trap_init)(struct mlxsw_core *mlxsw_core,
 			 const struct devlink_trap *trap, void *trap_ctx);
 	void (*trap_fini)(struct mlxsw_core *mlxsw_core,
@@ -378,9 +377,6 @@ int mlxsw_core_kvd_sizes_get(struct mlxsw_core *mlxsw_core,
 			     u64 *p_single_size, u64 *p_double_size,
 			     u64 *p_linear_size);
 
-void mlxsw_core_fw_flash_start(struct mlxsw_core *mlxsw_core);
-void mlxsw_core_fw_flash_end(struct mlxsw_core *mlxsw_core);
-
 u32 mlxsw_core_read_frc_h(struct mlxsw_core *mlxsw_core);
 u32 mlxsw_core_read_frc_l(struct mlxsw_core *mlxsw_core);
 
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 3ef4b4922fea..75742db632e9 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -42,7 +42,6 @@
 #include "spectrum_span.h"
 #include "spectrum_ptp.h"
 #include "spectrum_trap.h"
-#include "../mlxfw/mlxfw.h"
 
 #define MLXSW_SP1_FWREV_MAJOR 13
 #define MLXSW_SP1_FWREV_MINOR 2008
@@ -170,274 +169,6 @@ MLXSW_ITEM32(tx, hdr, fid, 0x08, 0, 16);
  */
 MLXSW_ITEM32(tx, hdr, type, 0x0C, 0, 4);
 
-struct mlxsw_sp_mlxfw_dev {
-	struct mlxfw_dev mlxfw_dev;
-	struct mlxsw_sp *mlxsw_sp;
-};
-
-static int mlxsw_sp_component_query(struct mlxfw_dev *mlxfw_dev,
-				    u16 component_index, u32 *p_max_size,
-				    u8 *p_align_bits, u16 *p_max_write_size)
-{
-	struct mlxsw_sp_mlxfw_dev *mlxsw_sp_mlxfw_dev =
-		container_of(mlxfw_dev, struct mlxsw_sp_mlxfw_dev, mlxfw_dev);
-	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_mlxfw_dev->mlxsw_sp;
-	char mcqi_pl[MLXSW_REG_MCQI_LEN];
-	int err;
-
-	mlxsw_reg_mcqi_pack(mcqi_pl, component_index);
-	err = mlxsw_reg_query(mlxsw_sp->core, MLXSW_REG(mcqi), mcqi_pl);
-	if (err)
-		return err;
-	mlxsw_reg_mcqi_unpack(mcqi_pl, p_max_size, p_align_bits,
-			      p_max_write_size);
-
-	*p_align_bits = max_t(u8, *p_align_bits, 2);
-	*p_max_write_size = min_t(u16, *p_max_write_size,
-				  MLXSW_REG_MCDA_MAX_DATA_LEN);
-	return 0;
-}
-
-static int mlxsw_sp_fsm_lock(struct mlxfw_dev *mlxfw_dev, u32 *fwhandle)
-{
-	struct mlxsw_sp_mlxfw_dev *mlxsw_sp_mlxfw_dev =
-		container_of(mlxfw_dev, struct mlxsw_sp_mlxfw_dev, mlxfw_dev);
-	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_mlxfw_dev->mlxsw_sp;
-	char mcc_pl[MLXSW_REG_MCC_LEN];
-	u8 control_state;
-	int err;
-
-	mlxsw_reg_mcc_pack(mcc_pl, 0, 0, 0, 0);
-	err = mlxsw_reg_query(mlxsw_sp->core, MLXSW_REG(mcc), mcc_pl);
-	if (err)
-		return err;
-
-	mlxsw_reg_mcc_unpack(mcc_pl, fwhandle, NULL, &control_state);
-	if (control_state != MLXFW_FSM_STATE_IDLE)
-		return -EBUSY;
-
-	mlxsw_reg_mcc_pack(mcc_pl,
-			   MLXSW_REG_MCC_INSTRUCTION_LOCK_UPDATE_HANDLE,
-			   0, *fwhandle, 0);
-	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(mcc), mcc_pl);
-}
-
-static int mlxsw_sp_fsm_component_update(struct mlxfw_dev *mlxfw_dev,
-					 u32 fwhandle, u16 component_index,
-					 u32 component_size)
-{
-	struct mlxsw_sp_mlxfw_dev *mlxsw_sp_mlxfw_dev =
-		container_of(mlxfw_dev, struct mlxsw_sp_mlxfw_dev, mlxfw_dev);
-	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_mlxfw_dev->mlxsw_sp;
-	char mcc_pl[MLXSW_REG_MCC_LEN];
-
-	mlxsw_reg_mcc_pack(mcc_pl, MLXSW_REG_MCC_INSTRUCTION_UPDATE_COMPONENT,
-			   component_index, fwhandle, component_size);
-	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(mcc), mcc_pl);
-}
-
-static int mlxsw_sp_fsm_block_download(struct mlxfw_dev *mlxfw_dev,
-				       u32 fwhandle, u8 *data, u16 size,
-				       u32 offset)
-{
-	struct mlxsw_sp_mlxfw_dev *mlxsw_sp_mlxfw_dev =
-		container_of(mlxfw_dev, struct mlxsw_sp_mlxfw_dev, mlxfw_dev);
-	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_mlxfw_dev->mlxsw_sp;
-	char mcda_pl[MLXSW_REG_MCDA_LEN];
-
-	mlxsw_reg_mcda_pack(mcda_pl, fwhandle, offset, size, data);
-	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(mcda), mcda_pl);
-}
-
-static int mlxsw_sp_fsm_component_verify(struct mlxfw_dev *mlxfw_dev,
-					 u32 fwhandle, u16 component_index)
-{
-	struct mlxsw_sp_mlxfw_dev *mlxsw_sp_mlxfw_dev =
-		container_of(mlxfw_dev, struct mlxsw_sp_mlxfw_dev, mlxfw_dev);
-	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_mlxfw_dev->mlxsw_sp;
-	char mcc_pl[MLXSW_REG_MCC_LEN];
-
-	mlxsw_reg_mcc_pack(mcc_pl, MLXSW_REG_MCC_INSTRUCTION_VERIFY_COMPONENT,
-			   component_index, fwhandle, 0);
-	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(mcc), mcc_pl);
-}
-
-static int mlxsw_sp_fsm_activate(struct mlxfw_dev *mlxfw_dev, u32 fwhandle)
-{
-	struct mlxsw_sp_mlxfw_dev *mlxsw_sp_mlxfw_dev =
-		container_of(mlxfw_dev, struct mlxsw_sp_mlxfw_dev, mlxfw_dev);
-	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_mlxfw_dev->mlxsw_sp;
-	char mcc_pl[MLXSW_REG_MCC_LEN];
-
-	mlxsw_reg_mcc_pack(mcc_pl, MLXSW_REG_MCC_INSTRUCTION_ACTIVATE, 0,
-			   fwhandle, 0);
-	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(mcc), mcc_pl);
-}
-
-static int mlxsw_sp_fsm_query_state(struct mlxfw_dev *mlxfw_dev, u32 fwhandle,
-				    enum mlxfw_fsm_state *fsm_state,
-				    enum mlxfw_fsm_state_err *fsm_state_err)
-{
-	struct mlxsw_sp_mlxfw_dev *mlxsw_sp_mlxfw_dev =
-		container_of(mlxfw_dev, struct mlxsw_sp_mlxfw_dev, mlxfw_dev);
-	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_mlxfw_dev->mlxsw_sp;
-	char mcc_pl[MLXSW_REG_MCC_LEN];
-	u8 control_state;
-	u8 error_code;
-	int err;
-
-	mlxsw_reg_mcc_pack(mcc_pl, 0, 0, fwhandle, 0);
-	err = mlxsw_reg_query(mlxsw_sp->core, MLXSW_REG(mcc), mcc_pl);
-	if (err)
-		return err;
-
-	mlxsw_reg_mcc_unpack(mcc_pl, NULL, &error_code, &control_state);
-	*fsm_state = control_state;
-	*fsm_state_err = min_t(enum mlxfw_fsm_state_err, error_code,
-			       MLXFW_FSM_STATE_ERR_MAX);
-	return 0;
-}
-
-static void mlxsw_sp_fsm_cancel(struct mlxfw_dev *mlxfw_dev, u32 fwhandle)
-{
-	struct mlxsw_sp_mlxfw_dev *mlxsw_sp_mlxfw_dev =
-		container_of(mlxfw_dev, struct mlxsw_sp_mlxfw_dev, mlxfw_dev);
-	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_mlxfw_dev->mlxsw_sp;
-	char mcc_pl[MLXSW_REG_MCC_LEN];
-
-	mlxsw_reg_mcc_pack(mcc_pl, MLXSW_REG_MCC_INSTRUCTION_CANCEL, 0,
-			   fwhandle, 0);
-	mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(mcc), mcc_pl);
-}
-
-static void mlxsw_sp_fsm_release(struct mlxfw_dev *mlxfw_dev, u32 fwhandle)
-{
-	struct mlxsw_sp_mlxfw_dev *mlxsw_sp_mlxfw_dev =
-		container_of(mlxfw_dev, struct mlxsw_sp_mlxfw_dev, mlxfw_dev);
-	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_mlxfw_dev->mlxsw_sp;
-	char mcc_pl[MLXSW_REG_MCC_LEN];
-
-	mlxsw_reg_mcc_pack(mcc_pl,
-			   MLXSW_REG_MCC_INSTRUCTION_RELEASE_UPDATE_HANDLE, 0,
-			   fwhandle, 0);
-	mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(mcc), mcc_pl);
-}
-
-static const struct mlxfw_dev_ops mlxsw_sp_mlxfw_dev_ops = {
-	.component_query	= mlxsw_sp_component_query,
-	.fsm_lock		= mlxsw_sp_fsm_lock,
-	.fsm_component_update	= mlxsw_sp_fsm_component_update,
-	.fsm_block_download	= mlxsw_sp_fsm_block_download,
-	.fsm_component_verify	= mlxsw_sp_fsm_component_verify,
-	.fsm_activate		= mlxsw_sp_fsm_activate,
-	.fsm_query_state	= mlxsw_sp_fsm_query_state,
-	.fsm_cancel		= mlxsw_sp_fsm_cancel,
-	.fsm_release		= mlxsw_sp_fsm_release,
-};
-
-static int mlxsw_sp_firmware_flash(struct mlxsw_sp *mlxsw_sp,
-				   const struct firmware *firmware,
-				   struct netlink_ext_ack *extack)
-{
-	struct mlxsw_sp_mlxfw_dev mlxsw_sp_mlxfw_dev = {
-		.mlxfw_dev = {
-			.ops = &mlxsw_sp_mlxfw_dev_ops,
-			.psid = mlxsw_sp->bus_info->psid,
-			.psid_size = strlen(mlxsw_sp->bus_info->psid),
-			.devlink = priv_to_devlink(mlxsw_sp->core),
-		},
-		.mlxsw_sp = mlxsw_sp
-	};
-	int err;
-
-	mlxsw_core_fw_flash_start(mlxsw_sp->core);
-	err = mlxfw_firmware_flash(&mlxsw_sp_mlxfw_dev.mlxfw_dev,
-				   firmware, extack);
-	mlxsw_core_fw_flash_end(mlxsw_sp->core);
-
-	return err;
-}
-
-static int mlxsw_sp_fw_rev_validate(struct mlxsw_sp *mlxsw_sp)
-{
-	const struct mlxsw_fw_rev *rev = &mlxsw_sp->bus_info->fw_rev;
-	const struct mlxsw_fw_rev *req_rev = mlxsw_sp->req_rev;
-	const char *fw_filename = mlxsw_sp->fw_filename;
-	union devlink_param_value value;
-	const struct firmware *firmware;
-	int err;
-
-	/* Don't check if driver does not require it */
-	if (!req_rev || !fw_filename)
-		return 0;
-
-	/* Don't check if devlink 'fw_load_policy' param is 'flash' */
-	err = devlink_param_driverinit_value_get(priv_to_devlink(mlxsw_sp->core),
-						 DEVLINK_PARAM_GENERIC_ID_FW_LOAD_POLICY,
-						 &value);
-	if (err)
-		return err;
-	if (value.vu8 == DEVLINK_PARAM_FW_LOAD_POLICY_VALUE_FLASH)
-		return 0;
-
-	/* Validate driver & FW are compatible */
-	if (rev->major != req_rev->major) {
-		WARN(1, "Mismatch in major FW version [%d:%d] is never expected; Please contact support\n",
-		     rev->major, req_rev->major);
-		return -EINVAL;
-	}
-	if (mlxsw_core_fw_rev_minor_subminor_validate(rev, req_rev))
-		return 0;
-
-	dev_err(mlxsw_sp->bus_info->dev, "The firmware version %d.%d.%d is incompatible with the driver (required >= %d.%d.%d)\n",
-		rev->major, rev->minor, rev->subminor, req_rev->major,
-		req_rev->minor, req_rev->subminor);
-	dev_info(mlxsw_sp->bus_info->dev, "Flashing firmware using file %s\n",
-		 fw_filename);
-
-	err = request_firmware_direct(&firmware, fw_filename,
-				      mlxsw_sp->bus_info->dev);
-	if (err) {
-		dev_err(mlxsw_sp->bus_info->dev, "Could not request firmware file %s\n",
-			fw_filename);
-		return err;
-	}
-
-	err = mlxsw_sp_firmware_flash(mlxsw_sp, firmware, NULL);
-	release_firmware(firmware);
-	if (err)
-		dev_err(mlxsw_sp->bus_info->dev, "Could not upgrade firmware\n");
-
-	/* On FW flash success, tell the caller FW reset is needed
-	 * if current FW supports it.
-	 */
-	if (rev->minor >= req_rev->can_reset_minor)
-		return err ? err : -EAGAIN;
-	else
-		return 0;
-}
-
-static int mlxsw_sp_flash_update(struct mlxsw_core *mlxsw_core,
-				 const char *file_name, const char *component,
-				 struct netlink_ext_ack *extack)
-{
-	struct mlxsw_sp *mlxsw_sp = mlxsw_core_driver_priv(mlxsw_core);
-	const struct firmware *firmware;
-	int err;
-
-	if (component)
-		return -EOPNOTSUPP;
-
-	err = request_firmware_direct(&firmware, file_name,
-				      mlxsw_sp->bus_info->dev);
-	if (err)
-		return err;
-	err = mlxsw_sp_firmware_flash(mlxsw_sp, firmware, extack);
-	release_firmware(firmware);
-
-	return err;
-}
-
 int mlxsw_sp_flow_counter_get(struct mlxsw_sp *mlxsw_sp,
 			      unsigned int counter_index, u64 *packets,
 			      u64 *bytes)
@@ -2851,10 +2582,6 @@ static int mlxsw_sp_init(struct mlxsw_core *mlxsw_core,
 	mlxsw_sp->core = mlxsw_core;
 	mlxsw_sp->bus_info = mlxsw_bus_info;
 
-	err = mlxsw_sp_fw_rev_validate(mlxsw_sp);
-	if (err)
-		return err;
-
 	mlxsw_core_emad_string_tlv_enable(mlxsw_core);
 
 	err = mlxsw_sp_base_mac_get(mlxsw_sp);
@@ -3054,8 +2781,6 @@ static int mlxsw_sp1_init(struct mlxsw_core *mlxsw_core,
 {
 	struct mlxsw_sp *mlxsw_sp = mlxsw_core_driver_priv(mlxsw_core);
 
-	mlxsw_sp->req_rev = &mlxsw_sp1_fw_rev;
-	mlxsw_sp->fw_filename = MLXSW_SP1_FW_FILENAME;
 	mlxsw_sp->kvdl_ops = &mlxsw_sp1_kvdl_ops;
 	mlxsw_sp->afa_ops = &mlxsw_sp1_act_afa_ops;
 	mlxsw_sp->afk_ops = &mlxsw_sp1_afk_ops;
@@ -3084,8 +2809,6 @@ static int mlxsw_sp2_init(struct mlxsw_core *mlxsw_core,
 {
 	struct mlxsw_sp *mlxsw_sp = mlxsw_core_driver_priv(mlxsw_core);
 
-	mlxsw_sp->req_rev = &mlxsw_sp2_fw_rev;
-	mlxsw_sp->fw_filename = MLXSW_SP2_FW_FILENAME;
 	mlxsw_sp->kvdl_ops = &mlxsw_sp2_kvdl_ops;
 	mlxsw_sp->afa_ops = &mlxsw_sp2_act_afa_ops;
 	mlxsw_sp->afk_ops = &mlxsw_sp2_afk_ops;
@@ -3112,8 +2835,6 @@ static int mlxsw_sp3_init(struct mlxsw_core *mlxsw_core,
 {
 	struct mlxsw_sp *mlxsw_sp = mlxsw_core_driver_priv(mlxsw_core);
 
-	mlxsw_sp->req_rev = &mlxsw_sp3_fw_rev;
-	mlxsw_sp->fw_filename = MLXSW_SP3_FW_FILENAME;
 	mlxsw_sp->kvdl_ops = &mlxsw_sp2_kvdl_ops;
 	mlxsw_sp->afa_ops = &mlxsw_sp2_act_afa_ops;
 	mlxsw_sp->afk_ops = &mlxsw_sp2_afk_ops;
@@ -3588,6 +3309,8 @@ static void mlxsw_sp_ptp_transmitted(struct mlxsw_core *mlxsw_core,
 static struct mlxsw_driver mlxsw_sp1_driver = {
 	.kind				= mlxsw_sp1_driver_name,
 	.priv_size			= sizeof(struct mlxsw_sp),
+	.fw_req_rev			= &mlxsw_sp1_fw_rev,
+	.fw_filename			= MLXSW_SP1_FW_FILENAME,
 	.init				= mlxsw_sp1_init,
 	.fini				= mlxsw_sp_fini,
 	.basic_trap_groups_set		= mlxsw_sp_basic_trap_groups_set,
@@ -3603,7 +3326,6 @@ static struct mlxsw_driver mlxsw_sp1_driver = {
 	.sb_occ_max_clear		= mlxsw_sp_sb_occ_max_clear,
 	.sb_occ_port_pool_get		= mlxsw_sp_sb_occ_port_pool_get,
 	.sb_occ_tc_port_bind_get	= mlxsw_sp_sb_occ_tc_port_bind_get,
-	.flash_update			= mlxsw_sp_flash_update,
 	.trap_init			= mlxsw_sp_trap_init,
 	.trap_fini			= mlxsw_sp_trap_fini,
 	.trap_action_set		= mlxsw_sp_trap_action_set,
@@ -3627,6 +3349,8 @@ static struct mlxsw_driver mlxsw_sp1_driver = {
 static struct mlxsw_driver mlxsw_sp2_driver = {
 	.kind				= mlxsw_sp2_driver_name,
 	.priv_size			= sizeof(struct mlxsw_sp),
+	.fw_req_rev			= &mlxsw_sp2_fw_rev,
+	.fw_filename			= MLXSW_SP2_FW_FILENAME,
 	.init				= mlxsw_sp2_init,
 	.fini				= mlxsw_sp_fini,
 	.basic_trap_groups_set		= mlxsw_sp_basic_trap_groups_set,
@@ -3642,7 +3366,6 @@ static struct mlxsw_driver mlxsw_sp2_driver = {
 	.sb_occ_max_clear		= mlxsw_sp_sb_occ_max_clear,
 	.sb_occ_port_pool_get		= mlxsw_sp_sb_occ_port_pool_get,
 	.sb_occ_tc_port_bind_get	= mlxsw_sp_sb_occ_tc_port_bind_get,
-	.flash_update			= mlxsw_sp_flash_update,
 	.trap_init			= mlxsw_sp_trap_init,
 	.trap_fini			= mlxsw_sp_trap_fini,
 	.trap_action_set		= mlxsw_sp_trap_action_set,
@@ -3665,6 +3388,8 @@ static struct mlxsw_driver mlxsw_sp2_driver = {
 static struct mlxsw_driver mlxsw_sp3_driver = {
 	.kind				= mlxsw_sp3_driver_name,
 	.priv_size			= sizeof(struct mlxsw_sp),
+	.fw_req_rev			= &mlxsw_sp3_fw_rev,
+	.fw_filename			= MLXSW_SP3_FW_FILENAME,
 	.init				= mlxsw_sp3_init,
 	.fini				= mlxsw_sp_fini,
 	.basic_trap_groups_set		= mlxsw_sp_basic_trap_groups_set,
@@ -3680,7 +3405,6 @@ static struct mlxsw_driver mlxsw_sp3_driver = {
 	.sb_occ_max_clear		= mlxsw_sp_sb_occ_max_clear,
 	.sb_occ_port_pool_get		= mlxsw_sp_sb_occ_port_pool_get,
 	.sb_occ_tc_port_bind_get	= mlxsw_sp_sb_occ_tc_port_bind_get,
-	.flash_update			= mlxsw_sp_flash_update,
 	.trap_init			= mlxsw_sp_trap_init,
 	.trap_fini			= mlxsw_sp_trap_fini,
 	.trap_action_set		= mlxsw_sp_trap_action_set,
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
index c8077eddf0a8..a23b677d2144 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
@@ -162,8 +162,6 @@ struct mlxsw_sp {
 	struct mlxsw_sp_counter_pool *counter_pool;
 	struct mlxsw_sp_span *span;
 	struct mlxsw_sp_trap *trap;
-	const struct mlxsw_fw_rev *req_rev;
-	const char *fw_filename;
 	const struct mlxsw_sp_kvdl_ops *kvdl_ops;
 	const struct mlxsw_afa_ops *afa_ops;
 	const struct mlxsw_afk_ops *afk_ops;
-- 
2.26.2

