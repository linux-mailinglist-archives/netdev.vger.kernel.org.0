Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B76581BEEE1
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 06:01:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726577AbgD3EBh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 00:01:37 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:21898 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726040AbgD3EBg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 00:01:36 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03U40PLZ023670;
        Wed, 29 Apr 2020 21:01:24 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=VR0JJv7G5HZHOpwOzAqpWF283wRzb9gszpvKGmlFH4Y=;
 b=TG+redVKHe6hUeCdKYutFw2+vowAqEARaISsqfQnyPFAGH3kxr4EmWM7mVEqwWzmQowA
 m0rd1Tt0sno8XSWQJkEb+AVgL/vzQF5F0gj2VLZCrQpLD8G5Exk8rEGb4vs223yPJMhq
 rKcM+9yvNYMWxBd5ocZtguVwQ4vKl5lSnVc= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 30n5bxkdqv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 29 Apr 2020 21:01:23 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.198) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Wed, 29 Apr 2020 21:01:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=epadMs1CbnnzZy8cxka+a/vWVLK2odBf4quyycC8n4KzjDhlj5TACEvJ1c2BijmOdb5MCRtZ8jDJ+AvlbWhTO+LbVeFRV6BGZOmjuo1htgqc87hCQ7RflCsXHoXKG1MlV5Iflm9S7eE1Y+epg4Ucyt1JLZq7uj0MLlXUlOe1VyUeae5oVgFz0X6CqAOzLUeoy6+mPntfffyvunrj8hCvlPBMkn9Zt5CEj6EMUcvmic96yrf4V8UK/Goy1MlkID/BY/TvT6ngTCSArt/5117X/V6hy3JYNKZm221ZUBZoWQJSQyAGdWq3WJPw0zoHF7Lihn1Atd05yPHzOCCkd0E0hg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VR0JJv7G5HZHOpwOzAqpWF283wRzb9gszpvKGmlFH4Y=;
 b=YRUPSCdG1/Og9tHzs36do7Xv8B5/7OPjAMazMt0lu0RbpgxvVuH1P3O2GOeFLFSQQ6BscZP/jJOsZywFsyZ4rzQ/hpFvyaidukufjfZrPwguHwDw954/0P3R5Mu/wo4Aggzf+VnJJwwXqP+LQhF6mcudjiaHkMuSOc2mz25bC9naii88LzhOitzkKk01oHHS6KkWC2Yht7HuJ3lsbpXACZWtsoUIxyrbwGTRTwQ6hfX0lJtn9MH9CXvVEgRf86lQvMf+Fu9MBWbX/0jzUDyUPdl1OiKPois1MWrGV81yIkE0BcBm+D57cH3sMip1UgZ6Zs+EUyfpwWXUiPm8CnLbPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VR0JJv7G5HZHOpwOzAqpWF283wRzb9gszpvKGmlFH4Y=;
 b=ErcDMPw5uFsne0enUcodW2JK36ZogRwxxL/GTuoApKgcrBUpN3W7BUGg/PwdxRzGvMuXnVuQ4H4Jg/INAQNqz2Auxdqc0Ie9zNlCFE3VU5ht7eVemsESRIqYzmG7+Gcu9SL87cMCPoMh5QcQv2ptx9itTrDi8wW7BZOGKno2voc=
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2613.namprd15.prod.outlook.com (2603:10b6:a03:151::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.22; Thu, 30 Apr
 2020 04:01:19 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::8988:aa27:5d70:6923]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::8988:aa27:5d70:6923%5]) with mapi id 15.20.2937.028; Thu, 30 Apr 2020
 04:01:19 +0000
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
 <CAEf4BzZgZ7h_asHNGk_34vJv_yvLtWGcTGwdTO4fgLPySaG-Eg@mail.gmail.com>
 <cc802671-76e6-e911-0e4e-53a4e99c69ff@fb.com>
 <9f5bd594-9511-1df4-093d-33111fc9c2dd@fb.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <d50e3abf-d279-6954-1ccf-c20c506f5721@fb.com>
