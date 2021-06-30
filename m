Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F0E13B87EF
	for <lists+netdev@lfdr.de>; Wed, 30 Jun 2021 19:47:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232772AbhF3Rtw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Jun 2021 13:49:52 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:51590 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229573AbhF3Rtv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Jun 2021 13:49:51 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.43/8.16.0.43) with SMTP id 15UHh82O027169;
        Wed, 30 Jun 2021 10:47:06 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=hkc9gTerCLcCkq2koJVmvi4/rj+V4iDagtqqOnQJePw=;
 b=S0hO85sqxsqSChpIb++ZCLRQr78Pm9LoqAie7x97h2NDu1gztNj6IZbTpYReQ7Iur10k
 35x3oIHd7iha8wmD4qQqCGDI0811YB5Q25Z3a56ZsrIVGryDAO+UtZpNGGOH3qL1avCW
 PDKuAz25P1InZSRtqFSubzCvMA/6/75jcto= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0001303.ppops.net with ESMTP id 39gt4hsd4f-11
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 30 Jun 2021 10:47:06 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.228) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 30 Jun 2021 10:47:05 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FPCORGfWR7j7a+gxQRNMHQmhizP8ibqU8gnpTdJ46l808EriekJLFtbtAZtmnHm4lQeJvcKjOfM6i2cGwZhTMJJJY9yTWciRlu3rQ2LmjsxKJvSrtKUtSe37Znbn9LGTpX35O++fscRfz+0eHCOVcpFqPiREOD99IpfqNYc3BaZqCM8GB9b0RjZYeTnUhwvQt1rdsH0BrVv70op+7xavt4chkrnxOz6de6hRO/YAM9CBuRExzPZQ1Cc8AAFpzj5BtGBiWoPN0VIZUnsmq5agW49p/cvq9uuNxWEScPAyeTtjfbXteOiiQ3Zvd/kKTSYnGz+dz/jgSaoV1HmEtf90ew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hkc9gTerCLcCkq2koJVmvi4/rj+V4iDagtqqOnQJePw=;
 b=mn7pf23WKy130avYHjx+VZr0oiTgtfhgtbEnDCnJ0w8Vnv2iQWUktcthGKYrJAGGnAMVaGh74fM4k4MiJBc4eauSJVQDfMZtYf4IKDCrtOL6dBubB0SeaXh9HF1DhZ4hSAnbMMLjjybd9mAqtdmz9ZGG5HMCF5xhq1KkLeIxedePX3AyptYlVfVkCng63Sl4dUYo7UoABBKLaMMkwlljADVAYbQS5JCs+Hj/VveNoF/C34/Kgr+p+bfxnBVvqu02jXRocV/y9tCiTj8dRddKv0xCi+3PcCiphPDoBuBNcYdeAoVQ+gyDNoAlodarRFcP6kmErBLv4cipzd7z3Lchyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=fb.com;
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SN6PR15MB2479.namprd15.prod.outlook.com (2603:10b6:805:17::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.20; Wed, 30 Jun
 2021 17:47:03 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::d886:b658:e2eb:a906]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::d886:b658:e2eb:a906%5]) with mapi id 15.20.4287.023; Wed, 30 Jun 2021
 17:47:03 +0000
Subject: Re: [PATCH bpf-next 4/5] bpf: Add bpf_get_func_ip helper for kprobe
 programs
To:     Jiri Olsa <jolsa@redhat.com>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>
CC:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Masami Hiramatsu <mhiramat@kernel.org>
References: <20210629192945.1071862-1-jolsa@kernel.org>
 <20210629192945.1071862-5-jolsa@kernel.org>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <9286ce63-5cba-e16a-a7db-886548a04a64@fb.com>
