Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD83F6EA89A
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 12:50:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231542AbjDUKuA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 06:50:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229825AbjDUKtv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 06:49:51 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2077.outbound.protection.outlook.com [40.107.102.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5572B6E92
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 03:49:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QQQJnBnaRsNWkZiLsyOMJ/SGKTwd32o26DcLeCWsFQ6CVkMSOIVuE54fLNQPh9mXj+CVcm6VpO9IaRW+jt4N0eH/JjEPXpQsYc6bf6gvIrIdq8RcberZkAnfwpEImBAxZfVHoKa7ydQWgIJx7S2BHSypMcclkzwWMOY8rUgZA8HO2ag2I0sakGQRjOscoL7yi15xWyx/pSqyjsNH07wSFtXz5bepwWDs4hruKiVJ+tbK8KFbyjemYoLp1WQfqg1w+yQD9uePyK/hi43fVpp30oDniGJNXB+NJwNoCzNoh0MaI1dyYVSmFLEg0SoZAsEBs81qq48mj8/JxjlRdM9NXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h/8fzqFBSSJ1v1rH0wsmzXvevh0TGzu+UtY3Pmgutt0=;
 b=WpCNs/C75eUJcmn8RjbUzNCTxIYloD9+UlxwjX3SggjPXB7fJLNw+zFN9yrhtLEDMs0CSKYDhHyNImUSuqIStTqe2kCAM96MwWxAh1JR/sHu/vFTVhsM4Sa4Bxff6qgetRFDQy456ma9sSunzNfanEr6okSl/F74lnE984QOe4j+CgDT5blqV+rwjrA/i6gDC5qw650QNfQW2LrLhYTRDjwLdFi+wP2bvX3e2jA7pNPHSarFBW2oCKeELvCv1mg8u9bGMluYgNN+uxni+qT9g57H1fnVqPqqNEjQ48/NsAvgDt3QuixS5qmQ7F0ebeHyIZSeN/pjEwN0hVjPrw6s5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h/8fzqFBSSJ1v1rH0wsmzXvevh0TGzu+UtY3Pmgutt0=;
 b=CHOfZZmAu5S8MNgmmDAJu4H92VDKJnK3vw/JeT+PvoaUb6VYOIcCDbC51v2tHHhYgIAg9bhxh58JNGxvmEwzowxVLJqdWxZHZrhjtjhtUuGpYAm+pGbAhm1Wd99JNa3/c/6WuyN7a1y7xbKwYiNOeiaZV5cXdo6vypbA3WnhJli50JWWMmcQWGKIpQVEo9vm21M++U0fgB2+oGwfbstPEyKkshxHZrN2AlobyDvj0g8OoOoMnUN0O+fg3u8D4mH5wJrmfVCrFB+47J+WDWQH2ZKz0pLTuyzAB2MCSkMJxR39g84D8UnfY59NG/MpV6kijVnadcC932Kch7q0dCfk8A==
Received: from BN1PR13CA0030.namprd13.prod.outlook.com (2603:10b6:408:e2::35)
 by MN0PR12MB5905.namprd12.prod.outlook.com (2603:10b6:208:379::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.30; Fri, 21 Apr
 2023 10:49:48 +0000
Received: from BN8NAM11FT085.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:e2:cafe::43) by BN1PR13CA0030.outlook.office365.com
 (2603:10b6:408:e2::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.11 via Frontend
 Transport; Fri, 21 Apr 2023 10:49:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 BN8NAM11FT085.mail.protection.outlook.com (10.13.176.100) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6319.27 via Frontend Transport; Fri, 21 Apr 2023 10:49:47 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Fri, 21 Apr 2023
 03:49:41 -0700
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.37; Fri, 21 Apr 2023 03:49:40 -0700
Received: from vdi.nvidia.com (10.127.8.13) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.986.37 via Frontend
 Transport; Fri, 21 Apr 2023 03:49:38 -0700
From:   Dima Chumak <dchumak@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>
CC:     <netdev@vger.kernel.org>, Jiri Pirko <jiri@resnulli.us>,
        Leon Romanovsky <leon@kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Dima Chumak <dchumak@nvidia.com>, Jiri Pirko <jiri@nvidia.com>
Subject: [PATCH net-next V2 3/4] devlink: Expose port function commands to control IPsec packet offloads
Date:   Fri, 21 Apr 2023 13:49:00 +0300
Message-ID: <20230421104901.897946-4-dchumak@nvidia.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230421104901.897946-1-dchumak@nvidia.com>
References: <20230421104901.897946-1-dchumak@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT085:EE_|MN0PR12MB5905:EE_
X-MS-Office365-Filtering-Correlation-Id: 760624b5-0dae-49b1-9925-08db4256206e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: G7HlM5XQvX35ZwsIbSiPt2WqQk5BVnBtnWpWNcJfWnAJpqNI0JsOtijShSHu0cvl7ZzeQSirhO2gy1IFZNC/ZKPmg+tsDeQBk9jt6IQ2f0Kv+lyTGJlmxDi65oMlcN8Isr/M87cQZADywd241vjISHaqPIayMkqWFIV5yIPp3qvn1QFAYWF9B8wkJBsFbVnYPBTXQsHq+Xl7BuWSHv9TjG7vVTISLvUp410MmLNiiOjeE6ixFZogHIbcSx7UogFfuSIQBUP3xeEit4RgX7+CXxpxbnIuOThKdkDTBFbmxX5CMBdaBKdwer97+uY+zvuoPaswsQ1kas9A5Wl0dVYu9t9K4umoRoa4R9cdG2GvX/OiCm3FHEK7lApzAfaXLBi0d2oy5J8podOFU7C/DhIWGQrYdAB/7HI16qpaiDrsi9+vkpGLRpUduJjJspSXE+9jjJbmTvH0VZYxWulAJQLxyLhwbifLvP2n9Bs+hw4ASgMNDKleR6QEDvLKrgwN6/Pk9HPg0Tn1HI0n6+OnEw1lVOUTt/aH7cF3gPmySSW8wcqIB5siudptmA7nxkkhM/Da5zbStkYcwUP3HH/BRDMULrlZISB4ueVcCQiKqa6/kA4tV4H6NBxnhtqEWRGesS+MhWtBdD1i7qLn114FiEufw5DxVirogO5DuLVi/XtalAqvhQAgKVBCMCEm2cB/cwggVYHcH4CcnVJdDAjdLXEIqIda+PNO+4u+jlshB8VVdpT5jmDpxDR5eIXRDoFJg05J4hYjs/RyYW4c0sg9N5gjV5lKjaX6gOzDw5QYN7PSKtk=
X-Forefront-Antispam-Report: CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(396003)(39860400002)(346002)(136003)(376002)(451199021)(40470700004)(36840700001)(46966006)(5660300002)(7696005)(40460700003)(2906002)(4326008)(70206006)(36756003)(70586007)(8936002)(41300700001)(6666004)(7636003)(356005)(316002)(82310400005)(8676002)(34020700004)(86362001)(478600001)(82740400003)(40480700001)(54906003)(110136005)(1076003)(26005)(426003)(336012)(36860700001)(107886003)(83380400001)(186003)(2616005)(47076005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2023 10:49:47.9922
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 760624b5-0dae-49b1-9925-08db4256206e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT085.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5905
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

Expose port function commands to enable / disable IPsec packet offloads,
this is used to control the port IPsec capabilities.

When IPsec packet is disabled for a function of the port (default),
function cannot offload IPsec packet operations (encapsulation and XFRM
policy offload). When enabled, IPsec packet operations can be offloaded
by the function of the port, which includes crypto operation
(Encrypt/Decrypt), IPsec encapsulation and XFRM state and policy
offload.

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
 .../networking/devlink/devlink-port.rst       | 28 ++++++++++
 include/net/devlink.h                         | 21 +++++++
 include/uapi/linux/devlink.h                  |  2 +
 net/devlink/leftover.c                        | 55 +++++++++++++++++++
 4 files changed, 106 insertions(+)

diff --git a/Documentation/networking/devlink/devlink-port.rst b/Documentation/networking/devlink/devlink-port.rst
index 6983b11559cb..f5adb910427a 100644
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
 
@@ -267,6 +270,31 @@ processed in software by the kernel.
         function:
             hw_addr 00:00:00:00:00:00 ipsec_crypto enabled
 
+IPsec packet capability setup
+-----------------------------
+When user enables IPsec packet capability for a VF, user application can offload
+XFRM state and policy crypto operation (Encrypt/Decrypt) to this VF, as well as
+IPsec encapsulation.
+
+When IPsec packet capability is disabled (default) for a VF, the XFRM state and
+policy is processed in software by the kernel.
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

