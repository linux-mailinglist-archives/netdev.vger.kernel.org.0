Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 065D1644C0C
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 19:52:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229580AbiLFSwf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 13:52:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229849AbiLFSwO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 13:52:14 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F038C3E097
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 10:52:08 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jhA/U4DcSpQ6e94gvLOWNKNjVbyHUP2+cZeTlQzpvznWV782U6nBB3KQt3SMLAtQ4lJDpgS2jm1gF+MhAcqXL5nqCw6pVCEdEVCJ3+5mwyAIc6TW2xhUk0Ds/mAELkiCuQOuM0kn6gAMq7x0bdhmqe5khmKnO2ekhNrp5cLhkLMI9jZA8TIj6zScC5xlxJQadYQIKCA0mU4acywpJQwfKzn0u6b5GntCPmy0MyyErjVQh4/nW4wpAdynKM4aUDOr+4o5WDqcvS1FUfVhTlZaa+eclCVbo1CN4T32IChqubzg4LPPxWJh2KmQxzFiKBfX7WtvO0oLUp/0vqfypx/1Gw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q3aL3fqrTH2HDbvmQvVt7e0hu3VESTDYktDeDoXNSDU=;
 b=VvaA+E5+7kPApEUFwWIot1lJD/bqpuC9YxvNG7RuWelROWQwu2D50ViRqjv5GPvRoruhhW2eAYlVvjexSjG+3Tvjve2kSL1ClqJtk1WBVHhMEq8PpPvnRgeD4lfByUY8QE3LjmdzbambRQzY51SENNNsMrho6ZAKE9IBoe2Crc646tByOrdfqx8KIgsQEvw1XdEF/uSc2IMQCzoCBvUYpLwbIEqxUMfxXkYusWTB74AoGbV0N1IWYzrUmLh/6yHXpuC8BW/UFGwtVZAaIlybuC7rga5XiFtbIwro4OrT6Jki1MK41VW6XKlb2XGLki2axh10R1XjJ2lsHpVQbP4VCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q3aL3fqrTH2HDbvmQvVt7e0hu3VESTDYktDeDoXNSDU=;
 b=acstU7mdZsDNCuDYRCGR4MPxV/k4HFk3ClqtmLQN0OUneP3zUtD9gV9dfB3q+hns/C9/KvqLOmGL+YWlt8oHlSIt/pZ78Yj7ct65b2xFHwQsgDBN5AZFr+2ACvHHzJL207IbFKKYAZGnRYvnYoBGhvSnh6tSgX219yRiwLbfBaFOdv0q8Q8h1MSL+JjZY9UE+VsCTZd6CpJ+pCE27koy2fSDqq35wCC//kLobC/xyWFU/X0pRhonI4pMh+06LKtzVoz+EI0za+QLi6EnL1ipF4HO/s5qZRzHwQN7ySGgtCZ0OQpjqqA+i5LNB4vy7+sckW4OAPV6xmr9iGHFVJrlOw==
Received: from MW3PR05CA0019.namprd05.prod.outlook.com (2603:10b6:303:2b::24)
 by DS0PR12MB7780.namprd12.prod.outlook.com (2603:10b6:8:152::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Tue, 6 Dec
 2022 18:52:07 +0000
Received: from CO1NAM11FT003.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:2b:cafe::cb) by MW3PR05CA0019.outlook.office365.com
 (2603:10b6:303:2b::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.8 via Frontend
 Transport; Tue, 6 Dec 2022 18:52:06 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CO1NAM11FT003.mail.protection.outlook.com (10.13.175.93) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5901.14 via Frontend Transport; Tue, 6 Dec 2022 18:52:06 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Tue, 6 Dec 2022
 10:51:52 -0800
Received: from nps-server-23.mtl.labs.mlnx (10.126.231.35) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Tue, 6 Dec 2022 10:51:49 -0800
From:   Shay Drory <shayd@nvidia.com>
To:     <netdev@vger.kernel.org>, <kuba@kernel.org>, <davem@davemloft.net>
CC:     <danielj@nvidia.com>, <yishaih@nvidia.com>, <jiri@nvidia.com>,
        <saeedm@nvidia.com>, <parav@nvidia.com>,
        Shay Drory <shayd@nvidia.com>,
        Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net-next V4 7/8] devlink: Expose port function commands to control migratable
