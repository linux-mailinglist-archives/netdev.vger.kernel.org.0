Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD5E452F056
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 18:16:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351489AbiETQQj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 12:16:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351454AbiETQQh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 12:16:37 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 685665DD01;
        Fri, 20 May 2022 09:16:35 -0700 (PDT)
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24KCVBVM001397;
        Fri, 20 May 2022 09:16:14 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=GdUOKWmVt9m0KIJSZ3CC+cIpGap1EgsTEd69z2s+Ykc=;
 b=LtbSbSLjETccjyBS8U6yxSUHMti+13Ht/251D63BsG/k13ut24a02Z3GB1cRSy2PmZ7V
 ekEj8B2wdup4VCCQAW5Tfd3fxUzS6kRxcBs3wCPGga4jnuFDUa7GHu8hSNhvwxZdlehz
 +ce90Bz5WS8cnAu2sjVLxMtxab0UTeiHzWc= 
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2170.outbound.protection.outlook.com [104.47.58.170])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3g5rgj7uyf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 20 May 2022 09:16:14 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DFQibIUN9ycdglpAggPhBU02rljGdfyY0oJr2g/av5oKoti6nOJmkdgfp3k2JN/AT+uAeeAYRahNj5SCgeTzQ3yMzaXO6BRDfPTztxgr+13QzVKqqRmgKekOFFivOrOH8zo4vGAHTbq4YPfgxuKb+fIsh1AWL4PoVYrP1H7wJUoB7KYbh9/JoUnPu0vEQsdsTz00k4siNOtiiioSlguREks3k1GU4q7Y3Ifo11dIFfyi3rc50RRitOBue40LU60Rf0PXkNXRa40+rSSXGoG7RGSVyQ1mqgzfLoZEjaq0o7hs1/zCigb+AyTDqX1kBS64qN9Gu0SBcXfAw+u+PC8pdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GdUOKWmVt9m0KIJSZ3CC+cIpGap1EgsTEd69z2s+Ykc=;
 b=Ji+tvSYeoLHrDydOcoxI9O2TmCjnmU2MONYMo9YUPtrOKQZiQi7INhwxVvfTDihtE+cmSNsCb4vF1nYjZY/yufBLOGx3HWAWhrY5xD3AJ/LzR2E4swgXogzATq3XqwihI6eWl7v5llXjRetkl1VLG6Cth2uBeln4cM1Lcn3iL4sprVto6ZV9ea/hVcizbLoZY+4ZhsJTwVNi3KkDKYtTvFEXSdwkwG6Li84ziv4MmsvXrG4oYEsZTdZKo40P8sa9rXVSwe0tNgBeD4k/1o0IsT5vzSVB6bR7TZmxCUw+WRY0HgnY5k1WQPU7wpOAqh7sVz1iJhghY9KiNsjxjVSsEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SJ0PR15MB4154.namprd15.prod.outlook.com (2603:10b6:a03:2ca::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.17; Fri, 20 May
 2022 16:16:12 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::5811:4996:bbfd:3c53]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::5811:4996:bbfd:3c53%7]) with mapi id 15.20.5273.017; Fri, 20 May 2022
 16:16:12 +0000
Message-ID: <eca39189-9258-b1cc-0a1d-a0d7e6027861@fb.com>
Date:   Fri, 20 May 2022 09:16:08 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.0
Subject: Re: [PATCH bpf-next v1 2/5] cgroup: bpf: add cgroup_rstat_updated()
 and cgroup_rstat_flush() kfuncs
Content-Language: en-US
To:     Yosry Ahmed <yosryahmed@google.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Hao Luo <haoluo@google.com>,
        Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Shuah Khan <shuah@kernel.org>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Michal Hocko <mhocko@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        David Rientjes <rientjes@google.com>,
        Greg Thelen <gthelen@google.com>,
        Shakeel Butt <shakeelb@google.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Cgroups <cgroups@vger.kernel.org>
