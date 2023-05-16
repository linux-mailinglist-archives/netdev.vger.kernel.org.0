Return-Path: <netdev+bounces-3056-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5B0157054B8
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 19:09:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 52A371C20F07
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 17:09:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 338C1101D5;
	Tue, 16 May 2023 17:09:18 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1174C101C9;
	Tue, 16 May 2023 17:09:18 +0000 (UTC)
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD1613AB9;
	Tue, 16 May 2023 10:09:15 -0700 (PDT)
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34GFmIQL027483;
	Tue, 16 May 2023 10:08:56 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=s2048-2021-q4;
 bh=MQlgpSdoXcxOjPgeVjAJdNybHAzVpUE+Y2jzBDtHqP0=;
 b=cwUEQcsPRJhYNHqSeDc2PPQ8q2IP55IRux2kYUsUdO9+Puas7fRojqNqpcOpvkdssaya
 w60QG4y3IKXol8N58IvdAC1u7iw/OQEZ94my78WTjqcitg06381kQsGTTWiBtJMYCKcc
 n1i0OMDShjGPrNNdZ7Jj94mlyKV8+yCTAkLVrH2nYdGvUmQvWO3SrSht26EuQPt9EMfo
 cpR0gej/57ylYs7vYkcuKOVG1RGF8qcsVJeYi+Pqrz59cxlmDC/x7WNdVwP/hChk3JFl
 vjHd4NgnWj7voWGgjWGSn8PJOq3w1bPdUn7w4O2n0eJ1TnVs6Z06uW6GpwaUuPd39jgL yA== 
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2175.outbound.protection.outlook.com [104.47.55.175])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3qm2wv4mjq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 16 May 2023 10:08:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fyhIvqtT/FtarGSDAiEiPaMpxSPKgBvvtt4WPiiVx/BQZtEnbQse11ov7y0ANWbc5AAiuj72g/x3/Qqd+yUgRPKP9OfY4F15rG5pSQF6pLGnFvK7CsaF9uDK+v3kH8pHpVNVKrZg6x02G0HxuQ5qttBrPm3aohBpMpQ2LOQUG5oJdLbJmoujYftlImrfzRRmx6r16xS6As23oTYbLCAfBJa7/I/9OpXdsuSxBs0gzdpa6Jjh644Bgc+Pd/Jp8jU6WIIW7DWDPYI/yHoTkR4FYNDcSskAG8FpY8cMwdpGGASNDVyLViOvVjH4iWSNLMVdKOV8twQGysSGFzi8AKGKmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MQlgpSdoXcxOjPgeVjAJdNybHAzVpUE+Y2jzBDtHqP0=;
 b=RpScDkldpOZ0+L1ZvykYwBtGhFJFnGExvob1JXZQyLYn4c3V2/jaHLtXCKQA4ulZnF62ewoq7rB/zit2ebbfiEJzVzhhHYrObj6bqohCqwU/18099+UuGP3rXcuqYClFRZalQrwiWwqikVyhFzPHMVY6R2dWJWNuHxa33BXDCPSJF6l607qVlvoELy1V4psfVFO2zGhQW5xCEnQ1dSOjyi0aOoaO6FVppuUXM6qF4+UTGMGRge1cR8qp9p7wlYCJnrdz5lmjL2/gnFGAhNnqrlz6MS/g130KR2GorEqzSLwyXzI+PPLlRTzPWQNS8mTHK7f30hOZxe3AUkmR/kApJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by IA1PR15MB6292.namprd15.prod.outlook.com (2603:10b6:208:444::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.30; Tue, 16 May
 2023 17:08:21 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::589f:9230:518:7f53]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::589f:9230:518:7f53%6]) with mapi id 15.20.6387.030; Tue, 16 May 2023
 17:08:21 +0000
Message-ID: <e37c0a65-a3f6-e2e6-c2ad-367db20253a0@meta.com>
Date: Tue, 16 May 2023 10:08:17 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.10.1
Subject: Re: [bug] kernel: bpf: syscall: a possible sleep-in-atomic bug in
 __bpf_prog_put()
