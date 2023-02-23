Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D31CE6A13FF
	for <lists+netdev@lfdr.de>; Fri, 24 Feb 2023 00:52:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229509AbjBWXwq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Feb 2023 18:52:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbjBWXwp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Feb 2023 18:52:45 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2042.outbound.protection.outlook.com [40.107.244.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 684EC54553
        for <netdev@vger.kernel.org>; Thu, 23 Feb 2023 15:52:43 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NJ9JLnvPdw4JVlsGr44OoSP2jvhnS+5mCG/0yNt23V6Cb9C7GgzmFVWCGf88RnE0yOCnQaF505hwP4gGqfry4bDaTxVZ2MvYyLCqMsMBJhCvrkOO5MoEdfVhSxRqqmou6Ue7lFJCNjn6yazpU+jWdW+0KlDpXlQonWLBGrIMrn6UOvyaVkrosw0WR8FSSgQdb7i+ohs72R2Y21XdHDpEV45mKdrFVyQzpAVIGLd9d8EE0Wp4aJePCLZFfDNQiQd4mKsTC7qI3MWtfiotxzvaa2pSDkDf9LKbIYCn5iKkjzdm/Vc1uQsIoqLu7j/H66dKswmqsNOxuGqhzcAcveuSxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=80w24LGXzYqCjXbg1TkiwnYB0KIljHAiu1iDPxSD9A4=;
 b=Fa0pef4shSD5/PGoQFD5QomPDQG4hQFKmvcbpoUsuifwyrNQ6EErAZErmg4nxrZJf2OMepgFdQwjfdnyQsICHHovbK1bjW5NHM1zcfI1NXi9sA4Uo4kGOcQOvRfvXO3kqCgOsqYJDsNa9QTwMpiMhUwc1Gvq8rigyBTCQDGITmcC46/hyhBpQQU0YHe9GeYmI9Aqn58DSTNQRFUc+FjRJHOzmJYZD586EQXTPZVlrbZe9/hxv5Y7+2RH+YQNkwT/pd8/i0fMen9nWVdAsi6UIBoyXbdteKzcW+LwJOkCYWojKwFr6+TqSHerFqv/UCbd6dxwgLKjNIErCpJXdVg3Ow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=80w24LGXzYqCjXbg1TkiwnYB0KIljHAiu1iDPxSD9A4=;
 b=rF0KDwijDON/zbrp78/xpBVHVcQXI3cZt4WGUdpefqfkQqALP1w8nVbHZDTbrgxMDxy8S5LcZ0QbvakrXb5AzvXwjJ41QU6aAItTue8fmKnXGO53VufnKDxtcevOGdY6Fupifg+w2aU9KjbRN/a2bXzSYJKehAcv8Nr/OVtmMME=
Received: from DM6PR13CA0045.namprd13.prod.outlook.com (2603:10b6:5:134::22)
 by IA1PR12MB6236.namprd12.prod.outlook.com (2603:10b6:208:3e4::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.19; Thu, 23 Feb
 2023 23:52:40 +0000
Received: from DS1PEPF0000E639.namprd02.prod.outlook.com
 (2603:10b6:5:134:cafe::2e) by DM6PR13CA0045.outlook.office365.com
 (2603:10b6:5:134::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.7 via Frontend
 Transport; Thu, 23 Feb 2023 23:52:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS1PEPF0000E639.mail.protection.outlook.com (10.167.17.71) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6134.14 via Frontend Transport; Thu, 23 Feb 2023 23:52:39 +0000
Received: from SATLEXMB08.amd.com (10.181.40.132) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 23 Feb
 2023 17:52:39 -0600
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB08.amd.com
 (10.181.40.132) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 23 Feb
 2023 15:52:38 -0800
Received: from xcbecree41x.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34 via Frontend
 Transport; Thu, 23 Feb 2023 17:52:38 -0600
From:   <edward.cree@amd.com>
To:     <netdev@vger.kernel.org>
CC:     Edward Cree <ecree.xilinx@gmail.com>, <linux-net-drivers@amd.com>,
        <habetsm.xilinx@gmail.com>, <leon@kernel.org>
Subject: [RFC PATCH v2 net-next] sfc: support offloading TC VLAN push/pop actions to the MAE
Date:   Thu, 23 Feb 2023 23:50:26 +0000
Message-ID: <20230223235026.26066-1-edward.cree@amd.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1PEPF0000E639:EE_|IA1PR12MB6236:EE_
X-MS-Office365-Filtering-Correlation-Id: d36ffbcd-acba-43bb-c46e-08db15f90c22
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4W6AdqyKe365+uNL1iwkUYASOuyLHSBK3BIznigZz8B+Rjd7pQUFzq2Cfeat0AoGpxCBC1SheHZ6q7PP4I94Hxc/yELWln5mNmdINHHUXLhY46r+oktMQqsQ1EVwGVxZGsiDsjGxSQEe9z1xUdlUoeKmjdiTW6geTU9YsWlV0HXDq+dFAelfY4IbqQol83iocr/3bxsRzgbRDjlW5pVxkgR3Bz0U+skbEKby40rwi5oMt1U3YtazEV4A0gkpxv44tgnmXgidw4UINxbbhl0aFYrljbDrc1q4l52WhMzdUSsRA2h/cicPiH1b/p6sifkFeo+ebUlDPkOG8CWSH8FU0ei9LXCVrTb2Eq/DWxZ6cHrQA3+5n1qNCoJzOAC9TNQmq7mdzF2Q84p+S4GhCMfjIeaj9b7WZmS9c0tixHobyhI5jSIMQ1gZ/4IoLO9qSWT8kgJGBlTGX9EjtDw1fjR75UZGd/ePSRf6mKprUamGIMPTP9Cxoz3DIf2IFVNxLPm7RxJWqhKD7mhVF9io3hQFd163VyTYUQwQeRBA++86kbfz26gHsvZivNVoJ0WbL9idx7Sjb9PljONvIoFzEO3hMsL3sGgsiEqqHriqFR6m+vkfrNlXXasI4yIu915HsORT7oYxVIEON9Nt4sqG4lzmUXLMRxhEDa+C6i8GINeVAl7vZNnbWDpVtyt/4OsWC8QWLEITOMA6dvToe/rjnsJOsbov22RQaP9N1Oe6At9sqbA=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(376002)(396003)(136003)(346002)(39860400002)(451199018)(46966006)(36840700001)(40470700004)(2616005)(82740400003)(478600001)(70586007)(6916009)(70206006)(426003)(8676002)(336012)(4326008)(83380400001)(6666004)(1076003)(5660300002)(8936002)(41300700001)(26005)(36860700001)(2906002)(186003)(2876002)(47076005)(81166007)(40460700003)(54906003)(316002)(356005)(86362001)(40480700001)(36756003)(82310400005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Feb 2023 23:52:39.6921
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d36ffbcd-acba-43bb-c46e-08db15f90c22
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DS1PEPF0000E639.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6236
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Edward Cree <ecree.xilinx@gmail.com>

EF100 can pop and/or push up to two VLAN tags.

Signed-off-by: Edward Cree <ecree.xilinx@gmail.com>
---
Changed in v2: reworked act->vlan_push/pop to be counts rather than bitmasks,
 and simplified the corresponding efx_tc_action_order handling.

 drivers/net/ethernet/sfc/mae.c  | 16 +++++++++++++
 drivers/net/ethernet/sfc/mcdi.h |  5 +++++
 drivers/net/ethernet/sfc/tc.c   | 40 +++++++++++++++++++++++++++++++++
 drivers/net/ethernet/sfc/tc.h   |  4 ++++
 4 files changed, 65 insertions(+)

diff --git a/drivers/net/ethernet/sfc/mae.c b/drivers/net/ethernet/sfc/mae.c
index 6321fd393fc3..142b3d6ae6aa 100644
--- a/drivers/net/ethernet/sfc/mae.c
+++ b/drivers/net/ethernet/sfc/mae.c
@@ -682,6 +682,10 @@ int efx_mae_alloc_action_set(struct efx_nic *efx, struct efx_tc_action_set *act)
 	size_t outlen;
 	int rc;
 
+	MCDI_POPULATE_DWORD_2(inbuf, MAE_ACTION_SET_ALLOC_IN_FLAGS,
+			      MAE_ACTION_SET_ALLOC_IN_VLAN_PUSH, act->vlan_push,
+			      MAE_ACTION_SET_ALLOC_IN_VLAN_POP, act->vlan_pop);
+
 	MCDI_SET_DWORD(inbuf, MAE_ACTION_SET_ALLOC_IN_SRC_MAC_ID,
 		       MC_CMD_MAE_MAC_ADDR_ALLOC_OUT_MAC_ID_NULL);
 	MCDI_SET_DWORD(inbuf, MAE_ACTION_SET_ALLOC_IN_DST_MAC_ID,
@@ -694,6 +698,18 @@ int efx_mae_alloc_action_set(struct efx_nic *efx, struct efx_tc_action_set *act)
 			       MC_CMD_MAE_COUNTER_ALLOC_OUT_COUNTER_ID_NULL);
 	MCDI_SET_DWORD(inbuf, MAE_ACTION_SET_ALLOC_IN_COUNTER_LIST_ID,
 		       MC_CMD_MAE_COUNTER_LIST_ALLOC_OUT_COUNTER_LIST_ID_NULL);
+	if (act->vlan_push) {
+		MCDI_SET_WORD_BE(inbuf, MAE_ACTION_SET_ALLOC_IN_VLAN0_TCI_BE,
+				 act->vlan_tci[0]);
+		MCDI_SET_WORD_BE(inbuf, MAE_ACTION_SET_ALLOC_IN_VLAN0_PROTO_BE,
+				 act->vlan_proto[0]);
+	}
+	if (act->vlan_push >= 2) {
+		MCDI_SET_WORD_BE(inbuf, MAE_ACTION_SET_ALLOC_IN_VLAN1_TCI_BE,
+				 act->vlan_tci[1]);
+		MCDI_SET_WORD_BE(inbuf, MAE_ACTION_SET_ALLOC_IN_VLAN1_PROTO_BE,
+				 act->vlan_proto[1]);
+	}
 	MCDI_SET_DWORD(inbuf, MAE_ACTION_SET_ALLOC_IN_ENCAP_HEADER_ID,
 		       MC_CMD_MAE_ENCAP_HEADER_ALLOC_OUT_ENCAP_HEADER_ID_NULL);
 	if (act->deliver)
diff --git a/drivers/net/ethernet/sfc/mcdi.h b/drivers/net/ethernet/sfc/mcdi.h
index b139b76febff..454e9d51a4c2 100644
--- a/drivers/net/ethernet/sfc/mcdi.h
+++ b/drivers/net/ethernet/sfc/mcdi.h
@@ -233,6 +233,11 @@ void efx_mcdi_sensor_event(struct efx_nic *efx, efx_qword_t *ev);
 	((void)BUILD_BUG_ON_ZERO(_field ## _LEN != 2),  \
 	le16_to_cpu(*(__force const __le16 *)MCDI_STRUCT_PTR(_buf, _field)))
 /* Write a 16-bit field defined in the protocol as being big-endian. */
+#define MCDI_SET_WORD_BE(_buf, _field, _value) do {			\
+	BUILD_BUG_ON(MC_CMD_ ## _field ## _LEN != 2);			\
+	BUILD_BUG_ON(MC_CMD_ ## _field ## _OFST & 1);			\
+	*(__force __be16 *)MCDI_PTR(_buf, _field) = (_value);		\
+	} while (0)
 #define MCDI_STRUCT_SET_WORD_BE(_buf, _field, _value) do {		\
 	BUILD_BUG_ON(_field ## _LEN != 2);				\
 	BUILD_BUG_ON(_field ## _OFST & 1);				\
diff --git a/drivers/net/ethernet/sfc/tc.c b/drivers/net/ethernet/sfc/tc.c
index deeaab9ee761..12b34320bc81 100644
--- a/drivers/net/ethernet/sfc/tc.c
+++ b/drivers/net/ethernet/sfc/tc.c
@@ -286,6 +286,8 @@ static int efx_tc_flower_parse_match(struct efx_nic *efx,
 
 /* For details of action order constraints refer to SF-123102-TC-1§12.6.1 */
 enum efx_tc_action_order {
+	EFX_TC_AO_VLAN_POP,
+	EFX_TC_AO_VLAN_PUSH,
 	EFX_TC_AO_COUNT,
 	EFX_TC_AO_DELIVER
 };
@@ -294,6 +296,20 @@ static bool efx_tc_flower_action_order_ok(const struct efx_tc_action_set *act,
 					  enum efx_tc_action_order new)
 {
 	switch (new) {
+	case EFX_TC_AO_VLAN_POP:
+		if (act->vlan_pop >= 2)
+			return false;
+		/* If we've already pushed a VLAN, we can't then pop it;
+		 * the hardware would instead try to pop an existing VLAN
+		 * before pushing the new one.
+		 */
+		if (act->vlan_push)
+			return false;
+		fallthrough;
+	case EFX_TC_AO_VLAN_PUSH:
+		if (act->vlan_push >= 2)
+			return false;
+		fallthrough;
 	case EFX_TC_AO_COUNT:
 		if (act->count)
 			return false;
@@ -393,6 +409,7 @@ static int efx_tc_flower_replace(struct efx_nic *efx,
 
 	flow_action_for_each(i, fa, &fr->action) {
 		struct efx_tc_action_set save;
+		u16 tci;
 
 		if (!act) {
 			/* more actions after a non-pipe action */
@@ -494,6 +511,29 @@ static int efx_tc_flower_replace(struct efx_nic *efx,
 			}
 			*act = save;
 			break;
+		case FLOW_ACTION_VLAN_POP:
+			if (act->vlan_push) {
+				act->vlan_push--;
+			} else if (efx_tc_flower_action_order_ok(act, EFX_TC_AO_VLAN_POP)) {
+				act->vlan_pop++;
+			} else {
+				NL_SET_ERR_MSG_MOD(extack, "More than two VLAN pops, or action order violated");
+				rc = -EINVAL;
+				goto release;
+			}
+			break;
+		case FLOW_ACTION_VLAN_PUSH:
+			if (!efx_tc_flower_action_order_ok(act, EFX_TC_AO_VLAN_PUSH)) {
+				rc = -EINVAL;
+				NL_SET_ERR_MSG_MOD(extack, "More than two VLAN pushes, or action order violated");
+				goto release;
+			}
+			tci = fa->vlan.vid & 0x0fff;
+			tci |= fa->vlan.prio << 13;
+			act->vlan_tci[act->vlan_push] = cpu_to_be16(tci);
+			act->vlan_proto[act->vlan_push] = fa->vlan.proto;
+			act->vlan_push++;
+			break;
 		default:
 			NL_SET_ERR_MSG_FMT_MOD(extack, "Unhandled action %u",
 					       fa->id);
diff --git a/drivers/net/ethernet/sfc/tc.h b/drivers/net/ethernet/sfc/tc.h
index 418ce8c13a06..542853f60c2a 100644
--- a/drivers/net/ethernet/sfc/tc.h
+++ b/drivers/net/ethernet/sfc/tc.h
@@ -19,7 +19,11 @@
 #define IS_ALL_ONES(v)	(!(typeof (v))~(v))
 
 struct efx_tc_action_set {
+	u16 vlan_push:2;
+	u16 vlan_pop:2;
 	u16 deliver:1;
+	__be16 vlan_tci[2]; /* TCIs for vlan_push */
+	__be16 vlan_proto[2]; /* Ethertypes for vlan_push */
 	struct efx_tc_counter_index *count;
 	u32 dest_mport;
 	u32 fw_id; /* index of this entry in firmware actions table */
