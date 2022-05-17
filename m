Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AE2352AD94
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 23:35:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229558AbiEQVfT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 17:35:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbiEQVfR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 17:35:17 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0ED922253D;
        Tue, 17 May 2022 14:35:17 -0700 (PDT)
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24HKFEso032110;
        Tue, 17 May 2022 14:35:00 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=dRKIZXpiJ8Nu+zU5Md0Ps3RnaveEOY+QJfG1AWhsJak=;
 b=TuBYfIHJRer7tv1vA+TogKDeBHkR39Eg8bQFvbk80QDGsml51xWqDMPV+MYnOZNXLeeK
 oKDB9xAPZfgpXyzHKs5y5jN4lDrXjmKRnsQdN3aCdrPux3bZcebG3/obRxj8scXLWj+Y
 Pcj2YlpZi0QW0GEU/Gw9MSC08WgOsziA0wQ= 
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2046.outbound.protection.outlook.com [104.47.57.46])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3g4ck0bn8v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 May 2022 14:34:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZO/QndaAFM8rlDATvZUn81xyaDTVzUfVsea/8YFNlSb5v+0dDBJ4sPhxTpN90tnUk9LRiVtk4CAwh+knDUOzhkafixNL+nIP9+getlUtNpnQN4liB0IqSVQbkggRmwHyVECjwKihX7BsbvVxXSZHWzu2mifIkY5GqtMoqASCE/U3+nwNhSLcLSu1btPSZBmLazRFUZCMasSufm+g7hKkdqTfPNOXLRNKj9Zwf+wwIrgygDWwrCBjyWhWvvY8pfhloykJ7Tsq2AxdRz18XsCq6iJyKmqcPU+c0B6NwhelnBYetSHGgrxNrs34l5CRGMe4AG2x67CdpWhKlZmFpzhRxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dRKIZXpiJ8Nu+zU5Md0Ps3RnaveEOY+QJfG1AWhsJak=;
 b=TzuAyZwIoDh40zPjL36o5WT6j+E9SkEH2PARyxI5RRis2X/kHng76d6Snt7Zjosv2iLSawSlXc8RnXTOvPX13g8H9Ye1SzAR/bC6ZGFScx+a85bxQY4pZCa6QKwH6+y0fEs6qQCvNRuFgHg1bLO8rroVa73jUiizleeXdidBJIxahLaQORJOwzi/3N4aOEuXnXqf1k9ge5wN+9we4spOL/mRmREZuCwPJPHA5wmBYnenyTx18FYNoDvi1W+7EhP+fZUkTnPGqpsohgsADdTI/idznHthgENIukKBhlo1zn8QrQPj4RNxB37TPrUWCCAeRHn5bkdDWEt7cONf4zAUgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by CY5PR15MB5438.namprd15.prod.outlook.com (2603:10b6:930:3a::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.18; Tue, 17 May
 2022 21:34:57 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::5811:4996:bbfd:3c53]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::5811:4996:bbfd:3c53%7]) with mapi id 15.20.5273.013; Tue, 17 May 2022
 21:34:57 +0000
Message-ID: <7c5e64f2-f2cf-61b7-9231-fc267bf0f2d8@fb.com>
Date:   Tue, 17 May 2022 14:34:55 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.0
Subject: Re: [PATCH bpf-next v3 4/4] bpf_trace: pass array of u64 values in
 kprobe_multi.addrs
Content-Language: en-US
To:     Jiri Olsa <olsajiri@gmail.com>,
        Eugene Syromiatnikov <esyr@redhat.com>
Cc:     Masami Hiramatsu <mhiramat@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        Shuah Khan <shuah@kernel.org>, linux-kselftest@vger.kernel.org
References: <cover.1652772731.git.esyr@redhat.com>
 <6ef675aeeea442fa8fc168cd1cb4e4e474f65a3f.1652772731.git.esyr@redhat.com>
 <YoNnAgDsIWef82is@krava> <20220517123050.GA25149@asgard.redhat.com>
 <YoP/eEMqAn3sVFXf@krava>
