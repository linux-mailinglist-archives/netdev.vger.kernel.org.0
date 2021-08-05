Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6018B3E18BF
	for <lists+netdev@lfdr.de>; Thu,  5 Aug 2021 17:52:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242694AbhHEPwS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 11:52:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbhHEPwP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Aug 2021 11:52:15 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBF64C061765;
        Thu,  5 Aug 2021 08:52:00 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id ca5so9842992pjb.5;
        Thu, 05 Aug 2021 08:52:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=+WAVvy3jG8c4BM1UieKc0hBr5+TPYkK4USUWUu/waLs=;
        b=f9NRItGcA82zfK89pCSO+FmqIIS9do5TDWjGS2Phwk71Ji2CmZnf8PxAfzm2UDR9km
         lAgg56lZbpeu+K8iuYKOH1bUmUq+Y/w/ympLbW5zEuqcXD+Ru4sUL4cDWR8qGdqEidfP
         ziOfCCbUfhxx8uX8F2JJ2xPz5qHc78AmuoWiHkw+umEWamoItzUkWexCOBGuIR0ULKl+
         eOmE9bSQ4nk3xuDfmkfuO0ZE6gpw9xgYHGc/K8FFsdr9ojyhAkwggIRaPFhLl1LTpS6j
         IdRxy4GUR6A7AcO0BdasFcNqOb53Xf4LXDenQVsPE/VC2bZYgbJo499AOTpLdDoOb8Uh
         Zbqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+WAVvy3jG8c4BM1UieKc0hBr5+TPYkK4USUWUu/waLs=;
        b=NoeS6ZRxQ1QcJMIGRcj7d4+uvlDHdtilLojbYj+nf17zY89IjJdgbcp/zciueQjmGv
         JwYYyh9grmMiq1lURn/IqMs21AXfzLyHYkWp2DXi2KJ3+03QM7p57JXHSZPRZyqoQSSW
         idQWMxJtvlnAXPQDwJMFsdjea9Cq1SmNG0tLvdOtYp0VMG3DubMr10J5va+i/hDqvnml
         FiKNvDO5VSId4bs+nhiNYCFGmByGeXxfXP12Cf9KTpiSfJj0REmfb2RJtW29eb7yphh0
         GDYnzVwtjNz9EcYPBoHWSuT8Jhil341Mdg0w3VydmqDY/BjaouOkbS3qxwVmkhSiim7s
         iUIg==
X-Gm-Message-State: AOAM531iuRyfO625zkJSTzxGQUdV/t+QL39O8hCBCdlEN36+V7r+55VZ
        6bAan7oNqsnFJaW53NKQOU4=
X-Google-Smtp-Source: ABdhPJzLAimd4Y4p28t2bHcnYkc9F26SFPNdWJKKxX6QGrlC4uJA5cMAwBVxgkywklDtK+gtxm7ShA==
X-Received: by 2002:a62:d447:0:b029:291:19f7:ddcd with SMTP id u7-20020a62d4470000b029029119f7ddcdmr169701pfl.54.1628178720447;
        Thu, 05 Aug 2021 08:52:00 -0700 (PDT)
Received: from ?IPv6:2404:f801:0:5:8000::4b1? ([2404:f801:9000:1a:efea::4b1])
        by smtp.gmail.com with ESMTPSA id w11sm8659286pgk.34.2021.08.05.08.51.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Aug 2021 08:51:59 -0700 (PDT)
Subject: Re: [PATCH V2 03/14] x86/set_memory: Add x86_set_memory_enc static
 call support
To:     Dave Hansen <dave.hansen@intel.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        wei.liu@kernel.org, decui@microsoft.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, x86@kernel.org, hpa@zytor.com,
        dave.hansen@linux.intel.com, luto@kernel.org,
        konrad.wilk@oracle.com, boris.ostrovsky@oracle.com,
        jgross@suse.com, sstabellini@kernel.org, joro@8bytes.org,
        will@kernel.org, davem@davemloft.net, kuba@kernel.org,
        jejb@linux.ibm.com, martin.petersen@oracle.com, arnd@arndb.de,
        hch@lst.de, m.szyprowski@samsung.com, robin.murphy@arm.com,
        Tianyu.Lan@microsoft.com, rppt@kernel.org,
        kirill.shutemov@linux.intel.com, akpm@linux-foundation.org,
        brijesh.singh@amd.com, thomas.lendacky@amd.com, pgonda@google.com,
        david@redhat.com, krish.sadhukhan@oracle.com, saravanand@fb.com,
        aneesh.kumar@linux.ibm.com, xen-devel@lists.xenproject.org,
        martin.b.radev@gmail.com, ardb@kernel.org, rientjes@google.com,
        tj@kernel.org, keescook@chromium.org,
        michael.h.kelley@microsoft.com, iommu@lists.linux-foundation.org,
        linux-arch@vger.kernel.org, linux-hyperv@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        netdev@vger.kernel.org, vkuznets@redhat.com, parri.andrea@gmail.com
References: <20210804184513.512888-1-ltykernel@gmail.com>
 <20210804184513.512888-4-ltykernel@gmail.com>
 <5823af8a-7dbb-dbb0-5ea2-d9846aa2a36a@intel.com>
 <942e6fcb-3bdf-9294-d3db-ca311db440d3@gmail.com>
 <YQv0bRBUq1N5+jgG@hirez.programming.kicks-ass.net>
 <fa63e6ad-9536-d5e9-d754-fa04fad69252@intel.com>
From:   Tianyu Lan <ltykernel@gmail.com>
Message-ID: <01d2f33c-6e50-ae88-73ff-84042504c26e@gmail.com>
Date:   Thu, 5 Aug 2021 23:51:43 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <fa63e6ad-9536-d5e9-d754-fa04fad69252@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/5/2021 10:29 PM, Dave Hansen wrote:
> On 8/5/21 7:23 AM, Peter Zijlstra wrote:
>> This is assuming any of this is actually performance critical, based off
>> of this using static_call() to begin with.
> 
> This code is not performance critical.
> 
> I think I sent folks off on a wild goose chase when I asked that we make
> an effort to optimize code that does:
> 
> 	if (some_hyperv_check())
> 		foo();
> 
> 	if (some_amd_feature_check())
> 		bar();
> 
> with checks that will actually compile away when Hyper-V or
> some_amd_feature() is disabled.  That's less about performance and just
> about good hygiene.  I *wanted* to see
> cpu_feature_enabled(X86_FEATURE...) checks.
> 
> Someone suggested using static calls, and off we went...
> 
> Could we please just use cpu_feature_enabled()?
>

Yes, cpu_feature_enabled() works. The target is just to run platform 
code after platform check. I will update this in the next version.
