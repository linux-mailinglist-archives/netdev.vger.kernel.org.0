Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFAC14264BA
	for <lists+netdev@lfdr.de>; Fri,  8 Oct 2021 08:36:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229767AbhJHGiV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Oct 2021 02:38:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231895AbhJHGiQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Oct 2021 02:38:16 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7377C061570;
        Thu,  7 Oct 2021 23:36:21 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id o133so1088783pfg.7;
        Thu, 07 Oct 2021 23:36:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:cc:references:from:organization:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=VYvqLsCwq7Y1ITSI86mNXDEYQBi/HyoPa7nmq+M6K2w=;
        b=O+pQ7Zo+/Tnnbrp+Zt/Gt38SR1/TuldJuS5pYAOukT8k3XZ+YS80X2sow3SwwPY5Hx
         8EsppMfFssdh/8zUhMZ8RA2Kxq6/a2JkrekQx0F8Da8qPoePLXzfSwTF3UyhRZALjYDz
         RIcrGkiS1cJAPWHlYfzmijJu05tn7wohv8wNFLYbQAGCqHHywC6SO/aUFttAobtD6TNZ
         duTwMbJbj3cLBcpNBMUE7JP+Acw13wlCP1qQfiF+8+dS8x4jJ1zubRxA37ipa8igkIAW
         Ijy2mq57ajlVz6RCIR850DrXnjCRG8jYZYHYRvZHU/Am6LFzHMWQW/547MOe9oEZvpXg
         qPoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:to:cc:references:from:organization:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=VYvqLsCwq7Y1ITSI86mNXDEYQBi/HyoPa7nmq+M6K2w=;
        b=Ra1x5pjz2KBnbl78JfNNxui3Jl7iYEQVAbnrUycnqxjnY3j6q8dABU48ImfUdDYWV3
         WNdt7rnidgvJLXB4waz3Ar6dyrUy3Tlb4lF9vkycogIm3GAl+1U8E63pnNUN+OEmNTV+
         PXmlEQG3MFVQpck45f9D8gsKGKcCGAHqYbrP4xw8FACSE0i+sa+IxrQYE9CgR1dhukAc
         Bo2C6C7nao03yo13bMXWh8dLUrZh3bmJ4OWjQt4heS+qW9tuxuUzPpWh+pB75cZTbkRf
         enBW0FuCuK0J8s3ZGQMobMVISZPsnAkS5Gh9XvJYHV2SGcgNnJUl1mpzFDTnVkFKFGli
         9RrA==
X-Gm-Message-State: AOAM532kO0v7vKwkp21NHzJUAKoYzbc7nua8eSiDkwG98+3GJDMS23wW
        IWHjyOaelR7ZSRadq1L+Xfg=
X-Google-Smtp-Source: ABdhPJxkZRdgQSvLpnpuWq/WDzGinqyhJmPxyjSE5Fok2tMhY+k9hQYW/vdBfpdlh0D9YLb9Tjbkag==
X-Received: by 2002:a63:720d:: with SMTP id n13mr3195739pgc.470.1633674981246;
        Thu, 07 Oct 2021 23:36:21 -0700 (PDT)
