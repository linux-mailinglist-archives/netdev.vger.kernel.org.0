Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB73040DD1B
	for <lists+netdev@lfdr.de>; Thu, 16 Sep 2021 16:44:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238768AbhIPOpc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Sep 2021 10:45:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237526AbhIPOpb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Sep 2021 10:45:31 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A595C061574;
        Thu, 16 Sep 2021 07:44:11 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id t4so4052644plo.0;
        Thu, 16 Sep 2021 07:44:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=daOJCQ5ZGPvwc1951n97peFQn5CdNcYRqjhdeKz1vfU=;
        b=kFhwzpK+Y6fzZ8X7nPLZDzATwjammU+fVatUdP6GQmmOa4cwb7pps1Nw0JafcdN05c
         us+rB0fvubZS9oiEAFzEFlFf312AuI1o1bEmAQE4QmcO1zjNKu1RZh97KgxL0BNdbt63
         0Jr+VY4PzihMoQPiBbmbSubnZSyQYJcQQgB+obVuZmtoGKsNqbBtlR5Gbo8zv710wZ9R
         a8mRhJlIllHxWHu31340de111QSrO67EpQHGFhSYs/S/jlv0B8eWaFAGTKy4KKxxqu/i
         pxm1iG7a99zgqWZv5DChQlteGUPk7MFUk4oD2MTOCUtVe1ZR4X5ZKY5Ua3wnolLudPA4
         hmZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=daOJCQ5ZGPvwc1951n97peFQn5CdNcYRqjhdeKz1vfU=;
        b=hQFiDPa/zWuqOizk67ZxzUc/hig4SPZafaAyO5E1dGfBxJKQOUxHbSnsVmhtgnazOz
         0mNpptgOPSTFDgRjZwvct8aZlnijU8GfqocN8AyrQdtCUKhVAL6l/O8vAtNn++TEkfVf
         4w6GXcLVqYDrWSn+uVokCiN9X7lv7LviqHVfELqTCnLfpMSCvHV5IN7VhnPgcKiqDKtx
         +9mqeHPB/RCmPq34PovdkN+qnj4jqHR2h0nRgs9IVefnqtzyuDO+KEPnNIFYlVQejqMb
         D766ZqcBfZ9WA19uYN5evwGaTisga2pH9vG64+wBDB8Kuynxb1rUtf323GT3l3hZx7Lq
         kV7g==
X-Gm-Message-State: AOAM531zvE2MeOfwfjXIsALjVkoGZcNhA4ZmShZeM8zTjXOtZnVJZOuZ
        /EN93lFv7gzOPZWg2MZ0cE4=
X-Google-Smtp-Source: ABdhPJy1NmsnM3CBTxeh4uCd/At4jyjgdaLl8A9jDJfcHgoAtY82XgoTk9uMDIbNLVKuF0mho51VHA==
X-Received: by 2002:a17:903:248f:b029:128:d5ea:18a7 with SMTP id p15-20020a170903248fb0290128d5ea18a7mr5070119plw.83.1631803450601;
        Thu, 16 Sep 2021 07:44:10 -0700 (PDT)
Received: from ?IPv6:2404:f801:0:5:8000::50b? ([2404:f801:9000:1a:efea::50b])
        by smtp.gmail.com with ESMTPSA id d3sm3759819pga.7.2021.09.16.07.43.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Sep 2021 07:44:10 -0700 (PDT)
Subject: Re: [PATCH V5 12/12] net: netvsc: Add Isolation VM support for netvsc
 driver
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
From:   Tianyu Lan <ltykernel@gmail.com>
Message-ID: <850a0129-ef82-67e9-165f-8503da6889dd@gmail.com>
Date:   Thu, 16 Sep 2021 22:43:56 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <MWHPR21MB15939A5D74CA1DF25EE816ADD7DB9@MWHPR21MB1593.namprd21.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/16/2021 12:21 AM, Michael Kelley wrote:
> I think you are proposing this approach to allocating memory for the send
> and receive buffers so that you can avoid having two virtual mappings for
> the memory, per comments from Christop Hellwig.  But overall, the approach
> seems a bit complex and I wonder if it is worth it.  If allocating large contiguous
> chunks of physical memory is successful, then there is some memory savings
> in that the data structures needed to keep track of the physical pages is
> smaller than the equivalent page tables might be.  But if you have to revert
> to allocating individual pages, then the memory savings is reduced.
> 

Yes, this version follows idea from Christop in the previous 
discussion.(https://lkml.org/lkml/2021/9/2/112)
This patch shows the implementation and check whether this is a right 
direction.

> Ultimately, the list of actual PFNs has to be kept somewhere.  Another approach
> would be to do the reverse of what hv_map_memory() from the v4 patch
> series does.  I.e., you could do virt_to_phys() on each virtual address that
> maps above VTOM, and subtract out the shared_gpa_boundary to get the
> list of actual PFNs that need to be freed.

virt_to_phys() doesn't work for virtual address returned by 
vmap/vmap_pfn() (just like it doesn't work for va returned by 
vmalloc()). The pfn above vTom doesn't have struct page backing and
vmap_pfn() populates the pfn directly in the pte.(Please see the
vmap_pfn_apply()). So it's not easy to convert the va to pa.

>   This way you don't have two copies
> of the list of PFNs -- one with and one without the shared_gpa_boundary added.
> But it comes at the cost of additional code so that may not be a great idea.
> 
> I think what you have here works, and I don't have a clearly better solution
> at the moment except perhaps to revert to the v4 solution and just have two
> virtual mappings.  I'll keep thinking about it.  Maybe Christop has other
> thoughts.



