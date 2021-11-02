Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C68F443151
	for <lists+netdev@lfdr.de>; Tue,  2 Nov 2021 16:12:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234226AbhKBPPT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Nov 2021 11:15:19 -0400
Received: from mail-co1nam11on2065.outbound.protection.outlook.com ([40.107.220.65]:25313
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234198AbhKBPPR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Nov 2021 11:15:17 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fm1ORWzIvT2YO9oUaBsDUdQ3pSDE2ZftyqH7iLZOZTReO8yag2EHcW60gZGPmYMVpO7BxNqHudFMezT8f/EibX3B0g288r368mIlzzjK4NI1EJFHcyzymKWHlPZBlN7x10gjk5XJcqKcXHG6kJ0dIX7jLd1wk8wvKIkWhPooUkiyjCNNGpTOCxynbqZbtTOwFpwxsLySqZqJD8xl1EhyUIAgOOPFKWv0srwGfpUOjYPdNC5QCw7CTNYmFwujs6tr3W4Vu9u+I+8ze7pA5QxtofHhh4Ud67jK+252rSCDQppStv5IdZM5TXtZupoBYeMMIVNsyq5wYulHyOWaP5v8zA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UP3ACzM/gkojTlXY3Pb336jItPNTMC+Poeu3m5hoEt8=;
 b=QJSKNrUeJHiZQTMlt0UynBIz98pjXhzAxmjwbYNenk+bIhvucQGSebBa3UxNv6cEc4SQDw5F8rd9Mb+ybk/JtVUJ773OY6eUR7IEQfIjIkw0ioANMSnHPLbbqixQCK2s3tt0De1iBMJk75b7xjEod6woS2twk8t1si2dU+daUWPiQTXSI6STPvhPeYV/SQUX4kNNbLKsm9NH8NLQnWt3myXW+FKNn9pHxbpUE1QvI3qKGy3VqVtf6u+57XxXvsybFjyep9ognfE/nLsN8KUB4COgBkg1KILxYKr8xTKo8Tq9dInCQEWH3gcY3HP8CO0agKTByehvOGoDpwZJyDCifA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UP3ACzM/gkojTlXY3Pb336jItPNTMC+Poeu3m5hoEt8=;
 b=mc651zFy8V+ipIpyWfgQmvoXpkioH02Oqj1E/Rs9RaAIBtJHP4Rm2Q0xL9poLuFy4mNsghWWTqOeypn0WwpNTNLoC2vj2AbLE++X5Z1qch2RI9YYf0+/aXqWl7g6ofhvkCXtKJ95YIQPn+tCPXxCukCa2sT1zXkrGDnVyTHdURdLDXbtuw6lLUSHk0bM1o/fxi5aHHl7a/CVKc6/0nIvd2N1pBHsQMcnRSa1M8wYoJO7oYt1LQyfujqgXsHc13lJWFpBGj5rnX6x1Kt5/D/ifypALF2s2id2/r3y+BjS/MtTDs77/WFwASpOVpd75AfjWnhBzXhdHSn5MFT3mdU5hg==
Received: from MWHPR1701CA0022.namprd17.prod.outlook.com
 (2603:10b6:301:14::32) by MN2PR12MB3743.namprd12.prod.outlook.com
 (2603:10b6:208:168::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.15; Tue, 2 Nov
 2021 15:12:38 +0000
Received: from CO1NAM11FT036.eop-nam11.prod.protection.outlook.com
 (2603:10b6:301:14:cafe::83) by MWHPR1701CA0022.outlook.office365.com
 (2603:10b6:301:14::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.15 via Frontend
 Transport; Tue, 2 Nov 2021 15:12:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT036.mail.protection.outlook.com (10.13.174.124) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4649.14 via Frontend Transport; Tue, 2 Nov 2021 15:12:37 +0000
Received: from [172.27.14.165] (172.20.187.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 2 Nov
 2021 15:12:34 +0000
Message-ID: <279b0a91-506d-e657-022d-aad52c17dfc6@nvidia.com>
Date:   Tue, 2 Nov 2021 17:12:31 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Content-Language: en-US
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@nvidia.com>
From:   Maxim Mikityanskiy <maximmi@nvidia.com>
Subject: 4-year old off-by-two bug in the BPF verifier's boundary checks?
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f16e0b38-ca6e-4a3d-73fa-08d99e1334b5
X-MS-TrafficTypeDiagnostic: MN2PR12MB3743:
X-Microsoft-Antispam-PRVS: <MN2PR12MB37438AA48B81DE803F76339ADC8B9@MN2PR12MB3743.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2958;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AmByi9s2wXE3VG92VXQdJjqpi01RNxehUDoSaMuINK9QFvac/aaAloPt972yi1dne3KqnZDrMYmea0gN85sNAPInr+eltxqv7N8uOrn+AJ3Prx6qEZo+IEr52lDh5MQodq5ceOQG8ggyxwBIMuKWweDrxOodfPV3TuPbUc6zPoiyzdICkrcz3FUe2r66geH3EamQeqxmysn16Kl/TrxAXPoa3z2Ta2wOWasHPWcmYkGdyWf9nxC/6D6D/vbMbeDQBAOUqUc2y/xtYiAMVo1MhM084HvptmzUH31H7QYtHhZqFXgmpjon//gVrSfTIors7cJT0+2Mxz8mWLwFdvGT5S1Z9uuhORWmdy8rMIW2yy4rWWRJfbT0iDGfeNEewTclEAgydsdcYC3EAKqUC/QKAxjeswgqbanT6a/UsTauKI0DDB6Fw2UwWkfFovXGS4d39ZBnMBfY7eEteTCM3Ag4YmRCZyFa9LeIpXLvNp/z2yLBdR/LB8RAM1EumjxSSxfIgIFxatz6gsa7EeY2O4qqTnEiK2vzttorwK4KEC26MzsVKk1K4XHZ+mOFyLWbi3xx8/xkTe/D7bbG8tbUvxFLqQcFiOuugqqFi/765elGTXZadjkdAmkNQ5X5ZBvixfD014DiZVwTNGGzBdZJzXdlnyC/nVOh6cHwc7dltymdZ7Sn301gtqSMOXDLBTaOXbueEvuNW7Ou76CgcCGTqqyXJpUwBj0Y1fF0kNFEItixk1PdPFKZRSChD9JjylFXOn74DKQGY4wVmmzLsbDEGlJFxcyl89QVAWlw9OBgSNu7sA87//JgdJ/IdSp+rzJdZ9FoCyoV6YOmSmMjNrGkYUakde3mALrt1jspXMFxuf+AZEU=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(966005)(2906002)(5660300002)(36860700001)(8676002)(4326008)(70206006)(70586007)(31686004)(8936002)(36756003)(86362001)(31696002)(508600001)(16526019)(82310400003)(107886003)(316002)(47076005)(336012)(54906003)(2616005)(16576012)(110136005)(83380400001)(426003)(6666004)(186003)(7636003)(356005)(26005)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Nov 2021 15:12:37.4470
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f16e0b38-ca6e-4a3d-73fa-08d99e1334b5
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT036.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3743
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi guys,

I think I found cases where the BPF verifier mistakenly rejects valid 
BPF programs when doing pkt_end boundary checks, and the selftests for 
these cases test wrong things as well.

Daniel's commit fb2a311a31d3 ("bpf: fix off by one for range markings 
with L{T, E} patterns") [1] attempts to fix an off-by-one bug in 
boundary checks, but I think it shifts the index by 1 in a wrong 
direction, so instead of fixing, the bug becomes off-by-two.

A following commit b37242c773b2 ("bpf: add test cases to bpf selftests 
to cover all access tests") [2] adds unit tests to check the new 
behavior, but the tests look also wrong to me.

Let me analyze these two tests:

{
         "XDP pkt read, pkt_data' > pkt_end, good access",
         .insns = {
         BPF_LDX_MEM(BPF_W, BPF_REG_2, BPF_REG_1, offsetof(struct 
xdp_md, data)),
         BPF_LDX_MEM(BPF_W, BPF_REG_3, BPF_REG_1,
                     offsetof(struct xdp_md, data_end)),
         BPF_MOV64_REG(BPF_REG_1, BPF_REG_2),
         BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, 8),
         BPF_JMP_REG(BPF_JGT, BPF_REG_1, BPF_REG_3, 1),
         BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1, -8),
         BPF_MOV64_IMM(BPF_REG_0, 0),
         BPF_EXIT_INSN(),
         },
         .result = ACCEPT,
         .prog_type = BPF_PROG_TYPE_XDP,
         .flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
},

{
         "XDP pkt read, pkt_data' >= pkt_end, bad access 1",
         .insns = {
         BPF_LDX_MEM(BPF_W, BPF_REG_2, BPF_REG_1, offsetof(struct 
xdp_md, data)),
         BPF_LDX_MEM(BPF_W, BPF_REG_3, BPF_REG_1,
                     offsetof(struct xdp_md, data_end)),
         BPF_MOV64_REG(BPF_REG_1, BPF_REG_2),
         BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, 8),
         BPF_JMP_REG(BPF_JGE, BPF_REG_1, BPF_REG_3, 1),
         BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1, -8),
         BPF_MOV64_IMM(BPF_REG_0, 0),
         BPF_EXIT_INSN(),
         },
         .errstr = "R1 offset is outside of the packet",
         .result = REJECT,
         .prog_type = BPF_PROG_TYPE_XDP,
         .flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
},

The first program looks good both to me and the verifier: if data + 8 > 
data_end, we bail out, otherwise, if data + 8 <= data_end, we read 8 
bytes: [data; data+7].

The second program doesn't pass the verifier, and the test expects it to 
be rejected, but the program itself still looks fine to me: if data + 8 
 >= data_end, we bail out, otherwise, if data + 8 < data_end, we read 8 
bytes: [data; data+7], and this is fine, because data + 7 is for sure < 
data_end. The verifier considers data + 7 to be out of bounds, although 
both data + 7 and data + 8 are still valid offsets, hence the off-by-two 
bug.

Are my considerations valid, or am I stupidly missing anything?

I suggest to fix it like this:

--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -8492,7 +8492,7 @@ static void find_good_pkt_pointers(struct 
bpf_verifier_state *vstate,

         new_range = dst_reg->off;
         if (range_right_open)
-               new_range--;
+               new_range++;

         /* Examples for register markings:
          *

I don't think this bug poses any security threat, since the checks are 
stricter than needed, but it's a huge functional issue.

Thanks,
Max

[1]: 
https://patchwork.ozlabs.org/project/netdev/patch/3df9cce096b139eb0efb3b0c7bf9fcc5c5dc6629.1508545543.git.daniel@iogearbox.net/
[2]: 
https://patchwork.ozlabs.org/project/netdev/patch/3bc01f5985324b0e233e86616f4fe171c0d4ca8b.1508545543.git.daniel@iogearbox.net/
