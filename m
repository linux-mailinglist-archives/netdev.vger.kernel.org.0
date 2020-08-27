Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 787B3254CA3
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 20:10:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726894AbgH0SKP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 14:10:15 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:11158 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726243AbgH0SKO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Aug 2020 14:10:14 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07RI4uFq010508;
        Thu, 27 Aug 2020 11:09:59 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=lwncnA3niud5vNina8M3umpf6zQykgW2bPp9cMoK6l0=;
 b=lXLgI16jVF1zqhxJkM/hIC8GA5QHlZ2MS2qVLwJJvxUW/LCOku/0NotOix0o24aaQ10a
 UErbPEQAixmwmq2Y8gf+JgJz/QQ8grDj8qhWzEA+EXgBaQjt5QWXkxpx+w+5Lag0edT2
 rL9jmki4Tggmpj6KvMjMZ2B6T1vEmqCZKyk= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 335up66pkq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 27 Aug 2020 11:09:58 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.198) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 27 Aug 2020 11:09:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k6A6k/DDndYufg6Movg7cMDEj07Bus4CAkOBfEjWoVDi8D3HDX8XsXbAcrxpyHEUtzNWWMmrbjkAsECVSFWBEsBkqaW+7ekOdxSspRSYTpGVDZtJkKAgEN8BecUYyED/ZRvby2oIv7gkL1CY4Xn+JhEJaGTJd1NfuaaeTCAg2yszhpd5gYVX5olL/pt5xfRPVZ1mjQeJAYstr63OcogtELmQ46Ew/EdxNP0IKgSh4kuR35lwq9mupI0KF4ZrTeF4OjsCGvOXKoerRNXn2m7BwY6olCJiq+OhQ+bkaQgy+Gen79ACUmdeVwJge9V1JgnmP2Guo20H01YaCW3rxdt9zQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lwncnA3niud5vNina8M3umpf6zQykgW2bPp9cMoK6l0=;
 b=dZuy7kD1WDC14ywm44Mb5oBRD/9wlK4p/ZIPk8VDPwSptOt3T8kk84YNIpvbgwowWOhs0Ksi/LWilWqna0+OQvfJHvURH2eKEvzYVMjmyCFgCSfUoODDRvrJa68tSzvvtnLO6sp6bzUoTU2lzAUEBZYzjBxpbcSqwMdIQO4iqz6McR1v6XiN56BG1JbYkh04P0EQSngLvlNGQCOhYRXHirVhxrJ21GKtP4FP0k+f7mcfMuM7KabowABnuoAjQd3MGt/0Tce6alSgI/X5Z8fsCovqfbfhM0fN80+LG0bygxWd9pB6cYIEbaB/kpe2j5hPvygSz/MuBlYgl50g/rcTlw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lwncnA3niud5vNina8M3umpf6zQykgW2bPp9cMoK6l0=;
 b=UGgmr/9ebkBDJYigsgQAxs9+FGPBbMaqfmGO+HlPCn8wXKpu/WoO34D5zTUnCpitr3Ph9lDH1oLeWtpH7VvaGuWkTwG9h7xqOpsPqy/gAMnpUrBzUIt/tc1m2dBe07gqSb2YfMWksVySArwKuc476zt4zXNQmIsYkpzsApcXdfI=
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB3000.namprd15.prod.outlook.com (2603:10b6:a03:b1::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3326.19; Thu, 27 Aug
 2020 18:09:55 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::56b:2925:8762:2d80]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::56b:2925:8762:2d80%7]) with mapi id 15.20.3326.021; Thu, 27 Aug 2020
 18:09:55 +0000
Subject: Re: [PATCH bpf-next 2/5] bpf: add main_thread_only customization for
 task/task_file iterators
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
References: <20200827000618.2711826-1-yhs@fb.com>
 <20200827000620.2711963-1-yhs@fb.com>
 <CAEf4BzYBQVX-YQyZiJe+xrMUmk_k+mU=Q-RNULeS4pt-YyzQUA@mail.gmail.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <784f27f8-552a-41e8-c8c4-a4ea0b590884@fb.com>
Date:   Thu, 27 Aug 2020 11:09:50 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.11.0
In-Reply-To: <CAEf4BzYBQVX-YQyZiJe+xrMUmk_k+mU=Q-RNULeS4pt-YyzQUA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR17CA0025.namprd17.prod.outlook.com
 (2603:10b6:208:15e::38) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from 255.255.255.255 (255.255.255.255) by MN2PR17CA0025.namprd17.prod.outlook.com (2603:10b6:208:15e::38) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3326.19 via Frontend Transport; Thu, 27 Aug 2020 18:09:53 +0000
