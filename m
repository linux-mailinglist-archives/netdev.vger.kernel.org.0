Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4842F3C1558
	for <lists+netdev@lfdr.de>; Thu,  8 Jul 2021 16:40:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232008AbhGHOnY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Jul 2021 10:43:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229738AbhGHOnX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Jul 2021 10:43:23 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEBC2C061574;
        Thu,  8 Jul 2021 07:40:40 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id v7so6189183pgl.2;
        Thu, 08 Jul 2021 07:40:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=YXjZj7OhvPZJaAtT6Qwq7/8ZjjZCmfNtMSr8qDj8MRU=;
        b=ayW8QQM2efuvpdH0iOtsj9sDatgzjNkhl4+y/ouwe04BZcpt7tSpZSztZE1HcOshdP
         QXaUNAf/1sngsBP+5ZL0dubNDykY4vKK6b9Wmf6V3NS5iLDuzZvWuWys1GP5fH3k/OTC
         tYDRBkngjXQYqPF3DQewzYEvp4aC50Y/xFZW27B7I7FoSeruMrEakyjTyq4nU9lq5OXG
         9pEOEVcjBjM/2JuAGoOCNl8yharry3mPga7LZqh8ptcnsE3cQjXBDpSs+J18TjrzoZin
         UJfMRAaQiH9cX09/xDZhBpWcjIM9jra7EdcFVO0s5QSQNR3e2+qLq6ocQLn3NXgEDy83
         /jFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=YXjZj7OhvPZJaAtT6Qwq7/8ZjjZCmfNtMSr8qDj8MRU=;
        b=KY3IZP+h3AWsRkeE4s9gY9cY43Evi421zJH5RBBFZBybGM7r4r8RUU1jYi8gHH97qL
         9vne1E7MW6n3DHCdSfm2jGVqmkMeIYeV4dGWoaoggmukovV/foWZpRpNJdtAL6eyHOZI
         kzttcE4fWJ95uKQmg9EnWJfGh1jhDu4zH7uVofyCxf5IakG9Xc9Iv144g9fxxx9NZYbb
         PG1hQYnB1OaB7RSk94f+JwKfqi/A2nSj4HSaMh6LRa96ymGs6sqDuJtWMs1zgy4GqY47
         MzCoNu7eenoovkmzzRAEO6XYW29fSmLU/TfKDJ1wsXm8aY8+wApJdd8/Bo4lorvvKxOL
         vkEw==
X-Gm-Message-State: AOAM530jAu/5I7cDPcuflCVWU5ES5W4xDO4+lKDBYYiCrOFQpq8w3uX8
        PjJy5MjpQSMUdLJnyD9x3n4=
X-Google-Smtp-Source: ABdhPJwsdOgUCGltloBXaOdJeRrQgvHkqG47NpBLcd9gNcAJ5PSk2V3aVVR6tD13omBoKJiA4S0mBQ==
X-Received: by 2002:aa7:818a:0:b029:309:a073:51cb with SMTP id g10-20020aa7818a0000b0290309a07351cbmr31830476pfi.40.1625755240540;
        Thu, 08 Jul 2021 07:40:40 -0700 (PDT)
Received: from ?IPv6:2404:f801:0:5:8000::4b1? ([2404:f801:9000:18:efec::4b1])
        by smtp.gmail.com with ESMTPSA id h20sm3216729pfn.173.2021.07.08.07.40.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Jul 2021 07:40:39 -0700 (PDT)
Subject: Re: [RFC PATCH V4 01/12] x86/HV: Initialize shared memory boundary in
 the Isolation VM.
To:     Olaf Hering <olaf@aepfle.de>
Cc:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        wei.liu@kernel.org, decui@microsoft.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, x86@kernel.org, hpa@zytor.com,
        dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
        konrad.wilk@oracle.com, boris.ostrovsky@oracle.com,
        jgross@suse.com, sstabellini@kernel.org, joro@8bytes.org,
        will@kernel.org, davem@davemloft.net, kuba@kernel.org,
        jejb@linux.ibm.com, martin.petersen@oracle.com, arnd@arndb.de,
        hch@lst.de, m.szyprowski@samsung.com, robin.murphy@arm.com,
        rppt@kernel.org, akpm@linux-foundation.org,
        kirill.shutemov@linux.intel.com, Tianyu.Lan@microsoft.com,
        thomas.lendacky@amd.com, ardb@kernel.org,
        nramas@linux.microsoft.com, robh@kernel.org, keescook@chromium.org,
        rientjes@google.com, pgonda@google.com, martin.b.radev@gmail.com,
        hannes@cmpxchg.org, saravanand@fb.com, krish.sadhukhan@oracle.com,
        xen-devel@lists.xenproject.org, tj@kernel.org,
        michael.h.kelley@microsoft.com, iommu@lists.linux-foundation.org,
        linux-arch@vger.kernel.org, linux-hyperv@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        netdev@vger.kernel.org, vkuznets@redhat.com, brijesh.singh@amd.com,
        anparri@microsoft.com
References: <20210707153456.3976348-1-ltykernel@gmail.com>
 <20210707153456.3976348-2-ltykernel@gmail.com>
 <20210708073400.GA28528@aepfle.de>
From:   Tianyu Lan <ltykernel@gmail.com>
Message-ID: <9b5d6843-67c5-066e-0997-995ec77e06b2@gmail.com>
Date:   Thu, 8 Jul 2021 22:40:24 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210708073400.GA28528@aepfle.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Olaf:

On 7/8/2021 3:34 PM, Olaf Hering wrote:
> On Wed, Jul 07, Tianyu Lan wrote:
> 
>> +++ b/include/asm-generic/mshyperv.h
>> @@ -34,8 +34,18 @@ struct ms_hyperv_info {
> 
>>   	void  __percpu **ghcb_base;
> 
> It would be cool if the cover letter states which commit id this series is based on.

Thanks for your reminder. I will add this in the later version.
This patchset is rebased on Hyper-V next branch with Swiotlb 
“Restricted DMA“ patches from Claire Chang <tientzu@chromium.org>
 
https://lore.kernel.org/lkml/20210624155526.2775863-1-tientzu@chromium.org/
