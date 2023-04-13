Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCEFF6E0BE7
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 12:57:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231236AbjDMK5A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 06:57:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231150AbjDMK47 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 06:56:59 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D804270D
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 03:56:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bP5ZqRhTa9kx3+Z/wS4KEmiSi3u4gCOrD8Ryg1odOQM8R7XzwigCClWvm8Pt74rex0bnJhIfW0V6WsC/dJ9an8p9Sip1iUxDySPuYINHMJrWAAyTC/Lhk2OfuK539Hg3saI2Xo3A8rbAoG8csFlvoJGcvnCCd6Kgk4v1f6C0w+qtXZ0lHIzE9ZqXRdY4P9yLd1Wmp3Y5/oZiieGqUVPxy9Hm/q7LxnEomZ3DRR96tbK0SsypObPU62HZTTgPKbGNqK+mwJRnolMUzqQ1IbCZ3QH9Gsm9acqb8RPKSFr6pre0shbQIFauiTqUzhT/nHZ7OjchMD8ni5TKA80kK4LJcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EvhyYkuW8uOEfIuGQ+pph9oPmKdQS3QKUy0+aZmSHXM=;
 b=oZA0WQBoIkajGf+sN8aaVzE007Lti1Nn9qio9TPWmZhci+itpM+wZdi3cYlo8N/nqsAY/3ixWHluQEmiplzvN95DigzS8InXrCjLdFgSdf7kfftrmsLXN0aBIr6zUm2SHS098naryeP23P98qrGFv3PgRdcwXfPTfOvKajsTikuaaNrvD0JVjAiayw3kHB7kj8acWSDuB59YzpPq0G6XP2WRu7cbfrJKNccWwfezTs9h9N+wFMabnHSF2lpmGl+AGGPaOuDwgbLiOZWC5Yw4pTtPqhE+ntB7XE0R45N/AaRZAnQrtDcV4Krdk1XRU1fnbdWVFn2F9yGIukNxmfw8yw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EvhyYkuW8uOEfIuGQ+pph9oPmKdQS3QKUy0+aZmSHXM=;
 b=bsqM+E/3X1cokH4px/GdN0IXkCHqU+0c417GvCKzhykuEtCtijb6+b7Z3BMDWRZwJD1arkKiu1lH9x0Ane+l+pmECMpEIFKyW5D6lRCN0dkQeXG03E7j6rznubwRPMG8pO82vRQYRAzZsAuM+8XjOF5OCLGNuKKrwQqhePpLJ889nM0XFRg8LSNg2DCF7Tv/2Bl3HmVMuDI7VaooeVNrVNjmZ/CNP0Te0CufPlO9wS0FaRhl2TrWu7wMpNQ2Zv3Amn34vztaulja+1yyWJwQzyzEQV2Y+2mOWuBlsQjrTA+Y7SF4lRAWbOBN0XDB/N/XgKSlWhLtaFisXq0H+/k2sA==
