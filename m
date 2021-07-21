Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AFE63D120A
	for <lists+netdev@lfdr.de>; Wed, 21 Jul 2021 17:11:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239653AbhGUObH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Jul 2021 10:31:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239465AbhGUObG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Jul 2021 10:31:06 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DD5DC061575;
        Wed, 21 Jul 2021 08:11:42 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id p14-20020a17090ad30eb02901731c776526so4192034pju.4;
        Wed, 21 Jul 2021 08:11:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=D1h2d+g+iMU4/jGzVM3W4ntrau1j74+yLE1tV8PoAic=;
        b=JudKBwJXYhQRbS+X/S9haoQpA4vJDhCumYWHOc7uZasKxl1Q15/54S3UgtA5DU2MnM
         lzw3uMGa0951XioyMj3JRFDtKLLdbQZHKtkmzd142ej6G99ZpSQbf4pbYKJMHmvy2Mvg
         n+IsgH/Gi14qKpxeEr/tuJjCd3FpmXh2SNA8p3U4jEKfIwjxFSccYMGg+ONArMU/Wu6E
         XfXZg/05bIatm0Sic/3vAKBQLh3YqfKOOK2+BKsvSUdJLbF0e9ivPdg52QOQvmKU+WWe
         jjv9l41sek6SngfQtz7UvvRRFhkx72h8LHByGOFdzs8RI71z4WB014t9ZJNaOfnnb+nh
         5peg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=D1h2d+g+iMU4/jGzVM3W4ntrau1j74+yLE1tV8PoAic=;
        b=ZJdu65U7WvmjcWaIW4sBjW6h5zWSvMf99dpkKg8cqaW714pAEoaRcyidjRDVt5b1Zw
         xA1hTMpLmOa1z0aWM9yaDcYyCubL0zS8K5yhNpxb096mD5qMSWhoFjUe0V+Rnl40vbjf
         b3FQXJxvImbySjq0tg8I+nmm3veyPbucRxG+PG22uq2XPOueZhQcj8N3eEirWozjkxvc
         jJpC18O83oCnH2olkXn/piw3LN71eRkJNF/GJUjL2FqftgjM8R2o5JY3pfi7h4/65r6a
         2LaqWuBJfh3ZKA8Mn979MmPvB8ENfqVvSKUml6U1SqQpD6xExoXyMEfek3wyBD/jREpR
         ll2A==
X-Gm-Message-State: AOAM533Pj41p6Cs4xXifCzd1p6gvUIrTLW7PiQGRVjp01z5wP3sms/6u
        W2LjHPjGs0iNsyXk1Z90/rU=
X-Google-Smtp-Source: ABdhPJx35AxUVV6O398anppLcbEKI32dfRaLuLVMxOpRJ+rodbbxxyqhUxP+qwoyGdOJ7uanWVT8yQ==
X-Received: by 2002:a17:902:db11:b029:12b:4a2e:7ec4 with SMTP id m17-20020a170902db11b029012b4a2e7ec4mr28239454plx.71.1626880302118;
        Wed, 21 Jul 2021 08:11:42 -0700 (PDT)
Received: from ?IPv6:2404:f801:0:5:8000::4b1? ([2404:f801:9000:1a:efea::4b1])
        by smtp.gmail.com with ESMTPSA id j6sm23210086pji.23.2021.07.21.08.11.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Jul 2021 08:11:41 -0700 (PDT)
Subject: Re: [Resend RFC PATCH V4 09/13] x86/Swiotlb/HV: Add Swiotlb bounce
 buffer remap function for HV IVM
To:     Christoph Hellwig <hch@lst.de>
Cc:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        wei.liu@kernel.org, decui@microsoft.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, x86@kernel.org, hpa@zytor.com,
        dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
        konrad.wilk@oracle.com, boris.ostrovsky@oracle.com,
        jgross@suse.com, sstabellini@kernel.org, joro@8bytes.org,
        will@kernel.org, davem@davemloft.net, kuba@kernel.org,
        jejb@linux.ibm.com, martin.petersen@oracle.com, arnd@arndb.de,
        m.szyprowski@samsung.com, robin.murphy@arm.com,
        kirill.shutemov@linux.intel.com, akpm@linux-foundation.org,
        rppt@kernel.org, Tianyu.Lan@microsoft.com, thomas.lendacky@amd.com,
        ardb@kernel.org, robh@kernel.org, nramas@linux.microsoft.com,
        pgonda@google.com, martin.b.radev@gmail.com, david@redhat.com,
        krish.sadhukhan@oracle.com, saravanand@fb.com,
        xen-devel@lists.xenproject.org, keescook@chromium.org,
        rientjes@google.com, hannes@cmpxchg.org,
        michael.h.kelley@microsoft.com, iommu@lists.linux-foundation.org,
        linux-arch@vger.kernel.org, linux-hyperv@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        netdev@vger.kernel.org, vkuznets@redhat.com, brijesh.singh@amd.com,
        anparri@microsoft.com
References: <20210707154629.3977369-1-ltykernel@gmail.com>
 <20210707154629.3977369-10-ltykernel@gmail.com>
 <20210720135437.GA13554@lst.de>
 <8f1a285d-4b67-8041-d326-af565b2756c0@gmail.com>
 <20210721143355.GA10848@lst.de>
From:   Tianyu Lan <ltykernel@gmail.com>
Message-ID: <0e2ca0e2-201d-68d4-5dc0-7341f8e9106a@gmail.com>
Date:   Wed, 21 Jul 2021 23:11:26 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210721143355.GA10848@lst.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/21/2021 10:33 PM, Christoph Hellwig wrote:
> On Wed, Jul 21, 2021 at 06:28:48PM +0800, Tianyu Lan wrote:
>> dma_mmap_attrs() and dma_get_sgtable_attrs() get input virtual address
>> belonging to backing memory with struct page and returns bounce buffer
>> dma physical address which is below shared_gpa_boundary(vTOM) and passed
>> to Hyper-V via vmbus protocol.
>>
>> The new map virtual address is only to access bounce buffer in swiotlb
>> code and will not be used other places. It's stored in the mem->vstart.
>> So the new API set_memory_decrypted_map() in this series is only called
>> in the swiotlb code. Other platforms may replace set_memory_decrypted()
>> with set_memory_decrypted_map() as requested.
> 
> It seems like you are indeed not using these new helpers in
> dma_direct_alloc.  How is dma_alloc_attrs/dma_alloc_coherent going to
> work on these systems?
> 

Current vmbus device drivers don't use dma_alloc_attrs/dma_alloc
_coherent() because vmbus driver allocates ring buffer for all devices. 
Ring buffer has been marked decrypted and remapped in vmbus driver. 
Netvsc and storvsc drivers just need to use  dma_map_single/dma_map_page().



