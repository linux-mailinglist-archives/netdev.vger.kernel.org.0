Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F6F150BAF9
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 17:01:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1449097AbiDVPDb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 11:03:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1449152AbiDVPCt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 11:02:49 -0400
Received: from mint-fitpc2.mph.net (unknown [81.168.73.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A8A50D6C
        for <netdev@vger.kernel.org>; Fri, 22 Apr 2022 07:59:54 -0700 (PDT)
Received: from palantir17.mph.net (unknown [192.168.0.4])
        by mint-fitpc2.mph.net (Postfix) with ESMTP id D3DEF320133;
        Fri, 22 Apr 2022 15:59:53 +0100 (BST)
Received: from localhost ([::1] helo=palantir17.mph.net)
        by palantir17.mph.net with esmtp (Exim 4.89)
        (envelope-from <habetsm.xilinx@gmail.com>)
        id 1nhulF-0007Al-LD; Fri, 22 Apr 2022 15:59:53 +0100
Subject: [PATCH net-next 13/28] sfc/siena: Rename functions in
 ethtool_common.h to avoid conflicts with sfc
From:   Martin Habets <habetsm.xilinx@gmail.com>
To:     kuba@kernel.org, pabeni@redhat.com, davem@davemloft.net
Cc:     netdev@vger.kernel.org, ecree.xilinx@gmail.com
Date:   Fri, 22 Apr 2022 15:59:53 +0100
Message-ID: <165063959350.27138.9263323614329751388.stgit@palantir17.mph.net>
In-Reply-To: <165063937837.27138.6911229584057659609.stgit@palantir17.mph.net>
References: <165063937837.27138.6911229584057659609.stgit@palantir17.mph.net>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=1.7 required=5.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
        FORGED_GMAIL_RCVD,FREEMAIL_FROM,KHOP_HELO_FCRDNS,MAY_BE_FORGED,
        NML_ADSP_CUSTOM_MED,SPF_HELO_NONE,SPF_SOFTFAIL autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For siena use efx_siena_ as the function prefix.
efx_ethtool_fill_self_tests() can become static.

Signed-off-by: Martin Habets <habetsm.xilinx@gmail.com>
---
 drivers/net/ethernet/sfc/siena/ethtool.c        |   48 +++---
 drivers/net/ethernet/sfc/siena/ethtool_common.c |  191 ++++++++++++-----------
 drivers/net/ethernet/sfc/siena/ethtool_common.h |   95 ++++++-----
 3 files changed, 166 insertions(+), 168 deletions(-)

diff --git a/drivers/net/ethernet/sfc/siena/ethtool.c b/drivers/net/ethernet/sfc/siena/ethtool.c
index 7aa621e97212..429653a49dee 100644
--- a/drivers/net/ethernet/sfc/siena/ethtool.c
+++ b/drivers/net/ethernet/sfc/siena/ethtool.c
@@ -243,40 +243,40 @@ const struct ethtool_ops efx_siena_ethtool_ops = {
 	.supported_coalesce_params = ETHTOOL_COALESCE_USECS |
 				     ETHTOOL_COALESCE_USECS_IRQ |
 				     ETHTOOL_COALESCE_USE_ADAPTIVE_RX,
-	.get_drvinfo		= efx_ethtool_get_drvinfo,
+	.get_drvinfo		= efx_siena_ethtool_get_drvinfo,
 	.get_regs_len		= efx_ethtool_get_regs_len,
 	.get_regs		= efx_ethtool_get_regs,
-	.get_msglevel		= efx_ethtool_get_msglevel,
-	.set_msglevel		= efx_ethtool_set_msglevel,
+	.get_msglevel		= efx_siena_ethtool_get_msglevel,
+	.set_msglevel		= efx_siena_ethtool_set_msglevel,
 	.get_link		= ethtool_op_get_link,
 	.get_coalesce		= efx_ethtool_get_coalesce,
 	.set_coalesce		= efx_ethtool_set_coalesce,
 	.get_ringparam		= efx_ethtool_get_ringparam,
 	.set_ringparam		= efx_ethtool_set_ringparam,
-	.get_pauseparam         = efx_ethtool_get_pauseparam,
-	.set_pauseparam         = efx_ethtool_set_pauseparam,
-	.get_sset_count		= efx_ethtool_get_sset_count,
-	.self_test		= efx_ethtool_self_test,
-	.get_strings		= efx_ethtool_get_strings,
+	.get_pauseparam         = efx_siena_ethtool_get_pauseparam,
+	.set_pauseparam         = efx_siena_ethtool_set_pauseparam,
+	.get_sset_count		= efx_siena_ethtool_get_sset_count,
+	.self_test		= efx_siena_ethtool_self_test,
+	.get_strings		= efx_siena_ethtool_get_strings,
 	.set_phys_id		= efx_ethtool_phys_id,
-	.get_ethtool_stats	= efx_ethtool_get_stats,
+	.get_ethtool_stats	= efx_siena_ethtool_get_stats,
 	.get_wol                = efx_ethtool_get_wol,
 	.set_wol                = efx_ethtool_set_wol,
-	.reset			= efx_ethtool_reset,
-	.get_rxnfc		= efx_ethtool_get_rxnfc,
-	.set_rxnfc		= efx_ethtool_set_rxnfc,
-	.get_rxfh_indir_size	= efx_ethtool_get_rxfh_indir_size,
-	.get_rxfh_key_size	= efx_ethtool_get_rxfh_key_size,
-	.get_rxfh		= efx_ethtool_get_rxfh,
-	.set_rxfh		= efx_ethtool_set_rxfh,
-	.get_rxfh_context	= efx_ethtool_get_rxfh_context,
-	.set_rxfh_context	= efx_ethtool_set_rxfh_context,
+	.reset			= efx_siena_ethtool_reset,
+	.get_rxnfc		= efx_siena_ethtool_get_rxnfc,
+	.set_rxnfc		= efx_siena_ethtool_set_rxnfc,
+	.get_rxfh_indir_size	= efx_siena_ethtool_get_rxfh_indir_size,
+	.get_rxfh_key_size	= efx_siena_ethtool_get_rxfh_key_size,
+	.get_rxfh		= efx_siena_ethtool_get_rxfh,
+	.set_rxfh		= efx_siena_ethtool_set_rxfh,
+	.get_rxfh_context	= efx_siena_ethtool_get_rxfh_context,
+	.set_rxfh_context	= efx_siena_ethtool_set_rxfh_context,
 	.get_ts_info		= efx_ethtool_get_ts_info,
-	.get_module_info	= efx_ethtool_get_module_info,
-	.get_module_eeprom	= efx_ethtool_get_module_eeprom,
-	.get_link_ksettings	= efx_ethtool_get_link_ksettings,
-	.set_link_ksettings	= efx_ethtool_set_link_ksettings,
+	.get_module_info	= efx_siena_ethtool_get_module_info,
+	.get_module_eeprom	= efx_siena_ethtool_get_module_eeprom,
+	.get_link_ksettings	= efx_siena_ethtool_get_link_ksettings,
+	.set_link_ksettings	= efx_siena_ethtool_set_link_ksettings,
 	.get_fec_stats		= efx_ethtool_get_fec_stats,
-	.get_fecparam		= efx_ethtool_get_fecparam,
-	.set_fecparam		= efx_ethtool_set_fecparam,
+	.get_fecparam		= efx_siena_ethtool_get_fecparam,
+	.set_fecparam		= efx_siena_ethtool_set_fecparam,
 };
diff --git a/drivers/net/ethernet/sfc/siena/ethtool_common.c b/drivers/net/ethernet/sfc/siena/ethtool_common.c
index 0c19d26e1872..6fd09f119dce 100644
--- a/drivers/net/ethernet/sfc/siena/ethtool_common.c
+++ b/drivers/net/ethernet/sfc/siena/ethtool_common.c
@@ -100,8 +100,8 @@ static const struct efx_sw_stat_desc efx_sw_stat_desc[] = {
 
 #define EFX_ETHTOOL_SW_STAT_COUNT ARRAY_SIZE(efx_sw_stat_desc)
 
-void efx_ethtool_get_drvinfo(struct net_device *net_dev,
-			     struct ethtool_drvinfo *info)
+void efx_siena_ethtool_get_drvinfo(struct net_device *net_dev,
+				   struct ethtool_drvinfo *info)
 {
 	struct efx_nic *efx = netdev_priv(net_dev);
 
@@ -111,70 +111,22 @@ void efx_ethtool_get_drvinfo(struct net_device *net_dev,
 	strlcpy(info->bus_info, pci_name(efx->pci_dev), sizeof(info->bus_info));
 }
 
-u32 efx_ethtool_get_msglevel(struct net_device *net_dev)
+u32 efx_siena_ethtool_get_msglevel(struct net_device *net_dev)
 {
 	struct efx_nic *efx = netdev_priv(net_dev);
 
 	return efx->msg_enable;
 }
 
-void efx_ethtool_set_msglevel(struct net_device *net_dev, u32 msg_enable)
+void efx_siena_ethtool_set_msglevel(struct net_device *net_dev, u32 msg_enable)
 {
 	struct efx_nic *efx = netdev_priv(net_dev);
 
 	efx->msg_enable = msg_enable;
 }
 
-void efx_ethtool_self_test(struct net_device *net_dev,
-			   struct ethtool_test *test, u64 *data)
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
-	rc = efx_siena_selftest(efx, efx_tests, test->flags);
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
-void efx_ethtool_get_pauseparam(struct net_device *net_dev,
-				struct ethtool_pauseparam *pause)
+void efx_siena_ethtool_get_pauseparam(struct net_device *net_dev,
+				      struct ethtool_pauseparam *pause)
 {
 	struct efx_nic *efx = netdev_priv(net_dev);
 
@@ -183,8 +135,8 @@ void efx_ethtool_get_pauseparam(struct net_device *net_dev,
 	pause->autoneg = !!(efx->wanted_fc & EFX_FC_AUTO);
 }
 
-int efx_ethtool_set_pauseparam(struct net_device *net_dev,
-			       struct ethtool_pauseparam *pause)
+int efx_siena_ethtool_set_pauseparam(struct net_device *net_dev,
+				     struct ethtool_pauseparam *pause)
 {
 	struct efx_nic *efx = netdev_priv(net_dev);
 	u8 wanted_fc, old_fc;
@@ -340,9 +292,9 @@ static int efx_fill_loopback_test(struct efx_nic *efx,
  * The reason for merging these three functions is to make sure that
  * they can never be inconsistent.
  */
-int efx_ethtool_fill_self_tests(struct efx_nic *efx,
-				struct efx_self_tests *tests,
-				u8 *strings, u64 *data)
+static int efx_ethtool_fill_self_tests(struct efx_nic *efx,
+				       struct efx_self_tests *tests,
+				       u8 *strings, u64 *data)
 {
 	struct efx_channel *channel;
 	unsigned int n = 0, i;
@@ -395,6 +347,54 @@ int efx_ethtool_fill_self_tests(struct efx_nic *efx,
 	return n;
 }
 
+void efx_siena_ethtool_self_test(struct net_device *net_dev,
+				 struct ethtool_test *test, u64 *data)
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
+	rc = efx_siena_selftest(efx, efx_tests, test->flags);
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
 static size_t efx_describe_per_queue_stats(struct efx_nic *efx, u8 *strings)
 {
 	size_t n_stats = 0;
@@ -439,7 +439,7 @@ static size_t efx_describe_per_queue_stats(struct efx_nic *efx, u8 *strings)
 	return n_stats;
 }
 
-int efx_ethtool_get_sset_count(struct net_device *net_dev, int string_set)
+int efx_siena_ethtool_get_sset_count(struct net_device *net_dev, int string_set)
 {
 	struct efx_nic *efx = netdev_priv(net_dev);
 
@@ -456,8 +456,8 @@ int efx_ethtool_get_sset_count(struct net_device *net_dev, int string_set)
 	}
 }
 
-void efx_ethtool_get_strings(struct net_device *net_dev,
-			     u32 string_set, u8 *strings)
+void efx_siena_ethtool_get_strings(struct net_device *net_dev,
+				   u32 string_set, u8 *strings)
 {
 	struct efx_nic *efx = netdev_priv(net_dev);
 	int i;
@@ -483,9 +483,9 @@ void efx_ethtool_get_strings(struct net_device *net_dev,
 	}
 }
 
-void efx_ethtool_get_stats(struct net_device *net_dev,
-			   struct ethtool_stats *stats,
-			   u64 *data)
+void efx_siena_ethtool_get_stats(struct net_device *net_dev,
+				 struct ethtool_stats *stats,
+				 u64 *data)
 {
 	struct efx_nic *efx = netdev_priv(net_dev);
 	const struct efx_sw_stat_desc *stat;
@@ -558,8 +558,8 @@ void efx_ethtool_get_stats(struct net_device *net_dev,
 }
 
 /* This must be called with rtnl_lock held. */
-int efx_ethtool_get_link_ksettings(struct net_device *net_dev,
-				   struct ethtool_link_ksettings *cmd)
+int efx_siena_ethtool_get_link_ksettings(struct net_device *net_dev,
+					 struct ethtool_link_ksettings *cmd)
 {
 	struct efx_nic *efx = netdev_priv(net_dev);
 	struct efx_link_state *link_state = &efx->link_state;
@@ -581,8 +581,9 @@ int efx_ethtool_get_link_ksettings(struct net_device *net_dev,
 }
 
 /* This must be called with rtnl_lock held. */
-int efx_ethtool_set_link_ksettings(struct net_device *net_dev,
-				   const struct ethtool_link_ksettings *cmd)
+int
+efx_siena_ethtool_set_link_ksettings(struct net_device *net_dev,
+				     const struct ethtool_link_ksettings *cmd)
 {
 	struct efx_nic *efx = netdev_priv(net_dev);
 	int rc;
@@ -601,8 +602,8 @@ int efx_ethtool_set_link_ksettings(struct net_device *net_dev,
 	return rc;
 }
 
-int efx_ethtool_get_fecparam(struct net_device *net_dev,
-			     struct ethtool_fecparam *fecparam)
+int efx_siena_ethtool_get_fecparam(struct net_device *net_dev,
+				   struct ethtool_fecparam *fecparam)
 {
 	struct efx_nic *efx = netdev_priv(net_dev);
 	int rc;
@@ -614,8 +615,8 @@ int efx_ethtool_get_fecparam(struct net_device *net_dev,
 	return rc;
 }
 
-int efx_ethtool_set_fecparam(struct net_device *net_dev,
-			     struct ethtool_fecparam *fecparam)
+int efx_siena_ethtool_set_fecparam(struct net_device *net_dev,
+				   struct ethtool_fecparam *fecparam)
 {
 	struct efx_nic *efx = netdev_priv(net_dev);
 	int rc;
@@ -806,8 +807,8 @@ static int efx_ethtool_get_class_rule(struct efx_nic *efx,
 	return rc;
 }
 
-int efx_ethtool_get_rxnfc(struct net_device *net_dev,
-			  struct ethtool_rxnfc *info, u32 *rule_locs)
+int efx_siena_ethtool_get_rxnfc(struct net_device *net_dev,
+				struct ethtool_rxnfc *info, u32 *rule_locs)
 {
 	struct efx_nic *efx = netdev_priv(net_dev);
 	u32 rss_context = 0;
@@ -1125,8 +1126,8 @@ static int efx_ethtool_set_class_rule(struct efx_nic *efx,
 	return 0;
 }
 
-int efx_ethtool_set_rxnfc(struct net_device *net_dev,
-			  struct ethtool_rxnfc *info)
+int efx_siena_ethtool_set_rxnfc(struct net_device *net_dev,
+				struct ethtool_rxnfc *info)
 {
 	struct efx_nic *efx = netdev_priv(net_dev);
 
@@ -1147,7 +1148,7 @@ int efx_ethtool_set_rxnfc(struct net_device *net_dev,
 	}
 }
 
-u32 efx_ethtool_get_rxfh_indir_size(struct net_device *net_dev)
+u32 efx_siena_ethtool_get_rxfh_indir_size(struct net_device *net_dev)
 {
 	struct efx_nic *efx = netdev_priv(net_dev);
 
@@ -1156,15 +1157,15 @@ u32 efx_ethtool_get_rxfh_indir_size(struct net_device *net_dev)
 	return ARRAY_SIZE(efx->rss_context.rx_indir_table);
 }
 
-u32 efx_ethtool_get_rxfh_key_size(struct net_device *net_dev)
+u32 efx_siena_ethtool_get_rxfh_key_size(struct net_device *net_dev)
 {
 	struct efx_nic *efx = netdev_priv(net_dev);
 
 	return efx->type->rx_hash_key_size;
 }
 
-int efx_ethtool_get_rxfh(struct net_device *net_dev, u32 *indir, u8 *key,
-			 u8 *hfunc)
+int efx_siena_ethtool_get_rxfh(struct net_device *net_dev, u32 *indir, u8 *key,
+			       u8 *hfunc)
 {
 	struct efx_nic *efx = netdev_priv(net_dev);
 	int rc;
@@ -1184,8 +1185,8 @@ int efx_ethtool_get_rxfh(struct net_device *net_dev, u32 *indir, u8 *key,
 	return 0;
 }
 
-int efx_ethtool_set_rxfh(struct net_device *net_dev, const u32 *indir,
-			 const u8 *key, const u8 hfunc)
+int efx_siena_ethtool_set_rxfh(struct net_device *net_dev, const u32 *indir,
+			       const u8 *key, const u8 hfunc)
 {
 	struct efx_nic *efx = netdev_priv(net_dev);
 
@@ -1203,8 +1204,8 @@ int efx_ethtool_set_rxfh(struct net_device *net_dev, const u32 *indir,
 	return efx->type->rx_push_rss_config(efx, true, indir, key);
 }
 
-int efx_ethtool_get_rxfh_context(struct net_device *net_dev, u32 *indir,
-				 u8 *key, u8 *hfunc, u32 rss_context)
+int efx_siena_ethtool_get_rxfh_context(struct net_device *net_dev, u32 *indir,
+				       u8 *key, u8 *hfunc, u32 rss_context)
 {
 	struct efx_nic *efx = netdev_priv(net_dev);
 	struct efx_rss_context *ctx;
@@ -1234,10 +1235,10 @@ int efx_ethtool_get_rxfh_context(struct net_device *net_dev, u32 *indir,
 	return rc;
 }
 
-int efx_ethtool_set_rxfh_context(struct net_device *net_dev,
-				 const u32 *indir, const u8 *key,
-				 const u8 hfunc, u32 *rss_context,
-				 bool delete)
+int efx_siena_ethtool_set_rxfh_context(struct net_device *net_dev,
+				       const u32 *indir, const u8 *key,
+				       const u8 hfunc, u32 *rss_context,
+				       bool delete)
 {
 	struct efx_nic *efx = netdev_priv(net_dev);
 	struct efx_rss_context *ctx;
@@ -1299,7 +1300,7 @@ int efx_ethtool_set_rxfh_context(struct net_device *net_dev,
 	return rc;
 }
 
-int efx_ethtool_reset(struct net_device *net_dev, u32 *flags)
+int efx_siena_ethtool_reset(struct net_device *net_dev, u32 *flags)
 {
 	struct efx_nic *efx = netdev_priv(net_dev);
 	int rc;
@@ -1311,9 +1312,9 @@ int efx_ethtool_reset(struct net_device *net_dev, u32 *flags)
 	return efx_siena_reset(efx, rc);
 }
 
-int efx_ethtool_get_module_eeprom(struct net_device *net_dev,
-				  struct ethtool_eeprom *ee,
-				  u8 *data)
+int efx_siena_ethtool_get_module_eeprom(struct net_device *net_dev,
+					struct ethtool_eeprom *ee,
+					u8 *data)
 {
 	struct efx_nic *efx = netdev_priv(net_dev);
 	int ret;
@@ -1325,8 +1326,8 @@ int efx_ethtool_get_module_eeprom(struct net_device *net_dev,
 	return ret;
 }
 
-int efx_ethtool_get_module_info(struct net_device *net_dev,
-				struct ethtool_modinfo *modinfo)
+int efx_siena_ethtool_get_module_info(struct net_device *net_dev,
+				      struct ethtool_modinfo *modinfo)
 {
 	struct efx_nic *efx = netdev_priv(net_dev);
 	int ret;
diff --git a/drivers/net/ethernet/sfc/siena/ethtool_common.h b/drivers/net/ethernet/sfc/siena/ethtool_common.h
index 659491932101..04b375dc6800 100644
--- a/drivers/net/ethernet/sfc/siena/ethtool_common.h
+++ b/drivers/net/ethernet/sfc/siena/ethtool_common.h
@@ -11,53 +11,50 @@
 #ifndef EFX_ETHTOOL_COMMON_H
 #define EFX_ETHTOOL_COMMON_H
 
-void efx_ethtool_get_drvinfo(struct net_device *net_dev,
-			     struct ethtool_drvinfo *info);
-u32 efx_ethtool_get_msglevel(struct net_device *net_dev);
-void efx_ethtool_set_msglevel(struct net_device *net_dev, u32 msg_enable);
-void efx_ethtool_self_test(struct net_device *net_dev,
-			   struct ethtool_test *test, u64 *data);
-void efx_ethtool_get_pauseparam(struct net_device *net_dev,
-				struct ethtool_pauseparam *pause);
-int efx_ethtool_set_pauseparam(struct net_device *net_dev,
-			       struct ethtool_pauseparam *pause);
-int efx_ethtool_fill_self_tests(struct efx_nic *efx,
-				struct efx_self_tests *tests,
-				u8 *strings, u64 *data);
-int efx_ethtool_get_sset_count(struct net_device *net_dev, int string_set);
-void efx_ethtool_get_strings(struct net_device *net_dev, u32 string_set,
-			     u8 *strings);
-void efx_ethtool_get_stats(struct net_device *net_dev,
-			   struct ethtool_stats *stats __attribute__ ((unused)),
-			   u64 *data);
-int efx_ethtool_get_link_ksettings(struct net_device *net_dev,
-				   struct ethtool_link_ksettings *out);
-int efx_ethtool_set_link_ksettings(struct net_device *net_dev,
-				   const struct ethtool_link_ksettings *settings);
-int efx_ethtool_get_fecparam(struct net_device *net_dev,
-			     struct ethtool_fecparam *fecparam);
-int efx_ethtool_set_fecparam(struct net_device *net_dev,
-			     struct ethtool_fecparam *fecparam);
-int efx_ethtool_get_rxnfc(struct net_device *net_dev,
-			  struct ethtool_rxnfc *info, u32 *rule_locs);
-int efx_ethtool_set_rxnfc(struct net_device *net_dev,
-			  struct ethtool_rxnfc *info);
-u32 efx_ethtool_get_rxfh_indir_size(struct net_device *net_dev);
-u32 efx_ethtool_get_rxfh_key_size(struct net_device *net_dev);
-int efx_ethtool_get_rxfh(struct net_device *net_dev, u32 *indir, u8 *key,
-			 u8 *hfunc);
-int efx_ethtool_set_rxfh(struct net_device *net_dev,
-			 const u32 *indir, const u8 *key, const u8 hfunc);
-int efx_ethtool_get_rxfh_context(struct net_device *net_dev, u32 *indir,
-				 u8 *key, u8 *hfunc, u32 rss_context);
-int efx_ethtool_set_rxfh_context(struct net_device *net_dev,
-				 const u32 *indir, const u8 *key,
-				 const u8 hfunc, u32 *rss_context,
-				 bool delete);
-int efx_ethtool_reset(struct net_device *net_dev, u32 *flags);
-int efx_ethtool_get_module_eeprom(struct net_device *net_dev,
-				  struct ethtool_eeprom *ee,
-				  u8 *data);
-int efx_ethtool_get_module_info(struct net_device *net_dev,
-				struct ethtool_modinfo *modinfo);
+void efx_siena_ethtool_get_drvinfo(struct net_device *net_dev,
+				   struct ethtool_drvinfo *info);
+u32 efx_siena_ethtool_get_msglevel(struct net_device *net_dev);
+void efx_siena_ethtool_set_msglevel(struct net_device *net_dev, u32 msg_enable);
+void efx_siena_ethtool_self_test(struct net_device *net_dev,
+				 struct ethtool_test *test, u64 *data);
+void efx_siena_ethtool_get_pauseparam(struct net_device *net_dev,
+				      struct ethtool_pauseparam *pause);
+int efx_siena_ethtool_set_pauseparam(struct net_device *net_dev,
+				     struct ethtool_pauseparam *pause);
+int efx_siena_ethtool_get_sset_count(struct net_device *net_dev, int string_set);
+void efx_siena_ethtool_get_strings(struct net_device *net_dev, u32 string_set,
+				   u8 *strings);
+void efx_siena_ethtool_get_stats(struct net_device *net_dev,
+				 struct ethtool_stats *stats __always_unused,
+				 u64 *data);
+int efx_siena_ethtool_get_link_ksettings(struct net_device *net_dev,
+					 struct ethtool_link_ksettings *out);
+int efx_siena_ethtool_set_link_ksettings(struct net_device *net_dev,
+				const struct ethtool_link_ksettings *settings);
+int efx_siena_ethtool_get_fecparam(struct net_device *net_dev,
+				   struct ethtool_fecparam *fecparam);
+int efx_siena_ethtool_set_fecparam(struct net_device *net_dev,
+				   struct ethtool_fecparam *fecparam);
+int efx_siena_ethtool_get_rxnfc(struct net_device *net_dev,
+				struct ethtool_rxnfc *info, u32 *rule_locs);
+int efx_siena_ethtool_set_rxnfc(struct net_device *net_dev,
+				struct ethtool_rxnfc *info);
+u32 efx_siena_ethtool_get_rxfh_indir_size(struct net_device *net_dev);
+u32 efx_siena_ethtool_get_rxfh_key_size(struct net_device *net_dev);
+int efx_siena_ethtool_get_rxfh(struct net_device *net_dev, u32 *indir, u8 *key,
+			       u8 *hfunc);
+int efx_siena_ethtool_set_rxfh(struct net_device *net_dev,
+			       const u32 *indir, const u8 *key, const u8 hfunc);
+int efx_siena_ethtool_get_rxfh_context(struct net_device *net_dev, u32 *indir,
+				       u8 *key, u8 *hfunc, u32 rss_context);
+int efx_siena_ethtool_set_rxfh_context(struct net_device *net_dev,
+				       const u32 *indir, const u8 *key,
+				       const u8 hfunc, u32 *rss_context,
+				       bool delete);
+int efx_siena_ethtool_reset(struct net_device *net_dev, u32 *flags);
+int efx_siena_ethtool_get_module_eeprom(struct net_device *net_dev,
+					struct ethtool_eeprom *ee,
+					u8 *data);
+int efx_siena_ethtool_get_module_info(struct net_device *net_dev,
+				      struct ethtool_modinfo *modinfo);
 #endif

