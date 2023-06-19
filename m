Return-Path: <netdev+bounces-12064-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7CF7E735DA9
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 21:01:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A07D51C20481
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 19:01:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 323D31427B;
	Mon, 19 Jun 2023 19:01:43 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1334BEA8;
	Mon, 19 Jun 2023 19:01:42 +0000 (UTC)
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4D63E6F;
	Mon, 19 Jun 2023 12:01:38 -0700 (PDT)
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
	by m0089730.ppops.net (8.17.1.19/8.17.1.19) with ESMTP id 35JItTBk009557;
	Mon, 19 Jun 2023 12:01:18 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=s2048-2021-q4;
 bh=fiCEkCwO1qmukLVP7ZE+3OWdE09NCjPZpYapc76ILsE=;
 b=IFhLMJshuNVSEkUwxvQszbQwwJBRqeLco0aAIytckZyFHHQj7ZwSiDAhy9Qc6bBl1g5u
 0ilkK0CEexp4ZqoRiYv01ZJaWF8xE9beWGcmAhLBkGOCbcXkQTFp7RGXOB7hr+CStEB6
 wUKAhYz8sv3vxrsLMmShP/jv7Z5JVW1H1VsNBK/4PdAAInyb06jRS5Ai04QoGZCw0GJs
 /bR7edoiBjv+DtKHtNpVICQ8DT7DHbWsnyayNKixfkGIV0ydVbw9zmdeG5My/HfZJNIZ
 gOwFwykVJp8x4Nnm2R4ErfMhS7I+EX03E9Qq/EqYd+A/clspgozXBN0MbNvRScvmrWGY 0g== 
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2040.outbound.protection.outlook.com [104.47.73.40])
	by m0089730.ppops.net (PPS) with ESMTPS id 3r98b9xm89-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 19 Jun 2023 12:01:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mpezKMYpVvTgg3koQ7EvZCP0YqlIVj0hCdfDB+C1STSWKvqAO+xufJULuS8c0geHyiCgfidDstslmDiKH8Yw1/cRBE7fuwG5D8db6tD7yXe5Tyx1iEFCfSnQzd+LkBi6dQuud0l2+0L7wcn1j0DN4TPZrzMD634LofIk09xiwzUOirO+r8b2iuT3jEOx43ZDWIQRQk9YjUbAJJcFsrhxOKBEJtYl3BXc3PqHbxFyeepTNwcl7BgfMN4YzIEmSzaZePrm+mnAWa1nak53keG31qFER8zuboUySQKIiXt7rAgpSbjpUVigmtKcJA641G/SYtqjnCpzA/zKPNHQUosSXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fiCEkCwO1qmukLVP7ZE+3OWdE09NCjPZpYapc76ILsE=;
 b=QTMVkfTBg3oQRX641lQKUvSA9qSqMaWWQK4IaSOAldTcU0EaLIQOWGFs/U/CXpaWMvuAWG5uLKtjai2xMcsAvMR/FPhGKpYa6U0U29JTtfN8TC51+A+bx/8xnmTRQULSKxuBIReuqTGeuc2Z85Zypd3YHBsx5uxYyC5bqkOzGjU7A+EH8T6U0morV5GWFlGB/iYhNTYLIzRYfr3rXmA69ymEGWb6t0jFvv4KWEmnDiirPk367dfkWECjfLv4/ps1vIbjYu1Bc4xW9NoXv3ifpycMLj3uib2kM5QIn6jMJXARbo5VZ6COGACdn9cYWpKBIFs6+mn5rZWDqDjvSMHspg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SJ0PR15MB5177.namprd15.prod.outlook.com (2603:10b6:a03:423::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.35; Mon, 19 Jun
 2023 19:01:10 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::428f:acec:2c1f:c812]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::428f:acec:2c1f:c812%6]) with mapi id 15.20.6500.036; Mon, 19 Jun 2023
 19:01:11 +0000
Message-ID: <a93079f2-fcd4-e3ef-3b92-92d443b8e8c6@meta.com>
Date: Mon, 19 Jun 2023 12:01:05 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.12.0
Subject: Re: [bug] kernel: bpf: syscall: a possible sleep-in-atomic bug in
 __bpf_prog_put()
Content-Language: en-US
To: Teng Qi <starmiku1207184332@gmail.com>
Cc: ast@kernel.org, daniel@iogearbox.net, john.fastabend@gmail.com,
        andrii@kernel.org, martin.lau@linux.dev, song@kernel.org, yhs@fb.com,
        kpsingh@kernel.org, sdf@google.com, haoluo@google.com,
        jolsa@kernel.org, davem@davemloft.net, kuba@kernel.org,
        hawk@kernel.org, bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
