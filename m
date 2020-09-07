Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02DA025FE74
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 18:16:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730513AbgIGQQu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 12:16:50 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:42314 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730404AbgIGQOp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Sep 2020 12:14:45 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.61])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 2235A60079;
        Mon,  7 Sep 2020 16:14:44 +0000 (UTC)
Received: from us4-mdac16-58.ut7.mdlocal (unknown [10.7.66.29])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 1F5A9800A4;
        Mon,  7 Sep 2020 16:14:44 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.66.30])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 130F580051;
        Mon,  7 Sep 2020 16:14:43 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 680D7100074;
        Mon,  7 Sep 2020 16:14:42 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 7 Sep 2020
 17:14:37 +0100
From:   Edward Cree <ecree@solarflare.com>
Subject: [PATCH net-next 2/6] sfc: remove phy_op indirection
To:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>
References: <4634ee2f-728d-fa64-aa2c-490f607fc9fd@solarflare.com>
Message-ID: <9cc76465-9c1c-ec10-846a-b58f16d0d083@solarflare.com>
Date:   Mon, 7 Sep 2020 17:14:34 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <4634ee2f-728d-fa64-aa2c-490f607fc9fd@solarflare.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.6.1012-25650.007
X-TM-AS-Result: No-8.334400-8.000000-10
X-TMASE-MatchedRID: LxUtM2UXi6H73t5CJqhvBVS0U/rncMc44OB3iDG6ikkPNrgrymv1t7XQ
        PQH2e5fTRNOpK12YNjKAMphXXPmrGgqJXBnMYVP6Qjh5L2ZXj+zDAPSbMWlGt2MunwKby/AXCh5
        FGEJlYgGe8FYbkZPwl3DlPghqPnfyYlldA0POS1IaPMGCcVm9Do7u1T4G/rnNHApIKLQpe4TJh+
        gWZ30QuDJmrhp6ayBx+KZhROBtIu4X/ky8TX34Ovx0ykrbAxjCy0Q+dW8+UWSHX0cDZiY+DdZG7
        wxznp6b8xOs0XQtEBOz0ZOkreXeRsO/OWwmGMlR34b00P59Zxn54F/2i/DwjWww+4tkH8hHVtO0
        mkb0wEEdcCkvP9biww2ey6QlJHWrljkQLbuyhxZyAOhmFi1q9qKRkGOW2z9yDYIuXla5Kxl5bBi
        V7e/VjNzJbc9PWaiTeAOULFlZVKeoXh0SiGjEzOb3p4cnIXGNotK56hhv1yLYCfmDULr78qLoSL
        E/BAxZB/9hipIVofSyLWMOBEOR94XwLmDOfXrwh2VzUlo4HVPLvfc3C6SWwhS+f3d7BiKCKxcM9
        WvjZiIRkpbHYCAig4v9sGOtq3aS7eqO+VpGDY0qsMfMfrOZRYVQ55H8w+7m27KSseGDg93x/hK2
        QE5rfm7yMHV18pp9v2+R/HPv1u4DjykToBIr35zEHTUOuMX3UF29eTJQq9lRi8CV5QOJiNLljeT
        upbj5QJfYbXwzAv5CfOA7UxChFHCTqKEiKvUh6GyDR2ZB+cYgT/sXtGXrf4xRWJphhsrcXe0D1w
        CedaKCjSZvFnzuSqKVkUMkmoWC1edj7sn8eqqeAiCmPx4NwLTrdaH1ZWqCGtkvK5L7RXEXvQkGi
        3tjz46HM5rqDwqtlExlQIQeRG0=
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--8.334400-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.6.1012-25650.007
X-MDID: 1599495283-7VEafEEYH5Ha
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Originally there were several implementations of PHY operations for the
 several different PHYs used on Falcon boards.  But Falcon is now in a
 separate driver, and all sfc NICs since then have had MCDI-managed PHYs.
Thus, there is no need to indirect through function pointers in
 efx->phy_op; we can simply call the efx_mcdi_phy_* functions directly.

This also hooks up these functions for EF100, which was previously using
 the dummy_phy_ops.

Signed-off-by: Edward Cree <ecree@solarflare.com>
---
 drivers/net/ethernet/sfc/efx.c              |  17 +-
 drivers/net/ethernet/sfc/efx_common.c       |  26 +-
 drivers/net/ethernet/sfc/ethtool_common.c   |  44 +-
 drivers/net/ethernet/sfc/mcdi.h             |   1 -
 drivers/net/ethernet/sfc/mcdi_port.c        | 593 +-------------------
 drivers/net/ethernet/sfc/mcdi_port_common.c | 560 ++++++++++++++++++
 drivers/net/ethernet/sfc/mcdi_port_common.h |  13 +-
 drivers/net/ethernet/sfc/net_driver.h       |  47 --
 drivers/net/ethernet/sfc/selftest.c         |  12 +-
 9 files changed, 601 insertions(+), 712 deletions(-)

diff --git a/drivers/net/ethernet/sfc/efx.c b/drivers/net/ethernet/sfc/efx.c
index e06fa89f2d72..aad6710c0afb 100644
--- a/drivers/net/ethernet/sfc/efx.c
+++ b/drivers/net/ethernet/sfc/efx.c
@@ -33,7 +33,7 @@
 #include "selftest.h"
 #include "sriov.h"
 
-#include "mcdi.h"
+#include "mcdi_port_common.h"
 #include "mcdi_pcol.h"
 #include "workarounds.h"
 
@@ -149,23 +149,17 @@ static int efx_init_port(struct efx_nic *efx)
 
 	mutex_lock(&efx->mac_lock);
 
-	rc = efx->phy_op->init(efx);
-	if (rc)
-		goto fail1;
-
 	efx->port_initialized = true;
 
 	/* Ensure the PHY advertises the correct flow control settings */
-	rc = efx->phy_op->reconfigure(efx);
+	rc = efx_mcdi_port_reconfigure(efx);
 	if (rc && rc != -EPERM)
-		goto fail2;
+		goto fail;
 
 	mutex_unlock(&efx->mac_lock);
 	return 0;
 
-fail2:
-	efx->phy_op->fini(efx);
-fail1:
+fail:
 	mutex_unlock(&efx->mac_lock);
 	return rc;
 }
@@ -177,7 +171,6 @@ static void efx_fini_port(struct efx_nic *efx)
 	if (!efx->port_initialized)
 		return;
 
-	efx->phy_op->fini(efx);
 	efx->port_initialized = false;
 
 	efx->link_state.up = false;
@@ -1229,7 +1222,7 @@ static int efx_pm_thaw(struct device *dev)
 			goto fail;
 
 		mutex_lock(&efx->mac_lock);
-		efx->phy_op->reconfigure(efx);
+		efx_mcdi_port_reconfigure(efx);
 		mutex_unlock(&efx->mac_lock);
 
 		efx_start_all(efx);
diff --git a/drivers/net/ethernet/sfc/efx_common.c b/drivers/net/ethernet/sfc/efx_common.c
index dfc6032e75f4..9eda54e27cd4 100644
--- a/drivers/net/ethernet/sfc/efx_common.c
+++ b/drivers/net/ethernet/sfc/efx_common.c
@@ -19,6 +19,7 @@
 #include "rx_common.h"
 #include "tx_common.h"
 #include "nic.h"
+#include "mcdi_port_common.h"
 #include "io.h"
 #include "mcdi_pcol.h"
 
@@ -544,7 +545,7 @@ void efx_start_all(struct efx_nic *efx)
 	 * to poll now because we could have missed a change
 	 */
 	mutex_lock(&efx->mac_lock);
-	if (efx->phy_op->poll(efx))
+	if (efx_mcdi_phy_poll(efx))
 		efx_link_status_changed(efx);
 	mutex_unlock(&efx->mac_lock);
 
@@ -714,9 +715,6 @@ void efx_reset_down(struct efx_nic *efx, enum reset_type method)
 	mutex_lock(&efx->mac_lock);
 	down_write(&efx->filter_sem);
 	mutex_lock(&efx->rss_lock);
-	if (efx->port_initialized && method != RESET_TYPE_INVISIBLE &&
-	    method != RESET_TYPE_DATAPATH)
-		efx->phy_op->fini(efx);
 	efx->type->fini(efx);
 }
 
