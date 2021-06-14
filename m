Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FD313A68B1
	for <lists+netdev@lfdr.de>; Mon, 14 Jun 2021 16:05:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234491AbhFNOHb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 10:07:31 -0400
Received: from mail-pg1-f172.google.com ([209.85.215.172]:40837 "EHLO
        mail-pg1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234235AbhFNOHZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Jun 2021 10:07:25 -0400
Received: by mail-pg1-f172.google.com with SMTP id m2so2003980pgk.7;
        Mon, 14 Jun 2021 07:05:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=yJB+B/uqyT8Yj8oTe4yW/iwZF1PlGwEGbYmCRyf4VPs=;
        b=WH301YVkd+NT/H+jeV6pcNYHdcjqtaqvIdtbpu0fkkYAmJ7rw0/VnTDAhSvIgbv4c0
         oazbEKmF+c7M1WRPaxGMZU5xoCLTUJgtdxU9APUEzGlzXnchk40ZNp3QFWLwuNrBu83j
         e2ylhCoSYk62pl120eNuhLwuvfMbaggtn+gXAD60VuMlb9RO9aR6yjsww4EENQAJey5G
         2ZzxWZw9pL2yOQEQRAidkW9g0ErNbkj+wegNJA0H7wJ55BH2rzTM1HnAVz1Nh8SFyWFK
         I7BbhU7Q2hwWxihuFlWkGm+R8myZotEgjwBltHJuCwGgHkDJ5/gTI6uquz0y/0l8g0ap
         0ueg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=yJB+B/uqyT8Yj8oTe4yW/iwZF1PlGwEGbYmCRyf4VPs=;
        b=O7SsglrsisO5g9SvVXVyGOQsdgDPrGN+Z/o6DksgNz+HXxec6qxB6E5eZ5uSIxMAK/
         hDgOrergHjYSlDA4avlmAJDSas3u8k29m7ZG6CujVv9WfbreHSG6yFU1VMMwcNE5+fRX
         7EaiqmvjtvkT+8vP7jN33UWI0BPIh6xa2Kd421NuiUxSrhzBgPUmX51f3yjUFqnThOhX
         fFcQ8r4jA8UCOkWLcydLpvmMvoyTudTVn02RtQHtJUi25CBAQ6b78KzHLv/zTuSEBfR6
         Dvrt3VwDlxQRxuZHH6mHWweVx19h34MfBIHTgTLoH0mMu2M4avUkgMgLqZd+r5AmhgZN
         I5Ug==
X-Gm-Message-State: AOAM531prSayypQTp290EodSMoY1aDSwj3O+bnpNnPDgEU2a6wbQkqLE
        zUAgPbpplvXgp/FTg+Hs4DY=
X-Google-Smtp-Source: ABdhPJyxkq2bPSQ3rYusHXFwzEn3le7fAXsaXh5Rh36tAMz0+W6V1tW5a8HSqlbDYgsTNNATX2tI2A==
X-Received: by 2002:a63:5760:: with SMTP id h32mr17200205pgm.367.1623679460361;
        Mon, 14 Jun 2021 07:04:20 -0700 (PDT)
Received: from ?IPv6:2404:f801:0:5:8000::4b1? ([2404:f801:9000:1a:efea::4b1])
        by smtp.gmail.com with ESMTPSA id x206sm12950089pfc.211.2021.06.14.07.04.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Jun 2021 07:04:20 -0700 (PDT)
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
From:   Tianyu Lan <ltykernel@gmail.com>
Message-ID: <e10c2696-23c3-befe-4f4d-25e18918132f@gmail.com>
Date:   Mon, 14 Jun 2021 22:04:06 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210614070903.GA29976@lst.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 6/14/2021 3:09 PM, Christoph Hellwig wrote:
> On Mon, Jun 07, 2021 at 11:21:20PM +0800, Tianyu Lan wrote:
>>> dma_map_single can only be used on page baked memory, and if this is
>>> using page backed memory you wouldn't need to do thee phys_to_virt
>>> tricks.  Can someone explain the mess here in more detail?
>>
>> Sorry. Could you elaborate the issue? These pages in the pb array are not
>> allocated by DMA API and using dma_map_single() here is to map these pages'
>> address to bounce buffer physical address.
> 
> dma_map_single just calls dma_map_page using virt_to_page.  So this
> can't work on addresses not in the kernel linear mapping.
> 

The pages in the hv_page_buffer array here are in the kernel linear 
mapping. The packet sent to host will contain an array which contains 
transaction data. In the isolation VM, data in the these pages needs to 
be copied to bounce buffer and so call dma_map_single() here to map 
these data pages with bounce buffer. The vmbus has ring buffer where the 
send/receive packets are copied to/from. The ring buffer has been 
remapped to the extra space above shared gpa boundary/vTom during 
probing Netvsc driver and so not call dma map function for vmbus ring
buffer.




