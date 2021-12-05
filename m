Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBFD2468A30
	for <lists+netdev@lfdr.de>; Sun,  5 Dec 2021 09:48:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232644AbhLEIwE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Dec 2021 03:52:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229543AbhLEIwE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Dec 2021 03:52:04 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 723E4C061751;
        Sun,  5 Dec 2021 00:48:37 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id nh10-20020a17090b364a00b001a69adad5ebso5955979pjb.2;
        Sun, 05 Dec 2021 00:48:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=8ElIWeK3HZUhVw6Ru2fZxbGUFywB7lrb6pvwqCD90RQ=;
        b=bhv+ck/2NjW3XdA5BdRJjrWjIx7SyB0AZD+SN7/uKgD3cNgz6NnwAapRCo31zVSjzb
         NgZfsJ9/WQJJVn0VQnfOvhjrrQOUzDrWIZM6PBt02DsFfzOz0P0ty/E37M6lr8XytZ8A
         GgSWqw3N3Wxkk4kEV7dVoFtJ/fMVjrGspM0eMj7D7dAa6oC4rMqhk2Wmz428zuCyQ5ZD
         c+miU2npH6exTC0s6kc0N84Ux0N5mF2cpbZBZ2fD2HS6+BdfQnTvvbKBTj/M+EhVg9eP
         ySsd7Y2jJxO1lk6Nu30PxbFhUxeOGHSf8UIIB9fVS7RViOaS3EpL1I+yAKQTnYjJJO58
         teFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=8ElIWeK3HZUhVw6Ru2fZxbGUFywB7lrb6pvwqCD90RQ=;
        b=vhEPnzkWBoLKI95nzIcry28xmq4d1bR+P6aXU+omkLXvziTau2Nhmyv45kkf6548tI
         ihcGMHEX9Yd8ehQRONYVIRigxtursya4jlQHlI/LIR3lneY1sKdCv/7xpVoRBBx8ngqW
         X0ArbB1qvm0OM8JMRfXmZJN+GnN/HJrAYkCQ3I7STmxe2NWtYwIapUJqnHHvPO6G6dN5
         uHLrUGfStdYvEwPgcm1qRXxufBbbKreTBEH47Tp9bzR6HsB8nMtRJqiXQP+YFB7TNP8q
         Ty4qBVMfttr+iPiTroEYgLO7YJCVnYAFJuD30RNC2ervKXfL0EMzmNU+gXNrFIueoXPC
         2drw==
X-Gm-Message-State: AOAM532/BQkrYMLe0ivhqFVDeMbE/sH06YA+ZKcLzl93VimY4xFnjxRq
        yOWJEeCIypZ3fJcmmLEbvAI=
X-Google-Smtp-Source: ABdhPJzbQjlNRx+yi2tFC2SlLvbS0vVoKxN+s/34myLn6vcm23U1Ad+X1dwpNWhVsnVmCKxk4h5fmA==
X-Received: by 2002:a17:902:b28a:b0:142:3e17:38d8 with SMTP id u10-20020a170902b28a00b001423e1738d8mr35656284plr.56.1638694116990;
        Sun, 05 Dec 2021 00:48:36 -0800 (PST)
Received: from ?IPV6:2404:f801:0:5:8000::50b? ([2404:f801:9000:1a:efea::50b])
        by smtp.gmail.com with ESMTPSA id m10sm6512901pgv.75.2021.12.05.00.48.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 05 Dec 2021 00:48:36 -0800 (PST)
Message-ID: <125ffb7d-958c-e77a-243b-4cf38f690396@gmail.com>
Date:   Sun, 5 Dec 2021 16:48:24 +0800
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
From:   Tianyu Lan <ltykernel@gmail.com>
In-Reply-To: <a5943893-510a-3fc8-cbb7-8742369bf36b@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/5/2021 4:34 PM, Juergen Gross wrote:
> On 05.12.21 09:18, Tianyu Lan wrote:
>> From: Tianyu Lan <Tianyu.Lan@microsoft.com>
>>
>> hyperv Isolation VM requires bounce buffer support to copy
>> data from/to encrypted memory and so enable swiotlb force
>> mode to use swiotlb bounce buffer for DMA transaction.
>>
>> In Isolation VM with AMD SEV, the bounce buffer needs to be
>> accessed via extra address space which is above shared_gpa_boundary
>> (E.G 39 bit address line) reported by Hyper-V CPUID ISOLATION_CONFIG.
>> The access physical address will be original physical address +
>> shared_gpa_boundary. The shared_gpa_boundary in the AMD SEV SNP
>> spec is called virtual top of memory(vTOM). Memory addresses below
>> vTOM are automatically treated as private while memory above
>> vTOM is treated as shared.
>>
>> Hyper-V initalizes swiotlb bounce buffer and default swiotlb
>> needs to be disabled. pci_swiotlb_detect_override() and
>> pci_swiotlb_detect_4gb() enable the default one. To override
>> the setting, hyperv_swiotlb_detect() needs to run before
>> these detect functions which depends on the pci_xen_swiotlb_
>> init(). Make pci_xen_swiotlb_init() depends on the hyperv_swiotlb
>> _detect() to keep the order.
> 
> Why? Does Hyper-V plan to support Xen PV guests? If not, I don't see
> the need for adding this change.
> 

This is to keep detect function calling order that Hyper-V detect 
callback needs to call before pci_swiotlb_detect_override() and 
pci_swiotlb_detect_4gb(). This is the same for why
pci_swiotlb_detect_override() needs to depend on the 
pci_xen_swiotlb_detect(). Hyper-V also has such request and so make xen 
detect callback depends on Hyper-V one.
