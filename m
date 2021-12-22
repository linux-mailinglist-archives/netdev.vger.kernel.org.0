Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6925247CA87
	for <lists+netdev@lfdr.de>; Wed, 22 Dec 2021 01:48:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239708AbhLVAsV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 19:48:21 -0500
Received: from mga07.intel.com ([134.134.136.100]:7457 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230412AbhLVAsU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Dec 2021 19:48:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1640134100; x=1671670100;
  h=message-id:subject:from:reply-to:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=lPAB9TpPA8m0orWH5yrp/UacAeQjOTYI0kcgojBycwc=;
  b=Q4sGfgYn5E7rK0SnUKAn6whZUX/xZ9ot2wVplO/PM122yrGuRJw/kcru
   +kIctKoH7UD8R7cJr2HtFixYwA2McVP7JQGI9tObVlHJs6V/sn4iZMA01
   +DhQ5dfoBJFFDgn2yXaJocGFSjNttDgtoKJSBopPcMoX8vkQLG7wRbWQO
   cTbs9Fk/y9wL0ui13IyVlKqFGC/qe69u05gqrIwzAmEEoAXGIwJo3NCEH
   o6rFN3SziTXAKCJ6q8yf1iwiu50zFTt79KARIuP3wI8urjWdsNw45++xy
   PCr15zO6jxGeFyI0I10HPlPXF1Gvg3nkysWmkSzqmXvxegFGEEkGnFGAT
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10205"; a="303889263"
X-IronPort-AV: E=Sophos;i="5.88,224,1635231600"; 
   d="scan'208";a="303889263"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Dec 2021 16:48:19 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,224,1635231600"; 
   d="scan'208";a="613653051"
Received: from linux.intel.com ([10.54.29.200])
  by fmsmga002.fm.intel.com with ESMTP; 21 Dec 2021 16:48:18 -0800
Received: from rbambrou-mobl.amr.corp.intel.com (unknown [10.209.90.33])
        by linux.intel.com (Postfix) with ESMTP id 18C64580684;
        Tue, 21 Dec 2021 16:48:18 -0800 (PST)
Message-ID: <35bca887e697597f7b3e1944b3dd7347c6defca1.camel@linux.intel.com>
Subject: Re: [PATCH 0/4] driver_core: Auxiliary drvdata helper cleanup
From:   "David E. Box" <david.e.box@linux.intel.com>
Reply-To: david.e.box@linux.intel.com
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     gregkh@linuxfoundation.org, mustafa.ismail@intel.com,
        shiraz.saleem@intel.com, dledford@redhat.com, leon@kernel.org,
        saeedm@nvidia.com, davem@davemloft.net, kuba@kernel.org,
        vkoul@kernel.org, yung-chuan.liao@linux.intel.com,
        pierre-louis.bossart@linux.intel.com, mst@redhat.com,
        jasowang@redhat.com, andriy.shevchenko@linux.intel.com,
        hdegoede@redhat.com, virtualization@lists.linux-foundation.org,
        alsa-devel@alsa-project.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org
Date:   Tue, 21 Dec 2021 16:48:17 -0800
In-Reply-To: <20211222000905.GN6467@ziepe.ca>
References: <20211221235852.323752-1-david.e.box@linux.intel.com>
         <20211222000905.GN6467@ziepe.ca>
Organization: David E. Box
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2021-12-21 at 20:09 -0400, Jason Gunthorpe wrote:
> On Tue, Dec 21, 2021 at 03:58:48PM -0800, David E. Box wrote:
> > Depends on "driver core: auxiliary bus: Add driver data helpers" patch [1].
> > Applies the helpers to all auxiliary device drivers using
> > dev_(get/set)_drvdata. Drivers were found using the following search:
> > 
> >     grep -lr "struct auxiliary_device" $(grep -lr "drvdata" .)
> > 
> > Changes were build tested using the following configs:
> > 
> >     vdpa/mlx5:       CONFIG_MLX5_VDPA_NET
> >     net/mlx53:       CONFIG_MLX5_CORE_EN
> >     soundwire/intel: CONFIG_SOUNDWIRE_INTEL
> >     RDAM/irdma:      CONFIG_INFINIBAND_IRDMA
> >                      CONFIG_MLX5_INFINIBAND
> > 
> > [1] https://www.spinics.net/lists/platform-driver-x86/msg29940.html 
> 
> I have to say I don't really find this to be a big readability
> improvement.

I should have referenced the thread [1] discussing the benefit of this change
since the question was asked and answered already. The idea is that drivers
shouldn't have to touch the device API directly if they are already using a
higher level core API (auxiliary bus) that can do that on its behalf.

One benefit of this scheme is that it limits the number of places where changes
need to be made if the device core were to change.

[1] https://lore.kernel.org/all/YbBwOb6JvWkT3JWI@kroah.com/

> 
> Also, what use is 'to_auxiliary_dev()' ? I didn't see any users added..

This was not added by that patch.

Thanks

David
> 
> Jason

