Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C58263DB0B
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 17:53:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230350AbiK3Qxj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 11:53:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229798AbiK3Qxh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 11:53:37 -0500
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA04F10FA;
        Wed, 30 Nov 2022 08:53:36 -0800 (PST)
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AUG5b0M030118;
        Wed, 30 Nov 2022 08:52:33 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=s2048-2021-q4;
 bh=JMvBGCcI0MB9dv42HUzPK3yzZzLk7tYrfTf5iuWEFzU=;
 b=fNA5vY3hti7ZBeE7+Wj9YrCUaqNiqfFVnIAtrgvp1R02MWmcHVNlItN5BF7MA0feiR4J
 v/N1dnJUeSqFBc9fROBymAeVMvqnSz258PWTnSWqQivSEI/CbKKLTxwDza/V1Rm4HOJP
 4BM8bSevxPeYYY/3ohAZRT+lhOUcizOSyECdsIcFirumNSfzwW/LzRxlFy4RS5VoZGRH
 9n5HF5UyMO7XkAnFP2Dmt9mjjGXzlVxdOLC8/L00hEB263IiKIio6XIozxWj9t41zK4H
 5XqQyJaDXiUV2IDWaXuYEpmHryab4faa7vjdHyk+Ccdi25osMTbY/DbNBNXYWCE/h3fI 9A== 
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam02lp2042.outbound.protection.outlook.com [104.47.51.42])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3m5w6af89n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 30 Nov 2022 08:52:33 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GCCCbDV9dVAg0JmjikUo6o0IMX1EpnV510IWrWIMc5gb0NDXTQ85AAL54LguqVONRFw76hMedf28wVBfPC2+6cgiVz7J5oBG6BRmrpyX/n28t2UKez4xQU2LLcRVTuoUTn9Yjd0tfYNpRQDCFAxJCRh1fHajxaKlG8dPo3/pR3MBzfZDMDJZVXy9WmrS9oBKMEbXo8TFYBxgltsjFPRqy7WQaSVGJ+yDSdnOo2EzuIKNTiKw75r30aKN24VxTl1YL+HeeKDum/j7xS5/haRk88OdIZljy8d8wUuHhqbNQ9GsCOwYjwYFYxspevxXEYzt7RumRLuFYWRiYF1JytnHQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JMvBGCcI0MB9dv42HUzPK3yzZzLk7tYrfTf5iuWEFzU=;
 b=LQBPIcvaaMM9NE8AB/67RnvDLLrClpFiR8fmVKFdaEY+jIrrJ8/NXnmpMWR4zBGvUbFbmbAYX9ks3QodksX9uWJd6xu8TilADuWlE75i/SmXqp6TJ+PZs+YoWZ9BDLkVNuSn7h9w2trCft2pCniVvXDA42BrSBuVwxcVz1xqTqEUFShcUHVoEznlchXbCeWqKcIeZiAuyE8D2OEU1M0fGSGVZYC/OIC+aKqJCLQyjfugn2k3RyBwy6hBpcq71xQ1qvsgwQMCjVODdQ7jw4sVi28dmBqzK2jtszyEZHdxXf4yACIV6LgtV7wwJQ1txvCCW55ksHx0v/Aq0+f1yUfhIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by BN6PR15MB1185.namprd15.prod.outlook.com (2603:10b6:404:ef::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.17; Wed, 30 Nov
 2022 16:52:31 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::d665:7e05:61d1:aebf]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::d665:7e05:61d1:aebf%7]) with mapi id 15.20.5857.023; Wed, 30 Nov 2022
 16:52:30 +0000
Message-ID: <a1745d9b-4bfc-50d2-8da6-7631ae2b24d0@meta.com>
Date:   Wed, 30 Nov 2022 08:52:27 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.5.0
Subject: Re: [PATCH bpf v3] selftests/bpf: Fix "missing ENDBR" BUG for
 destructor kfunc