References: <20230516111823.2103536-1-starmiku1207184332@gmail.com>
 <e37c0a65-a3f6-e2e6-c2ad-367db20253a0@meta.com>
 <CALyQVax8X63qekZVhvRTmZFFs+ucPKRkBB7UnRZk6Hu3ggi7Og@mail.gmail.com>
 <57dc6a0e-6ba9-e77c-80ac-6bb0a6e2650a@meta.com>
 <CALyQVazb=D1ejapiFdTnan6JbjFJA2q9ifhSsmF4OC9MDz3oAw@mail.gmail.com>
 <d027cb6b-e32c-36ad-3aba-9a7b1177f89f@meta.com>
 <CALyQVayW7e4FPbaMNNuOmYGYt5pcd47zsx2xVkrekEDaVm7H2g@mail.gmail.com>
 <113dc8c1-0840-9ee3-2840-28246731604c@meta.com>
 <CALyQVaxFKisZ_4DjofVE9PH+nFcOKSMJG4XDkn1znsqU+EnYHw@mail.gmail.com>
 <c6e4aa90-aa35-fa42-1196-a71c88994620@meta.com>
 <CALyQVayjJ_q5su8fXgx-UCtZi4+ig6OUm0jXhNdoqkYnXSy9RA@mail.gmail.com>
From: Yonghong Song <yhs@meta.com>
In-Reply-To: <CALyQVayjJ_q5su8fXgx-UCtZi4+ig6OUm0jXhNdoqkYnXSy9RA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-ClientProxiedBy: SJ0PR03CA0145.namprd03.prod.outlook.com
 (2603:10b6:a03:33c::30) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR1501MB2064:EE_|SJ0PR15MB5177:EE_
