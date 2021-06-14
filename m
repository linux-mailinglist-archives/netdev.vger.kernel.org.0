Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78FBF3A5D6D
	for <lists+netdev@lfdr.de>; Mon, 14 Jun 2021 09:09:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232508AbhFNHLO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 03:11:14 -0400
Received: from verein.lst.de ([213.95.11.211]:43049 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232455AbhFNHLM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Jun 2021 03:11:12 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 1F7FB67373; Mon, 14 Jun 2021 09:09:04 +0200 (CEST)
Date:   Mon, 14 Jun 2021 09:09:03 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Tianyu Lan <ltykernel@gmail.com>
Cc:     Christoph Hellwig <hch@lst.de>, kys@microsoft.com,
        haiyangz@microsoft.com, sthemmin@microsoft.com, wei.liu@kernel.org,
        decui@microsoft.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, x86@kernel.org, hpa@zytor.com, arnd@arndb.de,
        dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
        akpm@linux-foundation.org, kirill.shutemov@linux.intel.com,
        rppt@kernel.org, hannes@cmpxchg.org, cai@lca.pw,
        krish.sadhukhan@oracle.com, saravanand@fb.com,
        Tianyu.Lan@microsoft.com, konrad.wilk@oracle.com,
        m.szyprowski@samsung.com, robin.murphy@arm.com,
        boris.ostrovsky@oracle.com, jgross@suse.com,
        sstabellini@kernel.org, joro@8bytes.org, will@kernel.org,
        xen-devel@lists.xenproject.org, davem@davemloft.net,
        kuba@kernel.org, jejb@linux.ibm.com, martin.petersen@oracle.com,
        iommu@lists.linux-foundation.org, linux-arch@vger.kernel.org,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, netdev@vger.kernel.org,
        vkuznets@redhat.com, thomas.lendacky@amd.com,
        brijesh.singh@amd.com, sunilmut@microsoft.com
Subject: Re: [RFC PATCH V3 10/11] HV/Netvsc: Add Isolation VM support for
 netvsc driver
Message-ID: <20210614070903.GA29976@lst.de>
References: <20210530150628.2063957-1-ltykernel@gmail.com> <20210530150628.2063957-11-ltykernel@gmail.com> <20210607065007.GE24478@lst.de> <279cb4bf-c5b6-6db9-0f1e-9238e902c8f2@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <279cb4bf-c5b6-6db9-0f1e-9238e902c8f2@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 07, 2021 at 11:21:20PM +0800, Tianyu Lan wrote:
>> dma_map_single can only be used on page baked memory, and if this is
>> using page backed memory you wouldn't need to do thee phys_to_virt
>> tricks.  Can someone explain the mess here in more detail?
>
> Sorry. Could you elaborate the issue? These pages in the pb array are not 
> allocated by DMA API and using dma_map_single() here is to map these pages' 
> address to bounce buffer physical address.

dma_map_single just calls dma_map_page using virt_to_page.  So this
can't work on addresses not in the kernel linear mapping.