Content-Language: en-US
To:     Chen Hu <hu1.chen@intel.com>
Cc:     jpoimboe@kernel.org, memxor@gmail.com, bpf@vger.kernel.org,
        Pengfei Xu <pengfei.xu@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Kees Cook <keescook@chromium.org>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org
References: <20221130101135.26806-1-hu1.chen@intel.com>
From:   Yonghong Song <yhs@meta.com>
In-Reply-To: <20221130101135.26806-1-hu1.chen@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-ClientProxiedBy: BYAPR03CA0018.namprd03.prod.outlook.com
 (2603:10b6:a02:a8::31) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR1501MB2064:EE_|BN6PR15MB1185:EE_
X-MS-Office365-Filtering-Correlation-Id: 0019bde5-0609-4adc-acdb-08dad2f34535
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: k1PwmAmfFyPp8KATOGj+T/W3D6fGiErQ8bXZII+spvbwjnjKtHiJ5q3/AWtz6sbAb2kFxa3Bzfx4KJs5jLouBKQp74s5PgS54zzITMz7y/FdQQbrOpz+47fHBHwkYPDohBPkvizsnH4Hj9UxtAJcySGgKeAPF8Zgn1L0xWyax3EItRAOLDv1NQZk+2Nj0fbrOxb4tbF2tU5LV8g0TQM3K3FSBXtldpRl6PwATj7zzE9qdYDAT0WyeWoH9etHa8/o1XhRK9zl5+oGG8xlKghqfWZHMj54o4unOaK0N+KYtzRVlWwjG3S5f4Y2RkkWVQ5JyySez6tZMl36Rh5S9ir/zdvvGkSv4OM2E0qaGmSsuUMfj6t9dAKSObUFgii6pI8N6aC72xJncJumAyR2EMzIAnNMtLfhBEOCvPGL3f8QL4Zx2IqaO/WpiyzA63nJDYe1EanJSlumV96NnMzy8ZFO+6doFINVLGd1FiuVzPUsDAeuYZRkLaRH//JBM340Mht1rSHHFRClJlH5a5kHOtUnn5FjuMRA8teYt5b6tBZWf1SyY8vsSTQV2kgp/tSYVPhGSHVJPnjDwn6maDYJV2nVF1OV54dB3k8Nqo9bLCycwtfdNTMaXDm1S0pc80mm5cEiQj5854mjSnm6XoKPJ8yT+MlROBCVYjli70Hss8JjKIZWZkyQ3RqOEggvFBqfcve76Py91t7XTwWe09jlCUuzUTVSNcOHXs+3/w/gpztV6pDklmyJBPC4LeowPsGQUT8/EBSHlNFInUTZXJhO2hteW4Ron1VwHfNOv1jt+gtBaIZh+V6x3M7mx7aM5eWlL5Qy
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(376002)(366004)(396003)(39860400002)(346002)(451199015)(966005)(36756003)(41300700001)(31686004)(8936002)(66556008)(53546011)(66476007)(6512007)(478600001)(8676002)(66946007)(6666004)(6486002)(2616005)(31696002)(6506007)(86362001)(54906003)(83380400001)(4326008)(2906002)(7416002)(7406005)(186003)(6916009)(316002)(5660300002)(38100700002)(21314003)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?emMrWThpeUtJQzRYUTlzUmsvK2FNdWV1YUhydHpSRFFMa3ZJNEN6V1dXK0pT?=
 =?utf-8?B?c0dGRWRVZktCTGpWWVJBZFpaY3VNRUhEL0VuSzRWQnVpUGhuRUY0OUgwejZW?=
 =?utf-8?B?bmdhSTVRRDZWMkp4SjNlWVNvMWdBa09YTFgwQ1JiVTQ2VkFnRllrSmNQaWJK?=
 =?utf-8?B?R21PL252NHhMenh6YzlIckhYRzR1ZXBXY0lmdDdwbDVZOU4rWHFVT2FCNFlE?=
 =?utf-8?B?MkJDNVAwMFVFU29MQnlZVG1mcENZdHcvOWt3Q0R5UWt0Q1hreHl5RDEwb1hM?=
 =?utf-8?B?b1FUUDFadis1TnNzc3BHSlpuWklaRy9PRWZyMjVJSHQrRGFDMXpQZURGalZZ?=
 =?utf-8?B?MVcveDVrc1VEcEYrS2E4YlNQQ3k0ODU2cURyT1g4TmpnbTlrQ2J3RXZ3M1RQ?=
 =?utf-8?B?VjM5b1ArLzE3YkRXQXlRWHNRZ1I0ZC9LQWZWMW5DbVBzV2VWS0ZSVkttM3hv?=
 =?utf-8?B?WmVwN3JqU283RFczUzlJOFpsZ3ZSNUJkZkJXVDdTUnhHMWRIRHY0Q2xDeGZm?=
 =?utf-8?B?dnNMbHpZR20xbXZjRU1jcnNxY25qUTNTeTdzaXdwN3VTTWRRSy9SZ1YvcFBX?=
 =?utf-8?B?VkNxVWV2UHJ6amdoSXZsdEJkZTMxU1pJSEExSUlCR0FzTUdrdnAxTWNZQVJD?=
 =?utf-8?B?YjFHU2lyWXI3Nm5keXBJR0dZMlZVMS9yNFdEbE1DMndrTHZENWZGWEpwaGJ3?=
 =?utf-8?B?S09LVzN6WWJIMUhmcit0amk0RnNLdS9RUTdPWEEvU2tPYlhPeXlNb1h0V09o?=
 =?utf-8?B?RkJYS25ZTmtKeGlUbEV0THVFc2hBOVhsQXY2QkRJSk1IR1h5a081cXlOdzJx?=
 =?utf-8?B?UnNJU0NWdFM2OTNyU3lNdEIzYWk4RGgxSzVSUEE2MnJoS3ZBcXExQjd5M0hU?=
 =?utf-8?B?ejkwOTlwQ2lJcGlFU0lsMXU5SkRtbk1GMTNIVjBVSWt2WU8wSW5nN3ZocUd1?=
 =?utf-8?B?QVp0eG5sLzhwU0hPZlNoTEFGYjZlcTk1RHloc1cyQzVXZEZPZVpWNStDVkts?=
 =?utf-8?B?YVZoRkFjai9wWDk1cXdUbmRLWW9WZzZ5VGE5TEoyVVI5bG9CSHRwUEhHRXQy?=
 =?utf-8?B?L041VDNrbHhFNndyL0hEWXZMYVFxVmVZdHMrU2NwZXRmSytHdGd5ci9UNDJ0?=
 =?utf-8?B?c3NQVWVobVdBR1FjT3U5ZjRuSStiOVNTV0ZLMjFxZDBUM25ORGp0SzBEWVJz?=
 =?utf-8?B?N24zeVBrOHVmNG1tblFlSXdBWEhHTzBFcStlQk9FYmRTY0Z6RGtUSFdqQWdY?=
 =?utf-8?B?L21adFVMZFQrVmQxQXJGd1FISnh4d0xqZDJ5b3ZRa3F6K0FrZ3hzSWtCSVEx?=
 =?utf-8?B?NCsxaTYwd0k1MGxNMmhpUHB4b0dyanVudEx2eDNDaDB1ZUd4cjh4ODhYRVp3?=
 =?utf-8?B?bUlWMEZkVDVvMFdvMkYzeFlReE9HZU9nV3lON1MveDB0RkV3TEpRZGtGUm5a?=
 =?utf-8?B?S2NNdFBMSy9xY2MxNXlaRXc2TkswdWFENnR1eklONnYzd1h0OWd1Rm9pVVdQ?=
 =?utf-8?B?d0JZVUdiYW83TWo2VnNnYlVPbzB6SUJRRlpYWFVpd1VkZ1dPazNodzZCVFpS?=
 =?utf-8?B?SFFtWnFrNnhzRkZuc0xyd0JqSDdoLytTci9uSnYzRmZMbjJUWkxrWkJYUzZW?=
 =?utf-8?B?OXRHMWVGUzE0MndmNmJ2SmdBUlhkZ2lTUVZ0UjJzb1QrcU9CWjYxR3VwVHFG?=
 =?utf-8?B?aFU3Skx3TWJ2S1h3dDV3SzREOFFHNEtYUzU0V1AveW5SZUJtY1ZwK2lXbXBC?=
 =?utf-8?B?UzRsblkyMXAvYVBOelhHRHF4MDlhZHN2UE01Rm5pQ1BLL2o1UlRpSkZZaUlV?=
 =?utf-8?B?SG9wTmE0ZnR3djVjWGl0clo5Vmxna1lwKzlIZnI0S1FyRU9XdG9vdDA4bnNR?=
 =?utf-8?B?c0tKdlRXLzJQdnphaDZKakt2WWNJKzVuSGVTUXZKMDZ1ZTVIcEZ6cG1TUFBN?=
 =?utf-8?B?T3hmWERBR2VoMEU1TGw0emNhQkd1S3Z2a2NPeG9uTW5uRE9MQUVGVFdxRXhN?=
 =?utf-8?B?S0syRmZZdzJCM2l2WHN1Zno5d1gyanRRdmdEVEpNbDRKcjJ5Skdaa2FTRnN1?=
 =?utf-8?B?K3Voci95bjhJWG9KcmdXM21ZZTB4OWREclhwR3NRRXIvY29uZXZYVStLelBP?=
 =?utf-8?B?eVV2VVNBVzdjb0JtZUhZSUFWYjRpeHl3bVZrYzFXR0dRNEY2MXVrN1cydXIr?=
 =?utf-8?B?ZkE9PQ==?=
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0019bde5-0609-4adc-acdb-08dad2f34535
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Nov 2022 16:52:30.8565
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vxmjD+cJJb1X5fu83O1iXpUfwvhT4KNRBkYILW2tAXb/6kg/rDpKzWtPTs94vlot
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR15MB1185
X-Proofpoint-ORIG-GUID: 85hyFoXotEJvcsBpBTFW5WOHOFHk5x8V
X-Proofpoint-GUID: 85hyFoXotEJvcsBpBTFW5WOHOFHk5x8V
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-30_04,2022-11-30_02,2022-06-22_01
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/30/22 2:11 AM, Chen Hu wrote:
> With CONFIG_X86_KERNEL_IBT enabled, the test_verifier triggers the
> following BUG:
> 
>    traps: Missing ENDBR: bpf_kfunc_call_test_release+0x0/0x30
>    ------------[ cut here ]------------
>    kernel BUG at arch/x86/kernel/traps.c:254!
>    invalid opcode: 0000 [#1] PREEMPT SMP
>    <TASK>
>     asm_exc_control_protection+0x26/0x50
>    RIP: 0010:bpf_kfunc_call_test_release+0x0/0x30
>    Code: 00 48 c7 c7 18 f2 e1 b4 e8 0d ca 8c ff 48 c7 c0 00 f2 e1 b4 c3
> 	0f 1f 44 00 00 66 0f 1f 00 0f 1f 44 00 00 0f 0b 31 c0 c3 66 90
>         <66> 0f 1f 00 0f 1f 44 00 00 48 85 ff 74 13 4c 8d 47 18 b8 ff ff ff
>     bpf_map_free_kptrs+0x2e/0x70
>     array_map_free+0x57/0x140
>     process_one_work+0x194/0x3a0
>     worker_thread+0x54/0x3a0
>     ? rescuer_thread+0x390/0x390
>     kthread+0xe9/0x110
>     ? kthread_complete_and_exit+0x20/0x20
> 
> It turns out that ENDBR in bpf_kfunc_call_test_release() is converted to
> NOP by apply_ibt_endbr().
> 
> The only text references to this function from kernel side are:
> 
>    $ grep -r bpf_kfunc_call_test_release
>    net/bpf/test_run.c:noinline void bpf_kfunc_call_test_release(...)
>    net/bpf/test_run.c:BTF_ID_FLAGS(func, bpf_kfunc_call_test_release, ...)
>    net/bpf/test_run.c:BTF_ID(func, bpf_kfunc_call_test_release)

We have some other function like this. For example, some newly added
functions like bpf_obj_new_impl(), bpf_obj_drop_impl(), do they have
the same missing endbr problem? If this is the case, we need a
general solution.

> 
> but it may be called from bpf program as kfunc. (no other caller from
> kernel)
> 
> This fix creates dummy references to destructor kfuncs so ENDBR stay
> there.
> 
> Also modify macro XXX_NOSEAL slightly:
> - ASM_IBT_NOSEAL now stands for pure asm
> - IBT_NOSEAL can be used directly in C
> 
> Signed-off-by: Chen Hu <hu1.chen@intel.com>
> Tested-by: Pengfei Xu <pengfei.xu@intel.com>
> ---
> v3:
> - Macro go to IBT related header as suggested by Jiri Olsa
> - Describe reference to the func clearly in commit message as suggested
>    by Peter Zijlstra and Jiri Olsa
>   
> v2: https://lore.kernel.org/all/20221122073244.21279-1-hu1.chen@intel.com/
> 
> v1: https://lore.kernel.org/all/20221121085113.611504-1-hu1.chen@intel.com/
> 
>   arch/x86/include/asm/ibt.h | 6 +++++-
>   arch/x86/kvm/emulate.c     | 2 +-
>   net/bpf/test_run.c         | 5 +++++
>   3 files changed, 11 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/include/asm/ibt.h b/arch/x86/include/asm/ibt.h
> index 9b08082a5d9f..be86dc31661c 100644
> --- a/arch/x86/include/asm/ibt.h
> +++ b/arch/x86/include/asm/ibt.h
> @@ -36,11 +36,14 @@
>    * the function as needing to be "sealed" (i.e. ENDBR converted to NOP by
>    * apply_ibt_endbr()).
>    */
> -#define IBT_NOSEAL(fname)				\
> +#define ASM_IBT_NOSEAL(fname)				\
>   	".pushsection .discard.ibt_endbr_noseal\n\t"	\
>   	_ASM_PTR fname "\n\t"				\
>   	".popsection\n\t"
>   
> +#define IBT_NOSEAL(name)				\
> +	asm(ASM_IBT_NOSEAL(#name))
> +
>   static inline __attribute_const__ u32 gen_endbr(void)
>   {
>   	u32 endbr;
> @@ -94,6 +97,7 @@ extern __noendbr void ibt_restore(u64 save);
>   #ifndef __ASSEMBLY__
>   
>   #define ASM_ENDBR
> +#define ASM_IBT_NOSEAL(name)
>   #define IBT_NOSEAL(name)
>   
>   #define __noendbr
> diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
> index 4a43261d25a2..d870c8bb5831 100644
> --- a/arch/x86/kvm/emulate.c
> +++ b/arch/x86/kvm/emulate.c
> @@ -327,7 +327,7 @@ static int fastop(struct x86_emulate_ctxt *ctxt, fastop_t fop);
>   	".type " name ", @function \n\t" \
>   	name ":\n\t" \
>   	ASM_ENDBR \
> -	IBT_NOSEAL(name)
> +	ASM_IBT_NOSEAL(name)
>   
>   #define FOP_FUNC(name) \
>   	__FOP_FUNC(#name)
> diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
> index fcb3e6c5e03c..9e9c8e8d50d7 100644
> --- a/net/bpf/test_run.c
> +++ b/net/bpf/test_run.c
> @@ -601,6 +601,11 @@ noinline void bpf_kfunc_call_memb_release(struct prog_test_member *p)
>   {
>   }
>   
> +#ifdef CONFIG_X86_KERNEL_IBT
> +IBT_NOSEAL(bpf_kfunc_call_test_release);
> +IBT_NOSEAL(bpf_kfunc_call_memb_release);
> +#endif
> +
>   noinline void bpf_kfunc_call_memb1_release(struct prog_test_member1 *p)
>   {
>   	WARN_ON_ONCE(1);
