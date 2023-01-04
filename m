Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FBBD65DC12
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 19:26:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239785AbjADS0o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 13:26:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239662AbjADS0T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 13:26:19 -0500
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A93C2B7D7;
        Wed,  4 Jan 2023 10:26:18 -0800 (PST)
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 304CefFh016254;
        Wed, 4 Jan 2023 10:25:48 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=s2048-2021-q4;
 bh=d5yaOPaLJUUxGB1LxJGoqQ+JazPX8IGAKCcVLyCkFAg=;
 b=VdmE5JachLOSB/d6VzK5Djf76cgN1PhUMrSxUMyTlyrhkud+CmKpZqxD0nv61jNEDvxH
 7xpaEj0cc6OIXSeuaZb6ATLrPzeQAqwA4j7KvnsEhJIf4qmDE0i/pM588BbEqF9NaXVD
 jY+bLBozuYKzZOY6b/wnokrUXXe336IUTTjLeMmc/ipRsZnZUN0Bbofk1ldgyBUEbTsu
 3Han/I75lj2Bf64oVQE5dARVP9qOuWBELQl1Q2qWzr+DbBXW7VJonUL4MwTesCHFUBtk
 IvW5tPXoEjx3GnT9hDSp2+/p6BXshHXMQ2LRjcw/l02SBd5IHpB77EZr1LVK1M2qu6nX qA== 
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2040.outbound.protection.outlook.com [104.47.73.40])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3mvkt8ju5v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 04 Jan 2023 10:25:47 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZcMPpUqkZ3KGMVrwwtCwf8LY+rwqtK0kyFzMay2jFJAyM+ekumi7R+/OQJHsdxUR9QUEuLMsWixQRbg8cuDtIBoT+9EdRsM28/If/kQzq0tCSHYtT8850bJyz8ZeSVDFnhJ/C0ektsXs2UNZI97i+6WnalD0lDDD+VUXqFYVjyxrGNXgRbFSiNAQVyT0S3WgxxV4kcfRjkLDV1yiqyOdD/vnHeRIrAJGiCVeuN4h/kql1aROrznlfGmN3W+8PTdc6Wo1S3kBvjDsYLLxFEPR8pXGOzyitX8I0FrvCOaP/DLRHMd/sqd2vAxBsa9N9s0TK4aHwxypi0xiOfcYIw7/XQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=d5yaOPaLJUUxGB1LxJGoqQ+JazPX8IGAKCcVLyCkFAg=;
 b=IQf1o58jWtnu8BkubI70Kzk15Ez67GUyYjQECNNR9fC2EEILUPxu6HTu0+8kH2R/7qBz96IwyMtu7k0G1l4JDbL/bY8xzI/dISMDbMvf6f3k0pKSS5P6e79gulQGj243V0iTX8t3Db2rfRnlvFsyGnmdbxa9XFyQi13LIhmJGwXQCudfVLMT0BalO7+N9pd7skvSGT5yP9/LoPikSyX1fvNhNz88mLXYTRqUrqBQ4cABBbGejRzV6ug04H3YUxm6osANanZ+bQh9/JXranQuSm9ejwFeaMJXbPOo70jcr+ZjazdSuneeb5g+Dj67o8FfJJbRxjmPKwaVPxqMJZkmGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by BN7PR15MB2482.namprd15.prod.outlook.com (2603:10b6:406:82::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.18; Wed, 4 Jan
 2023 18:25:38 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::3cc9:4d23:d516:59f0]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::3cc9:4d23:d516:59f0%4]) with mapi id 15.20.5944.019; Wed, 4 Jan 2023
 18:25:37 +0000
Message-ID: <ba11a68a-6099-0e0e-6531-e70e64429b7e@meta.com>
Date:   Wed, 4 Jan 2023 10:24:07 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.1
Subject: Re: [PATCH bpf-next] bpf, x86: Simplify the parsing logic of
 structure parameters
Content-Language: en-US
To:     Pu Lehui <pulehui@huaweicloud.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        Pu Lehui <pulehui@huawei.com>
References: <20230103013158.1945869-1-pulehui@huaweicloud.com>
From:   Yonghong Song <yhs@meta.com>
In-Reply-To: <20230103013158.1945869-1-pulehui@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0032.namprd03.prod.outlook.com
 (2603:10b6:a03:33e::7) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR1501MB2064:EE_|BN7PR15MB2482:EE_
