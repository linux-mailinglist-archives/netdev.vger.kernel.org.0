Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4322043690F
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 19:31:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231604AbhJURdo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Oct 2021 13:33:44 -0400
Received: from mail-dm6nam08on2066.outbound.protection.outlook.com ([40.107.102.66]:19744
        "EHLO NAM04-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231281AbhJURdk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 Oct 2021 13:33:40 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cCCEn8nUSKmIVVY8hN+V3Ed289BtKsTNY5PnHBmcJwfW597+rUrfxFplp2dylAxQQkaspSBcJDY8WFSwWjVoCIUz6BkL1B6+DE1VI6Ok50KRwN0m6dnroLXtM68q/zgMPEIQckcv18b5Zz045gQygIdQ1RX/9UTyIIFmmsxd1hQrmP30D8bPdQr0Rn34Dj0VYrTqx9oephBPrvaNwOLqGOUAuU6y9DWg0QcjieuY5GVOiTenkUNw59BysAU0oGUHKlPR4RITl9IC3moCVno5HQ3LRR/4TqreoF7IN+oEPae2Q+6hB2T1YZZIUGEqrkrG2+RGjtP40QlxhczP7t68ag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=M6C9s3/LUsDNZy57CHUwlmB+nZMt26rI4LWN5wAcOGw=;
 b=M7V7aP2z4RUhgs9FdpHNxqB6+iwMiJ+t02F8TPazsFSygEXWzuXtaEWd+73NIQwwHtwlGwtw9swjlru8MgKyBfevbkuUrKplwkpVUNdvmjKPEZJIXsfG3OscXauzgvYdI8YoQcCT5RN4IarIAC5s/D4TH5RfZwPPR1g1gA8edmCiD2dQIpBXjW82dwsz3p+gMMb9kMqJoBR/w5Nxr23pX7f3qjiuIGo71QRlDFxGu/beBPxoq1LTYUNTb1tRV86DMQ7er/X8SJg4RHH0YX26VDD248jq+6ke9osY/UiWupZrk9tYuuW7+BtrOlRo9GfmTPp1ZIuYa7tkaPuuli+Rww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M6C9s3/LUsDNZy57CHUwlmB+nZMt26rI4LWN5wAcOGw=;
 b=EAV1LSV7hsMF/F3HcsCpTWjn9//tjiadBKUzzM/kfX4Qi3qwMG2i1UzUyt0vep+G+WHJzsV/qBf3cy/ynDVuy+cacpBLIJ9reXFvzGBDa+p0ws9kYPCcp9xbaV5EvKBBWZbKQpuULHd3BnAMYFIq8Pd6Xi9yewaKDxg1fO8myVmL5dEhPniOEg6CcFlFK69dyHr9zC9lUCbm+idN17QWZAiBxMBHAjIuChtmf+NCT2ehqOOZOad9R0U02iwJkeWh9cXJ3tkoPpcSoJf+vQAQQoGCPcUBMMORxPl01UuAgvo8TssrcFMRCfCp2KhYhAdN2HvlauiYMv4XwGHRrk2iIw==
Received: from MWHPR1401CA0004.namprd14.prod.outlook.com
 (2603:10b6:301:4b::14) by BL1PR12MB5255.namprd12.prod.outlook.com
 (2603:10b6:208:315::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.15; Thu, 21 Oct
 2021 17:31:21 +0000
Received: from CO1NAM11FT014.eop-nam11.prod.protection.outlook.com
 (2603:10b6:301:4b:cafe::f1) by MWHPR1401CA0004.outlook.office365.com
 (2603:10b6:301:4b::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.16 via Frontend
 Transport; Thu, 21 Oct 2021 17:31:21 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT014.mail.protection.outlook.com (10.13.175.99) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4628.16 via Frontend Transport; Thu, 21 Oct 2021 17:31:20 +0000
Received: from [172.27.0.234] (172.20.187.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 21 Oct
 2021 17:31:10 +0000
Message-ID: <055556e9-8028-a399-a099-f141a63cfbb5@nvidia.com>
Date:   Thu, 21 Oct 2021 20:31:06 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH bpf-next 10/10] bpf: Add sample for raw syncookie helpers
Content-Language: en-US
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        "Jesper Dangaard Brouer" <hawk@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        "Nick Desaulniers" <ndesaulniers@google.com>,
        Brendan Jackman <jackmanb@google.com>,
        Florent Revest <revest@chromium.org>,
        Joe Stringer <joe@cilium.io>,
        "Lorenz Bauer" <lmb@cloudflare.com>,
        Tariq Toukan <tariqt@nvidia.com>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <clang-built-linux@googlegroups.com>
References: <20211019144655.3483197-1-maximmi@nvidia.com>
 <20211019144655.3483197-11-maximmi@nvidia.com>
 <20211021010605.osyvspqie63asgn4@ast-mbp.dhcp.thefacebook.com>
From:   Maxim Mikityanskiy <maximmi@nvidia.com>
In-Reply-To: <20211021010605.osyvspqie63asgn4@ast-mbp.dhcp.thefacebook.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 34e0d999-6fc2-4b2b-702f-08d994b898d0
X-MS-TrafficTypeDiagnostic: BL1PR12MB5255:
X-Microsoft-Antispam-PRVS: <BL1PR12MB52551E4EF4BE591234C1D4BBDCBF9@BL1PR12MB5255.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jsipfv9pgXCnzcmeghPUBsulJWnjVonKXa8ggtPwnHZtQ1i/b/BZaRBPBHoQkJDXMUepprL1vMgClVusX4dEDs4N6F2CCumKNCYxYi9JnKezc2LydMw/awI/rMqc1IFVl5hgfJvfXy+VbQrwWufJlJwSfzxMk0PeCwfPdE0+UX1BYWVGPhn+yum1l+0zA3O/ByQcEQtdsj7uwf1SGNlOd8+zuu1xepkKvL0CmgXkwZvuA6iEPUZakzafMyxZMmQLvBzHnTMznbZdLcioFVnQl86O1fpkcAGSMCOiEqLnRuJ1cSYHh44d2hP9idOP2tCypmG9A9QWCw8MzI2drzabWeIC9cfP6EfcLxLqExu12PAWPCgO2XMhrarYIE1oPViSA2ooDfSU4nis/aU8hwdHBqxH8ZLAo33PULPNj4BcAJLEanjEW5XA3nA3ro2qLgxtn/LKUB4K0YVft/kMX8MXxu05wxOOpy2TzV7eqwwwvoWGAMxYiW9D5tNXwqDwpvDETvdrySIBKWMnXx5OJIAHDamE/YcTUEYyhX7YPhq6NEKxtFm5cBAAOzuIjZIJ6NiFB/9e9qiP44B0w+jnMtOolipGUgf0XLbyU9I5waHQAp2euCKDC6PPP4qceHPh+4onA/bDxzHv4GH52tnMkgoNmygOc/6zzdtQrsr3Mkx0bbOu0THj9jDKG0U+OGdI5PkrVl+Z2/0k/6JSnOBC79xv4dc5TPKBN2Pqze8uO4DTE0g=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(316002)(53546011)(7416002)(8676002)(5660300002)(16576012)(508600001)(31696002)(2616005)(336012)(426003)(36756003)(8936002)(31686004)(356005)(16526019)(6916009)(7636003)(4326008)(47076005)(2906002)(26005)(186003)(36860700001)(70206006)(54906003)(70586007)(82310400003)(4001150100001)(6666004)(86362001)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2021 17:31:20.3388
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 34e0d999-6fc2-4b2b-702f-08d994b898d0
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT014.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5255
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-10-21 04:06, Alexei Starovoitov wrote:
> On Tue, Oct 19, 2021 at 05:46:55PM +0300, Maxim Mikityanskiy wrote:
>> This commit adds a sample for the new BPF helpers: bpf_ct_lookup_tcp,
>> bpf_tcp_raw_gen_syncookie and bpf_tcp_raw_check_syncookie.
>>
>> samples/bpf/syncookie_kern.c is a BPF program that generates SYN cookies
>> on allowed TCP ports and sends SYNACKs to clients, accelerating synproxy
>> iptables module.
>>
>> samples/bpf/syncookie_user.c is a userspace control application that
>> allows to configure the following options in runtime: list of allowed
>> ports, MSS, window scale, TTL.
>>
>> samples/bpf/syncookie_test.sh is a script that demonstrates the setup of
>> synproxy with XDP acceleration.
>>
>> Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
>> Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
>> ---
>>   samples/bpf/.gitignore        |   1 +
>>   samples/bpf/Makefile          |   3 +
>>   samples/bpf/syncookie_kern.c  | 591 ++++++++++++++++++++++++++++++++++
>>   samples/bpf/syncookie_test.sh |  55 ++++
>>   samples/bpf/syncookie_user.c  | 388 ++++++++++++++++++++++
>>   5 files changed, 1038 insertions(+)
>>   create mode 100644 samples/bpf/syncookie_kern.c
>>   create mode 100755 samples/bpf/syncookie_test.sh
>>   create mode 100644 samples/bpf/syncookie_user.c
> 
> Tests should be in selftests/bpf.
> Samples are for samples only.

It's not a test, please don't be confused by the name of 
syncookie_test.sh - it's more like a demo script.

syncookie_user.c and syncookie_kern.c are 100% a sample, they show how 
to use the new helpers and are themselves a more or less 
feature-complete solution to protect from SYN flood. syncookie_test.sh 
should probably be named syncookie_demo.sh, it demonstrates how to bring 
pieces together.

These files aren't aimed to be a unit test for the new helpers, their 
purpose is to show the usage.

> 
>> +// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
> 
> Isn't it deprecated?
> LICENSES/deprecated/Linux-OpenIB

Honestly, I had no idea, I just used our template. I'll ask whoever is 
responsible for the license.

If it's deprecated, what should be used instead?

> 
>> +	// Don't combine additions to avoid 32-bit overflow.
> 
> c++ style comment?
> did you run checkpatch?

Sure I did, and it doesn't complain on such comments. If such comments 
are a problem, please tell me, but I also saw them in other BPF samples.

Thanks for reviewing!
