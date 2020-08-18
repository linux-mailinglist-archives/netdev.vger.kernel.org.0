Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45C6D248C8B
	for <lists+netdev@lfdr.de>; Tue, 18 Aug 2020 19:08:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728590AbgHRRH6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 13:07:58 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:61102 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728122AbgHRRHn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Aug 2020 13:07:43 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07IGoHV7027162;
        Tue, 18 Aug 2020 10:07:27 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=qyDADlo3irZFdJq63p3DBbkpOJ+F0GEENE0Rnr29thI=;
 b=lqCT2nRPWaKEKcnmWHp/b3TMQ0kQKAl1hAqwqlt0P/Hpgnxx2zTr4slf0jAZwI11licZ
 +WESFQe/5qTYPn2GYQ/tinN0W4sJJpqlbIySYe9dH42twN2H1SSauRw3OZJ9EPjO4sBY
 SRPrPwtE1T1UWqxbtJMJuYqWtSK38g4G+Ks= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3304pauu74-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 18 Aug 2020 10:07:27 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.175) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 18 Aug 2020 10:07:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iuexjy5m5kXlI4MayToq77fYs3RfrOoiWwpbHrmy4mJklF8tdkIfjzkoweZ3soTT67v4fpOFczqhXfRnr0h9bGeHHp/gRott47sQsjFIc7UzteDQjEElCu8Svms7HLxYR24eMWmSte2g2as2rUykI26r7ZYxVtsEfZC+/No1bYNpYNYmQZHvnp9Hi+0BB6m4P6uSP0xdu4ecSIv65aSzWUPU7kooj0Te/rhIsL+faxZP8kDkZG8qGjYVqJkNZkRrwMvGMzV5AgyfNO3HK12Z2mnOM1MUk8bYIW5uO9w3gTfxu+hlUjnxXpPsCMlHa0XetKFm+qFSNvKG5fahMuLjQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qyDADlo3irZFdJq63p3DBbkpOJ+F0GEENE0Rnr29thI=;
 b=UiMdRfF4Ix5o6L3iPUMDEvTEawfspmRCqjr7xquyAoIDpw8n9xeiTrij7PgRxmWij3InosaN6VGK3WJiMpCP20zB/RKXWCzFMKg1jf1XSqmzAln9n/IkP0E0v/KTrjv91rgtoDgqKdAzQTzFmzBRBhaO6Si0fobuPNNTRN9Ssf9mvegFul+ae9lUquh7ECB1BWcPkUGoTeFkpQxBVzXlSdDfzzT235rtaVdjmMA1uuRQE5z8kMxrMneYb8ZxkceU+hVGzlRyXbqMwt8UO0hROiTs2TlTsE+aV60udm+9FSl0NYj41pkvVCvRkyyLTcq8wMZqq/DfqBAh4RIc+aK/PQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qyDADlo3irZFdJq63p3DBbkpOJ+F0GEENE0Rnr29thI=;
 b=W2vnv4QzIUD0XlQvp++wSTl1U8Uj0qmyxM3CaeTvMu4bvmVDTjAxi3kpdEV5oIZPU3xP7oTjZ4Uyon0f8Gdbw78IpxSQCHzz3/KbzO8tOft90+o8Zg4UW6F4dgjeMbV93GxHH2+I70LpgBjPnWljtWvfxH6jtBSJAta0A7axpzk=
Authentication-Results: surriel.com; dkim=none (message not signed)
 header.d=none;surriel.com; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2584.namprd15.prod.outlook.com (2603:10b6:a03:150::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3283.16; Tue, 18 Aug
 2020 17:07:19 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::56b:2925:8762:2d80]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::56b:2925:8762:2d80%7]) with mapi id 15.20.3283.028; Tue, 18 Aug 2020
 17:07:19 +0000
Subject: Re: [PATCH bpf 1/2] bpf: fix a rcu_sched stall issue with bpf
 task/task_file iterator
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Rik van Riel <riel@surriel.com>
References: <20200818162408.836759-1-yhs@fb.com>
 <20200818162408.836816-1-yhs@fb.com>
 <CAEf4BzY=YskvOg+cr_XFF42kDWOL3T1mzx=vAoQcS2oAzPOUsQ@mail.gmail.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <dec87ef2-07c7-93ec-7a27-1902f257fb18@fb.com>