X-MS-Office365-Filtering-Correlation-Id: fc6258e8-3b51-4694-e413-08daee8113c1
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7M8vIOrWIBSKJypybQrJttz4qTtvMbZe3JYCI8DJoWziGJ/T8NTY63JZ7ycwXVJLor36aY0vIg479zZWVRkM6w1uSiqzMcKkLZzD5xKcPIdRXWg0Cvq2q313tRBGJiTmJFk/VqQ7Yv3is5fRHMXEBSRiVPRbdxu7xHAnsVilNiClwCxRc293JbG4hYnvI4h26IZwO0jvW8hIUBVqBw0v+JP/pY68WKXwfZIJuYunKfSVv+9otfgPRnxgy2sUE6/xyogMRz+m9y34jjdHlgx1H6E4zFuIk+B82aLi6h9TaofS/z7aBlPSi95ngrSvpAI4iqbAppuisSUNH5ZrusHi4ndjaCVUuEYll/3W880grwBxJpwt/LLy+ncQKjnJ8XUzF9eHj5sFRKFGWsmPd4Jk2s3rQ7k8BhVwh8g1Lm3nzMTCFCDZP8vtHHY0pohaXMIuZKtTZQc8Bb4Nspc/jyOhhUUp7sZNP9B6QcQ2L4F32LThweeC+sXZeea52lnR2wXRV70m9LVleIME4KQLY2xwq1xMyUv9Z65rkFUXKSKN7Enc6Hfh01vpruLRh+RAZqJ5ExPxbjelI9YsMXqnm4ahCPNnferP85YPCrGMUZmZ8xZGWUG4WRu0nmmsAL8C6/lOfe0TkHof2sNxfrOoWBVsnBMNkM2sePoufpuf6jHOxdF4Y8+VR0bzorj6PIvoMZWup4FlRhlIReQ96QDWBTsCN8GGWZy2XF2H0F4fVl39TLk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(39860400002)(136003)(346002)(366004)(396003)(451199015)(6666004)(6506007)(53546011)(478600001)(83380400001)(6486002)(36756003)(86362001)(31696002)(38100700002)(6512007)(186003)(2616005)(4326008)(66476007)(8936002)(66946007)(66556008)(5660300002)(7416002)(8676002)(41300700001)(31686004)(2906002)(316002)(54906003)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MGJ5Tmd3cll3TENrT0FydWZOOERvckV6c0l0b2t4UjEzMkVNZy9QaVMrdmxZ?=
 =?utf-8?B?WngvSkRTYzU3bzFZL3pUT0JSSnBSblRTWm9rMEpIckxSYmZEZGEwTzliZGtB?=
 =?utf-8?B?MWFhbWZFMjJtUlorRlp0N0JmU3lkVTJYeWhFdmZCbnJFZ2dRR0FMQmx3aDlr?=
 =?utf-8?B?dXNvdkJlUDkrVlIxakpyMENMSXJFYmlLYzBGOVFMVjZLdGdMSlJWcUx3QjEz?=
 =?utf-8?B?eFlCMHBMNXhTaEhxeWcvZ09jZnZhcW5aTEpZR1gxcmRHY2E3OVN0am5IL0tN?=
 =?utf-8?B?SUs2aDVpeXlYVUhrZ0dvWXNhWGFNbmw5by82eU5SUDUvS1hkb0VnOVA5eWl5?=
 =?utf-8?B?aTU2Mm9MQ1JIUnNTbk53NUxyOFBmQUcxc2ptMUpodUZ6aHNSVXlqVFQ2OHV1?=
 =?utf-8?B?ZmlpUkxxOW5IZU9BUTBib3dlR3NpcGxNN3l4S0d0UkY5eEpKYy9KYVVJek4z?=
 =?utf-8?B?czByYTVldVBjTHBwSm5wSk1na2pNemhuVEp6RFAvWVg1UjFZWENGL2t2UTNG?=
 =?utf-8?B?aVFSb1dYZys1Y1p0ZlcrRm9rc3F4T0dXTDY4WFNDazVMcTlsVWNsQnh4b2ww?=
 =?utf-8?B?amNVamVzWjV2S0IvQXVXZjZXckdlOTRXVnlvTkJvdExVejkzRU9oaFdXb1h2?=
 =?utf-8?B?RXhkNlhCY3dGbUJnWVgzMmdNUHFCS25vRVJGZERwNkUwM25pbFFEcXNSTGFH?=
 =?utf-8?B?cUhOc2pmc1l2VStBUms1eTd0TWt2enZYU21xbnZEMXRwOEI1VTNzZnZBQ2g0?=
 =?utf-8?B?Mk13SEtheExwVC9VS1NpRkV3SHpDOVB6bEFjUWtjSU1tUVZhT1FqTEZIVjNo?=
 =?utf-8?B?UW1PRDdpSmZhZWFwMVlQQk9MQXkvSXgrRnU1NlNvQ05ucVdjUU9DZEVSSFdt?=
 =?utf-8?B?MXYvdXVmSEJuaHFYSHJxcjdyRWlOYnNWQnB0WUZaMWE2SnBrU2dmQy9QVDRl?=
 =?utf-8?B?Wlc4c1M4VXlnMHVBVUFsWjV3Sm9FL2tRMDRGdjBLZWlZd0h2VkVFekl1bGdn?=
 =?utf-8?B?MUg5L244S2ozV2Z0M2NFTldCbVpuYnNhUW9FemhwUjVScG9KYkd4dHhsbW5O?=
 =?utf-8?B?L2s0OHh2Y04yVjh5aEFYVnVubUhzd2Rpai9HZzNmaFlVaDlEeFRpcGxJRmM4?=
 =?utf-8?B?blc4ZjNNWC9FUlQ3UFdCQ1E0VzRnWmJ1cjI1ZnJZdFRNL2N2b2tSWUs3cnVJ?=
 =?utf-8?B?TjRtL09RYWpXTFJHWEw0V0VtM3NtR0ljMTBXM0dHbFU0NUVDb2UrZklIRFVy?=
 =?utf-8?B?cTJVdWNDbXpzemlyT1h0YndHWlA2L1lKWEppTkExaUpDKzQ3a2pNaTBlOEdy?=
 =?utf-8?B?MXM4N2xIMzJhWlJmSXZOSUtUUjkwNlhLN2FtWVNjZXNjU2pxamp3K0FTRDIr?=
 =?utf-8?B?V3IrQUxRVHJ2djk5djdHQy80a0lBd0hGVStqd1FHeUpQTm1BVW1oMEVhSW83?=
 =?utf-8?B?T21PVDk5T3BHVHZ4azJZOVJQc2hLZ2hMYVVKeEQ3eXhJY1FicHBHQjN6VGFT?=
 =?utf-8?B?T3dwQjI3OENEc0I1cDR3Yk94RURYd2UyS1VsRmpCQ3U0SEF4SFZuc1NaZXo5?=
 =?utf-8?B?dGN0MGNOQ1c5UHppNThaSzNzL1lUaTYreUVGbUhudUY5ZVlrRXZ6c0RKdkhr?=
 =?utf-8?B?NjFobndPUkFSdldZTG5FbXBnYU1hVW1HSGYveU9nN0JoaUJrTHNET2dkdWhJ?=
 =?utf-8?B?KzRNWmtXM0NsMitIVmozWUw2cVErRG92UW1RN3A2L0hZeVZjOVZRbzNuMEcy?=
 =?utf-8?B?UjUyWTc4aGpzSC9NWTJ5ZkhGNWc0STVyazJPQWEzQmZSQjF5VC9wcHRBVTh2?=
 =?utf-8?B?LzlEak9WdFdOUEhDTnlyTFBXekgwTy9mM01kazc2eUNKc2UxYytITE5KNFIw?=
 =?utf-8?B?aVd5dmVORXFvek5YMHpSejRxelFZS1ZheVlFZHdrS0I1QldUQWh4V1o2cWdR?=
 =?utf-8?B?MnA4R1htczZiVzZXRVNZajdJc3g3WnUrL3pMd1RWRi9UYnJYazNHdEQ4cDZm?=
 =?utf-8?B?aFdWbzRXaHRlU0dmUFhYc0p2SzE2TlI4MTZPR3BiWjdhczNiWDBUTFJZdVI4?=
 =?utf-8?B?eERoQncwQzFINHVsYU5RU1YrUDlHV1R1R1huVllNV2M4dythU0g0YWxaYmpY?=
 =?utf-8?B?SWFFYXVGRUVDL0Y0OGpEb3VjblBCWUhrYkd0SFpSMDUzWFF0RVFoOGtYVThN?=
 =?utf-8?B?aWc9PQ==?=
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fc6258e8-3b51-4694-e413-08daee8113c1
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jan 2023 18:25:37.7418
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: L8J7neKjZnEmRd7d4Lb97m8JVMkfxo0uSRBi+B0l8G8oVFb0m4rEn4vVBrtiM3pV
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR15MB2482
X-Proofpoint-ORIG-GUID: ErbZIzbIqBoXzgn7jmmzW9QgCcz-z7Qj
X-Proofpoint-GUID: ErbZIzbIqBoXzgn7jmmzW9QgCcz-z7Qj
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2023-01-04_07,2023-01-04_02,2022-06-22_01
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/2/23 5:31 PM, Pu Lehui wrote:
> From: Pu Lehui <pulehui@huawei.com>
> 
> Extra_nregs of structure parameters and nr_args can be
> added directly at the beginning, and using a flip flag
> to identifiy structure parameters. Meantime, renaming
> some variables to make them more sense.
> 
> Signed-off-by: Pu Lehui <pulehui@huawei.com>

