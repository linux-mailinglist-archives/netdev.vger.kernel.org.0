Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 927423DA704
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 17:02:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237579AbhG2PCk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Jul 2021 11:02:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236736AbhG2PCj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Jul 2021 11:02:39 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 204C7C061765;
        Thu, 29 Jul 2021 08:02:36 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id t21so7267234plr.13;
        Thu, 29 Jul 2021 08:02:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=+bK/E9hMSXhFLJuYffyy4lnGRV/WQf1v1wRicssH11c=;
        b=FwB6x7B4iG0F7MUs9/9F6Dg/9PoCSP7gVTcOX0ocOJU41g4H+lOYYpyql4IyYVFcQY
         /jR2vjQ8vXFjFKbHbASRXdJemRdLMW21jXT3DV06qcoHuzHkTjYfMvskkaAemBRPzjTP
         h4JIu0oy0kK8PPRWkGWT9A0ZMN37pPHspf8nHPV3REyaJvIq/2bRvESuNsbdqOhCVZps
         wVNuJN0Wcl6YgLLFJnGARAl2uxPd4PQ0Gk5oTKljpXKFW8Dd8N4UiP1kBqxQ7w9zRhD8
         K8YjAuIKZcJf6XeOYfYrcl4FxeujnfCoH+ST0WDAmJ9l2jF1cG2dsUQ3hNCcIAs2tXUI
         dquA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+bK/E9hMSXhFLJuYffyy4lnGRV/WQf1v1wRicssH11c=;
        b=krkSatZVGsHUeqp2PyHHi9Edp5fYjIxcfGeKfL7GUX9LQJKisnJOTrD8NUPeagqISk
         q+pOH/BBWfUNeHZDlqJM6KEdXpLpe05nH+qPnmZdUvdVUU0mCpOtUJPlQ03ZWSjPj+DH
         eNWDORS1b1M80hPS1iCbhXeu7/2AHBKyxD9QpBVcwbnddYAi2tXDw8yJuAKnmADT7KzS
         oF3dqyL2wyoCro6U7XpWlltJ2+DIpie+7UjwCwMrJusan48YBb6NZFgIo8Nkr84141r9
         WknC+fvxUFcnDPbwbo9caz6tVQ5eu6eWRqbzUPcG8hXbeT2cinz7B34xuBW8V0sHBB8H
         LYsQ==
X-Gm-Message-State: AOAM532938mSLUmq52/zjOkVE+2fYJdjb1f6Fcqb1AfyGyMjbla1+KWY
        IC7ag/KCGUAyvQyEvZP9ThQ=
X-Google-Smtp-Source: ABdhPJzBGI9zTfesOKkMJXLKPI10+fN42IwNJPZiUXGYmFrvx/nDBD1B0BKa0HCMXpw5NCSATnP3lw==
X-Received: by 2002:a17:90a:e651:: with SMTP id ep17mr5748786pjb.85.1627570953940;
        Thu, 29 Jul 2021 08:02:33 -0700 (PDT)
Received: from ?IPv6:2404:f801:0:5:8000::4b1? ([2404:f801:9000:1a:efea::4b1])
        by smtp.gmail.com with ESMTPSA id h30sm4026153pfr.191.2021.07.29.08.02.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Jul 2021 08:02:33 -0700 (PDT)
Subject: Re: [PATCH 03/13] x86/HV: Add new hvcall guest address host
 visibility support
