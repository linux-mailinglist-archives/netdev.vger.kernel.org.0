Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBFC946AB14
	for <lists+netdev@lfdr.de>; Mon,  6 Dec 2021 22:55:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356113AbhLFV6p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 16:58:45 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:59358 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240577AbhLFV6o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 16:58:44 -0500
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B6HvnlW001949;
        Mon, 6 Dec 2021 13:54:59 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=Si1vHAf3o9x7X8fPyhPbxkD5oz3V5U5jzcc6fxpyvIw=;
 b=h3SqI4vVCgosCsl1waxIAHzGD/iQznNPQsRkwuDoz991Ir4Yw0fFpAfyRzbdVO9jANfA
 7ufgqPgmLCQXp41JU+1ah7BVmzUZvQ9XFa6WS7aDXj4i4cSN39hnXYA7pz3+T5uBV2Go
 +y0GXvKZO3TQsFfoAThFaeSGJvvDU2ItxPU= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3csdrhdemu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 06 Dec 2021 13:54:58 -0800
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 6 Dec 2021 13:54:57 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cljeJ8FYiGTKAeAV7eLK3KV5kH3yDI3joBhz5VECPcwIVI6R40gYiC87TFcZQRKWWcmqjFxV8RW7Yy6Jlpe4as/nDfjRPPniRS8iBe6sht5JBfE1S/CAkQLmn+Rsec5nl6vsBRHfIv54YanAStIXU4oAgXVun/ld10XMsIsU0HccxLgzyJhmc8K8cwVKaA1IA0udagjtycgjSsgZcVv3cizziiPsA/9c5IGRKDwuC4FTh/ixy76ZrjEy0eBkad4rv8ViP624zcxj/5wYKpY2m6HQrLgvA1LPDOX+yhk1oHjPZrfe0yCgo1Q8pI+25W8O8oqddpYJb0pDm2ALkD9RJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Si1vHAf3o9x7X8fPyhPbxkD5oz3V5U5jzcc6fxpyvIw=;
 b=nsbWTaKhYGAA5SyvcirWWRi372+iTTwY/oPUmJjy6chD12o7pB53UDSHHWnF52psIIYy+uhQnJHzAGtm4HMab4fNz1b8xyfH5xImE+MVYr2ow9FxPYuTpBPceQw1w7vqeu4xgnuyTxMr9hmOPhEEXerpPxNT3njdd/mZleeyoKZ/2GuO63e2wILbFDLJUvF55eITieB2/mXarRbkCVys63h91SHL67rBGX+iFy/vmDEAT561d5wLvKMGzgUQ1A3oNXdy/VVqpHAlAovQq2i0nCKIuWJ1Mp/IwetNvvden/Iv9U4q8LP4R7rwX8DSuVSiuzV4hmz/oW6nd1moAgwskg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from MW3PR15MB3980.namprd15.prod.outlook.com (2603:10b6:303:48::23)
 by CO1PR15MB4955.namprd15.prod.outlook.com (2603:10b6:303:e6::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.22; Mon, 6 Dec
 2021 21:54:56 +0000
Received: from MW3PR15MB3980.namprd15.prod.outlook.com
 ([fe80::cdcf:702a:58e9:b0a6]) by MW3PR15MB3980.namprd15.prod.outlook.com
 ([fe80::cdcf:702a:58e9:b0a6%8]) with mapi id 15.20.4755.022; Mon, 6 Dec 2021
 21:54:56 +0000
Message-ID: <f1cf12b9-01f5-f980-a349-1cbcd1124409@fb.com>
Date:   Mon, 6 Dec 2021 13:54:53 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.0
Subject: Re: [PATCH bpf-next 2/3] bpf: Add get_func_[arg|ret|arg_cnt] helpers
Content-Language: en-US
To:     Jiri Olsa <jolsa@redhat.com>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
CC:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
References: <20211204140700.396138-1-jolsa@kernel.org>
 <20211204140700.396138-3-jolsa@kernel.org>
From:   Andrii Nakryiko <andriin@fb.com>
In-Reply-To: <20211204140700.396138-3-jolsa@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MWHPR03CA0012.namprd03.prod.outlook.com
 (2603:10b6:300:117::22) To MW3PR15MB3980.namprd15.prod.outlook.com
 (2603:10b6:303:48::23)
MIME-Version: 1.0
Received: from [IPV6:2620:10d:c085:2103:b2:4e6a:72dd:1ddf] (2620:10d:c090:400::5:1d85) by MWHPR03CA0012.namprd03.prod.outlook.com (2603:10b6:300:117::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.17 via Frontend Transport; Mon, 6 Dec 2021 21:54:54 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c6f8e059-948d-4efd-28b8-08d9b9030a52
X-MS-TrafficTypeDiagnostic: CO1PR15MB4955:EE_
X-Microsoft-Antispam-PRVS: <CO1PR15MB4955021F6D15080B87DC519BC66D9@CO1PR15MB4955.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:2449;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ODdjpIHFwLrM0BKPZsEw3N57Iqv3wY/cMffcgMGX85+AyNeg0v2KXoO1fxAOALvutAvIqNHR5yd3pCDlZvYiKoxhISZKFaCjyEgmiSIFyGTONvagouf3wN/xkv5rDyMuWgg2tfCWzeZmPhChoVpVW8AIO0Hoie/gO8ZwQfMy2s3yFChbN1O11j4D5nzvGl5SCMugm8fvrigbad3qYQUP+fGRXvKwUwjK+oR9NHoIQEDcBshP9Pp5DulWpnHE+oeq3uGnqqmb2fIKeKNC5kwtYSqVC2bfsatBtZi9TPDWFWk94Cm2WpVDaxUOY8IFocEmDjM9spPa1so+wJo+887x01wSKv1yDaJzqwa/gyBls7u/yid+WHBXLPWwH+1Sdk4SSgoL2FkSBq5QF0ORFxpoW4pkjc8GOPRTpVjDADAC9JZd9bYeiv5gBZqR8WjCb12Uzz+nCdnSLcomOFOgfdXmklwCBQyUOKbjzDs7gzAYuu6iFnoDvCjgtqLlnXGw6HTgoEgUrO2WRq8hEr+zNRvQkHL1Hf8xrzQKpZH/p4rCC5uyYTnTqrriWE1uONe15y0RNNcy/e8FhGOUJc+rXttJ6docnwqRvUt/3AkzYGcODcbwRWMBruLCPBJ1nsp/9+OEWmXEP01Eq+zLX8lgcJi2HOEc61ROGGr5JbWRwCGbR1d84Qu6R9fEYc/KVLZ43aqB33EHnou19CbZyej26KbvP6vBeVy44fnM8Jpr2kstI48=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR15MB3980.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(31696002)(66946007)(36756003)(110136005)(86362001)(66556008)(2906002)(31686004)(38100700002)(186003)(6486002)(66476007)(5660300002)(8936002)(83380400001)(508600001)(4326008)(316002)(2616005)(8676002)(54906003)(53546011)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RU1EM0FMWDhTMGF3RlpiOHE5ZGYvRHdCU1BUNVU3R0dtVXF0REtMTjlRcUhI?=
 =?utf-8?B?UUdKOElOcmVGVGovMEFiTFpUWndpazVZY0dHcGJIZnRzVVNiYlJSWmRTTHpj?=
 =?utf-8?B?OFRCZG05bWFhNFJVTHg5SUIyVjlmUkV4NzZ2Q3N0ekkxeUVYc2FxbG9ZZVA4?=
 =?utf-8?B?VmxoclMzckE3bjlmK0tTenpIWWc2UHhTUER6aHZDWi80ZTdQV3NtakZoejdY?=
 =?utf-8?B?NDY3YmhrN1Y5b1BrTUFGeVRJVGtuamRqZVZIRnpybFJGQUJ5RzZQSmdCSkNx?=
 =?utf-8?B?U2tMTjhBQmhZeXdyc0I3N2pGRk1yVmd0MEdWU0hURjV1T21seHFFanExTFBT?=
 =?utf-8?B?bDVTN1JJcjhBWi9lQU1HbUp2NmluVFFMdkp5U3RlVG1jYnIwaFV0S0RVZHpV?=
 =?utf-8?B?aExleXMxem1vZnQyN2NmL1N4TTNBL2NXTTZ4bi9aMVJ2c3dncDZMVGIxaWlH?=
 =?utf-8?B?amR3V2NjRW1hR2pYUDAveE1sVEk0VXZrSXhibVdRdVViNC9ib3NKMi9qQ1B5?=
 =?utf-8?B?RkthYnFLMFlrOTN0L2VyallhbE5PVFRzVnNQVVRaejNmNTloRVFoUjQrN2Vh?=
 =?utf-8?B?MUFGeUJaREt6OElwNHd0WGhwYitKK2R3aWFmbnNFOFBvMU0xNnFlcGtuVXAr?=
 =?utf-8?B?WmRob1RqTS8xQ29iazQvZzB2VFV2Sm1VNTZONjBXc2NvWEtVTFlKRGRGT3FN?=
 =?utf-8?B?dS9IS1d6Z2tqUmRJZDlLZU9PUjZHTXUzNlhza1o2elBxeGhwNnpGdVE4dG9L?=
 =?utf-8?B?d3E0TTR6ai9GN3pZMkRQZUtOeUcvY1JmWDUwcUZsWFdzaUpEMG16M3BzWE5J?=
 =?utf-8?B?Z1A4elF6Z1FGZ3Y5KzNKcGNmNUkzOC8zNkx4eXhzTFRTd1pTTG1uNUFJT2hs?=
 =?utf-8?B?TS96bmhkN0g2MzcvN2NIZ0kwaDZXTHZXTnh5S0hyMHZZbTJDTks2S2VWMHNH?=
 =?utf-8?B?Q1NuaDk1NVhNZk9pU3IrMEpxQjNPbDFnckNDa3R0dkFMZGxnSlRza1dlN2tL?=
 =?utf-8?B?VGR5d0JsQXZYT2JPbUR1YnI3SUdZZ2hsbnN3eU11SnpMZG1pRG1wUldZaEhq?=
 =?utf-8?B?SStCejMrZkVySWU2anl1WTVQOFlXYmdyQ0lXTGQzREU3WkI0d1JtQkc4Vlc4?=
 =?utf-8?B?am1sTkU1b2xFbWNRaER6Zml0aVNnSW5JcWkzQWlKZUZUMWVCR29GMlNRY2hT?=
 =?utf-8?B?bE5nUHNzcUt2R004bERXc3YrdXRCYjBoUzJzYlovbEphaFZBbEVaMlFOY2kv?=
 =?utf-8?B?M1BZZ1hJYTFqYVVhSUowc2lEbDRRb1Z5cm92T0RtbzllU2U4REF4M3NFazh3?=
 =?utf-8?B?eUtraWxDM2JuVEk3RjVnejlsSDU1Nm1ROVR3bGROcDVFYVllaVYvcVFlSWl5?=
 =?utf-8?B?MVVldWllMFBLdkJCN2hMWVJyb0Q0QW9vbVo0OFMzNVk2VnBhSndmYTVyMHJ5?=
 =?utf-8?B?NGFFSVJaNEQxWEsyRjhYWEMyMzc0L0pwSDVlRnoyVXN3YXFoVm8ycThTVEVU?=
 =?utf-8?B?MjJqdHVac29mSVNJWDdEZm9KOUhsMzI4Vm1jYmJVRlFlRURQUHRzVlRQTlhl?=
 =?utf-8?B?NTliRXJHWk8xVXM2UTUwd09RWnZ6SmJraTlyOThHd2wxN0M2alVrTURKQjFT?=
 =?utf-8?B?aTMrL1EvSDd2cTU3amNITUgrSVlhRXBTVlp4UHR5OVF3Slk3L1MwZ2FWVGlM?=
 =?utf-8?B?NlZhYktpV1FuQkpUZ3ZRd0l4L0lqVUhGN1E5cEgrMVNnNVgxdWxrQjErcTVs?=
 =?utf-8?B?aW1uVE1nV1ovVTJFQWRjNklBUnREcmdkdXNaZWFZanFKamlZUmpQZlhwTUZI?=
 =?utf-8?B?Vzd0MERjQ09YeCtFVjVWaldVaVRRZktyMkhNbkFBN1FKRG5RbUR0anpLdy9o?=
 =?utf-8?B?TGVtUUlNdmFkNUV6MlpJdHJUSURYKzQ2NDNLOGp1Uk9Ka1pMYWorQ0hMcDZk?=
 =?utf-8?B?NGNmN1Uyci9OUTB5V1JuNzNPQjR3a0RzTGRpOTdiVEN2OTdvZWlGMlYwTTZP?=
 =?utf-8?B?bVFwTTdJMWRXQ2piN1RQY09CVVhQU1d6TWx5bklUQk1OZlp6K2l0cUljZ2Zw?=
 =?utf-8?B?UW1zUWlySXF2NWlFZXBRVGU1SmxjNzVtcjdSeS9RWWRBN1hPUWVCcEFvbGMv?=
 =?utf-8?Q?m5tCNPlFkUneTq9b9Lk/0THA2?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c6f8e059-948d-4efd-28b8-08d9b9030a52
X-MS-Exchange-CrossTenant-AuthSource: MW3PR15MB3980.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2021 21:54:56.0117
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: S+zASaoNbv1v8kH+uzdH2HyQujB/T3e4EHVfSpUg1P//l6TBzp+Tzmuv1T95HS/9
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR15MB4955
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: sFeu_qscMNGS3BhaU2folWHCoLApvaFu
X-Proofpoint-GUID: sFeu_qscMNGS3BhaU2folWHCoLApvaFu
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-06_07,2021-12-06_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 spamscore=0 mlxscore=0
 priorityscore=1501 mlxlogscore=999 malwarescore=0 bulkscore=0
 clxscore=1011 adultscore=0 lowpriorityscore=0 phishscore=0 impostorscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112060134
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 12/4/21 6:06 AM, Jiri Olsa wrote:
> Adding following helpers for tracing programs:
>
> Get n-th argument of the traced function:
>    long bpf_get_func_arg(void *ctx, u32 n, u64 *value)
>
> Get return value of the traced function:
>    long bpf_get_func_ret(void *ctx, u64 *value)
>
> Get arguments count of the traced funtion:
>    long bpf_get_func_arg_cnt(void *ctx)
>
> The trampoline now stores number of arguments on ctx-8
> address, so it's easy to verify argument index and find
> return value argument's position.
>
> Moving function ip address on the trampoline stack behind
> the number of functions arguments, so it's now stored on
> ctx-16 address if it's needed.
>
> All helpers above are inlined by verifier.
>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---


Please cc me at andrii@kernel.org email for future emails, you'll save a 
lot of trouble with replying to your emails :) Thanks!


>   arch/x86/net/bpf_jit_comp.c    | 15 ++++++-
>   include/uapi/linux/bpf.h       | 28 +++++++++++++
>   kernel/bpf/verifier.c          | 73 +++++++++++++++++++++++++++++++++-
>   kernel/trace/bpf_trace.c       | 58 ++++++++++++++++++++++++++-
>   tools/include/uapi/linux/bpf.h | 28 +++++++++++++
>   5 files changed, 198 insertions(+), 4 deletions(-)
>
> diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
> index b106e80e8d9c..142e6b90fa52 100644
> --- a/arch/x86/net/bpf_jit_comp.c
> +++ b/arch/x86/net/bpf_jit_comp.c
> @@ -1941,7 +1941,7 @@ int arch_prepare_bpf_trampoline(struct bpf_tramp_image *im, void *image, void *i
>   				void *orig_call)
>   {
>   	int ret, i, nr_args = m->nr_args;
> -	int regs_off, ip_off, stack_size = nr_args * 8;
> +	int regs_off, ip_off, args_off, stack_size = nr_args * 8;
>   	struct bpf_tramp_progs *fentry = &tprogs[BPF_TRAMP_FENTRY];
>   	struct bpf_tramp_progs *fexit = &tprogs[BPF_TRAMP_FEXIT];
>   	struct bpf_tramp_progs *fmod_ret = &tprogs[BPF_TRAMP_MODIFY_RETURN];
> @@ -1968,6 +1968,8 @@ int arch_prepare_bpf_trampoline(struct bpf_tramp_image *im, void *image, void *i
>   	 *                 [ ...             ]
>   	 * RBP - regs_off  [ reg_arg1        ]
>   	 *
> +	 * RBP - args_off  [ args count      ]  always
> +	 *
>   	 * RBP - ip_off    [ traced function ]  BPF_TRAMP_F_IP_ARG flag
>   	 */
>   
> @@ -1978,6 +1980,10 @@ int arch_prepare_bpf_trampoline(struct bpf_tramp_image *im, void *image, void *i
>   
>   	regs_off = stack_size;
>   
> +	/* args count  */
> +	stack_size += 8;
> +	args_off = stack_size;
> +
>   	if (flags & BPF_TRAMP_F_IP_ARG)
>   		stack_size += 8; /* room for IP address argument */
>   
> @@ -1996,6 +2002,13 @@ int arch_prepare_bpf_trampoline(struct bpf_tramp_image *im, void *image, void *i
>   	EMIT4(0x48, 0x83, 0xEC, stack_size); /* sub rsp, stack_size */
>   	EMIT1(0x53);		 /* push rbx */
>   
> +	/* Store number of arguments of the traced function:
> +	 *   mov rax, nr_args
> +	 *   mov QWORD PTR [rbp - args_off], rax
> +	 */
> +	emit_mov_imm64(&prog, BPF_REG_0, 0, (u32) nr_args);
> +	emit_stx(&prog, BPF_DW, BPF_REG_FP, BPF_REG_0, -args_off);
> +
>   	if (flags & BPF_TRAMP_F_IP_ARG) {
>   		/* Store IP address of the traced function:
>   		 * mov rax, QWORD PTR [rbp + 8]
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index c26871263f1f..d5a3791071d6 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -4983,6 +4983,31 @@ union bpf_attr {
>    *	Return
>    *		The number of loops performed, **-EINVAL** for invalid **flags**,
>    *		**-E2BIG** if **nr_loops** exceeds the maximum number of loops.
> + *
> + * long bpf_get_func_arg(void *ctx, u32 n, u64 *value)
> + *	Description
> + *		Get **n**-th argument (zero based) of the traced function (for tracing programs)
> + *		returned in **value**.
> + *
> + *	Return
> + *		0 on success.
> + *		**-EINVAL** if n >= arguments count of traced function.
> + *
> + * long bpf_get_func_ret(void *ctx, u64 *value)
> + *	Description
> + *		Get return value of the traced function (for tracing programs)
> + *		in **value**.
> + *
> + *	Return
> + *		0 on success.
> + *		**-EINVAL** for tracing programs other than BPF_TRACE_FEXIT or BPF_MODIFY_RETURN.


-EOPNOTSUPP maybe?


> + *
> + * long bpf_get_func_arg_cnt(void *ctx)
> + *	Description
> + *		Get number of arguments of the traced function (for tracing programs).
> + *
> + *	Return
> + *		The number of arguments of the traced function.
>    */
>   #define __BPF_FUNC_MAPPER(FN)		\
>   	FN(unspec),			\
> @@ -5167,6 +5192,9 @@ union bpf_attr {
>   	FN(kallsyms_lookup_name),	\
>   	FN(find_vma),			\
>   	FN(loop),			\
> +	FN(get_func_arg),		\
> +	FN(get_func_ret),		\
> +	FN(get_func_arg_cnt),		\
>   	/* */
>   
>   /* integer value in 'imm' field of BPF_CALL instruction selects which helper
> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index 6522ffdea487..cf6853d3a8e9 100644
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -12974,6 +12974,7 @@ static int fixup_kfunc_call(struct bpf_verifier_env *env,
>   static int do_misc_fixups(struct bpf_verifier_env *env)
>   {
>   	struct bpf_prog *prog = env->prog;
> +	enum bpf_attach_type eatype = prog->expected_attach_type;
>   	bool expect_blinding = bpf_jit_blinding_enabled(prog);
>   	enum bpf_prog_type prog_type = resolve_prog_type(prog);
>   	struct bpf_insn *insn = prog->insnsi;
> @@ -13344,11 +13345,79 @@ static int do_misc_fixups(struct bpf_verifier_env *env)
>   			continue;
>   		}
>   
> +		/* Implement bpf_get_func_arg inline. */
> +		if (prog_type == BPF_PROG_TYPE_TRACING &&
> +		    insn->imm == BPF_FUNC_get_func_arg) {
> +			/* Load nr_args from ctx - 8 */
> +			insn_buf[0] = BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1, -8);
> +			insn_buf[1] = BPF_JMP32_REG(BPF_JGE, BPF_REG_2, BPF_REG_0, 6);
> +			insn_buf[2] = BPF_ALU64_IMM(BPF_LSH, BPF_REG_2, 3);
> +			insn_buf[3] = BPF_ALU64_REG(BPF_ADD, BPF_REG_2, BPF_REG_1);
> +			insn_buf[4] = BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_2, 0);
> +			insn_buf[5] = BPF_STX_MEM(BPF_DW, BPF_REG_3, BPF_REG_0, 0);
> +			insn_buf[6] = BPF_MOV64_IMM(BPF_REG_0, 0);
> +			insn_buf[7] = BPF_JMP_A(1);
> +			insn_buf[8] = BPF_MOV64_IMM(BPF_REG_0, -EINVAL);
> +			cnt = 9;
> +
> +			new_prog = bpf_patch_insn_data(env, i + delta, insn_buf, cnt);
> +			if (!new_prog)
> +				return -ENOMEM;
> +
> +			delta    += cnt - 1;
> +			env->prog = prog = new_prog;
> +			insn      = new_prog->insnsi + i + delta;
> +			continue;
> +		}
> +
> +		/* Implement bpf_get_func_ret inline. */
> +		if (prog_type == BPF_PROG_TYPE_TRACING &&
> +		    insn->imm == BPF_FUNC_get_func_ret) {
> +			if (eatype == BPF_TRACE_FEXIT ||
> +			    eatype == BPF_MODIFY_RETURN) {
> +				/* Load nr_args from ctx - 8 */
> +				insn_buf[0] = BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1, -8);
> +				insn_buf[1] = BPF_ALU64_IMM(BPF_LSH, BPF_REG_0, 3);
> +				insn_buf[2] = BPF_ALU64_REG(BPF_ADD, BPF_REG_0, BPF_REG_1);
> +				insn_buf[3] = BPF_LDX_MEM(BPF_DW, BPF_REG_3, BPF_REG_0, 0);
> +				insn_buf[4] = BPF_STX_MEM(BPF_DW, BPF_REG_2, BPF_REG_3, 0);
> +				insn_buf[5] = BPF_MOV64_IMM(BPF_REG_0, 0);
> +				cnt = 6;
> +			} else {
> +				insn_buf[0] = BPF_MOV64_IMM(BPF_REG_0, -EINVAL);
> +				cnt = 1;
> +			}
> +
> +			new_prog = bpf_patch_insn_data(env, i + delta, insn_buf, cnt);
> +			if (!new_prog)
> +				return -ENOMEM;
> +
> +			delta    += cnt - 1;
> +			env->prog = prog = new_prog;
> +			insn      = new_prog->insnsi + i + delta;
> +			continue;
> +		}
> +
> +		/* Implement get_func_arg_cnt inline. */
> +		if (prog_type == BPF_PROG_TYPE_TRACING &&
> +		    insn->imm == BPF_FUNC_get_func_arg_cnt) {
> +			/* Load nr_args from ctx - 8 */
> +			insn_buf[0] = BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1, -8);
> +
> +			new_prog = bpf_patch_insn_data(env, i + delta, insn_buf, 1);
> +			if (!new_prog)
> +				return -ENOMEM;
> +
> +			env->prog = prog = new_prog;
> +			insn      = new_prog->insnsi + i + delta;
> +			continue;
> +		}


To be entirely honest, I'm not even sure we need to inline them. In 
programs that care about performance they will be called at most once. 
In others it doesn't matter. But even if they weren't, is the function 
call really such a big overhead for tracing cases? I don't mind it 
either, I just can hardly follow it.


> +
>   		/* Implement bpf_get_func_ip inline. */
>   		if (prog_type == BPF_PROG_TYPE_TRACING &&
>   		    insn->imm == BPF_FUNC_get_func_ip) {
> -			/* Load IP address from ctx - 8 */
> -			insn_buf[0] = BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1, -8);
> +			/* Load IP address from ctx - 16 */
> +			insn_buf[0] = BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1, -16);
>   
>   			new_prog = bpf_patch_insn_data(env, i + delta, insn_buf, 1);
>   			if (!new_prog)


[...]

