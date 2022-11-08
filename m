Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 566EA620DB7
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 11:49:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233577AbiKHKti (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 05:49:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233990AbiKHKst (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 05:48:49 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2062d.outbound.protection.outlook.com [IPv6:2a01:111:f400:7eab::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EC6D1AF1F
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 02:48:38 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BZPFKaJuvuJrL1eXI+k5yLFtgFTkMNah8lhgxJodOG9sPNbVGrf9UDw9G4HObFMnpgggUaen6fvXO3JADtg11M5UvlmorV33PK6knE+OrbxgVO4vHe/qx6AxrcJlY6tH10/48QQT/2CVUrrco1+dyWwtGCoMFIv7Mf4gObf9jsYs1rclmPaM19wazXJcyi9U0WEXdU60MHCNOLGjXoXES8c+EQEqoHCZ3VOIXHn0BhHK8394J1z22StRiSadXWydOKlJsMRtfLC0CJzXHzoKJjVENCAky8aI1PrrRwLLky0lr3HvSt5SZ+tPKr/SuDD6+1X2MSpteje9wFN1Js+dew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ya4tW0j0iTCUe/pMNIiYlbMX2deTzFP2fjC285Q6y6A=;
 b=Jqj35WCc4M7dVKbeJ33I6OMmY96TIJH27U21CjvCgdYm2TU+qJhoBpItVacpyPMIAu+CRgVs46K17AUTFnHmH+Z6UKNrPwnminPboyvOQo2o9T+dN5pZqnZbS8t3nwAioqZ5/Qxue09ZrCENmqaBe6WVCGnxq4pT4CQu0LVPeCzLOWFm9LpKcTBW8rk1jwiMVh0C4u3A0egxcFtmxrGI0usC6GbXIkhIv0xWlzu3rKcThT1SIy1KhwN3Kq1kQ3CbtSzXxvWhlpbKMGK8RYBAnrGp1IQLaxGIZqlWlmIFb+GVYf8PLS8k4n6TPl/Y3PUyVosGkmvmyuAGqQvPcPspBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ya4tW0j0iTCUe/pMNIiYlbMX2deTzFP2fjC285Q6y6A=;
 b=W2+vx2lqQ9e/3TW3R3jdSdCIDXxqiHuvyJVX31mySw+RrBJPWkXSP2DMPofvNps7HCYECVNE9JziWo8vaWHHvID7NQz3nuP8TFpbswNHN9TSf95DZ3tcQ/+cjKyj6QEESqno1lRbvhvibqQGnwAnyaLHlF0wgBkPd2L2ZRcuWRaes8aErS8pBpc0bUZiOx7n0lWiaP2ZVv2GvvguNVHtUcYDKo59BRMRE1UjkwucfeIoxk5u/+EcDaC2SaAqAKRQya2Btynyk0H1t2yi9kdnc+Hj/YmPgMuqOF/npvxpWV2fStPewsj+nKu2UdagUdn+ujfEx1yzzsGIBRJlZPY8Tw==
Received: from BN0PR03CA0027.namprd03.prod.outlook.com (2603:10b6:408:e6::32)
 by BN9PR12MB5340.namprd12.prod.outlook.com (2603:10b6:408:105::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.27; Tue, 8 Nov
 2022 10:48:34 +0000
Received: from BN8NAM11FT097.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:e6:cafe::71) by BN0PR03CA0027.outlook.office365.com
 (2603:10b6:408:e6::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.27 via Frontend
 Transport; Tue, 8 Nov 2022 10:48:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN8NAM11FT097.mail.protection.outlook.com (10.13.176.147) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5791.20 via Frontend Transport; Tue, 8 Nov 2022 10:48:33 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Tue, 8 Nov 2022
 02:48:18 -0800
Received: from yaviefel.vdiclient.nvidia.com (10.126.230.35) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.29; Tue, 8 Nov 2022 02:48:15 -0800
From:   Petr Machata <petrm@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Ivan Vecera <ivecera@redhat.com>, <netdev@vger.kernel.org>
CC:     Nikolay Aleksandrov <razor@blackwall.org>,
        Roopa Prabhu <roopa@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Petr Machata <petrm@nvidia.com>,
        <bridge@lists.linux-foundation.org>,
        Ido Schimmel <idosch@nvidia.com>,
        "Hans J . Schultz" <netdev@kapio-technology.com>,
        <mlxsw@nvidia.com>
Subject: [PATCH net-next 11/15] mlxsw: spectrum_switchdev: Add locked bridge port support
Date:   Tue, 8 Nov 2022 11:47:17 +0100
Message-ID: <f433543efdb610ef5a6aba9ac52b4783ff137a13.1667902754.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <cover.1667902754.git.petrm@nvidia.com>
References: <cover.1667902754.git.petrm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT097:EE_|BN9PR12MB5340:EE_
X-MS-Office365-Filtering-Correlation-Id: 3375c7e5-c92a-4d08-4033-08dac176c883
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ySeSXLIPyj960g4Qlh5YKkl1456UwkHamJsPRtit6HswW6o2wznq13lvt//cFH7wMAf3Nuuth8BjvoAaROTc3alTesZPj7iaypEMrBqxQZPbKNEGCbpZS4+0cqNO6n5o2ZadqmkcEZYFKBeaLXXh91o/M/1beB45uIvyAmJaSYFs9viuuvSlC3dhZk5AwpIRIhjHsxs5vNDf0lXdZ5OIEF1r9zurgBiQg9cylWdx309RpiQ/MAtDNhFrdT9fhbpmtkRPWtWJ40xLr8DlY524rnppsImeOna2tl3PtBr0yVwag7xj9Vr0hOD5gD/LDFEJxdm+EOQF1Gb1PhWwEsZ1plwGdzoEQKPZmE7kDIv7ECQRpwvY372IErLXBLW0CTaDnTEF0utwyEAQPeDJZPha2jnarWN/Ksucf+7lN7QK/TVD/28+kmRtIZjrzA5Fr3VM5dYbeXXWhD5dqPS4vD5LDXCrdOV/jN8AxmlTYbcHrGqIZBmsPFOOKa5Up4SXeQY97CKzf+NvNxKoQ11v9hKWR2HV7nLtrzHjtpPTrOcNWiiiEVxjY6wTpcEXENJAVUoC+PP4XUca/Jg0+xZRE12/qnPk0EwLnwKe/xgvEh0z8nrESTGOh0ZVXqzgSpRhRBdw6Ir+hRE7zp8r9bF5xQj7utV84Kkp3oiQBBRKikqrvkRkmM4nr9QnbjxrcRKKutQM9Eaps12LIKcxga8ejDK3Jjrs/mLcz0JslMbs99F5PSFrcewYmTRyZ6fqvVwvgUXJcLditVgzC2Ap+6XnN9Fjmg==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(396003)(136003)(39860400002)(376002)(346002)(451199015)(40470700004)(46966006)(36840700001)(86362001)(36756003)(7636003)(356005)(82740400003)(36860700001)(4326008)(16526019)(2906002)(5660300002)(47076005)(336012)(186003)(2616005)(7696005)(26005)(83380400001)(426003)(70586007)(70206006)(316002)(82310400005)(40480700001)(40460700003)(110136005)(54906003)(41300700001)(8936002)(8676002)(478600001)(107886003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Nov 2022 10:48:33.8661
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3375c7e5-c92a-4d08-4033-08dac176c883
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT097.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5340
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Add locked bridge port support by reacting to changes in the
'BR_PORT_LOCKED' flag. When set, enable security checks on the local
port via the previously added SPFSR register.

When security checks are enabled, an incoming packet will trigger an FDB
lookup with the packet's source MAC and the FID it was classified to. If
an FDB entry was not found or was found to be pointing to a different
port, the packet will be dropped. Such packets increment the
"discard_ingress_general" ethtool counter. For added visibility, user
space can trap such packets to the CPU by enabling the "locked_port"
trap. Example:

 # devlink trap set pci/0000:06:00.0 trap locked_port action trap

Unlike other configurations done via bridge port flags (e.g., learning,
flooding), security checks are enabled in the device on a per-port basis
and not on a per-{port, VLAN} basis. As such, scenarios where user space
can configure different locking settings for different VLANs configured
on a port need to be vetoed. To that end, veto the following scenarios:

1. Locking is set on a bridge port that is a VLAN upper

2. Locking is set on a bridge port that has VLAN uppers

3. VLAN upper is configured on a locked bridge port

Examples:

 # bridge link set dev swp1.10 locked on
 Error: mlxsw_spectrum: Locked flag cannot be set on a VLAN upper.

 # ip link add link swp1 name swp1.10 type vlan id 10
 # bridge link set dev swp1 locked on
 Error: mlxsw_spectrum: Locked flag cannot be set on a bridge port that has VLAN uppers.

 # bridge link set dev swp1 locked on
 # ip link add link swp1 name swp1.10 type vlan id 10
 Error: mlxsw_spectrum: VLAN uppers are not supported on a locked port.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Petr Machata <petrm@nvidia.com>
---

Notes:
    v1:
    * Add 'BR_PORT_MAB' in mlxsw_sp_port_attr_br_pre_flags_set().

 .../net/ethernet/mellanox/mlxsw/spectrum.c    |  4 ++++
 .../mellanox/mlxsw/spectrum_switchdev.c       | 23 ++++++++++++++++++-
 2 files changed, 26 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index b34366521914..f5b2d965d476 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -4760,6 +4760,10 @@ static int mlxsw_sp_netdevice_port_upper_event(struct net_device *lower_dev,
 			NL_SET_ERR_MSG_MOD(extack, "VLAN uppers are only supported with 802.1q VLAN protocol");
 			return -EOPNOTSUPP;
 		}
+		if (is_vlan_dev(upper_dev) && mlxsw_sp_port->security) {
+			NL_SET_ERR_MSG_MOD(extack, "VLAN uppers are not supported on a locked port");
+			return -EOPNOTSUPP;
+		}
 		break;
 	case NETDEV_CHANGEUPPER:
 		upper_dev = info->upper_dev;
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
index db149af7c888..accea95cae5d 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
@@ -782,14 +782,26 @@ mlxsw_sp_bridge_port_learning_set(struct mlxsw_sp_port *mlxsw_sp_port,
 
 static int
 mlxsw_sp_port_attr_br_pre_flags_set(struct mlxsw_sp_port *mlxsw_sp_port,
+				    const struct net_device *orig_dev,
 				    struct switchdev_brport_flags flags,
 				    struct netlink_ext_ack *extack)
 {
-	if (flags.mask & ~(BR_LEARNING | BR_FLOOD | BR_MCAST_FLOOD)) {
+	if (flags.mask & ~(BR_LEARNING | BR_FLOOD | BR_MCAST_FLOOD |
+			   BR_PORT_LOCKED | BR_PORT_MAB)) {
 		NL_SET_ERR_MSG_MOD(extack, "Unsupported bridge port flag");
 		return -EINVAL;
 	}
 
+	if ((flags.mask & BR_PORT_LOCKED) && is_vlan_dev(orig_dev)) {
+		NL_SET_ERR_MSG_MOD(extack, "Locked flag cannot be set on a VLAN upper");
+		return -EINVAL;
+	}
+
+	if ((flags.mask & BR_PORT_LOCKED) && vlan_uses_dev(orig_dev)) {
+		NL_SET_ERR_MSG_MOD(extack, "Locked flag cannot be set on a bridge port that has VLAN uppers");
+		return -EINVAL;
+	}
+
 	return 0;
 }
 
@@ -822,6 +834,13 @@ static int mlxsw_sp_port_attr_br_flags_set(struct mlxsw_sp_port *mlxsw_sp_port,
 			return err;
 	}
 
+	if (flags.mask & BR_PORT_LOCKED) {
+		err = mlxsw_sp_port_security_set(mlxsw_sp_port,
+						 flags.val & BR_PORT_LOCKED);
+		if (err)
+			return err;
+	}
+
 	if (bridge_port->bridge_device->multicast_enabled)
 		goto out;
 
@@ -1189,6 +1208,7 @@ static int mlxsw_sp_port_attr_set(struct net_device *dev, const void *ctx,
 		break;
 	case SWITCHDEV_ATTR_ID_PORT_PRE_BRIDGE_FLAGS:
 		err = mlxsw_sp_port_attr_br_pre_flags_set(mlxsw_sp_port,
+							  attr->orig_dev,
 							  attr->u.brport_flags,
 							  extack);
 		break;
@@ -2787,6 +2807,7 @@ void mlxsw_sp_port_bridge_leave(struct mlxsw_sp_port *mlxsw_sp_port,
 
 	bridge_device->ops->port_leave(bridge_device, bridge_port,
 				       mlxsw_sp_port);
+	mlxsw_sp_port_security_set(mlxsw_sp_port, false);
 	mlxsw_sp_bridge_port_put(mlxsw_sp->bridge, bridge_port);
 }
 
-- 
2.35.3

