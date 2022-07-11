Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1285C570E2B
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 01:20:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231350AbiGKXUr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jul 2022 19:20:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229811AbiGKXUn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jul 2022 19:20:43 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 511E4240B8;
        Mon, 11 Jul 2022 16:20:42 -0700 (PDT)
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26BNCKrs003882;
        Mon, 11 Jul 2022 16:20:14 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : from : to : cc : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=/WhxfDpH50Sb2qh5TYOpSPqv54bg2xPOrEmDshi5FjY=;
 b=SPfZw5k9zQoE6Wc0aeHuzJVOMCE4vTNRF+/u4Dr3cvWBHgHzX6XD2set6pCoIn0C8MgL
 fFuEaJ1w4qXPjP5P8nPnxz7YxIkA33SC2ZjBts56Aqc0TCkzMzal7nO5cLyjhQDOnccw
 m8MCkOSUR35THppnW5Cpf8Xb1OcNoSKZQMM= 
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2049.outbound.protection.outlook.com [104.47.56.49])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3h8w4n83ja-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 11 Jul 2022 16:20:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RZ16AamE1r1yfXxc4Cy5xTupo8fIM7ziap9iKWmGL8kJvZjNuGQTIX5oYig/WEB53LjeY78g69tHIyKIjJXJdkpq64RGEvAtM3+3Tk5lI1kxodzBiEh+kjh4XTbZVPNGJWuSs0ENb/OSAdiHBCPRr3C+4UBKrQ3CPOP2/rZhC2tdO0bWnFhYe4CicVuINuCUeVhfCwge/nV19/crYQv9xsc6rXZ4SetGbHfTLHez+X463bH/mi4fSojfddXe6qThE2D93z9lGI3K7kti9eHPMpW1Wju/d6a2FAEpgWqSIa8EeAJzCUBxMFuiQMkoo3hSFCzno+2TjPq63fF1Puf7BA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/WhxfDpH50Sb2qh5TYOpSPqv54bg2xPOrEmDshi5FjY=;
 b=m0dDtE0ahhgxzrv/1Q24TU3Cv451Ic4RaRindUGcv52F4AxJTEXGd6dCL3Xuw37WXYJOlgCMq1QKgpBtl6StsuWAAKp+z3mO6WS2roiqo1sfRZ5bsh3dg++jMnIhCcZ3mRSBKg90a3Jqopd+n0gsWbi2dJKyXGps2kl/9olP7I6VoB9A2F5iafknzblmAYtxwjwaGSyWKbW6+UDLa5A6DZnLPOuvyDMLCc9oIvnz4rDXy6SOPFT5HOLncFVvP6xSxcgsF9rka+m4Cmc2WM8u6VWzSpC34Oyi0axWyqCws9UBnCbIz8KRLXoXXZpIt/JgP6K1ixdliQhqsIqlgFASOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by BY3PR15MB5028.namprd15.prod.outlook.com (2603:10b6:a03:3cb::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.26; Mon, 11 Jul
 2022 23:20:11 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::9568:e5d9:b8ab:bb23]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::9568:e5d9:b8ab:bb23%6]) with mapi id 15.20.5417.026; Mon, 11 Jul 2022
 23:20:11 +0000
Message-ID: <a6d048b8-d017-ea7e-36f0-1c4f88fc4399@fb.com>
Date:   Mon, 11 Jul 2022 16:20:08 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Subject: Re: [PATCH bpf-next v3 4/8] bpf: Introduce cgroup iter
Content-Language: en-US
From:   Yonghong Song <yhs@fb.com>
To:     Yosry Ahmed <yosryahmed@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Hao Luo <haoluo@google.com>,
        Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>
Cc:     Johannes Weiner <hannes@cmpxchg.org>,
        Shuah Khan <shuah@kernel.org>,
        Michal Hocko <mhocko@kernel.org>,
        KP Singh <kpsingh@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny@suse.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        David Rientjes <rientjes@google.com>,
        Stanislav Fomichev <sdf@google.com>,
        Greg Thelen <gthelen@google.com>,
        Shakeel Butt <shakeelb@google.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, cgroups@vger.kernel.org
References: <20220709000439.243271-1-yosryahmed@google.com>
 <20220709000439.243271-5-yosryahmed@google.com>
 <370cb480-a427-4d93-37d9-3c6acd73b967@fb.com>
In-Reply-To: <370cb480-a427-4d93-37d9-3c6acd73b967@fb.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR03CA0099.namprd03.prod.outlook.com
 (2603:10b6:a03:333::14) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e55e8f00-29c8-4f67-4066-08da6393e6ec
