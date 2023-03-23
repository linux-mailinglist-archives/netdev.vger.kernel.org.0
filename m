Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB3AF6C6632
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 12:12:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229993AbjCWLL7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 07:11:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229849AbjCWLL5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 07:11:57 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2059.outbound.protection.outlook.com [40.107.220.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE7162D168
        for <netdev@vger.kernel.org>; Thu, 23 Mar 2023 04:11:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PncVfewLHmytK/rbqqRy+ET+BRoXSfdlKZwoNGiFwiNdYcPLSz1EQTv8t/uZ/SmWyq8/yt6yliJ0DAHUTGYRnuH1oOsSAx5HBzlRmu4QjDl7cxf/U9nlCO7GMV0JRRGKs0ygD3afJh5DrVFJYns6rp7g4iQMZ9caTu5CVBXh6NSfqiq+PSvGVRugsepSnRhKukGKt02okTSf63sgGbTw2PLc3c5Sr52xhGIKDfJl9LRqm6s77dMGsb7suj1EC4Nsj0Fpoj9fzZbS4uNDGs4HpkUWbUTo2e2TK6o/QAO1s/Zw5UqU51GUEUmcH5D3f6GVmmZAjrxfBE/fcjXKvHiRbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/dTNXqjsDAOycLUOm5ZKMKDQ3BK2Lq+cwe07jpwPyys=;
 b=Y4e61QOmI0WkjES4cZ/5X+VfGWTekN1sO2eDDs+kVJcxiD/tl/jRGbCCZrvtc6ZXVDapefl1SKXONpu50HnoMDi+xSSeNJp78amFN06+mxEsfuHTI2LERx8MikflyZzn9Jl0Zhli6XEF+XS/6Pr1XbqQ3juzzoa9QmmocDzwt/W7ylVvR3rsyK+sebYw+O1sDCnhQAAECEr/hMP+SF76RcSU/7CEHV2gyErLaYhqHJ2U8FMVKQ26UE2SQKOA5kzW2s20saIApqwHo5pAZ+YPFA9VL2ZdwFbe9y3fX1+t6ONXw1DgHxH6r8AZ0xXFbiJozmpSv7XnLRdkPga6HqVZgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/dTNXqjsDAOycLUOm5ZKMKDQ3BK2Lq+cwe07jpwPyys=;
 b=QDZhjZb3MAnmQAx/B2u78G3JhGDQAYN+NZ4JHcNIGIRmAqqucCfsB91QAZGq1SNezWEuxowjyiXzs8iLaEMC1bUDWTHLp08+ccKSzTdkmmpI5QWR1WJ6ij3TYHchlaNouqqduW1TK41CjDktMzMvXhuLlit1ZCDKjs+BacuFTTLOIsdSYaJe10I2k5C9PGTo8qecVtts5a9n9x0CzAvuv4KGBuEtaLWNi6cUqH5oTAPRgorgh7efgPS8pawaP1PtpzjKuHMeDOGmFdqoSTltbV1mJlN6k9WNnc1vdWol5JTRNyrGPbFWP3Iagd2KmVw1lxkgURD1u4IsjQ9qAvavSw==
Received: from DS7P222CA0015.NAMP222.PROD.OUTLOOK.COM (2603:10b6:8:2e::27) by
 DM4PR12MB6661.namprd12.prod.outlook.com (2603:10b6:8:bb::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.38; Thu, 23 Mar 2023 11:11:52 +0000
Received: from DS1PEPF0000E654.namprd02.prod.outlook.com
 (2603:10b6:8:2e:cafe::c5) by DS7P222CA0015.outlook.office365.com
 (2603:10b6:8:2e::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.38 via Frontend
 Transport; Thu, 23 Mar 2023 11:11:52 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DS1PEPF0000E654.mail.protection.outlook.com (10.167.18.10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.30 via Frontend Transport; Thu, 23 Mar 2023 11:11:52 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Thu, 23 Mar 2023
 04:11:42 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Thu, 23 Mar
 2023 04:11:42 -0700
Received: from vdi.nvidia.com (10.127.8.13) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.986.5 via Frontend Transport; Thu, 23 Mar
 2023 04:11:39 -0700
From:   Dima Chumak <dchumak@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Jiri Pirko <jiri@resnulli.us>,
        Leon Romanovsky <leon@kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>, <netdev@vger.kernel.org>,
        Dima Chumak <dchumak@nvidia.com>, Jiri Pirko <jiri@nvidia.com>
Subject: [PATCH net-next 1/4] devlink: Expose port function commands to control IPsec crypto offloads
Date:   Thu, 23 Mar 2023 13:10:56 +0200
Message-ID: <20230323111059.210634-2-dchumak@nvidia.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230323111059.210634-1-dchumak@nvidia.com>
References: <20230323111059.210634-1-dchumak@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1PEPF0000E654:EE_|DM4PR12MB6661:EE_
X-MS-Office365-Filtering-Correlation-Id: 5ba519e2-1f6f-4bab-0510-08db2b8f67e1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +9/4YRvFS9G80uHv2bKcDgxsq2ogMpinpBi63O9sEiAsXcsw7PeQYbiP4AuhI/TFmN2UVxcuDQd3h7FaIkEPZ8Bl/p0jnMQH3vKtLvtZgD0eQyr3NablQpgzOXc2pl3LbOLhZIewEw/bYysA+nVhKdVlPblQenuIyZEqlbx1o7dtPATOxtCxMgPzIaVVpkvvM+pxGA4HbaEeE/U8cIGwy6iABLzQ8WoG/3d0n0UU4CIRbO/pg1wjQb25BhGBI1kOkklbLOYSp6zCyUgjGSyOS8f8tj8eLEo6ANzJU3gJ5mR49BEu8slqC0vx4pvaPwKm+VwlT6PJ+wx+AVKKDe+RaDkz+hn3ISZcPHf2vG3/UKc3r9v8UfQxQ75px2ulTp9ubMdTy/4z75LxHjuQLX27vXIVI0odzebjcd8XGN+G2+BE6mWlhOvax8gztUpu7tKGkLhI/bKdY95UfC7nU4uI+sxYhsEvGO6x6QxsN43Q82sHOSbFokMizqXWD1iJWrXD8IkAZEL0bGR/yyPhh2ZbSfwtBtJmRL/DbAVwHnNT8icOWMN/zhFs8S9UPOMs0tUj2DqTfs4dee4wrXxoV9mdUJHgcxQm4b9UO8D6xnzOd+VCuU8qrZPay40P584nASkHs6gcomz/ohalUn2C6HGk/JSkFcWNFq6OH73AgM4okYJZvWPflHBH9nRWEZbbhfFq8YDaZJUjYu1g8sqbJDEla+Ez7e33ETB0r5Ys4Q2lWMVoC0EXIajuPI6tJ3gpNx0q
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(396003)(136003)(376002)(346002)(39860400002)(451199018)(36840700001)(46966006)(40470700004)(41300700001)(5660300002)(8676002)(6916009)(4326008)(2906002)(40460700003)(36860700001)(82740400003)(356005)(36756003)(86362001)(7636003)(7696005)(107886003)(6666004)(26005)(478600001)(70586007)(70206006)(316002)(8936002)(40480700001)(82310400005)(1076003)(54906003)(47076005)(426003)(83380400001)(336012)(2616005)(186003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2023 11:11:52.4612
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ba519e2-1f6f-4bab-0510-08db2b8f67e1
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DS1PEPF0000E654.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6661
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Expose port function commands to enable / disable IPsec crypto offloads,
this is used to control the port IPsec capabilities.

When IPsec is disabled for a function of the port (default), function
cannot offload any IPsec crypto operations. When enabled, IPsec crypto
operations can be offloaded by the function of the port.

Example of a PCI VF port which supports IPsec crypto offloads:

$ devlink port show pci/0000:06:00.0/1
    pci/0000:06:00.0/1: type eth netdev enp6s0pf0vf0 flavour pcivf pfnum 0 vfnum 0
        function:
        hw_addr 00:00:00:00:00:00 roce enable ipsec_crypto disable

$ devlink port function set pci/0000:06:00.0/1 ipsec_crypto enable

$ devlink port show pci/0000:06:00.0/1
    pci/0000:06:00.0/1: type eth netdev enp6s0pf0vf0 flavour pcivf pfnum 0 vfnum 0
        function:
        hw_addr 00:00:00:00:00:00 roce enable ipsec_crypto enable

Signed-off-by: Dima Chumak <dchumak@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
 .../networking/devlink/devlink-port.rst       | 27 +++++++++
 include/net/devlink.h                         | 21 +++++++
 include/uapi/linux/devlink.h                  |  2 +
 net/devlink/leftover.c                        | 55 +++++++++++++++++++
 4 files changed, 105 insertions(+)

diff --git a/Documentation/networking/devlink/devlink-port.rst b/Documentation/networking/devlink/devlink-port.rst
index 3da590953ce8..e7c7482714d7 100644
--- a/Documentation/networking/devlink/devlink-port.rst
+++ b/Documentation/networking/devlink/devlink-port.rst
@@ -128,6 +128,9 @@ Users may also set the RoCE capability of the function using
 Users may also set the function as migratable using
 'devlink port function set migratable' command.
 
+Users may also set the IPsec crypto capability of the function using
+`devlink port function set ipsec_crypto` command.
+
 Function attributes
 ===================
 
@@ -240,6 +243,30 @@ Attach VF to the VM.
 Start the VM.
 Perform live migration.
 
+IPsec crypto capability setup
+-----------------------------
+When user enables IPsec crypto capability for a VF, user application can offload
+XFRM state to this VF.
+
+When IPsec crypto capability is disabled (default) for a VF, the XFRM state is
+processed in software by the kernel.
+
+- Get IPsec crypto capability of the VF device::
+
+    $ devlink port show pci/0000:06:00.0/2
+    pci/0000:06:00.0/2: type eth netdev enp6s0pf0vf1 flavour pcivf pfnum 0 vfnum 1
+        function:
+            hw_addr 00:00:00:00:00:00 ipsec_crypto disabled
+
+- Set IPsec crypto capability of the VF device::
+
+    $ devlink port function set pci/0000:06:00.0/2 ipsec_crypto enable
+
+    $ devlink port show pci/0000:06:00.0/2
+    pci/0000:06:00.0/2: type eth netdev enp6s0pf0vf1 flavour pcivf pfnum 0 vfnum 1
+        function:
+            hw_addr 00:00:00:00:00:00 ipsec_crypto enabled
+
 Subfunction
 ============
 
diff --git a/include/net/devlink.h b/include/net/devlink.h
index 6a942e70e451..4e5f4aeca29d 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -1495,6 +1495,27 @@ struct devlink_ops {
 	int (*port_fn_migratable_set)(struct devlink_port *devlink_port,
 				      bool enable,
 				      struct netlink_ext_ack *extack);
+	/**
+	 * @port_fn_ipsec_crypto_get: Port function's ipsec_crypto get function.
+	 *
+	 * Query ipsec_crypto state of a function managed by the devlink port.
+	 * Return -EOPNOTSUPP if port function IPsec crypto offload is not
+	 * supported.
+	 */
+	int (*port_fn_ipsec_crypto_get)(struct devlink_port *devlink_port,
+				      bool *is_enable,
+				      struct netlink_ext_ack *extack);
+	/**
+	 * @port_fn_ipsec_crypto_set: Port function's ipsec_crypto set function.
+	 *
+	 * Enable/Disable ipsec_crypto state of a function managed by the devlink
+	 * port.
+	 * Return -EOPNOTSUPP if port function IPsec crypto offload is not
+	 * supported.
+	 */
+	int (*port_fn_ipsec_crypto_set)(struct devlink_port *devlink_port,
+				      bool enable,
+				      struct netlink_ext_ack *extack);
 	/**
 	 * port_new() - Add a new port function of a specified flavor
 	 * @devlink: Devlink instance
diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
index 3782d4219ac9..f9ae9a058ad2 100644
--- a/include/uapi/linux/devlink.h
+++ b/include/uapi/linux/devlink.h
@@ -661,6 +661,7 @@ enum devlink_resource_unit {
 enum devlink_port_fn_attr_cap {
 	DEVLINK_PORT_FN_ATTR_CAP_ROCE_BIT,
 	DEVLINK_PORT_FN_ATTR_CAP_MIGRATABLE_BIT,
+	DEVLINK_PORT_FN_ATTR_CAP_IPSEC_CRYPTO_BIT,
 
 	/* Add new caps above */
 	__DEVLINK_PORT_FN_ATTR_CAPS_MAX,
@@ -669,6 +670,7 @@ enum devlink_port_fn_attr_cap {
 #define DEVLINK_PORT_FN_CAP_ROCE _BITUL(DEVLINK_PORT_FN_ATTR_CAP_ROCE_BIT)
 #define DEVLINK_PORT_FN_CAP_MIGRATABLE \
 	_BITUL(DEVLINK_PORT_FN_ATTR_CAP_MIGRATABLE_BIT)
+#define DEVLINK_PORT_FN_CAP_IPSEC_CRYPTO _BITUL(DEVLINK_PORT_FN_ATTR_CAP_IPSEC_CRYPTO_BIT)
 
 enum devlink_port_function_attr {
 	DEVLINK_PORT_FUNCTION_ATTR_UNSPEC,
diff --git a/net/devlink/leftover.c b/net/devlink/leftover.c
index dffca2f9bfa7..07761df2471d 100644
--- a/net/devlink/leftover.c
+++ b/net/devlink/leftover.c
@@ -492,6 +492,29 @@ static int devlink_port_fn_migratable_fill(const struct devlink_ops *ops,
 	return 0;
 }
 
+static int devlink_port_fn_ipsec_crypto_fill(const struct devlink_ops *ops,
+					     struct devlink_port *devlink_port,
+					     struct nla_bitfield32 *caps,
+					     struct netlink_ext_ack *extack)
+{
+	bool is_enable;
+	int err;
+
+	if (!ops->port_fn_ipsec_crypto_get ||
+	    devlink_port->attrs.flavour != DEVLINK_PORT_FLAVOUR_PCI_VF)
+		return 0;
+
+	err = ops->port_fn_ipsec_crypto_get(devlink_port, &is_enable, extack);
+	if (err) {
+		if (err == -EOPNOTSUPP)
+			return 0;
+		return err;
+	}
+
+	devlink_port_fn_cap_fill(caps, DEVLINK_PORT_FN_CAP_IPSEC_CRYPTO, is_enable);
+	return 0;
+}
+
 static int devlink_port_fn_caps_fill(const struct devlink_ops *ops,
 				     struct devlink_port *devlink_port,
 				     struct sk_buff *msg,
@@ -509,6 +532,10 @@ static int devlink_port_fn_caps_fill(const struct devlink_ops *ops,
 	if (err)
 		return err;
 
+	err = devlink_port_fn_ipsec_crypto_fill(ops, devlink_port, &caps, extack);
+	if (err)
+		return err;
+
 	if (!caps.selector)
 		return 0;
 	err = nla_put_bitfield32(msg, DEVLINK_PORT_FN_ATTR_CAPS, caps.value,
@@ -843,6 +870,15 @@ devlink_port_fn_roce_set(struct devlink_port *devlink_port, bool enable,
 	return ops->port_fn_roce_set(devlink_port, enable, extack);
 }
 
+static int
+devlink_port_fn_ipsec_crypto_set(struct devlink_port *devlink_port, bool enable,
+				 struct netlink_ext_ack *extack)
+{
+	const struct devlink_ops *ops = devlink_port->devlink->ops;
+
+	return ops->port_fn_ipsec_crypto_set(devlink_port, enable, extack);
+}
+
 static int devlink_port_fn_caps_set(struct devlink_port *devlink_port,
 				    const struct nlattr *attr,
 				    struct netlink_ext_ack *extack)
@@ -867,6 +903,13 @@ static int devlink_port_fn_caps_set(struct devlink_port *devlink_port,
 		if (err)
 			return err;
 	}
+	if (caps.selector & DEVLINK_PORT_FN_CAP_IPSEC_CRYPTO) {
+		err = devlink_port_fn_ipsec_crypto_set(devlink_port, caps_value &
+						       DEVLINK_PORT_FN_CAP_IPSEC_CRYPTO,
+						       extack);
+		if (err)
+			return err;
+	}
 	return 0;
 }
 
@@ -1235,6 +1278,18 @@ static int devlink_port_function_validate(struct devlink_port *devlink_port,
 				return -EOPNOTSUPP;
 			}
 		}
+		if (caps.selector & DEVLINK_PORT_FN_CAP_IPSEC_CRYPTO) {
+			if (!ops->port_fn_ipsec_crypto_set) {
+				NL_SET_ERR_MSG_ATTR(extack, attr,
+						    "Port doesn't support ipsec_crypto function attribute");
+				return -EOPNOTSUPP;
+			}
+			if (devlink_port->attrs.flavour != DEVLINK_PORT_FLAVOUR_PCI_VF) {
+				NL_SET_ERR_MSG_ATTR(extack, attr,
+						    "ipsec_crypto function attribute supported for VFs only");
+				return -EOPNOTSUPP;
+			}
+		}
 	}
 	return 0;
 }
-- 
2.40.0

