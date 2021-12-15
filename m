Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD3FE4751D2
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 06:00:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239794AbhLOFAw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 00:00:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbhLOFAv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Dec 2021 00:00:51 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFC03C061574;
        Tue, 14 Dec 2021 21:00:51 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id n15-20020a17090a394f00b001b0f6d6468eso2792718pjf.3;
        Tue, 14 Dec 2021 21:00:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=8sb3K87sdhKiYvwx5bE3jeNXRLJJS0kXGICNRdYkExM=;
        b=GVxjwKmV+XdfIx3OX8dNy0HsVz+rAhcBP4TxG/bSjazWU1VGQl3lo1m/ntwbSt/fE8
         +fLt661wiY2Ob3UprzkHURpD8SPtv4vHfUM/qgarRm+yGZxuZRKRzNHfy6+6gVbu+Hm6
         irdS04nAlXP7ipPNqkW5x5zmKimsFBWvHX9F3Bwrt5Nta8SM6aSBKlZmMehQQRnZQrLS
         jMbPbmJP843pXc50Ss37z22jgJfrijxc5qboOdvVWhHjb7sXSeK2tJftp8Ha2seC/yVQ
         /A9vgVwODdZfImj6DIVkjVQAXWlrbNDT0tUyuL5dQtYdvCvOnt9h1qdW/5d2mw0Oo6mr
         FJSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=8sb3K87sdhKiYvwx5bE3jeNXRLJJS0kXGICNRdYkExM=;
        b=UxWrph/Mo3HKEgUq5pKUuO3WGiARgEvPIy6fzYuN4dlPGcp9BVciKxLKWVTIvjSXRc
         sE9uXupOhed5MeGEPVz//d7xKlFOib/uflbHeI7cd1tLK3AOQwdcgd/XvzNV8/FgtSwk
         iz27k8Qjm9ilUGP6r1tb+9AKY1ATrQ17ZfPz2YdS7Z5ghuKfhgL9y1z5xhBuYZjqEE3o
         cl17G7o0631+CZyg7lxbbcpXWi/ut6b1lm+U5e/6aFiaOtDVZ7ZOQj6LUFHvvbx7ao1r
         PlYJFtEVFXxVEraBAk7o/RLxLZhbC105wUXKjLYq7oEaUS1D0b+wuBiDSzV+7fRcVoEv
         4Kfw==
X-Gm-Message-State: AOAM532tnPdQ0ZFkq+Vz4+EsNO7Ic27KdVnktLb4eIZEjstf2J484ozQ
        Mv5cQR06kd5Nznmxhar2AKQ=
X-Google-Smtp-Source: ABdhPJwcOKly8tCIGgpC7MXZRzN03nfzM7/pY6teJOhQSIlHmDoW624D++0O7lZvpqu65iezQV0wQw==
X-Received: by 2002:a17:902:728e:b0:143:a388:868b with SMTP id d14-20020a170902728e00b00143a388868bmr9724300pll.33.1639544450122;
        Tue, 14 Dec 2021 21:00:50 -0800 (PST)
Received: from ?IPV6:2404:f801:0:5:8000::50b? ([2404:f801:9000:1a:efea::50b])
        by smtp.gmail.com with ESMTPSA id m6sm723040pfh.87.2021.12.14.21.00.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Dec 2021 21:00:49 -0800 (PST)
Message-ID: <fb2ff8b7-ab8c-7c4b-0850-222cd2cf7c4a@gmail.com>
Date:   Wed, 15 Dec 2021 13:00:38 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH V7 1/5] swiotlb: Add swiotlb bounce buffer remap function
 for HV IVM
Content-Language: en-US
To:     Dave Hansen <dave.hansen@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>, kys@microsoft.com,
        haiyangz@microsoft.com, sthemmin@microsoft.com, wei.liu@kernel.org,
        decui@microsoft.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
        hpa@zytor.com, davem@davemloft.net, kuba@kernel.org,
        jejb@linux.ibm.com, martin.petersen@oracle.com, arnd@arndb.de,
        hch@infradead.org, m.szyprowski@samsung.com, robin.murphy@arm.com,
        Tianyu.Lan@microsoft.com, michael.h.kelley@microsoft.com
