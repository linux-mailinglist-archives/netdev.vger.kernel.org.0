Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42FF3469889
	for <lists+netdev@lfdr.de>; Mon,  6 Dec 2021 15:19:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343912AbhLFOXC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 09:23:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343892AbhLFOXB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 09:23:01 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67FE7C061354;
        Mon,  6 Dec 2021 06:19:33 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id np3so7866857pjb.4;
        Mon, 06 Dec 2021 06:19:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=7+TjBg26qYjN6N7+9VcAF9zyslm2ABiWax4bLutA+tA=;
        b=f9M5JLJRG6hZFPCcZ1VGBj6dk4h92i9GiiVgKsNNUQFiDTSIXmaER9IaQWziUfrQ/0
         qa3GNaf/njTkL1uJ81a318oppGqxeZ4BbcT9GGYMjs1cw8PHMlBEDdFp5Gu7W2ZYhqeP
         DQ0dE5SsoRhc/sIPqjG5IRHWnrHc+0w5hEjT3ppnETiBZyKvJyuh5hygqrwyVBhoEnmJ
         IwRmbyJ5sNomLrxjpRo1y9wtWt2MJXEM2X247X8t1UvJ2rV20IbyXdb2S1lE9i34MGPO
         C7yQKcwPzpoDJz5kk+NMg8L4gzvSsI27nnr11s1xyG3B7cafIHH1YyJFJ5x78gBD3amG
         bCXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=7+TjBg26qYjN6N7+9VcAF9zyslm2ABiWax4bLutA+tA=;
        b=UvlXzEXsd3R7DYnp24g12FIxKHRqf3uACVzaNWIxuF/Rm1HM9VYnvDYSkum0zbjTfH
         bvfDK9J+RbDP3fccdPb4DqZU0m+H4ee2CG+RYQw9SZqQuebuv71BPRnb+dnCvamYg0t3
         kSHWnxIpfIqGCDbCOWK0rrGFNXqz8Sq0tzZ9l4bSNuIz+YzbJ+MvYtXR5u97dCj5oAV4
         wxSDrNGtgSBnAqDxetZjh732Qnnae5H6/RHYZGH7oWcHiocovqvmfsLXdAaI6/hQhQtg
         HEs8tFOATeg7vTzEb+W9AFQaEBhZKjQtX+/xd7mbV/7RdnUojGn65JCEbO+MuJy3/Iqp
         4rJA==
X-Gm-Message-State: AOAM533wUm/y5Fvsmg7Hn4FuUXY9kAUcngliIFhkx08PzWCqic65Y5bb
        ZkWdTPzgZOKDyg7I5VW0IWg=
X-Google-Smtp-Source: ABdhPJw5eBcqMnlmCu3VP7SDK7JlPHBF3sS/6sU5CfZhorAn8F+Tm/Z37W+b1RJF7S8Gmv/jOQFzmw==
X-Received: by 2002:a17:90b:4b51:: with SMTP id mi17mr37838716pjb.48.1638800372941;
        Mon, 06 Dec 2021 06:19:32 -0800 (PST)
Received: from ?IPV6:2404:f801:0:5:8000::50b? ([2404:f801:9000:1a:efea::50b])
        by smtp.gmail.com with ESMTPSA id h1sm3517800pfh.219.2021.12.06.06.19.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Dec 2021 06:19:32 -0800 (PST)
Message-ID: <581569ce-b166-1cad-2624-66de319cc2b9@gmail.com>
Date:   Mon, 6 Dec 2021 22:19:21 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [PATCH V4 3/5] hyperv/IOMMU: Enable swiotlb bounce buffer for
 Isolation VM
