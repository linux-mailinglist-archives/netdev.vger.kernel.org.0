Return-Path: <netdev+bounces-9365-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A6DE7289EF
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 23:08:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 886B71C21016
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 21:07:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C03734474;
	Thu,  8 Jun 2023 21:07:58 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B11431EEE;
	Thu,  8 Jun 2023 21:07:57 +0000 (UTC)
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B71F2D42;
	Thu,  8 Jun 2023 14:07:55 -0700 (PDT)
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
	by m0001303.ppops.net (8.17.1.19/8.17.1.19) with ESMTP id 358Gmvaa020704;
	Thu, 8 Jun 2023 14:07:11 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=s2048-2021-q4;
 bh=n63nSmaJuUIoK1z2sPRQ4AfXZLgi0W4CcBjJZp2U1xk=;
 b=SGyiU3kyk73AlxxlhOo8+ommK54fye8xSPI2cQeJ+CnU+/txGJaPhnb71JELAaeDUT0v
 gl0Ck4adRxqe5mJ+9ioncAVVzQIx+84JuCTEshBemeDE2ZwWNEYHm6+aHGVpk2nVKfCd
 SVj35SEwiPy7yBDiIQyxoFGLzyjBNbLeqwOlLlY7rOQRwPO9o/CHRyX43hvIA2Sx14tX
 HfbP4nJ7nd1lAqgxjLZ7rO3laMiSjSy0zEakjZCwqbXPPGK7QMGzIyO7BYhDq90aGcQo
 6mLYJRzcfuKZYkn+KV8pmEskOJ+I8iTd+vMTIS6GWwb/Cr7H5zS81a9mtVWbaPinLFx3 YQ== 
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
	by m0001303.ppops.net (PPS) with ESMTPS id 3r34d0yaqr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 08 Jun 2023 14:07:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ahBET+gjuCryrG72W7denPT0LUI8KM0C9UnjHKBBdOQZ0Y3zLsyQBbKMGqbEcpNUGyln3QwLhYmakYPacc2/hSylirD9u2zXq58miUDF3E5zdCwgFWBVkCrYLybnd+zkNAqV/BFo1sJE3tW0Kln4kZyJbZh+v4hRDhyWxPtPHRb/4FzrdWpo6mpz7N5d38HE0iRQ2P1ApozEP3gd84l7BogpxV2z0zVftUiJoYgpNlHxW18jpjflpGeckwM3DxN3rdHV14L52Y5Pslhql7O7q1Mh4Xu9WDnhikSDiSJbaSBGGBCFDZlAjasDcUCsJ8GM5UdSmRzwz7bqcIPbbUUrrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n63nSmaJuUIoK1z2sPRQ4AfXZLgi0W4CcBjJZp2U1xk=;
 b=hQ/mb9RFn/R4sozFZCo/FU1LqvzcSitqkbTJMcdv+f3wMk7iJgbL80cFCwlBL4x9txz1adj5Lg0R6l0D++YjIcaGc++hA37/5xIqWxejC8M5maLrAD1gusatb7wEcPj2PW14Oe6OMHlUFWcJZnEYTkp/c5iuR4/v1U2fwRjWLq+gUkcpf8qls6SyRoYOXFkbxbvQR+lqT886bTPM6y/CrxxTcp4XCu2g9WUNVThnnQeoowDM4JLdNgv/JhYpbD45KguU5ocqSWSFchAKFBUxSqO/z0BUKC8KUWs0TaciI8bsgfPlBIc3b80PlThoPmg8o53A4o9HaeRMAy5ZIDJJNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SJ2PR15MB5647.namprd15.prod.outlook.com (2603:10b6:a03:4d1::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.36; Thu, 8 Jun
 2023 21:07:09 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::bf7d:a453:b8d9:cf0]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::bf7d:a453:b8d9:cf0%6]) with mapi id 15.20.6455.030; Thu, 8 Jun 2023
 21:07:08 +0000
Message-ID: <4ca27e23-b027-0e39-495b-2ba3376342cc@meta.com>
Date: Thu, 8 Jun 2023 14:07:05 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.11.2
Subject: Re: [PATCH bpf-next v3 1/3] bpf, x86: allow function arguments up to
 12 for TRACING
