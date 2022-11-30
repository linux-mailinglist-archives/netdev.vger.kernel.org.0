Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFF6563D504
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 12:53:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234857AbiK3Lxj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 06:53:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235050AbiK3LxJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 06:53:09 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on20610.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e89::610])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4293D4384F
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 03:52:55 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TnW6RJ+ZGtfORZSPHykJbnhhL1JsuTBSg8gRe1+LBACP9dZf3t5xDS/9EXVfziaS7cfKM2jvLO6B/G1/x+7P4akL+NftTepRmjbweeubAjxRHlf/L3uYZxJnI8BcROippm8H8YVCMGi1Mz5D0dgO9n0pxEkX8gX2T2mTZn2fqWmBpcME5jXUwadgtcBchSUIeu/HqzrMG/mPOQYfVS4HEzAomutwVhCHaV2r0p53Es5BBz0azTWjAWexD2Imyfoxg0sUrOmSiUSh1e3x41etRor8aSAcgj43UHSa+tzewbatXJnHT3mfKsxD7LRLLXFZBemZ2ZHMPGg+XX7iRURuxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+8tnz/fAIpB6X4FwfAExW1GLX/Kd3rHDtlo5rFKlJ40=;
 b=X/tlbAeqboYqVJPgF1UrMDd1aJaEPhqt8H3DsVxv2QZzrgTHnuCVcc8D05eLf3H/hrk893nYvD2P7rOUQEGJR79TUb43t/j01NLjiiHtpqnZJ7STdKWCcgU6o5pJIHwNX8YhJ8BuW66GU67sRCnOG9SLiNlU79rkzbyH1IyBFGDIN4AqJy1WqyktgSo1JjKq31UHFbLN5wvEe751HpTyHyTEtQQl+NhAyA26YAco1fzOu6yAfFbw1gQ4F8mBH1X2eFU+PcbrFpLZ2tYCo9VRAD1FCgpWEC9Eqf7FF67VMHaaMcG3mgQvN0qAVyH/ZDqxx582nmJUmiepo0sZsrO2ew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+8tnz/fAIpB6X4FwfAExW1GLX/Kd3rHDtlo5rFKlJ40=;
 b=gY71+n50ebDdbaBin7YJCobU4+fD9zI4aTvXYZxM8ITWY7+ycp93QQHJvuB7YeNZWKByXrgFTRd7GAbZqOjcmGPdgRdT2Rm5NWE7sDWkPkXBDZ1NtaTK8GKzfdX245X05Wqy9TLn9LZ5jC4RQgbHzLCEUwx6+ZAO/pOX7CtzcB8v1aggdXhqfbFsHKS5RBOuKsPmjBVAqEnOd+u9xmew2Kx+hrExr8Ys/uyZ8fWXgmyRFhCb/7dIsijRWxbY3OJ7eA0bA7ufLG0EIK7oxgDAVsZgsY5RaAvgr5xvWrLMr9g+NsyNHi8qI3Yz/jMMMC+CghfafWZdpkp6jZgBN8q0aA==