Date:   Wed, 30 Jun 2021 10:47:01 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
In-Reply-To: <20210629192945.1071862-5-jolsa@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:a3d3]
X-ClientProxiedBy: SJ0PR03CA0128.namprd03.prod.outlook.com
 (2603:10b6:a03:33c::13) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21e1::1398] (2620:10d:c090:400::5:a3d3) by SJ0PR03CA0128.namprd03.prod.outlook.com (2603:10b6:a03:33c::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4287.22 via Frontend Transport; Wed, 30 Jun 2021 17:47:03 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2485956a-11c8-4ed6-d454-08d93bef1217
X-MS-TrafficTypeDiagnostic: SN6PR15MB2479:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR15MB2479F30A4C5F23DED63EDE3CD3019@SN6PR15MB2479.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:1148;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0xRxX664Ptje9nIs+Txetycxs4Bouedm/fm5Ocqk7aV3cxT6ML6KkzZYzrc8kzOOjIbmkCuf9qjImwCh7nWYHUj0gThU1uN32AoCOwd/AhitN0NYy7nNz+0R4nCL5wpvrOxbz77pJ3g8aS/zgTezwzzVMAftbOw5pShZc5AIjuBHOgn9zbr3jwYKGm7Olnbj457sCoBx/K9dJ+WaS0HSPIT1bv+xXmOLkSiQ+dcTpufrmx7wlPnLY2VwJAaBsza2xzy6oqCxorLF3zAfPKtyM8EJR3aiqR1rFAuxIQNNUaNz+O4iXq/Y3r8GrRHfc1p5VhL1zQihDpGG7DYmMFFQKxsq84+LzRoHYG22Nozx2GpE7VfwNqmTJVTav3dSs15BZp1zVtXVv4ahFPkCayVn7s0XMFEnD+9mrQOgYKyOwr63GHiDVUcx4AEyJNodqicFk6AOROO79gV/pbJ8gkIs8IBoORwtE2ryl1kEevLSAecoWXJoSZG5zO5THvVTKsB+r1aCyORyckUvUKPhDD8eZWHiBX1QlvVFDnHJFt+vbwxL81xzezLTEchb5GcW2o/+hDZ0g5jLD2Jky6fXQM2iFihGvFR3yB7WyTHg5PH9li8d9VIs7RdzhApnG6J3X7zyCkTJK9ZJ+PpGX8776wvJ0BcLN1FiuyaWARkZKpjVbIrzZy4+WnR6Pu4MKf5aKz3tXWLddBQybsC0XnKqVmqRSGim1LAE2lA7fsbAC0Fa8JQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(376002)(39860400002)(346002)(366004)(2616005)(478600001)(36756003)(66556008)(8936002)(53546011)(66946007)(6486002)(2906002)(66476007)(110136005)(54906003)(83380400001)(52116002)(186003)(8676002)(16526019)(4326008)(6636002)(5660300002)(86362001)(31686004)(31696002)(38100700002)(316002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZVRpcm1mQXNtS21qT2h1SC9USWROQkZkcEZoT1Fla1cxRVFGVExmbVNzTGxv?=
 =?utf-8?B?S29EeVhCZDhQN21rb3Q1TSs0QmRPV3ZtL2hmVDVOdjQ3Mk42Z0Fjdk1nVmQ3?=
 =?utf-8?B?TkR0VVRKZ2tyNjhRWmZqeEM5aWMwcjVnbmZiTDJaNGtLUmk2TVZMc1VmcWgx?=
 =?utf-8?B?TXBNK3VwZ05qdnE1dlpSdW9naGxZaC83RFBsZElHUVNTeUhoZVpxc0dyTkNB?=
 =?utf-8?B?Q2dMb1BDT1F5d2hUQ3AwaElJcVZ0d0FOcG1jaGFIVzYvSGdQRGVjSytncDd3?=
 =?utf-8?B?SktteDJYN0duZjRDUWtMUnFqQXlWS2tscWtqSU1wNlVqQ0lKWi9PVTFhS2xL?=
 =?utf-8?B?RTFsTXBhSXVwZVorWHo5Nlh4eGhZd0VCTUJmTGU2WDhUQ3FQT2V1djZoUU9Z?=
 =?utf-8?B?bCtNVkFQUS9JajJmZzBySEpkclhDdmZORStDVElSeFZuNjlGMjBFN214bmNU?=
 =?utf-8?B?eGd6NHhRTWNZWXF0azBoMzJTeitFRm5JbDFBMEtCUHBDSkRHQkJZYUQzakJI?=
 =?utf-8?B?THhVUXd5eCtNOGh1cUVDS2YzWk9SQUJScGhmYmovNlJkMGRjejE5Z0JzQmtO?=
 =?utf-8?B?ckdES1pOM0NLVHVvdXhZUEk1T3pFcm1GSlFieWFrbVZZd2I3N1l4OW5QaUhN?=
 =?utf-8?B?aGdIcEFxOWx2YzhybmdlMVN6UnZVVWoyQ2xBcVFjVkE4dW8yVDMrRzZjbkpJ?=
 =?utf-8?B?MWx0cUlMelJSMmpKWGRjQWZVbUJzR1YvL1FWVjNTVWpWVUp6aUVVZXlGY2M1?=
 =?utf-8?B?dGkyaFNQVjBTNTlOc1kvbXAzWGdGNzdEZkZ5WUdDdnBmQk9UWFVUUitjZFpT?=
 =?utf-8?B?eittOFc5OGFsWlo1MC9wSm9rYWxkN09NbkR4dG81bHRtd3d0a0xNQ2ZJN2FC?=
 =?utf-8?B?TkQzUWZJUGZLbVN2S2xnZHRHbDNvWDNkY2dPRnZVMlhiVEVYNDZzVW12QVhU?=
 =?utf-8?B?TzBQV2pJSUZHaXJvRG42SG51aUpXdDBYYmN2UVBGSlpaRG1KV2l3R09BOFhE?=
 =?utf-8?B?bTJrMWZBRG9KY2JXMjcrYVdONVpoaGRCVXJ5UTgybzFWSjliWkVscDZGZmpz?=
 =?utf-8?B?R3NLVXZKK2VTTVNYeU5JY3JpUHV2aGFkZ2ZqUnkrTnRmdjVNTTBvNHZESTBv?=
 =?utf-8?B?b3JwL2dnbmtVeUpEMERhRHJxR3gwNXFia0twamdROEhKYXF6ZVcvMnA0STNO?=
 =?utf-8?B?cVpKeHE5MnljL2loSGxCLzB4MUJTSUsyaisrNVoraFVXVWhKRFdMYmhNK3I1?=
 =?utf-8?B?d1FSK1BiMXZMdDN6N1cvT0VjSUZEK1lyWVorSHlmbms3UHVIcTFKOEFxVnlH?=
 =?utf-8?B?VlpmaDRkRklZN3JHeE5FOUpGQUpudzRZR2MxZ3IraTZzSGZOeGVnNmlId0s4?=
 =?utf-8?B?MTYvNUZ0V2xFQ2VUTjZmUU11aW9FOXNwWUxzQUxIb0JSdWVTaUxOZGtMTU56?=
 =?utf-8?B?d09nYmVvOXk0UFZsM09Ua2JNUDBWOXdtaXpyR3dBUnlKWTNrdXdpV01vT2ZC?=
 =?utf-8?B?Q25Cb3NvQk9mRlhYdzFOOWltV200WXUwb3ZBMktNMEtRQVVZaUxDeDVKQ25E?=
 =?utf-8?B?amVjem01cU14b0RYVmJCVC9MbW5xL1F5Tnc4azZpU0hydXpvdjJ6RE5taEN1?=
 =?utf-8?B?M2pZTXNsL0VBTVJ2NndjZXY1ZjMrZGJQM2ZRVXBrY2I3MGJLWTA0UTlNMVph?=
 =?utf-8?B?K3VHbDZRNFZoT243RFVpbjJLUTdVdjdzKy9NclhQbEpoUjI2U1BVK0ZIR0Ns?=
 =?utf-8?B?SnJBem5hNk1PbTYrSUxFVmR6YmRFdWJWbUZoTXB5YmFUZWQ4b2xQdlZ3ckE0?=
 =?utf-8?B?VTdTZS9CZGNTd29lUG5tUT09?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2485956a-11c8-4ed6-d454-08d93bef1217
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jun 2021 17:47:03.8058
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VL6vEzcwPn7lljZkK+4htcEkVa21cRhXICuunTkw5eKDKeeILgx4dlxlFagA1V7I
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR15MB2479
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: 1BqWpWDE2_pdIHG9aIw3DXZ2TZMIQdxk
X-Proofpoint-ORIG-GUID: 1BqWpWDE2_pdIHG9aIw3DXZ2TZMIQdxk
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-06-30_08:2021-06-30,2021-06-30 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0 phishscore=0
 malwarescore=0 impostorscore=0 mlxlogscore=999 clxscore=1011 mlxscore=0
 priorityscore=1501 suspectscore=0 adultscore=0 lowpriorityscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106300097
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/29/21 12:29 PM, Jiri Olsa wrote:
> Adding bpf_get_func_ip helper for BPF_PROG_TYPE_KPROBE programs,
> so it's now possible to call bpf_get_func_ip from both kprobe and
> kretprobe programs.
> 
> Taking the caller's address from 'struct kprobe::addr', which is
> defined for both kprobe and kretprobe.
> 
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
>   include/uapi/linux/bpf.h       |  2 +-
>   kernel/bpf/verifier.c          |  2 ++
>   kernel/trace/bpf_trace.c       | 14 ++++++++++++++
>   kernel/trace/trace_kprobe.c    | 20 ++++++++++++++++++--
>   kernel/trace/trace_probe.h     |  5 +++++
>   tools/include/uapi/linux/bpf.h |  2 +-
>   6 files changed, 41 insertions(+), 4 deletions(-)
> 
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index 83e87ffdbb6e..4894f99a1993 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -4783,7 +4783,7 @@ union bpf_attr {
>    *
>    * u64 bpf_get_func_ip(void *ctx)
>    * 	Description
> - * 		Get address of the traced function (for tracing programs).
> + * 		Get address of the traced function (for tracing and kprobe programs).
>    * 	Return
>    * 		Address of the traced function.
>    */
> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index 701ff7384fa7..b66e0a7104f8 100644
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -5979,6 +5979,8 @@ static bool has_get_func_ip(struct bpf_verifier_env *env)
>   			return -ENOTSUPP;
>   		}
>   		return 0;
> +	} else if (type == BPF_PROG_TYPE_KPROBE) {
> +		return 0;
>   	}
>   
>   	verbose(env, "func %s#%d not supported for program type %d\n",
> diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
> index 9edd3b1a00ad..1a5bddce9abd 100644
> --- a/kernel/trace/bpf_trace.c
> +++ b/kernel/trace/bpf_trace.c
> @@ -961,6 +961,18 @@ static const struct bpf_func_proto bpf_get_func_ip_proto_tracing = {
>   	.arg1_type	= ARG_PTR_TO_CTX,
>   };
>   
> +BPF_CALL_1(bpf_get_func_ip_kprobe, struct pt_regs *, regs)
> +{
> +	return trace_current_kprobe_addr();
> +}
> +
> +static const struct bpf_func_proto bpf_get_func_ip_proto_kprobe = {
> +	.func		= bpf_get_func_ip_kprobe,
> +	.gpl_only	= true,
> +	.ret_type	= RET_INTEGER,
> +	.arg1_type	= ARG_PTR_TO_CTX,
> +};
> +
>   const struct bpf_func_proto *
>   bpf_tracing_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
>   {
> @@ -1092,6 +1104,8 @@ kprobe_prog_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
>   	case BPF_FUNC_override_return:
>   		return &bpf_override_return_proto;
>   #endif
> +	case BPF_FUNC_get_func_ip:
> +		return &bpf_get_func_ip_proto_kprobe;
>   	default:
>   		return bpf_tracing_func_proto(func_id, prog);
>   	}
> diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
> index ea6178cb5e33..b07d5888db14 100644
> --- a/kernel/trace/trace_kprobe.c
> +++ b/kernel/trace/trace_kprobe.c
> @@ -1570,6 +1570,18 @@ static int kretprobe_event_define_fields(struct trace_event_call *event_call)
>   }
>   
>   #ifdef CONFIG_PERF_EVENTS
> +/* Used by bpf get_func_ip helper */
> +DEFINE_PER_CPU(u64, current_kprobe_addr) = 0;

Didn't check other architectures. But this should work
for x86 where if nested kprobe happens, the second
kprobe will not call kprobe handlers.

This essentially is to provide an additional parameter to
bpf program. Andrii is developing a mechanism to
save arbitrary data in *current task_struct*, which
might be used here to save current_kprobe_addr, we can
save one per cpu variable.

> +
> +u64 trace_current_kprobe_addr(void)
> +{
> +	return *this_cpu_ptr(&current_kprobe_addr);
> +}
> +
> +static void trace_current_kprobe_set(struct trace_kprobe *tk)
> +{
> +	__this_cpu_write(current_kprobe_addr, (u64) tk->rp.kp.addr);
> +}
>   
>   /* Kprobe profile handler */
>   static int
> @@ -1585,6 +1597,7 @@ kprobe_perf_func(struct trace_kprobe *tk, struct pt_regs *regs)
>   		unsigned long orig_ip = instruction_pointer(regs);
>   		int ret;
>   
> +		trace_current_kprobe_set(tk);
>   		ret = trace_call_bpf(call, regs);
>   
>   		/*
> @@ -1631,8 +1644,11 @@ kretprobe_perf_func(struct trace_kprobe *tk, struct kretprobe_instance *ri,
>   	int size, __size, dsize;
>   	int rctx;
>   
> -	if (bpf_prog_array_valid(call) && !trace_call_bpf(call, regs))
> -		return;
> +	if (bpf_prog_array_valid(call)) {
> +		trace_current_kprobe_set(tk);
> +		if (!trace_call_bpf(call, regs))
> +			return;
> +	}
>   
>   	head = this_cpu_ptr(call->perf_events);
>   	if (hlist_empty(head))
[...]
