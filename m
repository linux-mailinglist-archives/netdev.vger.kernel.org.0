Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97AB966D737
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 08:50:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235686AbjAQHur (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 02:50:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235597AbjAQHup (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 02:50:45 -0500
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 705372410E;
        Mon, 16 Jan 2023 23:50:44 -0800 (PST)
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30H6xKZt018469;
        Mon, 16 Jan 2023 23:50:21 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=s2048-2021-q4;
 bh=2bvG/okPetBveyDZ21nG8dqqiJ7rPmhPwWAT7kjY740=;
 b=S8JzLLpOP+K7gDnfDFxT2qnGRTEvmm+h5mZ7laOIgXMWm0+knoTuhER9I6igVFzQj8og
 62whiIBBztUc+ol4yw5/kv3QRQNLBjzLSf+4GB/u+PhegBtoUJnoI05zCdUrhiA09ezZ
 UCjl+xe4a7YJZublumX1J03ezvb/lfzl8UWeeTqtTgbyvD9uPb+YEoatKR9VJbwkiS47
 4mYiCGnZOSBg2+EfJ0iM2MhRE1muvlviPsoThOTMY4dFY8Xs+Xxeu8v7pfw2s4lPBGeZ
 yLR2EM9NOVmib3ZSUGutDz+D5y2fnmBSi6jt6dxnumEa+7bBkt1HfV1i0KEf7jLfK3KX YQ== 
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2106.outbound.protection.outlook.com [104.47.70.106])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3n58dkba8h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 Jan 2023 23:50:21 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g58UyzItmeRuDdDa/m7QNJ37z5Y1/SCgKxJ4vFgYF5JWKnQP9oZY6kVqy0YxsM68c+WtPygn0wy8Try7GncjQhr3YpZOaUbPZTkHJY+nKonJ+E71hCIoDCPUD1Cv6Ja3fjHH2q6J/oijfUeph1HnalIq9Q7hgBJvng2+11ZB+aQIdIQhQOpk5JmMaB2c23Vsi6HxQBQhKg4voVimlwVMS3U4hsUpqNIefjyzj8aEoGjNoiWjW0ELzCUEFplUU/7XVeNefQAZzNbQdUHbzxB0jRAHxNiqLviKJqCvi2Tt8g9rLcsUe0LiGRuOiy8EKkUR1JWPRh+yzscouYmok8GRAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dHXGK4QQVqbtPnmVF0DDqiKgFbpmyIdoLiJDfhe6PG0=;
 b=IGKCb2eAMa87Jq7Daj4FZja6wTFIwUrY/Mlripo+K1JI8Px7SFrt1sdANW+S3YPVC2+49PNYCE0zUnX2ImSrIydxT31H9jjvbcuBDRJ8F5xqRNHe1Zyp0lrVZp+DWW7IFcIxrgKFikJIvEOqlCsQfZQVv8mvt3e/nGMmKTasizK34zvMzfJJkM90Ey+wg63qhfjoebxjj5la+bYpMDXOVHUMOp4CDS3Zx2IZ4Jx/Olwi4wB9UPHA3wSNk+lURKhibfeX5XGuz5OeXSRCwJupFEIx63R0hBqx5Vs4oiNERJyY7GqyFWzM9dCYopV3AG94NgJNX8lWP9FsA56N+wpO9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by PH0PR15MB5829.namprd15.prod.outlook.com (2603:10b6:510:296::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.12; Tue, 17 Jan
 2023 07:50:19 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::3cc9:4d23:d516:59f0]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::3cc9:4d23:d516:59f0%4]) with mapi id 15.20.5986.023; Tue, 17 Jan 2023
 07:50:19 +0000
Message-ID: <18306a8f-e71f-b322-6c09-4a498e28c5e6@meta.com>
Date:   Mon, 16 Jan 2023 23:50:15 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.1
Subject: Re: KASAN: use-after-free Read in ___bpf_prog_run
Content-Language: en-US
To:     Hao Sun <sunhao.th@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
References: <CACkBjsbS0jeOUFzxWH-bBay9=cTQ_S2JbMnAa7V2sHpp_19PPw@mail.gmail.com>
 <52379286-960e-3fcd-84a2-3cab4d3b7c4e@meta.com>
 <5B270DBF-E305-4C86-B246-F5C8A5D942CA@gmail.com>
 <501fb848-5211-7706-aee2-4eac6310f1ae@meta.com>
 <933A445C-725E-4BC2-8860-2D0A92C34C58@gmail.com>
 <0f1d2e35-b027-43c9-067f-5e5e177071ed@meta.com>
 <F4EB9C63-8ED6-4640-9BD4-4709F01589FD@gmail.com>
