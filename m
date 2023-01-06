Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D677F66015F
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 14:36:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233965AbjAFNg0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 08:36:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233714AbjAFNgW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 08:36:22 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2085.outbound.protection.outlook.com [40.107.237.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B3B026D
        for <netdev@vger.kernel.org>; Fri,  6 Jan 2023 05:36:17 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XR7MjYEseJAzbdLYVyFo2LSW+eESROeqYch2ulgV8yoITFQp7nhX95NBnOQNtTlsinxY2U71wsSYeKRrInSWMwiudRJK4JBLQB3+q/3erKioi/up333mTYucF2jRk6eRXY7RzfAvoWcFh0gF4FPudwVsJTWuzHpDqK+KYgwdhFWBAbI+TmVAAfGyYcufkanSTYHfSW2nCzTvW2h5Nr0LU3ypFtN9vNQvWikXuB2sneVTtxI5MGX6m1qCaLJ6SNbtbVEr4FdfZXHpMZJ2dYVdmszE2PnefbvZpS2t2O1qdQPW+L+rKGQqRRfmSiS+OKOz1XNnPrX1evIK4LYFc6L0Qw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=50BnEFyfDGepMIZJY3UAmnZMiARCAe8Wn0x+mzjPlxg=;
 b=FewhYpN09Y63PrlAneEJI/wkgCKKE81rKwpq6IvzMQltrUVGqPtRhbRrpPK7zUARZGi/eVTvifupWgsJiRtUAcXVQRsjqL0Xe24Pbyu01rmDpYkopFaVAg2fcn2gNrg3AVGM8KIlEYDuNPaW3Kws0cAEgOakodwhZhjIgeZi9/OjQP6sDJrwHiRgSQZx71093x4Z/sbjPxi/waLR1ZFuc9NuKUKCb9gAvg5543/FlLlcay+fCFRUBalaU4lv+AtD+JuTkmbKBq257iK9VFtvx7vbKjT/jgvHpXRG8tFdPMX5az8KvxkEKvtNR8Z8z/nYJwYTnxItzrgupL7t1tnrbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=50BnEFyfDGepMIZJY3UAmnZMiARCAe8Wn0x+mzjPlxg=;
 b=rQ+wkLCZr8/TGV0pf97+Tlb8n07Cd6vGVQq7ehuOUSDvsAvR4IYiN7sjso+4UDm96nEJeDDLJvY5ViUSvLxmdHVoBFWMkuwUMh3skDdkoQ7iUQnxD21j3jD0Aqoe2xxo9n2Lkz/fj/xoYWiEtNkXyEeXoaIFqXWDYFchGXyU6fsHkLdW9T/qwfV4Y/7RSywI5IZLyCFEv9lCr/mNgWFNm2qEDuGWyn0K3yHRsECMFDBLaszUl1tTlMrkJ3patIvStPgX2MVPr4i1Ol+0BcyQwvDcVQ86QuraV3P/7xecEoxKl9DLYbAVhjK+lhIpnHFqK0ovPVKhfpLJLkNCLbtwqA==
Received: from DS7PR03CA0154.namprd03.prod.outlook.com (2603:10b6:5:3b2::9) by
 SN7PR12MB6689.namprd12.prod.outlook.com (2603:10b6:806:273::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Fri, 6 Jan
 2023 13:36:15 +0000
Received: from DM6NAM11FT052.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3b2:cafe::b5) by DS7PR03CA0154.outlook.office365.com
 (2603:10b6:5:3b2::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.15 via Frontend
 Transport; Fri, 6 Jan 2023 13:36:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DM6NAM11FT052.mail.protection.outlook.com (10.13.172.111) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5966.17 via Frontend Transport; Fri, 6 Jan 2023 13:36:15 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Fri, 6 Jan 2023
 05:36:07 -0800
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Fri, 6 Jan 2023
 05:36:07 -0800
Received: from vdi.nvidia.com (10.127.8.9) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.986.36 via Frontend Transport; Fri, 6 Jan
 2023 05:36:04 -0800
From:   <ehakim@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <raeds@nvidia.com>, <davem@davemloft.net>, <edumazet@google.com>,
        <kuba@kernel.org>, <pabeni@redhat.com>, <sd@queasysnail.net>,
        <atenart@kernel.org>, Emeel Hakim <ehakim@nvidia.com>
Subject: [PATCH net-next v6 1/2] macsec: add support for IFLA_MACSEC_OFFLOAD in macsec_changelink
Date:   Fri, 6 Jan 2023 15:35:50 +0200
Message-ID: <20230106133551.31940-2-ehakim@nvidia.com>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20230106133551.31940-1-ehakim@nvidia.com>
References: <20230106133551.31940-1-ehakim@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT052:EE_|SN7PR12MB6689:EE_
X-MS-Office365-Filtering-Correlation-Id: 6a4812f4-2cf4-4ae1-f62d-08daefeafbe0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aaSj9jQKpj6DOYPU/4RkLmex22Swb3sPtGgqhqJVIL4SpNTCkz58DgH0MDGmUjaFa+DORySPf5ADDHuQPab25MIfsBrAVRGTd62SgGwTelvIrVuehmqPWthaZPv1g85SSsAUpITLX4IoBHxZRdcuA1hNrEJqzR67FDtLXfoZebtnLtDtsIvekUw10BuPXZCqM3Vga3Rx5HHg9equVjYIhQPqZ+GNOqZdt3yfR8ysjhm2R9/OW/3DJvbJrVI7oZFzVzrAHG08RmQd1bhpRZaS25uxJtRIz7SA+SQjQX6WYFnz6Jb6g7bP1h53gNzMDP8J6lTa3vtVGFLONiCHQD9ygB/sRhad30/9I7hGlhnvVGmTZNAjCZ42HHQk7Nr9eMAcRUWlNWZCj3XAqY8VajkPTnvD2TKFv78/s7ABYra9C5oVTnoQ/it+O117yn0UVU5BOboIooecQ8l8WGZDDLXBp0qokPyNGVIL7CJos2nRAdCfBZiuqO9xhQ3UpHfjIHP2evAYz00jichhYHl9+uNTXe7zI5dSgbvumD5NV600gEbkUm5cFvxMZgfSMBmZd86THLpGvcmLe+jTKLW8dvF1m1xEnp8ZUkx2GUlQKLRM4AMILOSFIBrnRoFIPGVqa7M97SDnGXyMyiYDi3SnVoJonV8TOT10m1O4vcrBWSDhCKdrci3OCtMLnd2G5uje4PZJViTBGg43sVfndY5L+QFZ/g==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(136003)(396003)(376002)(346002)(39860400002)(451199015)(36840700001)(40470700004)(46966006)(478600001)(107886003)(2876002)(36756003)(6666004)(36860700001)(83380400001)(82310400005)(82740400003)(7636003)(40460700003)(86362001)(7696005)(40480700001)(356005)(336012)(1076003)(47076005)(426003)(2616005)(186003)(26005)(5660300002)(70586007)(316002)(8676002)(70206006)(8936002)(4326008)(54906003)(2906002)(41300700001)(6916009);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2023 13:36:15.2150
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a4812f4-2cf4-4ae1-f62d-08daefeafbe0
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT052.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6689
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
v5 -> v6: - Locking issue got fixed in a separate patch so rebase
V4 -> V5: - Fail immediately if macsec ops does not exist
V3 -> V4: - Dont pass whole attributes data to macsec_update_offload, just pass relevant attribute.
                 - Fix code style.
                 - Remove macsec_changelink_upd_offload
V2 -> V3: - Split the original patch into 3 patches, the macsec_rtnl_policy related change (separate patch)
                        to be sent to "net" branch as a fix.
                  - Change the original patch title to make it clear that it's only adding IFLA_MACSEC_OFFLOAD
                    to changelink
V1 -> V2: Add common helper to avoid duplicating code
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

