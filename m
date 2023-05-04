Return-Path: <netdev+bounces-460-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 14BF66F771C
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 22:36:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4B4991C216EB
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 20:36:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B6534A959;
	Thu,  4 May 2023 20:36:34 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BD0AC12C;
	Thu,  4 May 2023 20:36:34 +0000 (UTC)
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5F9C1AEC4;
	Thu,  4 May 2023 13:36:05 -0700 (PDT)
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 344EF8Uq009944;
	Thu, 4 May 2023 13:18:11 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=s2048-2021-q4;
 bh=zQhmDN/NR8B5jQ7RPB07VAFUVws5NnVLaNn57dG65Ik=;
 b=KJNLA3nlQ3LkcDhfOGz3BzQ4NfZ9DGT+zwMZMqgLGp1FBfb8BlzeiEPYYQnEUM9/O0XB
 n8INV4mtZEp+fyGyTXSeqkZYLbJmYi5UWjk3Qhptm07FyG4hU7hdNpM0SlpVTPJevFsI
 D3qn0EK50oRt2ZcoB74oz7Qi4WXVEwX8Pmw/npRsv5d11aAd6l4N9cdhn8iUw6mZEbkP
 FKpeES281GorZkF7/KD+FNiy+Lj2KgluD/k3EA0SLsQT1obMYDk3BsohX862cFmwHh5S
 Ztj+bI/qAR9qgSDSsnaAr3TOL0l6wKtuyIgqbYLbqpkL8A97TOYmYP8qz25mdDjuot2X EQ== 
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2047.outbound.protection.outlook.com [104.47.66.47])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3qc1uaf49r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 04 May 2023 13:18:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gM2yhKxVGV4Y7PJ2V4jrRfkitTudXv7xmSXA54yWG1JEMb1cHYpLqZG1R/MISuqOuSiPEH4vZ6XQ3LFHgpRIlP8Lw6oz96TunboasBuOJ7A5DArCkjtLDpmudct40ddZYX4UG1SqMQnzVbxo2MRCk6DfKUtZYI7OM4szwc/Ni2QyVc7qJcUJpazpL358ufCPAJHOWSTAhfAwk6iKQx6TidnW5P7wCDJXmeLrDpReP5Wr3+k4EnUnAY97/FUsDAdnA8oqAWhzi4/PiLEvDvHUFZ5CIjkBzwmeP/rwrCr64rsUyhb3JRyxGEJkCTOSNCS8CGCqv55qtfOXVfKOWLpXAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zQhmDN/NR8B5jQ7RPB07VAFUVws5NnVLaNn57dG65Ik=;
 b=i4Fk7jmkkmh6kWhYojM559rzKXU9VaHunSF94rQT3yIgOGieWEfOV3uv5JaNVwDjQPIOeKxzCILZDIlyzz2XKjEOUGjNOQoM+XEH6BPwGbClIAlx0EEUiOwN5Tu+DpP4WvitqyenpHRfJlae1jLr2UR07JGOBg4cWvcALW9ijjA6y9kzItyH967S30YqQTugerS1krfLlTZUELm5YEgWPYwU9y+BO5iFvvRL7ROnejGhuraTunzgqXDmb1E/S6oXA3TrtAtBhtnGJSY2Fzy9SBwL6498l/GTZiAE8c3cEa/9ztA0V/GS3dRiv4VldK75eZZoahUbt8LND5HvA4npwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by CY5PR15MB5461.namprd15.prod.outlook.com (2603:10b6:930:37::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.20; Thu, 4 May
 2023 20:18:08 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::589f:9230:518:7f53]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::589f:9230:518:7f53%6]) with mapi id 15.20.6363.022; Thu, 4 May 2023
 20:18:07 +0000
Message-ID: <2cb24299-5322-6482-024a-427024f03b7d@meta.com>
Date: Thu, 4 May 2023 13:18:04 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.10.1
Subject: Re: [PATCH] bpf: Fix mask generation for 32-bit narrow loads of
 64-bit fields
