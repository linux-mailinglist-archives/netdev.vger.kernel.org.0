Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7326461A0F
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 15:41:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378535AbhK2Oo4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 09:44:56 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:9322 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1378882AbhK2Omo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 09:42:44 -0500
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1ATELQk5004373;
        Mon, 29 Nov 2021 14:38:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : references : date : in-reply-to : message-id : content-type :
 mime-version; s=pp1; bh=psXxLdwgVEfnMFpvXcmOhsuzbnixwOwpECiDllB2p2s=;
 b=UrUjl8gxrQqUiuM9ig65LsK8IPLa9BMrdxtleUAK4SgasupVKzbLE94r022+ZnjMGu7i
 nqBkSuKlF9kZXMpDW8Fw14NsV6oqYZSyQtG6rim+p43Q8/gjbqY0AFnp2du4mOOCFwWS
 D1UdtOn49Y/IcLKhW40JUsTcHg8Ii/DMwbVXECqrrW172FbGL1Z8zRBQSSndvvyW3yyA
 BK1OjUopyF3GSexF1rLfB4wayFAdZ8YQWt3e2qUxB0tRe3hVfEA8mPSjS5QelBe2AMBm
 2VhOwceKNO+qPTGGWixhqY6xZU/mqr+4S7po081C7eMhMUwkhudu1SZTFlH6jEPRUOKd vw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cn0j8rdyf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 29 Nov 2021 14:38:49 +0000
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1ATEMXKM008522;
        Mon, 29 Nov 2021 14:38:49 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cn0j8rdxt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 29 Nov 2021 14:38:49 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1ATESIiO020879;
        Mon, 29 Nov 2021 14:38:46 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma06ams.nl.ibm.com with ESMTP id 3ckbxjnx71-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 29 Nov 2021 14:38:46 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1ATEVIQE36504026
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 29 Nov 2021 14:31:18 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4A25252052;
        Mon, 29 Nov 2021 14:38:44 +0000 (GMT)
Received: from tuxmaker.linux.ibm.com (unknown [9.152.85.9])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTPS id ABFAF52059;
        Mon, 29 Nov 2021 14:38:43 +0000 (GMT)
From:   Sven Schnelle <svens@linux.ibm.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     Yafang Shao <laoar.shao@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "linux-perf-use." <linux-perf-users@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org, Linux MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel test robot <oliver.sang@intel.com>,
        kbuild test robot <lkp@intel.com>,
        Andrii Nakryiko <andrii@kernel.org>,
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
        <yt9d35nfvy8s.fsf@linux.ibm.com>
        <54e1b56c-e424-a4b3-4d61-3018aa095f36@redhat.com>
Date:   Mon, 29 Nov 2021 15:38:43 +0100
In-Reply-To: <54e1b56c-e424-a4b3-4d61-3018aa095f36@redhat.com> (David
        Hildenbrand's message of "Mon, 29 Nov 2021 15:32:26 +0100")
Message-ID: <yt9dy257uivg.fsf@linux.ibm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.0.50 (gnu/linux)
Content-Type: text/plain
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: ETDg9BFbTme7HiDfY2tb_B3LhNdBNEJU
X-Proofpoint-GUID: UY2W4q60_I3lDZdKPxr3dXpyNLCmd1d5
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-29_08,2021-11-28_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 adultscore=0
 spamscore=0 lowpriorityscore=0 suspectscore=0 mlxlogscore=999
 clxscore=1015 bulkscore=0 mlxscore=0 priorityscore=1501 impostorscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111290073
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

David Hildenbrand <david@redhat.com> writes:
> On 29.11.21 15:21, Sven Schnelle wrote:
>> Yafang Shao <laoar.shao@gmail.com> writes:
>>> Thanks for the report and debugging!
>>> Seems we should explicitly define it as signed ?
>>> Could you pls. help verify it?
>>>
>>> diff --git a/include/linux/sched.h b/include/linux/sched.h
>>> index cecd4806edc6..44d36c6af3e1 100644
>>> --- a/include/linux/sched.h
>>> +++ b/include/linux/sched.h
>>> @@ -278,7 +278,7 @@ struct task_group;
>>>   * Define the task command name length as enum, then it can be visible to
>>>   * BPF programs.
>>>   */
>>> -enum {
>>> +enum SignedEnum {
>>>         TASK_COMM_LEN = 16,
>>>  };
>> 
>> Umm no. What you're doing here is to define the name of the enum as
>> 'SignedEnum'. This doesn't change the type. I think before C++0x you
>> couldn't force an enum type.
>
> I think there are only some "hacks" to modify the type with GCC. For
> example, with "__attribute__((packed))" we can instruct GCC to use the
> smallest type possible for the defined enum values.

Yes, i meant no way that the standard defines. You could force it to
signed by having a negative member.

> I think with some fake entries one can eventually instruct GCC to use an
> unsigned type in some cases:
>
> https://stackoverflow.com/questions/14635833/is-there-a-way-to-make-an-enum-unsigned-in-the-c90-standard-misra-c-2004-compl
>
> enum {
> 	TASK_COMM_LEN = 16,
> 	TASK_FORCE_UNSIGNED = 0x80000000,
> };
>
> Haven't tested it, though, and I'm not sure if we should really do that
> ... :)

TBH, i would vote for reverting the change. defining an array size as
enum feels really odd.

Regards
Sven