Received: from DM6PR08CA0060.namprd08.prod.outlook.com (2603:10b6:5:1e0::34)
 by MW4PR12MB7333.namprd12.prod.outlook.com (2603:10b6:303:21a::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.30; Thu, 13 Apr
 2023 10:56:48 +0000
Received: from DM6NAM11FT096.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:1e0:cafe::95) by DM6PR08CA0060.outlook.office365.com
 (2603:10b6:5:1e0::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.40 via Frontend
 Transport; Thu, 13 Apr 2023 10:56:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DM6NAM11FT096.mail.protection.outlook.com (10.13.173.145) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6298.32 via Frontend Transport; Thu, 13 Apr 2023 10:56:48 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Thu, 13 Apr 2023
 03:56:37 -0700
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Thu, 13 Apr
 2023 03:56:37 -0700
Received: from vdi.nvidia.com (10.127.8.9) by mail.nvidia.com (10.129.68.10)
 with Microsoft SMTP Server id 15.2.986.37 via Frontend Transport; Thu, 13 Apr
 2023 03:56:35 -0700
From:   Emeel Hakim <ehakim@nvidia.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <sd@queasysnail.net>
CC:     <netdev@vger.kernel.org>, <leon@kernel.org>,
        Emeel Hakim <ehakim@nvidia.com>
Subject: [PATCH net-next v5 1/5] vlan: Add MACsec offload operations for VLAN interface
Date:   Thu, 13 Apr 2023 13:56:18 +0300
Message-ID: <20230413105622.32697-2-ehakim@nvidia.com>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20230413105622.32697-1-ehakim@nvidia.com>
References: <20230413105622.32697-1-ehakim@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT096:EE_|MW4PR12MB7333:EE_
X-MS-Office365-Filtering-Correlation-Id: 17cf4ff2-d61d-41f4-8aa7-08db3c0dc776
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Rj7yu4XhvdrSFTEJDUU1FoYrsi/SoSUifwaWHuabBus5jxrg6tokoiV0andEp0SWASAUAwa66POpi7rW3hV5PROe1ghhXHZ5HYi92lig97bf01PxH9wCJzLOzS2kBzrwxNUWv59B9SmFrr+TAOSnIBFvIwYe0cRo8UzKA0jY4mnvKCXMe3/w3ZEWrLwENkmQ2Z6fbxPtXAQGrnmyv8D0YePUarSVWU9c59Xdqr/i5DKTGk3Rkxn7LZK9+DXwy/2L7ft3heoHoArjVjrDSknYuPnhu7vuml4SSizWINgYykENOxlqGBNzCKU3MthP5eqtFelfNmty62ivc/h+hh1EwQ1vUWsIcYdBRfnrfi3ubI3uPR+feE/HV4memf+dVanawxdS9SsLAxbF8W/8LMWuBWxy+FrvApikNTPUtahbCRLv05djEJdv2cp/WDz47DOaQ5a+l6YamncMSNESL48Z5CAzXqVOesuRoVtmJmgHc8LKLYEV5jiFKCX1rfny3dyLTXU+Zp9ifwD/M6vVMsLstmumm1ApX1VCylZdkrwf9gkafrCMkI99TJGCdS5/4b5pTevQQrt4CCj0DPujvfD+vNvlmchL7PTnUlwS8PYBo+OIfvDr29L2C6xoWG3lz9D1fkLs+tpUEqiSd/sasQcEsRBFrQBupbrA/diO9sdjcHy9n4LUl9Mled+JSYMUFC2cikX4yAW79yn1wppQchYawTiPVtVvWzEbxGKtSElf9qfVGzNW8XKPohFjCAFd6ASkbFEMLS4IrtLEJOk8Nnxtlu/2FYWsezhH3OELAmHqSKk=
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(136003)(396003)(376002)(39860400002)(346002)(451199021)(36840700001)(40470700004)(46966006)(316002)(4326008)(82740400003)(70206006)(70586007)(2616005)(47076005)(426003)(336012)(5660300002)(41300700001)(34020700004)(82310400005)(7696005)(6666004)(36756003)(86362001)(40460700003)(107886003)(54906003)(40480700001)(26005)(186003)(1076003)(2906002)(83380400001)(8676002)(8936002)(36860700001)(478600001)(356005)(7636003)(110136005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2023 10:56:48.0327
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 17cf4ff2-d61d-41f4-8aa7-08db3c0dc776
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT096.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7333
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for MACsec offload operations for VLAN driver
to allow offloading MACsec when VLAN's real device supports
Macsec offload by forwarding the offload request to it.

Signed-off-by: Emeel Hakim <ehakim@nvidia.com>
---
 net/8021q/vlan_dev.c | 242 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 242 insertions(+)

diff --git a/net/8021q/vlan_dev.c b/net/8021q/vlan_dev.c
index 5920544e93e8..870e4935d6e6 100644
--- a/net/8021q/vlan_dev.c
+++ b/net/8021q/vlan_dev.c
@@ -26,6 +26,7 @@
 #include <linux/ethtool.h>
 #include <linux/phy.h>
 #include <net/arp.h>
+#include <net/macsec.h>
 
 #include "vlan.h"
 #include "vlanproc.h"
@@ -572,6 +573,9 @@ static int vlan_dev_init(struct net_device *dev)
 			   NETIF_F_HIGHDMA | NETIF_F_SCTP_CRC |
 			   NETIF_F_ALL_FCOE;
 
+	if (real_dev->vlan_features & NETIF_F_HW_MACSEC)
+		dev->hw_features |= NETIF_F_HW_MACSEC;
+
 	dev->features |= dev->hw_features | NETIF_F_LLTX;
 	netif_inherit_tso_max(dev, real_dev);
 	if (dev->features & NETIF_F_VLAN_FEATURES)
@@ -803,6 +807,241 @@ static int vlan_dev_fill_forward_path(struct net_device_path_ctx *ctx,
 	return 0;
 }
 
+#if IS_ENABLED(CONFIG_MACSEC)
+
+static const struct macsec_ops *vlan_get_macsec_ops(const struct macsec_context *ctx)
+{
+	return vlan_dev_priv(ctx->netdev)->real_dev->macsec_ops;
+}
+
+static int vlan_macsec_offload(int (* const func)(struct macsec_context *),
+			       struct macsec_context *ctx)
+{
+	if (unlikely(!func))
+		return 0;
+
+	return (*func)(ctx);
+}
+
+static int vlan_macsec_dev_open(struct macsec_context *ctx)
+{
+	const struct macsec_ops *ops = vlan_get_macsec_ops(ctx);
+
+	if (!ops)
+		return -EOPNOTSUPP;
+
+	return vlan_macsec_offload(ops->mdo_dev_open, ctx);
+}
+
+static int vlan_macsec_dev_stop(struct macsec_context *ctx)
+{
+	const struct macsec_ops *ops = vlan_get_macsec_ops(ctx);
+
+	if (!ops)
+		return -EOPNOTSUPP;
+
+	return vlan_macsec_offload(ops->mdo_dev_stop, ctx);
+}
+
+static int vlan_macsec_add_secy(struct macsec_context *ctx)
+{
+	const struct macsec_ops *ops = vlan_get_macsec_ops(ctx);
+
+	if (!ops)
+		return -EOPNOTSUPP;
+
+	return vlan_macsec_offload(ops->mdo_add_secy, ctx);
+}
+
+static int vlan_macsec_upd_secy(struct macsec_context *ctx)
+{
+	const struct macsec_ops *ops = vlan_get_macsec_ops(ctx);
+
+	if (!ops)
+		return -EOPNOTSUPP;
+
+	return vlan_macsec_offload(ops->mdo_upd_secy, ctx);
+}
+
+static int vlan_macsec_del_secy(struct macsec_context *ctx)
+{
+	const struct macsec_ops *ops = vlan_get_macsec_ops(ctx);
+
+	if (!ops)
+		return -EOPNOTSUPP;
+
+	return vlan_macsec_offload(ops->mdo_del_secy, ctx);
+}
+
+static int vlan_macsec_add_rxsc(struct macsec_context *ctx)
+{
+	const struct macsec_ops *ops = vlan_get_macsec_ops(ctx);
+
+	if (!ops)
+		return -EOPNOTSUPP;
+
+	return vlan_macsec_offload(ops->mdo_add_rxsc, ctx);
+}
+
+static int vlan_macsec_upd_rxsc(struct macsec_context *ctx)
+{
+	const struct macsec_ops *ops = vlan_get_macsec_ops(ctx);
+
+	if (!ops)
+		return -EOPNOTSUPP;
+
+	return vlan_macsec_offload(ops->mdo_upd_rxsc, ctx);
+}
+
+static int vlan_macsec_del_rxsc(struct macsec_context *ctx)
+{
+	const struct macsec_ops *ops = vlan_get_macsec_ops(ctx);
+
+	if (!ops)
+		return -EOPNOTSUPP;
+
+	return vlan_macsec_offload(ops->mdo_del_rxsc, ctx);
+}
+
+static int vlan_macsec_add_rxsa(struct macsec_context *ctx)
+{
+	const struct macsec_ops *ops = vlan_get_macsec_ops(ctx);
+
+	if (!ops)
+		return -EOPNOTSUPP;
+
+	return vlan_macsec_offload(ops->mdo_add_rxsa, ctx);
+}
+
+static int vlan_macsec_upd_rxsa(struct macsec_context *ctx)
+{
+	const struct macsec_ops *ops = vlan_get_macsec_ops(ctx);
+
+	if (!ops)
+		return -EOPNOTSUPP;
+
+	return vlan_macsec_offload(ops->mdo_upd_rxsa, ctx);
+}
+
+static int vlan_macsec_del_rxsa(struct macsec_context *ctx)
+{
+	const struct macsec_ops *ops = vlan_get_macsec_ops(ctx);
+
+	if (!ops)
+		return -EOPNOTSUPP;
+
+	return vlan_macsec_offload(ops->mdo_del_rxsa, ctx);
+}
+
+static int vlan_macsec_add_txsa(struct macsec_context *ctx)
+{
+	const struct macsec_ops *ops = vlan_get_macsec_ops(ctx);
+
+	if (!ops)
+		return -EOPNOTSUPP;
+
+	return vlan_macsec_offload(ops->mdo_add_txsa, ctx);
+}
+
+static int vlan_macsec_upd_txsa(struct macsec_context *ctx)
+{
+	const struct macsec_ops *ops = vlan_get_macsec_ops(ctx);
+
+	if (!ops)
+		return -EOPNOTSUPP;
+
+	return vlan_macsec_offload(ops->mdo_upd_txsa, ctx);
+}
+
+static int vlan_macsec_del_txsa(struct macsec_context *ctx)
+{
+	const struct macsec_ops *ops = vlan_get_macsec_ops(ctx);
+
+	if (!ops)
+		return -EOPNOTSUPP;
+
+	return vlan_macsec_offload(ops->mdo_del_txsa, ctx);
+}
+
+static int vlan_macsec_get_dev_stats(struct macsec_context *ctx)
+{
+	const struct macsec_ops *ops = vlan_get_macsec_ops(ctx);
+
+	if (!ops)
+		return -EOPNOTSUPP;
+
+	return vlan_macsec_offload(ops->mdo_get_dev_stats, ctx);
+}
+
+static int vlan_macsec_get_tx_sc_stats(struct macsec_context *ctx)
+{
+	const struct macsec_ops *ops = vlan_get_macsec_ops(ctx);
+
+	if (!ops)
+		return -EOPNOTSUPP;
+
+	return vlan_macsec_offload(ops->mdo_get_tx_sc_stats, ctx);
+}
+
+static int vlan_macsec_get_tx_sa_stats(struct macsec_context *ctx)
+{
+	const struct macsec_ops *ops = vlan_get_macsec_ops(ctx);
+
+	if (!ops)
+		return -EOPNOTSUPP;
+
+	return vlan_macsec_offload(ops->mdo_get_tx_sa_stats, ctx);
+}
+
+static int vlan_macsec_get_rx_sc_stats(struct macsec_context *ctx)
+{
+	const struct macsec_ops *ops = vlan_get_macsec_ops(ctx);
+
+	if (!ops)
+		return -EOPNOTSUPP;
+
+	return vlan_macsec_offload(ops->mdo_get_rx_sc_stats, ctx);
+}
+
+static int vlan_macsec_get_rx_sa_stats(struct macsec_context *ctx)
+{
+	const struct macsec_ops *ops = vlan_get_macsec_ops(ctx);
+
+	if (!ops)
+		return -EOPNOTSUPP;
+
+	return vlan_macsec_offload(ops->mdo_get_rx_sa_stats, ctx);
+}
+
+static const struct macsec_ops macsec_offload_ops = {
+	/* Device wide */
+	.mdo_dev_open = vlan_macsec_dev_open,
+	.mdo_dev_stop = vlan_macsec_dev_stop,
+	/* SecY */
+	.mdo_add_secy = vlan_macsec_add_secy,
+	.mdo_upd_secy = vlan_macsec_upd_secy,
+	.mdo_del_secy = vlan_macsec_del_secy,
+	/* Security channels */
+	.mdo_add_rxsc = vlan_macsec_add_rxsc,
+	.mdo_upd_rxsc = vlan_macsec_upd_rxsc,
+	.mdo_del_rxsc = vlan_macsec_del_rxsc,
+	/* Security associations */
+	.mdo_add_rxsa = vlan_macsec_add_rxsa,
+	.mdo_upd_rxsa = vlan_macsec_upd_rxsa,
+	.mdo_del_rxsa = vlan_macsec_del_rxsa,
+	.mdo_add_txsa = vlan_macsec_add_txsa,
+	.mdo_upd_txsa = vlan_macsec_upd_txsa,
+	.mdo_del_txsa = vlan_macsec_del_txsa,
+	/* Statistics */
+	.mdo_get_dev_stats = vlan_macsec_get_dev_stats,
+	.mdo_get_tx_sc_stats = vlan_macsec_get_tx_sc_stats,
+	.mdo_get_tx_sa_stats = vlan_macsec_get_tx_sa_stats,
+	.mdo_get_rx_sc_stats = vlan_macsec_get_rx_sc_stats,
+	.mdo_get_rx_sa_stats = vlan_macsec_get_rx_sa_stats,
+};
+
+#endif
+
 static const struct ethtool_ops vlan_ethtool_ops = {
 	.get_link_ksettings	= vlan_ethtool_get_link_ksettings,
 	.get_drvinfo	        = vlan_ethtool_get_drvinfo,
@@ -869,6 +1108,9 @@ void vlan_setup(struct net_device *dev)
 	dev->priv_destructor	= vlan_dev_free;
 	dev->ethtool_ops	= &vlan_ethtool_ops;
 
+#if IS_ENABLED(CONFIG_MACSEC)
+	dev->macsec_ops		= &macsec_offload_ops;
+#endif
 	dev->min_mtu		= 0;
 	dev->max_mtu		= ETH_MAX_MTU;
 
-- 
2.21.3

