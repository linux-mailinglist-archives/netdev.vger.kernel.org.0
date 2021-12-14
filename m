Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 704E847448E
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 15:13:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234791AbhLNONw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 09:13:52 -0500
Received: from mail-mw2nam10on2057.outbound.protection.outlook.com ([40.107.94.57]:34465
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230093AbhLNONw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Dec 2021 09:13:52 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lJMSFePiyhWSdHxt50DtKaw3Zsi0d+iCmYyjQFiZ1s2/95vDlt0AtAStxdOMJsUL1c2H7FM/bg5O58BRLNE515g0HHy4wkYd5uoWrJ5L+TaVXvdC8rN72148ai8wnKbG7sETadyk2V/R4kmhu/OCm4f20Del5MqjONDn+NTke+lB3ub3UbV8xFvqVjt7Yriw8Qt19E9x5DQHC9TtpzuGaizp9tXWxecTWAaVCl3vIMKMfdNyb7BCE+tj6Y9Qqii1JhoucllOMGQzjlH9B0uU+lu+bRJ1Bz8xsdbT4oCAfrqSndYZ98FGGdY5JAXplCKCnIn8jRcH5CgtX/FiSGoDpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jI4WpIhh6FbO6JmRstnOxlJF8mBHcSMELo86z3HyMWQ=;
 b=ENrek3sc1nizryISNUbhAhogi5VOqugLjCRW/DIDM6jLZzbW5zO21pEm9Vg0dEiogQC1I7/b6AyjCdWX7Kc6GjfXf24wuItZBgclBAsFfzyhDNNSffDiDppHygrryxcZQIeUIOzxF8Z+3alErRJZXsPeHxPb4TxjtUZIR4q3nym66nqMnysL2mya6O1go7WZ7WO3gWybQaTkdDn5jZ6ILV6QmOLorsp4fkFlqnZE/0ufK1q6ioDqWEnWOpvMfQTBv8DpWCBfX+cLIQ+dXSKx8aXSbi0Nbnu7Clm/xcBVkFTA0nWDkWyx9q7YbkaLfcFlQFXLIL/m28Lethw6kdo0eQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 203.18.50.14) smtp.rcpttodomain=strlen.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jI4WpIhh6FbO6JmRstnOxlJF8mBHcSMELo86z3HyMWQ=;
 b=CSpzmKt5yLf61Eklid0Pmj8KyH2hyAjWOy+8z9uEvmSnBAYKGCO9MCPRoUrpqKRrDn+h63N/F+D4ZdPMw76KQtr/Soea442Lh11hdhO+9NQG48UChzSmGLNxj4XQrUnLuzdG5rMvdqUDqjOQZKfK6TRscPcRR9Pby/8Y5Iq3FUNRwljfARZhxHUsjC6C69hOr4mTmi+RLnEBO0mYyq5gZ3wXzbRDRy4vttycLxlLqd/MyhFnSugrqVjiqjsYppCpJmL4fuviMB2GEl7HTOFn4f6r3tF9UqfJwy3KWFlK8Af1P40xxy9AqBfCaAamOfzya/G2tgNeZdXv3pXBpG4jxw==
Received: from DM6PR03CA0002.namprd03.prod.outlook.com (2603:10b6:5:40::15) by
 DM5PR12MB1625.namprd12.prod.outlook.com (2603:10b6:4:b::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4778.16; Tue, 14 Dec 2021 14:13:49 +0000
Received: from DM6NAM11FT036.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:40:cafe::8f) by DM6PR03CA0002.outlook.office365.com
 (2603:10b6:5:40::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.14 via Frontend
 Transport; Tue, 14 Dec 2021 14:13:49 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 203.18.50.14)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 203.18.50.14 as permitted sender) receiver=protection.outlook.com;
 client-ip=203.18.50.14; helo=mail.nvidia.com;
Received: from mail.nvidia.com (203.18.50.14) by
 DM6NAM11FT036.mail.protection.outlook.com (10.13.172.64) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4778.13 via Frontend Transport; Tue, 14 Dec 2021 14:13:49 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by HKMAIL103.nvidia.com
 (10.18.16.12) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 14 Dec
 2021 14:13:23 +0000
Received: from [172.27.13.97] (172.20.187.5) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.986.9; Tue, 14 Dec 2021
 06:13:16 -0800
Message-ID: <da66687b-17fb-caa6-b5aa-7dff6b7bcb63@nvidia.com>
Date:   Tue, 14 Dec 2021 16:13:13 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH bpf-next v3 9/9] selftests/bpf: Add test for unstable CT
 lookup API
