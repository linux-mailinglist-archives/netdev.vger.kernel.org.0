Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E812F461803
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 15:24:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377765AbhK2O12 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 09:27:28 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:42042 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S232511AbhK2OZ2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 09:25:28 -0500
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1ATDlFr0028332;
        Mon, 29 Nov 2021 14:21:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : references : date : in-reply-to : message-id : mime-version :
 content-type; s=pp1; bh=SDxQU0Cf2tzKKlX7o2UXE1teEX8a7e551zSq540YKLk=;
 b=d+crWRJPa5r57bLvIQzzuevNedkyG3+niNSYWU9Swfp2n///dxmoX+dZO+LB4CVZ71bN
 5c5IcI4VvQFzEWHfWhl38qeOnM5aj4PT5wNRBfAgpyJhpvI1siJ/TTn+/uLBq2W73OKO
 aFazRIgZeoxM30M3r+yoWawVO9Gi8zKqhTdtc9k8IatSEcmSOh5NxInE6bp/mr45vUHJ
 7EVLWfbOz8YunoJmYa4BvTgth4e8v/lscPHGWM7ZFlhU1SZfK+/at1qyct0ZiAT/eBKX
 3lJGXQjMoKTdMbVS1FchE7/jju5VIOxLwa5smjQAZhS1sVAj9hfPoOr5iqSnxgQsJRne JA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3cn026rxka-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 29 Nov 2021 14:21:30 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1ATDllAl029213;
        Mon, 29 Nov 2021 14:21:30 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3cn026rxhx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 29 Nov 2021 14:21:30 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1ATEDKn4001853;
        Mon, 29 Nov 2021 14:21:27 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma05fra.de.ibm.com with ESMTP id 3ckca94tnx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 29 Nov 2021 14:21:27 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1ATELODV11272478
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 29 Nov 2021 14:21:25 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C7476AE04D;
        Mon, 29 Nov 2021 14:21:24 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3C90AAE072;
        Mon, 29 Nov 2021 14:21:24 +0000 (GMT)
Received: from tuxmaker.linux.ibm.com (unknown [9.152.85.9])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Mon, 29 Nov 2021 14:21:24 +0000 (GMT)
From:   Sven Schnelle <svens@linux.ibm.com>
To:     Yafang Shao <laoar.shao@gmail.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "linux-perf-use." <linux-perf-users@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org, Linux MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel test robot <oliver.sang@intel.com>,
        kbuild test robot <lkp@intel.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        David Hildenbrand <david@redhat.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Michal Miroslaw <mirq-linux@rere.qmqm.pl>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Matthew Wilcox <willy@infradead.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Kees Cook <keescook@chromium.org>,
        Petr Mladek <pmladek@suse.com>
Subject: Re: [PATCH v2 7/7] tools/testing/selftests/bpf: replace open-coded
 16 with TASK_COMM_LEN
References: <20211120112738.45980-1-laoar.shao@gmail.com>
        <20211120112738.45980-8-laoar.shao@gmail.com>
        <yt9d35nf1d84.fsf@linux.ibm.com>
        <CALOAHbDtqpkN4D0vHvGxTSpQkksMWtFm3faMy0n+pazxN_RPPg@mail.gmail.com>
Date:   Mon, 29 Nov 2021 15:21:23 +0100
In-Reply-To: <CALOAHbDtqpkN4D0vHvGxTSpQkksMWtFm3faMy0n+pazxN_RPPg@mail.gmail.com>
        (Yafang Shao's message of "Mon, 29 Nov 2021 21:41:11 +0800")
Message-ID: <yt9d35nfvy8s.fsf@linux.ibm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.0.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 7Xp9iYRAqWlAkU7aNJskL8ZvHI5hqD4L
X-Proofpoint-ORIG-GUID: 4I5asdX1Ck6krCqWTqdjTyeMLwa83xva
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-29_08,2021-11-28_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 mlxscore=0
 bulkscore=0 mlxlogscore=999 spamscore=0 priorityscore=1501 suspectscore=0
 clxscore=1015 adultscore=0 impostorscore=0 phishscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111290071
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Yafang Shao <laoar.shao@gmail.com> writes:

> On Mon, Nov 29, 2021 at 6:13 PM Sven Schnelle <svens@linux.ibm.com> wrote:
>> > diff --git a/include/linux/sched.h b/include/linux/sched.h
>> > index 78c351e35fec..cecd4806edc6 100644
>> > --- a/include/linux/sched.h
>> > +++ b/include/linux/sched.h
>> > @@ -274,8 +274,13 @@ struct task_group;
>> >
>> >  #define get_current_state()  READ_ONCE(current->__state)
>> >
>> > -/* Task command name length: */
>> > -#define TASK_COMM_LEN                        16
>> > +/*
>> > + * Define the task command name length as enum, then it can be visible to
>> > + * BPF programs.
>> > + */
>> > +enum {
>> > +     TASK_COMM_LEN = 16,
>> > +};
>>
>> This breaks the trigger-field-variable-support.tc from the ftrace test
>> suite at least on s390:
>>
>> echo
>> 'hist:keys=next_comm:wakeup_lat=common_timestamp.usecs-$ts0:onmatch(sched.sched_waking).wakeup_latency($wakeup_lat,next_pid,sched.sched_waking.prio,next_comm)
>> if next_comm=="ping"'
>> linux/tools/testing/selftests/ftrace/test.d/trigger/inter-event/trigger-field-variable-support.tc: line 15: echo: write error: Invalid argument
>>
>> I added a debugging line into check_synth_field():
>>
>> [   44.091037] field->size 16, hist_field->size 16, field->is_signed 1, hist_field->is_signed 0
>>
>> Note the difference in the signed field.
>>
>
> Hi Sven,
>
> Thanks for the report and debugging!
> Seems we should explicitly define it as signed ?
> Could you pls. help verify it?
>
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index cecd4806edc6..44d36c6af3e1 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -278,7 +278,7 @@ struct task_group;
>   * Define the task command name length as enum, then it can be visible to
>   * BPF programs.
>   */
> -enum {
> +enum SignedEnum {
>         TASK_COMM_LEN = 16,
>  };

Umm no. What you're doing here is to define the name of the enum as
'SignedEnum'. This doesn't change the type. I think before C++0x you
couldn't force an enum type.

Regards
Sven
