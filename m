Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E104B64572E
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 11:10:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229674AbiLGKKx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 05:10:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229572AbiLGKKw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 05:10:52 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2077.outbound.protection.outlook.com [40.107.92.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F6D340469;
        Wed,  7 Dec 2022 02:10:51 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PnWDAv7Jj4SqQD40IGAVpDSmUtih5YCavFgPV1ssuhpIN5K3n+9G3nMBy70prfSlfU8Lc9cMia65U+mBo9NbluGyDRFwA2klY2LOGjapz8Rn1QpetLcStQeVqn3vtKs7TjzMwtySr0CEd3yPjBpxTD3Z2FsGH0zuC53eJ71+YQQjJrizKMOLwWvDGutEQURurxzzNJoh+95gOVFJcbaedt7Zq9lg3VyaBb2b9azbnyLurvoohaJD3yD9polTbjdq9k+6AOw5wV8kwey5TgM+dHwM598tGoYPJ+r8Kb1ARZJ/0Cdmkx6p95T+YwXGFAuOuzd1KlS+7TOw8yNhkhJQJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rSbFa3byZr01FI7JugOz1hqgf7AcBlYtULcUImUdSr8=;
 b=UBT/fnpNcTf+vGJe0fbFEo2BtP3DI1KXnOWqLjXR2Cz0PvA0YyWqVFOmVMbpMjRTw8CYApvjDQuA2UuPZ094V0JD1iflr4X46PsM5/eJaB+AHnEcGOX8wIG0ReIY1hV4XdryjH3o7pTokww5at2M+M/P6gHCmbp/eLnMzAdXAIpPzAJvlsh4nO1O52jLPy5ZDJ/FndSbQdHB0FgrFvjXbqNvZJNWGCL1LbQVj2G6L372PxrQ5yq9gA+zcvskVWIlW0HiHITqw2wsCfYR72XAVUIAaIs49UL8nitwb1LC/w6TlvlfQgWgpM1Gi3XrOtTFnD/CycXM8GeyFzkdKrO+oQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rSbFa3byZr01FI7JugOz1hqgf7AcBlYtULcUImUdSr8=;
 b=m/UYLCTiVtn9vWjpHMDBVU5r0YLXM+F1YnnLEH9FmwqKgJtebyR9XM2Z73JQJn39GVBpnxE0wlYNrd42B6iAj9Mq1dOwe1799YFurSVRkQBuFoQ/3JHCqWv/Wi/3Olsoksyq2uAUl7X+kKmoyLvJje6pEhQX0YnUqqXfXE0Qq2IqHz5CPW3TDCn9LARAeZ/XwDOC2Vd/saLwjNWSJYAPvC/EAeNjyx2Y4Dzb9GMM1IuQaJtX/lpfYIWdiPK89eCK7D2wudEhySddqmrjeBdH8x2+LfOaPDKD8i/Cr4kTDT6PKeAB9GXdQi1/dfj/1ozNWVCnyRazqgg3kBeYrOKf9w==
Received: from BN9PR03CA0978.namprd03.prod.outlook.com (2603:10b6:408:109::23)
 by PH8PR12MB6868.namprd12.prod.outlook.com (2603:10b6:510:1cb::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Wed, 7 Dec
 2022 10:10:49 +0000
Received: from BL02EPF0000C405.namprd05.prod.outlook.com
 (2603:10b6:408:109:cafe::93) by BN9PR03CA0978.outlook.office365.com
 (2603:10b6:408:109::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14 via Frontend
 Transport; Wed, 7 Dec 2022 10:10:49 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BL02EPF0000C405.mail.protection.outlook.com (10.167.241.7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5880.8 via Frontend Transport; Wed, 7 Dec 2022 10:10:49 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Wed, 7 Dec 2022
 02:10:30 -0800
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Wed, 7 Dec 2022
 02:10:30 -0800
Received: from vdi.nvidia.com (10.127.8.9) by mail.nvidia.com (10.129.68.10)
 with Microsoft SMTP Server id 15.2.986.36 via Frontend Transport; Wed, 7 Dec
 2022 02:10:27 -0800
From:   <ehakim@nvidia.com>
To:     <linux-kernel@vger.kernel.org>
CC:     <raeds@nvidia.com>, <davem@davemloft.net>, <edumazet@google.com>,
        <kuba@kernel.org>, <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <sd@queasysnail.net>, <atenart@kernel.org>, <jiri@resnulli.us>,
        Emeel Hakim <ehakim@nvidia.com>
Subject: [PATCH net-next v3 1/2] macsec: add support for IFLA_MACSEC_OFFLOAD in macsec_changelink
Date:   Wed, 7 Dec 2022 12:10:16 +0200
Message-ID: <20221207101017.533-1-ehakim@nvidia.com>
X-Mailer: git-send-email 2.21.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF0000C405:EE_|PH8PR12MB6868:EE_
X-MS-Office365-Filtering-Correlation-Id: f2c360d6-6871-4b65-8ba7-08dad83b50c6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5uwb/RyH6XQnL6mAyJuEmZbEQ3Q8DsEruYZMo7AM6msf6gven9MFwd+EjyS+VxnFRjZ85zwPbsAZT/+/zYlCFrtPvTuAnUNNxt7NeFgSKlXk/xlnJCYhuAjKaVmoqOJFZOQmEpP9KUpmGbLQV2iaTvxXQ9B7hGhq/+VUHAK0/0CWHBdYDJu7L++WvAVeeSFhsAiu5jAhYRX7wFXrIlZTY0vPOK9k+sAWwXgp1CqF2K11tvETZtQAVnmXskjvuAnZUJS0Jz9961euvQPBtMauwJVfufFccTXvcH3VTTqbUmIJOEKZYtSIBQBxhEShWctosYCFJkox/5qwEqRbckhbDFVhRMB01J7NK7iUSlEi5I3x4nX1PTNs6AYwuoCGkga84tWMdXmvGwHwhpxPKO0iWT75G4U2Mx4xMq+8QsJHPBRlxb1mTr2nuu3dfVUUy1yzThAXpi2aSfBcA/GeS83J2qFHCXXBOTpSl3de3tM0+LtaX5CNLC1IU8jzcm4WwftIeI7JD4BbY/P7lXDBUfDUk90DIKy9zJInUXn183xmxtc3RvEKdGJojDu+b8o0MemRUXwa9bY3sPPz37DgNN45ppeSjqOcOX6gLDhoZyKNvOWkhLqmMfYU5RstWJP8a+E+eTOOscFj8x/QCg2aw4ci9efDKinLKOz23Q7AHFLPohvpeskKpgUYNLD+c7qOSMw8LYyJXq59pFFpcd+jPNKQRA==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(376002)(136003)(396003)(346002)(451199015)(40470700004)(46966006)(36840700001)(70586007)(8676002)(41300700001)(5660300002)(2876002)(8936002)(2906002)(316002)(70206006)(54906003)(4326008)(6916009)(36756003)(40480700001)(82310400005)(356005)(7636003)(86362001)(40460700003)(83380400001)(478600001)(186003)(107886003)(426003)(1076003)(47076005)(2616005)(7696005)(336012)(6666004)(36860700001)(82740400003)(26005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2022 10:10:49.4174
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f2c360d6-6871-4b65-8ba7-08dad83b50c6
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BL02EPF0000C405.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6868
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
macsec_change link.

Since the handling in macsec_changelink is similar to macsec_upd_offload,
update macsec_upd_offload to use a common helper function to avoid
duplication.

Example for setting offload for a macsec device:
    ip link set macsec0 type macsec offload mac

Reviewed-by: Raed Salem <raeds@nvidia.com>
Signed-off-by: Emeel Hakim <ehakim@nvidia.com>
---
V2 -> V3: - Split the original patch into 3 patches, the macsec_rtnl_policy related change (separate patch)
			to be sent to "net" branch as a fix.
		  - Change the original patch title to make it clear that it's only adding IFLA_MACSEC_OFFLOAD
		    to changelink
V1 -> V2: Add common helper to avoid duplicating code 

 drivers/net/macsec.c | 102 +++++++++++++++++++++++++++----------------
 1 file changed, 64 insertions(+), 38 deletions(-)

diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index d73b9d535b7a..1850a1ee4380 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -2583,16 +2583,45 @@ static bool macsec_is_configured(struct macsec_dev *macsec)
 	return false;
 }
 
+static int macsec_update_offload(struct macsec_dev *macsec, enum macsec_offload offload)
+{
+	enum macsec_offload prev_offload;
+	const struct macsec_ops *ops;
+	struct macsec_context ctx;
+	int ret = 0;
+
+	prev_offload = macsec->offload;
+
+	/* Check if the device already has rules configured: we do not support
+	 * rules migration.
+	 */
+	if (macsec_is_configured(macsec))
+		return -EBUSY;
+
+	ops = __macsec_get_ops(offload == MACSEC_OFFLOAD_OFF ? prev_offload : offload,
+			       macsec, &ctx);
+	if (!ops)
+		return -EOPNOTSUPP;
+
+	macsec->offload = offload;
+
+	ctx.secy = &macsec->secy;
+	ret = (offload == MACSEC_OFFLOAD_OFF) ? macsec_offload(ops->mdo_del_secy, &ctx) :
+		      macsec_offload(ops->mdo_add_secy, &ctx);
+
+	if (ret)
+		macsec->offload = prev_offload;
+
+	return ret;
+}
+
 static int macsec_upd_offload(struct sk_buff *skb, struct genl_info *info)
 {
 	struct nlattr *tb_offload[MACSEC_OFFLOAD_ATTR_MAX + 1];
-	enum macsec_offload offload, prev_offload;
-	int (*func)(struct macsec_context *ctx);
 	struct nlattr **attrs = info->attrs;
-	struct net_device *dev;
-	const struct macsec_ops *ops;
-	struct macsec_context ctx;
+	enum macsec_offload offload;
 	struct macsec_dev *macsec;
+	struct net_device *dev;
 	int ret;
 
 	if (!attrs[MACSEC_ATTR_IFINDEX])
@@ -2629,39 +2658,7 @@ static int macsec_upd_offload(struct sk_buff *skb, struct genl_info *info)
 
 	rtnl_lock();
 
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
+	ret = macsec_update_offload(macsec, offload);
 
 	rtnl_unlock();
 	return ret;
@@ -3803,6 +3800,29 @@ static int macsec_changelink_common(struct net_device *dev,
 	return 0;
 }
 
+static int macsec_changelink_upd_offload(struct net_device *dev, struct nlattr *data[])
+{
+	enum macsec_offload offload;
+	struct macsec_dev *macsec;
+
+	macsec = macsec_priv(dev);
+	offload = nla_get_u8(data[IFLA_MACSEC_OFFLOAD]);
+
+	if (macsec->offload == offload)
+		return 0;
+
+	/* Check if the offloading mode is supported by the underlying layers */
+	if (offload != MACSEC_OFFLOAD_OFF &&
+	    !macsec_check_offload(offload, macsec))
+		return -EOPNOTSUPP;
+
+	/* Check if the net device is busy. */
+	if (netif_running(dev))
+		return -EBUSY;
+
+	return macsec_update_offload(macsec, offload);
+}
+
 static int macsec_changelink(struct net_device *dev, struct nlattr *tb[],
 			     struct nlattr *data[],
 			     struct netlink_ext_ack *extack)
@@ -3831,6 +3851,12 @@ static int macsec_changelink(struct net_device *dev, struct nlattr *tb[],
 	if (ret)
 		goto cleanup;
 
+	if (data[IFLA_MACSEC_OFFLOAD]) {
+		ret = macsec_changelink_upd_offload(dev, data);
+		if (ret)
+			goto cleanup;
+	}
+
 	/* If h/w offloading is available, propagate to the device */
 	if (macsec_is_offloaded(macsec)) {
 		const struct macsec_ops *ops;
-- 
2.21.3

