Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2217E473C0B
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 05:37:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233951AbhLNEhJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Dec 2021 23:37:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231237AbhLNEhI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Dec 2021 23:37:08 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9985BC061574;
        Mon, 13 Dec 2021 20:37:07 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id u17so12696612plg.9;
        Mon, 13 Dec 2021 20:37:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:from:subject:to:cc
         :references:content-language:in-reply-to:content-transfer-encoding;
        bh=w4jF6pVlAr6sHba/AXtkTZyGmAkMDj6qQwAZlJ+UdLM=;
        b=OO8cW6CQyLhwtJRdZo64ynH6YeKqGhXzDwlR96DxhxE8Bz5kntawlo3U2eaGVD6CHI
         QwlLfqlppyoVymnRsSdhwAbcwoI1D7iwAn/eC7pS7Pj0K1VfQQPlhUUd5xy+WbCBAYDe
         CQOlcjQSfsQlxLiRuxOWyrkrVDXvfEueSrvOQHwoCOK3vTOpot3KDNKHU3PW7aUlZOQX
         MN7v7ONz+WWwWOXpsViMSrzGNo6sSDbOMGzJD6Qa0xvRGJgAgkSVClBY32rRHfyCo6A3
         FQ9HQBcHZRpZZlCrmfLicfdlKItAAolAJVEfIXHGJEJMbZjO/ZWcO9H4hEoGAYqHbkbf
         SDXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:from
         :subject:to:cc:references:content-language:in-reply-to
         :content-transfer-encoding;
        bh=w4jF6pVlAr6sHba/AXtkTZyGmAkMDj6qQwAZlJ+UdLM=;
        b=pbj4RHfLXR3vaJ3f+39BXabS7GGoegOvJW1Ap5kq13Pk6w6DnFiMxUpPDIRwrvsRsY
         5s+2RAukrCs8yQQWCUQZGp88R9cLYVsgS23iw1ZGIfIZdFDCU846ucL9wrZTHaeM9nQl
         0kboFqFGPME3m43Sfmv+plrPE/6ZITyuHk7jDf7YQZH13oJdkljxGQ5HGD0zvPnVWdUc
         DLvlsRR8xaFYxFtE5d7I5yg4Ltdx7vAB+fcVYRNGxVdAQafigf7CSRpoPnppNRkZnxe4
         Ddd1foBipd2FNWYB6sXlNxeGpFR/jA7xIrTq4SsLbpXhCMQ0w7WdAqYH5IBC2Rz+2lmD
         cLIw==
X-Gm-Message-State: AOAM532KccntHo/TuVgNVxULWDszCHcxYHIjZNVbhiTFg8EzeG9f6w9I
        b5vLw2rclTqpF2o0LeAcwMw=
X-Google-Smtp-Source: ABdhPJw8uDA1QXzEpygmuAAZVoXz6dprKQR+3bFuLs1n/mm4f5XuNE+IqFlivIE3110OJ/+FyvUzTA==
X-Received: by 2002:a17:90b:4b86:: with SMTP id lr6mr2944595pjb.98.1639456626921;
        Mon, 13 Dec 2021 20:37:06 -0800 (PST)
Received: from ?IPV6:2404:f801:0:5:8000::50b? ([2404:f801:9000:1a:efea::50b])
        by smtp.gmail.com with ESMTPSA id rm10sm812022pjb.29.2021.12.13.20.36.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Dec 2021 20:37:06 -0800 (PST)
Message-ID: <3243ff22-f6c8-b7cd-26b7-6e917e274a7c@gmail.com>
Date:   Tue, 14 Dec 2021 12:36:56 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
From:   Tianyu Lan <ltykernel@gmail.com>
Subject: Re: [PATCH V7 1/5] swiotlb: Add swiotlb bounce buffer remap function
 for HV IVM
To:     Dave Hansen <dave.hansen@intel.com>, kys@microsoft.com,
        haiyangz@microsoft.com, sthemmin@microsoft.com, wei.liu@kernel.org,
        decui@microsoft.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
        hpa@zytor.com, davem@davemloft.net, kuba@kernel.org,
        jejb@linux.ibm.com, martin.petersen@oracle.com, arnd@arndb.de,
        hch@infradead.org, m.szyprowski@samsung.com, robin.murphy@arm.com,
        thomas.lendacky@amd.com, Tianyu.Lan@microsoft.com,
        michael.h.kelley@microsoft.com
Cc:     iommu@lists.linux-foundation.org, linux-arch@vger.kernel.org,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, netdev@vger.kernel.org,
        vkuznets@redhat.com, brijesh.singh@amd.com, konrad.wilk@oracle.com,
        hch@lst.de, joro@8bytes.org, parri.andrea@gmail.com
References: <20211213071407.314309-1-ltykernel@gmail.com>
 <20211213071407.314309-2-ltykernel@gmail.com>
 <198e9243-abca-b23e-0e8e-8581a7329ede@intel.com>
Content-Language: en-US
In-Reply-To: <198e9243-abca-b23e-0e8e-8581a7329ede@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/14/2021 12:45 AM, Dave Hansen wrote:
> On 12/12/21 11:14 PM, Tianyu Lan wrote:
>> In Isolation VM with AMD SEV, bounce buffer needs to be accessed via
>> extra address space which is above shared_gpa_boundary (E.G 39 bit
>> address line) reported by Hyper-V CPUID ISOLATION_CONFIG. The access
>> physical address will be original physical address + shared_gpa_boundary.
>> The shared_gpa_boundary in the AMD SEV SNP spec is called virtual top of
>> memory(vTOM). Memory addresses below vTOM are automatically treated as
>> private while memory above vTOM is treated as shared.
> 
> This seems to be independently reintroducing some of the SEV
> infrastructure.  Is it really OK that this doesn't interact at all with
> any existing SEV code?
> 
> For instance, do we need a new 'swiotlb_unencrypted_base', or should
> this just be using sme_me_mask somehow?

Hi Dave:
        Thanks for your review. Hyper-V provides a para-virtualized
confidential computing solution based on the AMD SEV function and not
expose sev&sme capabilities to guest. So sme_me_mask is unset in the
Hyper-V Isolation VM. swiotlb_unencrypted_base is more general solution
to handle such case of different address space for encrypted and
decrypted memory and other platform also may reuse it.
