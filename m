Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89C4C6480FF
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 11:32:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229656AbiLIKcS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 05:32:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229948AbiLIKb7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 05:31:59 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2062.outbound.protection.outlook.com [40.107.93.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 304376B9AA
        for <netdev@vger.kernel.org>; Fri,  9 Dec 2022 02:31:45 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YaymJU452ejzf14EBFOCIAqt/JQ0t9kwMmLFach7uFs7j/AjD4gM4pOOTJuk4UlDEWnp6CTv+axsjchDqMJyIcMWSjhqlPV1LSnz+8E1c2/bzcmIkJi+B/ydGiYVLNTOUr2jzZKZFgyMRAs9egm34feeDvBSYcQ5t6vUilU1hOpVOhTGJGgcpa9S85/x18zvPO4tVue+EI2A67Y+5b6zzC8b/PNLzTr+DTpIwRO6bKSu++q9iAh3VTi6wM4zN09Z4mIZO46mG7lbB4V1u4xt0ew4hRsWJsLRsSZTFImjHccY3R9xO2q/v9ufQALhcTZXXHHEuQcjyJkMe9Ym4ccQVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QfTINIV5McVF3ZOLsRJTV9oQ/NSSqshpLwjgfTry35Q=;
 b=jWIXki9T8MVvf43HQiTroamTorDql7WbC/8skr9b11INO21zFEoIRe9lrIykWwSjpbraabSAFSxP9wNP7bqWezOzVZMP5sxDcJ91lwointi8dJOZ/157+sxg3drv9yweoLhwN9QQ1n6ulr2WKYHVhYV5MY0uENxzLbu5a1G0i4JOKp6ysmub/kYdgVdtDqhtILGdmeAAXZ8q2boDRuPBTimqMm1TOg8yTT/BrC9dmIChwyqzaZjAVAwl1HsBJ0EimnCUQQBvEJQ5l+JzZ6cJ8+ZK6DdkuR0dz7nF3LSH6Wfnr/qmJRAErgCrWOe0Hc1Gg49xG0N9fsUSqkLyjwgFVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QfTINIV5McVF3ZOLsRJTV9oQ/NSSqshpLwjgfTry35Q=;
 b=T+SeP3QA1jfp2/BDrOl/jhMJ8Rge/JWPz1Vzjts4uDi3as0b73CjR/8LyEhwZjA6JPyXH7YwrNxVZ1Tf9qMIGEyIoB7zf3rL2NFSX1MiqOC/40qKRC1vtKctklHqEiBkl8ZhSi2VKcAiH2CiUKmqsuiOmwJdS1lXYcmEFert82xBIMEk58ZV1T5neT/FKxwhkGUMnUce03gZr2Kkd8+q0ZMLKQxXE+mV7UkArIkQFXGy5+PbkY52ZGpNp7xbty3JgOGshPBZjdFVbm9GTzF9kZqB6gWfcO/631jrCuC6mAbDJM8aNIrepwtXt/79p2rwx2I8CkILaPSQ77/SHt4+Xw==
Received: from DM6PR03CA0030.namprd03.prod.outlook.com (2603:10b6:5:40::43) by
 SJ0PR12MB8137.namprd12.prod.outlook.com (2603:10b6:a03:4e5::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Fri, 9 Dec
 2022 10:31:43 +0000
Received: from DS1PEPF0000E654.namprd02.prod.outlook.com
 (2603:10b6:5:40:cafe::91) by DM6PR03CA0030.outlook.office365.com
 (2603:10b6:5:40::43) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.16 via Frontend
 Transport; Fri, 9 Dec 2022 10:31:43 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DS1PEPF0000E654.mail.protection.outlook.com (10.167.18.10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5880.8 via Frontend Transport; Fri, 9 Dec 2022 10:31:43 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Fri, 9 Dec 2022
 02:31:29 -0800
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Fri, 9 Dec 2022
 02:31:29 -0800
Received: from vdi.nvidia.com (10.127.8.9) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server id 15.2.986.36 via Frontend Transport; Fri, 9 Dec
 2022 02:31:26 -0800
From:   <ehakim@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <raeds@nvidia.com>, <davem@davemloft.net>, <edumazet@google.com>,
        <kuba@kernel.org>, <pabeni@redhat.com>, <sd@queasysnail.net>,
        <atenart@kernel.org>, <jiri@resnulli.us>,
        Emeel Hakim <ehakim@nvidia.com>, Jiri Pirko <jiri@nvidia.com>
Subject: [PATCH net-next v5 1/2] macsec: add support for IFLA_MACSEC_OFFLOAD in macsec_changelink
Date:   Fri, 9 Dec 2022 12:31:08 +0200
Message-ID: <20221209103108.16858-1-ehakim@nvidia.com>
X-Mailer: git-send-email 2.21.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1PEPF0000E654:EE_|SJ0PR12MB8137:EE_
X-MS-Office365-Filtering-Correlation-Id: 6e798722-8801-44be-fe63-08dad9d090df
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cj/lUCAz8yYYngIw5yoyPPNeRbiAJAXjGTqGIpbbSUBiNXER2y63/FeZdYmuD6afdPpKU4i8dx2GhJWZiQ/K+tWUlEarHger2g8IQHOAdY+R5NK58dP+YlUVSHkpW6HuxDyxb0I0rg/W3u3Rs+rCovo0w7EFGUPoqeQz/2z72jcLP/n7cSVV9DGIemex4Z0+bNpS54SuktJ+90ki7d/J+4l46NbT6yFrn0pH14gGPWPvywUlhCmjCB0cWzT1VIVj2hYFpibncDATcr5dJnI7KnN1KYP4ijVrApb/tSRv0VpdttyOTWqsiNvqMiwkBfaNHHd7QzoTO5gs5U0fMBN2VRgPyh8mmwnze4LisQPlupH4XjFntUzQLx/7jcuVyTWWFRkRQduBi8ZKwPAHT8+LLQYo+PJpwc0SILoAhtUehBS3PGut7G0iWQMuzTjStXDlyqCGGQsLvWwk29Z+S0Q9ADxe/Shtc/ZfIfbgDmokDaolvuoRMdpDIjYoF/Nzc8kFThByOi6ttyGZCp7SBu7GpD7AeU1xCbbDnYcB52dyehKHYpjh2iQKpsOj5YL7rEGMxKr6JeHiXUTgCaQAFq0F1Tu7SGKqDxqqaHSezd2iLlC+IKCmvXRHJe3otS/FyMM1DetRpVTL2dj6/BuhX9d9+lAjvKRCZohCR1nk5Kr++mEpd4nmaDL8qySqMwegaMs2Q2Ap34d5DgjhXgCC1/7T4w==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(346002)(376002)(136003)(39860400002)(396003)(451199015)(36840700001)(46966006)(40470700004)(316002)(36756003)(8936002)(36860700001)(4326008)(86362001)(41300700001)(7636003)(2906002)(5660300002)(82740400003)(83380400001)(82310400005)(356005)(2876002)(70586007)(478600001)(70206006)(6916009)(2616005)(40480700001)(54906003)(40460700003)(8676002)(6666004)(426003)(107886003)(1076003)(336012)(186003)(47076005)(7696005)(26005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2022 10:31:43.1807
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e798722-8801-44be-fe63-08dad9d090df
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DS1PEPF0000E654.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB8137
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
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Emeel Hakim <ehakim@nvidia.com>
---
V4 -> V5: - Fail immediately if macsec ops does not exist
V3 -> V4: - Dont pass whole attributes data to macsec_update_offload, just pass relevant attribute.
                 - Fix code style.
                 - Remove macsec_changelink_upd_offload
V2 -> V3: - Split the original patch into 3 patches, the macsec_rtnl_policy related change (separate patch)
                        to be sent to "net" branch as a fix.
                  - Change the original patch title to make it clear that it's only adding IFLA_MACSEC_OFFLOAD
                    to changelink
V1 -> V2: Add common helper to avoid duplicating code

 drivers/net/macsec.c | 101 +++++++++++++++++++++++--------------------
 1 file changed, 53 insertions(+), 48 deletions(-)

diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index d73b9d535b7a..cdc7124efaf0 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -2583,38 +2583,16 @@ static bool macsec_is_configured(struct macsec_dev *macsec)
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
-	int ret;
-
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
+	int ret = 0;
 
-	dev = get_dev_from_nl(genl_info_net(info), attrs);
-	if (IS_ERR(dev))
-		return PTR_ERR(dev);
 	macsec = macsec_priv(dev);
 
-	if (!tb_offload[MACSEC_OFFLOAD_ATTR_TYPE])
-		return -EINVAL;
-
-	offload = nla_get_u8(tb_offload[MACSEC_OFFLOAD_ATTR_TYPE]);
 	if (macsec->offload == offload)
 		return 0;
 
@@ -2627,43 +2605,64 @@ static int macsec_upd_offload(struct sk_buff *skb, struct genl_info *info)
 	if (netif_running(dev))
 		return -EBUSY;
 
-	rtnl_lock();
-
-	prev_offload = macsec->offload;
-	macsec->offload = offload;
-
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
 
-rollback:
-	macsec->offload = prev_offload;
+	if (!tb_offload[MACSEC_OFFLOAD_ATTR_TYPE])
+		return -EINVAL;
+
+	offload = nla_get_u8(tb_offload[MACSEC_OFFLOAD_ATTR_TYPE]);
+
+	rtnl_lock();
+
+	ret = macsec_update_offload(dev, offload);
 
 	rtnl_unlock();
+
 	return ret;
 }
 
@@ -3831,6 +3830,12 @@ static int macsec_changelink(struct net_device *dev, struct nlattr *tb[],
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

