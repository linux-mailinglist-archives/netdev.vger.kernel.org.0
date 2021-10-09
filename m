Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 646F042783F
	for <lists+netdev@lfdr.de>; Sat,  9 Oct 2021 11:03:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232767AbhJIJFx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Oct 2021 05:05:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229995AbhJIJFv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Oct 2021 05:05:51 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55E72C061570;
        Sat,  9 Oct 2021 02:03:55 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id g13-20020a17090a3c8d00b00196286963b9so10998957pjc.3;
        Sat, 09 Oct 2021 02:03:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:cc:references:from:organization:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9qcEnY7LWWVnfnWWdE/53QVeJXgV23dpnMmCKmoi43I=;
        b=qDlC5cc1DQN2i1KPn89a0E6mfQ1XAkCgODj1oUZ8H3GtbYhB7TYoRdulkcLgkdwkhV
         p3mjQwBPu4bXLAz5MWJaW6cIrLN5YRPlIcIEO/tH0VLTj8rCad7cZknye2KOK39BEAqb
         lJK+Q+LlLmNGWUMuHqO/h/IrNk3tEoDBzcp1JfSmH3JgH5pBZfngDw+22JL9WTIRGArZ
         yZwrvn/Uo5kus1I8D7sVHRBuhOhvSDNvnR5O8rvmLd0fM29k0oYtMOYLO8E5xbOW9IDI
         WCmiPFFUc7h99JufGaWgg4pgIBf6+qYjZckjR/bF6/DtXeEdyxsb6jWbxodfy6+UebxX
         eEZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:to:cc:references:from:organization:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=9qcEnY7LWWVnfnWWdE/53QVeJXgV23dpnMmCKmoi43I=;
        b=bT51Kqzfevl6bY9mP7We3TOUMI/b5Tg/o29/9JbX0T7a0RuoGOA69sXAq4aXAo7HaY
         PeLzPL4mzKTLckFNYno1MfkgDcT6ARomw+4QzuKfVyCaL7EmZ+SZm9At6nGDG3Ta+2Kb
         CyZjW9Td8QBUh9M3J5RgtOfG/Thqew8LydMvAVUehvCl/n+orgGVhh+pIfStMyYlxP2P
         8q4UgW6BCyJt1wMS3IoNfpsVkctR1vB2nyZ9mFhHI07ci+xZy9/uzXWUo1f9GLZygGQ7
         aMpDLwU1Lwu4GnXzlOtvOT8F0wWPDhhkEVgfrT+opz4m73D89LbofWJeMLnHY3kRaybV
         MTgg==
X-Gm-Message-State: AOAM532YugW9EyDtLOTaKEJejCzdK35VZqx8XrBLWzrhJztSqJZ9zOoD
        TJdNbfYKGERpHn8+u9vK4Xw=
X-Google-Smtp-Source: ABdhPJwR8ra0ftWx83sPVKUYIaAYxXi97CuV76ta8+i2iOw8twP2Qe7cC3fukioXu2k+BlPsipVbmg==
X-Received: by 2002:a17:90a:4097:: with SMTP id l23mr17828806pjg.141.1633770234807;
        Sat, 09 Oct 2021 02:03:54 -0700 (PDT)
Received: from Likes-MacBook-Pro.local ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id e8sm1698248pfn.45.2021.10.09.02.03.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 09 Oct 2021 02:03:54 -0700 (PDT)
To:     Song Liu <songliubraving@fb.com>
Cc:     Peter Zijlstra <peterz@infradead.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        "like.xu@linux.intel.com" <like.xu@linux.intel.com>,
        Andi Kleen <andi@firstfloor.org>,
        "Liang, Kan" <kan.liang@intel.com>
