Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37AAD683207
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 17:00:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233407AbjAaQAO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 11:00:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231874AbjAaQAK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 11:00:10 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9407E069
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 08:00:05 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id me3so42964277ejb.7
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 08:00:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ah9+k0w/nRIiVTPPZXwqr7trAB5DOfdEEINSad8SRrU=;
        b=QETQKU1/4codq3BX8Ei4sqqHEH2UlgFz3UkYFpIbZ7tyFWw31mKriW4Fj4DQKfLSj9
         Ou4hBSaynTzNKEBNiEyCPAu+kAMDoTogzahhNHXCSbEyEoO7MNcmK5GvjOyE5qV54ITd
         8vVbkr+iMXR0Ixf1313ozfDfseEEb1KZWqSEjkROePeOHMQhOJKhhBlOzdWGHyu/9QfW
         ZKnHBvJrQx9QxMBCjqMIvENgqbdc4KTJPWnfgTpIO8wjyhvnR6DG5vHwj66npXhffojg
         4a2XwUUlzVZp6Q52rnAyLTyJsfZ3pj/yA3XYIQGhZF46JGwpjCzp19ntkNvivtpkbGYR
         tH6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ah9+k0w/nRIiVTPPZXwqr7trAB5DOfdEEINSad8SRrU=;
        b=NkvDMG1yEHb/1j4obbE/ux6YCqs3yitEiWAMU7HFIr5QK4pafBv60COs0l1jZnIp4w
         1SiaP7lme42kkLy5eds/dr4rk/P51T1OPoghQpuID/xTBZPcdcZhQAs298nsZBK+jlxh
         u5WaIgp33syUwVaZnCujbLG7UupUBWm0TCSrqSX+8yy5wTJ5G8mTVKt4EGfr0m3mN//R
         0C8HGUhD4bHFn/mIQbV/i8urIkPgnF8AnhrUwTcvd4WknAgOr3BOevrSRkhYMxVswdAc
         yESNCswCXrogY7mEyAFD1cQs469Xwx4YOMRKDDM8PNGDGVGWDQZTcLQwhQge8ep7nZLa
         hmfA==
X-Gm-Message-State: AFqh2kpgPJP3zzr6SlmbEB3werzg4QWbN2ztOhb4kHld1lcx8ZWHd7nN
        0PpJVN/5Nucq/ZIxwrm/gYmUlg==
X-Google-Smtp-Source: AMrXdXtQ7r8FAsvfnYrhUCCVQRLR9gnkLUCTmWYwkWRritatTQf+Nm+8d7KhCm9coKYyHk9QUx0v/Q==
X-Received: by 2002:a17:907:a2cb:b0:871:dd2:4af0 with SMTP id re11-20020a170907a2cb00b008710dd24af0mr65022425ejc.26.1675180804341;
        Tue, 31 Jan 2023 08:00:04 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id g18-20020a170906595200b00888d593ce76sm3252074ejr.72.2023.01.31.08.00.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Jan 2023 08:00:03 -0800 (PST)
Date:   Tue, 31 Jan 2023 17:00:02 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     alejandro.lucero-palau@amd.com
Cc:     netdev@vger.kernel.org, linux-net-drivers@amd.com,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, habetsm.xilinx@gmail.com,
        ecree.xilinx@gmail.com, linux-doc@vger.kernel.org, corbet@lwn.net,
        jiri@nvidia.com
Subject: Re: [PATCH v4 net-next 1/8] sfc: add devlink support for ef100
Message-ID: <Y9k7Ap4Irby7vnWg@nanopsycho>
References: <20230131145822.36208-1-alejandro.lucero-palau@amd.com>
 <20230131145822.36208-2-alejandro.lucero-palau@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230131145822.36208-2-alejandro.lucero-palau@amd.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Jan 31, 2023 at 03:58:15PM CET, alejandro.lucero-palau@amd.com wrote:
