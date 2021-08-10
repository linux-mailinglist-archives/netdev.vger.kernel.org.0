Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67D903E5ABB
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 15:09:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241056AbhHJNJy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 09:09:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238793AbhHJNJx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Aug 2021 09:09:53 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B94DDC0613D3;
        Tue, 10 Aug 2021 06:09:31 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id mq2-20020a17090b3802b0290178911d298bso5285565pjb.1;
        Tue, 10 Aug 2021 06:09:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=66KGVVLHGJOMxSHzgJj6VDCRB8/apj3sR/Ynuos6wU8=;
        b=pt4Qw4Gt2cFRP884fMrdBTfJzkwL2gx6Mo1qS6xvvDhfSdIustLAFX7++VkRY1h4um
         tTehujaFm9rbEjIEwB0Xu4QM2VZRfXhLGrMo8JNp/sDj6XoPD9WPfZ8v2F3qn2rH9A9d
         OGCnPFdaPpTRfjqukxIeWiIpd6XfYc4MZvSVh7tbwIwGO2vT6u6skC56ab4LGrfYsBku
         cbFUdZZjMM6VnimGAjkoLRcPks9PLwbJP0vFH3G0Hbv47WNqW4yslC4eCkDCDu113c9j
         ijT0klWyzKut4iQ2YBiKGjugVqCFd+8zcrAniUpAohoQSh6qC1V2Qr33L9WPJqBDjAdX
         IuxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=66KGVVLHGJOMxSHzgJj6VDCRB8/apj3sR/Ynuos6wU8=;
        b=frCKtQI1YS38Xm+X5OX3SvlTItm+3OFg53bIjvJol3QyTBtKAao5HDsf05rra10xEQ
         3LhKLa+5kDdYs5rD482BLg0VjVRwc2LJREAVoertWp35Vjs/bF1bvOV99jACjCf6tQA0
         rAsLeXQy3Ust2M+EdzDFZnSannd+fOtYzW/EHx2qrzVaHA9ATVEg9dC0BZG66IZ+l7rT
         789gTMysdJz7yuPsNNQ/n7Ft3IJVvnA0Vq/gVKOKgHM4rE6hHZ0jbPzJrRKDfYjGuvya
         iMoV/SUgOZv+VWMmLQlY3KVPKgtK0pK26E0F7YqNzAO7ZCQ6G2Vb9c7p3Y4FhVcWBBwN
         ojTA==
X-Gm-Message-State: AOAM530pX6KVNFGpGSsSsjx0Qv3es1RvOd0h8P5UcbcPtRHUvwcZlCS/
        9bhRKUw293Oa0hs/5RNSppk=
X-Google-Smtp-Source: ABdhPJzfPih5Ybmexq3iu0hKNG6YxeEAVSzL4u+nolQ/+flfaaM1LfzobnQ7JyAdR0R5YSEGRoeWmg==
X-Received: by 2002:aa7:8f05:0:b029:3b4:ff54:9a10 with SMTP id x5-20020aa78f050000b02903b4ff549a10mr29132627pfr.29.1628600971342;
        Tue, 10 Aug 2021 06:09:31 -0700 (PDT)
Received: from ?IPv6:2404:f801:0:5:8000::4b1? ([2404:f801:9000:18:efec::4b1])
        by smtp.gmail.com with ESMTPSA id c9sm22240121pgq.58.2021.08.10.06.09.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Aug 2021 06:09:30 -0700 (PDT)
Subject: Re: [PATCH V3 03/13] x86/HV: Add new hvcall guest address host
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
        Tianyu.Lan@microsoft.com, pgonda@google.com,
        martin.b.radev@gmail.com, akpm@linux-foundation.org,
        kirill.shutemov@linux.intel.com, rppt@kernel.org,
        sfr@canb.auug.org.au, saravanand@fb.com,
        krish.sadhukhan@oracle.com, aneesh.kumar@linux.ibm.com,
        xen-devel@lists.xenproject.org, rientjes@google.com,
        hannes@cmpxchg.org, tj@kernel.org, michael.h.kelley@microsoft.com
Cc:     iommu@lists.linux-foundation.org, linux-arch@vger.kernel.org,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, netdev@vger.kernel.org,
        vkuznets@redhat.com, parri.andrea@gmail.com
References: <20210809175620.720923-1-ltykernel@gmail.com>
 <20210809175620.720923-4-ltykernel@gmail.com>
 <a0499916-38e2-0b1e-f2b9-ef760f6d4d92@intel.com>
From:   Tianyu Lan <ltykernel@gmail.com>
Message-ID: <3f09c505-3e4d-3b06-e92a-db6fd3e50d0c@gmail.com>
Date:   Tue, 10 Aug 2021 21:09:16 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <a0499916-38e2-0b1e-f2b9-ef760f6d4d92@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/10/2021 6:12 AM, Dave Hansen wrote:
> On 8/9/21 10:56 AM, Tianyu Lan wrote:
>> From: Tianyu Lan <Tianyu.Lan@microsoft.com>
>>
>> Add new hvcall guest address host visibility support to mark
>> memory visible to host. Call it inside set_memory_decrypted
>> /encrypted(). Add HYPERVISOR feature check in the
>> hv_is_isolation_supported() to optimize in non-virtualization
>> environment.
> 
>  From an x86/mm perspective:
> 
> Acked-by: Dave Hansen <dave.hansen@intel.com>
> 

Thanks for your ACK.


> A tiny nit:
> 
>> diff --git a/arch/x86/hyperv/hv_init.c b/arch/x86/hyperv/hv_init.c
>> index 0bb4d9ca7a55..b3683083208a 100644
>> --- a/arch/x86/hyperv/hv_init.c
>> +++ b/arch/x86/hyperv/hv_init.c
>> @@ -607,6 +607,12 @@ EXPORT_SYMBOL_GPL(hv_get_isolation_type);
>>   
>>   bool hv_is_isolation_supported(void)
>>   {
>> +	if (!cpu_feature_enabled(X86_FEATURE_HYPERVISOR))
>> +		return 0;
>> +
>> +	if (!hypervisor_is_type(X86_HYPER_MS_HYPERV))
>> +		return 0;
>> +
>>   	return hv_get_isolation_type() != HV_ISOLATION_TYPE_NONE;
>>   }
> This might be worthwhile to move to a header.  That ensures that
> hv_is_isolation_supported() use can avoid even a function call.  But, I
> see this is used in modules and its use here is also in a slow path, so
> it's not a big deal
> 

I will move it to header in the following version.


Thanks.
