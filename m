Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCB3D44D60C
	for <lists+netdev@lfdr.de>; Thu, 11 Nov 2021 12:47:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233171AbhKKLu1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Nov 2021 06:50:27 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:27238 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232898AbhKKLu0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Nov 2021 06:50:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636631257;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3FPfS7kZXFceS9Lgp1RH/lsyVsBLRGLqfS3FoOXYSuE=;
        b=JUG0zHkr9XKE+vyp2JQ6ZOnO7o1vblP3jalWF4kINFFMYiaplaDm9Z8PxGwLW6pMoGFutK
        wClQirNVbisXCdAvgSvn5/0BWygrFVn7hTc6h0yMsuV02eUZe+0OWYyMOyWav098hjC4q7
        vgY/hnArrBuzrOh7X+lXS0JHzwP2DMc=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-155-EQzeHXpFPP6LwFq5bPlRhg-1; Thu, 11 Nov 2021 06:47:35 -0500
X-MC-Unique: EQzeHXpFPP6LwFq5bPlRhg-1
Received: by mail-wr1-f70.google.com with SMTP id p17-20020adff211000000b0017b902a7701so965093wro.19
        for <netdev@vger.kernel.org>; Thu, 11 Nov 2021 03:47:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=3FPfS7kZXFceS9Lgp1RH/lsyVsBLRGLqfS3FoOXYSuE=;
        b=Ef1eEKv8A2vOwWdXXrHnACjTNUiQlVQ1VlZUWmbwECD1QbApRo9oiRo1rUbtxjBVZa
         r+jKK3X3ilHfWFwWX7culMcaLoXuUJ2baxARGV8DUV+16o4kOUSVrBpeYSswaHa6tfE3
         HOTN8vrfYuXRzhvw/a3e1Mkhu/CnIdiASAVaLenwJnY+icZgs9kzwJVpqXsdnig9ZjAX
         JEA43f7Zg5O3gdSV4HPCfSDHcxI2RdIP5L2t1hnq45SbifXfxj7+3Vi+jnt5iafDCQsH
         0+b7ObTFc/nncIBmbHya3ayTycxWkGvYnRO5MoUMp/RFSfcuIaY9eGYXciC65d+NpNKO
         E0Kg==
X-Gm-Message-State: AOAM530L55QBHbbQHvXOxQlhzx0wCFQvVOUhmhJnEr30ue/uebxjNXnx
        NhvYlY4nPJr7pCdYg2PXEz78bTix8kFOYkPIwRK55J9UYZbITuUva/h4mFsoxU89eqOa0poRqJK
        bFbZc6eZGkIadDTFm
X-Received: by 2002:a5d:45cc:: with SMTP id b12mr8082379wrs.164.1636631254683;
        Thu, 11 Nov 2021 03:47:34 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwO566pckJvXEcwz+OG93YPsApF+toGZKExvaMFLBrnliRRTv/LgjAiYUOFAAaeaDr4bLvTMw==
X-Received: by 2002:a5d:45cc:: with SMTP id b12mr8082352wrs.164.1636631254480;
        Thu, 11 Nov 2021 03:47:34 -0800 (PST)
Received: from [192.168.3.132] (p4ff23ee8.dip0.t-ipconnect.de. [79.242.62.232])
        by smtp.gmail.com with ESMTPSA id d8sm2782565wrm.76.2021.11.11.03.47.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Nov 2021 03:47:33 -0800 (PST)
Message-ID: <70dd5e1c-99c9-c1ca-4e3f-1a894896cf06@redhat.com>
Date:   Thu, 11 Nov 2021 12:47:33 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH 4/7] fs/binfmt_elf: use get_task_comm instead of
 open-coded string copy
Content-Language: en-US
To:     Petr Mladek <pmladek@suse.com>
Cc:     Yafang Shao <laoar.shao@gmail.com>, akpm@linux-foundation.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-perf-users@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        oliver.sang@intel.com, lkp@intel.com,
        Kees Cook <keescook@chromium.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Michal Miroslaw <mirq-linux@rere.qmqm.pl>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Matthew Wilcox <willy@infradead.org>,
        Al Viro <viro@zeniv.linux.org.uk>
References: <20211108083840.4627-1-laoar.shao@gmail.com>
 <20211108083840.4627-5-laoar.shao@gmail.com>
 <a13c0541-59a3-6561-6d42-b51fef9f7c8b@redhat.com>
 <b495d38d-5cdd-8a33-b9d3-de721095ccab@redhat.com> <YYz/4bSdSXR3Palz@alley>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <YYz/4bSdSXR3Palz@alley>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11.11.21 12:34, Petr Mladek wrote:
> On Thu 2021-11-11 11:06:04, David Hildenbrand wrote:
>> On 11.11.21 11:03, David Hildenbrand wrote:
>>> On 08.11.21 09:38, Yafang Shao wrote:
>>>> It is better to use get_task_comm() instead of the open coded string
>>>> copy as we do in other places.
>>>>
>>>> struct elf_prpsinfo is used to dump the task information in userspace
>>>> coredump or kernel vmcore. Below is the verfication of vmcore,
>>>>
>>>> crash> ps
>>>>    PID    PPID  CPU       TASK        ST  %MEM     VSZ    RSS  COMM
>>>>       0      0   0  ffffffff9d21a940  RU   0.0       0      0  [swapper/0]
>>>>>     0      0   1  ffffa09e40f85e80  RU   0.0       0      0  [swapper/1]
>>>>>     0      0   2  ffffa09e40f81f80  RU   0.0       0      0  [swapper/2]
>>>>>     0      0   3  ffffa09e40f83f00  RU   0.0       0      0  [swapper/3]
>>>>>     0      0   4  ffffa09e40f80000  RU   0.0       0      0  [swapper/4]
>>>>>     0      0   5  ffffa09e40f89f80  RU   0.0       0      0  [swapper/5]
>>>>       0      0   6  ffffa09e40f8bf00  RU   0.0       0      0  [swapper/6]
>>>>>     0      0   7  ffffa09e40f88000  RU   0.0       0      0  [swapper/7]
>>>>>     0      0   8  ffffa09e40f8de80  RU   0.0       0      0  [swapper/8]
>>>>>     0      0   9  ffffa09e40f95e80  RU   0.0       0      0  [swapper/9]
>>>>>     0      0  10  ffffa09e40f91f80  RU   0.0       0      0  [swapper/10]
>>>>>     0      0  11  ffffa09e40f93f00  RU   0.0       0      0  [swapper/11]
>>>>>     0      0  12  ffffa09e40f90000  RU   0.0       0      0  [swapper/12]
>>>>>     0      0  13  ffffa09e40f9bf00  RU   0.0       0      0  [swapper/13]
>>>>>     0      0  14  ffffa09e40f98000  RU   0.0       0      0  [swapper/14]
>>>>>     0      0  15  ffffa09e40f9de80  RU   0.0       0      0  [swapper/15]
>>>>
>>>> It works well as expected.
>>>>
>>>> Suggested-by: Kees Cook <keescook@chromium.org>
>>>> Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
>>>> Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
>>>> Cc: Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
>>>> Cc: Andrii Nakryiko <andrii.nakryiko@gmail.com>
>>>> Cc: Michal Miroslaw <mirq-linux@rere.qmqm.pl>
>>>> Cc: Peter Zijlstra <peterz@infradead.org>
>>>> Cc: Steven Rostedt <rostedt@goodmis.org>
>>>> Cc: Matthew Wilcox <willy@infradead.org>
>>>> Cc: David Hildenbrand <david@redhat.com>
>>>> Cc: Al Viro <viro@zeniv.linux.org.uk>
>>>> Cc: Kees Cook <keescook@chromium.org>
>>>> Cc: Petr Mladek <pmladek@suse.com>
>>>> ---
>>>>  fs/binfmt_elf.c | 2 +-
>>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>>
>>>> diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
>>>> index a813b70f594e..138956fd4a88 100644
>>>> --- a/fs/binfmt_elf.c
>>>> +++ b/fs/binfmt_elf.c
>>>> @@ -1572,7 +1572,7 @@ static int fill_psinfo(struct elf_prpsinfo *psinfo, struct task_struct *p,
>>>>  	SET_UID(psinfo->pr_uid, from_kuid_munged(cred->user_ns, cred->uid));
>>>>  	SET_GID(psinfo->pr_gid, from_kgid_munged(cred->user_ns, cred->gid));
>>>>  	rcu_read_unlock();
>>>> -	strncpy(psinfo->pr_fname, p->comm, sizeof(psinfo->pr_fname));
>>>> +	get_task_comm(psinfo->pr_fname, p);
>>>>  
>>>>  	return 0;
>>>>  }
>>>>
>>>
>>> We have a hard-coded "pr_fname[16]" as well, not sure if we want to
>>> adjust that to use TASK_COMM_LEN?
>>
>> But if the intention is to chance TASK_COMM_LEN later, we might want to
>> keep that unchanged.
> 
> It seems that len will not change in the end. Another solution is
> going to be used for the long names, see
> https://lore.kernel.org/r/20211108084142.4692-1-laoar.shao@gmail.com.

Yes, that's what I recall as well. The I read the patch
subjects+descriptions in this series "make it adopt to task comm size
change" and was slightly confused.

Maybe we should just remove any notion of "task comm size change" from
this series and instead just call it a cleanup.


-- 
Thanks,

David / dhildenb

