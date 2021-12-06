Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3F92469871
	for <lists+netdev@lfdr.de>; Mon,  6 Dec 2021 15:17:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343800AbhLFOUe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 09:20:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238792AbhLFOUe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 09:20:34 -0500
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AC77C061746;
        Mon,  6 Dec 2021 06:17:05 -0800 (PST)
Received: by mail-pg1-x535.google.com with SMTP id r138so10541123pgr.13;
        Mon, 06 Dec 2021 06:17:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=MlPjTzqAzGMiJV1XIvo3CWuIKKPvCgUAVf8fFzgqOVA=;
        b=aUNHCl+dyTHAibi55HobGp+ZEySdQG08OEI+Y5k9nKK1X7xf+qtKsmguZgkbi+whPm
         GdJx9SeuhwP2ruODw9GfMgbHlzGk1gA6u4kF0GNnRTEbqTtzWhv5aQOvFkSisqrp80Je
         AuiZLyvBxRbWVKNJfUOgUEgQe+/ruz2KLZzOD08be7j/r8WHZNcwGCfhgny3RP1zHKHA
         1KDnGlCjbWtR+gN0SkVDdYDBRV83mT0qrFufECTGnYo50zNSja6vhsEoHMcB7bAvEpfm
         2tJ0a1+Qw3wjhe2hKKQCf2+fKGAqtRWFQXDtWW6xNYHAMZ+JXZUxTRR80tunhwvY2yh9
         HWsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=MlPjTzqAzGMiJV1XIvo3CWuIKKPvCgUAVf8fFzgqOVA=;
        b=2znyan+jpEFYyoLNcPgxbulTffLdYwPTvIfrz9wNz+QybX76q12eZUwfb1SbTnhkjD
         105E4VkCMl5wIylbspviWr8Z2DCel4drey9Kq2b+2d9SUsUHhNxm7KPxNPztMspQW5Eu
         DoXBPWf5CbjqmlhbkE32lm2D7N1dLBHKKilqh502U05OWMOnyGdGqS7nnMnXYpCOcL25
         9RerDZTGXA/DdxeoFvowne2DJeAZ75xnW43ddORAUsIG+ifwk1QXaLAKrvG5n/HTSJLA
         Gmy/tEN8dArpTjBmdArqMQisIhckWy9DwUP99c4YiD4oFTcuHdAuHLtBuaaJIBICRlg+
         ViBA==
X-Gm-Message-State: AOAM533lcqDMwCVGOohyxlRHQ9/u7UWRgNEkg6r2OwtJeoCYGTHaiIHE
        a/8jU6lDdtsJvdiiMi+q708=
X-Google-Smtp-Source: ABdhPJwC0KD/zVGir6spSXosBbRFLHsih0Tulm1FqYapzoO5PMARObP84mGb9GeA31fKmf/7FDoFjA==
X-Received: by 2002:a62:1cc4:0:b0:49f:99b6:3507 with SMTP id c187-20020a621cc4000000b0049f99b63507mr37506196pfc.76.1638800225207;
        Mon, 06 Dec 2021 06:17:05 -0800 (PST)
Received: from ?IPV6:2404:f801:0:5:8000::50b? ([2404:f801:9000:18:efec::50b])
        by smtp.gmail.com with ESMTPSA id d6sm10030597pgv.48.2021.12.06.06.16.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Dec 2021 06:17:04 -0800 (PST)
Message-ID: <ed333f81-0527-ae98-6348-a2bf6e783dae@gmail.com>
Date:   Mon, 6 Dec 2021 22:16:51 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [PATCH V4 1/5] Swiotlb: Add Swiotlb bounce buffer remap function
 for HV IVM
Content-Language: en-US
To:     Christoph Hellwig <hch@lst.de>
Cc:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        wei.liu@kernel.org, decui@microsoft.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, jgross@suse.com,
        sstabellini@kernel.org, boris.ostrovsky@oracle.com,
        joro@8bytes.org, will@kernel.org, davem@davemloft.net,
        kuba@kernel.org, jejb@linux.ibm.com, martin.petersen@oracle.com,
        arnd@arndb.de, hch@infradead.org, m.szyprowski@samsung.com,
        robin.murphy@arm.com, thomas.lendacky@amd.com,
        Tianyu.Lan@microsoft.com, xen-devel@lists.xenproject.org,
        michael.h.kelley@microsoft.com, iommu@lists.linux-foundation.org,
        linux-arch@vger.kernel.org, linux-hyperv@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        netdev@vger.kernel.org, vkuznets@redhat.com, brijesh.singh@amd.com,
        konrad.wilk@oracle.com, parri.andrea@gmail.com,
        dave.hansen@intel.com
References: <20211205081815.129276-1-ltykernel@gmail.com>
 <20211205081815.129276-2-ltykernel@gmail.com> <20211206140916.GB5100@lst.de>
From:   Tianyu Lan <ltykernel@gmail.com>
In-Reply-To: <20211206140916.GB5100@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/6/2021 10:09 PM, Christoph Hellwig wrote:
> Please spell swiotlb with a lower case s.  Otherwise this look good
> 
> Acked-by: Christoph Hellwig <hch@lst.de>
> 
> Feel free to carry this in whatever tree is suitable for the rest of the
> patches.
> 

Sure. Thanks for your ack and will update "swiotlb" in the next version.

