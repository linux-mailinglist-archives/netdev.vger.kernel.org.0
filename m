Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1E933D9BF4
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 04:57:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233500AbhG2C5E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 22:57:04 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:56734 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233297AbhG2C5D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Jul 2021 22:57:03 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16T2u6dH010668;
        Wed, 28 Jul 2021 19:56:45 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=WK6rV5hi3Km/FyI/EdNdqqzpmDHYQubZKDhZTc1R6tg=;
 b=XUrgfDiL55sg0rrRFdrRZFFSKKhJVdIAXGuEI/0f6jgAit7hkvz0r37kyaFAHXGyANNV
 cCG3gyo8v6K1RJJO3CvOAmVysY1q/Eeth5zcaR2e86CAtukG+je+FiFJblaMgMVVlqhB
 5UeFRyO96AOGrAIWEe/wn0MeX0MPG/iTXU8= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3a37bjctpb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 28 Jul 2021 19:56:45 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.175) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 28 Jul 2021 19:56:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MJL5RXxpFpckAn5n60jICyIhLJjGqbfl6BO6vaFIBVUE9TKxj68vMCwc2/4WmqBSu97nu6wKsIUp92A4KtkP0jE/WI4QB+2Zkh1cM87Ovmf52fm/QbCnR1Zksehs4DYInQXUUorZedp93UKvII5dOFVtvT1IZ00ccvFWclT0F09BpLS1GrBDahNAvvI6wkOsClfxYJuG53B/YB3ZhSX8TqLBQEq11WPGpPF6jvFYVTegNdWXjGMIcUiEL9VsuRIvCILCrg005QxNDr24625qByHiyZ9dnizbwdwVr5wMnmgtGNwQ+FJ2k2fdrbqHSgHILLsQ5k+/2kpdZlhQkA4Bpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WK6rV5hi3Km/FyI/EdNdqqzpmDHYQubZKDhZTc1R6tg=;
 b=YfL+ZGLrDSb5gZtSHajid9Cb/yao2Tpd/J4Z4t9nQG1LBFZR8w+46Lk4+PKGCmt3AG6bv1dPYlG6xe26wNk+djMytW2itZ+V8jh1NSM8t0g41PTkO8FVZSNXz8C0LvriRWEzo4dLjC1tFkH8ZC23/s8ezIIpPWBKvDfbq6KsaB9V1fR0ykf7tWJl5rbLQB7pSKtrltba94PuzYmwtpsGu9iNcFb8l5ukJ0L390OaxNVamKYJ7jBYl7LuOv+4X7lSIis6vrEvvNb57Y5ZQOIuP7ewJSyjhaO3HlW30cKk8khqPsMvFDDdgVExjlrjKg5xA4u6Son+ibfLaj5LYJQWYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=fb.com;
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SN6PR15MB2336.namprd15.prod.outlook.com (2603:10b6:805:26::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.17; Thu, 29 Jul
 2021 02:56:43 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::c143:fac2:85b4:14cb]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::c143:fac2:85b4:14cb%7]) with mapi id 15.20.4373.021; Thu, 29 Jul 2021
 02:56:43 +0000
Subject: Re: [PATCH 14/14] bpf/tests: Add tail call test suite
To:     Johan Almbladh <johan.almbladh@anyfinetworks.com>,
        <ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>
CC:     <kafai@fb.com>, <songliubraving@fb.com>,
        <john.fastabend@gmail.com>, <kpsingh@kernel.org>,
        <Tony.Ambardar@gmail.com>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, kernel test robot <lkp@intel.com>
References: <20210728170502.351010-1-johan.almbladh@anyfinetworks.com>
 <20210728170502.351010-15-johan.almbladh@anyfinetworks.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <1483fad6-709a-50f5-4b8e-358ad2848dfe@fb.com>