X-Originating-IP: [2620:10d:c091:480::1:2638]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a41354d6-653b-406b-151e-08d84ab4667b
X-MS-TrafficTypeDiagnostic: BYAPR15MB3000:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB30000149759BA97AB87C2AC6D3550@BYAPR15MB3000.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nYGMPtvEJnkm1Km2X9LZHuyDYyEkSgkZK7YYMj5XmuRUFmg2uYTK300WSCxmpoH4FfJWgtpgW2WgJD488NnSM0Qb3gbyKhJx+LdyTe2vsDpEZbcDh3VUuFu/8IH/KztX6z4uZmivYro//+uadVQ5xvsD4fXxK3d0FSr69QeZBTcD6/HWiudHwdMbSz0yu/OQmF8GkUFrenxyYvq+SSE/yOEMUHPjcDG3yd3Pzex7vDfcHjsUQTiZV+ZjH/YWheCJR9ADcbQe3gmBmFbKDO5an1g7BTzul/FtiUtdwD9dU0dIeNP+30L9BtDVvF1XqOm9/MTSKPMxQrmYUPuhPLUI8o5DjYswAaeBNGK2DqBWJCMF2px305+7GBWEEKIpwgWO
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(376002)(39860400002)(136003)(396003)(366004)(2906002)(6486002)(31686004)(5660300002)(54906003)(36756003)(478600001)(186003)(53546011)(52116002)(83380400001)(4326008)(8936002)(8676002)(2616005)(956004)(86362001)(66556008)(16576012)(316002)(31696002)(66946007)(66476007)(6916009)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: v1HaL3Ftodbyxdj7Y8ALvV/It+dfU4DvxDMNGn4mc31cn6wpLr2x/w8j36r1yk3VYSxw0pBbaLo3lZLlzrIJbzrrDZF29ztAERdoprdir07oC5U5s4JIX01e9Sq5DU/U8OIw5DfBx1h2YiGVpy4JpemRElwQra7u/5tzD3p3uheqYFDxgYO3v2orGd5+78irQ9B5FJfIF/3frNQ1QuTdemU9aoV2Yfb41+6KLOcsBlEtKb2mhcqRM7wZyX8YFrfYv4L7On6ZxASk29uSuL3cEGgu7VbCBo2odf15vVyun1j8OIg5CDaxSAKKgUF4pwdpBRpWkFdYwj8ha9YxmqBEgjTu+O94uk2nN0ZIUoyteZK/RL1uyCFnjUJcZICfHgHo/ojwwc4Zd61Pb6Qq4x0NXK1nnw6TWbuIUkWOvtjh0QlUQNCPt6cwIky5yD53/ib9uS+qZgUArjayeIfqhd//mGG6GDo2qW4D2ACTDWIbgJosGYOYA4CgYKEr/mWUlyCIJt8HGzoeYfjpxfSpLytSIO2PFlVlwzVar8VxMFt7KyUolcw2fqt2ltfpS2bXgPUnMgOMrVBjnIawYDf/7jC2u8O9rhfeLbQ3DGjb5snz+XnIVXD3orq2IwGteX90eLJKUrutnW0eCUShgYKro9MXXTQr+j+yLDrOwPzZBTLi6h6vhnq3/OZ2JLNfMdHy+zPE
X-MS-Exchange-CrossTenant-Network-Message-Id: a41354d6-653b-406b-151e-08d84ab4667b
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Aug 2020 18:09:55.1403
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RJu1/l3hGQM2JSI0n2Qy+tgdvpcaQ+ovK851CFX45neGzDjIFvqZtElrDwK2cKpb
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3000
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-27_10:2020-08-27,2020-08-27 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0
 priorityscore=1501 mlxlogscore=999 malwarescore=0 spamscore=0
 clxscore=1015 impostorscore=0 suspectscore=0 phishscore=0 bulkscore=0
 adultscore=0 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2008270136
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/26/20 10:07 PM, Andrii Nakryiko wrote:
> On Wed, Aug 26, 2020 at 5:07 PM Yonghong Song <yhs@fb.com> wrote:
>>
>> Currently, task and task_file by default iterates through
>> all tasks. For task_file, by default, all files from all tasks
>> will be traversed.
>>
>> But for a user process, the file_table is shared by all threads
>> of that process. So traversing the main thread per process should
>> be enough to traverse all files and this can save a lot of cpu
>> time if some process has large number of threads and each thread
>> has lots of open files.
>>
>> This patch implemented a customization for task/task_file iterator,
>> permitting to traverse only the kernel task where its pid equal
>> to tgid in the kernel. This includes some kernel threads, and
>> main threads of user processes. This will solve the above potential
>> performance issue for task_file. This customization may be useful
>> for task iterator too if only traversing main threads is enough.
>>
>> Signed-off-by: Yonghong Song <yhs@fb.com>
>> ---
>>   include/linux/bpf.h            |  3 ++-
>>   include/uapi/linux/bpf.h       |  5 ++++
>>   kernel/bpf/task_iter.c         | 46 +++++++++++++++++++++++-----------
>>   tools/include/uapi/linux/bpf.h |  5 ++++
>>   4 files changed, 43 insertions(+), 16 deletions(-)
>>
>> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
>> index a6131d95e31e..058eb9b0ba78 100644
>> --- a/include/linux/bpf.h
>> +++ b/include/linux/bpf.h
>> @@ -1220,7 +1220,8 @@ int bpf_obj_get_user(const char __user *pathname, int flags);
>>          int __init bpf_iter_ ## target(args) { return 0; }
>>
>>   struct bpf_iter_aux_info {
>> -       struct bpf_map *map;
>> +       struct bpf_map *map;    /* for iterator traversing map elements */
>> +       bool main_thread_only;  /* for task/task_file iterator */
> 
> As a user of task_file iterator I'd hate to make this decision,
> honestly, especially if I can't prove that all processes share the
> same file table (I think clone() syscall allows to do weird
> combinations like that, right?). It does make sense for a task/

Right. the clone() syscall permits different kinds of sharing,
sharing address space and sharing files are separated. It is possible
that address space is shared and files are not shared. That is
why I want to add flags for task_file so that if user knows
they do not have cases where address space shared and files not
shared, they can use main_thread_only to improve performance.

> iterator, though, if I need to iterate a user-space process (group of
> tasks). So can we do this:
> 
> 1a. Either add a new bpf_iter type process/ (or in kernel lingo
> task_group/) to iterate only main threads (group_leader in kernel
> lingo);
> 1b. Or make this main_thread_only an option for only a task/ iterator
> (and maybe call it "group_leader_only" or something to reflect kernel
> terminology?)

The following is the kernel pid_type definition,

enum pid_type
{
         PIDTYPE_PID,
         PIDTYPE_TGID,
         PIDTYPE_PGID,
         PIDTYPE_SID,
         PIDTYPE_MAX,
};

Right now, task iterator is traversed following
PIDTYPE_PID, i.e., every tasks in the system.

To iterate through main thread, we need to traverse following
PIDTYPE_TGID.

In the future, it is possible, people want to traverse
following PIDTYPE_PGID (process group) or PIDTYPE_SID (session).

Or we might have other customization, e.g., cgroup_id, which can
be filtered in the bpf program, but in-kernel filtering can
definitely improve performance.

So I prefer 1b.

Yes, naming is hard.
The name "main_thread_only" is mostly from userspace perspective.
"group_leader_only" might not be good as it may be confused with
possible future process group.

> 
> 2. For task/file iterator, still iterate all tasks, but if the task's
> files struct is the same as group_leader's files struct, then go to
> the next one. This should eliminate tons of duplication of iterating
> the same files over and over. It would still iterate a bunch of tasks,
> but compared to the number of files that's generally a much smaller
> number, so should still give sizable savings. I don't think we need an
> extra option for this, tbh, this behavior was my intuitive
> expectation, so I don't think you'll be breaking any sane user of this
> iterator.

What you suggested makes sense. for task_file iterator, we only promise
to visit all files from all tasks. We can do necessary filtering to 
remove duplicates in the kernel and did not break promise.
I will remove customization from task_file iterator.

> 
> Disclaimer: I haven't got a chance to look through kernel code much,
> so I'm sorry if what I'm proposing is something that is impossible to
> implement or extremely hard/unreliable. But thought I'll put this idea
> out there before we decide on this.
> 
> WDYT?
> 
> [...]
> 
