Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F7B96C6634
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 12:12:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231335AbjCWLML (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 07:12:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229800AbjCWLMB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 07:12:01 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2049.outbound.protection.outlook.com [40.107.92.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 657B11C5BB
        for <netdev@vger.kernel.org>; Thu, 23 Mar 2023 04:11:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fuIvV8JpYjHmEey8OM7Yknu5Ih4C6rJDTsewwl47zaIWo5FKO37/jaFppFx4L6tmlxHX474eDrbMrWAqXdEini1d3g4Zjog/Zrigl7Bc58Phq0xxqJMg55z5K+hWeSOmoklsIdbkvS9oPpMBiDKLK3mkygh8JZMosVjd6odjR1kE+REhIo/Ag9Cgrrl/N/y4NHxykMbUAOtmFSojDFLSdkOgyMo//mm5n9JOoeRMp+IjVbvaeUNoGqAdfQ8a/XrIqek2yEdgwbwvEbyETX64OZAVWXaDPnryDNWwFYUFuJyqZsMfzOryPJEfLs3GXCwGsiNcXGv56OjW0q5+Ms9TiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eswZTtlcQgQCRXR85SavX8OTDA8g1VN/gIkigQkvsyM=;
 b=PfbXPpTTHqqde/+L3NJ2ypW8ckJ7wjtFl3hcWTqLZVUTtnxGddk78Z6pwROdAU129PGYGQnUg6BT0BrqxBgJCOlNBlqrQs7FWh994oyIBDjpyD9n6hp1ozJuxTIZw35OEy26PlU2Fj655Np9vQ7iwrKg+DWuT34ZGQqrk7pvMNKKfmJV6jZ8Qwc6xtMORD8VhQZjgvmIamun0kIxAkHGGXzpp3A8uYdmJ1uMf5oT/+OS2RrjyNYXfzmDL1sPxxuPWdyEvNAe7mLJkMzbs+k/2zKqwvEFxHK4laLR9Bl+XVzf7QEsb/IsVtDobPyj1hAJHvBH2sJMI1VAiz6KvZgYsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eswZTtlcQgQCRXR85SavX8OTDA8g1VN/gIkigQkvsyM=;
 b=Z65JJhpoj/ij3DY7oAkrUAnhGRWVNAl0dfr4cknFa8htVpxhUhbnqIJnMI5ZIp9tzDjapUfDicltaR6kvA8vUfJWMftZv9lFZ7qRMC0ba584s7JOXsvV8+PnGFvKLIN5rWDBEe9HkWGPs1lbhPf4v6DYZsoznEkKdRuq/+6d/VTpHoHtwuTFXGwH/KpnPsg80wa1lJhNxgYtCl6am/qGIiFkvrYB4y8x1IfL9liDdixPSTu9vPw2mT3btF2v2PH+EXQ8vChiB7BMUOTuRj+ydjj9VuxBn3HRocpVzISJpcX97QewsHbU8ybz+htfjjRqLsRq1w0pO0JEPHe/G3PWsA==
Received: from DM6PR14CA0046.namprd14.prod.outlook.com (2603:10b6:5:18f::23)
 by CH0PR12MB5107.namprd12.prod.outlook.com (2603:10b6:610:be::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.38; Thu, 23 Mar
 2023 11:11:56 +0000
Received: from DS1PEPF0000E64C.namprd02.prod.outlook.com
 (2603:10b6:5:18f:cafe::48) by DM6PR14CA0046.outlook.office365.com
 (2603:10b6:5:18f::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.38 via Frontend
 Transport; Thu, 23 Mar 2023 11:11:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DS1PEPF0000E64C.mail.protection.outlook.com (10.167.18.42) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.30 via Frontend Transport; Thu, 23 Mar 2023 11:11:56 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Thu, 23 Mar 2023
 04:11:48 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Thu, 23 Mar
 2023 04:11:48 -0700
Received: from vdi.nvidia.com (10.127.8.13) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.986.5 via Frontend Transport; Thu, 23 Mar
 2023 04:11:45 -0700
From:   Dima Chumak <dchumak@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Jiri Pirko <jiri@resnulli.us>,
        Leon Romanovsky <leon@kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>, <netdev@vger.kernel.org>,
        Dima Chumak <dchumak@nvidia.com>, Jiri Pirko <jiri@nvidia.com>
Subject: [PATCH net-next 3/4] devlink: Expose port function commands to control IPsec packet offloads
Date:   Thu, 23 Mar 2023 13:10:58 +0200
Message-ID: <20230323111059.210634-4-dchumak@nvidia.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230323111059.210634-1-dchumak@nvidia.com>
References: <20230323111059.210634-1-dchumak@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1PEPF0000E64C:EE_|CH0PR12MB5107:EE_
X-MS-Office365-Filtering-Correlation-Id: 70459d81-0ab2-49b4-0633-08db2b8f6a41
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BLUwfF/nAFGP27gpBQlWKhFZeB6kw6a/aObolj2sHdgrAdv/YjZidXgJyaj3ja2YXzagsFtR8BBKJ/q44fJquOaAZ6gITbixqydZ1pb+pJ85aJ8ZIG4ohSwYOp1+y8c0X0K4ORraJTgL3vczryK7QFbLpCXDjQIOnAUsB0uWhX0hjKHq9bzcDPcK2mG4AuwLmSIjTWgPc/yGg/HwcGBbt+kG0DaEO0bHMJZGdoHPDPKxW8Jm7dZqUHAuxoyspRtKv3jVX6g0ceeA1HXVPGxlPoaAi6JrMad1Usld5NTQU1rlFrvYt8CzBRhXgrQnUqbu3SwDGyr9bnfyPEQoYJFRUzHI2gz7+3+VjRlEtYSuvFS2Ny6IBzOP8zsi88MDrFksV7GzBmZI+k6E0fVnigH67mi/UeMU/5Tjmc6w8abgH+1a29If7/gLFlsJVLnB71DKarDOXmajFprgzwnA0mffYvNLMqiY/ylszo7KVfjlqZ/hiavDHFw/jWn/+UonIIPAgoe/Q7dgdSAZG04c61373CxlIT3a+tRREDu73eHdwPWc7OektxKL68CofE454grV7Wt+JIMY7GTsrIzNBxAn7lDNbw+Ie4thf5ZewZCDxw6nAHwL3ZeZuFs+b0ucsnooBAD403yd7PWwwQPp/gI2j3kxmOjfTOG2ozcXH6QQYIKRwiVu7H1Z4u0h6ZruWsCcTD4vNcYkYhAwVopB4M7f+dDUy7Hfjxjn2srV1K1mMzz7wTGqYKWdf5hmACrUynLA
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(376002)(136003)(346002)(396003)(451199018)(40470700004)(46966006)(36840700001)(40460700003)(4326008)(6916009)(70206006)(70586007)(8676002)(36860700001)(316002)(54906003)(5660300002)(7636003)(82740400003)(41300700001)(8936002)(1076003)(26005)(426003)(47076005)(107886003)(6666004)(2616005)(336012)(186003)(83380400001)(478600001)(7696005)(86362001)(82310400005)(36756003)(40480700001)(356005)(2906002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2023 11:11:56.4458
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 70459d81-0ab2-49b4-0633-08db2b8f6a41
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DS1PEPF0000E64C.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5107
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Expose port function commands to enable / disable IPsec packet offloads,
this is used to control the port IPsec capabilities.

When IPsec is disabled for a function of the port (default), function
cannot offload any IPsec packet operations. When enabled, IPsec packet
operations can be offloaded by the function of the port.

Example of a PCI VF port which supports IPsec packet offloads:

$ devlink port show pci/0000:06:00.0/1
    pci/0000:06:00.0/1: type eth netdev enp6s0pf0vf0 flavour pcivf pfnum 0 vfnum 0
        function:
        hw_addr 00:00:00:00:00:00 roce enable ipsec_packet disable

$ devlink port function set pci/0000:06:00.0/1 ipsec_packet enable

$ devlink port show pci/0000:06:00.0/1
    pci/0000:06:00.0/1: type eth netdev enp6s0pf0vf0 flavour pcivf pfnum 0 vfnum 0
        function:
        hw_addr 00:00:00:00:00:00 roce enable ipsec_packet enable

Signed-off-by: Dima Chumak <dchumak@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
 .../networking/devlink/devlink-port.rst       | 27 +++++++++
 include/net/devlink.h                         | 21 +++++++
 include/uapi/linux/devlink.h                  |  2 +
 net/devlink/leftover.c                        | 55 +++++++++++++++++++
 4 files changed, 105 insertions(+)

diff --git a/Documentation/networking/devlink/devlink-port.rst b/Documentation/networking/devlink/devlink-port.rst
index e7c7482714d7..05d95cf95284 100644
--- a/Documentation/networking/devlink/devlink-port.rst
+++ b/Documentation/networking/devlink/devlink-port.rst
@@ -131,6 +131,9 @@ Users may also set the function as migratable using
 Users may also set the IPsec crypto capability of the function using
 `devlink port function set ipsec_crypto` command.
 
+Users may also set the IPsec packet capability of the function using
+`devlink port function set ipsec_packet` command.
+
 Function attributes
 ===================
 
@@ -267,6 +270,30 @@ processed in software by the kernel.
         function:
             hw_addr 00:00:00:00:00:00 ipsec_crypto enabled
 
+IPsec packet capability setup
+-----------------------------
+When user enables IPsec packet capability for a VF, user application can offload
+XFRM state to this VF.
+
+When IPsec packet capability is disabled (default) for a VF, the XFRM state is
+processed in software by the kernel.
+
+- Get IPsec packet capability of the VF device::
+
+    $ devlink port show pci/0000:06:00.0/2
+    pci/0000:06:00.0/2: type eth netdev enp6s0pf0vf1 flavour pcivf pfnum 0 vfnum 1
+        function:
+            hw_addr 00:00:00:00:00:00 ipsec_packet disabled
+
+- Set IPsec packet capability of the VF device::
+
+    $ devlink port function set pci/0000:06:00.0/2 ipsec_packet enable
+
+    $ devlink port show pci/0000:06:00.0/2
+    pci/0000:06:00.0/2: type eth netdev enp6s0pf0vf1 flavour pcivf pfnum 0 vfnum 1
+        function:
+            hw_addr 00:00:00:00:00:00 ipsec_packet enabled
+
 Subfunction
 ============
 
diff --git a/include/net/devlink.h b/include/net/devlink.h
index 4e5f4aeca29d..772453b36c20 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -1516,6 +1516,27 @@ struct devlink_ops {
 	int (*port_fn_ipsec_crypto_set)(struct devlink_port *devlink_port,
 				      bool enable,
 				      struct netlink_ext_ack *extack);
+	/**
+	 * @port_fn_ipsec_packet_get: Port function's ipsec_packet get function.
+	 *
+	 * Query ipsec_packet state of a function managed by the devlink port.
+	 * Return -EOPNOTSUPP if port function IPsec packet offload is not
+	 * supported.
+	 */
+	int (*port_fn_ipsec_packet_get)(struct devlink_port *devlink_port,
+					bool *is_enable,
+					struct netlink_ext_ack *extack);
+	/**
+	 * @port_fn_ipsec_packet_set: Port function's ipsec_packet set function.
+	 *
+	 * Enable/Disable ipsec_packet state of a function managed by the devlink
+	 * port.
+	 * Return -EOPNOTSUPP if port function IPsec packet offload is not
+	 * supported.
+	 */
+	int (*port_fn_ipsec_packet_set)(struct devlink_port *devlink_port,
+					bool enable,
+					struct netlink_ext_ack *extack);
 	/**
 	 * port_new() - Add a new port function of a specified flavor
 	 * @devlink: Devlink instance
diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
index f9ae9a058ad2..03875e078be8 100644
--- a/include/uapi/linux/devlink.h
+++ b/include/uapi/linux/devlink.h
@@ -662,6 +662,7 @@ enum devlink_port_fn_attr_cap {
 	DEVLINK_PORT_FN_ATTR_CAP_ROCE_BIT,
 	DEVLINK_PORT_FN_ATTR_CAP_MIGRATABLE_BIT,
 	DEVLINK_PORT_FN_ATTR_CAP_IPSEC_CRYPTO_BIT,
+	DEVLINK_PORT_FN_ATTR_CAP_IPSEC_PACKET_BIT,
 
 	/* Add new caps above */
 	__DEVLINK_PORT_FN_ATTR_CAPS_MAX,
@@ -671,6 +672,7 @@ enum devlink_port_fn_attr_cap {
 #define DEVLINK_PORT_FN_CAP_MIGRATABLE \
 	_BITUL(DEVLINK_PORT_FN_ATTR_CAP_MIGRATABLE_BIT)
 #define DEVLINK_PORT_FN_CAP_IPSEC_CRYPTO _BITUL(DEVLINK_PORT_FN_ATTR_CAP_IPSEC_CRYPTO_BIT)
+#define DEVLINK_PORT_FN_CAP_IPSEC_PACKET _BITUL(DEVLINK_PORT_FN_ATTR_CAP_IPSEC_PACKET_BIT)
 
 enum devlink_port_function_attr {
 	DEVLINK_PORT_FUNCTION_ATTR_UNSPEC,
diff --git a/net/devlink/leftover.c b/net/devlink/leftover.c
index 07761df2471d..8cadfeb285a9 100644
--- a/net/devlink/leftover.c
+++ b/net/devlink/leftover.c
@@ -515,6 +515,29 @@ static int devlink_port_fn_ipsec_crypto_fill(const struct devlink_ops *ops,
 	return 0;
 }
 
+static int devlink_port_fn_ipsec_packet_fill(const struct devlink_ops *ops,
+					     struct devlink_port *devlink_port,
+					     struct nla_bitfield32 *caps,
+					     struct netlink_ext_ack *extack)
+{
+	bool is_enable;
+	int err;
+
+	if (!ops->port_fn_ipsec_packet_get ||
+	    devlink_port->attrs.flavour != DEVLINK_PORT_FLAVOUR_PCI_VF)
+		return 0;
+
+	err = ops->port_fn_ipsec_packet_get(devlink_port, &is_enable, extack);
+	if (err) {
+		if (err == -EOPNOTSUPP)
+			return 0;
+		return err;
+	}
+
+	devlink_port_fn_cap_fill(caps, DEVLINK_PORT_FN_CAP_IPSEC_PACKET, is_enable);
+	return 0;
+}
+
 static int devlink_port_fn_caps_fill(const struct devlink_ops *ops,
 				     struct devlink_port *devlink_port,
 				     struct sk_buff *msg,
@@ -536,6 +559,10 @@ static int devlink_port_fn_caps_fill(const struct devlink_ops *ops,
 	if (err)
 		return err;
 
+	err = devlink_port_fn_ipsec_packet_fill(ops, devlink_port, &caps, extack);
+	if (err)
+		return err;
+
 	if (!caps.selector)
 		return 0;
 	err = nla_put_bitfield32(msg, DEVLINK_PORT_FN_ATTR_CAPS, caps.value,
@@ -879,6 +906,15 @@ devlink_port_fn_ipsec_crypto_set(struct devlink_port *devlink_port, bool enable,
 	return ops->port_fn_ipsec_crypto_set(devlink_port, enable, extack);
 }
 
+static int
+devlink_port_fn_ipsec_packet_set(struct devlink_port *devlink_port, bool enable,
+				 struct netlink_ext_ack *extack)
+{
+	const struct devlink_ops *ops = devlink_port->devlink->ops;
+
+	return ops->port_fn_ipsec_packet_set(devlink_port, enable, extack);
+}
+
 static int devlink_port_fn_caps_set(struct devlink_port *devlink_port,
 				    const struct nlattr *attr,
 				    struct netlink_ext_ack *extack)
@@ -910,6 +946,13 @@ static int devlink_port_fn_caps_set(struct devlink_port *devlink_port,
 		if (err)
 			return err;
 	}
+	if (caps.selector & DEVLINK_PORT_FN_CAP_IPSEC_PACKET) {
+		err = devlink_port_fn_ipsec_packet_set(devlink_port, caps_value &
+						       DEVLINK_PORT_FN_CAP_IPSEC_PACKET,
+						       extack);
+		if (err)
+			return err;
+	}
 	return 0;
 }
 
@@ -1290,6 +1333,18 @@ static int devlink_port_function_validate(struct devlink_port *devlink_port,
 				return -EOPNOTSUPP;
 			}
 		}
+		if (caps.selector & DEVLINK_PORT_FN_CAP_IPSEC_PACKET) {
+			if (!ops->port_fn_ipsec_packet_set) {
+				NL_SET_ERR_MSG_ATTR(extack, attr,
+						    "Port doesn't support ipsec_packet function attribute");
+				return -EOPNOTSUPP;
+			}
+			if (devlink_port->attrs.flavour != DEVLINK_PORT_FLAVOUR_PCI_VF) {
+				NL_SET_ERR_MSG_ATTR(extack, attr,
+						    "ipsec_packet function attribute supported for VFs only");
+				return -EOPNOTSUPP;
+			}
+		}
 	}
 	return 0;
 }
-- 
2.40.0

