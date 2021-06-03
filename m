Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5B4C39A4C4
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 17:38:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230033AbhFCPkH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 11:40:07 -0400
Received: from mail-pg1-f172.google.com ([209.85.215.172]:38543 "EHLO
        mail-pg1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229881AbhFCPkF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Jun 2021 11:40:05 -0400
Received: by mail-pg1-f172.google.com with SMTP id 6so5435014pgk.5;
        Thu, 03 Jun 2021 08:38:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=BVYx1tfLGUQhuXKxLmm7FvDthvCK68hj9EtKYIRIQHQ=;
        b=miB2ljSk1RA9tY/uYJGQ9mMwA4UDMc4OP5R2SPNH1XSMN+zppyZP3Jc++5YNxmzOby
         kALkMRui/3t9gSuqF33Vb3xRJqf9zGMvEy1ThQuUuoC56/3xsrdMaI/j4lWWgNSF2sTJ
         COY0x0gCbiM503+Xvvp9Nsgl9aAqJhwkWUkCuJddQ5kBPKpL6maIzV4Esr2iyVTK2nDK
         TGTOiLPti6ZFCSfL7YPGf1T/ifO0Td+1Cseob26JVYcCljKap3dtfQjqMVk0i9iDWAeR
         pRTkE5bQUe239zrqx8ZeVhOf2I48ijf3+Yv7Odtm6yW32eQYlYwHea3YOPPmHlNYafZU
         cDkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=BVYx1tfLGUQhuXKxLmm7FvDthvCK68hj9EtKYIRIQHQ=;
        b=MBzkjYyU1bxPKcJPl/hmKhXY3+KqqWIVGjA76UkYWqFAz5VmhLCHAh8jYAUCBqxFWc
         NMhkYUDJz94pq+srIlyKRCe3S4uUO23JZy+j5vP3+ft56bzsK5igOM524tCIcfAGTEdf
         1+zZ2AMSTlmdBVGbiECAjUvXYCCbGx2trpg6ChylnIvrzIKNfh1sAUjTMqIXUOAp2H4l
         g6NzkhNmGy/1Ung9cLmf+WjXRDZEAPUkJtdRaQxvAWqpDOy6jk5j1+sphx9ZCXmP3hPs
         yYjGKl18URdA06g3v/yjM0NpVfkTLFA04pfkdZPNZONF7gOoUA5pDwMh43OS3ZQSWNE4
         ogpQ==
X-Gm-Message-State: AOAM530t5ftDZxmCRn8F+9X+Xj8RdIUZ10Bwt42oC4WuZlB2kG6eQfmb
        6PLiJ+nsDyPjIouQhN07TwI=
X-Google-Smtp-Source: ABdhPJyuSSLvdEikeh+Nq/zhDPHcKBsCeWjVlIXCtWnktcvNT96pyk1AlIWziUacbt3mBXpwaDz9WA==
X-Received: by 2002:aa7:8755:0:b029:2eb:8c8f:d1f1 with SMTP id g21-20020aa787550000b02902eb8c8fd1f1mr271415pfo.11.1622734640422;
        Thu, 03 Jun 2021 08:37:20 -0700 (PDT)
Received: from ?IPv6:2404:f801:0:5:8000::4b1? ([2404:f801:9000:18:efec::4b1])
        by smtp.gmail.com with ESMTPSA id r10sm3237979pga.48.2021.06.03.08.37.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Jun 2021 08:37:19 -0700 (PDT)
Subject: Re: [RFC PATCH V3 09/11] HV/IOMMU: Enable swiotlb bounce buffer for
 Isolation VM
To:     Boris Ostrovsky <boris.ostrovsky@oracle.com>, kys@microsoft.com,
        haiyangz@microsoft.com, sthemmin@microsoft.com, wei.liu@kernel.org,
        decui@microsoft.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, x86@kernel.org, hpa@zytor.com, arnd@arndb.de,
        dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
        akpm@linux-foundation.org, kirill.shutemov@linux.intel.com,
        rppt@kernel.org, hannes@cmpxchg.org, cai@lca.pw,
        krish.sadhukhan@oracle.com, saravanand@fb.com,
        Tianyu.Lan@microsoft.com, konrad.wilk@oracle.com, hch@lst.de,
        m.szyprowski@samsung.com, robin.murphy@arm.com, jgross@suse.com,
        sstabellini@kernel.org, joro@8bytes.org, will@kernel.org,
        xen-devel@lists.xenproject.org, davem@davemloft.net,
        kuba@kernel.org, jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     iommu@lists.linux-foundation.org, linux-arch@vger.kernel.org,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, netdev@vger.kernel.org,
        vkuznets@redhat.com, thomas.lendacky@amd.com,
        brijesh.singh@amd.com, sunilmut@microsoft.com
References: <20210530150628.2063957-1-ltykernel@gmail.com>
 <20210530150628.2063957-10-ltykernel@gmail.com>
 <9488c114-81ad-eb67-79c0-5ed319703d3e@oracle.com>
 <a023ee3f-ce85-b54f-79c3-146926bf3279@gmail.com>
 <d6714e8b-dcb6-798b-59a4-5bb68f789564@oracle.com>
From:   Tianyu Lan <ltykernel@gmail.com>
Message-ID: <1cdf4e6e-6499-e209-d499-7ab82992040b@gmail.com>
Date:   Thu, 3 Jun 2021 23:37:06 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <d6714e8b-dcb6-798b-59a4-5bb68f789564@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/3/2021 12:02 AM, Boris Ostrovsky wrote:
> 
> On 6/2/21 11:01 AM, Tianyu Lan wrote:
>> Hi Boris:
>>      Thanks for your review.
>>
>> On 6/2/2021 9:16 AM, Boris Ostrovsky wrote:
>>>
>>> On 5/30/21 11:06 AM, Tianyu Lan wrote:
>>>> @@ -91,6 +92,6 @@ int pci_xen_swiotlb_init_late(void)
>>>>    EXPORT_SYMBOL_GPL(pci_xen_swiotlb_init_late);
>>>>      IOMMU_INIT_FINISH(2,
>>>> -          NULL,
>>>> +          hyperv_swiotlb_detect,
>>>>              pci_xen_swiotlb_init,
>>>>              NULL);
>>>
>>>
>>> Could you explain this change?
>>
>> Hyper-V allocates its own swiotlb bounce buffer and the default
>> swiotlb buffer should not be allocated. swiotlb_init() in pci_swiotlb_init() is to allocate default swiotlb buffer.
>> To achieve this, put hyperv_swiotlb_detect() as the first entry in the iommu_table_entry list. The detect loop in the pci_iommu_alloc() will exit once hyperv_swiotlb_detect() is called in Hyper-V VM and other iommu_table_entry callback will not be called.
> 
> 
> 
> Right. But pci_xen_swiotlb_detect() will only do something for Xen PV guests, and those guests don't run on hyperV. It's either xen_pv_domain() (i.e. hypervisor_is_type(X86_HYPER_XEN_PV)) or hypervisor_is_type(X86_HYPER_MS_HYPERV) but never both. So I don't think there needs to be a dependency between the two callbacks.

Yes, the dependency is between hyperv_swiotlb_detect() and
pci_swiotlb_detect_override()/pci_swiotlb_detect_4gb(). Now
pci_swiotlb_detect_override() and pci_swiotlb_detect_4gb() depends on
pci_xen_swiotlb_detect(). To keep dependency between
hyperv_swiotlb_detect() and pci_swiotlb_detect_override/4gb(), make 
pci_xen_swiotlb_detect() depends on hyperv_swiotlb_detect() and just to
keep order in the IOMMU table. Current iommu_table_entry only has one
depend callback and this is why I put xen depends on hyperv detect function.

Thanks.
