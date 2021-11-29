Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94AC5461D3C
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 18:59:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350787AbhK2SC6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 13:02:58 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:28338 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S235871AbhK2SA6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 13:00:58 -0500
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1ATHlSjv030769;
        Mon, 29 Nov 2021 17:56:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : references : date : in-reply-to : message-id : mime-version :
 content-type; s=pp1; bh=ji692FR3Mz1r0MiNEkxX/c6ZHq97AskB3w5QWFypXGo=;
 b=b16Q7OX+ghgVZuUSv4mHyRHEiyEIFbqnMfmdr6rLvcDGDyAo5hvhzXMqnLZfBoWRyUTZ
 w4biEwhOxnKzV0pdmWp/5FQ54zKQvLgntaJLjsVw1xCfe9JThX1ojJo0HE5nz5C1gH4B
 mqEloUmu/Zlybw8u3MYRV7Qv7iqQJ/LytQHNyIsJiqBudHaMP3jIyCv08x+8NhfP3/eb
 14dkYA8a4IkBgVtYiExmtaoFficoc4lGAeX4SKfyzxEjIbXXPy9ppY2ObULM1G3SXfeU
 Bl0UZrje3AGFt6sy+JQy7F/iTSi/8FJnq1oBRKje74rp2l8xKh5ndSXMJFDaYwLudI/V WQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3cn3jsg61x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 29 Nov 2021 17:56:59 +0000
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1ATHmXfk001537;
        Mon, 29 Nov 2021 17:56:58 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3cn3jsg61a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 29 Nov 2021 17:56:58 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1ATHsCNU006974;
        Mon, 29 Nov 2021 17:56:56 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma06ams.nl.ibm.com with ESMTP id 3ckbxjqgk2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 29 Nov 2021 17:56:56 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1ATHus0V29360440
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 29 Nov 2021 17:56:54 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E678EAE055;
        Mon, 29 Nov 2021 17:56:53 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5283EAE053;
        Mon, 29 Nov 2021 17:56:53 +0000 (GMT)
Received: from tuxmaker.linux.ibm.com (unknown [9.152.85.9])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Mon, 29 Nov 2021 17:56:53 +0000 (GMT)
From:   Sven Schnelle <svens@linux.ibm.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Yafang Shao <laoar.shao@gmail.com>, akpm@linux-foundation.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-perf-users@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        oliver.sang@intel.com, lkp@intel.com,
        Andrii Nakryiko <andrii@kernel.org>,
        David Hildenbrand <david@redhat.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Michal Miroslaw <mirq-linux@rere.qmqm.pl>,
        Peter Zijlstra <peterz@infradead.org>,
        Matthew Wilcox <willy@infradead.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Kees Cook <keescook@chromium.org>,
        Petr Mladek <pmladek@suse.com>,
        Tom Zanussi <zanussi@kernel.org>
Subject: Re: [PATCH v2 7/7] tools/testing/selftests/bpf: replace open-coded
 16 with TASK_COMM_LEN
References: <20211120112738.45980-1-laoar.shao@gmail.com>
        <20211120112738.45980-8-laoar.shao@gmail.com>
        <yt9d35nf1d84.fsf@linux.ibm.com>
        <20211129123043.5cfd687a@gandalf.local.home>
Date:   Mon, 29 Nov 2021 18:56:53 +0100
In-Reply-To: <20211129123043.5cfd687a@gandalf.local.home> (Steven Rostedt's
        message of "Mon, 29 Nov 2021 12:30:43 -0500")
Message-ID: <yt9dsfvesv4q.fsf@linux.ibm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.0.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: htLDRgK8ppBcOGDZPtY3fNCU6FdZEDnP
X-Proofpoint-ORIG-GUID: IvWG1lU-w3IH0aApjQ2nUWGJ9ljZGTna
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-29_10,2021-11-28_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011 mlxlogscore=999
 malwarescore=0 bulkscore=0 spamscore=0 impostorscore=0 phishscore=0
 priorityscore=1501 mlxscore=0 adultscore=0 suspectscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111290082
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Steven Rostedt <rostedt@goodmis.org> writes:

> On Mon, 29 Nov 2021 11:13:31 +0100
> Sven Schnelle <svens@linux.ibm.com> wrote:
>
>
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
>
> That should not break on strings.
>
> Does this fix it (if you keep the patch)?

It does. Thanks!

> -- Steve
>
> diff --git a/kernel/trace/trace_events_hist.c b/kernel/trace/trace_events_hist.c
> index 9555b8e1d1e3..319f9c8ca7e7 100644
> --- a/kernel/trace/trace_events_hist.c
> +++ b/kernel/trace/trace_events_hist.c
> @@ -3757,7 +3757,7 @@ static int check_synth_field(struct synth_event *event,
>  
>  	if (strcmp(field->type, hist_field->type) != 0) {
>  		if (field->size != hist_field->size ||
> -		    field->is_signed != hist_field->is_signed)
> +		    (!field->is_string && field->is_signed != hist_field->is_signed))
>  			return -EINVAL;
>  	}
>  
