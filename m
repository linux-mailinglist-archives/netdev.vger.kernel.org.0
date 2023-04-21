Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 704116EA89C
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 12:50:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231522AbjDUKtx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 06:49:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231591AbjDUKtt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 06:49:49 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2081.outbound.protection.outlook.com [40.107.244.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 243486E92
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 03:49:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EtTPNKefQ2+OaTL/e8jqXuzfH11/hSC1Lh4VBTGgP/wJrUakdVS87X/hfRVam3XYjQAYklFCfR6VFAe/uOVW1cDRm5x2bHocnSpgH1u88cBYb1HhPMQJra0hUmxQIRzPcJrSL3aCn9ysyZEKtdAkoSmVVk5QGZGzP9vmcC0Pf7fgWjQGQ22oS7h7cT+RFeJ6JKREGt8vIkXI6qkHNoMTk+e32n8Y7Vu9k1WDIkPZx/Ws2CfgPjoTWd6qQ768+jUAJRZIrwxZE2Yl5qa0u1UsJbsl/uh1+mC+jSqO2KcfgDiLL33RKEqlI4Blwt5U/JCBa30cYXaGNsR/5AjrqMw7FQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G2znixs7Z60tItwVLQpqrCQd4r+HNF9pI3VUrDVtjtA=;
 b=B8g1CnPjmu24nci5NUx4Yy1RhoZ+pD235lpsz+XIjJJiS3UYjJGEPQLj4nR0ogPgZHrXPUHriiBf9NMH6MUuEhfS8ir7P+MlwpMbrsBvYHzAVUDvA7cy6WOXxZljgrTdQV2o2l5ycyLHzEUQMga9fatsVQyjJYSWndOb5MCHfVj1U56CRal7qWr9cY9CEed/FmCQJdiJq4qZ9cYLyMhvjqn9K2mForBk4nLzWhpX/M42smtJH7lXP+fnUuHmlXorm+gtBKhQzvelnkvxXor8n8b1hRRRkvrkcffZKiYBtMxn1TaEJrXAnzqnSrYtKYb3WOx1iKf3eN9GYkpHohPZ+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G2znixs7Z60tItwVLQpqrCQd4r+HNF9pI3VUrDVtjtA=;
 b=c1wdtL44ADKOsTWcvCfg27o7V7yDyY/85RgrWV1bM/Ttaae68BtBIOws3dgqpz2lnYYt42LQ1k1DtH/ljhL9DEyr7OBT0TFqQhjZq18FsMbRn8d6nu3ZzYQdPHgQSa2Jts6Iu4DpqEyhN5YEZhFMl4hJV41VjOAPwJYY+iFOkrGbC9S3aTX8NYaoOJWVFRHK6hFWesnW7l0G3ARxR84n3YXSQxqqLhKifw5ROf6oHZSk+lcgNGpIcI1Vo6NFZyXdtvuEDZEdAaKhgK8ciUqg3wvnMjJhIw5GZ8juNanrmL+aiA0tjcLeiE+NUF2Gxa5Z9bXtMMnGDSO3oGcNJqcBVQ==
Received: from BN1PR13CA0028.namprd13.prod.outlook.com (2603:10b6:408:e2::33)
 by BL1PR12MB5144.namprd12.prod.outlook.com (2603:10b6:208:316::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.22; Fri, 21 Apr
 2023 10:49:44 +0000
Received: from BN8NAM11FT085.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:e2:cafe::3d) by BN1PR13CA0028.outlook.office365.com
 (2603:10b6:408:e2::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.11 via Frontend
 Transport; Fri, 21 Apr 2023 10:49:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 BN8NAM11FT085.mail.protection.outlook.com (10.13.176.100) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6319.27 via Frontend Transport; Fri, 21 Apr 2023 10:49:43 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Fri, 21 Apr 2023
 03:49:35 -0700
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.37; Fri, 21 Apr 2023 03:49:34 -0700
Received: from vdi.nvidia.com (10.127.8.13) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.986.37 via Frontend
 Transport; Fri, 21 Apr 2023 03:49:32 -0700
From:   Dima Chumak <dchumak@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>
CC:     <netdev@vger.kernel.org>, Jiri Pirko <jiri@resnulli.us>,
        Leon Romanovsky <leon@kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Dima Chumak <dchumak@nvidia.com>, Jiri Pirko <jiri@nvidia.com>
Subject: [PATCH net-next V2 1/4] devlink: Expose port function commands to control IPsec crypto offloads
Date:   Fri, 21 Apr 2023 13:48:58 +0300
Message-ID: <20230421104901.897946-2-dchumak@nvidia.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230421104901.897946-1-dchumak@nvidia.com>
References: <20230421104901.897946-1-dchumak@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT085:EE_|BL1PR12MB5144:EE_
X-MS-Office365-Filtering-Correlation-Id: 6e5231ac-e968-4026-9c1b-08db42561dbd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xDzjPGDlXvru8V1V40/t6z7n8erO9ZqT6aKGDtsMjztUQlwCz2rweEUSn3Jnjlgw09YYdMpM4KfIpcM9hutkcSgq1BHbKitzQZHpw1rTaMBC4GwNBqGdDiSShneoIXiblxf1eXEcr0FFNGdlhdGCWJkE3F1cGIZ6SUztkLnRMwtO130BGnQIAXZae6fty7Wz7WjAWK26P18c1aS/wWzRftDkqkppVQokAGEvz3TttU4j3ylprRZYTVP4lkYzI9p6dsB+DSRV5GP4AShr/JdEYCJNSUhZjx2k2IZJDkA2MlD3tQhEo5BUqTwlSHT10JKpcatmDC9gLEj/R0K8u+sEh/NwR9/NU3eR8Lbq1l8tK84hbcxqXjZgfuGx1pwxAs2ZvMiKOTyYYfzG15ifc9aKG1QFXes6HbeI/ZlIEITJvJXb6yXKpZpskRpXoU0wrc9wt7Z/IhzsJQn1pnM/rliIiZhmGyq+CQ+fzcMimOeTxZLCAQMplZKvm5czOqKrQmOUjZqCo68FpcvqqQQQZY58ZJq3UjuYhehYZyaF9pgxvnRDd3GPXHm2PJkqc245hrhloCM1phDYyDKoVLXQPVPCeoRdwH5IUzZ48HY+LcTjoaDOyU28ismnAlJhSlgTd9VK9/TjVgiwMic6oLIr24aLz6yol8Dmg+5Rn7NFEZXo77xZMxP2cuU4ou/5P85DxYFNl4EFnSuXAnq9OjzLNkD7b63sokM0/f0FIOQ1Vvr5U6uaELtTRJlynOYoD4scSyq34Zzi7DwqUdJWbbWViVLjClg3hfGIfZq6NZSopltYTy4=
X-Forefront-Antispam-Report: CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(346002)(136003)(396003)(376002)(39860400002)(451199021)(36840700001)(40470700004)(46966006)(41300700001)(70206006)(70586007)(316002)(110136005)(34020700004)(107886003)(26005)(54906003)(4326008)(478600001)(186003)(8936002)(426003)(8676002)(83380400001)(336012)(5660300002)(1076003)(36860700001)(47076005)(7696005)(36756003)(6666004)(40460700003)(82740400003)(356005)(2906002)(2616005)(7636003)(82310400005)(40480700001)(86362001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2023 10:49:43.4768
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e5231ac-e968-4026-9c1b-08db42561dbd
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT085.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5144
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Expose port function commands to enable / disable IPsec crypto offloads,
this is used to control the port IPsec capabilities.

When IPsec crypto is disabled for a function of the port (default),
function cannot offload any IPsec crypto operations (Encrypt/Decrypt and
XFRM state offloading). When enabled, IPsec crypto operations can be
offloaded by the function of the port.

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
index 3da590953ce8..6983b11559cb 100644
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
+XFRM state crypto operation (Encrypt/Decrypt) to this VF.
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

