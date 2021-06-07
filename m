Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D97D539D54C
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 08:46:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230340AbhFGGr5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 02:47:57 -0400
Received: from verein.lst.de ([213.95.11.211]:44650 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230198AbhFGGr4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Jun 2021 02:47:56 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 619F368AFE; Mon,  7 Jun 2021 08:46:03 +0200 (CEST)
Date:   Mon, 7 Jun 2021 08:46:03 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Tianyu Lan <ltykernel@gmail.com>
Cc:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        wei.liu@kernel.org, decui@microsoft.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, x86@kernel.org, hpa@zytor.com,
        arnd@arndb.de, dave.hansen@linux.intel.com, luto@kernel.org,
        peterz@infradead.org, akpm@linux-foundation.org,
        kirill.shutemov@linux.intel.com, rppt@kernel.org,
        hannes@cmpxchg.org, cai@lca.pw, krish.sadhukhan@oracle.com,
        saravanand@fb.com, Tianyu.Lan@microsoft.com,
        konrad.wilk@oracle.com, hch@lst.de, m.szyprowski@samsung.com,
        robin.murphy@arm.com, boris.ostrovsky@oracle.com, jgross@suse.com,
        sstabellini@kernel.org, joro@8bytes.org, will@kernel.org,
        xen-devel@lists.xenproject.org, davem@davemloft.net,
        kuba@kernel.org, jejb@linux.ibm.com, martin.petersen@oracle.com,
        iommu@lists.linux-foundation.org, linux-arch@vger.kernel.org,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, netdev@vger.kernel.org,
        vkuznets@redhat.com, thomas.lendacky@amd.com,
        brijesh.singh@amd.com, sunilmut@microsoft.com
Subject: Re: [RFC PATCH V3 11/11] HV/Storvsc: Add Isolation VM support for
 storvsc driver
Message-ID: <20210607064603.GD24478@lst.de>
References: <20210530150628.2063957-1-ltykernel@gmail.com> <20210530150628.2063957-12-ltykernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210530150628.2063957-12-ltykernel@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, May 30, 2021 at 11:06:28AM -0400, Tianyu Lan wrote:
> +				for (i = 0; i < request->hvpg_count; i++)
> +					dma_unmap_page(&device->device,
> +							request->dma_range[i].dma,
> +							request->dma_range[i].mapping_size,
> +							request->vstor_packet.vm_srb.data_in
> +							     == READ_TYPE ?
> +							DMA_FROM_DEVICE : DMA_TO_DEVICE);
> +				kfree(request->dma_range);

Unreadably long lines.  You probably want to factor the quoted code into
a little readable helper and do the same for the map side.
