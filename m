Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D3DB41A730
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 07:39:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235973AbhI1FlC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 01:41:02 -0400
Received: from verein.lst.de ([213.95.11.211]:50132 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234243AbhI1Fk5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Sep 2021 01:40:57 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id ED5FC67373; Tue, 28 Sep 2021 07:39:11 +0200 (CEST)
Date:   Tue, 28 Sep 2021 07:39:11 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Tianyu Lan <ltykernel@gmail.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        vkuznets <vkuznets@redhat.com>,
        "parri.andrea@gmail.com" <parri.andrea@gmail.com>,
        "dave.hansen@intel.com" <dave.hansen@intel.com>,
        Michael Kelley <mikelley@microsoft.com>,
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
        "arnd@arndb.de" <arnd@arndb.de>,
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
Subject: Re: [PATCH V5 12/12] net: netvsc: Add Isolation VM support for
 netvsc driver
Message-ID: <20210928053911.GA29208@lst.de>
References: <20210914133916.1440931-1-ltykernel@gmail.com> <20210914133916.1440931-13-ltykernel@gmail.com> <MWHPR21MB15939A5D74CA1DF25EE816ADD7DB9@MWHPR21MB1593.namprd21.prod.outlook.com> <43e22b84-7273-4099-42ea-54b06f398650@gmail.com> <e379a60b-4d74-9167-983f-f70c96bb279e@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e379a60b-4d74-9167-983f-f70c96bb279e@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 27, 2021 at 10:26:43PM +0800, Tianyu Lan wrote:
> Hi Christoph:
>     Gentile ping. The swiotlb and shared memory mapping changes in this
> patchset needs your reivew. Could you have a look?

I'm a little too busy for a review of such a huge patchset right now.
That being said here are my comments from a very quick review:

 - the bare memremap usage in swiotlb looks strange and I'd
   definitively expect a well documented wrapper.
 - given that we can now hand out swiotlb memory for coherent mappings
   we need to carefully audit what happens when this memremaped
   memory gets mmaped or used through dma_get_sgtable
 - the netscv changes I'm not happy with at all.  A large part of it
   is that the driver already has a bad structure, but this series
   is making it significantly worse.  We'll need to find a way
   to use the proper dma mapping abstractions here.  One option
   if you want to stick to the double vmapped buffer would be something
   like using dma_alloc_noncontigous plus a variant of
   dma_vmap_noncontiguous that takes the shared_gpa_boundary into
   account.