X-MS-Office365-Filtering-Correlation-Id: 4603e4f6-a074-4cfe-3e1e-08db70f78bc7
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	5OHsXLfRiGpn6fsvSUCdbji803VecT4RDYUJVa3a3QviOmZpulYtwehkBZYM8lNA1B8LvoA8oM95YxvdeFU3AwUs5StWePKp5RiMk3j/bKf9jLDYkVkjF7hs1dguNeDTaB4sFwX0XovJHpfjXwP92+Bqy5lXYPzbzOLkBrrCH8iV947JrLswQ51k6pNlzrrA88ON0hplaWKHo9j2RoUoAh1s5DstOI+37qFPqACP0x/8+liNzmP10uwVmd879brfCnWCq9TBNqscBvxGXt6ar2+TdhMsJUij1OJseYy2R3SMFQV+Wxq0lEdNMIPfNpY+J4VrcKs7R5ioSLkEvps/4YgglFZH++4fklkamAbUxyRtVelg8OweaEvOjZsmUIsYAl33bYa7L/GK6tXqBBEkNmRuwLRubywVNeHvQsIqYP4VUvNNJUqVZ6zyB+XxrnyHdi1x8o+aORKIXaaDjKGNERbPv4I+wQrLoEu8JA/dNPOucZewVQniSNMbnJjzL66scR13F35m5GYlhfDgcwcvtee45TQbcGqkSczKmNc05k7YPPtQLlFZKAyw6UwxTF5VRpoDuEm8OtXRfbeW7ZR6W8DV164k4BJsgtk46SnkT3JbQMJ45IRcksji/iBHCCvjienV8rwM5D86vJgvhd+wog==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(396003)(366004)(39860400002)(346002)(136003)(451199021)(30864003)(2906002)(7416002)(5660300002)(8676002)(8936002)(36756003)(41300700001)(86362001)(31696002)(6666004)(6486002)(478600001)(83380400001)(186003)(6506007)(6512007)(53546011)(2616005)(31686004)(38100700002)(316002)(66476007)(66556008)(6916009)(66946007)(4326008)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?OTFTc3o3bFJ0MmpNbVNZc1RFMCtBQ1ZJb2hNU1dtNm4yb25ZNDJvdmFTVHZV?=
 =?utf-8?B?aVNJWkZnRkhLWXhwUm5IL0h2azhsNCtvdEpWVC9vSmNyNlV0d0lZenEwQzRs?=
 =?utf-8?B?aHQ3RjE2Mjk4N1hYOHAyTmJFcE1rRjd3Ump3ZGF2eitjYzBDTGJtK2RvUm1Y?=
 =?utf-8?B?b2dyMXhQcHowRnp3NWFlT2NQVUw5VTdSeUdSKzI4akNBVUJGdHdsV1MweW9C?=
 =?utf-8?B?REtkYWdxdnlDY3FPTlh6bE9pMU1haUNzMldXN0NhOG1XNnpsV2NJcHBEMnZI?=
 =?utf-8?B?K2Zha09wSUtaY21lN0dIeDVQM1UvbmtQdGM0ZGhyWmNqVzVhdGhVRit4ZUZZ?=
 =?utf-8?B?MUtuZ1hxeDN0VVhwd24zMU1iUHF0Zk12V1doRmRFdU5DN0VqZFVXNTVIbExC?=
 =?utf-8?B?UXR6cGwxSWFiZXVpcnRQb015L1Z5S0pKa3FNOHo3Q0gwOVArS0IrYUVBWDBS?=
 =?utf-8?B?cVNtNVNSdTRnbE95aUpqVHlMdjE5dTBZeUpadGxTMWRJUWVNV0pEWjlDZXBM?=
 =?utf-8?B?YVpBY0RDZThQaEhVbGE1QTRIY3cvRUJRNUxmRE1EamtBZ0xjd2VNTUNBZnVU?=
 =?utf-8?B?UjlSTjRLSndkYngwbkkwbml4S05FOXIvZGdUZFJURWRHbmt3NHMvQmVNYmJE?=
 =?utf-8?B?amxsekxyYVpuQW5aVytPUzNZdmtSdXRWUTBJR3ZjbjNsdnpoSzhRaHhIVlA3?=
 =?utf-8?B?U2Eyd09xRkZydFc3TFpBZG5UdTU2NlBjZkNnM1JpVVhWR01JQVFBNUVPMWJ0?=
 =?utf-8?B?UXRBeHVsUE5KYjRRTElUdzlybGEreU1ZakpXQ0V3L3hsbTNpN0dIYlFIR2NY?=
 =?utf-8?B?MzlOY1BCck5aL0NQNWJ5cjE1WDJ4RE1XQVJuV1gvWmZKVmg1MU1mZkFBcUNN?=
 =?utf-8?B?RFpCZU5oRTE4dUhVV3MwcGJkV1pLajN0ZlBWdHltVEs2ZnVNejhPT3doRHU0?=
 =?utf-8?B?M1gxMTZpOC9HYWtVK1I4VFJrK2tiazh2VVByVzNFcEdSa2xmVUpPZ0pJSnJx?=
 =?utf-8?B?MXVXMWNqQlQ4REtMeVppY0NMZ00zU3JZZVk3MmZrbnBtZ3E1aUk4RHNqUmcr?=
 =?utf-8?B?bUJ6K1VpTjVLUE9BS2xhZFRpMExydnMzQWtvSUFHNEFtN1ltWFZjLzhjcFVL?=
 =?utf-8?B?bTUxUmd2RDNDYjZOYy85M2hzWXAwSXNTRFFmZVZGWXVNU0dkUTlBQjBpV0V0?=
 =?utf-8?B?U2laU2dmSytqTE54NElFZk5hTUM3U2NPclVXUzJwOXNORUpaK3FsZkgvU1Mx?=
 =?utf-8?B?MWZtTnp6eXBJUVI1b1I5cWphRmUzWlB0c0xJV0NxUlU1c1g4SEttUEFiUDNk?=
 =?utf-8?B?NXZXUzNMQmNjN1Y4bFg5Vy8vNkRUZ0NSYXJ2UHBtbXM5QzRhRFUwNkZROVRT?=
 =?utf-8?B?d2NJSXhzMVdpTUJ4cVZkN1REcHhNSEVTb1lHbUVwV0cwV3ZPSGNCMlRQMW9j?=
 =?utf-8?B?d1djckMxbXMvWkpmVGVVcGxDWmd0NzZuYWNGeUZjbEpXb2VuejR4a3FVRjNF?=
 =?utf-8?B?WUVWbTJEZ2pDSXVSRjZPWmtHTDdzZzBmckY5Z3lHN05xREhCaVFoejRqd3hq?=
 =?utf-8?B?SzlMbjlTRG9wcTZnODM3bk9OaVBUbFZ0MG5ZYUtQd3laVlJKNDVyUUdSbHpE?=
 =?utf-8?B?a3ZTSVVHSE9rODZpTGY0cm1tZGt1c0g3clJzRmJlUjFHMHltNEZ1L01ZMmpH?=
 =?utf-8?B?RDRFZ1ZsaUVZR0ZUZmRkMEJIYWgxQ2FsWllnNXdKb0MrM3ZoYkxHVlZodHVD?=
 =?utf-8?B?S1Q0cWhGK0kybFBGaXJvdEJLcCtsQzA1NEpFQ0luOW16K2UzSUJHT3pGTWNI?=
 =?utf-8?B?Y1JNblRkSjBraDdCL0dIbXZjVFI2ZC82TzNOcFJ1QXVySVhSL2hiMC9Sb1BP?=
 =?utf-8?B?bmFNN1VsWTdmczZFZEdwOEtBYWJENlV5QzRIUHNsS2JSNHNnd0cycm8zUVpq?=
 =?utf-8?B?N3FaZ3lEd3BYWFlRSURYNWpUNEdyc29uRmx4Sm1KSjhPdUJLcGFuRkc4NzJw?=
 =?utf-8?B?ajg4QzVQYklHdG4rNXBsZTA1VlM2ckIwYW1DalNEcUFtZXRhSnl0SmpTSnlx?=
 =?utf-8?B?a0JBOUwvRUxrRm9tblFoc1BqbTd5THpVcExEQXl3L3RsVlkzVllqSy82cURR?=
 =?utf-8?B?enlpNEhKUWo4cFBpSWhQUDMwSVlUVGFDcnl2VnRuWWFiNG9RVm91elYwRXFl?=
 =?utf-8?B?b0E9PQ==?=
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4603e4f6-a074-4cfe-3e1e-08db70f78bc7
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jun 2023 19:01:10.8796
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KfwWgq/qjgDwpps/kiMlPgczXKsZy2zjITQrkx3Ffi8gwy77un2nUXySTPazeWml
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR15MB5177
X-Proofpoint-ORIG-GUID: GgncEF3A9t514sGP4ZCEXGDsBeIxTiJL
X-Proofpoint-GUID: GgncEF3A9t514sGP4ZCEXGDsBeIxTiJL
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-06-19_11,2023-06-16_01,2023-05-22_02
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
	RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



