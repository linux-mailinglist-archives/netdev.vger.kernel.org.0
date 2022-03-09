Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2116D4D2FA5
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 14:03:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232931AbiCINEJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 08:04:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231963AbiCINEI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 08:04:08 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2075.outbound.protection.outlook.com [40.107.243.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A50566AC9
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 05:03:09 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ld14CPxBP60iear8FchjBNmPxQbFYy32rlfjYVX7G+zI/U4T33AyPaEQDRw1pZIQ0T9RH82Un88RAltDFUDxIgNJnP1sjHJgO9WbDEP7/7lsoPodXk1ZzKZxO3TlzIwLGXScBOpv4PDhsKuu+Ihmn0Tz9yBc7MP6rqMhRTDjNygch7IXtn2f9jtIteGL9jEH5SBHXakwebQ2yVDB5qh9SVCIfB57OeQj0JrIBIc/vMT+rhTQ+eEt3ZrVQCJ6M9r1KIkuwLHHYUdVZg25KiEQrXAn0rckEwAnaT/eitYKnynYYg1IQ6T/GzMtLOvyvd1a3X01AkSaFZvj97+0wySs+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+m0hhEiqWR+lJhXWxPiOVcc9YqljxJa7FXxvDy7jIlM=;
 b=Ap3Y2BGfukh8Rbcmd5aNg14tMefaaNCa+d/sGSgjZl5zC3LOAUBro81MDSJrQkW5LasuzJUkZ0AEOP8ZpKPbwxmLzHsB5aZEh8Zs9yUg29n42pExwxk9/gryP59zZPwR6E3J2qwlQcx0YGmUB4vXVOpI4uXTjGCTxNw/NeTqrotBmA3zpJJPh5ljYREpo5hF2ykG2TPGgjFbGGa0k1b4qk11x6vAX3lvD2pZvt31slUeEBdI9aAMaNObOuE7Cr0OnSuO0i9YYRiHCAI5y4b5B9zzy2r4MRvXO7OpS3I7xEIxLOERZz5eiLRDM7+cEX4+d1CLTreEtLQF0QZ26v1I4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+m0hhEiqWR+lJhXWxPiOVcc9YqljxJa7FXxvDy7jIlM=;
 b=qV7s9ie1ZF/wcfFbQKMi+nfaLDyy3JwcsjTg3eOigGHJm5pX1FulOSu2DyMqqdgneiw+bszl8iW8OPN5T2QG5UdlqSiGVgakdAPAy9hhKe7WaPybrNVOXqxlnZcIz1vqLw49xykSKVoP/VkgGQjx0V2VYEpvrMULbsI4mclGbn8A7+zLwspuw7MBTXbhakfNBEzW7CyeqPMQ/VnMOKoTZ9yB2gPqGKy5QfQl9GPPWooa7mFC+NYISrjXKMj/wq0jVuGf45eAUiUhIBNSkqjU4q/hZnDhmt0wLC9GPGagmgRpn+Xa/QI3UBgWR2chjIgUE0bq/4JUCy3aFvnnvD6lOQ==
Received: from BN1PR13CA0021.namprd13.prod.outlook.com (2603:10b6:408:e2::26)
 by MN2PR12MB4799.namprd12.prod.outlook.com (2603:10b6:208:a2::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Wed, 9 Mar
 2022 13:03:06 +0000
Received: from BN8NAM11FT005.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:e2:cafe::16) by BN1PR13CA0021.outlook.office365.com
 (2603:10b6:408:e2::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.7 via Frontend
 Transport; Wed, 9 Mar 2022 13:03:06 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.234) by
 BN8NAM11FT005.mail.protection.outlook.com (10.13.176.69) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5038.14 via Frontend Transport; Wed, 9 Mar 2022 13:03:05 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 9 Mar
 2022 13:03:04 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Wed, 9 Mar 2022
 05:03:02 -0800
Received: from dev-r-vrt-138.mtr.labs.mlnx (10.127.8.10) by mail.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server id 15.2.986.9 via Frontend
 Transport; Wed, 9 Mar 2022 05:03:00 -0800
From:   Roi Dayan <roid@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     Roi Dayan <roid@nvidia.com>, Maor Dickman <maord@nvidia.com>,
        "Jakub Kicinski" <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "Jamal Hadi Salim" <jhs@mojatatu.com>, Jiri Pirko <jiri@nvidia.com>
Subject: [PATCH net-next 1/3] net/sched: add vlan push_eth and pop_eth action to the hardware IR
Date:   Wed, 9 Mar 2022 15:02:54 +0200
Message-ID: <20220309130256.1402040-2-roid@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220309130256.1402040-1-roid@nvidia.com>
References: <20220309130256.1402040-1-roid@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e9b608d6-df75-456a-8c6d-08da01cd26a3
X-MS-TrafficTypeDiagnostic: MN2PR12MB4799:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB479901A1D5316B6ABF72D6C9B80A9@MN2PR12MB4799.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8HMlu6YxPPI7PdhC10UyIKeUyym79eNF37zw6zg3TsBDTyL67F8Yfj3/AjL6WBuOlDEVLvh+Q9thJNhj97OQijC79HcphPyoIb1nE+zBpDOmrKwXXCely0L3RxZZ1zGgNXNHTgXFW92WNQSOviDL3ztGYOJ8dhCax2WBwXkziM1jttxhIzsToyZcUhI1ztMNyv22lokmxTKSOB7k5jzTK4UxPXr25crQEdGEoMIE6DcrOuKaek2ntfRIerN22INbLQLdj2EnmguQRAdnLB7hzpaYTmU4qBNQBxc84cxQPWUkd8WWe8QWXJFax4h4gxY9ouUZy3kOP4FA39t85avjdzv1w+YBviJEbmVqzselclpiHtS2qZDFd49sZi+dGmF056Stf2c8IB22mtHJqC847GUhv41BUWqt+FT/wlyBg/96levdHvCmSHYDq1KQlI0IYpnH9dnkrfrRhrADWmnYyJMxKjVozcVBPB2lrHZaDzij7ZJkmUFUUqEs294hckAw4zxmypOmLL9o2kGJZxkLNny7S61OzNb9ulwU2ZTqem9aB4QRe/fE+v/1r0w4VxgOWCCURUn9eAiFHYpjncYLqLR4eXM+6aWkPYOv2emVXk9Sn4pLbqYEqeqBHV8jM4y3fpQf1gHdyvcWhCv7LWaeJwx/M4zzdoWkjsxWd674qy1NTeHWg+HAuP0mmRRp0mCY+sJ/DsuLhYBtVGQgT7D7Kw==
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(46966006)(40470700004)(4326008)(8936002)(26005)(336012)(6666004)(8676002)(54906003)(40460700003)(1076003)(6916009)(5660300002)(186003)(426003)(83380400001)(36756003)(2906002)(2616005)(81166007)(86362001)(356005)(107886003)(82310400004)(36860700001)(508600001)(70206006)(70586007)(47076005)(316002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2022 13:03:05.2803
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e9b608d6-df75-456a-8c6d-08da01cd26a3
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT005.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4799
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maor Dickman <maord@nvidia.com>

Add vlan push_eth and pop_eth action to the hardware intermediate
representation model which would subsequently allow it to be used
by drivers for offload.

Signed-off-by: Maor Dickman <maord@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
---
 include/net/flow_offload.h   |  4 ++++
 include/net/tc_act/tc_vlan.h | 14 ++++++++++++++
 net/sched/act_vlan.c         | 14 ++++++++++++++
 3 files changed, 32 insertions(+)

diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
index 92267d23083e..2bfa666842c5 100644
--- a/include/net/flow_offload.h
+++ b/include/net/flow_offload.h
@@ -150,6 +150,8 @@ enum flow_action_id {
 	FLOW_ACTION_PPPOE_PUSH,
 	FLOW_ACTION_JUMP,
 	FLOW_ACTION_PIPE,
+	FLOW_ACTION_VLAN_PUSH_ETH,
+	FLOW_ACTION_VLAN_POP_ETH,
 	NUM_FLOW_ACTIONS,
 };
 
@@ -211,6 +213,8 @@ struct flow_action_entry {
 			__be16		proto;
 			u8		prio;
 		} vlan;
+		unsigned char vlan_push_eth_dst[ETH_ALEN];
+		unsigned char vlan_push_eth_src[ETH_ALEN];
 		struct {				/* FLOW_ACTION_MANGLE */
 							/* FLOW_ACTION_ADD */
 			enum flow_action_mangle_base htype;
diff --git a/include/net/tc_act/tc_vlan.h b/include/net/tc_act/tc_vlan.h
index f94b8bc26f9e..8a3422c70f9f 100644
--- a/include/net/tc_act/tc_vlan.h
+++ b/include/net/tc_act/tc_vlan.h
@@ -78,4 +78,18 @@ static inline u8 tcf_vlan_push_prio(const struct tc_action *a)
 
 	return tcfv_push_prio;
 }
+
+static inline void tcf_vlan_push_dst(unsigned char *dest, const struct tc_action *a)
+{
+	rcu_read_lock();
+	memcpy(dest, rcu_dereference(to_vlan(a)->vlan_p)->tcfv_push_dst, ETH_ALEN);
+	rcu_read_unlock();
+}
+
+static inline void tcf_vlan_push_src(unsigned char *dest, const struct tc_action *a)
+{
+	rcu_read_lock();
+	memcpy(dest, rcu_dereference(to_vlan(a)->vlan_p)->tcfv_push_src, ETH_ALEN);
+	rcu_read_unlock();
+}
 #endif /* __NET_TC_VLAN_H */
diff --git a/net/sched/act_vlan.c b/net/sched/act_vlan.c
index 756e2dcde1cd..d27604204f17 100644
--- a/net/sched/act_vlan.c
+++ b/net/sched/act_vlan.c
@@ -390,6 +390,14 @@ static int tcf_vlan_offload_act_setup(struct tc_action *act, void *entry_data,
 			entry->vlan.proto = tcf_vlan_push_proto(act);
 			entry->vlan.prio = tcf_vlan_push_prio(act);
 			break;
+		case TCA_VLAN_ACT_POP_ETH:
+			entry->id = FLOW_ACTION_VLAN_POP_ETH;
+			break;
+		case TCA_VLAN_ACT_PUSH_ETH:
+			entry->id = FLOW_ACTION_VLAN_PUSH_ETH;
+			tcf_vlan_push_dst(entry->vlan_push_eth_dst, act);
+			tcf_vlan_push_src(entry->vlan_push_eth_src, act);
+			break;
 		default:
 			return -EOPNOTSUPP;
 		}
@@ -407,6 +415,12 @@ static int tcf_vlan_offload_act_setup(struct tc_action *act, void *entry_data,
 		case TCA_VLAN_ACT_MODIFY:
 			fl_action->id = FLOW_ACTION_VLAN_MANGLE;
 			break;
+		case TCA_VLAN_ACT_POP_ETH:
+			fl_action->id = FLOW_ACTION_VLAN_POP_ETH;
+			break;
+		case TCA_VLAN_ACT_PUSH_ETH:
+			fl_action->id = FLOW_ACTION_VLAN_PUSH_ETH;
+			break;
 		default:
 			return -EOPNOTSUPP;
 		}
-- 
2.34.1