Thanks for refactoring. Using nr_regs instead of nr_args indeed
making things easier to understand. Ack with a few nits below.

Acked-by: Yonghong Song <yhs@fb.com>

> ---
>   arch/x86/net/bpf_jit_comp.c | 99 +++++++++++++++++--------------------
>   1 file changed, 46 insertions(+), 53 deletions(-)
> 
> diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
> index e3e2b57e4e13..e7b72299f5a4 100644
> --- a/arch/x86/net/bpf_jit_comp.c
> +++ b/arch/x86/net/bpf_jit_comp.c
> @@ -1839,62 +1839,57 @@ st:			if (is_imm8(insn->off))
>   	return proglen;
>   }
>   
> -static void save_regs(const struct btf_func_model *m, u8 **prog, int nr_args,
> +static void save_regs(const struct btf_func_model *m, u8 **prog, int nr_regs,
>   		      int stack_size)
>   {
> -	int i, j, arg_size, nr_regs;
> +	int i, j, arg_size;
> +	bool is_struct = false;
> +
>   	/* Store function arguments to stack.
>   	 * For a function that accepts two pointers the sequence will be:
>   	 * mov QWORD PTR [rbp-0x10],rdi
>   	 * mov QWORD PTR [rbp-0x8],rsi
>   	 */
> -	for (i = 0, j = 0; i < min(nr_args, 6); i++) {
> -		if (m->arg_flags[i] & BTF_FMODEL_STRUCT_ARG) {
> -			nr_regs = (m->arg_size[i] + 7) / 8;
> +	for (i = 0, j = 0; i < min(nr_regs, 6); i++) {
> +		arg_size = m->arg_size[j];
> +		if (arg_size > 8) {
>   			arg_size = 8;
> -		} else {
> -			nr_regs = 1;
> -			arg_size = m->arg_size[i];
> +			is_struct ^= 1;
>   		}
>   
> -		while (nr_regs) {
> -			emit_stx(prog, bytes_to_bpf_size(arg_size),
> -				 BPF_REG_FP,
> -				 j == 5 ? X86_REG_R9 : BPF_REG_1 + j,
> -				 -(stack_size - j * 8));
> -			nr_regs--;
> -			j++;
> -		}
> +		emit_stx(prog, bytes_to_bpf_size(arg_size),
> +			 BPF_REG_FP,
> +			 i == 5 ? X86_REG_R9 : BPF_REG_1 + i,
> +			 -(stack_size - i * 8));
> +
> +		j = is_struct ? j : j + 1;
>   	}
>   }
>   
> -static void restore_regs(const struct btf_func_model *m, u8 **prog, int nr_args,
> +static void restore_regs(const struct btf_func_model *m, u8 **prog, int nr_regs,
>   			 int stack_size)
>   {
> -	int i, j, arg_size, nr_regs;
> +	int i, j, arg_size;
> +	bool is_struct = false;

Maybe
	bool next_same_struct = false
to better characterize what it means?

>   
>   	/* Restore function arguments from stack.
>   	 * For a function that accepts two pointers the sequence will be:
>   	 * EMIT4(0x48, 0x8B, 0x7D, 0xF0); mov rdi,QWORD PTR [rbp-0x10]
>   	 * EMIT4(0x48, 0x8B, 0x75, 0xF8); mov rsi,QWORD PTR [rbp-0x8]
>   	 */
> -	for (i = 0, j = 0; i < min(nr_args, 6); i++) {
> -		if (m->arg_flags[i] & BTF_FMODEL_STRUCT_ARG) {
> -			nr_regs = (m->arg_size[i] + 7) / 8;
> +	for (i = 0, j = 0; i < min(nr_regs, 6); i++) {

Let us put a comment here so the later users can understand the logic
behind 'is_struct ^= 1'.

/* The arg_size is at most 16 bytes, enforced by the verifier. */

> +		arg_size = m->arg_size[j];
> +		if (arg_size > 8) {
>   			arg_size = 8;
> -		} else {
> -			nr_regs = 1;
> -			arg_size = m->arg_size[i];
> +			is_struct ^= 1;

next_same_struct = !next_same_struct;

The same for above save_regs().

>   		}
>   
> -		while (nr_regs) {
> -			emit_ldx(prog, bytes_to_bpf_size(arg_size),
> -				 j == 5 ? X86_REG_R9 : BPF_REG_1 + j,
> -				 BPF_REG_FP,
> -				 -(stack_size - j * 8));
> -			nr_regs--;
> -			j++;
> -		}
> +		emit_ldx(prog, bytes_to_bpf_size(arg_size),
> +			 i == 5 ? X86_REG_R9 : BPF_REG_1 + i,
> +			 BPF_REG_FP,
> +			 -(stack_size - i * 8));
> +
> +		j = is_struct ? j : j + 1;
>   	}
>   }
>   
[...]
