Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1872E1BE838
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 22:15:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726781AbgD2UPW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 16:15:22 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:34704 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726456AbgD2UPW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 16:15:22 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03TK85Ck016384;
        Wed, 29 Apr 2020 13:15:08 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=syhwfwJYVbAWmMZK5APslEfPNSEUmL3jC8HPSbaScD8=;
 b=WdxxEZoKCT8oCEVT75qP/Y5Hq4bekTBGvZiK4zhupslQuQhOkhOxWy35i61eghSCDjAb
 92hQlEMDyVoqDRUDuQ+NEf9jWGsMqJScNvOuAA0xbiLZqgHvcL9zMQH2x7855+9WKigm
 CFgprJXKO0R/n7nbCGuonlKreuPQxfbB9uw= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 30qd20hcce-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 29 Apr 2020 13:15:08 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.196) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Wed, 29 Apr 2020 13:15:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J3XesL3w91v8tnhFxY84aJh5j5Zb185JPtC7UxSxykX5QhZsBvAE+9StVB2JuK6uUnjSZpoUZK4dtL0XbQbjPbMUvZrrbtAJ3kDB/9fP3d4RkwuYfxajgsBTrHOf5HbKDLWns5iw6siYM4WyFzgzO7/qxwdKJs63KTu6Pqy2UHCRjkAjczhjEtLkJHHQu074UwlXqTqsUd8AqVESJwALYGJBLM+lFPnihWio/bokyI+87rxmeIeXvm6aBA/ttzyewM5t2wRdRCxev1n77r7pjpuLPH6udvyFF9wiBCCoH+CIuzqHpRuoGd5KY9P8zlSLFkS8TV6Tlt6dg4FZMeXAQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=syhwfwJYVbAWmMZK5APslEfPNSEUmL3jC8HPSbaScD8=;
 b=SOhLOFIoLvNMtX73PnuCI0WgUuSjJdsxv8ScvK+miowmLDG3ZR10GimgBhN4VmHE3npQeLNTTFS8wjao5cLe8iF/rUpJv7eUNo6u+H4MxqDcf3aKgsL0RHjCLsQGfR/ZECL96uolmNhOiavUb7C0TgRpjskZd0BwZu9cwHDSu1Kw5GpTz4RLnvUW2nBKNnEIq9rpVV3yf+okbVDLrmXJcLZUmFtFv63uZmAX8FDLd3yQSx2+wmZ6Xm+PaUqtH0yVOGjcsUyGPUQW82+bCFz22DIjytuChxwlc2D+SyC+H/6fIRuoODX+bEbXhhBvGILtQFN+PrzCuENC+gy8Qse55A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=syhwfwJYVbAWmMZK5APslEfPNSEUmL3jC8HPSbaScD8=;
 b=NeZon/xKQJfAG2kjycV7rQBUaXbm9vcHFGOS6iwWAmLWhgSCmYTAo4CnFzt0xzIIjJnXfejCmzH39ZIkW6caKot4CEkghwaoccdguPXgLxlnUZbYw9Qu9eIKzvhVw926vX49yu+K/qc0Cz6Skklf2AZQPxWcwhOeJ192KreH7l0=
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB4104.namprd15.prod.outlook.com (2603:10b6:a02:c8::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13; Wed, 29 Apr
 2020 20:15:05 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::8988:aa27:5d70:6923]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::8988:aa27:5d70:6923%5]) with mapi id 15.20.2937.028; Wed, 29 Apr 2020
 20:15:05 +0000
Subject: Re: [PATCH bpf-next v1 03/19] bpf: add bpf_map iterator
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <ast@fb.com>
CC:     Martin KaFai Lau <kafai@fb.com>, Andrii Nakryiko <andriin@fb.com>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
References: <20200427201235.2994549-1-yhs@fb.com>
 <20200427201237.2994794-1-yhs@fb.com>
 <20200429003738.pv4flhdaxpg66wiv@kafai-mbp>
 <3df31c9a-2df7-d76a-5e54-b2cd48692883@fb.com>
 <a5255338-94e8-3f4b-518e-e7f7146f69f2@fb.com>
 <65a83b48-3965-5ae9-fafd-3e8836b03d2c@fb.com>
 <7f15274d-46dd-f43f-575e-26a40032f900@fb.com>
 <CAEf4BzaCVZem4O9eR9gBTO5c+PHy5zE8BdLD2Aa-PCLHC4ywRg@mail.gmail.com>
 <401b5bd2-dc43-4465-1232-34428a1b3e4e@fb.com>
 <f9a3590f-1fd3-2151-5b52-4e7ddc0da934@fb.com>
 <CAEf4BzY1eycQ81h+nFKUhwAjCERAmAZhKXyHDAF2Sm4Gsb9UMw@mail.gmail.com>
 <b070519a-0956-01bb-35d9-3ced12e0cd11@fb.com>
 <2be3cd4a-cf55-2eeb-c33b-a25135defceb@fb.com>
 <CAEf4BzZgZ7h_asHNGk_34vJv_yvLtWGcTGwdTO4fgLPySaG-Eg@mail.gmail.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <cc802671-76e6-e911-0e4e-53a4e99c69ff@fb.com>
