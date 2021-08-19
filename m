Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D02073F1705
	for <lists+netdev@lfdr.de>; Thu, 19 Aug 2021 12:03:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238229AbhHSKD4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Aug 2021 06:03:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232750AbhHSKDz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Aug 2021 06:03:55 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65928C061575;
        Thu, 19 Aug 2021 03:03:19 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id n12so3625687plf.4;
        Thu, 19 Aug 2021 03:03:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=0Z5bZ3ATC9rIbWdXJn4JmmnZhJaPoQBdkWHt9cjrKG8=;
        b=IT2Usca3A4sKF8ubQedNM5SaMd/P+GOOPAsVwIijlGErP0fzExJmYSY+A4eUcUkpXJ
         rlIgf13cji4zTPlulH73wgPhlbbzcXLto1AWAY23pc05ugnHQG+lyNsgg/hndXCJDvOZ
         akViMH02DTRkHylRGYPHa/SdGfpAhtYNgDzsjZBFu8ziREk5Ir52t81sOV2jRIjUiWu/
         9kVTMEdyW5UV9EJv7Rbge0li4OczD1s3+x4R5IGStjZTrxrYWtpg+4kGHyRYWdS60W/5
         Am1K2wsgWrjeJ9fH+MvIMoJfBnS3nAhxZjbc45vuLQjaMveZqMq4x3zvuPukeR63TOml
         jWXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0Z5bZ3ATC9rIbWdXJn4JmmnZhJaPoQBdkWHt9cjrKG8=;
        b=Y5MN8Zbm5dAwNafJHeGb7lBqAbEiJDCsM4jvqABc1KRLuq2uDqoSoDags/zUgzDZEA
         GM7puysXgSiDJikiagz/HT0+kSS5NNXQBw4lXT7DfLMVSpmIyPNoi3gBQU/V7jdCBiA5
         Ol2z6pQAyfvdbGx1enQ0w4mDFL9NWoSEfE7tWYhaKvtGo0+BBKl3HS13c/6gpefHjZ6m
         f476g5pZFahcm4EA5u45TV53h5E/s/18lx1ZqZioWVRHaHsWZYxaznECBHRIo27s2G7p
         hryHHsbC6Gl29U6SqByVmC3iCw9tDRJY0lrflXzVhCjURILVur8luwYrSSzbGPl+B89u
         xfHQ==
X-Gm-Message-State: AOAM530q1SDPu7lmm0WX5ovbkZ8ugMDwU9jgu7WflcNzdhGUuX0coFXY
        wpnIEeUR/YaBopwqK3dVMWY=
X-Google-Smtp-Source: ABdhPJzfJPRP2BLYCvwXpllkEgoVoCQWlDbtUrPyndvtVP/tYRGu2BCJLYGTmAw6sGYSn2DMVJ/QVQ==
X-Received: by 2002:a17:902:bc4b:b029:12d:77e8:2c26 with SMTP id t11-20020a170902bc4bb029012d77e82c26mr10961353plz.67.1629367398962;
        Thu, 19 Aug 2021 03:03:18 -0700 (PDT)
Received: from ?IPv6:2404:f801:0:5:8000::50b? ([2404:f801:9000:18:efec::50b])
        by smtp.gmail.com with ESMTPSA id l11sm2847556pfd.187.2021.08.19.03.03.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Aug 2021 03:03:18 -0700 (PDT)
Subject: Re: [PATCH V3 10/13] x86/Swiotlb: Add Swiotlb bounce buffer remap
 function for HV IVM
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
        thomas.lendacky@amd.com, brijesh.singh@amd.com, ardb@kernel.org,
        Tianyu.Lan@microsoft.com, pgonda@google.com,
        martin.b.radev@gmail.com, akpm@linux-foundation.org,
        kirill.shutemov@linux.intel.com, rppt@kernel.org,
        sfr@canb.auug.org.au, saravanand@fb.com,
        krish.sadhukhan@oracle.com, aneesh.kumar@linux.ibm.com,
        xen-devel@lists.xenproject.org, rientjes@google.com,
        hannes@cmpxchg.org, tj@kernel.org, michael.h.kelley@microsoft.com,
        iommu@lists.linux-foundation.org, linux-arch@vger.kernel.org,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, netdev@vger.kernel.org,
        vkuznets@redhat.com, parri.andrea@gmail.com, dave.hansen@intel.com
References: <20210809175620.720923-1-ltykernel@gmail.com>
 <20210809175620.720923-11-ltykernel@gmail.com>
 <20210812122741.GC19050@lst.de>
 <d18ae061-6fc2-e69e-fc2c-2e1a1114c4b4@gmail.com>
 <890e5e21-714a-2db6-f68a-6211a69bebb9@gmail.com>
 <20210819084951.GA10461@lst.de>
 <1c5ae861-2c35-2ef5-e764-db45bbcb88a9@gmail.com>
 <20210819100200.GA16908@lst.de>
From:   Tianyu Lan <ltykernel@gmail.com>
Message-ID: <8bcadc06-ce4c-8be9-c1ac-44c544e02960@gmail.com>
Date:   Thu, 19 Aug 2021 18:03:04 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210819100200.GA16908@lst.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/19/2021 6:02 PM, Christoph Hellwig wrote:
> On Thu, Aug 19, 2021 at 05:59:02PM +0800, Tianyu Lan wrote:
>>
>>
>> On 8/19/2021 4:49 PM, Christoph Hellwig wrote:
>>> On Mon, Aug 16, 2021 at 10:50:26PM +0800, Tianyu Lan wrote:
>>>> Hi Christoph:
>>>>         Sorry to bother you.Please double check with these two patches
>>>> " [PATCH V3 10/13] x86/Swiotlb: Add Swiotlb bounce buffer remap function
>>>> for HV IVM" and "[PATCH V3 09/13] DMA: Add dma_map_decrypted/dma_
>>>> unmap_encrypted() function".
>>>
>>> Do you have a git tree somewhere to look at the whole tree?
>>
>> Yes, here is my github link for these two patches.
>>
>> https://github.com/lantianyu/linux/commit/462f7e4e44644fe7e182f7a5fb043a75acb90ee5
>>
>> https://github.com/lantianyu/linux/commit/c8de236bf4366d39e8b98e5a091c39df29b03e0b
> 
> Which branch is this?
> 

https://github.com/lantianyu/linux/tree/isolationv3