Received: from Likes-MacBook-Pro.local ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id h2sm1129697pjk.44.2021.10.07.23.36.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 Oct 2021 23:36:20 -0700 (PDT)
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
From:   Like Xu <like.xu.linux@gmail.com>
Organization: Tencent
Subject: Re: bpf_get_branch_snapshot on qemu-kvm
Message-ID: <d46d96ff-02a3-5ea7-a273-2945f4ef17a5@gmail.com>
Date:   Fri, 8 Oct 2021 14:36:12 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <7B80A399-1F96-4375-A306-A4142B44FFBF@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/10/2021 1:46 pm, Song Liu wrote:
> 
> 
>> On Oct 7, 2021, at 8:34 PM, Like Xu <like.xu.linux@gmail.com> wrote:
>>
>> On 30/9/2021 4:05 am, Song Liu wrote:
>>> Hi Kan,
>>>> On Sep 29, 2021, at 9:35 AM, Liang, Kan <kan.liang@intel.com> wrote:
>>>>
>>>>>>> - get confirmation that clearing GLOBAL_CTRL is suffient to supress
>>>>>>>   PEBS, in which case we can simply remove the PEBS_ENABLE clear.
>>>>>>
>>>>>> How should we confirm this? Can we run some tests for this? Or do we
>>>>>> need hardware experts' input for this?
>>>>>
>>>>> I'll put it on the list to ask the hardware people when I talk to them next. But
>>>>> maybe Kan or Andi know without asking.
>>>>
>>>> If the GLOBAL_CTRL is explicitly disabled, the counters do not count anymore.
>>>> It doesn't matter if PEBS is enabled or not.
>>>>
>>>> See 6c1c07b33eb0 ("perf/x86/intel: Avoid unnecessary PEBS_ENABLE MSR
>>>> access in PMI "). We optimized the PMU handler base on it.
>>> Thanks for these information!
>>> IIUC, all we need is the following on top of bpf-next/master:
>>> diff --git i/arch/x86/events/intel/core.c w/arch/x86/events/intel/core.c
>>> index 1248fc1937f82..d0d357e7d6f21 100644
>>> --- i/arch/x86/events/intel/core.c
>>> +++ w/arch/x86/events/intel/core.c
>>> @@ -2209,7 +2209,6 @@ intel_pmu_snapshot_branch_stack(struct perf_branch_entry *entries, unsigned int
>>>          /* must not have branches... */
>>>          local_irq_save(flags);
>>>          __intel_pmu_disable_all(false); /* we don't care about BTS */
>>
>> If the value passed in is true, does it affect your use case?
>>
>>> -       __intel_pmu_pebs_disable_all();
>>
>> In that case, we can reuse "static __always_inline void intel_pmu_disable_all(void)"
>> regardless of whether PEBS is supported or enabled inside the guest and the host ?
>>
>>>          __intel_pmu_lbr_disable();
>>
>> How about using intel_pmu_lbr_disable_all() to cover Arch LBR?
> 
> We are using LBR without PMI, so there isn't any hardware mechanism to
> stop the LBR, we have to stop it in software. There is always a delay
> between the event triggers and the LBR is stopped. In this window,

Do you use counters for snapshot branch stack?

Can the assumption of "without PMI" be broken sine Intel does have
the hardware mechanism like "freeze LBR on counter overflow
(aka, DEBUGCTLMSR_FREEZE_LBRS_ON_PMI)" ?

> the LBR is still running and old entries are being replaced by new entries.
> We actually need the old entries before the triggering event, so the key
> design goal here is to minimize the number of branch instructions between
> the event triggers and the LBR is stopped.

Yes, it makes sense.

> 
> Here, both __intel_pmu_disable_all(false) and __intel_pmu_lbr_disable()
> are used to optimize for this goal: the fewer branch instructions the
> better.

Is it possible that we have another LBR in-kernel user in addition to the current
BPF-LBR snapshot user, such as another BPF-LBR snapshot user or a LBR perf user ?

In the intel_pmu_snapshot_[arch]_branch_stack(), what if there is a PMI or NMI 
handler
to be called before __intel_pmu_lbr_disable(), which means more branch instructions
(assuming we don't use the FREEZE_LBRS_ON_xxx capability)?

How about try to disable LBR at the earliest possible time, before 
__intel_pmu_disable_all(false) ?

> 
> After removing __intel_pmu_pebs_disable_all() from
> intel_pmu_snapshot_branch_stack(), we found quite a few LBR entries in
> extable related code. With these entries, snapshot branch stack is not

Are you saying that you still need to call
__intel_pmu_pebs_disable_all() to maintain precision ?

> really useful in the VM, because all the interesting entries are flushed
> by these. I am not sure how to further optimize these. Do you have some
> suggestions on this?


> 
> Thanks,
> Song
> 
