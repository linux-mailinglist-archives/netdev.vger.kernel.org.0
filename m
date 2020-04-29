Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01A621BD514
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 08:51:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726472AbgD2Gvy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 02:51:54 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:31206 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726274AbgD2Gvy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 02:51:54 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03T6otmQ019563;
        Tue, 28 Apr 2020 23:51:41 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=JoS6OjNhFzXbM4tPWhCIplYB56yYZwvUQ/pK7Y9+s30=;
 b=RJEvJbBC8HGEXlCgLyYm8DYpwQ11rWHTlvmvHO/ZqwKcgwcMISLw6TDhDaVayneqSOkn
 4AOIiPlKQiJYF9rWwUisi5JnUyZOlXhWa5FNWYFIFyY27b9xOh2PYemAtrcngGD65nQE
 27w+dQVf8XzAoe0D467oXne2n8VpjCgIibg= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 30q4f88286-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 28 Apr 2020 23:51:41 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.230) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Tue, 28 Apr 2020 23:51:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HX3Awl3Ss0vgn+TphzrvlV0BYe5GcBUYNUdB0nw5pQx5YpZ6dZ7rewHTE+e56RkkyC++aMU3j1UkakBeA+XUjwkJLS0MkVSY9ZAiBYGK5rzVSIHdilaIMSTDcyrsqoX+LYijHS130C6JUmAnKRALSeFLgWIZJEc6b1+XJtufC01Jk2sNedOTfgRtzNPGZyUEp8Ufx9BzYKqe+NCRjc7i3DYh0KWm5QeT6D6WSPYTfAubLFdE4tx/OlUeC43O3J6wMaT2S+SClCGDmZ9/P8pZRxw+pfsuIJvEGO7Pm1TQlKI9mFbPlKY37Fw51huQvyOoNvNur+Yjg4AotS6PZw4Eag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JoS6OjNhFzXbM4tPWhCIplYB56yYZwvUQ/pK7Y9+s30=;
 b=MtqD60qPJfEq7BE70ojd0ojM89bu2R5BN5TeWeh6K74N+LZ2RUHhfFC+EEBK0Q+lqEzUjUMxqcRhsFQ2ENfSgFIJNbjRmsx33Axp4KUiOrg4FpiLPMdMejuHu5Vg7+A2hE+bSYg56RQaGS7kIIYeHUccsXy9FjIi6Z1k0oE401DEIvmZ8i7L6g1hu1ZdmeMSCSa/G8ysejnGMJX2LCZHt5kBRekxVJdG5fUy7OOBvRyJyfgD2xC/pHtGFatgI5PH/K0ybPa8FzHAcHuN67inMV1VsRu5ogIoAZ1zuHaWO9sEr71ZrPk00joIwV6R7/DJK55GbA97f3SLQp0Q05Ma1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JoS6OjNhFzXbM4tPWhCIplYB56yYZwvUQ/pK7Y9+s30=;
 b=NzPQJ21/b31vqtoNOQ5ueaNtIQSIfCa7fJVVbwG69cPoBfISq9vKSOy8yv5CvNMR4up5SlsgT9kiJh8OLFJkc9D1B3fQ+/iRtRCQkc+w0bSp36xV6RtU4PSQYxdu9Iq1mx7mqLEN8KYvMK97GeTUCpazr9NMK/S5m2Kp+NpvfwY=
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2373.namprd15.prod.outlook.com (2603:10b6:a02:92::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13; Wed, 29 Apr
 2020 06:51:36 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::8988:aa27:5d70:6923]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::8988:aa27:5d70:6923%5]) with mapi id 15.20.2937.023; Wed, 29 Apr 2020
 06:51:36 +0000
Subject: Re: [PATCH bpf-next v1 03/19] bpf: add bpf_map iterator
To:     Martin KaFai Lau <kafai@fb.com>
CC:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <ast@fb.com>,
        Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
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
 <20200429063448.fwqubjdz72uikpga@kafai-mbp>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <a0e60713-edfa-9363-c75a-0e8977612858@fb.com>
