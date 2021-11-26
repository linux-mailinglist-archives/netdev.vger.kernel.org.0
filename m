Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38A1245EDAA
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 13:12:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232042AbhKZMP3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Nov 2021 07:15:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377339AbhKZMN3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Nov 2021 07:13:29 -0500
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30F84C0619E0;
        Fri, 26 Nov 2021 03:39:17 -0800 (PST)
Received: by mail-pf1-x435.google.com with SMTP id p13so1024842pfw.2;
        Fri, 26 Nov 2021 03:39:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=ambWW/4YEyu662pYE46PBmuDJfo9av+csYLqJQyv9eI=;
        b=be/+Ee7qIA99Wogw9aDbu8FGuY+NkyZyPMuDQQQMyfJu74GW/p4hwR7Uk3SV8SOWot
         OTvvRslVrIRWr+jhwF4djz3GnmhzFxoTjzdSB66EYMTFp4ObhQoXBUaxMmS0E8ljOC5C
         BvMJB5gq9CLv6RX+bLXdcwcuXLE+FMY5lUFCbxIImkmK67mwpllFQSs45yZerfLFiBCR
         DbhWdfqUQ3x6YsTjsY/25enAc6WD87puZv3GLXecg2pr4iVTltkGoYwbxLChdmS97p73
         BAHuN7hbOH9DJ41QGZsyZO96dnKzD8IZFOupSItaLv9c137ht8NLB+g2Qd6+KKgLGpSA
         nk6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ambWW/4YEyu662pYE46PBmuDJfo9av+csYLqJQyv9eI=;
        b=S5+c/cfo7ZU8D+LjNbTGkk3UFkdKKUpmHnQsN2v0WOjqoif9Q+ccKd+9ifcNuejygq
         gkfwSCsEzd1UAO2lRx30M2+78NJqp/MtkoXSsFGEg9SilZ66gr79kFi3CbiGiEJ5IKyh
         SPTW0mb4rzsBU1uTfq0tN8FFbWf8In9BmbsrOqCr3NUjMWMSJA9Buoc1VgHnUb9jYGqH
         8e+ekpCf0z3kMNJ/bl8riwtUIyZEM3NOFKR1d6Ii9Y9WOblduyEU22ATNi7jx1+OW1j4
         6wCeEY+2CXo2vG1vChVGqBPIZVyeC77ek51HTomluaPZOJRDEMTNFlEPBw9NxfdvKcP6
         Udcg==
X-Gm-Message-State: AOAM533UW3JqewjFv/52R8TPlYFwwrLlE0H8H6XB9OMlqI7cp5lGoUkh
        Tg1NAZ53TR6hFwFWogPz5ug=
X-Google-Smtp-Source: ABdhPJyqblxnRgV5wg5BPP9Vi1R0NhHs6AkjTX8lIUxkdCJzlfse/09nmYdMwJ3MumBswrLh4eDT7g==
X-Received: by 2002:a65:5a8e:: with SMTP id c14mr20429967pgt.241.1637926756738;
        Fri, 26 Nov 2021 03:39:16 -0800 (PST)
Received: from ?IPV6:2404:f801:0:5:8000::50b? ([2404:f801:9000:18:efec::50b])
        by smtp.gmail.com with ESMTPSA id f21sm7243932pfe.69.2021.11.26.03.39.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Nov 2021 03:39:16 -0800 (PST)
Message-ID: <e874b4c3-1d09-8d2a-bd59-80bae7e554d6@gmail.com>
Date:   Fri, 26 Nov 2021 19:39:03 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.1
Subject: Re: [PATCH 3/5] hyperv/IOMMU: Enable swiotlb bounce buffer for
 Isolation VM
Content-Language: en-US
To:     Christoph Hellwig <hch@lst.de>
Cc:     dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, x86@kernel.org,
        hpa@zytor.com, jgross@suse.com, sstabellini@kernel.org,
        boris.ostrovsky@oracle.com, kys@microsoft.com,
        haiyangz@microsoft.com, sthemmin@microsoft.com, wei.liu@kernel.org,
        decui@microsoft.com, joro@8bytes.org, will@kernel.org,
        davem@davemloft.net, kuba@kernel.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, m.szyprowski@samsung.com,
        robin.murphy@arm.com, xen-devel@lists.xenproject.org,
        michael.h.kelley@microsoft.com,
        Tianyu Lan <Tianyu.Lan@microsoft.com>,
        iommu@lists.linux-foundation.org, linux-hyperv@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        netdev@vger.kernel.org, vkuznets@redhat.com, brijesh.singh@amd.com,
        konrad.wilk@oracle.com, parri.andrea@gmail.com,
        thomas.lendacky@amd.com, dave.hansen@intel.com
References: <20211116153923.196763-1-ltykernel@gmail.com>
 <20211116153923.196763-4-ltykernel@gmail.com> <20211117100142.GB10330@lst.de>
 <c93bf3d4-75c1-bc3d-2789-1d65e7c19158@gmail.com>
 <20211126074022.GA23659@lst.de>
From:   Tianyu Lan <ltykernel@gmail.com>
In-Reply-To: <20211126074022.GA23659@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/26/2021 3:40 PM, Christoph Hellwig wrote:
> On Wed, Nov 17, 2021 at 10:00:08PM +0800, Tianyu Lan wrote:
>> On 11/17/2021 6:01 PM, Christoph Hellwig wrote:
>>> This doesn't really have much to do with normal DMA mapping,
>>> so why does this direct through the dma ops?
>>>
>>
>> According to the previous discussion, dma_alloc_noncontigous()
>> and dma_vmap_noncontiguous() may be used to handle the noncontigous
>> memory alloc/map in the netvsc driver. So add alloc/free and vmap/vunmap
>> callbacks here to handle the case. The previous patch v4 & v5 handles
>> the allocation and map in the netvsc driver. If this should not go though
>> dma ops, We also may make it as vmbus specific function and keep
>> the function in the vmbus driver.
> 
> But that only makes sense if they can actually use the normal DMA ops.
> If you implement your own incomplete ops and require to use them you
> do nothing but adding indirect calls to your fast path and making the
> code convoluted.
> 

Because the generic part implementation can't meet the netvsc driver
requests that allocate 16M memory and map pages via vmap_pfn(). So add 
Hyperv alloc_noncontiguous and vmap_noncontiguous callbacks. If this is
not a right way. we should call these hyper-V functions in the netvsc
driver directly, right?

Could you have a look at Michael summary about this series we made and
give some guides?

https://www.mail-archive.com/xen-devel@lists.xenproject.org/msg109284.html

Thanks.





