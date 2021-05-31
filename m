Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A88E8395456
	for <lists+netdev@lfdr.de>; Mon, 31 May 2021 06:08:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230008AbhEaEKW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 May 2021 00:10:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbhEaEKP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 May 2021 00:10:15 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 467B6C061574;
        Sun, 30 May 2021 21:08:36 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id r1so7367975pgk.8;
        Sun, 30 May 2021 21:08:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=B5E+Z+YC3ztWK1Gz5JJ/ZjFYfV7x7WXsq6pvj4QOEV8=;
        b=qpIh0hZZdMUbO/xaXOluESyDyKh1wuXDzVMU8DbvilQdbzUAKKvtHMi2tZHdZZl6FD
         pzHWR1qJ9SA0OUooLhgYA/FHAGzMTwF85gH2zMJXOjHY8akNBlPm2ZAFPL/BsX6AECn0
         g+snaripSV02Ww2TMRpmrTPml1udHoN6L4hr2lbSznbW+9RR1UtQlYNf3WxE5hsOWUtQ
         ktECgJ1y4SLarJMnSz0M8Q7rpMoLOq1xtTjLcSnDW6jj68DsuSfsO/MEvpsp4a3+Pm5b
         T6ij0KxeYE/ElhOhht4tRwlDS7A1Bc2B1m97gM084MLnflqwYjE/MK2P0UCAVk17tm4z
         0i8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=B5E+Z+YC3ztWK1Gz5JJ/ZjFYfV7x7WXsq6pvj4QOEV8=;
        b=mbI6AAUZRHYlCRmGziwGa1xARwPaosVg8IJFq2FPK3vwVGCyYYU0YoVbnozfJE/Ljx
         5quYyeilqUBLsUwM4NLGlBbZ+gEapIiOGMBd3mYn7dk284hGxWZDX346VvZakZUU/fuL
         sep16M/UWddyD9DO09h7ksMNYcsCW+fAS80315JOYVG/n4qAJfEA+mYM67Vlcy9jyGhB
         simojDdDV5fnmra0R7t3IPDZn7j9CDiiXSgZl/ORcleI9dsSAxP6RxPlqF6dZqPR58Pi
         3+vacqjMyw9nX6g7++QR7e5eApW3eXdxQpeNFIYrXklBR2cO/C4Hu9m/7bGzMgmRpJKj
         WlWQ==
X-Gm-Message-State: AOAM531q+ZZLHb6DMBM0WwKjuDh9qvWLooSnxHrYUmRgGsx0A82xuDCK
        lQ3RCgO038sHhUx8/yfKEPg=
X-Google-Smtp-Source: ABdhPJx+HANXtJX9yvLkBX/HVsORb2hbS4daFpETnK5c9NyvtRnVmWON27YgYVQ2Kp8imni+2oGhjA==
X-Received: by 2002:a63:5a43:: with SMTP id k3mr21331103pgm.308.1622434115432;
        Sun, 30 May 2021 21:08:35 -0700 (PDT)
Received: from ?IPv6:2404:f801:0:5:8000::4b1? ([2404:f801:9000:1a:efea::4b1])
        by smtp.gmail.com with ESMTPSA id v4sm4275222pfn.41.2021.05.30.21.08.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 30 May 2021 21:08:35 -0700 (PDT)
Subject: Re: [RFC PATCH V3 03/11] x86/Hyper-V: Add new hvcall guest address
 host visibility support
To:     Borislav Petkov <bp@alien8.de>
Cc:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        wei.liu@kernel.org, decui@microsoft.com, tglx@linutronix.de,
        mingo@redhat.com, x86@kernel.org, hpa@zytor.com, arnd@arndb.de,
        dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
        akpm@linux-foundation.org, kirill.shutemov@linux.intel.com,
        rppt@kernel.org, hannes@cmpxchg.org, cai@lca.pw,
        krish.sadhukhan@oracle.com, saravanand@fb.com,
        Tianyu.Lan@microsoft.com, konrad.wilk@oracle.com, hch@lst.de,
        m.szyprowski@samsung.com, robin.murphy@arm.com,
        boris.ostrovsky@oracle.com, jgross@suse.com,
        sstabellini@kernel.org, joro@8bytes.org, will@kernel.org,
        xen-devel@lists.xenproject.org, davem@davemloft.net,
        kuba@kernel.org, jejb@linux.ibm.com, martin.petersen@oracle.com,
        iommu@lists.linux-foundation.org, linux-arch@vger.kernel.org,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, netdev@vger.kernel.org,
        vkuznets@redhat.com, thomas.lendacky@amd.com,
        brijesh.singh@amd.com, sunilmut@microsoft.com
References: <20210530150628.2063957-1-ltykernel@gmail.com>
 <20210530150628.2063957-4-ltykernel@gmail.com> <YLPYqxF7urDIAd9z@zn.tnic>
From:   Tianyu Lan <ltykernel@gmail.com>
Message-ID: <3716c9e0-2508-3553-5a70-e4b3f5f4c82e@gmail.com>
Date:   Mon, 31 May 2021 12:08:21 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <YLPYqxF7urDIAd9z@zn.tnic>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Borislav:
	Thanks for your review.

On 5/31/2021 2:25 AM, Borislav Petkov wrote:
> On Sun, May 30, 2021 at 11:06:20AM -0400, Tianyu Lan wrote:
>> diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
>> index 156cd235659f..a82975600107 100644
>> --- a/arch/x86/mm/pat/set_memory.c
>> +++ b/arch/x86/mm/pat/set_memory.c
>> @@ -29,6 +29,8 @@
>>   #include <asm/proto.h>
>>   #include <asm/memtype.h>
>>   #include <asm/set_memory.h>
>> +#include <asm/hyperv-tlfs.h>
>> +#include <asm/mshyperv.h>
>>   
>>   #include "../mm_internal.h"
>>   
>> @@ -1986,8 +1988,14 @@ static int __set_memory_enc_dec(unsigned long addr, int numpages, bool enc)
>>   	int ret;
>>   
>>   	/* Nothing to do if memory encryption is not active */
>> -	if (!mem_encrypt_active())
>> +	if (hv_is_isolation_supported()) {
>> +		return hv_set_mem_host_visibility((void *)addr,
>> +				numpages * HV_HYP_PAGE_SIZE,
>> +				enc ? VMBUS_PAGE_NOT_VISIBLE
>> +				: VMBUS_PAGE_VISIBLE_READ_WRITE);
> 
> Put all this gunk in a hv-specific function somewhere in hv-land which
> you only call from here. This way you probably won't even need to export
> hv_set_mem_host_visibility() and so on...
> 

Good idea. Will update. Thanks.


