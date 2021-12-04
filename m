Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F4F746832B
	for <lists+netdev@lfdr.de>; Sat,  4 Dec 2021 08:26:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350888AbhLDHaQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Dec 2021 02:30:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344803AbhLDHaP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Dec 2021 02:30:15 -0500
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CF03C061751;
        Fri,  3 Dec 2021 23:26:50 -0800 (PST)
Received: by mail-pf1-x435.google.com with SMTP id n26so5093389pff.3;
        Fri, 03 Dec 2021 23:26:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=eCoo4UdX0KSai3rgxqp+sZCsWhUUBGl2p1rpp3l5eBw=;
        b=SrgtERJGlFYclhGBMZWqWPGAIZbR6fQ6Uu4tpnTSOZi4kEEMeogHi+38ibOB1Ey21P
         NsKwL8E3bcEDfz8ZW+SzX7lW4BoeQcApz4UUqds31/0hKjtB8GC+RLIm017R9iXqjTQ5
         5L1ib+SOX+p6av7/1hxf7B+3Qxk2Iw7WqrJvdJo9bhmIi2CFI/RD70cSaIdmmD4TnbkS
         5y6tetKfkLX0NGXFeSmkkx7JTdHF8qPgaL8esKv9vgiuB4mG86p3+JuYbDIU/22ynW84
         XgstoStjjO1fceJiyUS6HIleMKpq85ai6WbYYTiWfwnyb44HUdjQ0qsdqcUOoB5fcM8p
         lk9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=eCoo4UdX0KSai3rgxqp+sZCsWhUUBGl2p1rpp3l5eBw=;
        b=paI9ynkNdEFp8apqFpcAXt7YeovGZJBAWBcy/sDNgOJcn4Pu3Fa/btEBkX4r8h2MyN
         ODKzK5PfzLL7WpuqiQmUSTxOQS7OB+zCRZGQx4n8IhpHmCdoC/QoA+Hm+VSXkorrl+ia
         vgLF3xPTDAm3wWdw+/v1ET421xkrCTKvHEqfsgL6KF/8R3e0nmDL5dz2lZ4FhuASUiY/
         i+MSPNEmcrBhyW05F7KnfdFrfRJ9UI7u43fWkJ4OPLs+Q/9+8+IhSokkZb2MwNrGLO48
         H0who+yquuy+gKS/Ad3JF/4r9Nw7xjm4Rg8rjygCE//Dkv9E3dQdHe6amqPExi7pl8fy
         VoqA==
X-Gm-Message-State: AOAM531AmJ3cdjgUIQcIxzpD9zgoLCKUQqynoctANCvz21lsD4Pt3327
        ETXNH7g4KZkBULt0+xaj0Rg=
X-Google-Smtp-Source: ABdhPJwCQRkn3xmR+kfR3YlZKVCxe03wvGUj2OGYKR6Vkh9NokqMfnW2TUg5Koi/TslOtDsFr3TRJg==
X-Received: by 2002:a63:8ac1:: with SMTP id y184mr8696835pgd.48.1638602809615;
        Fri, 03 Dec 2021 23:26:49 -0800 (PST)
Received: from ?IPV6:2404:f801:0:5:8000::50b? ([2404:f801:9000:18:efec::50b])
        by smtp.gmail.com with ESMTPSA id m184sm4248180pga.61.2021.12.03.23.26.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Dec 2021 23:26:49 -0800 (PST)
Message-ID: <877e6f24-2004-0681-f9f3-241fb6ace427@gmail.com>
Date:   Sat, 4 Dec 2021 15:26:36 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [PATCH V3 3/5] hyperv/IOMMU: Enable swiotlb bounce buffer for
 Isolation VM
Content-Language: en-US
To:     "Michael Kelley (LINUX)" <mikelley@microsoft.com>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        Dexuan Cui <decui@microsoft.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
        "jgross@suse.com" <jgross@suse.com>,
        "sstabellini@kernel.org" <sstabellini@kernel.org>,
        "boris.ostrovsky@oracle.com" <boris.ostrovsky@oracle.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "will@kernel.org" <will@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "hch@infradead.org" <hch@infradead.org>,
        "m.szyprowski@samsung.com" <m.szyprowski@samsung.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        Tianyu Lan <Tianyu.Lan@microsoft.com>,
        "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>
Cc:     "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        vkuznets <vkuznets@redhat.com>,
        "brijesh.singh@amd.com" <brijesh.singh@amd.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "hch@lst.de" <hch@lst.de>,
        "parri.andrea@gmail.com" <parri.andrea@gmail.com>,
        "dave.hansen@intel.com" <dave.hansen@intel.com>
References: <20211201160257.1003912-1-ltykernel@gmail.com>
 <20211201160257.1003912-4-ltykernel@gmail.com>
 <MWHPR21MB159390BE1B546A6F90FB1F18D76A9@MWHPR21MB1593.namprd21.prod.outlook.com>
From:   Tianyu Lan <ltykernel@gmail.com>
In-Reply-To: <MWHPR21MB159390BE1B546A6F90FB1F18D76A9@MWHPR21MB1593.namprd21.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/4/2021 3:17 AM, Michael Kelley (LINUX) wrote:
>> +static void __init hyperv_iommu_swiotlb_init(void)
>> +{
>> +	unsigned long hyperv_io_tlb_size;
>> +	void *hyperv_io_tlb_start;
>> +
>> +	/*
>> +	 * Allocate Hyper-V swiotlb bounce buffer at early place
>> +	 * to reserve large contiguous memory.
>> +	 */
>> +	hyperv_io_tlb_size = swiotlb_size_or_default();
>> +	hyperv_io_tlb_start = memblock_alloc(hyperv_io_tlb_size, PAGE_SIZE);
>> +
>> +	if (!hyperv_io_tlb_start)
>> +		pr_warn("Fail to allocate Hyper-V swiotlb buffer.\n");
> In the error case, won't swiotlb_init_with_tlb() end up panic'ing when
> it tries to zero out the memory?   The only real choice here is to
> return immediately after printing the message, and not call
> swiotlb_init_with_tlb().
> 

Yes, agree. Will update.
