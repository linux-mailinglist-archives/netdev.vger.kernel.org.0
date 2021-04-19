Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A800363B95
	for <lists+netdev@lfdr.de>; Mon, 19 Apr 2021 08:37:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237580AbhDSGhG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 02:37:06 -0400
Received: from verein.lst.de ([213.95.11.211]:45287 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230002AbhDSGhE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Apr 2021 02:37:04 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 030166736F; Mon, 19 Apr 2021 08:36:31 +0200 (CEST)
Date:   Mon, 19 Apr 2021 08:36:30 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc:     Tianyu Lan <ltykernel@gmail.com>, kys@microsoft.com,
        haiyangz@microsoft.com, sthemmin@microsoft.com, wei.liu@kernel.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, x86@kernel.org,
        hpa@zytor.com, arnd@arndb.de, akpm@linux-foundation.org,
        gregkh@linuxfoundation.org, hch@lst.de, m.szyprowski@samsung.com,
        robin.murphy@arm.com, joro@8bytes.org, will@kernel.org,
        davem@davemloft.net, kuba@kernel.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, Tianyu Lan <Tianyu.Lan@microsoft.com>,
        iommu@lists.linux-foundation.org, linux-arch@vger.kernel.org,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-scsi@vger.kernel.org,
        netdev@vger.kernel.org, vkuznets@redhat.com,
        thomas.lendacky@amd.com, brijesh.singh@amd.com,
        sunilmut@microsoft.com
Subject: Re: [Resend RFC PATCH V2 07/12] HV/Vmbus: Initialize VMbus ring
 buffer for Isolation VM
Message-ID: <20210419063630.GA18882@lst.de>
References: <20210414144945.3460554-1-ltykernel@gmail.com> <20210414144945.3460554-8-ltykernel@gmail.com> <YHig78Xra5tEQhMD@dhcp-10-154-102-149.vpn.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YHig78Xra5tEQhMD@dhcp-10-154-102-149.vpn.oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 15, 2021 at 04:24:15PM -0400, Konrad Rzeszutek Wilk wrote:
> So you are exposing these two:
>  EXPORT_SYMBOL_GPL(get_vm_area);
>  EXPORT_SYMBOL_GPL(ioremap_page_range);
> 
> But if you used vmap wouldn't you get the same thing for free?

Yes, this needs to go into some vmap version, preferably reusing the
existing code in kernel/dma/remap.c.

Exporting get_vm_area is a complete dealbreaker and not going to happen.
We worked hard on not exposing it to modules.
