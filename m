Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2D6E4CE7E8
	for <lists+netdev@lfdr.de>; Sun,  6 Mar 2022 01:29:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231726AbiCFA3r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Mar 2022 19:29:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229752AbiCFA3p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Mar 2022 19:29:45 -0500
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59B812459D;
        Sat,  5 Mar 2022 16:28:55 -0800 (PST)
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 2260GglS008965;
        Sat, 5 Mar 2022 16:28:24 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=xgDAwZn7LcPztf2SO5Kv1GXtqWRlzRQpjBiYdrFdRR8=;
 b=pMtjizTErhJWASxaGTnp74v0v90DZdXvYFtutkBDeAk2GPZcxC6FA9yefIIhgnFnxjJw
 N4JcwGDbyeS5vLJHOey8rytTwVGFnvSmyZKqDroVDXQ8Ijlww6MK/bN9mflhEez3BcdQ
 eBLjYhUxWC8cnGS3Kgb0Mu3XIxpdu1LCW6I= 
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2046.outbound.protection.outlook.com [104.47.66.46])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3em5uw2nu2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 05 Mar 2022 16:28:23 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Fhf0VZHN+TxjdN6SQrXCRqszJHSP5lIwtR8Bb/Jt5O4Mu42S4FfrE14/kzpjeQChkfKSwc6po/bevLFsrgUkfGGu47cYqxUMUPjAGsakRvNqDBYXzEdfjgZ0AUfBtc5TvwTa8vXEXutIlhSWe9ackocF6k6Ch6Dgf5Sq+VvqOKslfwKslb6QdpdF3GFmo+CXlaFADHb07wGVLXGFbH2nJzt2eizdYUnDtpL4xSHttZ/roBswUq2dxBSuhWdfYUYVzQ1kN8OSTr2WOFohd0sLVX5FSNWsH9EOmf+rZj3kIgAn3UJXRj1zhvtibHWrzYhM5Xwi7EzH6/TNoFthuyeIjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xgDAwZn7LcPztf2SO5Kv1GXtqWRlzRQpjBiYdrFdRR8=;
 b=ZINJZ4FE7kCveRvtW5PgCjSdAhojGX03lEXWLPFSyPDADeauJJKwoGk3SnrIoeX2H+fdLKuTLiZy4d9HSMPBYdJR6lljYOt8vMQxkZGoX6OM/1zSIExcXRDwjZpcn8QSSCvkFG53dyAiGDWoc8e+ngFKAllMiOfimC07jwZrL/S7fobyzCFwSCzCXPwDyaJZqfoTSWQbwcmuaWqqkSklEhHe73UGHE2mYcOD0Qyk7k5rC5PpA+/Yg3sw8TZbvS6F88i9Iuwnh9hDhQnRetxCe17Sj6P+hPKrb7jyY3IjL3uT6FsrnNeJd09JkTPUtMmz/WTnY4HkNkavjt69NtgZBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from DM5PR1501MB2055.namprd15.prod.outlook.com (2603:10b6:4:a1::13)
 by BY3PR15MB4834.namprd15.prod.outlook.com (2603:10b6:a03:3b5::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Sun, 6 Mar
 2022 00:28:21 +0000
Received: from DM5PR1501MB2055.namprd15.prod.outlook.com
 ([fe80::df:de9c:3b7c:7903]) by DM5PR1501MB2055.namprd15.prod.outlook.com
 ([fe80::df:de9c:3b7c:7903%5]) with mapi id 15.20.5038.017; Sun, 6 Mar 2022
 00:28:21 +0000
Message-ID: <38f99862-e5f4-0688-b5ef-43fa6584b823@fb.com>
Date:   Sat, 5 Mar 2022 16:28:17 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.1
Subject: Re: [RFC] A couple of issues on BPF callstack
Content-Language: en-US
To:     Namhyung Kim <namhyung@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Eugene Loh <eugene.loh@oracle.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Hao Luo <haoluo@google.com>
References: <20220304232832.764156-1-namhyung@kernel.org>
From:   Yonghong Song <yhs@fb.com>
In-Reply-To: <20220304232832.764156-1-namhyung@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-ClientProxiedBy: MWHPR2201CA0051.namprd22.prod.outlook.com
 (2603:10b6:301:16::25) To DM5PR1501MB2055.namprd15.prod.outlook.com
 (2603:10b6:4:a1::13)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c504c9b8-2409-4f5c-b7b1-08d9ff0837df
X-MS-TrafficTypeDiagnostic: BY3PR15MB4834:EE_
X-Microsoft-Antispam-PRVS: <BY3PR15MB483478F020D4A57076BD7422D3079@BY3PR15MB4834.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /1D1daYc5Hgjlh1BOsxTF33dPyFOIEzYuxiqq38xUg2XYCaFf0KjfTWcVxfE3bXOOLkHeAZE7UxKwZhK8g7/0gP1NSwdIzCy5HONf3FaPDk5q0DJEQiMnzGyl8ORsrOc00hUUjP2M6+Bq04hxNRahuvyrNMDBdFQQif1cc31wZUDo+Vswm2mMLdkR6HRtBrKApzCDgmngTZEq2CmT7IN1r2HN3LIm512Nzml90vmeVcC0Qb8cHwvU2zDtgDkiYgNhhtTjL3eN5A+FvdXReh7vmIS0u3qj+KR76iJpaU0hkDYzRP3PJyghsAPeXm/SKEDRrlg36nJ7BncKwVLhM9LoHvw1SqeYb2BA/CErqWg254uCw7uZVwSK5Bboe5C9U+N+f8DPq3pZqGszGaTOnbjgL3LHa5QDTIFCoqRJvDsJ1W/FaB2bXHFHj9Z2byUripMIqzCdl2Pnotxc+GqaPYIQEvjsopbm+NnZ0px2KhQGZRZvOo3CUE7LVT6Kp72zl6mEmZIqDB2nSFdEoeJAkmwMWCo9pCH44MH5KJjYmmv25RVy1S8ATO94L0bTo9146nHz6JDy5UsoX0uGMlZXr4YiwLAFS6gNEAOlvJWSj9GzvR3gkUrjabq/+s4zFPcPmdkGIlzU0MOPWOP78kOPtP4/I98CL0BKz9fh0tK1ZdEXhvg8WA3ThL0fhzKOVZ0JYAVbNxsxG0r4qjNdfuwH/Yqy/NPR/GBiCzsBGTxFRI92abIS+qbjyYWFCrRuLMdt1O525lu5gBeivfHIT0Rowp1B9aTbVnS/zOrb/QnVFUDqWXP/1uLM4abo+2OvuZTXT9DsmdOsDeZCIf9RlD4t6kvMOMcxR02mTNFmAjIHs3dcaQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR1501MB2055.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(4326008)(8676002)(83380400001)(66556008)(66946007)(66476007)(6512007)(86362001)(186003)(2616005)(6506007)(8936002)(6666004)(7416002)(53546011)(31696002)(2906002)(52116002)(316002)(110136005)(966005)(36756003)(6486002)(5660300002)(54906003)(31686004)(508600001)(38100700002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QS8rVWdJU2t0V2xsRkZSeVI1Z1MvclJQVDVSVHU2L0pTUS9VUERKS251cXA3?=
 =?utf-8?B?dE1oRm43Ri83N3I3eTdxUEpkbGlvcHdpRklzK2plTlJKWjMwdGdNdjZUUUxJ?=
 =?utf-8?B?YzUzLzd2MWVCOHlCSDN2VDJKb1lMeUZMNUJHNVpHT1JCNURybS9JRFRubGxF?=
 =?utf-8?B?SFVOYmVxUnZsZUhPeit5enpjcTkrV1hQd2ZNckR3WDhKMzlsQUVFZUFUMzZ4?=
 =?utf-8?B?S3F4K2krQVZheElxL3paSkhLdVo2ZTlUNDRkSEVjWUw3MjdPTGxEdGIwcisy?=
 =?utf-8?B?OU40YnVCM29ldUpzWkp1UlFWNXpuR05Fc1JSL0s4cHUzMlU0YzdrMnRyNjNL?=
 =?utf-8?B?aGNPN0RnUTlYZC9vd2hrbzNNOHhubGdITy9wMUVkSTErdUptWXZQOHRVUU0w?=
 =?utf-8?B?empoU1B5TmJKUDc5bTI4dVZrcjhYaVJ4UXU3b3lZNGo5SmM4dDBwSlVpRVZa?=
 =?utf-8?B?bGtRZXYyenVQaVduU2I2SFN4OG41Ri9vaG5xR096RExvNjV4UnZjeDBZaDRk?=
 =?utf-8?B?d1FlendQL2tCUm90a0pPYkJMZXZZZFNhbjhWYTJiRHpQWSsyMjRHSU02WWR2?=
 =?utf-8?B?Q0w5a0pQT1UzRUpJYVJ3dWl5dy9iNDdLZGxoanV3L2NKdDJYMkorc3pabmJB?=
 =?utf-8?B?SGk3aTRNa3JvU1RadXJQc2owRkNuTUp5MjZoblYzcU9zZXRpODJzaVFWaTVP?=
 =?utf-8?B?dUdzdUJIcXBydyttNm8xQkZzT2lhRmdWMzNRWGh1UkljOURZdmJxWkZKM01O?=
 =?utf-8?B?VHBpdWxnaGx1TkEwa2UxWi9Za1BydnlZUjNWZUJxcEc0TWRmM1hFRC9WRmJV?=
 =?utf-8?B?cm1BQW9CTzY0dWF6VGtLdFc0WDhWT2JqQWJJNit6ZWFyZ0NPbk84azNyQWla?=
 =?utf-8?B?R1dueW0rcXF4dUFHbHFQU1BZUEhUbHoyVW9XK0Z3WGp4RWgrb1pCcnpiWXJS?=
 =?utf-8?B?T2JjQkdMeGdVTVQ3UndQNHczVlJCcjZLSWUzeGZNR3RFMWVwZytoc1NyT2Vy?=
 =?utf-8?B?WkEzNDNpTlRFaE1mS1J4YlV1WlJPaUxqUHlFRXh0cStiUnBPd0loTE9wMUhW?=
 =?utf-8?B?K0UyOGJuWTkzTU9rS1hvYU84WFhKZzU2ekx4Qm5oY0RjMlh3NWJCVllDWHI0?=
 =?utf-8?B?N2lGT3MySHNKaFpVc2kvekxoSit2ZSsvZGZWSXNEWUtOdTJFTW5zekJ0cndJ?=
 =?utf-8?B?cmZHR2kyZ080RTVTZ2YvaTRLTStPVksvLzgyVFdGbzRCVThkclcwSkdCUU95?=
 =?utf-8?B?TlcxRVFIQndWaXU0ZGdDQ1JtTVAvS0ROSkdHS0o1MGNjUU8yM2w1ZHJmN3F3?=
 =?utf-8?B?czJWN1BoUjhrNytjemYyL2lTdkNqTlphVUozekJDY0JUN0FSS1RZeUQ0cERL?=
 =?utf-8?B?K05DV1plTGFXN1hqZldlSXpZdllxYkxCV3dQUFVZcDZGSUJMM2pHUzN0Q05G?=
 =?utf-8?B?ZTFsWWVoaWJMNUI3TnZMTWNhWGNVZnNaMTlYR2FaK2xVMnNhOTlLK2tGNk5D?=
 =?utf-8?B?bXVIR1hFaWpGUGZheWYvNXN1QzdVU3JZOHRoSmI2OHZmbFlIRUVsNE8zZE9C?=
 =?utf-8?B?T0ZiaEVLMFNrM3NlWnpHTGg0ZEVIVThjVTYybStWOEJpam5HOG10VEZCdWtj?=
 =?utf-8?B?dG51VXllb08wQnVoeEJhY1lHWnZJeHdRbFllYzczKzAwbktiTDJPZ1h4T0JD?=
 =?utf-8?B?Tnk3a0Vkcjcrc2NVRUtiaFlMaU43NHZjcEJYSjM4SkRJNlhZa2ZGWGp0c29B?=
 =?utf-8?B?WVBOdXlkUkFIN2c1c1VLcUY5UEdtdC9wWUZuMlZWNjltUmxLdFBWZXMrclBz?=
 =?utf-8?B?cFZWbHZWZDVtTnZsT0kvZ3pJZEdFalNnMkxWRmNXL1dMc29CM3hvdW1XTVZ5?=
 =?utf-8?B?TmxKV1hoNUlzUnpnRWMyU1FpR2luU0VxT2xjTjg4S1R5SnNMSkp3TzduVDZ5?=
 =?utf-8?B?QXdXejRGcUx3T2FvdFpMcXRTSGlRanVjdVZ4RElsWVJYZms5emdoQWp0ZGRR?=
 =?utf-8?B?UFBEcUhMS3VpZkk5S2xscUhOc0RTTy9jbmZDSm0xOThFZ3duUUhnWElHQ2xw?=
 =?utf-8?B?ak1iTXk0L29nUHRzU1hmU3U4RklrcmwxOUlVRG9ZMlFrMld5czdwanEvZ0gz?=
 =?utf-8?Q?DdpIC7Fz7f8bUT2Gsgr4GKZY/?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c504c9b8-2409-4f5c-b7b1-08d9ff0837df
X-MS-Exchange-CrossTenant-AuthSource: DM5PR1501MB2055.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Mar 2022 00:28:21.3740
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 76rCySWvjPg/tDDQieDVV2Ki+tcHGxIzIejOCiTmHJQCdXn5si3X3zXFZosViror
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY3PR15MB4834
X-Proofpoint-ORIG-GUID: F8x2lNbQMfTjKKK67TT2or7u2obT0d-O
X-Proofpoint-GUID: F8x2lNbQMfTjKKK67TT2or7u2obT0d-O
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-05_09,2022-03-04_01,2022-02-23_01
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/4/22 3:28 PM, Namhyung Kim wrote:
> Hello,
> 
> While I'm working on lock contention tracepoints [1] for a future BPF
> use, I found some issues on the stack trace in BPF programs.  Maybe
> there are things that I missed but I'd like to share my thoughts for
> your feedback.  So please correct me if I'm wrong.
> 
> The first thing I found is how it handles skipped frames in the
> bpf_get_stack{,id}.  Initially I wanted a short stack trace like 4
> depth to identify callers quickly, but it turned out that 4 is not
> enough and it's all filled with the BPF code itself.
> 
> So I set to skip 4 frames but it always returns an error (-EFAULT).
> After some time I figured out that BPF doesn't allow to set skip
> frames greater than or equal to buffer size.  This seems strange and
> looks like a bug.  Then I found a bug report (and a partial fix) [2]
> and work on a full fix now.

Thanks for volunteering. Looking forward to the patch.

> 
> But it revealed another problem with BPF programs on perf_event which
> use a variant of stack trace functions.  The difference is that it
> needs to use a callchain in the perf sample data.  The perf callchain
> is saved from the begining while BPF callchain is saved at the last to
> limit the stack depth by the buffer size.  But I can handle that.
> 
> More important thing to me is the content of the (perf) callchain.  If
> the event has __PERF_SAMPLE_CALLCHAIN_EARLY, it will have context info
> like PERF_CONTEXT_KERNEL.  So user might or might not see it depending
> on whether the perf_event set with precise_ip and SAMPLE_CALLCHAIN.
> This doesn't look good.

Patch 7b04d6d60fcf ("bpf: Separate bpf_get_[stack|stackid] for
perf events BPF") tried to fix __PERF_SAMPLE_CALLCHAIN_EARLY issue
for bpf_get_stack[id]() helpers.
The helpers will check whether event->attr.sample_type has
__PERF_SAMPLE_CALLCHAIN_EARLY encoded or not, based on which
the stacks will be retrieved accordingly.
Did you any issue here?

> 
> After all, I think it'd be really great if we can skip those
> uninteresting info easily.  Maybe we could add a flag to skip BPF code

We cannot just skip those callchains with __PERF_SAMPLE_CALLCHAIN_EARLY.
There are real use cases for it.

> perf context, and even some scheduler code from the trace respectively
> like in stack_trace_consume_entry_nosched().

A flag for the bpf_get_stack[id]() helpers? It is possible. It would be
great if you can detail your use case here and how a flag could help
you.

> 
> Thoughts?
> 
> Thanks,
> Namhyung
> 
> 
> [1] https://lore.kernel.org/all/20220301010412.431299-1-namhyung@kernel.org/
> [2] https://lore.kernel.org/bpf/30a7b5d5-6726-1cc2-eaee-8da2828a9a9c@oracle.com/
