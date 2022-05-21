Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85D8352F706
	for <lists+netdev@lfdr.de>; Sat, 21 May 2022 02:53:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350741AbiEUAw7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 20:52:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235683AbiEUAw5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 20:52:57 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D47821AD5AD;
        Fri, 20 May 2022 17:52:56 -0700 (PDT)
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24KMsHvw029503;
        Fri, 20 May 2022 17:52:30 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=RTeQWk2uEdnNz7G7Y/KJAeI2aPGMBpJrhLcIXKIx3Ls=;
 b=eUH/+QawHUtXDPUm8GIZeDcQUDGSa1FnL1qbfWGD+Xx/ssVlT3rklTD2uCY4rYiaCczh
 GMXcuTQ1Ad0I7Wf5ryWMLBUoO0tgUdxXZzxEK+xjDXnOp1VBe+rz4tE7wCuzygsRbTJe
 ObiUjybOiXXi/EurPhtFDVEVnTyh+cl3bps= 
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2177.outbound.protection.outlook.com [104.47.57.177])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3g5xexfwyb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 20 May 2022 17:52:30 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HZZ+HNlod5LBgk1D2bnPnWKsEINgIRHHk9QR+NrSEzPJ74RwmAX+fdKCwM+sMcl0bcJwDkZ9vEZgCJ/rmDYAyKIKj4Oq7Ngppad1dTHiLnxGjVhvwfVOQzFtPGRWV7TNpdsMw5Vyxw0AAbeXMbmbZEbkwtDmglIIJEprtDC+PIIcP6t7CyXYWR+9k8EpqJLCoOYo+QAXzwluAV3+l7hSTBp/RHKI3P0FopKAcjiB2O5Z9Fp57XkXCIFHR/h/S43KfuvBNODpK4Gn9Uth+/MsRQoaXCrRNHJw6lW/r+5ruh8v2n4Fsk0SWuoqPfs/347df1ngp0+JcCXvAewFxSLmDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RTeQWk2uEdnNz7G7Y/KJAeI2aPGMBpJrhLcIXKIx3Ls=;
 b=I3YKdgWgmO4nn1rj44C9D9c0FFxzxaypxAmu8CJ63RfcZ+/mnP4917QUl3YjCmolqbNDVOHwmpjvEZdSIDjWONHXhltNnMFLF1PgUkKAwOZZpXoH7vxWnbhYWaXrxpwR2baTOoz3IZh2329IZR4+SdJF2V/ANbgtIEBUM4PyP3CiqFOu1fF9CTn2If0oi0/VGrZN2sWPC/CYk2wjJjkG0PsjeK6IpWJr8Aib3QJuPsBLqeCLbi0K5Hppyn6rCi9dzp/BWQ530+eTMg1OWWsKmZLprcPyJdRQyI1JwsyriIk/8WpxJqlheAojCRbF5lx+/hsWTgTbmdWS/XuFF1ZwKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SJ0PR15MB4233.namprd15.prod.outlook.com (2603:10b6:a03:2ec::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.19; Sat, 21 May
 2022 00:52:27 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::5811:4996:bbfd:3c53]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::5811:4996:bbfd:3c53%7]) with mapi id 15.20.5273.017; Sat, 21 May 2022
 00:52:27 +0000
Message-ID: <b181f363-f66b-d74f-2251-c49877ac4b18@fb.com>
Date:   Fri, 20 May 2022 17:52:24 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.0
Subject: Re: [PATCH bpf-next v1 3/5] bpf: Introduce cgroup iter
Content-Language: en-US
To:     Tejun Heo <tj@kernel.org>
Cc:     Yosry Ahmed <yosryahmed@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Hao Luo <haoluo@google.com>,
        Zefan Li <lizefan.x@bytedance.com>,
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
 <20220520012133.1217211-4-yosryahmed@google.com>
 <YodGI73xq8aIBrNM@slm.duckdns.org>
 <CAJD7tkbvMcMWESMcWi6TtdCKLr6keBNGgZTnqcHZvBrPa1qWPw@mail.gmail.com>
 <YodNLpxut+Zddnre@slm.duckdns.org>
 <73fd9853-5dab-8b59-24a0-74c0a6cae88e@fb.com>
 <YofFli6UCX4J5YnU@slm.duckdns.org>