Date:   Tue, 6 Dec 2022 20:51:18 +0200
Message-ID: <20221206185119.380138-8-shayd@nvidia.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221206185119.380138-1-shayd@nvidia.com>
References: <20221206185119.380138-1-shayd@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT003:EE_|DS0PR12MB7780:EE_
X-MS-Office365-Filtering-Correlation-Id: ccdbe645-1a82-4c9f-7485-08dad7baf8e0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rBiOu5nIPT1q06p5hAx8sZa4nBKm0F3U/hgA7uI3VTTeUz720RZofZJF8RlGKMBOv5pfcc0GdZBYLA+i5MQE0Xa0PEO5H/ARHEM2uq98xiOB98LWdFgaKTv1bG0SBHOHUIC2D6UbaZ5eTyXciuNx0lBIMAhmIEPJP2UIdDNN4ZaEr86gg42hK94c860cQcwwp+kQBWqLy3WWYDMJS7WBXJGAn3klGvZmvDrZAia1k31g4bh2CR6HQN4EmzKCsBdFLcUd0GyHMh2DM9oQQDdswJbUduuf1/VhGvkc1uXiAeP/y5+RRFlo/9Y8n/hIKG7Cya4z4KDdG+3WAieNOEWqVb0/JNrzS92YPAb2LVeFddXtW2qTWqikOKns3Djyl/3zejyl6EvnWkUTiwhjzqALzN5OLJfBCea5R9BccodzGekgEeZYcLnoocu2w50FNG5ZpfiYSUIh+I9lit5R/xJZ6viBSClcoJ9m5I06ltY2wkfEnYuvfOQYLcLVxw7lddxJIQUaWn7EEltZ/fwiK8ie3iGVOqOItHKiy2kiZ5BSaOKU7BkfgdrIjZMJvh6e4to+1ZmxovN91l3ECIgruGf04Ecq+SHXaGy0Ofz1iKVNOvfJyZeyJ09I3YjCfq6tflPXeKtBJ1WCQZ2Wppk7PdA1sX8Birmx6aKkU2lW8EAJBOAqm+n0mzI29+YUtai+wvz3kDK6EMZ+k8MDVMZvGtcDmw==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(346002)(136003)(396003)(376002)(451199015)(40470700004)(46966006)(36840700001)(478600001)(47076005)(83380400001)(316002)(5660300002)(40460700003)(8936002)(6666004)(426003)(86362001)(336012)(16526019)(2906002)(1076003)(2616005)(110136005)(36860700001)(36756003)(82310400005)(54906003)(356005)(7636003)(8676002)(70586007)(82740400003)(26005)(70206006)(186003)(40480700001)(4326008)(41300700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2022 18:52:06.4132
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ccdbe645-1a82-4c9f-7485-08dad7baf8e0
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT003.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7780
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Expose port function commands to enable / disable migratable
capability, this is used to set the port function as migratable.

Live migration is the process of transferring a live virtual machine
from one physical host to another without disrupting its normal
operation.

In order for a VM to be able to perform LM, all the VM components must
be able to perform migration. e.g.: to be migratable.
In order for VF to be migratable, VF must be bound to VFIO driver with
migration support.

When migratable capability is enabled for a function of the port, the
device is making the necessary preparations for the function to be
migratable, which might include disabling features which cannot be
migrated.

Example of LM with migratable function configuration:
Set migratable of the VF's port function.

$ devlink port show pci/0000:06:00.0/2
pci/0000:06:00.0/2: type eth netdev enp6s0pf0vf1 flavour pcivf pfnum 0
vfnum 1
    function:
        hw_addr 00:00:00:00:00:00 migratable disable

$ devlink port function set pci/0000:06:00.0/2 migratable enable

$ devlink port show pci/0000:06:00.0/2
pci/0000:06:00.0/2: type eth netdev enp6s0pf0vf1 flavour pcivf pfnum 0
vfnum 1
    function:
        hw_addr 00:00:00:00:00:00 migratable enable

Bind VF to VFIO driver with migration support:
$ echo <pci_id> > /sys/bus/pci/devices/0000:08:00.0/driver/unbind
$ echo mlx5_vfio_pci > /sys/bus/pci/devices/0000:08:00.0/driver_override
$ echo <pci_id> > /sys/bus/pci/devices/0000:08:00.0/driver/bind

Attach VF to the VM.
Start the VM.
Perform LM.

Cc: Shannon Nelson <snelson@pensando.io>
Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
v3->v4:
 - change port_function_mig to port_fn_migratable
v2->v3:
 - fix documentation warning
 - introduce DEVLINK_PORT_FN_CAP_MIGRATABLE
v1->v2:
 - fix documentation warning
---
 .../networking/devlink/devlink-port.rst       | 46 ++++++++++++++++
 include/net/devlink.h                         | 21 +++++++
 include/uapi/linux/devlink.h                  |  3 +
 net/core/devlink.c                            | 55 +++++++++++++++++++
 4 files changed, 125 insertions(+)

diff --git a/Documentation/networking/devlink/devlink-port.rst b/Documentation/networking/devlink/devlink-port.rst
index c3302d23e480..3da590953ce8 100644
--- a/Documentation/networking/devlink/devlink-port.rst
+++ b/Documentation/networking/devlink/devlink-port.rst
@@ -125,6 +125,9 @@ this means a MAC address.
 Users may also set the RoCE capability of the function using
 `devlink port function set roce` command.
 
+Users may also set the function as migratable using
+'devlink port function set migratable' command.
+
 Function attributes
 ===================
 
@@ -194,6 +197,49 @@ VF/SF driver cannot override it.
         function:
             hw_addr 00:00:00:00:00:00 roce disable
 
+migratable capability setup
+---------------------------
+Live migration is the process of transferring a live virtual machine
+from one physical host to another without disrupting its normal
+operation.
+
+User who want PCI VFs to be able to perform live migration need to
+explicitly enable the VF migratable capability.
+
+When user enables migratable capability for a VF, and the HV binds the VF to VFIO driver
+with migration support, the user can migrate the VM with this VF from one HV to a
+different one.
+
+However, when migratable capability is enable, device will disable features which cannot
+be migrated. Thus migratable cap can impose limitations on a VF so let the user decide.
+
+Example of LM with migratable function configuration:
+- Get migratable capability of the VF device::
+
+    $ devlink port show pci/0000:06:00.0/2
+    pci/0000:06:00.0/2: type eth netdev enp6s0pf0vf1 flavour pcivf pfnum 0 vfnum 1
+        function:
+            hw_addr 00:00:00:00:00:00 migratable disable
+
+- Set migratable capability of the VF device::
+
+    $ devlink port function set pci/0000:06:00.0/2 migratable enable
+
+    $ devlink port show pci/0000:06:00.0/2
+    pci/0000:06:00.0/2: type eth netdev enp6s0pf0vf1 flavour pcivf pfnum 0 vfnum 1
+        function:
+            hw_addr 00:00:00:00:00:00 migratable enable
+
+- Bind VF to VFIO driver with migration support::
+
+    $ echo <pci_id> > /sys/bus/pci/devices/0000:08:00.0/driver/unbind
+    $ echo mlx5_vfio_pci > /sys/bus/pci/devices/0000:08:00.0/driver_override
+    $ echo <pci_id> > /sys/bus/pci/devices/0000:08:00.0/driver/bind
+
+Attach VF to the VM.
+Start the VM.
+Perform live migration.
+
 Subfunction
 ============
 
diff --git a/include/net/devlink.h b/include/net/devlink.h
index ce4c65d2f2e7..0f376a28b9c4 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -1469,6 +1469,27 @@ struct devlink_ops {
 	 */
 	int (*port_fn_roce_set)(struct devlink_port *devlink_port,
 				bool enable, struct netlink_ext_ack *extack);
+	/**
+	 * @port_fn_migratable_get: Port function's migratable get function.
+	 *
+	 * Query migratable state of a function managed by the devlink port.
+	 * Return -EOPNOTSUPP if port function migratable handling is not
+	 * supported.
+	 */
+	int (*port_fn_migratable_get)(struct devlink_port *devlink_port,
+				      bool *is_enable,
+				      struct netlink_ext_ack *extack);
+	/**
+	 * @port_fn_migratable_set: Port function's migratable set function.
+	 *
+	 * Enable/Disable migratable state of a function managed by the devlink
+	 * port.
+	 * Return -EOPNOTSUPP if port function migratable handling is not
+	 * supported.
+	 */
+	int (*port_fn_migratable_set)(struct devlink_port *devlink_port,
+				      bool enable,
+				      struct netlink_ext_ack *extack);
 	/**
 	 * port_new() - Add a new port function of a specified flavor
 	 * @devlink: Devlink instance
diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
index 6cc2925bd478..3782d4219ac9 100644
--- a/include/uapi/linux/devlink.h
+++ b/include/uapi/linux/devlink.h
@@ -660,12 +660,15 @@ enum devlink_resource_unit {
 
 enum devlink_port_fn_attr_cap {
 	DEVLINK_PORT_FN_ATTR_CAP_ROCE_BIT,
+	DEVLINK_PORT_FN_ATTR_CAP_MIGRATABLE_BIT,
 
 	/* Add new caps above */
 	__DEVLINK_PORT_FN_ATTR_CAPS_MAX,
 };
 
 #define DEVLINK_PORT_FN_CAP_ROCE _BITUL(DEVLINK_PORT_FN_ATTR_CAP_ROCE_BIT)
+#define DEVLINK_PORT_FN_CAP_MIGRATABLE \
+	_BITUL(DEVLINK_PORT_FN_ATTR_CAP_MIGRATABLE_BIT)
 
 enum devlink_port_function_attr {
 	DEVLINK_PORT_FUNCTION_ATTR_UNSPEC,
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 8c0ad52431c5..ab40ebcb4aea 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -715,6 +715,29 @@ static int devlink_port_fn_roce_fill(const struct devlink_ops *ops,
 	return 0;
 }
 
+static int devlink_port_fn_migratable_fill(const struct devlink_ops *ops,
+					   struct devlink_port *devlink_port,
+					   struct nla_bitfield32 *caps,
+					   struct netlink_ext_ack *extack)
+{
+	bool is_enable;
+	int err;
+
+	if (!ops->port_fn_migratable_get ||
+	    devlink_port->attrs.flavour != DEVLINK_PORT_FLAVOUR_PCI_VF)
+		return 0;
+
+	err = ops->port_fn_migratable_get(devlink_port, &is_enable, extack);
+	if (err) {
+		if (err == -EOPNOTSUPP)
+			return 0;
+		return err;
+	}
+
+	devlink_port_fn_cap_fill(caps, DEVLINK_PORT_FN_CAP_MIGRATABLE, is_enable);
+	return 0;
+}
+
 static int devlink_port_fn_caps_fill(const struct devlink_ops *ops,
 				     struct devlink_port *devlink_port,
 				     struct sk_buff *msg,
@@ -728,6 +751,10 @@ static int devlink_port_fn_caps_fill(const struct devlink_ops *ops,
 	if (err)
 		return err;
 
+	err = devlink_port_fn_migratable_fill(ops, devlink_port, &caps, extack);
+	if (err)
+		return err;
+
 	if (!caps.selector)
 		return 0;
 	err = nla_put_bitfield32(msg, DEVLINK_PORT_FN_ATTR_CAPS, caps.value,
@@ -1322,6 +1349,15 @@ static int devlink_port_fn_state_fill(const struct devlink_ops *ops,
 	return 0;
 }
 
+static int
+devlink_port_fn_mig_set(struct devlink_port *devlink_port, bool enable,
+			struct netlink_ext_ack *extack)
+{
+	const struct devlink_ops *ops = devlink_port->devlink->ops;
+
+	return ops->port_fn_migratable_set(devlink_port, enable, extack);
+}
+
 static int
 devlink_port_fn_roce_set(struct devlink_port *devlink_port, bool enable,
 			 struct netlink_ext_ack *extack)
@@ -1348,6 +1384,13 @@ static int devlink_port_fn_caps_set(struct devlink_port *devlink_port,
 		if (err)
 			return err;
 	}
+	if (caps.selector & DEVLINK_PORT_FN_CAP_MIGRATABLE) {
+		err = devlink_port_fn_mig_set(devlink_port, caps_value &
+					      DEVLINK_PORT_FN_CAP_MIGRATABLE,
+					      extack);
+		if (err)
+			return err;
+	}
 	return 0;
 }
 
@@ -1769,6 +1812,18 @@ static int devlink_port_function_validate(struct devlink_port *devlink_port,
 					    "Port doesn't support RoCE function attribute");
 			return -EOPNOTSUPP;
 		}
+		if (caps.selector & DEVLINK_PORT_FN_CAP_MIGRATABLE) {
+			if (!ops->port_fn_migratable_set) {
+				NL_SET_ERR_MSG_ATTR(extack, attr,
+						    "Port doesn't support migratable function attribute");
+				return -EOPNOTSUPP;
+			}
+			if (devlink_port->attrs.flavour != DEVLINK_PORT_FLAVOUR_PCI_VF) {
+				NL_SET_ERR_MSG_ATTR(extack, attr,
+						    "migratable function attribute supported for VFs only");
+				return -EOPNOTSUPP;
+			}
+		}
 	}
 	return 0;
 }
-- 
2.38.1

