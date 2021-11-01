Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14CF4441A8A
	for <lists+netdev@lfdr.de>; Mon,  1 Nov 2021 12:14:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232093AbhKALQ7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 07:16:59 -0400
Received: from mail-mw2nam10on2045.outbound.protection.outlook.com ([40.107.94.45]:30240
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232126AbhKALQ6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Nov 2021 07:16:58 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZZSeRz75N3XrNOxlvjyTd6lXaDifdxLJoGTWMP7tnP6R2bzXOuVGE4P30J0RhfMZ657ZLOf2Dy1sJ9eb7R4KK7q0ygU1YDLYpfINnVj+yEcFZvA4slGICEkFMhRCWVrjCS3yDXMf1L/RNUONMbNp5UWvW7ytbeCJfFznlv0tHTsSxmNzvavtnuODXmJb32Wa0MlhOP29oI9F5iHW1PjXq/WgCMMiZLVzd1uFZJwb5bOdDo5o9tNysLcyXDyX19UZdFByAJIi4vey20pTeBAcc41JQ3wPkGFJcLjIYNoF7pHxkYMFJs2GU+qko0JOgXsjhxKN6Orj2oIYkkD7bdvX0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=s0Tx1dqihqJwHC0wMTdZjhJuoWdfkkGu5EqUcjjz/EQ=;
 b=CcJWp7YdWdks+cLZmU427IxFRWYmI1L5KI/CXOe7pBjCo14WtmdZXfN63d7cUACyE6RAGKUN5CpcQQ19D3kSfkz81kw5Rkc85kYrNMR/sR8QxhOTdie98fyhREuOV92i5+3Ldz0lWG+mN+2c8QnMcZE1KjHOkwNCRmJfwch0EOgLL/odx86pNV6hXfOTN90qQ+6hWrLsRzTjPR2ifm9pH2DvKbk0gPhSeA7AzWHle6545VrfCxVHsDLGz8QfUYv88tTmG7AXLTu/AnBeZh7skppfM51ekWeT2BdSEBKvm0PPWVmvIpdLGRPDd2JMrttEhm95NQClbIZvI8iAaarTRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s0Tx1dqihqJwHC0wMTdZjhJuoWdfkkGu5EqUcjjz/EQ=;
 b=Z2YnJ45sLad/lE4JGPGxkI5ZDVwMjG8BOaFy0bf3XZ2YFwp0hGbTXmW8VJzlipt55fhv6/ul+RIyTFZBnH86Ek0zAHX2uiG2/A4pZpWzVs/vTOs3uuP/QsxNTZNn4WrvmLKBsxdDNhMGmnyFfMzeW+9vKsZDXmseja4qH1fF0/To7ZHy6wzV0053of0RakdmfX+7bbCTzBMp+El9hxk5mlz9dDWx0QVqYgg0v3VdSPLUkR08MVMQFGnvHWvbzx9s/nE6H2gfO+6uJHl4zfqGCuHgIdXnLVEmMHwJCmJG1sltx1IxZ3dKeQr7zEKr2VXFeNUfpv4abMU5AWscAE5M1A==
Received: from MW4PR03CA0032.namprd03.prod.outlook.com (2603:10b6:303:8e::7)
 by BYAPR12MB4631.namprd12.prod.outlook.com (2603:10b6:a03:10d::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.14; Mon, 1 Nov
 2021 11:14:22 +0000
Received: from CO1NAM11FT018.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8e:cafe::2c) by MW4PR03CA0032.outlook.office365.com
 (2603:10b6:303:8e::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.15 via Frontend
 Transport; Mon, 1 Nov 2021 11:14:22 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT018.mail.protection.outlook.com (10.13.175.16) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4649.14 via Frontend Transport; Mon, 1 Nov 2021 11:14:22 +0000
Received: from [172.27.15.76] (172.20.187.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 1 Nov
 2021 11:14:13 +0000
Message-ID: <1901a631-25c0-158d-b37f-df6d23d8e8ab@nvidia.com>
Date:   Mon, 1 Nov 2021 13:14:10 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH bpf-next 09/10] bpf: Add a helper to issue timestamp
 cookies in XDP
Content-Language: en-US
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        "Lorenz Bauer" <lmb@cloudflare.com>,
        Alexei Starovoitov <ast@kernel.org>
CC:     Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Brendan Jackman <jackmanb@google.com>,
        "Florent Revest" <revest@chromium.org>,
        Joe Stringer <joe@cilium.io>, Tariq Toukan <tariqt@nvidia.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        <clang-built-linux@googlegroups.com>
References: <20211019144655.3483197-1-maximmi@nvidia.com>
 <20211019144655.3483197-10-maximmi@nvidia.com>
 <CACAyw9_MT-+n_b1pLYrU+m6OicgRcndEBiOwb5Kc1w0CANd_9A@mail.gmail.com>
 <87y26nekoc.fsf@toke.dk>
From:   Maxim Mikityanskiy <maximmi@nvidia.com>
In-Reply-To: <87y26nekoc.fsf@toke.dk>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [172.20.187.6]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 654f6d49-4cb8-4267-b8c9-08d99d28c1b7
X-MS-TrafficTypeDiagnostic: BYAPR12MB4631:
X-Microsoft-Antispam-PRVS: <BYAPR12MB4631B7D679D5DCA95C1F1A93DC8A9@BYAPR12MB4631.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cgNeV9pf+gsQ5grEoTG3luxltxLqPwQ9Si3AVK6JxC1u/6zQ7HI0jv8ZIuXLNgGYZj1ixI9Tecj5C31/DthDf2mZAvzJ1/X974es2wuZ0cQX2c+9dZI6bqMYNK8NCmml1dosxJGqqi6HsSa6bPsRyAWb3aGZGIHvLPGWiVD84SaiQ1kjChtAvLuzh3yy08Fk/zRB1mP9OZUb04oHHPtXl935UY2d1S9DeLl03buAXkacxofIpazQHg3kRrzpWmGTg5ghkRjWpTOOiX55mAm46BcD+HmJkurYtVEU2tjNgEiMBQvdeQIgxchu5Fo4JoTBwpDcc6rdHjaz06PedYB4/O9RYYPeNVKqYFyiAZBb15HGoMS5OibmMBk55A1sOXPCeIG3ISFBYk93vbXXIw56mi/0+QThDKuvwsoxZnQc8w3TGWSgf+2c16Tamj+QUghkNvNpCxfPMmIMrnBAgP95qp+gqrj3u9R+/v2RY2lSFfUyF1pyMap9q/UAkxWQMbI9rGs56x2f+jKtNo4ClF2pXC9q5jpUUHNYczZDxMtP1Sq1QFdSnJN2quMO7C+LfrNsp69VtTXTQZ5KF+YHHONH0DNbWibdfcnjxjNHKyhsHfCMG8ACpM5s8lMVWUskn8CcG4DBfVBUyFcZaCSD1Pq+mnFXtvyGMZoVrL5KHYhaD9aFqecOskk0rmqleNOK4OozL5nSYTkdhVaWzoLg0gfHSZH6+EyZxQQMAX20bqF9zPA=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(16576012)(4001150100001)(2906002)(83380400001)(316002)(70206006)(336012)(8676002)(54906003)(47076005)(70586007)(426003)(8936002)(2616005)(110136005)(36906005)(508600001)(53546011)(356005)(26005)(7416002)(4326008)(36860700001)(16526019)(7636003)(82310400003)(66574015)(31686004)(31696002)(186003)(86362001)(5660300002)(36756003)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Nov 2021 11:14:22.2802
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 654f6d49-4cb8-4267-b8c9-08d99d28c1b7
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT018.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB4631
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-10-20 19:16, Toke Høiland-Jørgensen wrote:
> Lorenz Bauer <lmb@cloudflare.com> writes:
> 
>>> +bool cookie_init_timestamp_raw(struct tcphdr *th, __be32 *tsval, __be32 *tsecr)
>>
>> I'm probably missing context, Is there something in this function that
>> means you can't implement it in BPF?
> 
> I was about to reply with some other comments but upon closer inspection
> I ended up at the same conclusion: this helper doesn't seem to be needed
> at all?

After trying to put this code into BPF (replacing the underlying 
ktime_get_ns with ktime_get_mono_fast_ns), I experienced issues with 
passing the verifier.

In addition to comparing ptr to end, I had to add checks that compare 
ptr to data_end, because the verifier can't deduce that end <= data_end. 
More branches will add a certain slowdown (not measured).

A more serious issue is the overall program complexity. Even though the 
loop over the TCP options has an upper bound, and the pointer advances 
by at least one byte every iteration, I had to limit the total number of 
iterations artificially. The maximum number of iterations that makes the 
verifier happy is 10. With more iterations, I have the following error:

BPF program is too large. Processed 1000001 insn 
 
 
                        processed 1000001 insns (limit 1000000) 
max_states_per_insn 29 total_states 35489 peak_states 596 mark_read 45

I assume that BPF_COMPLEXITY_LIMIT_INSNS (1 million) is the accumulated 
amount of instructions that the verifier can process in all branches, is 
that right? It doesn't look realistic that my program can run 1 million 
instructions in a single run, but it might be that if you take all 
possible flows and add up the instructions from these flows, it will 
exceed 1 million.

The limitation of maximum 10 TCP options might be not enough, given that 
valid packets are permitted to include more than 10 NOPs. An alternative 
of using bpf_load_hdr_opt and calling it three times doesn't look good 
either, because it will be about three times slower than going over the 
options once. So maybe having a helper for that is better than trying to 
fit it into BPF?

One more interesting fact is the time that it takes for the verifier to 
check my program. If it's limited to 10 iterations, it does it pretty 
fast, but if I try to increase the number to 11 iterations, it takes 
several minutes for the verifier to reach 1 million instructions and 
print the error then. I also tried grouping the NOPs in an inner loop to 
count only 10 real options, and the verifier has been running for a few 
hours without any response. Is it normal? Commit c04c0d2b968a ("bpf: 
increase complexity limit and maximum program size") says it shouldn't 
take more than one second in any case.

Thanks,
Max
