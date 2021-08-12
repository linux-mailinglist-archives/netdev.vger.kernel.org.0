Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB1013EA7AE
	for <lists+netdev@lfdr.de>; Thu, 12 Aug 2021 17:38:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237976AbhHLPjK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Aug 2021 11:39:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234287AbhHLPjJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Aug 2021 11:39:09 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEB17C061756;
        Thu, 12 Aug 2021 08:38:43 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id d1so7837491pll.1;
        Thu, 12 Aug 2021 08:38:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=JDlSeWOgXcTARSX0Sb/7iqT+nIM3mRl7e9seVpJTDsQ=;
        b=eKwdoqgzbDwCSyrgnVW4fQAzUSWeoRx/kyQpFmKK+Fp7BDnr2/nHtS2A8lP7dy74pV
         DhjbUbYBUBvR9ptLkWXPFGdb66asLd49SRfdmf9wxKJzWqlZ8T7NSu4mDDdOyr8QYGjC
         0lNFiTw2Utqsdhq+i1tE7yKdLkrhwYJ4GcUjf5y7cP+4awTK44NJV01YV+BxlT3oQexu
         0CRKAKLjxtq43dNgpQlyRzLdedFvCS41p+H+3bYjSaKBrgs7oVUsW9kyJWLlM734zPxy
         UEVzFvb9jP9wMt2dE2D+cHyIUPC4b4v/Fn8lr0Ong2WornEq8pHks9kPtVFyDLYSburS
         y7eQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JDlSeWOgXcTARSX0Sb/7iqT+nIM3mRl7e9seVpJTDsQ=;
        b=hJM2eKZLuZWUGB1ZtYM8wIiGMxjrCxMiW8u7lE1hFTvrP8+0ra24mXUBHibngk+tEl
         VQ5BjEmaA/xjwH1pnIA8isw4jKFnHG9NR1BnFQLkQvBmwb/oe45twLb22dqWGeuJtLF2
         EzK7E5Yan3jWQkbmv5bPeK4HK9dHKtYKW3YjSdIeLwCvu3U7M4EM/QRmoIqxnMiI9Kob
         /jyyw4/zqn0DkARto5BXYYHE6GJofaBpqbOmsJr/MuQ1loD9veIqsNgctoZ7Hbcin3Py
         OSNla+20BPGXPB/3duAIOSw+aeRJMlj8hW5QZyTlexSg0GYhb+xYlafuGHhrm/ULzryv
         whog==
X-Gm-Message-State: AOAM531lCJB/VtPrvzReAuDOevNIq+02KskgqcOvIJR24csxf9ar/okT
        pKeCX4OOPOMDqeI3EMSzdxI=
X-Google-Smtp-Source: ABdhPJzM/sI+FsioyGJB+Q38ExsQyZIIBjJUHCnSB8L/yQaI33b3CkRfajWOppoDj5zZgXKq84mYaQ==
X-Received: by 2002:a17:90a:648b:: with SMTP id h11mr5000375pjj.141.1628782723341;
        Thu, 12 Aug 2021 08:38:43 -0700 (PDT)
Received: from ?IPv6:2404:f801:0:5:8000::4b1? ([2404:f801:9000:1a:efea::4b1])
        by smtp.gmail.com with ESMTPSA id y7sm4139094pfp.102.2021.08.12.08.38.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Aug 2021 08:38:42 -0700 (PDT)
Subject: Re: [PATCH V3 09/13] DMA: Add dma_map_decrypted/dma_unmap_encrypted()
 function
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
 <20210809175620.720923-10-ltykernel@gmail.com>
 <20210812122657.GB19050@lst.de>
From:   Tianyu Lan <ltykernel@gmail.com>
Message-ID: <0598906d-9a47-34a9-16bf-4bacff7fa058@gmail.com>
Date:   Thu, 12 Aug 2021 23:38:27 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210812122657.GB19050@lst.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/12/2021 8:26 PM, Christoph Hellwig wrote:
> On Mon, Aug 09, 2021 at 01:56:13PM -0400, Tianyu Lan wrote:
>> From: Tianyu Lan <Tianyu.Lan@microsoft.com>
>>
>> In Hyper-V Isolation VM with AMD SEV, swiotlb boucne buffer
>> needs to be mapped into address space above vTOM and so
>> introduce dma_map_decrypted/dma_unmap_encrypted() to map/unmap
>> bounce buffer memory. The platform can populate man/unmap callback
>> in the dma memory decrypted ops.
> 
> Nothing here looks actually DMA related, and the names are horribly
> confusing vs the actual dma_map_* calls.
> 

OK. So this still need to keep in the set_memory.c file.