From:   Yonghong Song <yhs@fb.com>
In-Reply-To: <YofFli6UCX4J5YnU@slm.duckdns.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-ClientProxiedBy: SJ0PR03CA0041.namprd03.prod.outlook.com
 (2603:10b6:a03:33e::16) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 944b0a0e-9b86-4984-8896-08da3ac42cf9
X-MS-TrafficTypeDiagnostic: SJ0PR15MB4233:EE_
X-Microsoft-Antispam-PRVS: <SJ0PR15MB4233E64821060AD468DA82C2D3D29@SJ0PR15MB4233.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wtrqhtOjr5Qc/DDn46pqUqIQ+9Vk0lVrPl23ytpEdD7Zzwbhj7LB035wS2B3BWxwMO2lVPJ7tE2aADJjcYLdt5A+Wx9Zf7k8dXi9jeR9q6G7Z5G/YWH/E/b1wJMRZY4Zal6G/Vk8AcudPpLtZdxryvvc1A8InWZJVr3XYs33Y+qCim44gDAG8aK4MI5xTaDYRXVuTmiF1xUEqMvwOKj0xKD2Lr+J+fCZ3Z3j8TTz7NBKYDehRN+S0brupAVv+GPgr3icqGz67ybcHu19wLeaIKw9qyFrry3YKJMPISClcyu/JYi9h7eyMidxnHgbdNi8Lo7K9qpmTm9GP+qylFoMn94ppSw5U8W54EUHStAD2by4MqPq+3PptxGeJhnSZ6AjCkQQhOioPj095CwqZzDH50xtFocwdK54JJyTloZtmBBmXaPdL6KYeRz7t2PT+xS47yGGK4a2pxGzsMytC2KcvnwQ2pKefICX4zvucU2qaUriG2SOg642itpKyJrm5wbBvwTSxEAqTPcuxh7HE3uQFNieVEWv/aHvvPTatuE5OyvMuAxluxBJm1+8dXFR7cQrvgn0uabbmhQsVgvNUvUhFUjHnrPDAFz2+y2/x/WvpPZeniz8Cc95yl3Pd3EbiC1AjyHMmd8efJGf97QXq7A6L0cgU04oaptSB8vZFHfk3VcSdx+tAojwwYbhnPwDbCUbVkOdme9OgzKxsPJX39VtAjtffuz2RZCEtgjePcLIH9gKRLrggxfnaTt5iiDyipCchq0xsEDF8oylnCnuebKNic61GExVrxuRpjpoMHT++GJirBAOKaSJsi/5OhrsyB/tnQ2vIHLrZCZnelrEfmpCHA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6486002)(966005)(186003)(2616005)(8936002)(36756003)(2906002)(5660300002)(7416002)(31686004)(508600001)(316002)(54906003)(6916009)(38100700002)(8676002)(31696002)(86362001)(66476007)(66556008)(66946007)(4326008)(6666004)(6512007)(6506007)(52116002)(53546011)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TnkrVDBCOW9SdXFpblA0RE41WTNXUHdoQUd3OFllSHdrMmN0NHBjV0V3N0pX?=
 =?utf-8?B?bVo2RlRpM29UZTNiYXlucHc1L3pqclZicVA3RFd6NE5FY2VibGpRV2hqVU9a?=
 =?utf-8?B?UW43RG1qdVlSa2pRTmo5R1dBM2tLMXFHVTl4bXlnVjRuZU9ScFVVQ2dITDRs?=
 =?utf-8?B?dWhtVkNuUGZxdEVtaWliSHNSV2dDRTBybDIrTUE3WWNPbXZaVjlUUkZrMnBN?=
 =?utf-8?B?ZDBmd2RVbXJLankwTGM3d0VqSVFZWnVBUGdVbWdaWDVMbUpsZUdlRVRBQzU2?=
 =?utf-8?B?UXRFNjkrU2pUaWxRTXVWSlV0VmRMaDJKYkJ1TzBVazBlbFhFS2s4MHJmM3hi?=
 =?utf-8?B?N0F0R0dtcFJTdjZsSVZzS3dGQnZVekx1UCtwVmxWWUlqangvZENnMi9mUnVP?=
 =?utf-8?B?WldQZ3VVR3dRYWV0ZERxTTgwdE1hNG1vZGRJb21SVndUYjh5MmJ5dGhwVXBz?=
 =?utf-8?B?OU1VdFowV1ovZGp6OG9PRWdISnhvSHp5M3I1YmdmL0M0NTFEOUtZeXZ4NGxl?=
 =?utf-8?B?TnVOUlNuQXJRcDR1TXFqVElhUWt6SHNSRTFWUHBhVzIzTTJCWjEzSEIrV2pY?=
 =?utf-8?B?N2txWWwwK041QmZkby9ya25IeTQ2S3M4T2YzcVdINUZVbzZ2L2U5azk2OFZy?=
 =?utf-8?B?UEpCcVhMeTUrNUpKQXlWcHVPUzN6VzdvcjgxcjRmem9qb3dXOU0vdkRCWlJS?=
 =?utf-8?B?dmJudXBGdmIxTU1ZMWdLMEtObm1BMmRPRlE2dkl3UDNqNG8xQldsWmp1bDlo?=
 =?utf-8?B?ZWNJYW14dHhCQWx1aHd0OFdna3dXMytYd3Z3MDlwby8vazg0enNWSkRvM084?=
 =?utf-8?B?TmRwL3JCb1oxbDdOY05DMkRVT0FFc2IwWVRXU3VlMmtVTkZzNTFwNVo4eWtG?=
 =?utf-8?B?bTZ2bzl4elhDU1FPVU1RVGw4c0syMXhWUEdNZjV1OG1TVjd3bFVKcXo3cTEz?=
 =?utf-8?B?ekQwSDdGMVdnUU5LUXVFRmdBZURucW9sWXN1cmVVS2V1UlY0cVVPUTlxWFM0?=
 =?utf-8?B?MmRDVzNYVEF1d044S00vOTJSV2NqcENicnFtREdJdktBOW1TQi9BaUV0emdp?=
 =?utf-8?B?SVIrVjNKVDg2YUJxWUc4cTBDbzJEcGpZSmNxR0Q3a04xU0Yxc2hBSTNCdE5p?=
 =?utf-8?B?RmpDdVY3Vy9SR1dEeHNCS3QxMGVNcEROcHN4L083cGM0OFp0R204QTJtOWVD?=
 =?utf-8?B?NjhuNkhvMURENnIwei95RC9PTTRBUjVUUTk3cEdqV0JqQURBUXcwSDRsTVhV?=
 =?utf-8?B?aWVublRZcDRTcFZKcXlRUXRmQng1V0F2ZGtOSW9UZm9ScDRuRFRuL1ZvUDNV?=
 =?utf-8?B?NWlHdXlvVDE5cTBTL0U0aVRIRFpLNFQ0aTFFZ0lYRGVzOS9rdzJ4T3VXQzZ1?=
 =?utf-8?B?VXJXSWpZNzBMVEZWQlNlRTJRSVJtdVhWVXQ3blIxeFJEZi9XeDM5TWx3U0lu?=
 =?utf-8?B?QklLSk02SUk5WGFObVBmZmdPbEY3V2lkN0djLzh5ZTR6UFBlR0dlaERxcHhG?=
 =?utf-8?B?dDBud3lEekg2cDNKRjdBNnRleVRTQlNseU1JZzh3bkxvb1FFOVBhbk5pNVEv?=
 =?utf-8?B?b29ROWl1blVQWlIvMWpYTkdGLzNlWEYzYTNYRkFzalMvRllzd2F5U2xtMlNa?=
 =?utf-8?B?Z2RBZUV2TVVCUTFYOHYvZEFFRVljem80UFBWd0wyMTBkQ2RmM1BEaGh0VkUv?=
 =?utf-8?B?VnJsajMyMHFPT3g0NjZWRTQ5L2thS2ZFaGVvZGhHTzlaR2RoTDFBMzY2aTk4?=
 =?utf-8?B?eUlhdmk4MWxxTG44UEMyRlgvdnFSekNOQjdJRHdpK25icldxSVcvWUlCT0xH?=
 =?utf-8?B?NUZJdXg2QmJFTU1yTU1wMFdRMzA3WjZOOUZaQjZzbExDVXFQV0QwaFMwbGJh?=
 =?utf-8?B?UjhJY2MvaVVQdHNLYnVLUk0yNnNNeW0yeDg5dVZYcVkrcjJYMkNEQzdZUXo3?=
 =?utf-8?B?U2ZtQUg2YlpZOFlBcjlPUE41ejFUQTRpdk9aSUJhS3E4WDUxTVB2M3FPS3N1?=
 =?utf-8?B?Wnl2ZGZSQ3JqRVd2Vk05Mm9VbWdXcWdMVUxGVHlTYUQyY1c0cWs4V1Y0ZGhl?=
 =?utf-8?B?cllXU1RNVE9Fb0pMOWxCOWQrT0ZNRStBNmk5MEV0alZjQzM3RFYrOVNodDhw?=
 =?utf-8?B?UHZncmdTWXhlQTRsNmxMcmozZjJBb25PMmhxaE9qbHNvYW80RmhLeThsV3FH?=
 =?utf-8?B?S3FlcEF1ZVg5Uk5Tdlo2YnlaNGFtL1JMdVZLdFRnb25ldFYxdHphM0FVaStz?=
 =?utf-8?B?c09aSFJtS1dZM25YMWFscEJSckttY3lFeFRzUzNvaGJ3aVE3WVo2bFh4UHNw?=
 =?utf-8?B?cFZiWXBQQzFqNHVuRTIvam1xeGZMOWlqcS9hbm5pQ0EzZ1Q3SDZzb3dVYStK?=
 =?utf-8?Q?7BUjSXyck6axOyh0=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 944b0a0e-9b86-4984-8896-08da3ac42cf9
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 May 2022 00:52:27.1242
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KkWX0VmugxnmTVC8Qz3QW783nuxnzPLIk3/nctAt02e0aXOSS4YEHlP4klPpXiIi
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR15MB4233
X-Proofpoint-ORIG-GUID: 0lAbtFEuTWje_bcVe2bV5roQtrNtKQtC
X-Proofpoint-GUID: 0lAbtFEuTWje_bcVe2bV5roQtrNtKQtC
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-20_08,2022-05-20_02,2022-02-23_01
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



