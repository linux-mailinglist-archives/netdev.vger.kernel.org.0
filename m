Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5342C46E76D
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 12:17:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236546AbhLILUv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 06:20:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235365AbhLILUu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Dec 2021 06:20:50 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92C13C061746;
        Thu,  9 Dec 2021 03:17:17 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id j5-20020a17090a318500b001a6c749e697so5918397pjb.1;
        Thu, 09 Dec 2021 03:17:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=7++LgR6CHSvNByLY82LW9yKqPrn0areIcNLzqPnbuDs=;
        b=devInOcspgU9jMzUkwQ4cW9HzrPs8Huk68CilnEkO0UWTbHyLicW6H5aVikM64Gmnx
         WFs4Sp2hpBcuLpVmLGIsvEPCFunl7OLPuW8wpVIoJMvHPR4Y45nM/4sWIbLncBsa3Tps
         UCW7DSv0OKimSsiFG+nqvvCNykGnbOPOTWRktixpuBhEC7IcYt5V7AbFgEQKYZS5V8Nk
         pmC3XjlowIpRQL3uAPUUJXhKBDet1SCbmvvKnsJTSDwAU9fnFWxmbNzL8p1bq1OEnEl8
         /bcYeIiCEkI8oSLGwK1p0KxtDFemGjK9t+BFw0jb/uD2AVAmRJLTnu/+fy92lNKJGZJF
         R1Mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=7++LgR6CHSvNByLY82LW9yKqPrn0areIcNLzqPnbuDs=;
        b=AEQSXzBXIEA6z5+mfgjnvnZyawK+2i5lQNFX97/1GjIpD127rOTLAZ8Z7BHEnE/LQh
         1OgSvmur5qtaGk7x7wNi+JT1W4vFmZfnlq/BU1A+L/BTeu9OT0I4RwAR0yHR2lM9HglY
         N6nmVNnyyLhMw5n5EGoN4Ww+LFSQeIjGgfiCgj/zgxGAk3yW6ASdgMPBEXKe59iZSKKi
         74QYIVpmI3aPv0+HyvyrCBx3QR81vh1O5De859Pd43EK1YPHnphY4t3vPFBqiP8YqpTY
         KsHLE2+Fbcgoni/qpKJznb6+bh5dkVRDs1d3GoSqsUScF+j4WEgsWWKiW6xPx9MGbj2M
         vIHA==
X-Gm-Message-State: AOAM5330A67IZdTlmpG1UUe05BEiS/3rPUAAe/7+DrMUITkXF+DX71o7
        PlIyA1lEhEPDcGKpIkvmVRY=
X-Google-Smtp-Source: ABdhPJw6mFG+w4KDhuIF/LkOsGARjWx+5UEh9URRd9WM7jkBUtu2M0tOhMtumtGVnqqsw5jUCAd09g==
X-Received: by 2002:a17:90b:3850:: with SMTP id nl16mr14999898pjb.10.1639048637182;
        Thu, 09 Dec 2021 03:17:17 -0800 (PST)
Received: from ?IPV6:2404:f801:0:5:8000::50b? ([2404:f801:9000:18:efec::50b])
        by smtp.gmail.com with ESMTPSA id d10sm6777113pfl.139.2021.12.09.03.17.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Dec 2021 03:17:16 -0800 (PST)
Message-ID: <ff4497cc-741a-113c-c6eb-dd5966716863@gmail.com>
Date:   Thu, 9 Dec 2021 19:17:08 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH V6 4/5] scsi: storvsc: Add Isolation VM support for
 storvsc driver
Content-Language: en-US
To:     Long Li <longli@microsoft.com>, KY Srinivasan <kys@microsoft.com>,
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
        "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
        "Michael Kelley (LINUX)" <mikelley@microsoft.com>
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
 <20211207075602.2452-5-ltykernel@gmail.com>
 <BY5PR21MB1506535EF9222ED4300C38BBCE709@BY5PR21MB1506.namprd21.prod.outlook.com>
From:   Tianyu Lan <ltykernel@gmail.com>
In-Reply-To: <BY5PR21MB1506535EF9222ED4300C38BBCE709@BY5PR21MB1506.namprd21.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/9/2021 4:00 PM, Long Li wrote:
>> @@ -1848,21 +1851,22 @@ static int storvsc_queuecommand(struct Scsi_Host
>> *host, struct scsi_cmnd *scmnd)
>>   		payload->range.len = length;
>>   		payload->range.offset = offset_in_hvpg;
>>
>> +		sg_count = scsi_dma_map(scmnd);
>> +		if (sg_count < 0)
>> +			return SCSI_MLQUEUE_DEVICE_BUSY;
> Hi Tianyu,
> 
> This patch (and this patch series) unconditionally adds code for dealing with DMA addresses for all VMs, including non-isolation VMs.
> 
> Does this add performance penalty for VMs that don't require isolation?
> 

Hi Long:
	scsi_dma_map() in the traditional VM just save sg->offset to
sg->dma_address and no data copy because swiotlb bounce buffer code
doesn't work. The data copy only takes place in the Isolation VM and
swiotlb_force is set. So there is no additional overhead in the 
traditional VM.

Thanks.
