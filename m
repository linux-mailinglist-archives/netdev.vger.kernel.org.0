Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 359F61BE609
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 20:15:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726893AbgD2SPD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 14:15:03 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:16328 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726511AbgD2SPC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 14:15:02 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03TIB3Qe000987;
        Wed, 29 Apr 2020 11:14:49 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=JD8S87fYBk4kasjMOXNNBTDYcNJe522AdYTLW5YbuMk=;
 b=RxUpdD0odZuulwAvki+Y6BcIG1dcuWHh0U8PU1oFN+36swr+mA1sriJJobmwjWzYHLmu
 +JHay8OL7UAIIOeh6aI3ExkDF/8l8N8AEkNFmFT82n/lT/SuV5Wg5oIDWWbonG8Qz7sy
 mHRZyrmpjp7mH5WqpMPrcVjUGOb/uxodvJI= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 30pq0dh982-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 29 Apr 2020 11:14:49 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.196) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Wed, 29 Apr 2020 11:14:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AkkxvgSfm+8Sk5ZptAnKLy7P0/Z1rIPsHB7FtsqO0iWr9jLmk9BNn0oGdM1AvSC1BDepWtLAmDJNOwW5ZX5p47OZ/fzbD5u/PnwWup7uZHBE7XDl5r4blQfu6bEl+EdI0rz1Gjrshk/rkMK3Kr3BBsOQrJ0kExXW/MukSifXuiLI8rgCa7FSdImvXqVzdtBxm8ZvmK9uZX53xgqA8WSei+NTJbja6U4kRMZlPORAz9gP5mPoH5OmPAKj7+Q+9QGVxtst9khvbp94xQ8FxeyyIfPUCwSZqSwDeirdWhBO/25SyijMwPB7mIttfIbmSyN5U5JkoYfPmjG4bcOfO43RSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JD8S87fYBk4kasjMOXNNBTDYcNJe522AdYTLW5YbuMk=;
 b=jCZKw8uW9MUjSCDxTfxQ6nekfORE7JK+2KggmfUm6GWCBW8pHvmL9PXuOsSoLeDarbX7BuCOz7B8vACwiLevJxdJ6FxcOdFi6W84Lt2WyisFYrx4wAPUJq8C1gC1Bkj3PS07SPcPOuqwskN6Ga1kwchlccYQEuFDm9zC5Amez1sT83pwh43hMJ6hxx7VgG9Jamc89smeqNzaQmips8qU7zN+FXniVxmvx4/Ro/lKTtNXGJ3gYhWJy1bHmTOE+H3PliNjPrrnSQfTFzcTWkGMrHjpgT6EU+zGLoUTwJs/fxQhVY7RAeQMIT2pQomLKUyR4Sl2F/Az55gCpcPjIy7QXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JD8S87fYBk4kasjMOXNNBTDYcNJe522AdYTLW5YbuMk=;
 b=UHe1vIQHRdWEV6ueV7PMw745H5mynlBzxk1+0txM/BmMngEBCvFEIaCe2HS6ZiKzqaIW+AgGBOmAm/UiFP0YCgIR94WDpZ4w/VncZRcQ8eCpyIwENaqQDrWdJAGdEGoKLub5Qo54IMflH5hrayxRhbleL9Q/mC15t75gFIpnaG4=
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2919.namprd15.prod.outlook.com (2603:10b6:a03:b1::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.22; Wed, 29 Apr
 2020 18:14:47 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::8988:aa27:5d70:6923]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::8988:aa27:5d70:6923%5]) with mapi id 15.20.2937.028; Wed, 29 Apr 2020
 18:14:47 +0000
