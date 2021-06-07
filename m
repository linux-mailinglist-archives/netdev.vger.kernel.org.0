Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C8B039D53D
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 08:45:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230281AbhFGGqr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 02:46:47 -0400
Received: from verein.lst.de ([213.95.11.211]:44619 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230212AbhFGGqr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Jun 2021 02:46:47 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id B14DA68AFE; Mon,  7 Jun 2021 08:44:53 +0200 (CEST)
Date:   Mon, 7 Jun 2021 08:44:53 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc:     Tianyu Lan <ltykernel@gmail.com>, kys@microsoft.com,
        haiyangz@microsoft.com, sthemmin@microsoft.com, wei.liu@kernel.org,
        decui@microsoft.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, x86@kernel.org, hpa@zytor.com, arnd@arndb.de,
        dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
        akpm@linux-foundation.org, kirill.shutemov@linux.intel.com,
        rppt@kernel.org, hannes@cmpxchg.org, cai@lca.pw,
        krish.sadhukhan@oracle.com, saravanand@fb.com,
        Tianyu.Lan@microsoft.com, konrad.wilk@oracle.com, hch@lst.de,
        m.szyprowski@samsung.com, robin.murphy@arm.com, jgross@suse.com,
        sstabellini@kernel.org, joro@8bytes.org, will@kernel.org,
        xen-devel@lists.xenproject.org, davem@davemloft.net,
        kuba@kernel.org, jejb@linux.ibm.com, martin.petersen@oracle.com,
        iommu@lists.linux-foundation.org, linux-arch@vger.kernel.org,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, netdev@vger.kernel.org,
        vkuznets@redhat.com, thomas.lendacky@amd.com,
        brijesh.singh@amd.com, sunilmut@microsoft.com
Subject: Re: [RFC PATCH V3 09/11] HV/IOMMU: Enable swiotlb bounce buffer
 for Isolation VM
Message-ID: <20210607064453.GC24478@lst.de>
References: <20210530150628.2063957-1-ltykernel@gmail.com> <20210530150628.2063957-10-ltykernel@gmail.com> <9488c114-81ad-eb67-79c0-5ed319703d3e@oracle.com> <a023ee3f-ce85-b54f-79c3-146926bf3279@gmail.com> <d6714e8b-dcb6-798b-59a4-5bb68f789564@oracle.com> <1cdf4e6e-6499-e209-d499-7ab82992040b@gmail.com> <099f311b-9614-dac5-ce05-6dad988f8a62@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <099f311b-9614-dac5-ce05-6dad988f8a62@oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Honestly, we really need to do away with the concept of hypervisor-
specific swiotlb allocations and just add a hypervisor hook to remap the
"main" buffer. That should remove a lot of code and confusion not just
for Xen but also any future addition like hyperv.
