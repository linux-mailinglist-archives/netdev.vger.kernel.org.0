Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E35B746221
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 17:09:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726338AbfFNPJC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 11:09:02 -0400
Received: from verein.lst.de ([213.95.11.211]:47751 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725789AbfFNPJC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Jun 2019 11:09:02 -0400
Received: by newverein.lst.de (Postfix, from userid 2407)
        id EDC7268B05; Fri, 14 Jun 2019 17:08:27 +0200 (CEST)
Date:   Fri, 14 Jun 2019 17:08:27 +0200
From:   'Christoph Hellwig' <hch@lst.de>
To:     Robin Murphy <robin.murphy@arm.com>
Cc:     'Christoph Hellwig' <hch@lst.de>,
        David Laight <David.Laight@ACULAB.COM>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        David Airlie <airlied@linux.ie>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Ian Abbott <abbotti@mev.co.uk>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Sean Paul <sean@poorly.run>,
        "moderated list:ARM PORT" <linux-arm-kernel@lists.infradead.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        Daniel Vetter <daniel@ffwll.ch>
Subject: Re: [PATCH 16/16] dma-mapping: use exact allocation in
 dma_alloc_contiguous
Message-ID: <20190614150827.GA9460@lst.de>
References: <20190614134726.3827-1-hch@lst.de> <20190614134726.3827-17-hch@lst.de> <a90cf7ec5f1c4166b53c40e06d4d832a@AcuMS.aculab.com> <20190614145001.GB9088@lst.de> <4113cd5f-5c13-e9c7-bc5e-dcf0b60e7054@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4113cd5f-5c13-e9c7-bc5e-dcf0b60e7054@arm.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 14, 2019 at 04:05:33PM +0100, Robin Murphy wrote:
> That said, I don't believe this particular patch should make any 
> appreciable difference - alloc_pages_exact() is still going to give back 
> the same base address as the rounded up over-allocation would, and 
> PAGE_ALIGN()ing the size passed to get_order() already seemed to be 
> pointless.

True, we actually do get the right alignment just about anywhere.
Not 100% sure about the various static pool implementations, but we
can make sure if any didn't we'll do that right thing once those
get consolidated.
