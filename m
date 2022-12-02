Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05DA064021E
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 09:30:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232862AbiLBIad (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 03:30:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232406AbiLBI3S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 03:29:18 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2057.outbound.protection.outlook.com [40.107.92.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A007B0B75
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 00:27:09 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=liMTGXLn7zRAJ4GA6294pOsScGHkr65M4HAmrG6Bwz+EFT461as+1Hm5QXT/Ko97ItfYnZIu5Bq271NldT8eJ5MLVWdh9YKVGa5Ag2wwrGX0tdpaB+6nE/AIaEfDbYeR3nyM7IlAEdZktycovCnAL/DCLOCIin1+miklKzmH+K495biqu4+j/gUeutm3eGVXCBVbe40ad8YZ50MuJTEeDTLVJG0SBFIDcCBPMipImLlix7DuSiA9w/ETCzvt3sjzsU44oCs07s0+27Lq4tVsgeFV6nsF2gAj1gxjcqu7j/ZfGlxt2XbGGMAJVjrxS6mq6QQAYb6dXcyP+CWiC8/rxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wWFdRmCdeB0qwnmZbBuyUCx7h0WXmtCUhh3eXF1joUk=;
 b=RZF0F2M9lpHfpXzq1KIaVxwKJDJhXcKobcVK01Nbdmiho6uKmORoZVWc99Z8vNl0kEaaudd6J1DHHAQsuky0DxQpgnRtsLKj+0rLc+WxDwNgv/uveKbX7BMiRdHAMxFrdLQmbY2atoDr8+b05Ls0npKSOSk6l9pu6G/AUCaGx1qP5T3qdWZPDP+QKmrpWy2dDC8b/7Lb4qxpyeunhtPPJtHYKA8/4zs3wunk5e5/CSatMNg+iF95hLL9d/Re9UcybbWpRVmnkfSvpqMXBkOVV4DbUxu4T9VMRxLDMNq3UTG7e0yFTUzm9rA0GJ6+IaBmfL7yXebhONsrDzHYfBrkVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wWFdRmCdeB0qwnmZbBuyUCx7h0WXmtCUhh3eXF1joUk=;
 b=WjKzpKzaBoTRtDjs7gRC1eBxaNEflmqSft1+BKyP7A2nxIfK7ihfb69OgUO8BeyB1ntw+zLK6GHYV55KRhM2s02dbPIkj2JFyuH1wLnCtJbWpuZ1K05dGZMCSazMtc+tqdsBRkae9UjuggfmbJIfODL0t730/+Mn1sCsSe9CBNf2dPsH4PrTrr+uGwogmE07lo9spjuSF+JizvC1j6U2CtPLtLJyLDWUUoytbJoW1YjaOgbY6hcVg8qiWFpqFk8Ry2VNxiIExVJ2e4fStQXHDq5qUVv5pUi8yQwPy+uLPyzar8Wl2vXjwlNCh1h8diIpzJ32pIADTI6UhEsqT3AA7A==
Received: from MW4PR03CA0337.namprd03.prod.outlook.com (2603:10b6:303:dc::12)
 by DS7PR12MB5765.namprd12.prod.outlook.com (2603:10b6:8:74::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Fri, 2 Dec
 2022 08:27:07 +0000
Received: from CO1NAM11FT049.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:dc:cafe::3) by MW4PR03CA0337.outlook.office365.com
 (2603:10b6:303:dc::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.10 via Frontend
 Transport; Fri, 2 Dec 2022 08:27:06 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CO1NAM11FT049.mail.protection.outlook.com (10.13.175.50) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5880.10 via Frontend Transport; Fri, 2 Dec 2022 08:27:06 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Fri, 2 Dec 2022
 00:26:54 -0800
Received: from nps-server-23.mtl.labs.mlnx (10.126.231.35) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Fri, 2 Dec 2022 00:26:51 -0800
From:   Shay Drory <shayd@nvidia.com>
To:     <netdev@vger.kernel.org>, <kuba@kernel.org>, <davem@davemloft.net>
CC:     <danielj@nvidia.com>, <yishaih@nvidia.com>, <jiri@nvidia.com>,
        <saeedm@nvidia.com>, <parav@nvidia.com>
Subject: [PATCH net-next V2 7/8] devlink: Expose port function commands to control migratable
Date:   Fri, 2 Dec 2022 10:26:21 +0200
Message-ID: <20221202082622.57765-8-shayd@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CO1NAM11FT049:EE_|DS7PR12MB5765:EE_
X-MS-Office365-Filtering-Correlation-Id: 24477438-74b6-4e10-be53-08dad43effa9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: j+HrHTFlmEaNXXyyd5nCZyfUKxt2ngJn/7XbxmM1ogqy3vAWJxKIvwdGzSVBGTWxp1IqR9Wmlwq/iqfmrXcYe/J0u+saiJ85glptY+pjHYm/F/UyObS/W8JsUiR4qSXdaBQGpXoT4OFRhPZNigTLkVKWz13YZXOCXEzqVL2yBvGU9+lxdR57Yu1Felm83dsHJm/tcGvFDPhwBy74nmsmDVPoODgnVxs1bISz0LsoA3v/YqPQOVGJlC8QwZNSwEnGXShe3Idt9Lgp1itwT1lo/26jnKORzY3d4u8TRvHQ7U7kuiQUqF6jmZd/rqp6scctR2VzboIeRDXAk5w+sROJ59CpH9E+eSenJvvMp+VqHhiOoVxxZYvCZTXf14p1J+5id4GxhWK2xehcJDhvmNo4t++WQjD9DXPov30B+JHmUDs84zSdINbLPLIHe214iG+iDzFdDjiVTFiuF88c4cVA66/RYp7dViWRia87IOJnt8eaKeLpL6U3iE0Jrttfm6r0Txh9taWnCXudp8whmDC5LHAi4IY6UR1ZtY9JwVDXtL65nFNyB5eWHIt70SCjqfMrzXQh+AjJqv3tO127+rg4TTVpJmbOwKV2d4bC3FcPh2JFSGvc9ouM/DZF3VzgvAyRpH/pYEkPtRjHnP5TQSy+om2dgGhqiZuEs2e8KDJ+9NkPWp79GnlEavCCkk7nXHK686f7LRvKqg9FePYrhCvD5g==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(136003)(376002)(396003)(346002)(451199015)(36840700001)(46966006)(40470700004)(7636003)(40480700001)(40460700003)(356005)(6666004)(2906002)(36756003)(2616005)(107886003)(86362001)(16526019)(478600001)(186003)(8936002)(36860700001)(26005)(316002)(70586007)(5660300002)(41300700001)(70206006)(110136005)(4326008)(54906003)(8676002)(82740400003)(336012)(1076003)(82310400005)(83380400001)(47076005)(426003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Dec 2022 08:27:06.7315
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 24477438-74b6-4e10-be53-08dad43effa9
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT049.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5765
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

Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Reported-by: kernel test robot <lkp@intel.com>
---
v1->v2:
 - fix documentation warning
---
 .../networking/devlink/devlink-port.rst       | 46 ++++++++++++++++
 include/net/devlink.h                         | 21 ++++++++
 include/uapi/linux/devlink.h                  |  1 +
 net/core/devlink.c                            | 54 +++++++++++++++++++
 4 files changed, 122 insertions(+)

diff --git a/Documentation/networking/devlink/devlink-port.rst b/Documentation/networking/devlink/devlink-port.rst
index 79f9c0390b47..2e3d17291ae0 100644
--- a/Documentation/networking/devlink/devlink-port.rst
+++ b/Documentation/networking/devlink/devlink-port.rst
@@ -125,6 +125,9 @@ this means a MAC address.
 Users may also set the RoCE capability of the function using
 'devlink port function set roce' command.
 
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
+$ echo <pci_id> > /sys/bus/pci/devices/0000:08:00.0/driver/unbind
+$ echo mlx5_vfio_pci > /sys/bus/pci/devices/0000:08:00.0/driver_override
+$ echo <pci_id> > /sys/bus/pci/devices/0000:08:00.0/driver/bind
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
index 830f8ffd69d1..5a2b87a05c74 100644
--- a/include/uapi/linux/devlink.h
+++ b/include/uapi/linux/devlink.h
@@ -660,6 +660,7 @@ enum devlink_resource_unit {
 
 enum devlink_port_fn_attr_cap {
 	DEVLINK_PORT_FN_ATTR_CAP_ROCE,
+	DEVLINK_PORT_FN_ATTR_CAP_MIGRATABLE,
 
 	/* Add new caps above */
 	__DEVLINK_PORT_FN_ATTR_CAPS_MAX,
diff --git a/net/core/devlink.c b/net/core/devlink.c
index dcf6aae443a9..9ea6d1f854db 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -728,6 +728,29 @@ static int devlink_port_fn_roce_fill(const struct devlink_ops *ops,
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
+	DEVLINK_PORT_FN_SET_CAP(caps, DEVLINK_PORT_FN_CAP(MIGRATABLE), is_enable);
+	return 0;
+}
+
 static int devlink_port_fn_caps_fill(const struct devlink_ops *ops,
 				     struct devlink_port *devlink_port,
 				     struct sk_buff *msg,
@@ -741,6 +764,10 @@ static int devlink_port_fn_caps_fill(const struct devlink_ops *ops,
 	if (err)
 		return err;
 
+	err = devlink_port_function_mig_fill(ops, devlink_port, &caps, extack);
+	if (err)
+		return err;
+
 	if (!caps.selector)
 		return 0;
 	err = nla_put_bitfield32(msg, DEVLINK_PORT_FN_ATTR_CAPS, caps.value,
@@ -1335,6 +1362,15 @@ static int devlink_port_fn_state_fill(const struct devlink_ops *ops,
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
@@ -1361,6 +1397,13 @@ static int devlink_port_fn_caps_set(struct devlink_port *devlink_port,
 		if (err)
 			return err;
 	}
+	if (caps.selector & DEVLINK_PORT_FN_CAP(MIGRATABLE)) {
+		err = devlink_port_fn_mig_set(devlink_port, caps_value &
+					      DEVLINK_PORT_FN_CAP(MIGRATABLE),
+					      extack);
+		if (err)
+			return err;
+	}
 	return 0;
 }
 
@@ -1781,6 +1824,17 @@ static int devlink_port_function_validate(struct devlink_port *devlink_port,
 					    "Port doesn't support RoCE function attribute");
 			return -EOPNOTSUPP;
 		}
+		if (caps.selector & DEVLINK_PORT_FN_CAP(MIGRATABLE)) {
+			if (!ops->port_function_mig_set) {
+				NL_SET_ERR_MSG_ATTR(extack, attr,
+						    "Port doesn't support migratable function attribute");
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

