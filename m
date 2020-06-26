Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CFFD20B086
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 13:31:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728512AbgFZLas (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 07:30:48 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:32826 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725945AbgFZLas (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 07:30:48 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.50.144])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 0EE0C200A8;
        Fri, 26 Jun 2020 11:30:47 +0000 (UTC)
Received: from us4-mdac16-60.at1.mdlocal (unknown [10.110.50.153])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 0D0C8800A4;
        Fri, 26 Jun 2020 11:30:47 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.49.30])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 8EF9540070;
        Fri, 26 Jun 2020 11:30:46 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 428EF140058;
        Fri, 26 Jun 2020 11:30:46 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 26 Jun
 2020 12:30:41 +0100
From:   Edward Cree <ecree@solarflare.com>
Subject: [PATCH net-next 09/15] sfc: commonise other ethtool bits
To:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>
References: <1a1716f9-f909-4093-8107-3c2435d834c5@solarflare.com>
Message-ID: <d23f6256-4961-8e11-a481-fe491f8aa586@solarflare.com>
Date:   Fri, 26 Jun 2020 12:30:38 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <1a1716f9-f909-4093-8107-3c2435d834c5@solarflare.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1020-25504.003
X-TM-AS-Result: No-2.706000-8.000000-10
X-TMASE-MatchedRID: fuBbsyL8JiaiUxusi3FJ7aiUivh0j2Pv6VTG9cZxEjJwGpdgNQ0JrHIo
        zGa69omdrdoLblq9S5ra/g/NGTW3Mnab6P5ygEs+NVRz+HwqL4KikZBjlts/cmww+4tkH8hH4nq
        pTUaab810p/zdXT5B89Qd9rLjD5L4qBkiu618z01yAOhmFi1q9gqiBO2qhCIGdLv/+WrG6tOcXp
        v2z7jW5TNom9IXV8Jm56/YecsCTdHCpGfpWZNAsv9XRIMLUOjQD+jls0cSwJOrj76PS+omiCJ1Y
        T6M2y/pq6zKW70eycORk6XtYogiau9c69BWUTGwC24oEZ6SpSmb4wHqRpnaDnRCcFDRICKLECCj
        uJQTz5c8mab1SpvDK4tZHmvFqVxfhZyTLVRCk4mBottJSfe7kwO0aZpSlQ4xTQHu68rL/pzcX1L
        lthoqdO19DVI++epMmpVdReMayPPYX68FmWzgr7JqpzuBzRvlw2tMTSg0x74=
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--2.706000-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1020-25504.003
X-MDID: 1593171047-AvocL7jy68kf
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A few more ethtool handlers which EF100 will share.

Signed-off-by: Edward Cree <ecree@solarflare.com>
---
 drivers/net/ethernet/sfc/ethtool.c        | 93 -----------------------
 drivers/net/ethernet/sfc/ethtool_common.c | 93 +++++++++++++++++++++++
 drivers/net/ethernet/sfc/ethtool_common.h |  8 ++
 3 files changed, 101 insertions(+), 93 deletions(-)

diff --git a/drivers/net/ethernet/sfc/ethtool.c b/drivers/net/ethernet/sfc/ethtool.c
index 5e0051b94ae7..48a96ed6b7d0 100644
--- a/drivers/net/ethernet/sfc/ethtool.c
+++ b/drivers/net/ethernet/sfc/ethtool.c
@@ -68,54 +68,6 @@ static void efx_ethtool_get_regs(struct net_device *net_dev,
 	efx_nic_get_regs(efx, buf);
 }
 