On 5/20/22 9:45 AM, Tejun Heo wrote:
> Hello, Yonghong.
> 
> On Fri, May 20, 2022 at 09:29:43AM -0700, Yonghong Song wrote:
>> Maybe you can have a bpf program signature like below:
>>
>> int BPF_PROG(dump_vmscan, struct bpf_iter_meta *meta, struct cgroup *cgrp,
>> struct cgroup *parent_cgrp)
>>
>> parent_cgrp is NULL when cgrp is the root cgroup.
>>
>> I would like the bpf program should send the following information to
>> user space:
>>     <parent cgroup dir name> <current cgroup dir name>
> 
> I don't think parent cgroup dir name would be sufficient to reconstruct the
> path given that multiple cgroups in different subtrees can have the same
> name. For live cgroups, userspace can find the path from id (or ino) without
> traversing anything by constructing the fhandle, open it open_by_handle_at()
> and then reading /proc/self/fd/$FD symlink -
> https://lkml.org/lkml/2020/12/2/1126. This isn't available for dead cgroups
> but I'm not sure how much that'd matter given that they aren't visible from
> userspace anyway.

passing id/ino to user space and then get directory name in userspace
should work just fine.

> 
>>     <various stats interested by the user>
>>
>> This way, user space can easily construct the cgroup hierarchy stat like
>>                             cpu   mem   cpu pressure   mem pressure ...
>>     cgroup1                 ...
>>        child1               ...
>>          grandchild1        ...
>>        child2               ...
>>     cgroup 2                ...
>>        child 3              ...
>>          ...                ...
>>
>> the bpf iterator can have additional parameter like
>> cgroup_id = ... to only call bpf program once with that
>> cgroup_id if specified.
>>
>> The kernel part of cgroup_iter can call cgroup_rstat_flush()
>> before calling cgroup_iter bpf program.
>>
>> WDYT?
> 
> Would it work to just pass in @cgrp and provide a group of helpers so that
> the program can do whatever it wanna do including looking up the full path
> and passing that to userspace?

I am not super familiar with cgroup internals, I guess with cgroup + 
helpers to retrieve stats, or directly expose stats data structure
to bpf program. Either one is okay to me as long as we can get
desired results.

> 
> Thanks.
> 
