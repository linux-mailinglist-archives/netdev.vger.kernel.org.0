Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F9426C9715
	for <lists+netdev@lfdr.de>; Sun, 26 Mar 2023 19:01:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232492AbjCZRBW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Mar 2023 13:01:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232489AbjCZRBI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Mar 2023 13:01:08 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 357395FFD
        for <netdev@vger.kernel.org>; Sun, 26 Mar 2023 10:01:05 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id t10so26489160edd.12
        for <netdev@vger.kernel.org>; Sun, 26 Mar 2023 10:01:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112; t=1679850064;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nZXb2+qygNbjzLHXmsrj7zi5WUAuLCHh86RQvypcKFM=;
        b=q+sAgEA1tWrHayteteZXKjSxrxezbir3t+wBsdKGIAoBkOoTMMm3pKi4jRWImIKU6d
         bDWlamdhWgWdF4eOQ8L4wfw3AWzNIkqQgEGSSr/Xw/qFLeKiAXBUAT3UWFokg2kEPgID
         +vDHQ85sdPBUc6WAaUVeF82R2q9oASw3ss9vKFmdSQpkwULsDiweGL5xf8IhyveZahs0
         wkYhuyX53dLvGvH6tQuZkKAEzMqAvOQ2htlJh4FPW6sAHkX+B3ENVx054nljW7s0f3Hl
         snM/ZmqY8BY/3+a8eL1TU3Puf5CS9P+mbJX9dGDF6H2oC3OjUk9AQMmUkienURbejifw
         bisg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679850064;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nZXb2+qygNbjzLHXmsrj7zi5WUAuLCHh86RQvypcKFM=;
        b=yTjbRzEtmrlkK1gUfSdhHZyHm8n12bmCPceajdbiiSuM9hei5bP0+a0/qOtSd1R8zb
         BDi9cvPPVfCU56OKy3zTG2aXrusaO3OiKC9LjJykKITo/7L0eOWN4Ht5vDOEYH99PNq8
         xTBayjVnwwyIo7g2CTVSmHEV71mFyILYYddxfDS4j4qCygQl88oioJEtmy232qvf8wC5
         Lwb3Ui8EL0iXjZtt31Ay9KL8BOTrkxIr9nYMl8xjyt1Y1Zzwy5RpopwiywSt+GS66g9M
         3jZZ7QPwWWuvp551I3HH0CXWe/fg9xZ6yprb9gpOkwWxf5/w1EZXw3PtACUHxyBNhhe9
         L6+A==
X-Gm-Message-State: AAQBX9dQ/ZuwCJH9vjBJP77OfHWoBtXW+84xZc4EaV9SMREpy70/bhwV
        UM1CMerQQygO2MEDEvUMYCDIZyqmkbh1TsVipbw=
X-Google-Smtp-Source: AKy350Y8KqmSx4SJO/HdBUgJZAtE4an2+rgY5TSAdQyfaVzCo5KUni7h4KHnZ1X3U+S7dr1V3iHAuA==
X-Received: by 2002:a17:906:d8d0:b0:932:3688:ae81 with SMTP id re16-20020a170906d8d000b009323688ae81mr9369494ejb.9.1679850064490;
        Sun, 26 Mar 2023 10:01:04 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id u23-20020a170906409700b009334a6ef3e8sm11132772ejj.141.2023.03.26.10.01.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Mar 2023 10:01:03 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org, arkadiusz.kubalewski@intel.com,
        vadim.fedorenko@linux.dev, vadfed@meta.com
Cc:     kuba@kernel.org, jonathan.lemon@gmail.com, pabeni@redhat.com,
        poros@redhat.com, mschmidt@redhat.com,
        linux-arm-kernel@lists.infradead.org, linux-clk@vger.kernel.org
Subject: [patch dpll-rfc 7/7] mlx5: Implement SyncE support using DPLL infrastructure
Date:   Sun, 26 Mar 2023 19:00:52 +0200
Message-Id: <20230326170052.2065791-8-jiri@resnulli.us>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230326170052.2065791-1-jiri@resnulli.us>
References: <20230312022807.278528-1-vadfed@meta.com>
 <20230326170052.2065791-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

