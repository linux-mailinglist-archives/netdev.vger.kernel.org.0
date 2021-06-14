Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 887533A6816
	for <lists+netdev@lfdr.de>; Mon, 14 Jun 2021 15:37:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234087AbhFNNjY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 09:39:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233298AbhFNNjT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Jun 2021 09:39:19 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E51DC061574;
        Mon, 14 Jun 2021 06:37:16 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id fy24-20020a17090b0218b029016c5a59021fso10113572pjb.0;
        Mon, 14 Jun 2021 06:37:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=L2zqO1GmHtYJk6YxBI1sWe6jLyKPpb1AfJC8K4R6e5k=;
        b=Cxb1/imPkH0J0mCr4lfArmxBVSP9MZn7j5y/xPOvK408iNpZ/trCx7iTSB97b+6h2r
         GH8FYPrOC4Fgm9Z7GYXw2Q6TAfu1pePiEZj/1/rkvJ46B3Wt5yANQsUnBs0W0Zpx2yUg
         FUCFHCSdOksAFWye+3qd6MfK6evFhwMm5txRVoHom2eNUq2iAZevoB1ovrJLeR2+pngA
         zIKmOSyFmyM+dI38qtVe8XxjSsIv9gPiitEg81toKRhlb1r2KrcyYfURTl4AM29GboLz
         j4D3UMpwPezOe7xh7mP/Tz2Ele5K3oJYUbWnr9/m79e2/FDBSwGRnqztvf0n1OEzcoie
         ma5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=L2zqO1GmHtYJk6YxBI1sWe6jLyKPpb1AfJC8K4R6e5k=;
        b=NdFN1MCv40Q8A0eLJMYLSctH3f1NdwefHxOqHizrrotFIuZjvRmlgrb48FFvVWVFVT
         PodghbAk3kL2Mp30craPSabpo42/T36iZ//8Wghlpop32fZ4Q/jKunRZDuQUe0/ZL8p4
         yLmMsZB30CGDtEnAaNJhqlfqEYFFBMaeNDWu3mtecpb3p5ClLWslV26qWpjZRIWAww0M
         QH3VLbTpPe4FeTsWPQxz7dcfsR2WG2xcqdm6RIL8dfqrmwsM6izLl8ZCidtFZUjy5Q+n
         Pff4yI470SdGvmQcA84IrWuF1OxJk20Uq372/fYF1mB9amAL4vmmVMPwP5w8qw/0UM0t
         meJg==
X-Gm-Message-State: AOAM531TR5lW3biAmmbK/MLAGj9qvgBkEJNqhui0kSgyN64zcj2uuzJq
        BSvi5RmKiHoJJVIhdweqGGo=
X-Google-Smtp-Source: ABdhPJzc3ULYnZUK4PYU2Lj8UKWkUEgb6rd9+REx3GFM6TekjZ3ClxH5FkBxfIYNNF665iBfi2dSTw==
X-Received: by 2002:a17:902:b585:b029:f6:5cd5:f128 with SMTP id a5-20020a170902b585b02900f65cd5f128mr16662490pls.43.1623677835908;
        Mon, 14 Jun 2021 06:37:15 -0700 (PDT)
Received: from ?IPv6:2404:f801:0:5:8000::4b1? ([2404:f801:9000:1a:efea::4b1])
        by smtp.gmail.com with ESMTPSA id 125sm12375806pfg.52.2021.06.14.06.37.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Jun 2021 06:37:15 -0700 (PDT)
Subject: Re: [RFC PATCH V3 08/11] swiotlb: Add bounce buffer remap address
 setting function
To:     Christoph Hellwig <hch@lst.de>
Cc:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        wei.liu@kernel.org, decui@microsoft.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, x86@kernel.org, hpa@zytor.com,
        arnd@arndb.de, dave.hansen@linux.intel.com, luto@kernel.org,
        peterz@infradead.org, akpm@linux-foundation.org,
        kirill.shutemov@linux.intel.com, rppt@kernel.org,
        hannes@cmpxchg.org, cai@lca.pw, krish.sadhukhan@oracle.com,
        saravanand@fb.com, Tianyu.Lan@microsoft.com,
        konrad.wilk@oracle.com, m.szyprowski@samsung.com,
        robin.murphy@arm.com, boris.ostrovsky@oracle.com, jgross@suse.com,
        sstabellini@kernel.org, joro@8bytes.org, will@kernel.org,
        xen-devel@lists.xenproject.org, davem@davemloft.net,
        kuba@kernel.org, jejb@linux.ibm.com, martin.petersen@oracle.com,
        iommu@lists.linux-foundation.org, linux-arch@vger.kernel.org,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, netdev@vger.kernel.org,
        vkuznets@redhat.com, thomas.lendacky@amd.com,
        brijesh.singh@amd.com, sunilmut@microsoft.com
References: <20210530150628.2063957-1-ltykernel@gmail.com>
 <20210530150628.2063957-9-ltykernel@gmail.com>
 <20210607064312.GB24478@lst.de>
 <48516ce3-564c-419e-b355-0ce53794dcb1@gmail.com>
 <20210614071223.GA30171@lst.de>
From:   Tianyu Lan <ltykernel@gmail.com>
Message-ID: <3e64e59b-7440-69a5-75c5-43225f3d6c0a@gmail.com>
Date:   Mon, 14 Jun 2021 21:37:01 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210614071223.GA30171@lst.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/14/2021 3:12 PM, Christoph Hellwig wrote:
> On Mon, Jun 07, 2021 at 10:56:47PM +0800, Tianyu Lan wrote:
>> These addresses in extra address space works as system memory mirror. The
>> shared memory with host in Isolation VM needs to be accessed via extra
>> address space which is above shared gpa boundary.
> 
> Why?
> 

The shared_gpa_boundary in the AMD SEV SNP spec is called virtual top of
memory(vTOM). Memory addresses below vTOM are automatically treated as
private while memory above vTOM is treated as shared. Using vTOM to
separate memory in this way avoids the need to augment the standard x86
page tables with C-bit markings, simplifying guest OS software.
