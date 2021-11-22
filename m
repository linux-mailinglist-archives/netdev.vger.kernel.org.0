Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0915459072
	for <lists+netdev@lfdr.de>; Mon, 22 Nov 2021 15:43:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235492AbhKVOqx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Nov 2021 09:46:53 -0500
Received: from mail-mw2nam10on2087.outbound.protection.outlook.com ([40.107.94.87]:6657
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239037AbhKVOqu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Nov 2021 09:46:50 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kWzWNvG2wIN8lwS/8i5KDrAESWbJLjlgA1MlpRGwd3iw4YeFWmYwdYzDxpeI+yyqDcyv0cImObtZ4Zjp00KbRuSvYZnkJO+SfD/k/x+ffaceSmFqoQyXWamrviERlx+o55EbCGx6JTmf40cYMgkG7A45vuIHakxNHBdBjR8IOVflVsM+wqoaIAHa8oPtl5QkawC+bxWMkZhpyhCAawXX1TpyJ7NWLyfZZGRnkH2Nr3mRdRpD0dbMRpI71sQqfs+5V6hizrDg4IuH4VW+CUTb3GPZW1LJj3MRoFr+qJ03Vqvojqh8Ujdb+Zy486/l6zsbJnFW4VOobe/SwmDUSY+yqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dcZtFmI/LaP48A97sgFGSaW/02qfj2OzJBgM5ov2P6Q=;
 b=Zfl7iFeN5bfFhLe1rdOD1Yr4ra6tYPpS4xcJ5nGEfa+m4bHVYLZeViC46ZUOJtiIfNh60KYpoJgdM3/00ke5Ab8KayeSnD+roHH/5SorhVoh8yah8IEJ+Wh87mIzuEUs3jR20ZZtsNdsCrCz/qFWIOk7qSlH0J/8Fvwcb6XBp6UqXv+FRfkXTBdRJbEFf6yhij61EWPDJIw9CDoZAZRIU3/I8yNTkSui620ZR7ID/hF5t3zu6/LueEpopTUH5dPkoLVtslqZqaK8jD2GH/L4JGk8tltJxEwR1db/dMwHvA0NYH3YsfOGuk3L9M0nFl1ilgz+Lc2BG18Q4xB2i2HMgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dcZtFmI/LaP48A97sgFGSaW/02qfj2OzJBgM5ov2P6Q=;
 b=JX1p9If3NaoHuZkRhfU9LbhirVs7asUQ67RwMt0ImCfkRzn5YlQcYSSd0RfYp6YUmQCenJHpnAnzet8Faxlp05116ALGhPyGSF98gb0jWMkG10JzGeAAGRSXkdv4zuC1LQ3hOHdfVGZpVMU1qvYaYIWC1tH4/jSxC1vpinoFH5q+Ro2j1vVfRY6oUrKXg+WgztAe/EYHpVMX47N+KA/g16YhCXT3qm3K8Qw8sEtZsLCfcnrMiUxxZyHEuBOS6zTEbVXw/G3q/p8cbQVkQaseg+BSE9tdEBg/ZQtPPyf3DpwcngT8cMptR4StTFc/6gR1pDSBTA+y3ZV93yjspFVFIQ==
Received: from DM6PR03CA0091.namprd03.prod.outlook.com (2603:10b6:5:333::24)
 by MN2PR12MB4253.namprd12.prod.outlook.com (2603:10b6:208:1de::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.19; Mon, 22 Nov
 2021 14:43:42 +0000
Received: from DM6NAM11FT053.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:333:cafe::9) by DM6PR03CA0091.outlook.office365.com
 (2603:10b6:5:333::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.22 via Frontend
 Transport; Mon, 22 Nov 2021 14:43:42 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT053.mail.protection.outlook.com (10.13.173.74) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4713.20 via Frontend Transport; Mon, 22 Nov 2021 14:43:41 +0000
Received: from mtx-w2012r202.mtx.labs.mlnx (172.20.187.5) by
 HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1497.18; Mon, 22 Nov 2021 14:43:40 +0000
From:   Sunil Rani <sunrani@nvidia.com>
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <parav@nvidia.com>, <jiri@nvidia.com>, <saeedm@nvidia.com>,
        Sunil Rani <sunrani@nvidia.com>,
        Bodong Wang <bodong@nvidia.com>
Subject: [PATCH net-next 1/2] devlink: Add support to set port function as trusted
Date:   Mon, 22 Nov 2021 16:43:06 +0200
Message-ID: <20211122144307.218021-2-sunrani@nvidia.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211122144307.218021-1-sunrani@nvidia.com>
References: <20211122144307.218021-1-sunrani@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a492b4ed-8e77-4d41-3f44-08d9adc67a7f
X-MS-TrafficTypeDiagnostic: MN2PR12MB4253:
X-Microsoft-Antispam-PRVS: <MN2PR12MB42535EED8A613DDF796DA1E6D49F9@MN2PR12MB4253.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3968;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nwwjh51muQ9e/5ryCdoSMpewYMFzo99Dxs9c+wY5c3yD+7jUQV+Eb5cXjbu6u7XyU14sRxhJIX+ILOqRnK/gsrSDQo3nVL6Hn7aTcNJv7v8kHDSptTI3up85Yx+zQRtIbDQiy4BffXdwGq25nfjN/QA8BzBp9+N+5u1QGvVUgPqLIBpjs6mve3WlLzzgiRRTN0rGIWuE3YwMJyyf6uaqsxNKsPTSLilcQztWbZK/YYsdURmr9Vy465fibhuwxUehk/1mj7MIHwCZakXjAfD9pcQgBp/dZa+EjUq5KdZtubXPhsFUZKNoAAFG2b3F9Kn0+zw4/Tv9+Qck35/CiwTQBQAQwW6bNvhOe1ksPeAtJTrviC/Hwd6bbP1sBk0CSOMfdJ/tub5Rej/YL5hoep95PixNEVAjTCsTaawC+z0tJLfp7RsDcaM2sIGmTEOYDefv2lHYMnttqvSIovYzT3NdcVrPDNguH+S6HHabw0u11xzoshTiwbBQb1CQph96vJ5FNPGc2/PjzLv5/JPyGO/Cis/LWrCbAbUdr0fDaxr3Tdyxp/NjouDBRfhORz7aMlFMqI4wV/ZBiyhy4QsYHgp+MV85PYd7T630F/LXTdO1S8E7966Uyl+bKOu/yd3GzUpneQCxdrDIQDZC9s2b65/WSiWXTbyH0qzLuLe6TNEGt8sFBRplsza4JHOGsYc4kINZXw7y47Wjun/bi9DxgicPBouUgfHpSNjnfLUT4VCR/nE=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(107886003)(508600001)(426003)(83380400001)(6666004)(2616005)(1076003)(70586007)(70206006)(186003)(36906005)(26005)(2906002)(316002)(4326008)(5660300002)(86362001)(8936002)(356005)(16526019)(54906003)(110136005)(82310400003)(36860700001)(36756003)(8676002)(336012)(47076005)(7636003)(461764006);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Nov 2021 14:43:41.7886
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a492b4ed-8e77-4d41-3f44-08d9adc67a7f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT053.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4253
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support to mark a given PCI sub-function (SF) or
Virtual function (VF) as a trusted function. The device/firmware
decides how to define privileges and access to resources.
These functions by default are in untrusted mode.

Examples of add, set a function as trusted and show commands:
$ devlink port add pci/0000:08:00.0 flavour pcisf pfnum 0 sfnum 88
pci/0000:08:00.0/32768: type eth netdev eth6 flavour pcisf controller 0 pfnum 0 sfnum 88 splittable false
  function:
    hw_addr 00:00:00:00:00:00 state inactive opstate detached trusted false

$ devlink port function set pci/0000:08:00.0/32768 trusted true

$ devlink port show pci/0000:08:00.0/32768
pci/0000:08:00.0/32768: type eth netdev eth6 flavour pcisf controller 0 pfnum 0 sfnum 88 splittable false
  function:
    hw_addr 00:00:00:00:00:00 state inactive opstate detached trusted true

Signed-off-by: Sunil Rani <sunrani@nvidia.com>
Signed-off-by: Bodong Wang <bodong@nvidia.com>
Reviewed-by: Parav Pandit <parav@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
 .../networking/devlink/devlink-port.rst       |  4 ++
 include/net/devlink.h                         | 22 ++++++++
 include/uapi/linux/devlink.h                  |  1 +
 net/core/devlink.c                            | 55 +++++++++++++++++++
 4 files changed, 82 insertions(+)

diff --git a/Documentation/networking/devlink/devlink-port.rst b/Documentation/networking/devlink/devlink-port.rst
index 7627b1da01f2..bedd9cd411be 100644
--- a/Documentation/networking/devlink/devlink-port.rst
+++ b/Documentation/networking/devlink/devlink-port.rst
@@ -122,6 +122,10 @@ A user may set the hardware address of the function using
 'devlink port function set hw_addr' command. For Ethernet port function
 this means a MAC address.
 
+A user can set a function as trusted so that a function has the additional
+privileges. One example is to allow trusted function to query and operate
+the steering database similar to the switchdev device.
+
 Subfunction
 ============
 
diff --git a/include/net/devlink.h b/include/net/devlink.h
index aab3d007c577..c82b2113d6fd 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -1461,6 +1461,28 @@ struct devlink_ops {
 				 enum devlink_port_fn_state state,
 				 struct netlink_ext_ack *extack);
 
+	/**
+	 * port_fn_trusted_get() - Get the trusted state of port function
+	 * @port: The devlink port
+	 * @trusted: Query privilege state
+	 * @extack: extack for reporting error messages
+	 *
+	 * Return: 0 on success, negative value otherwise.
+	 */
+	int (*port_fn_trusted_get)(struct devlink_port *port,
+				   bool *trusted,
+				   struct netlink_ext_ack *extack);
+	/**
+	 * port_fn_trusted_set() - Set the trusted state of port function
+	 * @port: The devlink port
+	 * @trusted: Set privilege state
+	 * @extack: extack for reporting error messages
+	 *
+	 * Return: 0 on success, negative value otherwise.
+	 */
+	int (*port_fn_trusted_set)(struct devlink_port *port,
+				   bool trusted,
+				   struct netlink_ext_ack *extack);
 	/**
 	 * Rate control callbacks.
 	 */
diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
index b897b80770f6..36624a356478 100644
--- a/include/uapi/linux/devlink.h
+++ b/include/uapi/linux/devlink.h
@@ -604,6 +604,7 @@ enum devlink_port_function_attr {
 	DEVLINK_PORT_FUNCTION_ATTR_HW_ADDR,	/* binary */
 	DEVLINK_PORT_FN_ATTR_STATE,	/* u8 */
 	DEVLINK_PORT_FN_ATTR_OPSTATE,	/* u8 */
+	DEVLINK_PORT_FN_ATTR_TRUSTED,	/* u8 */
 
 	__DEVLINK_PORT_FUNCTION_ATTR_MAX,
 	DEVLINK_PORT_FUNCTION_ATTR_MAX = __DEVLINK_PORT_FUNCTION_ATTR_MAX - 1
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 5ba4f9434acd..6aaa3a67194a 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -147,6 +147,7 @@ static const struct nla_policy devlink_function_nl_policy[DEVLINK_PORT_FUNCTION_
 	[DEVLINK_PORT_FN_ATTR_STATE] =
 		NLA_POLICY_RANGE(NLA_U8, DEVLINK_PORT_FN_STATE_INACTIVE,
 				 DEVLINK_PORT_FN_STATE_ACTIVE),
+	[DEVLINK_PORT_FN_ATTR_TRUSTED] = { .type = NLA_U8 },
 };
 
 static DEFINE_XARRAY_FLAGS(devlinks, XA_FLAGS_ALLOC);
@@ -986,6 +987,31 @@ devlink_port_fn_opstate_valid(enum devlink_port_fn_opstate opstate)
 	       opstate == DEVLINK_PORT_FN_OPSTATE_ATTACHED;
 }
 
+static int devlink_port_fn_trusted_fill(const struct devlink_ops *ops,
+					struct devlink_port *port,
+					struct sk_buff *msg,
+					struct netlink_ext_ack *extack,
+					bool *msg_updated)
+{
+	bool trusted;
+	int err;
+
+	if (!ops->port_fn_trusted_get)
+		return 0;
+
+	err = ops->port_fn_trusted_get(port, &trusted, extack);
+	if (err) {
+		if (err == -EOPNOTSUPP)
+			return 0;
+		return err;
+	}
+
+	if (nla_put_u8(msg, DEVLINK_PORT_FN_ATTR_TRUSTED, trusted))
+		return -EMSGSIZE;
+	*msg_updated = true;
+	return 0;
+}
+
 static int devlink_port_fn_state_fill(const struct devlink_ops *ops,
 				      struct devlink_port *port,
 				      struct sk_buff *msg,
@@ -1042,6 +1068,9 @@ devlink_nl_port_function_attrs_put(struct sk_buff *msg, struct devlink_port *por
 	if (err)
 		goto out;
 	err = devlink_port_fn_state_fill(ops, port, msg, extack, &msg_updated);
+	if (err)
+		goto out;
+	err = devlink_port_fn_trusted_fill(ops, port, msg, extack, &msg_updated);
 out:
 	if (err || !msg_updated)
 		nla_nest_cancel(msg, function_attr);
@@ -1434,6 +1463,25 @@ static int devlink_port_function_hw_addr_set(struct devlink_port *port,
 					      extack);
 }
 
+static int devlink_port_fn_trusted_set(struct devlink_port *port,
+				       const struct nlattr *attr,
+				       struct netlink_ext_ack *extack)
+{
+	const struct devlink_ops *ops;
+	bool trusted;
+
+	if (nla_get_u8(attr) > 1)
+		return -EINVAL;
+
+	trusted = nla_get_u8(attr);
+	ops = port->devlink->ops;
+	if (!ops->port_fn_trusted_set) {
+		NL_SET_ERR_MSG_MOD(extack, "Function does not support trust setting");
+		return -EOPNOTSUPP;
+	}
+	return ops->port_fn_trusted_set(port, trusted, extack);
+}
+
 static int devlink_port_fn_state_set(struct devlink_port *port,
 				     const struct nlattr *attr,
 				     struct netlink_ext_ack *extack)
@@ -1471,6 +1519,13 @@ static int devlink_port_function_set(struct devlink_port *port,
 		if (err)
 			return err;
 	}
+
+	attr = tb[DEVLINK_PORT_FN_ATTR_TRUSTED];
+	if (attr) {
+		err = devlink_port_fn_trusted_set(port, attr, extack);
+		if (err)
+			return err;
+	}
 	/* Keep this as the last function attribute set, so that when
 	 * multiple port function attributes are set along with state,
 	 * Those can be applied first before activating the state.
-- 
2.26.2

