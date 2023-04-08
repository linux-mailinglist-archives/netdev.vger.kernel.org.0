Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 990216DBA4C
	for <lists+netdev@lfdr.de>; Sat,  8 Apr 2023 12:58:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230074AbjDHK6d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Apr 2023 06:58:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230095AbjDHK6R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Apr 2023 06:58:17 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2053.outbound.protection.outlook.com [40.107.244.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97D673596
        for <netdev@vger.kernel.org>; Sat,  8 Apr 2023 03:58:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eqrZDDpsL1o+L3HCX+58wqqXKPC5JKRB8hisyroxjCKERtjXSfAtwjDOmOJdtRo1wljMo4oqVWvxsTafxaurzqPhdV/fp+iWPn/k+ir7Eh2cXGS6zpxIVDCuHu/fp4Vu1zSD0rO+Jw8pTMBxswgwb4F6sSiI2uA4XFq9cp0Q0t0MboHXdeJTEbb1cikMMi/R+H7wZ82Gl6P0DIAVwgXaRCvDBdSBrRDsc6y8o9xcNKeYWkPGD8xyM2NpT0HTZjySA8ADPcCupCOtwBTuQyudf4Q27nKurC3pOc/TImnnRgR2zvwY8cO+gMhnDggFfwra32xDjLvhJdl3czYxjVGfsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EvhyYkuW8uOEfIuGQ+pph9oPmKdQS3QKUy0+aZmSHXM=;
 b=GltoPuFsGawHacztOzIBDB+Bg79n0Xkux05l2XrytJWTfA4WcBcmY6p42ArdZzZQisaL9r8QmRn2+Lgro0/8Qcd0PQ2AYj0ZrByrbZSNIPYPNGpVLmP+Is88nW5/ROdX+fo0iQgop+v0mhuoqwzYM+3KYx+TlZxmVx3zN/zonS5oVRLnIJRSNdsrl3hkgmFbMaPi41FZna/8Z51QyNQnUYX9P2Kb4i3mjqGYKdc57uhXRCHn9+NAik3wjIYOFGe6JL8Lv3fpZQENNkZjvly2+68Q5dkemDwX8Fwz0gVc17WaEyy7o433b0u5BxT/thsuYobpGy+KIidB6g8b6zgC+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EvhyYkuW8uOEfIuGQ+pph9oPmKdQS3QKUy0+aZmSHXM=;
 b=E2b9hXceKMa4BZJyTCm1LTaXV19kZ4ObMR1r87anct9IelP9egO7rhm2SjeYpMDbDF9+0TL/4CTpugJ930wrCtL8jmgnNMlXuT1nJFlTbVYtmwUFFNyQjYs44wyhGOBf7TdIxhudvarZNjmiXZGnrPb7cnpfuynXDYnhSbgR8tsJyqFjFfzXy3jYLti+2UupKpDYWRd+3VMCweAr8scAL+EkLYBohWJdf++3sAPGXugCXuYpBwbGSe3TdXqWhZyL7lGbeKO4byq2oIBS/CyRlyPXQsMNJuGTflbn71lvgsbp2/UuLG0ly0gcu5/N6Io7rwQoEapZFw1Tpca/MntEdA==
Received: from DM6PR02CA0156.namprd02.prod.outlook.com (2603:10b6:5:332::23)
 by CY5PR12MB6105.namprd12.prod.outlook.com (2603:10b6:930:2a::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.35; Sat, 8 Apr
 2023 10:57:57 +0000
Received: from DM6NAM11FT049.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:332:cafe::4a) by DM6PR02CA0156.outlook.office365.com
 (2603:10b6:5:332::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.36 via Frontend
 Transport; Sat, 8 Apr 2023 10:57:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 DM6NAM11FT049.mail.protection.outlook.com (10.13.172.188) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6298.21 via Frontend Transport; Sat, 8 Apr 2023 10:57:56 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Sat, 8 Apr 2023
 03:57:43 -0700
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.37; Sat, 8 Apr 2023 03:57:43 -0700
Received: from vdi.nvidia.com (10.127.8.9) by mail.nvidia.com (10.126.190.181)
 with Microsoft SMTP Server id 15.2.986.37 via Frontend Transport; Sat, 8 Apr
 2023 03:57:41 -0700
From:   Emeel Hakim <ehakim@nvidia.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <sd@queasysnail.net>
CC:     <netdev@vger.kernel.org>, <leon@kernel.org>,
        Emeel Hakim <ehakim@nvidia.com>
Subject: [PATCH net-next v4 1/5] vlan: Add MACsec offload operations for VLAN interface
Date:   Sat, 8 Apr 2023 13:57:31 +0300
Message-ID: <20230408105735.22935-2-ehakim@nvidia.com>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20230408105735.22935-1-ehakim@nvidia.com>
References: <20230408105735.22935-1-ehakim@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT049:EE_|CY5PR12MB6105:EE_
X-MS-Office365-Filtering-Correlation-Id: bc966c4b-ab70-4b9a-abb9-08db38201c7a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: f+89fn2JBVil/EGKCQZM6z0OE4vi28OLN7Nn5VaVnjMfAirlqxU86SvdoRX3N+zOAZmo/v9iV6/7yFwQJfkqgGBXI/aGj/JAYuMeJcxKZJlIL7zrFbU6+dzF2jFy4hRK8NNdMiY04ZFrdgJsOoBxkkoiXxb0DHOsm+ajkp1SRt80pFmLryU5uiGoRyUjMgrYYzDMdve4mFMQ1WxXYKpxBmOyrehZmouWdzVn2Tecw7BH3QNAzzcgO3px+1qA52Vbzl2m8YOJu5a48WfBKw+OvFjBDbItZ4neHtEEQYKoCfrUov8NQ/PjnnGcjlvu1I6RJx3XF5vW3N6zooHIpc/4nGD0mtZREB0WJf1RSNW9Pgvl8RJ2ZX+6ho2GxZQ5YkYDyKzZnDwRgnABm8YZ3YgFrg342CURqjic0T3K4O8Wk3uBiHCXPX+s+Ych5Npa1ciuD94VclPmIum8WJD8fu5defhzX+7aqjLIW/3Wuwfs7kG5o6D1aYAzmS0UxeVuggpVHIA3bIlQ4Z2CgSTrqsouq9aD7Y5nPjk8rd4lCspUMqCy/9lKOHpDpYCMO6MenicYNeLHSYZ7YbGrtCcXvQwfOoQfgA6NnOewIQPnDVNUPgvm2O8GHNkqhGb9IqUWnO0ryp275hYJtlODaLDCh5358ULL+F9rWu28wCTV075LfmHcJWwLJZoGKOYI/iWPXcl1qfAs46a+GPGai2MTbbfTKvxQ0VMEHccyVOIjooQMdsbS4rL1mqgFPsWQjhG5aXoW
X-Forefront-Antispam-Report: CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(396003)(346002)(39860400002)(136003)(376002)(451199021)(46966006)(40470700004)(36840700001)(5660300002)(82310400005)(4326008)(82740400003)(7636003)(40480700001)(478600001)(356005)(36756003)(36860700001)(70586007)(70206006)(8676002)(86362001)(41300700001)(110136005)(316002)(54906003)(7696005)(40460700003)(8936002)(426003)(2616005)(336012)(186003)(26005)(1076003)(2906002)(107886003)(6666004)(47076005)(83380400001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2023 10:57:56.9561
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bc966c4b-ab70-4b9a-abb9-08db38201c7a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT049.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6105
X-Spam-Status: No, score=0.8 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
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

