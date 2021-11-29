Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF3EE4611F0
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 11:16:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237668AbhK2KTr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 05:19:47 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:10164 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232318AbhK2KRp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 05:17:45 -0500
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AT9lO29006206;
        Mon, 29 Nov 2021 10:13:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : references : date : in-reply-to : message-id : mime-version :
 content-type; s=pp1; bh=bTykWiZilsgvIEF8053GRPR7j2ZWFDbGpwj1KiG5Zb8=;
 b=ZRE/D4iZlWQha3YL2zQJ5zfjlQOQWX3mJjlDDOtDsbip+iNART4SQ9TYsBVlt6sQ9Lvg
 lhcgSJ/vR8ria0U2HK7ve1FWaeu13ghyyPlTALSRwVqkoO5J4f+oRgQ3GJ1jENxs4mlD
 wBCb/yvDvJfJrIqHSupTFsxkmGEVI8h2KHSVa4efgopiXMJNh2WvFLOJ1Lp9kiK1Zx2e
 YoMGsqehghyuHXuDSSMvq/2AR6MJAfB5XHx5vadvs6QPCRefk3mCDyGkHdvUQXt0KudR
 EzqoKVBLFwyoApWg7k40rBgQ0UjvJDgR2H5t8gDOMcDc24QUtZA4STRUEYv8NTKgCZ7f Nw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cmvht8gh0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 29 Nov 2021 10:13:39 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1AT9nGP2013939;
        Mon, 29 Nov 2021 10:13:38 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cmvht8gg8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 29 Nov 2021 10:13:38 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1ATADJsi020937;
        Mon, 29 Nov 2021 10:13:35 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma01fra.de.ibm.com with ESMTP id 3ckca9ajq7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 29 Nov 2021 10:13:35 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1ATADWKX22544770
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 29 Nov 2021 10:13:32 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 83AC611C04A;
        Mon, 29 Nov 2021 10:13:32 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E328911C04C;
        Mon, 29 Nov 2021 10:13:31 +0000 (GMT)
Received: from tuxmaker.linux.ibm.com (unknown [9.152.85.9])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Mon, 29 Nov 2021 10:13:31 +0000 (GMT)
From:   Sven Schnelle <svens@linux.ibm.com>
To:     Yafang Shao <laoar.shao@gmail.com>
Cc:     akpm@linux-foundation.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-perf-users@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, oliver.sang@intel.com, lkp@intel.com,
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
Date:   Mon, 29 Nov 2021 11:13:31 +0100
In-Reply-To: <20211120112738.45980-8-laoar.shao@gmail.com> (Yafang Shao's
        message of "Sat, 20 Nov 2021 11:27:38 +0000")
Message-ID: <yt9d35nf1d84.fsf@linux.ibm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.0.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: tCV3Q3i4lUvrnwlJ9X-_0skwr0F3PEoJ
X-Proofpoint-ORIG-GUID: 9MlKZj6a0c4TU5bozMc3VrKzCk8L9suc
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-29_07,2021-11-28_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 clxscore=1011
 bulkscore=0 phishscore=0 impostorscore=0 lowpriorityscore=0
 priorityscore=1501 mlxscore=0 mlxlogscore=999 malwarescore=0 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111290049
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Yafang Shao <laoar.shao@gmail.com> writes:

> As the sched:sched_switch tracepoint args are derived from the kernel,
> we'd better make it same with the kernel. So the macro TASK_COMM_LEN is
> converted to type enum, then all the BPF programs can get it through BTF.
>
> The BPF program which wants to use TASK_COMM_LEN should include the header
> vmlinux.h. Regarding the test_stacktrace_map and test_tracepoint, as the
> type defined in linux/bpf.h are also defined in vmlinux.h, so we don't
> need to include linux/bpf.h again.
>
> Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
> Acked-by: Andrii Nakryiko <andrii@kernel.org>
> Acked-by: David Hildenbrand <david@redhat.com>
> Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> Cc: Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
> Cc: Andrii Nakryiko <andrii.nakryiko@gmail.com>
> Cc: Michal Miroslaw <mirq-linux@rere.qmqm.pl>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Matthew Wilcox <willy@infradead.org>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Al Viro <viro@zeniv.linux.org.uk>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Petr Mladek <pmladek@suse.com>
> ---
>  include/linux/sched.h                                   | 9 +++++++--
>  tools/testing/selftests/bpf/progs/test_stacktrace_map.c | 6 +++---
>  tools/testing/selftests/bpf/progs/test_tracepoint.c     | 6 +++---
>  3 files changed, 13 insertions(+), 8 deletions(-)
>
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index 78c351e35fec..cecd4806edc6 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -274,8 +274,13 @@ struct task_group;
>  
>  #define get_current_state()	READ_ONCE(current->__state)
>  
> -/* Task command name length: */
> -#define TASK_COMM_LEN			16
> +/*
> + * Define the task command name length as enum, then it can be visible to
> + * BPF programs.
> + */
> +enum {
> +	TASK_COMM_LEN = 16,
> +};

This breaks the trigger-field-variable-support.tc from the ftrace test
suite at least on s390:

echo 'hist:keys=next_comm:wakeup_lat=common_timestamp.usecs-$ts0:onmatch(sched.sched_waking).wakeup_latency($wakeup_lat,next_pid,sched.sched_waking.prio,next_comm) if next_comm=="ping"'
linux/tools/testing/selftests/ftrace/test.d/trigger/inter-event/trigger-field-variable-support.tc: line 15: echo: write error: Invalid argument

I added a debugging line into check_synth_field():

[   44.091037] field->size 16, hist_field->size 16, field->is_signed 1, hist_field->is_signed 0

Note the difference in the signed field.

Regards
Sven
