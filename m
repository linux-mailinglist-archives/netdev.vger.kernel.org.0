Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 282694D26E9
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 05:06:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231756AbiCID3I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 22:29:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231751AbiCID3H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 22:29:07 -0500
Received: from APC01-SG2-obe.outbound.protection.outlook.com (mail-sgaapc01on2114.outbound.protection.outlook.com [40.107.215.114])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB41B606C0;
        Tue,  8 Mar 2022 19:28:08 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V56K7EIW9YgAiDgn69YTQWbgN43B5iYFQ5GrnR4JbPfnsIrpkI3y0lliy+HUQq7Pl5ejdC/1omrvq5KFtd33GLk5c1n5SIUUY+r9Joqb8SiBp4Bhg8OrxnZhBVxiOBkfcPZws5CPtTSfwoVhMgo+Et3hjBv4XK+yRv6d7HCjjmHWD5gxSR1wZF6wFDRRhyczv9+fKzA7tAdZOrdevjfvj7K9zvTVNRFcT33ye3ayXjnk3VweHr2w3P/mSvooHnfCgaHDOAczjN9NZsgmWJ6WXHIgCPe4f+79jzpOliz05el+4PafjcDh27bqMYnL5dw/BMSu5q4+4NYaWqie6ofrPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PsTvfaPVIz0ijZDWkEoP5d1+44dwkiCSKx6ak8H2HVM=;
 b=JZgOj3IVcp3s7cTGGRJ9a2i4BpVLCTCQOiGbDa6VOcatDoQ6Q/+Ox8un1uA5MgsabbQXEnoeweILZzQ60fQb4MMUT3TKpSUPbCO2yDEJEMWjwe+X3ccCdV65giedT4X768zKLLWzLe+a/8Cb7D1vQ00T/LZi3KZifBe+tBjnqNFUDjPdFVQC1mxFnoRQr+vHlR+RZ7ziiA7bh0NKN6z4Vk87X1I+TxEaMJPlXq95UkTbpQEVamC0MK+82JkBUSFRSWZQUkNUlR9kzOb6F0etAGOyh4HBjNjr58drCI68Hppuvn5M/FZy7jtdT33GW9sivWbEtkGeUctnWmUfFRjI0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo0.onmicrosoft.com;
 s=selector2-vivo0-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PsTvfaPVIz0ijZDWkEoP5d1+44dwkiCSKx6ak8H2HVM=;
 b=lXnURFZZkobP3Vwl5eKoTUSGhADuFhT5DTvDSB6jTTaDoY4FuJpBF6jsd7cHGv22w/NNIo12MqcHIXoGw+EhKNYtrySj6MbdkS1p08MQGpAO4fcJa6KQvQS/aDg5uktMRWTrPDNe0fxEp40fITDmQkXtlz76LNqVi7smZJSplL4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from HK2PR06MB3492.apcprd06.prod.outlook.com (2603:1096:202:2f::10)
 by SG2PR06MB2523.apcprd06.prod.outlook.com (2603:1096:4:5e::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.18; Wed, 9 Mar
 2022 03:28:03 +0000
Received: from HK2PR06MB3492.apcprd06.prod.outlook.com
 ([fe80::d924:a610:681d:6d59]) by HK2PR06MB3492.apcprd06.prod.outlook.com
 ([fe80::d924:a610:681d:6d59%5]) with mapi id 15.20.5038.027; Wed, 9 Mar 2022
 03:28:03 +0000
Message-ID: <86879fb3-e3f8-7857-2ed9-490340f3c6fe@vivo.com>
Date:   Wed, 9 Mar 2022 11:27:57 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [PATCH v2] selftests/bpf: fix array_size.cocci warning
Content-Language: en-US
To:     Shuah Khan <shuah@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Yucong Sun <sunyucong@gmail.com>,
        Dave Marchevsky <davemarchevsky@fb.com>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Christy Lee <christylee@fb.com>,
        Delyan Kratunov <delyank@fb.com>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        "open list:BPF (Safe dynamic programs and tools)" 
        <netdev@vger.kernel.org>,
        "open list:BPF (Safe dynamic programs and tools)" 
        <bpf@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
Cc:     "zhengkui_guo@outlook.com" <zhengkui_guo@outlook.com>
References: <b01130f4-0f9c-9fe4-639b-0dcece4ca09a@iogearbox.net>
 <20220309032325.1526-1-guozhengkui@vivo.com>
From:   Guo Zhengkui <guozhengkui@vivo.com>
In-Reply-To: <20220309032325.1526-1-guozhengkui@vivo.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR0302CA0011.apcprd03.prod.outlook.com
 (2603:1096:3:2::21) To HK2PR06MB3492.apcprd06.prod.outlook.com
 (2603:1096:202:2f::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9fb83627-2f4e-424b-447d-08da017cd1a2
X-MS-TrafficTypeDiagnostic: SG2PR06MB2523:EE_
X-Microsoft-Antispam-PRVS: <SG2PR06MB2523BD20D0CDEE217337271CC70A9@SG2PR06MB2523.apcprd06.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ps3+QzsgvD/uehJyJgzKDK9I+usQHH2RwOwCCugJz/CO4AFLYIb074j9jus1N/aawmizV1pA8aN0k9OyFZOQgj4Ru75FI2vSQwvzQ6vEjB2ybauSPMANtpbCvq2YojCe0fIvm+4p7iLObaBwKzMA/FQcboK5kFyr0UIF/GGoLXoUrU8Sqmfuo/6HsPDoE9FMqPtk73E/aYmF6Mi47ZgT6qslmdKT4OkrOvdPBrVGc8xPCQdSWASFih2xJfoDJ4sTHut63lawerpH24LITeczp6kRH1iRAKKegLtnirILDu9iBSoREtl+E/Md1j7MYsHb84I83N3yhcEPZcwmcu7WiBX2GeqoXZ1X2EC2RAvJAY9Gs5YlhiQ0YRFuzFVi/QcUyLdnP4qflBbVGAcMpSqjkrNj+Ti/jC5ftg5PbZg9EV5r++1EJzwByMdf2PV5DQXGO9botil0+UnSoVBlHU9Wpk5YdzlLvzwlkf2KM2VzamQaeo2DB6EIUdLHFMbPSlMNTN8s7ijB3h5b84pXW3wTa1FtPKxcDFl6f8BUUMwpvnxM7riQnkPZXBQDeCGZSMyVr+sWayo8cQ9NblxJi/iWA51DnxgMq/I1rMTH8MVjIu3xq5gZweE5KvtjWQ6PvqhPwNCEwkDndr1D/emyKI6F5YtrjXeJJeRYlB157XoSjXjGhiRV0BPhlZ7L1XcQF08WWuHoXXQTmYXp/4vcET2Yu2mC5yTa5tBlbiBHJLFfY9iP08uJcgCzsqr6nRz3tUZq2E5rt9Ew7t8FFJykBoCLrXKrtkqLavs81bGDgGHrKqg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HK2PR06MB3492.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(2616005)(83380400001)(86362001)(38100700002)(38350700002)(7416002)(31696002)(186003)(921005)(30864003)(8936002)(5660300002)(36756003)(2906002)(26005)(66476007)(4326008)(8676002)(66946007)(66556008)(6666004)(6506007)(6512007)(52116002)(53546011)(31686004)(6486002)(508600001)(110136005)(316002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OUVINkJSQ0FFMGtRRWtYaE1JanRoWkNzQjZSbzVGWFFveFViVFpHRmhzY1U3?=
 =?utf-8?B?QjFoZnpSSlVVZURQSmxVMlhHbEpvK0FaS0FsRlhNSnh5KzJibS9UblNxQ1k0?=
 =?utf-8?B?V3Ewai9TUTFEL01hOEZsdFhTajFNaHQ1NCtVU3Joc1JPWEh2QTRYOUx6dnp4?=
 =?utf-8?B?dzVuNktmRm11c1VZZ3ZOZ2hYOVBFRmRRZkxKQ2EybFA3SlpoVmtaS1pOeER1?=
 =?utf-8?B?MkpqU2Q1N3p1UVVheHI1TkxaVEFoSkNkemdjblFhdFo0elFGb0M5WEhQRTg1?=
 =?utf-8?B?ejVONW55MDFyRVhWeElqVm12NjRSa0FNT2ZWVVZpUFJLeDFNM2FOR0k2NWNG?=
 =?utf-8?B?Vk1kMmxtRi84aW92eEl5ek90Tjc5b3hDMmJIR3hIbzVEN2c5blpBcmdyRXdh?=
 =?utf-8?B?b0xKemtjQXNYZG1PSTV5d2FIdS80dXE5T1J6VVhkZEhvUDNJKzcwMmZZbDBq?=
 =?utf-8?B?eTVVcVlPenlJNkI2eDFWNEtQYStFRDB3ZjN3MEJJWVBUZ0lKUWdQKy9NZFlF?=
 =?utf-8?B?RTZEWHBrRUpWUmNKOHYyOVJkUE56WlIzNy91R3hDd3BtUmIyUUZ0NkJjbVBh?=
 =?utf-8?B?d1JPZzZXM1I4cHpkcWVSbThqcnBVR2FGL1NDK2RRWkIvdWdzbDkrdTZkOGUy?=
 =?utf-8?B?OG5UWERpN3dSVXViMVNhaEc1OUxlejF0NG1DN1dFaWpuV1d1YW1PVHVKd2Q3?=
 =?utf-8?B?Yzg4bWROdFgvU0NIa2psaTNNN2JocS9jdTlLYVpPcW5vY2kwMUd0RnVEKytk?=
 =?utf-8?B?V3dUR3dIWFR2N1hDSEE4UXljVnJRMjk4Z2czT3VzYnd3YTIzZEVqK29VN3Bv?=
 =?utf-8?B?RXo0YUlyUGNPaEJFQTF5dy9USEllRWFiR2ZDSVRHOTJmbjF2bHpyUU5mWWNQ?=
 =?utf-8?B?QjVTMWFLUHVxcDd0aG05VlhIaGJ1bWFaUmZPRFhZWitDelEzY05jOTB4OGdP?=
 =?utf-8?B?eC9mV0s3aWp1bko1eTZzVCtyL0lranJkVWtwTEY5MEtzUWpvaWYxdUxCSnNs?=
 =?utf-8?B?T1lkakVlRHl4R3BxWDE2ZTZ1bGdSNmVhM005emxodXUyTWlhSXVZYUIrd1Fv?=
 =?utf-8?B?VDQ5V3poNmNCNlh6NnNDblNWUy9UMXAxNTZXWm54SnRVSHRyZWMxbVdpdkFx?=
 =?utf-8?B?V01OVytzMkk0NDdBM3dPTGZaOHBvRU1wbnBPVzV0K01iVVVXcUpoYjVIVUJ2?=
 =?utf-8?B?OTFiaWNMRVBpa0ttZ09YZXNCYWtmMGVjOFNNMGpVaXhFQlprYnE1QU5qQkVk?=
 =?utf-8?B?MnpCTEswQnlkeFRpNUhkY1VkME01d1FySTVKQ2h0U2lkOE95bzZpZDlmNkR4?=
 =?utf-8?B?Ky9ERzEvRUkwQm8vK2JRaHRQekNieWdGNW5YMVZ6Wm1lcWVQV0wwTW90MXgy?=
 =?utf-8?B?SWsrTjk5UmNtZC90WkpGRVpHOHRvOXJpdkhGbEdpTHV5ZnFiaUlxak5jUFB6?=
 =?utf-8?B?VzYvdEZZd2hLci9GUHRqZVQxYlVZaUd4U29KbTY4UHJnUm40b0RDYzB2NkNj?=
 =?utf-8?B?ZDJuSStqY1FRcnhiV29UUXFXd3JTT093dTF4ZHg0dFB1a0pZcS8vYVhMdEFl?=
 =?utf-8?B?SDhkOThmWUliUTBLODFDMlBHTWdWWnFkM3pGTWVBRG9Va3l2UVpkamZtYjAx?=
 =?utf-8?B?cDhHUzZza256YWJ6bk13Tmp4OGdlR2c1UFpPcWU0dUF1REp0TVdGUzJINTBk?=
 =?utf-8?B?TUs2aytKUXFOM2o0SVFuRWtqMWFNZnhwODYzdURNV2R1N2NseTIrdnRzRmky?=
 =?utf-8?B?cmptSW1ibVlhME5Ha3h5VllsejR4cXhoU0ZLMHdRTitCUmNjS3kwelQvdW93?=
 =?utf-8?B?YnlnbWIyUHl5YWRwVkpsZVpxN1J5R3lJN3VTNE1mVjRlWlhVbjB0SDUwRWFH?=
 =?utf-8?B?ZU1MN0pOVVRtZEtwd1M2cm9QOWdrMkUvckJrOG1RUjFkbEtvZHo0eWVVYlNa?=
 =?utf-8?B?cjBjNTBWQktlMTZ2aFVrdUpWWVNVMzlPdkNZdWdZNEZoODNla1ZyNWpLSnow?=
 =?utf-8?B?a0xNRzd3MHlXSUNFTUtSajNkbS9UQUEvanJQcUFIdVJTb3VLNWVqQ3NNOVJk?=
 =?utf-8?B?RXdkZEUwcnlPdVg5M0lyc1o1bjJhSnp0OEZrZ3dUT3A3QjU3dC94L0xWZWk3?=
 =?utf-8?B?T2J1bEVRd3BxWWk0QW9IcFpoa0NjVktqSTh3ZWRQenBXRWpBYWd5WEgyV0M2?=
 =?utf-8?Q?L1tp/BMdDSurMFJZSydsKbQ=3D?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9fb83627-2f4e-424b-447d-08da017cd1a2
X-MS-Exchange-CrossTenant-AuthSource: HK2PR06MB3492.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2022 03:28:03.3022
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XvXagKyyvEocFwCapPIjvZYD4wOAxsu7p9GSbeS05zdJfm73ZEIsUmjugRx3mCjfASM0DRFNHSvF35q/6R0p5A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SG2PR06MB2523
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sorry for my mistake. I forgot to change commit message. I will send 
another patch.

On 2022/3/9 11:22, Guo Zhengkui wrote:
> Fix the array_size.cocci warning in tools/testing/selftests/bpf/
> 
> Use `ARRAY_SIZE(arr)` instead of forms like `sizeof(arr)/sizeof(arr[0])`.
> 
> syscall.c and test_rdonly_maps.c don't contain header files which
> implement ARRAY_SIZE() macro. So I add `#include <linux/kernel.h>`,
> in which ARRAY_SIZE(arr) not only calculates the size of `arr`, but also
> checks that `arr` is really an array (using __must_be_array(arr)).
> 
> Signed-off-by: Guo Zhengkui <guozhengkui@vivo.com>
> ---
>   .../selftests/bpf/prog_tests/cgroup_attach_autodetach.c     | 2 +-
>   .../testing/selftests/bpf/prog_tests/cgroup_attach_multi.c  | 2 +-
>   .../selftests/bpf/prog_tests/cgroup_attach_override.c       | 2 +-
>   tools/testing/selftests/bpf/prog_tests/global_data.c        | 6 +++---
>   tools/testing/selftests/bpf/prog_tests/obj_name.c           | 2 +-
>   tools/testing/selftests/bpf/progs/syscall.c                 | 3 ++-
>   tools/testing/selftests/bpf/progs/test_rdonly_maps.c        | 3 ++-
>   tools/testing/selftests/bpf/test_cgroup_storage.c           | 2 +-
>   tools/testing/selftests/bpf/test_lru_map.c                  | 4 ++--
>   tools/testing/selftests/bpf/test_sock_addr.c                | 6 +++---
>   tools/testing/selftests/bpf/test_sockmap.c                  | 4 ++--
>   11 files changed, 19 insertions(+), 17 deletions(-)
> 
> diff --git a/tools/testing/selftests/bpf/prog_tests/cgroup_attach_autodetach.c b/tools/testing/selftests/bpf/prog_tests/cgroup_attach_autodetach.c
> index 858916d11e2e..9367bd2f0ae1 100644
> --- a/tools/testing/selftests/bpf/prog_tests/cgroup_attach_autodetach.c
> +++ b/tools/testing/selftests/bpf/prog_tests/cgroup_attach_autodetach.c
> @@ -14,7 +14,7 @@ static int prog_load(void)
>   		BPF_MOV64_IMM(BPF_REG_0, 1), /* r0 = 1 */
>   		BPF_EXIT_INSN(),
>   	};
> -	size_t insns_cnt = sizeof(prog) / sizeof(struct bpf_insn);
> +	size_t insns_cnt = ARRAY_SIZE(prog);
>   
>   	return bpf_test_load_program(BPF_PROG_TYPE_CGROUP_SKB,
>   			       prog, insns_cnt, "GPL", 0,
> diff --git a/tools/testing/selftests/bpf/prog_tests/cgroup_attach_multi.c b/tools/testing/selftests/bpf/prog_tests/cgroup_attach_multi.c
> index 38b3c47293da..db0b7bac78d1 100644
> --- a/tools/testing/selftests/bpf/prog_tests/cgroup_attach_multi.c
> +++ b/tools/testing/selftests/bpf/prog_tests/cgroup_attach_multi.c
> @@ -63,7 +63,7 @@ static int prog_load_cnt(int verdict, int val)
>   		BPF_MOV64_IMM(BPF_REG_0, verdict), /* r0 = verdict */
>   		BPF_EXIT_INSN(),
>   	};
> -	size_t insns_cnt = sizeof(prog) / sizeof(struct bpf_insn);
> +	size_t insns_cnt = ARRAY_SIZE(prog);
>   	int ret;
>   
>   	ret = bpf_test_load_program(BPF_PROG_TYPE_CGROUP_SKB,
> diff --git a/tools/testing/selftests/bpf/prog_tests/cgroup_attach_override.c b/tools/testing/selftests/bpf/prog_tests/cgroup_attach_override.c
> index 356547e849e2..9421a5b7f4e1 100644
> --- a/tools/testing/selftests/bpf/prog_tests/cgroup_attach_override.c
> +++ b/tools/testing/selftests/bpf/prog_tests/cgroup_attach_override.c
> @@ -16,7 +16,7 @@ static int prog_load(int verdict)
>   		BPF_MOV64_IMM(BPF_REG_0, verdict), /* r0 = verdict */
>   		BPF_EXIT_INSN(),
>   	};
> -	size_t insns_cnt = sizeof(prog) / sizeof(struct bpf_insn);
> +	size_t insns_cnt = ARRAY_SIZE(prog);
>   
>   	return bpf_test_load_program(BPF_PROG_TYPE_CGROUP_SKB,
>   			       prog, insns_cnt, "GPL", 0,
> diff --git a/tools/testing/selftests/bpf/prog_tests/global_data.c b/tools/testing/selftests/bpf/prog_tests/global_data.c
> index 6fb3d3155c35..027685858925 100644
> --- a/tools/testing/selftests/bpf/prog_tests/global_data.c
> +++ b/tools/testing/selftests/bpf/prog_tests/global_data.c
> @@ -29,7 +29,7 @@ static void test_global_data_number(struct bpf_object *obj, __u32 duration)
>   		{ "relocate .rodata reference", 10, ~0 },
>   	};
>   
> -	for (i = 0; i < sizeof(tests) / sizeof(tests[0]); i++) {
> +	for (i = 0; i < ARRAY_SIZE(tests); i++) {
>   		err = bpf_map_lookup_elem(map_fd, &tests[i].key, &num);
>   		CHECK(err || num != tests[i].num, tests[i].name,
>   		      "err %d result %llx expected %llx\n",
> @@ -58,7 +58,7 @@ static void test_global_data_string(struct bpf_object *obj, __u32 duration)
>   		{ "relocate .bss reference",    4, "\0\0hello" },
>   	};
>   
> -	for (i = 0; i < sizeof(tests) / sizeof(tests[0]); i++) {
> +	for (i = 0; i < ARRAY_SIZE(tests); i++) {
>   		err = bpf_map_lookup_elem(map_fd, &tests[i].key, str);
>   		CHECK(err || memcmp(str, tests[i].str, sizeof(str)),
>   		      tests[i].name, "err %d result \'%s\' expected \'%s\'\n",
> @@ -92,7 +92,7 @@ static void test_global_data_struct(struct bpf_object *obj, __u32 duration)
>   		{ "relocate .data reference",   3, { 41, 0xeeeeefef, 0x2111111111111111ULL, } },
>   	};
>   
> -	for (i = 0; i < sizeof(tests) / sizeof(tests[0]); i++) {
> +	for (i = 0; i < ARRAY_SIZE(tests); i++) {
>   		err = bpf_map_lookup_elem(map_fd, &tests[i].key, &val);
>   		CHECK(err || memcmp(&val, &tests[i].val, sizeof(val)),
>   		      tests[i].name, "err %d result { %u, %u, %llu } expected { %u, %u, %llu }\n",
> diff --git a/tools/testing/selftests/bpf/prog_tests/obj_name.c b/tools/testing/selftests/bpf/prog_tests/obj_name.c
> index 6194b776a28b..7093edca6e08 100644
> --- a/tools/testing/selftests/bpf/prog_tests/obj_name.c
> +++ b/tools/testing/selftests/bpf/prog_tests/obj_name.c
> @@ -20,7 +20,7 @@ void test_obj_name(void)
>   	__u32 duration = 0;
>   	int i;
>   
> -	for (i = 0; i < sizeof(tests) / sizeof(tests[0]); i++) {
> +	for (i = 0; i < ARRAY_SIZE(tests); i++) {
>   		size_t name_len = strlen(tests[i].name) + 1;
>   		union bpf_attr attr;
>   		size_t ncopy;
> diff --git a/tools/testing/selftests/bpf/progs/syscall.c b/tools/testing/selftests/bpf/progs/syscall.c
> index e550f728962d..62e6fa49a4ab 100644
> --- a/tools/testing/selftests/bpf/progs/syscall.c
> +++ b/tools/testing/selftests/bpf/progs/syscall.c
> @@ -6,6 +6,7 @@
>   #include <bpf/bpf_tracing.h>
>   #include <../../../tools/include/linux/filter.h>
>   #include <linux/btf.h>
> +#include <bpf_util.h>
>   
>   char _license[] SEC("license") = "GPL";
>   
> @@ -82,7 +83,7 @@ int bpf_prog(struct args *ctx)
>   	static __u64 value = 34;
>   	static union bpf_attr prog_load_attr = {
>   		.prog_type = BPF_PROG_TYPE_XDP,
> -		.insn_cnt = sizeof(insns) / sizeof(insns[0]),
> +		.insn_cnt = ARRAY_SIZE(insns),
>   	};
>   	int ret;
>   
> diff --git a/tools/testing/selftests/bpf/progs/test_rdonly_maps.c b/tools/testing/selftests/bpf/progs/test_rdonly_maps.c
> index fc8e8a34a3db..a500f2c15970 100644
> --- a/tools/testing/selftests/bpf/progs/test_rdonly_maps.c
> +++ b/tools/testing/selftests/bpf/progs/test_rdonly_maps.c
> @@ -3,6 +3,7 @@
>   
>   #include <linux/ptrace.h>
>   #include <linux/bpf.h>
> +#include <bpf_util.h>
>   #include <bpf/bpf_helpers.h>
>   
>   const struct {
> @@ -64,7 +65,7 @@ int full_loop(struct pt_regs *ctx)
>   {
>   	/* prevent compiler to optimize everything out */
>   	unsigned * volatile p = (void *)&rdonly_values.a;
> -	int i = sizeof(rdonly_values.a) / sizeof(rdonly_values.a[0]);
> +	int i = ARRAY_SIZE(rdonly_values.a);
>   	unsigned iters = 0, sum = 0;
>   
>   	/* validate verifier can allow full loop as well */
> diff --git a/tools/testing/selftests/bpf/test_cgroup_storage.c b/tools/testing/selftests/bpf/test_cgroup_storage.c
> index 5b8314cd77fd..d6a1be4d8020 100644
> --- a/tools/testing/selftests/bpf/test_cgroup_storage.c
> +++ b/tools/testing/selftests/bpf/test_cgroup_storage.c
> @@ -36,7 +36,7 @@ int main(int argc, char **argv)
>   		BPF_MOV64_REG(BPF_REG_0, BPF_REG_1),
>   		BPF_EXIT_INSN(),
>   	};
> -	size_t insns_cnt = sizeof(prog) / sizeof(struct bpf_insn);
> +	size_t insns_cnt = ARRAY_SIZE(prog);
>   	int error = EXIT_FAILURE;
>   	int map_fd, percpu_map_fd, prog_fd, cgroup_fd;
>   	struct bpf_cgroup_storage_key key;
> diff --git a/tools/testing/selftests/bpf/test_lru_map.c b/tools/testing/selftests/bpf/test_lru_map.c
> index 6e6235185a86..563bbe18c172 100644
> --- a/tools/testing/selftests/bpf/test_lru_map.c
> +++ b/tools/testing/selftests/bpf/test_lru_map.c
> @@ -878,11 +878,11 @@ int main(int argc, char **argv)
>   	assert(nr_cpus != -1);
>   	printf("nr_cpus:%d\n\n", nr_cpus);
>   
> -	for (f = 0; f < sizeof(map_flags) / sizeof(*map_flags); f++) {
> +	for (f = 0; f < ARRAY_SIZE(map_flags); f++) {
>   		unsigned int tgt_free = (map_flags[f] & BPF_F_NO_COMMON_LRU) ?
>   			PERCPU_FREE_TARGET : LOCAL_FREE_TARGET;
>   
> -		for (t = 0; t < sizeof(map_types) / sizeof(*map_types); t++) {
> +		for (t = 0; t < ARRAY_SIZE(map_types); t++) {
>   			test_lru_sanity0(map_types[t], map_flags[f]);
>   			test_lru_sanity1(map_types[t], map_flags[f], tgt_free);
>   			test_lru_sanity2(map_types[t], map_flags[f], tgt_free);
> diff --git a/tools/testing/selftests/bpf/test_sock_addr.c b/tools/testing/selftests/bpf/test_sock_addr.c
> index f0c8d05ba6d1..f3d5d7ac6505 100644
> --- a/tools/testing/selftests/bpf/test_sock_addr.c
> +++ b/tools/testing/selftests/bpf/test_sock_addr.c
> @@ -723,7 +723,7 @@ static int xmsg_ret_only_prog_load(const struct sock_addr_test *test,
>   		BPF_MOV64_IMM(BPF_REG_0, rc),
>   		BPF_EXIT_INSN(),
>   	};
> -	return load_insns(test, insns, sizeof(insns) / sizeof(struct bpf_insn));
> +	return load_insns(test, insns, ARRAY_SIZE(insns));
>   }
>   
>   static int sendmsg_allow_prog_load(const struct sock_addr_test *test)
> @@ -795,7 +795,7 @@ static int sendmsg4_rw_asm_prog_load(const struct sock_addr_test *test)
>   		BPF_EXIT_INSN(),
>   	};
>   
> -	return load_insns(test, insns, sizeof(insns) / sizeof(struct bpf_insn));
> +	return load_insns(test, insns, ARRAY_SIZE(insns));
>   }
>   
>   static int recvmsg4_rw_c_prog_load(const struct sock_addr_test *test)
> @@ -858,7 +858,7 @@ static int sendmsg6_rw_dst_asm_prog_load(const struct sock_addr_test *test,
>   		BPF_EXIT_INSN(),
>   	};
>   
> -	return load_insns(test, insns, sizeof(insns) / sizeof(struct bpf_insn));
> +	return load_insns(test, insns, ARRAY_SIZE(insns));
>   }
>   
>   static int sendmsg6_rw_asm_prog_load(const struct sock_addr_test *test)
> diff --git a/tools/testing/selftests/bpf/test_sockmap.c b/tools/testing/selftests/bpf/test_sockmap.c
> index 1ba7e7346afb..dfb4f5c0fcb9 100644
> --- a/tools/testing/selftests/bpf/test_sockmap.c
> +++ b/tools/testing/selftests/bpf/test_sockmap.c
> @@ -1786,7 +1786,7 @@ static int populate_progs(char *bpf_file)
>   		i++;
>   	}
>   
> -	for (i = 0; i < sizeof(map_fd)/sizeof(int); i++) {
> +	for (i = 0; i < ARRAY_SIZE(map_fd); i++) {
>   		maps[i] = bpf_object__find_map_by_name(obj, map_names[i]);
>   		map_fd[i] = bpf_map__fd(maps[i]);
>   		if (map_fd[i] < 0) {
> @@ -1867,7 +1867,7 @@ static int __test_selftests(int cg_fd, struct sockmap_options *opt)
>   	}
>   
>   	/* Tests basic commands and APIs */
> -	for (i = 0; i < sizeof(test)/sizeof(struct _test); i++) {
> +	for (i = 0; i < ARRAY_SIZE(test); i++) {
>   		struct _test t = test[i];
>   
>   		if (check_whitelist(&t, opt) != 0)
