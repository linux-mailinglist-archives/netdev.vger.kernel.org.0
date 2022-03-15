Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66A904D99DF
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 12:02:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347781AbiCOLDv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 07:03:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347784AbiCOLDs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 07:03:48 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam08on2086.outbound.protection.outlook.com [40.107.100.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B276E443D8
        for <netdev@vger.kernel.org>; Tue, 15 Mar 2022 04:02:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Pd9PRTZjv6Qgi4Nmnc8N8McY5rMffhXcGbAXBeYc9KEIyrkUFXU2bzwBOyIs4Ce+UBL5v51GXuiROY/X4S0WdKDI1DR6fskOydp2XJeKTNWVExKrA6a3dzp3suidlZtmMzprg5JkmM8JRj/g3L6WDknR9x4HSVJcFXBr/yWp3O2rTt0HmojjkYhx3d4HPu7HUPp/F3O1wfzeDwj13PPVahFJtkhMVOD0J3hP7zOwpuasDfwE0IPpTkEsXoJHJGPSkVlGBMU1DLGLIIXJsQxQm/dUaOzPjYYxOXhglZiEhXTePE2FkHX+KkBQ8oMWpULMSOavrY95WHe5TqpDt5Zlaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Pm/TYrtiyF9jTWlhfA/0Ald4GBeSo5Hql1pGAyNeY2Q=;
 b=KEJ0BY9cREC9uO12X2xSHkXtkmoetDy82+oRiN0p30p4Op/5KPzOcsDl25UryTa0xDMC0nP8s3fXrbpJSKjjhYmTRQrc3QBt2uPqckzlhLcabK4cIWzXxbKDPIm/N7BF6fmQdC6qCEHWaOtpoj5ofKqSnVGHIdj8t/CyR2ZGJ20Ca9+c5n02It6oKuEZeGW/IwJ3KUkJOxKlIFwcUzxIRHO7EFbzpvj7Vrw+fq+ihrnRWBs5Glr12EqT3AZU2CmAh9N2X3zBJsrTRvxav8XCflpj4r0mhW56eRlJ6qalAjhna6YWusFvT2WCCFFfg0jOCEJ/qkc8R4fyqq7CrMCKtQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Pm/TYrtiyF9jTWlhfA/0Ald4GBeSo5Hql1pGAyNeY2Q=;
 b=av5QZG4/n9L5XMJM4rl64724r3VkRV3Thc/jKbfudEs+a16qf2kUdqWRoCC1jMlPINbfCSQhxpZlQjqRqW0LR6ASG08t1Zok1gsykaBdehThZEPklnzxOkmpF6vkUeI0z/znKHtGBbfjht9eyJab3ZQ8S7iBKGECoyb2zUOx8T42q9VU/a0cXUVX2UTx20i56XAimuLf35tCszhMx7eLI8XoPvBO4hnL3Ev1u7M6TqZHKUehqBnv6QdyKvWUQdmqyZI+TZcbbSYmJUwP8G/3te1zHTTsUgDy1SKbl7VVfFiFLdnYYGmdY76rWhiWsbtndW7meDVM7++VBSWSYDUiJA==
Received: from MWHPR10CA0049.namprd10.prod.outlook.com (2603:10b6:300:2c::11)
 by BL1PR12MB5142.namprd12.prod.outlook.com (2603:10b6:208:312::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.25; Tue, 15 Mar
 2022 11:02:35 +0000
Received: from CO1NAM11FT060.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:2c:cafe::28) by MWHPR10CA0049.outlook.office365.com
 (2603:10b6:300:2c::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.22 via Frontend
 Transport; Tue, 15 Mar 2022 11:02:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.238) by
 CO1NAM11FT060.mail.protection.outlook.com (10.13.175.132) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5061.22 via Frontend Transport; Tue, 15 Mar 2022 11:02:34 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Tue, 15 Mar
 2022 11:02:33 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Tue, 15 Mar
 2022 04:02:32 -0700
Received: from dev-r-vrt-138.mtr.labs.mlnx (10.127.8.10) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server id 15.2.986.22 via Frontend
 Transport; Tue, 15 Mar 2022 04:02:30 -0700
From:   Roi Dayan <roid@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     Roi Dayan <roid@nvidia.com>, Maor Dickman <maord@nvidia.com>,
        "Jakub Kicinski" <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "Jamal Hadi Salim" <jhs@mojatatu.com>, Jiri Pirko <jiri@nvidia.com>
Subject: [PATCH net-next v2 1/3] net/sched: add vlan push_eth and pop_eth action to the hardware IR
Date:   Tue, 15 Mar 2022 13:02:09 +0200
Message-ID: <20220315110211.1581468-2-roid@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220315110211.1581468-1-roid@nvidia.com>
References: <20220315110211.1581468-1-roid@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9c4e6b0b-ac41-4785-83d4-08da06734ef8
X-MS-TrafficTypeDiagnostic: BL1PR12MB5142:EE_
X-Microsoft-Antispam-PRVS: <BL1PR12MB5142C6D6D406E6750E70999BB8109@BL1PR12MB5142.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0FZc383CfkkEY67V4rSpbwmoUs9ughVALjhYoNGI61aLnIWEBGqjsV0Ol/Yi6TgX59qZaNM1EBBYrFarTY22l68/0TWCpcGDjq4A2HbpAGdch4JYBq4JHFg+iORKw0DQKDFlxccZt6twJeW1t/NYRAKMmChy5UJJkEfaqsCdZgYlLYEuQBYhMmEWIP0xjaE+IRdrRUhalqGULIKg7v44DABtf1hVpGGCdal7wN9TVhWaWCZMYmLT/un6YwIf5MtUCrjrbQSOlX91jgz0LfPa2LZ7bXHfMxNCq2FmGtfQBvf+9//qv/oFPgjb1R2CBOBN5+uWv1x1UCz+Pqar8FiyW2eta6XO8JFcH+Px6TT1SjD5rKl4qmLaYfisOfoZpXMlnwGJFk2mun/VvXLe6/WXF9qfeIxCkm+R+IwJHHfF+EV+x+4twC04J8tY3Zyimf8552/UhrXnOSVAUS+TxksoOtmcyyDjoCjWOEePluJPJzkGFvDVcm+YtDm0Sr/1ZrVXJHBaujy7Es+kgkSwhLYhmsNLg0kFVoiBJyCV4NBFfPnFlsgCY/yQ50tKI5tsZ61n0JoaTmVhXmtynX/R9UDf59IZit8uauU0x2pFFb478hqm1jX7gQusDME9Qm5i+6NgbGJSMH1HI9WKNVQYA4R2fnbNq0LYKoB6pjIu0vCho3CcJj6Sd6RPfpC9Tfy+1+K8WO0PQ6ubV0jT1s4GlZ/Uzw==
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(40470700004)(36840700001)(6916009)(54906003)(316002)(36860700001)(40460700003)(6666004)(107886003)(36756003)(26005)(1076003)(186003)(2616005)(83380400001)(81166007)(5660300002)(2906002)(508600001)(356005)(8676002)(86362001)(70586007)(70206006)(82310400004)(8936002)(47076005)(336012)(426003)(4326008)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2022 11:02:34.1011
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c4e6b0b-ac41-4785-83d4-08da06734ef8
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT060.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5142
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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
 include/net/flow_offload.h   |  6 ++++++
 include/net/tc_act/tc_vlan.h | 10 ++++++++++
 net/sched/act_vlan.c         | 13 +++++++++++++
 3 files changed, 29 insertions(+)

diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
index 92267d23083e..021778a7e1af 100644
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
 
@@ -211,6 +213,10 @@ struct flow_action_entry {
 			__be16		proto;
 			u8		prio;
 		} vlan;
+		struct {				/* FLOW_ACTION_VLAN_PUSH_ETH */
+			unsigned char dst[ETH_ALEN];
+			unsigned char src[ETH_ALEN];
+		} vlan_push_eth;
 		struct {				/* FLOW_ACTION_MANGLE */
 							/* FLOW_ACTION_ADD */
 			enum flow_action_mangle_base htype;
diff --git a/include/net/tc_act/tc_vlan.h b/include/net/tc_act/tc_vlan.h
index f94b8bc26f9e..a97600f742de 100644
--- a/include/net/tc_act/tc_vlan.h
+++ b/include/net/tc_act/tc_vlan.h
@@ -78,4 +78,14 @@ static inline u8 tcf_vlan_push_prio(const struct tc_action *a)
 
 	return tcfv_push_prio;
 }
+
+static inline void tcf_vlan_push_eth(unsigned char *src, unsigned char *dest,
+				     const struct tc_action *a)
+{
+	rcu_read_lock();
+	memcpy(dest, rcu_dereference(to_vlan(a)->vlan_p)->tcfv_push_dst, ETH_ALEN);
+	memcpy(dest, rcu_dereference(to_vlan(a)->vlan_p)->tcfv_push_src, ETH_ALEN);
+	rcu_read_unlock();
+}
+
 #endif /* __NET_TC_VLAN_H */
diff --git a/net/sched/act_vlan.c b/net/sched/act_vlan.c
index 756e2dcde1cd..883454c4f921 100644
--- a/net/sched/act_vlan.c
+++ b/net/sched/act_vlan.c
@@ -390,6 +390,13 @@ static int tcf_vlan_offload_act_setup(struct tc_action *act, void *entry_data,
 			entry->vlan.proto = tcf_vlan_push_proto(act);
 			entry->vlan.prio = tcf_vlan_push_prio(act);
 			break;
+		case TCA_VLAN_ACT_POP_ETH:
+			entry->id = FLOW_ACTION_VLAN_POP_ETH;
+			break;
+		case TCA_VLAN_ACT_PUSH_ETH:
+			entry->id = FLOW_ACTION_VLAN_PUSH_ETH;
+			tcf_vlan_push_eth(entry->vlan_push_eth.src, entry->vlan_push_eth.dst, act);
+			break;
 		default:
 			return -EOPNOTSUPP;
 		}
@@ -407,6 +414,12 @@ static int tcf_vlan_offload_act_setup(struct tc_action *act, void *entry_data,
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

