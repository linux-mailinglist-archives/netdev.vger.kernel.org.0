Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 514423A2DF0
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 16:20:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230487AbhFJOV6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 10:21:58 -0400
Received: from mail-pf1-f173.google.com ([209.85.210.173]:40837 "EHLO
        mail-pf1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230084AbhFJOV4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 10:21:56 -0400
Received: by mail-pf1-f173.google.com with SMTP id q25so1744617pfh.7;
        Thu, 10 Jun 2021 07:20:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=S7U7wM1689XPFk0ln7YagGhi2kwC7oBCIYjLHGTATmA=;
        b=j1ssCm/VIao3T0Xc2kwXH6tQqWfrySQ1IoYffbIUZhSffD09z3SFuktT6padpAZaa/
         O6dOSr9MfmJ3BaiaCjc0PA9hj1D56rpnhXvTnUEKbRnxOiqwlkMuTGEQqMho8+laNO3A
         Ps4g2Ewhuj5lqgG3+vb3Pr6h4xORMt0ouVqwcSeoFvA+lTlqRvdEpC++3hJnHyetmZQS
         Y1STui7T1ekgTq6zzEkx3p9dSbyB7UT0DfPgF2o16fgVpJiH+bKr87Q/n9chxbr1Li1Z
         sUz1mgnrmF2Vvd/rNoSeF09YxbBnVBhhC9qN6Rqm62kNLgrUCEgGYVPXMjW1fXotfIvd
         p8kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=S7U7wM1689XPFk0ln7YagGhi2kwC7oBCIYjLHGTATmA=;
        b=kWJ0n92EMSemDX8LCjIXl8nXzyu0NXPmNfJA/KwwaLVT59wFJ6d9CXrx+1thVckuQm
         OloP7fD0zPnEPSKzo++vi2GpXMKgMFR/69Qr5ezRaGS7CT3OhhJOraSAJ1899mXft0ke
         sbA8v7XnLGOa65igfE9KGrhkGaGO57CB9CpaADqu8QKMlv4xBpEtLL3wX5/xdLkcBro/
         kT9X8WOy5QW5ISwoWH+0SuOyacepYUq/T2TupIAwYzL+P1cejLGpBoYqCt73P8PEvvay
         cBUDhpdVdZWwmxPf4okrjk+DLXa9pab5VZTbSZii8ZYigACwvLmaAqoMQ2p6eQO4oEQE
         dsrg==
X-Gm-Message-State: AOAM530Bxq8Bw8GdvqHfhlwO8NSPrVUZZD9qoYds0///pQywi5vf1hvT
        0I3PrlCNQA8LquJmQjTlWO0=
X-Google-Smtp-Source: ABdhPJykpYU7kOZkoptn+vRUH+LpqhlVAnDQIkp8KIQpRwT8RFYkpZNT1LtsR90ESObN7s+cfunBTA==
X-Received: by 2002:a63:7404:: with SMTP id p4mr5123864pgc.405.1623334740224;
        Thu, 10 Jun 2021 07:19:00 -0700 (PDT)
Received: from ?IPv6:2404:f801:0:5:8000::4b1? ([2404:f801:9000:1a:efea::4b1])
        by smtp.gmail.com with ESMTPSA id s22sm2725797pfd.94.2021.06.10.07.18.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Jun 2021 07:18:59 -0700 (PDT)
Subject: Re: [RFC PATCH V3 03/11] x86/Hyper-V: Add new hvcall guest address
 host visibility support
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kys@microsoft.com,
        haiyangz@microsoft.com, sthemmin@microsoft.com, wei.liu@kernel.org,
        decui@microsoft.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, x86@kernel.org, hpa@zytor.com, arnd@arndb.de,
        dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
        akpm@linux-foundation.org, kirill.shutemov@linux.intel.com,
        rppt@kernel.org, hannes@cmpxchg.org, cai@lca.pw,
        krish.sadhukhan@oracle.com, saravanand@fb.com,
        Tianyu.Lan@microsoft.com, konrad.wilk@oracle.com, hch@lst.de,
        m.szyprowski@samsung.com, robin.murphy@arm.com,
        boris.ostrovsky@oracle.com, jgross@suse.com,
        sstabellini@kernel.org, joro@8bytes.org, will@kernel.org,
        xen-devel@lists.xenproject.org, davem@davemloft.net,
        kuba@kernel.org, jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     iommu@lists.linux-foundation.org, linux-arch@vger.kernel.org,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, netdev@vger.kernel.org,
        thomas.lendacky@amd.com, brijesh.singh@amd.com,
        sunilmut@microsoft.com
References: <20210530150628.2063957-1-ltykernel@gmail.com>
 <20210530150628.2063957-4-ltykernel@gmail.com>
 <878s3iyrtg.fsf@vitty.brq.redhat.com>
From:   Tianyu Lan <ltykernel@gmail.com>
Message-ID: <2a0170a9-e4d5-1c63-7901-416094f6ab64@gmail.com>
Date:   Thu, 10 Jun 2021 22:18:45 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <878s3iyrtg.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vitaly:
	Thanks for your review.

On 6/10/2021 5:47 PM, Vitaly Kuznetsov wrote:
>> diff --git a/arch/x86/include/asm/hyperv-tlfs.h b/arch/x86/include/asm/hyperv-tlfs.h
>> index 606f5cc579b2..632281b91b44 100644
>> --- a/arch/x86/include/asm/hyperv-tlfs.h
>> +++ b/arch/x86/include/asm/hyperv-tlfs.h
>> @@ -262,6 +262,17 @@ enum hv_isolation_type {
>>   #define HV_X64_MSR_TIME_REF_COUNT	HV_REGISTER_TIME_REF_COUNT
>>   #define HV_X64_MSR_REFERENCE_TSC	HV_REGISTER_REFERENCE_TSC
>>   
>> +/* Hyper-V GPA map flags */
>> +#define HV_MAP_GPA_PERMISSIONS_NONE            0x0
>> +#define HV_MAP_GPA_READABLE                    0x1
>> +#define HV_MAP_GPA_WRITABLE                    0x2
>> +
>> +enum vmbus_page_visibility {
>> +	VMBUS_PAGE_NOT_VISIBLE = 0,
>> +	VMBUS_PAGE_VISIBLE_READ_ONLY = 1,
>> +	VMBUS_PAGE_VISIBLE_READ_WRITE = 3
>> +};
>> +
> Why do we need both flags and the enum? I don't see HV_MAP_GPA_* being
> used anywhere and VMBUS_PAGE_VISIBLE_READ_WRITE looks like
> HV_MAP_GPA_READABLE | HV_MAP_GPA_WRITABLE.
> 
> As this is used to communicate with the host, I'd suggest to avoid using
> enum and just use flags everywhere.
> 

Nice catch. Will update in the next version.

Thanks.
