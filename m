Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0BF340DBE7
	for <lists+netdev@lfdr.de>; Thu, 16 Sep 2021 15:56:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235959AbhIPN5r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Sep 2021 09:57:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232753AbhIPN5q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Sep 2021 09:57:46 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B1FDC061574;
        Thu, 16 Sep 2021 06:56:26 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id w19so5901448pfn.12;
        Thu, 16 Sep 2021 06:56:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=VQdB0cmtRyC2OUQYF1nmKrbKRoOhkmjS2WdWxiwvfV0=;
        b=CIfTuZFoNILRqkZ8DcW/GNbMyGgDnxBr4dVf4uWbZjU8pjj4lrHMRtQVPwcdxklAuQ
         JZziDYokWmjzVIErChST09t12g0u5Q0uRpqfgz1HLLBW1rjGMPZLz0kZ+aU/1VtdGCBf
         ScvmIZdC/KAH9/s5zwFCH/t+wJJgREk4jkxOEav0yNRvD2PeR9Mt0gXD43CEjS0rWa6X
         1ojan6I2m/RB70FhK0zBN0wx5wwjfaYXFG9iPhqmYChnfbWqL1/mqLAFucMtI4L4kMUT
         mDpT/XbuXdWRn1Ki+KD46f09IzCVvENPhyPuOqItQNeOtC2mXKgNu7d+59tp7LLGPGIj
         mQdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=VQdB0cmtRyC2OUQYF1nmKrbKRoOhkmjS2WdWxiwvfV0=;
        b=mm5Jcb5NdRlsCB9HoB33b4242Pg9E5CzZMYcqy6K7oYa1DJeI1IqXGA1ZRf3M2SJWa
         6oHTB0ocx6YfeIWNuFcQVDioCgkAqjUQMewqv4qc3xpGmfWKT+10DcSYH47a4wmkYHPc
         5sw0qGPXEFV6z/6kyNzgUVfRVpGVaIcFTT+tiKL0/MsGJBDbiSQt3iQMPfuEnDsVe64J
         2cuBNc9YBqpaIAI22nbL/F1ETrDe/bbYuHnM91EyG3UAvWTvdDqXOaZXRbz2ZfT1kq0X
         FgXANfhbGNlMIpLEYUd+PNoCgO3uWG5ePZzY4DwBMyZDfO5W8N+sME3oPaecytu6AWGJ
         njhw==
X-Gm-Message-State: AOAM530j0P7VuTmTbz2RCtNDAOYAJvlhMlraO19PDO9J1oFDfi4NC9a6
        1FvNBhBWL8uADKHh/CgNKKY=
X-Google-Smtp-Source: ABdhPJwil566vQyG+FPIeqOpCAnK+VdYspH+w8JoanT8EwRLxY95XCPpJH9ls0yqVjdetF6RlrGZEg==
X-Received: by 2002:a65:44c4:: with SMTP id g4mr5187939pgs.254.1631800585774;
        Thu, 16 Sep 2021 06:56:25 -0700 (PDT)
Received: from ?IPv6:2404:f801:0:5:8000::50b? ([2404:f801:9000:18:efec::50b])
        by smtp.gmail.com with ESMTPSA id w11sm3376724pfj.65.2021.09.16.06.56.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Sep 2021 06:56:25 -0700 (PDT)
Subject: Re: [PATCH V5 12/12] net: netvsc: Add Isolation VM support for netvsc
 driver
To:     Haiyang Zhang <haiyangz@microsoft.com>,
        Michael Kelley <mikelley@microsoft.com>,
        KY Srinivasan <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        Dexuan Cui <decui@microsoft.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, "x86@kernel.org" <x86@kernel.org>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "luto@kernel.org" <luto@kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "boris.ostrovsky@oracle.com" <boris.ostrovsky@oracle.com>,
        "jgross@suse.com" <jgross@suse.com>,
        "sstabellini@kernel.org" <sstabellini@kernel.org>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "will@kernel.org" <will@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "arnd@arndb.de" <arnd@arndb.de>, "hch@lst.de" <hch@lst.de>,
        "m.szyprowski@samsung.com" <m.szyprowski@samsung.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "brijesh.singh@amd.com" <brijesh.singh@amd.com>,
        Tianyu Lan <Tianyu.Lan@microsoft.com>,
        "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
        "pgonda@google.com" <pgonda@google.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "rppt@kernel.org" <rppt@kernel.org>,
        "sfr@canb.auug.org.au" <sfr@canb.auug.org.au>,
        "aneesh.kumar@linux.ibm.com" <aneesh.kumar@linux.ibm.com>,
        "saravanand@fb.com" <saravanand@fb.com>,
        "krish.sadhukhan@oracle.com" <krish.sadhukhan@oracle.com>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
        "tj@kernel.org" <tj@kernel.org>,
        "rientjes@google.com" <rientjes@google.com>
Cc:     "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        vkuznets <vkuznets@redhat.com>,
        "parri.andrea@gmail.com" <parri.andrea@gmail.com>,
        "dave.hansen@intel.com" <dave.hansen@intel.com>
References: <20210914133916.1440931-1-ltykernel@gmail.com>
 <20210914133916.1440931-13-ltykernel@gmail.com>
 <MWHPR21MB15939A5D74CA1DF25EE816ADD7DB9@MWHPR21MB1593.namprd21.prod.outlook.com>
 <MN2PR21MB12959F10240EC1BB2270B345CADB9@MN2PR21MB1295.namprd21.prod.outlook.com>
From:   Tianyu Lan <ltykernel@gmail.com>
Message-ID: <31da994f-a032-dd40-a90e-bfdaf313d45d@gmail.com>
Date:   Thu, 16 Sep 2021 21:56:11 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <MN2PR21MB12959F10240EC1BB2270B345CADB9@MN2PR21MB1295.namprd21.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/16/2021 12:46 AM, Haiyang Zhang wrote:
>>> +				memset(vmap_pages, 0,
>>> +				       sizeof(*vmap_pages) * vmap_page_index);
>>> +				vmap_page_index = 0;
>>> +
>>> +				for (j = 0; j < i; j++)
>>> +					__free_pages(pages[j], alloc_unit);
>>> +
>>> +				kfree(pages);
>>> +				alloc_unit = 1;
>> This is the case where a large enough contiguous physical memory chunk
>> could not be found.  But rather than dropping all the way down to single
>> pages, would it make sense to try something smaller, but not 1?  For
>> example, cut the alloc_unit in half and try again.  But I'm not sure of
>> all the implications.
> I had the same question. But probably gradually decrementing uses too much
> time?
> 

This version is to propose the solution. We may optimize this to try
smaller size until to single page if this is right direction.


