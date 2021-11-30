Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EBF1463D87
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 19:16:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239483AbhK3STq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 13:19:46 -0500
Received: from mail-bn8nam12on2056.outbound.protection.outlook.com ([40.107.237.56]:12784
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239326AbhK3STp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Nov 2021 13:19:45 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CDnCzuadmLLA9hCcQYj5DzBlQp9Fvx5MEQiVrAjNMWJHc8rAos86yPht4BXJWm1adEedqLb5JOQHaHUwsSJ/sQDb72PJp2hY/y0jpscSj4noVgeS/OpJrPDe0q5B4oZX8pRJRgpOMTgo2exUg9kPALI49Oft0vxB7ZHQtmDI7u9SSy8rcVRhGoHCjzfHYPsqqOIwJ5Y2aPFK+nm2Ry9biRblWBLnCq4DcxeBYH8V/CtVgk+FisjFhFiCuD3g3vmHcoPt8lPcKjxsrOCEqF9KsYOpc2+Wehki+JZT0IQUb1GTx9+DrI6b0riYqBVsm5lpkCS2SQQz/0rigzuka4wrlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bNNm7qJM3ZO/NLRTD+8n6yEeGBpDql22y8iVkjYWCug=;
 b=WyU3EGzKZBONl9IsZWW2IcfSu2RzTHwtPNXcVGbZ53J2Tn5zWwg4ZKjK8c+96GIaxiKnhEb9SpRUftOWdqyR4jTH1tGkemNW3cYUgn2MuPmt4R1TpXDx3dSwrwmnvsTJkzwB7Gv1NoWSQCv/E7rxTcHEFDOxXY5aInngmIA2WSAi1pEmuc3YV3qj0qWfKeQh6NhKrVWDet9YrWrbXpgvouF7HoWFmUUfQq8wvzdY3jm5yLiVy/sWaMV17C/MbTYCKhcXlQW9DnFSNBz8O0CGMIeckVprfr4MDOWgmckT7eQNKS2SfrOahQoMWkB8bZQnDsx4LZPN/e+xyOv2rc83MQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bNNm7qJM3ZO/NLRTD+8n6yEeGBpDql22y8iVkjYWCug=;
 b=j8mkyCPRL6qAjfc9g0yNqBMGoWk/iHjnHSJsBp13F8P6y7azw5OXKjAW3IQT8bwCEz7Byg2yosw5hR9mXCiC66sytxciyiwPf2gMBGnFOFZnSaLUdkmYDq277xu7DE/XwgL5UQZVGjPbgiV+VN7yDz2046i9rEpIBQ4z82VAr1B9Qpmm2l/hKPfLfi/6J0zcc8xr7k9hvV/c6qFp2RyvjsnvGOteFh9B5KPIFTE3ZVaM0kTGsrg7IZSGISgZHOBYm8UYS/rulzcRB0Tm3bXIMMUK6CF2LgfRU9mjpz6qIagFh/iykhwJc3oymoQwEN9/TjYGkbY24CiKw7f0RregRg==
Received: from DM5PR06CA0057.namprd06.prod.outlook.com (2603:10b6:3:37::19) by
 BL0PR12MB4994.namprd12.prod.outlook.com (2603:10b6:208:1ca::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.11; Tue, 30 Nov
 2021 18:16:24 +0000
Received: from DM6NAM11FT047.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:37:cafe::17) by DM5PR06CA0057.outlook.office365.com
 (2603:10b6:3:37::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.11 via Frontend
 Transport; Tue, 30 Nov 2021 18:16:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT047.mail.protection.outlook.com (10.13.172.139) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4734.22 via Frontend Transport; Tue, 30 Nov 2021 18:16:24 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 30 Nov
 2021 18:16:23 +0000
Received: from vdi.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Tue, 30 Nov 2021 18:16:20 +0000
From:   Maxim Mikityanskiy <maximmi@nvidia.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>
CC:     Shuah Khan <shuah@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        Maxim Mikityanskiy <maximmi@nvidia.com>
Subject: [PATCH bpf] bpf: Fix the off-by-two error in range markings
Date:   Tue, 30 Nov 2021 20:16:07 +0200
Message-ID: <20211130181607.593149-1-maximmi@nvidia.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2b6510de-0be2-4955-ad98-08d9b42d84d6
X-MS-TrafficTypeDiagnostic: BL0PR12MB4994:
X-Microsoft-Antispam-PRVS: <BL0PR12MB49945FC5276BDD608152D59EDC679@BL0PR12MB4994.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1201;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: P33bd6f4iplGME0Bm97MxdiokxCEvYpTo89zBVsZy4X5gNsM8o/LvZOLxkSQM4NWDUPyWuzcZNdWQyC9Azq4jvaphTm3Gdpngdz3gRy4VIKAQs2e9DRpdjHzFIs/tBT4P1ZQOkRig2HIwhNwjjDg7e1CQvz/jVdOAgQ6g5CtwYa7Q3I/osdSkZFxEqO2HiesTuREktH/WsoKJCuAI4IbxWQk+53hmb9xXVybanYN9J7PmOLOTqqCZrVLvEZf/1rhvb7ytrsxGHZnxOtmVPQFgdhhh9P7zfPS0dhea6XbLNsyWBh+qjkJ0xP7f2fNZSZwd41p/qKwc4S9q43nuIU/fjuN2tqgOYPb3gKxAyG9VBRCNmbvg4Odvb0eYLESfomDEj767vnzo2UnsHMFrIq+RUerO/SqKXVaOddtdanYmt3G2Y+PsE/SQIoJCe7H4xnTxRQ9X8CXeGTlyEkwd1cjbsXzSFmM+EoUvH1liqh02i+J9Ge1hjFpqMrmRv6NQLtCBqubA32OJx1Yl4EIdX2Z0UC1u+k5FSxHD+C7Lol9aoTJDukSwP00zP5fZxgz9g4TgAD7beeAX9rS7KEky3DzPjUMGKYrsGHrCV2aj+vYd2xShLZ4zJbI7eleqYGAAkZMVCT8MjALKCCfp4X/1PlA+mi9J95hDAIif4fKDUlRTN7Ba+s3pRFSKEe8qpfDT/4USjjy8VUk8Vo9zp+/1zlAYrlIUcffFlQtk9VNhEfiHe33TaeWdPeRA9rCdGsKprIJU0NkJ1/iocvRjBx1yi5xjA==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(40470700001)(186003)(82310400004)(54906003)(8936002)(86362001)(1076003)(7416002)(508600001)(36756003)(5660300002)(110136005)(7696005)(40460700001)(26005)(36860700001)(8676002)(6666004)(4326008)(336012)(47076005)(426003)(70586007)(356005)(316002)(7636003)(70206006)(83380400001)(2616005)(107886003)(2906002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Nov 2021 18:16:24.2976
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b6510de-0be2-4955-ad98-08d9b42d84d6
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT047.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB4994
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The first commit cited below attempts to fix the off-by-one error that
appeared in some comparisons with an open range. Due to this error,
arithmetically equivalent pieces of code could get different verdicts
from the verifier, for example (pseudocode):

  // 1. Passes the verifier:
  if (data + 8 > data_end)
      return early
  read *(u64 *)data, i.e. [data; data+7]

  // 2. Rejected by the verifier (should still pass):
  if (data + 7 >= data_end)
      return early
  read *(u64 *)data, i.e. [data; data+7]

The attempted fix, however, shifts the range by one in a wrong
direction, so the bug not only remains, but also such piece of code
starts failing in the verifier:

  // 3. Rejected by the verifier, but the check is stricter than in #1.
  if (data + 8 >= data_end)
      return early
  read *(u64 *)data, i.e. [data; data+7]

The change performed by that fix converted an off-by-one bug into
off-by-two. The second commit cited below added the BPF selftests
written to ensure than code chunks like #3 are rejected, however,
they should be accepted.

This commit fixes the off-by-two error by adjusting new_range in the
right direction and fixes the tests by changing the range into the one
that should actually fail.

Fixes: fb2a311a31d3 ("bpf: fix off by one for range markings with L{T, E} patterns")
Fixes: b37242c773b2 ("bpf: add test cases to bpf selftests to cover all access tests")
Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
---
After this patch is merged, I'm going to submit another patch to
bpf-next, that will add new selftests for this bug.

 kernel/bpf/verifier.c                         |  2 +-
 .../bpf/verifier/xdp_direct_packet_access.c   | 32 +++++++++----------
 2 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 50efda51515b..f3001937bbb9 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -8422,7 +8422,7 @@ static void find_good_pkt_pointers(struct bpf_verifier_state *vstate,
 
 	new_range = dst_reg->off;
 	if (range_right_open)
-		new_range--;
+		new_range++;
 
 	/* Examples for register markings:
 	 *
diff --git a/tools/testing/selftests/bpf/verifier/xdp_direct_packet_access.c b/tools/testing/selftests/bpf/verifier/xdp_direct_packet_access.c
index bfb97383e6b5..de172a5b8754 100644
--- a/tools/testing/selftests/bpf/verifier/xdp_direct_packet_access.c
+++ b/tools/testing/selftests/bpf/verifier/xdp_direct_packet_access.c
@@ -112,10 +112,10 @@
 	BPF_LDX_MEM(BPF_W, BPF_REG_3, BPF_REG_1,
 		    offsetof(struct xdp_md, data_end)),
 	BPF_MOV64_REG(BPF_REG_1, BPF_REG_2),
-	BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, 8),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, 6),
 	BPF_JMP_REG(BPF_JGT, BPF_REG_3, BPF_REG_1, 1),
 	BPF_JMP_IMM(BPF_JA, 0, 0, 1),
-	BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1, -8),
+	BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1, -6),
 	BPF_MOV64_IMM(BPF_REG_0, 0),
 	BPF_EXIT_INSN(),
 	},
@@ -167,10 +167,10 @@
 	BPF_LDX_MEM(BPF_W, BPF_REG_3, BPF_REG_1,
 		    offsetof(struct xdp_md, data_end)),
 	BPF_MOV64_REG(BPF_REG_1, BPF_REG_2),
-	BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, 8),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, 6),
 	BPF_JMP_REG(BPF_JLT, BPF_REG_1, BPF_REG_3, 1),
 	BPF_JMP_IMM(BPF_JA, 0, 0, 1),
-	BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1, -8),
+	BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1, -6),
 	BPF_MOV64_IMM(BPF_REG_0, 0),
 	BPF_EXIT_INSN(),
 	},
@@ -274,9 +274,9 @@
 	BPF_LDX_MEM(BPF_W, BPF_REG_3, BPF_REG_1,
 		    offsetof(struct xdp_md, data_end)),
 	BPF_MOV64_REG(BPF_REG_1, BPF_REG_2),
-	BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, 8),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, 6),
 	BPF_JMP_REG(BPF_JGE, BPF_REG_1, BPF_REG_3, 1),
-	BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1, -8),
+	BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1, -6),
 	BPF_MOV64_IMM(BPF_REG_0, 0),
 	BPF_EXIT_INSN(),
 	},
@@ -437,9 +437,9 @@
 	BPF_LDX_MEM(BPF_W, BPF_REG_3, BPF_REG_1,
 		    offsetof(struct xdp_md, data_end)),
 	BPF_MOV64_REG(BPF_REG_1, BPF_REG_2),
-	BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, 8),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, 6),
 	BPF_JMP_REG(BPF_JLE, BPF_REG_3, BPF_REG_1, 1),
-	BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1, -8),
+	BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1, -6),
 	BPF_MOV64_IMM(BPF_REG_0, 0),
 	BPF_EXIT_INSN(),
 	},
@@ -544,10 +544,10 @@
 		    offsetof(struct xdp_md, data_meta)),
 	BPF_LDX_MEM(BPF_W, BPF_REG_3, BPF_REG_1, offsetof(struct xdp_md, data)),
 	BPF_MOV64_REG(BPF_REG_1, BPF_REG_2),
-	BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, 8),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, 6),
 	BPF_JMP_REG(BPF_JGT, BPF_REG_3, BPF_REG_1, 1),
 	BPF_JMP_IMM(BPF_JA, 0, 0, 1),
-	BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1, -8),
+	BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1, -6),
 	BPF_MOV64_IMM(BPF_REG_0, 0),
 	BPF_EXIT_INSN(),
 	},
@@ -599,10 +599,10 @@
 		    offsetof(struct xdp_md, data_meta)),
 	BPF_LDX_MEM(BPF_W, BPF_REG_3, BPF_REG_1, offsetof(struct xdp_md, data)),
 	BPF_MOV64_REG(BPF_REG_1, BPF_REG_2),
-	BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, 8),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, 6),
 	BPF_JMP_REG(BPF_JLT, BPF_REG_1, BPF_REG_3, 1),
 	BPF_JMP_IMM(BPF_JA, 0, 0, 1),
-	BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1, -8),
+	BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1, -6),
 	BPF_MOV64_IMM(BPF_REG_0, 0),
 	BPF_EXIT_INSN(),
 	},
@@ -706,9 +706,9 @@
 		    offsetof(struct xdp_md, data_meta)),
 	BPF_LDX_MEM(BPF_W, BPF_REG_3, BPF_REG_1, offsetof(struct xdp_md, data)),
 	BPF_MOV64_REG(BPF_REG_1, BPF_REG_2),
-	BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, 8),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, 6),
 	BPF_JMP_REG(BPF_JGE, BPF_REG_1, BPF_REG_3, 1),
-	BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1, -8),
+	BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1, -6),
 	BPF_MOV64_IMM(BPF_REG_0, 0),
 	BPF_EXIT_INSN(),
 	},
@@ -869,9 +869,9 @@
 		    offsetof(struct xdp_md, data_meta)),
 	BPF_LDX_MEM(BPF_W, BPF_REG_3, BPF_REG_1, offsetof(struct xdp_md, data)),
 	BPF_MOV64_REG(BPF_REG_1, BPF_REG_2),
-	BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, 8),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, 6),
 	BPF_JMP_REG(BPF_JLE, BPF_REG_3, BPF_REG_1, 1),
-	BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1, -8),
+	BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1, -6),
 	BPF_MOV64_IMM(BPF_REG_0, 0),
 	BPF_EXIT_INSN(),
 	},
-- 
2.30.2

