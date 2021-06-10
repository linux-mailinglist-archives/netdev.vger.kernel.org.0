Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37C813A2E15
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 16:25:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231336AbhFJO1h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 10:27:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230153AbhFJO1g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 10:27:36 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 867CFC061574;
        Thu, 10 Jun 2021 07:25:24 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id k22-20020a17090aef16b0290163512accedso5574790pjz.0;
        Thu, 10 Jun 2021 07:25:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=9LfruKTSmGsaKr3T0KtsgMI2g1V5D5r+FfKoliRoTY8=;
        b=c3W9IY55kAGRSZQMUKIse7CYjATOc/WNsezUixaF5fWDkVciqS0+iWaZcHtL2rFFUw
         q6Af9zyVo5zJyfySRvKv8k+huR+szVR1Xb8GDyTonmbkQ3V0MoPt+EBqk/fvrUpoIhu0
         FpoCg5T+vTYyaf/IELWrWdHqeg6MOtolC1d7jn3ifj33bWYJ1rAiXRMyOW50J2wlpwFG
         OzCk7HbGROQ8oMztcbHmPooQ1M2yg6rOw9Gp0rsVbF3wVqRpT60yIqJM59aQu50FPywK
         5PKEXQwlOBjWNljf/CAPll8LJKaf8zXSJtCqfJmCU42oGpqB5i4sk/wWojxWFZDHy/Ps
         2toA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9LfruKTSmGsaKr3T0KtsgMI2g1V5D5r+FfKoliRoTY8=;
        b=T2G4mEfYrGXXBVm8dgrZKagV13bFY1A1h5Qq4PACuqFfIl5QWe1xp4uwe4SnckpWDZ
         OSFrJ82BHaCkdmhlYo2sK+D7VgKZU0VsSsdfH6v3owDUZcBa5pPg/5ehXFTWSu5LJOGM
         4oC8qT1/4BvnWnVdSMsQonN4LsXOPpO2aC/ng8IPEpRJgh5a2byoSZNClYvMGnZ5ogpv
         +GdYb8110SMZTCMI/fsWCyhVFpjNtdAaxT9Zs1jxPqhhhGg8HYWt1XjSSVcACAwzxuiK
         tQKd+GByD1vxHJVirQIl3USitpTOWN3t16Xd830rqrDksPcdB/mMKhm3UhtxFXcbITYR
         PhyQ==
X-Gm-Message-State: AOAM530EL4WiVuZJrwHe6k5KGYiiGLTdFc+l0/GqHytLu9oSLQ6VjrFz
        vHYFGzLDx4ENRmclKn5FuRE=
X-Google-Smtp-Source: ABdhPJzdwp2MX3HMzPasMcsmUlDqisDdNAsXcZ2anZ9ouahX31714ETLaZ+TtT/Nrt8h3xRgpVym6w==
X-Received: by 2002:a17:90a:7bce:: with SMTP id d14mr3702065pjl.38.1623335123951;
        Thu, 10 Jun 2021 07:25:23 -0700 (PDT)
Received: from ?IPv6:2404:f801:0:5:8000::4b1? ([2404:f801:9000:1a:efea::4b1])
        by smtp.gmail.com with ESMTPSA id 1sm8338487pjm.8.2021.06.10.07.25.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Jun 2021 07:25:23 -0700 (PDT)
Subject: Re: [RFC PATCH V3 08/11] swiotlb: Add bounce buffer remap address
 setting function
From:   Tianyu Lan <ltykernel@gmail.com>
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
 <20210530150628.2063957-9-ltykernel@gmail.com>
 <20210607064312.GB24478@lst.de>
 <48516ce3-564c-419e-b355-0ce53794dcb1@gmail.com>
Message-ID: <9c05f7fd-6460-5d4a-aa83-08626839d18e@gmail.com>
Date:   Thu, 10 Jun 2021 22:25:10 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <48516ce3-564c-419e-b355-0ce53794dcb1@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/7/2021 10:56 PM, Tianyu Lan wrote:
> 
> On 6/7/2021 2:43 PM, Christoph Hellwig wrote:
>> On Sun, May 30, 2021 at 11:06:25AM -0400, Tianyu Lan wrote:
>>> From: Tianyu Lan <Tianyu.Lan@microsoft.com>
>>>
>>> For Hyper-V isolation VM with AMD SEV SNP, the bounce buffer(shared 
>>> memory)
>>> needs to be accessed via extra address space(e.g address above bit39).
>>> Hyper-V code may remap extra address space outside of swiotlb. swiotlb_
>>> bounce() needs to use remap virtual address to copy data from/to bounce
>>> buffer. Add new interface swiotlb_set_bounce_remap() to do that.
>>
>> Why can't you use the bus_dma_region ranges to remap to your preferred
>> address?
>>
> 
> Thanks for your suggestion.
> 
> These addresses in extra address space works as system memory mirror. 
> The shared memory with host in Isolation VM needs to be accessed via 
> extra address space which is above shared gpa boundary. During 
> initializing swiotlb bounce buffer pool, only address bellow shared gpa 
> boundary can be accepted by swiotlb API because it is treated as system 
> memory and managed by memory management. This is why Hyper-V swiotlb 
> bounce buffer pool needs to be allocated in Hyper-V code and map
> associated physical address in extra address space. The patch target is
> to add the new interface to set start virtual address of bounce buffer
> pool and let swiotlb boucne buffer copy function to use right virtual 
> address for extra address space.
> 
> bus_dma_region is to translate cpu physical address to dma address.
> It can't modify the virtual address of bounce buffer pool and let
> swiotlb code to copy data with right address. If some thing missed,
> please correct me.
> 

Hi Christoph:
	Sorry to bother you. Could you have a look at my previous reply?
I try figuring out the right way.

Thanks.
