Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E151470247
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 15:01:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239164AbhLJOFG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 09:05:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239129AbhLJOFE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Dec 2021 09:05:04 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E0F8C061746;
        Fri, 10 Dec 2021 06:01:29 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id z6so6341952plk.6;
        Fri, 10 Dec 2021 06:01:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language
         :from:to:cc:references:in-reply-to:content-transfer-encoding;
        bh=qGyMg3tvfT9nUCepnAppoZ9Lv+yUxkzqt89//s+CHr8=;
        b=E5gvOzOd9Jcgbo7L0/Gr2lPgDb+GzCE1t9Hj5oLewunkZJ69lNCjzxAU+rrM7IZX8M
         m3l9lRj2J8s1wNDOSmylB7KXS78MBT5AoUfgGA9Lt5H9CgvPI3rtE+36X8jmCXZD/FQh
         vN05DUXd4DejDyXPhkRZD+YfK5YG6cv397KJs01OrVXKhlLKE0Awcy1NbP8ZR9zum4Tx
         0ERuW0U61lzP2W3au6RMK4oP4M2lfyyNEhkRSZbW81m729P0vMx/YjDbGowwayZRjSDb
         MwIhPqLO1Vk1KSKHZP9u/MTjJi8Fb3+F/5X7rj5h2Q4nFoGUHhKLQYJfktOvskXkeuok
         ML3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=qGyMg3tvfT9nUCepnAppoZ9Lv+yUxkzqt89//s+CHr8=;
        b=J16bhdEnchqUFJT2JVFGFsmX3dDBQN9TC7RvgOIZ5uuybGAe2JVRZlkF/vjeICxp2P
         wQSP8BXUHA0/6r9lz6GQ6xrHpIantNs8zHZXmirPK/PPxzMbutOwNB8V8q8BiGT3S0xo
         1hF4ehhLtyUhp21A0309Mum3DDFe47ODgOwA5E6GFCw0NeLNiKuIFA333MuhZsjSbOjQ
         +zbATAecrD6tsSGqBagOqRuIkRMPris/wqCadM3c9ZDt5YRK2JWqnOqRuOAIuVtURncQ
         DFrRxp8Qhzelu4llcCzSYAaujt8Ev064I3fODlqrPRE3tsJr1hwK0ExgziopBgFs7ene
         dGDg==
X-Gm-Message-State: AOAM5319bkWsTaPPA/AVpLhwJjCa3QKQso7pl5UFUyg+qBdypq2w+Kqc
        51Aq3zX6Gvj1BD8qq57bf9Y=
X-Google-Smtp-Source: ABdhPJyN70DofvK36my/JEa51Le1W77gGRolxr53HVM8X29rx2LLiZygscgs0COaIR0G2PUhK4LxUA==
X-Received: by 2002:a17:90b:384a:: with SMTP id nl10mr24345699pjb.234.1639144888831;
        Fri, 10 Dec 2021 06:01:28 -0800 (PST)
Received: from [10.10.156.113] ([167.220.233.113])
        by smtp.gmail.com with ESMTPSA id n71sm3733339pfd.50.2021.12.10.06.01.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Dec 2021 06:01:28 -0800 (PST)
Message-ID: <6baeb3c4-a493-80d1-439d-fa7dbe1a703a@gmail.com>
Date:   Fri, 10 Dec 2021 22:01:16 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH V6 3/5] hyper-v: Enable swiotlb bounce buffer for
 Isolation VM
Content-Language: en-US
From:   Tianyu Lan <ltykernel@gmail.com>
To:     "Michael Kelley (LINUX)" <mikelley@microsoft.com>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        Dexuan Cui <decui@microsoft.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "hch@infradead.org" <hch@infradead.org>,
        "m.szyprowski@samsung.com" <m.szyprowski@samsung.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        Tianyu Lan <Tianyu.Lan@microsoft.com>,
        "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>
Cc:     "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        vkuznets <vkuznets@redhat.com>,
        "brijesh.singh@amd.com" <brijesh.singh@amd.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "hch@lst.de" <hch@lst.de>, "joro@8bytes.org" <joro@8bytes.org>,
        "parri.andrea@gmail.com" <parri.andrea@gmail.com>,
        "dave.hansen@intel.com" <dave.hansen@intel.com>
References: <20211207075602.2452-1-ltykernel@gmail.com>
 <20211207075602.2452-4-ltykernel@gmail.com>
 <MWHPR21MB159359667085776793988EACD7709@MWHPR21MB1593.namprd21.prod.outlook.com>
 <4d60fcd1-97df-f4a1-1b79-643e65f66b3e@gmail.com>
In-Reply-To: <4d60fcd1-97df-f4a1-1b79-643e65f66b3e@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/10/2021 9:25 PM, Tianyu Lan wrote:
>>> @@ -319,8 +320,16 @@ static void __init ms_hyperv_init_platform(void)
>>>           pr_info("Hyper-V: Isolation Config: Group A 0x%x, Group B 
>>> 0x%x\n",
>>>               ms_hyperv.isolation_config_a, 
>>> ms_hyperv.isolation_config_b);
>>>
>>> -        if (hv_get_isolation_type() == HV_ISOLATION_TYPE_SNP)
>>> +        if (hv_get_isolation_type() == HV_ISOLATION_TYPE_SNP) {
>>>               static_branch_enable(&isolation_type_snp);
>>> +            swiotlb_unencrypted_base = ms_hyperv.shared_gpa_boundary;
>>> +        }
>>> +
>>> +        /*
>>> +         * Enable swiotlb force mode in Isolation VM to
>>> +         * use swiotlb bounce buffer for dma transaction.
>>> +         */
>>> +        swiotlb_force = SWIOTLB_FORCE;
>> I'm good with this approach that directly updates the swiotlb settings 
>> here
>>
>> rather than in IOMMU initialization code.  It's a lot more 
>> straightforward.
>>
>> However, there's an issue if building for X86_32 without PAE, in that the
>> swiotlb module may not be built, resulting in compile and link 
>> errors.  The
>> swiotlb.h file needs to be updated to provide a stub function for
>> swiotlb_update_mem_attributes().   swiotlb_unencrypted_base probably
>> needs wrapper functions to get/set it, which can be stubs when
>> CONFIG_SWIOTLB is not set.  swiotlb_force is a bit of a mess in that 
>> it already
>> has a stub definition that assumes it will only be read, and not set.  
>> A bit of
>> thinking will be needed to sort that out.
> 
> It's ok to fix the issue via selecting swiotlb when CONFIG_HYPERV is
> set?
> 
Sorry. ignore the previous statement. These codes doesn't depend on 
CONFIG_HYPERV.

How about making these code under #ifdef CONFIG_X86_64 or CONFIG_SWIOTLB?
