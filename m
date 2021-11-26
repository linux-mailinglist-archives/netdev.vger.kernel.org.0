Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5ED145F2A0
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 18:09:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231545AbhKZRMl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Nov 2021 12:12:41 -0500
Received: from mail-bn1nam07on2088.outbound.protection.outlook.com ([40.107.212.88]:44438
        "EHLO NAM02-BN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229555AbhKZRKk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Nov 2021 12:10:40 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BVd/r9Zm0kmpnMAmYoic/jYZexLUYXb8PTr7L++83Qn/cM3ZltMjDqLYMNqH3Zt5eOeKnN8lScdOnJpE2JiFZhowPPwIR4p2DLUQxgvhoqE5/bEgvS9zeU7mnCzC6bSNruU3VTXWRUIuH72t8gtIw8egdhIlVnnkxAK8DBZet0NFY4hcIkETLz5RwL81am8ED5phi34he9z4U/14P9I+Wst4H1VSpAQl0cjoVA4mWus+bVil3a0vJplV/mw9orDj7EopvwNi8Siw9dmGyNR2Pl/zRojHoX1i51Yf8lOqUTczuhxWAMPNqhE9qMIfucoOYWR/Si70DNmMBYHjLQPgYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MD6ZlNOYQbh/kIQrLUcYNexs256WG4JbbJbt3gPGyuQ=;
 b=Ay3VNcR7rl3HV3G5UBDNM0iTU8knF2Yl0oA0YI6keNd6Y+mdeVIbb88n4ndVxGHBhul2dVPQB3CPdNb3obxM8r+O/pbL0BKMIZPUh+ZiabVD+OoHLXOJNu1U9Apo/wrwbYPqDTFFz9ZrB/NIuzWdg1HiX7gx3uJGWlneOT+jsMiCjiqcfZUaabhP8G12eSrXHi3EyF+I23/D6qt2DPg5njlNHvBIxmYaADnRc5QH+LpPRMEYQuJoNMIZrn+F5Z5glLTFluvlyp15T4/X1ILRNrA0uEff7N1e7ycsqudiYaENSgWCHrB69S/wmxxvrIVjwtvvPFfpG6p6KEqYQeuSsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=temperror (sender ip
 is 216.228.112.34) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=temperror action=none header.from=nvidia.com; dkim=none (message not
 signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MD6ZlNOYQbh/kIQrLUcYNexs256WG4JbbJbt3gPGyuQ=;
 b=EWKmYNN7R4J3Nv1kxjS+6SQrE78G2cmdwdbqYANfuSuNmQVZYc/jBjPAKZMXu+dTOTWEAvdahFS2xfYd/oziNtEVdF/CNkIAduOGl6NyqSr8pE3bqyRc2kttJr8PKWPmJb1u1uiAmBJn0lmjBX2ArfYH9JptjnnEoFRlJf8bTRAtWIgmrfnJDtSjzoPUzFmwKgTxEZk8uIRHtFPcgxpBdc98KKNGoNETWZEoIP93UfUkp6vLEwEEhLqU6AfgAx+xzOkRZUbXisskmOT30EQ7qPV27fsYHe36AzgyAms0qFSlxFIf4yD6LIGlU4BZ7iVFo+jPzCyeWRw3YNgLjzt6pQ==
Received: from BN6PR19CA0055.namprd19.prod.outlook.com (2603:10b6:404:e3::17)
 by BYAPR12MB3109.namprd12.prod.outlook.com (2603:10b6:a03:db::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.23; Fri, 26 Nov
 2021 17:07:25 +0000
Received: from BN8NAM11FT046.eop-nam11.prod.protection.outlook.com
 (2603:10b6:404:e3:cafe::44) by BN6PR19CA0055.outlook.office365.com
 (2603:10b6:404:e3::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.22 via Frontend
 Transport; Fri, 26 Nov 2021 17:07:25 +0000
X-MS-Exchange-Authentication-Results: spf=temperror (sender IP is
 216.228.112.34) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=temperror action=none header.from=nvidia.com;
Received-SPF: TempError (protection.outlook.com: error in processing during
 lookup of nvidia.com: DNS Timeout)
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT046.mail.protection.outlook.com (10.13.177.127) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4734.22 via Frontend Transport; Fri, 26 Nov 2021 17:07:23 +0000
Received: from [172.27.0.11] (172.20.187.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Fri, 26 Nov
 2021 17:07:20 +0000
Message-ID: <9c2407eb-9d67-acd6-a38d-8d390eedfb5a@nvidia.com>
Date:   Fri, 26 Nov 2021 19:07:16 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: 4-year old off-by-two bug in the BPF verifier's boundary checks?
Content-Language: en-US
From:   Maxim Mikityanskiy <maximmi@nvidia.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@nvidia.com>
References: <279b0a91-506d-e657-022d-aad52c17dfc6@nvidia.com>
 <fd6296d6-154c-814a-f088-e0567a566a21@iogearbox.net>
 <23ed87c9-5598-27d3-6851-b41262bc9bfa@nvidia.com>
In-Reply-To: <23ed87c9-5598-27d3-6851-b41262bc9bfa@nvidia.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [172.20.187.6]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 110578ec-ac58-4026-3818-08d9b0ff3716
X-MS-TrafficTypeDiagnostic: BYAPR12MB3109:
X-Microsoft-Antispam-PRVS: <BYAPR12MB310912211F877007A349B569DC639@BYAPR12MB3109.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WzQB0T8fCyq4HSuBUitrsSJOkrT1loe0G4heFddvVstFm2gWEwbpbm3YWhSx2YkoB2GIih4KMa03cgDcPvKQRm6SCWDD/CmGkaT8f36tIL+Xl+I8mWwvIrl+Yma/5koU+5LeLTSWzowrJHoQ1vB+fFmqEpz0oIu5GV9r8DVuWx16jjm/oBx8Hb57S+MWiFbz7V0uTge66ELcZ3J5zxY+biDWK3cyg6wQCuLyhIltS/Swj97ONzykJY1chmH2mu7q6Yx/S0JL91QbsGAARNWQ2FqWoYi/46lJBj5Lmg2KwR6lGVPyDHo0TXKUO7Lv0UIG56rdvkR5W6N7Fgm3ijatDguoaiRsd0n6R23GFlNWVpHQe7pO1WzZXoQmd+mdCd4X8BsGFNzIZ+m+hbeH/uSR5zDRU55OwiSDhFv5TUUNmIhKCqBLYf+9UhPnZjqpK0AjjiFSahxNp3zNiV9EzLwdGSFNjr2BN4q7cJIWJ8muorMHoyNCtOpAoL/VmRBgWj2JHnTo/0+T6qoPB3w0gt6XZKLzVhIEp5yBydUolR1jRVKw5YqXKbosawWfThU9alKY/z2zT3TXIvqVKftFVjOVq+Xxdxmlg2kFHUS3bc25d3tVNQjNsEDJsXo8FnN/n7maiFdX6FN/1q9SheyLIE8PA1T6lUJqapTixZfp2rdVbTP6FrHnO9am/bvvRctCvOmM7v2hFZ+tEXWhwLeGHEmx7OfLteqo9+jzt0CG7QcfX0QI3bEy7/j93zInw7FoY7TmEAdtakIlM48uDEFtVZH3w1drzmYUn88+oz/c2mK/AKgeC4zEw6oslZ1OI2P3Z4uL
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(2616005)(63370400001)(36860700001)(53546011)(82310400004)(107886003)(7636003)(36756003)(356005)(4001150100001)(5660300002)(966005)(426003)(4326008)(63350400001)(31696002)(8936002)(45080400002)(83380400001)(508600001)(16526019)(8676002)(186003)(19627235002)(336012)(2906002)(6666004)(16576012)(47076005)(70586007)(26005)(31686004)(54906003)(110136005)(86362001)(316002)(70206006)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Nov 2021 17:07:23.5278
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 110578ec-ac58-4026-3818-08d9b0ff3716
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT046.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3109
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-11-25 16:33, Maxim Mikityanskiy wrote:
> On 2021-11-09 13:34, Daniel Borkmann wrote:
>> Hi Maxim,
>>
>> On 11/2/21 4:12 PM, Maxim Mikityanskiy wrote:
>>> Hi guys,
>>>
>>> I think I found cases where the BPF verifier mistakenly rejects valid 
>>> BPF programs when doing pkt_end boundary checks, and the selftests 
>>> for these cases test wrong things as well.
>>>
>>> Daniel's commit fb2a311a31d3 ("bpf: fix off by one for range markings 
>>> with L{T, E} patterns") [1] attempts to fix an off-by-one bug in 
>>> boundary checks, but I think it shifts the index by 1 in a wrong 
>>> direction, so instead of fixing, the bug becomes off-by-two.
>>>
>>> A following commit b37242c773b2 ("bpf: add test cases to bpf 
>>> selftests to cover all access tests") [2] adds unit tests to check 
>>> the new behavior, but the tests look also wrong to me.
>>>
>>> Let me analyze these two tests:
>>>
>>> {
>>>          "XDP pkt read, pkt_data' > pkt_end, good access",
>>>          .insns = {
>>>          BPF_LDX_MEM(BPF_W, BPF_REG_2, BPF_REG_1, offsetof(struct 
>>> xdp_md, data)),
>>>          BPF_LDX_MEM(BPF_W, BPF_REG_3, BPF_REG_1,
>>>                      offsetof(struct xdp_md, data_end)),
>>>          BPF_MOV64_REG(BPF_REG_1, BPF_REG_2),
>>>          BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, 8),
>>>          BPF_JMP_REG(BPF_JGT, BPF_REG_1, BPF_REG_3, 1),
>>>          BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1, -8),
>>>          BPF_MOV64_IMM(BPF_REG_0, 0),
>>>          BPF_EXIT_INSN(),
>>>          },
>>>          .result = ACCEPT,
>>>          .prog_type = BPF_PROG_TYPE_XDP,
>>>          .flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
>>> },
>>>
>>> {
>>>          "XDP pkt read, pkt_data' >= pkt_end, bad access 1",
>>>          .insns = {
>>>          BPF_LDX_MEM(BPF_W, BPF_REG_2, BPF_REG_1, offsetof(struct 
>>> xdp_md, data)),
>>>          BPF_LDX_MEM(BPF_W, BPF_REG_3, BPF_REG_1,
>>>                      offsetof(struct xdp_md, data_end)),
>>>          BPF_MOV64_REG(BPF_REG_1, BPF_REG_2),
>>>          BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, 8),
>>>          BPF_JMP_REG(BPF_JGE, BPF_REG_1, BPF_REG_3, 1),
>>>          BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1, -8),
>>>          BPF_MOV64_IMM(BPF_REG_0, 0),
>>>          BPF_EXIT_INSN(),
>>>          },
>>>          .errstr = "R1 offset is outside of the packet",
>>>          .result = REJECT,
>>>          .prog_type = BPF_PROG_TYPE_XDP,
>>>          .flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
>>> },
>>>
>>> The first program looks good both to me and the verifier: if data + 8 
>>> > data_end, we bail out, otherwise, if data + 8 <= data_end, we read 
>>> 8 bytes: [data; data+7].
>>>
>>> The second program doesn't pass the verifier, and the test expects it 
>>> to be rejected, but the program itself still looks fine to me: if 
>>> data + 8 >= data_end, we bail out, otherwise, if data + 8 < data_end, 
>>> we read 8 bytes: [data; data+7], and this is fine, because data + 7 
>>> is for sure < data_end. The verifier considers data + 7 to be out of 
>>> bounds, although both data + 7 and data + 8 are still valid offsets, 
>>> hence the off-by-two bug.
>>>
>>> Are my considerations valid, or am I stupidly missing anything?
>>
>> Sorry for my late reply, bit too swamped lately. So we have the two 
>> variants:
>>
>>    r2 = data;
>>    r2 += 8;
>>    if (r2 > data_end) goto <handle exception>
>>      <access okay>
>>
>>    r2 = data;
>>    r2 += 8;
>>    if (r2 >= data_end) goto <handle exception>
>>      <access okay>
>>
>> Technically, the first option is the more correct way to check, 
>> meaning, we have 8 bytes of
>> access in the <access okay> branch. The second one is overly 
>> pessimistic in that if r2 equals
>> data_end we bail out even though we wouldn't have to. So in that case 
>> <access okay> branch
>> would have 9 bytes for access since r2 with offset 8 is already < 
>> data_end.
>>
>> Anyway, please send a fix and updated test cases. Thanks Maxim!
> 
> Just pinging with my status: I'm still on it, I returned from vacation 
> and back to work, but I'm currently struggling with running the BPF 
> selftests.
> 
> I'm using tools/testing/selftests/bpf/vmtest.sh, I've hit a few issues 
> trying to make it work, especially the glibc version issue (I have glibc 
> 2.33 on my host, but the VM image has 2.32 and can't run binaries 
> compiled on the host), for which I applied this workaround to build the 
> test progs statically:
> 
> https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Fwww.spinics.net%2Flists%2Fbpf%2Fmsg41647.html&amp;data=04%7C01%7Cmaximmi%40nvidia.com%7C13976fd5b93e4df1a6ca08d9b020eaaf%7C43083d15727340c1b7db39efd9ccc17a%7C0%7C0%7C637734477702442983%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000&amp;sdata=sklOvJNabJJtUzktnCw1s0M4pLb7UJnd0xezhvvH8os%3D&amp;reserved=0 
> 
> 
> However, the test suite just hangs after:
> 
> ...
> + /etc/rcS.d/S50-startup
> ./test_progs
> [    1.639277] bpf_testmod: loading out-of-tree module taints kernel.
> #1 align:OK
> #2 atomic_bounds:OK
> [    1.824515] tsc: Refined TSC clocksource calibration: 2399.983 MHz
> [    1.826421] clocksource: tsc: mask: 0xffffffffffffffff max_cycles: 
> 0x22982765f14, max_idle_ns: 440795222551 ns
> [    1.829486] clocksource: Switched to clocksource tsc
> #3 atomics:OK
> #4 attach_probe:OK
> #5 autoload:OK
> #6 bind_perm:OK
> #7 bloom_filter_map:OK
> #8 bpf_cookie:OK

I figured out that I actually had to run test_verifier, rather than 
test_progs, but I also found the issue with test_progs:

tools/testing/selftests/bpf/prog_tests/bpf_iter.c:

/* Read CMP_BUFFER_SIZE (1kB) from bpf_iter. Read in small chunks
  * to trigger seq_file corner cases. The expected output is much
  * longer than 1kB, so the while loop will terminate.
  */
len = 0;
while (len < CMP_BUFFER_SIZE) {
         err = read_fd_into_buffer(iter_fd, task_vma_output + len,
                                   min(read_size, CMP_BUFFER_SIZE - len));
         if (CHECK(err < 0, "read_iter_fd", "read_iter_fd failed\n"))
                 goto out;
         len += err;
}

The output was actually shorter than 1K, err was 0, and the loop was 
infinite. I think a simple `if (!err) break;` should fix it. I'll submit 
it as well.

> 
> Any hint would be much appreciated. I'm trying to do my debugging too.
> 
> Thanks,
> Max

