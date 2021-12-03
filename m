Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D97C346764A
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 12:26:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243157AbhLCL33 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Dec 2021 06:29:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242314AbhLCL32 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Dec 2021 06:29:28 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA824C06173E;
        Fri,  3 Dec 2021 03:26:04 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id n15-20020a17090a160f00b001a75089daa3so4920700pja.1;
        Fri, 03 Dec 2021 03:26:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=Df2I2A2zVcIhvBHXD5z9iabD7nB5LthE/+eMaX0CJns=;
        b=LrhVabQro3+RJTAF2UUwo++Q3tHVPc9KkdjTXgZj5009TrrrQoEZbScehBEamrCUSN
         uAuPgOUZCbn39oord0X3XW7U/XIJ2WzNu0xdbBsMDjNH8DRAcaKxm/RnUdXTK7TPH9GB
         /3QVEkipv/oDwHi2iskl2LfbgoDlNjPpNEnAH9c0t4ds6OIO4vgwzDl9tD4vqPr3Jj1i
         soeN//lG51eXYc9/8Noh0CxgiHul5HzjoLY8pcB7lUlMXYr1yF0iF5iR8ZnAimEr0fEF
         u9pUnIeyp3+uCAIcJI0WC45iQsDzZ7vfXZh4Mm9tVdhmXvGp7nCrb22wqTAz0TVn9HBO
         JiOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Df2I2A2zVcIhvBHXD5z9iabD7nB5LthE/+eMaX0CJns=;
        b=E8sotDUvNz5HdcrH5IfA/iK7LvYJgg4RelVWrRLHVizWFSn6hFgkgEsenDUzTKeLrA
         Q+h+N1mYrB4xEWlmyrB0uaJzqjnis9D8EP9nBoLskUzEheAPiqgbPITWDF7x2vJdhcDf
         NOo5uVxEB8EFXXg39S9SI1ncNlWE3jXW7nWxdUBApY93HkAH+pW+/208VhKRDBm6O6bt
         g3x2wKYiOCWwog+1Vxa6Jndci62ccXZpdX+QRu9netfxemp4Y0bJI1IJ8Xv40BeafVnL
         qg9q0pBH8BiLz+X6qKpNoc1NuQ31iZO8FW0piEUxmXpmOGJ/OO31krkMCF2YeZRXJLO1
         5qFg==
X-Gm-Message-State: AOAM530kmE34KKke+ux6Vu+DB64YRdpMEiEZfMFXjH+7nD2Th4oF16aC
        8Bkj52vCbo0njkL9R0TL8XY=
X-Google-Smtp-Source: ABdhPJzPvoKIz31xLOmSdpnjjIrMa2J9GjBdJxPwkC+KmRLj7Ds+PG6GrIFi6sWFBo0epAEx6rdfGQ==
X-Received: by 2002:a17:90b:190f:: with SMTP id mp15mr13348018pjb.210.1638530764387;
        Fri, 03 Dec 2021 03:26:04 -0800 (PST)
Received: from ?IPV6:2404:f801:0:5:8000::50b? ([2404:f801:9000:1a:efea::50b])
        by smtp.gmail.com with ESMTPSA id mp12sm5062949pjb.39.2021.12.03.03.25.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Dec 2021 03:26:04 -0800 (PST)
Message-ID: <4006e942-b6bf-ac21-c56b-4719e514dbd2@gmail.com>
Date:   Fri, 3 Dec 2021 19:25:52 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [PATCH V3 3/5] hyperv/IOMMU: Enable swiotlb bounce buffer for
 Isolation VM
Content-Language: en-US
To:     Wei Liu <wei.liu@kernel.org>
Cc:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        decui@microsoft.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
        hpa@zytor.com, jgross@suse.com, sstabellini@kernel.org,
        boris.ostrovsky@oracle.com, joro@8bytes.org, will@kernel.org,
        davem@davemloft.net, kuba@kernel.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, arnd@arndb.de, hch@infradead.org,
        m.szyprowski@samsung.com, robin.murphy@arm.com,
        Tianyu.Lan@microsoft.com, thomas.lendacky@amd.com,
        xen-devel@lists.xenproject.org, michael.h.kelley@microsoft.com,
        iommu@lists.linux-foundation.org, linux-arch@vger.kernel.org,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, netdev@vger.kernel.org,
        vkuznets@redhat.com, brijesh.singh@amd.com, konrad.wilk@oracle.com,
        hch@lst.de, parri.andrea@gmail.com, dave.hansen@intel.com
References: <20211201160257.1003912-1-ltykernel@gmail.com>
 <20211201160257.1003912-4-ltykernel@gmail.com>
 <20211202144336.z2sfs6kw5kdsfqgv@liuwe-devbox-debian-v2>
From:   Tianyu Lan <ltykernel@gmail.com>
In-Reply-To: <20211202144336.z2sfs6kw5kdsfqgv@liuwe-devbox-debian-v2>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/2/2021 10:43 PM, Wei Liu wrote:
> On Wed, Dec 01, 2021 at 11:02:54AM -0500, Tianyu Lan wrote:
> [...]
>> diff --git a/arch/x86/xen/pci-swiotlb-xen.c b/arch/x86/xen/pci-swiotlb-xen.c
>> index 46df59aeaa06..30fd0600b008 100644
>> --- a/arch/x86/xen/pci-swiotlb-xen.c
>> +++ b/arch/x86/xen/pci-swiotlb-xen.c
>> @@ -4,6 +4,7 @@
>>   
>>   #include <linux/dma-map-ops.h>
>>   #include <linux/pci.h>
>> +#include <linux/hyperv.h>
>>   #include <xen/swiotlb-xen.h>
>>   
>>   #include <asm/xen/hypervisor.h>
>> @@ -91,6 +92,6 @@ int pci_xen_swiotlb_init_late(void)
>>   EXPORT_SYMBOL_GPL(pci_xen_swiotlb_init_late);
>>   
>>   IOMMU_INIT_FINISH(pci_xen_swiotlb_detect,
>> -		  NULL,
>> +		  hyperv_swiotlb_detect,
> 
> It is not immediately obvious why this is needed just by reading the
> code. Please consider copying some of the text in the commit message to
> a comment here.
> 

Thanks for suggestion. Will update.