Date:   Tue, 28 Apr 2020 23:51:33 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
In-Reply-To: <20200429063448.fwqubjdz72uikpga@kafai-mbp>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MWHPR15CA0070.namprd15.prod.outlook.com
 (2603:10b6:301:4c::32) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from macbook-pro-52.local.dhcp.thefacebook.com (2620:10d:c090:400::5:e9ab) by MWHPR15CA0070.namprd15.prod.outlook.com (2603:10b6:301:4c::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.19 via Frontend Transport; Wed, 29 Apr 2020 06:51:35 +0000
X-Originating-IP: [2620:10d:c090:400::5:e9ab]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a990611c-c9ec-4967-d9ea-08d7ec09c2b2
X-MS-TrafficTypeDiagnostic: BYAPR15MB2373:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB2373F016780D2E9763754D72D3AD0@BYAPR15MB2373.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 03883BD916
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(346002)(136003)(39860400002)(366004)(376002)(396003)(186003)(16526019)(31686004)(6862004)(478600001)(66476007)(66556008)(8936002)(36756003)(5660300002)(52116002)(66946007)(8676002)(6486002)(53546011)(86362001)(6512007)(6506007)(6636002)(2616005)(2906002)(31696002)(54906003)(316002)(37006003)(4326008);DIR:OUT;SFP:1102;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KclXZ8FlsA015CP769yNmgoerRl3y7TD4NTo0VxNGA85piek3RJIy6M+IdSuUs+8u0LZce5w1BeOb6Q5HPG2m75vGJlreJUzbUUcTqA1QVxW1IjDyl6OrwGsOLTebXp0DbDHMonjogGHHfhJ8Gz8rC6uxci7jR1G60T3JRDsVKe0K/FRBxdmiHTmWTwW72MvcQWm1yTG83GPtKP33x5ShSA4LLSBtIxsKSe/G+Aj39q73BPu9u3oh9NvYoX4nlY0YNAV+siVhrpolG949VB9p7u7nDsLCyfE6XI1jGnp3fQolxxFKvJdzwyESnj/jHzqXTwlOfc+VN60cRWDgP8+snmH7ppmqYRQa82oNoYUW5hasagMeHuP+helIEpCgH1Be/uuTj4q86mWE3Y66H0th3LfGoJUbQw5AU0C8BdWBLdTjXjXwvUjhPJ3FVH201nl
X-MS-Exchange-AntiSpam-MessageData: 534ERJdo0nmkpLBe85+UDaT0FdBjChAigvOLPcNCs02JvBdKnn68hXxVUItBL5c8CuLxExkDJtkUCWJp2LIfYEoM7nXl/wqvt1LrbkLocad0Y0XIQo+qltaib9HtlDDo7lDL7aZOBYJg9TKfU1XJbQTp+I5S/jEDEKHMUWNFKN7S40SEPYSfyIUxT7+aGT3V0YhfElaEAQfG2HEJ91aYHfYHaV1BE5cn0kkVqD1CejS8TnppJ6kjjr+0NduVNwzfXI8dZjWfTQQtfqp8uqmtbk5AYkS8qDCBDRHc40KJcY9eCV2wB2LAdUuRiBPpt989V8lqWHzkwg4ECZirD3qxbPK/he3feImUkOk5w8VJ6wdfsEmRXYzXB1OPovQM9Hio4UOpfW7HfajY4pJTbaptePLyaqI9G4agEmO3wDOiEFBG43t1FQftkha8QR2qdnbBf/AKMFrgTTFO1adNh550aocKILge+aNKiS/MIOVIhLc02+lYyt+BD39HPtMThorqbkclE8/nacZ8BdBYX9+jOG2ovooT4j+XxnxeTw7H5gRPDAHV3gwXG/NTm+pJh4j5YS51X2FdO559Ai84kkDltTUVpr4F8/fAqq6OFbdeWgiVFHi93ez9BrIQrqgr6R9wDnBWEJREc2GbxwqcIPBQWa1NhWMwD4aCvtqr3Z3KkWdTCSheDgacUKXpPtnaw0UXLpIKO2ARYj4+M0KPf38ovcmMO5vjaenGxtqnd8xSC34b8I5U+nyNTiIzXw0cY8s49CFzU9GVBnoUh2nKva93pfyFWULHsU2DvuC+GZcZJVPwpwFyMGzt4qdaYK5TswXt49DjYgAXYq4o+yxOBz3tFQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: a990611c-c9ec-4967-d9ea-08d7ec09c2b2
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2020 06:51:36.2515
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zfV+ETDoeHQKcJ+u0y0fo7ySOlL3rl9hVd6ti6UDzIjizRq2iPNY9/RfDmB1yylp
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2373
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-29_02:2020-04-28,2020-04-29 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=999
 mlxscore=0 lowpriorityscore=0 adultscore=0 bulkscore=0 clxscore=1015
 priorityscore=1501 suspectscore=0 phishscore=0 spamscore=0 malwarescore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004290055
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/28/20 11:34 PM, Martin KaFai Lau wrote:
> On Tue, Apr 28, 2020 at 11:20:30PM -0700, Yonghong Song wrote:
>>
>>
>> On 4/28/20 11:08 PM, Andrii Nakryiko wrote:
>>> On Tue, Apr 28, 2020 at 10:10 PM Yonghong Song <yhs@fb.com> wrote:
>>>>
>>>>
>>>>
>>>> On 4/28/20 7:44 PM, Alexei Starovoitov wrote:
>>>>> On 4/28/20 6:15 PM, Yonghong Song wrote:
>>>>>>
>>>>>>
>>>>>> On 4/28/20 5:48 PM, Alexei Starovoitov wrote:
>>>>>>> On 4/28/20 5:37 PM, Martin KaFai Lau wrote:
>>>>>>>>> +    prog = bpf_iter_get_prog(seq, sizeof(struct
>>>>>>>>> bpf_iter_seq_map_info),
>>>>>>>>> +                 &meta.session_id, &meta.seq_num,
>>>>>>>>> +                 v == (void *)0);
>>>>>>>>    From looking at seq_file.c, when will show() be called with "v ==
>>>>>>>> NULL"?
>>>>>>>>
>>>>>>>
>>>>>>> that v == NULL here and the whole verifier change just to allow NULL...
>>>>>>> may be use seq_num as an indicator of the last elem instead?
>>>>>>> Like seq_num with upper bit set to indicate that it's last?
>>>>>>
>>>>>> We could. But then verifier won't have an easy way to verify that.
>>>>>> For example, the above is expected:
>>>>>>
>>>>>>         int prog(struct bpf_map *map, u64 seq_num) {
>>>>>>            if (seq_num >> 63)
>>>>>>              return 0;
>>>>>>            ... map->id ...
>>>>>>            ... map->user_cnt ...
>>>>>>         }
>>>>>>
>>>>>> But if user writes
>>>>>>
>>>>>>         int prog(struct bpf_map *map, u64 seq_num) {
>>>>>>             ... map->id ...
>>>>>>             ... map->user_cnt ...
>>>>>>         }
>>>>>>
>>>>>> verifier won't be easy to conclude inproper map pointer tracing
>>>>>> here and in the above map->id, map->user_cnt will cause
>>>>>> exceptions and they will silently get value 0.
>>>>>
>>>>> I mean always pass valid object pointer into the prog.
>>>>> In above case 'map' will always be valid.
>>>>> Consider prog that iterating all map elements.
>>>>> It's weird that the prog would always need to do
>>>>> if (map == 0)
>>>>>      goto out;
>>>>> even if it doesn't care about finding last.
>>>>> All progs would have to have such extra 'if'.
>>>>> If we always pass valid object than there is no need
>>>>> for such extra checks inside the prog.
>>>>> First and last element can be indicated via seq_num
>>>>> or via another flag or via helper call like is_this_last_elem()
>>>>> or something.
>>>>
>>>> Okay, I see what you mean now. Basically this means
>>>> seq_ops->next() should try to get/maintain next two elements,
>>>
>>> What about the case when there are no elements to iterate to begin
>>> with? In that case, we still need to call bpf_prog for (empty)
>>> post-aggregation, but we have no valid element... For bpf_map
>>> iteration we could have fake empty bpf_map that would be passed, but
>>> I'm not sure it's applicable for any time of object (e.g., having a
>>> fake task_struct is probably quite a bit more problematic?)...
>>
>> Oh, yes, thanks for reminding me of this. I put a call to
>> bpf_prog in seq_ops->stop() especially to handle no object
>> case. In that case, seq_ops->start() will return NULL,
>> seq_ops->next() won't be called, and then seq_ops->stop()
>> is called. My earlier attempt tries to hook with next()
>> and then find it not working in all cases.
>>
>>>
>>>> otherwise, we won't know whether the one in seq_ops->show()
>>>> is the last or not.
> I think "show()" is convoluted with "stop()/eof()".  Could "stop()/eof()"
> be its own separate (and optional) bpf_prog which only does "stop()/eof()"?

I thought this before. But user need to write a program instead of
a simple "if" condition in the main program...

> 
>>>> We could do it in newly implemented
>>>> iterator bpf_map/task/task_file. Let me check how I could
>>>> make existing seq_ops (ipv6_route/netlink) works with
>>>> minimum changes.