Date:   Wed, 29 Apr 2020 13:15:02 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
In-Reply-To: <CAEf4BzZgZ7h_asHNGk_34vJv_yvLtWGcTGwdTO4fgLPySaG-Eg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MWHPR03CA0012.namprd03.prod.outlook.com
 (2603:10b6:300:117::22) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from macbook-pro-52.local.dhcp.thefacebook.com (2620:10d:c090:400::5:99f7) by MWHPR03CA0012.namprd03.prod.outlook.com (2603:10b6:300:117::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.19 via Frontend Transport; Wed, 29 Apr 2020 20:15:04 +0000
X-Originating-IP: [2620:10d:c090:400::5:99f7]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b91c3b0b-96bd-4d1a-b755-08d7ec7a01c3
X-MS-TrafficTypeDiagnostic: BYAPR15MB4104:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB41045560B9DC6A7B3E08A662D3AD0@BYAPR15MB4104.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 03883BD916
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(366004)(376002)(396003)(39860400002)(346002)(136003)(316002)(52116002)(2906002)(6506007)(53546011)(110136005)(54906003)(186003)(8676002)(6636002)(86362001)(2616005)(36756003)(6486002)(16526019)(8936002)(478600001)(31686004)(6512007)(5660300002)(66946007)(4326008)(66476007)(31696002)(66556008);DIR:OUT;SFP:1102;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Z+W10T2pDkWH45QlCWAt459yPPS9S55smCk7HdVOZ5Zouvhjjk+is4sn7gKEf+EMsIKN/0VZTc2tKQaXqctVdSCCB0SW3Zo80iZU+33ZfcsfCuH4eAiHgSGoZc6BSynzqP0m6ZHMyvwFN0dOYW0B2Mii0vPNQRuJvFBWOXOAFHncy1OawQ/od8TLPnOoR30n1A5GtJG/ty+Yfn1o6s+TBMoOBp7DH807FGacVhb03ZLeSFZwVBreBCFSsxtcllYNd6FjfmU7by1haZ4VZMO7Ob2SISgvO2txl7mnFhVEmie5+h4QB1sqgTL4RN44A0ch2kDNcgCVRzyh0LLh1GWgu4mtHZMIlwSL60I/HfpIt/5st9P7I2fMe153P5LTSr42d3nsV6t5GXi8LHed4hJomXAAB4b5kLHf7eyoocXzSqfnhy9/oKA+75ptlk10SEdP
X-MS-Exchange-AntiSpam-MessageData: qBV0YrdZo5MbyZvI5ZveU2vPSJSq1IWLHuS53vRAp+xYrdlGSinMjrB2XZWEyb84YftLODNx83cEUMN796DcDEZsKluZeIkgwU0Vn1Vf2qYI/Y+nz41QCo4yvNkX71pz+nK6IKWz0hUPZ3owW7AZDe8yP66WmaCneh5wU4NetRCsndT76jvMva89u5auK5/AQppOX8vCqQDLnM3ahbI/VH46cK+NrY1Mo6u5F8bsQVD2QtQBkZhK7WGMC6k6xb9lXlwcgrQUq8tgLp5nZHElG9aSd2DfoyI7M3Og5O2MFLHooVhGBKgxttdJXICToeyCEM4DXLeBYMg5F+4mltwqP4jbtm04k7UMbuD4Kyl6zgb88P9WPgp1qpcMoofyDay/aH66pLP0bLZxNcGn1TIzm33RGOFzw8vZ/CE5k2QByAqzflshG/Ed9CYCrGkQ47fvDVq913ss7NekuuflFaZcNIHcvhh1ofIf4/Skk60czRnT3mCdTLpXX1U4Ni0HAnrv5grSqANl6xvMhWzGPFnUkikFBlnQal/WoRZIrivMZ7A31MVzLKCZdVyED/TpQb5SjB98RlLCIGdjKB/9g0xIsQuysJYET3hXVvPeTlVCdWUJrjeaVVKUZyuHsnwuoUwiM+KdCVEku0m9ENNVrfttu9AAbD86dRCTJr4ZJTQAqY2BPn5LK0NaFMxn3Pgu8Qt5D21x3djCav2kn7UnAP8rhw4A0wswX0xnA8pMlIZicmKN/QSthmSH1eFpNvsNgWbwMIvwQ5ShPWEe14XrZwHivetRvF8Ricvh/3Q2HV28bxXnotGgm2oD+7XmkKeKHLAUqk86bbKuDh9gCA6JIZwldA==
X-MS-Exchange-CrossTenant-Network-Message-Id: b91c3b0b-96bd-4d1a-b755-08d7ec7a01c3
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2020 20:15:05.7742
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RbFz0SlfYidhoLDpYFSBlym7QseficwsPqGSwHDcT/g9boo2tPVhykXPfGYYkuut
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB4104
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-29_10:2020-04-29,2020-04-29 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015
 impostorscore=0 lowpriorityscore=0 suspectscore=0 priorityscore=1501
 mlxlogscore=999 malwarescore=0 phishscore=0 mlxscore=0 adultscore=0
 spamscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004290147
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/29/20 12:19 PM, Andrii Nakryiko wrote:
> On Wed, Apr 29, 2020 at 8:34 AM Alexei Starovoitov <ast@fb.com> wrote:
>>
>> On 4/28/20 11:44 PM, Yonghong Song wrote:
>>>
>>>
>>> On 4/28/20 11:40 PM, Andrii Nakryiko wrote:
>>>> On Tue, Apr 28, 2020 at 11:30 PM Alexei Starovoitov <ast@fb.com> wrote:
>>>>>
>>>>> On 4/28/20 11:20 PM, Yonghong Song wrote:
>>>>>>
>>>>>>
>>>>>> On 4/28/20 11:08 PM, Andrii Nakryiko wrote:
>>>>>>> On Tue, Apr 28, 2020 at 10:10 PM Yonghong Song <yhs@fb.com> wrote:
>>>>>>>>
>>>>>>>>
>>>>>>>>
>>>>>>>> On 4/28/20 7:44 PM, Alexei Starovoitov wrote:
>>>>>>>>> On 4/28/20 6:15 PM, Yonghong Song wrote:
>>>>>>>>>>
>>>>>>>>>>
>>>>>>>>>> On 4/28/20 5:48 PM, Alexei Starovoitov wrote:
>>>>>>>>>>> On 4/28/20 5:37 PM, Martin KaFai Lau wrote:
>>>>>>>>>>>>> +    prog = bpf_iter_get_prog(seq, sizeof(struct
>>>>>>>>>>>>> bpf_iter_seq_map_info),
>>>>>>>>>>>>> +                 &meta.session_id, &meta.seq_num,
>>>>>>>>>>>>> +                 v == (void *)0);
>>>>>>>>>>>>     From looking at seq_file.c, when will show() be called with
>>>>>>>>>>>> "v ==
>>>>>>>>>>>> NULL"?
>>>>>>>>>>>>
>>>>>>>>>>>
>>>>>>>>>>> that v == NULL here and the whole verifier change just to allow
>>>>>>>>>>> NULL...
>>>>>>>>>>> may be use seq_num as an indicator of the last elem instead?
>>>>>>>>>>> Like seq_num with upper bit set to indicate that it's last?
>>>>>>>>>>
>>>>>>>>>> We could. But then verifier won't have an easy way to verify that.
>>>>>>>>>> For example, the above is expected:
>>>>>>>>>>
>>>>>>>>>>          int prog(struct bpf_map *map, u64 seq_num) {
>>>>>>>>>>             if (seq_num >> 63)
>>>>>>>>>>               return 0;
>>>>>>>>>>             ... map->id ...
>>>>>>>>>>             ... map->user_cnt ...
>>>>>>>>>>          }
>>>>>>>>>>
>>>>>>>>>> But if user writes
>>>>>>>>>>
>>>>>>>>>>          int prog(struct bpf_map *map, u64 seq_num) {
>>>>>>>>>>              ... map->id ...
>>>>>>>>>>              ... map->user_cnt ...
>>>>>>>>>>          }
>>>>>>>>>>
>>>>>>>>>> verifier won't be easy to conclude inproper map pointer tracing
>>>>>>>>>> here and in the above map->id, map->user_cnt will cause
>>>>>>>>>> exceptions and they will silently get value 0.
>>>>>>>>>
>>>>>>>>> I mean always pass valid object pointer into the prog.
>>>>>>>>> In above case 'map' will always be valid.
>>>>>>>>> Consider prog that iterating all map elements.
>>>>>>>>> It's weird that the prog would always need to do
>>>>>>>>> if (map == 0)
>>>>>>>>>       goto out;
>>>>>>>>> even if it doesn't care about finding last.
>>>>>>>>> All progs would have to have such extra 'if'.
>>>>>>>>> If we always pass valid object than there is no need
>>>>>>>>> for such extra checks inside the prog.
>>>>>>>>> First and last element can be indicated via seq_num
>>>>>>>>> or via another flag or via helper call like is_this_last_elem()
>>>>>>>>> or something.
>>>>>>>>
>>>>>>>> Okay, I see what you mean now. Basically this means
>>>>>>>> seq_ops->next() should try to get/maintain next two elements,
>>>>>>>
>>>>>>> What about the case when there are no elements to iterate to begin
>>>>>>> with? In that case, we still need to call bpf_prog for (empty)
>>>>>>> post-aggregation, but we have no valid element... For bpf_map
>>>>>>> iteration we could have fake empty bpf_map that would be passed, but
>>>>>>> I'm not sure it's applicable for any time of object (e.g., having a
>>>>>>> fake task_struct is probably quite a bit more problematic?)...
>>>>>>
>>>>>> Oh, yes, thanks for reminding me of this. I put a call to
>>>>>> bpf_prog in seq_ops->stop() especially to handle no object
>>>>>> case. In that case, seq_ops->start() will return NULL,
>>>>>> seq_ops->next() won't be called, and then seq_ops->stop()
>>>>>> is called. My earlier attempt tries to hook with next()
>>>>>> and then find it not working in all cases.
>>>>>
>>>>> wait a sec. seq_ops->stop() is not the end.
>>>>> With lseek of seq_file it can be called multiple times.
>>>
>>> Yes, I have taken care of this. when the object is NULL,
>>> bpf program will be called. When the object is NULL again,
>>> it won't be called. The private data remembers it has
>>> been called with NULL.
>>
>> Even without lseek stop() will be called multiple times.
>> If I read seq_file.c correctly it will be called before
>> every copy_to_user(). Which means that for a lot of text
>> (or if read() is done with small buffer) there will be
>> plenty of start,show,show,stop sequences.
> 
> 
> Right start/stop can be called multiple times, but seems like there
> are clear indicators of beginning of iteration and end of iteration:
> - start() with seq_num == 0 is start of iteration (can be called
> multiple times, if first element overflows buffer);
> - stop() with p == NULL is end of iteration (seems like can be called
> multiple times as well, if user keeps read()'ing after iteration
> completed).
> 
> There is another problem with stop(), though. If BPF program will
> attempt to output anything during stop(), that output will be just
> discarded. Not great. Especially if that output overflows and we need

The stop() output will not be discarded in the following cases:
    - regular show() objects overflow and stop() BPF program not called
    - regular show() objects not overflow, which means iteration is done,
      and stop() BPF program does not overflow.

The stop() seq_file output will be discarded if
    - regular show() objects not overflow and stop() BPF program output
      overflows.
    - no objects to iterate, BPF program got called, but its seq_file
      write/printf will be discarded.

Two options here:
   - implement Alexei suggestion to look ahead two elements to
     always having valid object and indicating the last element
     with a special flag.
   - Per Andrii's suggestion below to implement new way or to
     tweak seq_file() a little bit to resolve the above cases
     where stop() seq_file outputs being discarded.

Will try to experiment with both above options...


> to re-allocate buffer.
> 
> We are trying to use seq_file just to reuse 140 lines of code in
> seq_read(), which is no magic, just a simple double buffer and retry
> piece of logic. We don't need lseek and traverse, we don't need all
> the escaping stuff. I think bpf_iter implementation would be much
> simpler if bpf_iter had better control over iteration. Then this whole
> "end of iteration" behavior would be crystal clear. Should we maybe
> reconsider again?
> 
> I understand we want to re-use networking iteration code, but we can
> still do that with custom implementation of seq_read, because we are
> still using struct seq_file and follow its semantics. The change would
> be to allow stop(NULL) (or any stop() call for that matter) to perform
> output (and handle retry and buffer re-allocation). Or, alternatively,
> coupled with seq_operations intercept proposal in patch #7 discussion,
> we can add extra method (e.g., finish()) that would be called after
> all elements are traversed and will allow to emit extra stuff. We can
> do that (implement finish()) in seq_read, as well, if that's going to
> fly ok with seq_file maintainers, of course.
> 
