Return-Path: <netdev+bounces-6052-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 83C097148E7
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 13:51:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2C0431C20837
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 11:51:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E07336FD8;
	Mon, 29 May 2023 11:50:10 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF00B746A
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 11:50:10 +0000 (UTC)
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2076.outbound.protection.outlook.com [40.107.237.76])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D2AE9B
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 04:50:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WT1Sch4Rrr7kMFRMZpl95UTjLeD/tsxQBnPRM8FHAkTwAuxVLZwrS5aR5HPw8LhvvaG6mu/9HG1upBxoHB9R3ebk83sERkAB0hREb0LD3i77NOxVumhtIFz/ZnTty6K2POHyxNsWcmjcC0gCSGlOaqQ5fmh+1WVwIQQ+XPVbBYgOfbPbhV8xoEnapWafTT8Oq089tdzT3hlWduxh/6I8fZ4FP2xLF8red+BUsMAqvyNOuOma/+ZL62W2u9iVOL6WJk4A88IU4QiXq2fvHpe9pf6lzvjaRgIJab32CUvVO7wKTSnjIU9bVtQuaB5tTSPFoxLExAePfJIYTqNnDOH6TA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VSdU3zwmLDiO+kyAaRsEdMZsXlHWLaaAmuYA+aih/7U=;
 b=OeHBEGDOzazBRXjGi5XaQOV6Eu0v/QrSAbprae6W3CrOtPrxX4Zzb0RqFDTmDFjNGA0b3P1l3tfpoZzsIb74huSroaqd//eyeBczOoQRSYeNHP1uJGgshf5GJwEYH9eiACpfYYdu5TdwlaApb6hWEoqshngcC0vUQPxSQWE2ykLhTCwAOtnZDz2vY3kzt6LDpE50JeBMpdbTEzNscNUFPTXOfV0xvuVz7h/TW3P9zJDS21AwEUi0KUFG5B+Nz6Ql0xWfq4gwxymia/VBQ2WdFA3zXMSvmR2kzgkDMizr9FQOcm89wBS5LPDCkptkYPHc0L6UD7iTxz19qrk8Sc404A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VSdU3zwmLDiO+kyAaRsEdMZsXlHWLaaAmuYA+aih/7U=;
 b=Mc1tYqsUuU/w9CfsCldpTCd4hdA8ncJrauRQ34SqY3HFhcHQwZLHfZ6hNIjJQgmaKdxbMh20aknuigB5SOZzv4WOZtBPdtugsh6CXT9RU8HSMNadMCv9GB4ADUzYmFCokX29t8cSItMzVUI0eWAsL9RKV7EJdIDiGms9We+55/wayWppYN0VlzHIp2QjbGXyj0aHh2TzulQHVBsYNMz+pdxtbZ+yCu1o97ENxml5GvX29IMkds7bEIg9qdANLQzEQth2O94SqW3pAMj1N+sh6K8BLIFE186HMAIj4g6800FlAxy2l/RExZ5i55dWU6GmSijikEuUNZMDIyM/y+aadw==
