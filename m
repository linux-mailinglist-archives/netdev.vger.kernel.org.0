Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE17064A672
	for <lists+netdev@lfdr.de>; Mon, 12 Dec 2022 19:04:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229600AbiLLSED (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 13:04:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232964AbiLLSEA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 13:04:00 -0500
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA0606151;
        Mon, 12 Dec 2022 10:03:59 -0800 (PST)
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BCHZ7pp014487;
        Mon, 12 Dec 2022 10:03:38 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=s2048-2021-q4;
 bh=5imMhklgIQn1qku9bAI67TdmZd6zGbU0656ExC7FT2E=;
 b=kmU8CxVAExLcPZssZ1M24dmnA5dwEZGr0D3pNoFiZsHs+WLldOU5FIGM17NHNkMAKrmJ
 w4dX3LLlsGYjgrEegINnjUqR51k1Us2l3vYdyb4uMMXLpyZU5HOXGo0VO7u3pzwEYjbJ
 qqAVzIbe6dGpDC/fPOCgFA66abf4o9z4MmH1wEpk+6qLKKz+5+2j0TieJkghhllLViAu
 MXlB8Hu0P9ACFMIgBl7cw56jnXDSfNl+q9IsD+lXhLj9h8Sxd5VHQ4fYwEofS2gL/MvI
 aL22WyTSUAHMF3GmtMcEQMfPiUV3z4uiUD3ucBorW6nljb0082+9aOeCldoQ2Fc/UsR+ Jg== 
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2173.outbound.protection.outlook.com [104.47.55.173])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3me4xsaebv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 12 Dec 2022 10:03:37 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FgPETowXsJ5pF06wjWxVJqG94LaU6LqDZRTO7ywmDUD8Tceo7KEtsyV81VSR+lKyHjor7dFilueEq6gJQPG9uYUw8aMP6H69nBYpRZ/SN63NisKVD/6CuRjnooL6DIaXytxKG0zXAGQkGrzI/OCv/W8HHkjvLgTvfCFBsn+dBSL66veNRxwiI84a5Iq7pm7fIph6QDsVx0K9oy79seZ2mz/eznM1393TFe+myH7qirf7VUzDW00DiXJa++0DiGSKI921DWniQ4oRPQjdbLSKdyW3wAJ2PTsT4PHXpD9wyM9oXnDfWnM/5xf3K2d0IJr+htkQFcxNldjtq30VFuiW5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5imMhklgIQn1qku9bAI67TdmZd6zGbU0656ExC7FT2E=;
 b=O16NS1naXXGcTP6QunZzgedsC/0DM+c5E3jOAOscbK51GPXwOitr3vWxb/9s9ZFQo6NAF08UXkherLRjg6JyngiCrpCJ5J1dKWUtKbqVNIKV3RG9OQyhOqulhx4CsjpiotqSfBNRY9BoiFAB2p5/+wx+fh+CEeu360Z4GxbdLfQkkbye6TEg8DMxJ1p3gPZXmwOVJWmWcsdSSrErhtmA7G6zlv5CuGxm6g/XopT6DuFUQ3MiP7RIGlrR57vqAwgnyTMBjlBAUW/U//mORBVBUu5YJZqzmnBC44bpdoJueRnXUw/91q5TsdiBKc4bquoRg81fkcKEFlVVLt+0jfbq/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from DM5PR1501MB2055.namprd15.prod.outlook.com (2603:10b6:4:a1::13)
 by SA1PR15MB5819.namprd15.prod.outlook.com (2603:10b6:806:338::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.10; Mon, 12 Dec
 2022 18:03:35 +0000
Received: from DM5PR1501MB2055.namprd15.prod.outlook.com
 ([fe80::f462:bf61:5f19:e2e9]) by DM5PR1501MB2055.namprd15.prod.outlook.com
 ([fe80::f462:bf61:5f19:e2e9%4]) with mapi id 15.20.5880.019; Mon, 12 Dec 2022
 18:03:35 +0000
Message-ID: <01ade45b-8ca6-d584-199b-a06778038356@meta.com>
Date:   Mon, 12 Dec 2022 10:03:31 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.5.1
Subject: Re: [PATCH 2/5] Replace invocation of weak PRNG in kernel/bpf/core.c
Content-Language: en-US
To:     david.keisarschm@mail.huji.ac.il,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     aksecurity@gmail.com, ilay.bahat1@gmail.com, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
References: <cover.1670778651.git.david.keisarschm@mail.huji.ac.il>
 <7c16cafe96c47ff5234fbb980df9d3e3d48a0296.1670778652.git.david.keisarschm@mail.huji.ac.il>
From:   Yonghong Song <yhs@meta.com>
In-Reply-To: <7c16cafe96c47ff5234fbb980df9d3e3d48a0296.1670778652.git.david.keisarschm@mail.huji.ac.il>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-ClientProxiedBy: SJ0PR03CA0240.namprd03.prod.outlook.com
 (2603:10b6:a03:39f::35) To DM5PR1501MB2055.namprd15.prod.outlook.com
 (2603:10b6:4:a1::13)
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR1501MB2055:EE_|SA1PR15MB5819:EE_
X-MS-Office365-Filtering-Correlation-Id: e9b0e789-6987-4a6d-fd42-08dadc6b302e
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RT/3FH+wPW0AtAjel0HwmB8nCDNDCOG5Eo+LXhpNBUmYHhPKLtZEG7X/qQjz7uuA2qnK9SIBj24okBSrecEaXk12WK56In9a1GovUdWVJHJsQ1JPbjRgTkTDtDnatj8zNdQf0NC+OlP0baExJtaKitohGhdgwUA/VXeeVE0wq1MIrDEjIv8O9XshtTneWQ3lwUWh3GT+ABAxMqDhFgyIhrQNQ3t48e0H1o4tSqvr+eWitU71axSz8JhTazjYDqITYGn7YTuTapxUOyV8l7fmzImR2c2LpvAQ+oNupcrPTJza0AhYneBSMPO5xEd/eMeuzmLXxEpo9GnSGG7S5XFQPAh6rJavrljNX0AZD4oqteoY95o5tGA4jxTciNwqBzd4o5e04asLmjZ+dNvjC9i6bXECedpUb8nndQI6sfa08KHOesgyvPnLo6BZFVX9X3eRtw/O1dw0humg2R5IwlxYEWgkIeYruYm6q2she4a3dAzD8TlSZIknudKsQVT08wAovmWfz/ooCxtqp0wVI2C01yDW8luBxsAmFF2Q1WgClO04soO2gFeyMxpCNM7HlCMQHAU2Fms5oekWRVRBKPpWnlO/XIKaFGDMHMFCUJxnNVt1474xGanGF/aU+bvbYqEslmUPCRyh7fNtkgzkjENH/ZTj/r+21PvncHupUUMZeS9NhUtwS55PurK1v4RRlWHdB07SoZGT1Iaal880QdSmqWGf1+O4cZ9AO8TzCqHIuQhFvMS6v6gtGElT48q/K1amlwvWgpICD+OzgtY9rFeBrw3maCkQ2miZRlJ+0bxaaXY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR1501MB2055.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(346002)(396003)(39860400002)(376002)(136003)(451199015)(36756003)(53546011)(6506007)(6512007)(5660300002)(8936002)(41300700001)(921005)(6666004)(478600001)(2616005)(6486002)(186003)(966005)(110136005)(83380400001)(7416002)(4326008)(31686004)(2906002)(66556008)(66946007)(86362001)(38100700002)(316002)(8676002)(31696002)(66476007)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZGVvVHhpKzJSa01nT1NZc01WdlhxSm5vSkd2M3ZtcGJTa3g2b1U2S1g0SUJ6?=
 =?utf-8?B?Q21YVXpoWWhKYVM1RzA0T3ZNSi9qd3ZCVy9id21jZms2MzJwdVo2TE1OUFN5?=
 =?utf-8?B?NVBneEJnT1d0Wk1FN1hWZjRPbWllUDZ4c1g2ZkRGRGt4SnRwQStwdm9tRG4v?=
 =?utf-8?B?aFNyeTBHeXZuUGpGQ3luanV2RktQNm5TSWVEZUFuSmtvcGZFMzk4ZFhLaXdS?=
 =?utf-8?B?cHF0SkMrcE05b1Q3T1F2TmJ1K3I1Qm9yZWR6VVVtQjhLdmdwaTFDQ1ZKMWhr?=
 =?utf-8?B?bUhvYWtTbkc0K2JLZmk4NFpRaTRUbnBuQk5BUXU0WDF0cTJKOExsb2NzL3ZF?=
 =?utf-8?B?YlNBcWNrZGhDcU05L3d2MXl0R3FUUElpNURpcnp5VmtOdm83WUJuK1V1bUxi?=
 =?utf-8?B?NTVKNHJjMGJQQkpqSFduZ3ZxeVJRbGtObjN2T0NmTWowaHcxSmt5NzBRL3A1?=
 =?utf-8?B?REFUVDE1akxONnMveFZNWmtFeUxIbnUyc3h1UkkxQWx1SWtBc3d4cXkrY2tN?=
 =?utf-8?B?dDVmRGR3OUJ0MFVsR1k4dDBKRFNOYlhJUXpieExzdWlBc2c3SUVFTFNjdWZk?=
 =?utf-8?B?bVVDTnhoSHVRS000NVB4ckt4YmxnRXFXYXJCN2VvN2Y3Wk5DVGJQa0prWkox?=
 =?utf-8?B?ejdJdTBTT3ozWm5NaHFBTGxLdktPSlhRMjVZMEc4OVRoUE43d1FQRUZlNjdo?=
 =?utf-8?B?VU45VFlRT0JDRFdLTldveXhtZGpndXRydVV0WVZzdUs1bmphVEZOV3ZaZitl?=
 =?utf-8?B?ZFE4K2V3Z3V2UHZXd3pvL2tDUGsxV2tOOHVRWlBTaGtRWHR2cVB0Vno0L25m?=
 =?utf-8?B?SjFKNEs5bVJVaGJSWjZVYnlEWVRMMUp2SmZsbDFKU2xkeGRVOE1FOXdGY0xl?=
 =?utf-8?B?SFQ3d2V1S3l2VjVEV1VCUDZ1ZEdSUElQV29CVS9hSjlGd0tWR1RKVTdtVHVN?=
 =?utf-8?B?cmk2dVhDbzMxMVRxaUtKeGFGRUd3ZVp3S1lkUStSQ2FIYWxtQmtCcjhxZVFF?=
 =?utf-8?B?U05MT01WalhFK3V3MUlvbXJJdndXSWkvanhCZVVsRmRaemUzU3FxS2ZISy9x?=
 =?utf-8?B?MFVwdDFoYWFXUkJDVjVUQUIxalp4aisyQS9HS1pDUWZWSWI1clRLQ3BtUFRX?=
 =?utf-8?B?a1VRNWFwcU91T2drU2xyRld3eW84Rnp1Yi9tWFJOT01MNERlS1U0VkFrd1px?=
 =?utf-8?B?YVJzSlhiTHUrQ0Y4OGRKRG9TQytzQVJnSVI1TWszdWJGUnVNSm9nSVYrQ2xa?=
 =?utf-8?B?U3NsRXJQK3UvR2xRb2FYTTk1bWloUGEvL0dUNnlUOUN5c21hWjlVZUFYOGpV?=
 =?utf-8?B?TnJnTnQwNXNYcktOY0VDWXYxUGZqc1k5WjV0Z2pVNUtYYUx5cTRHenRyY0dM?=
 =?utf-8?B?VnQ1Q3VPam1OSy9xOHV5YkRlakU5ZXFnaTB3RmFVbkt6Z1d0N2pYdVBwcVJF?=
 =?utf-8?B?ZnFYL0tqcDJvcDE1eVovUHIzR3VhdU5PWVdKWlY2QlpqbTd2VVZtKzlNS3Bh?=
 =?utf-8?B?Z3Jzd1NGbGhodDNoSkpweXI1SWJjVGRtYUplYUxaUU5aeGtPYVpkc1I1SWEy?=
 =?utf-8?B?bGpGczY5YWtNRTJyQW1DK2pYYXVkQ3VCNTVjQUVqZWhBZmgxcTJPaVJmRS9C?=
 =?utf-8?B?cHlhL0VpQmV2bGRmZlY2d1I5OEtFM3RFYkN4ZWRONTF5T0dUYWh1WlA1RDJF?=
 =?utf-8?B?TGp0Z2ZwS2NWYThVZkpCcEJjMDFGaDZ3MnJ5OGVud05IbHRjN3pxSitrREF1?=
 =?utf-8?B?aHZqUWlLYVJRL0RKbTI4LzhkYVBUc095SzZ3MHdkbjYxUlQ2OFIrTUNxR1R6?=
 =?utf-8?B?aVZmTVY5bDJEK2xQN0F0UE9FNUd6ZFNQYWR1enVISEhvZHJTSXd3UnRIS3NW?=
 =?utf-8?B?SWk1cWhMKytnemZvaGhUcytSZFFrRnZtUVFCSjE2L2pGa1U4S0xZSEt3N1pj?=
 =?utf-8?B?bTdoUU9FOU84M3NHVC9VU1NxMHBBeG1hZUpieG5UbnhVZnU0YVhrekRtd2Mw?=
 =?utf-8?B?MnRoVjRpdmlQUUFNUlA3ajRmRTZwazRBeGlSK2FEcENzS203blUvYWZ6akI3?=
 =?utf-8?B?akRBMU5BMFZzcWZ2QjUzRjVyeTByRGhkZjNIcERyQy8zazFVSWNmWWJMR2o0?=
 =?utf-8?B?cTNZcE5sQmppWEExZjRxNTdEbDg2blNidDZvUlJsRU03MGQ3UnVHRVpYSCtC?=
 =?utf-8?B?NGc9PQ==?=
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e9b0e789-6987-4a6d-fd42-08dadc6b302e
X-MS-Exchange-CrossTenant-AuthSource: DM5PR1501MB2055.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Dec 2022 18:03:35.5749
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HmHlDyRFDII2cnpxmYw1OXrnPyNKGhUJ/ZRHuLB3bPwEPd2nwZXR9guYap1Qk2ag
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB5819
X-Proofpoint-GUID: WiALj-EdSbm8VbA8F3N8YJyZHmBtUZXg
X-Proofpoint-ORIG-GUID: WiALj-EdSbm8VbA8F3N8YJyZHmBtUZXg
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-12_02,2022-12-12_02,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/11/22 2:16 PM, david.keisarschm@mail.huji.ac.il wrote:
> From: David <david.keisarschm@mail.huji.ac.il>
> 
> We changed the invocation of
>   prandom_u32_state to get_random_u32.
>   We deleted the maintained state,
>   which was a CPU-variable,
>   since get_random_u32 maintains its own CPU-variable.
>   We also deleted the state initializer,
>   since it is not needed anymore.
> 
> Signed-off-by: David <david.keisarschm@mail.huji.ac.il>
> ---
>   include/linux/bpf.h   |  1 -
>   kernel/bpf/core.c     | 13 +------------
>   kernel/bpf/verifier.c |  2 --
>   net/core/filter.c     |  1 -
>   4 files changed, 1 insertion(+), 16 deletions(-)
> 
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index c1bd1bd10..0689520b9 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -2572,7 +2572,6 @@ const struct bpf_func_proto *tracing_prog_func_proto(
>     enum bpf_func_id func_id, const struct bpf_prog *prog);
>   
>   /* Shared helpers among cBPF and eBPF. */
> -void bpf_user_rnd_init_once(void);
>   u64 bpf_user_rnd_u32(u64 r1, u64 r2, u64 r3, u64 r4, u64 r5);
>   u64 bpf_get_raw_cpu_id(u64 r1, u64 r2, u64 r3, u64 r4, u64 r5);
>   
> diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
> index 4cb5421d9..a6f06894e 100644
> --- a/kernel/bpf/core.c
> +++ b/kernel/bpf/core.c
> @@ -2579,13 +2579,6 @@ void bpf_prog_free(struct bpf_prog *fp)
>   }
>   EXPORT_SYMBOL_GPL(bpf_prog_free);
>   
> -/* RNG for unpriviledged user space with separated state from prandom_u32(). */
> -static DEFINE_PER_CPU(struct rnd_state, bpf_user_rnd_state);
> -
> -void bpf_user_rnd_init_once(void)
> -{
> -	prandom_init_once(&bpf_user_rnd_state);
> -}
>   
>   BPF_CALL_0(bpf_user_rnd_u32)
>   {
> @@ -2595,12 +2588,8 @@ BPF_CALL_0(bpf_user_rnd_u32)
>   	 * transformations. Register assignments from both sides are
>   	 * different, f.e. classic always sets fn(ctx, A, X) here.
>   	 */
> -	struct rnd_state *state;
>   	u32 res;
> -
> -	state = &get_cpu_var(bpf_user_rnd_state);
> -	res = predictable_rng_prandom_u32_state(state);
> -	put_cpu_var(bpf_user_rnd_state);
> +	res = get_random_u32();
>   
>   	return res;
>   }

Please see the discussion here.
https://lore.kernel.org/bpf/87edtctz8t.fsf@toke.dk/
There is a performance concern with the above change.

> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index 264b3dc71..9f22fb3fa 100644
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -14049,8 +14049,6 @@ static int do_misc_fixups(struct bpf_verifier_env *env)
>   
>   		if (insn->imm == BPF_FUNC_get_route_realm)
>   			prog->dst_needed = 1;
> -		if (insn->imm == BPF_FUNC_get_prandom_u32)
> -			bpf_user_rnd_init_once();
>   		if (insn->imm == BPF_FUNC_override_return)
>   			prog->kprobe_override = 1;
>   		if (insn->imm == BPF_FUNC_tail_call) {
> diff --git a/net/core/filter.c b/net/core/filter.c
> index bb0136e7a..7a595ac00 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -443,7 +443,6 @@ static bool convert_bpf_extensions(struct sock_filter *fp,
>   			break;
>   		case SKF_AD_OFF + SKF_AD_RANDOM:
>   			*insn = BPF_EMIT_CALL(bpf_user_rnd_u32);
> -			bpf_user_rnd_init_once();
>   			break;
>   		}
>   		break;
