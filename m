Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DAC064021A
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 09:30:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232846AbiLBIaJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 03:30:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231775AbiLBI3Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 03:29:16 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2063.outbound.protection.outlook.com [40.107.94.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C26D6AD309
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 00:26:54 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RqfgSbuGuj0EPSzYxJhjHxr3JFgr1LcG72TJ7UXKnzqSI6FiMTPkWDZ0VQ25jfuBg0WbUtL782x/469RgifBGlgvTB7k1kNwDSkoi7ZGGc81wH3t5RacjcqdFTYJzzX8X2k47j0+pYs7tJTQslzM7U3IIPgNdTVld8TrGAABTCt6enR0jjaf+iciaTxIB+AZ75RVnUcdcy54j1l4RKY15vVoJtQqXxXTfmchp2W3Ue75C+jeDEgxo/P4lqIegBGr7wT+i63Qf+aPLimBXy18olRKKocIV2b1+RDVx7bXSRmJMXauRjrdYKzs46phaJkxld8HMXM5HNDecCh6Kn7L6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iuROjBwmMaxRRY9kR3q8lk9vS9JAf0cwOL+3YeWtNz0=;
 b=BpYIujWqavb+KyntxmlTro2EBdvZ8uxMrO4VzCgpFnDneMrspbZcwRunjIH476aFeVxEjiQHynN+9kHyZYg0ZNqvzg6+AIxnilfXrMODtIbHbuUCB1mPAWmpLGxV+UwtG9hI/GOd+AqRoyvLBDqXu4V21+63x0swZT95qG7+wB0F9mzW4V10pQI5qg6kzBXWjdkmWa243XzG15p3PUeSC/CeDxeXbADBDvnbT5BMvjiR0U0955/hv9N1L9BULmlazg/pW6iGKkNpOkatNlFzluPPELmhgOpocR/D86dsJu2tZi77KzpbvN1oF2J5PLAtc0TRVH757BsbCSrHCdBL1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iuROjBwmMaxRRY9kR3q8lk9vS9JAf0cwOL+3YeWtNz0=;
 b=qs9CLesiH/zYyByspuj3NLmiTbb5N7hxg2/yMWT111w82gB3w5fV4hsEBwbuvWOB5ALw3AZpiDfWJEXz1ODe54RZTuc+HzCWbOuUbM3/JUmhW4nICsEAL7WDuks/rPT5OWBc3XnwEXwlRdjZ0kc2TtNYi0w+e0lba7jxqTqZYtyZA112fid2VzuL6g+vy94PpGnLGlf0U9D7dGUZOOpPNVjRs8SIjhyVLi/o27+AyBTyfKC/27vyeiJCbu4mq4s3iixf28J4YsiIeSSw/SyB+UW3pz4Br2FS3hvB/rCmrxWjqIq1d8f6rqZd68ahTzadubt7+eDhHcwZvI9ZhnYSaQ==
Received: from MW4PR03CA0144.namprd03.prod.outlook.com (2603:10b6:303:8c::29)
 by SN7PR12MB8172.namprd12.prod.outlook.com (2603:10b6:806:352::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.10; Fri, 2 Dec
 2022 08:26:51 +0000
Received: from CO1NAM11FT087.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8c:cafe::c) by MW4PR03CA0144.outlook.office365.com
 (2603:10b6:303:8c::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.8 via Frontend
 Transport; Fri, 2 Dec 2022 08:26:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CO1NAM11FT087.mail.protection.outlook.com (10.13.174.68) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5880.8 via Frontend Transport; Fri, 2 Dec 2022 08:26:51 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Fri, 2 Dec 2022
 00:26:39 -0800
Received: from nps-server-23.mtl.labs.mlnx (10.126.231.35) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Fri, 2 Dec 2022 00:26:36 -0800
From:   Shay Drory <shayd@nvidia.com>
To:     <netdev@vger.kernel.org>, <kuba@kernel.org>, <davem@davemloft.net>
CC:     <danielj@nvidia.com>, <yishaih@nvidia.com>, <jiri@nvidia.com>,
        <saeedm@nvidia.com>, <parav@nvidia.com>
Subject: [PATCH net-next V2 2/8] devlink: Validate port function request
Date:   Fri, 2 Dec 2022 10:26:16 +0200
Message-ID: <20221202082622.57765-3-shayd@nvidia.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221202082622.57765-1-shayd@nvidia.com>
References: <20221202082622.57765-1-shayd@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT087:EE_|SN7PR12MB8172:EE_
X-MS-Office365-Filtering-Correlation-Id: 234fc17a-b48d-4c97-46f5-08dad43ef677
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: U8A0pbgH9OFX0xmyVsRFVODk+fKjMVulqSzez+i4DH/pGHkCxovdKUCMTxc4vSBiV89HrrlBIUOSADYwpAt1meXVWHcLG6SwOpeddd6Wiw1mtR69MW/ZVL2vEgvFKwxlBStzYMETAumap2M/gkDGScQTm68d/T6Nn1jW6z4cm8rY+TISll/WQCHSmhqGuGClqAx8OLnrO9oK74s5Qho+XqoYxr18L209K3x2aft6LAl+jJAnvTMuTBb0+xdVcEGc6RPSaQwBPcHBJZJz3LOBbvbvBpPx9IBeczTZmcYAG70iVmuZoW0GFenjPHTDW9CmystI55/CSKlSA/CtgpezbgtIwspYpDZLRZ/ncLwxqfydIGf15J2M/O9gECd+UEPdDNdvDqppo3z+Pg5lshRqDz8Q8o11tK/6Ph7b0sasaTVsj2mVwYInWSM0Yb86B/UtXP8dJDxedn69B68BYT/s1mNdtp3aLr8UE8MWGekao16dWJlDxLfXR7B0L+eSGyovnNIKX70M2Ta3BzvwSmSsdxV1+RfA+t9y63gnnIFxgQF+6rHQm1Kh7OiT+2fWratS25KhkuGx+TrWIKzFtvZwZR4Nt3HPlosHeLxmDyr8kVuoglP0CKtljxAQXgjQIgKLsaDpa7/iR9ZIW2nDsk2lTOFIdkrxlCzHXEWzzKeSeBUlfv8iWHfQIrccGM7/xvgVKSfqMn11CAEVxofW/zbVlg==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(376002)(346002)(39860400002)(396003)(136003)(451199015)(40470700004)(46966006)(36840700001)(36756003)(82310400005)(8676002)(70586007)(70206006)(186003)(426003)(336012)(41300700001)(4326008)(5660300002)(1076003)(2616005)(82740400003)(16526019)(47076005)(8936002)(54906003)(110136005)(316002)(15650500001)(2906002)(40480700001)(26005)(6666004)(356005)(7636003)(107886003)(36860700001)(83380400001)(478600001)(86362001)(40460700003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Dec 2022 08:26:51.3013
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 234fc17a-b48d-4c97-46f5-08dad43ef677
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT087.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB8172
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
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
index fca3ebee97b0..70614dc90f9c 100644
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