Received: from DS7PR03CA0135.namprd03.prod.outlook.com (2603:10b6:5:3b4::20)
 by SA3PR12MB8763.namprd12.prod.outlook.com (2603:10b6:806:312::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.22; Mon, 29 May
 2023 11:50:07 +0000
Received: from DM6NAM11FT039.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3b4:cafe::30) by DS7PR03CA0135.outlook.office365.com
 (2603:10b6:5:3b4::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.23 via Frontend
 Transport; Mon, 29 May 2023 11:50:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DM6NAM11FT039.mail.protection.outlook.com (10.13.172.83) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6455.21 via Frontend Transport; Mon, 29 May 2023 11:50:07 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Mon, 29 May 2023
 04:49:54 -0700
Received: from dev-r-vrt-155.mtr.labs.mlnx (10.126.231.35) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.37; Mon, 29 May 2023 04:49:48 -0700
From: Ido Schimmel <idosch@nvidia.com>
To: <netdev@vger.kernel.org>, <bridge@lists.linux-foundation.org>
CC: <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
	<edumazet@google.com>, <taras.chornyi@plvision.eu>, <saeedm@nvidia.com>,
	<leon@kernel.org>, <petrm@nvidia.com>, <vladimir.oltean@nxp.com>,
	<claudiu.manoil@nxp.com>, <alexandre.belloni@bootlin.com>,
	<UNGLinuxDriver@microchip.com>, <jhs@mojatatu.com>,
	<xiyou.wangcong@gmail.com>, <jiri@resnulli.us>, <roopa@nvidia.com>,
	<razor@blackwall.org>, <simon.horman@corigine.com>, Ido Schimmel
	<idosch@nvidia.com>
Subject: [PATCH net-next v2 5/8] mlxsw: spectrum_flower: Split iif parsing to a separate function
Date: Mon, 29 May 2023 14:48:32 +0300
Message-ID: <20230529114835.372140-6-idosch@nvidia.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230529114835.372140-1-idosch@nvidia.com>
References: <20230529114835.372140-1-idosch@nvidia.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT039:EE_|SA3PR12MB8763:EE_
X-MS-Office365-Filtering-Correlation-Id: 57489f9b-32dd-47c9-39ce-08db603ad951
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	jBhAwmeXVeABhhK/rfFy7a7NE9k1d9fVJ3rE3KAnLOKhf32I5RDtPSlbIjOG29SvEKtpm2pF7HFjzDT6Lf0kKVtpOGgSYWEMVfLceylPkyzEtoiv5k0kLUyIGmwTTXh6GaXFA6qkFuZWE24QTxKh6C19M50/3yPCe2wj4jXBxc7ElV/bISjRsTQ6Hi5Cr2wNY+gsDEzWVNvxrqbvJ9emOdmRgLWP4fCKHei9uQQPPP4ujqcPidSuVclSvFFDJeM/Pk9K7dj6UnBe67yLw+9gfjrdkczX8JlS6WjsKXlM/g99WYTEGZBOIlu/O1APBUVZ4o6cX2P3hA7M3Lg757vtfUgaysL2gh2ntrmMAmX0WhKs7wit5xIY9ddW4QQFwB5GBWTy7lvo/wtymnQSsMuhnNJgBeP2+sCtof3UwhC69ZtCYrc8GcQD/u8xNNZGRjErXXBZ0Ru/5AHNrtzSbXIAeIfU4SxZARnR3sFviiDEVnbqq6thFCXgX1cgkN9hdr8p1LMehKy29Z22Srx6FSK68yi5qKWj03fuOb+1MR0WcVnNbLQtP/kYfsvxpE1+GP4F46hKNisYSOITsPxK3BtOsi9z/N3PfdvvKg4bpQmwBMguw39Gps1TZW2SWuVqTwyM3qw9Y/HBkuyaZusJ0cTlaAdShgCdHEeHTMfztTdelvlMjcH00FPZres2npRf77Ue9q4y6QK+Q8qcfDlwcwNLEqMHZKmbsdrSRFLWaUtKH1DwcokpyT6s908CuMIjWa6w
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(136003)(39860400002)(346002)(376002)(396003)(451199021)(46966006)(36840700001)(40470700004)(82310400005)(86362001)(41300700001)(40480700001)(40460700003)(4326008)(6666004)(316002)(7416002)(36756003)(70206006)(70586007)(107886003)(36860700001)(5660300002)(16526019)(186003)(478600001)(2906002)(1076003)(26005)(2616005)(47076005)(83380400001)(426003)(336012)(54906003)(8676002)(8936002)(82740400003)(356005)(7636003)(110136005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 May 2023 11:50:07.1999
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 57489f9b-32dd-47c9-39ce-08db603ad951
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DM6NAM11FT039.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB8763
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Currently, mlxsw only supports the 'ingress_ifindex' field in the
'FLOW_DISSECTOR_KEY_META' key, but subsequent patches are going to add
support for the 'l2_miss' field as well. Split the parsing of the
'ingress_ifindex' field to a separate function to avoid nesting. No
functional changes intended.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---

Notes:
    v2:
    * New patch.

 .../ethernet/mellanox/mlxsw/spectrum_flower.c | 54 +++++++++++--------
 1 file changed, 33 insertions(+), 21 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
index 6fec9223250b..2b0bae847eb9 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
@@ -281,45 +281,35 @@ static int mlxsw_sp_flower_parse_actions(struct mlxsw_sp *mlxsw_sp,
 	return 0;
 }
 
-static int mlxsw_sp_flower_parse_meta(struct mlxsw_sp_acl_rule_info *rulei,
-				      struct flow_cls_offload *f,
-				      struct mlxsw_sp_flow_block *block)
+static int
+mlxsw_sp_flower_parse_meta_iif(struct mlxsw_sp_acl_rule_info *rulei,
+			       const struct mlxsw_sp_flow_block *block,
+			       const struct flow_match_meta *match,
+			       struct netlink_ext_ack *extack)
 {
-	struct flow_rule *rule = flow_cls_offload_flow_rule(f);
 	struct mlxsw_sp_port *mlxsw_sp_port;
 	struct net_device *ingress_dev;
-	struct flow_match_meta match;
-
-	if (!flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_META))
-		return 0;
-
-	flow_rule_match_meta(rule, &match);
 
-	if (match.mask->l2_miss) {
-		NL_SET_ERR_MSG_MOD(f->common.extack, "Can't match on \"l2_miss\"");
-		return -EOPNOTSUPP;
-	}
-
-	if (match.mask->ingress_ifindex != 0xFFFFFFFF) {
-		NL_SET_ERR_MSG_MOD(f->common.extack, "Unsupported ingress ifindex mask");
+	if (match->mask->ingress_ifindex != 0xFFFFFFFF) {
+		NL_SET_ERR_MSG_MOD(extack, "Unsupported ingress ifindex mask");
 		return -EINVAL;
 	}
 
 	ingress_dev = __dev_get_by_index(block->net,
-					 match.key->ingress_ifindex);
+					 match->key->ingress_ifindex);
 	if (!ingress_dev) {
-		NL_SET_ERR_MSG_MOD(f->common.extack, "Can't find specified ingress port to match on");
+		NL_SET_ERR_MSG_MOD(extack, "Can't find specified ingress port to match on");
 		return -EINVAL;
 	}
 
 	if (!mlxsw_sp_port_dev_check(ingress_dev)) {
-		NL_SET_ERR_MSG_MOD(f->common.extack, "Can't match on non-mlxsw ingress port");
+		NL_SET_ERR_MSG_MOD(extack, "Can't match on non-mlxsw ingress port");
 		return -EINVAL;
 	}
 
 	mlxsw_sp_port = netdev_priv(ingress_dev);
 	if (mlxsw_sp_port->mlxsw_sp != block->mlxsw_sp) {
-		NL_SET_ERR_MSG_MOD(f->common.extack, "Can't match on a port from different device");
+		NL_SET_ERR_MSG_MOD(extack, "Can't match on a port from different device");
 		return -EINVAL;
 	}
 
@@ -327,9 +317,31 @@ static int mlxsw_sp_flower_parse_meta(struct mlxsw_sp_acl_rule_info *rulei,
 				       MLXSW_AFK_ELEMENT_SRC_SYS_PORT,
 				       mlxsw_sp_port->local_port,
 				       0xFFFFFFFF);
+
 	return 0;
 }
 
+static int mlxsw_sp_flower_parse_meta(struct mlxsw_sp_acl_rule_info *rulei,
+				      struct flow_cls_offload *f,
+				      struct mlxsw_sp_flow_block *block)
+{
+	struct flow_rule *rule = flow_cls_offload_flow_rule(f);
+	struct flow_match_meta match;
+
+	if (!flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_META))
+		return 0;
+
+	flow_rule_match_meta(rule, &match);
+
+	if (match.mask->l2_miss) {
+		NL_SET_ERR_MSG_MOD(f->common.extack, "Can't match on \"l2_miss\"");
+		return -EOPNOTSUPP;
+	}
+
+	return mlxsw_sp_flower_parse_meta_iif(rulei, block, &match,
+					      f->common.extack);
+}
+
 static void mlxsw_sp_flower_parse_ipv4(struct mlxsw_sp_acl_rule_info *rulei,
 				       struct flow_cls_offload *f)
 {
-- 
2.40.1


