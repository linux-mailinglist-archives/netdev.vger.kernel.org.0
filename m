Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5E333D6997
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 00:36:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233736AbhGZVzo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 17:55:44 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:14892 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233660AbhGZVzn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Jul 2021 17:55:43 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16QLXex7017013;
        Mon, 26 Jul 2021 15:35:56 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=QbiMam6JEbQGuol5tAR2RjMn88/3vZYDDTfilZ8gTNY=;
 b=SKnRGnjxC6SrPDyxaOIvGGYOYc85xpIqu7U28legez/xlRk0vB0JgUgTEfCcSmccMxeZ
 ALDoLu6jqU3hahdeCBSqwY6HXHy4PQqKEiRP1zinjiNIJX6D+/3cC7onxOHXDlcmEnfY
 FTS18G/QhEFC1vxn+qdOdVHUPk3NTHNwB5g= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3a2350s2nk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 26 Jul 2021 15:35:55 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.197) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 26 Jul 2021 15:35:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kgyNeALKj//KXu/FStdr7CNpArUov3oIZrLzhuqCFL0knyA2uwwInnbYRiOeiRqrqcrxQCYA2O/3iHK5eF+0OF6DeH9Z4gf5YGkx1yfX3Xi2g4bYl5SyQMwnHixJloExqwxqz/4B+7liJ7Jd7U1TE94bL+y3Sok1PjuGukeWt8J1LZoI5n69+e0C7/Q6TQtgGYrBE5X73uzCBck4vejtrCi02de8EB0TjE6wR85ZnKd5lZuaXBZWIoobx1SYG7lUYpvXO9VOIxeH8imyEY3fEqwiQFgb9QW91AD6KxE9VlJistSPasPwy60yRecT/mewpnXTFnxQUgINXJdVnIc71A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QbiMam6JEbQGuol5tAR2RjMn88/3vZYDDTfilZ8gTNY=;
 b=duM67EkNKaKjzSSeXgt5lOjCabOZmci+JHle8l/ZWsLsituSCo2V5hUjMOe7dLzDo0L5XKvmBqNlGPChQ8YRPgNnmaAFVQz43FjEA7fdGPiylZvia46uYqHkLD1wTugZX3SWFE/0ASTSEBkODzdwVaP8iPkh684KAhvrrdRuteoIumrxrW3nSsH9X2u8hFPUcWsE8tnPVAWTznpHiKCNsoiNaQXq7ozYB5zbJ87fG3s8HeBoZwpie+5pt8H0GG6TPwcwG2qgJquyqG9la+YkuURYfBmq/sxiTgBqAi1ogaFera+rnsi4O7CbfUULj+MnYufHMpnGTdeUnU6uoQIUfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SN6PR15MB2367.namprd15.prod.outlook.com (2603:10b6:805:1a::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.25; Mon, 26 Jul
 2021 22:35:53 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::c143:fac2:85b4:14cb]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::c143:fac2:85b4:14cb%7]) with mapi id 15.20.4352.031; Mon, 26 Jul 2021
 22:35:53 +0000
Subject: Re: [PATCH bpf-next v2] bpf: increase supported cgroup storage value
 size
To:     <sdf@google.com>
CC:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>, <ast@kernel.org>,
        <daniel@iogearbox.net>, <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>
References: <20210723235429.339744-1-sdf@google.com>
 <c9e87cd8-ced7-a411-62a1-ecd980b82dc5@fb.com> <YP7XHHm/09YsBXkx@google.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <ea6acda9-417f-af4e-22df-7fcb0f50598b@fb.com>