Subject: Re: [PATCH bpf-next v1 03/19] bpf: add bpf_map iterator
To:     Alexei Starovoitov <ast@fb.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>
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
From:   Yonghong Song <yhs@fb.com>
Message-ID: <352a43d5-dd62-adeb-9522-46933ace8c18@fb.com>
Date:   Wed, 29 Apr 2020 11:14:43 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
In-Reply-To: <2be3cd4a-cf55-2eeb-c33b-a25135defceb@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MWHPR03CA0016.namprd03.prod.outlook.com
 (2603:10b6:300:117::26) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from macbook-pro-52.local.dhcp.thefacebook.com (2620:10d:c090:400::5:99f7) by MWHPR03CA0016.namprd03.prod.outlook.com (2603:10b6:300:117::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.19 via Frontend Transport; Wed, 29 Apr 2020 18:14:45 +0000
X-Originating-IP: [2620:10d:c090:400::5:99f7]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7a6d0133-cd89-4bf3-3a20-08d7ec6932f6
X-MS-TrafficTypeDiagnostic: BYAPR15MB2919:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB291994F2CF152AA333B37DC0D3AD0@BYAPR15MB2919.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-Forefront-PRVS: 03883BD916
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(396003)(366004)(136003)(346002)(376002)(39860400002)(31696002)(86362001)(6486002)(4326008)(8936002)(478600001)(31686004)(8676002)(6512007)(2616005)(66556008)(66946007)(66476007)(316002)(16526019)(110136005)(54906003)(2906002)(52116002)(36756003)(6506007)(5660300002)(186003)(53546011);DIR:OUT;SFP:1102;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: khYnoL9A/RqIU/a75BvAw6InnlBnLoP9EHhlhVGWtpbmtSkZjX04noo5LjjurSaYttN0ugM9nOZIyg9N7I/g7nY8lbHl1xmiMYAsHlPfOlM+XztU1yJCYAdDdPxcOed7z+/w7kRguvp2u+8AZiK3eiziiwOcDUqWaCWyet+y/trkG3hiIBNcl5WWZl6NK8n5ncmANoObAvoQ8cV0BUltjDD3GD7UXq0Kzem4PxFgqIFQX76zGULhe3Yb6lREqKcssHefBeQ0EXQnewqr9mzhIuMUF1q6CEyktEN24VzKV+MBZDFMDQBmb5JcyHjoFeffI3qO1NUaCuWrefjm608QmA9oxA7SUdtAdgTM88ElKERZRWXNZfWXWDL+X/ptdiu7Mic2jYa5zKmUEOjONteCT9EmDhokr8nhNe/QBk4mjWiMmeV99bqoZRkyHtmo3b9Y
X-MS-Exchange-AntiSpam-MessageData: 859pN5WmfLGSuedJt3rTYDnEXg9x/yH9fKBJHImMPqGmXF3Tq7dRuQ8LHkN9rXVqNkUPWeLbAHi13c3U6w+1HltHKG9BW4DDLC+T2UOYCVXO1f31yOCkx0+Xx4cNdkcJtlZ4WzDaDMhV0d1062BaeRkUAoce+N16HNvJ27XFMvC8ozGzYJyG60CdMptN+LIVodWvI/fRi790ijVpkRvipFXIuegRN0h3HSgsgdDpQiM2kUaRT6B/CLA7AXy9hxZxjl80CHU2U4Zl7SJbqCl+S8dYPcZKYqXuB90PjFnvLyWI+AB97MtFF8VE0p1TjlqypzjHgPo1DMEbrCkbJCwcDm28Aypvop74r/s9z9JTWNJRwWi1rDDbYNyllzOX5G9GRIOuGfMqSBPzFr0vzmkANMVZ2j8Sn03nLRrc5BGRAODmEUbFqRKymZR/caYKp4orhUnc30Nro7pZ5l/Y0RcO/HVVJ0RybxyDbUnSZ1QVlPpqDzqYWvR4udU26hVKzX9hqZc2AFCKR6cH9feR+Ixzh43AAlMwz4l2x/krqPnamtVDl/kZC38qH9SXiXLUlTHWaE3DV5H2xUd1bcmxtOGUJh5+/fju4bcNo2hX7QUl0Ar+mftXolM5kxHsJCe4P602AfhpXxoE0OGgsiTtbXM9DDPe3t9npwhlZ099+hVcXvTIP+qh6hudofX4G7D3bM6o45IMsMXI/UXdIaTheZSzIP4QgZE1qkBbS3ukgom3bwxkAx5/yqWEYG78n+iLUZoBVOGts1JYCecDKLR7iKhC/BnweuuK0gXG9prgO4MaEP4xwiagYyvvFo6XEva6tDpvkXFT5JFdukJNvE5PInHATw==
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a6d0133-cd89-4bf3-3a20-08d7ec6932f6
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2020 18:14:46.9421
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rVtT4rLTvfwzUVoKGGQi60Px0uFrnLzk1IHKsTE1bInrFUjUMYvs8JwqWfQpFRn/
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2919
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-29_09:2020-04-29,2020-04-29 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 priorityscore=1501 clxscore=1015 adultscore=0 lowpriorityscore=0
 impostorscore=0 malwarescore=0 bulkscore=0 spamscore=0 mlxscore=0
 mlxlogscore=999 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2003020000 definitions=main-2004290139
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/29/20 8:34 AM, Alexei Starovoitov wrote:
> On 4/28/20 11:44 PM, Yonghong Song wrote:
>>
>>
>> On 4/28/20 11:40 PM, Andrii Nakryiko wrote:
>>> On Tue, Apr 28, 2020 at 11:30 PM Alexei Starovoitov <ast@fb.com> wrote:
>>>>
>>>> On 4/28/20 11:20 PM, Yonghong Song wrote:
>>>>>
>>>>>
>>>>> On 4/28/20 11:08 PM, Andrii Nakryiko wrote:
>>>>>> On Tue, Apr 28, 2020 at 10:10 PM Yonghong Song <yhs@fb.com> wrote:
>>>>>>>
>>>>>>>
>>>>>>>
>>>>>>> On 4/28/20 7:44 PM, Alexei Starovoitov wrote:
>>>>>>>> On 4/28/20 6:15 PM, Yonghong Song wrote:
>>>>>>>>>
>>>>>>>>>
>>>>>>>>> On 4/28/20 5:48 PM, Alexei Starovoitov wrote:
>>>>>>>>>> On 4/28/20 5:37 PM, Martin KaFai Lau wrote:
>>>>>>>>>>>> +    prog = bpf_iter_get_prog(seq, sizeof(struct
>>>>>>>>>>>> bpf_iter_seq_map_info),
>>>>>>>>>>>> +                 &meta.session_id, &meta.seq_num,
>>>>>>>>>>>> +                 v == (void *)0);
>>>>>>>>>>>    From looking at seq_file.c, when will show() be called 
>>>>>>>>>>> with "v ==
>>>>>>>>>>> NULL"?
>>>>>>>>>>>
>>>>>>>>>>
>>>>>>>>>> that v == NULL here and the whole verifier change just to allow
>>>>>>>>>> NULL...
>>>>>>>>>> may be use seq_num as an indicator of the last elem instead?
>>>>>>>>>> Like seq_num with upper bit set to indicate that it's last?
>>>>>>>>>
>>>>>>>>> We could. But then verifier won't have an easy way to verify that.
>>>>>>>>> For example, the above is expected:
>>>>>>>>>
>>>>>>>>>         int prog(struct bpf_map *map, u64 seq_num) {
>>>>>>>>>            if (seq_num >> 63)
>>>>>>>>>              return 0;
>>>>>>>>>            ... map->id ...
>>>>>>>>>            ... map->user_cnt ...
>>>>>>>>>         }
>>>>>>>>>
>>>>>>>>> But if user writes
>>>>>>>>>
>>>>>>>>>         int prog(struct bpf_map *map, u64 seq_num) {
>>>>>>>>>             ... map->id ...
>>>>>>>>>             ... map->user_cnt ...
>>>>>>>>>         }
>>>>>>>>>
>>>>>>>>> verifier won't be easy to conclude inproper map pointer tracing
>>>>>>>>> here and in the above map->id, map->user_cnt will cause
>>>>>>>>> exceptions and they will silently get value 0.
>>>>>>>>
>>>>>>>> I mean always pass valid object pointer into the prog.
>>>>>>>> In above case 'map' will always be valid.
>>>>>>>> Consider prog that iterating all map elements.
>>>>>>>> It's weird that the prog would always need to do
>>>>>>>> if (map == 0)
>>>>>>>>      goto out;
>>>>>>>> even if it doesn't care about finding last.
>>>>>>>> All progs would have to have such extra 'if'.
>>>>>>>> If we always pass valid object than there is no need
>>>>>>>> for such extra checks inside the prog.
>>>>>>>> First and last element can be indicated via seq_num
>>>>>>>> or via another flag or via helper call like is_this_last_elem()
>>>>>>>> or something.
>>>>>>>
>>>>>>> Okay, I see what you mean now. Basically this means
>>>>>>> seq_ops->next() should try to get/maintain next two elements,
>>>>>>
>>>>>> What about the case when there are no elements to iterate to begin
>>>>>> with? In that case, we still need to call bpf_prog for (empty)
>>>>>> post-aggregation, but we have no valid element... For bpf_map
>>>>>> iteration we could have fake empty bpf_map that would be passed, but
>>>>>> I'm not sure it's applicable for any time of object (e.g., having a
>>>>>> fake task_struct is probably quite a bit more problematic?)...
>>>>>
>>>>> Oh, yes, thanks for reminding me of this. I put a call to
>>>>> bpf_prog in seq_ops->stop() especially to handle no object
>>>>> case. In that case, seq_ops->start() will return NULL,
>>>>> seq_ops->next() won't be called, and then seq_ops->stop()
>>>>> is called. My earlier attempt tries to hook with next()
>>>>> and then find it not working in all cases.
>>>>
>>>> wait a sec. seq_ops->stop() is not the end.
>>>> With lseek of seq_file it can be called multiple times.
>>
>> Yes, I have taken care of this. when the object is NULL,
>> bpf program will be called. When the object is NULL again,
>> it won't be called. The private data remembers it has
>> been called with NULL.
> 
> Even without lseek stop() will be called multiple times.
> If I read seq_file.c correctly it will be called before
> every copy_to_user(). Which means that for a lot of text
> (or if read() is done with small buffer) there will be
> plenty of start,show,show,stop sequences.

That is true, this may cause revisit the same object if the object
still exists return start() called again. I followed similar
practice with ipv6_route(), trying to looking up the same
object at start() and only advanced right before next().
