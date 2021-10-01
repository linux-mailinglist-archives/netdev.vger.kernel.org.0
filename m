Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F18EC41EE65
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 15:18:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352324AbhJANUP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 09:20:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352696AbhJANTt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Oct 2021 09:19:49 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFE87C0613EB;
        Fri,  1 Oct 2021 06:17:45 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id w11so6262277plz.13;
        Fri, 01 Oct 2021 06:17:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Ylpl7fwcJ6dmn8OOkjpCoC6BQ0dUN3SoIftGjd4jR9U=;
        b=jXNrEhRQ+XqK/MsLCBs+KJXQnxuYQ2yX2fUjSWwoGUrREJtyMpH0hGhkVJMSW1wLd1
         QG/YWwpP9/HYnq/HsGiy0rsQXdViF2LhyHl20KL67shjcwzQb+r6Spe6JdGO57xbxAIb
         gOKluJnZ+JrnIhxbd1z7MVSLZINqTYaToYH7z9tQnKhI3GUggfMdP3C+l3uhn5niPwD/
         KNdDhOLicZnNfLsyH2DOOiMn5FXB5uSpqeEDAki+hKUEjLkS6p16gb9tUjokkdO1eYPS
         xzxm4SVx+EUgVWK2LFtWAAWE4j3yrI9HDIes+q6qDkvmzz1/HvAx024kqsTy+GXRRnHC
         QMiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Ylpl7fwcJ6dmn8OOkjpCoC6BQ0dUN3SoIftGjd4jR9U=;
        b=heNPYB15lSVZPM+CoPjpGIX6ZrM/QzCbSLoQpmH39OVTmCRTIksf1FFwfUUTp6snHV
         6tqWm9wLuNbm8yOjqaHBviF1OHHheBtd7GmfKDOUA7nW/tzrzn7HZuEkVeZk72aWwKAy
         r8OLtubQ2msIWFBToasjeZRv4hnaB/MhEbd5eYCdBOsto49bGIqJci2kOg7lqPeYvKhc
         AqHmqd1+n3kMcxcGD8uYcaBE/x/4DEPWX8qBbfAmANp5/FdP9sXxHZMyctnfvPAwccUn
         NG0LqPR5IRuUuXOhBeP4o1w5SHvIjtENq+m8wPKem/zkbm2zEO7q8tiASbbefbvw0lkc
         CKrg==
X-Gm-Message-State: AOAM530FB8V6+76MeeESUb0S3Ifzk+rQ/RieIe8BOsnE9D8W005K3kMR
        06L460lHRdW1bm5oDbQniBA=
X-Google-Smtp-Source: ABdhPJzVVuw8Y9jVkevWrUuql70mrqqyUm154zOarGgS2WsExr7akQAa/DG3ZUsriL6WynJLxWvg/w==
X-Received: by 2002:a17:902:c612:b0:13c:9801:a336 with SMTP id r18-20020a170902c61200b0013c9801a336mr9397654plr.27.1633094265436;
        Fri, 01 Oct 2021 06:17:45 -0700 (PDT)
Received: from ?IPv6:2404:f801:0:5:8000::50b? ([2404:f801:9000:18:efec::50b])
        by smtp.gmail.com with ESMTPSA id e11sm6404924pfm.28.2021.10.01.06.17.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Oct 2021 06:17:45 -0700 (PDT)
Subject: Re: [PATCH V6 3/8] x86/hyperv: Add new hvcall guest address host
 visibility support
To:     Borislav Petkov <bp@alien8.de>
Cc:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        wei.liu@kernel.org, decui@microsoft.com, tglx@linutronix.de,
        mingo@redhat.com, x86@kernel.org, hpa@zytor.com,
        dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
        davem@davemloft.net, kuba@kernel.org, gregkh@linuxfoundation.org,
        arnd@arndb.de, brijesh.singh@amd.com, jroedel@suse.de,
        Tianyu.Lan@microsoft.com, thomas.lendacky@amd.com,
        pgonda@google.com, akpm@linux-foundation.org, rppt@kernel.org,
        kirill.shutemov@linux.intel.com, saravanand@fb.com,
        aneesh.kumar@linux.ibm.com, rientjes@google.com, tj@kernel.org,
        michael.h.kelley@microsoft.com, linux-arch@vger.kernel.org,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, vkuznets@redhat.com,
        konrad.wilk@oracle.com, hch@lst.de, robin.murphy@arm.com,
        joro@8bytes.org, parri.andrea@gmail.com, dave.hansen@intel.com
