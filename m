Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82CA66620E2
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 10:03:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233678AbjAIJDw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 04:03:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237047AbjAIJD3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 04:03:29 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2059.outbound.protection.outlook.com [40.107.93.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9625B11A22
        for <netdev@vger.kernel.org>; Mon,  9 Jan 2023 00:56:39 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i/9/kw950i56l23i9EC61oBqMWygW3fLUppQNJbI55Mh1WGHRwCSl5J4rVc37sIGBfeqaTnXJex6wo2Ve0x7/CfcJ6ygbC5C3A/GSjw4DiX7gBtB1zti3OY2tGXsTsAUlGmLk3mpGglMyYvXSKZXJgKB1tsHCDjEgPFD8daxM9z9zVksYMAbznhRHPY94a0n5ImuGB0vdkLTPRukqz4/a4jESDM4jOp+H78Z3B0rv7q7f74no3sqwqmODH1+YeNiLaceE30K9voH8R6VZgQzWljMZnQvRWx4v+Qu2u2aoXe/H4A26HIlk+hbuTxE6HplL7Pm/f3Xolg+U7OuIAHiFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=veDAK+QCIXq8ggqULqQStu8+emtMh46WZ4CewH4Tft0=;
 b=Y+D6PHU8KIoFXtDszE2A2YJIa/3JLMyUnjVRDd+3Avl/vfT4tkTKPy0kFgtsTpsPdwwaZ3kkZhFr1G1mPpxjLT1AAAJuSOajsQ10hhOZxPhz7Cw4/YDic/9x64C9KBzpO0ciItHy/afbB1WZBXX2sxtPwtHlDVveVVTfALNcZG+XhqbdSiegnbtk9i3NHSGUuD/figWN27/SQ+miSJmXX88IQj3Y4BjdwHMci6AWFQXYzAKERKi7X13Uz77fAI0n8M/TjRLkT8cFMNk8OLtqQJD/Moy/abXEcFegsGEFJZL83wnobW7UsZTMHJGQYTBC0nCtLRVthSpQpzew1VL1qQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=veDAK+QCIXq8ggqULqQStu8+emtMh46WZ4CewH4Tft0=;
 b=dBxtFGstOM+4Lpj9r1HiGiJeYZBjb+a59+02nLCBPA34SrSp/Qsd3gHRgUSnGSRijaifssXdI0RUlt5HFPH0UNZ4fXwddcLnriprf80ivKbIcSDZTTeAmcM9PciNPwAUVo6Ki2WsM7h1jsIlKSwhIB0YiQtdKGaxv79Od+5HdmdKXix8iFU9uuG0Tiu5dkIIqk4E8zNdZOH63ZgxLacDPhAceG3O80qt7pJqJM8QRVsJe1E/yx9ZvBtRAR1YoZt0PTuw18qIzrh/GzdFO8h9jUTvhVAeCpEVgXFEB7XLsdR5w246MZU4UzC/0UGVHLLtOL1NBPBhjSQoimyCBbnjpg==
Received: from DM6PR07CA0102.namprd07.prod.outlook.com (2603:10b6:5:337::35)
 by SA1PR12MB6920.namprd12.prod.outlook.com (2603:10b6:806:258::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Mon, 9 Jan
 2023 08:56:38 +0000
Received: from DM6NAM11FT083.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:337:cafe::66) by DM6PR07CA0102.outlook.office365.com
 (2603:10b6:5:337::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18 via Frontend
 Transport; Mon, 9 Jan 2023 08:56:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DM6NAM11FT083.mail.protection.outlook.com (10.13.173.97) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5986.18 via Frontend Transport; Mon, 9 Jan 2023 08:56:37 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Mon, 9 Jan 2023
 00:56:24 -0800
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Mon, 9 Jan 2023
 00:56:24 -0800
Received: from vdi.nvidia.com (10.127.8.9) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.986.36 via Frontend Transport; Mon, 9 Jan
 2023 00:56:21 -0800
From:   <ehakim@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <raeds@nvidia.com>, <davem@davemloft.net>, <edumazet@google.com>,
        <kuba@kernel.org>, <pabeni@redhat.com>, <sd@queasysnail.net>,
        <atenart@kernel.org>, Emeel Hakim <ehakim@nvidia.com>
Subject: [PATCH net-next v7 1/2] macsec: add support for IFLA_MACSEC_OFFLOAD in macsec_changelink
Date:   Mon, 9 Jan 2023 10:55:56 +0200
Message-ID: <20230109085557.10633-2-ehakim@nvidia.com>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20230109085557.10633-1-ehakim@nvidia.com>
References: <20230109085557.10633-1-ehakim@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT083:EE_|SA1PR12MB6920:EE_
X-MS-Office365-Filtering-Correlation-Id: 560218c8-a2cf-4182-3a92-08daf21f6b00
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BF+qFLgT+N1E7gD/NLV/2W1W7poauQ5UXP+1Ng+v5mckcdgDKyp8kRcZ727w0y5yWN6IJc4mZpAIcvadB/m5oWXMV6Z3QJoZ0eIpDvdTEcdirnoXSkYTWa9hhjqD4fbJHuodKuJEfKUz7Xbhci+K2+le5A6AA2SjoUi6Tnk0F/FMR82fbp7dIoUoNYWKrc1k9qrNjBQZx1nhUb475VDVUdApZF3vndREdKfyKodF1ujNyqBbEEekscbi61i8VjjzMFQ9O3uaLkDBKuW9orw7TTDGgIbIGVHztJTT+AEh+EbiewvgJJZ0mirL9TO9MdJ5tTpDXHmbvHiGwEotu338MTT4N9KbdiqbRIgTV5zqW7yxaB2pTexsn9KqT+ZvcZScWUw++rz//wPgv4+7FJ9YPmHk8QHnMHYKnAggWF1mEzv6+FKFWIRwW75QG/D5vsl4iTiqFF3NA6SfQHjVBtuRvT9tEyq6ZJp3m59tmnkXbCDMN0t2ln7+C2Rw7U6SM7exm5U8rfXEod+x7/nMsCQsL+aHGqmTkZ7c3Svm+1HyzKsVK9YjlYmLJ+B1ubJOz5nZlm/QRHChAZKIr8RZmkJoHybsNPLVAkyK7xwE0H3rpB92s3D7Kbc5OgwQztRE+117UEnSDapIMGZ3sHKVhonHfb37GtEAQW9uRP3K/YpipNiSrhhw3/JLiDUmrNFGBA71WSmHnvzNC8xOecAHrLlK3Q==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(346002)(376002)(396003)(136003)(451199015)(36840700001)(46966006)(40470700004)(426003)(47076005)(36860700001)(83380400001)(7636003)(86362001)(2906002)(2876002)(356005)(41300700001)(82740400003)(8936002)(82310400005)(5660300002)(40460700003)(186003)(40480700001)(6666004)(107886003)(1076003)(2616005)(336012)(478600001)(26005)(8676002)(6916009)(4326008)(316002)(70206006)(7696005)(70586007)(54906003)(36756003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jan 2023 08:56:37.7869
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 560218c8-a2cf-4182-3a92-08daf21f6b00
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT083.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB6920
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

Signed-off-by: Emeel Hakim <ehakim@nvidia.com>
---
v6 -> v7: - Dont change rtnl_lock position after commit f3b4a00f0f62 ("net: macsec: fix net device access prior to holding a lock").
v5 -> v6: - Locking issue got fixed in a separate patch so rebase
V4 -> V5: - Fail immediately if macsec ops does not exist
V3 -> V4: - Dont pass whole attributes data to macsec_update_offload, just pass relevant attribute.
                 - Fix code style.
                 - Remove macsec_changelink_upd_offload
V2 -> V3: - Split the original patch into 3 patches, the macsec_rtnl_policy related change (separate patch)
                        to be sent to "net" branch as a fix.
                  - Change the original patch title to make it clear that it's only adding IFLA_MACSEC_OFFLOAD
                    to changelink
V1 -> V2: - Add common helper to avoid duplicating code
 drivers/net/macsec.c | 111 ++++++++++++++++++++++---------------------
 1 file changed, 56 insertions(+), 55 deletions(-)

diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index bf8ac7a3ded7..687d4480b7b3 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -2583,18 +2583,61 @@ static bool macsec_is_configured(struct macsec_dev *macsec)
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
 
+	macsec = macsec_priv(dev);
+
+	if (macsec->offload == offload)
+		return 0;
+
+	/* Check if the offloading mode is supported by the underlying layers */
+	if (offload != MACSEC_OFFLOAD_OFF &&
+	    !macsec_check_offload(offload, macsec)) {
+		return -EOPNOTSUPP;
+	}
+
+	/* Check if the net device is busy. */
+	if (netif_running(dev))
+		return -EBUSY;
+
+	/* Check if the device already has rules configured: we do not support
+	 * rules migration.
+	 */
+	if (macsec_is_configured(macsec))
+		return -EBUSY;
+
+	prev_offload = macsec->offload;
+
+	ops = __macsec_get_ops(offload == MACSEC_OFFLOAD_OFF ? prev_offload : offload,
+			       macsec, &ctx);
+	if (!ops)
+		return -EOPNOTSUPP;
+
+	macsec->offload = offload;
+
+	ctx.secy = &macsec->secy;
+	ret = offload == MACSEC_OFFLOAD_OFF ? macsec_offload(ops->mdo_del_secy, &ctx)
+					    : macsec_offload(ops->mdo_add_secy, &ctx);
+	if (ret)
+		macsec->offload = prev_offload;
+
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
 	if (!attrs[MACSEC_ATTR_IFINDEX])
 		return -EINVAL;
 
@@ -2613,7 +2656,6 @@ static int macsec_upd_offload(struct sk_buff *skb, struct genl_info *info)
 		ret = PTR_ERR(dev);
 		goto out;
 	}
-	macsec = macsec_priv(dev);
 
 	if (!tb_offload[MACSEC_OFFLOAD_ATTR_TYPE]) {
 		ret = -EINVAL;
@@ -2621,55 +2663,8 @@ static int macsec_upd_offload(struct sk_buff *skb, struct genl_info *info)
 	}
 
 	offload = nla_get_u8(tb_offload[MACSEC_OFFLOAD_ATTR_TYPE]);
-	if (macsec->offload == offload)
-		goto out;
 
-	/* Check if the offloading mode is supported by the underlying layers */
-	if (offload != MACSEC_OFFLOAD_OFF &&
-	    !macsec_check_offload(offload, macsec)) {
-		ret = -EOPNOTSUPP;
-		goto out;
-	}
-
-	/* Check if the net device is busy. */
-	if (netif_running(dev)) {
-		ret = -EBUSY;
-		goto out;
-	}
-
-	prev_offload = macsec->offload;
-	macsec->offload = offload;
-
-	/* Check if the device already has rules configured: we do not support
-	 * rules migration.
-	 */
-	if (macsec_is_configured(macsec)) {
-		ret = -EBUSY;
-		goto rollback;
-	}
-
-	ops = __macsec_get_ops(offload == MACSEC_OFFLOAD_OFF ? prev_offload : offload,
-			       macsec, &ctx);
-	if (!ops) {
-		ret = -EOPNOTSUPP;
-		goto rollback;
-	}
-
-	if (prev_offload == MACSEC_OFFLOAD_OFF)
-		func = ops->mdo_add_secy;
-	else
-		func = ops->mdo_del_secy;
-
-	ctx.secy = &macsec->secy;
-	ret = macsec_offload(func, &ctx);
-	if (ret)
-		goto rollback;
-
-	rtnl_unlock();
-	return 0;
-
-rollback:
-	macsec->offload = prev_offload;
+	ret = macsec_update_offload(dev, offload);
 out:
 	rtnl_unlock();
 	return ret;
@@ -3840,6 +3835,12 @@ static int macsec_changelink(struct net_device *dev, struct nlattr *tb[],
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

