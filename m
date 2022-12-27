Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98BDF656862
	for <lists+netdev@lfdr.de>; Tue, 27 Dec 2022 09:26:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229728AbiL0I0L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Dec 2022 03:26:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229632AbiL0I0I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Dec 2022 03:26:08 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2056.outbound.protection.outlook.com [40.107.92.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 997B5263D
        for <netdev@vger.kernel.org>; Tue, 27 Dec 2022 00:26:03 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YZEYK891Zx8yyf25vnJBsvLYePRALzAu75mLQLFTAwF879nAW77BgLqBUkaWC5Yq0dz3BsSl2YOYKtHLgSskB4fW7KNnJAfn99Zakmyi82mNddEExGFrJ7j4dzYQmCgxNmrVlSOTuoGaRRAWKBVvyhrT1EwOaIu2qODnnK47FC86UC8NAvDb4gZzRUwgoYcjdl6sKlpCn2GGSL4uDUCXA4b938nYdKtfE1C3GknCbV2nY89jkrx7sNzLI0P48qGY61xPMso0XFPQVLj6H6Qk4qZcwUZA/aw4FQw6JgC+CLmXTWZWaywpmyDEILTaCIXOMXdBWxMrNak6rUwlMCfStg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eoIwdymIKGWSwHSbp2RxIzxTyBefDh4zTuW6ThAMO+8=;
 b=aIWGJiLpdSKSmmJLopsmgDTHPADoGpIVG2UGparAdGHVP5HZWxAHcw7k4jfwTtz8NVtkR8wE/Fk6JI5LLRrIZldy3rEh3dkxFdIuuBpZzR3urlgB8YFrdyak0w+AH1rUeFxABZlv02RA2cn+29iaBGoJ8cSX35aIMPy80GAUMuVjxPtSDbjqh0Ot98g6ed0qqth8Mo5NljLekHjPRbTQgRHhaSD1hGgfL8BDxQ7cYNCBEGQq2WMbXfghNNVFlI4rsMqbdlX0xDJja6iEwxC6cT8p3VN0y+qVX0DK5KVB3MZuYNQ3EyTho/HdSFnnd23JP8kaLPx8qcnhR4gAx8824g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eoIwdymIKGWSwHSbp2RxIzxTyBefDh4zTuW6ThAMO+8=;
 b=kHlUAxLf674N3zwXYCu7IN68nZ39nhgCb/wS3kvsI4GHxtLZ6vwuESsMvaG8kMdeY2XQfMFMT4laDAhn0WfN1YIdX7E2SOyTQFIgVn0mFaNRarj9WoKE2TiMDKtYo0R+STQaYofMaslscx+dg02p5rwroMjP+gV9BOQg2h6b86n9nmVNfiIaWYG4h29Uml4U/UWAOA1v8FeOvPo/0imSoksLMohQj7uL6l4e9fk0iytXgWZfNK95doiYgUnQR3XmoQ1rcHwUgS1RNetlidEYHmyOcRwgIuQnIAsM4phiw2MdqIsRdhw3je9RIfzxW8TJsTwqYyjRks6WJ9T0JgjA+A==
Received: from BN0PR08CA0012.namprd08.prod.outlook.com (2603:10b6:408:142::34)
 by CH0PR12MB8531.namprd12.prod.outlook.com (2603:10b6:610:181::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.16; Tue, 27 Dec
 2022 08:26:01 +0000
Received: from BN8NAM11FT038.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:142:cafe::ed) by BN0PR08CA0012.outlook.office365.com
 (2603:10b6:408:142::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.17 via Frontend
 Transport; Tue, 27 Dec 2022 08:26:01 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN8NAM11FT038.mail.protection.outlook.com (10.13.176.246) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5944.17 via Frontend Transport; Tue, 27 Dec 2022 08:26:01 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Tue, 27 Dec
 2022 00:25:38 -0800
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Tue, 27 Dec
 2022 00:25:38 -0800
Received: from vdi.nvidia.com (10.127.8.9) by mail.nvidia.com (10.129.68.9)
 with Microsoft SMTP Server id 15.2.986.36 via Frontend Transport; Tue, 27 Dec
 2022 00:25:35 -0800
From:   <ehakim@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <raeds@nvidia.com>, <davem@davemloft.net>, <edumazet@google.com>,
        <kuba@kernel.org>, <pabeni@redhat.com>, <sd@queasysnail.net>,
        <atenart@kernel.org>, Emeel Hakim <ehakim@nvidia.com>
Subject: [PATCH net-next 1/2] macsec: add support for IFLA_MACSEC_OFFLOAD in macsec_changelink
Date:   Tue, 27 Dec 2022 10:25:16 +0200
Message-ID: <20221227082517.8675-1-ehakim@nvidia.com>
X-Mailer: git-send-email 2.21.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT038:EE_|CH0PR12MB8531:EE_
X-MS-Office365-Filtering-Correlation-Id: 7fd15b87-589b-4127-8129-08dae7e3fcdd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: a5vj+7Tgcxc53Ybmdz9sgU+gKIKKuUMFyEFTSE6cVAksjPw1tegzC8y2PlFjoFQepsh76AcFgupgsncCTxbLRcRH+E8/tjjeWrz01MivVs/vd/Tjg5nqCfS98Ng4abSp6GskJsobu6WVlZHZduQWN6B9pLf7OdspteTj49GIGeB61QVExXihLOA30RhbCT3d4JarZ09H7hXcMR4HKQ6JmvTTw8pey6yWxUAZIcS6Wo2Gw1Kosf4rfCAi3P9Vzik6TY7GQLQzOdh3OSmfxqE1MBdDNHDDJTJXsgrqO2N6357pZ56e5NkWzmlLWvdHcytQe0YalmFDMp78VleGb9DBxoEfVOSSGQHwgTU+bTLfbk6Nv6zfu/Q0Oj+W6KCTaqyDvzJOHwacUerP/VgT/QC90u5uYOQZ8KmR1+66+6ik3datlzM3M+SeY1GQoDvjmEka96N76X2MT8m6Vu1QbTuThsNgKTpAP5TtdtaMnHmSYOAMaUQEojJ3249n1PRYpy3OWwqzKC56gKMUYwfTTRtZl28oUcSVx5BXIB5zTuLf1YB01Dmn77VzGfFIzic08IOy4BYrN2HC9QOKluj3CQeOTg70TteT9A869iXaCfX6KkwmD/zo75oFlCo3S2zseIerwFe6UctZbq+Fgwoapyi/+u4h9baRzrljaM9Sa+PuC95KSvqHyRLqyfm/xlz7Y8hg6g0x3vBXIFbDRlfHwH2WMw==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(376002)(396003)(346002)(136003)(39860400002)(451199015)(46966006)(40470700004)(36840700001)(2906002)(2876002)(8936002)(70586007)(8676002)(70206006)(41300700001)(4326008)(6916009)(54906003)(316002)(107886003)(6666004)(26005)(478600001)(82310400005)(356005)(7696005)(40480700001)(2616005)(1076003)(426003)(36756003)(336012)(83380400001)(47076005)(7636003)(5660300002)(82740400003)(186003)(40460700003)(86362001)(36860700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Dec 2022 08:26:01.0282
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7fd15b87-589b-4127-8129-08dae7e3fcdd
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT038.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB8531
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
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