Date:   Mon, 26 Jul 2021 15:35:50 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
In-Reply-To: <YP7XHHm/09YsBXkx@google.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MWHPR12CA0046.namprd12.prod.outlook.com
 (2603:10b6:301:2::32) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21c8::1398] (2620:10d:c090:400::5:835) by MWHPR12CA0046.namprd12.prod.outlook.com (2603:10b6:301:2::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.24 via Frontend Transport; Mon, 26 Jul 2021 22:35:52 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ba544c1a-a24d-4494-710e-08d95085ba05
X-MS-TrafficTypeDiagnostic: SN6PR15MB2367:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR15MB2367D79296D24FC43BC37E26D3E89@SN6PR15MB2367.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dqukeka9c+y+eAEk1iDeC3P2YndpoSZZwxevccM5CYFY8ABbzlQVOIUoLpi6ptP7nMy61wThyBcZ5XRUM5YOD6Na4v0QDCuxvdb6jVBpmxrf5qr0KEcpWEmwzK0WqPeJ3cZ4aFf1DYAGlQ2t9FFsD3W2NY0+ODJVr8XHTRZZZRHRdwjgBC5bzHKf0B8lT+VDpQyODXlHeHErrsc51x17H1tHB6BSU/lJ708oBOfP8Q2XJcsNF7MrUET+Qu021SYcpOpPzjDf1t9akHzyR1/WSaEoDMt1U4q4zxCfSDJZe0ofz6xWF283eQpLVMnXHluZCc31I8xpYFbEFn+JkreQYh3JbGRCl48VJkeqsU8CmjOyP1FpZrdlEZ3iw6BQ3/ydJo9d2bwrHR2VlQbRtwvDGfk7/IethvOEiCtu0JkeY6F8RnUrWHlGtSQFTll+bPBHJvAnWMaPhyQoCeQ7FPAmSRSpmc19PSJEn6R5XHewAPlOyMnE8LRQIxBgDEvqISNkhMeXpX5eaqKlfIFPDIEY9l/fvQqGxFu9ZqO0u809Hs3n8s0MjKKBrMlMAAAeiGzjepDLfKShfB36m4xULonRbdFsp2M29xBNCFb+bFfHiQmIMLw8GhDr2YBChuoVwWtLO/WvahYXYHYl746E/m/TTXp4D7gXBqNpGIs/6CyUfFA3we850iVI6uGAMVdjHWE3RU2CKQbxMb+UGUw47PsIsRgIM2VRlPT3wRfbTbZC4BS6+S20eEFJWWeL6a1rVZSfPqim6Rj6jqKpoq5dnA03CQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(346002)(376002)(396003)(136003)(366004)(83380400001)(66946007)(6916009)(2906002)(8936002)(8676002)(38100700002)(31686004)(186003)(4326008)(66556008)(66476007)(6486002)(53546011)(36756003)(316002)(2616005)(31696002)(478600001)(86362001)(52116002)(5660300002)(45980500001)(43740500002)(309714004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OGpGUEVDQXA5UXp5M1kydURVNWRTazVWakpmWjVrWW1mUXd5cGhReTN1N05W?=
 =?utf-8?B?c20zczMwWWJUeXlHMEliQi9nS2pucCtZdTBzaTJpWmRhbFozN0VQM1dEcTBC?=
 =?utf-8?B?VE5UYncrU1NjK2JwKy9FeDBCYzVLUDF4ZjNqSWFjdmFtN2RMcmltWlp3RXRi?=
 =?utf-8?B?aXZHQTYyd1FScktaaGpEWWVtMEV3aU1EU3ZzNy9SQkxHRFFlTmxDQmFoRCt0?=
 =?utf-8?B?bmdXb05vR09NbmZRTmFESDhiV2h1c1NBMisrVStiSWZGNzFaWTFvQll2MXhD?=
 =?utf-8?B?V25RSXNybGU0aHR2OHhkbU13ZERzejllRGlwRThnaWRQZHJHdmEvWUR1MFFw?=
 =?utf-8?B?VVA2VnlzejRFcnpURm9DcisrYWlyckRuTFF3bnFKUk1LRWIyY04yQjlFRm9W?=
 =?utf-8?B?NUZlb0xKOFNacVZMRFhBa1ZOa2E2NTAwSnRMUi9vQVBVQXgvSE1VMnQ3anNL?=
 =?utf-8?B?ZDFBSTNMZjBmUmNaQXJTb2ZwUml2cTRsUVBTU01rVCtIZlZVUHJiYVoxUVl6?=
 =?utf-8?B?ODl2Q0NCNDRPNlNoS0lCUnhORXcwOUh2Y3hqdnJHclBiZ1FpTVNwOG1HRzE2?=
 =?utf-8?B?ZlQ2SU1hNG5VZk1ZUkk1TWNubFBxZzRaZU9TTVFFUUxNbUM1b0w1dFkwVnJE?=
 =?utf-8?B?Q05BUjJRL202RWxGOFh4SEFMSFZuUzYzTWFRaVhNbWYyKzEybVV6cHU3aHlp?=
 =?utf-8?B?ZkhtQ04yT1FhV1prT1dJbDU3SVF6NHN2VGx1MUYzMkZnRVhrRHJzTERUOERE?=
 =?utf-8?B?aktFSi9Qd2ZPa3Y4cjJVYjIvMDEvYnAyZGd6ZzFyTVlQWlN0OWhTV1RvVVVy?=
 =?utf-8?B?UU1SbEdLZDZKNjMrQWhHK0FjLzJzd1d4cGtmeEJ3YXRSaC9wV0g5cGM2Mm5u?=
 =?utf-8?B?eDg3SnIxbEdvM29qMkRWRkFxczJ3NjB4UmxIVjZUcXRVR1gvZEduU0dxN0FT?=
 =?utf-8?B?T3dBM0luY1JQMUdodHl1ODQwZEZPZ3hKM0Jid3EySjY1cVdHalAxanBianlP?=
 =?utf-8?B?cy9oeElKN252c1M4RXlWeEsvUEVDck1pc2pqV2UxMVB4MkpYOVNSMVQrR3lX?=
 =?utf-8?B?L3paUmJudTdxd1BweVd1bmFNZlJFNUhDc2svQmw1OWxlM0xvcVpZRjFPNkNz?=
 =?utf-8?B?TFl2TXZMMFQ4djJobDg0d0kvbVUwN0V6NlB1cklkUmdJWHdjMlgxRmNmdko5?=
 =?utf-8?B?YVloVGR6MVpsSVJldUhFTTVZQ2FEcU1oZHp6ZzdHMlhBOXd5VC9mWDc1Rnds?=
 =?utf-8?B?L2VGd3ovTUlib3lUSDQ0VjZVWkJ3cGwxRk5hVFZEUThNdVd3M0ozbVJJb1ZF?=
 =?utf-8?B?MGhJWFFwaHc1bFd4WFIyRUZTbXEvSXJJVHRTd0VoMi9Kam9tWXZuUXhaNHRS?=
 =?utf-8?B?SHB4WFVlT3hYRnhzUDFOa1VVeVJ6TFJkSjJxY2dVQU9HQXNTTm9Bd1F6R1p3?=
 =?utf-8?B?ay93amdMbndaTHRqdC84V2xlQWZOYitHMENPRkFXbkZ1aitUOHV2bWJBNTdC?=
 =?utf-8?B?Q0QvMXJlTndXdUI3eUE3aDAxbFF4ZS9aekdKUDVBdFk5YVJsN3hCTm9MZWdZ?=
 =?utf-8?B?STVzc05yQjlSb3pJUkp5dDV1KzRjVlMzV2x3RWVwdHJ6WTg0WmVqQXFYU1dz?=
 =?utf-8?B?SElUN3ZyUHkzNExMVllzSmdpN1MwZU9rVDMxY2x2Sm5TY202RmJmVGVNT2ww?=
 =?utf-8?B?WCtJQ0FSWUdsY3lzUUVqVnlGZ0ZJUnhJNTdibDNIU1RHbldkNUNCdk1jZjhq?=
 =?utf-8?B?bVBQZG95S084S2NiT20ySnlKdC9KZWIwaTlBVFZYcUN5d2dnZ25GbHdFNjdW?=
 =?utf-8?B?RlZMdmhGWGFYNWhJUXl0dz09?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ba544c1a-a24d-4494-710e-08d95085ba05
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jul 2021 22:35:53.3306
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: l8JaXd9qLJNqneEG9LmWzYLxo6/T8z/pFusp/1trNETEf3ZI/k4HgCoG+MPCoTN8
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR15MB2367
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: HtV2rnMVwN4WjnTKYIQ_6HOvhZynbTf5
X-Proofpoint-GUID: HtV2rnMVwN4WjnTKYIQ_6HOvhZynbTf5
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-26_14:2021-07-26,2021-07-26 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015
 priorityscore=1501 lowpriorityscore=0 malwarescore=0 bulkscore=0
 mlxscore=0 adultscore=0 spamscore=0 suspectscore=0 mlxlogscore=999
 impostorscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2107140000 definitions=main-2107260127
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/26/21 8:39 AM, sdf@google.com wrote:
> On 07/25, Yonghong Song wrote:
> 
> 
>> On 7/23/21 4:54 PM, Stanislav Fomichev wrote:
>> > Current max cgroup storage value size is 4k (PAGE_SIZE). The other 
>> local
>> > storages accept up to 64k (BPF_LOCAL_STORAGE_MAX_VALUE_SIZE). Let's 
>> align
>> > max cgroup value size with the other storages.
>> >
>> > For percpu, the max is 32k (PCPU_MIN_UNIT_SIZE) because percpu
>> > allocator is not happy about larger values.
>> >
>> > netcnt test is extended to exercise those maximum values
>> > (non-percpu max size is close to, but not real max).
>> >
>> > v2:
>> > * cap max_value_size instead of BUILD_BUG_ON (Martin KaFai Lau)
>> >
>> > Cc: Martin KaFai Lau <kafai@fb.com>
>> > Signed-off-by: Stanislav Fomichev <sdf@google.com>
>> > ---
>> >   kernel/bpf/local_storage.c                    | 11 +++++-
>> >   tools/testing/selftests/bpf/netcnt_common.h   | 38 
>> +++++++++++++++----
>> >   .../testing/selftests/bpf/progs/netcnt_prog.c | 29 +++++++-------
>> >   tools/testing/selftests/bpf/test_netcnt.c     | 25 +++++++-----
>> >   4 files changed, 72 insertions(+), 31 deletions(-)
>> >
>> > diff --git a/kernel/bpf/local_storage.c b/kernel/bpf/local_storage.c
>> > index 7ed2a14dc0de..035e9e3a7132 100644
>> > --- a/kernel/bpf/local_storage.c
>> > +++ b/kernel/bpf/local_storage.c
>> > @@ -1,6 +1,7 @@
>> >   //SPDX-License-Identifier: GPL-2.0
>> >   #include <linux/bpf-cgroup.h>
>> >   #include <linux/bpf.h>
>> > +#include <linux/bpf_local_storage.h>
>> >   #include <linux/btf.h>
>> >   #include <linux/bug.h>
>> >   #include <linux/filter.h>
>> > @@ -283,9 +284,17 @@ static int cgroup_storage_get_next_key(struct 
>> bpf_map *_map, void *key,
>> >   static struct bpf_map *cgroup_storage_map_alloc(union bpf_attr *attr)
>> >   {
>> > +    __u32 max_value_size = BPF_LOCAL_STORAGE_MAX_VALUE_SIZE;
>> >       int numa_node = bpf_map_attr_numa_node(attr);
>> >       struct bpf_cgroup_storage_map *map;
>> > +    /* percpu is bound by PCPU_MIN_UNIT_SIZE, non-percu
>> > +     * is the same as other local storages.
>> > +     */
>> > +    if (attr->map_type == BPF_MAP_TYPE_PERCPU_CGROUP_STORAGE)
>> > +        max_value_size = min_t(__u32, max_value_size,
>> > +                       PCPU_MIN_UNIT_SIZE);
>> > +
>> >       if (attr->key_size != sizeof(struct bpf_cgroup_storage_key) &&
>> >           attr->key_size != sizeof(__u64))
>> >           return ERR_PTR(-EINVAL);
>> > @@ -293,7 +302,7 @@ static struct bpf_map 
>> *cgroup_storage_map_alloc(union bpf_attr *attr)
>> >       if (attr->value_size == 0)
>> >           return ERR_PTR(-EINVAL);
>> > -    if (attr->value_size > PAGE_SIZE)
>> > +    if (attr->value_size > max_value_size)
>> >           return ERR_PTR(-E2BIG);
>> >       if (attr->map_flags & ~LOCAL_STORAGE_CREATE_FLAG_MASK ||
>> > diff --git a/tools/testing/selftests/bpf/netcnt_common.h 
>> b/tools/testing/selftests/bpf/netcnt_common.h
>> > index 81084c1c2c23..dfcf184ff713 100644
>> > --- a/tools/testing/selftests/bpf/netcnt_common.h
>> > +++ b/tools/testing/selftests/bpf/netcnt_common.h
>> > @@ -6,19 +6,43 @@
>> >   #define MAX_PERCPU_PACKETS 32
>> > +/* sizeof(struct bpf_local_storage_elem):
>> > + *
>> > + * It really is about 128 bytes, but allocate more to account for 
>> possible
> 
>> Maybe more specific to be 128 bytes on x86_64? As suggested below, 32bit
>> architecture may have smaller size.
> 
>> Looks like that the size of struct bpf_local_storage_elem won't change
>> anytime soon, so it is probably okay to mention 128 bytes here.
> SG, I'll clarify that it's x86_64 only. Or do you want me to use 128
> as SIZEOF_BPF_LOCAL_STORAGE_ELEM ?

Just clarify it is x86_64 only.

> 
>> > + * layout changes, different architectures, etc.
>> > + * It will wrap up to PAGE_SIZE internally anyway.
> 
>> What will be wrap up to PAGE_SIZE? More explanations?
> 
> I'll reword to the following:
> 
> It really is about 128 bytes on x86_64, but allocate more to account for
> possible layout changes, different architectures, etc.
> The kernel will wrap up to PAGE_SIZE internally anyway.

This is better.

> 
> (clarify that the kernel will wrap it up internally)
> 
>> > + */
>> > +#define SIZEOF_BPF_LOCAL_STORAGE_ELEM        256
>> > +
>> > +/* Try to estimate kernel's BPF_LOCAL_STORAGE_MAX_VALUE_SIZE: */
>> > +#define BPF_LOCAL_STORAGE_MAX_VALUE_SIZE    (0xFFFF - \
>> > +                         SIZEOF_BPF_LOCAL_STORAGE_ELEM)
>> > +
>> > +#define PCPU_MIN_UNIT_SIZE            32768
>> > +
>> >   struct percpu_net_cnt {
>> > -    __u64 packets;
>> > -    __u64 bytes;
>> > +    union {
>> > +        struct {
>> > +            __u64 packets;
>> > +            __u64 bytes;
>> > -    __u64 prev_ts;
>> > +            __u64 prev_ts;
>> > -    __u64 prev_packets;
>> > -    __u64 prev_bytes;
>> > +            __u64 prev_packets;
>> > +            __u64 prev_bytes;
>> > +        } val;
> 
>> You don't need 'val' here. This way the code churn can be reduced.
> Good idea, dropping for both.
> 
>> > +        __u8 data[PCPU_MIN_UNIT_SIZE];
>> > +    };
>> >   };
>> >   struct net_cnt {
>> > -    __u64 packets;
>> > -    __u64 bytes;
>> > +    union {
>> > +        struct {
>> > +            __u64 packets;
>> > +            __u64 bytes;
>> > +        } val;
> 
>> The same here. 'val' is not needed.
> 
>> > +        __u8 data[BPF_LOCAL_STORAGE_MAX_VALUE_SIZE];
>> > +    };
>> >   };
>> >   #endif
>> > diff --git a/tools/testing/selftests/bpf/progs/netcnt_prog.c 
>> b/tools/testing/selftests/bpf/progs/netcnt_prog.c
>> > index d071adf178bd..4b0884239892 100644
>> > --- a/tools/testing/selftests/bpf/progs/netcnt_prog.c
>> > +++ b/tools/testing/selftests/bpf/progs/netcnt_prog.c
>> > @@ -34,34 +34,35 @@ int bpf_nextcnt(struct __sk_buff *skb)
>> >       cnt = bpf_get_local_storage(&netcnt, 0);
>> >       percpu_cnt = bpf_get_local_storage(&percpu_netcnt, 0);
>> > -    percpu_cnt->packets++;
>> > -    percpu_cnt->bytes += skb->len;
>> > +    percpu_cnt->val.packets++;
>> > +    percpu_cnt->val.bytes += skb->len;
>> > -    if (percpu_cnt->packets > MAX_PERCPU_PACKETS) {
>> > -        __sync_fetch_and_add(&cnt->packets,
>> > -                     percpu_cnt->packets);
>> > -        percpu_cnt->packets = 0;
>> > +    if (percpu_cnt->val.packets > MAX_PERCPU_PACKETS) {
>> > +        __sync_fetch_and_add(&cnt->val.packets,
>> > +                     percpu_cnt->val.packets);
>> > +        percpu_cnt->val.packets = 0;
>> > -        __sync_fetch_and_add(&cnt->bytes,
>> > -                     percpu_cnt->bytes);
>> > -        percpu_cnt->bytes = 0;
>> > +        __sync_fetch_and_add(&cnt->val.bytes,
>> > +                     percpu_cnt->val.bytes);
>> > +        percpu_cnt->val.bytes = 0;
>> >       }
>> >       ts = bpf_ktime_get_ns();
>> > -    dt = ts - percpu_cnt->prev_ts;
>> > +    dt = ts - percpu_cnt->val.prev_ts;
>> >       dt *= MAX_BPS;
>> >       dt /= NS_PER_SEC;
>> > -    if (cnt->bytes + percpu_cnt->bytes - percpu_cnt->prev_bytes < dt)
>> > +    if (cnt->val.bytes + percpu_cnt->val.bytes -
>> > +        percpu_cnt->val.prev_bytes < dt)
>> >           ret = 1;
>> >       else
>> >           ret = 0;
>> >       if (dt > REFRESH_TIME_NS) {
>> > -        percpu_cnt->prev_ts = ts;
>> > -        percpu_cnt->prev_packets = cnt->packets;
>> > -        percpu_cnt->prev_bytes = cnt->bytes;
>> > +        percpu_cnt->val.prev_ts = ts;
>> > +        percpu_cnt->val.prev_packets = cnt->val.packets;
>> > +        percpu_cnt->val.prev_bytes = cnt->val.bytes;
>> >       }
>> >       return !!ret;
>> > diff --git a/tools/testing/selftests/bpf/test_netcnt.c 
>> b/tools/testing/selftests/bpf/test_netcnt.c
>> > index a7b9a69f4fd5..1138765406a5 100644
>> > --- a/tools/testing/selftests/bpf/test_netcnt.c
>> > +++ b/tools/testing/selftests/bpf/test_netcnt.c
>> > @@ -33,11 +33,11 @@ static int bpf_find_map(const char *test, struct 
>> bpf_object *obj,
>> >   int main(int argc, char **argv)
>> >   {
>> > -    struct percpu_net_cnt *percpu_netcnt;
>> > +    struct percpu_net_cnt *percpu_netcnt = NULL;
> 
>> Assigning NULL is not needed, right?
> Yeah, it's not needed, but I'd prefer to have it for consistency
> (so both free() work regardless of the ordering and future changes).
> Let me know if you strongly disagree, I can drop it.

That is fine. The compiler will probably remove the initialization.

> 
>> >       struct bpf_cgroup_storage_key key;
>> > +    struct net_cnt *netcnt = NULL;
>> >       int map_fd, percpu_map_fd;
>> >       int error = EXIT_FAILURE;
>> > -    struct net_cnt netcnt;
>> >       struct bpf_object *obj;
>> >       int prog_fd, cgroup_fd;
>> >       unsigned long packets;
>> > @@ -52,6 +52,12 @@ int main(int argc, char **argv)
[...]
