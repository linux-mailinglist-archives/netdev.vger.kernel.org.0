Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDDBC463D97
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 19:18:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245421AbhK3SVm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 13:21:42 -0500
Received: from mail-dm6nam10on2070.outbound.protection.outlook.com ([40.107.93.70]:14175
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239566AbhK3SVm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Nov 2021 13:21:42 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L8CqaxLT2TH0rFzau9+Fb0H5V/Ba5IR+LJYfWmCv6FUb75Ul/NDgnTACynssRp8BYejNS6wxFZkugIefOsoDTHL7HC+HMWaUaTBtVswG6uwPb8X799pm6aSDxed2qBWi60RIaTFBM+pBAo2djCwREA6BgvdLbB2V5B7IXjdEBczgHJquytB6ePHsTMOw1Vy+wHnYHKtwkoK3Yp5xG2tOmaByXdoJSnl7vNAkEGAgALCIqiC3nIPuxdTws3//FCGGYX9icpoNv92DGZ6hXYFkAqFTTPbrbG0L4ma4PBNrUV418iIcD4m3Ux3ZX/UdlHXFyoHxviqi7Z4+lLTw4oJTHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ImTTXV2jXY0GyyFZs5CZWCAjuJIYD/+1j417UrI/i20=;
 b=Fmg66KP1cgsDqZwR/5EH5grVRp5JvCak5cSdtYj/AxKNItOoTREYStChHK55L1txZIRAZt1PW2V2Xr4SwKUATYfyRmSy42/FVwd/ZVKCHR5G50Nz18fwqRtktAv/C6kNn2GizrpSvMrKaYvS/lHXH01n7bHZCfiOQhGODXnv9U8v0M0h06il0M+K/Uqnkcseyfs1QdwF7RM23SHSZfxJRGjSBXy6p+J1h/FcxcE6Af8/4scFy7R82SL8HS6FU6aERZ2UPZshnzT5io55kDo8cBB8mGciy4LRJv17eYB41rJg+Ft0SuL0+EXXqyQXiYECYVzApBG1FoHpL8svxM+0QA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=fb.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ImTTXV2jXY0GyyFZs5CZWCAjuJIYD/+1j417UrI/i20=;
 b=aV945P/dZmSxVJsL6uuoRSiKVrXnx810STSJ8suJPp65+AuiWnIQbnbVdxZWIDtWbc5JE62T+jHwErdxcNPi445IpSdn9O0+ST1bYaVOrI7VDd95f+QQHFieYdU7fwXDxfHeANcbI1FnW04sQayV52ArmdBaWAXRA7BtI5MBnM2zTLmFQfDwoBnrY1QSd2bPfTTmhSx79ffhA/OItXWO4eL6+HhTNccsr4oB/i9IcCUdOzYRMFy8FvomdRWru80Wt1xboqvgEkKz/ZjM1QkTPvn17kSHlBIWmPbe4dpNwujh8OXKkZVbzEmp8HyV69g7O8Z2wwp7uZWczKP3U3EVng==
Received: from CO2PR04CA0184.namprd04.prod.outlook.com (2603:10b6:104:5::14)
 by DM6PR12MB5549.namprd12.prod.outlook.com (2603:10b6:5:209::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.20; Tue, 30 Nov
 2021 18:18:19 +0000
Received: from CO1NAM11FT053.eop-nam11.prod.protection.outlook.com
 (2603:10b6:104:5:cafe::ea) by CO2PR04CA0184.outlook.office365.com
 (2603:10b6:104:5::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.23 via Frontend
 Transport; Tue, 30 Nov 2021 18:18:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 CO1NAM11FT053.mail.protection.outlook.com (10.13.175.63) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4755.13 via Frontend Transport; Tue, 30 Nov 2021 18:18:19 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 30 Nov
 2021 18:18:18 +0000
Received: from vdi.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Tue, 30 Nov 2021 18:18:14 +0000
From:   Maxim Mikityanskiy <maximmi@nvidia.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>
CC:     Shuah Khan <shuah@kernel.org>,
        Florent Revest <revest@chromium.org>,
        "Dave Marchevsky" <davemarchevsky@fb.com>,
        <linux-kselftest@vger.kernel.org>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, Maxim Mikityanskiy <maximmi@nvidia.com>
Subject: [PATCH bpf] bpf: Fix the test_task_vma selftest to support output shorter than 1 kB
Date:   Tue, 30 Nov 2021 20:18:11 +0200
Message-ID: <20211130181811.594220-1-maximmi@nvidia.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: aa4ceb7d-ce5c-419a-2146-08d9b42dc934
X-MS-TrafficTypeDiagnostic: DM6PR12MB5549:
X-Microsoft-Antispam-PRVS: <DM6PR12MB55493E5B54170305ADEFD8ADDC679@DM6PR12MB5549.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:233;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rIamLGXLdDMQVvZdDBVq8TRtovUdIOuhWIG8Fl/E9iAAt4alfeQYMSunabc+ePMl42h0s+mUWDTUQCbJacHkv8lkObqondJ4o9sZU/xy6X6C1vZYibugvm03U7QKSz5ZJxAo16O4zMbVUudm1R9SRU4ezqxVlMSS4CcSuSiYf+7JuTuRl+kVp72KX4zWoRCI9H5z989K83wxS5PKw/z2GlXVBBRoZFAcQjS3E1tVfh2ds3srQKRZMPumYGYtnsmCEnJT9BrVO1tV1xfXretj5QMGF2Mg09SGqlUzZzW1cy4UGkKu4hCdwH5Fh33DQK8d2GzqU1AR2ZeIQkPJitLKhJ//OPBL3r4nvsChe8uicY/0TZ/cDwlKn9kGbH0QrJdPZFyh1agDSGaBnBC/+qdJs12GW7HaYlmdL3q0oyaw59tvVilAOUuNsoRcrw3EGRbeioWPjEgqqHAeIZQKNonaHAMoGhWdCCNmbfvQDQ0mZMNR/jdIIz70yPQIZcnxGyFihmggir1omaVMF9USTXanMVQJ6TFntUiBDRNuD+R6H8P277fQ5UqnnZGeEjy/MWUSZs+5IuL60PP1BekezbPbqAGxOWNNQsECBMjjcP2FORvFBc6rA8UiLPxqZ65mLJta7i9rA5g2W4M+sqwCK+Sw15rhQVAX+A5UGna0myfYFSp0IBftdPTbssZGF2/j9R6P7Fmxf0R0l09wBzoGpk3IypfHZ6kIdzNKozC2bg0geFRfgqrWAlhfdjc4laYLFvDp4Cvpv/JuY/ZOFQUpYkQSfQ==
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid04.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(40470700001)(2906002)(83380400001)(36756003)(316002)(7416002)(336012)(36860700001)(2616005)(426003)(7636003)(6666004)(356005)(26005)(40460700001)(110136005)(1076003)(86362001)(70206006)(8936002)(8676002)(7696005)(5660300002)(82310400004)(54906003)(107886003)(186003)(47076005)(70586007)(508600001)(4326008);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Nov 2021 18:18:19.0863
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: aa4ceb7d-ce5c-419a-2146-08d9b42dc934
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT053.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB5549
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The test for bpf_iter_task_vma assumes that the output will be longer
than 1 kB, as the comment above the loop says. Due to this assumption,
the loop becomes infinite if the output turns to be shorter than 1 kB.
The return value of read_fd_into_buffer is 0 when the end of file was
reached, and len isn't being increased any more.

This commit adds a break on EOF to handle short output correctly. For
the reference, this is the contents that I get when running test_progs
under vmtest.sh, and it's shorter than 1 kB:

00400000-00401000 r--p 00000000 fe:00 25867     /root/bpf/test_progs
00401000-00674000 r-xp 00001000 fe:00 25867     /root/bpf/test_progs
00674000-0095f000 r--p 00274000 fe:00 25867     /root/bpf/test_progs
0095f000-00983000 r--p 0055e000 fe:00 25867     /root/bpf/test_progs
00983000-00a8a000 rw-p 00582000 fe:00 25867     /root/bpf/test_progs
00a8a000-0484e000 rw-p 00000000 00:00 0
7f6c64000000-7f6c64021000 rw-p 00000000 00:00 0
7f6c64021000-7f6c68000000 ---p 00000000 00:00 0
7f6c6ac8f000-7f6c6ac90000 r--s 00000000 00:0d 8032
anon_inode:bpf-map
7f6c6ac90000-7f6c6ac91000 ---p 00000000 00:00 0
7f6c6ac91000-7f6c6b491000 rw-p 00000000 00:00 0
7f6c6b491000-7f6c6b492000 r--s 00000000 00:0d 8032
anon_inode:bpf-map
7f6c6b492000-7f6c6b493000 rw-s 00000000 00:0d 8032
anon_inode:bpf-map
7ffc1e23d000-7ffc1e25e000 rw-p 00000000 00:00 0
7ffc1e3b8000-7ffc1e3bc000 r--p 00000000 00:00 0
7ffc1e3bc000-7ffc1e3bd000 r-xp 00000000 00:00 0
7fffffffe000-7ffffffff000 --xp 00000000 00:00 0

Fixes: e8168840e16c ("selftests/bpf: Add test for bpf_iter_task_vma")
Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
---
 tools/testing/selftests/bpf/prog_tests/bpf_iter.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/bpf_iter.c b/tools/testing/selftests/bpf/prog_tests/bpf_iter.c
index 9454331aaf85..ea6823215e9c 100644
--- a/tools/testing/selftests/bpf/prog_tests/bpf_iter.c
+++ b/tools/testing/selftests/bpf/prog_tests/bpf_iter.c
@@ -1206,13 +1206,14 @@ static void test_task_vma(void)
 		goto out;
 
 	/* Read CMP_BUFFER_SIZE (1kB) from bpf_iter. Read in small chunks
-	 * to trigger seq_file corner cases. The expected output is much
-	 * longer than 1kB, so the while loop will terminate.
+	 * to trigger seq_file corner cases.
 	 */
 	len = 0;
 	while (len < CMP_BUFFER_SIZE) {
 		err = read_fd_into_buffer(iter_fd, task_vma_output + len,
 					  min(read_size, CMP_BUFFER_SIZE - len));
+		if (!err)
+			break;
 		if (CHECK(err < 0, "read_iter_fd", "read_iter_fd failed\n"))
 			goto out;
 		len += err;
-- 
2.30.2