Implement SyncE support using newly introduced DPLL support.
Make sure that each PFs/VFs/SFs probed with appropriate capability
will spawn a dpll auxiliary device and register appropriate dpll device
and pin instances.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/Kconfig   |   8 +
 .../net/ethernet/mellanox/mlx5/core/Makefile  |   3 +
 drivers/net/ethernet/mellanox/mlx5/core/dev.c |  17 +
 .../net/ethernet/mellanox/mlx5/core/dpll.c    | 429 ++++++++++++++++++
 include/linux/mlx5/driver.h                   |   2 +
 include/linux/mlx5/mlx5_ifc.h                 |  59 ++-
 6 files changed, 517 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/dpll.c

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Kconfig b/drivers/net/ethernet/mellanox/mlx5/core/Kconfig
index bb1d7b039a7e..15a48d376eb3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/Kconfig
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Kconfig
@@ -188,3 +188,11 @@ config MLX5_SF_MANAGER
 	port is managed through devlink.  A subfunction supports RDMA, netdevice
 	and vdpa device. It is similar to a SRIOV VF but it doesn't require
 	SRIOV support.
+
+config MLX5_DPLL
+	tristate "Mellanox 5th generation network adapters (ConnectX series) DPLL support"
+	depends on NETDEVICES && ETHERNET && PCI && MLX5_CORE
+	select DPLL
+	help
+	  DPLL support in Mellanox Technologies ConnectX NICs.
+
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Makefile b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
index 6c2f1d4a58ab..c2c864aba1f5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/Makefile
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
@@ -123,3 +123,6 @@ mlx5_core-$(CONFIG_MLX5_SF) += sf/vhca_event.o sf/dev/dev.o sf/dev/driver.o irq_
 # SF manager
 #
 mlx5_core-$(CONFIG_MLX5_SF_MANAGER) += sf/cmd.o sf/hw_table.o sf/devlink.o
+
+obj-$(CONFIG_MLX5_DPLL) += mlx5_dpll.o
+mlx5_dpll-y :=	dpll.o
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/dev.c b/drivers/net/ethernet/mellanox/mlx5/core/dev.c
index 445fe30c3d0b..7520e5987cb2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/dev.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/dev.c
@@ -227,6 +227,19 @@ static bool is_ib_enabled(struct mlx5_core_dev *dev)
 	return err ? false : val.vbool;
 }
 
