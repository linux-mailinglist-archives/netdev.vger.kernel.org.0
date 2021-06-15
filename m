Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E09E3A82E4
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 16:31:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230391AbhFOOdv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 10:33:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230076AbhFOOdu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Jun 2021 10:33:50 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E0C5C061574;
        Tue, 15 Jun 2021 07:31:45 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id a127so7581321pfa.10;
        Tue, 15 Jun 2021 07:31:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=09f7flVgvhf5eQwpZCIbvOGTARFj7yeM2HilMpzlWLk=;
        b=jk2oxSkqx62fHfzZ2Td3CQMKVDfVLX5soiM/JukpALSNJHJr6bPDtlz3KWKAxXo94O
         s/hllSh2es9DhRUKAKUitklZDcf/EnVOKXhkOj9PYfOCpVShjA/ALCwL9qmhEU6/Uawa
         XK557NRD7ifNeZzvRQOvgq1OjZVLzX0tIkT8t770jqHE0cKYFvqhPHbZNRgnhaDUZKFF
         qX9q9wmOAxzVgsgD1wpLoriKUlqy7RCPkNZ1jG4aLxQucHRt8DEitzL0SOUV96Pc1UDE
         2mXJY2Jw/0wFzqk5I0o9iVdLMmeZJJ8WeATZpVLS5cPgmlZCB/DeT8DlSYdBw+t/FiNV
         Ts4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=09f7flVgvhf5eQwpZCIbvOGTARFj7yeM2HilMpzlWLk=;
        b=LwuxIzy9pg+zHfZXKOoMDDHdPL4iwbga1lkeOmj8z4a79H6tthZ6VmA1omj3bvfPYk
         5ibSpIwbNCIwENqu+YVo/qllWVn4NhlHHJgYxq4ryoM2eSdwSBjlg1Sx+OrMNq7NdojQ
         4afvgvbx27WSSvpTJ+o8A4gtoyMR+rBpedb4qNAa62n6I2QLnhisGLW3W3/VB79tpzUM
         iv8lV/ReZRwuGM31Tkxw04qTCMJM8YgcZIkb0jBA7hc/DKPJXfYEYWTJgkoIMtKbXOr9
         uHCHHFuYVIXNkskgWrp4D5ACeEyXLXkR1V16t7/ndKa038mxFM4lkuthDRk6g02mid8L
         gKoQ==
X-Gm-Message-State: AOAM530h9mUzaqcVFQgJjN/YMhjBL3L9+NqQb84sdq35JVWwm1ozNr4X
        2qmv7sTBnjoEo9c3hTmoqyY=
X-Google-Smtp-Source: ABdhPJyHvlYi58GrVtZOOV1UUSDfdDdKTtRA2DlWTeNf7j5KzC+iOROVnZire7W4JyUnDsrG1dvTzA==
X-Received: by 2002:a65:550e:: with SMTP id f14mr22678348pgr.160.1623767504841;
        Tue, 15 Jun 2021 07:31:44 -0700 (PDT)
Received: from ?IPv6:2404:f801:0:5:8000::4b1? ([2404:f801:9000:1a:efea::4b1])
        by smtp.gmail.com with ESMTPSA id fy16sm2711030pjb.49.2021.06.15.07.31.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Jun 2021 07:31:44 -0700 (PDT)
Subject: Re: [RFC PATCH V3 10/11] HV/Netvsc: Add Isolation VM support for
 netvsc driver
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
 <20210530150628.2063957-11-ltykernel@gmail.com>
 <20210607065007.GE24478@lst.de>
 <279cb4bf-c5b6-6db9-0f1e-9238e902c8f2@gmail.com>
 <20210614070903.GA29976@lst.de>
 <e10c2696-23c3-befe-4f4d-25e18918132f@gmail.com>
 <20210614153339.GB1741@lst.de>
From:   Tianyu Lan <ltykernel@gmail.com>
Message-ID: <7d86307f-83ff-03ad-c6e9-87b455c559b8@gmail.com>
Date:   Tue, 15 Jun 2021 22:31:31 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210614153339.GB1741@lst.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/14/2021 11:33 PM, Christoph Hellwig wrote:
> On Mon, Jun 14, 2021 at 10:04:06PM +0800, Tianyu Lan wrote:
>> The pages in the hv_page_buffer array here are in the kernel linear
>> mapping. The packet sent to host will contain an array which contains
>> transaction data. In the isolation VM, data in the these pages needs to be
>> copied to bounce buffer and so call dma_map_single() here to map these data
>> pages with bounce buffer. The vmbus has ring buffer where the send/receive
>> packets are copied to/from. The ring buffer has been remapped to the extra
>> space above shared gpa boundary/vTom during probing Netvsc driver and so
>> not call dma map function for vmbus ring
>> buffer.
> 
> So why do we have all that PFN magic instead of using struct page or
> the usual kernel I/O buffers that contain a page pointer?
> 

These PFNs originally is part of Hyper-V protocol data and will be sent
to host. Host accepts these GFN and copy data from/to guest memory. The 
translation from va to pa is done by caller that populates the 
hv_page_buffer array. I will try calling dma map function before 
populating struct hv_page_buffer and this can avoid redundant 
translation between PA and VA.
