Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55E3653146C
	for <lists+netdev@lfdr.de>; Mon, 23 May 2022 18:25:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238128AbiEWPmF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 11:42:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238093AbiEWPmC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 11:42:02 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 715C83893;
        Mon, 23 May 2022 08:42:00 -0700 (PDT)
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24NB4GXq007302;
        Mon, 23 May 2022 08:41:44 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=1ZIhtYxH6LhqP7wMlhSSJzDCSCL5XdlKJ0cyz33+6zE=;
 b=Kh+NvFB82xNKHlovCU5kCDZ2JeDdLAsSxfansr9RhDYyC/BGBFiWZQqtDwucAfox/KFk
 fdthUKuZejEQZ9GDQ3UUlIz7el4MfhoCqFp5LVWhzjb6QcY1odpkDN10MiRlXSnwgPBR
 HhdfltGCTv8mR86708naaxruPXhQyeC3wBU= 
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2100.outbound.protection.outlook.com [104.47.70.100])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3g6yd39amm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 23 May 2022 08:41:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DeDPuJCnXEYvJ+zIS4lCHqMlKrUgSLXIksq8rFuUH3C9aQxtXWAN0hcc5eM/cIr6DmNGecqLHOBcKaSBRG8K/0lnvO3JeaULdK12RHbYDQCY/7/eiOl5xx2SGgMDdkoN/ONGrGy3UAmLU9qZNKTCEMrikmIn/XdcFj8HR0JgNBD05+2hYz13958CctwMYdrhYQSwm7ACft/inbm4q9CYq4RwRZ7V2ZIfaOtjSkScylzRD19LvM0NuoKhmttF1lGEatXNuBB/cQnmuanBCTQc4TP4YV6A4jWyYtjQMKw8T0H3uKd2ddOY8Sm2vVtFSk/qiOgv+WyU/wBpBlUbYTgV8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1ZIhtYxH6LhqP7wMlhSSJzDCSCL5XdlKJ0cyz33+6zE=;
 b=QbSzj0H1Q9u/t92kN6UjF/5aC+5estTYdzUWj0yM8Tx8J+Oul202GSVOuQb7w3EZZcWjsl98cmWTt2KN40Jsf5vC/DszQUnfTEQxHFsWpVRiAwKsCDKqb6LvrN7QdyXvA0j304u5i4KH0TdYxlHHUiQSkkMj7mEUSM/NVUd7zq7jVz3hf50jM3J78TOFgFJoWMLgZ/lfOP+G0yeN6WNxFIki4ch5Do483hLSkwz/qG+tSnsxfglEFUO0rLdmXT/zENpN1lGvcth9hjFxlZ8mQkUhkfSDYH+9PztNXbp84JVlyd7ByKyWwgpXWO5qvuKmPEI+6Vs0p2UbSyHIEcv6DQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SA0PR15MB3871.namprd15.prod.outlook.com (2603:10b6:806:80::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.23; Mon, 23 May
 2022 15:41:41 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::5811:4996:bbfd:3c53]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::5811:4996:bbfd:3c53%7]) with mapi id 15.20.5273.023; Mon, 23 May 2022
 15:41:41 +0000
Message-ID: <e693a6f3-7058-0bc8-d5a6-f1572ebd75f8@fb.com>
Date:   Mon, 23 May 2022 08:41:38 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.0
Subject: Re: [PATCH bpf-next v7 03/11] bpf: per-cgroup lsm flavor
Content-Language: en-US
To:     Stanislav Fomichev <sdf@google.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org
References: <20220518225531.558008-1-sdf@google.com>
 <20220518225531.558008-4-sdf@google.com>
 <36bdf09d-dfb7-6e3e-fb62-bae856c57bc2@fb.com>
 <CAKH8qBuaOSP3nFFwExnTRcgiNt-hvL4Nc_sLrFZnZRK=s8-zng@mail.gmail.com>
From:   Yonghong Song <yhs@fb.com>
In-Reply-To: <CAKH8qBuaOSP3nFFwExnTRcgiNt-hvL4Nc_sLrFZnZRK=s8-zng@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0262.namprd03.prod.outlook.com
 (2603:10b6:303:b4::27) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cdad57c9-e2c4-4bcf-f553-08da3cd2bb9b
