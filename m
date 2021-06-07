Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 182E939DFCC
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 16:57:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230390AbhFGO7I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 10:59:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230193AbhFGO7E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Jun 2021 10:59:04 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A85F9C061766;
        Mon,  7 Jun 2021 07:57:01 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id 27so14010942pgy.3;
        Mon, 07 Jun 2021 07:57:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=mkL4psSj+prMNO7AohBJyTx+Q189qdo7fgANRpB5e+4=;
        b=lhaKoBcNOuAsXD3pTAmPwsFop0hqZ7JU5MLd+d9L1no2Uoec0Qyp3qHl7oh02shWeI
         Jes/SZ8q3U+KfCNoq9c1Xrlmq8EXws4qXzfcpkEnMBLnTwTeOLVn57/5lNMv0IIQu936
         eZ7O1rSFr9fTp5zpfxPADKjK5NrHWx5QoMUdi6NsRSJlWsZAOZ1xE13fUHg60coHCGz9
         L8KTelBvvQsClf1NodL6YCelq4Ol69U2fD2Jwlp+Qg82jWdc6cKvPRG+8Dfwd10h1GXK
         eJIB1Vu38FzkxJlUAMfqjcOa76EjkPTv6FXCcrF7OHioGvvqCsPHt0hXWXzpcsKlznTI
         Ov6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=mkL4psSj+prMNO7AohBJyTx+Q189qdo7fgANRpB5e+4=;
        b=FwS6i0uKIdwoGvDNri0MVo4csFd3/e/afhHykIx33QdV5oVVTlDVmnRfLXkAbR/ZOZ
         dqlubCpcoT8p6jf3rDaFvUtM411rFOqNt3zJzHB0g44L0EOd2gn57E4JNqdEe8dCrbp3
         Thk1HCW8OHcok4kCyCuRrfX58zZOOq+MA1pcpJ8oaraabaoDOno32/6ccb6UKTDUZCpq
         KGJoajV9T0+0mC2QAwhLWb23ScCKklTc19wezbdyHF450EEnGoCUrWuVG2LkMbbmXG9h
         oZwxyl7rng+Ub/CKN5EBf/QqZ/ZstlN2/JczEdBY4BohM+z8ynWmDjflRPI2DVNhS9VM
         mFtw==
X-Gm-Message-State: AOAM53203/RcrdZZty4YE+UJ6Aa2bSbHN3mjILh8WB9DPJ4NfRlNoYyJ
        3yY0gvVQd4zS6Ub4hhV1Cgk=
X-Google-Smtp-Source: ABdhPJyAa6AVd7SFvf1Ep4fkh59q91v76tY7vbke901CKM7Z5XY+dbd7TJGFiS7g5cKGjx+7iiHgJA==
X-Received: by 2002:a65:6a51:: with SMTP id o17mr18093661pgu.170.1623077821197;
        Mon, 07 Jun 2021 07:57:01 -0700 (PDT)
Received: from ?IPv6:2404:f801:0:5:8000::4b1? ([2404:f801:9000:1a:efea::4b1])
        by smtp.gmail.com with ESMTPSA id p14sm9148073pgk.6.2021.06.07.07.56.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Jun 2021 07:57:00 -0700 (PDT)
Subject: Re: [RFC PATCH V3 08/11] swiotlb: Add bounce buffer remap address
 setting function
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
From:   Tianyu Lan <ltykernel@gmail.com>
Message-ID: <48516ce3-564c-419e-b355-0ce53794dcb1@gmail.com>
Date:   Mon, 7 Jun 2021 22:56:47 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210607064312.GB24478@lst.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 6/7/2021 2:43 PM, Christoph Hellwig wrote:
> On Sun, May 30, 2021 at 11:06:25AM -0400, Tianyu Lan wrote:
>> From: Tianyu Lan <Tianyu.Lan@microsoft.com>
>>
>> For Hyper-V isolation VM with AMD SEV SNP, the bounce buffer(shared memory)
>> needs to be accessed via extra address space(e.g address above bit39).
>> Hyper-V code may remap extra address space outside of swiotlb. swiotlb_
>> bounce() needs to use remap virtual address to copy data from/to bounce
>> buffer. Add new interface swiotlb_set_bounce_remap() to do that.
> 
> Why can't you use the bus_dma_region ranges to remap to your preferred
> address?
> 

Thanks for your suggestion.

These addresses in extra address space works as system memory mirror. 
The shared memory with host in Isolation VM needs to be accessed via 
extra address space which is above shared gpa boundary. During 
initializing swiotlb bounce buffer pool, only address bellow shared gpa 
boundary can be accepted by swiotlb API because it is treated as system 
memory and managed by memory management. This is why Hyper-V swiotlb 
bounce buffer pool needs to be allocated in Hyper-V code and map
associated physical address in extra address space. The patch target is
to add the new interface to set start virtual address of bounce buffer
pool and let swiotlb boucne buffer copy function to use right virtual 
address for extra address space.

bus_dma_region is to translate cpu physical address to dma address.
It can't modify the virtual address of bounce buffer pool and let
swiotlb code to copy data with right address. If some thing missed,
please correct me.

Thanks.
