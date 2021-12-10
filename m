Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B384247018F
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 14:25:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241679AbhLJN32 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 08:29:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230479AbhLJN31 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Dec 2021 08:29:27 -0500
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BEDAC061746;
        Fri, 10 Dec 2021 05:25:52 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id 8so8489707pfo.4;
        Fri, 10 Dec 2021 05:25:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=uqbMD53C4ItO9uYDsVUp6EzSCFXpBRENU7IWZcPSA4M=;
        b=DYNhmkDVXoEZft9BS7jFUM1vYYZ9YvKi4muEhJQLHJqiGbbJk0Iumlz2I6fT8+haze
         +MHAL/pcdD4GLXyqCU4Eprb2eJjd2mf5vjZ8DzEVupN2/zan52H0xynI+4aaWNtuVWQR
         u3FFiz7DqcRVKU3YNjfbYFUBd9ISYneZ0CFIwjjQz4wdmgu3nHHTvURDoHnr8+4N58O0
         +eACuj6LixZk6F8b3vkNTwo6yKMoV83F9BRq8aU/+w55tia+vJpE3bD21MEPY3j+2BaE
         9dLxiZxTDsTYe+1zqNUFCvJlKUuDFeGgSZNtGgd0+OHn+cZQKKeYxLE0Si0RPs0NHEOx
         16Kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=uqbMD53C4ItO9uYDsVUp6EzSCFXpBRENU7IWZcPSA4M=;
        b=dmc4mvED9DO2IiGQtPKxe9QzVvaXQIfLeMof9VkeuGyVFRFdjppS/s1aIt8mpkbPr8
         NKo67xR/iq9uLuIzmBhjw+e0rOVpstWsEot8jz7IFdz+++0phNgXtylpbxk/04wKWXnJ
         UKYnR5QbR9WC2JxMhsOk96nMj+VzafpIZWYYRebPNAvoZTCjPu9BgUNdFe+8F6kaEIuH
         8D+NkRqh7Ie5EQiAgRijSg4qpWAZioOKoeiYRatkFLxhrT4GXk14EVd+hsFZXW5cXsxD
         q86ktT2AICAQH8jeIAQdt4fv053tSo92nhVRSf2ljLB/BJrhGSHpq2DmwROTPQ+xHzpo
         nPZA==
X-Gm-Message-State: AOAM530IxhxH/i6HBlmdp4AR/pXelH+kAlVmt1QkYvSRdeRyKxC38SA/
        cn0p0UkBgogF4Ex3yVSersY=
X-Google-Smtp-Source: ABdhPJw/w6j8JzL1Fx/z+ArF/5BNciB/RRrnV3JnjQfO14coUZUSUS2ONAfIBFDYLQpvqjdNq3HtQA==
X-Received: by 2002:a62:1708:0:b0:4a7:e068:b121 with SMTP id 8-20020a621708000000b004a7e068b121mr17936120pfx.61.1639142752136;
        Fri, 10 Dec 2021 05:25:52 -0800 (PST)
Received: from [10.10.156.113] ([167.220.232.113])
        by smtp.gmail.com with ESMTPSA id c17sm1481858pfc.163.2021.12.10.05.25.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Dec 2021 05:25:51 -0800 (PST)
Message-ID: <4d60fcd1-97df-f4a1-1b79-643e65f66b3e@gmail.com>
Date:   Fri, 10 Dec 2021 21:25:40 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH V6 3/5] hyper-v: Enable swiotlb bounce buffer for
 Isolation VM
Content-Language: en-US
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
From:   Tianyu Lan <ltykernel@gmail.com>
In-Reply-To: <MWHPR21MB159359667085776793988EACD7709@MWHPR21MB1593.namprd21.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/10/2021 4:09 AM, Michael Kelley (LINUX) wrote:
>> @@ -319,8 +320,16 @@ static void __init ms_hyperv_init_platform(void)
>>   		pr_info("Hyper-V: Isolation Config: Group A 0x%x, Group B 0x%x\n",
>>   			ms_hyperv.isolation_config_a, ms_hyperv.isolation_config_b);
>>
>> -		if (hv_get_isolation_type() == HV_ISOLATION_TYPE_SNP)
>> +		if (hv_get_isolation_type() == HV_ISOLATION_TYPE_SNP) {
>>   			static_branch_enable(&isolation_type_snp);
>> +			swiotlb_unencrypted_base = ms_hyperv.shared_gpa_boundary;
>> +		}
>> +
>> +		/*
>> +		 * Enable swiotlb force mode in Isolation VM to
>> +		 * use swiotlb bounce buffer for dma transaction.
>> +		 */
>> +		swiotlb_force = SWIOTLB_FORCE;
> I'm good with this approach that directly updates the swiotlb settings here
> 
> rather than in IOMMU initialization code.  It's a lot more straightforward.
> 
> However, there's an issue if building for X86_32 without PAE, in that the
> swiotlb module may not be built, resulting in compile and link errors.  The
> swiotlb.h file needs to be updated to provide a stub function for
> swiotlb_update_mem_attributes().   swiotlb_unencrypted_base probably
> needs wrapper functions to get/set it, which can be stubs when
> CONFIG_SWIOTLB is not set.  swiotlb_force is a bit of a mess in that it already
> has a stub definition that assumes it will only be read, and not set.  A bit of
> thinking will be needed to sort that out.

It's ok to fix the issue via selecting swiotlb when CONFIG_HYPERV is
set?

> 
>>   	}
>>
>>   	if (hv_max_functions_eax >= HYPERV_CPUID_NESTED_FEATURES) {
>> diff --git a/include/linux/hyperv.h b/include/linux/hyperv.h
>> index b823311eac79..1f037e114dc8 100644
>> --- a/include/linux/hyperv.h
>> +++ b/include/linux/hyperv.h
>> @@ -1726,6 +1726,14 @@ int hyperv_write_cfg_blk(struct pci_dev *dev, void *buf, unsigned int len,
>>   int hyperv_reg_block_invalidate(struct pci_dev *dev, void *context,
>>   				void (*block_invalidate)(void *context,
>>   							 u64 block_mask));
>> +#if IS_ENABLED(CONFIG_HYPERV)
>> +int __init hyperv_swiotlb_detect(void);
>> +#else
>> +static inline int __init hyperv_swiotlb_detect(void)
>> +{
>> +	return 0;
>> +}
>> +#endif
> I don't think hyperv_swiotlb_detect() is used any longer, so this change
> should be dropped.
Yes, will update.
