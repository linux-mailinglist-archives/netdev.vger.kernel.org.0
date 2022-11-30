Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B760163D507
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 12:54:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234230AbiK3LyJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 06:54:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234800AbiK3LxV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 06:53:21 -0500
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2054.outbound.protection.outlook.com [40.107.100.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13DFBD54
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 03:53:18 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jLWyyblvvhHnOzRILz+8O6Zsojg0+lZxlszvqnrvCubPfwWtZj5bySFkTmLaTCztg3TsUbjwYwNe4Jyqmz3hLgVDo+6lGApMOReUGjUmKFbMu8yFEMsqJWEGkPqLP+736mA0ZkNQOTrwShZA49Z4DX9+D4OaZCG7BA1XmHLxjO87gl8fzxJ8RNfJ54rcY3xWifyGnRqowlFvq7N381hSFc7ubsss7kIqa2DkNI5Kb0l/hvxhz7s8LSq9OHDut3WDnOB7aWF/eDu7n4/lGYvmuYSkORtw5IZkHFb5xlW2s4oXavFdcz4mY8Lnm68WSpONuI6qjCJ/A7ZK8xdCscKEyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FDJozuQHCSr3ZMNjAnIaJoaAehIXma1I+dSjgGlqGpU=;
 b=HFqoAnS4YenKgUDivwAEn0P8V52K+bW9cEiZgiU4mK79HvMeOJl0HOdp1s9PuKxdJY8dBzb/TXgrI8c3en94g2VGaMwlEqO3zQk8RH0C1xQ0BfsrXq5/ntRzEmhlMhFP9ua6erPxEkkEQMH91AdcQ3cbfgzpP+i+lJLdrvdT1unWPbxSOi3h4e84MpbCoDvEi9ILV9jSrzeI+1E0k9L9SZx9SxQc4L6VDL78/fdHmgZwYC/WVjo6y7AeCWTezLp+vxDHnXAU0nAmQ/aEAxolcewjAnkbFQIEj2E5OhM4div0KSBmMdjJFzhhJJi7polSTGzbvUEI0J467VpWbat9zA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FDJozuQHCSr3ZMNjAnIaJoaAehIXma1I+dSjgGlqGpU=;
 b=GuX984lnYDw4W3YMb1yfcPl09Jb9JIMr0H2YEsYFqvbRgu3divBiX6Tsl9i0Hk6csN9WtOCLuYblv7jy/ag9h8JLW06lxxlMCBGl9MdWmgY4iSoQgMEC7sOQuUqX/tZtuL9u3w7GpBOslTGeDYKev14r7VFUm1ZSOYnCvdxVo2nhUXMAj9w6DnXmz7dKVOVqCxpq0A0GpvS5qI8o5txHkMpAENzcOuX14e/W5JveoeFSsiwxjAePrkGCH5Fj6BNJC1hwqAe5DSke4Tj0J04NZTUh1MAp06ASdPpantmUAVoXw7jr3FEg5AWep6GeTIwTXvtlQwjIZVIR5RjnqC0lmA==
Received: from BN0PR08CA0014.namprd08.prod.outlook.com (2603:10b6:408:142::23)
 by DS0PR12MB7654.namprd12.prod.outlook.com (2603:10b6:8:11d::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Wed, 30 Nov
 2022 11:53:16 +0000
Received: from BN8NAM11FT032.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:142:cafe::5a) by BN0PR08CA0014.outlook.office365.com
 (2603:10b6:408:142::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23 via Frontend
 Transport; Wed, 30 Nov 2022 11:53:16 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN8NAM11FT032.mail.protection.outlook.com (10.13.177.88) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5857.17 via Frontend Transport; Wed, 30 Nov 2022 11:53:16 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Wed, 30 Nov
 2022 03:53:02 -0800
Received: from nps-server-23.mtl.labs.mlnx (10.126.231.35) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Wed, 30 Nov 2022 03:52:57 -0800
From:   Shay Drory <shayd@nvidia.com>
To:     <netdev@vger.kernel.org>, <kuba@kernel.org>, <davem@davemloft.net>
CC:     <danielj@nvidia.com>, <yishaih@nvidia.com>, <jiri@nvidia.com>,
        <saeedm@nvidia.com>, <parav@nvidia.com>
Subject: [PATCH net-next 7/8] devlink: Expose port function commands to control migratable
Date:   Wed, 30 Nov 2022 13:52:16 +0200
Message-ID: <20221130115217.7171-8-shayd@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BN8NAM11FT032:EE_|DS0PR12MB7654:EE_
X-MS-Office365-Filtering-Correlation-Id: acc0c921-c561-4983-ece2-08dad2c977a0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CI+zvDAsL5lZiOK6y7/pDXmmFVqQcd4RGfnyC3rdoVzaXOxtXXnCjsT9uRjJGHQd/QpOIKnxx1WKZRLFdOKc6ruUMVpCH4eOEIW+clxYJPqPwB5K5vApRCc2WbKzyImy7uhA9f6iDkOOyylC3scq17/KJPA+RHwr+nBWGXhDfXH9nRJaKXmha3NQ0jW+djksObwtuxecd6I8os2MpmR6I1jZMXQzvIRKAazjrEJaXqhnWh/NYwKDEhcQITwCSJ8ov6saFUvw9prcVML8gDu1Ag8J3KIetgMju/M4tbXT8l6Pe7wlEwUEW17PVx8IcL+P30n9SkomCwYF7NytObJJlEM7x3EoUEvlixefzi1l8dB7JBF0ZUeKBPPxcKn1IFir4gjR9ztLRXzJipATLhtiRCHmPhh03put843FsAnYsbxARxVpuxgONU1oCg1dBTIFEsznOu9H3438+sYN2Pg7qLsfOQ8e2Jj2bgysaQfeoM0BcJnRNGkmGc6KZGdDaJC5489n0FXVC09Ex3E+AHqTWWp7KiMbS64QPEhTZnJojPKoSMuqz/58OsCGGNm4gLYHmzJsE8MOl5kfh9Z8D985pOyVxLPxgJK9jO5LZYuIZ/wvFQ3SBXOC12ksEBgQfnNgEUkWrrfFePJ+GSA92222U+f+Dy4d/VeVakFMB2C42bXA8WJf4yMQs3B+C+AgENEHiTo1PXLKHXFiUoi2G9wQwA==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(346002)(136003)(376002)(396003)(39860400002)(451199015)(40470700004)(36840700001)(46966006)(2906002)(7636003)(41300700001)(36756003)(54906003)(70206006)(8676002)(36860700001)(40460700003)(110136005)(8936002)(70586007)(5660300002)(2616005)(26005)(16526019)(82310400005)(1076003)(86362001)(316002)(107886003)(6666004)(426003)(336012)(4326008)(186003)(356005)(83380400001)(40480700001)(82740400003)(478600001)(47076005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Nov 2022 11:53:16.1453
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: acc0c921-c561-4983-ece2-08dad2c977a0
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT032.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7654
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
---
 .../networking/devlink/devlink-port.rst       | 45 ++++++++++++++++
 include/net/devlink.h                         | 21 ++++++++
 include/uapi/linux/devlink.h                  |  1 +
 net/core/devlink.c                            | 54 +++++++++++++++++++
 4 files changed, 121 insertions(+)

diff --git a/Documentation/networking/devlink/devlink-port.rst b/Documentation/networking/devlink/devlink-port.rst
index 79f9c0390b47..b1b0ce50d9f1 100644
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
 
@@ -194,6 +197,48 @@ VF/SF driver cannot override it.
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
+- Bind VF to VFIO driver with migration support:
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
index 7f75100e8b26..8abffd9201d7 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -1454,6 +1454,27 @@ struct devlink_ops {
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
index c6f1fbe54095..f70201be0479 100644
--- a/include/uapi/linux/devlink.h
+++ b/include/uapi/linux/devlink.h
@@ -658,6 +658,7 @@ enum devlink_resource_unit {
 
 enum devlink_port_fn_attr_cap {
 	DEVLINK_PORT_FN_ATTR_CAP_ROCE,
+	DEVLINK_PORT_FN_ATTR_CAP_MIGRATABLE,
 
 	/* Add new caps above */
 	__DEVLINK_PORT_FN_ATTR_CAPS_MAX,
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 88846ad635a0..3fd47bbf891b 100644
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