Content-Language: en-US
To: Will Deacon <will@kernel.org>, bpf@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Krzesimir Nowak <krzesimir@kinvolk.io>, Yonghong Song <yhs@fb.com>,
        Andrey Ignatov <rdna@fb.com>
References: <20230502165754.16728-1-will@kernel.org>
From: Yonghong Song <yhs@meta.com>
In-Reply-To: <20230502165754.16728-1-will@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PH0PR07CA0075.namprd07.prod.outlook.com
 (2603:10b6:510:f::20) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR1501MB2064:EE_|CY5PR15MB5461:EE_
X-MS-Office365-Filtering-Correlation-Id: 04317eab-859f-4422-43d2-08db4cdcac56
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	E0kdwSNZm9HSj0LNSITHRj+ae0Q9rU8B/J+JdfKO6Csfy0UscNs/bm1Zp/NyQNzGXBBVZiYbrQOP+m4KH9FU0mdV/+dcAaabvr8ddTdaqpU01tmdHQkP/lEL68fmeMPPuSIUEr8zkL3XibcoynRndBZpwoEkDMG9xmG+JQ6NKiWPFGQD6WQsToJJy6xHxXHhYyLxsAzOfa6mlNgzL9ECbApJS+B5UGLxnjqaR7lwf3ya4auF7GYeuty5RklIY9n7z0mdynRqCdpGYIxMgr/3dpb352KS+uAS+oPKsfz+e+8wQR+pgJX7SQpvgSL0E9enF0zy5pzlbUVl/qloMdeX52qVL3nqEMFSEyF5me5qNpZo9CEEHXcYlt5ewVjLVKWDDkG72ppYTqooLHW5Jgs1lGderuRGjRA90kMmCWYtGEOaTG8x1wucEJIrRhwJ0RqgudP69n0nsbki+IFQKKtngVsWlvlSjY98N9Zxan7M+8mc2lT+WDReSZfaUD/EIDJBFNq9NCRi3ZtlrBtPEbLzxjb25+t56HiGvfXFE/etz5YYydq1xRWCLF9ENmOQ6My2zf2RTvC8uJuzk+JEfnrgHl7wOagrLdAvG8AZqBmJrdZELfJXK0Hoih3i5GcvREu/qsaV8Sj743JHnJ7LTs/rLA==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(396003)(136003)(376002)(366004)(39860400002)(451199021)(31686004)(2906002)(66946007)(66556008)(66476007)(86362001)(2616005)(31696002)(5660300002)(8676002)(8936002)(316002)(4326008)(36756003)(478600001)(6666004)(54906003)(6486002)(41300700001)(6512007)(53546011)(186003)(83380400001)(6506007)(38100700002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?L2l0ajlvK21jR3Z4NzZlc0dZajRhOXptbnpZbDlJODlpVjFnRXFhTnM2TE53?=
 =?utf-8?B?bDdxWnFaZ0tpNGxrK3Zza1NRRzgvKzB6aE5iaWMveUVtNGVmOFBBcVg4V2Ji?=
 =?utf-8?B?c3F5VU9ZWndVUllMOGlVN3ViOG1jcm5CbVFoOWRVejE0bGZxRjZiTjdzMm1D?=
 =?utf-8?B?MG5COHlZcm9MU1JlVURZSnNnd2FqSzE0ckZEekV4emM5RllBZkhMZE5CYXFR?=
 =?utf-8?B?Ni9KeWYwb2daYUxVT1BpR296UTF1ZGpuUk5qQUpXdVJsNnlJNzlsbllaYzlU?=
 =?utf-8?B?NnJhYklybWlUUlRMR1oreUJHM3NOby90ZlV5MlBmaW40QzluQ2dEVVQ0Vm1p?=
 =?utf-8?B?NHl4dEdYVGdqOU4rTHFSeUg3SmwrWHhwUDdidENGdXB3bGJhaFRkM29WanpU?=
 =?utf-8?B?WTJCcS9TYTlLYzNuU0JPNzY1cndzWmFXM1paSWJTbEZNL3JjeXg4dCt3Wi8y?=
 =?utf-8?B?d0wxbmpGYmRzb2NJUzcrZjd0R1hrb3g5MXdiMnJoSDJVeGpWd0lkQ2M5MEta?=
 =?utf-8?B?Y1VmTzJndGtSUG1Od3hMeWxPRW5MMU5lTlJIVVo5R2o4K0lxZktrUk9yd25J?=
 =?utf-8?B?TmFoa0pJY2FxNlpMMm5YcnBtZkp5RUM3Z3BuK0VNdTBLTUpvRWdnRkh0bFhx?=
 =?utf-8?B?U3hkYUdjQ0pBNi9qbytaYnZoU2FSWjg2SGVlbjJEN1F3Y1EvaEN1bmhwdHJ1?=
 =?utf-8?B?WUtXSHMydVRQZHg0T3o3VmpFdy9JcThRSmpVNTJrRi9rVGJ3MVc1QlNFWTgr?=
 =?utf-8?B?MGcwenBqQm1YWXFtV1owMHZQL3M2ZXFMZ1hCb3V0eFM2cWNBSGRtekp3d0Nl?=
 =?utf-8?B?RzNtWlk0UUluRlZTWjFQUUEzUnQxMW5QM1kyNEVyaHFRV2U1dis5NjhzVlZy?=
 =?utf-8?B?TjJtb25iV3Vpb0hGVTNyNUZCNVBiaWlsUEMzNG5VK3Ruek1ZcTBXTnQveGNx?=
 =?utf-8?B?T0s2UTZRSmx5Z1puNFZXOHdnajNHYWpvZFE0NDVZTHZtOWtlVUp6SXlJOFFC?=
 =?utf-8?B?M05OOEVqU0llK05FL215UlZmVnc0ZHZCODExYlkxd2t6WUYyWnZJVjhyUVdh?=
 =?utf-8?B?RllVazUvZDZuSmtpTGlMUnNSMmhQbEdhTmRadHZzRkY5cGQ0SFZKTTM4ZG00?=
 =?utf-8?B?SHYxd1Rycm94S0xLNWRmYncvcEsyWTZWOTNGaUt5d0thT0dtOG44N0F5aS95?=
 =?utf-8?B?RExVTkFmQW1KaUhqOUNtMWlyYmg1Si9BR2RWajkxK2MvOEFVLzFqaDFCSjhn?=
 =?utf-8?B?ZHZWVWVvUDB0OFFRMktMN3RnZitmRGVPN3pzaXNFVlJ2Q0o3M2licFFUdm1l?=
 =?utf-8?B?YS9QS1MyTVhMQ1lEZERnUzVGbmx6bkpEa1ZNMVZhSjBLd3I5SndOSjN4Q2NZ?=
 =?utf-8?B?QnlQUEFRc3NFaTJ4c0Z2d2Nxb01wU00weUJvNHEvOWFXWjAzaDlwL3NUM2xi?=
 =?utf-8?B?Z3JDOHBKNHdMNXB0a3k4V1plcThubE1ENVdnYVZCdHZidEVacktVcm9OQ0tE?=
 =?utf-8?B?Z09mTUdzSWg3OUtjdHhlVnFmd0M4NERWOXd6aWpHNE43SE1GZ2xISHBKVTJm?=
 =?utf-8?B?SGxaUVM5Q0kvNTZVQ0JaQklsMy9UWDI3N3pzaittNnJTZjBHTENzUmJ5cDZH?=
 =?utf-8?B?ZCtwZE5IdTlxVmVvTFE3ZkVyN21FYnQ5eWdUN1F0VWEwRGtpTFZ0YllPTzc0?=
 =?utf-8?B?Tmh2TDhnb0Q2WW1OUXFuUkNQRndTNVQ5N0Mzek5vRU1ab09lbVFhV0JscXFV?=
 =?utf-8?B?SkhkRTJnN2ltVStkbUc2WTlQZkJQWDRSakJXVXRiYzFXbG9wQ0c4clNJbHpZ?=
 =?utf-8?B?RkFINytkcGE0c0VrL3l1cWxoZm1xRUFaVkkwbHppMXlkUWpmTkFqMGxsT0FN?=
 =?utf-8?B?YXNiQXNOZ1Z2SWVpTmJpcjlJUG9JV3ZsRi9mZ3BieWdFTjVpdXVlZTRmQ3BD?=
 =?utf-8?B?ZzlSNEhvWnJncTRCTW13SnkzSVc0czc3VUVsYUdibWI1TkN5TGorNlpvSHps?=
 =?utf-8?B?OXF1UkZ3eUNzMFpWcTJINEZubWJXT3IxVUY0T09FbzhIMVVTazIxVEc2VS9l?=
 =?utf-8?B?a3JHTnM0cm81RDByb1ZZeGVJeVhkemR5NFZoWjB6M0pwN0VodTdwY1BvcmNN?=
 =?utf-8?B?Y3Rrczk1V3FUZnh3Ni9vUDh5RFltdG4vRzMwOHgwcTVLWnVrWGlsbHd3bXhS?=
 =?utf-8?B?Wmc9PQ==?=
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 04317eab-859f-4422-43d2-08db4cdcac56
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2023 20:18:07.7883
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VHsvvw44F2ljlilGvYPHTTLEo9QpKv9G8H8mvS22rseL/FT9qhhrGerI3sjW9Svg
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR15MB5461
X-Proofpoint-ORIG-GUID: qiQFf_lgz-37Acz68ciS870iHaqgMFYU
X-Proofpoint-GUID: qiQFf_lgz-37Acz68ciS870iHaqgMFYU
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-04_13,2023-05-04_01,2023-02-09_01
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
	RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



On 5/2/23 9:57 AM, Will Deacon wrote:
> A narrow load from a 64-bit context field results in a 64-bit load
> followed potentially by a 64-bit right-shift and then a bitwise AND
> operation to extract the relevant data.
> 
> In the case of a 32-bit access, an immediate mask of 0xffffffff is used
> to construct a 64-bit BPP_AND operation which then sign-extends the mask
> value and effectively acts as a glorified no-op.
> 
> Fix the mask generation so that narrow loads always perform a 32-bit AND
> operation.
> 
> Cc: Alexei Starovoitov <ast@kernel.org>
> Cc: Daniel Borkmann <daniel@iogearbox.net>
> Cc: John Fastabend <john.fastabend@gmail.com>
> Cc: Krzesimir Nowak <krzesimir@kinvolk.io>
> Cc: Yonghong Song <yhs@fb.com>
> Cc: Andrey Ignatov <rdna@fb.com>
> Fixes: 31fd85816dbe ("bpf: permits narrower load from bpf program context fields")
> Signed-off-by: Will Deacon <will@kernel.org>


Thanks for the fix! You didn't miss anything. It is a bug and we did not 
find it probably because user always use 'u64 val = ctx->u64_field' in 
their bpf code...

But I think the commit message can be improved. An example to show the
difference without and with this patch can explain the issue much better.

Acked-by: Yonghong Song <yhs@fb.com>

> ---
> 
> I spotted this while playing around with the JIT on arm64. I can't
> figure out why 31fd85816dbe special-cases 8-byte ctx fields in the
> first place, so I fear I may be missing something...
> 
>   kernel/bpf/verifier.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index fbcf5a4e2fcd..5871aa78d01a 100644
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -17033,7 +17033,7 @@ static int convert_ctx_accesses(struct bpf_verifier_env *env)
>   					insn_buf[cnt++] = BPF_ALU64_IMM(BPF_RSH,
>   									insn->dst_reg,
>   									shift);
> -				insn_buf[cnt++] = BPF_ALU64_IMM(BPF_AND, insn->dst_reg,
> +				insn_buf[cnt++] = BPF_ALU32_IMM(BPF_AND, insn->dst_reg,
>   								(1ULL << size * 8) - 1);
>   			}
>   		}