From:   Yonghong Song <yhs@fb.com>
In-Reply-To: <YoP/eEMqAn3sVFXf@krava>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0P220CA0028.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:a03:41b::11) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 25240ba4-7671-4839-0495-08da384d170c
X-MS-TrafficTypeDiagnostic: CY5PR15MB5438:EE_
X-Microsoft-Antispam-PRVS: <CY5PR15MB5438D00416F6222FE5F96784D3CE9@CY5PR15MB5438.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0RXa6J31cOChIfCwynoYccKjax+2KHgp2XcxFTn1rhdzE8W5Rpko+/GqiBQ5WbGVeJlP7PUUcjNmWEtSO5xWKhfYtZex4mIJkVB5SLNkH5KRltf1XuLcoa+t8A5qeIDKxNa9FEdDxASjsYk53Fr+m0jfbrg6K3lEPiP6evnAPs0XDRf3WKKcCinik/FKafmbXQ9r+cfzOUFCvd8OjjtDkLfBvuw7tiROljLtdSwHdH8d0NVu6cNbFrRYeiuRzxbOJ/FFYdhujVoQSB2kqFKxVaiUueLmvvzc8yXKleZK/ah62UsAPRZwwmTVdEZ+Mgj3H45MKOPCg9UeviuMl/lhBgIYLQSfVFA3ft5v6cmjI++aZEOJoVCztkfWwg+xXgha+v5Z7K+pNorLWygzTfLM4aVp7A784ZIC+7hCUPABNra1YR4foq22C9AB+oC1bMwMNd63mwtaZiyFJpxDxcEJ7RmltmYTUrs5iqyrKW/A2Z9ms3HY7atIq5iWjVSl6fC2X9TAC9OmAmwKXNUij/G+AUGPdIKDk+eyrcOR8w9OKRlbDp07t4l8GC3fVHIZfd67OTHaFAHKlrOyHu7COCu/H3bFi2TsDW1LPw8xs0VlljdqOS/dKkFN6Bp+UBEm2SbLwrKU9cUzCxM5Fs3CcHLc2kpe7mbq0Qmjykkt5D3zRKx/YMYaIWONJlWEGj8wPsKnD2Uh4njW8Mz3yO4l6sJnlujYy4z7BLLsLNWApDobQPeRLYNfIykyY1893M9U8dkA
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(316002)(36756003)(31686004)(5660300002)(6506007)(7416002)(6486002)(86362001)(54906003)(8936002)(66946007)(66476007)(110136005)(2616005)(31696002)(508600001)(52116002)(66556008)(4326008)(83380400001)(8676002)(2906002)(38100700002)(53546011)(186003)(6512007)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?a3RXbE80eGorKzQwQzFIYytXK2lTK083Z2FRdnZmaFh4SHZuaUtHVGdQeEk1?=
 =?utf-8?B?c0VlaHE0WDdyWWUxUlVYM09iVjNmck9IS200WHB2cWttdHBHc25TVjVMMXRv?=
 =?utf-8?B?NDNJR2R4ZEtVM1JQKzYwOVFoVzkxZzRSTzl4clR6cVl4L2ErNm5QaklyeU9N?=
 =?utf-8?B?WW9VZFUzRXlhN1JNSTg1VFIzenJkSDhmNGpSRWU0QlBtVnRMWm5mZFQyZUpq?=
 =?utf-8?B?SmJyeDVNbEpabC9tY3Y4WkVhNEUxM3o5eHNndEVYbUlTSS82UFFwRzBVOHRj?=
 =?utf-8?B?d2xnUDVXbVlYVElVcC9zRXVDYUxvKzgwaHkxZ0xVMU5GSHBiK1hZbkk5clRD?=
 =?utf-8?B?M1hMSS8rK24zelBFaDM2cGVsNGxqRWJzMTM1Q0pTb2p6UEd3YmNrNFI1c2Vz?=
 =?utf-8?B?WElPaW94aWh3azU2YjZSb2xHSzR2VmozUnUxZTF2eUJyM3FJY0RNbWpLaTNn?=
 =?utf-8?B?U2lzUmFZMjBWT01rdXBGZkl0VVVIdnFNd2RPYlgrWUNvcjhkcmxnNlhaY3pH?=
 =?utf-8?B?V215VlcxWFIyNHV3V05iU3hhOGV1ZVpWbXhwbldCOUdXNWNScm5EQVlTMXI0?=
 =?utf-8?B?c1hpdFFoaHlhUWd4MVNVK3pJYzROdDB3NmR5NWpwUkZNT2h3U3VLSWpOTyta?=
 =?utf-8?B?eXdqWWNDREJwcnM0R21XSUJFNkJzb1BjVDUxckwzRzJGSTBROFU5b1dZNHlR?=
 =?utf-8?B?RU9PUHFVUzFMTzY1VzR3SzdIbkwrMnRyRkFQVHFLcldhMGt4S2s1a0E2YU1R?=
 =?utf-8?B?Y2h0YUk3c2JvR1JIS3RIWjZSMEZZdmVaSm5DZDBlL2k2TTBVbDFTRzZGN3Nl?=
 =?utf-8?B?OEJkeWtYNjRGQW14WHFheTl1bWREQk03bWpveDBMWXJ4Y1N2Z2xDOW9WeGtt?=
 =?utf-8?B?eW9oTk4vVGlCWlpPMG9nSjRVdGs3bzZWbjRvVWJGaVdHbUQ3MXdSekRVTG1R?=
 =?utf-8?B?SktvZTM3VTVTdDVEZzB3TU5aYXJna2ZvQkxuUHBpNmhuK1owb2txQ2ozcWpR?=
 =?utf-8?B?T2tab1Vpb25lSGIva3lnbWtBL2llQWppV3B5cWJtWndGcWNkOWNQVjMvdzVF?=
 =?utf-8?B?ckNNbndVS2ZxbFFtRDc4SW5IdFFvZEh3K1dHNXJwalhkbGF6dk0yMmt0U0NL?=
 =?utf-8?B?YjZHSUR4RDVzMnVrTENzZzVlMVc0bzdwUm9vTytSanRmM29ncTl3cVFaTDJ4?=
 =?utf-8?B?WDZTQTZGM082aDZFTVAyUy9HdTlPbkpwZWRsZmxHV2x6VTU4UDBseHEvWDZ1?=
 =?utf-8?B?Mm52K3VtSjlhSHgyUUxQamx2MnZ3RTFYOTBURHAxNVBGKzZxYXJoc1pzbk9D?=
 =?utf-8?B?ZHNiN1l0aVJGMjJweHd3N05YNkcrMlBLUnV5bFVSbkloZEhUZTNBMUZXYUww?=
 =?utf-8?B?eitFVVJwa2tzaTNlK01iMWRuU0QyODZaZHFFS210QkVEdmJkOW8yT1VUbUpG?=
 =?utf-8?B?c0UzTThhcHJGVTBKZlhsRTlmZFFwVVQxRHY3MmZCRlJMTXI4Tm41b2J6S0pJ?=
 =?utf-8?B?K2dpMUFpNWNLTFVBQXVVaUw2eFh1eUdSd0szbU1scW1vclVDMUFTbjI1NzBB?=
 =?utf-8?B?MGk4eWdqODlmZ0ZyMm13c3JNRHZqVHNITEtXZ1JSdG02Z0hxWmszWGdHVWtG?=
 =?utf-8?B?dmw0WmJsK3lZSGladVZaQytBWnFENktrQnNYSms4TmEycFhyYlVzRTNORHBM?=
 =?utf-8?B?YjN5cFhjL2JuZEhDMnhyeWlBU0VIY0p0ckMvTXorV2dZVEc1emdUdzdZajRl?=
 =?utf-8?B?QmpxZHNBZHRCTkN0WXdlTmVHN3ptREc4Z2d6VWFMTGltSHpBQmFjd2lRTVdX?=
 =?utf-8?B?M1B6SXhzOE9JM1VHalBiaUxwNGNDbkp4S083WkxGeDgvbEJTQVBZREpqa2dY?=
 =?utf-8?B?bFpwUGdka3ZYR0gvTG1YeTFNR1FaVHJmc3pKVUI3Qjg2RVZVVUFXemNVR1RI?=
 =?utf-8?B?aXd6d1dMR0dKVXRqVytwUWp2RXgyRW9FQ1dmY2J1Q2d1SGxONnNRR1RQSTFo?=
 =?utf-8?B?WFJ3T3p4RkM0VTdYRldnbmVmU3dqMmJSLzNwYmdzU3A4eWhXVVhZRWFUOHRq?=
 =?utf-8?B?U1N3TUVoYy84VUg4aGVJanhqZVlCVnk2bk9jai9wSGVJNG1JRGpuNDVxMmov?=
 =?utf-8?B?UjhDNGJDb1FoUkI0S1ljazZ6R2JPTnd3eUhZOGxOMDRhRjZpSEFLc29FT3FS?=
 =?utf-8?B?RU9KVVRQeEw1RkoxNzRpajk1NUs2eHoreHdqdWcrN09uWllBZXdzSCtWRlJP?=
 =?utf-8?B?c0xlZjdyZk9zVmZrem4wQ3E0ZHVtN3JYeGNNdmVFdWh2UEpSN1ZpZjB1REww?=
 =?utf-8?B?TEkrWnRaSXRmMzg4RzFxdStVUXdzUmhVeUZhQzJrU1dSc3JFdTFDbnYrVmVp?=
 =?utf-8?Q?dsoq04XfSog9Q/Gg=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 25240ba4-7671-4839-0495-08da384d170c
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2022 21:34:57.8053
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pILo477J5QDUuWhOrApxewTsLrPwsWf0f+vgAoWgJYqBIMzscHwmBRVGFxAQ0h62
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR15MB5438
X-Proofpoint-GUID: hTePkdP3bN4eRk0vfBve2RTuXB0o_sm8
X-Proofpoint-ORIG-GUID: hTePkdP3bN4eRk0vfBve2RTuXB0o_sm8
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-17_03,2022-05-17_02,2022-02-23_01
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/17/22 1:03 PM, Jiri Olsa wrote:
> On Tue, May 17, 2022 at 02:30:50PM +0200, Eugene Syromiatnikov wrote:
>> On Tue, May 17, 2022 at 11:12:34AM +0200, Jiri Olsa wrote:
>>> On Tue, May 17, 2022 at 09:36:47AM +0200, Eugene Syromiatnikov wrote:
>>>> With the interface as defined, it is impossible to pass 64-bit kernel
>>>> addresses from a 32-bit userspace process in BPF_LINK_TYPE_KPROBE_MULTI,
>>>> which severly limits the useability of the interface, change the ABI
>>>> to accept an array of u64 values instead of (kernel? user?) longs.
>>>> Interestingly, the rest of the libbpf infrastructure uses 64-bit values
>>>> for kallsyms addresses already, so this patch also eliminates
>>>> the sym_addr cast in tools/lib/bpf/libbpf.c:resolve_kprobe_multi_cb().
>>>
>>> so the problem is when we have 32bit user sace on 64bit kernel right?
>>>
>>> I think we should keep addrs as longs in uapi and have kernel to figure out
>>> if it needs to read u32 or u64, like you did for symbols in previous patch
>>
>> No, it's not possible here, as addrs are kernel addrs and not user space
>> addrs, so user space has to explicitly pass 64-bit addresses on 64-bit
>> kernels (or have a notion whether it is running on a 64-bit
>> or 32-bit kernel, and form the passed array accordingly, which is against
>> the idea of compat layer that tries to abstract it out).
> 
> hum :-\ I'll need to check on compat layer.. there must
> be some other code doing this already somewhere, right?

