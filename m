Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFDA2641D66
	for <lists+netdev@lfdr.de>; Sun,  4 Dec 2022 15:17:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230158AbiLDORd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Dec 2022 09:17:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230140AbiLDORQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Dec 2022 09:17:16 -0500
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2043.outbound.protection.outlook.com [40.107.96.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D76AE164A6
        for <netdev@vger.kernel.org>; Sun,  4 Dec 2022 06:17:14 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lckGHytNEUNZme2YJ2vNo/5ULrnRlEMjat76byc3+N9dNoWcKNQOniGG2R08Lg9jNYzRY3Mv4jm4O2CZ2sDrYHnhCFfw2At3EnWYyJEYnaM+pUbgxYsB1Jw4aQUSWBjwhg8mGI3/rclnDArhsLzBqILb0qLnQs5xFy8C6opx18kF4yYEV3f8UnAsqpHa0K1GEg4LsuJhaB6tkNTom5VsOyjmUAMmvUfUmWAiYr73+FUSlRpWBE01sADZe/Zel0Z/QesRj1VgK/mwTgHACN8qkI+2R5iTYvZ0ENFUZgnK99dNRwRcWf/ZAeWodSWetuATYae2b7CWC+J6S8NsLAkKqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pRq4H9JHjLX9xcCVP+UOFQpgdcSF0cLNStTrsajMsTU=;
 b=CittPzPl24NMAdmTEv/fLZHZvd9r6hYL6mcN8drtn8zYzw0dkmR9xwrnI/0357VMow82A5UPCmS/5usRxqBM4Hps1CVVGuqDe4bZtOC2cVPSj0EtQmtBaiegYBt8FoqAmPtX1BdoovI9swBPbwEzlu/fbS7Lv7W7YMYb1BQ9d4dppmVpdQhqz8fl2WnaEa4T3flVl4L2LSfbsa622yDEXQFqtK8ehNknn1J6+73bErGHtp1HA8vLtQZwGCDLCCdKaRnpVetI/qJiZgjFsBDxjrbkEAvSpgcRWSh9E79bZDMONyFQQGmBRfUPhhcBFFlozN+qTFiG9A1dAS8jNPHjsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pRq4H9JHjLX9xcCVP+UOFQpgdcSF0cLNStTrsajMsTU=;
 b=U9EYkHslTSpkd5qjzTyKledp2GF2brozErBA7humEyB2s3D/zQ4ewOyzNJ+ucsO5qT1fn7/DNLJvF9LkKHnVdGyZIotjs69TdtbudIhYfckbhulx4+gwRnjXAzGgEtTQ9q3HSNOrc8oXoVtQZrOhi11P/XfI1jKeG57LzkSzsRrNj9M8N6+AlvisKW8AmXAUlSF4FfOohKJJnBwapc07f8wkR+xtgLI+zIE7sRZnXB6cuVsu09/8Ga/RfSxBfAhQaL30JUcd7ZJdZ+XMVJ93sAK8hgaLQqRp5XRgH4j5GVetaMANdnixvOc04FfwgTOGR0fSrPBHRxwZEbjvBLAN2w==
Received: from DM6PR17CA0002.namprd17.prod.outlook.com (2603:10b6:5:1b3::15)
 by MN2PR12MB4485.namprd12.prod.outlook.com (2603:10b6:208:269::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.13; Sun, 4 Dec
 2022 14:17:12 +0000
Received: from DM6NAM11FT054.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:1b3:cafe::2c) by DM6PR17CA0002.outlook.office365.com
 (2603:10b6:5:1b3::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.8 via Frontend
 Transport; Sun, 4 Dec 2022 14:17:12 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DM6NAM11FT054.mail.protection.outlook.com (10.13.173.95) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5880.13 via Frontend Transport; Sun, 4 Dec 2022 14:17:12 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Sun, 4 Dec 2022
 06:17:04 -0800
Received: from nps-server-23.mtl.labs.mlnx (10.126.231.35) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Sun, 4 Dec 2022 06:17:00 -0800
From:   Shay Drory <shayd@nvidia.com>
To:     <netdev@vger.kernel.org>, <kuba@kernel.org>, <davem@davemloft.net>
CC:     <danielj@nvidia.com>, <yishaih@nvidia.com>, <jiri@nvidia.com>,
        <saeedm@nvidia.com>, <parav@nvidia.com>,
        Shay Drory <shayd@nvidia.com>,
        Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net-next V3 7/8] devlink: Expose port function commands to control migratable
Date:   Sun, 4 Dec 2022 16:16:31 +0200
Message-ID: <20221204141632.201932-8-shayd@nvidia.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221204141632.201932-1-shayd@nvidia.com>
References: <20221204141632.201932-1-shayd@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT054:EE_|MN2PR12MB4485:EE_
X-MS-Office365-Filtering-Correlation-Id: 8aa7c986-9c93-42e7-59e1-08dad6023ca9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wxRRffKxSs6BO+ThjMJQMQOvScyy2GQ9squfL4vQAdiNY1qBC+EAdr1YIMga/okjWVq19JM4+kGNBjsdPgHFuVU/JzhJ4q91AGmDbYvP9eckFQjVIS/ORh19/Hzvk6qI/iwSB9I6xGHlIrv2M003SthTGMw+sx5eg5VZzP3CnztJA6JZ50qKq4HIUw2AM5pXjmFvlyxEwdhjGMX3tLLSL4aQK7gzY7SvMC59p1PfrGzcPZBSU8/0CrxthhBD+0dI9tfjgUylP8f7fIIkNP8GzJXuI6j+SpsW+0ixG3rzIyrsYxXgyANpbvg9XGL/IWxErO+b/+JsJn0l+8qvfSCxxSAL2aG1o5VPhMKOcZBK/ygJqpbQgkc/VdCNfQre4bHtEfNh7TJwm7LmRdxC7qCNwVggMdl5txUZ81PUUxFTz6vdvoJS7FMmItszq6q2UigldrWPBxCtmFZ92sEibi6sA0IO1gX1wrF1x5NOAP5X3coLOHnckOFae/CcIRnExtxobg2V0gM7Lcg905zr2lPkgkdUFp3ldrxDZbl/hp4sQZ/RoT1hMG3DygyfEbGYkWvvTp32xtgNegN8K/yKUyQAmmULIcZ1s50vdk3I5KuM40oWDWI1+mOSIrlTPwsSh1KWI2bIiasi5SgEuK7/qBa8+1Kt4Sg2jWy2/OYw8Av/TW5OwpVcdWADd7tNh4zJ/F/3Zhuwv0ZfeCeu6ENNgrugRw==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(136003)(376002)(39860400002)(346002)(396003)(451199015)(36840700001)(46966006)(40470700004)(40480700001)(36756003)(40460700003)(86362001)(478600001)(7636003)(356005)(26005)(83380400001)(8936002)(5660300002)(41300700001)(6666004)(316002)(54906003)(110136005)(2906002)(70586007)(70206006)(4326008)(8676002)(36860700001)(82310400005)(82740400003)(2616005)(336012)(1076003)(186003)(16526019)(47076005)(426003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Dec 2022 14:17:12.0951
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8aa7c986-9c93-42e7-59e1-08dad6023ca9
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT054.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4485
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

When migratable capability is enable for a function of the port, the
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
index 20306fb8a1d9..fdb5e8da33ce 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -1470,6 +1470,27 @@ struct devlink_ops {
 	int (*port_function_roce_set)(struct devlink_port *devlink_port,
 				      bool enable,
 				      struct netlink_ext_ack *extack);
+	/**
+	 * @port_function_mig_get: Port function's migratable get function.
+	 *
+	 * Query migratable state of a function managed by the devlink port.
+	 * Return -EOPNOTSUPP if port function migratable handling is not
+	 * supported.
+	 */
+	int (*port_function_mig_get)(struct devlink_port *devlink_port,
+				     bool *is_enable,
+				     struct netlink_ext_ack *extack);
+	/**
+	 * @port_function_mig_set: Port function's migratable set function.
+	 *
+	 * Enable/Disable migratable state of a function managed by the devlink
+	 * port.
+	 * Return -EOPNOTSUPP if port function migratable handling is not
+	 * supported.
+	 */
+	int (*port_function_mig_set)(struct devlink_port *devlink_port,
+				     bool enable,
+				     struct netlink_ext_ack *extack);
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
index 5c4d3abd7677..bf2c1d3d6df3 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -727,6 +727,29 @@ static int devlink_port_fn_roce_fill(const struct devlink_ops *ops,
 	return 0;
 }
 
+static int devlink_port_function_mig_fill(const struct devlink_ops *ops,
+					  struct devlink_port *devlink_port,
+					  struct nla_bitfield32 *caps,
+					  struct netlink_ext_ack *extack)
+{
+	bool is_enable;
+	int err;
+
+	if (!ops->port_function_mig_get ||
+	    devlink_port->attrs.flavour != DEVLINK_PORT_FLAVOUR_PCI_VF)
+		return 0;
+
+	err = ops->port_function_mig_get(devlink_port, &is_enable, extack);
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
@@ -740,6 +763,10 @@ static int devlink_port_fn_caps_fill(const struct devlink_ops *ops,
 	if (err)
 		return err;
 
+	err = devlink_port_function_mig_fill(ops, devlink_port, &caps, extack);
+	if (err)
+		return err;
+
 	if (!caps.selector)
 		return 0;
 	err = nla_put_bitfield32(msg, DEVLINK_PORT_FN_ATTR_CAPS, caps.value,
@@ -1334,6 +1361,15 @@ static int devlink_port_fn_state_fill(const struct devlink_ops *ops,
 	return 0;
 }
 
+static int
+devlink_port_fn_mig_set(struct devlink_port *devlink_port, bool enable,
+			struct netlink_ext_ack *extack)
+{
+	const struct devlink_ops *ops = devlink_port->devlink->ops;
+
+	return ops->port_function_mig_set(devlink_port, enable, extack);
+}
+
 static int
 devlink_port_fn_roce_set(struct devlink_port *devlink_port, bool enable,
 			 struct netlink_ext_ack *extack)
@@ -1360,6 +1396,13 @@ static int devlink_port_fn_caps_set(struct devlink_port *devlink_port,
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
 
@@ -1781,6 +1824,18 @@ static int devlink_port_function_validate(struct devlink_port *devlink_port,
 					    "Port doesn't support RoCE function attribute");
 			return -EOPNOTSUPP;
 		}
+		if (caps.selector & DEVLINK_PORT_FN_CAP_MIGRATABLE) {
+			if (!ops->port_function_mig_set) {
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

