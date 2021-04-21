Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63E48366F76
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 17:53:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244129AbhDUPyB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 11:54:01 -0400
Received: from mail-bn8nam12on2041.outbound.protection.outlook.com ([40.107.237.41]:12800
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S244111AbhDUPx7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Apr 2021 11:53:59 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nR2asrnB6CP3DAyvEXuWYwugYn67E4sXuy/6KdS6hLhx9vkMoGegZj0x0qVP4eS0PE698w+uGG1UEoca/pu/QFAcbGVn7qhKIyC5cTYg1uW6trVQkoRwGmTq/idYOb5dXM9IoGXTVEh2ZxKOBHJKNDOCT/c73jl3hzLV5CkoaGwQw7HIrEBNx1WHy5XahLNwsijiX6dnUFz9wAxbQSAaLF7IId4hpq3DOYk4nL27XTG6j6dCCkfo5l5DQ2jCXxppf/57i380gpTdJzkV3EIKxaTSypnLt4DmAGcl3+7LO0/FJwpEaIWt0S5UJLjUI5NBnwGY0N09hUB/8yhATz1Xeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cxf/Ruo3phGxv21QJu1bW1lxlJsd4h35TWhdPsMgtFs=;
 b=QvdZnjIUldCiUQA0JqbKBFvLs4y66968Cf7p6qAfrEA2aE6CJCs/494YSlHN+W41Ao1pHOmsG9gNuuwe9soabRlgjlgZqb0JKc82XOBvKNbiHRc20x33SlbMP7VooBUljqEdosgfOCBDBIPq4O1UfgwM0oFjonUCXAdrXxx3oShx0yNTfQ2s1pfUmNz9b/uZTQwyAV+4LCmTkyqmotxGLbBwXV8a9cSJa/mvd/t1MQBB+pGjNMjVtcUXIBv8WRFQ8/oa6UWxsPbaBDlbGrR002fdT8h56Y1JGq8nopptQ//X/NaQ2ntHUXmEG8iUIzZwwmlrXpbJ92jAiX5sWkt3cg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cxf/Ruo3phGxv21QJu1bW1lxlJsd4h35TWhdPsMgtFs=;
 b=mP3r73hL0erIv9Hd0Al+fR32H0AFNWcUG8NQM0Q18zdhfySLVZcGcn0Mo5BurQTh1ODWYN0t1oUxLgUQ13mSqcxDLDzqoHGH0YRS8FvVxQg6WkA6OcL6NsTDpC4Ill4SvSJSlerJ+nZYgkKYtuGopWhYiDO2lknQf3R56ztCOWRlTbZnfr1LDIu8T4E1ELOeYuGetMBbNeSpnaf62cnLWj+No/20RmcPsmPW+7EkJKAkAYl0XxNDXbjoXcXrlACfKD8FfA2Znd3AfrCnpmp4GqQpSlldHHasgw1jhlPvv/B1JkU5wS718KbZhEm3gOV9dKhedzRMzGudDPF8q6eKWw==
Received: from BN0PR04CA0093.namprd04.prod.outlook.com (2603:10b6:408:ec::8)
 by CY4PR12MB1702.namprd12.prod.outlook.com (2603:10b6:903:11f::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.24; Wed, 21 Apr
 2021 15:53:25 +0000
Received: from BN8NAM11FT009.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:ec:cafe::f3) by BN0PR04CA0093.outlook.office365.com
 (2603:10b6:408:ec::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.22 via Frontend
 Transport; Wed, 21 Apr 2021 15:53:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT009.mail.protection.outlook.com (10.13.176.65) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4065.21 via Frontend Transport; Wed, 21 Apr 2021 15:53:24 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 21 Apr
 2021 15:53:23 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 21 Apr
 2021 15:53:23 +0000
Received: from vdi.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 21 Apr 2021 15:53:21 +0000
From:   <dlinkin@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <jiri@nvidia.com>,
        <stephen@networkplumber.org>, <dsahern@gmail.com>,
        <vladbu@nvidia.com>, Dmytro Linkin <dlinkin@nvidia.com>
Subject: [PATCH RESEND-2 RFC net-next 06/18] devlink: Introduce rate object
Date:   Wed, 21 Apr 2021 18:52:53 +0300
Message-ID: <1619020385-20220-7-git-send-email-dlinkin@nvidia.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1619020385-20220-1-git-send-email-dlinkin@nvidia.com>
References: <1619020385-20220-1-git-send-email-dlinkin@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 013f4dbe-4722-4e97-2bee-08d904dd98c1
X-MS-TrafficTypeDiagnostic: CY4PR12MB1702:
X-Microsoft-Antispam-PRVS: <CY4PR12MB170203DC88933A0A460D0528CB479@CY4PR12MB1702.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:883;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aFgzPXPn++KIUchPWbYI2RzR9niV3WX6/W6rt80ZoiFKAWBMKqi5Edeu9X3FM/aJWEchPIi/i9ekOSxnz1OlhCjKEdz690esY3WyfvDGGnyO3Cfn1xgENx3UG7gLcinD7xqJOCQCoeaJOjR+ZASfz8NK9SJW8S1a0q2G2oG7LupOAnx7SkT2+hzQEY9v5b1/OS3Q4U9mVHWflcU4TWln6tzgNQSin0b19tA1D89d4IG+dTwK+Te7DqZ/c76UZ3mtqgz5kRr28DO3wLxk3m28zEAGjcN4nO2wAKhQu2IC0lr4WaAAbxssx7q8uaAkiqg6hfZ/K051AkG22gRQXnFH+TLw3XP7lGs8ztNhHRMBfRbhHa2WrLwVBZBAhfAwECrtyF5Nm6//BX9mBPEF4NNV3SjBSCFgTau7t8xJCHGYeS/FRX857O5B0pODFGmzKPOWL851X/P+k3qemKOtidXv8ZGmQn6poMc052LLnPo8UwzBu6q5Hy8aMsJKfYtRBfYCm6D7QsWO+sr8v3wuilVN14aJy9ggrvi9OMo9Sy1WhzQ/BuXuRggP0n3HPX+B9LyD7dALuOlEpH8v5G+1kWysV3pHyg/AEnSZpo4+CfvWq8axz+0WMHa9tDPqNh9j/ePJhT0j7mnbNuChJpsbu0vL/Jpxe5Hv0xjgurcCyj2ntyDY52nj8i3aWwO/jthxsz3s
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(346002)(39860400002)(396003)(376002)(136003)(46966006)(36840700001)(7636003)(82310400003)(83380400001)(36906005)(6916009)(2616005)(8676002)(26005)(82740400003)(4326008)(54906003)(478600001)(2906002)(186003)(30864003)(5660300002)(36756003)(8936002)(356005)(316002)(86362001)(2876002)(7696005)(107886003)(70586007)(36860700001)(336012)(426003)(47076005)(70206006)(6666004)(461764006);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2021 15:53:24.4327
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 013f4dbe-4722-4e97-2bee-08d904dd98c1
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT009.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1702
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

$ devlink port func rate show
pci/0000:03:00.0/0: type leaf
pci/0000:03:00.0/1: type leaf

Co-developed-by: Vlad Buslov <vladbu@nvidia.com>
Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
Signed-off-by: Dmytro Linkin <dlinkin@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
 include/net/devlink.h        |  14 +++
 include/uapi/linux/devlink.h |  11 +++
 net/core/devlink.c           | 222 ++++++++++++++++++++++++++++++++++++++++++-
 3 files changed, 246 insertions(+), 1 deletion(-)

diff --git a/include/net/devlink.h b/include/net/devlink.h
index 853420d..073bc66 100644
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
@@ -131,6 +132,15 @@ struct devlink_port_attrs {
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
@@ -150,6 +160,8 @@ struct devlink_port {
 	struct delayed_work type_warn_dw;
 	struct list_head reporter_list;
 	struct mutex reporters_lock; /* Protects reporter_list */
+
+	struct devlink_rate *devlink_rate;
 };
 
 struct devlink_port_new_attrs {
@@ -1509,6 +1521,8 @@ void devlink_port_attrs_pci_vf_set(struct devlink_port *devlink_port, u32 contro
 				   u16 pf, u16 vf, bool external);
 void devlink_port_attrs_pci_sf_set(struct devlink_port *devlink_port,
 				   u32 controller, u16 pf, u32 sf);
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
index 737b61c..7acff15 100644
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
@@ -8618,6 +8783,61 @@ void devlink_port_attrs_pci_sf_set(struct devlink_port *devlink_port, u32 contro
 }
 EXPORT_SYMBOL_GPL(devlink_port_attrs_pci_sf_set);
 
+/**
+ *	devlink_rate_leaf_create - create devlink rate leaf
+ *
+ *	@devlink_port: devlink port object to create rate object on
+ *	@priv: driver private data
+ *
+ *	Create devlink rate object of type leaf on provided devlink port.
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
+ *	devlink_rate_leaf_destroy - destroy devlink rate leaf
+ *
+ *	@devlink_port: devlink port linked to the rate object
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