Cc:     iommu@lists.linux-foundation.org, linux-arch@vger.kernel.org,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, netdev@vger.kernel.org,
        vkuznets@redhat.com, brijesh.singh@amd.com, konrad.wilk@oracle.com,
        hch@lst.de, joro@8bytes.org, parri.andrea@gmail.com
References: <20211213071407.314309-1-ltykernel@gmail.com>
 <20211213071407.314309-2-ltykernel@gmail.com>
 <198e9243-abca-b23e-0e8e-8581a7329ede@intel.com>
 <3243ff22-f6c8-b7cd-26b7-6e917e274a7c@gmail.com>
 <c25ff1e8-4d1e-cf1c-a9f6-c189307f92fd@intel.com>
 <a1c8f26f-fbf2-29b6-e734-e6d6151c39f8@amd.com>
 <7afc23c3-22e7-9bbf-7770-c683bf84a7cc@intel.com>
From:   Tianyu Lan <ltykernel@gmail.com>
In-Reply-To: <7afc23c3-22e7-9bbf-7770-c683bf84a7cc@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/15/2021 6:40 AM, Dave Hansen wrote:
> On 12/14/21 2:23 PM, Tom Lendacky wrote:
>>> I don't really understand how this can be more general any *not* get
>>> utilized by the existing SEV support.
>>
>> The Virtual Top-of-Memory (VTOM) support is an SEV-SNP feature that is
>> meant to be used with a (relatively) un-enlightened guest. The idea is
>> that the C-bit in the guest page tables must be 0 for all accesses. It
>> is only the physical address relative to VTOM that determines if the
>> access is encrypted or not. So setting sme_me_mask will actually cause
>> issues when running with this feature. Since all DMA for an SEV-SNP
>> guest must still be to shared (unencrypted) memory, some enlightenment
>> is needed. In this case, memory mapped above VTOM will provide that via
>> the SWIOTLB update. For SEV-SNP guests running with VTOM, they are
>> likely to also be running with the Reflect #VC feature, allowing a
>> "paravisor" to handle any #VCs generated by the guest.
>>
>> See sections 15.36.8 "Virtual Top-of-Memory" and 15.36.9 "Reflect #VC"
>> in volume 2 of the AMD APM [1].
> 
> Thanks, Tom, that's pretty much what I was looking for.
> 
> The C-bit normally comes from the page tables.  But, the hardware also
> provides an alternative way to effectively get C-bit behavior without
> actually setting the bit in the page tables: Virtual Top-of-Memory
> (VTOM).  Right?
> 
> It sounds like Hyper-V has chosen to use VTOM instead of requiring the
> guest to do the C-bit in its page tables.
> 
> But, the thing that confuses me is when you said: "it (VTOM) is meant to
> be used with a (relatively) un-enlightened guest".  We don't have an
> unenlightened guest here.  We have Linux, which is quite enlightened.
>
>> Is VTOM being used because there's something that completely rules out
>> using the C-bit in the page tables?  What's that "something"?


For "un-enlightened" guest, there is an another system running insider
the VM to emulate some functions(tsc, timer, interrupt and so on) and
this helps not to modify OS(Linux/Windows) a lot. In Hyper-V Isolation
VM, we called the new system as HCL/paravisor. HCL runs in the VMPL0 and 
Linux runs in VMPL2. This is similar with nested virtualization. HCL
plays similar role as L1 hypervisor to emulate some general functions
(e.g, rdmsr/wrmsr accessing and interrupt injection) which needs to be
enlightened in the enlightened guest. Linux kernel needs to handle
#vc/#ve exception directly in the enlightened guest. HCL handles such
exception in un-enlightened guest and emulate interrupt injection which
helps not to modify OS core part code. Using vTOM also is same purpose.
Hyper-V uses vTOM avoid changing page table related code in OS(include
Windows and Linux)and just needs to map memory into decrypted address
space above vTOM in the driver code.

Linux has generic swiotlb bounce buffer implementation and so introduce
swiotlb_unencrypted_base here to set shared memory boundary or vTOM.
Hyper-V Isolation VM is un-enlightened guest. Hyper-V doesn't expose 
sev/sme capability to guest and so SEV code actually doesn't work.
So we also can't interact current existing SEV code and these code is
for enlightened guest support without HCL/paravisor. If other platforms
or SEV want to use similar vTOM feature, swiotlb_unencrypted_base can
be reused. So swiotlb_unencrypted_base is a general solution for all
platforms besides SEV and Hyper-V.