X-MS-TrafficTypeDiagnostic: BY3PR15MB5028:EE_
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jIhYCi898XcgsGI1SNufFUxfcVloRtTDGy5gY+mOh9yfeHN6QzAMegHXUf61GVybSJKLiMdQstaWSl9ud7k/ABx7Mkva11Md1qiUnadrSt1shIaYO+rGwTDKsdjkzYr8YRLHY25P6Q/XLd2JmAUHI616vSQ7TPdZLB5nckIuNXm517sE7zCJQpN3OJgzSwpV7Vm4EdfdT1kN+WZCpPSAEGxcYVbPGvDrCTcwPAIrtFjafiY6ZVUDOg/pr/LHxDdv2b5A+5/MKC0UicFjtAEORxNs95+qE6U1Ru5QFepYRkEgpwS1fWwu85RkuHAqyw8II0/wCIlWVk7U2SH0HOsJPeONe7c7gBOpSalMOnJ29GKxRcbqA0KuwQsgJ7tqc7I4HldSCy3g8jUC6p55OrpClkDptLZBVc8Ct5r610E87q9qFl/5CykkMGXLJj64XDNvs+91Jtm3ubKZgMeeqe0v3VLXB7jX5+jhYrICFaHAH0HKg0yfJUrGV/eb1GNWqhc2utuof1ezFSR27PN5NzwDnLObXomc1rPeilsWy1uKbiS10CG8qYlsdW7OTnX+CyJz/xzNTmAodYGjXYVNOsQeQ1AmEHBaxCBYdH0R/GMTnKnTqmhKSR+xnfOgSQOMeo4Bw8KpBeuZl2PVSp94U19SPPDusqyI7t6SWwfXoDSljogLa9pIrhj9dNysfjdJbh4+pJn0/9I0iv1j3Tf5c6C7swNH1SHZeF3CkdfuapXYzME59JXprsjGwRtR8Dp+jSu5lTFfqcGsXOMlJXR51y5krQRK+vdZXCRFE6j1WKW1/e5EILLG8GcG9Ph/snWq/3cmOp5WTNpv3pyuf94ORCUhoydrUcrBIxTtxsNg2/neM7k=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(346002)(376002)(396003)(366004)(136003)(110136005)(54906003)(6486002)(478600001)(38100700002)(36756003)(316002)(86362001)(41300700001)(6666004)(6512007)(31686004)(186003)(53546011)(66476007)(66946007)(4326008)(8676002)(66556008)(2616005)(31696002)(6506007)(5660300002)(7416002)(8936002)(83380400001)(2906002)(21314003)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QkhFMDBzeDBWdlNUVHNqNitPd1Vla3VXckpCMCtLNkJCN1RpNzRscmZUR0ZZ?=
 =?utf-8?B?L2JIT1BaOTR4ckJRNkJaOVBmN09lMlJrZ1hRSFFTNWZnSGUyNlJWWTI4OWFD?=
 =?utf-8?B?V2REbGY0c3Jra0dvR29TOWJscXVpeFk3QWx6Y2R2UDh3MndMY3dhak1MWmhu?=
 =?utf-8?B?dzNscms0Y09NVWlpVHpnMmFsWUVOTXk4MUk0Wk1rd1lnUXBzZDVWVWhOTUgw?=
 =?utf-8?B?NE9QZ1JmZHg0c0xHSFlzN1VvZGl6TmNEYmM0V3EyaklsTlU3SklpaGZFOEtQ?=
 =?utf-8?B?N3ZlL1R3bzJPTy9jVUhaOHN1cDc0d25jT2hOeDc1bnJwYkd3K0YxZXNsVDRG?=
 =?utf-8?B?L3NhK3hIS3FyWmU2elJocWVtaEdNSmlONEpWemZUTUJ6VU9ZNzF5QWdxcjN0?=
 =?utf-8?B?SUhlVEFvWkNXREM5K29WZWgwSGFiNE1vS1MwVVZrSzlOa1dpdVpaVXpJVFZK?=
 =?utf-8?B?RzNaZ1lsNHk4T0R3dU8ycjdYWG9HeGQwSGhZVG4zTy9QaFEvV0JrdWhkdlpM?=
 =?utf-8?B?YmNpS3hBMW9JUkltdkMvak51QjlSOFRWL3FlL096RGl2dkpySFdwU0lCSndK?=
 =?utf-8?B?aW00b2FOYnR0aUxRbUxROTVwVTQrR1NBZGU5NStXU29ZMUIybXZ5c3pxRW9Q?=
 =?utf-8?B?WW1NWmt0TkJYQnpMOXhCMWd1YXRGQk5sYm1ISjVZN3RWNWhPelpoN3dQODZs?=
 =?utf-8?B?OENtdHVnaE1lVTFZZTZmUlVrSlpvR2Z4Tk1VaHJkcjFYRHBxWFJxWnFrUE1w?=
 =?utf-8?B?a0Zoc1lvQkViTlJORnljMitINW9TaEYvR0hNTEwzd21RRnB4bTh5eHREekwz?=
 =?utf-8?B?NExmS0RmOGU5akxyK3NJZlhubHpqMmozeEVtaWhFdGVjOCtuTmxUSDlQdDIx?=
 =?utf-8?B?ZjFNSm82cTFGMVBXT2tYdzl6aWJvY1JkK0tKL1ZPbERVdzZGNjNyUXBCWmJu?=
 =?utf-8?B?UG40aVpidS9SbUxoV2ZRdFRldjgxVE9IVTZ0aVo2eHpEVHFuR1NGY3dIL01F?=
 =?utf-8?B?czN3VzdXdFF2c1VvUXFWaXhydzkyalNEdnVxWHVLSHp3bGpIVFl3NkNZR25F?=
 =?utf-8?B?L0h2TGZ2TzViSURaakNjQTdIUllNcmI3OUltdDZrS0dFTUE5aCtwMHI2NE51?=
 =?utf-8?B?Y3RaTGorbnlodGJkNmZETkpOYnVlQk52aklYMU1yc2VTQ3RlL0FMQWtVNk9z?=
 =?utf-8?B?bUlBUjU2Y29XSllIa1pMRjRZenV5aHlLZkxwVnZGWDBvUVdCcThvQWpUUnVS?=
 =?utf-8?B?eTE1TkNrVWVwRC9tQnB4d2RrdkpsZmFUdmlwbGgzdm9ldTBPSTNucjRtREpW?=
 =?utf-8?B?Z3lDNVhHUGc1YjZidHZyalhsT1BUV3dud0dmb0prMCtDUTNlQkhZR29CczZl?=
 =?utf-8?B?Q05lTjNwbFlmcWY3VFQvcU9EV1RJS1MyYm4xNDlsOVBnM09zb3RNY1lBd042?=
 =?utf-8?B?VmFTaFA0djNFSDVKTlNORjFoeFFjZ05kZGxTaVV0MWF3cHEvcUs5alF2alUv?=
 =?utf-8?B?VVl0LzJPQW4wbUpRM0dYbTFCNDBxM0FvQW9qZjh1U0ZrNTBsakFqZzFzYmFs?=
 =?utf-8?B?QlJKWFpFQ1hzeENENFdBVlA5V1prZVRQNGp5ckRoQTJEOEs3UEhXdjNnNG85?=
 =?utf-8?B?cjA4QlhoSDZiMmJpNWE0cXRGSE9QdDlUY3dnMXJ6NzY1a0RqcWwvTDZKQ2RH?=
 =?utf-8?B?cWs0aVFtdEhvaDRDSDB4WnA2bDhHaDZ2VmpPcnpkNkVZVE5KdHNpU0k3Z1M3?=
 =?utf-8?B?UnFxdy9HcUxMRGNWTmdOeitpd1hDL2xldVF6T2UvQmUyT1JZbHdEZjF3bEho?=
 =?utf-8?B?WGx1Tk54bHRCdmdMSjVWRHZtclZwYWRMSE9mRU0zMGp2NFFHMk1sZHlaSDRY?=
 =?utf-8?B?MlhEREZqKzI3aW9wV3hSUHI3L0FCSDRoTE9lbzJCUFhUYkw0M0RocWxnd0V0?=
 =?utf-8?B?cTFhY2sxdVFnSHpIOXI0TFA1Q3BVbkhhWWV6S09JYlFGcitrZlU4SFVHVm54?=
 =?utf-8?B?SzFCOW1NTEd3d0RUQ1l1dnVJd3l4RS9mZi8rKzlHZFRCTEVUbm92L0FFS1lC?=
 =?utf-8?B?N0o3TzUrWGVyb1JqeitsYUIwLzVLTWFuWmV3c3NQZllnYmIxSHplbkhNVDF4?=
 =?utf-8?B?Y1prb0FnWG9vMVVuajRDbWw1d3FvMlhLVHpCWGczQzQ0Q1J0c0tCa0NCbThN?=
 =?utf-8?B?V2c9PQ==?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e55e8f00-29c8-4f67-4066-08da6393e6ec
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jul 2022 23:20:11.4431
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pFlq/PNf/qaJjxmkOaf5sChtrAue+qfbU+wkfLzsN+ghTgTMHcNCc1R6Junz6SRK
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY3PR15MB5028
X-Proofpoint-ORIG-GUID: RUzGwmq4WNhMz-mWEzR_2H-3cBlnMl_X
X-Proofpoint-GUID: RUzGwmq4WNhMz-mWEzR_2H-3cBlnMl_X
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-11_25,2022-07-08_01,2022-06-22_01
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/10/22 5:19 PM, Yonghong Song wrote:
> 
> 
> On 7/8/22 5:04 PM, Yosry Ahmed wrote:
>> From: Hao Luo <haoluo@google.com>
>>
>> Cgroup_iter is a type of bpf_iter. It walks over cgroups in three modes:
>>
>>   - walking a cgroup's descendants in pre-order.
>>   - walking a cgroup's descendants in post-order.
>>   - walking a cgroup's ancestors.
>>
>> When attaching cgroup_iter, one can set a cgroup to the iter_link
>> created from attaching. This cgroup is passed as a file descriptor and
>> serves as the starting point of the walk. If no cgroup is specified,
>> the starting point will be the root cgroup.
>>
>> For walking descendants, one can specify the order: either pre-order or
>> post-order. For walking ancestors, the walk starts at the specified
>> cgroup and ends at the root.
>>
>> One can also terminate the walk early by returning 1 from the iter
>> program.
>>
>> Note that because walking cgroup hierarchy holds cgroup_mutex, the iter
>> program is called with cgroup_mutex held.
>>
>> Signed-off-by: Hao Luo <haoluo@google.com>
>> Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
>> Acked-by: Yonghong Song <yhs@fb.com>
>> ---
>>   include/linux/bpf.h                           |   8 +
>>   include/uapi/linux/bpf.h                      |  21 ++
>>   kernel/bpf/Makefile                           |   3 +
>>   kernel/bpf/cgroup_iter.c                      | 242 ++++++++++++++++++
>>   tools/include/uapi/linux/bpf.h                |  21 ++
>>   .../selftests/bpf/prog_tests/btf_dump.c       |   4 +-
>>   6 files changed, 297 insertions(+), 2 deletions(-)
>>   create mode 100644 kernel/bpf/cgroup_iter.c
>>
>> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
>> index 2b21f2a3452ff..5de9de06e2551 100644
>> --- a/include/linux/bpf.h
>> +++ b/include/linux/bpf.h
>> @@ -47,6 +47,7 @@ struct kobject;
>>   struct mem_cgroup;
>>   struct module;
>>   struct bpf_func_state;
>> +struct cgroup;
>>   extern struct idr btf_idr;
>>   extern spinlock_t btf_idr_lock;
>> @@ -1714,7 +1715,14 @@ int bpf_obj_get_user(const char __user 
>> *pathname, int flags);
>>       int __init bpf_iter_ ## target(args) { return 0; }
>>   struct bpf_iter_aux_info {
>> +    /* for map_elem iter */
>>       struct bpf_map *map;
>> +
>> +    /* for cgroup iter */
>> +    struct {
>> +        struct cgroup *start; /* starting cgroup */
>> +        int order;
>> +    } cgroup;
>>   };
>>   typedef int (*bpf_iter_attach_target_t)(struct bpf_prog *prog,
>> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
>> index 379e68fb866fc..6f5979e221927 100644
>> --- a/include/uapi/linux/bpf.h
>> +++ b/include/uapi/linux/bpf.h
>> @@ -87,10 +87,27 @@ struct bpf_cgroup_storage_key {
>>       __u32    attach_type;        /* program attach type (enum 
>> bpf_attach_type) */
>>   };
>> +enum bpf_iter_cgroup_traversal_order {
>> +    BPF_ITER_CGROUP_PRE = 0,    /* pre-order traversal */
>> +    BPF_ITER_CGROUP_POST,        /* post-order traversal */
>> +    BPF_ITER_CGROUP_PARENT_UP,    /* traversal of ancestors up to the 
>> root */
>> +};
>> +
>>   union bpf_iter_link_info {
>>       struct {
>>           __u32    map_fd;
>>       } map;
>> +
>> +    /* cgroup_iter walks either the live descendants of a cgroup 
>> subtree, or the ancestors
>> +     * of a given cgroup.
>> +     */
>> +    struct {
>> +        /* Cgroup file descriptor. This is root of the subtree if for 
>> walking the
>> +         * descendants; this is the starting cgroup if for walking 
>> the ancestors.
> 
> Adding comment that cgroup_fd 0 means starting from root cgroup?
> Also, if I understand correctly, cgroup v1 is also supported here, 
> right? If this is the case, for cgroup v1 which root cgroup will be
> used for cgroup_fd? It would be good to clarify here too.
> 
>> +         */
>> +        __u32    cgroup_fd;
>> +        __u32    traversal_order;
>> +    } cgroup;
>>   };
>>   /* BPF syscall commands, see bpf(2) man-page for more details. */
>> @@ -6134,6 +6151,10 @@ struct bpf_link_info {
>>                   struct {
>>                       __u32 map_id;
>>                   } map;
>> +                struct {
>> +                    __u32 traversal_order;
>> +                    __aligned_u64 cgroup_id;
>> +                } cgroup;
> 
> We actually has a problem here although I don't have a solution yet.
> 
> Without this patch, for bpf_link_info structure, the output of pahole,
> 
>                  struct {
> 
>                          __u64              target_name 
> __attribute__((__aligned__(8))); /*     0     8 */
>                          __u32              target_name_len;      /* 
>   8     4 */
>                          union {
> 
>                                  struct {
> 
>                                          __u32 map_id;            /* 
> 12     4 */
>                                  } map;                           /* 
> 12     4 */
>                          };                                       /* 
> 12     4 */
>                          union {
>                                  struct {
>                                          __u32      map_id;   /*     
> 0     4 */
>                                  } map;   /*     0     4 */
>                          };
> 
>                  } iter;
> 
> You can see map_id has the offset 12 from the beginning of 'iter' 
> structure.
> 
> With this patch,
> 
>                  struct {
>                          __u64              target_name 
> __attribute__((__aligned__(8))); /*     0     8 */
>                          __u32              target_name_len;      /* 
>   8     4 */
> 
>                          /* XXX 4 bytes hole, try to pack */
> 
>                          union {
>                                  struct {
>                                          __u32 map_id;            /* 
> 16     4 */
>                                  } map;                           /* 
> 16     4 */
>                                  struct {
>                                          __u32 traversal_order;   /* 
> 16     4 */
> 
>                                          /* XXX 4 bytes hole, try to 
> pack */
> 
>                                          __u64 cgroup_id;         /* 
> 24     8 */
>                                  } cgroup;                        /* 
> 16    16 */
>                          };                                       /* 
> 16    16 */
>                          union {
>                                  struct {
>                                          __u32      map_id;   /*     
> 0     4 */
>                                  } map;   /*     0     4 */
>                                  struct {
>                                          __u32      traversal_order;   
> /*     0     4 */
> 
>                                          /* XXX 4 bytes hole, try to 
> pack */
> 
>                                          __u64      cgroup_id;   /*     
> 8     8 */
>                                  } cgroup;   /*     0    16 */
>                          };
> 
>                  } iter;
> 
> There is a 4 byte hole after member 'target_name_len'. So map_id will
> have a offset 16 from the start of structure 'iter'.
> 
> 
> This will break uapi. We probably won't be able to change the existing
> uapi with adding a ':32' after member 'target_name_len'. I don't have
> a good solution yet, but any suggestion is welcome.
> 
> Also, for '__aligned_u64 cgroup_id', '__u64 cgroup_id' is enough.
> '__aligned_u64' mostly used for pointers.

Briefly discussed with Alexei, the following structure iter definition
should work. Later on, if we need to addition fields for other iter's,
for a single __u32, the field can be added to either the first or the
second union. If fields are more than __u32, they can be placed
in the second union.

                 struct {
                         __aligned_u64 target_name; /* in/out: 
target_name buffer ptr */
                         __u32 target_name_len;     /* in/out: 
target_name buffer len */
                         union {
                                 struct {
                                         __u32 map_id;
                                 } map;
                         };
                         union {
                                 struct {
                                         __u64 cgroup_id;
                                         __u32 traversal_order;
                                 } cgroup;
                         };
                 } iter;


> 
> 
>>               };
>>           } iter;
>>           struct  {
>> diff --git a/kernel/bpf/Makefile b/kernel/bpf/Makefile
>> index 057ba8e01e70f..00e05b69a4df1 100644
>> --- a/kernel/bpf/Makefile
>> +++ b/kernel/bpf/Makefile
>> @@ -24,6 +24,9 @@ endif
>>   ifeq ($(CONFIG_PERF_EVENTS),y)
>>   obj-$(CONFIG_BPF_SYSCALL) += stackmap.o
>>   endif
>> +ifeq ($(CONFIG_CGROUPS),y)
>> +obj-$(CONFIG_BPF_SYSCALL) += cgroup_iter.o
>> +endif
>>   obj-$(CONFIG_CGROUP_BPF) += cgroup.o
>>   ifeq ($(CONFIG_INET),y)
>>   obj-$(CONFIG_BPF_SYSCALL) += reuseport_array.o
>> diff --git a/kernel/bpf/cgroup_iter.c b/kernel/bpf/cgroup_iter.c
>> new file mode 100644
>> index 0000000000000..8f50b326016e6
>> --- /dev/null
>> +++ b/kernel/bpf/cgroup_iter.c
>> @@ -0,0 +1,242 @@
>> +// SPDX-License-Identifier: GPL-2.0-only
>> +/* Copyright (c) 2022 Google */
>> +#include <linux/bpf.h>
>> +#include <linux/btf_ids.h>
>> +#include <linux/cgroup.h>
>> +#include <linux/kernel.h>
>> +#include <linux/seq_file.h>
>> +
>> +#include "../cgroup/cgroup-internal.h"  /* cgroup_mutex and 
>> cgroup_is_dead */
>> +
>> +/* cgroup_iter provides three modes of traversal to the cgroup 
>> hierarchy.
>> + *
>> + *  1. Walk the descendants of a cgroup in pre-order.
>> + *  2. Walk the descendants of a cgroup in post-order.
>> + *  2. Walk the ancestors of a cgroup.
>> + *
>> + * For walking descendants, cgroup_iter can walk in either pre-order or
>> + * post-order. For walking ancestors, the iter walks up from a cgroup to
>> + * the root.
>> + *
>> + * The iter program can terminate the walk early by returning 1. Walk
>> + * continues if prog returns 0.
>> + *
>> + * The prog can check (seq->num == 0) to determine whether this is
>> + * the first element. The prog may also be passed a NULL cgroup,
>> + * which means the walk has completed and the prog has a chance to
>> + * do post-processing, such as outputing an epilogue.
>> + *
>> + * Note: the iter_prog is called with cgroup_mutex held.
>> + */
>> +
>> +struct bpf_iter__cgroup {
>> +    __bpf_md_ptr(struct bpf_iter_meta *, meta);
>> +    __bpf_md_ptr(struct cgroup *, cgroup);
>> +};
>> +
>> +struct cgroup_iter_priv {
>> +    struct cgroup_subsys_state *start_css;
>> +    bool terminate;
>> +    int order;
>> +};
>> +
>> +static void *cgroup_iter_seq_start(struct seq_file *seq, loff_t *pos)
>> +{
>> +    struct cgroup_iter_priv *p = seq->private;
>> +
>> +    mutex_lock(&cgroup_mutex);
>> +
>> +    /* support only one session */
>> +    if (*pos > 0)
>> +        return NULL;
> 
> This might be okay. But want to check what is
> the practical upper limit for cgroups in a system
> and whether we may miss some cgroups. If this
> happens, it will be a surprise to the user.
> 
>> +
>> +    ++*pos;
>> +    p->terminate = false;
>> +    if (p->order == BPF_ITER_CGROUP_PRE)
>> +        return css_next_descendant_pre(NULL, p->start_css);
>> +    else if (p->order == BPF_ITER_CGROUP_POST)
>> +        return css_next_descendant_post(NULL, p->start_css);
>> +    else /* BPF_ITER_CGROUP_PARENT_UP */
>> +        return p->start_css;
>> +}
>> +
>> +static int __cgroup_iter_seq_show(struct seq_file *seq,
>> +                  struct cgroup_subsys_state *css, int in_stop);
>> +
>> +static void cgroup_iter_seq_stop(struct seq_file *seq, void *v)
>> +{
>> +    /* pass NULL to the prog for post-processing */
>> +    if (!v)
>> +        __cgroup_iter_seq_show(seq, NULL, true);
>> +    mutex_unlock(&cgroup_mutex);
>> +}
>> +
> [...]
