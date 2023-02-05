Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AE9668B013
	for <lists+netdev@lfdr.de>; Sun,  5 Feb 2023 14:55:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229733AbjBENzs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Feb 2023 08:55:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229581AbjBENzr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Feb 2023 08:55:47 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2046.outbound.protection.outlook.com [40.107.223.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37D501E2BC
        for <netdev@vger.kernel.org>; Sun,  5 Feb 2023 05:55:46 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eNOeWhxvNuXW+XChI2+7Dlvpec4T+x8NtJlih5Y5pZ2B5SvqIKhNuoaTzM04tl0ec44OlMjR7/BpRFIbdfAT2KCzmczZjAefqbHgwTFgjsQJxNz9g1nwJxapZ20ANznpSYia+CE3hjGAuOFLSi4i+4AafFw6S6DtZmi5/oqa8TLdMtdIr5vnYGcAVR3hLD6J8KD8ucsAi2yFrzi6l46ztfK/mAP7i2iH1vkXIFnIyD2ZTaKQshY3xO/3QqI/rFIj8aH2B0Ufcu8IGTjPGLVbjBFgwavSeuasTC5WaTBixyigXantg4ihwJ4Z3mmiYHSSlVEPG89maVgU9DVyEXh/7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kjOoDS0OBM1oMuck7yvRmu/UAhKFur17MBXZ5OTCYcw=;
 b=Ua0boJM3zoAKTv8NjD8kYJKEwfWMAeTfUG17S7UEi1zMpNSX3a+X0fplI/eKyKCSK2tAjoqWltLTVnm5eEFGcuKPyZxhmsYXrdzBJYe+zpxsg2eOczVUic8eu1LWzEshqZmC7NMk7xzQ1/FIv9W+/nBbAheIj31vcrNs4IIOsLgYGhDRgxn1MRokHZGa1NCG/WOtjZbbz+BeJSy74TpYcqOI04M73wF/FlqiAcdbQM62vYBOKmKtNHsHRDs3ReLo6i+0HTt6eNbUHCexzTfOIG1JeEU86ZzjAsrYvihgtxYk0lmznWawB0AKmEKCpRsS21YJd+2Y4m1Df2x5gG+IRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kjOoDS0OBM1oMuck7yvRmu/UAhKFur17MBXZ5OTCYcw=;
 b=ViDzgDhiyzeae14AJwLnCzCo2ibxVBHj8r8NVOFoU5g99vUxLVhLkdiBasU2H5+IvmD37XUzI/HPHmQZ7DnFHIQeJ6EitCvNvYqqgEegLVievYQDn4uOTMjOZY7Qs7MnfuSACkUmxTKcwV7re/PLy/YKkhXxIAmbQjLJUxaDUJx3RjvDqGIDA8bM8i6u1o0VXjHvt3S5h+JOYh8lEDIXNY6cyW4NK/hv5QcGmAPvu0gEAzkNGOdafBMk6uBrTgsAqlTuYAQUWCnmr1CMz4eNwXTchJUBjMDWflL9NWUqi72GgDzNmPTGI5f0PnP8YAW7cowyZm22nf+8jc0/BTQ7CQ==
Received: from DM6PR08CA0012.namprd08.prod.outlook.com (2603:10b6:5:80::25) by
 IA0PR12MB7675.namprd12.prod.outlook.com (2603:10b6:208:433::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6064.27; Sun, 5 Feb 2023 13:55:43 +0000
Received: from DM6NAM11FT104.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:80:cafe::18) by DM6PR08CA0012.outlook.office365.com
 (2603:10b6:5:80::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.34 via Frontend
 Transport; Sun, 5 Feb 2023 13:55:42 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DM6NAM11FT104.mail.protection.outlook.com (10.13.173.232) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6064.34 via Frontend Transport; Sun, 5 Feb 2023 13:55:42 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Sun, 5 Feb 2023
 05:55:38 -0800
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Sun, 5 Feb 2023
 05:55:37 -0800
Received: from reg-r-vrt-019-180.mtr.labs.mlnx (10.127.8.11) by
 mail.nvidia.com (10.129.68.9) with Microsoft SMTP Server id 15.2.986.36 via
 Frontend Transport; Sun, 5 Feb 2023 05:55:35 -0800
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
Subject: [PATCH  net-next v2 2/9] net/sched: act_pedit, setup offload action for action stats query
Date:   Sun, 5 Feb 2023 15:55:18 +0200
Message-ID: <20230205135525.27760-3-ozsh@nvidia.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20230205135525.27760-1-ozsh@nvidia.com>
References: <20230205135525.27760-1-ozsh@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT104:EE_|IA0PR12MB7675:EE_
X-MS-Office365-Filtering-Correlation-Id: a9a7c31f-07d3-4ace-0b05-08db0780ac26
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Tc2GqWje+vb9Gg8Lh798MnTNqtNCvolT4EciTLvCw37S3P9i2MotKDQJ2y2NueQaupBbzBIk2WG8P80+1C2PzdCkVFNZA0aEJn3IP2lhZBYVM3lv1b8+68oM65l/5ZhsYsedNspIFbPPKbOJ3g+EkI2iJsCisntzOy2YIOnVZVigfZmMffbO9XKKc4pD4d9dC1mD6+mGJ3c2oadcvgqOGOIepHbxEoR6sWK1tTPpeCi2aQhLJhnxNJmlJv0US8sQYjSEy64HfSN6ExeE/7or7aqupxPpHztP8ygSG1KVnm6T/gceJqL72nRdm0QDGho9MwSi6BuE+pIRJEyalym1SvEcu6aYt4jtjRO3x1/8Vt8skVJ6wO4hB19yrhFGoNCAkZkopXVOR2kR3WzltNkBrSS9rVbTPRK2/25e8oyNUm+DIlzSH4uUPYtoA/76e+RW9spojD6OsxzLlv24x+gUReDAGnDJrJAQc+TgEc0LaH96wp4c1ECj/NkUoeFaHvZnrHoG60UScaz1mrSU7SJgt+AIjxtQ4KnJbMbEN4q2gOgUbF1lxeTPwQE/j9LNhwWEpTpLrbzUWy/RpCW+t0Gr0iwgotgAw0ryYfiemYZEtBxkwRKECeFXVEe+qAvOQEDHBFt2qzU60D5XcAu6q6gm7guSmXX4YmkxwbXarCOlT++cn6BRaxu96ZIw+j6IRFESnq4rJilW9A3e6yntA5OW4g==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(136003)(396003)(39860400002)(346002)(376002)(451199018)(36840700001)(40470700004)(46966006)(186003)(82310400005)(478600001)(7636003)(2906002)(26005)(6666004)(1076003)(70586007)(8676002)(8936002)(41300700001)(107886003)(6916009)(4326008)(70206006)(5660300002)(83380400001)(316002)(426003)(36756003)(336012)(82740400003)(356005)(54906003)(40480700001)(86362001)(2616005)(40460700003)(47076005)(36860700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2023 13:55:42.6877
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a9a7c31f-07d3-4ace-0b05-08db0780ac26
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT104.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB7675
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
---
 net/sched/act_pedit.c | 28 +++++++++++++++++++++++++++-
 1 file changed, 27 insertions(+), 1 deletion(-)

diff --git a/net/sched/act_pedit.c b/net/sched/act_pedit.c
index c42fcc47dd6d..dae88e205cb1 100644
--- a/net/sched/act_pedit.c
+++ b/net/sched/act_pedit.c
@@ -545,7 +545,33 @@ static int tcf_pedit_offload_act_setup(struct tc_action *act, void *entry_data,
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
+			cmd = tcf_pedit_cmd(act, k);
+
+			if (cmd != last_cmd) {
+				NL_SET_ERR_MSG_MOD(extack, "Unsupported pedit command offload");
+				return -EOPNOTSUPP;
+			}
+
+			last_cmd = cmd;
+		}
 	}
 
 	return 0;
-- 
1.8.3.1