Date:   Tue, 18 Aug 2020 10:07:14 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.11.0
In-Reply-To: <CAEf4BzY=YskvOg+cr_XFF42kDWOL3T1mzx=vAoQcS2oAzPOUsQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR16CA0043.namprd16.prod.outlook.com
 (2603:10b6:208:234::12) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c0a8:11e8::10d3] (2620:10d:c091:480::1:a06c) by MN2PR16CA0043.namprd16.prod.outlook.com (2603:10b6:208:234::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3283.15 via Frontend Transport; Tue, 18 Aug 2020 17:07:17 +0000
X-Originating-IP: [2620:10d:c091:480::1:a06c]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5e11160a-c8e0-4224-cc1d-08d843992a73
X-MS-TrafficTypeDiagnostic: BYAPR15MB2584:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB2584F6EA316B0CC0A5B68BA9D35C0@BYAPR15MB2584.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lyDQphnV+UCKE+V5PoN/rpk0mCZSu11643zi6Eh+hiXnY8ahGUAjDYQ+a7fWBJK2MecXCMBieaJNYPS21YH4McmZa346Pj4JBY5FMvE0NaD4VKqHdR7GEtAJvz9bf6zpqYXgfnwwaXKmwvODbacJRLCLkUw3unFToPTuExsoxBpD8yrGOjLJhfVLPWw7hQJ24TLoZSrusLI7j/ItEoaSRnnAJJVjuqLoWqgi8bjEaTJtscqWJO1b0mTT66SnITJFDcjgtp9Emn5ZWpnkKue9tTXHNA2XuhzGDPKWY1e7nrtO+Ma8bFNTEwULky0WDlZ3NHtpQWGHXoEPih50EtiWqWbArtUUbjQtiJSytfLHIz+VcO+C8ZO8CkPN2CVXwUwg
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(39860400002)(376002)(136003)(346002)(396003)(16526019)(66946007)(86362001)(6916009)(31696002)(36756003)(83380400001)(186003)(6666004)(66556008)(53546011)(6486002)(478600001)(2906002)(52116002)(2616005)(316002)(66476007)(5660300002)(31686004)(4326008)(8936002)(8676002)(54906003)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: 6f7fVN3Bb3Klw6QPLWGmYmVUtur12WiQds1Tv12SqOLn8C6N64VLgFz430n9X3pqgYG1A1LRrzJRvfnANJmJ9OU4zEnr/PcqOU8DiZSKgVvdR6DB31dyrZwBf+ce6fAE/1Mw8SrAeaiCNcZpy8OyzW1ElnRaSuihJ2NuGjaIAP/9nrXc/RK4+KrIFGEAj6m1Gxp2AWjUaahLkHLXfaNsif7Z5tUAShvh3BwLlWb82uopivQWjK2BMwPKDHo1qrhmgX11r6DOkPSdvIdufH0z09dDJU4SddFz1zBT0SHcsLSns2gmwqfioEulHBBL4fkGus4xVEN1P+VQl//OYyS0VtTtX+3bSFXENlkFMJTyx5XLSwMp83fVHr2RaRxXNGppezwBTI/hO/BEf3ClPVEmu/O3yZWkLr411i1FY40oJfnAnfPg0ivT+Zah8IkAirqo73xiez3CaEprg2nl7Jt2MXyRSxqZtB44S8d0lvcY+DTvrOw5ABgUIeSWrhFokP/KVCaf9bVuAcX/EvepRI/UIkJVwXczLuNaptc+/fayeSLDBtxw6ygIKHrcW2jxgdka479xZUyAe09ZSMLK2Rn7gOLwE1CHSW3z9Bh0dsWSBB7HA1gtXg4f/glsgf1fv2+8L7YnvkKuT3lwsQSIr1C3hwNLo2MYsmJaxU48gl3nWTJq5Ye+R8hXGQhgjbL5w8HX
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e11160a-c8e0-4224-cc1d-08d843992a73
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2020 17:07:19.5733
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GON9lHWDP76FNGOkNLfnsQ8Q1rSDRNicQUym0ScEPxh8F4Om1tlm2R/GzaJkl91d
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2584
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-18_11:2020-08-18,2020-08-18 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0 mlxscore=0
 lowpriorityscore=0 bulkscore=0 impostorscore=0 adultscore=0 spamscore=0
 phishscore=0 priorityscore=1501 suspectscore=0 clxscore=1015
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008180120
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/18/20 9:48 AM, Andrii Nakryiko wrote:
> On Tue, Aug 18, 2020 at 9:26 AM Yonghong Song <yhs@fb.com> wrote:
>>
>> In our production system, we observed rcu stalls when
>> 'bpftool prog` is running.
> 
> [...]
> 
>>
>> Note that `bpftool prog` actually calls a task_file bpf iterator
>> program to establish an association between prog/map/link/btf anon
>> files and processes.
>>
>> In the case where the above rcu stall occured, we had a process
>> having 1587 tasks and each task having roughly 81305 files.
>> This implied 129 million bpf prog invocations. Unfortunwtely none of
>> these files are prog/map/link/btf files so bpf iterator/prog needs
>> to traverse all these files and not able to return to user space
>> since there are no seq_file buffer overflow.
>>
>> The fix is to add cond_resched() during traversing tasks
>> and files. So voluntarily releasing cpu gives other tasks, e.g.,
>> rcu resched kthread, a chance to run.
> 
> What are the performance implications of doing this for every task
> and/or file? Have you benchmarked `bpftool prog` before/after? What
> was the difference?

The cond_resched() internally has a condition should_resched()
to check whether rescheduling should be done or not. Most kernel
invocations (if not all) just call cond_resched() without
additional custom logic to guess when to call cond_resched().
I suppose should_resched() should cheaper enough already.

Maybe Rik can comment here.

Regarding to the measurement, I did measure with 'strace -T ./bpftool 
prog` for 'read' syscall to complete with and without my patch.

e.g.,
read(7, 
"#\0\0\0\322\23\0\0tcpeventd\0\0\0\0\0\0\0)\0\0\0\322\23\0\0"..., 4096) 
= 4080 <27.094797>
or
read(7, 
"#\0\0\0\322\23\0\0tcpeventd\0\0\0\0\0\0\0)\0\0\0\322\23\0\0"..., 4096) 
= 4080 <34.281563>

The time various a lot during different runs. But based on
my observations, with and without cond_resched(), the range
of read() elapse time roughly the same.

> 
> I wonder if it's possible to amortize those cond_resched() and call
> them only ever so often, based on CPU time or number of files/tasks
> processed, if cond_resched() does turn out to slow bpf_iter down.
> 
>>
>> Cc: Paul E. McKenney <paulmck@kernel.org>
>> Signed-off-by: Yonghong Song <yhs@fb.com>
>> ---
>>   kernel/bpf/task_iter.c | 4 ++++
>>   1 file changed, 4 insertions(+)
>>
>> diff --git a/kernel/bpf/task_iter.c b/kernel/bpf/task_iter.c
>> index f21b5e1e4540..885b14cab2c0 100644
>> --- a/kernel/bpf/task_iter.c
>> +++ b/kernel/bpf/task_iter.c
>> @@ -27,6 +27,8 @@ static struct task_struct *task_seq_get_next(struct pid_namespace *ns,
>>          struct task_struct *task = NULL;
>>          struct pid *pid;
>>
>> +       cond_resched();
>> +
>>          rcu_read_lock();
>>   retry:
>>          pid = idr_get_next(&ns->idr, tid);
>> @@ -137,6 +139,8 @@ task_file_seq_get_next(struct bpf_iter_seq_task_file_info *info,
>>          struct task_struct *curr_task;
>>          int curr_fd = info->fd;
>>
>> +       cond_resched();
>> +
>>          /* If this function returns a non-NULL file object,
>>           * it held a reference to the task/files_struct/file.
>>           * Otherwise, it does not hold any reference.
>> --
>> 2.24.1
>>
