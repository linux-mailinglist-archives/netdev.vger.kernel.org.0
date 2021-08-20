Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B91633F2F9E
	for <lists+netdev@lfdr.de>; Fri, 20 Aug 2021 17:38:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241183AbhHTPi4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Aug 2021 11:38:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241159AbhHTPiw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Aug 2021 11:38:52 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1213DC061575;
        Fri, 20 Aug 2021 08:38:12 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id o2so9544148pgr.9;
        Fri, 20 Aug 2021 08:38:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=dVOZ4z0XPa7OayGE8ECMnwdJyIdPwvP3nXcnH8MPASM=;
        b=A/zNrhCd3U9O9ero/5NghZBre9EOOjJ3OGobszwgvGoiOz7/5WsjufLewqFNiAvU0v
         UdflMS96g40+NfLrBAqJeCjCdymuciBQ80Yx/AQ8ITRU/L7SATQ2tHnIIaF5k29JMsjP
         WAvdDEXHkH/FVzOYK69bzTjmosbJipBqxfsdB/cAPu2yYaYLLNyru8HIfNH/zhlEl+mU
         b5+PJ4XRQM2BJW9oXzisu/vOdi7dHLX+vQAJHyTA5vk0DQ7OMESbpxAVqABg7O8/+78J
         3nht4WbwZ0TDJVCxNgnUkxAG6lFfKLPK4ZeS+qG0noIJNBwIfI2dl2YXRq8khGR4QbyN
         AtMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dVOZ4z0XPa7OayGE8ECMnwdJyIdPwvP3nXcnH8MPASM=;
        b=sZGs0E9Hjaqwpzs1+GlX8nNK5nXheFFnPAKRE6Yf8m1gM8ASM+DhhdIkL3M7h+fqay
         tlXGOdrOoGFzLGqehpzxiLr+64rRhkIf2fH5GBqd+AABDjZRV6wJX6h8bnp5plEIyXzA
         tfDZkgqO0QcDHZxGe9uEY3iTaHsgjNU2EfaPoeHl3Ar6qLm6hy28Yy7FUO3y17BOOJoR
         5C399AHGbkgDw9LanJJeJmHiIguETA70Y850qZGMxkKDxl23SDzyhyTZUro/4y2Bxvo8
         FTKPSOlOUyIaCdzJoKZoPtT9O5RHm7MvffVLc4wq9J5OUYhU4ejNOXfmc0Y7hIn4yOF6
         BJJA==
X-Gm-Message-State: AOAM531RUu04c5KccPJaHZtyCF9dCsAjUgkdtohpV+msPPHqzIxUwGbm
        v0C5ChMCkSSmK6/ls7ovCR0=
X-Google-Smtp-Source: ABdhPJyVl6KA/n8a2L0ZyHmpD0HkIjOfmbblHOo22Ydnq/pt3+qZWO40wgWo8CzM7IJsFIvGGIvzGQ==
X-Received: by 2002:a63:1962:: with SMTP id 34mr19583687pgz.14.1629473891609;
        Fri, 20 Aug 2021 08:38:11 -0700 (PDT)
Received: from ?IPv6:2404:f801:0:5:8000::50b? ([2404:f801:9000:1a:efea::50b])
        by smtp.gmail.com with ESMTPSA id i26sm7738720pfu.6.2021.08.20.08.37.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Aug 2021 08:38:11 -0700 (PDT)
Subject: Re: [PATCH V3 13/13] HV/Storvsc: Add Isolation VM support for storvsc
 driver
From:   Tianyu Lan <ltykernel@gmail.com>
To:     Michael Kelley <mikelley@microsoft.com>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        Dexuan Cui <decui@microsoft.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, "x86@kernel.org" <x86@kernel.org>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "luto@kernel.org" <luto@kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "boris.ostrovsky@oracle.com" <boris.ostrovsky@oracle.com>,
        "jgross@suse.com" <jgross@suse.com>,
        "sstabellini@kernel.org" <sstabellini@kernel.org>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "will@kernel.org" <will@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "arnd@arndb.de" <arnd@arndb.de>, "hch@lst.de" <hch@lst.de>,
        "m.szyprowski@samsung.com" <m.szyprowski@samsung.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
        "brijesh.singh@amd.com" <brijesh.singh@amd.com>,
        "ardb@kernel.org" <ardb@kernel.org>,
        Tianyu Lan <Tianyu.Lan@microsoft.com>,
        "pgonda@google.com" <pgonda@google.com>,
        "martin.b.radev@gmail.com" <martin.b.radev@gmail.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "rppt@kernel.org" <rppt@kernel.org>,
        "sfr@canb.auug.org.au" <sfr@canb.auug.org.au>,
        "saravanand@fb.com" <saravanand@fb.com>,
        "krish.sadhukhan@oracle.com" <krish.sadhukhan@oracle.com>,
        "aneesh.kumar@linux.ibm.com" <aneesh.kumar@linux.ibm.com>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
        "rientjes@google.com" <rientjes@google.com>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
        "tj@kernel.org" <tj@kernel.org>
Cc:     "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        vkuznets <vkuznets@redhat.com>,
        "parri.andrea@gmail.com" <parri.andrea@gmail.com>,
        "dave.hansen@intel.com" <dave.hansen@intel.com>
References: <20210809175620.720923-1-ltykernel@gmail.com>
 <20210809175620.720923-14-ltykernel@gmail.com>
 <MWHPR21MB1593EEF30FFD5C60ED744985D7C09@MWHPR21MB1593.namprd21.prod.outlook.com>
 <a96626db-4ac9-3ce4-64e9-92568e4f827a@gmail.com>
Message-ID: <9ae704a9-838c-0a54-9c16-f0f10eaaaefe@gmail.com>
Date:   Fri, 20 Aug 2021 23:37:56 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <a96626db-4ac9-3ce4-64e9-92568e4f827a@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/20/2021 11:20 PM, Tianyu Lan wrote:
>> The whole approach here is to do dma remapping on each individual page
>> of the I/O buffer.  But wouldn't it be possible to use dma_map_sg() to 
>> map
>> each scatterlist entry as a unit?  Each scatterlist entry describes a 
>> range of
>> physically contiguous memory.  After dma_map_sg(), the resulting dma
>> address must also refer to a physically contiguous range in the swiotlb
>> bounce buffer memory.   So at the top of the "for" loop over the 
>> scatterlist
>> entries, do dma_map_sg() if we're in an isolated VM.  Then compute the
>> hvpfn value based on the dma address instead of sg_page().  But 
>> everything
>> else is the same, and the inner loop for populating the pfn_arry is 
>> unmodified.
>> Furthermore, the dma_range array that you've added is not needed, since
>> scatterlist entries already have a dma_address field for saving the 
>> mapped
>> address, and dma_unmap_sg() uses that field.
> 
> I don't use dma_map_sg() here in order to avoid introducing one more 
> loop(e,g dma_map_sg()). We already have a loop to populate 
> cmd_request->dma_range[] and so do the dma map in the same loop.

Sorry for a typo. s/cmd_request->dma_range[]/payload->range.pfn_array[]/