References: <0E5E6FCA-23ED-4CAA-ADEA-967430C62F6F@fb.com>
 <YVQXT5piFYa/SEY/@hirez.programming.kicks-ass.net>
 <d75f6a9a-dbb3-c725-c001-ec9bdd55173f@gmail.com>
 <YVRbX6vBgz+wYzZK@hirez.programming.kicks-ass.net>
 <C6DF009D-161A-4B17-88AE-3982DD6F22A2@fb.com>
 <YVSNV/1tFRGWIa6c@hirez.programming.kicks-ass.net>
 <SJ0PR11MB4814BBE6651FB9F8F05868FBE8A99@SJ0PR11MB4814.namprd11.prod.outlook.com>
 <0676194C-3ADF-4FF9-8655-2B15D54E72BE@fb.com>
 <ee2a1209-8572-a147-fdac-1a3d83862022@gmail.com>
 <7B80A399-1F96-4375-A306-A4142B44FFBF@fb.com>
 <d46d96ff-02a3-5ea7-a273-2945f4ef17a5@gmail.com>
 <1EB93A74-804B-4EE2-AECB-38580D40C80D@fb.com>
From:   Like Xu <like.xu.linux@gmail.com>
Organization: Tencent
Subject: Re: bpf_get_branch_snapshot on qemu-kvm
Message-ID: <0fe14e54-4ab3-75da-4bdc-561fe1461071@gmail.com>
Date:   Sat, 9 Oct 2021 17:03:46 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <1EB93A74-804B-4EE2-AECB-38580D40C80D@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/10/2021 1:08 am, Song Liu wrote:
> 
> 
>> On Oct 7, 2021, at 11:36 PM, Like Xu <like.xu.linux@gmail.com> wrote:
>>
>> On 8/10/2021 1:46 pm, Song Liu wrote:
>>>> On Oct 7, 2021, at 8:34 PM, Like Xu <like.xu.linux@gmail.com> wrote:
>>>>
>>>> On 30/9/2021 4:05 am, Song Liu wrote:
>>>>> Hi Kan,
>>>>>> On Sep 29, 2021, at 9:35 AM, Liang, Kan <kan.liang@intel.com> wrote:
>>>>>>
>>>>>>>>> - get confirmation that clearing GLOBAL_CTRL is suffient to supress
>>>>>>>>>   PEBS, in which case we can simply remove the PEBS_ENABLE clear.
>>>>>>>>
>>>>>>>> How should we confirm this? Can we run some tests for this? Or do we
>>>>>>>> need hardware experts' input for this?
>>>>>>>
>>>>>>> I'll put it on the list to ask the hardware people when I talk to them next. But
>>>>>>> maybe Kan or Andi know without asking.
>>>>>>
>>>>>> If the GLOBAL_CTRL is explicitly disabled, the counters do not count anymore.
>>>>>> It doesn't matter if PEBS is enabled or not.
>>>>>>
>>>>>> See 6c1c07b33eb0 ("perf/x86/intel: Avoid unnecessary PEBS_ENABLE MSR
>>>>>> access in PMI "). We optimized the PMU handler base on it.
>>>>> Thanks for these information!
>>>>> IIUC, all we need is the following on top of bpf-next/master:
>>>>> diff --git i/arch/x86/events/intel/core.c w/arch/x86/events/intel/core.c
>>>>> index 1248fc1937f82..d0d357e7d6f21 100644
>>>>> --- i/arch/x86/events/intel/core.c
>>>>> +++ w/arch/x86/events/intel/core.c
>>>>> @@ -2209,7 +2209,6 @@ intel_pmu_snapshot_branch_stack(struct perf_branch_entry *entries, unsigned int
>>>>>          /* must not have branches... */
>>>>>          local_irq_save(flags);
>>>>>          __intel_pmu_disable_all(false); /* we don't care about BTS */
>>>>
>>>> If the value passed in is true, does it affect your use case?
>>>>
>>>>> -       __intel_pmu_pebs_disable_all();
>>>>
>>>> In that case, we can reuse "static __always_inline void intel_pmu_disable_all(void)"
>>>> regardless of whether PEBS is supported or enabled inside the guest and the host ?
>>>>
>>>>>          __intel_pmu_lbr_disable();
>>>>
>>>> How about using intel_pmu_lbr_disable_all() to cover Arch LBR?
>>> We are using LBR without PMI, so there isn't any hardware mechanism to
>>> stop the LBR, we have to stop it in software. There is always a delay
>>> between the event triggers and the LBR is stopped. In this window,
>>
>> Do you use counters for snapshot branch stack?
>>
>> Can the assumption of "without PMI" be broken sine Intel does have
>> the hardware mechanism like "freeze LBR on counter overflow
>> (aka, DEBUGCTLMSR_FREEZE_LBRS_ON_PMI)" ?
> 
> We are capturing LBR on software events. For example, when a complex syscall,
> such as sys_bpf() and sys_perf_event_open(), returns -EINVAL, it is not obvious
> what wen wrong. The branch stack at the return (on a kretprobe or fexit) could
> give us additional information.
> 
>>
>>> the LBR is still running and old entries are being replaced by new entries.
>>> We actually need the old entries before the triggering event, so the key
>>> design goal here is to minimize the number of branch instructions between
>>> the event triggers and the LBR is stopped.
>>
>> Yes, it makes sense.
>>
>>> Here, both __intel_pmu_disable_all(false) and __intel_pmu_lbr_disable()
>>> are used to optimize for this goal: the fewer branch instructions the
>>> better.
>>
>> Is it possible that we have another LBR in-kernel user in addition to the current
>> BPF-LBR snapshot user, such as another BPF-LBR snapshot user or a LBR perf user ?
> 
> I think it is OK to have another user. We just need to capture the LBR entries.
> In fact, we simply enable LBR by opening a perf_event on each CPU. So from the
> kernel's point of view, the LBR is owned used by "another user".
> 
>>
>> In the intel_pmu_snapshot_[arch]_branch_stack(), what if there is a PMI or NMI handler
>> to be called before __intel_pmu_lbr_disable(), which means more branch instructions
>> (assuming we don't use the FREEZE_LBRS_ON_xxx capability)?
> 
> If we are unlucky and hit an NMI, we may get garbage data. The user will run the
> test again.
> 
>> How about try to disable LBR at the earliest possible time, before __intel_pmu_disable_all(false) ?
> 
> I am not sure which solution is the best here. On bare metal, current version works
> fine (available in bpf-next tree).
> 
>>
>>> After removing __intel_pmu_pebs_disable_all() from
>>> intel_pmu_snapshot_branch_stack(), we found quite a few LBR entries in
>>> extable related code. With these entries, snapshot branch stack is not
>>
>> Are you saying that you still need to call
>> __intel_pmu_pebs_disable_all() to maintain precision ?
> 
> I think we don't need pebs_disable_all. In the VM, pebs_disable_all will trigger
> "unchecked MSR access error" warning. After removing it, the warning message is
> gone. However, after we remove pebs_disable_all, we still see too many LBR entries
> are flushed before LBR is stopped. Most of these new entries are in extable code.
> I guess this is because the VM access these MSR differently.

Hi Song,

Thanks for your detailed input. I saw your workaround "if (is_hypervisor())" on 
the tree.

Even when the guest supports PEBS, this use case fails and the root cause is still
playing hide-and-seek with me. Just check with you to see if you get similar results
when the guest LBR behavior makes the test case fail like this:

serial_test_get_branch_snapshot:FAIL:find_looptest_in_lbr unexpected 
find_looptest_in_lbr: actual 0 <= expected 6
serial_test_get_branch_snapshot:FAIL:check_wasted_entries unexpected 
check_wasted_entries: actual 32 >= expected 10
#52 get_branch_snapshot:FAIL

Also, do you know or rough guess about how extable code relates to the test case ?

> 
> Thanks,
> Song
> 