To:     Dave Hansen <dave.hansen@intel.com>, kys@microsoft.com,
        haiyangz@microsoft.com, sthemmin@microsoft.com, wei.liu@kernel.org,
        decui@microsoft.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, x86@kernel.org, hpa@zytor.com,
        dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
        konrad.wilk@oracle.com, boris.ostrovsky@oracle.com,
        jgross@suse.com, sstabellini@kernel.org, joro@8bytes.org,
        will@kernel.org, davem@davemloft.net, kuba@kernel.org,
        jejb@linux.ibm.com, martin.petersen@oracle.com, arnd@arndb.de,
        hch@lst.de, m.szyprowski@samsung.com, robin.murphy@arm.com,
        thomas.lendacky@amd.com, brijesh.singh@amd.com, ardb@kernel.org,
        Tianyu.Lan@microsoft.com, rientjes@google.com,
        martin.b.radev@gmail.com, akpm@linux-foundation.org,
        rppt@kernel.org, kirill.shutemov@linux.intel.com,
        aneesh.kumar@linux.ibm.com, krish.sadhukhan@oracle.com,
        saravanand@fb.com, xen-devel@lists.xenproject.org,
        pgonda@google.com, david@redhat.com, keescook@chromium.org,
        hannes@cmpxchg.org, sfr@canb.auug.org.au,
        michael.h.kelley@microsoft.com
Cc:     iommu@lists.linux-foundation.org, linux-arch@vger.kernel.org,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, netdev@vger.kernel.org,
        vkuznets@redhat.com, anparri@microsoft.com
References: <20210728145232.285861-1-ltykernel@gmail.com>
 <20210728145232.285861-4-ltykernel@gmail.com>
 <a2444c36-0103-8e1c-7005-d97f77f90e85@intel.com>
 <0d956a05-7d24-57a0-f4a9-dccc849b52fc@gmail.com>
 <ec1d4cfd-bbbc-e27a-7589-e85d9f0438f4@intel.com>
From:   Tianyu Lan <ltykernel@gmail.com>
Message-ID: <8df2845d-ee90-56d0-1228-adebb103ec37@gmail.com>
Date:   Thu, 29 Jul 2021 23:02:16 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <ec1d4cfd-bbbc-e27a-7589-e85d9f0438f4@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/29/2021 10:09 PM, Dave Hansen wrote:
> On 7/29/21 6:01 AM, Tianyu Lan wrote:
>> On 7/29/2021 1:06 AM, Dave Hansen wrote:
>>> On 7/28/21 7:52 AM, Tianyu Lan wrote:
>>>> @@ -1986,7 +1988,9 @@ static int __set_memory_enc_dec(unsigned long
>>>> addr, int numpages, bool enc)
>>>>        int ret;
>>>>          /* Nothing to do if memory encryption is not active */
>>>> -    if (!mem_encrypt_active())
>>>> +    if (hv_is_isolation_supported())
>>>> +        return hv_set_mem_enc(addr, numpages, enc);
>>>> +    else if (!mem_encrypt_active())
>>>>            return 0;
>>>
>>> One more thing.  If you're going to be patching generic code, please
>>> start using feature checks that can get optimized away at runtime.
>>> hv_is_isolation_supported() doesn't look like the world's cheapest
>>> check.  It can't be inlined and costs at least a function call.
>>
>> Yes, you are right. How about adding a static branch key for the check
>> of isolation VM? This may reduce the check cost.
> 
> I don't think you need a static key.
> 
> There are basically three choices:
> 1. Use an existing X86_FEATURE bit.  I think there's already one for
>     when you are running under a hypervisor.  It's not super precise,
>     but it's better than what you have.
> 2. Define a new X86_FEATURE bit for when you are running under
>     Hyper-V.
> 3. Define a new X86_FEATURE bit specifically for Hyper-V isolation VM
>     support.  This particular feature might be a little uncommon to
>     deserve its own bit.
> 
> I'd probably just do #2.
> 

There is x86_hyper_type to identify hypervisor type and we may check 
this variable after checking X86_FEATURE_HYPERVISOR.

static inline bool hv_is_isolation_supported(void)
{
	if (!cpu_feature_enabled(X86_FEATURE_HYPERVISOR))
		return 0;

         if (x86_hyper_type != X86_HYPER_MS_HYPERV)
                 return 0;

	// out of line function call:
	return __hv_is_isolation_supported();
}	