Content-Language: en-US
To: menglong8.dong@gmail.com, alexei.starovoitov@gmail.com
Cc: davem@davemloft.net, dsahern@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, martin.lau@linux.dev,
        song@kernel.org, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, sdf@google.com, x86@kernel.org,
        imagedong@tencent.com, benbjiang@tencent.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org
References: <20230607125911.145345-1-imagedong@tencent.com>
 <20230607125911.145345-2-imagedong@tencent.com>
From: Yonghong Song <yhs@meta.com>
In-Reply-To: <20230607125911.145345-2-imagedong@tencent.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0086.namprd13.prod.outlook.com
 (2603:10b6:a03:2c4::31) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR1501MB2064:EE_|SJ2PR15MB5647:EE_
X-MS-Office365-Filtering-Correlation-Id: d781b75c-4733-41f5-6d3b-08db6864520a
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	mhbHtT4SHGVbjeG9+peYTt0TTV7rEqv9lHgRArqxTHCNuMGnRpyIPIj8pLZbY4oERhHtcDW36KooCZGu6rjWd7cmwVh+9nCZ6sVgqlq6XnqwABaaY3GcXbK7cFhg0FVcwMhXZ248/Thh1233YT62SI8seMFlw13pPGw0YKBT7BCsrkhyo+X7l02T+g7pQDBLBTXAfc0iqEHAZv/o6bpEIbjiMzu09bdk2refV2xC72OUKPvks7lJOea5H2BiXN6qaLcWzoDvkEAbKuuSkdpAU+OfYsPef2AkHu/yN+R5NIPoV3Uuj1mCnrvuBPPmDR4AzMISidoRARNBCiTJ0Gm61Pl6R7SstRaH6Wp01DeH/MadvDNhkMrxmj9uq5LB6bhvrAPN91gR6eiDunBQmanBjm0bjWVbWUog+po5yIGN3xIxAffY6KlC1umesiT4aLlN027tGrVUZgMG7eCGl7GxooBpOprGeowfGbn1z2VIMbOD8/czEp4iO35W1hRAwJ8wXgeE9uU0OAgdLp2apoZm8VvxEJrA0BrE2/kEV5g76aGqn+2dS+GBk5rmFwP0PY+s89/V6mCchOIT7rGCUQcKmRSEROxGKZ+7EwBHCz5kRXdhPa0gfYY4j2wHLm4rOsC4jW6lKAr/FXTMKHh1sEgdhw==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(136003)(376002)(346002)(396003)(39860400002)(451199021)(31686004)(6512007)(6506007)(41300700001)(5660300002)(186003)(53546011)(36756003)(7416002)(4326008)(66476007)(66556008)(6666004)(66946007)(8936002)(83380400001)(8676002)(2616005)(478600001)(2906002)(86362001)(31696002)(6486002)(316002)(38100700002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?UG12aUVrWGNFL3FCYllTRGVqSVhiZytIRUJxRE95NE9IRzlGd1NQM3JDUXB6?=
 =?utf-8?B?ekJzWUY5WnR1NXhBUThSUzAyWXFqVS9iQjRZVWlGZnQ1MThqOHVHaWlDOWZ6?=
 =?utf-8?B?d2FlNzYrLzV5L21ySkVJQkFGNGJuNnNzNzFMc3hBbm1YR1JoRFdoNFZmQjVV?=
 =?utf-8?B?RlVkMU0wMGFqZEJHejZpbkp5RExkQUtyZlRzMndjLzNXcDk4emcrOHphMlhD?=
 =?utf-8?B?VC9VUVBiVUhoU1ZKN2RPek9UeHlmSGZNSVFNeXMyT1ZhZ0ZPS09UWm5QRUFF?=
 =?utf-8?B?MWxVNVROclFtbnZuaERBclFjbG8yN2hjZkVBOC80Zjdmd0pXWE1GSnVIQUV5?=
 =?utf-8?B?R2NDMUxIZXEwS2RCNnVSdDVLbnh3ZFZxVTQwYUZHalZyOWxCT0tGNFozL0hv?=
 =?utf-8?B?SWdNeUN3aTE0dm45RisweVJ0NWlYaUl1S0N2YkdNbTVLTW1ISlVpUGFjTVky?=
 =?utf-8?B?bWhIWVZNWTJuT3B3eTd3anU5QU9WV1cxMWd5bC96dGZMY3RjSTcyWXRoaVJH?=
 =?utf-8?B?VTY4VzVRaldLQ2QyZkNKenRlMmtIV1RvVzdTUTU2R3pOZVFXejBuRGUvWFpC?=
 =?utf-8?B?cWhxWWhMNXEzckw4czRwZGdzb0xuQ0p2bGp2a2R0a1dwWVRid29HMUpheEdE?=
 =?utf-8?B?YjB5eHNCcXA2ZDNSaTRTZlNSbXZkVVM5VHFKMHFEaG9LOUJ1UVdraXhKRDVp?=
 =?utf-8?B?ZHhGS0xmcFp0bktXd1hZLzVadDFDZUY3Uzl2T1d5cHRGc3MzQ3RTVTMzeGhF?=
 =?utf-8?B?dGM2bG96U3BJazRPdUNHZ0cwMFoyZndGK0xscE1CYlhVMHN5OXZMK0hPbFpq?=
 =?utf-8?B?ZDdBN0tzWjdwbUF3QlB2SGlRWS8zaWZIYkJlaVk5Z1VxK2orcU8rUzNiTEUw?=
 =?utf-8?B?ZnBOUkhrbFlQQ25jY2hWNUxqTzduNVdnQmNGOG02MjNUenpiaGNTV29OUkQ0?=
 =?utf-8?B?UkZTdjRNYVE2L2JZTXp1dUIybnM5Y2d2eU8yZ0pucFo3dVN6dWV1RWU0MFlR?=
 =?utf-8?B?M2Q0QUtOWHBlaDM2UUs5YWlySmtjZ0JnMzNlVXdxSE84c09xekFSSFY0S3cr?=
 =?utf-8?B?eFZMUkk5Rjc5SmJ4U1gwYjJOcHJHMUdoRm1HYmhPbEFMajViQ1VTaENNKzRF?=
 =?utf-8?B?WndzWUdkYi9iT1NtaTFLRzhwdm51ZHQrZEFaZnlReUh0eXJnOGYwNGQ4LzUx?=
 =?utf-8?B?UW5mY2xKN1hQby9TbTl2Z092bjhpbHZXaVVUYzMzRDFEbVdkaXQ4VTM1RWQ4?=
 =?utf-8?B?bmhObEk5d2hWODVLQUVkWWRDVlA5YWNIR1krby9mMWJEWWMxZ2E5YnYxeXNJ?=
 =?utf-8?B?MVZaYmFsekI2RUtjRFVnSVp0ckJWU1VxVGJoVFU5VGxWU0RPblA4NDUySG8v?=
 =?utf-8?B?U2padUpNY1lqdXN6NW5JUWtYREJ6a24rUUp1MGcvUGZtM0hIQVpLamFKMm4z?=
 =?utf-8?B?YUNGclp0a1F2dWJYQVBOWGJKS1ZDQXVQRCtrVmMrbnc1WGg0MFJrcVdBRGtz?=
 =?utf-8?B?RWtIT0hRRFZpanFheEJlczQwaEZPcVVOY2VzRzUvZjNGMHZoZDNIWk5jQkp2?=
 =?utf-8?B?KzZWK3kvNHZrQ2o1bldSUGVLT3krU09ZUk9WY2ZCU01ud0dKK3VPUGEvWHJ0?=
 =?utf-8?B?QnBHeDNFSzZZejhHSzg3QWp3RHRKYkdZbUtLaUNvU253dVArSnpkUHpMMVMv?=
 =?utf-8?B?MVVFaGh4bUpzUFJWMEZIWDJScmRBUXJHZ1A3bWxRMVdlVUhBU3FtYmtZd2to?=
 =?utf-8?B?RVN0SldFa2hVMmMzRGZlNnpOc3NrWmhUUTJxN3lVb2JvRWNlMnpiTFJnVU1G?=
 =?utf-8?B?dlluNGM1dElBS3RxSEI2ZVBMMU1MQjJkVWJkWVVWeHo3OVdDWXZqUGxmeTV3?=
 =?utf-8?B?azVwcWxWVk1FSlIyYXR5bTRhNDljSXEzckhEb1JQQzdYanFlNjNVem5HcnJW?=
 =?utf-8?B?ZjFYbHRsUVhHbkZ4VHFvWjl3U3VuaHVUR2pFU0xYK3JsWFRGRHM3bW84UUM2?=
 =?utf-8?B?MG9sZ1IrQWx2SU9kSDVJZVg0NVI4UE9vb3IvYVpMdFVHbFNQb2FwT0pjMURW?=
 =?utf-8?B?Q00xUURJZGh6YjFhU2RNb3FydThFS3FBQ2ZjbHljbFpBejZiNE9OOVdnK1dY?=
 =?utf-8?B?T0hRV21yL3VIQW9YaVA4ZEJqdWhFSy83YjFWT0pCeWt3K2QzRVQ2SWdHc2ty?=
 =?utf-8?B?MFE9PQ==?=
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d781b75c-4733-41f5-6d3b-08db6864520a
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jun 2023 21:07:08.9294
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qSWejcwrRj5TwA/CTWfDHqTWtaVG4UtUrNfnze6Y307H5qyX45TW/kPN2oc6P7QA
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR15MB5647
X-Proofpoint-GUID: 2JpqSjwo74rTcOOZSe2HqLP4KWF56roJ
X-Proofpoint-ORIG-GUID: 2JpqSjwo74rTcOOZSe2HqLP4KWF56roJ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-08_16,2023-06-08_01,2023-05-22_02
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
	RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



On 6/7/23 5:59 AM, menglong8.dong@gmail.com wrote:
> From: Menglong Dong <imagedong@tencent.com>
> 
> For now, the BPF program of type BPF_PROG_TYPE_TRACING can only be used
> on the kernel functions whose arguments count less than 6. This is not
> friendly at all, as too many functions have arguments count more than 6.

Since you already have some statistics, maybe listed in the commit message.

> 
> Therefore, let's enhance it by increasing the function arguments count
> allowed in arch_prepare_bpf_trampoline(), for now, only x86_64.
> 
> For the case that we don't need to call origin function, which means
> without BPF_TRAMP_F_CALL_ORIG, we need only copy the function arguments
> that stored in the frame of the caller to current frame. The arguments
> of arg6-argN are stored in "$rbp + 0x18", we need copy them to
> "$rbp - regs_off + (6 * 8)".

Maybe I missed something, could you explain why it is '$rbp + 0x18'?

In the current upstream code, we have

         /* Generated trampoline stack layout:
          *
          * RBP + 8         [ return address  ]
          * RBP + 0         [ RBP             ]
          *
          * RBP - 8         [ return value    ]  BPF_TRAMP_F_CALL_ORIG or
          * 
BPF_TRAMP_F_RET_FENTRY_RET flags
          *
          *                 [ reg_argN        ]  always
          *                 [ ...             ]
          * RBP - regs_off  [ reg_arg1        ]  program's ctx pointer
          *
          * RBP - nregs_off [ regs count      ]  always
          *
          * RBP - ip_off    [ traced function ]  BPF_TRAMP_F_IP_ARG flag
          *
          * RBP - run_ctx_off [ bpf_tramp_run_ctx ]
          */

Next on-stack argument will be RBP + 16, right?

> 
> For the case with BPF_TRAMP_F_CALL_ORIG, we need prepare the arguments
> in stack before call origin function, which means we need alloc extra
> "8 * (arg_count - 6)" memory in the top of the stack. Note, there should
> not be any data be pushed to the stack before call the origin function.
> Then, we have to store rbx with 'mov' instead of 'push'.
> 
> We use EMIT3_off32() or EMIT4() for "lea" and "sub". The range of the
> imm in "lea" and "sub" is [-128, 127] if EMIT4() is used. Therefore,
> we use EMIT3_off32() instead if the imm out of the range.
> 
> It works well for the FENTRY and FEXIT, I'm not sure if there are other
> complicated cases.

MODIFY_RETURN is also impacted by this patch.

> 
> Reviewed-by: Jiang Biao <benbjiang@tencent.com>
> Signed-off-by: Menglong Dong <imagedong@tencent.com>
[...]

