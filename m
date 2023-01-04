Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4055365CDD4
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 08:47:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233436AbjADHrW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 02:47:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229970AbjADHrU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 02:47:20 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2040.outbound.protection.outlook.com [40.107.223.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86D60E36
        for <netdev@vger.kernel.org>; Tue,  3 Jan 2023 23:47:19 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Lz2XHLsyvJLGfaZDUyIR/URy1+LbdCJ/9+02hWA28owriWxbmV2bJ7p/GadHsGUb/KiesBBorNtlZalRvq0gBXNHZYwPPLcWAfg530jBhc1iw0X63KhfIgifItufhK1Cgw2x9plH/izEuRVlmxCfhhVjRPS8SYGIY6vt4P8jzji/1J3tO20RrfhgyQvFucG7QsrlqWQFx0PAHOCXD8bwWjD69W0GuM9sPG8F51D51+Mqa9PRK8Pg3px+D+UlCU2H9uWTWB0HXIMe65qfbL05CFEsLylm/n6fMW6EC9/gX5JjQZgfaS3nzG33wlBp2PXq0YoPJ7i0ly8zWlWg2F6fyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eoIwdymIKGWSwHSbp2RxIzxTyBefDh4zTuW6ThAMO+8=;
 b=cL4x4Qaf50M9XfUEvxAVYYVCz9cdOb0juYUmstax/c6IAMd285RxZTdEVERYDQVWGS/gAYpkYy3S5ZTfgKk8JULOLCvTzLs8ZJ9LEH0Gy4shkJvicVUgRtBf9SpqrDUw6rd6mprn5cOLmwQbvN5npJPF8oHUSF27eRkrLzRNVkZpK5K/lSDeM/gY+mIvsJ1GV0rgCpxOUNkOt0N5XLYaqKOXCi3llyLOSwNHBMJGbKJCBcJq612ve426OlYNPhDtI3ot3jkeYMRw6iWenEToN8Yk0pp1R5EfcIeW2ag4te54wdU85jepqSSPUNRUXEa6a4m8XGZPk+tSARFnAjJrtw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eoIwdymIKGWSwHSbp2RxIzxTyBefDh4zTuW6ThAMO+8=;
 b=JxH0bRM5TJciTJWk2unrbQAnRrv2kFqN9lcJZIFc1D3fh/GaLYyExYWlL8Hxg2EVtRFzN7onYCCe4BI6yyfaiKbHZg5OBfXKet8paAUBr0pzQbeAGSOU84VpoxDXp9omLt6gBmrlnT1V451TG9bxeIxLgLzNeHH0jWHXSAQXr4uc7QCKosEsWXR2ZX9r7s6TbkfoZ5nMwT8+WmzbF0T6tqC/fU55dyKbM/1xGPsyUparyk9Yof3Cg0bpwdT71WM2xn19uSQMjc3gBtYI4COPGCjxD3LQThbpa8Ra3Bh0290UOFHXWStKQozF+hDoSRsh4jOEBuJzl5YGYeUNq6XPtA==
Received: from BN9PR03CA0334.namprd03.prod.outlook.com (2603:10b6:408:f6::9)
 by SJ0PR12MB6965.namprd12.prod.outlook.com (2603:10b6:a03:448::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Wed, 4 Jan
 2023 07:47:17 +0000
Received: from BN8NAM11FT081.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:f6:cafe::9d) by BN9PR03CA0334.outlook.office365.com
 (2603:10b6:408:f6::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5966.19 via Frontend
 Transport; Wed, 4 Jan 2023 07:47:17 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 BN8NAM11FT081.mail.protection.outlook.com (10.13.177.233) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5944.17 via Frontend Transport; Wed, 4 Jan 2023 07:47:16 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Tue, 3 Jan 2023
 23:47:05 -0800
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Tue, 3 Jan 2023 23:47:04 -0800
Received: from vdi.nvidia.com (10.127.8.9) by mail.nvidia.com (10.126.190.180)
 with Microsoft SMTP Server id 15.2.986.36 via Frontend Transport; Tue, 3 Jan
 2023 23:47:02 -0800
From:   <ehakim@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <raeds@nvidia.com>, <davem@davemloft.net>, <edumazet@google.com>,
        <kuba@kernel.org>, <pabeni@redhat.com>, <sd@queasysnail.net>,
        <atenart@kernel.org>, Emeel Hakim <ehakim@nvidia.com>
Subject: [PATCH net-next 1/2] macsec: add support for IFLA_MACSEC_OFFLOAD in macsec_changelink
Date:   Wed, 4 Jan 2023 09:46:50 +0200
Message-ID: <20230104074651.6474-1-ehakim@nvidia.com>
X-Mailer: git-send-email 2.21.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT081:EE_|SJ0PR12MB6965:EE_
X-MS-Office365-Filtering-Correlation-Id: 28ebc82a-f8c6-4143-0b3d-08daee27e6ce
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZUWALs+HtgnLrOfbpmbqqCita3ag46+bsfAVyOCR2lGBT3BOxDQ3Olql9j98CCIBRAgYSNa6AKshzhzUPJMBg/S/9JfZxhVvSu2vrSKbHgiCURBltyILENKSsSA+0w2OQoyrhjKUGSQ5ZqIUoiCjB07ilzUGcyaJTJjxy9oidCQ5fpv7iMPSYkKr5QSPCrNc367SzpjY4VdgPweauWRjulfonzSaXqF/4mpz1/ZMYuUk53X2YCYnRSo29VfybTpgA3nLvvvQRIV+7hb1st44on06JKyWgnuuVfEmdY+ZI3/eD/wYtkkFE/TMtvlHDxSwcsByNucbkMwyVUCGe+Ws+pDigSi13B3ah4t3fqPVyUSPqX+Tew1BKNZ5ffOuryzD3iEIIBIB4GdOQpb4QRM+r/eVrVRiaWY8uDIq0VlyGdptp/lqaXzrD4xx5CTwvKJwN8NXK7gC+F41gFMC9KuklBI1uAXznt6MZaRrVkS2u4zINTwthEAmW+OC1ALQ3trlQmhtUsemtQY+dMkFpy3SO8+BDN1oUVWRXKZ/lfCoY/KfdgshQJ0btIs2TIGGuUpmxoY512/OAPlWEkh6CqesmiKNIhcJmY5sqD83I8xwNNPn3TPm0Dbt8bZ+qMSjxy8yW1U6GPl5AVh4HUTfd7M8rXDedBmMVGTV8hm31a7AgqreEkTJoLFUvbtz658yi/V5RlFvUvBq+oj9XFwNT+hsGQ==
X-Forefront-Antispam-Report: CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(396003)(39860400002)(376002)(136003)(346002)(451199015)(40470700004)(46966006)(36840700001)(2906002)(2876002)(5660300002)(8936002)(41300700001)(4326008)(8676002)(70206006)(70586007)(316002)(6916009)(54906003)(478600001)(2616005)(336012)(26005)(186003)(82310400005)(40480700001)(7696005)(6666004)(107886003)(1076003)(426003)(83380400001)(47076005)(82740400003)(356005)(7636003)(40460700003)(86362001)(36756003)(36860700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jan 2023 07:47:16.7713
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 28ebc82a-f8c6-4143-0b3d-08daee27e6ce
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT081.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB6965
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Emeel Hakim <ehakim@nvidia.com>

Add support for changing Macsec offload selection through the
netlink layer by implementing the relevant changes in
macsec_changelink.

Since the handling in macsec_changelink is similar to macsec_upd_offload,
update macsec_upd_offload to use a common helper function to avoid
duplication.

Example for setting offload for a macsec device:
    ip link set macsec0 type macsec offload mac

Reviewed-by: Raed Salem <raeds@nvidia.com>
Signed-off-by: Emeel Hakim <ehakim@nvidia.com>
---
 drivers/net/macsec.c | 116 +++++++++++++++++++++----------------------
 1 file changed, 57 insertions(+), 59 deletions(-)

diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index bf8ac7a3ded7..1974c59977aa 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -2583,95 +2583,87 @@ static bool macsec_is_configured(struct macsec_dev *macsec)
 	return false;
 }
 
-static int macsec_upd_offload(struct sk_buff *skb, struct genl_info *info)
+static int macsec_update_offload(struct net_device *dev, enum macsec_offload offload)
 {
-	struct nlattr *tb_offload[MACSEC_OFFLOAD_ATTR_MAX + 1];
-	enum macsec_offload offload, prev_offload;
-	int (*func)(struct macsec_context *ctx);
-	struct nlattr **attrs = info->attrs;
-	struct net_device *dev;
+	enum macsec_offload prev_offload;
 	const struct macsec_ops *ops;
 	struct macsec_context ctx;
 	struct macsec_dev *macsec;
 	int ret = 0;
 
-	if (!attrs[MACSEC_ATTR_IFINDEX])
-		return -EINVAL;
-
-	if (!attrs[MACSEC_ATTR_OFFLOAD])
-		return -EINVAL;
-
-	if (nla_parse_nested_deprecated(tb_offload, MACSEC_OFFLOAD_ATTR_MAX,
-					attrs[MACSEC_ATTR_OFFLOAD],
-					macsec_genl_offload_policy, NULL))
-		return -EINVAL;
-
-	rtnl_lock();
-
-	dev = get_dev_from_nl(genl_info_net(info), attrs);
-	if (IS_ERR(dev)) {
-		ret = PTR_ERR(dev);
-		goto out;
-	}
 	macsec = macsec_priv(dev);
 
-	if (!tb_offload[MACSEC_OFFLOAD_ATTR_TYPE]) {
-		ret = -EINVAL;
-		goto out;
-	}
-
-	offload = nla_get_u8(tb_offload[MACSEC_OFFLOAD_ATTR_TYPE]);
 	if (macsec->offload == offload)
-		goto out;
+		return 0;
 
 	/* Check if the offloading mode is supported by the underlying layers */
 	if (offload != MACSEC_OFFLOAD_OFF &&
 	    !macsec_check_offload(offload, macsec)) {
-		ret = -EOPNOTSUPP;
-		goto out;
+		return -EOPNOTSUPP;
 	}
 
 	/* Check if the net device is busy. */
-	if (netif_running(dev)) {
-		ret = -EBUSY;
-		goto out;
-	}
-
-	prev_offload = macsec->offload;
-	macsec->offload = offload;
+	if (netif_running(dev))
+		return -EBUSY;
 
 	/* Check if the device already has rules configured: we do not support
 	 * rules migration.
 	 */
-	if (macsec_is_configured(macsec)) {
-		ret = -EBUSY;
-		goto rollback;
-	}
+	if (macsec_is_configured(macsec))
+		return -EBUSY;
+
+	prev_offload = macsec->offload;
 
 	ops = __macsec_get_ops(offload == MACSEC_OFFLOAD_OFF ? prev_offload : offload,
 			       macsec, &ctx);
-	if (!ops) {
-		ret = -EOPNOTSUPP;
-		goto rollback;
-	}
+	if (!ops)
+		return -EOPNOTSUPP;
 
-	if (prev_offload == MACSEC_OFFLOAD_OFF)
-		func = ops->mdo_add_secy;
-	else
-		func = ops->mdo_del_secy;
+	macsec->offload = offload;
 
 	ctx.secy = &macsec->secy;
-	ret = macsec_offload(func, &ctx);
+	ret = offload == MACSEC_OFFLOAD_OFF ? macsec_offload(ops->mdo_del_secy, &ctx)
+					    : macsec_offload(ops->mdo_add_secy, &ctx);
 	if (ret)
-		goto rollback;
+		macsec->offload = prev_offload;
 
-	rtnl_unlock();
-	return 0;
+	return ret;
+}
+
+static int macsec_upd_offload(struct sk_buff *skb, struct genl_info *info)
+{
+	struct nlattr *tb_offload[MACSEC_OFFLOAD_ATTR_MAX + 1];
+	struct nlattr **attrs = info->attrs;
+	enum macsec_offload offload;
+	struct net_device *dev;
+	int ret;
+
+	if (!attrs[MACSEC_ATTR_IFINDEX])
+		return -EINVAL;
+
+	if (!attrs[MACSEC_ATTR_OFFLOAD])
+		return -EINVAL;
+
+	if (nla_parse_nested_deprecated(tb_offload, MACSEC_OFFLOAD_ATTR_MAX,
+					attrs[MACSEC_ATTR_OFFLOAD],
+					macsec_genl_offload_policy, NULL))
+		return -EINVAL;
+
+	dev = get_dev_from_nl(genl_info_net(info), attrs);
+	if (IS_ERR(dev))
+		return PTR_ERR(dev);
+
+	if (!tb_offload[MACSEC_OFFLOAD_ATTR_TYPE])
+		return -EINVAL;
+
+	offload = nla_get_u8(tb_offload[MACSEC_OFFLOAD_ATTR_TYPE]);
+
+	rtnl_lock();
+
+	ret = macsec_update_offload(dev, offload);
 
-rollback:
-	macsec->offload = prev_offload;
-out:
 	rtnl_unlock();
+
 	return ret;
 }
 
@@ -3840,6 +3832,12 @@ static int macsec_changelink(struct net_device *dev, struct nlattr *tb[],
 	if (ret)
 		goto cleanup;
 
+	if (data[IFLA_MACSEC_OFFLOAD]) {
+		ret = macsec_update_offload(dev, nla_get_u8(data[IFLA_MACSEC_OFFLOAD]));
+		if (ret)
+			goto cleanup;
+	}
+
 	/* If h/w offloading is available, propagate to the device */
 	if (macsec_is_offloaded(macsec)) {
 		const struct macsec_ops *ops;
-- 
2.21.3

