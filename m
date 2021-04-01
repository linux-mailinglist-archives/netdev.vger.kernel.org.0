Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D32A351251
	for <lists+netdev@lfdr.de>; Thu,  1 Apr 2021 11:33:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233866AbhDAJcR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Apr 2021 05:32:17 -0400
Received: from verein.lst.de ([213.95.11.211]:38986 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233930AbhDAJcG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Apr 2021 05:32:06 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id F161068B05; Thu,  1 Apr 2021 11:32:01 +0200 (CEST)
Date:   Thu, 1 Apr 2021 11:32:01 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Will Deacon <will@kernel.org>
Cc:     Christoph Hellwig <hch@lst.de>, Joerg Roedel <joro@8bytes.org>,
        Li Yang <leoyang.li@nxp.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        David Woodhouse <dwmw2@infradead.org>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        linuxppc-dev@lists.ozlabs.org, linux-arm-msm@vger.kernel.org,
        dri-devel@lists.freedesktop.org, freedreno@lists.freedesktop.org,
        iommu@lists.linux-foundation.org,
        linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: Re: [PATCH 06/18] iommu/fsl_pamu: remove ->domain_window_enable
Message-ID: <20210401093201.GC2934@lst.de>
References: <20210316153825.135976-1-hch@lst.de> <20210316153825.135976-7-hch@lst.de> <20210330124009.GF5908@willie-the-truck>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210330124009.GF5908@willie-the-truck>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 30, 2021 at 01:40:09PM +0100, Will Deacon wrote:
> > +	ret = pamu_config_ppaace(liodn, geom->aperture_start,
> > +				 geom->aperture_end - 1, ~(u32)0,
> 
> You're passing 'geom->aperture_end - 1' as the size here, but the old code
> seemed to _add_ 1:
> 

> > -	win_size = (domain->geometry.aperture_end + 1) >> ilog2(1);
> 
> here ^^ when calculating the exclusive upper bound. In other words, I think
> '1ULL << 36' used to get passed to pamu_config_ppaace(). Is that an
> intentional change?

No, I've fixed it up.
