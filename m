Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16DD0426317
	for <lists+netdev@lfdr.de>; Fri,  8 Oct 2021 05:34:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234904AbhJHDgM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 23:36:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229634AbhJHDgL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Oct 2021 23:36:11 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBCF2C061570;
        Thu,  7 Oct 2021 20:34:16 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id j15so5287878plh.7;
        Thu, 07 Oct 2021 20:34:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:cc:references:from:organization:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=RVQKCp1tqygjqO/AhaJUzopSL6lmHTNrVwx5fqj6hzQ=;
        b=nmI3c4yMSVoDZJSUyj830PEEvU8aVx+jX5eGPIAuSnGBnY9T8bfKCurwxHET55BlQG
         S1Cpqy/FlWfU+F/GHj0OFWmDxZz/FjDI+8CpxHS1mshpQtnnnwIda9p+EpKclziTjT8M
         qgzX/rw4SZo0Wf2VU7Vudzg+xHkQ0PX1YAPYcMmpVVYwWRJAQ94FxsU7cDvsiPaaOhuX
         rFi9JfCJMwu07obshoOWroJUk/69ghWSMcOCSRKcpMgUCZtmwkGPSZHIrbqXAhG8uvia
         7z00QMmS1QPtP0EQlfAx2l0mkRr7R6GbNsCfPC+JPo/vL/9P+33Smd53IvaHl+ndG7qa
         bL6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:to:cc:references:from:organization:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=RVQKCp1tqygjqO/AhaJUzopSL6lmHTNrVwx5fqj6hzQ=;
        b=ChrPppujq4swx3RsjnAx8rq4bmB34d10j1MG77bGSlMp9Z4jTWPRZP/Ryc39dant2B
         uEXPbfWOBhLo4MrCSYQJds344C9hISI2GDEouMb/VAF+XBYAE86SgEUCdVtUfo0szQLx
         Vv9H+yMezVsRp+hipaRDnbGRaH/0lZD1PATwaY38uzc5g5o6J2QxADWeky62Jnh9/sYS
         pqSGi/Ilv7aarqs+ll3wsw2pj0Y61hN0G9a2C2oHHQYUoXDSsXk6PAzHtlzj16o39nhT
         4w3D/yRnDKKbwLJOGS94jUmOSRaRjSmOL1kd5XsO3MAHg3PzZq1eGSU9fsKRSw9CHudK
         HuQg==
X-Gm-Message-State: AOAM53393SFJw70OdVAMzpI/kAQsncW+h5tH1A5GTHjyXh55LJ2pb6uw
        CJImm1B9kMrGDGSTnZdtK4Y=
X-Google-Smtp-Source: ABdhPJz5d5VHZQTIYKzN3/MgtV2lQ1waPlVvLm7p6Na6GgBaegQy0Aps3OoSACDcJNIa8BstK2Vx2A==
X-Received: by 2002:a17:90a:7bc8:: with SMTP id d8mr9636499pjl.128.1633664056423;
        Thu, 07 Oct 2021 20:34:16 -0700 (PDT)
Received: from Likes-MacBook-Pro.local ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id q14sm9299266pjm.17.2021.10.07.20.34.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 Oct 2021 20:34:16 -0700 (PDT)
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
From:   Like Xu <like.xu.linux@gmail.com>
Organization: Tencent
Subject: Re: bpf_get_branch_snapshot on qemu-kvm
Message-ID: <ee2a1209-8572-a147-fdac-1a3d83862022@gmail.com>
Date:   Fri, 8 Oct 2021 11:34:05 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <0676194C-3ADF-4FF9-8655-2B15D54E72BE@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 30/9/2021 4:05 am, Song Liu wrote:
> Hi Kan,
> 
>> On Sep 29, 2021, at 9:35 AM, Liang, Kan <kan.liang@intel.com> wrote:
>>
>>>>> - get confirmation that clearing GLOBAL_CTRL is suffient to supress
>>>>>   PEBS, in which case we can simply remove the PEBS_ENABLE clear.
>>>>
>>>> How should we confirm this? Can we run some tests for this? Or do we
>>>> need hardware experts' input for this?
>>>
>>> I'll put it on the list to ask the hardware people when I talk to them next. But
>>> maybe Kan or Andi know without asking.
>>
>> If the GLOBAL_CTRL is explicitly disabled, the counters do not count anymore.
>> It doesn't matter if PEBS is enabled or not.
>>
>> See 6c1c07b33eb0 ("perf/x86/intel: Avoid unnecessary PEBS_ENABLE MSR
>> access in PMI "). We optimized the PMU handler base on it.
> 
> Thanks for these information!
> 
> IIUC, all we need is the following on top of bpf-next/master:
> 
> diff --git i/arch/x86/events/intel/core.c w/arch/x86/events/intel/core.c
> index 1248fc1937f82..d0d357e7d6f21 100644
> --- i/arch/x86/events/intel/core.c
> +++ w/arch/x86/events/intel/core.c
> @@ -2209,7 +2209,6 @@ intel_pmu_snapshot_branch_stack(struct perf_branch_entry *entries, unsigned int
>          /* must not have branches... */
>          local_irq_save(flags);
>          __intel_pmu_disable_all(false); /* we don't care about BTS */

If the value passed in is true, does it affect your use case?

> -       __intel_pmu_pebs_disable_all();

In that case, we can reuse "static __always_inline void intel_pmu_disable_all(void)"
regardless of whether PEBS is supported or enabled inside the guest and the host ?

>          __intel_pmu_lbr_disable();

How about using intel_pmu_lbr_disable_all() to cover Arch LBR?

>          /*            ... until here */
>          return __intel_pmu_snapshot_branch_stack(entries, cnt, flags);
> @@ -2223,7 +2222,6 @@ intel_pmu_snapshot_arch_branch_stack(struct perf_branch_entry *entries, unsigned
>          /* must not have branches... */
>          local_irq_save(flags);
>          __intel_pmu_disable_all(false); /* we don't care about BTS */
> -       __intel_pmu_pebs_disable_all();
>          __intel_pmu_arch_lbr_disable();
>          /*            ... until here */
>          return __intel_pmu_snapshot_branch_stack(entries, cnt, flags);
> 
> 
> In the test, this does eliminate the warning.
> 
> Thanks,
> Song
> 
