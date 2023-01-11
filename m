Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 711096655C0
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 09:11:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230386AbjAKILw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 03:11:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231465AbjAKILu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 03:11:50 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2051.outbound.protection.outlook.com [40.107.220.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 667262632
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 00:11:48 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WcUtAntHnJ9te0EGk2uQMILeVrpsrvGqrko1baKmrkrzTWiEJQTi/tXewzK9TUQo//r/8I4qkz26k8AFHTNHbHVMyl4i76PvgAEea+aAdSv16PgKeb1flBbMOpkmNpmxSQrPmnIL6/SBEFhXGOpHfbi+Bd8QlGOTD00w2AkSYxtNOq6P/pY3NkTMkSdb1IXYGr4FfeB+eikrwmgR6CzHkxRPPZYA6kG6YmN8l7sPS5PoEoSmsH58okIwjFm/T6tqh6QV8MuU8RTbzfjBJvj01u+f1V3sN6jtYoyM0xEG9ahBdS0s959saTvzZk8VPOIyRwPVEWycDeIU3bKLsJo5Ug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Uuim0L6K1y1fghSHKBG5MJu4VILRU2m/6HwcHq57Ji4=;
 b=Fu+k9fqgtFCuaX/iu0HFIKobjg2lZvR7rDQOuUyZ89xzJJlRB0j1dkINuxnDMCmr+rIRRyGE5TBKwb6qwyigkgvkxc9dHDfCkt7yHN2jiQNJI96JFXELXmcvPdJVaIQY4xzEySIauf+4YvPDi4x6zh3/OkHxF/FTaYZaWzgJaIGJdOTAGDV95O5qYRiDh3UEbqHjHeaRjZtshOG8CQ1WdeTxtvhH/1c4bC82u34G8j93dTldBN/FuAmR/Jwf6QLtiERGnDRcoUmvOETKOhA7cYJq2HTVYSVF6R1ISA0MfIOJf1hwpeDDtmQ5nryuNXLFJGT3NAqsbvFYlXj+zbF75A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Uuim0L6K1y1fghSHKBG5MJu4VILRU2m/6HwcHq57Ji4=;
 b=Ty6joSdoih5XY9nqjcSIXpFCMj06Td6bCl86gKEHY56KZHz1AoSRoOaEC+41rA5L26jbRcNnh88qjQ4PTpSc16D0EcDCLQHMbhl78fQ/wWRgjbEbDZiUecMU5YGBzqStGwA0+0/3GBPUUqjfLJTC5rNmk9oyXVSNPUnVJmAIAMwMBne1EY+4uJ7kzWFLJ29Kk0ve6orJ9tRC52KjTYJnU7gWmfgTp7IJAu2cKjvdNTVr2P88JPvgikIIm3GG0rHYhFigk09krfWYK312SBnRafvfapd+2lgad4FSTet/NkCsCotDoiSKk5b6U75ffC76kZgPO9jhd9pCTx/7/9CUzA==
Received: from MW4PR04CA0375.namprd04.prod.outlook.com (2603:10b6:303:81::20)
 by BY5PR12MB4162.namprd12.prod.outlook.com (2603:10b6:a03:201::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.13; Wed, 11 Jan
 2023 08:11:45 +0000
Received: from CO1NAM11FT082.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:81:cafe::e8) by MW4PR04CA0375.outlook.office365.com
 (2603:10b6:303:81::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18 via Frontend
 Transport; Wed, 11 Jan 2023 08:11:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CO1NAM11FT082.mail.protection.outlook.com (10.13.175.224) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5986.18 via Frontend Transport; Wed, 11 Jan 2023 08:11:45 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Wed, 11 Jan
 2023 00:11:37 -0800
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Wed, 11 Jan
 2023 00:11:37 -0800
Received: from vdi.nvidia.com (10.127.8.9) by mail.nvidia.com (10.129.68.10)
 with Microsoft SMTP Server id 15.2.986.36 via Frontend Transport; Wed, 11 Jan
 2023 00:11:34 -0800
From:   <ehakim@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <raeds@nvidia.com>, <davem@davemloft.net>, <edumazet@google.com>,
        <kuba@kernel.org>, <pabeni@redhat.com>, <sd@queasysnail.net>,
        <atenart@kernel.org>, Emeel Hakim <ehakim@nvidia.com>
Subject: [PATCH net-next v8 1/2] macsec: add support for IFLA_MACSEC_OFFLOAD in macsec_changelink
Date:   Wed, 11 Jan 2023 10:11:11 +0200
Message-ID: <20230111081112.21067-2-ehakim@nvidia.com>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20230111081112.21067-1-ehakim@nvidia.com>
References: <20230111081112.21067-1-ehakim@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT082:EE_|BY5PR12MB4162:EE_
X-MS-Office365-Filtering-Correlation-Id: f2d3db41-4964-4caa-f71d-08daf3ab7ae0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BTakudEJJNWo7986WUKxC7M8Ovy5dKagZMaP/tUfzNFYnG87RTvdPUSR9jN8mlJ5j7uRr/El2I2ZcCtMYPCQKCeY1TSFPfGnX5h8WbbIPixIYm4SJU6+wceNLiCDbH3eK35jFTtp0gPzjASK8o8dHaJbQzNd1Ayti2uDCy229uzH/9t8mhEOCBATqf/fywBlw7OX/V9nnTUB7X74+vh06b+bcHQt+spqPVXnffjcXrjOplkkCijPmbuSoeDKzSuFBoBp3js1q0sgb/3GEGO1AIO4tF/DpdP7N+52RAX9V646grs1UU4l6TqoDI87vz6KCuVo2/f6SX00S7zAWurFQBVXeApGorm8blq/sX9zkjJCX8hMg20yNJ8V5JoSwczFoI0HF1YhvnXA1dLy3BPfKVUO52YHmBotMvJQQ4y/QVDXeibQV7Txm/gvuSpp8C/OD0lZPsC8OEHkMMKe6IStswaOMmLtsgsMspUV19koI0GHRUoyus2NfHqEQ3iP2DiNkAYO44bSBfcX0KNoKgRpjfZuLbrJZgs4Xu7wS8X0or59r1UnMnjapr3e7e42KoSeIQ0uu0VNOHc6vfxrnQ+MDODvea6plw1ntpPzjrDm/iaRt1OBhrfS3vpbAKTF002YPNbGSKFSa/2sp9QBwlR9Dsdc/xzNEivtgbQkfrslgqb+xrYq8ZDLrh9teCMefeo2kVvvNq+FsTT8n1YhEEQ/hw==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(396003)(136003)(346002)(39860400002)(376002)(451199015)(46966006)(40470700004)(36840700001)(6666004)(107886003)(36860700001)(2906002)(6916009)(8676002)(36756003)(5660300002)(8936002)(2876002)(83380400001)(4326008)(82740400003)(356005)(7636003)(41300700001)(47076005)(478600001)(426003)(336012)(186003)(26005)(82310400005)(70586007)(70206006)(40480700001)(7696005)(1076003)(86362001)(40460700003)(316002)(2616005)(54906003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jan 2023 08:11:45.2086
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f2d3db41-4964-4caa-f71d-08daf3ab7ae0
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT082.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4162
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

Signed-off-by: Emeel Hakim <ehakim@nvidia.com>
---
v7 -> v8: - Dont call mdo_upd_secy when mdo_add_secy has been just called.
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
 drivers/net/macsec.c | 116 +++++++++++++++++++++++--------------------
 1 file changed, 61 insertions(+), 55 deletions(-)

diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index bf8ac7a3ded7..31f8627d6a1d 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -2583,18 +2583,59 @@ static bool macsec_is_configured(struct macsec_dev *macsec)
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
+	struct macsec_dev *macsec;
+	struct net_device *dev;
+	int ret;
+
 	if (!attrs[MACSEC_ATTR_IFINDEX])
 		return -EINVAL;
 
@@ -2621,55 +2662,9 @@ static int macsec_upd_offload(struct sk_buff *skb, struct genl_info *info)
 	}
 
 	offload = nla_get_u8(tb_offload[MACSEC_OFFLOAD_ATTR_TYPE]);
-	if (macsec->offload == offload)
-		goto out;
-
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
+	if (macsec->offload != offload)
+		ret = macsec_update_offload(dev, offload);
 out:
 	rtnl_unlock();
 	return ret;
@@ -3817,6 +3812,8 @@ static int macsec_changelink(struct net_device *dev, struct nlattr *tb[],
 			     struct netlink_ext_ack *extack)
 {
 	struct macsec_dev *macsec = macsec_priv(dev);
+	bool macsec_offload_state_change = false;
+	enum macsec_offload offload;
 	struct macsec_tx_sc tx_sc;
 	struct macsec_secy secy;
 	int ret;
@@ -3840,8 +3837,17 @@ static int macsec_changelink(struct net_device *dev, struct nlattr *tb[],
 	if (ret)
 		goto cleanup;
 
+	if (data[IFLA_MACSEC_OFFLOAD]) {
+		offload = nla_get_u8(data[IFLA_MACSEC_OFFLOAD]);
+		if (macsec->offload != offload) {
+			macsec_offload_state_change = true;
+			ret = macsec_update_offload(dev, offload);
+			if (ret)
+				goto cleanup;
+		}
+	}
 	/* If h/w offloading is available, propagate to the device */
-	if (macsec_is_offloaded(macsec)) {
+	if (!macsec_offload_state_change && macsec_is_offloaded(macsec)) {
 		const struct macsec_ops *ops;
 		struct macsec_context ctx;
 
-- 
2.21.3

