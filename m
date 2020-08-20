Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2058424AE60
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 07:20:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726666AbgHTFUK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 01:20:10 -0400
Received: from verein.lst.de ([213.95.11.211]:40569 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725780AbgHTFUJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Aug 2020 01:20:09 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 4B4A168BEB; Thu, 20 Aug 2020 07:20:04 +0200 (CEST)
Date:   Thu, 20 Aug 2020 07:20:04 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Tomasz Figa <tfiga@chromium.org>
Cc:     alsa-devel@alsa-project.org, linux-ia64@vger.kernel.org,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        nouveau@lists.freedesktop.org, linux-nvme@lists.infradead.org,
        linux-mips@vger.kernel.org,
        "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
        linux-mm@kvack.org, Christoph Hellwig <hch@lst.de>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        linux-scsi@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Ben Skeggs <bskeggs@redhat.com>,
        Matt Porter <mporter@kernel.crashing.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Pawel Osciak <pawel@osciak.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        "list@263.net:IOMMU DRIVERS <iommu@lists.linux-foundation.org>, Joerg
        Roedel <joro@8bytes.org>, " <linux-arm-kernel@lists.infradead.org>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        linux-parisc@vger.kernel.org, netdev@vger.kernel.org,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "list@263.net:IOMMU DRIVERS <iommu@lists.linux-foundation.org>, Joerg
        Roedel <joro@8bytes.org>, " <iommu@lists.linux-foundation.org>
Subject: Re: [PATCH 05/28] media/v4l2: remove
 V4L2-FLAG-MEMORY-NON-CONSISTENT
Message-ID: <20200820052004.GA5305@lst.de>
References: <20200819065555.1802761-1-hch@lst.de> <20200819065555.1802761-6-hch@lst.de> <CAAFQd5COLxjydDYrfx47ht8tj-aNPiaVnC+WyQA7nvpW4gs=ww@mail.gmail.com> <20200819135454.GA17098@lst.de> <CAAFQd5BuXP7t3d-Rwft85j=KTyXq7y4s24mQxLr=VoY9krEGZw@mail.gmail.com> <20200820044347.GA4533@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200820044347.GA4533@lst.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 20, 2020 at 06:43:47AM +0200, Christoph Hellwig wrote:
> On Wed, Aug 19, 2020 at 03:57:53PM +0200, Tomasz Figa wrote:
> > > > Could you explain what makes you think it's unused? It's a feature of
> > > > the UAPI generally supported by the videobuf2 framework and relied on
> > > > by Chromium OS to get any kind of reasonable performance when
> > > > accessing V4L2 buffers in the userspace.
> > >
> > > Because it doesn't do anything except on PARISC and non-coherent MIPS,
> > > so by definition it isn't used by any of these media drivers.
> > 
> > It's still an UAPI feature, so we can't simply remove the flag, it
> > must stay there as a no-op, until the problem is resolved.
> 
> Ok, I'll switch to just ignoring it for the next version.

So I took a deeper look.  I don't really think it qualifies as a UAPI
in our traditional sense.  For one it only appeared in 5.9-rc1, so we
can trivially expedite the patch into 5.9-rc and not actually make it
show up in any released kernel version.  And even as of the current
Linus' tree the only user is a test driver.  So I really think the best
way to go ahead is to just revert it ASAP as the design wasn't thought
out at all.
