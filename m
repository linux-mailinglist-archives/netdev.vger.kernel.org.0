Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE19646B57B
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 09:15:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231991AbhLGITC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 03:19:02 -0500
Received: from mail-dm6nam10on2047.outbound.protection.outlook.com ([40.107.93.47]:62086
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231598AbhLGITB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Dec 2021 03:19:01 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FM9IuRoaj4OW8gqUs/iXEzwBeHWt319RuZF7gyos7GwuMiYDhJNqVi0imJ0fr4wUldwiWD+X7Jc/cVHr+RXsIgkVFv3PsziXz6LU9YuhEKeAqChDxvnKZOx2MUIG4MooTvSMTx5IVsmyqNW8+WDwF4BDfId/tw6iK8u0zus4XKhSAAkk4KUJ/Kchcq3V+SzJLztHnyBde/rjkMW721ek2kb0ANXdE7OfogvPkEgCyIyZWvQ8pJ8QO840PYApTDsVPD8DRbbBU59EcjAQeqO9QFhj2M4Bk1xhlJauuY9iFv2zs4EFjckqQmfBFn7wF6TVJFtRdRTLm1q0vmWvApDqWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q/b8t8GKdTs5USqfyHCphypRqU0mkUgg1JY4A6VEk24=;
 b=XlxugzCbWa0h8t56d8V0beabo5asVmsbYwfyciZWE6FkMHDRgZyBZUZwULApE2HcNCk1AxYj82s8A2HCjrrle/9deVylJx+dW5fxFFpcYTyjL3C9y0opiZXtpOf7exduXmyIOpeqOIZFFTg5oRvDRMx3f6/304U5N46WJ67Xk/luPnzLmHT8OBTIcB2bjh2Y0EzkeYjtE1RYuj58dAa2QVFnmLGy3eP0AIzYKf9i+bbCLl8/8C55h2dVvM1bPFjJ3iu59CgK3TmtfYV1ieuW0WiratxP/bZ6vd7HqqD0kJjBHDZeZl39+iR0BiB98+zHI6WPrjxEjyZQBDU7Jezsng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q/b8t8GKdTs5USqfyHCphypRqU0mkUgg1JY4A6VEk24=;
 b=qkAsI5aOkKSgyHycz8duJyfcAbYydOTtYgYQAyCFgFnx4IOItOv2btDHWwCbyoaOYFP8tKY23T8CRfKtjxyx/z31z/U7DZoOQc4IASrwA1pQI3GExMQnUjfww1PuDJroNvawXdWCtTHyI/Y7z5HO9osXLonp7gi3heRX5rs5r0ksmp64u+MYV3Rvlob/CRo20bSdPWLt4cVmbIoE8ygjlPu0GUW4FtWowZPNJomIAg3lRhCluUEaPph6dTKXsk1h0itQVF3lnJ/9LfCF02oDA91RgDL9IbeMths9h0ySFY6yb5tOBX0cvv8u2n/BOsFat+EjN1pOOV05Pbjf4oSyog==
Received: from CO2PR04CA0179.namprd04.prod.outlook.com (2603:10b6:104:4::33)
 by CY4PR12MB1270.namprd12.prod.outlook.com (2603:10b6:903:43::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.21; Tue, 7 Dec
 2021 08:15:27 +0000
Received: from CO1NAM11FT059.eop-nam11.prod.protection.outlook.com
 (2603:10b6:104:4:cafe::b7) by CO2PR04CA0179.outlook.office365.com
 (2603:10b6:104:4::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.14 via Frontend
 Transport; Tue, 7 Dec 2021 08:15:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 CO1NAM11FT059.mail.protection.outlook.com (10.13.174.160) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4755.13 via Frontend Transport; Tue, 7 Dec 2021 08:15:27 +0000
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 7 Dec
 2021 00:15:26 -0800
Received: from vdi.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Tue, 7 Dec 2021 00:15:23 -0800
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
Subject: [PATCH bpf] bpf: Add selftests to cover packet access corner cases
Date:   Tue, 7 Dec 2021 10:15:21 +0200
Message-ID: <20211207081521.41923-1-maximmi@nvidia.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 38e63d09-c43f-40e3-f6e9-08d9b959ba2a
X-MS-TrafficTypeDiagnostic: CY4PR12MB1270:EE_
X-Microsoft-Antispam-PRVS: <CY4PR12MB1270FA198008090524471E37DC6E9@CY4PR12MB1270.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1002;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CK8BtKkoCe5fChbuyZ6se3osbIPJKGWdfZ1tXEen7FDf48y5siRAuAEqGTdwZTVuhSsKE2piydwbfwZ2wTxCpPTryHg93/mD2W6tUwl5Ufn3RNW4yJpXfEJuyiD1iihIdbQxsPjRn/kZX3RHfMMcrhj+p5Hcq/ZApqmKfw2Vh+TCkeTyqohqPy34TeU4oKjW97v1L+TfhO/E6JSuCBe2yoaykh5DFjxvNEF1Q+uxlZESqB2pIaYuFv2BI56DE8SQcO5AsH7SqEnCzcPspLE0M9+KjwcU1NCM3JTBzjdIPKpF31mCFFCcEWqMhSHw3JfaRPsLEitnCMmSsYiYWzstMN9APUFaIO+QF/9NxVzJ6L1QCl+79xzHvAdf53DcmTO2CZ4hX17cfeZPiKlXBspZNvjmsdKWV1JDLBz/JkxdSAcAjzhYd5f1sasZ/muFXsvf3+yDV4qohal21bgDS9iL9IhWbVA7OZsDye9TiX02rfCUz3rks0RCNN0k9lCo9Ucj3UtUkMli18VCfSLOfOvY9UMcIwtsJBgjBa3O1jzvtY/t80qmEesk6Pgfv7Urq+SPC+Pez66ciVM73T2AmzG3/PYJuVPFZ2OdtWGThep8qVsrKvcFoqq3aoiKGjg6hw2VByffWYjALteggAgyiIP833OuEg/eKJ17NjL08/l1UIJdDSizChTksK1NBDk3vhnqkA7MI7OZwz/mcKL+m0NAIQNe+wZTfFJ8HfeFQ/94PoMvYN2E99IDqaoyNoGMUdakVEYSZI7ZfUK7IywVoEGGxm7mvgrMkbFixdQ1riT70FI=
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(40470700001)(4326008)(426003)(336012)(47076005)(7416002)(5660300002)(107886003)(8936002)(508600001)(36860700001)(86362001)(30864003)(2906002)(70586007)(70206006)(40460700001)(1076003)(186003)(26005)(7696005)(83380400001)(316002)(7636003)(356005)(54906003)(2616005)(36756003)(110136005)(82310400004)(34070700002)(8676002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2021 08:15:27.4904
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 38e63d09-c43f-40e3-f6e9-08d9b959ba2a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT059.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1270
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit adds BPF verifier selftests that cover all corner cases by
packet boundary checks. Specifically, 8-byte packet reads are tested at
the beginning of data and at the beginning of data_meta, using all kinds
of boundary checks (all comparison operators: <, >, <=, >=; both
permutations of operands: data + length compared to end, end compared to
data + length). For each case there are three tests:

1. Length is just enough for an 8-byte read. Length is either 7 or 8,
   depending on the comparison.

2. Length is increased by 1 - should still pass the verifier. These
   cases are useful, because they failed before commit 2fa7d94afc1a
   ("bpf: Fix the off-by-two error in range markings").

3. Length is decreased by 1 - should be rejected by the verifier.

Some existing tests are just renamed to avoid duplication.

Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
---
 .../bpf/verifier/xdp_direct_packet_access.c   | 600 +++++++++++++++++-
 1 file changed, 584 insertions(+), 16 deletions(-)

diff --git a/tools/testing/selftests/bpf/verifier/xdp_direct_packet_access.c b/tools/testing/selftests/bpf/verifier/xdp_direct_packet_access.c
index de172a5b8754..b4ec228eb95d 100644
--- a/tools/testing/selftests/bpf/verifier/xdp_direct_packet_access.c
+++ b/tools/testing/selftests/bpf/verifier/xdp_direct_packet_access.c
@@ -35,7 +35,7 @@
 	.prog_type = BPF_PROG_TYPE_XDP,
 },
 {
-	"XDP pkt read, pkt_data' > pkt_end, good access",
+	"XDP pkt read, pkt_data' > pkt_end, corner case, good access",
 	.insns = {
 	BPF_LDX_MEM(BPF_W, BPF_REG_2, BPF_REG_1, offsetof(struct xdp_md, data)),
 	BPF_LDX_MEM(BPF_W, BPF_REG_3, BPF_REG_1,
@@ -87,6 +87,41 @@
 	.prog_type = BPF_PROG_TYPE_XDP,
 	.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
 },
+{
+	"XDP pkt read, pkt_data' > pkt_end, corner case +1, good access",
+	.insns = {
+	BPF_LDX_MEM(BPF_W, BPF_REG_2, BPF_REG_1, offsetof(struct xdp_md, data)),
+	BPF_LDX_MEM(BPF_W, BPF_REG_3, BPF_REG_1,
+		    offsetof(struct xdp_md, data_end)),
+	BPF_MOV64_REG(BPF_REG_1, BPF_REG_2),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, 9),
+	BPF_JMP_REG(BPF_JGT, BPF_REG_1, BPF_REG_3, 1),
+	BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1, -9),
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_EXIT_INSN(),
+	},
+	.result = ACCEPT,
+	.prog_type = BPF_PROG_TYPE_XDP,
+	.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
+},
+{
+	"XDP pkt read, pkt_data' > pkt_end, corner case -1, bad access",
+	.insns = {
+	BPF_LDX_MEM(BPF_W, BPF_REG_2, BPF_REG_1, offsetof(struct xdp_md, data)),
+	BPF_LDX_MEM(BPF_W, BPF_REG_3, BPF_REG_1,
+		    offsetof(struct xdp_md, data_end)),
+	BPF_MOV64_REG(BPF_REG_1, BPF_REG_2),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, 7),
+	BPF_JMP_REG(BPF_JGT, BPF_REG_1, BPF_REG_3, 1),
+	BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1, -7),
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_EXIT_INSN(),
+	},
+	.errstr = "R1 offset is outside of the packet",
+	.result = REJECT,
+	.prog_type = BPF_PROG_TYPE_XDP,
+	.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
+},
 {
 	"XDP pkt read, pkt_end > pkt_data', good access",
 	.insns = {
@@ -106,7 +141,7 @@
 	.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
 },
 {
-	"XDP pkt read, pkt_end > pkt_data', bad access 1",
+	"XDP pkt read, pkt_end > pkt_data', corner case -1, bad access",
 	.insns = {
 	BPF_LDX_MEM(BPF_W, BPF_REG_2, BPF_REG_1, offsetof(struct xdp_md, data)),
 	BPF_LDX_MEM(BPF_W, BPF_REG_3, BPF_REG_1,
@@ -142,6 +177,42 @@
 	.prog_type = BPF_PROG_TYPE_XDP,
 	.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
 },
+{
+	"XDP pkt read, pkt_end > pkt_data', corner case, good access",
+	.insns = {
+	BPF_LDX_MEM(BPF_W, BPF_REG_2, BPF_REG_1, offsetof(struct xdp_md, data)),
+	BPF_LDX_MEM(BPF_W, BPF_REG_3, BPF_REG_1,
+		    offsetof(struct xdp_md, data_end)),
+	BPF_MOV64_REG(BPF_REG_1, BPF_REG_2),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, 7),
+	BPF_JMP_REG(BPF_JGT, BPF_REG_3, BPF_REG_1, 1),
+	BPF_JMP_IMM(BPF_JA, 0, 0, 1),
+	BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1, -7),
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_EXIT_INSN(),
+	},
+	.result = ACCEPT,
+	.prog_type = BPF_PROG_TYPE_XDP,
+	.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
+},
+{
+	"XDP pkt read, pkt_end > pkt_data', corner case +1, good access",
+	.insns = {
+	BPF_LDX_MEM(BPF_W, BPF_REG_2, BPF_REG_1, offsetof(struct xdp_md, data)),
+	BPF_LDX_MEM(BPF_W, BPF_REG_3, BPF_REG_1,
+		    offsetof(struct xdp_md, data_end)),
+	BPF_MOV64_REG(BPF_REG_1, BPF_REG_2),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, 8),
+	BPF_JMP_REG(BPF_JGT, BPF_REG_3, BPF_REG_1, 1),
+	BPF_JMP_IMM(BPF_JA, 0, 0, 1),
+	BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1, -8),
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_EXIT_INSN(),
+	},
+	.result = ACCEPT,
+	.prog_type = BPF_PROG_TYPE_XDP,
+	.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
+},
 {
 	"XDP pkt read, pkt_data' < pkt_end, good access",
 	.insns = {
@@ -161,7 +232,7 @@
 	.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
 },
 {
-	"XDP pkt read, pkt_data' < pkt_end, bad access 1",
+	"XDP pkt read, pkt_data' < pkt_end, corner case -1, bad access",
 	.insns = {
 	BPF_LDX_MEM(BPF_W, BPF_REG_2, BPF_REG_1, offsetof(struct xdp_md, data)),
 	BPF_LDX_MEM(BPF_W, BPF_REG_3, BPF_REG_1,
@@ -198,7 +269,43 @@
 	.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
 },
 {
-	"XDP pkt read, pkt_end < pkt_data', good access",
+	"XDP pkt read, pkt_data' < pkt_end, corner case, good access",
+	.insns = {
+	BPF_LDX_MEM(BPF_W, BPF_REG_2, BPF_REG_1, offsetof(struct xdp_md, data)),
+	BPF_LDX_MEM(BPF_W, BPF_REG_3, BPF_REG_1,
+		    offsetof(struct xdp_md, data_end)),
+	BPF_MOV64_REG(BPF_REG_1, BPF_REG_2),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, 7),
+	BPF_JMP_REG(BPF_JLT, BPF_REG_1, BPF_REG_3, 1),
+	BPF_JMP_IMM(BPF_JA, 0, 0, 1),
+	BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1, -7),
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_EXIT_INSN(),
+	},
+	.result = ACCEPT,
+	.prog_type = BPF_PROG_TYPE_XDP,
+	.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
+},
+{
+	"XDP pkt read, pkt_data' < pkt_end, corner case +1, good access",
+	.insns = {
+	BPF_LDX_MEM(BPF_W, BPF_REG_2, BPF_REG_1, offsetof(struct xdp_md, data)),
+	BPF_LDX_MEM(BPF_W, BPF_REG_3, BPF_REG_1,
+		    offsetof(struct xdp_md, data_end)),
+	BPF_MOV64_REG(BPF_REG_1, BPF_REG_2),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, 8),
+	BPF_JMP_REG(BPF_JLT, BPF_REG_1, BPF_REG_3, 1),
+	BPF_JMP_IMM(BPF_JA, 0, 0, 1),
+	BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1, -8),
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_EXIT_INSN(),
+	},
+	.result = ACCEPT,
+	.prog_type = BPF_PROG_TYPE_XDP,
+	.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
+},
+{
+	"XDP pkt read, pkt_end < pkt_data', corner case, good access",
 	.insns = {
 	BPF_LDX_MEM(BPF_W, BPF_REG_2, BPF_REG_1, offsetof(struct xdp_md, data)),
 	BPF_LDX_MEM(BPF_W, BPF_REG_3, BPF_REG_1,
@@ -250,6 +357,41 @@
 	.prog_type = BPF_PROG_TYPE_XDP,
 	.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
 },
+{
+	"XDP pkt read, pkt_end < pkt_data', corner case +1, good access",
+	.insns = {
+	BPF_LDX_MEM(BPF_W, BPF_REG_2, BPF_REG_1, offsetof(struct xdp_md, data)),
+	BPF_LDX_MEM(BPF_W, BPF_REG_3, BPF_REG_1,
+		    offsetof(struct xdp_md, data_end)),
+	BPF_MOV64_REG(BPF_REG_1, BPF_REG_2),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, 9),
+	BPF_JMP_REG(BPF_JLT, BPF_REG_3, BPF_REG_1, 1),
+	BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1, -9),
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_EXIT_INSN(),
+	},
+	.result = ACCEPT,
+	.prog_type = BPF_PROG_TYPE_XDP,
+	.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
+},
+{
+	"XDP pkt read, pkt_end < pkt_data', corner case -1, bad access",
+	.insns = {
+	BPF_LDX_MEM(BPF_W, BPF_REG_2, BPF_REG_1, offsetof(struct xdp_md, data)),
+	BPF_LDX_MEM(BPF_W, BPF_REG_3, BPF_REG_1,
+		    offsetof(struct xdp_md, data_end)),
+	BPF_MOV64_REG(BPF_REG_1, BPF_REG_2),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, 7),
+	BPF_JMP_REG(BPF_JLT, BPF_REG_3, BPF_REG_1, 1),
+	BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1, -7),
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_EXIT_INSN(),
+	},
+	.errstr = "R1 offset is outside of the packet",
+	.result = REJECT,
+	.prog_type = BPF_PROG_TYPE_XDP,
+	.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
+},
 {
 	"XDP pkt read, pkt_data' >= pkt_end, good access",
 	.insns = {
@@ -268,7 +410,7 @@
 	.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
 },
 {
-	"XDP pkt read, pkt_data' >= pkt_end, bad access 1",
+	"XDP pkt read, pkt_data' >= pkt_end, corner case -1, bad access",
 	.insns = {
 	BPF_LDX_MEM(BPF_W, BPF_REG_2, BPF_REG_1, offsetof(struct xdp_md, data)),
 	BPF_LDX_MEM(BPF_W, BPF_REG_3, BPF_REG_1,
@@ -304,7 +446,41 @@
 	.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
 },
 {
-	"XDP pkt read, pkt_end >= pkt_data', good access",
+	"XDP pkt read, pkt_data' >= pkt_end, corner case, good access",
+	.insns = {
+	BPF_LDX_MEM(BPF_W, BPF_REG_2, BPF_REG_1, offsetof(struct xdp_md, data)),
+	BPF_LDX_MEM(BPF_W, BPF_REG_3, BPF_REG_1,
+		    offsetof(struct xdp_md, data_end)),
+	BPF_MOV64_REG(BPF_REG_1, BPF_REG_2),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, 7),
+	BPF_JMP_REG(BPF_JGE, BPF_REG_1, BPF_REG_3, 1),
+	BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1, -7),
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_EXIT_INSN(),
+	},
+	.result = ACCEPT,
+	.prog_type = BPF_PROG_TYPE_XDP,
+	.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
+},
+{
+	"XDP pkt read, pkt_data' >= pkt_end, corner case +1, good access",
+	.insns = {
+	BPF_LDX_MEM(BPF_W, BPF_REG_2, BPF_REG_1, offsetof(struct xdp_md, data)),
+	BPF_LDX_MEM(BPF_W, BPF_REG_3, BPF_REG_1,
+		    offsetof(struct xdp_md, data_end)),
+	BPF_MOV64_REG(BPF_REG_1, BPF_REG_2),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, 8),
+	BPF_JMP_REG(BPF_JGE, BPF_REG_1, BPF_REG_3, 1),
+	BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1, -8),
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_EXIT_INSN(),
+	},
+	.result = ACCEPT,
+	.prog_type = BPF_PROG_TYPE_XDP,
+	.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
+},
+{
+	"XDP pkt read, pkt_end >= pkt_data', corner case, good access",
 	.insns = {
 	BPF_LDX_MEM(BPF_W, BPF_REG_2, BPF_REG_1, offsetof(struct xdp_md, data)),
 	BPF_LDX_MEM(BPF_W, BPF_REG_3, BPF_REG_1,
@@ -359,7 +535,44 @@
 	.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
 },
 {
-	"XDP pkt read, pkt_data' <= pkt_end, good access",
+	"XDP pkt read, pkt_end >= pkt_data', corner case +1, good access",
+	.insns = {
+	BPF_LDX_MEM(BPF_W, BPF_REG_2, BPF_REG_1, offsetof(struct xdp_md, data)),
+	BPF_LDX_MEM(BPF_W, BPF_REG_3, BPF_REG_1,
+		    offsetof(struct xdp_md, data_end)),
+	BPF_MOV64_REG(BPF_REG_1, BPF_REG_2),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, 9),
+	BPF_JMP_REG(BPF_JGE, BPF_REG_3, BPF_REG_1, 1),
+	BPF_JMP_IMM(BPF_JA, 0, 0, 1),
+	BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1, -9),
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_EXIT_INSN(),
+	},
+	.result = ACCEPT,
+	.prog_type = BPF_PROG_TYPE_XDP,
+	.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
+},
+{
+	"XDP pkt read, pkt_end >= pkt_data', corner case -1, bad access",
+	.insns = {
+	BPF_LDX_MEM(BPF_W, BPF_REG_2, BPF_REG_1, offsetof(struct xdp_md, data)),
+	BPF_LDX_MEM(BPF_W, BPF_REG_3, BPF_REG_1,
+		    offsetof(struct xdp_md, data_end)),
+	BPF_MOV64_REG(BPF_REG_1, BPF_REG_2),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, 7),
+	BPF_JMP_REG(BPF_JGE, BPF_REG_3, BPF_REG_1, 1),
+	BPF_JMP_IMM(BPF_JA, 0, 0, 1),
+	BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1, -7),
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_EXIT_INSN(),
+	},
+	.errstr = "R1 offset is outside of the packet",
+	.result = REJECT,
+	.prog_type = BPF_PROG_TYPE_XDP,
+	.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
+},
+{
+	"XDP pkt read, pkt_data' <= pkt_end, corner case, good access",
 	.insns = {
 	BPF_LDX_MEM(BPF_W, BPF_REG_2, BPF_REG_1, offsetof(struct xdp_md, data)),
 	BPF_LDX_MEM(BPF_W, BPF_REG_3, BPF_REG_1,
@@ -413,6 +626,43 @@
 	.prog_type = BPF_PROG_TYPE_XDP,
 	.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
 },
+{
+	"XDP pkt read, pkt_data' <= pkt_end, corner case +1, good access",
+	.insns = {
+	BPF_LDX_MEM(BPF_W, BPF_REG_2, BPF_REG_1, offsetof(struct xdp_md, data)),
+	BPF_LDX_MEM(BPF_W, BPF_REG_3, BPF_REG_1,
+		    offsetof(struct xdp_md, data_end)),
+	BPF_MOV64_REG(BPF_REG_1, BPF_REG_2),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, 9),
+	BPF_JMP_REG(BPF_JLE, BPF_REG_1, BPF_REG_3, 1),
+	BPF_JMP_IMM(BPF_JA, 0, 0, 1),
+	BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1, -9),
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_EXIT_INSN(),
+	},
+	.result = ACCEPT,
+	.prog_type = BPF_PROG_TYPE_XDP,
+	.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
+},
+{
+	"XDP pkt read, pkt_data' <= pkt_end, corner case -1, bad access",
+	.insns = {
+	BPF_LDX_MEM(BPF_W, BPF_REG_2, BPF_REG_1, offsetof(struct xdp_md, data)),
+	BPF_LDX_MEM(BPF_W, BPF_REG_3, BPF_REG_1,
+		    offsetof(struct xdp_md, data_end)),
+	BPF_MOV64_REG(BPF_REG_1, BPF_REG_2),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, 7),
+	BPF_JMP_REG(BPF_JLE, BPF_REG_1, BPF_REG_3, 1),
+	BPF_JMP_IMM(BPF_JA, 0, 0, 1),
+	BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1, -7),
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_EXIT_INSN(),
+	},
+	.errstr = "R1 offset is outside of the packet",
+	.result = REJECT,
+	.prog_type = BPF_PROG_TYPE_XDP,
+	.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
+},
 {
 	"XDP pkt read, pkt_end <= pkt_data', good access",
 	.insns = {
@@ -431,7 +681,7 @@
 	.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
 },
 {
-	"XDP pkt read, pkt_end <= pkt_data', bad access 1",
+	"XDP pkt read, pkt_end <= pkt_data', corner case -1, bad access",
 	.insns = {
 	BPF_LDX_MEM(BPF_W, BPF_REG_2, BPF_REG_1, offsetof(struct xdp_md, data)),
 	BPF_LDX_MEM(BPF_W, BPF_REG_3, BPF_REG_1,
@@ -467,7 +717,41 @@
 	.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
 },
 {
-	"XDP pkt read, pkt_meta' > pkt_data, good access",
+	"XDP pkt read, pkt_end <= pkt_data', corner case, good access",
+	.insns = {
+	BPF_LDX_MEM(BPF_W, BPF_REG_2, BPF_REG_1, offsetof(struct xdp_md, data)),
+	BPF_LDX_MEM(BPF_W, BPF_REG_3, BPF_REG_1,
+		    offsetof(struct xdp_md, data_end)),
+	BPF_MOV64_REG(BPF_REG_1, BPF_REG_2),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, 7),
+	BPF_JMP_REG(BPF_JLE, BPF_REG_3, BPF_REG_1, 1),
+	BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1, -7),
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_EXIT_INSN(),
+	},
+	.result = ACCEPT,
+	.prog_type = BPF_PROG_TYPE_XDP,
+	.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
+},
+{
+	"XDP pkt read, pkt_end <= pkt_data', corner case +1, good access",
+	.insns = {
+	BPF_LDX_MEM(BPF_W, BPF_REG_2, BPF_REG_1, offsetof(struct xdp_md, data)),
+	BPF_LDX_MEM(BPF_W, BPF_REG_3, BPF_REG_1,
+		    offsetof(struct xdp_md, data_end)),
+	BPF_MOV64_REG(BPF_REG_1, BPF_REG_2),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, 8),
+	BPF_JMP_REG(BPF_JLE, BPF_REG_3, BPF_REG_1, 1),
+	BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1, -8),
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_EXIT_INSN(),
+	},
+	.result = ACCEPT,
+	.prog_type = BPF_PROG_TYPE_XDP,
+	.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
+},
+{
+	"XDP pkt read, pkt_meta' > pkt_data, corner case, good access",
 	.insns = {
 	BPF_LDX_MEM(BPF_W, BPF_REG_2, BPF_REG_1,
 		    offsetof(struct xdp_md, data_meta)),
@@ -519,6 +803,41 @@
 	.prog_type = BPF_PROG_TYPE_XDP,
 	.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
 },
+{
+	"XDP pkt read, pkt_meta' > pkt_data, corner case +1, good access",
+	.insns = {
+	BPF_LDX_MEM(BPF_W, BPF_REG_2, BPF_REG_1,
+		    offsetof(struct xdp_md, data_meta)),
+	BPF_LDX_MEM(BPF_W, BPF_REG_3, BPF_REG_1, offsetof(struct xdp_md, data)),
+	BPF_MOV64_REG(BPF_REG_1, BPF_REG_2),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, 9),
+	BPF_JMP_REG(BPF_JGT, BPF_REG_1, BPF_REG_3, 1),
+	BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1, -9),
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_EXIT_INSN(),
+	},
+	.result = ACCEPT,
+	.prog_type = BPF_PROG_TYPE_XDP,
+	.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
+},
+{
+	"XDP pkt read, pkt_meta' > pkt_data, corner case -1, bad access",
+	.insns = {
+	BPF_LDX_MEM(BPF_W, BPF_REG_2, BPF_REG_1,
+		    offsetof(struct xdp_md, data_meta)),
+	BPF_LDX_MEM(BPF_W, BPF_REG_3, BPF_REG_1, offsetof(struct xdp_md, data)),
+	BPF_MOV64_REG(BPF_REG_1, BPF_REG_2),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, 7),
+	BPF_JMP_REG(BPF_JGT, BPF_REG_1, BPF_REG_3, 1),
+	BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1, -7),
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_EXIT_INSN(),
+	},
+	.errstr = "R1 offset is outside of the packet",
+	.result = REJECT,
+	.prog_type = BPF_PROG_TYPE_XDP,
+	.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
+},
 {
 	"XDP pkt read, pkt_data > pkt_meta', good access",
 	.insns = {
@@ -538,7 +857,7 @@
 	.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
 },
 {
-	"XDP pkt read, pkt_data > pkt_meta', bad access 1",
+	"XDP pkt read, pkt_data > pkt_meta', corner case -1, bad access",
 	.insns = {
 	BPF_LDX_MEM(BPF_W, BPF_REG_2, BPF_REG_1,
 		    offsetof(struct xdp_md, data_meta)),
@@ -574,6 +893,42 @@
 	.prog_type = BPF_PROG_TYPE_XDP,
 	.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
 },
+{
+	"XDP pkt read, pkt_data > pkt_meta', corner case, good access",
+	.insns = {
+	BPF_LDX_MEM(BPF_W, BPF_REG_2, BPF_REG_1,
+		    offsetof(struct xdp_md, data_meta)),
+	BPF_LDX_MEM(BPF_W, BPF_REG_3, BPF_REG_1, offsetof(struct xdp_md, data)),
+	BPF_MOV64_REG(BPF_REG_1, BPF_REG_2),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, 7),
+	BPF_JMP_REG(BPF_JGT, BPF_REG_3, BPF_REG_1, 1),
+	BPF_JMP_IMM(BPF_JA, 0, 0, 1),
+	BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1, -7),
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_EXIT_INSN(),
+	},
+	.result = ACCEPT,
+	.prog_type = BPF_PROG_TYPE_XDP,
+	.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
+},
+{
+	"XDP pkt read, pkt_data > pkt_meta', corner case +1, good access",
+	.insns = {
+	BPF_LDX_MEM(BPF_W, BPF_REG_2, BPF_REG_1,
+		    offsetof(struct xdp_md, data_meta)),
+	BPF_LDX_MEM(BPF_W, BPF_REG_3, BPF_REG_1, offsetof(struct xdp_md, data)),
+	BPF_MOV64_REG(BPF_REG_1, BPF_REG_2),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, 8),
+	BPF_JMP_REG(BPF_JGT, BPF_REG_3, BPF_REG_1, 1),
+	BPF_JMP_IMM(BPF_JA, 0, 0, 1),
+	BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1, -8),
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_EXIT_INSN(),
+	},
+	.result = ACCEPT,
+	.prog_type = BPF_PROG_TYPE_XDP,
+	.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
+},
 {
 	"XDP pkt read, pkt_meta' < pkt_data, good access",
 	.insns = {
@@ -593,7 +948,7 @@
 	.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
 },
 {
-	"XDP pkt read, pkt_meta' < pkt_data, bad access 1",
+	"XDP pkt read, pkt_meta' < pkt_data, corner case -1, bad access",
 	.insns = {
 	BPF_LDX_MEM(BPF_W, BPF_REG_2, BPF_REG_1,
 		    offsetof(struct xdp_md, data_meta)),
@@ -630,7 +985,43 @@
 	.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
 },
 {
-	"XDP pkt read, pkt_data < pkt_meta', good access",
+	"XDP pkt read, pkt_meta' < pkt_data, corner case, good access",
+	.insns = {
+	BPF_LDX_MEM(BPF_W, BPF_REG_2, BPF_REG_1,
+		    offsetof(struct xdp_md, data_meta)),
+	BPF_LDX_MEM(BPF_W, BPF_REG_3, BPF_REG_1, offsetof(struct xdp_md, data)),
+	BPF_MOV64_REG(BPF_REG_1, BPF_REG_2),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, 7),
+	BPF_JMP_REG(BPF_JLT, BPF_REG_1, BPF_REG_3, 1),
+	BPF_JMP_IMM(BPF_JA, 0, 0, 1),
+	BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1, -7),
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_EXIT_INSN(),
+	},
+	.result = ACCEPT,
+	.prog_type = BPF_PROG_TYPE_XDP,
+	.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
+},
+{
+	"XDP pkt read, pkt_meta' < pkt_data, corner case +1, good access",
+	.insns = {
+	BPF_LDX_MEM(BPF_W, BPF_REG_2, BPF_REG_1,
+		    offsetof(struct xdp_md, data_meta)),
+	BPF_LDX_MEM(BPF_W, BPF_REG_3, BPF_REG_1, offsetof(struct xdp_md, data)),
+	BPF_MOV64_REG(BPF_REG_1, BPF_REG_2),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, 8),
+	BPF_JMP_REG(BPF_JLT, BPF_REG_1, BPF_REG_3, 1),
+	BPF_JMP_IMM(BPF_JA, 0, 0, 1),
+	BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1, -8),
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_EXIT_INSN(),
+	},
+	.result = ACCEPT,
+	.prog_type = BPF_PROG_TYPE_XDP,
+	.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
+},
+{
+	"XDP pkt read, pkt_data < pkt_meta', corner case, good access",
 	.insns = {
 	BPF_LDX_MEM(BPF_W, BPF_REG_2, BPF_REG_1,
 		    offsetof(struct xdp_md, data_meta)),
@@ -682,6 +1073,41 @@
 	.prog_type = BPF_PROG_TYPE_XDP,
 	.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
 },
+{
+	"XDP pkt read, pkt_data < pkt_meta', corner case +1, good access",
+	.insns = {
+	BPF_LDX_MEM(BPF_W, BPF_REG_2, BPF_REG_1,
+		    offsetof(struct xdp_md, data_meta)),
+	BPF_LDX_MEM(BPF_W, BPF_REG_3, BPF_REG_1, offsetof(struct xdp_md, data)),
+	BPF_MOV64_REG(BPF_REG_1, BPF_REG_2),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, 9),
+	BPF_JMP_REG(BPF_JLT, BPF_REG_3, BPF_REG_1, 1),
+	BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1, -9),
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_EXIT_INSN(),
+	},
+	.result = ACCEPT,
+	.prog_type = BPF_PROG_TYPE_XDP,
+	.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
+},
+{
+	"XDP pkt read, pkt_data < pkt_meta', corner case -1, bad access",
+	.insns = {
+	BPF_LDX_MEM(BPF_W, BPF_REG_2, BPF_REG_1,
+		    offsetof(struct xdp_md, data_meta)),
+	BPF_LDX_MEM(BPF_W, BPF_REG_3, BPF_REG_1, offsetof(struct xdp_md, data)),
+	BPF_MOV64_REG(BPF_REG_1, BPF_REG_2),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, 7),
+	BPF_JMP_REG(BPF_JLT, BPF_REG_3, BPF_REG_1, 1),
+	BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1, -7),
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_EXIT_INSN(),
+	},
+	.errstr = "R1 offset is outside of the packet",
+	.result = REJECT,
+	.prog_type = BPF_PROG_TYPE_XDP,
+	.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
+},
 {
 	"XDP pkt read, pkt_meta' >= pkt_data, good access",
 	.insns = {
@@ -700,7 +1126,7 @@
 	.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
 },
 {
-	"XDP pkt read, pkt_meta' >= pkt_data, bad access 1",
+	"XDP pkt read, pkt_meta' >= pkt_data, corner case -1, bad access",
 	.insns = {
 	BPF_LDX_MEM(BPF_W, BPF_REG_2, BPF_REG_1,
 		    offsetof(struct xdp_md, data_meta)),
@@ -736,7 +1162,41 @@
 	.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
 },
 {
-	"XDP pkt read, pkt_data >= pkt_meta', good access",
+	"XDP pkt read, pkt_meta' >= pkt_data, corner case, good access",
+	.insns = {
+	BPF_LDX_MEM(BPF_W, BPF_REG_2, BPF_REG_1,
+		    offsetof(struct xdp_md, data_meta)),
+	BPF_LDX_MEM(BPF_W, BPF_REG_3, BPF_REG_1, offsetof(struct xdp_md, data)),
+	BPF_MOV64_REG(BPF_REG_1, BPF_REG_2),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, 7),
+	BPF_JMP_REG(BPF_JGE, BPF_REG_1, BPF_REG_3, 1),
+	BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1, -7),
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_EXIT_INSN(),
+	},
+	.result = ACCEPT,
+	.prog_type = BPF_PROG_TYPE_XDP,
+	.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
+},
+{
+	"XDP pkt read, pkt_meta' >= pkt_data, corner case +1, good access",
+	.insns = {
+	BPF_LDX_MEM(BPF_W, BPF_REG_2, BPF_REG_1,
+		    offsetof(struct xdp_md, data_meta)),
+	BPF_LDX_MEM(BPF_W, BPF_REG_3, BPF_REG_1, offsetof(struct xdp_md, data)),
+	BPF_MOV64_REG(BPF_REG_1, BPF_REG_2),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, 8),
+	BPF_JMP_REG(BPF_JGE, BPF_REG_1, BPF_REG_3, 1),
+	BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1, -8),
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_EXIT_INSN(),
+	},
+	.result = ACCEPT,
+	.prog_type = BPF_PROG_TYPE_XDP,
+	.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
+},
+{
+	"XDP pkt read, pkt_data >= pkt_meta', corner case, good access",
 	.insns = {
 	BPF_LDX_MEM(BPF_W, BPF_REG_2, BPF_REG_1,
 		    offsetof(struct xdp_md, data_meta)),
@@ -791,7 +1251,44 @@
 	.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
 },
 {
-	"XDP pkt read, pkt_meta' <= pkt_data, good access",
+	"XDP pkt read, pkt_data >= pkt_meta', corner case +1, good access",
+	.insns = {
+	BPF_LDX_MEM(BPF_W, BPF_REG_2, BPF_REG_1,
+		    offsetof(struct xdp_md, data_meta)),
+	BPF_LDX_MEM(BPF_W, BPF_REG_3, BPF_REG_1, offsetof(struct xdp_md, data)),
+	BPF_MOV64_REG(BPF_REG_1, BPF_REG_2),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, 9),
+	BPF_JMP_REG(BPF_JGE, BPF_REG_3, BPF_REG_1, 1),
+	BPF_JMP_IMM(BPF_JA, 0, 0, 1),
+	BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1, -9),
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_EXIT_INSN(),
+	},
+	.result = ACCEPT,
+	.prog_type = BPF_PROG_TYPE_XDP,
+	.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
+},
+{
+	"XDP pkt read, pkt_data >= pkt_meta', corner case -1, bad access",
+	.insns = {
+	BPF_LDX_MEM(BPF_W, BPF_REG_2, BPF_REG_1,
+		    offsetof(struct xdp_md, data_meta)),
+	BPF_LDX_MEM(BPF_W, BPF_REG_3, BPF_REG_1, offsetof(struct xdp_md, data)),
+	BPF_MOV64_REG(BPF_REG_1, BPF_REG_2),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, 7),
+	BPF_JMP_REG(BPF_JGE, BPF_REG_3, BPF_REG_1, 1),
+	BPF_JMP_IMM(BPF_JA, 0, 0, 1),
+	BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1, -7),
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_EXIT_INSN(),
+	},
+	.errstr = "R1 offset is outside of the packet",
+	.result = REJECT,
+	.prog_type = BPF_PROG_TYPE_XDP,
+	.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
+},
+{
+	"XDP pkt read, pkt_meta' <= pkt_data, corner case, good access",
 	.insns = {
 	BPF_LDX_MEM(BPF_W, BPF_REG_2, BPF_REG_1,
 		    offsetof(struct xdp_md, data_meta)),
@@ -845,6 +1342,43 @@
 	.prog_type = BPF_PROG_TYPE_XDP,
 	.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
 },
+{
+	"XDP pkt read, pkt_meta' <= pkt_data, corner case +1, good access",
+	.insns = {
+	BPF_LDX_MEM(BPF_W, BPF_REG_2, BPF_REG_1,
+		    offsetof(struct xdp_md, data_meta)),
+	BPF_LDX_MEM(BPF_W, BPF_REG_3, BPF_REG_1, offsetof(struct xdp_md, data)),
+	BPF_MOV64_REG(BPF_REG_1, BPF_REG_2),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, 9),
+	BPF_JMP_REG(BPF_JLE, BPF_REG_1, BPF_REG_3, 1),
+	BPF_JMP_IMM(BPF_JA, 0, 0, 1),
+	BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1, -9),
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_EXIT_INSN(),
+	},
+	.result = ACCEPT,
+	.prog_type = BPF_PROG_TYPE_XDP,
+	.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
+},
+{
+	"XDP pkt read, pkt_meta' <= pkt_data, corner case -1, bad access",
+	.insns = {
+	BPF_LDX_MEM(BPF_W, BPF_REG_2, BPF_REG_1,
+		    offsetof(struct xdp_md, data_meta)),
+	BPF_LDX_MEM(BPF_W, BPF_REG_3, BPF_REG_1, offsetof(struct xdp_md, data)),
+	BPF_MOV64_REG(BPF_REG_1, BPF_REG_2),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, 7),
+	BPF_JMP_REG(BPF_JLE, BPF_REG_1, BPF_REG_3, 1),
+	BPF_JMP_IMM(BPF_JA, 0, 0, 1),
+	BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1, -7),
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_EXIT_INSN(),
+	},
+	.errstr = "R1 offset is outside of the packet",
+	.result = REJECT,
+	.prog_type = BPF_PROG_TYPE_XDP,
+	.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
+},
 {
 	"XDP pkt read, pkt_data <= pkt_meta', good access",
 	.insns = {
@@ -863,7 +1397,7 @@
 	.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
 },
 {
-	"XDP pkt read, pkt_data <= pkt_meta', bad access 1",
+	"XDP pkt read, pkt_data <= pkt_meta', corner case -1, bad access",
 	.insns = {
 	BPF_LDX_MEM(BPF_W, BPF_REG_2, BPF_REG_1,
 		    offsetof(struct xdp_md, data_meta)),
@@ -898,3 +1432,37 @@
 	.prog_type = BPF_PROG_TYPE_XDP,
 	.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
 },
+{
+	"XDP pkt read, pkt_data <= pkt_meta', corner case, good access",
+	.insns = {
+	BPF_LDX_MEM(BPF_W, BPF_REG_2, BPF_REG_1,
+		    offsetof(struct xdp_md, data_meta)),
+	BPF_LDX_MEM(BPF_W, BPF_REG_3, BPF_REG_1, offsetof(struct xdp_md, data)),
+	BPF_MOV64_REG(BPF_REG_1, BPF_REG_2),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, 7),
+	BPF_JMP_REG(BPF_JLE, BPF_REG_3, BPF_REG_1, 1),
+	BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1, -7),
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_EXIT_INSN(),
+	},
+	.result = ACCEPT,
+	.prog_type = BPF_PROG_TYPE_XDP,
+	.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
+},
+{
+	"XDP pkt read, pkt_data <= pkt_meta', corner case +1, good access",
+	.insns = {
+	BPF_LDX_MEM(BPF_W, BPF_REG_2, BPF_REG_1,
+		    offsetof(struct xdp_md, data_meta)),
+	BPF_LDX_MEM(BPF_W, BPF_REG_3, BPF_REG_1, offsetof(struct xdp_md, data)),
+	BPF_MOV64_REG(BPF_REG_1, BPF_REG_2),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, 8),
+	BPF_JMP_REG(BPF_JLE, BPF_REG_3, BPF_REG_1, 1),
+	BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1, -8),
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_EXIT_INSN(),
+	},
+	.result = ACCEPT,
+	.prog_type = BPF_PROG_TYPE_XDP,
+	.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
+},
-- 
2.30.2