From:   Yonghong Song <yhs@meta.com>
In-Reply-To: <F4EB9C63-8ED6-4640-9BD4-4709F01589FD@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-ClientProxiedBy: SJ0PR03CA0158.namprd03.prod.outlook.com
 (2603:10b6:a03:338::13) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR1501MB2064:EE_|PH0PR15MB5829:EE_
X-MS-Office365-Filtering-Correlation-Id: 41e92293-286b-43eb-6fa8-08daf85f7a91
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zpD95IUnzZyEFcfVyhHcexMYImPMGZuKMFzvDRVwzRRPgAc7onDKxYHZxWEBV0RqfSu+kWm44rU2DqMskEMkPQzSGPn0/KCvrV6W7Qo71PkBx8BqGBqB0G0u707clYfzujbT6eo07q7xfia7XZ8k4ZksNDsOfuaZm59F9jBcZhqyo+7QrNgH6HlaI8Q05VBvNb3YEUtVcz3nLwKGQBABTi0a2no6jIHtEoCwW4K7GyAGneORwYuoSkGQkE2nBgprZRSOzm2Cs2GOX2KcI6BuIg5aFU/tlQASqDQSWYGw+YH4oygydv8WJRO0/0RBcRPeLPQ1yre+hI8aG9DxTpJOJKPFtNMBy+Q12DE0qZQfjlfTKdP4dldoa22joTlvycqg+sthYf3VrYQ3XAbS2mU8AT6H4XKyhrYXy8mWIT+OZQ3VWXaEnKL/QhcOLLDPl5cHvjfnhH0aOqsaTEhh+sczoJd4V24m+c4FGKLtf2L4UYK7nYAbUrHse6ESd6qsJE9N0On6lIRqOu38q8qJa7n9ndbARO0T3F6Eourxz3OYNEHldEr5Ljf4mpHMZvGT57HYob6eB2fMDr+Gtef30Y8M5pI9d3u8WMlbKi/KUvZmYtrq39jgaU+BM1gqN/V+YML4mw8rZ0/7E9oJtzsuJk+j69+dmfIXwjdjjOKOwyIFGn464B0TfXZQvy0yUiVXOIAGFLRSKGANPOe1xIERz69Wz2t7dUzb1r6OF4BdtVmQK5Z14kLkZvzAFE6lNqSLsdstVIL2Fki1lpgdI6B3uvGv0FGiKS9H1e3F7uTQ9z1VlFoA4xNHCZRWo+ccgS1LjXa39ejQXMkeH/YXa+MN3EZPQwGTLaQpvlPp6/sLbvm72lE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(136003)(346002)(39860400002)(396003)(376002)(451199015)(36756003)(31696002)(186003)(54906003)(478600001)(6486002)(966005)(6512007)(6666004)(53546011)(6506007)(41300700001)(2906002)(8936002)(7416002)(6916009)(316002)(5660300002)(4326008)(66556008)(66476007)(66946007)(8676002)(38100700002)(86362001)(2616005)(83380400001)(31686004)(10126625003)(101420200003)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dDZkelRHdGVHVC8zZGZDRWNkbksvWTRRTzNWMGN0OWF1WnY2cFlycWdBcU4r?=
 =?utf-8?B?bGJjMWVnaFdlejlnQmxKY1U0RklBcTZhRGZXS1FUYWlEV2lPa3VwZWJZQnBm?=
 =?utf-8?B?bDlpQlZBbEI1YSt6MVAzakdzVzFuWWRWMWhPVFhmeGZoZzRFL2hmazlsVEFR?=
 =?utf-8?B?cURWUEE0dnBmemtMaEMzc2ZKb3FLUXZ2NEF4NW9pSXk3UlYvUEpwNkIzcXMv?=
 =?utf-8?B?OWVvRzl4bU5TeDdRNVhxL2lRT21HVlY0ZzNtQnE3Q2RZOVI3Mm5PUXVzUW90?=
 =?utf-8?B?bElkY2ZGZ0ljR2pocjVlZ0poeFNKWDNvMGd5bWpFNnBRTmsvTk02K3dIK3pB?=
 =?utf-8?B?U3lNYkNMRS8renV5V3FsY29nVm95TjIvako3MkJYV0MveVFUSGU1VmtrVE41?=
 =?utf-8?B?UnZLQVB4dThUMDVKTmhkTExKRFByMGNaTkhsQi9mWEJmN2YwbVc3U2hlaEs3?=
 =?utf-8?B?MGV5OHVqYmR3UWd5SThrVGZMNis5bHl1cEx3SGdKNVp0dW02clc2dHE4WXBY?=
 =?utf-8?B?TUlScThZMDhuWGd5MDM5aHJuaEFadlMxTFZtdEZ3V1BEekptUFR1VjRBOTlI?=
 =?utf-8?B?WkhQbVdENytSMUpnd0Q4VWZrRFluL3dab2VsaW5RRlBMQVdHTDdJaUtOczZV?=
 =?utf-8?B?RjNnK2N0UjQybUcrVDlYd2pMV2VETkxkdXZCMW9zR3hUSFlEd25rQVpCNVR0?=
 =?utf-8?B?RWVYeWpqVTlmSVpCTi84cTB3NlpubnNZeG4wZW1ya3BPbUFWNzVkQ0dGemVu?=
 =?utf-8?B?dHVkcVdlQWdSVEJJM3ZNbmJTL2Z5NTNvVHVEbE1vbitqYXo5eXZmMExlRWpN?=
 =?utf-8?B?Q1pYb09vUWJtQmYvM2JnVktUYS9yVVFjU0IvMGQ0eTgwR2IvMlBPcmNtbXhS?=
 =?utf-8?B?UWdUQkt1Q0RydkdENWpwNStXWU80Z3ppVEpOKzF3dWlCU0w1RGJiaFRMVVhB?=
 =?utf-8?B?ektWemR0UENtTHFwVi9Zb3NYMHhWclEwZkVsaS9aSWFDMTBaN05VRE5Ed1hY?=
 =?utf-8?B?V3M4c21xTm1EbDUwLzVZRmdtT2FvaDVmVndCRzlpcEEzWHQ3cU15VHNqM2hH?=
 =?utf-8?B?ODNhZjFTcDNTL3B4Z3N3U1JnOUIzMEVoakQ3T2l1SHY4SmNNdFd4ZE5ZWXVQ?=
 =?utf-8?B?ZE9KL29qVHhmNU9McGRKK0Z0ZU1qZm5CNnl2dzdYc3ZuUTArMloyLzRsTUNl?=
 =?utf-8?B?S2dtaUtqMkxjRGhhZDBRYUVXQ09qSTNTcVZWOVVaOFg3NTJPREJBajNXdHpO?=
 =?utf-8?B?UTYrcFJqaXhBSlA4Q3hpZGVOeXVVZ3c2ZVZIYytsVUY1KzhWR29DeWhpaW1a?=
 =?utf-8?B?RHVYSDFWL1pNeUd6NGYrYmxzaVRzWlJ2QmxlSTVnOXFRcWlOdjVrQTRlUVBE?=
 =?utf-8?B?Ry94bVgvNkVaajBhMkt2OE8vZVdqejRCSms5T3FJRFRaV1kvVzE2TWh0biti?=
 =?utf-8?B?bktYM1Y5b1R3K01PUS8yd0dnRnNqWi9pVDUveC9GQnJkaGtCd005clhoQVdr?=
 =?utf-8?B?Ry83dUUrcDVIL3BJQ2FZRWtvcUJqYzY1UXE3SnRIUTZGamYzM05hS3pCSWp2?=
 =?utf-8?B?dWcwRXRTWEhXM0F3a2plMWwwR0FlOG1zSE1scWtMMkl5QUhMSTFJc2ErVkox?=
 =?utf-8?B?QmpqN0dZYXdib3JWd1N4Mmo0aVkyWmcvKy9DTm1xQXBKeWVNVmtXNUE5ZVJJ?=
 =?utf-8?B?ZHdOc1FMMzRPZE9rVU5FakNUWnA1d0pycUx3OWRhc0VtVkRGbElrM25ySkto?=
 =?utf-8?B?SHZPRlpGcDlvRitwNFprSlVYZlJmTEYwTFpZREJCMVNNZGErUDJyRFpLK1po?=
 =?utf-8?B?ZzZYSC9UNmVFTTl4RzFQT3psa1NYR3lYSVYvelhQeWdDaG1SQ1dtUk00cHU4?=
 =?utf-8?B?S1lwaHdqVUxSdUNUYmxMQUFrRU5RcDVTT1hVMnVxdXRpdjdadHNubmpubnU3?=
 =?utf-8?B?K1VROXlPRC9QQzBha1NLRHFKb1pFbW4rWWNYdm9pc2hKV2NPRkc0NU82dUtM?=
 =?utf-8?B?MzVCejl4VkROS0o1Q2NaeFBGWGlCT25RRU01UktMUnh0dnVUT1ZnUnVNcjBG?=
 =?utf-8?B?UnB0SThIc0VxeFE1Y1FpWmNnQ2JGWFpmRGNKc0p0TVdXQ3NvQkZ4TVNidUdI?=
 =?utf-8?B?OG5xZkNNOTVqYk9BcXRXQ3hiRS9SZy85aDhIVmc2a0I3ZmJpRkt2bVROYlBp?=
 =?utf-8?B?d0E9PQ==?=
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 41e92293-286b-43eb-6fa8-08daf85f7a91
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jan 2023 07:50:18.9998
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: L3JFtBv4EnkkJzR/X79G7gzEnZ3wdsuXSggPcKbOIBgeMyX8pY9rRL2lm/9/0AIz
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR15MB5829
X-Proofpoint-GUID: 1xx_1C3c9ItX9AsQ0N_xz4UuofLv_lez
X-Proofpoint-ORIG-GUID: 1xx_1C3c9ItX9AsQ0N_xz4UuofLv_lez
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 5 URL's were un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.923,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-17_03,2023-01-13_02,2022-06-22_01
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/16/23 4:45 AM, Hao Sun wrote:
> 
> 
>> On 12 Jan 2023, at 2:59 PM, Yonghong Song <yhs@meta.com> wrote:
>>
>>
>>
>> On 1/9/23 5:21 AM, Hao Sun wrote:
>>> Yonghong Song <yhs@meta.com> 于2022年12月18日周日 00:57写道：
>>>>
>>>>
>>>>
>>>> On 12/16/22 10:54 PM, Hao Sun wrote:
>>>>>
>>>>>
>>>>>> On 17 Dec 2022, at 1:07 PM, Yonghong Song <yhs@meta.com> wrote:
>>>>>>
>>>>>>
>>>>>>
>>>>>> On 12/14/22 11:49 PM, Hao Sun wrote:
>>>>>>> Hi,
>>>>>>> The following KASAN report can be triggered by loading and test
>>>>>>> running this simple BPF prog with a random data/ctx:
>>>>>>> 0: r0 = bpf_get_current_task_btf      ;
>>>>>>> R0_w=trusted_ptr_task_struct(off=0,imm=0)
>>>>>>> 1: r0 = *(u32 *)(r0 +8192)       ;
>>>>>>> R0_w=scalar(umax=4294967295,var_off=(0x0; 0xffffffff))
>>>>>>> 2: exit
>>>>>>> I've simplified the C reproducer but didn't find the root cause.
>>>>>>> JIT was disabled, and the interpreter triggered UAF when executing
>>>>>>> the load insn. A slab-out-of-bound read can also be triggered:
>>>>>>> https://pastebin.com/raw/g9zXr8jU
>>>>>>> This can be reproduced on:
>>>>>>> HEAD commit: b148c8b9b926 selftests/bpf: Add few corner cases to test
>>>>>>> padding handling of btf_dump
>>>>>>> git tree: bpf-next
>>>>>>> console log: https://pastebin.com/raw/1EUi9tJe
>>>>>>> kernel config: https://pastebin.com/raw/rgY3AJDZ
>>>>>>> C reproducer: https://pastebin.com/raw/cfVGuCBm
>>>>>>
>>>>>> I I tried with your above kernel config and C reproducer and cannot reproduce the kasan issue you reported.
>>>>>>
>>>>>> [root@arch-fb-vm1 bpf-next]# ./a.out
>>>>>> func#0 @0
>>>>>> 0: R1=ctx(off=0,imm=0) R10=fp0
>>>>>> 0: (85) call bpf_get_current_task_btf#158     ; R0_w=trusted_ptr_task_struct(off=0,imm=0)
>>>>>> 1: (61) r0 = *(u32 *)(r0 +8192)       ; R0_w=scalar(umax=4294967295,var_off=(0x0; 0xffffffff))
>>>>>> 2: (95) exit
>>>>>> processed 3 insns (limit 1000000) max_states_per_insn 0 total_states 0 peak_states 0 mark_read 0
>>>>>>
>>>>>> prog fd: 3
>>>>>> [root@arch-fb-vm1 bpf-next]#
>>>>>>
>>>>>> Your config indeed has kasan on.
>>>>>
>>>>> Hi,
>>>>>
>>>>> I can still reproduce this on a latest bpf-next build: 0e43662e61f25
>>>>> (“tools/resolve_btfids: Use pkg-config to locate libelf”).
>>>>> The simplified C reproducer sometime need to be run twice to trigger
>>>>> the UAF. Also note that interpreter is required. Here is the original
>>>>> C reproducer that loads and runs the BPF prog continuously for your
>>>>> convenience:
>>>>> https://pastebin.com/raw/WSJuNnVU
>>>>>
>>>>
>>>> I still cannot reproduce with more than 10 runs. The config has jit off
>>>> so it already uses interpreter. It has kasan on as well.
>>>> # CONFIG_BPF_JIT is not set
>>>>
>>>> Since you can reproduce it, I guess it would be great if you can
>>>> continue to debug this.
>>>>
>>> The load insn ‘r0 = *(u32*) (current + 8192)’ is OOB, because sizeof(task_struct)
>>> is 7240 as shown in KASAN report. The issue is that struct task_struct is special,
>>> its runtime size is actually smaller than it static type size. In X86:
>>> task_struct->thread_struct->fpu->fpstate->union fpregs_state is
>>> /*
>>> * ...
>>> * The size of the structure is determined by the largest
>>> * member - which is the xsave area. The padding is there
>>> * to ensure that statically-allocated task_structs (just
>>> * the init_task today) have enough space.
>>> */
>>> union fpregs_state {
>>> struct fregs_state fsave;
>>> struct fxregs_state fxsave;
>>> struct swregs_state soft;
>>> struct xregs_state xsave;
>>> u8 __padding[PAGE_SIZE];
>>> };
>>> In btf_struct_access(), the resolved size for task_struct is 10496, much bigger
>>> than its runtime size, so the prog in reproducer passed the verifier and leads
>>> to the oob. This can happen to all similar types, whose runtime size is smaller
>>> than its static size.
>>> Not sure how many similar cases are there, maybe special check to task_struct
>>> is enough. Any hint on how this should be addressed?
>>
>> This should a corner case, I am not aware of other allocations like this.
>>
>> For a normal program, if the access chain looks
>> like
>> task_struct->thread_struct->fpu->fpstate->fpregs_state->{fsave,fxsave, soft, xsave},
>> we should not hit this issue. So I think we don't need to address this
>> issue in kernel. The test itself should filter this out.
> 
> Maybe I didn’t make my point clear. The issue here is that the runtime size
> of task_struct is `arch_task_struct_size`, which equals to the following,
> see fpu__init_task_struct_size():
> 
> sizeof(task_struct) - sizeof(fpregs_state) + fpu_kernel_cfg.default_size
> 
> However, the verifier validates task_struct access based on the ty info in
> btf_vmlinux, which equals to sizeof(task_struct), much bigger than `arch_
> task_struct_size` due to the `__padding[PAGE_SIZE]` in fpregs_state, this
> leads to OOB access.
> 
> We should not allow progs that access the task_struct beyond `arch_task_
> struct_size` to be loaded. So maybe we should add a fixup in `btf_parse_
> vmlinux()` to assign the correct size to each type of this chain:
> task_struct->thread_struct->fpu->fpstate->fpregs_state;
> Or maybe we should fix this during generating BTF of vmlinux?

Thanks for detailed explanation. I do understand the problem with a 
slight caveat. I mentioned if the user doing a proper access in C
code like
 
task_struct->thread_struct->fpu->fpstate->fpregs_state->{fsave,fxsave, 
soft, xsave}
we should not hit the problem if the bpf program is written to
retrieve *correct* and *expected* data.

But if the bpf program tries to access the data beyond the *correct*
boundary (i.e. beyond fpu__init_task_struct_size()), uninit mem access
might happen.

Since fpu__init_task_struct_size() might be different for different
arch features, we cannot change vmlinux BTF. We could add a check in
btf_struct_access such that if
   . btf_id references to struct task_struct
   . walked offset > arch_task_struct_size
reject the program with a verification failure.
But I kind of don't like this special case as it only happens with
*incorrect* program. Note that we won't have fault as the memory
read is protected by bpf exception handling.