I am not familiar with all these compatibility thing. But if we
have 64-bit pointer for **syms, maybe we could also have
64-bit pointer for *syms for consistency?

> jirka
> 
>>
>>> we'll need to fix also bpf_kprobe_multi_cookie_swap because it assumes
>>> 64bit user space pointers
>>>
>>> would be gret if we could have selftest for this
>>>
>>> thanks,
>>> jirka
>>>
>>>>
>>>> Fixes: 0dcac272540613d4 ("bpf: Add multi kprobe link")
>>>> Fixes: 5117c26e877352bc ("libbpf: Add bpf_link_create support for multi kprobes")
>>>> Fixes: ddc6b04989eb0993 ("libbpf: Add bpf_program__attach_kprobe_multi_opts function")
>>>> Fixes: f7a11eeccb111854 ("selftests/bpf: Add kprobe_multi attach test")
>>>> Fixes: 9271a0c7ae7a9147 ("selftests/bpf: Add attach test for bpf_program__attach_kprobe_multi_opts")
>>>> Fixes: 2c6401c966ae1fbe ("selftests/bpf: Add kprobe_multi bpf_cookie test")
>>>> Signed-off-by: Eugene Syromiatnikov <esyr@redhat.com>
>>>> ---
>>>>   kernel/trace/bpf_trace.c                           | 25 ++++++++++++++++++----
>>>>   tools/lib/bpf/bpf.h                                |  2 +-
>>>>   tools/lib/bpf/libbpf.c                             |  8 +++----
>>>>   tools/lib/bpf/libbpf.h                             |  2 +-
>>>>   .../testing/selftests/bpf/prog_tests/bpf_cookie.c  |  2 +-
>>>>   .../selftests/bpf/prog_tests/kprobe_multi_test.c   |  8 +++----
>>>>   6 files changed, 32 insertions(+), 15 deletions(-)
>>>>
>>>> diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
>>>> index 9d3028a..30a15b3 100644
>>>> --- a/kernel/trace/bpf_trace.c
>>>> +++ b/kernel/trace/bpf_trace.c
>>>> @@ -2454,7 +2454,7 @@ int bpf_kprobe_multi_link_attach(const union bpf_attr *attr, struct bpf_prog *pr
>>>>   	void __user *ucookies;
>>>>   	unsigned long *addrs;
>>>>   	u32 flags, cnt, size, cookies_size;
>>>> -	void __user *uaddrs;
>>>> +	u64 __user *uaddrs;
>>>>   	u64 *cookies = NULL;
>>>>   	void __user *usyms;
>>>>   	int err;
>>>> @@ -2486,9 +2486,26 @@ int bpf_kprobe_multi_link_attach(const union bpf_attr *attr, struct bpf_prog *pr
>>>>   		return -ENOMEM;
>>>>   
>>>>   	if (uaddrs) {
>>>> -		if (copy_from_user(addrs, uaddrs, size)) {
>>>> -			err = -EFAULT;
>>>> -			goto error;
>>>> +		if (sizeof(*addrs) == sizeof(*uaddrs)) {
>>>> +			if (copy_from_user(addrs, uaddrs, size)) {
>>>> +				err = -EFAULT;
>>>> +				goto error;
>>>> +			}
>>>> +		} else {
>>>> +			u32 i;
>>>> +			u64 addr;
>>>> +
>>>> +			for (i = 0; i < cnt; i++) {
>>>> +				if (get_user(addr, uaddrs + i)) {
>>>> +					err = -EFAULT;
>>>> +					goto error;
>>>> +				}
>>>> +				if (addr > ULONG_MAX) {
>>>> +					err = -EINVAL;
>>>> +					goto error;
>>>> +				}
>>>> +				addrs[i] = addr;
>>>> +			}
>>>>   		}
>>>>   	} else {
>>>>   		struct user_syms us;
>>>> diff --git a/tools/lib/bpf/bpf.h b/tools/lib/bpf/bpf.h
>>>> index 2e0d373..da9c6037 100644
>>>> --- a/tools/lib/bpf/bpf.h
>>>> +++ b/tools/lib/bpf/bpf.h
>>>> @@ -418,7 +418,7 @@ struct bpf_link_create_opts {
>>>>   			__u32 flags;
>>>>   			__u32 cnt;
>>>>   			const char **syms;
>>>> -			const unsigned long *addrs;
>>>> +			const __u64 *addrs;
>>>>   			const __u64 *cookies;
>>>>   		} kprobe_multi;
>>>>   		struct {
>>>> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
>>>> index ef7f302..35fa9c5 100644
>>>> --- a/tools/lib/bpf/libbpf.c
>>>> +++ b/tools/lib/bpf/libbpf.c
>>>> @@ -10737,7 +10737,7 @@ static bool glob_match(const char *str, const char *pat)
>>>>   
>>>>   struct kprobe_multi_resolve {
>>>>   	const char *pattern;
>>>> -	unsigned long *addrs;
>>>> +	__u64 *addrs;
>>>>   	size_t cap;
>>>>   	size_t cnt;
>>>>   };
>>>> @@ -10752,12 +10752,12 @@ resolve_kprobe_multi_cb(unsigned long long sym_addr, char sym_type,
>>>>   	if (!glob_match(sym_name, res->pattern))
>>>>   		return 0;
>>>>   
>>>> -	err = libbpf_ensure_mem((void **) &res->addrs, &res->cap, sizeof(unsigned long),
>>>> +	err = libbpf_ensure_mem((void **) &res->addrs, &res->cap, sizeof(__u64),
>>>>   				res->cnt + 1);
>>>>   	if (err)
>>>>   		return err;
>>>>   
>>>> -	res->addrs[res->cnt++] = (unsigned long) sym_addr;
>>>> +	res->addrs[res->cnt++] = sym_addr;
>>>>   	return 0;
>>>>   }
[...]