>From: Alejandro Lucero <alejandro.lucero-palau@amd.com>
>
>Basic devlink infrastructure support.
>
>Signed-off-by: Alejandro Lucero <alejandro.lucero-palau@amd.com>
>---
> drivers/net/ethernet/sfc/Kconfig        |  1 +
> drivers/net/ethernet/sfc/Makefile       |  3 +-
> drivers/net/ethernet/sfc/ef100_netdev.c | 12 +++++
> drivers/net/ethernet/sfc/ef100_nic.c    |  3 +-
> drivers/net/ethernet/sfc/efx_devlink.c  | 71 +++++++++++++++++++++++++
> drivers/net/ethernet/sfc/efx_devlink.h  | 22 ++++++++
> drivers/net/ethernet/sfc/net_driver.h   |  2 +
> 7 files changed, 111 insertions(+), 3 deletions(-)
> create mode 100644 drivers/net/ethernet/sfc/efx_devlink.c
> create mode 100644 drivers/net/ethernet/sfc/efx_devlink.h
>
>diff --git a/drivers/net/ethernet/sfc/Kconfig b/drivers/net/ethernet/sfc/Kconfig
>index 0950e6b0508f..4af36ba8906b 100644
>--- a/drivers/net/ethernet/sfc/Kconfig
>+++ b/drivers/net/ethernet/sfc/Kconfig
>@@ -22,6 +22,7 @@ config SFC
> 	depends on PTP_1588_CLOCK_OPTIONAL
> 	select MDIO
> 	select CRC32
>+	select NET_DEVLINK
> 	help
> 	  This driver supports 10/40-gigabit Ethernet cards based on
> 	  the Solarflare SFC9100-family controllers.
>diff --git a/drivers/net/ethernet/sfc/Makefile b/drivers/net/ethernet/sfc/Makefile
>index 712a48d00069..55b9c73cd8ef 100644
>--- a/drivers/net/ethernet/sfc/Makefile
>+++ b/drivers/net/ethernet/sfc/Makefile
>@@ -6,7 +6,8 @@ sfc-y			+= efx.o efx_common.o efx_channels.o nic.o \
> 			   mcdi.o mcdi_port.o mcdi_port_common.o \
> 			   mcdi_functions.o mcdi_filters.o mcdi_mon.o \
> 			   ef100.o ef100_nic.o ef100_netdev.o \
>-			   ef100_ethtool.o ef100_rx.o ef100_tx.o
>+			   ef100_ethtool.o ef100_rx.o ef100_tx.o \
>+			   efx_devlink.o
> sfc-$(CONFIG_SFC_MTD)	+= mtd.o
> sfc-$(CONFIG_SFC_SRIOV)	+= sriov.o ef10_sriov.o ef100_sriov.o ef100_rep.o \
>                            mae.o tc.o tc_bindings.o tc_counters.o
>diff --git a/drivers/net/ethernet/sfc/ef100_netdev.c b/drivers/net/ethernet/sfc/ef100_netdev.c
>index ddcc325ed570..b10a226f4a07 100644
>--- a/drivers/net/ethernet/sfc/ef100_netdev.c
>+++ b/drivers/net/ethernet/sfc/ef100_netdev.c
>@@ -24,6 +24,7 @@
> #include "rx_common.h"
> #include "ef100_sriov.h"
> #include "tc_bindings.h"
>+#include "efx_devlink.h"
> 
> static void ef100_update_name(struct efx_nic *efx)
> {
>@@ -332,6 +333,8 @@ void ef100_remove_netdev(struct efx_probe_data *probe_data)
> 		efx_ef100_pci_sriov_disable(efx, true);
> #endif
> 
>+	/* devlink lock */
>+	efx_fini_devlink_start(efx);
> 	ef100_unregister_netdev(efx);
> 
> #ifdef CONFIG_SFC_SRIOV
>@@ -345,6 +348,9 @@ void ef100_remove_netdev(struct efx_probe_data *probe_data)
> 	kfree(efx->phy_data);
> 	efx->phy_data = NULL;
> 
>+	/* devlink unlock */
>+	efx_fini_devlink(efx);
>+
> 	free_netdev(efx->net_dev);
> 	efx->net_dev = NULL;
> 	efx->state = STATE_PROBED;
>@@ -405,6 +411,10 @@ int ef100_probe_netdev(struct efx_probe_data *probe_data)
> 	/* Don't fail init if RSS setup doesn't work. */
> 	efx_mcdi_push_default_indir_table(efx, efx->n_rx_channels);
> 
>+	/* devlink creation, registration and lock */
>+	if (efx_probe_devlink(efx))

Use variable to store the return value and check that in if.


>+		pci_info(efx->pci_dev, "devlink registration failed");
>+
> 	rc = ef100_register_netdev(efx);
> 	if (rc)
> 		goto fail;
>@@ -424,5 +434,7 @@ int ef100_probe_netdev(struct efx_probe_data *probe_data)
> 	}
> 
> fail:
>+	/* devlink unlock */
>+	efx_probe_devlink_done(efx);
> 	return rc;
> }
>diff --git a/drivers/net/ethernet/sfc/ef100_nic.c b/drivers/net/ethernet/sfc/ef100_nic.c
>index ad686c671ab8..e4aacb4ec666 100644
>--- a/drivers/net/ethernet/sfc/ef100_nic.c
>+++ b/drivers/net/ethernet/sfc/ef100_nic.c
>@@ -1120,11 +1120,10 @@ int ef100_probe_netdev_pf(struct efx_nic *efx)
> 		return rc;
> 
> 	rc = efx_ef100_get_base_mport(efx);
>-	if (rc) {
>+	if (rc)
> 		netif_warn(efx, probe, net_dev,
> 			   "Failed to probe base mport rc %d; representors will not function\n",
> 			   rc);
>-	}

I don't see how this hunk is related to this patch. Please remove.


