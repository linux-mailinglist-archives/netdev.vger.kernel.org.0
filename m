Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF9FB39E029
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 17:21:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230414AbhFGPX0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 11:23:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230217AbhFGPXZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Jun 2021 11:23:25 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B514C061766;
        Mon,  7 Jun 2021 08:21:34 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id 22-20020a17090a0c16b0290164a5354ad0so12181445pjs.2;
        Mon, 07 Jun 2021 08:21:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=AqJMsqQ4KNSlTkis4vnlFWwGNt3Bx7s+42JKf63F/jc=;
        b=WsBdcRsefCiECb9IqTSuqCUv8coeVKPfrhSnmSii/c3l1gmGod3/U/htpg5pceudXy
         aYMrb18s8dW7vOcfl+l3/JLyfgriswqTmUyfzOzd+MpR4PFDQBqNxGysTptsKMLLdnqS
         jvqIZCDUxhyEXhn3kFG8PvvaL25gkKk9fhLU2Y6GVkr75vdb0Ve9OxPhhCsLOSZbZ46o
         oReEyqo0bUD1A3JvfVwFOyoUdnbneVTJbIjly5SDJg+VKDoLMXo7YsQjaqCn4F5oQkI9
         W8T56TKPKa5QxGA65hUQQsSol/AsF5UgHxkBXTE4sP50uacN6R0GzZbY+xLSbeosBWte
         pywQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=AqJMsqQ4KNSlTkis4vnlFWwGNt3Bx7s+42JKf63F/jc=;
        b=MeQeU2Ir03tCyqYM3rLAHeZ1yS4sXLoA8ylkw+16k39ilc1HdG5cyR4dP1AfYW+qEz
         HO/ry9XUmE3SrAXs4DM59W5FAM8ids/qYGilbCcnBYRO5svd3nN2hRfjZIp+7y92qUIs
         NLHJT2bgZ/unAZXnLA8SN1NvLverYScZ5SbzehioOt/Q+n6JLFj+kNKQW0eNvllH9iJS
         JZDEp1V+avfwXlepJZrKDbDpnTNQyM5bELprAupcP1UpYgzyVnzHa0QoraTbHm2pVrp8
         Bbb7tSKrT5umWfYPyyno+1oXqMt16Y8a1qg9nQPYXrK506ZhcyclTcSUFXGN5i8CJMM6
         qArg==
X-Gm-Message-State: AOAM530fLaBlDfCNWDPHYFAAnWlcGl95qFjcwbAjPc/c92hikvRMFdZl
        7xSA7BZKUZM5Zj6YoMENaI0=
X-Google-Smtp-Source: ABdhPJwKT7FVRh43L9EMp25B1edDg0633yW6Rnccv/gD+CMCio9gORsvm6jnf+jqiJgT4Bx7SQrrGw==
X-Received: by 2002:a17:90a:c68a:: with SMTP id n10mr33294547pjt.32.1623079293798;
        Mon, 07 Jun 2021 08:21:33 -0700 (PDT)
Received: from ?IPv6:2404:f801:0:5:8000::4b1? ([2404:f801:9000:1a:efea::4b1])
        by smtp.gmail.com with ESMTPSA id g63sm8507428pfb.55.2021.06.07.08.21.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Jun 2021 08:21:33 -0700 (PDT)
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
From:   Tianyu Lan <ltykernel@gmail.com>
Message-ID: <279cb4bf-c5b6-6db9-0f1e-9238e902c8f2@gmail.com>
Date:   Mon, 7 Jun 2021 23:21:20 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210607065007.GE24478@lst.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/7/2021 2:50 PM, Christoph Hellwig wrote:
> On Sun, May 30, 2021 at 11:06:27AM -0400, Tianyu Lan wrote:
>> +	if (hv_isolation_type_snp()) {
>> +		pfns = kcalloc(buf_size / HV_HYP_PAGE_SIZE, sizeof(unsigned long),
>> +			       GFP_KERNEL);
>> +		for (i = 0; i < buf_size / HV_HYP_PAGE_SIZE; i++)
>> +			pfns[i] = virt_to_hvpfn(net_device->recv_buf + i * HV_HYP_PAGE_SIZE) +
>> +				(ms_hyperv.shared_gpa_boundary >> HV_HYP_PAGE_SHIFT);
>> +
>> +		vaddr = vmap_pfn(pfns, buf_size / HV_HYP_PAGE_SIZE, PAGE_KERNEL_IO);
>> +		kfree(pfns);
>> +		if (!vaddr)
>> +			goto cleanup;
>> +		net_device->recv_original_buf = net_device->recv_buf;
>> +		net_device->recv_buf = vaddr;
>> +	}
> 
> This probably wnats a helper to make the thing more readable.  But who
> came up with this fucked up communication protocol where the host needs
> to map random pfns into a contigous range?  Sometime I really have to
> wonder what crack the hyper-v people take when comparing this to the
> relatively sane approach others take.

Agree. Will add a helper function.
> 
>> +	for (i = 0; i < page_count; i++)
>> +		dma_unmap_single(&hv_dev->device, packet->dma_range[i].dma,
>> +				 packet->dma_range[i].mapping_size,
>> +				 DMA_TO_DEVICE);
>> +
>> +	kfree(packet->dma_range);
> 
> Any reason this isn't simply using a struct scatterlist?

I will have a look. Thanks to reminder scatterlist.

> 
>> +	for (i = 0; i < page_count; i++) {
>> +		char *src = phys_to_virt((pb[i].pfn << HV_HYP_PAGE_SHIFT)
>> +					 + pb[i].offset);
>> +		u32 len = pb[i].len;
>> +
>> +		dma = dma_map_single(&hv_dev->device, src, len,
>> +				     DMA_TO_DEVICE);
> 
> dma_map_single can only be used on page baked memory, and if this is
> using page backed memory you wouldn't need to do thee phys_to_virt
> tricks.  Can someone explain the mess here in more detail?

Sorry. Could you elaborate the issue? These pages in the pb array are 
not allocated by DMA API and using dma_map_single() here is to map these 
pages' address to bounce buffer physical address.

> 
>>   	struct rndis_device *dev = nvdev->extension;
>>   	struct rndis_request *request = NULL;
>> +	struct hv_device *hv_dev = ((struct net_device_context *)
>> +			netdev_priv(ndev))->device_ctx;
> 
> Why not use a net_device_context local variable instead of this cast
> galore?
> 

OK. I will update.


Thanks.
