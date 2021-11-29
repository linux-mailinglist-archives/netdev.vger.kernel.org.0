Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A1B5461956
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 15:35:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379091AbhK2Ohz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 09:37:55 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:50161 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1378727AbhK2Oft (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 09:35:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638196350;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dJBe9OPhF+PV6aWNoM1mTqTJe8Q2yU80n+V/5mpDDnU=;
        b=esvDb6ohWl78ETcyTeSR5bYc85pwmFQANFgNEQx3lum3ThhKu9cuOVpVb/CGBV7prXEuMk
        V7n2apwuDvDJCG29zS4e6Ye4YU3yjqvUkF6gA+Mc/zRYns2mDrmwMlHh7gLrutpVrosJa8
        NYbCBgNdWqdNTEZsbICJz/cJth5k6/M=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-540-IIjzOvGzNUKYZy6KUqQrtA-1; Mon, 29 Nov 2021 09:32:29 -0500
X-MC-Unique: IIjzOvGzNUKYZy6KUqQrtA-1
Received: by mail-wm1-f69.google.com with SMTP id g81-20020a1c9d54000000b003330e488323so5302306wme.0
        for <netdev@vger.kernel.org>; Mon, 29 Nov 2021 06:32:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:references:from:organization:subject
         :in-reply-to:content-transfer-encoding;
        bh=dJBe9OPhF+PV6aWNoM1mTqTJe8Q2yU80n+V/5mpDDnU=;
        b=FeDYlKRcBIWJSUT8gmahzS3gwFWFr0zJui30m9zlpYot52XRhnsCy23skdESrl0EfD
         dxxrsaplkwzM76iQYSRge+/h/iM4A5ZeYupPdLVvT4w1/s1rXUUmkb/Yd4j/h2VOXN75
         NkTYcc0YMtIbI0+/n2g0hDNevCx86+XcOBs/mLNZdz3h0gMSUASBhOpUIBIIixYrlbIM
         P1pd5B8IHk/yFXIhD9odgdH9R5PK87yycUWeOlQmgIJHBBBIYXTABHgR3jaFoZDzDNzv
         ZStuAHwumXmeKNXw3TuI8q34T/CK2mb5tV9wmpHbSQJDJ/a7SoLsejKoEwbIIYnc2/KH
         wBQQ==
X-Gm-Message-State: AOAM5308XqKjWEHeqJ2ml35ZEuBRzf2Tc7RCVc4Og9c4NESKNYbVxKSH
        nU5SMftGXPwM0rdI99R5rDem0y9wUswmY3Kol8Gjw4uWVDUfgeU24wlakTK9VwXdMD8NtGTQKmg
        laPOZk3hhWQs2IAgp
X-Received: by 2002:adf:d18f:: with SMTP id v15mr33386210wrc.447.1638196348161;
        Mon, 29 Nov 2021 06:32:28 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyA3jxLgz2qFbocjn5aqKjjz597XHuns2HayZngv2iHRT5zC+cXCqeSgXjkuMRuWEvUCgQECw==
X-Received: by 2002:adf:d18f:: with SMTP id v15mr33386167wrc.447.1638196347945;
        Mon, 29 Nov 2021 06:32:27 -0800 (PST)
Received: from [192.168.3.132] (p5b0c6664.dip0.t-ipconnect.de. [91.12.102.100])
        by smtp.gmail.com with ESMTPSA id l8sm21215902wmc.40.2021.11.29.06.32.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Nov 2021 06:32:27 -0800 (PST)
Message-ID: <54e1b56c-e424-a4b3-4d61-3018aa095f36@redhat.com>
Date:   Mon, 29 Nov 2021 15:32:26 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Content-Language: en-US
To:     Sven Schnelle <svens@linux.ibm.com>,
        Yafang Shao <laoar.shao@gmail.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
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
References: <20211120112738.45980-1-laoar.shao@gmail.com>
 <20211120112738.45980-8-laoar.shao@gmail.com>
 <yt9d35nf1d84.fsf@linux.ibm.com>
 <CALOAHbDtqpkN4D0vHvGxTSpQkksMWtFm3faMy0n+pazxN_RPPg@mail.gmail.com>
 <yt9d35nfvy8s.fsf@linux.ibm.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
Subject: Re: [PATCH v2 7/7] tools/testing/selftests/bpf: replace open-coded 16
 with TASK_COMM_LEN
In-Reply-To: <yt9d35nfvy8s.fsf@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 29.11.21 15:21, Sven Schnelle wrote:
> Hi,
> 
> Yafang Shao <laoar.shao@gmail.com> writes:
> 
>> On Mon, Nov 29, 2021 at 6:13 PM Sven Schnelle <svens@linux.ibm.com> wrote:
>>>> diff --git a/include/linux/sched.h b/include/linux/sched.h
>>>> index 78c351e35fec..cecd4806edc6 100644
>>>> --- a/include/linux/sched.h
>>>> +++ b/include/linux/sched.h
>>>> @@ -274,8 +274,13 @@ struct task_group;
>>>>
>>>>  #define get_current_state()  READ_ONCE(current->__state)
>>>>
>>>> -/* Task command name length: */
>>>> -#define TASK_COMM_LEN                        16
>>>> +/*
>>>> + * Define the task command name length as enum, then it can be visible to
>>>> + * BPF programs.
>>>> + */
>>>> +enum {
>>>> +     TASK_COMM_LEN = 16,
>>>> +};
>>>
>>> This breaks the trigger-field-variable-support.tc from the ftrace test
>>> suite at least on s390:
>>>
>>> echo
>>> 'hist:keys=next_comm:wakeup_lat=common_timestamp.usecs-$ts0:onmatch(sched.sched_waking).wakeup_latency($wakeup_lat,next_pid,sched.sched_waking.prio,next_comm)
>>> if next_comm=="ping"'
>>> linux/tools/testing/selftests/ftrace/test.d/trigger/inter-event/trigger-field-variable-support.tc: line 15: echo: write error: Invalid argument
>>>
>>> I added a debugging line into check_synth_field():
>>>
>>> [   44.091037] field->size 16, hist_field->size 16, field->is_signed 1, hist_field->is_signed 0
>>>
>>> Note the difference in the signed field.
>>>
>>
>> Hi Sven,
>>
>> Thanks for the report and debugging!
>> Seems we should explicitly define it as signed ?
>> Could you pls. help verify it?
>>
>> diff --git a/include/linux/sched.h b/include/linux/sched.h
>> index cecd4806edc6..44d36c6af3e1 100644
>> --- a/include/linux/sched.h
>> +++ b/include/linux/sched.h
>> @@ -278,7 +278,7 @@ struct task_group;
>>   * Define the task command name length as enum, then it can be visible to
>>   * BPF programs.
>>   */
>> -enum {
>> +enum SignedEnum {
>>         TASK_COMM_LEN = 16,
>>  };
> 
> Umm no. What you're doing here is to define the name of the enum as
> 'SignedEnum'. This doesn't change the type. I think before C++0x you
> couldn't force an enum type.

I think there are only some "hacks" to modify the type with GCC. For
example, with "__attribute__((packed))" we can instruct GCC to use the
smallest type possible for the defined enum values.

I think with some fake entries one can eventually instruct GCC to use an
unsigned type in some cases:

https://stackoverflow.com/questions/14635833/is-there-a-way-to-make-an-enum-unsigned-in-the-c90-standard-misra-c-2004-compl

enum {
	TASK_COMM_LEN = 16,
	TASK_FORCE_UNSIGNED = 0x80000000,
};

Haven't tested it, though, and I'm not sure if we should really do that
... :)

-- 
Thanks,

David / dhildenb

