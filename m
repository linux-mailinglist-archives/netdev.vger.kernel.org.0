Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 615E6454802
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 15:02:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238111AbhKQODr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 09:03:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238064AbhKQODS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Nov 2021 09:03:18 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FA79C061200;
        Wed, 17 Nov 2021 06:00:20 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id z6so1054833plk.6;
        Wed, 17 Nov 2021 06:00:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=pfKT7vWJtxV2smk9CnW5qMlXjmk0IHKeJrqLf4YFRis=;
        b=Rjj9c6AtN53lwjrZL6EQMTK4S9B6EyjLDiTKAEZtG92IG/z5eW4MmmZjuNMEaPPtjf
         LSOJT/vIwEcxXU1K7Ca+hnK+LznG3PkqsB9P36idDXcWR6yBZ0TKu/gYYNIynsfa6uwl
         wwXh4cR3P9Fphh3Ru4IOABiaCcVVd3dR/Z+YDRN5tiFV3q6iF+hOXqmMcg2FfSxJRFzw
         2zMMFPxbuq+GlPyeaD3MgQIipxxSO7TRApycEHsiuMj7dn5MGNWFoo8smcQRSoTJRhJs
         ZsXAJgdRa8E0sMFr5/frJselNGMJAjuNu9fCWyvPs//KwOW3T6zPAQdpgf+k/6JRtRmA
         Pl4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=pfKT7vWJtxV2smk9CnW5qMlXjmk0IHKeJrqLf4YFRis=;
        b=mS0jdIgZd7Q97Xdsz6TQfVm3/aXPIGbDgzFcled1XA+BjO6qacWEoy41rewMbLMR8l
         mjurSH+8T5Zhrpi1VtaUBD9xy2KKPcxi6KEMbZ/7WkKzpv0plVXgDyitV6RZDZEfBi/A
         UnLhj8PoqzXqDBtz/4NHnwKFqqDt9KsUNI98ekZ4Xt3RtZ6ld45scBFniinAiyG4x1wc
         TsrkJF2xrJ0P3GTzpoA1SkFO3gqjtYJwFI64c7aIwcmi2KQFDbg1mxkX1NCK1vmyfhCo
         c/3PUC+FQ99g0PglttpNKYw2EC98d68BBwn0RJfvQSFM/3hzBS1kwbM/mLi6jaNHxOXj
         JEAg==
X-Gm-Message-State: AOAM533eB/7pHX0GKB/sBPfJEbSwBgCBsndz9UUmRcRp5wbfyDqz7R5z
        4ZIBrOhbgCyCiLVLNswmUoc=
X-Google-Smtp-Source: ABdhPJz045G1qOXv6u71zRNaxnc6W77FjMF/vz0ksg1+BccDMfhcBoN3nBp5JPhXQCiAcID15bfAZg==
X-Received: by 2002:a17:903:32c2:b0:141:eed4:ec1c with SMTP id i2-20020a17090332c200b00141eed4ec1cmr56123455plr.33.1637157619685;
        Wed, 17 Nov 2021 06:00:19 -0800 (PST)
Received: from ?IPV6:2404:f801:0:5:8000::50b? ([2404:f801:9000:18:efec::50b])
        by smtp.gmail.com with ESMTPSA id 95sm5490056pjo.2.2021.11.17.06.00.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Nov 2021 06:00:19 -0800 (PST)
Message-ID: <c93bf3d4-75c1-bc3d-2789-1d65e7c19158@gmail.com>
Date:   Wed, 17 Nov 2021 22:00:08 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.1
Subject: Re: [PATCH 3/5] hyperv/IOMMU: Enable swiotlb bounce buffer for
 Isolation VM
Content-Language: en-US
To:     Christoph Hellwig <hch@lst.de>
Cc:     dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, x86@kernel.org,
        hpa@zytor.com, jgross@suse.com, sstabellini@kernel.org,
        boris.ostrovsky@oracle.com, kys@microsoft.com,
        haiyangz@microsoft.com, sthemmin@microsoft.com, wei.liu@kernel.org,
        decui@microsoft.com, joro@8bytes.org, will@kernel.org,
        davem@davemloft.net, kuba@kernel.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, m.szyprowski@samsung.com,
        robin.murphy@arm.com, xen-devel@lists.xenproject.org,
        michael.h.kelley@microsoft.com,
        Tianyu Lan <Tianyu.Lan@microsoft.com>,
        iommu@lists.linux-foundation.org, linux-hyperv@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        netdev@vger.kernel.org, vkuznets@redhat.com, brijesh.singh@amd.com,
        konrad.wilk@oracle.com, parri.andrea@gmail.com,
        thomas.lendacky@amd.com, dave.hansen@intel.com
References: <20211116153923.196763-1-ltykernel@gmail.com>
 <20211116153923.196763-4-ltykernel@gmail.com> <20211117100142.GB10330@lst.de>
From:   Tianyu Lan <ltykernel@gmail.com>
In-Reply-To: <20211117100142.GB10330@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/17/2021 6:01 PM, Christoph Hellwig wrote:
> This doesn't really have much to do with normal DMA mapping,
> so why does this direct through the dma ops?
> 

According to the previous discussion, dma_alloc_noncontigous()
and dma_vmap_noncontiguous() may be used to handle the noncontigous
memory alloc/map in the netvsc driver. So add alloc/free and vmap/vunmap
callbacks here to handle the case. The previous patch v4 & v5 handles
the allocation and map in the netvsc driver. If this should not go 
though dma ops, We also may make it as vmbus specific function and keep
the function in the vmbus driver.

https://lkml.org/lkml/2021/9/28/51