Content-Language: en-US
To:     Juergen Gross <jgross@suse.com>, kys@microsoft.com,
        haiyangz@microsoft.com, sthemmin@microsoft.com, wei.liu@kernel.org,
        decui@microsoft.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
        hpa@zytor.com, sstabellini@kernel.org, boris.ostrovsky@oracle.com,
        joro@8bytes.org, will@kernel.org, davem@davemloft.net,
        kuba@kernel.org, jejb@linux.ibm.com, martin.petersen@oracle.com,
        arnd@arndb.de, hch@infradead.org, m.szyprowski@samsung.com,
        robin.murphy@arm.com, thomas.lendacky@amd.com,
        Tianyu.Lan@microsoft.com, xen-devel@lists.xenproject.org,
        michael.h.kelley@microsoft.com
Cc:     iommu@lists.linux-foundation.org, linux-arch@vger.kernel.org,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, netdev@vger.kernel.org,
        vkuznets@redhat.com, brijesh.singh@amd.com, konrad.wilk@oracle.com,
        hch@lst.de, parri.andrea@gmail.com, dave.hansen@intel.com
References: <20211205081815.129276-1-ltykernel@gmail.com>
 <20211205081815.129276-4-ltykernel@gmail.com>
 <a5943893-510a-3fc8-cbb7-8742369bf36b@suse.com>
 <125ffb7d-958c-e77a-243b-4cf38f690396@gmail.com>
 <ed9aa3d5-9ac8-2195-e617-85599ffd7864@suse.com>
From:   Tianyu Lan <ltykernel@gmail.com>
In-Reply-To: <ed9aa3d5-9ac8-2195-e617-85599ffd7864@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/5/2021 6:31 PM, Juergen Gross wrote:
> On 05.12.21 09:48, Tianyu Lan wrote:
>>
>>
>> On 12/5/2021 4:34 PM, Juergen Gross wrote:
>>> On 05.12.21 09:18, Tianyu Lan wrote:
>>>> From: Tianyu Lan <Tianyu.Lan@microsoft.com>
>>>>
>>>> hyperv Isolation VM requires bounce buffer support to copy
>>>> data from/to encrypted memory and so enable swiotlb force
>>>> mode to use swiotlb bounce buffer for DMA transaction.
>>>>
>>>> In Isolation VM with AMD SEV, the bounce buffer needs to be
>>>> accessed via extra address space which is above shared_gpa_boundary
>>>> (E.G 39 bit address line) reported by Hyper-V CPUID ISOLATION_CONFIG.
>>>> The access physical address will be original physical address +
>>>> shared_gpa_boundary. The shared_gpa_boundary in the AMD SEV SNP
>>>> spec is called virtual top of memory(vTOM). Memory addresses below
>>>> vTOM are automatically treated as private while memory above
>>>> vTOM is treated as shared.
>>>>
>>>> Hyper-V initalizes swiotlb bounce buffer and default swiotlb
>>>> needs to be disabled. pci_swiotlb_detect_override() and
>>>> pci_swiotlb_detect_4gb() enable the default one. To override
>>>> the setting, hyperv_swiotlb_detect() needs to run before
>>>> these detect functions which depends on the pci_xen_swiotlb_
>>>> init(). Make pci_xen_swiotlb_init() depends on the hyperv_swiotlb
>>>> _detect() to keep the order.
>>>
>>> Why? Does Hyper-V plan to support Xen PV guests? If not, I don't see
>>> the need for adding this change.
>>>
>>
>> This is to keep detect function calling order that Hyper-V detect 
>> callback needs to call before pci_swiotlb_detect_override() and 
>> pci_swiotlb_detect_4gb(). This is the same for why
>> pci_swiotlb_detect_override() needs to depend on the 
>> pci_xen_swiotlb_detect(). Hyper-V also has such request and so make 
>> xen detect callback depends on Hyper-V one.
> 
> And does this even work without CONFIG_SWIOTLB_XEN, i.e. without
> pci_xen_swiotlb_detect() being in the system?
> 
Hi Juergen:
	Thanks for your review. This is a issue and I just sent out a v5 which 
decouples the dependency between xen and hyperv.