> 
> 	rc = efx_init_tc(efx);
> 	if (rc) {
>diff --git a/drivers/net/ethernet/sfc/efx_devlink.c b/drivers/net/ethernet/sfc/efx_devlink.c
>new file mode 100644
>index 000000000000..fab06aaa4b8a
>--- /dev/null
>+++ b/drivers/net/ethernet/sfc/efx_devlink.c
>@@ -0,0 +1,71 @@
>+// SPDX-License-Identifier: GPL-2.0-only
>+/****************************************************************************
>+ * Driver for AMD network controllers and boards
>+ * Copyright (C) 2023, Advanced Micro Devices, Inc.
>+ *
>+ * This program is free software; you can redistribute it and/or modify it
>+ * under the terms of the GNU General Public License version 2 as published
>+ * by the Free Software Foundation, incorporated herein by reference.
>+ */
>+
>+#include <linux/rtc.h>
>+#include "net_driver.h"
>+#include "ef100_nic.h"
>+#include "efx_devlink.h"
>+#include "nic.h"
>+#include "mcdi.h"
>+#include "mcdi_functions.h"
>+#include "mcdi_pcol.h"
>+
>+struct efx_devlink {
>+	struct efx_nic *efx;
>+};
>+
>+static const struct devlink_ops sfc_devlink_ops = {
>+};
>+
>+void efx_fini_devlink_start(struct efx_nic *efx)
>+{
>+	if (efx->devlink)
>+		devl_lock(efx->devlink);
>+}
>+
>+void efx_fini_devlink(struct efx_nic *efx)
>+{
>+	if (efx->devlink) {
>+		devl_unregister(efx->devlink);
>+		devl_unlock(efx->devlink);
>+		devlink_free(efx->devlink);
>+		efx->devlink = NULL;
>+	}
>+}
>+
>+int efx_probe_devlink(struct efx_nic *efx)
>+{
>+	struct efx_devlink *devlink_private;
>+
>+	if (efx->type->is_vf)
>+		return 0;
>+
>+	efx->devlink = devlink_alloc(&sfc_devlink_ops,
>+				     sizeof(struct efx_devlink),
>+				     &efx->pci_dev->dev);
>+	if (!efx->devlink)
>+		return -ENOMEM;
>+
>+	devl_lock(efx->devlink);
>+	devlink_private = devlink_priv(efx->devlink);
>+	devlink_private->efx = efx;
>+
>+	devl_register(efx->devlink);
>+
>+	return 0;
>+}
>+
>+void efx_probe_devlink_done(struct efx_nic *efx)
>+{
>+	if (!efx->devlink)
>+		return;
>+
>+	devl_unlock(efx->devlink);
>+}
>diff --git a/drivers/net/ethernet/sfc/efx_devlink.h b/drivers/net/ethernet/sfc/efx_devlink.h
>new file mode 100644
>index 000000000000..55d0d8aeca1e
>--- /dev/null
>+++ b/drivers/net/ethernet/sfc/efx_devlink.h
>@@ -0,0 +1,22 @@
>+/* SPDX-License-Identifier: GPL-2.0-only */
>+/****************************************************************************
>+ * Driver for AMD network controllers and boards
>+ * Copyright (C) 2023, Advanced Micro Devices, Inc.
>+ *
>+ * This program is free software; you can redistribute it and/or modify it
>+ * under the terms of the GNU General Public License version 2 as published
>+ * by the Free Software Foundation, incorporated herein by reference.
>+ */
>+
>+#ifndef _EFX_DEVLINK_H
>+#define _EFX_DEVLINK_H
>+
>+#include "net_driver.h"
>+#include <net/devlink.h>
>+
>+int efx_probe_devlink(struct efx_nic *efx);
>+void efx_probe_devlink_done(struct efx_nic *efx);
>+void efx_fini_devlink_start(struct efx_nic *efx);
>+void efx_fini_devlink(struct efx_nic *efx);

Odd naming... Just saying.


>+
>+#endif	/* _EFX_DEVLINK_H */
>diff --git a/drivers/net/ethernet/sfc/net_driver.h b/drivers/net/ethernet/sfc/net_driver.h
>index 3b49e216768b..d036641dc043 100644
>--- a/drivers/net/ethernet/sfc/net_driver.h
>+++ b/drivers/net/ethernet/sfc/net_driver.h
>@@ -994,6 +994,7 @@ enum efx_xdp_tx_queues_mode {
>  *      xdp_rxq_info structures?
>  * @netdev_notifier: Netdevice notifier.
>  * @tc: state for TC offload (EF100).
>+ * @devlink: reference to devlink structure owned by this device
>  * @mem_bar: The BAR that is mapped into membase.
>  * @reg_base: Offset from the start of the bar to the function control window.
>  * @monitor_work: Hardware monitor workitem
>@@ -1179,6 +1180,7 @@ struct efx_nic {
> 	struct notifier_block netdev_notifier;
> 	struct efx_tc_state *tc;
> 
>+	struct devlink *devlink;
> 	unsigned int mem_bar;
> 	u32 reg_base;
> 
>-- 
>2.17.1
>
