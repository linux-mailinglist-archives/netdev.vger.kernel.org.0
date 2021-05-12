Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3438637C0A4
	for <lists+netdev@lfdr.de>; Wed, 12 May 2021 16:49:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231439AbhELOux (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 May 2021 10:50:53 -0400
Received: from mail-dm6nam11on2045.outbound.protection.outlook.com ([40.107.223.45]:48763
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230347AbhELOuV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 May 2021 10:50:21 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OSQrmpXhWw8NtKF0DOAks+Mqvp1zcHh0Q0D6UW05JHeEraFqT3BpxuwRHUIl4jJZbTLGVcHbS4iCrs6tuYfrQJRX0vnXC30tdkF609OfZN4qbT1n1PzcJOf8K1zl7fu2OktJ/QEqwt74pjaKc+JdI53qUGPlUybLQjIjeu49T4W5xtS4ERfET65fFkBNEYesKR/SZIHhNnakneXajcxN5m3rcGWpsp3f3jjPpDj+3JuP/+KWVBYURB4Cm94GTrfS/OZTqcoQPQcAzLpdCQVyEcXmfIMcVUvln+MYmoLI3iBJuw1mG+cL6b9fEHAAo+WEgD+i6jzj81KcCVRQQugcog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oI/vudcgjl4J/ikbfGkzBBKY6/Q7PLea29EEp5GMGVc=;
 b=Lj4obu1e8pgeNHy10/20e2PLqZNUHbkcDK0n6oD2xpDooIlQZjvtPl9VAWRNcp5nGedW9t0mj3jnFrhcBookOlASB6eabKAhdydJmLDaidpbI7lFT77yaTjQaelr+44LJIENnJrr3k9A1vuTC2gU6KwKd1ganVT66GGaHzqW7iCnR0A1H3KO2OGwhsFNCOLlm+ulaUHmGihPGQBsXoeEdySfyF3ntQ2A9DH2AL8/HA85LOkJedTMd7371BVEI1hcYmiyxhQP2JI49IjZ5A0kyxFIFAwYZFNXKWcUvI8juVGyZ+kk+3jTIjrbTGQhMUH4faOZ5hBC7U3xgFuNzpYXBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=networkplumber.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=none sp=none pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oI/vudcgjl4J/ikbfGkzBBKY6/Q7PLea29EEp5GMGVc=;
 b=H833M9uzyp2y1LLLLizonIhepgAPtyY5ygvmJJyCLDI0d8bgoa1jfbHwEIdbUFdFEG26eRR0/UIn4+JHlf1MY6jOxcGiTWT+s9zbqSY00iGx3YbZX1iX4KC+05ayubYWzRHQiNmmVGzIGsgnibLLGWsFvHaZerT50Azjm3lB8M1YFUB5VxkZinMOLJqJoO0l7Vm3kMVCriJ4IRFz71Wn+S7c/kF6hbN5f29X4Im544ADV+SlvXloo2UYEZrPZpPUPnAz2aHlV0qH0O15oYJZE9oGSQOvmbVaE3tdcWK6cqWuJJdnOIR1nluSE4QqYGRVKD8zizebZl+yrGAx/EW33Q==
Received: from BN8PR03CA0020.namprd03.prod.outlook.com (2603:10b6:408:94::33)
 by BL1PR12MB5238.namprd12.prod.outlook.com (2603:10b6:208:31e::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.27; Wed, 12 May
 2021 14:49:09 +0000
Received: from BN8NAM11FT057.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:94:cafe::a7) by BN8PR03CA0020.outlook.office365.com
 (2603:10b6:408:94::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25 via Frontend
 Transport; Wed, 12 May 2021 14:49:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; networkplumber.org; dkim=none (message not signed)
 header.d=none;networkplumber.org; dmarc=pass action=none
 header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 BN8NAM11FT057.mail.protection.outlook.com (10.13.177.49) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4129.25 via Frontend Transport; Wed, 12 May 2021 14:49:09 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 12 May
 2021 14:49:08 +0000
Received: from vdi.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 12 May 2021 14:49:06 +0000
From:   <dlinkin@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <jiri@nvidia.com>,
        <stephen@networkplumber.org>, <dsahern@gmail.com>,
        <vladbu@nvidia.com>, <parav@nvidia.com>, <huyn@nvidia.com>,
        Dmytro Linkin <dlinkin@nvidia.com>
Subject: [PATCH RFC net-next v2 06/18] devlink: Introduce rate object
Date:   Wed, 12 May 2021 17:48:35 +0300
Message-ID: <1620830927-11828-7-git-send-email-dlinkin@nvidia.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1620830927-11828-1-git-send-email-dlinkin@nvidia.com>
References: <1620830927-11828-1-git-send-email-dlinkin@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 81851a6f-9566-4310-3081-08d9155519b5
X-MS-TrafficTypeDiagnostic: BL1PR12MB5238:
X-Microsoft-Antispam-PRVS: <BL1PR12MB523824254EFB91AF0FD0AA6ECB529@BL1PR12MB5238.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:127;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zuIzmr+wviIdL5+MiQUaUhxHXuTsoP23W9GrBht32pk6jDCH43bEj4QEsF6n4nAwn6ETWjWK6Qq+SUeztcUQzOzF/2W87iO6rlFGM46bdFWLb7DgFplOSN8Iu6uGveL1kAsRk54zHn4SeLvM6Vks+58ceXL4Tr/O2bZl8toiB9cwriw6T7yOuyabWGI93UAxVIc6mHn8tIFD1w5VEOYG9Vn+g1VIGUGPmcxMV/mNAt5FcALU0r5G7dqP6SO80bfszOOBAOJzSYrTd/j0q5qmZ47nmZCjTYeY6TNU0fTFRVCjYo20UFItB7tnMQCLVrXrwhDK0K0jl+0n/nZKRrRKqUg5tFm3M13V9G1tq1FYJe27/pPW41n1PkmZv8xRm46EcCz91tVAp1zCPLb7ElbALFCum3m0HRUrcvQGLX/lcjiSum1DADcvoUQxbyLZ8JITfGozjyMy1wWFhSwzVKE5AXoaYspTPUI7TovD+R80HguULGc8gEuZ9g4rByBvLv5ZkPnA+nYKvu6HE/kL2ZKkzBTRvaodoS4wDLN/aTxmehDqfvppsMqt9BQSul9q+6zrQYdziF+1hPBmyb85yP5H//XwIvxX67fWKWeH3AaxmKgwA3h9WDUzxZQCgugQBI+2xi4hZol4baCmngiXIb56BF79HVYNLwpDPfZGJNEutWsfKS4XIT+yuM98i/wfyxAv
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid04.nvidia.com;CAT:NONE;SFS:(4636009)(346002)(396003)(376002)(136003)(39860400002)(46966006)(36840700001)(70206006)(70586007)(6916009)(2616005)(7636003)(478600001)(107886003)(83380400001)(356005)(82310400003)(47076005)(26005)(82740400003)(36860700001)(8676002)(54906003)(5660300002)(7696005)(2906002)(8936002)(30864003)(6666004)(426003)(316002)(36906005)(2876002)(186003)(4326008)(86362001)(336012)(36756003)(461764006);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2021 14:49:09.5475
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 81851a6f-9566-4310-3081-08d9155519b5
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT057.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5238
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dmytro Linkin <dlinkin@nvidia.com>

Allow registering rate object for devlink ports with dedicated
devlink_rate_leaf_{create|destroy}() API. Implement new netlink
DEVLINK_CMD_RATE_GET command that is used to retrieve rate object info.
Add new DEVLINK_CMD_RATE_{NEW|DEL} commands that are used for
notifications when creating/deleting leaf rate object.

Rate API is intended to be used for rate limiting of individual
devlink ports (leafs) and their aggregates (nodes).

Example:

$ devlink port show
pci/0000:03:00.0/0
pci/0000:03:00.0/1

$ devlink port function rate show
pci/0000:03:00.0/0: type leaf
pci/0000:03:00.0/1: type leaf

Co-developed-by: Vlad Buslov <vladbu@nvidia.com>
Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
Signed-off-by: Dmytro Linkin <dlinkin@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---

Notes:
    v1->v2:
    - s/func/function/ in commit message
    - fixes kernel-doc for devlink_rate_leaf_{create|destroy}()

 include/net/devlink.h        |  14 +++
 include/uapi/linux/devlink.h |  11 +++
 net/core/devlink.c           | 229 ++++++++++++++++++++++++++++++++++++++++++-
 3 files changed, 253 insertions(+), 1 deletion(-)

diff --git a/include/net/devlink.h b/include/net/devlink.h
index 7c984ca..2f5954d 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -34,6 +34,7 @@ struct devlink_dev_stats {
 struct devlink {
 	struct list_head list;
 	struct list_head port_list;
+	struct list_head rate_list;
 	struct list_head sb_list;
 	struct list_head dpipe_table_list;
 	struct list_head resource_list;
@@ -133,6 +134,15 @@ struct devlink_port_attrs {
 	};
 };
 
+struct devlink_rate {
+	struct list_head list;
+	enum devlink_rate_type type;
+	struct devlink *devlink;
+	void *priv;
+
+	struct devlink_port *devlink_port;
+};
+
 struct devlink_port {
 	struct list_head list;
 	struct list_head param_list;
@@ -152,6 +162,8 @@ struct devlink_port {
 	struct delayed_work type_warn_dw;
 	struct list_head reporter_list;
 	struct mutex reporters_lock; /* Protects reporter_list */
+
+	struct devlink_rate *devlink_rate;
 };
 
 struct devlink_port_new_attrs {
@@ -1512,6 +1524,8 @@ void devlink_port_attrs_pci_vf_set(struct devlink_port *devlink_port, u32 contro
 void devlink_port_attrs_pci_sf_set(struct devlink_port *devlink_port,
 				   u32 controller, u16 pf, u32 sf,
 				   bool external);
+int devlink_rate_leaf_create(struct devlink_port *port, void *priv);
+void devlink_rate_leaf_destroy(struct devlink_port *devlink_port);
 int devlink_sb_register(struct devlink *devlink, unsigned int sb_index,
 			u32 size, u16 ingress_pools_count,
 			u16 egress_pools_count, u16 ingress_tc_count,
diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
index f6008b2..0c27b45 100644
--- a/include/uapi/linux/devlink.h
+++ b/include/uapi/linux/devlink.h
@@ -126,6 +126,11 @@ enum devlink_command {
 
 	DEVLINK_CMD_HEALTH_REPORTER_TEST,
 
+	DEVLINK_CMD_RATE_GET,		/* can dump */
+	DEVLINK_CMD_RATE_SET,
+	DEVLINK_CMD_RATE_NEW,
+	DEVLINK_CMD_RATE_DEL,
+
 	/* add new commands above here */
 	__DEVLINK_CMD_MAX,
 	DEVLINK_CMD_MAX = __DEVLINK_CMD_MAX - 1
@@ -206,6 +211,10 @@ enum devlink_port_flavour {
 				      */
 };
 
+enum devlink_rate_type {
+	DEVLINK_RATE_TYPE_LEAF,
+};
+
 enum devlink_param_cmode {
 	DEVLINK_PARAM_CMODE_RUNTIME,
 	DEVLINK_PARAM_CMODE_DRIVERINIT,
@@ -534,6 +543,8 @@ enum devlink_attr {
 	DEVLINK_ATTR_RELOAD_ACTION_STATS,       /* nested */
 
 	DEVLINK_ATTR_PORT_PCI_SF_NUMBER,	/* u32 */
+
+	DEVLINK_ATTR_RATE_TYPE,			/* u16 */
 	/* add new attributes above here, update the policy in devlink.c */
 
 	__DEVLINK_ATTR_MAX,
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 4eb9695..28b2490 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -190,6 +190,25 @@ static struct devlink_port *devlink_port_get_from_info(struct devlink *devlink,
 	return devlink_port_get_from_attrs(devlink, info->attrs);
 }
 
+static inline bool
+devlink_rate_is_leaf(struct devlink_rate *devlink_rate)
+{
+	return devlink_rate->type == DEVLINK_RATE_TYPE_LEAF;
+}
+
+static struct devlink_rate *
+devlink_rate_leaf_get_from_info(struct devlink *devlink, struct genl_info *info)
+{
+	struct devlink_rate *devlink_rate;
+	struct devlink_port *devlink_port;
+
+	devlink_port = devlink_port_get_from_attrs(devlink, info->attrs);
+	if (IS_ERR(devlink_port))
+		return ERR_CAST(devlink_port);
+	devlink_rate = devlink_port->devlink_rate;
+	return devlink_rate ?: ERR_PTR(-ENODEV);
+}
+
 struct devlink_sb {
 	struct list_head list;
 	unsigned int index;
@@ -408,12 +427,13 @@ struct devlink_snapshot {
 
 #define DEVLINK_NL_FLAG_NEED_PORT		BIT(0)
 #define DEVLINK_NL_FLAG_NEED_DEVLINK_OR_PORT	BIT(1)
+#define DEVLINK_NL_FLAG_NEED_RATE		BIT(2)
 
 /* The per devlink instance lock is taken by default in the pre-doit
  * operation, yet several commands do not require this. The global
  * devlink lock is taken and protects from disruption by user-calls.
  */
-#define DEVLINK_NL_FLAG_NO_LOCK			BIT(2)
+#define DEVLINK_NL_FLAG_NO_LOCK			BIT(3)
 
 static int devlink_nl_pre_doit(const struct genl_ops *ops,
 			       struct sk_buff *skb, struct genl_info *info)
@@ -442,6 +462,15 @@ static int devlink_nl_pre_doit(const struct genl_ops *ops,
 		devlink_port = devlink_port_get_from_info(devlink, info);
 		if (!IS_ERR(devlink_port))
 			info->user_ptr[1] = devlink_port;
+	} else if (ops->internal_flags & DEVLINK_NL_FLAG_NEED_RATE) {
+		struct devlink_rate *devlink_rate;
+
+		devlink_rate = devlink_rate_leaf_get_from_info(devlink, info);
+		if (IS_ERR(devlink_rate)) {
+			err = PTR_ERR(devlink_rate);
+			goto unlock;
+		}
+		info->user_ptr[1] = devlink_rate;
 	}
 	return 0;
 
@@ -749,6 +778,39 @@ static int devlink_nl_port_attrs_put(struct sk_buff *msg,
 	return 0;
 }
 
+static int devlink_nl_rate_fill(struct sk_buff *msg,
+				struct devlink *devlink,
+				struct devlink_rate *devlink_rate,
+				enum devlink_command cmd, u32 portid,
+				u32 seq, int flags,
+				struct netlink_ext_ack *extack)
+{
+	void *hdr;
+
+	hdr = genlmsg_put(msg, portid, seq, &devlink_nl_family, flags, cmd);
+	if (!hdr)
+		return -EMSGSIZE;
+
+	if (devlink_nl_put_handle(msg, devlink))
+		goto nla_put_failure;
+
+	if (nla_put_u16(msg, DEVLINK_ATTR_RATE_TYPE, devlink_rate->type))
+		goto nla_put_failure;
+
+	if (devlink_rate_is_leaf(devlink_rate)) {
+		if (nla_put_u32(msg, DEVLINK_ATTR_PORT_INDEX,
+				devlink_rate->devlink_port->index))
+			goto nla_put_failure;
+	}
+
+	genlmsg_end(msg, hdr);
+	return 0;
+
+nla_put_failure:
+	genlmsg_cancel(msg, hdr);
+	return -EMSGSIZE;
+}
+
 static bool
 devlink_port_fn_state_valid(enum devlink_port_fn_state state)
 {
@@ -920,6 +982,99 @@ static void devlink_port_notify(struct devlink_port *devlink_port,
 				msg, 0, DEVLINK_MCGRP_CONFIG, GFP_KERNEL);
 }
 
+static void devlink_rate_notify(struct devlink_rate *devlink_rate,
+				enum devlink_command cmd)
+{
+	struct devlink *devlink = devlink_rate->devlink;
+	struct sk_buff *msg;
+	int err;
+
+	WARN_ON(cmd != DEVLINK_CMD_RATE_NEW &&
+		cmd != DEVLINK_CMD_RATE_DEL);
+
+	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
+	if (!msg)
+		return;
+
+	err = devlink_nl_rate_fill(msg, devlink, devlink_rate,
+				   cmd, 0, 0, 0, NULL);
+	if (err) {
+		nlmsg_free(msg);
+		return;
+	}
+
+	genlmsg_multicast_netns(&devlink_nl_family, devlink_net(devlink),
+				msg, 0, DEVLINK_MCGRP_CONFIG, GFP_KERNEL);
+}
+
+static int devlink_nl_cmd_rate_get_dumpit(struct sk_buff *msg,
+					  struct netlink_callback *cb)
+{
+	struct devlink_rate *devlink_rate;
+	struct devlink *devlink;
+	int start = cb->args[0];
+	int idx = 0;
+	int err = 0;
+
+	mutex_lock(&devlink_mutex);
+	list_for_each_entry(devlink, &devlink_list, list) {
+		if (!net_eq(devlink_net(devlink), sock_net(msg->sk)))
+			continue;
+		mutex_lock(&devlink->lock);
+		list_for_each_entry(devlink_rate, &devlink->rate_list, list) {
+			enum devlink_command cmd = DEVLINK_CMD_RATE_NEW;
+			u32 id = NETLINK_CB(cb->skb).portid;
+
+			if (idx < start) {
+				idx++;
+				continue;
+			}
+			err = devlink_nl_rate_fill(msg, devlink,
+						   devlink_rate,
+						   cmd, id,
+						   cb->nlh->nlmsg_seq,
+						   NLM_F_MULTI, NULL);
+			if (err) {
+				mutex_unlock(&devlink->lock);
+				goto out;
+			}
+			idx++;
+		}
+		mutex_unlock(&devlink->lock);
+	}
+out:
+	mutex_unlock(&devlink_mutex);
+	if (err != -EMSGSIZE)
+		return err;
+
+	cb->args[0] = idx;
+	return msg->len;
+}
+
+static int devlink_nl_cmd_rate_get_doit(struct sk_buff *skb,
+					struct genl_info *info)
+{
+	struct devlink_rate *devlink_rate = info->user_ptr[1];
+	struct devlink *devlink = devlink_rate->devlink;
+	struct sk_buff *msg;
+	int err;
+
+	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
+	if (!msg)
+		return -ENOMEM;
+
+	err = devlink_nl_rate_fill(msg, devlink, devlink_rate,
+				   DEVLINK_CMD_RATE_NEW,
+				   info->snd_portid, info->snd_seq, 0,
+				   info->extack);
+	if (err) {
+		nlmsg_free(msg);
+		return err;
+	}
+
+	return genlmsg_reply(msg, info);
+}
+
 static int devlink_nl_cmd_get_doit(struct sk_buff *skb, struct genl_info *info)
 {
 	struct devlink *devlink = info->user_ptr[0];
@@ -7802,6 +7957,7 @@ static int devlink_nl_cmd_trap_policer_set_doit(struct sk_buff *skb,
 	[DEVLINK_ATTR_PORT_PCI_PF_NUMBER] = { .type = NLA_U16 },
 	[DEVLINK_ATTR_PORT_PCI_SF_NUMBER] = { .type = NLA_U32 },
 	[DEVLINK_ATTR_PORT_CONTROLLER_NUMBER] = { .type = NLA_U32 },
+	[DEVLINK_ATTR_RATE_TYPE] = { .type = NLA_U16 },
 };
 
 static const struct genl_small_ops devlink_nl_ops[] = {
@@ -7828,6 +7984,13 @@ static int devlink_nl_cmd_trap_policer_set_doit(struct sk_buff *skb,
 		.internal_flags = DEVLINK_NL_FLAG_NEED_PORT,
 	},
 	{
+		.cmd = DEVLINK_CMD_RATE_GET,
+		.doit = devlink_nl_cmd_rate_get_doit,
+		.dumpit = devlink_nl_cmd_rate_get_dumpit,
+		.internal_flags = DEVLINK_NL_FLAG_NEED_RATE,
+		/* can be retrieved by unprivileged users */
+	},
+	{
 		.cmd = DEVLINK_CMD_PORT_SPLIT,
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = devlink_nl_cmd_port_split_doit,
@@ -8202,6 +8365,7 @@ struct devlink *devlink_alloc(const struct devlink_ops *ops, size_t priv_size)
 	xa_init_flags(&devlink->snapshot_ids, XA_FLAGS_ALLOC);
 	__devlink_net_set(devlink, &init_net);
 	INIT_LIST_HEAD(&devlink->port_list);
+	INIT_LIST_HEAD(&devlink->rate_list);
 	INIT_LIST_HEAD(&devlink->sb_list);
 	INIT_LIST_HEAD_RCU(&devlink->dpipe_table_list);
 	INIT_LIST_HEAD(&devlink->resource_list);
@@ -8304,6 +8468,7 @@ void devlink_free(struct devlink *devlink)
 	WARN_ON(!list_empty(&devlink->resource_list));
 	WARN_ON(!list_empty(&devlink->dpipe_table_list));
 	WARN_ON(!list_empty(&devlink->sb_list));
+	WARN_ON(!list_empty(&devlink->rate_list));
 	WARN_ON(!list_empty(&devlink->port_list));
 
 	xa_destroy(&devlink->snapshot_ids);
@@ -8620,6 +8785,68 @@ void devlink_port_attrs_pci_sf_set(struct devlink_port *devlink_port, u32 contro
 }
 EXPORT_SYMBOL_GPL(devlink_port_attrs_pci_sf_set);
 
+/**
+ * devlink_rate_leaf_create - create devlink rate leaf
+ *
+ * @devlink_port: devlink port object to create rate object on
+ * @priv: driver private data
+ *
+ * Create devlink rate object of type leaf on provided @devlink_port.
+ * Throws call trace if @devlink_port already has a devlink rate object.
+ *
+ * Context: Takes and release devlink->lock <mutex>.
+ *
+ * Return: -ENOMEM if failed to allocate rate object, 0 otherwise.
+ */
+int
+devlink_rate_leaf_create(struct devlink_port *devlink_port, void *priv)
+{
+	struct devlink *devlink = devlink_port->devlink;
+	struct devlink_rate *devlink_rate;
+
+	devlink_rate = kzalloc(sizeof(*devlink_rate), GFP_KERNEL);
+	if (!devlink_rate)
+		return -ENOMEM;
+
+	mutex_lock(&devlink->lock);
+	WARN_ON(devlink_port->devlink_rate);
+	devlink_rate->type = DEVLINK_RATE_TYPE_LEAF;
+	devlink_rate->devlink = devlink;
+	devlink_rate->devlink_port = devlink_port;
+	devlink_rate->priv = priv;
+	list_add_tail(&devlink_rate->list, &devlink->rate_list);
+	devlink_port->devlink_rate = devlink_rate;
+	devlink_rate_notify(devlink_rate, DEVLINK_CMD_RATE_NEW);
+	mutex_unlock(&devlink->lock);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(devlink_rate_leaf_create);
+
+/**
+ * devlink_rate_leaf_destroy - destroy devlink rate leaf
+ *
+ * @devlink_port: devlink port linked to the rate object
+ *
+ * Context: Takes and release devlink->lock <mutex>.
+ */
+void devlink_rate_leaf_destroy(struct devlink_port *devlink_port)
+{
+	struct devlink_rate *devlink_rate = devlink_port->devlink_rate;
+	struct devlink *devlink = devlink_port->devlink;
+
+	if (!devlink_rate)
+		return;
+
+	mutex_lock(&devlink->lock);
+	devlink_rate_notify(devlink_rate, DEVLINK_CMD_RATE_DEL);
+	list_del(&devlink_rate->list);
+	devlink_port->devlink_rate = NULL;
+	mutex_unlock(&devlink->lock);
+	kfree(devlink_rate);
+}
+EXPORT_SYMBOL_GPL(devlink_rate_leaf_destroy);
+
 static int __devlink_port_phys_port_name_get(struct devlink_port *devlink_port,
 					     char *name, size_t len)
 {
-- 
1.8.3.1