-static void efx_ethtool_self_test(struct net_device *net_dev,
-				  struct ethtool_test *test, u64 *data)
-{
-	struct efx_nic *efx = netdev_priv(net_dev);
-	struct efx_self_tests *efx_tests;
-	bool already_up;
-	int rc = -ENOMEM;
-
-	efx_tests = kzalloc(sizeof(*efx_tests), GFP_KERNEL);
-	if (!efx_tests)
-		goto fail;
-
-	if (efx->state != STATE_READY) {
-		rc = -EBUSY;
-		goto out;
-	}
-
-	netif_info(efx, drv, efx->net_dev, "starting %sline testing\n",
-		   (test->flags & ETH_TEST_FL_OFFLINE) ? "off" : "on");
-
-	/* We need rx buffers and interrupts. */
-	already_up = (efx->net_dev->flags & IFF_UP);
-	if (!already_up) {
-		rc = dev_open(efx->net_dev, NULL);
-		if (rc) {
-			netif_err(efx, drv, efx->net_dev,
-				  "failed opening device.\n");
-			goto out;
-		}
-	}
-
-	rc = efx_selftest(efx, efx_tests, test->flags);
-
-	if (!already_up)
-		dev_close(efx->net_dev);
-
-	netif_info(efx, drv, efx->net_dev, "%s %sline self-tests\n",
-		   rc == 0 ? "passed" : "failed",
-		   (test->flags & ETH_TEST_FL_OFFLINE) ? "off" : "on");
-
-out:
-	efx_ethtool_fill_self_tests(efx, efx_tests, NULL, data);
-	kfree(efx_tests);
-fail:
-	if (rc)
-		test->flags |= ETH_TEST_FL_FAILED;
-}
-
 /*
  * Each channel has a single IRQ and moderation timer, started by any
  * completion (or other event).  Unless the module parameter
@@ -255,18 +207,6 @@ static int efx_ethtool_set_wol(struct net_device *net_dev,
 	return efx->type->set_wol(efx, wol->wolopts);
 }
 
-static int efx_ethtool_reset(struct net_device *net_dev, u32 *flags)
-{
-	struct efx_nic *efx = netdev_priv(net_dev);
-	int rc;
-
-	rc = efx->type->map_reset_flags(flags);
-	if (rc < 0)
-		return rc;
-
-	return efx_reset(efx, rc);
-}
-
 static int efx_ethtool_get_ts_info(struct net_device *net_dev,
 				   struct ethtool_ts_info *ts_info)
 {
@@ -281,39 +221,6 @@ static int efx_ethtool_get_ts_info(struct net_device *net_dev,
 	return 0;
 }
 
-static int efx_ethtool_get_module_eeprom(struct net_device *net_dev,
-					 struct ethtool_eeprom *ee,
-					 u8 *data)
-{
-	struct efx_nic *efx = netdev_priv(net_dev);
-	int ret;
-
-	if (!efx->phy_op || !efx->phy_op->get_module_eeprom)
-		return -EOPNOTSUPP;
-
-	mutex_lock(&efx->mac_lock);
-	ret = efx->phy_op->get_module_eeprom(efx, ee, data);
-	mutex_unlock(&efx->mac_lock);
-
-	return ret;
-}
-
-static int efx_ethtool_get_module_info(struct net_device *net_dev,
-				       struct ethtool_modinfo *modinfo)
-{
-	struct efx_nic *efx = netdev_priv(net_dev);
-	int ret;
-
-	if (!efx->phy_op || !efx->phy_op->get_module_info)
-		return -EOPNOTSUPP;
-
-	mutex_lock(&efx->mac_lock);
-	ret = efx->phy_op->get_module_info(efx, modinfo);
-	mutex_unlock(&efx->mac_lock);
-
-	return ret;
-}
-
 const struct ethtool_ops efx_ethtool_ops = {
 	.supported_coalesce_params = ETHTOOL_COALESCE_USECS |
 				     ETHTOOL_COALESCE_USECS_IRQ |
diff --git a/drivers/net/ethernet/sfc/ethtool_common.c b/drivers/net/ethernet/sfc/ethtool_common.c
index d7d8795eb1d3..c96595e50234 100644
--- a/drivers/net/ethernet/sfc/ethtool_common.c
+++ b/drivers/net/ethernet/sfc/ethtool_common.c
@@ -125,6 +125,54 @@ void efx_ethtool_set_msglevel(struct net_device *net_dev, u32 msg_enable)
 	efx->msg_enable = msg_enable;
 }
 
+void efx_ethtool_self_test(struct net_device *net_dev,
+			   struct ethtool_test *test, u64 *data)
+{
+	struct efx_nic *efx = netdev_priv(net_dev);
+	struct efx_self_tests *efx_tests;
+	bool already_up;
+	int rc = -ENOMEM;
+
+	efx_tests = kzalloc(sizeof(*efx_tests), GFP_KERNEL);
+	if (!efx_tests)
+		goto fail;
+
+	if (efx->state != STATE_READY) {
+		rc = -EBUSY;
+		goto out;
+	}
+
+	netif_info(efx, drv, efx->net_dev, "starting %sline testing\n",
+		   (test->flags & ETH_TEST_FL_OFFLINE) ? "off" : "on");
+
+	/* We need rx buffers and interrupts. */
+	already_up = (efx->net_dev->flags & IFF_UP);
+	if (!already_up) {
+		rc = dev_open(efx->net_dev, NULL);
+		if (rc) {
+			netif_err(efx, drv, efx->net_dev,
+				  "failed opening device.\n");
+			goto out;
+		}
+	}
+
+	rc = efx_selftest(efx, efx_tests, test->flags);
+
+	if (!already_up)
+		dev_close(efx->net_dev);
+
+	netif_info(efx, drv, efx->net_dev, "%s %sline self-tests\n",
+		   rc == 0 ? "passed" : "failed",
+		   (test->flags & ETH_TEST_FL_OFFLINE) ? "off" : "on");
+
+out:
+	efx_ethtool_fill_self_tests(efx, efx_tests, NULL, data);
+	kfree(efx_tests);
+fail:
+	if (rc)
+		test->flags |= ETH_TEST_FL_FAILED;
+}
+
 /* Restart autonegotiation */
 int efx_ethtool_nway_reset(struct net_device *net_dev)
 {
@@ -1273,3 +1321,48 @@ int efx_ethtool_set_rxfh_context(struct net_device *net_dev,
 	mutex_unlock(&efx->rss_lock);
 	return rc;
 }
+
+int efx_ethtool_reset(struct net_device *net_dev, u32 *flags)
+{
+	struct efx_nic *efx = netdev_priv(net_dev);
+	int rc;
+
+	rc = efx->type->map_reset_flags(flags);
+	if (rc < 0)
+		return rc;
+
+	return efx_reset(efx, rc);
+}
+
+int efx_ethtool_get_module_eeprom(struct net_device *net_dev,
+				  struct ethtool_eeprom *ee,
+				  u8 *data)
+{
+	struct efx_nic *efx = netdev_priv(net_dev);
+	int ret;
+
+	if (!efx->phy_op || !efx->phy_op->get_module_eeprom)
+		return -EOPNOTSUPP;
+
+	mutex_lock(&efx->mac_lock);
+	ret = efx->phy_op->get_module_eeprom(efx, ee, data);
+	mutex_unlock(&efx->mac_lock);
+
+	return ret;
+}
+
+int efx_ethtool_get_module_info(struct net_device *net_dev,
+				struct ethtool_modinfo *modinfo)
+{
+	struct efx_nic *efx = netdev_priv(net_dev);
+	int ret;
+
+	if (!efx->phy_op || !efx->phy_op->get_module_info)
+		return -EOPNOTSUPP;
+
+	mutex_lock(&efx->mac_lock);
+	ret = efx->phy_op->get_module_info(efx, modinfo);
+	mutex_unlock(&efx->mac_lock);
+
+	return ret;
+}
diff --git a/drivers/net/ethernet/sfc/ethtool_common.h b/drivers/net/ethernet/sfc/ethtool_common.h
index 024a78ce0905..7bfbbd08a1ef 100644
--- a/drivers/net/ethernet/sfc/ethtool_common.h
+++ b/drivers/net/ethernet/sfc/ethtool_common.h
@@ -15,6 +15,8 @@ void efx_ethtool_get_drvinfo(struct net_device *net_dev,
 			     struct ethtool_drvinfo *info);
 u32 efx_ethtool_get_msglevel(struct net_device *net_dev);
 void efx_ethtool_set_msglevel(struct net_device *net_dev, u32 msg_enable);
+void efx_ethtool_self_test(struct net_device *net_dev,
+			   struct ethtool_test *test, u64 *data);
 int efx_ethtool_nway_reset(struct net_device *net_dev);
 void efx_ethtool_get_pauseparam(struct net_device *net_dev,
 				struct ethtool_pauseparam *pause);
@@ -53,4 +55,10 @@ int efx_ethtool_set_rxfh_context(struct net_device *net_dev,
 				 const u32 *indir, const u8 *key,
 				 const u8 hfunc, u32 *rss_context,
 				 bool delete);
+int efx_ethtool_reset(struct net_device *net_dev, u32 *flags);
+int efx_ethtool_get_module_eeprom(struct net_device *net_dev,
+				  struct ethtool_eeprom *ee,
+				  u8 *data);
+int efx_ethtool_get_module_info(struct net_device *net_dev,
+				struct ethtool_modinfo *modinfo);
 #endif

