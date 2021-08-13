Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CE823EBBC4
	for <lists+netdev@lfdr.de>; Fri, 13 Aug 2021 19:58:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232642AbhHMR7P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Aug 2021 13:59:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232099AbhHMR7O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Aug 2021 13:59:14 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5E70C061756;
        Fri, 13 Aug 2021 10:58:47 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id bo18so16525411pjb.0;
        Fri, 13 Aug 2021 10:58:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=di7QngSrp4FnsSGO3LSu9eV65mIJNW5jKf6yiG0+RuU=;
        b=dQXLqc5X8fIsHbzymW3PLJOTOjlQdK8tcmZqLFzG352erBCZhuDdyQp5dJjpAxQs4B
         JeaS1pyddkxqdfr1t8ujRcY12W0PqS0hXNNOXZ0wFZF2oaeKK3/1DVpmWTSnCW6zOWzY
         gqsqTLjc9I8480wq1q6uBW3m6zMSJpXzGOBUxY9waV/oC7JaNorcF8JKXWehHZRJ5RUq
         g7RNoWhlraHMPVn4DI6/rTvyrmiPeXKT3mG72JAOtuEM7ufjtq62UA9Nz9UYy2mJkzEG
         NpAl0ATS3TPxm1KRHOuuzcztGTWzT/f9vfWyWDsL/FUIc3fxfMILeA2ztqpuFTME9rw+
         80RQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=di7QngSrp4FnsSGO3LSu9eV65mIJNW5jKf6yiG0+RuU=;
        b=XqGMN3QL9I1Hh944IKR1rRB1hOHxrzGNlzKB23+kKOmpyeheFUZGYMdbh4uZ8r1u3r
         Y1BAXG4NRAAjyXXBnFcqm8Fp0pUzQc+zzhMGR9PDmcQ0mKPxxPDp893h6jG5oDoexUm0
         UwURPKxEm+X1gymT+KtTW/iwAJXiWaUWFb4BAZn2BlRc9yJqugTOuVr/8WKjERoxW3eI
         py8wvjuviw178giVV4avC0dkWr0oSz3bcx3bXCssuHlAN0DX4nEm1cFSpm3fyYhtz7ZU
         PYjXIcCyj18moo41wMh7O4o2r34Bbghs9/PlGynE47s079ubSC9/tcPBC0DUl6ny9ueH
         Fz/A==
X-Gm-Message-State: AOAM5334QW6nv2Cnx3R0Ju9eJsqYVoryg5EJKgu6PGSzg+abSURAqq0n
        G41xhx80pHEJIfLbO98S2YI=
X-Google-Smtp-Source: ABdhPJwzwumzRBi1BCTF3AFHLjIkjk9cXsbjw6TqqLX1fdRzbRFo7tzsATIv9gSPcOccSh8E3bFC/Q==
X-Received: by 2002:a63:f749:: with SMTP id f9mr3387048pgk.77.1628877527474;
        Fri, 13 Aug 2021 10:58:47 -0700 (PDT)
Received: from ?IPv6:2404:f801:0:5:8000::50b? ([2404:f801:9000:1a:efea::50b])
        by smtp.gmail.com with ESMTPSA id 19sm2945794pfw.203.2021.08.13.10.58.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Aug 2021 10:58:47 -0700 (PDT)
Subject: Re: [PATCH V3 10/13] x86/Swiotlb: Add Swiotlb bounce buffer remap
 function for HV IVM
To:     Christoph Hellwig <hch@lst.de>
Cc:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        wei.liu@kernel.org, decui@microsoft.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, x86@kernel.org, hpa@zytor.com,
        dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
        konrad.wilk@oracle.com, boris.ostrovsky@oracle.com,
        jgross@suse.com, sstabellini@kernel.org, joro@8bytes.org,
        will@kernel.org, davem@davemloft.net, kuba@kernel.org,
        jejb@linux.ibm.com, martin.petersen@oracle.com, arnd@arndb.de,
        m.szyprowski@samsung.com, robin.murphy@arm.com,
        thomas.lendacky@amd.com, brijesh.singh@amd.com, ardb@kernel.org,
        Tianyu.Lan@microsoft.com, pgonda@google.com,
        martin.b.radev@gmail.com, akpm@linux-foundation.org,
        kirill.shutemov@linux.intel.com, rppt@kernel.org,
        sfr@canb.auug.org.au, saravanand@fb.com,
        krish.sadhukhan@oracle.com, aneesh.kumar@linux.ibm.com,
        xen-devel@lists.xenproject.org, rientjes@google.com,
        hannes@cmpxchg.org, tj@kernel.org, michael.h.kelley@microsoft.com,
        iommu@lists.linux-foundation.org, linux-arch@vger.kernel.org,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, netdev@vger.kernel.org,
        vkuznets@redhat.com, parri.andrea@gmail.com, dave.hansen@intel.com
References: <20210809175620.720923-1-ltykernel@gmail.com>
 <20210809175620.720923-11-ltykernel@gmail.com>
 <20210812122741.GC19050@lst.de>
From:   Tianyu Lan <ltykernel@gmail.com>
Message-ID: <d18ae061-6fc2-e69e-fc2c-2e1a1114c4b4@gmail.com>
Date:   Sat, 14 Aug 2021 01:58:32 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210812122741.GC19050@lst.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/12/2021 8:27 PM, Christoph Hellwig wrote:
> This is still broken.  You need to make sure the actual DMA allocations
> do have struct page backing.
> 

Hi Christoph:
      swiotlb_tbl_map_single() still returns PA below vTOM/share_gpa_
boundary. These PAs has backing pages and belong to system memory.
In other word, all PAs passed to DMA API have backing pages and these is 
no difference between Isolation guest and traditional guest for DMA API.
The new mapped VA for PA above vTOM here is just to access the bounce 
buffer in the swiotlb code and isn't exposed to outside.
