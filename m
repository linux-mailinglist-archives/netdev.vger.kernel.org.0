Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5214B34E754
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 14:17:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232017AbhC3MQb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 08:16:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:37758 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232005AbhC3MQC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Mar 2021 08:16:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7EF476023F;
        Tue, 30 Mar 2021 12:15:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617106561;
        bh=bw8KBo/NNqB097evsMkXsyFAnnqW6iPTNtBok4bird8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QQpwu09zdg1APUNJpuxQhrkAfEgb8Xx8xBXTFO5/bqrnCy7nUn9ZszN5WLb+sq6vo
         5UJCLWYDMVJjHKt1uBKBD6MMh1tpUC2/ZJUxkV8BiHWJrvRd361XyyytEj+6Li42BI
         tfxcD7Rdfa0dzL9ZkwRo0SzzQKJrMa88AgwyNDnuPLKRwADNMLnkiOXhBm9+lE1tBR
         rdun4d9sUp5EgfOD94h55VT+FoWTTMYz/Myrov9kU9g5f+P8nfcOj+TX3m+W0J04yq
         y4bdrKMyq4yHZ4rqf7cqV7h7YmIgfRkPLJ7ViI7cikjVljJ7l7h/CdSxY5MyPkvqqz
         V8lAE4+4RFo3g==
Date:   Tue, 30 Mar 2021 13:15:56 +0100
From:   Will Deacon <will@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Joerg Roedel <joro@8bytes.org>, Li Yang <leoyang.li@nxp.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        David Woodhouse <dwmw2@infradead.org>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        linuxppc-dev@lists.ozlabs.org, linux-arm-msm@vger.kernel.org,
        dri-devel@lists.freedesktop.org, freedreno@lists.freedesktop.org,
        iommu@lists.linux-foundation.org,
        linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: Re: [PATCH 03/18] iommu/fsl_pamu: remove support for setting
 DOMAIN_ATTR_GEOMETRY
Message-ID: <20210330121555.GC5908@willie-the-truck>
References: <20210316153825.135976-1-hch@lst.de>
 <20210316153825.135976-4-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210316153825.135976-4-hch@lst.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 16, 2021 at 04:38:09PM +0100, Christoph Hellwig wrote:
> The default geometry is the same as the one set by qman_port given
> that FSL_PAMU depends on having 64-bit physical and thus DMA addresses.
> 
> Remove the support to update the geometry and remove the now pointless
> geom_size field.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Acked-by: Li Yang <leoyang.li@nxp.com>
> ---
>  drivers/iommu/fsl_pamu_domain.c     | 55 +++--------------------------
>  drivers/iommu/fsl_pamu_domain.h     |  6 ----
>  drivers/soc/fsl/qbman/qman_portal.c | 12 -------
>  3 files changed, 5 insertions(+), 68 deletions(-)

Took me a minute to track down the other magic '36' which ends up in
aperture_end, but I found it eventually so:

Acked-by: Will Deacon <will@kernel.org>

(It does make me wonder what all this glue was intended to be used for)

Will