Received: from BN1PR13CA0015.namprd13.prod.outlook.com (2603:10b6:408:e2::20)
 by MN0PR12MB5979.namprd12.prod.outlook.com (2603:10b6:208:37e::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Wed, 30 Nov
 2022 11:52:51 +0000
Received: from BN8NAM11FT106.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:e2:cafe::81) by BN1PR13CA0015.outlook.office365.com
 (2603:10b6:408:e2::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.8 via Frontend
 Transport; Wed, 30 Nov 2022 11:52:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN8NAM11FT106.mail.protection.outlook.com (10.13.177.7) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5857.22 via Frontend Transport; Wed, 30 Nov 2022 11:52:50 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Wed, 30 Nov
 2022 03:52:40 -0800
Received: from nps-server-23.mtl.labs.mlnx (10.126.231.35) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Wed, 30 Nov 2022 03:52:36 -0800
From:   Shay Drory <shayd@nvidia.com>
To:     <netdev@vger.kernel.org>, <kuba@kernel.org>, <davem@davemloft.net>
CC:     <danielj@nvidia.com>, <yishaih@nvidia.com>, <jiri@nvidia.com>,
        <saeedm@nvidia.com>, <parav@nvidia.com>
Subject: [PATCH net-next 2/8] devlink: Validate port function request
Date:   Wed, 30 Nov 2022 13:52:11 +0200
Message-ID: <20221130115217.7171-3-shayd@nvidia.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130115217.7171-1-shayd@nvidia.com>
References: <20221130115217.7171-1-shayd@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT106:EE_|MN0PR12MB5979:EE_
X-MS-Office365-Filtering-Correlation-Id: 227d07c0-3560-461c-7795-08dad2c96872
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LJLF6ADR1fotEIfV3Yhv/qQSAn4HoNrlMDy3tgZEv2objYvyh//O6mu+IpykOQm+KtXxuJ/XctOQcZIwNiFK3GmDmpREN29Qxc0ojTJO/OcXi5b7gSVNh5OgNHKtwjnflwnyr4N6V7T9/fRrE3weG6+uq4uRn6kWLg6tvugERVIpVlR+q2S7M/SMmdcGDJ+V8GuwDcpPP4ydb0pTDGrzXAS982m7YqX3/yET3ieGhfMyR4Lk+yxq0xBemvT3yMky/JHrzk75mGejwd6pHSheB0kSyr7zieZe9TdBBGl6pAIpXEEe5AGEcc6AuMwZf83w5XP3/kRChvx2N05RNTgmuGZesHdLFTAH2IcNEahs+YFnlQVMxWpeoghvWUNKBuqX96fkmMsJPQtx+xxmT6r88R1wsclqw725JoR+zgffvsdGDQNqgNFcj36/KK78ngB8U0pDkI7VUsHtxWDvk2TsX/codR5Sl+5ItdQ1JhoAMLExjf6wsKXT3IwdYfXkM1waXMWiHKwuUB0HoQ7ul9joGplUCEy/kaQsngjAv2KwltynnnaQKSzsa6/8QULc/anKMHL/hSZzOWaJ2X2zYSDj3ZJNt2bzZ2ek10CKzM4huO44DXwVXgt1VCYY9e/GFiag8ZkpMVCQL8uhHnbfufMLjIFIS7rahbN93TnQhu747cF6BkiydljYqaOWYM3kjnW7vzM90n/2qhXAsWEou9dk4w==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(396003)(39860400002)(136003)(346002)(376002)(451199015)(46966006)(40470700004)(36840700001)(186003)(1076003)(2616005)(107886003)(336012)(426003)(36860700001)(47076005)(16526019)(5660300002)(6666004)(41300700001)(36756003)(82310400005)(70206006)(86362001)(26005)(8676002)(82740400003)(8936002)(478600001)(4326008)(40480700001)(54906003)(83380400001)(70586007)(2906002)(40460700003)(316002)(356005)(7636003)(15650500001)(110136005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Nov 2022 11:52:50.6907
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 227d07c0-3560-461c-7795-08dad2c96872
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT106.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5979
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In order to avoid partial request processing, validate the request
before processing it.

Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
 net/core/devlink.c | 27 ++++++++++++++++++++-------
 1 file changed, 20 insertions(+), 7 deletions(-)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index cea154ddce7a..485348697290 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -1644,11 +1644,6 @@ static int devlink_port_function_hw_addr_set(struct devlink_port *port,
 		}
 	}
 
-	if (!ops->port_function_hw_addr_set) {
-		NL_SET_ERR_MSG_MOD(extack, "Port doesn't support function attributes");
-		return -EOPNOTSUPP;
-	}
-
 	return ops->port_function_hw_addr_set(port, hw_addr, hw_addr_len,
 					      extack);
 }
@@ -1662,12 +1657,26 @@ static int devlink_port_fn_state_set(struct devlink_port *port,
 
 	state = nla_get_u8(attr);
 	ops = port->devlink->ops;
-	if (!ops->port_fn_state_set) {
+	return ops->port_fn_state_set(port, state, extack);
+}
+
+static int devlink_port_function_validate(struct devlink_port *devlink_port,
+					  struct nlattr **tb,
+					  struct netlink_ext_ack *extack)
+{
+	const struct devlink_ops *ops = devlink_port->devlink->ops;
+
+	if (tb[DEVLINK_PORT_FUNCTION_ATTR_HW_ADDR] &&
+	    !ops->port_function_hw_addr_set) {
+		NL_SET_ERR_MSG_MOD(extack, "Port doesn't support function attributes");
+		return -EOPNOTSUPP;
+	}
+	if (tb[DEVLINK_PORT_FN_ATTR_STATE] && !ops->port_fn_state_set) {
 		NL_SET_ERR_MSG_MOD(extack,
 				   "Function does not support state setting");
 		return -EOPNOTSUPP;
 	}
-	return ops->port_fn_state_set(port, state, extack);
+	return 0;
 }
 
 static int devlink_port_function_set(struct devlink_port *port,
@@ -1684,6 +1693,10 @@ static int devlink_port_function_set(struct devlink_port *port,
 		return err;
 	}
 
+	err = devlink_port_function_validate(port, tb, extack);
+	if (err)
+		return err;
+
 	attr = tb[DEVLINK_PORT_FUNCTION_ATTR_HW_ADDR];
 	if (attr) {
 		err = devlink_port_function_hw_addr_set(port, attr, extack);
-- 
2.38.1