@@ -759,10 +757,7 @@ int efx_reset_up(struct efx_nic *efx, enum reset_type method, bool ok)
 
 	if (efx->port_initialized && method != RESET_TYPE_INVISIBLE &&
 	    method != RESET_TYPE_DATAPATH) {
-		rc = efx->phy_op->init(efx);
-		if (rc)
-			goto fail;
-		rc = efx->phy_op->reconfigure(efx);
+		rc = efx_mcdi_port_reconfigure(efx);
 		if (rc && rc != -EPERM)
 			netif_err(efx, drv, efx->net_dev,
 				  "could not restore PHY settings\n");
@@ -959,7 +954,7 @@ void efx_schedule_reset(struct efx_nic *efx, enum reset_type type)
 
 /**************************************************************************
  *
- * Dummy PHY/MAC operations
+ * Dummy NIC operations
  *
  * Can be used for some unimplemented operations
  * Needed so all function pointers are valid and do not have to be tested
@@ -972,18 +967,6 @@ int efx_port_dummy_op_int(struct efx_nic *efx)
 }
 void efx_port_dummy_op_void(struct efx_nic *efx) {}
 
-static bool efx_port_dummy_op_poll(struct efx_nic *efx)
-{
-	return false;
-}
-
-static const struct efx_phy_operations efx_dummy_phy_operations = {
-	.init		 = efx_port_dummy_op_int,
-	.reconfigure	 = efx_port_dummy_op_int,
-	.poll		 = efx_port_dummy_op_poll,
-	.fini		 = efx_port_dummy_op_void,
-};
-
 /**************************************************************************
  *
  * Data housekeeping
@@ -1037,7 +1020,6 @@ int efx_init_struct(struct efx_nic *efx,
 	efx->rps_hash_table = kcalloc(EFX_ARFS_HASH_TABLE_SIZE,
 				      sizeof(*efx->rps_hash_table), GFP_KERNEL);
 #endif
-	efx->phy_op = &efx_dummy_phy_operations;
 	efx->mdio.dev = net_dev;
 	INIT_WORK(&efx->mac_work, efx_mac_work);
 	init_waitqueue_head(&efx->flush_wq);
diff --git a/drivers/net/ethernet/sfc/ethtool_common.c b/drivers/net/ethernet/sfc/ethtool_common.c
index 05ac87807929..622a72eb153a 100644
--- a/drivers/net/ethernet/sfc/ethtool_common.c
+++ b/drivers/net/ethernet/sfc/ethtool_common.c
@@ -15,6 +15,7 @@
 #include "selftest.h"
 #include "rx_common.h"
 #include "ethtool_common.h"
+#include "mcdi_port_common.h"
 
 struct efx_sw_stat_desc {
 	const char *name;
@@ -221,7 +222,7 @@ int efx_ethtool_set_pauseparam(struct net_device *net_dev,
 	efx_link_set_wanted_fc(efx, wanted_fc);
 	if (efx->link_advertising[0] != old_adv ||
 	    (efx->wanted_fc ^ old_fc) & EFX_FC_AUTO) {
-		rc = efx->phy_op->reconfigure(efx);
+		rc = efx_mcdi_port_reconfigure(efx);
 		if (rc) {
 			netif_err(efx, drv, efx->net_dev,
 				  "Unable to advertise requested flow "
@@ -372,20 +373,15 @@ int efx_ethtool_fill_self_tests(struct efx_nic *efx,
 	efx_fill_test(n++, strings, data, &tests->registers,
 		      "core", 0, "registers", NULL);
 
-	if (efx->phy_op->run_tests != NULL) {
-		EFX_WARN_ON_PARANOID(efx->phy_op->test_name == NULL);
+	for (i = 0; true; ++i) {
+		const char *name;
 
-		for (i = 0; true; ++i) {
-			const char *name;
-
-			EFX_WARN_ON_PARANOID(i >= EFX_MAX_PHY_TESTS);
-			name = efx->phy_op->test_name(efx, i);
-			if (name == NULL)
-				break;
+		EFX_WARN_ON_PARANOID(i >= EFX_MAX_PHY_TESTS);
+		name = efx_mcdi_phy_test_name(efx, i);
+		if (name == NULL)
+			break;
 
-			efx_fill_test(n++, strings, data, &tests->phy_ext[i],
-				      "phy", 0, name, NULL);
-		}
+		efx_fill_test(n++, strings, data, &tests->phy_ext[i], "phy", 0, name, NULL);
 	}
 
 	/* Loopback tests */
@@ -571,7 +567,7 @@ int efx_ethtool_get_link_ksettings(struct net_device *net_dev,
 	u32 supported;
 
 	mutex_lock(&efx->mac_lock);
-	efx->phy_op->get_link_ksettings(efx, cmd);
+	efx_mcdi_phy_get_link_ksettings(efx, cmd);
 	mutex_unlock(&efx->mac_lock);
 
 	/* Both MACs support pause frames (bidirectional and respond-only) */
@@ -607,7 +603,7 @@ int efx_ethtool_set_link_ksettings(struct net_device *net_dev,
 	}
 
 	mutex_lock(&efx->mac_lock);
-	rc = efx->phy_op->set_link_ksettings(efx, cmd);
+	rc = efx_mcdi_phy_set_link_ksettings(efx, cmd);
 	mutex_unlock(&efx->mac_lock);
 	return rc;
 }
@@ -618,10 +614,8 @@ int efx_ethtool_get_fecparam(struct net_device *net_dev,
 	struct efx_nic *efx = netdev_priv(net_dev);
 	int rc;
 
-	if (!efx->phy_op || !efx->phy_op->get_fecparam)
-		return -EOPNOTSUPP;
 	mutex_lock(&efx->mac_lock);
-	rc = efx->phy_op->get_fecparam(efx, fecparam);
+	rc = efx_mcdi_phy_get_fecparam(efx, fecparam);
 	mutex_unlock(&efx->mac_lock);
 
 	return rc;
@@ -633,10 +627,8 @@ int efx_ethtool_set_fecparam(struct net_device *net_dev,
 	struct efx_nic *efx = netdev_priv(net_dev);
 	int rc;
 
-	if (!efx->phy_op || !efx->phy_op->get_fecparam)
-		return -EOPNOTSUPP;
 	mutex_lock(&efx->mac_lock);
-	rc = efx->phy_op->set_fecparam(efx, fecparam);
+	rc = efx_mcdi_phy_set_fecparam(efx, fecparam);
 	mutex_unlock(&efx->mac_lock);
 
 	return rc;
@@ -1332,11 +1324,8 @@ int efx_ethtool_get_module_eeprom(struct net_device *net_dev,
 	struct efx_nic *efx = netdev_priv(net_dev);
 	int ret;
 
-	if (!efx->phy_op || !efx->phy_op->get_module_eeprom)
-		return -EOPNOTSUPP;
-
 	mutex_lock(&efx->mac_lock);
-	ret = efx->phy_op->get_module_eeprom(efx, ee, data);
+	ret = efx_mcdi_phy_get_module_eeprom(efx, ee, data);
 	mutex_unlock(&efx->mac_lock);
 
 	return ret;
@@ -1348,11 +1337,8 @@ int efx_ethtool_get_module_info(struct net_device *net_dev,
 	struct efx_nic *efx = netdev_priv(net_dev);
 	int ret;
 
-	if (!efx->phy_op || !efx->phy_op->get_module_info)
-		return -EOPNOTSUPP;
-
 	mutex_lock(&efx->mac_lock);
-	ret = efx->phy_op->get_module_info(efx, modinfo);
+	ret = efx_mcdi_phy_get_module_info(efx, modinfo);
 	mutex_unlock(&efx->mac_lock);
 
 	return ret;
diff --git a/drivers/net/ethernet/sfc/mcdi.h b/drivers/net/ethernet/sfc/mcdi.h
index 8aed65018964..ef6d21e4bd0b 100644
--- a/drivers/net/ethernet/sfc/mcdi.h
+++ b/drivers/net/ethernet/sfc/mcdi.h
@@ -355,7 +355,6 @@ int efx_mcdi_wol_filter_get_magic(struct efx_nic *efx, int *id_out);
 int efx_mcdi_wol_filter_remove(struct efx_nic *efx, int id);
 int efx_mcdi_wol_filter_reset(struct efx_nic *efx);
 int efx_mcdi_flush_rxqs(struct efx_nic *efx);
-int efx_mcdi_port_reconfigure(struct efx_nic *efx);
 void efx_mcdi_process_link_change(struct efx_nic *efx, efx_qword_t *ev);
 void efx_mcdi_mac_start_stats(struct efx_nic *efx);
 void efx_mcdi_mac_stop_stats(struct efx_nic *efx);
diff --git a/drivers/net/ethernet/sfc/mcdi_port.c b/drivers/net/ethernet/sfc/mcdi_port.c
index 98eeb404f68d..94c6a345c0b1 100644
--- a/drivers/net/ethernet/sfc/mcdi_port.c
+++ b/drivers/net/ethernet/sfc/mcdi_port.c
@@ -70,592 +70,6 @@ static int efx_mcdi_mdio_write(struct net_device *net_dev,
 	return 0;
 }
 
-static int efx_mcdi_phy_probe(struct efx_nic *efx)
-{
-	struct efx_mcdi_phy_data *phy_data;
-	MCDI_DECLARE_BUF(outbuf, MC_CMD_GET_LINK_OUT_LEN);
-	u32 caps;
-	int rc;
-
-	/* Initialise and populate phy_data */
-	phy_data = kzalloc(sizeof(*phy_data), GFP_KERNEL);
-	if (phy_data == NULL)
-		return -ENOMEM;
-
-	rc = efx_mcdi_get_phy_cfg(efx, phy_data);
-	if (rc != 0)
-		goto fail;
-
-	/* Read initial link advertisement */
-	BUILD_BUG_ON(MC_CMD_GET_LINK_IN_LEN != 0);
-	rc = efx_mcdi_rpc(efx, MC_CMD_GET_LINK, NULL, 0,
-			  outbuf, sizeof(outbuf), NULL);
-	if (rc)
-		goto fail;
-
-	/* Fill out nic state */
-	efx->phy_data = phy_data;
-	efx->phy_type = phy_data->type;
-
-	efx->mdio_bus = phy_data->channel;
-	efx->mdio.prtad = phy_data->port;
-	efx->mdio.mmds = phy_data->mmd_mask & ~(1 << MC_CMD_MMD_CLAUSE22);
-	efx->mdio.mode_support = 0;
-	if (phy_data->mmd_mask & (1 << MC_CMD_MMD_CLAUSE22))
-		efx->mdio.mode_support |= MDIO_SUPPORTS_C22;
-	if (phy_data->mmd_mask & ~(1 << MC_CMD_MMD_CLAUSE22))
-		efx->mdio.mode_support |= MDIO_SUPPORTS_C45 | MDIO_EMULATE_C22;
-
-	caps = MCDI_DWORD(outbuf, GET_LINK_OUT_CAP);
-	if (caps & (1 << MC_CMD_PHY_CAP_AN_LBN))
-		mcdi_to_ethtool_linkset(phy_data->media, caps,
-					efx->link_advertising);
-	else
-		phy_data->forced_cap = caps;
-
-	/* Assert that we can map efx -> mcdi loopback modes */
-	BUILD_BUG_ON(LOOPBACK_NONE != MC_CMD_LOOPBACK_NONE);
-	BUILD_BUG_ON(LOOPBACK_DATA != MC_CMD_LOOPBACK_DATA);
-	BUILD_BUG_ON(LOOPBACK_GMAC != MC_CMD_LOOPBACK_GMAC);
-	BUILD_BUG_ON(LOOPBACK_XGMII != MC_CMD_LOOPBACK_XGMII);
-	BUILD_BUG_ON(LOOPBACK_XGXS != MC_CMD_LOOPBACK_XGXS);
-	BUILD_BUG_ON(LOOPBACK_XAUI != MC_CMD_LOOPBACK_XAUI);
-	BUILD_BUG_ON(LOOPBACK_GMII != MC_CMD_LOOPBACK_GMII);
-	BUILD_BUG_ON(LOOPBACK_SGMII != MC_CMD_LOOPBACK_SGMII);
-	BUILD_BUG_ON(LOOPBACK_XGBR != MC_CMD_LOOPBACK_XGBR);
-	BUILD_BUG_ON(LOOPBACK_XFI != MC_CMD_LOOPBACK_XFI);
-	BUILD_BUG_ON(LOOPBACK_XAUI_FAR != MC_CMD_LOOPBACK_XAUI_FAR);
-	BUILD_BUG_ON(LOOPBACK_GMII_FAR != MC_CMD_LOOPBACK_GMII_FAR);
-	BUILD_BUG_ON(LOOPBACK_SGMII_FAR != MC_CMD_LOOPBACK_SGMII_FAR);
-	BUILD_BUG_ON(LOOPBACK_XFI_FAR != MC_CMD_LOOPBACK_XFI_FAR);
-	BUILD_BUG_ON(LOOPBACK_GPHY != MC_CMD_LOOPBACK_GPHY);
-	BUILD_BUG_ON(LOOPBACK_PHYXS != MC_CMD_LOOPBACK_PHYXS);
-	BUILD_BUG_ON(LOOPBACK_PCS != MC_CMD_LOOPBACK_PCS);
-	BUILD_BUG_ON(LOOPBACK_PMAPMD != MC_CMD_LOOPBACK_PMAPMD);
-	BUILD_BUG_ON(LOOPBACK_XPORT != MC_CMD_LOOPBACK_XPORT);
-	BUILD_BUG_ON(LOOPBACK_XGMII_WS != MC_CMD_LOOPBACK_XGMII_WS);
-	BUILD_BUG_ON(LOOPBACK_XAUI_WS != MC_CMD_LOOPBACK_XAUI_WS);
-	BUILD_BUG_ON(LOOPBACK_XAUI_WS_FAR != MC_CMD_LOOPBACK_XAUI_WS_FAR);
-	BUILD_BUG_ON(LOOPBACK_XAUI_WS_NEAR != MC_CMD_LOOPBACK_XAUI_WS_NEAR);
-	BUILD_BUG_ON(LOOPBACK_GMII_WS != MC_CMD_LOOPBACK_GMII_WS);
-	BUILD_BUG_ON(LOOPBACK_XFI_WS != MC_CMD_LOOPBACK_XFI_WS);
-	BUILD_BUG_ON(LOOPBACK_XFI_WS_FAR != MC_CMD_LOOPBACK_XFI_WS_FAR);
-	BUILD_BUG_ON(LOOPBACK_PHYXS_WS != MC_CMD_LOOPBACK_PHYXS_WS);
-
-	rc = efx_mcdi_loopback_modes(efx, &efx->loopback_modes);
-	if (rc != 0)
-		goto fail;
-	/* The MC indicates that LOOPBACK_NONE is a valid loopback mode,
-	 * but by convention we don't */
-	efx->loopback_modes &= ~(1 << LOOPBACK_NONE);
-
-	/* Set the initial link mode */
-	efx_mcdi_phy_decode_link(
-		efx, &efx->link_state,
-		MCDI_DWORD(outbuf, GET_LINK_OUT_LINK_SPEED),
-		MCDI_DWORD(outbuf, GET_LINK_OUT_FLAGS),
-		MCDI_DWORD(outbuf, GET_LINK_OUT_FCNTL));
-
-	/* Record the initial FEC configuration (or nearest approximation
-	 * representable in the ethtool configuration space)
-	 */
-	efx->fec_config = mcdi_fec_caps_to_ethtool(caps,
-						   efx->link_state.speed == 25000 ||
-						   efx->link_state.speed == 50000);
-
-	/* Default to Autonegotiated flow control if the PHY supports it */
-	efx->wanted_fc = EFX_FC_RX | EFX_FC_TX;
-	if (phy_data->supported_cap & (1 << MC_CMD_PHY_CAP_AN_LBN))
-		efx->wanted_fc |= EFX_FC_AUTO;
-	efx_link_set_wanted_fc(efx, efx->wanted_fc);
-
-	return 0;
-
-fail:
-	kfree(phy_data);
-	return rc;
-}
-
-static void efx_mcdi_phy_remove(struct efx_nic *efx)
-{
-	struct efx_mcdi_phy_data *phy_data = efx->phy_data;
-
-	efx->phy_data = NULL;
-	kfree(phy_data);
-}
-
-static void efx_mcdi_phy_get_link_ksettings(struct efx_nic *efx,
-					    struct ethtool_link_ksettings *cmd)
-{
-	struct efx_mcdi_phy_data *phy_cfg = efx->phy_data;
-	MCDI_DECLARE_BUF(outbuf, MC_CMD_GET_LINK_OUT_LEN);
-	int rc;
-
-	cmd->base.speed = efx->link_state.speed;
-	cmd->base.duplex = efx->link_state.fd;
-	cmd->base.port = mcdi_to_ethtool_media(phy_cfg->media);
-	cmd->base.phy_address = phy_cfg->port;
-	cmd->base.autoneg = !!(efx->link_advertising[0] & ADVERTISED_Autoneg);
-	cmd->base.mdio_support = (efx->mdio.mode_support &
-			      (MDIO_SUPPORTS_C45 | MDIO_SUPPORTS_C22));
-
-	mcdi_to_ethtool_linkset(phy_cfg->media, phy_cfg->supported_cap,
-				cmd->link_modes.supported);
-	memcpy(cmd->link_modes.advertising, efx->link_advertising,
-	       sizeof(__ETHTOOL_DECLARE_LINK_MODE_MASK()));
-
-	BUILD_BUG_ON(MC_CMD_GET_LINK_IN_LEN != 0);
-	rc = efx_mcdi_rpc(efx, MC_CMD_GET_LINK, NULL, 0,
-			  outbuf, sizeof(outbuf), NULL);
-	if (rc)
-		return;
-	mcdi_to_ethtool_linkset(phy_cfg->media,
-				MCDI_DWORD(outbuf, GET_LINK_OUT_LP_CAP),
-				cmd->link_modes.lp_advertising);
-}
-
-static int
-efx_mcdi_phy_set_link_ksettings(struct efx_nic *efx,
-				const struct ethtool_link_ksettings *cmd)
-{
-	struct efx_mcdi_phy_data *phy_cfg = efx->phy_data;
-	u32 caps;
-	int rc;
-
-	if (cmd->base.autoneg) {
-		caps = (ethtool_linkset_to_mcdi_cap(cmd->link_modes.advertising) |
-			1 << MC_CMD_PHY_CAP_AN_LBN);
-	} else if (cmd->base.duplex) {
-		switch (cmd->base.speed) {
-		case 10:     caps = 1 << MC_CMD_PHY_CAP_10FDX_LBN;     break;
-		case 100:    caps = 1 << MC_CMD_PHY_CAP_100FDX_LBN;    break;
-		case 1000:   caps = 1 << MC_CMD_PHY_CAP_1000FDX_LBN;   break;
-		case 10000:  caps = 1 << MC_CMD_PHY_CAP_10000FDX_LBN;  break;
-		case 40000:  caps = 1 << MC_CMD_PHY_CAP_40000FDX_LBN;  break;
-		case 100000: caps = 1 << MC_CMD_PHY_CAP_100000FDX_LBN; break;
-		case 25000:  caps = 1 << MC_CMD_PHY_CAP_25000FDX_LBN;  break;
-		case 50000:  caps = 1 << MC_CMD_PHY_CAP_50000FDX_LBN;  break;
-		default:     return -EINVAL;
-		}
-	} else {
-		switch (cmd->base.speed) {
-		case 10:     caps = 1 << MC_CMD_PHY_CAP_10HDX_LBN;     break;
-		case 100:    caps = 1 << MC_CMD_PHY_CAP_100HDX_LBN;    break;
-		case 1000:   caps = 1 << MC_CMD_PHY_CAP_1000HDX_LBN;   break;
-		default:     return -EINVAL;
-		}
-	}
-
-	caps |= ethtool_fec_caps_to_mcdi(efx->fec_config);
-
-	rc = efx_mcdi_set_link(efx, caps, efx_get_mcdi_phy_flags(efx),
-			       efx->loopback_mode, 0);
-	if (rc)
-		return rc;
-
-	if (cmd->base.autoneg) {
-		efx_link_set_advertising(efx, cmd->link_modes.advertising);
-		phy_cfg->forced_cap = 0;
-	} else {
-		efx_link_clear_advertising(efx);
-		phy_cfg->forced_cap = caps;
-	}
-	return 0;
-}
-
-static int efx_mcdi_phy_set_fecparam(struct efx_nic *efx,
-				     const struct ethtool_fecparam *fec)
-{
-	struct efx_mcdi_phy_data *phy_cfg = efx->phy_data;
-	u32 caps;
-	int rc;
-
-	/* Work out what efx_mcdi_phy_set_link_ksettings() would produce from
-	 * saved advertising bits
-	 */
-	if (test_bit(ETHTOOL_LINK_MODE_Autoneg_BIT, efx->link_advertising))
-		caps = (ethtool_linkset_to_mcdi_cap(efx->link_advertising) |
-			1 << MC_CMD_PHY_CAP_AN_LBN);
-	else
-		caps = phy_cfg->forced_cap;
-
-	caps |= ethtool_fec_caps_to_mcdi(fec->fec);
-	rc = efx_mcdi_set_link(efx, caps, efx_get_mcdi_phy_flags(efx),
-			       efx->loopback_mode, 0);
-	if (rc)
-		return rc;
-
-	/* Record the new FEC setting for subsequent set_link calls */
-	efx->fec_config = fec->fec;
-	return 0;
-}
-
-static const char *const mcdi_sft9001_cable_diag_names[] = {
-	"cable.pairA.length",
-	"cable.pairB.length",
-	"cable.pairC.length",
-	"cable.pairD.length",
-	"cable.pairA.status",
-	"cable.pairB.status",
-	"cable.pairC.status",
-	"cable.pairD.status",
-};
-
-static int efx_mcdi_bist(struct efx_nic *efx, unsigned int bist_mode,
-			 int *results)
-{
-	unsigned int retry, i, count = 0;
-	size_t outlen;
-	u32 status;
-	MCDI_DECLARE_BUF(inbuf, MC_CMD_START_BIST_IN_LEN);
-	MCDI_DECLARE_BUF(outbuf, MC_CMD_POLL_BIST_OUT_SFT9001_LEN);
-	u8 *ptr;
-	int rc;
-
-	BUILD_BUG_ON(MC_CMD_START_BIST_OUT_LEN != 0);
-	MCDI_SET_DWORD(inbuf, START_BIST_IN_TYPE, bist_mode);
-	rc = efx_mcdi_rpc(efx, MC_CMD_START_BIST,
-			  inbuf, MC_CMD_START_BIST_IN_LEN, NULL, 0, NULL);
-	if (rc)
-		goto out;
-
-	/* Wait up to 10s for BIST to finish */
-	for (retry = 0; retry < 100; ++retry) {
-		BUILD_BUG_ON(MC_CMD_POLL_BIST_IN_LEN != 0);
-		rc = efx_mcdi_rpc(efx, MC_CMD_POLL_BIST, NULL, 0,
-				  outbuf, sizeof(outbuf), &outlen);
-		if (rc)
-			goto out;
-
-		status = MCDI_DWORD(outbuf, POLL_BIST_OUT_RESULT);
-		if (status != MC_CMD_POLL_BIST_RUNNING)
-			goto finished;
-
-		msleep(100);
-	}
-
-	rc = -ETIMEDOUT;
-	goto out;
-
-finished:
-	results[count++] = (status == MC_CMD_POLL_BIST_PASSED) ? 1 : -1;
-
-	/* SFT9001 specific cable diagnostics output */
-	if (efx->phy_type == PHY_TYPE_SFT9001B &&
-	    (bist_mode == MC_CMD_PHY_BIST_CABLE_SHORT ||
-	     bist_mode == MC_CMD_PHY_BIST_CABLE_LONG)) {
-		ptr = MCDI_PTR(outbuf, POLL_BIST_OUT_SFT9001_CABLE_LENGTH_A);
-		if (status == MC_CMD_POLL_BIST_PASSED &&
-		    outlen >= MC_CMD_POLL_BIST_OUT_SFT9001_LEN) {
-			for (i = 0; i < 8; i++) {
-				results[count + i] =
-					EFX_DWORD_FIELD(((efx_dword_t *)ptr)[i],
-							EFX_DWORD_0);
-			}
-		}
-		count += 8;
-	}
-	rc = count;
-
-out:
-	return rc;
-}
-
-static int efx_mcdi_phy_run_tests(struct efx_nic *efx, int *results,
-				  unsigned flags)
-{
-	struct efx_mcdi_phy_data *phy_cfg = efx->phy_data;
-	u32 mode;
-	int rc;
-
-	if (phy_cfg->flags & (1 << MC_CMD_GET_PHY_CFG_OUT_BIST_LBN)) {
-		rc = efx_mcdi_bist(efx, MC_CMD_PHY_BIST, results);
-		if (rc < 0)
-			return rc;
-
-		results += rc;
-	}
-
-	/* If we support both LONG and SHORT, then run each in response to
-	 * break or not. Otherwise, run the one we support */
-	mode = 0;
-	if (phy_cfg->flags & (1 << MC_CMD_GET_PHY_CFG_OUT_BIST_CABLE_SHORT_LBN)) {
-		if ((flags & ETH_TEST_FL_OFFLINE) &&
-		    (phy_cfg->flags &
-		     (1 << MC_CMD_GET_PHY_CFG_OUT_BIST_CABLE_LONG_LBN)))
-			mode = MC_CMD_PHY_BIST_CABLE_LONG;
-		else
-			mode = MC_CMD_PHY_BIST_CABLE_SHORT;
-	} else if (phy_cfg->flags &
-		   (1 << MC_CMD_GET_PHY_CFG_OUT_BIST_CABLE_LONG_LBN))
-		mode = MC_CMD_PHY_BIST_CABLE_LONG;
-
-	if (mode != 0) {
-		rc = efx_mcdi_bist(efx, mode, results);
-		if (rc < 0)
-			return rc;
-		results += rc;
-	}
-
-	return 0;
-}
-
-static const char *efx_mcdi_phy_test_name(struct efx_nic *efx,
-					  unsigned int index)
-{
-	struct efx_mcdi_phy_data *phy_cfg = efx->phy_data;
-
-	if (phy_cfg->flags & (1 << MC_CMD_GET_PHY_CFG_OUT_BIST_LBN)) {
-		if (index == 0)
-			return "bist";
-		--index;
-	}
-
-	if (phy_cfg->flags & ((1 << MC_CMD_GET_PHY_CFG_OUT_BIST_CABLE_SHORT_LBN) |
-			      (1 << MC_CMD_GET_PHY_CFG_OUT_BIST_CABLE_LONG_LBN))) {
-		if (index == 0)
-			return "cable";
-		--index;
-
-		if (efx->phy_type == PHY_TYPE_SFT9001B) {
-			if (index < ARRAY_SIZE(mcdi_sft9001_cable_diag_names))
-				return mcdi_sft9001_cable_diag_names[index];
-			index -= ARRAY_SIZE(mcdi_sft9001_cable_diag_names);
-		}
-	}
-
-	return NULL;
-}
-
-#define SFP_PAGE_SIZE		128
-#define SFF_DIAG_TYPE_OFFSET	92
-#define SFF_DIAG_ADDR_CHANGE	BIT(2)
-#define SFF_8079_NUM_PAGES	2
-#define SFF_8472_NUM_PAGES	4
-#define SFF_8436_NUM_PAGES	5
-#define SFF_DMT_LEVEL_OFFSET	94
-
-/** efx_mcdi_phy_get_module_eeprom_page() - Get a single page of module eeprom
- * @efx:	NIC context
- * @page:	EEPROM page number
- * @data:	Destination data pointer
- * @offset:	Offset in page to copy from in to data
- * @space:	Space available in data
- *
- * Return:
- *   >=0 - amount of data copied
- *   <0  - error
- */
-static int efx_mcdi_phy_get_module_eeprom_page(struct efx_nic *efx,
-					       unsigned int page,
-					       u8 *data, ssize_t offset,
-					       ssize_t space)
-{
-	MCDI_DECLARE_BUF(outbuf, MC_CMD_GET_PHY_MEDIA_INFO_OUT_LENMAX);
-	MCDI_DECLARE_BUF(inbuf, MC_CMD_GET_PHY_MEDIA_INFO_IN_LEN);
-	size_t outlen;
-	unsigned int payload_len;
-	unsigned int to_copy;
-	int rc;
-
-	if (offset > SFP_PAGE_SIZE)
-		return -EINVAL;
-
-	to_copy = min(space, SFP_PAGE_SIZE - offset);
-
-	MCDI_SET_DWORD(inbuf, GET_PHY_MEDIA_INFO_IN_PAGE, page);
-	rc = efx_mcdi_rpc_quiet(efx, MC_CMD_GET_PHY_MEDIA_INFO,
-				inbuf, sizeof(inbuf),
-				outbuf, sizeof(outbuf),
-				&outlen);
-
-	if (rc)
-		return rc;
-
-	if (outlen < (MC_CMD_GET_PHY_MEDIA_INFO_OUT_DATA_OFST +
-			SFP_PAGE_SIZE))
-		return -EIO;
-
-	payload_len = MCDI_DWORD(outbuf, GET_PHY_MEDIA_INFO_OUT_DATALEN);
-	if (payload_len != SFP_PAGE_SIZE)
-		return -EIO;
-
-	memcpy(data, MCDI_PTR(outbuf, GET_PHY_MEDIA_INFO_OUT_DATA) + offset,
-	       to_copy);
-
-	return to_copy;
-}
-
-static int efx_mcdi_phy_get_module_eeprom_byte(struct efx_nic *efx,
-					       unsigned int page,
-					       u8 byte)
-{
-	int rc;
-	u8 data;
-
-	rc = efx_mcdi_phy_get_module_eeprom_page(efx, page, &data, byte, 1);
-	if (rc == 1)
-		return data;
-
-	return rc;
-}
-
-static int efx_mcdi_phy_diag_type(struct efx_nic *efx)
-{
-	/* Page zero of the EEPROM includes the diagnostic type at byte 92. */
-	return efx_mcdi_phy_get_module_eeprom_byte(efx, 0,
-						   SFF_DIAG_TYPE_OFFSET);
-}
-
-static int efx_mcdi_phy_sff_8472_level(struct efx_nic *efx)
-{
-	/* Page zero of the EEPROM includes the DMT level at byte 94. */
-	return efx_mcdi_phy_get_module_eeprom_byte(efx, 0,
-						   SFF_DMT_LEVEL_OFFSET);
-}
-
-static u32 efx_mcdi_phy_module_type(struct efx_nic *efx)
-{
-	struct efx_mcdi_phy_data *phy_data = efx->phy_data;
-
-	if (phy_data->media != MC_CMD_MEDIA_QSFP_PLUS)
-		return phy_data->media;
-
-	/* A QSFP+ NIC may actually have an SFP+ module attached.
-	 * The ID is page 0, byte 0.
-	 */
-	switch (efx_mcdi_phy_get_module_eeprom_byte(efx, 0, 0)) {
-	case 0x3:
-		return MC_CMD_MEDIA_SFP_PLUS;
-	case 0xc:
-	case 0xd:
-		return MC_CMD_MEDIA_QSFP_PLUS;
-	default:
-		return 0;
-	}
-}
-
-static int efx_mcdi_phy_get_module_eeprom(struct efx_nic *efx,
-					  struct ethtool_eeprom *ee, u8 *data)
-{
-	int rc;
-	ssize_t space_remaining = ee->len;
-	unsigned int page_off;
-	bool ignore_missing;
-	int num_pages;
-	int page;
-
-	switch (efx_mcdi_phy_module_type(efx)) {
-	case MC_CMD_MEDIA_SFP_PLUS:
-		num_pages = efx_mcdi_phy_sff_8472_level(efx) > 0 ?
-				SFF_8472_NUM_PAGES : SFF_8079_NUM_PAGES;
-		page = 0;
-		ignore_missing = false;
-		break;
-	case MC_CMD_MEDIA_QSFP_PLUS:
-		num_pages = SFF_8436_NUM_PAGES;
-		page = -1; /* We obtain the lower page by asking for -1. */
-		ignore_missing = true; /* Ignore missing pages after page 0. */
-		break;
-	default:
-		return -EOPNOTSUPP;
-	}
-
-	page_off = ee->offset % SFP_PAGE_SIZE;
-	page += ee->offset / SFP_PAGE_SIZE;
-
-	while (space_remaining && (page < num_pages)) {
-		rc = efx_mcdi_phy_get_module_eeprom_page(efx, page,
-							 data, page_off,
-							 space_remaining);
-
-		if (rc > 0) {
-			space_remaining -= rc;
-			data += rc;
-			page_off = 0;
-			page++;
-		} else if (rc == 0) {
-			space_remaining = 0;
-		} else if (ignore_missing && (page > 0)) {
-			int intended_size = SFP_PAGE_SIZE - page_off;
-
-			space_remaining -= intended_size;
-			if (space_remaining < 0) {
-				space_remaining = 0;
-			} else {
-				memset(data, 0, intended_size);
-				data += intended_size;
-				page_off = 0;
-				page++;
-				rc = 0;
-			}
-		} else {
-			return rc;
-		}
-	}
-
-	return 0;
-}
-
-static int efx_mcdi_phy_get_module_info(struct efx_nic *efx,
-					struct ethtool_modinfo *modinfo)
-{
-	int sff_8472_level;
-	int diag_type;
-
-	switch (efx_mcdi_phy_module_type(efx)) {
-	case MC_CMD_MEDIA_SFP_PLUS:
-		sff_8472_level = efx_mcdi_phy_sff_8472_level(efx);
-
-		/* If we can't read the diagnostics level we have none. */
-		if (sff_8472_level < 0)
-			return -EOPNOTSUPP;
-
-		/* Check if this module requires the (unsupported) address
-		 * change operation.
-		 */
-		diag_type = efx_mcdi_phy_diag_type(efx);
-
-		if ((sff_8472_level == 0) ||
-		    (diag_type & SFF_DIAG_ADDR_CHANGE)) {
-			modinfo->type = ETH_MODULE_SFF_8079;
-			modinfo->eeprom_len = ETH_MODULE_SFF_8079_LEN;
-		} else {
-			modinfo->type = ETH_MODULE_SFF_8472;
-			modinfo->eeprom_len = ETH_MODULE_SFF_8472_LEN;
-		}
-		break;
-
-	case MC_CMD_MEDIA_QSFP_PLUS:
-		modinfo->type = ETH_MODULE_SFF_8436;
-		modinfo->eeprom_len = ETH_MODULE_SFF_8436_LEN;
-		break;
-
-	default:
-		return -EOPNOTSUPP;
-	}
-
-	return 0;
-}
-
-static const struct efx_phy_operations efx_mcdi_phy_ops = {
-	.probe		= efx_mcdi_phy_probe,
-	.init		= efx_port_dummy_op_int,
-	.reconfigure	= efx_mcdi_port_reconfigure,
-	.poll		= efx_mcdi_phy_poll,
-	.fini		= efx_port_dummy_op_void,
-	.remove		= efx_mcdi_phy_remove,
-	.get_link_ksettings = efx_mcdi_phy_get_link_ksettings,
-	.set_link_ksettings = efx_mcdi_phy_set_link_ksettings,
-	.get_fecparam	= efx_mcdi_phy_get_fecparam,
-	.set_fecparam	= efx_mcdi_phy_set_fecparam,
-	.test_alive	= efx_mcdi_phy_test_alive,
-	.run_tests	= efx_mcdi_phy_run_tests,
-	.test_name	= efx_mcdi_phy_test_name,
-	.get_module_eeprom = efx_mcdi_phy_get_module_eeprom,
-	.get_module_info = efx_mcdi_phy_get_module_info,
-};
-
 u32 efx_mcdi_phy_get_caps(struct efx_nic *efx)
 {
 	struct efx_mcdi_phy_data *phy_data = efx->phy_data;
@@ -683,16 +97,13 @@ int efx_mcdi_port_probe(struct efx_nic *efx)
 {
 	int rc;
 
-	/* Hook in PHY operations table */
-	efx->phy_op = &efx_mcdi_phy_ops;
-
 	/* Set up MDIO structure for PHY */
 	efx->mdio.mode_support = MDIO_SUPPORTS_C45 | MDIO_EMULATE_C22;
 	efx->mdio.mdio_read = efx_mcdi_mdio_read;
 	efx->mdio.mdio_write = efx_mcdi_mdio_write;
 
 	/* Fill out MDIO structure, loopback modes, and initial link state */
-	rc = efx->phy_op->probe(efx);
+	rc = efx_mcdi_phy_probe(efx);
 	if (rc != 0)
 		return rc;
 
@@ -701,6 +112,6 @@ int efx_mcdi_port_probe(struct efx_nic *efx)
 
 void efx_mcdi_port_remove(struct efx_nic *efx)
 {
-	efx->phy_op->remove(efx);
+	efx_mcdi_phy_remove(efx);
 	efx_mcdi_mac_fini_stats(efx);
 }
diff --git a/drivers/net/ethernet/sfc/mcdi_port_common.c b/drivers/net/ethernet/sfc/mcdi_port_common.c
index 714d7f937212..71c76a6a6b0e 100644
--- a/drivers/net/ethernet/sfc/mcdi_port_common.c
+++ b/drivers/net/ethernet/sfc/mcdi_port_common.c
@@ -404,6 +404,196 @@ bool efx_mcdi_phy_poll(struct efx_nic *efx)
 	return !efx_link_state_equal(&efx->link_state, &old_state);
 }
 
+int efx_mcdi_phy_probe(struct efx_nic *efx)
+{
+	struct efx_mcdi_phy_data *phy_data;
+	MCDI_DECLARE_BUF(outbuf, MC_CMD_GET_LINK_OUT_LEN);
+	u32 caps;
+	int rc;
+
+	/* Initialise and populate phy_data */
+	phy_data = kzalloc(sizeof(*phy_data), GFP_KERNEL);
+	if (phy_data == NULL)
+		return -ENOMEM;
+
+	rc = efx_mcdi_get_phy_cfg(efx, phy_data);
+	if (rc != 0)
+		goto fail;
+
+	/* Read initial link advertisement */
+	BUILD_BUG_ON(MC_CMD_GET_LINK_IN_LEN != 0);
+	rc = efx_mcdi_rpc(efx, MC_CMD_GET_LINK, NULL, 0,
+			  outbuf, sizeof(outbuf), NULL);
+	if (rc)
+		goto fail;
+
+	/* Fill out nic state */
+	efx->phy_data = phy_data;
+	efx->phy_type = phy_data->type;
+
+	efx->mdio_bus = phy_data->channel;
+	efx->mdio.prtad = phy_data->port;
+	efx->mdio.mmds = phy_data->mmd_mask & ~(1 << MC_CMD_MMD_CLAUSE22);
+	efx->mdio.mode_support = 0;
+	if (phy_data->mmd_mask & (1 << MC_CMD_MMD_CLAUSE22))
+		efx->mdio.mode_support |= MDIO_SUPPORTS_C22;
+	if (phy_data->mmd_mask & ~(1 << MC_CMD_MMD_CLAUSE22))
+		efx->mdio.mode_support |= MDIO_SUPPORTS_C45 | MDIO_EMULATE_C22;
+
+	caps = MCDI_DWORD(outbuf, GET_LINK_OUT_CAP);
+	if (caps & (1 << MC_CMD_PHY_CAP_AN_LBN))
+		mcdi_to_ethtool_linkset(phy_data->media, caps,
+					efx->link_advertising);
+	else
+		phy_data->forced_cap = caps;
+
+	/* Assert that we can map efx -> mcdi loopback modes */
+	BUILD_BUG_ON(LOOPBACK_NONE != MC_CMD_LOOPBACK_NONE);
+	BUILD_BUG_ON(LOOPBACK_DATA != MC_CMD_LOOPBACK_DATA);
+	BUILD_BUG_ON(LOOPBACK_GMAC != MC_CMD_LOOPBACK_GMAC);
+	BUILD_BUG_ON(LOOPBACK_XGMII != MC_CMD_LOOPBACK_XGMII);
+	BUILD_BUG_ON(LOOPBACK_XGXS != MC_CMD_LOOPBACK_XGXS);
+	BUILD_BUG_ON(LOOPBACK_XAUI != MC_CMD_LOOPBACK_XAUI);
+	BUILD_BUG_ON(LOOPBACK_GMII != MC_CMD_LOOPBACK_GMII);
+	BUILD_BUG_ON(LOOPBACK_SGMII != MC_CMD_LOOPBACK_SGMII);
+	BUILD_BUG_ON(LOOPBACK_XGBR != MC_CMD_LOOPBACK_XGBR);
+	BUILD_BUG_ON(LOOPBACK_XFI != MC_CMD_LOOPBACK_XFI);
+	BUILD_BUG_ON(LOOPBACK_XAUI_FAR != MC_CMD_LOOPBACK_XAUI_FAR);
+	BUILD_BUG_ON(LOOPBACK_GMII_FAR != MC_CMD_LOOPBACK_GMII_FAR);
+	BUILD_BUG_ON(LOOPBACK_SGMII_FAR != MC_CMD_LOOPBACK_SGMII_FAR);
+	BUILD_BUG_ON(LOOPBACK_XFI_FAR != MC_CMD_LOOPBACK_XFI_FAR);
+	BUILD_BUG_ON(LOOPBACK_GPHY != MC_CMD_LOOPBACK_GPHY);
+	BUILD_BUG_ON(LOOPBACK_PHYXS != MC_CMD_LOOPBACK_PHYXS);
+	BUILD_BUG_ON(LOOPBACK_PCS != MC_CMD_LOOPBACK_PCS);
+	BUILD_BUG_ON(LOOPBACK_PMAPMD != MC_CMD_LOOPBACK_PMAPMD);
+	BUILD_BUG_ON(LOOPBACK_XPORT != MC_CMD_LOOPBACK_XPORT);
+	BUILD_BUG_ON(LOOPBACK_XGMII_WS != MC_CMD_LOOPBACK_XGMII_WS);
+	BUILD_BUG_ON(LOOPBACK_XAUI_WS != MC_CMD_LOOPBACK_XAUI_WS);
+	BUILD_BUG_ON(LOOPBACK_XAUI_WS_FAR != MC_CMD_LOOPBACK_XAUI_WS_FAR);
+	BUILD_BUG_ON(LOOPBACK_XAUI_WS_NEAR != MC_CMD_LOOPBACK_XAUI_WS_NEAR);
+	BUILD_BUG_ON(LOOPBACK_GMII_WS != MC_CMD_LOOPBACK_GMII_WS);
+	BUILD_BUG_ON(LOOPBACK_XFI_WS != MC_CMD_LOOPBACK_XFI_WS);
+	BUILD_BUG_ON(LOOPBACK_XFI_WS_FAR != MC_CMD_LOOPBACK_XFI_WS_FAR);
+	BUILD_BUG_ON(LOOPBACK_PHYXS_WS != MC_CMD_LOOPBACK_PHYXS_WS);
+
+	rc = efx_mcdi_loopback_modes(efx, &efx->loopback_modes);
+	if (rc != 0)
+		goto fail;
+	/* The MC indicates that LOOPBACK_NONE is a valid loopback mode,
+	 * but by convention we don't */
+	efx->loopback_modes &= ~(1 << LOOPBACK_NONE);
+
+	/* Set the initial link mode */
+	efx_mcdi_phy_decode_link(
+		efx, &efx->link_state,
+		MCDI_DWORD(outbuf, GET_LINK_OUT_LINK_SPEED),
+		MCDI_DWORD(outbuf, GET_LINK_OUT_FLAGS),
+		MCDI_DWORD(outbuf, GET_LINK_OUT_FCNTL));
+
+	/* Record the initial FEC configuration (or nearest approximation
+	 * representable in the ethtool configuration space)
+	 */
+	efx->fec_config = mcdi_fec_caps_to_ethtool(caps,
+						   efx->link_state.speed == 25000 ||
+						   efx->link_state.speed == 50000);
+
+	/* Default to Autonegotiated flow control if the PHY supports it */
+	efx->wanted_fc = EFX_FC_RX | EFX_FC_TX;
+	if (phy_data->supported_cap & (1 << MC_CMD_PHY_CAP_AN_LBN))
+		efx->wanted_fc |= EFX_FC_AUTO;
+	efx_link_set_wanted_fc(efx, efx->wanted_fc);
+
+	return 0;
+
+fail:
+	kfree(phy_data);
+	return rc;
+}
+
+void efx_mcdi_phy_remove(struct efx_nic *efx)
+{
+	struct efx_mcdi_phy_data *phy_data = efx->phy_data;
+
+	efx->phy_data = NULL;
+	kfree(phy_data);
+}
+
+void efx_mcdi_phy_get_link_ksettings(struct efx_nic *efx, struct ethtool_link_ksettings *cmd)
+{
+	struct efx_mcdi_phy_data *phy_cfg = efx->phy_data;
+	MCDI_DECLARE_BUF(outbuf, MC_CMD_GET_LINK_OUT_LEN);
+	int rc;
+
+	cmd->base.speed = efx->link_state.speed;
+	cmd->base.duplex = efx->link_state.fd;
+	cmd->base.port = mcdi_to_ethtool_media(phy_cfg->media);
+	cmd->base.phy_address = phy_cfg->port;
+	cmd->base.autoneg = !!(efx->link_advertising[0] & ADVERTISED_Autoneg);
+	cmd->base.mdio_support = (efx->mdio.mode_support &
+			      (MDIO_SUPPORTS_C45 | MDIO_SUPPORTS_C22));
+
+	mcdi_to_ethtool_linkset(phy_cfg->media, phy_cfg->supported_cap,
+				cmd->link_modes.supported);
+	memcpy(cmd->link_modes.advertising, efx->link_advertising,
+	       sizeof(__ETHTOOL_DECLARE_LINK_MODE_MASK()));
+
+	BUILD_BUG_ON(MC_CMD_GET_LINK_IN_LEN != 0);
+	rc = efx_mcdi_rpc(efx, MC_CMD_GET_LINK, NULL, 0,
+			  outbuf, sizeof(outbuf), NULL);
+	if (rc)
+		return;
+	mcdi_to_ethtool_linkset(phy_cfg->media,
+				MCDI_DWORD(outbuf, GET_LINK_OUT_LP_CAP),
+				cmd->link_modes.lp_advertising);
+}
+
+int efx_mcdi_phy_set_link_ksettings(struct efx_nic *efx, const struct ethtool_link_ksettings *cmd)
+{
+	struct efx_mcdi_phy_data *phy_cfg = efx->phy_data;
+	u32 caps;
+	int rc;
+
+	if (cmd->base.autoneg) {
+		caps = (ethtool_linkset_to_mcdi_cap(cmd->link_modes.advertising) |
+			1 << MC_CMD_PHY_CAP_AN_LBN);
+	} else if (cmd->base.duplex) {
+		switch (cmd->base.speed) {
+		case 10:     caps = 1 << MC_CMD_PHY_CAP_10FDX_LBN;     break;
+		case 100:    caps = 1 << MC_CMD_PHY_CAP_100FDX_LBN;    break;
+		case 1000:   caps = 1 << MC_CMD_PHY_CAP_1000FDX_LBN;   break;
+		case 10000:  caps = 1 << MC_CMD_PHY_CAP_10000FDX_LBN;  break;
+		case 40000:  caps = 1 << MC_CMD_PHY_CAP_40000FDX_LBN;  break;
+		case 100000: caps = 1 << MC_CMD_PHY_CAP_100000FDX_LBN; break;
+		case 25000:  caps = 1 << MC_CMD_PHY_CAP_25000FDX_LBN;  break;
+		case 50000:  caps = 1 << MC_CMD_PHY_CAP_50000FDX_LBN;  break;
+		default:     return -EINVAL;
+		}
+	} else {
+		switch (cmd->base.speed) {
+		case 10:     caps = 1 << MC_CMD_PHY_CAP_10HDX_LBN;     break;
+		case 100:    caps = 1 << MC_CMD_PHY_CAP_100HDX_LBN;    break;
+		case 1000:   caps = 1 << MC_CMD_PHY_CAP_1000HDX_LBN;   break;
+		default:     return -EINVAL;
+		}
+	}
+
+	caps |= ethtool_fec_caps_to_mcdi(efx->fec_config);
+
+	rc = efx_mcdi_set_link(efx, caps, efx_get_mcdi_phy_flags(efx),
+			       efx->loopback_mode, 0);
+	if (rc)
+		return rc;
+
+	if (cmd->base.autoneg) {
+		efx_link_set_advertising(efx, cmd->link_modes.advertising);
+		phy_cfg->forced_cap = 0;
+	} else {
+		efx_link_clear_advertising(efx);
+		phy_cfg->forced_cap = caps;
+	}
+	return 0;
+}
+
 int efx_mcdi_phy_get_fecparam(struct efx_nic *efx, struct ethtool_fecparam *fec)
 {
 	MCDI_DECLARE_BUF(outbuf, MC_CMD_GET_LINK_OUT_V2_LEN);
@@ -455,6 +645,32 @@ int efx_mcdi_phy_get_fecparam(struct efx_nic *efx, struct ethtool_fecparam *fec)
 	return 0;
 }
 
+int efx_mcdi_phy_set_fecparam(struct efx_nic *efx, const struct ethtool_fecparam *fec)
+{
+	struct efx_mcdi_phy_data *phy_cfg = efx->phy_data;
+	u32 caps;
+	int rc;
+
+	/* Work out what efx_mcdi_phy_set_link_ksettings() would produce from
+	 * saved advertising bits
+	 */
+	if (test_bit(ETHTOOL_LINK_MODE_Autoneg_BIT, efx->link_advertising))
+		caps = (ethtool_linkset_to_mcdi_cap(efx->link_advertising) |
+			1 << MC_CMD_PHY_CAP_AN_LBN);
+	else
+		caps = phy_cfg->forced_cap;
+
+	caps |= ethtool_fec_caps_to_mcdi(fec->fec);
+	rc = efx_mcdi_set_link(efx, caps, efx_get_mcdi_phy_flags(efx),
+			       efx->loopback_mode, 0);
+	if (rc)
+		return rc;
+
+	/* Record the new FEC setting for subsequent set_link calls */
+	efx->fec_config = fec->fec;
+	return 0;
+}
+
 int efx_mcdi_phy_test_alive(struct efx_nic *efx)
 {
 	MCDI_DECLARE_BUF(outbuf, MC_CMD_GET_PHY_STATE_OUT_LEN);
@@ -489,6 +705,350 @@ int efx_mcdi_port_reconfigure(struct efx_nic *efx)
 				 efx->loopback_mode, 0);
 }
 
+static const char *const mcdi_sft9001_cable_diag_names[] = {
+	"cable.pairA.length",
+	"cable.pairB.length",
+	"cable.pairC.length",
+	"cable.pairD.length",
+	"cable.pairA.status",
+	"cable.pairB.status",
+	"cable.pairC.status",
+	"cable.pairD.status",
+};
+
+static int efx_mcdi_bist(struct efx_nic *efx, unsigned int bist_mode,
+			 int *results)
+{
+	unsigned int retry, i, count = 0;
+	size_t outlen;
+	u32 status;
+	MCDI_DECLARE_BUF(inbuf, MC_CMD_START_BIST_IN_LEN);
+	MCDI_DECLARE_BUF(outbuf, MC_CMD_POLL_BIST_OUT_SFT9001_LEN);
+	u8 *ptr;
+	int rc;
+
+	BUILD_BUG_ON(MC_CMD_START_BIST_OUT_LEN != 0);
+	MCDI_SET_DWORD(inbuf, START_BIST_IN_TYPE, bist_mode);
+	rc = efx_mcdi_rpc(efx, MC_CMD_START_BIST,
+			  inbuf, MC_CMD_START_BIST_IN_LEN, NULL, 0, NULL);
+	if (rc)
+		goto out;
+
+	/* Wait up to 10s for BIST to finish */
+	for (retry = 0; retry < 100; ++retry) {
+		BUILD_BUG_ON(MC_CMD_POLL_BIST_IN_LEN != 0);
+		rc = efx_mcdi_rpc(efx, MC_CMD_POLL_BIST, NULL, 0,
+				  outbuf, sizeof(outbuf), &outlen);
+		if (rc)
+			goto out;
+
+		status = MCDI_DWORD(outbuf, POLL_BIST_OUT_RESULT);
+		if (status != MC_CMD_POLL_BIST_RUNNING)
+			goto finished;
+
+		msleep(100);
+	}
+
+	rc = -ETIMEDOUT;
+	goto out;
+
+finished:
+	results[count++] = (status == MC_CMD_POLL_BIST_PASSED) ? 1 : -1;
+
+	/* SFT9001 specific cable diagnostics output */
+	if (efx->phy_type == PHY_TYPE_SFT9001B &&
+	    (bist_mode == MC_CMD_PHY_BIST_CABLE_SHORT ||
+	     bist_mode == MC_CMD_PHY_BIST_CABLE_LONG)) {
+		ptr = MCDI_PTR(outbuf, POLL_BIST_OUT_SFT9001_CABLE_LENGTH_A);
+		if (status == MC_CMD_POLL_BIST_PASSED &&
+		    outlen >= MC_CMD_POLL_BIST_OUT_SFT9001_LEN) {
+			for (i = 0; i < 8; i++) {
+				results[count + i] =
+					EFX_DWORD_FIELD(((efx_dword_t *)ptr)[i],
+							EFX_DWORD_0);
+			}
+		}
+		count += 8;
+	}
+	rc = count;
+
+out:
+	return rc;
+}
+
+int efx_mcdi_phy_run_tests(struct efx_nic *efx, int *results, unsigned flags)
+{
+	struct efx_mcdi_phy_data *phy_cfg = efx->phy_data;
+	u32 mode;
+	int rc;
+
+	if (phy_cfg->flags & (1 << MC_CMD_GET_PHY_CFG_OUT_BIST_LBN)) {
+		rc = efx_mcdi_bist(efx, MC_CMD_PHY_BIST, results);
+		if (rc < 0)
+			return rc;
+
+		results += rc;
+	}
+
+	/* If we support both LONG and SHORT, then run each in response to
+	 * break or not. Otherwise, run the one we support */
+	mode = 0;
+	if (phy_cfg->flags & (1 << MC_CMD_GET_PHY_CFG_OUT_BIST_CABLE_SHORT_LBN)) {
+		if ((flags & ETH_TEST_FL_OFFLINE) &&
+		    (phy_cfg->flags &
+		     (1 << MC_CMD_GET_PHY_CFG_OUT_BIST_CABLE_LONG_LBN)))
+			mode = MC_CMD_PHY_BIST_CABLE_LONG;
+		else
+			mode = MC_CMD_PHY_BIST_CABLE_SHORT;
+	} else if (phy_cfg->flags &
+		   (1 << MC_CMD_GET_PHY_CFG_OUT_BIST_CABLE_LONG_LBN))
+		mode = MC_CMD_PHY_BIST_CABLE_LONG;
+
+	if (mode != 0) {
+		rc = efx_mcdi_bist(efx, mode, results);
+		if (rc < 0)
+			return rc;
+		results += rc;
+	}
+
+	return 0;
+}
+
+const char *efx_mcdi_phy_test_name(struct efx_nic *efx, unsigned int index)
+{
+	struct efx_mcdi_phy_data *phy_cfg = efx->phy_data;
+
+	if (phy_cfg->flags & (1 << MC_CMD_GET_PHY_CFG_OUT_BIST_LBN)) {
+		if (index == 0)
+			return "bist";
+		--index;
+	}
+
+	if (phy_cfg->flags & ((1 << MC_CMD_GET_PHY_CFG_OUT_BIST_CABLE_SHORT_LBN) |
+			      (1 << MC_CMD_GET_PHY_CFG_OUT_BIST_CABLE_LONG_LBN))) {
+		if (index == 0)
+			return "cable";
+		--index;
+
+		if (efx->phy_type == PHY_TYPE_SFT9001B) {
+			if (index < ARRAY_SIZE(mcdi_sft9001_cable_diag_names))
+				return mcdi_sft9001_cable_diag_names[index];
+			index -= ARRAY_SIZE(mcdi_sft9001_cable_diag_names);
+		}
+	}
+
+	return NULL;
+}
+
+#define SFP_PAGE_SIZE		128
+#define SFF_DIAG_TYPE_OFFSET	92
+#define SFF_DIAG_ADDR_CHANGE	BIT(2)
+#define SFF_8079_NUM_PAGES	2
+#define SFF_8472_NUM_PAGES	4
+#define SFF_8436_NUM_PAGES	5
+#define SFF_DMT_LEVEL_OFFSET	94
+
+/** efx_mcdi_phy_get_module_eeprom_page() - Get a single page of module eeprom
+ * @efx:	NIC context
+ * @page:	EEPROM page number
+ * @data:	Destination data pointer
+ * @offset:	Offset in page to copy from in to data
+ * @space:	Space available in data
+ *
+ * Return:
+ *   >=0 - amount of data copied
+ *   <0  - error
+ */
+static int efx_mcdi_phy_get_module_eeprom_page(struct efx_nic *efx,
+					       unsigned int page,
+					       u8 *data, ssize_t offset,
+					       ssize_t space)
+{
+	MCDI_DECLARE_BUF(outbuf, MC_CMD_GET_PHY_MEDIA_INFO_OUT_LENMAX);
+	MCDI_DECLARE_BUF(inbuf, MC_CMD_GET_PHY_MEDIA_INFO_IN_LEN);
+	size_t outlen;
+	unsigned int payload_len;
+	unsigned int to_copy;
+	int rc;
+
+	if (offset > SFP_PAGE_SIZE)
+		return -EINVAL;
+
+	to_copy = min(space, SFP_PAGE_SIZE - offset);
+
+	MCDI_SET_DWORD(inbuf, GET_PHY_MEDIA_INFO_IN_PAGE, page);
+	rc = efx_mcdi_rpc_quiet(efx, MC_CMD_GET_PHY_MEDIA_INFO,
+				inbuf, sizeof(inbuf),
+				outbuf, sizeof(outbuf),
+				&outlen);
+
+	if (rc)
+		return rc;
+
+	if (outlen < (MC_CMD_GET_PHY_MEDIA_INFO_OUT_DATA_OFST +
+			SFP_PAGE_SIZE))
+		return -EIO;
+
+	payload_len = MCDI_DWORD(outbuf, GET_PHY_MEDIA_INFO_OUT_DATALEN);
+	if (payload_len != SFP_PAGE_SIZE)
+		return -EIO;
+
+	memcpy(data, MCDI_PTR(outbuf, GET_PHY_MEDIA_INFO_OUT_DATA) + offset,
+	       to_copy);
+
+	return to_copy;
+}
+
+static int efx_mcdi_phy_get_module_eeprom_byte(struct efx_nic *efx,
+					       unsigned int page,
+					       u8 byte)
+{
+	int rc;
+	u8 data;
+
+	rc = efx_mcdi_phy_get_module_eeprom_page(efx, page, &data, byte, 1);
+	if (rc == 1)
+		return data;
+
+	return rc;
+}
+
+static int efx_mcdi_phy_diag_type(struct efx_nic *efx)
+{
+	/* Page zero of the EEPROM includes the diagnostic type at byte 92. */
+	return efx_mcdi_phy_get_module_eeprom_byte(efx, 0,
+						   SFF_DIAG_TYPE_OFFSET);
+}
+
+static int efx_mcdi_phy_sff_8472_level(struct efx_nic *efx)
+{
+	/* Page zero of the EEPROM includes the DMT level at byte 94. */
+	return efx_mcdi_phy_get_module_eeprom_byte(efx, 0,
+						   SFF_DMT_LEVEL_OFFSET);
+}
+
+static u32 efx_mcdi_phy_module_type(struct efx_nic *efx)
+{
+	struct efx_mcdi_phy_data *phy_data = efx->phy_data;
+
+	if (phy_data->media != MC_CMD_MEDIA_QSFP_PLUS)
+		return phy_data->media;
+
+	/* A QSFP+ NIC may actually have an SFP+ module attached.
+	 * The ID is page 0, byte 0.
+	 */
+	switch (efx_mcdi_phy_get_module_eeprom_byte(efx, 0, 0)) {
+	case 0x3:
+		return MC_CMD_MEDIA_SFP_PLUS;
+	case 0xc:
+	case 0xd:
+		return MC_CMD_MEDIA_QSFP_PLUS;
+	default:
+		return 0;
+	}
+}
+
+int efx_mcdi_phy_get_module_eeprom(struct efx_nic *efx, struct ethtool_eeprom *ee, u8 *data)
+{
+	int rc;
+	ssize_t space_remaining = ee->len;
+	unsigned int page_off;
+	bool ignore_missing;
+	int num_pages;
+	int page;
+
+	switch (efx_mcdi_phy_module_type(efx)) {
+	case MC_CMD_MEDIA_SFP_PLUS:
+		num_pages = efx_mcdi_phy_sff_8472_level(efx) > 0 ?
+				SFF_8472_NUM_PAGES : SFF_8079_NUM_PAGES;
+		page = 0;
+		ignore_missing = false;
+		break;
+	case MC_CMD_MEDIA_QSFP_PLUS:
+		num_pages = SFF_8436_NUM_PAGES;
+		page = -1; /* We obtain the lower page by asking for -1. */
+		ignore_missing = true; /* Ignore missing pages after page 0. */
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	page_off = ee->offset % SFP_PAGE_SIZE;
+	page += ee->offset / SFP_PAGE_SIZE;
+
+	while (space_remaining && (page < num_pages)) {
+		rc = efx_mcdi_phy_get_module_eeprom_page(efx, page,
+							 data, page_off,
+							 space_remaining);
+
+		if (rc > 0) {
+			space_remaining -= rc;
+			data += rc;
+			page_off = 0;
+			page++;
+		} else if (rc == 0) {
+			space_remaining = 0;
+		} else if (ignore_missing && (page > 0)) {
+			int intended_size = SFP_PAGE_SIZE - page_off;
+
+			space_remaining -= intended_size;
+			if (space_remaining < 0) {
+				space_remaining = 0;
+			} else {
+				memset(data, 0, intended_size);
+				data += intended_size;
+				page_off = 0;
+				page++;
+				rc = 0;
+			}
+		} else {
+			return rc;
+		}
+	}
+
+	return 0;
+}
+
+int efx_mcdi_phy_get_module_info(struct efx_nic *efx, struct ethtool_modinfo *modinfo)
+{
+	int sff_8472_level;
+	int diag_type;
+
+	switch (efx_mcdi_phy_module_type(efx)) {
+	case MC_CMD_MEDIA_SFP_PLUS:
+		sff_8472_level = efx_mcdi_phy_sff_8472_level(efx);
+
+		/* If we can't read the diagnostics level we have none. */
+		if (sff_8472_level < 0)
+			return -EOPNOTSUPP;
+
+		/* Check if this module requires the (unsupported) address
+		 * change operation.
+		 */
+		diag_type = efx_mcdi_phy_diag_type(efx);
+
+		if ((sff_8472_level == 0) ||
+		    (diag_type & SFF_DIAG_ADDR_CHANGE)) {
+			modinfo->type = ETH_MODULE_SFF_8079;
+			modinfo->eeprom_len = ETH_MODULE_SFF_8079_LEN;
+		} else {
+			modinfo->type = ETH_MODULE_SFF_8472;
+			modinfo->eeprom_len = ETH_MODULE_SFF_8472_LEN;
+		}
+		break;
+
+	case MC_CMD_MEDIA_QSFP_PLUS:
+		modinfo->type = ETH_MODULE_SFF_8436;
+		modinfo->eeprom_len = ETH_MODULE_SFF_8436_LEN;
+		break;
+
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	return 0;
+}
+
 static unsigned int efx_calc_mac_mtu(struct efx_nic *efx)
 {
 	return EFX_MAX_FRAME_LEN(efx->net_dev->mtu);
diff --git a/drivers/net/ethernet/sfc/mcdi_port_common.h b/drivers/net/ethernet/sfc/mcdi_port_common.h
index 9dbeee83266f..9d214079f699 100644
--- a/drivers/net/ethernet/sfc/mcdi_port_common.h
+++ b/drivers/net/ethernet/sfc/mcdi_port_common.h
@@ -45,9 +45,18 @@ u32 ethtool_fec_caps_to_mcdi(u32 ethtool_cap);
 u32 mcdi_fec_caps_to_ethtool(u32 caps, bool is_25g);
 void efx_mcdi_phy_check_fcntl(struct efx_nic *efx, u32 lpa);
 bool efx_mcdi_phy_poll(struct efx_nic *efx);
-int efx_mcdi_phy_get_fecparam(struct efx_nic *efx,
-			      struct ethtool_fecparam *fec);
+int efx_mcdi_phy_probe(struct efx_nic *efx);
+void efx_mcdi_phy_remove(struct efx_nic *efx);
+void efx_mcdi_phy_get_link_ksettings(struct efx_nic *efx, struct ethtool_link_ksettings *cmd);
+int efx_mcdi_phy_set_link_ksettings(struct efx_nic *efx, const struct ethtool_link_ksettings *cmd);
+int efx_mcdi_phy_get_fecparam(struct efx_nic *efx, struct ethtool_fecparam *fec);
+int efx_mcdi_phy_set_fecparam(struct efx_nic *efx, const struct ethtool_fecparam *fec);
 int efx_mcdi_phy_test_alive(struct efx_nic *efx);
+int efx_mcdi_port_reconfigure(struct efx_nic *efx);
+int efx_mcdi_phy_run_tests(struct efx_nic *efx, int *results, unsigned flags);
+const char *efx_mcdi_phy_test_name(struct efx_nic *efx, unsigned int index);
+int efx_mcdi_phy_get_module_eeprom(struct efx_nic *efx, struct ethtool_eeprom *ee, u8 *data);
+int efx_mcdi_phy_get_module_info(struct efx_nic *efx, struct ethtool_modinfo *modinfo);
 int efx_mcdi_set_mac(struct efx_nic *efx);
 int efx_mcdi_set_mtu(struct efx_nic *efx);
 int efx_mcdi_mac_init_stats(struct efx_nic *efx);
diff --git a/drivers/net/ethernet/sfc/net_driver.h b/drivers/net/ethernet/sfc/net_driver.h
index fc7ba51e555a..c3015f258ba0 100644
--- a/drivers/net/ethernet/sfc/net_driver.h
+++ b/drivers/net/ethernet/sfc/net_driver.h
@@ -657,51 +657,6 @@ static inline bool efx_link_state_equal(const struct efx_link_state *left,
 		left->fc == right->fc && left->speed == right->speed;
 }
 
-/**
- * struct efx_phy_operations - Efx PHY operations table
- * @probe: Probe PHY and initialise efx->mdio.mode_support, efx->mdio.mmds,
- *	efx->loopback_modes.
- * @init: Initialise PHY
- * @fini: Shut down PHY
- * @reconfigure: Reconfigure PHY (e.g. for new link parameters)
- * @poll: Update @link_state and report whether it changed.
- *	Serialised by the mac_lock.
- * @get_link_ksettings: Get ethtool settings. Serialised by the mac_lock.
- * @set_link_ksettings: Set ethtool settings. Serialised by the mac_lock.
- * @get_fecparam: Get Forward Error Correction settings. Serialised by mac_lock.
- * @set_fecparam: Set Forward Error Correction settings. Serialised by mac_lock.
- * @set_npage_adv: Set abilities advertised in (Extended) Next Page
- *	(only needed where AN bit is set in mmds)
- * @test_alive: Test that PHY is 'alive' (online)
- * @test_name: Get the name of a PHY-specific test/result
- * @run_tests: Run tests and record results as appropriate (offline).
- *	Flags are the ethtool tests flags.
- */
-struct efx_phy_operations {
-	int (*probe) (struct efx_nic *efx);
-	int (*init) (struct efx_nic *efx);
-	void (*fini) (struct efx_nic *efx);
-	void (*remove) (struct efx_nic *efx);
-	int (*reconfigure) (struct efx_nic *efx);
-	bool (*poll) (struct efx_nic *efx);
-	void (*get_link_ksettings)(struct efx_nic *efx,
-				   struct ethtool_link_ksettings *cmd);
-	int (*set_link_ksettings)(struct efx_nic *efx,
-				  const struct ethtool_link_ksettings *cmd);
-	int (*get_fecparam)(struct efx_nic *efx, struct ethtool_fecparam *fec);
-	int (*set_fecparam)(struct efx_nic *efx,
-			    const struct ethtool_fecparam *fec);
-	void (*set_npage_adv) (struct efx_nic *efx, u32);
-	int (*test_alive) (struct efx_nic *efx);
-	const char *(*test_name) (struct efx_nic *efx, unsigned int index);
-	int (*run_tests) (struct efx_nic *efx, int *results, unsigned flags);
-	int (*get_module_eeprom) (struct efx_nic *efx,
-			       struct ethtool_eeprom *ee,
-			       u8 *data);
-	int (*get_module_info) (struct efx_nic *efx,
-				struct ethtool_modinfo *modinfo);
-};
-
 /**
  * enum efx_phy_mode - PHY operating mode flags
  * @PHY_MODE_NORMAL: on and should pass traffic
@@ -920,7 +875,6 @@ struct efx_async_filter_insertion {
  *	field of %MC_CMD_GET_CAPABILITIES_V4 response, or %MC_CMD_MAC_NSTATS)
  * @stats_buffer: DMA buffer for statistics
  * @phy_type: PHY type
- * @phy_op: PHY interface
  * @phy_data: PHY private data (including PHY-specific stats)
  * @mdio: PHY MDIO interface
  * @mdio_bus: PHY MDIO bus ID (only used by Siena)
@@ -1094,7 +1048,6 @@ struct efx_nic {
 	bool rx_nodesc_drops_prev_state;
 
 	unsigned int phy_type;
-	const struct efx_phy_operations *phy_op;
 	void *phy_data;
 	struct mdio_if_info mdio;
 	unsigned int mdio_bus;
diff --git a/drivers/net/ethernet/sfc/selftest.c b/drivers/net/ethernet/sfc/selftest.c
index 34b9c7d50c4e..574856a8a83c 100644
--- a/drivers/net/ethernet/sfc/selftest.c
+++ b/drivers/net/ethernet/sfc/selftest.c
@@ -21,6 +21,7 @@
 #include "efx_common.h"
 #include "efx_channels.h"
 #include "nic.h"
+#include "mcdi_port_common.h"
 #include "selftest.h"
 #include "workarounds.h"
 
@@ -99,10 +100,8 @@ static int efx_test_phy_alive(struct efx_nic *efx, struct efx_self_tests *tests)
 {
 	int rc = 0;
 
-	if (efx->phy_op->test_alive) {
-		rc = efx->phy_op->test_alive(efx);
-		tests->phy_alive = rc ? -1 : 1;
-	}
+	rc = efx_mcdi_phy_test_alive(efx);
+	tests->phy_alive = rc ? -1 : 1;
 
 	return rc;
 }
@@ -257,11 +256,8 @@ static int efx_test_phy(struct efx_nic *efx, struct efx_self_tests *tests,
 {
 	int rc;
 
-	if (!efx->phy_op->run_tests)
-		return 0;
-
 	mutex_lock(&efx->mac_lock);
-	rc = efx->phy_op->run_tests(efx, tests->phy_ext, flags);
+	rc = efx_mcdi_phy_run_tests(efx, tests->phy_ext, flags);
 	mutex_unlock(&efx->mac_lock);
 	if (rc == -EPERM)
 		rc = 0;