Date:   Wed, 28 Jul 2021 19:56:38 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
In-Reply-To: <20210728170502.351010-15-johan.almbladh@anyfinetworks.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CO2PR04CA0160.namprd04.prod.outlook.com
 (2603:10b6:104:4::14) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21c8::1398] (2620:10d:c090:400::5:8298) by CO2PR04CA0160.namprd04.prod.outlook.com (2603:10b6:104:4::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.18 via Frontend Transport; Thu, 29 Jul 2021 02:56:41 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7aba66a3-478b-49bf-5fe5-08d9523c7ebd
X-MS-TrafficTypeDiagnostic: SN6PR15MB2336:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR15MB2336763F04F65C1D1A82950BD3EB9@SN6PR15MB2336.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:3826;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6mukuChO+5MDL9kKjIlvUMzmYFruKMb/SDvkgnt1GkXC5Riz6E1E43qgjb+XoMeiNCED+LCRUvy9F4efTdENjjGu3U6roEFYGmojCCzKVBjyqdgsOvEyO//pts4XiU1HBRMehkqpn21w/7KhvWTKp+Z7QfRtg8+zGUnxWUqYBiMPASQw7KtiLUogd+JeWxSJ7zATBxvb9zn1sJ2syJSAMiYm+1PQjqGA5c3vp8SKFY/i4IYAYZaNPjSQLxhogVsNgbSdpZJ/0HjBXgGjTJc1zQdRUoTI4pn5Vt8xVjc8Wi88A8RPEYEjZKNobGXnQA/4sJmd1EI1a+R7qOg9XPmIIILute/X3qMMNQKqg7OUyJ1jTnZd7EuZlAhrXn0thVY8bdxCS01kQmt+OsBkDdxuQXm5d0Ly7z+ik+ceuIsv+8RhZUAsCIPaEett5AhSDjPBgpHvh5zDau0HTskdk9S3b2HQwhpMW7AG0lm37rinARso9eomIynO4tLMuS4bNtIfuUyRqXiC3Ucu5WZXUZ2gSHWdI194RnUhfOElZ/GqPG6jzudeawrtEn1oXHAzqD7R3JJQzGDlPfuuWbDQj/Icd3M9nebCiJEpD5acZ70AZBJ87IhyoduL99JcY95kk8XhEZUU1lKX9iaZeMMG36EsfYz2fk1axI2raGVlugGGSVWSCtRSulDKo+/CKE7lRJPan10QcVqe7pOTr0Lx728CYi0f0dOetIIpHqMJMa1gBxQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(346002)(39860400002)(366004)(396003)(2906002)(31696002)(316002)(8676002)(8936002)(186003)(2616005)(52116002)(7416002)(6486002)(53546011)(66556008)(66946007)(38100700002)(31686004)(5660300002)(66476007)(36756003)(86362001)(478600001)(4326008)(6666004)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ekZlRGZsTFkwdWRwc2xjUFJKekx6ZkpESXJGL0NrbTdzMjJRb1dqd3QyTU85?=
 =?utf-8?B?UktERGI1Z3FEb2VSRCtrMGNNc0dXSEdxaWhqd3lLemVYUS9wTGJ5elJ4UEpi?=
 =?utf-8?B?Z1FlZzNzclFuWEh4cFhtSWM2TjQ2NnZwRkFvVUVOdm1GZmhxOHEyNjdhUFY4?=
 =?utf-8?B?SXdLRnFEQmg0REZ6UVpoMHBRRG9BUjlTaWZ5UmszaGpaYlRIVzJtd0ZDSDRz?=
 =?utf-8?B?dWxWQjVJYlFTdGR4eTNpVk1CYS9uVk1welZDRGJiQ3ZhWk05NWo1VyszdTg1?=
 =?utf-8?B?ZXV4cG9NNkNMZHgreHBScFJmc0UzOHZWSUwxbmNiTktGcVdzUUUrc2FXOUU2?=
 =?utf-8?B?SzVkb2FyWHNUalphQjhHQXZ1L250NzJiN25EMDFJWFcyUXNFdks3bjFodWdM?=
 =?utf-8?B?bWNTVnYrTmt1ZDZacHMzL042a3pmU3Mxcy9pd1pkUDZLb2FtRDlSclhUbEt0?=
 =?utf-8?B?S1hyQ1E4SDl5UGVUdmhBdmNNblVsdUxFNG5OOHRiaWQ2QjZUZ2ovUHY2Kzdi?=
 =?utf-8?B?V0RLcmZEaXZEekZUd0lqSFlqZ2l3M3dJY1Q3VVBxa3AwQVI1N1dHQjRiM2ls?=
 =?utf-8?B?bG11TXdJZmM2VFdkNllEQ1l1dERnK0ZOU2dFMlAvektoUUJLOGhBRGJ1eFlD?=
 =?utf-8?B?eHpRVUNLcDVsMFFGRDIvTWtEQTBNeGV6M0NLZjYzN1ZFNC80NzVFMStSc0Jt?=
 =?utf-8?B?Z1loWnkyU2luUWZtZ0gyTE9HeEhpTCtJM2hITWZhRWNqRm0yQU5zVEdqamQy?=
 =?utf-8?B?cTErRkllczB1ZndjMUNFdkdpSFhOTTBsWVBhaUVWb3VucldTaVg5QXNNTHJx?=
 =?utf-8?B?ckNJKzlsdElkKzlnTGVyeHNqOGJkSm1RTlRSWUNjSXlLbGcvR2l0c3JNazdr?=
 =?utf-8?B?VXU5bDE4dm1yYVljMHdOdXFiWmRQb29ocnI1cU9zbTZBazVMUHhlL1JXUWY3?=
 =?utf-8?B?V0ZZcmNhSFhoYmxXMGVqblpidVBmeUdROGhHYmFWQm1mQzRtNG5oMHdqSXFZ?=
 =?utf-8?B?MHVhU3ViVjdpMWNCbmV4a0FTS0ZnR2VMUXk4Tk9sTkF3S1FlaXFDU1ZjZS8r?=
 =?utf-8?B?VWFiZ2s2bkpGV2E1WTF6SzNURmkyU1RyM0hISktDUXd0SXNUdHA4d0RGa0w5?=
 =?utf-8?B?b25BQjJVeEdIRzNmWmNVVEdFaVZVZkxLNmVoQnhrWE5Gckxvd1JZZ0VDUExQ?=
 =?utf-8?B?MXpFTWpJeFgzVC83TEhGOVRrbW9lekJFR2JHZ3R6L0cwZWIrd1FvOUcyNkY5?=
 =?utf-8?B?ZWpOT0VJVFJtSzloTXFacGlJK1owQmoxVk1QdmVuN3E2Wm50N3RIWklEWXgx?=
 =?utf-8?B?d0JwcXR4ZGoxRkdBc1dGV2xCeDNhRDIzRFN3RXhSbVlpOGlyQ0J4VGdubmlN?=
 =?utf-8?B?OCtEZ0VWYkNaTXpDaDVSUVNrUlRSamIyYUsxNlYwQ2VPOVEzODgrZUhScTQr?=
 =?utf-8?B?Z3VuUmRQcEFncjJIdUxhNWFGZm8zSlBKb0JhT2ZqblJiZThOYk5wTlA0YkR3?=
 =?utf-8?B?MnRNQWUycklEaVBBdW0yRlM3dW5vSDloZWpnZEVhelFUbDRTNWtqa2VBQlBD?=
 =?utf-8?B?emNCWlBNVDVsbmZLMUxXZkNodTRTcDZtVjFzQmVtd1ViMjFFbmRZQ3gvenBR?=
 =?utf-8?B?dVkwdzJEbDJjckcxRnU1TXJtWkJRMm8zbGlsYmYydjRzMktDUlk2cFpYWFI1?=
 =?utf-8?B?TnZ5ODdPcms0RmNRc0xvLzVxaXRqN1pTS0ZPZ2pwMm5DMW1VQkMvRUJreGRE?=
 =?utf-8?B?aHhmTDluVm40RmRGN0pRR0JYVXdjN0xYVXVUT0s1NkEvTlY2dUhjRWh4VlNG?=
 =?utf-8?Q?Qzn1rkblhy9ZLa/9MqW4PEIExyvhpSt7rcehw=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7aba66a3-478b-49bf-5fe5-08d9523c7ebd
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2021 02:56:42.9050
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3S0Waz+XH7PAR1pnL1xkAzSYcGaLc+Zw8REFsfQMV66BrFtajPbTaRWNcqsq+IcL
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR15MB2336
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: 0Gt4KfPoQtOXHxXbEzAhM8P-x6q7IFf9
X-Proofpoint-ORIG-GUID: 0Gt4KfPoQtOXHxXbEzAhM8P-x6q7IFf9
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-29_03:2021-07-27,2021-07-29 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0 bulkscore=0
 priorityscore=1501 lowpriorityscore=0 suspectscore=0 adultscore=0
 mlxscore=0 mlxlogscore=999 impostorscore=0 clxscore=1011 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2107290015
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/28/21 10:05 AM, Johan Almbladh wrote:
> While BPF_CALL instructions were tested implicitly by the cBPF-to-eBPF
> translation, there has not been any tests for BPF_TAIL_CALL instructions.
> The new test suite includes tests for tail call chaining, tail call count
> tracking and error paths. It is mainly intended for JIT development and
> testing.
> 
> Signed-off-by: Johan Almbladh <johan.almbladh@anyfinetworks.com>
> Reported-by: kernel test robot <lkp@intel.com>

The above Reported-by tag can be removed. This patch itself is not
about fixing an issue reported by kernel test robot...

The patch looks good to me except a few minor comments below.

Acked-by: Yonghong Song <yhs@fb.com>

> ---
>   lib/test_bpf.c | 249 +++++++++++++++++++++++++++++++++++++++++++++++++
>   1 file changed, 249 insertions(+)
> 
> diff --git a/lib/test_bpf.c b/lib/test_bpf.c
> index af5758151d0a..222d454b2ed4 100644
> --- a/lib/test_bpf.c
> +++ b/lib/test_bpf.c
> @@ -8981,8 +8981,249 @@ static __init int test_bpf(void)
>   	return err_cnt ? -EINVAL : 0;
>   }
>   
> +struct tail_call_test {
> +	const char *descr;
> +	struct bpf_insn insns[MAX_INSNS];
> +	int result;
> +	int stack_depth;
> +};
> +
> +/*
> + * Magic marker used in test snippets for tail calls below.
> + * BPF_LD/MOV to R2 and R2 with this immediate value is replaced
> + * with the proper values by the test runner.
> + */
> +#define TAIL_CALL_MARKER 0x7a11ca11
> +
> +/* Special offset to indicate a NULL call target */
> +#define TAIL_CALL_NULL 0x7fff
> +
> +#define TAIL_CALL(offset)			       \
> +	BPF_LD_IMM64(R2, TAIL_CALL_MARKER),	       \
> +	BPF_RAW_INSN(BPF_ALU | BPF_MOV | BPF_K, R3, 0, \
> +		     offset, TAIL_CALL_MARKER),	       \
> +	BPF_JMP_IMM(BPF_TAIL_CALL, 0, 0, 0)
> +
> +/*
> + * Tail call tests. Each test case may call any other test in the table,
> + * including itself, specified as a relative index offset from the calling
> + * test. The index TAIL_CALL_NULL can be used to specify a NULL target
> + * function to test the JIT error path.
> + */
> +static struct tail_call_test tail_call_tests[] = {
> +	{
> +		"Tail call leaf",
> +		.insns = {
> +			BPF_ALU64_REG(BPF_MOV, R0, R1),
> +			BPF_ALU64_IMM(BPF_ADD, R0, 1),
> +			BPF_EXIT_INSN(),
> +		},
> +		.result = 1,
> +	},
> +	{
> +		"Tail call 2",
> +		.insns = {
> +			BPF_ALU64_IMM(BPF_ADD, R1, 2),
> +			TAIL_CALL(-1),
> +			BPF_ALU64_IMM(BPF_MOV, R0, -1),
> +			BPF_EXIT_INSN(),
> +		},
> +		.result = 3,
> +	},
> +	{
> +		"Tail call 3",
> +		.insns = {
> +			BPF_ALU64_IMM(BPF_ADD, R1, 3),
> +			TAIL_CALL(-1),
> +			BPF_ALU64_IMM(BPF_MOV, R0, -1),
> +			BPF_EXIT_INSN(),
> +		},
> +		.result = 6,
> +	},
> +	{
> +		"Tail call 4",
> +		.insns = {
> +			BPF_ALU64_IMM(BPF_ADD, R1, 4),
> +			TAIL_CALL(-1),
> +			BPF_ALU64_IMM(BPF_MOV, R0, -1),
> +			BPF_EXIT_INSN(),
> +		},
> +		.result = 10,
> +	},
> +	{
> +		"Tail call error path, max count reached",
> +		.insns = {
> +			BPF_ALU64_IMM(BPF_ADD, R1, 1),
> +			BPF_ALU64_REG(BPF_MOV, R0, R1),
> +			TAIL_CALL(0),
> +			BPF_EXIT_INSN(),
> +		},
> +		.result = MAX_TAIL_CALL_CNT + 1,
> +	},
> +	{
> +		"Tail call error path, NULL target",
> +		.insns = {
> +			BPF_ALU64_IMM(BPF_MOV, R0, -1),
> +			TAIL_CALL(TAIL_CALL_NULL),
> +			BPF_ALU64_IMM(BPF_MOV, R0, 1),
> +			BPF_EXIT_INSN(),
> +		},
> +		.result = 1,
> +	},
> +	{
> +		/* Must be the last test */
> +		"Tail call error path, index out of range",
> +		.insns = {
> +			BPF_ALU64_IMM(BPF_MOV, R0, -1),
> +			TAIL_CALL(1),    /* Index out of range */
> +			BPF_ALU64_IMM(BPF_MOV, R0, 1),
> +			BPF_EXIT_INSN(),
> +		},
> +		.result = 1,
> +	},
> +};
> +
> +static void __init destroy_tail_call_tests(struct bpf_array *progs)
> +{
> +	int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(tail_call_tests); i++)
> +		if (progs->ptrs[i])
> +			bpf_prog_free(progs->ptrs[i]);
> +	kfree(progs);
> +}
> +
> +static __init int prepare_tail_call_tests(struct bpf_array **pprogs)
> +{
> +	struct bpf_array *progs;
> +	int ntests = ARRAY_SIZE(tail_call_tests);
> +	int which, err;

reverse christmas tree?

> +
> +	/* Allocate the table of programs to be used for tall calls */
> +	progs = kzalloc(sizeof(*progs) + (ntests + 1) * sizeof(progs->ptrs[0]),
> +			GFP_KERNEL);
> +	if (!progs)
> +		goto out_nomem;
> +
> +	/* Create all eBPF programs and populate the table */
> +	for (which = 0; which < ntests; which++) {
> +		struct tail_call_test *test = &tail_call_tests[which];
> +		struct bpf_prog *fp;
> +		int len, i;
> +
> +		/* Compute the number of program instructions */
> +		for (len = 0; len < MAX_INSNS; len++) {
> +			struct bpf_insn *insn = &test->insns[len];
> +
> +			if (len < MAX_INSNS - 1 &&
> +			    insn->code == (BPF_LD | BPF_DW | BPF_IMM))
> +				len++;
> +			if (insn->code == 0)
> +				break;
> +		}
> +
> +		/* Allocate and initialize the program */
> +		fp = bpf_prog_alloc(bpf_prog_size(len), 0);
> +		if (!fp)
> +			goto out_nomem;
> +
> +		fp->len = len;
> +		fp->type = BPF_PROG_TYPE_SOCKET_FILTER;
> +		fp->aux->stack_depth = test->stack_depth;
> +		memcpy(fp->insnsi, test->insns, len * sizeof(struct bpf_insn));
> +
> +		/* Relocate runtime tail call offsets and addresses */
> +		for (i = 0; i < len; i++) {
> +			struct bpf_insn *insn = &fp->insnsi[i];
> +			int target;
> +
> +			if (insn->imm != TAIL_CALL_MARKER)
> +				continue;
> +
> +			switch (insn->code) {
> +			case BPF_LD | BPF_DW | BPF_IMM:
> +				if (insn->dst_reg == R2) {

Looks like the above condition is not needed. It is always true.

> +					insn[0].imm = (u32)(long)progs;
> +					insn[1].imm = ((u64)(long)progs) >> 32;
> +				}
> +				break;
> +
> +			case BPF_ALU | BPF_MOV | BPF_K:
> +			case BPF_ALU64 | BPF_MOV | BPF_K:

case BPF_ALU64 | BPF_MOV | BPF_K is not needed.

> +				if (insn->off == TAIL_CALL_NULL)
> +					target = ntests;
> +				else
> +					target = which + insn->off;
> +				if (insn->dst_reg == R3)

the same here, insn->dst_reg == R3 is not needed. It is always true.

I suggest to set insn->off = 0. Otherwise, it is an illegal insn.
We won't issue here because we didn't invoke verifier. It is still
good to make the insn legel.

> +					insn->imm = target;



> +				break;
> +			}
> +		}
> +
> +		fp = bpf_prog_select_runtime(fp, &err);
> +		if (err)
> +			goto out_err;
> +
> +		progs->ptrs[which] = fp;
> +	}
> +
> +	/* The last entry contains a NULL program pointer */
> +	progs->map.max_entries = ntests + 1;
> +	*pprogs = progs;
> +	return 0;
> +
> +out_nomem:
> +	err = -ENOMEM;
> +
> +out_err:
> +	if (progs)
> +		destroy_tail_call_tests(progs);
> +	return err;
> +}
> +
[...]