+static bool is_dpll_supported(struct mlx5_core_dev *dev)
+{
+	if (!IS_ENABLED(CONFIG_MLX5_DPLL))
+		return false;
+
+	if (!MLX5_CAP_MCAM_REG2(dev, synce_registers)) {
+		mlx5_core_warn(dev, "Missing SyncE capability\n");
+		return false;
+	}
+
+	return true;
+}
+
 enum {
 	MLX5_INTERFACE_PROTOCOL_ETH,
 	MLX5_INTERFACE_PROTOCOL_ETH_REP,
@@ -236,6 +249,8 @@ enum {
 	MLX5_INTERFACE_PROTOCOL_MPIB,
 
 	MLX5_INTERFACE_PROTOCOL_VNET,
+
+	MLX5_INTERFACE_PROTOCOL_DPLL,
 };
 
 static const struct mlx5_adev_device {
@@ -258,6 +273,8 @@ static const struct mlx5_adev_device {
 					   .is_supported = &is_ib_rep_supported },
 	[MLX5_INTERFACE_PROTOCOL_MPIB] = { .suffix = "multiport",
 					   .is_supported = &is_mp_supported },
+	[MLX5_INTERFACE_PROTOCOL_DPLL] = { .suffix = "dpll",
+					   .is_supported = &is_dpll_supported },
 };
 
 int mlx5_adev_idx_alloc(void)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/dpll.c b/drivers/net/ethernet/mellanox/mlx5/core/dpll.c
new file mode 100644
index 000000000000..afb092fcbcae
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/dpll.c
@@ -0,0 +1,429 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+/* Copyright (c) 2023, NVIDIA CORPORATION & AFFILIATES. All rights reserved. */
+
+#include <linux/dpll.h>
+#include <linux/mlx5/driver.h>
+
+// POSSIBLE DPLL API EXTENSIONS:
+// 1) Expose clock quality: MSECQ->local_ssm_code, MSECQ->local_enhanced_ssm_code
+//    Proposed enum:
+//      QL_DNU,
+//      QL_EEC1,
+//      QL_eEEC,
+//      QL_SSU_B,
+//      QL_SSU_A,
+//      QL_PRC,
+//      QL_ePRC,
+//      QL_PRTC,
+//      QL_ePRTC,
+// 2) Expose possibility to do holdover: MSEES->ho_acq
+// 3) DPLL Implementation hw-speficic values (debug?): MSEES->oper_freq_measure
+
+/* This structure represents a reference to DPLL, one is created
+ * per mdev instance.
+ */
+struct mlx5_dpll {
+	struct dpll_device *dpll;
+	struct dpll_pin *dpll_pin;
+	struct mlx5_core_dev *mdev;
+	struct workqueue_struct *wq;
+	struct delayed_work work;
+	struct {
+		bool valid;
+		enum dpll_lock_status lock_status;
+		enum dpll_pin_state pin_state;
+	} last;
+	struct notifier_block mdev_nb;
+	struct net_device *tracking_netdev;
+};
+
+static int mlx5_dpll_clock_id_get(struct mlx5_core_dev *mdev, u64 *clock_id)
+{
+	u32 out[MLX5_ST_SZ_DW(msecq_reg)] = {};
+	u32 in[MLX5_ST_SZ_DW(msecq_reg)] = {};
+	int err;
+
+	err = mlx5_core_access_reg(mdev, in, sizeof(in), out, sizeof(out),
+				   MLX5_REG_MSECQ, 0, 0);
+	if (err)
+		return err;
+	*clock_id = MLX5_GET64(msecq_reg, out, local_clock_identity);
+	return 0;
+}
+
+static int
+mlx5_dpll_synce_status_get(struct mlx5_core_dev *mdev,
+			   enum mlx5_msees_admin_status *admin_status,
+			   enum mlx5_msees_oper_status *oper_status)
+{
+	u32 out[MLX5_ST_SZ_DW(msees_reg)] = {};
+	u32 in[MLX5_ST_SZ_DW(msees_reg)] = {};
+	int err;
+
+	MLX5_SET(msees_reg, in, local_port, 1);
+	err = mlx5_core_access_reg(mdev, in, sizeof(in), out, sizeof(out),
+				   MLX5_REG_MSEES, 0, 0);
+	if (err)
+		return err;
+	if (admin_status)
+		*admin_status = MLX5_GET(msees_reg, out, admin_status);
+	if (oper_status)
+		*oper_status = MLX5_GET(msees_reg, out, oper_status);
+	return 0;
+}
+
+static int
+mlx5_dpll_synce_status_set(struct mlx5_core_dev *mdev,
+			   enum mlx5_msees_admin_status admin_status)
+{
+	u32 out[MLX5_ST_SZ_DW(msees_reg)] = {};
+	u32 in[MLX5_ST_SZ_DW(msees_reg)] = {};
+
+	MLX5_SET(msees_reg, in, local_port, 1);
+	MLX5_SET(msees_reg, in, field_select,
+		 MLX5_MSEES_FIELD_SELECT_ENABLE |
+		 MLX5_MSEES_FIELD_SELECT_ADMIN_STATUS);
+	MLX5_SET(msees_reg, in, admin_status, admin_status);
+	MLX5_SET(msees_reg, in, admin_freq_measure,
+		 admin_status == MLX5_MSEES_ADMIN_STATUS_TRACK);
+	return mlx5_core_access_reg(mdev, in, sizeof(in), out, sizeof(out),
+				    MLX5_REG_MSEES, 0, 0);
+}
+
+static enum dpll_lock_status
+mlx5_dpll_lock_status_from_oper_status(enum mlx5_msees_oper_status oper_status)
+{
+	switch (oper_status) {
+	case MLX5_MSEES_OPER_STATUS_SELF_TRACK:
+		fallthrough;
+	case MLX5_MSEES_OPER_STATUS_OTHER_TRACK:
+		return DPLL_LOCK_STATUS_LOCKED;
+	case MLX5_MSEES_OPER_STATUS_HOLDOVER:
+		return DPLL_LOCK_STATUS_HOLDOVER;
+	default:
+		return DPLL_LOCK_STATUS_UNLOCKED;
+	}
+}
+
+static int mlx5_dpll_device_lock_status_get(const struct dpll_device *dpll,
+					    enum dpll_lock_status *status,
+					    struct netlink_ext_ack *extack)
+{
+	struct mlx5_dpll *mdpll = dpll_priv(dpll);
+	enum mlx5_msees_oper_status oper_status;
+	int err;
+
+	err = mlx5_dpll_synce_status_get(mdpll->mdev, NULL, &oper_status);
+	if (err)
+		return err;
+
+	*status = mlx5_dpll_lock_status_from_oper_status(oper_status);
+	return 0;
+}
+
+static int mlx5_dpll_device_mode_get(const struct dpll_device *dpll,
+				     u32 *mode, struct netlink_ext_ack *extack)
+{
+	*mode = DPLL_MODE_MANUAL;
+	return 0;
+}
+
+static bool mlx5_dpll_device_mode_supported(const struct dpll_device *dpll,
+					    enum dpll_mode mode,
+					    struct netlink_ext_ack *extack)
+{
+	return mode == DPLL_MODE_MANUAL;
+}
+
+static const struct dpll_device_ops mlx5_dpll_device_ops = {
+	.lock_status_get = mlx5_dpll_device_lock_status_get,
+	.mode_get = mlx5_dpll_device_mode_get,
+	.mode_supported = mlx5_dpll_device_mode_supported,
+};
+
+static int mlx5_dpll_pin_direction_get(const struct dpll_pin *pin,
+				       const struct dpll_device *dpll,
+				       enum dpll_pin_direction *direction,
+				       struct netlink_ext_ack *extack)
+{
+	*direction = DPLL_PIN_DIRECTION_SOURCE;
+	return 0;
+}
+
+static enum dpll_pin_state
+mlx5_dpll_pin_state_from_admin_status(enum mlx5_msees_admin_status admin_status)
+{
+	return admin_status == MLX5_MSEES_ADMIN_STATUS_TRACK ?
+	       DPLL_PIN_STATE_CONNECTED : DPLL_PIN_STATE_DISCONNECTED;
+}
+
+static int mlx5_dpll_state_on_dpll_get(const struct dpll_pin *pin,
+				       const struct dpll_device *dpll,
+				       enum dpll_pin_state *state,
+				       struct netlink_ext_ack *extack)
+{
+	struct mlx5_dpll *mdpll = dpll_pin_on_dpll_priv(dpll, pin);
+	enum mlx5_msees_admin_status admin_status;
+	int err;
+
+	err = mlx5_dpll_synce_status_get(mdpll->mdev, &admin_status, NULL);
+	if (err)
+		return err;
+	*state = mlx5_dpll_pin_state_from_admin_status(admin_status);
+	return 0;
+}
+
+static int mlx5_dpll_state_on_dpll_set(const struct dpll_pin *pin,
+				       const struct dpll_device *dpll,
+				       enum dpll_pin_state state,
+				       struct netlink_ext_ack *extack)
+{
+	struct mlx5_dpll *mdpll = dpll_pin_on_dpll_priv(dpll, pin);
+
+	return mlx5_dpll_synce_status_set(mdpll->mdev,
+					  state == DPLL_PIN_STATE_CONNECTED ?
+					  MLX5_MSEES_ADMIN_STATUS_TRACK :
+					  MLX5_MSEES_ADMIN_STATUS_FREE_RUNNING);
+}
+
+static const struct dpll_pin_ops mlx5_dpll_pins_ops = {
+	.direction_get = mlx5_dpll_pin_direction_get,
+	.state_on_dpll_get = mlx5_dpll_state_on_dpll_get,
+	.state_on_dpll_set = mlx5_dpll_state_on_dpll_set,
+};
+
+static const struct dpll_pin_properties mlx5_dpll_pin_properties = {
+	.description = "n/a",
+	.type = DPLL_PIN_TYPE_SYNCE_ETH_PORT,
+	.capabilities = DPLL_PIN_CAPS_STATE_CAN_CHANGE,
+};
+
+#define MLX5_DPLL_PERIODIC_WORK_INTERVAL 500 /* ms */
+
+static void mlx5_dpll_periodic_work_queue(struct mlx5_dpll *mdpll)
+{
+	queue_delayed_work(mdpll->wq, &mdpll->work,
+			   msecs_to_jiffies(MLX5_DPLL_PERIODIC_WORK_INTERVAL));
+}
+
+static void mlx5_dpll_periodic_work(struct work_struct *work)
+{
+	struct mlx5_dpll *mdpll = container_of(work, struct mlx5_dpll,
+					       work.work);
+	enum mlx5_msees_admin_status admin_status;
+	enum mlx5_msees_oper_status oper_status;
+	enum dpll_lock_status lock_status;
+	enum dpll_pin_state pin_state,
+
+	err = mlx5_dpll_synce_status_get(mdpll->mdev, &admin_status,
+					 &oper_status);
+	if (err)
+		goto err_out;
+	lock_status = mlx5_dpll_lock_status_from_oper_status(oper_status);
+	pin_state = mlx5_dpll_pin_state_from_admin_status(admin_status);
+
+	if (!mdpll->last.valid)
+		goto invalid_out;
+
+	if (mdpll->last.lock_status != lock_status)
+		dpll_device_notify(mdpll->dpll, DPLL_A_LOCK_STATUS);
+	if (mdpll->last.pin_state != pin_state)
+		dpll_pin_notify(mdpll->dpll, mdpll->dpll_pin, DPLL_A_PIN_STATE);
+
+invalid_out:
+	mdpll->last.lock_status = lock_status;
+	mdpll->last.pin_state = pin_state;
+	mdpll->last.valid = true;
+err_out:
+	mlx5_dpll_periodic_work_queue(mdpll);
+}
+
+static void mlx5_dpll_netdev_dpll_pin_set(struct mlx5_dpll *mdpll,
+					  struct net_device *netdev)
+{
+	if (mdpll->tracking_netdev)
+		return;
+	netdev_dpll_pin_set(netdev, mdpll->dpll_pin);
+	mdpll->tracking_netdev = netdev;
+}
+
+static void mlx5_dpll_netdev_dpll_pin_clear(struct mlx5_dpll *mdpll)
+{
+	if (!mdpll->tracking_netdev)
+		return;
+	netdev_dpll_pin_clear(mdpll->tracking_netdev);
+	mdpll->tracking_netdev = NULL;
+}
+
+static int mlx5_dpll_mdev_notifier_event(struct notifier_block *nb,
+					 unsigned long event, void *data)
+{
+	struct mlx5_dpll *mdpll = container_of(nb, struct mlx5_dpll, mdev_nb);
+	struct net_device *netdev = data;
+
+	switch (event) {
+	case MLX5_DRIVER_EVENT_UPLINK_NETDEV:
+		if (netdev)
+			mlx5_dpll_netdev_dpll_pin_set(mdpll, netdev);
+		else
+			mlx5_dpll_netdev_dpll_pin_clear(mdpll);
+		break;
+	default:
+		return NOTIFY_DONE;
+	}
+
+	return NOTIFY_OK;
+}
+
+static void mlx5_dpll_mdev_netdev_track(struct mlx5_dpll *mdpll,
+					struct mlx5_core_dev *mdev)
+{
+	mdpll->mdev_nb.notifier_call = mlx5_dpll_mdev_notifier_event;
+	mlx5_blocking_notifier_register(mdev, &mdpll->mdev_nb);
+	mlx5_core_uplink_netdev_event_replay(mdev);
+}
+
+static void mlx5_dpll_mdev_netdev_untrack(struct mlx5_dpll *mdpll,
+					  struct mlx5_core_dev *mdev)
+{
+	mlx5_blocking_notifier_unregister(mdev, &mdpll->mdev_nb);
+	mlx5_dpll_netdev_dpll_pin_clear(mdpll);
+}
+
+static int mlx5_dpll_probe(struct auxiliary_device *adev,
+			   const struct auxiliary_device_id *id)
+{
+	struct mlx5_adev *edev = container_of(adev, struct mlx5_adev, adev);
+	struct mlx5_core_dev *mdev = edev->mdev;
+	struct mlx5_dpll *mdpll;
+	u64 clock_id;
+	int err;
+
+	err = mlx5_dpll_synce_status_set(mdev,
+					 MLX5_MSEES_ADMIN_STATUS_FREE_RUNNING);
+	if (err)
+		return err;
+
+	err = mlx5_dpll_clock_id_get(mdev, &clock_id);
+	if (err)
+		return err;
+
+	mdpll = kzalloc(sizeof(*mdpll), GFP_KERNEL);
+	if (!mdpll)
+		return -ENOMEM;
+	mdpll->mdev = mdev;
+	auxiliary_set_drvdata(adev, mdpll);
+
+	/* Multiple mdev instances might share one DPLL device. */
+	mdpll->dpll = dpll_device_get(clock_id, 0, DPLL_TYPE_EEC, THIS_MODULE);
+	if (IS_ERR(mdpll->dpll)) {
+		err = PTR_ERR(mdpll->dpll);
+		goto err_free_mdpll;
+	}
+
+	err = dpll_device_register(mdpll->dpll, &mlx5_dpll_device_ops,
+				   mdpll, &adev->dev);
+	if (err)
+		goto err_put_dpll_device;
+
+	/* Multiple mdev instances might share one DPLL pin. */
+	mdpll->dpll_pin = dpll_pin_get(clock_id, mlx5_get_dev_index(mdev),
+				       THIS_MODULE, &mlx5_dpll_pin_properties);
+	if (IS_ERR(mdpll->dpll_pin)) {
+		err = PTR_ERR(mdpll->dpll_pin);
+		goto err_unregister_dpll_device;
+	}
+
+	err = dpll_pin_register(mdpll->dpll, mdpll->dpll_pin,
+				&mlx5_dpll_pins_ops, mdpll, NULL);
+	if (err)
+		goto err_put_dpll_pin;
+
+	mdpll->wq = create_singlethread_workqueue("mlx5_dpll");
+	if (!mdpll->wq) {
+		err = -ENOMEM;
+		goto err_unregister_dpll_pin;
+	}
+
+	mlx5_dpll_mdev_netdev_track(mdpll, mdev);
+
+	INIT_DELAYED_WORK(&mdpll->work, &mlx5_dpll_periodic_work);
+	mlx5_dpll_periodic_work_queue(mdpll);
+
+	return 0;
+
+err_unregister_dpll_pin:
+	dpll_pin_unregister(mdpll->dpll, mdpll->dpll_pin,
+			    &mlx5_dpll_pins_ops, mdpll);
+err_put_dpll_pin:
+	dpll_pin_put(mdpll->dpll_pin);
+err_unregister_dpll_device:
+	dpll_device_unregister(mdpll->dpll, &mlx5_dpll_device_ops, mdpll);
+err_put_dpll_device:
+	dpll_device_put(mdpll->dpll);
+err_free_mdpll:
+	kfree(mdpll);
+	return err;
+}
+
+static void mlx5_dpll_remove(struct auxiliary_device *adev)
+{
+	struct mlx5_dpll *mdpll = auxiliary_get_drvdata(adev);
+	struct mlx5_core_dev *mdev = mdpll->mdev;
+
+	cancel_delayed_work(&mdpll->work);
+	mlx5_dpll_mdev_netdev_untrack(mdpll, mdev);
+	destroy_workqueue(mdpll->wq);
+	dpll_pin_unregister(mdpll->dpll, mdpll->dpll_pin,
+			    &mlx5_dpll_pins_ops, mdpll);
+	dpll_pin_put(mdpll->dpll_pin);
+	dpll_device_unregister(mdpll->dpll, &mlx5_dpll_device_ops, mdpll);
+	dpll_device_put(mdpll->dpll);
+	kfree(mdpll);
+
+	mlx5_dpll_synce_status_set(mdev,
+				   MLX5_MSEES_ADMIN_STATUS_FREE_RUNNING);
+}
+
+static int mlx5_dpll_suspend(struct auxiliary_device *adev, pm_message_t state)
+{
+	return 0;
+}
+
+static int mlx5_dpll_resume(struct auxiliary_device *adev)
+{
+	return 0;
+}
+
+static const struct auxiliary_device_id mlx5_dpll_id_table[] = {
+	{ .name = MLX5_ADEV_NAME ".dpll", },
+	{},
+};
+
+MODULE_DEVICE_TABLE(auxiliary, mlx5_dpll_id_table);
+
+static struct auxiliary_driver mlx5_dpll_driver = {
+	.name = "dpll",
+	.probe = mlx5_dpll_probe,
+	.remove = mlx5_dpll_remove,
+	.suspend = mlx5_dpll_suspend,
+	.resume = mlx5_dpll_resume,
+	.id_table = mlx5_dpll_id_table,
+};
+
+static int __init mlx5_dpll_init(void)
+{
+	return auxiliary_driver_register(&mlx5_dpll_driver);
+}
+
+static void __exit mlx5_dpll_exit(void)
+{
+	auxiliary_driver_unregister(&mlx5_dpll_driver);
+}
+
+module_init(mlx5_dpll_init);
+module_exit(mlx5_dpll_exit);
+
+MODULE_AUTHOR("Jiri Pirko <jiri@nvidia.com>");
+MODULE_DESCRIPTION("Mellanox 5th generation network adapters (ConnectX series) DPLL driver");
+MODULE_LICENSE("Dual BSD/GPL");
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index 7a898113b6b7..3cfa30b86878 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -154,6 +154,8 @@ enum {
 	MLX5_REG_MCC		 = 0x9062,
 	MLX5_REG_MCDA		 = 0x9063,
 	MLX5_REG_MCAM		 = 0x907f,
+	MLX5_REG_MSECQ		 = 0x9155,
+	MLX5_REG_MSEES		 = 0x9156,
 	MLX5_REG_MIRC		 = 0x9162,
 	MLX5_REG_SBCAM		 = 0xB01F,
 	MLX5_REG_RESOURCE_DUMP   = 0xC000,
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index e47d6c58da35..6ce11b43bf39 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -10143,7 +10143,9 @@ struct mlx5_ifc_mcam_access_reg_bits2 {
 	u8         mirc[0x1];
 	u8         regs_97_to_96[0x2];
 
-	u8         regs_95_to_64[0x20];
+	u8         regs_95_to_87[0x09];
+	u8         synce_registers[0x2];
+	u8         regs_84_to_64[0x15];
 
 	u8         regs_63_to_32[0x20];
 
@@ -12505,4 +12507,59 @@ struct mlx5_ifc_modify_page_track_obj_in_bits {
 	struct mlx5_ifc_page_track_bits obj_context;
 };
 
+struct mlx5_ifc_msecq_reg_bits {
+	u8         reserved_at_0[0x20];
+
+	u8         reserved_at_20[0x12];
+	u8         network_option[0x2];
+	u8         local_ssm_code[0x4];
+	u8         local_enhanced_ssm_code[0x8];
+
+	u8         local_clock_identity[0x40];
+
+	u8         reserved_at_80[0x180];
+};
+
+enum {
+	MLX5_MSEES_FIELD_SELECT_ENABLE			= BIT(0),
+	MLX5_MSEES_FIELD_SELECT_ADMIN_STATUS		= BIT(1),
+	MLX5_MSEES_FIELD_SELECT_ADMIN_FREQ_MEASURE	= BIT(2),
+};
+
+enum mlx5_msees_admin_status {
+	MLX5_MSEES_ADMIN_STATUS_FREE_RUNNING		= 0x0,
+	MLX5_MSEES_ADMIN_STATUS_TRACK			= 0x1,
+};
+
+enum mlx5_msees_oper_status {
+	MLX5_MSEES_OPER_STATUS_FREE_RUNNING		= 0x0,
+	MLX5_MSEES_OPER_STATUS_SELF_TRACK		= 0x1,
+	MLX5_MSEES_OPER_STATUS_OTHER_TRACK		= 0x2,
+	MLX5_MSEES_OPER_STATUS_HOLDOVER			= 0x3,
+	MLX5_MSEES_OPER_STATUS_FAIL_HOLDOVER		= 0x4,
+	MLX5_MSEES_OPER_STATUS_FAIL_FREE_RUNNING	= 0x5,
+};
+
+struct mlx5_ifc_msees_reg_bits {
+	u8         reserved_at_0[0x8];
+	u8         local_port[0x8];
+	u8         pnat[0x2];
+	u8         lp_msb[0x2];
+	u8         reserved_at_14[0xc];
+
+	u8         field_select[0x20];
+
+	u8         admin_status[0x4];
+	u8         oper_status[0x4];
+	u8         ho_acq[0x1];
+	u8         reserved_at_49[0xc];
+	u8         admin_freq_measure[0x1];
+	u8         oper_freq_measure[0x1];
+	u8         failure_reason[0x9];
+
+	u8         frequency_diff[0x20];
+
+	u8         reserved_at_80[0x180];
+};
+
 #endif /* MLX5_IFC_H */
-- 
2.39.0

