Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AB8D3EEF3B
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 17:36:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237716AbhHQPhN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 11:37:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231893AbhHQPhL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Aug 2021 11:37:11 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B0F4C061764;
        Tue, 17 Aug 2021 08:36:38 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id oa17so32662515pjb.1;
        Tue, 17 Aug 2021 08:36:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=jBb72hVOoT632QaKCIWdx6/CC01Jwh36ZqbBo7qR29w=;
        b=MZ87ScQaeTXUx2zc3QJX8paFfZdkSVdSMUYc0v0LY2+hc8AhlF3aqwldmB/BXXfh/z
         xVUkX3EuT93f+Ekid/9wOV8vd4VGMuUzHWRKeiBzsSym+hW8V3hELzVo+u+KhQB9PaFI
         yKaN6w7ws4iHi95okxDvcvyCJdiEqWiExOJPn7Rtxomj/p9ErurP79QsKnpF40UWedHY
         wXhiv+BXDH0p6Ybpa+matnVITHtpuG4LstcJLEA+MFTvG9pqsO1LvATqA0RHijA20GDK
         RCmlz/5mC+apSlI/jvD+4R9BoBCU6SvqrbqxGY696R6zje19Bg6nqx+tPpa86481eswl
         CE+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jBb72hVOoT632QaKCIWdx6/CC01Jwh36ZqbBo7qR29w=;
        b=DoKahIvjPv5ERb/sjGq5RyfrvGPaR61WnTwe+BKIzIP7CwBfpmkHKiYD2FyiqSjcHe
         5LwVegZbsxOVUPKJ5PH/zF6ZH6HqwdkhApKAszY2nDrN7zebfhGfSrs3BJw95i45c3xp
         6WTBv1jw7IbiGRWhuIbWxkJdBDrymO2fMyqlK1MFuBDLjxySPnqKBMUT5/dklKUtx9TZ
         vbStajETAWrG0+9+7QXsNGlWuMIfNmPBTB5ZKqJsabJd7XpHMe985tp6NWBsnMh7NWmV
         g5mPxWHm4aBoLIrADSzi2ifSmxmak32+7rdkCe2kx/JKPIMy7Y4AtZ1yWHnNsHdg9jTV
         QrWw==
X-Gm-Message-State: AOAM531g9bNl4Ihuzhsr5pklrb3WVQ+aL+enk7AF2qjRW6K5UOkj7q9W
        36rehwhwJyPr0nOLCeKMboM=
X-Google-Smtp-Source: ABdhPJyI43P3qYYJRg0q+cd32Cif7a9Xl5o4vVONB3bqiCMyd2bKoq7nZrIha1ZM+VxRpd1t2YLiqw==
X-Received: by 2002:a17:903:31c3:b029:ed:6f74:49c7 with SMTP id v3-20020a17090331c3b02900ed6f7449c7mr3321877ple.12.1629214598127;
        Tue, 17 Aug 2021 08:36:38 -0700 (PDT)
Received: from ?IPv6:2404:f801:0:5:8000::50b? ([2404:f801:9000:18:efec::50b])
        by smtp.gmail.com with ESMTPSA id q68sm3828407pgq.5.2021.08.17.08.36.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Aug 2021 08:36:37 -0700 (PDT)
Subject: Re: [PATCH V3 08/13] HV/Vmbus: Initialize VMbus ring buffer for
 Isolation VM
To:     Michael Kelley <mikelley@microsoft.com>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
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
        "arnd@arndb.de" <arnd@arndb.de>, "hch@lst.de" <hch@lst.de>,
        "m.szyprowski@samsung.com" <m.szyprowski@samsung.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
        "brijesh.singh@amd.com" <brijesh.singh@amd.com>,
        "ardb@kernel.org" <ardb@kernel.org>,
        Tianyu Lan <Tianyu.Lan@microsoft.com>,
        "pgonda@google.com" <pgonda@google.com>,
        "martin.b.radev@gmail.com" <martin.b.radev@gmail.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "rppt@kernel.org" <rppt@kernel.org>,
        "sfr@canb.auug.org.au" <sfr@canb.auug.org.au>,
        "saravanand@fb.com" <saravanand@fb.com>,
        "krish.sadhukhan@oracle.com" <krish.sadhukhan@oracle.com>,
        "aneesh.kumar@linux.ibm.com" <aneesh.kumar@linux.ibm.com>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
        "rientjes@google.com" <rientjes@google.com>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
        "tj@kernel.org" <tj@kernel.org>
Cc:     "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        vkuznets <vkuznets@redhat.com>,
        "parri.andrea@gmail.com" <parri.andrea@gmail.com>,
        "dave.hansen@intel.com" <dave.hansen@intel.com>
References: <20210809175620.720923-1-ltykernel@gmail.com>
 <20210809175620.720923-9-ltykernel@gmail.com>
 <MWHPR21MB1593FFD7F3402753751F433CD7FD9@MWHPR21MB1593.namprd21.prod.outlook.com>
From:   Tianyu Lan <ltykernel@gmail.com>
Message-ID: <9de7c3ae-8f3f-3fc4-0491-b9df24f03cb6@gmail.com>
Date:   Tue, 17 Aug 2021 23:36:22 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <MWHPR21MB1593FFD7F3402753751F433CD7FD9@MWHPR21MB1593.namprd21.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/17/2021 1:28 AM, Michael Kelley wrote:
> This patch does the following:
> 
> 1) The existing ring buffer wrap-around mapping functionality is still
> executed in hv_ringbuffer_init() when not doing SNP isolation.
> This mapping is based on an array of struct page's that describe the
> contiguous physical memory.
> 
> 2) New ring buffer wrap-around mapping functionality is added in
> hv_ringbuffer_post_init() for the SNP isolation case.  The case is
> handled in hv_ringbuffer_post_init() because it must be done after
> the GPADL is established, since that's where the host visibility
> is set.  What's interesting is that this case is exactly the same
> as #1 above, except that the mapping is based on physical
> memory addresses instead of struct page's.  We have to use physical
> addresses because of applying the GPA boundary, and there are no
> struct page's for those physical addresses.
> 
> Unfortunately, this duplicates a lot of logic in #1 and #2, except
> for the struct page vs. physical address difference.
> 
> Proposal:  Couldn't we always do #2, even for the normal case
> where SNP isolation is not being used?   The difference would
> only be in whether the GPA boundary is added.  And it looks like
> the normal case could be done after the GPADL is established,
> as setting up the GPADL doesn't have any dependencies on
> having the ring buffer mapped.  This approach would remove
> a lot of duplication.  Just move the calls to hv_ringbuffer_init()
> to after the GPADL is established, and do all the work there for
> both cases.
> 

Hi Michael:
     Thanks for suggestion. I just keep the original logic in current
code. I will try combining these two functions and report back.

Thanks.
