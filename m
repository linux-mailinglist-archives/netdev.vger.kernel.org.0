Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 14CB9E27F4
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 04:01:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408146AbfJXCBn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 22:01:43 -0400
Received: from verein.lst.de ([213.95.11.211]:43182 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2408092AbfJXCBm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Oct 2019 22:01:42 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 3BD0B68BE1; Thu, 24 Oct 2019 04:01:40 +0200 (CEST)
Date:   Thu, 24 Oct 2019 04:01:40 +0200
From:   "hch@lst.de" <hch@lst.de>
To:     Laurentiu Tudor <laurentiu.tudor@nxp.com>
Cc:     Robin Murphy <robin.murphy@arm.com>, "hch@lst.de" <hch@lst.de>,
        "joro@8bytes.org" <joro@8bytes.org>,
        Ioana Ciocoi Radulescu <ruxandra.radulescu@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Leo Li <leoyang.li@nxp.com>,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Madalin-cristian Bucur <madalin.bucur@nxp.com>
Subject: Re: [RFC PATCH 1/3] dma-mapping: introduce a new dma api
 dma_addr_to_phys_addr()
Message-ID: <20191024020140.GA6057@lst.de>
References: <20191022125502.12495-1-laurentiu.tudor@nxp.com> <20191022125502.12495-2-laurentiu.tudor@nxp.com> <62561dca-cdd7-fe01-a0c3-7b5971c96e7e@arm.com> <50a42575-02b2-c558-0609-90e2ad3f515b@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50a42575-02b2-c558-0609-90e2ad3f515b@nxp.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 23, 2019 at 11:53:41AM +0000, Laurentiu Tudor wrote:
> We had an internal discussion over these points you are raising and 
> Madalin (cc-ed) came up with another idea: instead of adding this prone 
> to misuse api how about experimenting with a new dma unmap and dma sync 
> variants that would return the physical address by calling the newly 
> introduced dma map op. Something along these lines:
>   * phys_addr_t dma_unmap_page_ret_phys(...)
>   * phys_addr_t dma_unmap_single_ret_phys(...)
>   * phys_addr_t dma_sync_single_for_cpu_ret_phys(...)
> I'm thinking that this proposal should reduce the risks opened by the 
> initial variant.
> Please let me know what you think.

I'm not sure what the ret is supposed to mean, but I generally like
that idea better.  We also need to make sure there is an easy way
to figure out if these APIs are available, as they generally aren't
for any non-IOMMU API IOMMU drivers.