References: <20220520012133.1217211-1-yosryahmed@google.com>
 <20220520012133.1217211-3-yosryahmed@google.com>
 <fa3b35a6-5c3c-42a1-23f0-a8143b4eaa57@fb.com>
 <CAJD7tkanipJ7-9H_L6KMUjpD2qS29-YCrnMXw+8BAKfbOk5P9Q@mail.gmail.com>
From:   Yonghong Song <yhs@fb.com>
In-Reply-To: <CAJD7tkanipJ7-9H_L6KMUjpD2qS29-YCrnMXw+8BAKfbOk5P9Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BY5PR17CA0023.namprd17.prod.outlook.com
 (2603:10b6:a03:1b8::36) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 071d5144-999b-4a63-f411-08da3a7c0e78
X-MS-TrafficTypeDiagnostic: SJ0PR15MB4154:EE_
X-Microsoft-Antispam-PRVS: <SJ0PR15MB4154B2807246B0293477588ED3D39@SJ0PR15MB4154.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vKG3SZoQhGWx8vK0q8743uloUgmLKTs9QC53k0qz7ewpIml53cJ9pRqvKi69K79itssfZbQIv/j/n9H09pDV8t1bVY2hFVZ8Gl4Nsw0QbctoL2+zl9Da3rIEYnduUatRSZAm5fguHUI5+BCnEOBWZi424TCTkfKDF2HMJJ/RBtCadsW0r4h0O/reoMkf7eA+FBzOmuR9z4oW/LZe4nCS8sPuPzVGGicZxY44Q2MHUDKncLo90qekOrw5mNOjk4w8B4WmrNCy8LPrrOakbWjrxe/SqfexLNFe5Wh05IzFJ8M5ej8BYRD1q2pRvKZKxSX7PAZXChCxTT5CONuEKbyMMeCOt0WEypTWMprJwlBBPOxGFysmD7YR48FCB4C+v5ot/ySqGMbWHogdyHLeZ+8VOSjv1ENsf4qjbM7/KW+vC4qp8681q0/kBX1GNaBbarnpsdpi5wnc+qTlX87frc4T4dIv2bUPTSdczvF+oe1pp/d9pNQI03T8SpYOsMlFNHWbZjygW7kSGCVrTyiSXHvQjeb64UX30MfTDMKw5JRRB2eE08W7buTyKIosY00TnjdxoSHBJnK5Ebnv+Z7agzGBDrZXeb0wU9L/YDCJx23aV2/qi0PaxtxOjcdGQsFuy34YSxBB2h+TveHg6xwguPSboazC4LdbwKYRp6U6UltMLE3/VEAC1zbp7N+SeIi9NXwJpAr291RyyR3f2JSXmGK2sOBQ0TQkepNpKG510t4EgTes96f86jekbzw56jjEAOI0
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(36756003)(186003)(2616005)(52116002)(83380400001)(2906002)(31686004)(6512007)(508600001)(8936002)(53546011)(316002)(6916009)(54906003)(7416002)(5660300002)(31696002)(86362001)(8676002)(6666004)(4326008)(66946007)(6506007)(6486002)(66556008)(38100700002)(66476007)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WG9SUS9QWFRzVHJQc0ZWM3FNcEpQSHRlM2ErWUthWjRVUW5Lbk5CdnorWVor?=
 =?utf-8?B?Zkk0aXVrNGpsaWNzN2h1WmtMSEZRRFkvc1hoWDdpeWJsR3hEREpkY00wVmI4?=
 =?utf-8?B?V1dtdk4yUjRaRWl1R2VEdEhHTWg0eTR4WHdRR3lhQllaVXpsanhRQVA4VUh6?=
 =?utf-8?B?Qmk4eTRMK0JhWkVuKzVjNWl3WkxBZVVEcjZKSXNLNEprZmRrS1l5L1RoMGxO?=
 =?utf-8?B?a3dOY0lGTlhmTGF5dFNHOHpYVXBmMEY5bTcvV0U0RkE3SWdQU056UktyblNt?=
 =?utf-8?B?WWNsQkZKVHdXQ1BxOGdRclhHNk1ldDE4cnRqdUNBMGp6MUU4M252Z2hiU2Zy?=
 =?utf-8?B?SUlmYzdlWFo2VlFkVVVTWi9WclZwaFBzMW1YTU5OSVVNUllZVWhuNk1Lc3Jj?=
 =?utf-8?B?WWd0Y2tZaTdhT0dqa0pPQi9KendnOGQ0V0pkRVlzU05za25CamlwRnhyOVp6?=
 =?utf-8?B?WjJGMllzZGhPdmdZNTh6ZUU3N3NXbmVtTzl0c1FsUDVGUTd2NDcyTE9mUGt3?=
 =?utf-8?B?dGVSNHRXbnpTd2dzRzErenN6YWhUTThXVDJYRTVyMW8vbHNoWDNnK1JZUy9u?=
 =?utf-8?B?eDYrYVgwZWZsd0tnMVJTSDRjZFNaZHk0cExJTktPT2YzcWdWcVZyU05kQngv?=
 =?utf-8?B?eHRJemV2N1BCMG9vbXFnUllBR2JDd0lKV0FmTWFTMWFONFBEcXFBS3BrNm9i?=
 =?utf-8?B?a096VkppTlVJSkU2bnVJVCtRYVRDYlBOYjFnRHNpa09KcnlGUmtvWUVmUXc4?=
 =?utf-8?B?bURCL3diVExoRlBLditUdFp0ZlI1UVdQa0JQbEhaTFZld3RFUHVZand2Rldu?=
 =?utf-8?B?ckxWa2F0dlRGa3lRWjdOWmZnYVpaa09Cb0hnY0UwK2txVnZTVHovZm5JRTZn?=
 =?utf-8?B?RjJkdE9JVE5sS3BZREpuOCs3ellHVlBmMk1DSW5uUE81Qys1TUNXbDFTUENF?=
 =?utf-8?B?K01mT1BPdGJhME10RlJiSm1tbEFpaFgzNDV3TmliVDhhNmhrc2VtZVJUQzBs?=
 =?utf-8?B?dkNPYTYzSTZMbk1sRDlZcmtLdFpCa2szUWR4QzE1RnNPMG1jTEM3VjBKNnBy?=
 =?utf-8?B?cW8yeTdzL01aQ3I5Z0ErYzRKNkp2MGZUR09vRWVJM1ZsdTJVUms5cEdtU2E5?=
 =?utf-8?B?S1F0NG01aWtwbUREdFdyRjd5TDdlOXFYNUZESmpJUU0yL1NBYlVCUzQ1cFJo?=
 =?utf-8?B?SmpuakR0a2JuRWFscURVc0crWGxWNXJJQk9mNk0raWRLdnhndHNIQUlmSHJJ?=
 =?utf-8?B?T2Jqc0Z3Vkt2VzRiRlF2ajhLaytFaEViaWRTbitXWVVEdmxCaDRJTjc0ZWU3?=
 =?utf-8?B?S1p0Y08vcXFPZlZ6UzNWS0V3MkVNZTRlYnBqZWk3V2tNemd1VFpvc29udU0x?=
 =?utf-8?B?Y2dxcTJKYzVGUDE5Zkg4RDRyRC81MFVRWjNuQmtuc0N5cktOZXdUOWpnWlZW?=
 =?utf-8?B?TGVabERnUTEvWVdRZ21oMkhFZkZaY0x1OTJhQnJLdU10OE84SCswNk1qSlRl?=
 =?utf-8?B?L3Z4Kzh2aUl6SXRyeTlhUjZ2VXhOVENzcmZ2a1FUOFR6aDlxbU9yUllsNElT?=
 =?utf-8?B?OTh2c290ZUs3ZDByRTNOSUxUZEUvZDFpaHkyVXpuOHk2cWV3YzZVSUU4Q0lE?=
 =?utf-8?B?VFdEcEJFSWNFY1NVdXY1cVBWRVhEK21HaUpqTFJ6SE9YelFiTnVnVVRuL3Y2?=
 =?utf-8?B?anZ1b1R1dDBGT2IwYVBVaXpqR25DMmFWV21xYk9zNm9TZlJuUmNKR0t0RmNP?=
 =?utf-8?B?UW9ZS2tUVTc3QUZZYnhZa0VtbklIOER3NE1yVlJXUkNtOUFaU1E5YlBZWHNR?=
 =?utf-8?B?TVg2MTczK0wyck9vUmVVYjNrRkxCdG9zZXdRR294Q2wzbVlOWUR2c3oyTWds?=
 =?utf-8?B?M1R6eFpKMkF3Q09UK3Jmc1pCZG80VHJ6SkZ5dGk2WlhYR0N5MFhLRkhpZkFR?=
 =?utf-8?B?QU1KeC9qUU5weUtLRXJlWnVOSlRWZ2N1L3VKditaSVZYUnB3RFdZUERPRUNV?=
 =?utf-8?B?YllwVlVEbHhpT1A5R1drMnRVaFBYWVlwZWNpRjhwUFBlRXNGcVdjclB2QXBC?=
 =?utf-8?B?L1JaclNJWWdKSHVpY0kvdW9JckJaZnN2UzlTeEswdW43cE5EWUZKRDAvS0lO?=
 =?utf-8?B?aFVBYXdiSmROUjEyeCttSWY5M25aclZHandRUTl1TzBROWhpajVPQ2p6VWF2?=
 =?utf-8?B?OUw5bG1oYTVTeTJrZzdUTzU4ZE9pWlBaeHN5VGpUZEkvWVMySnlEL0NtalRT?=
 =?utf-8?B?aVNRZkVYcDNRL1F1UGEvZlR0a3JhYllOenB4TU5SMitlR25mTFVkK1diUW93?=
 =?utf-8?B?VXBodEwzQUJJTktkbnoxd0lZejFsc2VrRFVYNkpaZ3M5LzFGYmxMVHhqaStq?=
 =?utf-8?Q?XoSUvaAhJGwxEiWE=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 071d5144-999b-4a63-f411-08da3a7c0e78
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 May 2022 16:16:12.0447
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zg01zzxsNlTwnCjSgWPFASBwEGP2Hkvq9s6LBAwRKj6AUv0gH6y0ffMItOP+iq3e
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR15MB4154
X-Proofpoint-GUID: gXLy7gcqu2VUFlpcmhCphNqbSHEPIkq1
X-Proofpoint-ORIG-GUID: gXLy7gcqu2VUFlpcmhCphNqbSHEPIkq1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-20_04,2022-05-20_02,2022-02-23_01
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/20/22 9:08 AM, Yosry Ahmed wrote:
> On Fri, May 20, 2022 at 8:15 AM Yonghong Song <yhs@fb.com> wrote:
>>
>>
>>
>> On 5/19/22 6:21 PM, Yosry Ahmed wrote:
>>> Add cgroup_rstat_updated() and cgroup_rstat_flush() kfuncs to bpf
>>> tracing programs. bpf programs that make use of rstat can use these
>>> functions to inform rstat when they update stats for a cgroup, and when
>>> they need to flush the stats.
>>>
>>> Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
>>> ---
>>>    kernel/cgroup/rstat.c | 35 ++++++++++++++++++++++++++++++++++-
>>>    1 file changed, 34 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/kernel/cgroup/rstat.c b/kernel/cgroup/rstat.c
>>> index e7a88d2600bd..a16a851bc0a1 100644
>>> --- a/kernel/cgroup/rstat.c
>>> +++ b/kernel/cgroup/rstat.c
>>> @@ -3,6 +3,11 @@
>>>
>>>    #include <linux/sched/cputime.h>
>>>
>>> +#include <linux/bpf.h>
>>> +#include <linux/btf.h>
>>> +#include <linux/btf_ids.h>
>>> +
>>> +
>>>    static DEFINE_SPINLOCK(cgroup_rstat_lock);
>>>    static DEFINE_PER_CPU(raw_spinlock_t, cgroup_rstat_cpu_lock);
>>>
>>> @@ -141,7 +146,12 @@ static struct cgroup *cgroup_rstat_cpu_pop_updated(struct cgroup *pos,
>>>        return pos;
>>>    }
>>>
>>> -/* A hook for bpf stat collectors to attach to and flush their stats */
>>> +/*
>>> + * A hook for bpf stat collectors to attach to and flush their stats.
>>> + * Together with providing bpf kfuncs for cgroup_rstat_updated() and
>>> + * cgroup_rstat_flush(), this enables a complete workflow where bpf progs that
>>> + * collect cgroup stats can integrate with rstat for efficient flushing.
>>> + */
>>>    __weak noinline void bpf_rstat_flush(struct cgroup *cgrp,
>>>                                     struct cgroup *parent, int cpu)
>>>    {
>>> @@ -476,3 +486,26 @@ void cgroup_base_stat_cputime_show(struct seq_file *seq)
>>>                   "system_usec %llu\n",
>>>                   usage, utime, stime);
>>>    }
>>> +
>>> +/* Add bpf kfuncs for cgroup_rstat_updated() and cgroup_rstat_flush() */
>>> +BTF_SET_START(bpf_rstat_check_kfunc_ids)
>>> +BTF_ID(func, cgroup_rstat_updated)
>>> +BTF_ID(func, cgroup_rstat_flush)
>>> +BTF_SET_END(bpf_rstat_check_kfunc_ids)
>>> +
>>> +BTF_SET_START(bpf_rstat_sleepable_kfunc_ids)
>>> +BTF_ID(func, cgroup_rstat_flush)
>>> +BTF_SET_END(bpf_rstat_sleepable_kfunc_ids)
>>> +
>>> +static const struct btf_kfunc_id_set bpf_rstat_kfunc_set = {
>>> +     .owner          = THIS_MODULE,
>>> +     .check_set      = &bpf_rstat_check_kfunc_ids,
>>> +     .sleepable_set  = &bpf_rstat_sleepable_kfunc_ids,
>>
>> There is a compilation error here:
>>
>> kernel/cgroup/rstat.c:503:3: error: ‘const struct btf_kfunc_id_set’ has
>> no member named ‘sleepable_set’; did you mean ‘release_set’?
>>       503 |  .sleepable_set = &bpf_rstat_sleepable_kfunc_ids,
>>           |   ^~~~~~~~~~~~~
>>           |   release_set
>>     kernel/cgroup/rstat.c:503:19: warning: excess elements in struct
>> initializer
>>       503 |  .sleepable_set = &bpf_rstat_sleepable_kfunc_ids,
>>           |                   ^
>>     kernel/cgroup/rstat.c:503:19: note: (near initialization for
>> ‘bpf_rstat_kfunc_set’)
>>     make[3]: *** [scripts/Makefile.build:288: kernel/cgroup/rstat.o] Error 1
>>
>> Please fix.
> 
> This patch series is rebased on top of 2 patches in the mailing list:
> - bpf/btf: also allow kfunc in tracing and syscall programs
> - btf: Add a new kfunc set which allows to mark a function to be
>    sleepable
> 
> I specified this in the cover letter, do I need to do something else
> in this situation? Re-send the patches as part of my series?

At least put a link in the cover letter for the above two patches?
This way, people can easily find them to double check.

> 
> 
> 
>>
>>> +};
>>> +
>>> +static int __init bpf_rstat_kfunc_init(void)
>>> +{
>>> +     return register_btf_kfunc_id_set(BPF_PROG_TYPE_TRACING,
>>> +                                      &bpf_rstat_kfunc_set);
>>> +}
>>> +late_initcall(bpf_rstat_kfunc_init);
