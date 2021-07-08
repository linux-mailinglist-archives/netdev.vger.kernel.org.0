Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96D313C14B3
	for <lists+netdev@lfdr.de>; Thu,  8 Jul 2021 15:54:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231887AbhGHN5R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Jul 2021 09:57:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231747AbhGHN5P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Jul 2021 09:57:15 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 150F8C061574;
        Thu,  8 Jul 2021 06:54:33 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id y17so6004931pgf.12;
        Thu, 08 Jul 2021 06:54:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=flXS1TuPwc//SKu4jyAw/jiI5sdlmmbGzljFY5ti5Is=;
        b=XPkbMtvNl1RRRIvI1exOBM0vNgLKe6Jr87NeF6M+XhU9hnWhIdYPy6g62fwe5U7Scv
         3OrZnM5xlgUHY4f2QkjgEeTcpa0o7dLnUyXfN9mRo8UFkwC9CeIap+ugcNZHLtK80D4t
         8wj5AZpA2H01PaBi7V8Kr6OodXxWYwqaKRbRwr4D/HdqeXVSeWVPyWGFP9JDZE8rPpuq
         b1I1cNp+0ih77D2DO6KbMwqCi2Da2EhcxiCcJG4ylxqWFEI1KpNBSWZO6ZthAYh6sGk7
         5b0XLFqNbcA1I9TlauYSplfC94nkC/MEEMZPwarYocJlHfxxxZoTys2fUSvH0P62QbMn
         xy8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=flXS1TuPwc//SKu4jyAw/jiI5sdlmmbGzljFY5ti5Is=;
        b=NLxHFZW/mBFJXM6W0tGaJO7O4Q/uBfCU+CqtmdeH+0nS6uFSG29exkJs06dWHGDxld
         t6T5Oo1oDKrZaOyIWl2fHAoMvT/dyRMcj6tFLJ1zNlmGkcOS0SZBBAkoshcI5/RRZcQn
         ZKEHFANWtPdzDMJfBV3UT/b9fDARZO0vWODb//7uLI99YpQz/vK5rMVCHhNTtuA16PCQ
         zFDrhcY7w5OuE5jRkcYxgfXmLM0GMKFgdOLSiWuXQJ448WIDaa4Hd9PEuGU5VYAhuXMb
         kfBbVdF39XkFZCaYiee3ng1Eb4GWC+so6+kadEW15Oe6qOQpVk6lGhBY5zYJghD+vkAH
         evjw==
X-Gm-Message-State: AOAM533Y564Gjim3jKTITSHzSlv7hxEOSratmzCNOKng28apnROI6BgM
        iNQv5nMx1gyexnCd80xn5Jc=
X-Google-Smtp-Source: ABdhPJz+HRb86cNh6Rdrx5mbqP68t5brrjDI0iQFQSntirGPjVbEL5v53qALGvweTO+18SVX/9PgGQ==
X-Received: by 2002:a63:f556:: with SMTP id e22mr32044865pgk.189.1625752472618;
        Thu, 08 Jul 2021 06:54:32 -0700 (PDT)
Received: from ?IPv6:2404:f801:0:5:8000::4b1? ([2404:f801:9000:1a:efea::4b1])
        by smtp.gmail.com with ESMTPSA id s6sm10053656pjp.45.2021.07.08.06.54.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Jul 2021 06:54:32 -0700 (PDT)
Subject: Re: [Resend RFC PATCH V4 13/13] x86/HV: Not set memory
 decrypted/encrypted during kexec alloc/free page in IVM
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
        kirill.shutemov@linux.intel.com, akpm@linux-foundation.org,
        rppt@kernel.org, Tianyu.Lan@microsoft.com, thomas.lendacky@amd.com,
        ardb@kernel.org, robh@kernel.org, nramas@linux.microsoft.com,
        pgonda@google.com, martin.b.radev@gmail.com, david@redhat.com,
        krish.sadhukhan@oracle.com, saravanand@fb.com,
        xen-devel@lists.xenproject.org, keescook@chromium.org,
        rientjes@google.com, hannes@cmpxchg.org,
        michael.h.kelley@microsoft.com
Cc:     iommu@lists.linux-foundation.org, linux-arch@vger.kernel.org,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, netdev@vger.kernel.org,
        vkuznets@redhat.com, brijesh.singh@amd.com, anparri@microsoft.com
References: <20210707154629.3977369-1-ltykernel@gmail.com>
 <20210707154629.3977369-14-ltykernel@gmail.com>
 <3b5a1bd0-369a-2723-97c1-4ab4edb14eda@intel.com>
From:   Tianyu Lan <ltykernel@gmail.com>
Message-ID: <e4508d82-826e-86be-96cf-feecc1b4a260@gmail.com>
Date:   Thu, 8 Jul 2021 21:54:15 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <3b5a1bd0-369a-2723-97c1-4ab4edb14eda@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave:
      Thanks for your review.

On 7/8/2021 12:14 AM, Dave Hansen wrote:
> On 7/7/21 8:46 AM, Tianyu Lan wrote:
>> @@ -598,7 +599,7 @@ void arch_kexec_unprotect_crashkres(void)
>>    */
>>   int arch_kexec_post_alloc_pages(void *vaddr, unsigned int pages, gfp_t gfp)
>>   {
>> -	if (sev_active())
>> +	if (sev_active() || hv_is_isolation_supported())
>>   		return 0;
>>   
>>   	/*
>> @@ -611,7 +612,7 @@ int arch_kexec_post_alloc_pages(void *vaddr, unsigned int pages, gfp_t gfp)
>>   
>>   void arch_kexec_pre_free_pages(void *vaddr, unsigned int pages)
>>   {
>> -	if (sev_active())
>> +	if (sev_active() || hv_is_isolation_supported())
>>   		return;
> 
> You might want to take a look through the "protected guest" patches.  I
> think this series is touching a few of the same locations that TDX and
> recent SEV work touch.
> 
> https://lore.kernel.org/lkml/20210618225755.662725-5-sathyanarayanan.kuppuswamy@linux.intel.com/

Thanks for reminder. You are right. There will be a generic API to check 
"proteced guest" type.