On 6/19/23 2:05 AM, Teng Qi wrote:
> Hello!
> 
>> It would be great if you also print out in_interrupt() value, so we know
>> whether softirq or nmi is enabled or not.
> 
> After adding the in_interrupt(), the interesting output cases are as follows:
> [ 38.596580] bpf_prog_put: in_irq() 0, irqs_disabled() 0, in_interrupt() 256,
>          preempt_count() 256, in_atomic() 1, rcu_read_lock_held() 0
> [ 62.300608] bpf_prog_put: in_irq() 0, irqs_disabled() 0, in_interrupt() 256,
>          preempt_count() 256, in_atomic() 1, rcu_read_lock_held() 1
> [ 62.301179] bpf_prog_put: in_irq() 0, irqs_disabled() 0, in_interrupt() 0,
>          preempt_count() 0, in_atomic() 0, rcu_read_lock_held() 1
> 
> Based on these cases, the current code is safe for the first two cases, because
>          in_interrupt() in vfree() prevents sleeping.
> However, the rcu_read_lock_held() is not reliable, so we cannot rely on it.
> Considering all the discussions so far, I think the best plan now is to change
> the condition in __bpf_prog_put() to ‘irqs_disabled() || in_atomic()’ and
> provide examples for possible issues. This plan effectively addresses
> more possible atomic contexts of __bpf_prog_put() without incurring
> any additional cost.

Thanks for analysis. In the above, in_atomic()=1 is due to 
preempt_count()=256 which implies a softirq. Actually in_atomic() will
be true if preempt_disabled or in_interrupt. So I guess your previous
change

diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index a75c54b6f8a3..11df562e481b 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -2147,7 +2147,7 @@ static void __bpf_prog_put(struct bpf_prog *prog)
         struct bpf_prog_aux *aux = prog->aux;

         if (atomic64_dec_and_test(&aux->refcnt)) {
-               if (in_irq() || irqs_disabled()) {
+               if (!in_interrupt()) {
                         INIT_WORK(&aux->work, bpf_prog_put_deferred);
                         schedule_work(&aux->work);
                 } else {

should be okay. Just need to explain in the commit message
   - why with 'in_interrupt()' it is okay to call
     bpf_prog_put_deferred() directly, and
   - why with '!in_interrupt()' it is not okay to call
     pf_prog_put_deferred() directly

Thanks!

> -- Teng Qi
> 
> On Mon, Jun 12, 2023 at 8:02 AM Yonghong Song <yhs@meta.com> wrote:
>>
>>
>>
>> On 6/11/23 6:02 AM, Teng Qi wrote:
>>> Hello!
>>>> BTW, please do create a test case, e.g, sockmap test case which
>>>> can show the problem with existing code base.
>>>
>>> I add a printk in bpf_prog_put_deferred():
>>> static void bpf_prog_put_deferred(struct work_struct *work)
>>> {
>>>           // . . .
>>>           int inIrq = in_irq();
>>>           int irqsDisabled = irqs_disabled();
>>>           int preemptBits = preempt_count();
>>>           int inAtomic = in_atomic();
>>>           int rcuHeld = rcu_read_lock_held();
>>>           printk("bpf_prog_put: in_irq() %d, irqs_disabled() %d, preempt_count()
>>>            %d, in_atomic() %d, rcu_read_lock_held() %d",
>>>           inIrq, irqsDisabled, preemptBits, inAtomic, rcuHeld);
>>>           // . . .
>>> }
>>>
>>> When running the selftest, I see the following output:
>>> [255340.388339] bpf_prog_put: in_irq() 0, irqs_disabled() 0,
>>>           preempt_count() 256, in_atomic() 1, rcu_read_lock_held() 1
>>> [255393.237632] bpf_prog_put: in_irq() 0, irqs_disabled() 0,
>>>           preempt_count() 0, in_atomic() 0, rcu_read_lock_held() 1
>>
>> It would be great if you also print out in_interrupt() value, so we know
>> whether softirq or nmi is enabled or not.
>>
>> We cannot really WARN with !rcu_read_lock_held() since the
>> __bpf_prog_put funciton is called in different contexts.
>>
>> Also, note that rcu_read_lock_held() may not be reliable. rcu subsystem
>> will return 1 if not tracked or not sure about the result.
>>
>>>
>>> Based on this output, I believe it is sufficient to construct a self-test case
>>> for bpf_prog_put_deferred() called under preempt disabled or rcu read lock
>>> region. However, I'm a bit confused about what I should do to build the
>>> self-test case. Are we looking to create a checker that verifies the
>>> context of bpf_prog_put_deferred() is valid? Or do we need a test case that
>>> can trigger this bug?
>>>
>>> Could you show me more ideas to construct a self test case? I am not familiar
>>> with it and have no idea.
>>
>> Okay, I see. It seems hard to create a test case with warnings since
>> bpf_prog_put_deferred is called in different context. So some
>> examples for possible issues (through code analysis) should be good enough.
>>
>>>
>>> -- Teng Qi
>>>
>>> On Thu, May 25, 2023 at 3:34 AM Yonghong Song <yhs@meta.com> wrote:
>>>>
>>>>
>>>>
>>>> On 5/24/23 5:42 AM, Teng Qi wrote:
>>>>> Thank you.
>>>>>
>>>>>> We cannot use rcu_read_lock_held() in the 'if' statement. The return
>>>>>> value rcu_read_lock_held() could be 1 for some configurations regardless
>>>>>> whether rcu_read_lock() is really held or not. In most cases,
>>>>>> rcu_read_lock_held() is used in issuing potential warnings.
>>>>>> Maybe there are other ways to record whether rcu_read_lock() is held or not?
>>>>>
>>>>> Sorry. I was not aware of the dependency of configurations of
>>>>> rcu_read_lock_held().
>>>>>
>>>>>> If we cannot resolve rcu_read_lock() presence issue, maybe the condition
>>>>>> can be !in_interrupt(), so any process-context will go to a workqueue.
>>>>>
>>>>> I agree that using !in_interrupt() as a condition is an acceptable solution.
>>>>
>>>> This should work although it could be conservative.
>>>>
>>>>>
>>>>>> Alternatively, we could have another solution. We could add another
>>>>>> function e.g., bpf_prog_put_rcu(), which indicates that bpf_prog_put()
>>>>>> will be done in rcu context.
>>>>>
>>>>> Implementing a new function like bpf_prog_put_rcu() is a solution that involves
>>>>> more significant changes.
>>>>
>>>> Maybe we can change signature of bpf_prog_put instead? Like
>>>>       void bpf_prog_put(struct bpf_prog *prog, bool in_rcu)
>>>> and inside bpf_prog_put we can add
>>>>       WARN_ON_ONCE(in_rcu && !bpf_rcu_lock_held());
>>>>
>>>>>
>>>>>> So if in_interrupt(), do kvfree, otherwise,
>>>>>> put into a workqueue.
>>>>>
>>>>> Shall we proceed with submitting a patch following this approach?
>>>>
>>>> You could choose either of the above although I think with newer
>>>> bpf_prog_put() is better.
>>>>
>>>> BTW, please do create a test case, e.g, sockmap test case which
>>>> can show the problem with existing code base.
>>>>
>>>>>
>>>>> I would like to mention something unrelated to the possible bug. At this
>>>>> moment, things seem to be more puzzling. vfree() is safe under in_interrupt()
>>>>> but not safe under other atomic contexts.
>>>>> This disorder challenges our conventional belief, a monotonic incrementation
>>>>> of limitations of the hierarchical atomic contexts, that programer needs
>>>>> to be more and more careful to write code under rcu read lock, spin lock,
>>>>> bh disable, interrupt...
>>>>> This disorder can lead to unexpected consequences, such as code being safe
>>>>> under interrupts but not safe under spin locks.
>>>>> The disorder makes kernel programming more complex and may result in more bugs.
>>>>> Even though we find a way to resolve the possible bug about the bpf_prog_put(),
>>>>> I feel sad for undermining of kernel`s maintainability and disorder of
>>>>> hierarchy of atomic contexts.
>>>>>
>>>>> -- Teng Qi
>>>>>
>>>>> On Tue, May 23, 2023 at 12:33 PM Yonghong Song <yhs@meta.com> wrote:
>>>>>>
>>>>>>
>>>>>>
>>>>>> On 5/21/23 6:39 AM, Teng Qi wrote:
>>>>>>> Thank you.
>>>>>>>
>>>>>>>     > Your above analysis makes sense if indeed that kvfree cannot appear
>>>>>>>     > inside a spin lock region or RCU read lock region. But is it true?
>>>>>>>     > I checked a few code paths in kvfree/kfree. It is either guarded
>>>>>>>     > with local_irq_save/restore or by
>>>>>>>     > spin_lock_irqsave/spin_unlock_
>>>>>>>     > irqrestore, etc. Did I miss
>>>>>>>     > anything? Are you talking about RT kernel here?
>>>>>>>
>>>>>>> To see the sleepable possibility of kvfree, it is important to analyze the
>>>>>>> following calling stack:
>>>>>>> mm/util.c: 645 kvfree()
>>>>>>> mm/vmalloc.c: 2763 vfree()
>>>>>>>
>>>>>>> In kvfree(), to call vfree, if the pointer addr points to memory
>>>>>>> allocated by
>>>>>>> vmalloc(), it calls vfree().
>>>>>>> void kvfree(const void *addr)
>>>>>>> {
>>>>>>>             if (is_vmalloc_addr(addr))
>>>>>>>                     vfree(addr);
>>>>>>>             else
>>>>>>>                     kfree(addr);
>>>>>>> }
>>>>>>>
>>>>>>> In vfree(), in_interrupt() and might_sleep() need to be considered.
>>>>>>> void vfree(const void *addr)
>>>>>>> {
>>>>>>>             // ...
>>>>>>>             if (unlikely(in_interrupt()))
>>>>>>>             {
>>>>>>>                     vfree_atomic(addr);
>>>>>>>                     return;
>>>>>>>             }
>>>>>>>             // ...
>>>>>>>             might_sleep();
>>>>>>>             // ...
>>>>>>> }
>>>>>>
>>>>>> Sorry. I didn't check vfree path. So it does look like that
>>>>>> we need to pay special attention to non interrupt part.
>>>>>>
>>>>>>>
>>>>>>> The vfree() may sleep if in_interrupt() == false. The RCU read lock region
>>>>>>> could have in_interrupt() == false and spin lock region which only disables
>>>>>>> preemption also has in_interrupt() == false. So the kvfree() cannot appear
>>>>>>> inside a spin lock region or RCU read lock region if the pointer addr points
>>>>>>> to memory allocated by vmalloc().
>>>>>>>
>>>>>>>     > > Therefore, we propose modifying the condition to include
>>>>>>>     > > in_atomic(). Could we
>>>>>>>     > > update the condition as follows: "in_irq() || irqs_disabled() ||
>>>>>>>     > > in_atomic()"?
>>>>>>>     > Thank you! We look forward to your feedback.
>>>>>>>
>>>>>>> We now think that ‘irqs_disabled() || in_atomic() ||
>>>>>>> rcu_read_lock_held()’ is
>>>>>>> more proper. irqs_disabled() is for irq flag reg, in_atomic() is for
>>>>>>> preempt count and rcu_read_lock_held() is for RCU read lock region.
>>>>>>
>>>>>> We cannot use rcu_read_lock_held() in the 'if' statement. The return
>>>>>> value rcu_read_lock_held() could be 1 for some configuraitons regardless
>>>>>> whether rcu_read_lock() is really held or not. In most cases,
>>>>>> rcu_read_lock_held() is used in issuing potential warnings.
>>>>>> Maybe there are other ways to record whether rcu_read_lock() is held or not?
>>>>>>
>>>>>> I agree with your that 'irqs_disabled() || in_atomic()' makes sense
>>>>>> since it covers process context local_irq_save() and spin_lock() cases.
>>>>>>
>>>>>> If we cannot resolve rcu_read_lock() presence issue, maybe the condition
>>>>>> can be !in_interrupt(), so any process-context will go to a workqueue.
>>>>>>
>>>>>> Alternatively, we could have another solution. We could add another
>>>>>> function e.g., bpf_prog_put_rcu(), which indicates that bpf_prog_put()
>>>>>> will be done in rcu context. So if in_interrupt(), do kvfree, otherwise,
>>>>>> put into a workqueue.
>>>>>>
>>>>>>
>>>>>>>
>>>>>>> -- Teng Qi
>>>>>>>
>>>>>>> On Sun, May 21, 2023 at 11:45 AM Yonghong Song <yhs@meta.com
>>>>>>> <mailto:yhs@meta.com>> wrote:
>>>>>>>
>>>>>>>
>>>>>>>
>>>>>>>        On 5/19/23 7:18 AM, Teng Qi wrote:
>>>>>>>         > Thank you for your response.
>>>>>>>         >  > Looks like you only have suspicion here. Could you find a real
>>>>>>>        violation
>>>>>>>         >  > here where __bpf_prog_put() is called with !in_irq() &&
>>>>>>>         >  > !irqs_disabled(), but inside spin_lock or rcu read lock? I
>>>>>>>        have not seen
>>>>>>>         >  > things like that.
>>>>>>>         >
>>>>>>>         > For the complex conditions to call bpf_prog_put() with 1 refcnt,
>>>>>>>        we have
>>>>>>>         > been
>>>>>>>         > unable to really trigger this atomic violation after trying to
>>>>>>>        construct
>>>>>>>         > test cases manually. But we found that it is possible to show
>>>>>>>        cases with
>>>>>>>         > !in_irq() && !irqs_disabled(), but inside spin_lock or rcu read lock.
>>>>>>>         > For example, even a failed case, one of selftest cases of bpf,
>>>>>>>        netns_cookie,
>>>>>>>         > calls bpf_sock_map_update() and may indirectly call bpf_prog_put()
>>>>>>>         > only inside rcu read lock: The possible call stack is:
>>>>>>>         > net/core/sock_map.c: 615 bpf_sock_map_update()
>>>>>>>         > net/core/sock_map.c: 468 sock_map_update_common()
>>>>>>>         > net/core/sock_map.c:  217 sock_map_link()
>>>>>>>         > kernel/bpf/syscall.c: 2111 bpf_prog_put()
>>>>>>>         >
>>>>>>>         > The files about netns_cookie include
>>>>>>>         > tools/testing/selftests/bpf/progs/netns_cookie_prog.c and
>>>>>>>         > tools/testing/selftests/bpf/prog_tests/netns_cookie.c. We
>>>>>>>        inserted the
>>>>>>>         > following code in
>>>>>>>         > ‘net/core/sock_map.c: 468 sock_map_update_common()’:
>>>>>>>         > static int sock_map_update_common(..)
>>>>>>>         > {
>>>>>>>         >          int inIrq = in_irq();
>>>>>>>         >          int irqsDisabled = irqs_disabled();
>>>>>>>         >          int preemptBits = preempt_count();
>>>>>>>         >          int inAtomic = in_atomic();
>>>>>>>         >          int rcuHeld = rcu_read_lock_held();
>>>>>>>         >          printk("in_irq() %d, irqs_disabled() %d, preempt_count() %d,
>>>>>>>         >            in_atomic() %d, rcu_read_lock_held() %d", inIrq,
>>>>>>>        irqsDisabled,
>>>>>>>         >            preemptBits, inAtomic, rcuHeld);
>>>>>>>         > }
>>>>>>>         >
>>>>>>>         > The output message is as follows:
>>>>>>>         > root@(none):/root/bpf# ./test_progs -t netns_cookie
>>>>>>>         > [  137.639188] in_irq() 0, irqs_disabled() 0, preempt_count() 0,
>>>>>>>         > in_atomic() 0,
>>>>>>>         >          rcu_read_lock_held() 1
>>>>>>>         > #113     netns_cookie:OK
>>>>>>>         > Summary: 1/0 PASSED, 0 SKIPPED, 0 FAILED
>>>>>>>         >
>>>>>>>         > We notice that there are numerous callers in kernel/, net/ and
>>>>>>>        drivers/,
>>>>>>>         > so we
>>>>>>>         > highly suggest modifying __bpf_prog_put() to address this gap.
>>>>>>>        The gap
>>>>>>>         > exists
>>>>>>>         > because __bpf_prog_put() is only safe under in_irq() ||
>>>>>>>        irqs_disabled()
>>>>>>>         > but not in_atomic() || rcu_read_lock_held(). The following code
>>>>>>>        snippet may
>>>>>>>         > mislead developers into thinking that bpf_prog_put() is safe in all
>>>>>>>         > contexts.
>>>>>>>         > if (in_irq() || irqs_disabled()) {
>>>>>>>         >          INIT_WORK(&aux->work, bpf_prog_put_deferred);
>>>>>>>         >          schedule_work(&aux->work);
>>>>>>>         > } else {
>>>>>>>         >          bpf_prog_put_deferred(&aux->work);
>>>>>>>         > }
>>>>>>>         >
>>>>>>>         > Implicit dependency may lead to issues.
>>>>>>>         >
>>>>>>>         >  > Any problem here?
>>>>>>>         > We mentioned it to demonstrate the possibility of kvfree() being
>>>>>>>         > called by __bpf_prog_put_noref().
>>>>>>>         >
>>>>>>>         > Thanks.
>>>>>>>         > -- Teng Qi
>>>>>>>         >
>>>>>>>         > On Wed, May 17, 2023 at 1:08 AM Yonghong Song <yhs@meta.com
>>>>>>>        <mailto:yhs@meta.com>
>>>>>>>         > <mailto:yhs@meta.com <mailto:yhs@meta.com>>> wrote:
>>>>>>>         >
>>>>>>>         >
>>>>>>>         >
>>>>>>>         >     On 5/16/23 4:18 AM, starmiku1207184332@gmail.com
>>>>>>>        <mailto:starmiku1207184332@gmail.com>
>>>>>>>         >     <mailto:starmiku1207184332@gmail.com
>>>>>>>        <mailto:starmiku1207184332@gmail.com>> wrote:
>>>>>>>         >      > From: Teng Qi <starmiku1207184332@gmail.com
>>>>>>>        <mailto:starmiku1207184332@gmail.com>
>>>>>>>         >     <mailto:starmiku1207184332@gmail.com
>>>>>>>        <mailto:starmiku1207184332@gmail.com>>>
>>>>>>>         >      >
>>>>>>>         >      > Hi, bpf developers,
>>>>>>>         >      >
>>>>>>>         >      > We are developing a static tool to check the matching between
>>>>>>>         >     helpers and the
>>>>>>>         >      > context of hooks. During our analysis, we have discovered some
>>>>>>>         >     important
>>>>>>>         >      > findings that we would like to report.
>>>>>>>         >      >
>>>>>>>         >      > ‘kernel/bpf/syscall.c: 2097 __bpf_prog_put()’ shows that
>>>>>>>        function
>>>>>>>         >      > bpf_prog_put_deferred() won`t be called in the condition of
>>>>>>>         >      > ‘in_irq() || irqs_disabled()’.
>>>>>>>         >      > if (in_irq() || irqs_disabled()) {
>>>>>>>         >      >      INIT_WORK(&aux->work, bpf_prog_put_deferred);
>>>>>>>         >      >      schedule_work(&aux->work);
>>>>>>>         >      > } else {
>>>>>>>         >      >
>>>>>>>         >      >      bpf_prog_put_deferred(&aux->work);
>>>>>>>         >      > }
>>>>>>>         >      >
>>>>>>>         >      > We suspect this condition exists because there might be
>>>>>>>        sleepable
>>>>>>>         >     operations
>>>>>>>         >      > in the callees of the bpf_prog_put_deferred() function:
>>>>>>>         >      > kernel/bpf/syscall.c: 2097 __bpf_prog_put()
>>>>>>>         >      > kernel/bpf/syscall.c: 2084 bpf_prog_put_deferred()
>>>>>>>         >      > kernel/bpf/syscall.c: 2063 __bpf_prog_put_noref()
>>>>>>>         >      > kvfree(prog->aux->jited_linfo);
>>>>>>>         >      > kvfree(prog->aux->linfo);
>>>>>>>         >
>>>>>>>         >     Looks like you only have suspicion here. Could you find a real
>>>>>>>         >     violation
>>>>>>>         >     here where __bpf_prog_put() is called with !in_irq() &&
>>>>>>>         >     !irqs_disabled(), but inside spin_lock or rcu read lock? I
>>>>>>>        have not seen
>>>>>>>         >     things like that.
>>>>>>>         >
>>>>>>>         >      >
>>>>>>>         >      > Additionally, we found that array prog->aux->jited_linfo is
>>>>>>>         >     initialized in
>>>>>>>         >      > ‘kernel/bpf/core.c: 157 bpf_prog_alloc_jited_linfo()’:
>>>>>>>         >      > prog->aux->jited_linfo = kvcalloc(prog->aux->nr_linfo,
>>>>>>>         >      >    sizeof(*prog->aux->jited_linfo),
>>>>>>>        bpf_memcg_flags(GFP_KERNEL |
>>>>>>>         >     __GFP_NOWARN));
>>>>>>>         >
>>>>>>>         >     Any problem here?
>>>>>>>         >
>>>>>>>         >      >
>>>>>>>         >      > Our question is whether the condition 'in_irq() ||
>>>>>>>         >     irqs_disabled() == false' is
>>>>>>>         >      > sufficient for calling 'kvfree'. We are aware that calling
>>>>>>>         >     'kvfree' within the
>>>>>>>         >      > context of a spin lock or an RCU lock is unsafe.
>>>>>>>
>>>>>>>        Your above analysis makes sense if indeed that kvfree cannot appear
>>>>>>>        inside a spin lock region or RCU read lock region. But is it true?
>>>>>>>        I checked a few code paths in kvfree/kfree. It is either guarded
>>>>>>>        with local_irq_save/restore or by
>>>>>>>        spin_lock_irqsave/spin_unlock_irqrestore, etc. Did I miss
>>>>>>>        anything? Are you talking about RT kernel here?
>>>>>>>
>>>>>>>
>>>>>>>         >      >
>>>>>>>         >      > Therefore, we propose modifying the condition to include
>>>>>>>         >     in_atomic(). Could we
>>>>>>>         >      > update the condition as follows: "in_irq() ||
>>>>>>>        irqs_disabled() ||
>>>>>>>         >     in_atomic()"?
>>>>>>>         >      >
>>>>>>>         >      > Thank you! We look forward to your feedback.
>>>>>>>         >      >
>>>>>>>         >      > Signed-off-by: Teng Qi <starmiku1207184332@gmail.com
>>>>>>>        <mailto:starmiku1207184332@gmail.com>
>>>>>>>         >     <mailto:starmiku1207184332@gmail.com
>>>>>>>        <mailto:starmiku1207184332@gmail.com>>>
>>>>>>>         >
>>>>>>>