Content-Language: en-US
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
CC:     <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        "Martin KaFai Lau" <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Florian Westphal <fw@strlen.de>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        <netdev@vger.kernel.org>, <netfilter-devel@vger.kernel.org>
References: <20211210130230.4128676-1-memxor@gmail.com>
 <20211210130230.4128676-10-memxor@gmail.com>
From:   Maxim Mikityanskiy <maximmi@nvidia.com>
In-Reply-To: <20211210130230.4128676-10-memxor@gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e489ad6a-fc63-4ac0-9ffe-08d9bf0bf33b
X-MS-TrafficTypeDiagnostic: DM5PR12MB1625:EE_
X-Microsoft-Antispam-PRVS: <DM5PR12MB162522AB0B2FBF2B78B1A597DC759@DM5PR12MB1625.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +vpZ7GGdb0QmsZaG1z7CydjfkAzDfc7pbY6CSsCjfHxvlmC/ye+dxOSwjbpYyDm0sFn/ZfbSBeaL86lecoZoYEkaDUOHNFiF1A2Rv0pSL1Lg5d0Zw+7CsWOBfXennV3lGmW4Q4/gbJFzBV67K58zdPSvRB3QoO5IvnMvC1Mq72TPn+TYzfqpq6+kjSY4os5Eo5/TYTvMVes+/iLR81CFAX5CktDb5uTrbpB4XAGEc5B2Sas/gsK493xwvzDk4AohRoAl3WxDv78iKfz3/L5KWTUjS8GxeD45Fw4/HqVU3ET/Bcy1xLgGvQpHPaM/upbvJZ0ptHaTYhrpodmEmr4Yq42e0Ty87b2gWhlBldek8RauSAqUlLzAHMllG1p8yjO2XaH79oD6jOofzfbJY0tcBglyl6YiG72PfFwmaD5JIvda3FZkTBSYq0BOniSxZqDUS1ipUuHIAJJ/TA6A617mlt8/cY/uiIGgikKAcoSWpvwG4TWjRQv8joMlwbvqO6UXOXiYAv5fGJhb0r1ISE5U64itCwi7/hD0MvFsJSYs2li1YNfceoLNhrmbFGdeGPN1dmtx2z2kHPS9e3IBQ4Q0rqKClzWy16m17jGl1pIDrVB371CV5VXCEsqBqS8ojuhw0ptkfBTiQLmvofT/JE7LmZdSum/H0gTbXfTfP8JA+u37V4MzQsl8KSIy8+iy6mCo+ZTR3zZWSrKy1SmLfAR3lRcpXghFlMdjR1wq9cvmYDuswPibW9XEY6FPyNCfcjGtNtWTTbR2AaoJjRApQBjMtU0V2fvmr5+8q/jgc/9PiAnQEiT6sl+MynmLcWQhkJgrHYchzQZXjyXNt6EFcEBjoA==
X-Forefront-Antispam-Report: CIP:203.18.50.14;CTRY:HK;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:hkhybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(40470700001)(70206006)(336012)(86362001)(70586007)(426003)(4001150100001)(6916009)(2906002)(26005)(4326008)(36756003)(16526019)(34020700004)(186003)(54906003)(16576012)(53546011)(316002)(2616005)(83380400001)(7636003)(508600001)(356005)(5660300002)(7416002)(40460700001)(82310400004)(6666004)(8936002)(47076005)(31696002)(36860700001)(8676002)(31686004)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2021 14:13:49.1421
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e489ad6a-fc63-4ac0-9ffe-08d9bf0bf33b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[203.18.50.14];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT036.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1625
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-12-10 15:02, Kumar Kartikeya Dwivedi wrote:
> This tests that we return errors as documented, and also that the kfunc
> calls work from both XDP and TC hooks.
> 
> Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> ---
>   tools/testing/selftests/bpf/config            |   4 +
>   .../testing/selftests/bpf/prog_tests/bpf_nf.c |  48 ++++++++
>   .../testing/selftests/bpf/progs/test_bpf_nf.c | 113 ++++++++++++++++++
>   3 files changed, 165 insertions(+)
>   create mode 100644 tools/testing/selftests/bpf/prog_tests/bpf_nf.c
>   create mode 100644 tools/testing/selftests/bpf/progs/test_bpf_nf.c
> 
> diff --git a/tools/testing/selftests/bpf/config b/tools/testing/selftests/bpf/config
> index 5192305159ec..4a2a47fcd6ef 100644
> --- a/tools/testing/selftests/bpf/config
> +++ b/tools/testing/selftests/bpf/config
> @@ -46,3 +46,7 @@ CONFIG_IMA_READ_POLICY=y
>   CONFIG_BLK_DEV_LOOP=y
>   CONFIG_FUNCTION_TRACER=y
>   CONFIG_DYNAMIC_FTRACE=y
> +CONFIG_NETFILTER=y
> +CONFIG_NF_DEFRAG_IPV4=y
> +CONFIG_NF_DEFRAG_IPV6=y
> +CONFIG_NF_CONNTRACK=y
> diff --git a/tools/testing/selftests/bpf/prog_tests/bpf_nf.c b/tools/testing/selftests/bpf/prog_tests/bpf_nf.c
> new file mode 100644
> index 000000000000..56e8d745b8c8
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/prog_tests/bpf_nf.c
> @@ -0,0 +1,48 @@
> +// SPDX-License-Identifier: GPL-2.0
> +#include <test_progs.h>
> +#include <network_helpers.h>
> +#include "test_bpf_nf.skel.h"
> +
> +enum {
> +	TEST_XDP,
> +	TEST_TC_BPF,
> +};
> +
> +void test_bpf_nf_ct(int mode)
> +{
> +	struct test_bpf_nf *skel;
> +	int prog_fd, err, retval;
> +
> +	skel = test_bpf_nf__open_and_load();
> +	if (!ASSERT_OK_PTR(skel, "test_bpf_nf__open_and_load"))
> +		return;
> +
> +	if (mode == TEST_XDP)
> +		prog_fd = bpf_program__fd(skel->progs.nf_xdp_ct_test);
> +	else
> +		prog_fd = bpf_program__fd(skel->progs.nf_skb_ct_test);
> +
> +	err = bpf_prog_test_run(prog_fd, 1, &pkt_v4, sizeof(pkt_v4), NULL, NULL,
> +				(__u32 *)&retval, NULL);
> +	if (!ASSERT_OK(err, "bpf_prog_test_run"))
> +		goto end;
> +
> +	ASSERT_EQ(skel->bss->test_einval_bpf_tuple, -EINVAL, "Test EINVAL for NULL bpf_tuple");
> +	ASSERT_EQ(skel->bss->test_einval_reserved, -EINVAL, "Test EINVAL for reserved not set to 0");
> +	ASSERT_EQ(skel->bss->test_einval_netns_id, -EINVAL, "Test EINVAL for netns_id < -1");
> +	ASSERT_EQ(skel->bss->test_einval_len_opts, -EINVAL, "Test EINVAL for len__opts != NF_BPF_CT_OPTS_SZ");
> +	ASSERT_EQ(skel->bss->test_eproto_l4proto, -EPROTO, "Test EPROTO for l4proto != TCP or UDP");
> +	ASSERT_EQ(skel->bss->test_enonet_netns_id, -ENONET, "Test ENONET for bad but valid netns_id");
> +	ASSERT_EQ(skel->bss->test_enoent_lookup, -ENOENT, "Test ENOENT for failed lookup");
> +	ASSERT_EQ(skel->bss->test_eafnosupport, -EAFNOSUPPORT,"Test EAFNOSUPPORT for invalid len__tuple");
> +end:
> +	test_bpf_nf__destroy(skel);
> +}
> +
> +void test_bpf_nf(void)
> +{
> +	if (test__start_subtest("xdp-ct"))
> +		test_bpf_nf_ct(TEST_XDP);
> +	if (test__start_subtest("tc-bpf-ct"))
> +		test_bpf_nf_ct(TEST_TC_BPF);
> +}
> diff --git a/tools/testing/selftests/bpf/progs/test_bpf_nf.c b/tools/testing/selftests/bpf/progs/test_bpf_nf.c
> new file mode 100644
> index 000000000000..7cfff245b24f
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/test_bpf_nf.c
> @@ -0,0 +1,113 @@
> +// SPDX-License-Identifier: GPL-2.0
> +#include <vmlinux.h>
> +#include <bpf/bpf_helpers.h>
> +
> +#define EAFNOSUPPORT 97
> +#define EPROTO 71
> +#define ENONET 64
> +#define EINVAL 22
> +#define ENOENT 2
> +
> +int test_einval_bpf_tuple = 0;
> +int test_einval_reserved = 0;
> +int test_einval_netns_id = 0;
> +int test_einval_len_opts = 0;
> +int test_eproto_l4proto = 0;
> +int test_enonet_netns_id = 0;
> +int test_enoent_lookup = 0;
> +int test_eafnosupport = 0;
> +
> +struct nf_conn *bpf_xdp_ct_lookup(struct xdp_md *, struct bpf_sock_tuple *, u32,
> +				  struct bpf_ct_opts *, u32) __weak __ksym;
> +struct nf_conn *bpf_skb_ct_lookup(struct __sk_buff *, struct bpf_sock_tuple *, u32,
> +				  struct bpf_ct_opts *, u32) __weak __ksym;
> +void bpf_ct_release(struct nf_conn *) __weak __ksym;
> +
> +#define nf_ct_test(func, ctx)                                                  \
> +	({                                                                     \
> +		struct bpf_ct_opts opts_def = { .l4proto = IPPROTO_TCP,        \
> +						.netns_id = -1 };              \

I noticed that when CONFIG_NF_CONNTRACK=m, struct bpf_ct_opts doesn't 
get added to vmlinux.h. What is the right way to get definitions of 
structs from modules in BPF programs? Are they supposed to be part of 
vmlinux.h?

> +		struct bpf_sock_tuple bpf_tuple;                               \
> +		struct nf_conn *ct;                                            \
> +                                                                               \
> +		__builtin_memset(&bpf_tuple, 0, sizeof(bpf_tuple.ipv4));       \
> +		ct = func(ctx, NULL, 0, &opts_def, sizeof(opts_def));          \
> +		if (ct)                                                        \
> +			bpf_ct_release(ct);                                    \
> +		else                                                           \
> +			test_einval_bpf_tuple = opts_def.error;                \
> +                                                                               \
> +		opts_def.reserved[0] = 1;                                      \
> +		ct = func(ctx, &bpf_tuple, sizeof(bpf_tuple.ipv4), &opts_def,  \
> +			  sizeof(opts_def));                                   \
> +		opts_def.reserved[0] = 0;                                      \
> +		opts_def.l4proto = IPPROTO_TCP;                                \
> +		if (ct)                                                        \
> +			bpf_ct_release(ct);                                    \
> +		else                                                           \
> +			test_einval_reserved = opts_def.error;                 \
> +                                                                               \
> +		opts_def.netns_id = -2;                                        \
> +		ct = func(ctx, &bpf_tuple, sizeof(bpf_tuple.ipv4), &opts_def,  \
> +			  sizeof(opts_def));                                   \
> +		opts_def.netns_id = -1;                                        \
> +		if (ct)                                                        \
> +			bpf_ct_release(ct);                                    \
> +		else                                                           \
> +			test_einval_netns_id = opts_def.error;                 \
> +                                                                               \
> +		ct = func(ctx, &bpf_tuple, sizeof(bpf_tuple.ipv4), &opts_def,  \
> +			  sizeof(opts_def) - 1);                               \
> +		if (ct)                                                        \
> +			bpf_ct_release(ct);                                    \
> +		else                                                           \
> +			test_einval_len_opts = opts_def.error;                 \
> +                                                                               \
> +		opts_def.l4proto = IPPROTO_ICMP;                               \
> +		ct = func(ctx, &bpf_tuple, sizeof(bpf_tuple.ipv4), &opts_def,  \
> +			  sizeof(opts_def));                                   \
> +		opts_def.l4proto = IPPROTO_TCP;                                \
> +		if (ct)                                                        \
> +			bpf_ct_release(ct);                                    \
> +		else                                                           \
> +			test_eproto_l4proto = opts_def.error;                  \
> +                                                                               \
> +		opts_def.netns_id = 0xf00f;                                    \
> +		ct = func(ctx, &bpf_tuple, sizeof(bpf_tuple.ipv4), &opts_def,  \
> +			  sizeof(opts_def));                                   \
> +		opts_def.netns_id = -1;                                        \
> +		if (ct)                                                        \
> +			bpf_ct_release(ct);                                    \
> +		else                                                           \
> +			test_enonet_netns_id = opts_def.error;                 \
> +                                                                               \
> +		ct = func(ctx, &bpf_tuple, sizeof(bpf_tuple.ipv4), &opts_def,  \
> +			  sizeof(opts_def));                                   \
> +		if (ct)                                                        \
> +			bpf_ct_release(ct);                                    \
> +		else                                                           \
> +			test_enoent_lookup = opts_def.error;                   \
> +                                                                               \
> +		ct = func(ctx, &bpf_tuple, sizeof(bpf_tuple.ipv4) - 1,         \
> +			  &opts_def, sizeof(opts_def));                        \
> +		if (ct)                                                        \
> +			bpf_ct_release(ct);                                    \
> +		else                                                           \
> +			test_eafnosupport = opts_def.error;                    \
> +	})
> +
> +SEC("xdp")
> +int nf_xdp_ct_test(struct xdp_md *ctx)
> +{
> +	nf_ct_test(bpf_xdp_ct_lookup, ctx);
> +	return 0;
> +}
> +
> +SEC("tc")
> +int nf_skb_ct_test(struct __sk_buff *ctx)
> +{
> +	nf_ct_test(bpf_skb_ct_lookup, ctx);
> +	return 0;
> +}
> +
> +char _license[] SEC("license") = "GPL";

