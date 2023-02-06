Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD48C68BF20
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 15:01:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230333AbjBFOBD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 09:01:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231232AbjBFOAe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 09:00:34 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2074.outbound.protection.outlook.com [40.107.220.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 020F625977
        for <netdev@vger.kernel.org>; Mon,  6 Feb 2023 06:00:23 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dXg4UnngiNWJpX/Z5RgWJTFLWXxM+JDG7Dn3N6EYh4KftWB8wS1UTKTfV4POXOLNeoo9f0zY322gbEj6wrKKpcNeET+opSvcSw3Y1xHcr7/5EehbAUEuFLMKiIReDM16YmZPalSoWXoXlUAJfAuhuTDOt4ixdNwblybIh4cov56n2fV4EQ6xkAV/91LxuJb/WtxJyr62Mxmg+MoPTX2N5PLQ5r5fgpWtB4CWrj0n8d/zTMkaioifsB5d1WMblN7/Kdh+ME/ltmtB1/9CUrKQDEE1h8WlzyT31ERNQW822ntL9Yf54nhwsKX7BDftezGa8gsfas0RRUVO/2yE6Y2DdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=e/0TXdOq2Aq9wVekOrNIz1RxpxU9N5Q8aJNDtqw2Ohk=;
 b=g/LlL2AwhbqGqPaYANotQFlASjREFe0LdsXZ2QMcAu/nybzgE2HyWnPnVLYgkWElO8smkMrSJaw1c729TYvyP0f1Kik7pPxZ4/nhn4m7MMZo3FDaxOSXL9aPrgExkiitlFinw3lAmExktsQvg4yq31E+UtMTyem2eHgD1XnKvDtKUeZPW8lsiGpNapitl58r0JxHl/+/udrCarMkbsxur0XhjdH3UppG/EJ5LwCYpVQSW1pCw4lH/YtYa0NCw527WQhLi80RL0nEAOIBu0T6AHUKScRVFYMK+aznWP78FNnwZk2UptzdVaJjDaX588ksUQsx6gMS2HtdB2INyMWnsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e/0TXdOq2Aq9wVekOrNIz1RxpxU9N5Q8aJNDtqw2Ohk=;
 b=OzlwKBY5P2bxXT2EO3+EHx5PWUDRQ+K+h6cJ2Sl5qCz94Y84WR3emLCGDiKRztAJ077puMrH9cNTerXA3beZwcAyRIEDbY2anqy5+sH+mM+DSMiZvzujPsqJHMTbwsEgwRGFW1K/I0kHVUx2suTLTNk9+9aBsNiwiFOJ/iItWzZAyP2X6bWfMSZdMHj03qYhqNjbGRBTX4H9GEQmDYXxRfB2oDcLFhmaHN/K7vWJfy3rre4QzgZUvnjf4GsY4Ia/4P3CV61cLBO74H5I60zEL8xTg2zq4dB0Roiji3YxblfuYnQhPwjXuoPUYCJQFjMPDDZarBgF+7SsV3uzH71PDg==
Received: from BN9PR03CA0758.namprd03.prod.outlook.com (2603:10b6:408:13a::13)
 by IA0PR12MB7752.namprd12.prod.outlook.com (2603:10b6:208:431::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.34; Mon, 6 Feb
 2023 14:00:21 +0000
Received: from BN8NAM11FT033.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:13a:cafe::90) by BN9PR03CA0758.outlook.office365.com
 (2603:10b6:408:13a::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.34 via Frontend
 Transport; Mon, 6 Feb 2023 14:00:21 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 BN8NAM11FT033.mail.protection.outlook.com (10.13.177.149) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6064.32 via Frontend Transport; Mon, 6 Feb 2023 14:00:21 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Mon, 6 Feb 2023
 06:00:11 -0800
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Mon, 6 Feb 2023 06:00:10 -0800
Received: from reg-r-vrt-019-180.mtr.labs.mlnx (10.127.8.11) by
 mail.nvidia.com (10.126.190.180) with Microsoft SMTP Server id 15.2.986.36
 via Frontend Transport; Mon, 6 Feb 2023 06:00:08 -0800
From:   Oz Shlomo <ozsh@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     Saeed Mahameed <saeedm@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        "Jiri Pirko" <jiri@nvidia.com>,
        Marcelo Ricardo Leitner <mleitner@redhat.com>,
        "Simon Horman" <simon.horman@corigine.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        "Oz Shlomo" <ozsh@nvidia.com>
Subject: [PATCH  net-next v3 2/9] net/sched: act_pedit, setup offload action for action stats query
Date:   Mon, 6 Feb 2023 15:54:35 +0200
Message-ID: <20230206135442.15671-3-ozsh@nvidia.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20230206135442.15671-1-ozsh@nvidia.com>
References: <20230206135442.15671-1-ozsh@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT033:EE_|IA0PR12MB7752:EE_
X-MS-Office365-Filtering-Correlation-Id: 8ae79492-7792-4ed4-00bf-08db084a7ce4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wQlb/XIqVK6L6YAJyrL6kbJ8RVu3ohh3sGGXT2xKy+8ft/JSAP7Do2unnLWX8eH2kmM8efWJ3Yva7uIGmWhU5L1yu8LqgxNE/UdCUw+ogBCEYH2Z6E6aVopTgzfjYyh6jdiDBdfTu+jMV+dsP/MQ6+slewKs9wfzWGkoTRlH5lOZTZsBpfMXn4ruyebntSc1IhrIFKGAU4bzNFu9fG3xmFhm1dmlkk0XXSdUyRdhjh/1S/N//gP22sNxsTlGhbAdD/plafE+nK8J7qF2yFlI6Kjs8fzI8jkS/Oa4/oSMifAxmky0fmHvo7UhjEGGLOaMY/krHOOpOJRQy2HM1ZIxzKqNFPOj5yyEYSV0zROaUlA4kM7jiD4IKqSMv9PBtBAjlDq5b6bZ3ROg69HjrVbnuQMRVSUvKYPAFlYRg4tjywEarbVHSHlB1ZDEw1Z8jEpu8wn9lazw4pBLjgGW+HfDqR5lmU29w6D+eN8yFxJ2o6rNvP6njTciChohTDQLUpbgmi361+g2/5CdVSjMfTNWNdK+HUwQq5Pp5k46bDwgjtUW+dov9y5Xlc8uXabuvJZx5LQwTEHzsJkOgj3/5dfGm8UhR9cxky1geqovA4LKt9a/cKCXPqOLp9nFndCphPu/uDCwqv583eFNEk/qOiGQOAL9+jZ9CY99efijS4ci2gjDKRuQuBzjb1u2U+lOz+i9jpJjEv95/IXiZBEaxdgC1w==
X-Forefront-Antispam-Report: CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(136003)(346002)(39860400002)(376002)(396003)(451199018)(36840700001)(40470700004)(46966006)(82310400005)(40460700003)(6916009)(1076003)(40480700001)(107886003)(6666004)(478600001)(2616005)(8676002)(186003)(26005)(4326008)(70586007)(70206006)(316002)(54906003)(36756003)(82740400003)(7636003)(356005)(86362001)(426003)(47076005)(83380400001)(36860700001)(336012)(5660300002)(41300700001)(8936002)(2906002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2023 14:00:21.6945
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ae79492-7792-4ed4-00bf-08db084a7ce4
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT033.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB7752
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A single tc pedit action may be translated to multiple flow_offload
actions.
Offload only actions that translate to a single pedit command value.

Signed-off-by: Oz Shlomo <ozsh@nvidia.com>

---
Change log:

V1 -> V2:
    - Add extack message on error
    - Assign the flow action id outside the for loop.
      Ensure the rest of the pedit actions follow the assigned id.

V2 -> V3:
    - Fix last_cmd initialization
---
 net/sched/act_pedit.c | 27 ++++++++++++++++++++++++++-
 1 file changed, 26 insertions(+), 1 deletion(-)

diff --git a/net/sched/act_pedit.c b/net/sched/act_pedit.c
index c42fcc47dd6d..924beb76f5b7 100644
--- a/net/sched/act_pedit.c
+++ b/net/sched/act_pedit.c
@@ -545,7 +545,32 @@ static int tcf_pedit_offload_act_setup(struct tc_action *act, void *entry_data,
 		}
 		*index_inc = k;
 	} else {
-		return -EOPNOTSUPP;
+		struct flow_offload_action *fl_action = entry_data;
+		u32 cmd = tcf_pedit_cmd(act, 0);
+		u32 last_cmd;
+		int k;
+
+		switch (cmd) {
+		case TCA_PEDIT_KEY_EX_CMD_SET:
+			fl_action->id = FLOW_ACTION_MANGLE;
+			break;
+		case TCA_PEDIT_KEY_EX_CMD_ADD:
+			fl_action->id = FLOW_ACTION_ADD;
+			break;
+		default:
+			NL_SET_ERR_MSG_MOD(extack, "Unsupported pedit command offload");
+			return -EOPNOTSUPP;
+		}
+
+		for (k = 1; k < tcf_pedit_nkeys(act); k++) {
+			last_cmd = cmd;
+			cmd = tcf_pedit_cmd(act, k);
+
+			if (cmd != last_cmd) {
+				NL_SET_ERR_MSG_MOD(extack, "Unsupported pedit command offload");
+				return -EOPNOTSUPP;
+			}
+		}
 	}
 
 	return 0;
-- 
1.8.3.1