References: <20210930130545.1210298-1-ltykernel@gmail.com>
 <20210930130545.1210298-4-ltykernel@gmail.com> <YVX7n4YM8ZirwTQu@zn.tnic>
From:   Tianyu Lan <ltykernel@gmail.com>
Message-ID: <8a9a6753-d0b5-3c12-5a5c-17decae3548b@gmail.com>
Date:   Fri, 1 Oct 2021 21:17:33 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <YVX7n4YM8ZirwTQu@zn.tnic>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Boris:
	Thanks for your review.

On 10/1/2021 2:02 AM, Borislav Petkov wrote:
> On Thu, Sep 30, 2021 at 09:05:39AM -0400, Tianyu Lan wrote:
>> @@ -1980,15 +1982,11 @@ int set_memory_global(unsigned long addr, int numpages)
>>   				    __pgprot(_PAGE_GLOBAL), 0);
>>   }
>>   
>> -static int __set_memory_enc_dec(unsigned long addr, int numpages, bool enc)
>> +static int __set_memory_enc_pgtable(unsigned long addr, int numpages, bool enc)
> 
> What exactly is that "pgtable" at the end of the name supposed to mean?
> 

This was suggested by Dave Hansen. It gets used for the hypervisors
that get informed about "encryption" status via page tables: SEV and TDX.

https://lore.kernel.org/linux-iommu/c00e269c-da4c-c703-0182-0221c73a76cc@intel.com/

> So if you want to have different indirections here, I'd suggest you do
> this:
> 
> set_memory_encrypted/decrypted() is the external API. It calls
> 
> _set_memory_enc_dec() which does your hv_* checks. Note the single
> underscore "_" prefix.
> 
> Then, the workhorse remains __set_memory_enc_dec().
> 
> Ok?
> 
> Also, we're reworking the mem_encrypt_active() accessors:
> 
> https://lkml.kernel.org/r/20210928191009.32551-1-bp@alien8.de
> 
> so some synchronization when juggling patchsets will be needed. JFYI
> anyway.

Thanks for reminder. I know that patchset and suggested to decouple 
dependency among SEV, TDX and Hyper=v patchset.

> 
> Also 2, building your set triggers this, dunno if I'm missing some
> patches on my local branch for that.

Thanks for your test. Missing hv_set_register() when CONFIG_HYPERV is 
not selected. I will fix it in the next version.

> 
> In file included from ./arch/x86/include/asm/mshyperv.h:240,
>                   from ./include/clocksource/hyperv_timer.h:18,
>                   from ./arch/x86/include/asm/vdso/gettimeofday.h:21,
>                   from ./include/vdso/datapage.h:137,
>                   from ./arch/x86/include/asm/vgtod.h:12,
>                   from arch/x86/entry/vdso/vma.c:20:
> ./include/asm-generic/mshyperv.h: In function ‘vmbus_signal_eom’:
> ./include/asm-generic/mshyperv.h:153:3: error: implicit declaration of function ‘hv_set_register’; did you mean ‘kset_register’? [-Werror=implicit-function-declaration]
>    153 |   hv_set_register(HV_REGISTER_EOM, 0);
>        |   ^~~~~~~~~~~~~~~
>        |   kset_register
> In file included from ./arch/x86/include/asm/mshyperv.h:240,
>                   from arch/x86/mm/pat/set_memory.c:34:
> ./include/asm-generic/mshyperv.h: In function ‘vmbus_signal_eom’:
> ...
> 
