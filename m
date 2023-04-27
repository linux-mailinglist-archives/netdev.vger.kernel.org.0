Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 375BF6F0A29
	for <lists+netdev@lfdr.de>; Thu, 27 Apr 2023 18:46:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244131AbjD0QqS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Apr 2023 12:46:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244295AbjD0QqJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Apr 2023 12:46:09 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2055.outbound.protection.outlook.com [40.107.244.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EF3E49E1
        for <netdev@vger.kernel.org>; Thu, 27 Apr 2023 09:46:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mDhv1VWBK2nUy0T1HAp8sRaNxShe14INcSZwZOJgD6wbw3edPjnLwI7cE9yjBWum0+pyVqf42O5+KbTIaClRg38gcHKCWiJjyNKFnaVj3ZtyrxFgUp8TXIEkXlamAOEkt9c0Jhl2cZrfuBy5TbjIMT4YD+Siw1SSy1naMDUYr79Pxoe6mZxMndJTuC8teiAQp9PQp0pLTgL3MJOQReEjNroqeFjymOjNxiuS4+uTxyfZsxdqpaDOOdcprfIFj7UXQd/nvVIOC8mY/6H2r0Qz2v7jirh8UlWVcsorZT5jiZB64J/eVdqR1/tM0ShaREDda6wbePluLWoKI0DZFuMFZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1kfJzdYx89Cw4lIXhmMCG7wQW3t9PZbR1/aLDFs24Is=;
 b=QNgnu1cBAHI11d3wZLU+sCtSqcgQXY3yJHMjs220O1Drh/y3JtkdFp+U84VP20xsprnqv20Tp1w3lLfxFCHjfkg+/kP2TWOvYnymboIsB2u4LoViEjuhvjZBqWjXfnF+Pjh+eA1Ly+OBA8FdIrVFWvL90E4q7ZudpdMEB/x/ts1n8LrjupNOjpqpVdTQhnUtg8oACvXNMmL1g9CyAdD8lKnAoXKoxn9UhbTw/KkJeBwWm15Sy+ENOJntbXXD4Md4AvfvKKcolPuhyNgfXgyW+0HfBT9xpJV4l/h7NqozI1pL1QDSdSSUclwa57K9Gm7ecp2NHh6y7qx2pY5eKGv9zw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1kfJzdYx89Cw4lIXhmMCG7wQW3t9PZbR1/aLDFs24Is=;
 b=0oUhp7B6fztBil6Z/+cYy0crI0UEFd1uOsho1ZXagm0zMIxLPwOdSbfmmoReqW25ev8vpeC5DLHuiSQYLoIbC8XbvmdUbpfooxhRVaMVTgfjYMJRlO+UX38KSJe7inOmOMwjfEsu0UlA4BmGMijXXZRFAF4GAG6mg/x5K+3opBY=
Received: from BL0PR02CA0087.namprd02.prod.outlook.com (2603:10b6:208:51::28)
 by DM6PR12MB4926.namprd12.prod.outlook.com (2603:10b6:5:1bb::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.22; Thu, 27 Apr
 2023 16:46:03 +0000
Received: from BL02EPF000145BA.namprd05.prod.outlook.com
 (2603:10b6:208:51:cafe::55) by BL0PR02CA0087.outlook.office365.com
 (2603:10b6:208:51::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.22 via Frontend
 Transport; Thu, 27 Apr 2023 16:46:03 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL02EPF000145BA.mail.protection.outlook.com (10.167.241.210) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6340.21 via Frontend Transport; Thu, 27 Apr 2023 16:46:03 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 27 Apr
 2023 11:46:01 -0500
From:   Shannon Nelson <shannon.nelson@amd.com>
To:     <shannon.nelson@amd.com>, <brett.creeley@amd.com>,
        <netdev@vger.kernel.org>
CC:     <drivers@pensando.io>
Subject: [PATCH RFC net-next 2/2] pds_core: tc command handling for vlan push-pop
Date:   Thu, 27 Apr 2023 09:45:46 -0700
Message-ID: <20230427164546.31296-3-shannon.nelson@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230427164546.31296-1-shannon.nelson@amd.com>
References: <20230427164546.31296-1-shannon.nelson@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF000145BA:EE_|DM6PR12MB4926:EE_
X-MS-Office365-Filtering-Correlation-Id: 745e4da2-6efa-487d-96c0-08db473ee390
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +L3CQ2G955fCzGm9AJpoY/uFAzNDCkIannfStP/AI2v2X7SO+dWJctgpDKX1afl796GgLWr74Ig1amaKm9Krc+U+FYhL5aSuDpCT9qQXP8swjlWZCyQJJwtuzIhggTJMRmhB2TbOc+YNJuoVpolQfFtKAkfGre+IlaNw/AsNDXW06n75Sht4BXn7ote6QN59Iu+ZXrQ7o9BiTiwSsXAXzAoumimidgwZ9+eZ3Uj8IsnADPGHQ1cA/kN8StOzPMs+/db97X+2AJDwCz04PpdaKXmJaZ0JNFBW+fRqkdfhU6Sb7sSpj9W5/HQzuZA4ie2XUuZIb/rQt9qa4C9cIZnimhZsp6R0Zd65X0I8yKy0kbTGWlIJyZlm04cSfnj1MutrJPa6Ckptns9IZ+cxHDChqJGEQmI/UdNcegcLBTTL+14zx7WTcJ06j4JX6ddBEt4WaMTIu6J1EOaxJksiVojQvlbnodtD1j+yku8VUf8/bh1vaNcPZo2u9lC8N5lywA77tIu1hRzeW5al+GIYo3otLs8PzTSCkgVQUp7VkHVoEFlemQtRIKN4+p523cpg+S7ehJ7+IQ44H49EdogB+Gz7M6lU6c0wheydzaOR1/t2kl5jEpEPiskLWplaH80Nnr6eKGUpl5H5uzi9Yagq9ue3WHtcLiNJVFJ2wU5IdhFEln4m6MZP9RWyeVBRNbpDrZK9B3GK2p1Ki9q130hejC0VLFmjl8f0vkrEcE+z8xGVXI4=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(346002)(396003)(136003)(39860400002)(376002)(451199021)(46966006)(36840700001)(40470700004)(36860700001)(2616005)(426003)(336012)(83380400001)(47076005)(82310400005)(36756003)(40480700001)(82740400003)(81166007)(356005)(86362001)(40460700003)(110136005)(70206006)(478600001)(6666004)(5660300002)(8676002)(8936002)(44832011)(70586007)(2906002)(4326008)(316002)(41300700001)(1076003)(16526019)(186003)(26005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Apr 2023 16:46:03.4192
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 745e4da2-6efa-487d-96c0-08db473ee390
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BL02EPF000145BA.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4926
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Set up handling of tc commands for adding VF vlan push-pop HW
offload through the VF's representor.  The FW doesn't currently
have a proper set of adminq commands for any tc filtering,
that's a future discussion.  For now we have to get by with
using the existing VF_SETATTR command that will add the push
and pop in a single request.

Example commands for use:

    # add a qdisc for context
    tc qdisc add dev eth0 handle ffff: ingress

    # add a rule to wrap outgoing traffic with vlan id 124
    tc filter add dev eth0 parent ffff: pref 11 protocol all u32 skip_sw \
	   match u32 0 0 flowid 1:1 action vlan push id 124

    # add a rule to pop the tag from incoming traffic
    # this is required normally, but redundant with current FW
    tc filter add dev eth0 parent ffff: pref 1 protocol 802.1Q u32 skip_sw \
	   match u32 0 0 action vlan pop

    # remove rules
    tc filter del dev eth0 parent ffff:

Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
---
 drivers/net/ethernet/amd/pds_core/core.h |   2 +
 drivers/net/ethernet/amd/pds_core/rep.c  | 182 +++++++++++++++++++++++
 2 files changed, 184 insertions(+)

diff --git a/drivers/net/ethernet/amd/pds_core/core.h b/drivers/net/ethernet/amd/pds_core/core.h
index 2f38143dd5c2..ebd55bc0a7dc 100644
--- a/drivers/net/ethernet/amd/pds_core/core.h
+++ b/drivers/net/ethernet/amd/pds_core/core.h
@@ -37,6 +37,8 @@ struct pdsc_vf {
 	struct pdsc *vf;
 	u16     index;
 	__le16  vif_types[PDS_DEV_TYPE_MAX];
+
+	u16     vlanid;
 };
 
 struct pdsc_devinfo {
diff --git a/drivers/net/ethernet/amd/pds_core/rep.c b/drivers/net/ethernet/amd/pds_core/rep.c
index 297d9e2bac31..265b3be5b9d3 100644
--- a/drivers/net/ethernet/amd/pds_core/rep.c
+++ b/drivers/net/ethernet/amd/pds_core/rep.c
@@ -4,15 +4,194 @@
 #include <linux/pci.h>
 #include <linux/etherdevice.h>
 #include <linux/ethtool.h>
+#include <net/pkt_cls.h>
+#include <net/tc_act/tc_vlan.h>
 
 #include "core.h"
 
 struct pds_rep {
 	struct pdsc *vf;
 	struct pdsc *pf;
+	u32 vlan_offload_handle;
+	u16 vlan_id;
 };
 
+static int pdsc_set_vf_vlan(struct net_device *netdev, int vf_id,
+			    u16 vid, u8 qos, __be16 proto)
+{
+	struct pds_rep *vf_rep = netdev_priv(netdev);
+	union pds_core_dev_comp comp = { 0 };
+	union pds_core_dev_cmd cmd = {
+		.vf_setattr.opcode = PDS_CORE_CMD_VF_SETATTR,
+		.vf_setattr.attr = PDS_CORE_VF_ATTR_VLAN,
+		.vf_setattr.vf_index = cpu_to_le16(vf_id),
+		.vf_setattr.vlanid = cpu_to_le16(vid),
+	};
+	struct pdsc *pf = vf_rep->pf;
+	int err;
+
+	netdev_info(netdev, "%s: vf %d vlan %d\n", __func__, vf_id, vid);
+
+	err = pdsc_devcmd(pf, &cmd, &comp, pf->devcmd_timeout);
+	if (!err)
+		pf->vfs[vf_id].vlanid = vid;
+
+	return err;
+}
+
+static void print_cls(struct net_device *netdev,
+		      struct tc_cls_u32_offload *cls)
+{
+	netdev_info(netdev, "cmd %d chain_i %d proto %#x prio %d\n",
+		    cls->command, cls->common.chain_index,
+		    cls->common.protocol, cls->common.prio);
+	netdev_info(netdev, "  handle %#x val %#x mask %#x link_handle %#x fshift %d\n",
+		    cls->knode.handle, cls->knode.val, cls->knode.mask,
+		    cls->knode.link_handle, cls->knode.fshift);
+	netdev_info(netdev, "  exts %p res %p sel %p\n",
+		    cls->knode.exts,  cls->knode.res,  cls->knode.sel);
+}
+
+static int pdsc_configure_clsu32(struct net_device *netdev,
+				 struct tc_cls_u32_offload *cls)
+{
+	struct pds_rep *vf_rep = netdev_priv(netdev);
+	const struct tc_action *a, *act = NULL;
+	int err = 0;
+	u16 vid;
+	int i;
+
+	netdev_info(netdev, "%s: top handle %#x\n",
+		    __func__, vf_rep->vlan_offload_handle);
+	print_cls(netdev, cls);
+
+	if (!tcf_exts_has_actions(cls->knode.exts))
+		return -EINVAL;
+
+	/* only one action TCA_ID_VLAN is supported */
+	tcf_exts_for_each_action(i, a, cls->knode.exts) {
+		if (!is_tcf_vlan(a)) {
+			netdev_err(netdev, "%s: unsupported action %d\n",
+				   __func__, a->ops->id);
+			return -EOPNOTSUPP;
+		} else if (act) {
+			netdev_err(netdev, "%s: multiple vlan actions?\n",
+				   __func__);
+			return -EOPNOTSUPP;
+		}
+
+		act = a;
+	}
+
+	switch (tcf_vlan_action(act)) {
+	case TCA_VLAN_ACT_PUSH:
+		vid = tcf_vlan_push_vid(act);
+		if (!vid)
+			return -EINVAL;
+
+		/* only one allowed at a time */
+		if (vf_rep->vlan_id)
+			return -EBUSY;
+
+		/* with existing FW this will set up both push and pop */
+		err = pdsc_set_vf_vlan(netdev, vf_rep->vf->vf_id, vid, 0,
+				       tcf_vlan_push_proto(act));
+		if (!err) {
+			vf_rep->vlan_id = vid;
+			vf_rep->vlan_offload_handle = TC_U32_USERHTID(cls->knode.handle);
+		}
+		break;
+	case TCA_VLAN_ACT_POP:
+		/* with existing FW this is redundant */
+		err = 0;
+		break;
+	default:
+		netdev_err(netdev, "%s: tcf_vlan_action %d unsupported\n",
+			   __func__, tcf_vlan_action(act));
+		return -EOPNOTSUPP;
+	}
+
+	return err;
+}
+
+static int pdsc_delete_clsu32(struct net_device *netdev,
+			      struct tc_cls_u32_offload *cls)
+{
+	struct pds_rep *vf_rep = netdev_priv(netdev);
+	int err;
+
+	netdev_info(netdev, "%s: top handle %#x\n",
+		    __func__, vf_rep->vlan_offload_handle);
+	print_cls(netdev, cls);
+
+	if (vf_rep->vlan_offload_handle != TC_U32_USERHTID(cls->knode.handle))
+		return -EINVAL;
+
+	netdev_info(netdev, "%s: vf_id %d vlan_id %d delete\n",
+		    __func__, vf_rep->vf->vf_id, vf_rep->vlan_id);
+
+	/* with existing FW this will remove both push and pop */
+	err = pdsc_set_vf_vlan(netdev, vf_rep->vf->vf_id, 0, 0, 0);
+	vf_rep->vlan_id = 0;
+	vf_rep->vlan_offload_handle = 0;
+
+	return err;
+}
+
+static int pdsc_setup_tc_cls_u32(struct net_device *netdev,
+				 struct tc_cls_u32_offload *cls_u32)
+{
+	switch (cls_u32->command) {
+	case TC_CLSU32_NEW_KNODE:
+	case TC_CLSU32_REPLACE_KNODE:
+		return pdsc_configure_clsu32(netdev, cls_u32);
+	case TC_CLSU32_DELETE_KNODE:
+		return pdsc_delete_clsu32(netdev, cls_u32);
+
+	case TC_CLSU32_NEW_HNODE:
+	case TC_CLSU32_REPLACE_HNODE:
+	case TC_CLSU32_DELETE_HNODE:
+		return 0;
+	default:
+		netdev_info(netdev, "%s: unhandled cls_u32->command = %d\n",
+			    __func__, cls_u32->command);
+		return -EOPNOTSUPP;
+	}
+}
+
+static int pdsc_setup_tc_block_cb(enum tc_setup_type tc_type, void *type_data,
+				  void *cb_priv)
+{
+	struct net_device *netdev = cb_priv;
+
+	if (!tc_cls_can_offload_and_chain0(netdev, type_data))
+		return -EOPNOTSUPP;
+
+	switch (tc_type) {
+	case TC_SETUP_CLSU32:
+		return pdsc_setup_tc_cls_u32(netdev, type_data);
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
+static LIST_HEAD(pdsc_block_cb_list);
+
+static int pdsc_setup_tc(struct net_device *netdev, enum tc_setup_type tc_type, void *type_data)
+{
+	switch (tc_type) {
+	case TC_SETUP_BLOCK:
+		return flow_block_cb_setup_simple(type_data,
+						  &pdsc_block_cb_list,
+						  pdsc_setup_tc_block_cb,
+						  netdev, netdev, true);
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
 static const struct net_device_ops pdsc_rep_netdev_ops = {
+	.ndo_setup_tc		= pdsc_setup_tc,
 };
 
 static void pdsc_get_rep_drvinfo(struct net_device *netdev,
@@ -60,6 +239,9 @@ int pdsc_add_rep(struct pdsc *vf, struct pdsc *pf)
 
 	vf->netdev->netdev_ops = &pdsc_rep_netdev_ops;
 	vf->netdev->ethtool_ops = &pdsc_rep_ethtool_ops;
+	vf->netdev->features |= NETIF_F_HW_TC;
+	vf->netdev->hw_features |= NETIF_F_HW_TC;
+
 	netif_carrier_off(vf->netdev);
 
 	SET_NETDEV_DEVLINK_PORT(vf->netdev,  &vf->dl_port);
-- 
2.17.1

