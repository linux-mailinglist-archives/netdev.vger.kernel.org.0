Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19ACE39D6E1
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 10:16:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230316AbhFGIR5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 04:17:57 -0400
Received: from mail-pj1-f54.google.com ([209.85.216.54]:53199 "EHLO
        mail-pj1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229545AbhFGIR4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Jun 2021 04:17:56 -0400
Received: by mail-pj1-f54.google.com with SMTP id h16so9344558pjv.2;
        Mon, 07 Jun 2021 01:15:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=c5tZw1PE5ja1kIfp0A9CThFtz7RTJJ96vn5JKsdn4zo=;
        b=XoQyLvz24OoCRIOShkQNcu9DiR7bBkokC0zH2y0VsTYjxJfKw7R0siA80dncjT3YUK
         wAQolPJ8LMP2QAHMUANfaqPmSCX0C5CGSEEQPtRRcQTl1EKUo8gRIPdRN/yizwXOvk7a
         MyxLl0xOVUFh4CzE2lkyyns1y8zU/3BfW8wnjMepLuBa14dDIuRlcgHvnJy9KhXaOr8X
         f1b1b3SWDcQzR8oj41QVFoJZ6XqUPNURZphda8kDAwgTk/UUkxjzRis3jA/H1Gt2YM49
         MOGgQu1k2QTfbhGmrfPyoKrM3mYFHKWoquCiDY9UKYa1vj3gMvLKx5aFnrcD/cKhHcp4
         J8+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=c5tZw1PE5ja1kIfp0A9CThFtz7RTJJ96vn5JKsdn4zo=;
        b=U5B5//UCw1NXbo2scwqBFg38TxwRH3IiycN05CUTa6Am23xPa9mLhy3mtLnJGvNv/Q
         s42PMnrkoWbfp7t9Ryd7RFn4aVpXpDPyvHf520aKDpkiNSL/x2OyS6CKzpxTf3Anc4zj
         8joYLjNtX2CqCr9PmkA2D5u9Zepe5ChMRSJO/BqtlijT6+K39sUD+RTCTSET7kc44taA
         oxwbYtndMH4dTHzRn5QfFF76fWLvJDIO25FHvtV8IrSoZASfOt94QPZjA89R0g8gWPGK
         csXopPcXTsn7ihQwWEiPZOgMs4PxqnvEBcrgfUvrdVKUcN79twhv4Gy3vwXptmFr3X9F
         UVzg==
X-Gm-Message-State: AOAM531xCCSZT9paFIA/Oe0RszpZIcYjNxmBHGU3BR9sy8HQWUC3s1yC
        0wlKPicluEu0K5glcRAQaA0=
X-Google-Smtp-Source: ABdhPJz5DsUF3lCnv8yQA4dIwCqwn7lOEnqmDAyx9VQ48+J+hBL0/9GZGiwWD3mDm4r9zCHOflaTmA==
X-Received: by 2002:a17:902:9a42:b029:f5:1cf7:2e52 with SMTP id x2-20020a1709029a42b02900f51cf72e52mr16701852plv.25.1623053690127;
        Mon, 07 Jun 2021 01:14:50 -0700 (PDT)
Received: from ?IPv6:2404:f801:0:5:8000::4b1? ([2404:f801:9000:1a:efea::4b1])
        by smtp.gmail.com with ESMTPSA id r11sm8236573pgl.34.2021.06.07.01.14.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Jun 2021 01:14:49 -0700 (PDT)
Subject: Re: [RFC PATCH V3 01/11] x86/HV: Initialize GHCB page in Isolation VM
To:     Christoph Hellwig <hch@lst.de>
Cc:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        wei.liu@kernel.org, decui@microsoft.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, x86@kernel.org, hpa@zytor.com,
        arnd@arndb.de, dave.hansen@linux.intel.com, luto@kernel.org,
        peterz@infradead.org, akpm@linux-foundation.org,
        kirill.shutemov@linux.intel.com, rppt@kernel.org,
        hannes@cmpxchg.org, cai@lca.pw, krish.sadhukhan@oracle.com,
        saravanand@fb.com, Tianyu.Lan@microsoft.com,
        konrad.wilk@oracle.com, m.szyprowski@samsung.com,
        robin.murphy@arm.com, boris.ostrovsky@oracle.com, jgross@suse.com,
        sstabellini@kernel.org, joro@8bytes.org, will@kernel.org,
        xen-devel@lists.xenproject.org, davem@davemloft.net,
        kuba@kernel.org, jejb@linux.ibm.com, martin.petersen@oracle.com,
        iommu@lists.linux-foundation.org, linux-arch@vger.kernel.org,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, netdev@vger.kernel.org,
        vkuznets@redhat.com, thomas.lendacky@amd.com,
        brijesh.singh@amd.com, sunilmut@microsoft.com
References: <20210530150628.2063957-1-ltykernel@gmail.com>
 <20210530150628.2063957-2-ltykernel@gmail.com>
 <20210607064142.GA24478@lst.de>
From:   Tianyu Lan <ltykernel@gmail.com>
Message-ID: <37260f47-bd32-08f7-b006-f75f4d3c408a@gmail.com>
Date:   Mon, 7 Jun 2021 16:14:36 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210607064142.GA24478@lst.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Christoph:
	Thanks for your review.

On 6/7/2021 2:41 PM, Christoph Hellwig wrote:
> On Sun, May 30, 2021 at 11:06:18AM -0400, Tianyu Lan wrote:
>> +	if (ms_hyperv.ghcb_base) {
>> +		rdmsrl(MSR_AMD64_SEV_ES_GHCB, ghcb_gpa);
>> +
>> +		ghcb_va = ioremap_cache(ghcb_gpa, HV_HYP_PAGE_SIZE);
>> +		if (!ghcb_va)
>> +			return -ENOMEM;
> 
> Can you explain this a bit more?  We've very much deprecated
> ioremap_cache in favor of memremap.  Why yo you need a __iomem address
> here?  Why do we need the remap here at all? >

GHCB physical address is an address in extra address space which is 
above shared gpa boundary reported by Hyper-V CPUID. The addresses below
shared gpa boundary treated as encrypted and the one above is treated as 
decrypted. System memory is remapped in the extra address space and it 
starts from the boundary. The shared memory with host needs to use 
address in the extra address(pa + shared_gpa_boundary) in Linux guest.

Here is to map ghcb page for the communication operations with 
Hypervisor(e.g, hypercall and read/write MSR) via GHCB page.

memremap() will go through iomem_resource list and the address in extra 
address space will not be in the list. So I used ioremap_cache(). I will
memremap() instead of ioremap() here.

> Does the data structure at this address not have any types that we
> could use a struct for?

The struct will be added in the following patch. I will refresh the 
following patch and use the struct hv_ghcb for the mapped point.
> 
>> +
>> +		rdmsrl(MSR_AMD64_SEV_ES_GHCB, ghcb_gpa);
>> +		ghcb_va = ioremap_cache(ghcb_gpa, HV_HYP_PAGE_SIZE);
>> +		if (!ghcb_va) {
> 
> This seems to duplicate the above code.

The above is to map ghcb for BSP and here does the same thing for APs
Will add a new function to avoid the duplication.

> 
>> +bool hv_isolation_type_snp(void)
>> +{
>> +	return static_branch_unlikely(&isolation_type_snp);
>> +}
>> +EXPORT_SYMBOL_GPL(hv_isolation_type_snp);
> 
> This probably wants a kerneldoc explaining when it should be used. >

OK. I will add.

