Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AB9C45471B
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 14:23:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237505AbhKQNZj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 08:25:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232163AbhKQNZj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Nov 2021 08:25:39 -0500
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4810C061570;
        Wed, 17 Nov 2021 05:22:40 -0800 (PST)
Received: by mail-pg1-x534.google.com with SMTP id 28so2232919pgq.8;
        Wed, 17 Nov 2021 05:22:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=n7Jf+5/Jh7KOEFSs12H1gnleHX5Ul1EJihf5cWALbbw=;
        b=NMtrHwlhumZZGG7ACQ5UZwJN7rtTqhVOALh7ylXTR9G6Y8zmsKtbGjwSxvzwVD314V
         mFlCILMpoJPcOxUNV38QoEdCs8zz43HlJK1GNiNc4P2QVifmYL23tPn/GqSDrxCGPg16
         bvAIjKJA0lzwI5sAj/KKF7Bc8fhHe/9Wx28bmwIGJrkCjDmdcCDuD5dw7cCpuvtFoqub
         iSkzJKRMidoqCXXQSY0sUPKp3Cs63451CNuN8JlBUt7M7BBJqI/PFOoctzgC3YAkmPjZ
         yOWSQXVn3LZwrWkLZBlx3QxZWWBmdX22onr58Glga9JdD2AAQeBuO5o77eDt6FelUOw8
         iVxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=n7Jf+5/Jh7KOEFSs12H1gnleHX5Ul1EJihf5cWALbbw=;
        b=b9UyN0TiiyTrrUM5mEVW0SLXg+DC3fOTfUw4UTOuK/YxkehoAr9f6NSymOWOyBqOCw
         ZP/wzZEt0UizfGSypZaR5lD2XT/ZI19sJx/zX0Pda6CY93KZL5jSyTngq6TDoDmcN0o6
         Gw8qnnpoZl7W8FvZ3XCnIV31/N5IrQE0M0sA4N5VomOGcZTXqA9xoXB4UQBUGcns37h9
         vM1R+zFAj3tR1DSoo821Zfw1D/HCw/3y4+fscstgFsiT1pC1M0UcwdOFhrdjVqk/MbZS
         8OG8xhSOFBDVTaeMzO/7Fr6GBa8W8b5DpsyjzOl5UrjyXCQ9J6XDWaqGDQNYOWqpM+XC
         Lv/g==
X-Gm-Message-State: AOAM532Kmw5b5iLYFPgryVggLtRMLp0ZCft1Kg2ILRAx9cHtwmA4swM8
        Hlj8fOcvkwa1WS7nEfL5Vy0=
X-Google-Smtp-Source: ABdhPJwYIet5fq/8KowjGXs7GPhnQ/zbG+7NtQHLznln3NXsAVsDB6ZMleQEQVqBwkPH6jdcXK5meg==
X-Received: by 2002:a05:6a00:2146:b0:44c:2922:8abf with SMTP id o6-20020a056a00214600b0044c29228abfmr48946221pfk.27.1637155360284;
        Wed, 17 Nov 2021 05:22:40 -0800 (PST)
Received: from ?IPV6:2404:f801:0:5:8000::50b? ([2404:f801:9000:18:efec::50b])
        by smtp.gmail.com with ESMTPSA id t40sm23310231pfg.107.2021.11.17.05.22.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Nov 2021 05:22:39 -0800 (PST)
Message-ID: <fb9809f5-a830-733e-745b-aa1b1d2671f5@gmail.com>
Date:   Wed, 17 Nov 2021 21:22:27 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.1
Subject: Re: [PATCH 3/5] hyperv/IOMMU: Enable swiotlb bounce buffer for
 Isolation VM
Content-Language: en-US
To:     Borislav Petkov <bp@alien8.de>
Cc:     dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
        tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        hpa@zytor.com, jgross@suse.com, sstabellini@kernel.org,
        boris.ostrovsky@oracle.com, kys@microsoft.com,
        haiyangz@microsoft.com, sthemmin@microsoft.com, wei.liu@kernel.org,
        decui@microsoft.com, joro@8bytes.org, will@kernel.org,
        davem@davemloft.net, kuba@kernel.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, hch@lst.de, m.szyprowski@samsung.com,
        robin.murphy@arm.com, xen-devel@lists.xenproject.org,
        michael.h.kelley@microsoft.com,
        Tianyu Lan <Tianyu.Lan@microsoft.com>,
        iommu@lists.linux-foundation.org, linux-hyperv@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        netdev@vger.kernel.org, vkuznets@redhat.com, brijesh.singh@amd.com,
        konrad.wilk@oracle.com, parri.andrea@gmail.com,
        thomas.lendacky@amd.com, dave.hansen@intel.com
References: <20211116153923.196763-1-ltykernel@gmail.com>
 <20211116153923.196763-4-ltykernel@gmail.com> <YZQCp6WWKAdOCbh8@zn.tnic>
From:   Tianyu Lan <ltykernel@gmail.com>
In-Reply-To: <YZQCp6WWKAdOCbh8@zn.tnic>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/17/2021 3:12 AM, Borislav Petkov wrote:
> What you should do, instead, is add an isol. VM specific
> hv_cc_platform_has() just like amd_cc_platform_has() and handle
> the cc_attrs there for your platform, like return false for
> CC_ATTR_GUEST_MEM_ENCRYPT and then you won't need to add that hv_* thing
> everywhere.
> 
> And then fix it up in __set_memory_enc_dec() too.
>

Yes, agree. Will add hv cc_attrs and check via cc_platform_has().