Date:   Wed, 29 Apr 2020 21:01:15 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
In-Reply-To: <9f5bd594-9511-1df4-093d-33111fc9c2dd@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MWHPR19CA0057.namprd19.prod.outlook.com
 (2603:10b6:300:94::19) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from MacBook-Pro-52.local (2620:10d:c090:400::5:8d6a) by MWHPR19CA0057.namprd19.prod.outlook.com (2603:10b6:300:94::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.19 via Frontend Transport; Thu, 30 Apr 2020 04:01:17 +0000
X-Originating-IP: [2620:10d:c090:400::5:8d6a]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: aa551d11-8654-4a18-da79-08d7ecbb231c
X-MS-TrafficTypeDiagnostic: BYAPR15MB2613:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB2613A6F7CA0C332F66013466D3AA0@BYAPR15MB2613.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-Forefront-PRVS: 0389EDA07F
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(39860400002)(366004)(396003)(376002)(136003)(346002)(5660300002)(6506007)(66476007)(66556008)(53546011)(186003)(36756003)(2906002)(4326008)(66946007)(86362001)(6486002)(31696002)(8936002)(2616005)(16526019)(6512007)(110136005)(316002)(52116002)(54906003)(478600001)(8676002)(31686004);DIR:OUT;SFP:1102;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DdE0Gq0lhoqP9pxJAnxjJ+14syYyeujxUVcXzOw6yplSrWqmecBSz8Pmpe5jEstg2Klir0lPCX8kdJ4bgvUZP/VXoc/FKzUQlo0Nz0o9lYQtAwGx94EwsPL2rgxSRKxN1pPiYtMreRH/GUATl7zFFl95npkcxFoFWSFnuHESZmQk1nOHBeui7mu/7/eJ0ZmBYwYbLiq7Yzdw1xBfhbn6+TyR2ml1buHGUcpy6pn2bWxMhG+zQzIkNwZSyZBy71r4ETBsWMxVeXLc21HrwDgS3NyF6+JJYSC6JMRwThjGWxrXRN2ciesKiv9QHMqVtfRCKI9LXxGujsjtiVoV2e+WnLzdBUroKODXNp1jAlHRrTYVK6LrCcYP4Fv8K79jZSE0eeD6I/WANXkZEO/NavjmTo46HOTD2SoNBOS2oHxMzsyAz0/7gUjKbKOvB+/5ypNW
X-MS-Exchange-AntiSpam-MessageData: 064uCXSG7oBhWdBxA7ccWBtVjbTSg/34/H9vjzdPxSg3LrDIah3QsapwGR2d4rPIRFFgidOMBVtuPzgcRtK2Dmu3BhauXNP8y403ENuAuAtQYTuLUM9ggIZLSHH7mTX+zCZ8FduFI1HHeUxF0mb5hv1CXbjwGe3yLUx2IpcKp73shJyVQeZSxKcRivOfwugmnXvSQQ/PaPmP6zDJY13Mm9O9k/Z9Jmh9A3mgbEizSJneX+LZ7itn1TxPhbIoTlxpiA/dNAmT8ZDDGPNOaiq7vvrQobbR3isfR7Lx5Cpgpm0y0uO0M2q+8+5fo+j+UuP01tQpD8niP/eSEw9DH1Ar9c6iRGwEhKbnZ76vYXEhWIm+qVc1TMBJfbYhfMTX6Y1XWwL+nEyZSw5nVuGFkh5ZhfAv81z++c+JX2fZGSH+A0/bP7BRN0MPZ2awLQnXIqTtDbMQTNrocqA4uH4OZRcFyxUNO4Bw6UWlnCLZZp2HlFltu1TDlHuSL5BZNipTJRuWtgJ0P5SEJYH0cKUREkfWr4EkufO7VjnxSp8HsPBhhiaGO6jAz2Ej582SkL+jID7fLzYCBMmtKQaEJPHqyO82QZMTu6VTHnorRIpKnEhGu/LLjB4Zfe16E37eX5wC9tDkx1xZFro7CeH9jgx4pJKCcc191VU0D5jX3cXbq1xp7FGC9/fNf41NO3QHLXwYYEHF8Kz5rStD3UpUGjhVC0FItxNKCNelT4uOlyntpP9apF06QeCxU21rhxcLz+TkK5lxei3Le817nxURp1rfzdp3/i5tzFRzVygzTZdW3qu0aNncfMdHiSjK+ErN/nMjugsdKmdUFMvmshyKx/ZPE4NCKQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: aa551d11-8654-4a18-da79-08d7ecbb231c
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2020 04:01:19.0896
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Y6PO/OTJ8K5H9Ujc0/LnAL0rTG2JAL6o8VjWgWwj/moyGtaSXy5eaXG0spU5uEEH
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2613
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-30_01:2020-04-30,2020-04-30 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 malwarescore=0
 mlxlogscore=999 suspectscore=0 bulkscore=0 clxscore=1015 impostorscore=0
 adultscore=0 priorityscore=1501 spamscore=0 phishscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004300029
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/29/20 8:06 PM, Alexei Starovoitov wrote:
> On 4/29/20 1:15 PM, Yonghong Song wrote:
>>>>
>>>> Even without lseek stop() will be called multiple times.
>>>> If I read seq_file.c correctly it will be called before
>>>> every copy_to_user(). Which means that for a lot of text
>>>> (or if read() is done with small buffer) there will be
>>>> plenty of start,show,show,stop sequences.
>>>
>>>
>>> Right start/stop can be called multiple times, but seems like there
>>> are clear indicators of beginning of iteration and end of iteration:
>>> - start() with seq_num == 0 is start of iteration (can be called
>>> multiple times, if first element overflows buffer);
>>> - stop() with p == NULL is end of iteration (seems like can be called
>>> multiple times as well, if user keeps read()'ing after iteration
>>> completed).
>>>
>>> There is another problem with stop(), though. If BPF program will
>>> attempt to output anything during stop(), that output will be just
>>> discarded. Not great. Especially if that output overflows and we need
>>
>> The stop() output will not be discarded in the following cases:
>>     - regular show() objects overflow and stop() BPF program not called
>>     - regular show() objects not overflow, which means iteration is done,
>>       and stop() BPF program does not overflow.
>>
>> The stop() seq_file output will be discarded if
>>     - regular show() objects not overflow and stop() BPF program output
>>       overflows.
>>     - no objects to iterate, BPF program got called, but its seq_file
>>       write/printf will be discarded.
>>
>> Two options here:
>>    - implement Alexei suggestion to look ahead two elements to
>>      always having valid object and indicating the last element
>>      with a special flag.
>>    - Per Andrii's suggestion below to implement new way or to
>>      tweak seq_file() a little bit to resolve the above cases
>>      where stop() seq_file outputs being discarded.
>>
>> Will try to experiment with both above options...
>>
>>
>>> to re-allocate buffer.
>>>
>>> We are trying to use seq_file just to reuse 140 lines of code in
>>> seq_read(), which is no magic, just a simple double buffer and retry
>>> piece of logic. We don't need lseek and traverse, we don't need all
>>> the escaping stuff. I think bpf_iter implementation would be much
>>> simpler if bpf_iter had better control over iteration. Then this whole
>>> "end of iteration" behavior would be crystal clear. Should we maybe
>>> reconsider again?
> 
> That's what I was advocating for some time now.
> 
> I think seq_file is barely usable as a /proc extension and completely
> unusable for iterating.
> All the discussions in the last few weeks are pointing out that
> majority of use cases are in the iterating space instead of dumping.
> Dumping human readable strings as unstable /proc extension is
> a small subset. So I think we shouldn't use fs/seq_file.c.
> The dance around double op->next() or introducing op->finish()
> into seq_ops looks like fifth wheel to the car.
> I think bpf_iter semantics and bpf prog logic would be much simpler
> and easier to understand if op->read method was re-implemented
> for the purpose of iterating the objects.
> I mean seq_op->start/next/stop can be reused as-is to iterate
> existing kernel objects like sockets, but seq_read() will not be
> used. We should explicitly disable lseek and write on our
> cat-able files and use new bpf_seq_read() as .read op.
> This specialized bpf_seq_read() will still do a sequences of
> start/show/show/stop for every copy_to_user, but we don't need to
> add finish() to seq_op and hack existing seq_read().
> We also will be able to provide precise seq_num into the program
> instead of approximation.
> bpf_seq_read wouldn't need to deal with ppos and traverse.
> It wouldn't need fancy m->size<<=1 retries.
> It can allocate fixed PAGE_SIZE and be done with it.
> It's fine to restrict bpf progs to not dump more than 4k
> chracters per object.
> And we can call bpf_iter prog exactly once per element.
> Plenty of pros and no real cons.

This may indeed be simpler and scalarable since it is specific for our 
use case compared to ouble next with tweaking the
existing target (ipv6_route, netlink, etc.). Will explore
this way.