Content-Language: en-US
To: starmiku1207184332@gmail.com, ast@kernel.org, daniel@iogearbox.net,
        john.fastabend@gmail.com, andrii@kernel.org, martin.lau@linux.dev,
        song@kernel.org, yhs@fb.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org, davem@davemloft.net,
        kuba@kernel.org, hawk@kernel.org
Cc: bpf@vger.kernel.org, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
References: <20230516111823.2103536-1-starmiku1207184332@gmail.com>
From: Yonghong Song <yhs@meta.com>
In-Reply-To: <20230516111823.2103536-1-starmiku1207184332@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR03CA0141.namprd03.prod.outlook.com
 (2603:10b6:a03:33c::26) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR1501MB2064:EE_|IA1PR15MB6292:EE_
X-MS-Office365-Filtering-Correlation-Id: 192cc242-ae36-4161-8bc2-08db5630269c
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	/ANNYl5wJ/kGBDaB59dru8pW4et6Uabyo1u9Pb5yK2m+Ymy7SWYwa6f6wBSMHv7JsIYhKIc5JiKpkAFj64LfH6LY6OwNxPDMxEkRVSvMMhfOsq4nlLWndQe/N0Or9JiquxQVaeG43wBLsPJHwHBemihKoqA7aXd+sFpoEqxNaZZqnEhwJ4TYT5541hMzy2C3lSB5Zu/TpcNi5gvCgb4X+iIflpSnrjWJgllnX1bPgUSfZng2QM3lU/u370ua1lcP1/8Zo8q1ievf5fxsu/eCEzNuxSCVDYAqKw3iE82IHCY+VVWfIQR3dpWdH2rk1K5VurWkiYVlMEG8C12uoESuD+P469WXmMLLnmkre6IgpDexqtPEMzasNsAm7TJ8e4AyRHA0S4bmvLyab7OvMAaA4oDmIgSXz7whVO1haS8fPO8fXx1znlO8NNNXk/WfqwbKnEUL0UIvDYAvho4yKme/eDP4OyD5cdNzhjyV5H5MVPat3OimTNVgzuxymKV1Jg2yHxJo8eEiDw2bmpke+IAEjDY/JIH1eIUXjMoAIh5HYgfXvuqtrkwRKKbOnAwkeGBlSoUYD9zzzQXXgS3O9e8HtbBXvYLRHe40V/f8rbI2Dg64MNqLIzGskuoZwHwEE8rLGeuTswvcFBFshX1rUyVi5w8b0mt27ecNdI3LJSGHF9A=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(136003)(396003)(376002)(39860400002)(366004)(451199021)(83380400001)(8936002)(31686004)(7416002)(8676002)(5660300002)(31696002)(316002)(921005)(86362001)(2906002)(2616005)(186003)(53546011)(6512007)(6506007)(478600001)(38100700002)(66946007)(66556008)(66476007)(41300700001)(36756003)(4326008)(6666004)(6486002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?TFd0TEowMy9OY2o5R2E3cGZ3T0xiaG44dFdXQUJHTTRINEVVMnNLSWovY3B1?=
 =?utf-8?B?aHdzV3Q5MHBmeThZRjhYeW1NYW5OY05YNVRLRmFla0J3ZFl6QWRDNUc2VnBQ?=
 =?utf-8?B?NWVlVHh4S2gxS2RMQlR2VFNZZFdmMWZDOUNCaDJpTkN4QTJqYUN0ZWsxZjhG?=
 =?utf-8?B?UFRaMENtV2l2aStZNXNraVhaLzl0Wk5ndFBZcTkvRjFTSWJiVFFqRTl4QWNx?=
 =?utf-8?B?Y3RrcjhsRGdMY0NheS91Q2tlWXIrNDJzNFMzM3djaU1yRURCNkVacTZvL2Rs?=
 =?utf-8?B?NzJwRHVza0FDWWJWbU4wdGtiSWRGZUdGZDJBWHpaMnh3VkthUHlveFBDSDNN?=
 =?utf-8?B?MENSeW0xRXNrNC9iRURXME9VZlJOY1ZKa2JyVlBMUEsvV1BuNW84ZlNncFlw?=
 =?utf-8?B?bmJJckwwamVlNEFGei9ZNm5OcTBVNGk4WnhEYUZUR1dnVitJT2xCOTFDMnlp?=
 =?utf-8?B?R3E3SEFsSVNocXBtUzFWSXZtQ1NWd3h3TTZ1dmlmT0VKL1lrN241WkVYL1Y5?=
 =?utf-8?B?NXNpMWRjY3dNQ2tvcE1abDRCL1QzWEdrUExpT0M0ZWk4ZVBzRXBndTVISzVp?=
 =?utf-8?B?TGxHU2NsLzRNNjQxbVJDK2oyMnZGR1VNVVRCMy92eUR3M09vZno0L3M1Y2ZS?=
 =?utf-8?B?VXFYaHdRbXdwQWlhbXpOeG01czltQ0l6WXlnTUxFL2phYkprWGF3cU0zOFpt?=
 =?utf-8?B?WDZZbXdiWmhlaW1wM1hnem1rTzZTRHNDQzE4L1hSSVFWMUpZUWZZTjBDTyt1?=
 =?utf-8?B?WHpoT1lJNytWdkNrcmtKWmZNS29OS1pNMTZvQitlZDdsRmJTVHpqWUp4ZTJU?=
 =?utf-8?B?R2RFcmYzbVg2Y3BOenRxb2NOSEpDb2xKYmp4Y3FNbU5NVHlyb0xqMXg2TStF?=
 =?utf-8?B?VjZvMzVpRmVVbzRHa3Y0Y1FIbG1vVFFQVm9nQXR6dHFxaWQzQ0ZMMDZLYjU3?=
 =?utf-8?B?Uk1Wc2JlRXNpZVNVdC9NUTdyeXRuZ1hoVm93Umc0NHEvMU5zbTJlQkxseWRs?=
 =?utf-8?B?cm5vTUJvVUwveUJBd3FSVG11ZmhhWFdTZ0wzWE94YWhXUlh2elhFUjdoWDFC?=
 =?utf-8?B?aFozaEcwTzI2RUpsb2dXWUxKOVB1bkE5RVVuRm5wSXNWdG83eXM1RHFMZWVa?=
 =?utf-8?B?cmFjeEhFK0FLVThEZGYzbnBjMlpnM1JOQS9PMzN2NjMvbksxR21XMkI1MGVM?=
 =?utf-8?B?MG5iU0xrWlhHTFdiWVNhMVBsbmFmZUpMQ2UwWjdyZVNlVEM5emk2ZE45Y1NW?=
 =?utf-8?B?TlVBYmg0Rmw3MkRxckh6SXhJc2lFTk5sc1RNKzQ0S1VDVnFhZ2h3emhWbDdx?=
 =?utf-8?B?a3pta1JubmJ2L0l3TmZwSlRnT3RYRm45VW5VQTNyb0tNTFBiMXN1RDF4Nmlr?=
 =?utf-8?B?anNhZzBRMFA2UWxpQkdjbEd5cURranRQUXBiWkprcFMvRmllWVBMRUE2QWpY?=
 =?utf-8?B?ckZycHhSUXo4bWlSbVlXS080UlBhUXJrM1p6SXlmUjNYeDYwTXJaUUtwYith?=
 =?utf-8?B?NHNqSWlBOUdUdTdWcVhzYUxtZ0o1ZHROd3lvR2ZOc3Bmc0g5TDZYbGJUWENT?=
 =?utf-8?B?blp1RzI0S3hxNmdhMGZnSGZ2VUxNM3I5TDY0REw3UmgvYXRpS0lDYVVtd0RF?=
 =?utf-8?B?azhLSVVpalloQUcrNUpkQjA4bTM1SGZiOHhYM0o2UUovYlBUUGxsWEVDM0Fn?=
 =?utf-8?B?cnlOMmNnYzlPTXpHbnRINDhsVmRkUlU4ZnEvdFR4UFZBd0lHYzNnQTFsSDhl?=
 =?utf-8?B?aDFkNEtPRFMyWVdlemlyMlMvUWluN2ZYWkZCWmMrZEtxTU1ramgwVkJGWVY2?=
 =?utf-8?B?c1pvc3BFVTVUNmNhVGsya0tnczByaTZ1dW5jSDc5QzFITDFOaCtiWVZ4SFVo?=
 =?utf-8?B?N3NPZkVyZVg4eGd5akVXbXdNbkZSQ2dSWEcraDdLcnNkRklWZndLWnFYdEp0?=
 =?utf-8?B?NGlSVkx3M1lzbVV5S0ZXOXhHOUVORnJucW1KbE1qblBFUFBhSzRJTE9mWmRq?=
 =?utf-8?B?MFR5a21IMUpvTzF4WDF2K2dKb0tBemptYWlUNHh4TWxWR1l4NVNMMTFoVTFO?=
 =?utf-8?B?M2xPNThaTmcxRG43OFFOL2RIUG96VDRHWE1XNFpKbVUzdDZCTG1tblZTK0tL?=
 =?utf-8?B?Um9SVXBaTXpLSnBkRzBDblZUbnhNemEvTEo0QXNGdnpEWG85eTc4ZzhWWE9z?=
 =?utf-8?B?QlE9PQ==?=
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 192cc242-ae36-4161-8bc2-08db5630269c
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 May 2023 17:08:21.0945
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WtMtdn5Apz+vBTe2TtX0IIeLhT+BZmmJlbCx76oBICMnszyS6D2ttDVYB5wwyv8a
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR15MB6292
X-Proofpoint-GUID: j2UZKLFRAqC4h16w1r5hrYeosq9Qkv6c
X-Proofpoint-ORIG-GUID: j2UZKLFRAqC4h16w1r5hrYeosq9Qkv6c
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-16_09,2023-05-16_01,2023-02-09_01
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
	RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



On 5/16/23 4:18 AM, starmiku1207184332@gmail.com wrote:
> From: Teng Qi <starmiku1207184332@gmail.com>
> 
> Hi, bpf developers,
> 
> We are developing a static tool to check the matching between helpers and the
> context of hooks. During our analysis, we have discovered some important
> findings that we would like to report.
> 
> ‘kernel/bpf/syscall.c: 2097 __bpf_prog_put()’ shows that function
> bpf_prog_put_deferred() won`t be called in the condition of
> ‘in_irq() || irqs_disabled()’.
> if (in_irq() || irqs_disabled()) {
>      INIT_WORK(&aux->work, bpf_prog_put_deferred);
>      schedule_work(&aux->work);
> } else {
> 
>      bpf_prog_put_deferred(&aux->work);
> }
> 
> We suspect this condition exists because there might be sleepable operations
> in the callees of the bpf_prog_put_deferred() function:
> kernel/bpf/syscall.c: 2097 __bpf_prog_put()
> kernel/bpf/syscall.c: 2084 bpf_prog_put_deferred()
> kernel/bpf/syscall.c: 2063 __bpf_prog_put_noref()
> kvfree(prog->aux->jited_linfo);
> kvfree(prog->aux->linfo);

Looks like you only have suspicion here. Could you find a real violation 
here where __bpf_prog_put() is called with !in_irq() && 
!irqs_disabled(), but inside spin_lock or rcu read lock? I have not seen
things like that.

> 
> Additionally, we found that array prog->aux->jited_linfo is initialized in
> ‘kernel/bpf/core.c: 157 bpf_prog_alloc_jited_linfo()’:
> prog->aux->jited_linfo = kvcalloc(prog->aux->nr_linfo,
>    sizeof(*prog->aux->jited_linfo), bpf_memcg_flags(GFP_KERNEL | __GFP_NOWARN));

Any problem here?

> 
> Our question is whether the condition 'in_irq() || irqs_disabled() == false' is
> sufficient for calling 'kvfree'. We are aware that calling 'kvfree' within the
> context of a spin lock or an RCU lock is unsafe.
> 
> Therefore, we propose modifying the condition to include in_atomic(). Could we
> update the condition as follows: "in_irq() || irqs_disabled() || in_atomic()"?
> 
> Thank you! We look forward to your feedback.
> 
> Signed-off-by: Teng Qi <starmiku1207184332@gmail.com>