X-MS-TrafficTypeDiagnostic: SA0PR15MB3871:EE_
X-Microsoft-Antispam-PRVS: <SA0PR15MB38718430F714220626E7D6C4D3D49@SA0PR15MB3871.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Z9SE02M9VNzCyZL8gY6aNVLyNjKmEj6zsTPqHlrcBM2Vl47bdEyA0KxiB9b0q6DKkkJAtAK2VBCt1aQUx9xsFYC7gXlSIS7prLkIMND0KUoFWMqt0jUffBZtrP7xoaY76/N8Jmbp1aR+cJPbkI48bNM1aMu1ciOc8sSUg2o/ypSFsvZrfWTHy87E8EaiN3hbh9W2xFipGq7WuJmMMs4e0YsemA7EO4Uk8/t9+XvDeqRLyHSMlD72AiAdDHL0piSa7ilUkSskzG+PFdkahtU09PbkVBzdAW4i5VmfzsQs6zNfBZyzUC6Y9Yz/aqy5ibhKw0jevgy/np1zPRB9Km1hBdh4RsQ47x3u1PndcJ7N9ZD26Fac9C0E3rbCDA/7GXsj+eXC+HhoT9pvQyoq0PwVVFeGnpzx/reUq7AXjZS0H+7RgwaWgy26Lhu1FlS4rV+ffP6PIaDJhFcOIIpRCoacg/PnSo2nWBTjQQwFahxAbVfwgYpKTn60moZix54fJM34VxrH7me5nkRpaT16IFEUzQMj9WTKzyMHC/oHQNMldORDKrliIxc3sM0OHT/SkvWnpAKZ3WL9EaEZ+1fynaivsOTfe3fcX1cITvUAe2d8kgXKNmKdCa3q+ER+v8d7WsI6mqn+K8VoK3Mq8jun0WduqDxx8C666pxlUfSpHGFDxTm35AVOe8vmxK08FWX/DZWP042G+z4DUkyUJbbN5FwBBMFQ6ye4dyK0KsU+sfVtH1c=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(31686004)(52116002)(38100700002)(6512007)(36756003)(6916009)(2906002)(31696002)(6506007)(6666004)(53546011)(8676002)(316002)(83380400001)(8936002)(4326008)(66556008)(66946007)(66476007)(186003)(86362001)(2616005)(508600001)(6486002)(5660300002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OTZZLzNLdzQ4VnBTV0cvTzNzeXRnN3RDZVNwcExxRWJ4U3pZR0lkUVM0N2FE?=
 =?utf-8?B?eFlFYkhjZ3NtcFpGa0FEY3JKcUxkanM2azlrYzY2SjBwZ1VRYjZGQnM2ekhM?=
 =?utf-8?B?cHVqMFdlOVlyZ1ZTSG1RSVpnY082ekl6R2hwREg2NUVsNWlpMUlleThFUzNM?=
 =?utf-8?B?S01PQ1VyaWdqbUVEVHArQnZUYzAxZ2JPV2d1RCt6NUd6R0FOSkoyOGlVOFhN?=
 =?utf-8?B?ZkNKaTVncnorU01JM1pPaisyVWFHaitTamV2QzBaWGN6ZWJJcVlRd0FDR2Z3?=
 =?utf-8?B?RTNCc21reWMwZzVwQS9WZWVHb2hmMVoyeEpUM0FYRCtVbEdZOXU3NEhTWml4?=
 =?utf-8?B?NWw0Wll2eCtQTDV2VzI2Nmt2c0huWm5naHJOTFlRKzZXelVqWVprWmJRM0dX?=
 =?utf-8?B?RDh3WWFBeXg2bU4zUzZjaGhPRUxuelVQTzlZNExVYloxZ3E0UFZPbnpTWE9E?=
 =?utf-8?B?dVFVQXF5MDQ3V1hPQjhxZ0JRRmZkZkJ2U3Z5VkJTUWhsRXdYcDBmdzF2MEVT?=
 =?utf-8?B?cldpZWQrZ2RTVnFMNUxsWmRmY0FUTjlsM1l0ZGw5K1JXcUdKV2VObWxvcnR1?=
 =?utf-8?B?bmo4bldDWHpTWHB5aDJraUhNYURjTDFWM0Q5MHpaR0Y4NWUwbWJCUlhhR2I3?=
 =?utf-8?B?UFh1dGdwQ0hBMW9CVTN6SXE2L0g3ZUNtSmlaOFNRTFlUUjRHbWVhQ28vdFRY?=
 =?utf-8?B?ckJWd0ZuVncrUUkrMzRRbDArZ2JNQklZS2RBTi9oNzVxblNwa2JwdWVudmtu?=
 =?utf-8?B?bGZCVEp0UWxFeWZOMTJQOUpreW9NL2JRRkZ6QTdhYlFzWW1KbG4yVzNzZk5B?=
 =?utf-8?B?R2F1bFFmRFcyVlUrbllMUUZiSUxDeEhSZGdLenk1bkxpOFFCUWlzT084M1Jz?=
 =?utf-8?B?ZXlEN0xiWElISlVHdU9OaXF3ck9jdWhLWHlBdnRFRHJRbkhoWkxNVHlTdnlF?=
 =?utf-8?B?ODhaSFREMjZJZWZjWHJPSjNrSjRQVkQ5czBxNnpmSmpjUG1FdTNwSDVvZUVp?=
 =?utf-8?B?dzFYaEdGaVAzS0dicXFBTDhYTTJCZWI5ZjVZUGRrKzlPSnJSVjl0ZVh2dytP?=
 =?utf-8?B?SXA0VzlHalROdDdGaXN4d0ZjTzVYZGRNNjh2Nno0Nno1bTk3eFlyWHcxcElD?=
 =?utf-8?B?bWlZMCtLYWhvYUVZMFE4ZExJR05IcW15ajk2N1hEeUtUcTJ1MXBYQk5jajNV?=
 =?utf-8?B?VkUwUnFBcEpadEVQTFhjVndVUzVKbmpXckJoT0tOVDFGTjZzQ29kRmRWNWg5?=
 =?utf-8?B?Um04bThab1FScWlndnBBK0pxRERjTkxPd3VudWxxWVdMamFzZkNtSXMwNnlu?=
 =?utf-8?B?anZEKzJ5dFJJa1IzaVVnM1JoTlV1R3JxNEVzOWo4TWozdEFnbmFaSGZBV1o3?=
 =?utf-8?B?TFRuMG9sSE9MbXNXdTh5UXhiUFEyMmlJZTBhRmpoVzhWdDJ4NW1tbElUMHdu?=
 =?utf-8?B?MithaHJkNGExaUhoRjZwdU56Wkx0NDh5aEY1NHZFYU9TZiswOE1SaVgyQitx?=
 =?utf-8?B?S1k2ZjVUS1E0NUEzdmRQSUNIanI4UE4zZTYvYnBJdzM5VTM4d1QreC8rUzd5?=
 =?utf-8?B?QzVtcmVCTzhSOUJSaTRkM2F4dHV0VDdPNU1qaXUvQ3pvVXFnbWpRYmtYUWZt?=
 =?utf-8?B?VUFnT2hPTlV5TFBTenlOL3lnR2p1L3Q2UG9OOWhYQUV5QVpHUGc2UmlBNFgr?=
 =?utf-8?B?WWZOSGo3cjRZN1pycjZibnlMdWpvZE5xWEV1TWZVckc5NEwrVXRielhqcEx4?=
 =?utf-8?B?bnNqNEhjNEU3ZGVVdkYzYWM1SlJGOVVWekdrZTFwM0s0UXJBcW9vOUIzaGpC?=
 =?utf-8?B?MlF4UGJ2MnJYZmJ4cFFNaDFJVmJsK2J4YWlzdWIzZ2JSOGV5eXl1cjJlZjFw?=
 =?utf-8?B?ZjVBeVBlRVh4TzgySzhMSEJIVG0rbWxaUkNiNnFQelFLUDByZ3ZNU2NBR0pQ?=
 =?utf-8?B?bVZsdVhnaDJTUStuME5ZeURTZXovQ2FpeGFjM0RSYitEZUF0eUV4ZGhWV2ZG?=
 =?utf-8?B?ZE1UT0cwM09VWVRya28vd3FGTk56S1dBQ3hTcXRydWtpK08vQkd4WVpYTDY4?=
 =?utf-8?B?NUtMSkNwaWNOenFvbTh3T1M2czd1S1Iyd29sTVRXMGJuTjVsWjJ4WUlQa0Fr?=
 =?utf-8?B?Vnl2QnNpS2RyTWNPNG0wdk1YOE43YW5jbW1SOWZYQU1VZXN0b0s1M2h6MElI?=
 =?utf-8?B?TllFZ0k0ZGE5U0VGZE9hNHZ6ZXdKZ0x4c3c0eUVJejFtLzZ1b215YkM4TU83?=
 =?utf-8?B?QW1Kc0FBamo2VjYydU9MZXZGK3pQOFppUC9uUVVzR2NzNjA4VmgwdkRXdkha?=
 =?utf-8?B?ZUdWQW5ONjdFZEg0d1M3YXg3SEtkeFNyR1BKcVFRdHdLRFFOVi9UTEptL1p6?=
 =?utf-8?Q?vgNkftXdE8L7PL/g=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cdad57c9-e2c4-4bcf-f553-08da3cd2bb9b
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 May 2022 15:41:41.6111
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XvhtH01zS/2fzW3gtUmYfCnXpm/dkzqdtMkeAumGsBlR77mVX8uNl5eRth5htpsS
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR15MB3871
X-Proofpoint-GUID: ZQqDizMKrC1tsthUEnOFqTUBTtSAFvco
X-Proofpoint-ORIG-GUID: ZQqDizMKrC1tsthUEnOFqTUBTtSAFvco
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-23_06,2022-05-23_01,2022-02-23_01
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/20/22 5:03 PM, Stanislav Fomichev wrote:
> On Thu, May 19, 2022 at 6:01 PM Yonghong Song <yhs@fb.com> wrote:
>>
>>
>>
>> On 5/18/22 3:55 PM, Stanislav Fomichev wrote:
>>> Allow attaching to lsm hooks in the cgroup context.
>>>
>>> Attaching to per-cgroup LSM works exactly like attaching
>>> to other per-cgroup hooks. New BPF_LSM_CGROUP is added
>>> to trigger new mode; the actual lsm hook we attach to is
>>> signaled via existing attach_btf_id.
>>>
>>> For the hooks that have 'struct socket' or 'struct sock' as its first
>>> argument, we use the cgroup associated with that socket. For the rest,
>>> we use 'current' cgroup (this is all on default hierarchy == v2 only).
>>> Note that for some hooks that work on 'struct sock' we still
>>> take the cgroup from 'current' because some of them work on the socket
>>> that hasn't been properly initialized yet.
>>>
>>> Behind the scenes, we allocate a shim program that is attached
>>> to the trampoline and runs cgroup effective BPF programs array.
>>> This shim has some rudimentary ref counting and can be shared
>>> between several programs attaching to the same per-cgroup lsm hook.
>>>
>>> Note that this patch bloats cgroup size because we add 211
>>> cgroup_bpf_attach_type(s) for simplicity sake. This will be
>>> addressed in the subsequent patch.
>>>
>>> Also note that we only add non-sleepable flavor for now. To enable
>>> sleepable use-cases, bpf_prog_run_array_cg has to grab trace rcu,
>>> shim programs have to be freed via trace rcu, cgroup_bpf.effective
>>> should be also trace-rcu-managed + maybe some other changes that
>>> I'm not aware of.
>>>
>>> Signed-off-by: Stanislav Fomichev <sdf@google.com>
>>> ---
>>>    arch/x86/net/bpf_jit_comp.c     |  24 +++--
>>>    include/linux/bpf-cgroup-defs.h |   6 ++
>>>    include/linux/bpf-cgroup.h      |   7 ++
>>>    include/linux/bpf.h             |  25 +++++
>>>    include/linux/bpf_lsm.h         |  14 +++
>>>    include/linux/btf_ids.h         |   3 +-
>>>    include/uapi/linux/bpf.h        |   1 +
>>>    kernel/bpf/bpf_lsm.c            |  50 +++++++++
>>>    kernel/bpf/btf.c                |  11 ++
>>>    kernel/bpf/cgroup.c             | 181 ++++++++++++++++++++++++++++---
>>>    kernel/bpf/core.c               |   2 +
>>>    kernel/bpf/syscall.c            |  10 ++
>>>    kernel/bpf/trampoline.c         | 184 ++++++++++++++++++++++++++++++++
>>>    kernel/bpf/verifier.c           |  28 +++++
>>>    tools/include/linux/btf_ids.h   |   4 +-
>>>    tools/include/uapi/linux/bpf.h  |   1 +
>>>    16 files changed, 527 insertions(+), 24 deletions(-)
>>
>> A few nits below.
>>
>>>
>>> diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
>>> index a2b6d197c226..5cdebf4312da 100644
>>> --- a/arch/x86/net/bpf_jit_comp.c
>>> +++ b/arch/x86/net/bpf_jit_comp.c
>>> @@ -1765,6 +1765,10 @@ static int invoke_bpf_prog(const struct btf_func_model *m, u8 **pprog,
>>>                           struct bpf_tramp_link *l, int stack_size,
>>>                           int run_ctx_off, bool save_ret)
>>>    {
>>> +     void (*exit)(struct bpf_prog *prog, u64 start,
>>> +                  struct bpf_tramp_run_ctx *run_ctx) = __bpf_prog_exit;
>>> +     u64 (*enter)(struct bpf_prog *prog,
>>> +                  struct bpf_tramp_run_ctx *run_ctx) = __bpf_prog_enter;
>>>        u8 *prog = *pprog;
>>>        u8 *jmp_insn;
>>>        int ctx_cookie_off = offsetof(struct bpf_tramp_run_ctx, bpf_cookie);
[...]
>>>        return bsearch(&id, set->ids, set->cnt, sizeof(u32), btf_id_cmp_func) != NULL;
>>> diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
>>> index 134785ab487c..2c356a38f4cf 100644
>>> --- a/kernel/bpf/cgroup.c
>>> +++ b/kernel/bpf/cgroup.c
>>> @@ -14,6 +14,9 @@
>>>    #include <linux/string.h>
>>>    #include <linux/bpf.h>
>>>    #include <linux/bpf-cgroup.h>
>>> +#include <linux/btf_ids.h>
>>> +#include <linux/bpf_lsm.h>
>>> +#include <linux/bpf_verifier.h>
>>>    #include <net/sock.h>
>>>    #include <net/bpf_sk_storage.h>
>>>
>>> @@ -61,6 +64,85 @@ bpf_prog_run_array_cg(const struct cgroup_bpf *cgrp,
>>>        return run_ctx.retval;
>>>    }
>>>
>>> +unsigned int __cgroup_bpf_run_lsm_sock(const void *ctx,
>>> +                                    const struct bpf_insn *insn)
>>> +{
>>> +     const struct bpf_prog *shim_prog;
>>> +     struct sock *sk;
>>> +     struct cgroup *cgrp;
>>> +     int ret = 0;
>>> +     u64 *regs;
>>> +
>>> +     regs = (u64 *)ctx;
>>> +     sk = (void *)(unsigned long)regs[BPF_REG_0];
>>
>> Maybe just my own opinion. Using BPF_REG_0 as index is a little bit
>> confusing. Maybe just use '0' to indicate the first parameters.
>> Maybe change 'regs' to 'params' is also a better choice?
>> In reality, trampline just passed an array of parameters to
>> the program. The same for a few places below.
> 
> Sure, let's rename it and use 0. I'll do args instead of params maybe?

'args' works for me too.

> 
>>> +     /*shim_prog = container_of(insn, struct bpf_prog, insnsi);*/
>>> +     shim_prog = (const struct bpf_prog *)((void *)insn - offsetof(struct bpf_prog, insnsi));
>>
>> I didn't experiment, but why container_of won't work?
> 
> There is a type check in container_of that doesn't seem to work for flex arrays:
> 
> kernel/bpf/cgroup.c:78:14: error: static_assert failed due to
> requirement '__builtin_types_compatible_p(const struct bpf_insn,
> struct bpf_insn []"
>          shim_prog = container_of(insn, struct bpf_prog, insnsi);
>                      ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> ./include/linux/container_of.h:19:2: note: expanded from macro 'container_of'
>          static_assert(__same_type(*(ptr), ((type *)0)->member) ||       \
>          ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> ./include/linux/build_bug.h:77:34: note: expanded from macro 'static_assert'
> #define static_assert(expr, ...) __static_assert(expr, ##__VA_ARGS__, #expr)
>                                   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> ./include/linux/build_bug.h:78:41: note: expanded from macro '__static_assert'
> #define __static_assert(expr, msg, ...) _Static_assert(expr, msg)
>                                          ^              ~~~~
> 1 error generated.

You are right. Thanks for explanation.

[...]
