Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E887545708F
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 15:23:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235285AbhKSO06 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Nov 2021 09:26:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232080AbhKSO06 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Nov 2021 09:26:58 -0500
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9396C061574;
        Fri, 19 Nov 2021 06:23:56 -0800 (PST)
Received: by mail-pg1-x531.google.com with SMTP id 200so8796593pga.1;
        Fri, 19 Nov 2021 06:23:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language
         :from:to:cc:references:in-reply-to:content-transfer-encoding;
        bh=dvjMlZBI3ldb1jXqYwhDV7AWs1lj5LCSS81ZY56RgHg=;
        b=lD29CjzOk03sgDLP+GNvSpxJtgVkW5rJkK+91U6AQudAzMZxrwkaky9OEq6jf27Gw7
         +El3go4e6gBFGCWthIzBWcaH6MtynoVd2Asx0s8lF4AHh9KTCrYFWAivyI8ee0X1Vv36
         V2FQuAVabQQBAbOL0fIquaORLXE6V2pQuWoxP4p8Bdmk66ffMTRypmvZJws3ZQPoiG7R
         xBnlvWtgNAT1CZU5CVKw8D3+cafHZ/lwicgnA/RP75ZpQaa+0T4cnXOpdWgAZYBmS+Ds
         D+JWFTqNXrZl80kk+n0WgCyZhptSAvKOJXiZ1wT44+Ikfkw7mB3QMLEop9ypqPjQJy3c
         M8pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=dvjMlZBI3ldb1jXqYwhDV7AWs1lj5LCSS81ZY56RgHg=;
        b=ymOoSNPXb9r3m4Ip0eXlmv0Q4P1UZsmxUwGL5lKG/9B7dE2h+J3/mZSlEGyKl66/v1
         0GwcmDvEOK1uQdQxDkgT6oCc7DuGNytaHFfzTNJALqupO2HMuNf/RK5bnZM6PDLLwq7f
         kK6EGX1448Q21QUEGs5Vfz41APQwtGtzHbKJwzpriOPEAWjQRfFRzDYcKyphbCKaMuvX
         RymMoxcyEXGdlUWR8iuZYzqd3l8X8ap8TosIWVJBK0sK1N9gyVjqVTEb3uLrI3kJ+9aG
         iHytVLT8pWOJbrFv80RMGta6mzqTWS4j9ZNkV3DU3LjimptmgCDs90a9+iNzZzzmQIUC
         cFUA==
X-Gm-Message-State: AOAM533D70nN4qd2+pQf94pHCLx7NMxOCx+wlfL/XlIBDxI4keQOYY/X
        y5ekXgyMeYgJxNEInVywDT7KYgjaLReP6g==
X-Google-Smtp-Source: ABdhPJzKRBXlcGt3waRWzaH9R47/6SD0/IgoWcAgajHv/fxOJufbEPJI6hNEQ9SuwB+/pum/5oX3UA==
X-Received: by 2002:a63:b54a:: with SMTP id u10mr17506905pgo.69.1637331836308;
        Fri, 19 Nov 2021 06:23:56 -0800 (PST)
Received: from ?IPV6:2404:f801:0:5:8000::50b? ([2404:f801:9000:1a:efea::50b])
        by smtp.gmail.com with ESMTPSA id l12sm3181520pfu.100.2021.11.19.06.23.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Nov 2021 06:23:55 -0800 (PST)
Message-ID: <f7fcb4d5-fcdd-0d24-60ed-62c27ed8e2d9@gmail.com>
Date:   Fri, 19 Nov 2021 22:23:45 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.1
Subject: Re: [PATCH 3/5] hyperv/IOMMU: Enable swiotlb bounce buffer for
 Isolation VM
Content-Language: en-US
From:   Tianyu Lan <ltykernel@gmail.com>
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
In-Reply-To: <c93bf3d4-75c1-bc3d-2789-1d65e7c19158@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/17/2021 10:00 PM, Tianyu Lan wrote:
> On 11/17/2021 6:01 PM, Christoph Hellwig wrote:
>> This doesn't really have much to do with normal DMA mapping,
>> so why does this direct through the dma ops?
>>
> 
> According to the previous discussion, dma_alloc_noncontigous()
> and dma_vmap_noncontiguous() may be used to handle the noncontigous
> memory alloc/map in the netvsc driver. So add alloc/free and vmap/vunmap
> callbacks here to handle the case. The previous patch v4 & v5 handles
> the allocation and map in the netvsc driver. If this should not go 
> though dma ops, We also may make it as vmbus specific function and keep
> the function in the vmbus driver.
> 
> https://lkml.org/lkml/2021/9/28/51


Hi Christoph:
       Sorry to bother you. Could you have a look? Which solution do you
prefer? If we need to call dma_alloc/map_noncontigous() function in the
netvsc driver what patch 4 does. The Hyper-V specific implementation
needs to be hided in some callbacks and call these callback in the
dma_alloc/map_noncontigous(). I used dma ops here. If the allocation and
map operation should be Hyper-V specific function, we may put these
functions in the vmbus driver and other vmbus device drivers also may
reuse these functions if necessary.

Thanks.
