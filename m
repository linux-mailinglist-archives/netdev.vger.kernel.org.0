Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E937A45DC70
	for <lists+netdev@lfdr.de>; Thu, 25 Nov 2021 15:36:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352542AbhKYOjR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Nov 2021 09:39:17 -0500
Received: from mail-mw2nam10on2045.outbound.protection.outlook.com ([40.107.94.45]:35350
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1355038AbhKYOhQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Nov 2021 09:37:16 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k54JuOgYIFle9OLs6J5oufogWkjiMxhfKq2grzTsio9Gr+3Co5GTlw7jkGjMHGaHYrkeW1f7ZnJ/RmnUGWgMRoqCOuI0cwb5zGf6CGm57N0HbAReUCXMRoUfL3sG47lGvlfQ+mk74YssChgs130vCeJDZm3RYvKoNtK7Hw9w3GxTKY/dPhl4Bh+FiJ9naQoeqBy3qEjZkxaNXTocEdl6H+UB6Bq/iJjfZSaTfmc7J0WEE+4Q6jc7qqO9N+xQrUUdu5YuvgZY76wwpzwnxb9jj4QTZk/Qeof2Ksg/h91/s0/X0wn/vt45k2uvvAc1iMosalAsUa5G+7ITG7mMRfprsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=E/5oLVtWl6xvQyfoCt8XDcUyA4p8l4aMMUkhVX7jhww=;
 b=d4636IeQnIR6yzhDjK2x2S5Ebfv2MFMe5W+hjsZdoOKsVhTl0NOopCgDz/7cmeHcRH3K6Y82Gb0vv4fY0OAizwqaqyR6NmRBypO7dqSTgk3eppx5ZGRPkBnSI8dWCnzqe2TbpWq0WNC9aVCRxx1UGVAZsYEgfb3wf//IXneSWszGz/lgGIYDk6etlSlmcyk7Ir8t2otnV+5ZTGGeXGDcdd5VKG0wjpo8hwq802a2YSmq/GpnZLNAjQCao1z2+D+XDA+5z9CCPxi0xD3vrIwTNbwY1TttkjwBTCpUJ/StdGlpUNssEvIOGUGuHirOiBifYFHdeQIX5viqTpPurYpWJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E/5oLVtWl6xvQyfoCt8XDcUyA4p8l4aMMUkhVX7jhww=;
 b=fDtKeFlRaHJlf1DE3zy2u+Ld3ekbccIrl7UgAzQ075Abfpb1nA5FBGfx+IGcgOE6XBlFJAaayE496wgrHCdlBdUo+Sbn6IZE8GrcC79PbZj8E46EsFzIKz1MnvsTnQT7UAJWtK0GVRLg2g1h6Ql4YaqjvshcFoF4GQMPgBYwfQcB4MKBNQ+cbUfpt/Qd+m4OFbvPpvemvMph8afk+tqPcdTq6ubbCVdS9W6soXb/qcoRW9Wjt1My//KLvscN0HS9/cdWr4v1UMf7sljhIg9eVAIRYCI50AKHbIlxbthPmkDcuh9YJm3AImhOthvg7i7BBgkPn6JYdNLXNyNUB7fHiw==
Received: from MWHPR1701CA0006.namprd17.prod.outlook.com
 (2603:10b6:301:14::16) by CO6PR12MB5425.namprd12.prod.outlook.com
 (2603:10b6:303:13e::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.24; Thu, 25 Nov
 2021 14:34:02 +0000
Received: from CO1NAM11FT056.eop-nam11.prod.protection.outlook.com
 (2603:10b6:301:14:cafe::8c) by MWHPR1701CA0006.outlook.office365.com
 (2603:10b6:301:14::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.22 via Frontend
 Transport; Thu, 25 Nov 2021 14:34:02 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT056.mail.protection.outlook.com (10.13.175.107) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4734.22 via Frontend Transport; Thu, 25 Nov 2021 14:34:01 +0000
Received: from [172.27.15.34] (172.20.187.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 25 Nov
 2021 14:33:58 +0000
Message-ID: <23ed87c9-5598-27d3-6851-b41262bc9bfa@nvidia.com>
Date:   Thu, 25 Nov 2021 16:33:55 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: 4-year old off-by-two bug in the BPF verifier's boundary checks?
Content-Language: en-US
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@nvidia.com>
References: <279b0a91-506d-e657-022d-aad52c17dfc6@nvidia.com>
 <fd6296d6-154c-814a-f088-e0567a566a21@iogearbox.net>
From:   Maxim Mikityanskiy <maximmi@nvidia.com>
In-Reply-To: <fd6296d6-154c-814a-f088-e0567a566a21@iogearbox.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [172.20.187.6]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: de15d5ac-e9a3-46d2-ac98-08d9b0209fff
X-MS-TrafficTypeDiagnostic: CO6PR12MB5425:
X-Microsoft-Antispam-PRVS: <CO6PR12MB54253E26D118442473610EE7DC629@CO6PR12MB5425.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oa5euWTXBuDzzFuKkeq7DV8yxzuUg0VJBGPO/D98TrXsKPdOjQf7CynvQOotpcddAB8HjZ5hMpograjkRriTHo9cOuQpmGkVs8t+XlIN9Kp2R1p5ZSSh36UVI75bhRATGYJDisig15GNWAKklKeUpglLRhwynLdWMiJ0wBHfC387r/02QdgniKvAy5d7bKhDSWXBTTXS3pi2yBInttJeu8QECDsrXPDeUzNIZi3xd5IvibQAh07mfkIVCI+plZa2PNG8miO8WCT7iCyxN9JKQhJc5vVazXI9XZxL1Z7aB20iyN4rRjVlgE3/dHqcDzoORe1mIS2NR17obnAiiaz9RYTg/ApCQCQnpAbX1TJF/VzD4eRj9sU5+hHpy/QFTlYGC6tVVQ4K5UggN+o/2IgjegsP+/5ccyBHgiPF07gYfR4Mjtg1570lpe9pITrpIcctvS7HLaHfy2JNCz5tH6WsCmRSmd9geKsBYvgWJg3XcN7RUmfPbTFc1qc0vcMzKYN7PxggI8UNUzUhkJHWdSYqXEcGoRKnCq8taQEHS+gEL1ILn5w0rAHPquKuNwLdq25jKeL1bFVQ9oCz1mE4p0JK6An5f5hh6fi/W3fyEjOxmCVPATA20CBuyuhEmZIXQCsp0tPI2JmxyJ6kbK6Q2Rsm+1iEhcdrphqvPOCM9Pi0HZU1gFvimcBbEVy/IKKPaM+2ho0tZrhv1XXpXVi1hLOT0m8BAqSBmAvwyaBYMB2zVV6JHDflxgEdP2qrQpvTA/cPN+202Hq0V2QgJODAaAhjuFMVhZyr3Ul3lkd3Ui7iNLCXujYmxSOEdQU6KRqazcwi
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(336012)(966005)(36756003)(70206006)(70586007)(4326008)(86362001)(2906002)(8676002)(31696002)(186003)(16576012)(83380400001)(53546011)(19627235002)(6666004)(426003)(356005)(82310400004)(5660300002)(107886003)(36860700001)(508600001)(26005)(31686004)(8936002)(110136005)(54906003)(2616005)(47076005)(16526019)(7636003)(316002)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2021 14:34:01.8391
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: de15d5ac-e9a3-46d2-ac98-08d9b0209fff
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT056.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR12MB5425
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-11-09 13:34, Daniel Borkmann wrote:
> Hi Maxim,
> 
> On 11/2/21 4:12 PM, Maxim Mikityanskiy wrote:
>> Hi guys,
>>
>> I think I found cases where the BPF verifier mistakenly rejects valid 
>> BPF programs when doing pkt_end boundary checks, and the selftests for 
>> these cases test wrong things as well.
>>
>> Daniel's commit fb2a311a31d3 ("bpf: fix off by one for range markings 
>> with L{T, E} patterns") [1] attempts to fix an off-by-one bug in 
>> boundary checks, but I think it shifts the index by 1 in a wrong 
>> direction, so instead of fixing, the bug becomes off-by-two.
>>
>> A following commit b37242c773b2 ("bpf: add test cases to bpf selftests 
>> to cover all access tests") [2] adds unit tests to check the new 
>> behavior, but the tests look also wrong to me.
>>
>> Let me analyze these two tests:
>>
>> {
>>          "XDP pkt read, pkt_data' > pkt_end, good access",
>>          .insns = {
>>          BPF_LDX_MEM(BPF_W, BPF_REG_2, BPF_REG_1, offsetof(struct 
>> xdp_md, data)),
>>          BPF_LDX_MEM(BPF_W, BPF_REG_3, BPF_REG_1,
>>                      offsetof(struct xdp_md, data_end)),
>>          BPF_MOV64_REG(BPF_REG_1, BPF_REG_2),
>>          BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, 8),
>>          BPF_JMP_REG(BPF_JGT, BPF_REG_1, BPF_REG_3, 1),
>>          BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1, -8),
>>          BPF_MOV64_IMM(BPF_REG_0, 0),
>>          BPF_EXIT_INSN(),
>>          },
>>          .result = ACCEPT,
>>          .prog_type = BPF_PROG_TYPE_XDP,
>>          .flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
>> },
>>
>> {
>>          "XDP pkt read, pkt_data' >= pkt_end, bad access 1",
>>          .insns = {
>>          BPF_LDX_MEM(BPF_W, BPF_REG_2, BPF_REG_1, offsetof(struct 
>> xdp_md, data)),
>>          BPF_LDX_MEM(BPF_W, BPF_REG_3, BPF_REG_1,
>>                      offsetof(struct xdp_md, data_end)),
>>          BPF_MOV64_REG(BPF_REG_1, BPF_REG_2),
>>          BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, 8),
>>          BPF_JMP_REG(BPF_JGE, BPF_REG_1, BPF_REG_3, 1),
>>          BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1, -8),
>>          BPF_MOV64_IMM(BPF_REG_0, 0),
>>          BPF_EXIT_INSN(),
>>          },
>>          .errstr = "R1 offset is outside of the packet",
>>          .result = REJECT,
>>          .prog_type = BPF_PROG_TYPE_XDP,
>>          .flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
>> },
>>
>> The first program looks good both to me and the verifier: if data + 8 
>> > data_end, we bail out, otherwise, if data + 8 <= data_end, we read 8 
>> bytes: [data; data+7].
>>
>> The second program doesn't pass the verifier, and the test expects it 
>> to be rejected, but the program itself still looks fine to me: if data 
>> + 8 >= data_end, we bail out, otherwise, if data + 8 < data_end, we 
>> read 8 bytes: [data; data+7], and this is fine, because data + 7 is 
>> for sure < data_end. The verifier considers data + 7 to be out of 
>> bounds, although both data + 7 and data + 8 are still valid offsets, 
>> hence the off-by-two bug.
>>
>> Are my considerations valid, or am I stupidly missing anything?
> 
> Sorry for my late reply, bit too swamped lately. So we have the two 
> variants:
> 
>    r2 = data;
>    r2 += 8;
>    if (r2 > data_end) goto <handle exception>
>      <access okay>
> 
>    r2 = data;
>    r2 += 8;
>    if (r2 >= data_end) goto <handle exception>
>      <access okay>
> 
> Technically, the first option is the more correct way to check, meaning, 
> we have 8 bytes of
> access in the <access okay> branch. The second one is overly pessimistic 
> in that if r2 equals
> data_end we bail out even though we wouldn't have to. So in that case 
> <access okay> branch
> would have 9 bytes for access since r2 with offset 8 is already < data_end.
> 
> Anyway, please send a fix and updated test cases. Thanks Maxim!

Just pinging with my status: I'm still on it, I returned from vacation 
and back to work, but I'm currently struggling with running the BPF 
selftests.

I'm using tools/testing/selftests/bpf/vmtest.sh, I've hit a few issues 
trying to make it work, especially the glibc version issue (I have glibc 
2.33 on my host, but the VM image has 2.32 and can't run binaries 
compiled on the host), for which I applied this workaround to build the 
test progs statically:

https://www.spinics.net/lists/bpf/msg41647.html

However, the test suite just hangs after:

...
+ /etc/rcS.d/S50-startup
./test_progs
[    1.639277] bpf_testmod: loading out-of-tree module taints kernel.
#1 align:OK
#2 atomic_bounds:OK
[    1.824515] tsc: Refined TSC clocksource calibration: 2399.983 MHz
[    1.826421] clocksource: tsc: mask: 0xffffffffffffffff max_cycles: 
0x22982765f14, max_idle_ns: 440795222551 ns
[    1.829486] clocksource: Switched to clocksource tsc
#3 atomics:OK
#4 attach_probe:OK
#5 autoload:OK
#6 bind_perm:OK
#7 bloom_filter_map:OK
#8 bpf_cookie:OK

Any hint would be much appreciated. I'm trying to do my debugging too.

Thanks,
Max
