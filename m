Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BEBD2CF39F
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 19:08:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729617AbgLDSHK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 13:07:10 -0500
Received: from mga04.intel.com ([192.55.52.120]:7222 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726330AbgLDSHJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Dec 2020 13:07:09 -0500
IronPort-SDR: Iqae64z9AkZ0vQrBnvGDsyBMX4s40q3ADaV04lhYsfHMsB2qrIZzsXp9LiB81O9BEfgf9PbBD8
 Q8MpTIk8vKBg==
X-IronPort-AV: E=McAfee;i="6000,8403,9825"; a="170848754"
X-IronPort-AV: E=Sophos;i="5.78,393,1599548400"; 
   d="scan'208";a="170848754"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Dec 2020 10:05:26 -0800
IronPort-SDR: dB024BUUc2ReToxwwk3+yKJCSCqnipy75nu4pzMRAIE5pt6J+sn7ZQBbU7PN+58EiiSEtvtyS2
 1zERCTqPYUXQ==
X-IronPort-AV: E=Sophos;i="5.78,393,1599548400"; 
   d="scan'208";a="482476089"
Received: from mwalsh7-mobl1.amr.corp.intel.com ([10.212.248.252])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Dec 2020 10:05:25 -0800
Message-ID: <2b6a928aadc8c49070aa184e6f41cf2377a22721.camel@linux.intel.com>
Subject: Re: [resend/standalone PATCH v4] Add auxiliary bus support
From:   Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
To:     Greg KH <gregkh@linuxfoundation.org>,
        Dan Williams <dan.j.williams@intel.com>, broonie@kernel.org
Cc:     lgirdwood@gmail.com, davem@davemloft.net, kuba@kernel.org,
        jgg@nvidia.com, Kiran Patil <kiran.patil@intel.com>,
        Fred Oh <fred.oh@linux.intel.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Dave Ertman <david.m.ertman@intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Shiraz Saleem <shiraz.saleem@intel.com>,
        Parav Pandit <parav@mellanox.com>,
        Martin Habets <mhabets@solarflare.com>,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Date:   Fri, 04 Dec 2020 10:05:24 -0800
In-Reply-To: <X8os+X515fxeqefg@kroah.com>
References: <160695681289.505290.8978295443574440604.stgit@dwillia2-desk3.amr.corp.intel.com>
         <X8os+X515fxeqefg@kroah.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.3-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2020-12-04 at 13:35 +0100, Greg KH wrote:
> On Wed, Dec 02, 2020 at 04:54:24PM -0800, Dan Williams wrote:
> > From: Dave Ertman <david.m.ertman@intel.com>
> > 
> > Add support for the Auxiliary Bus, auxiliary_device and
> > auxiliary_driver.
> > It enables drivers to create an auxiliary_device and bind an
> > auxiliary_driver to it.
> > 
> > The bus supports probe/remove shutdown and suspend/resume
> > callbacks.
> > Each auxiliary_device has a unique string based id; driver binds to
> > an auxiliary_device based on this id through the bus.
> > 
> > Co-developed-by: Kiran Patil <kiran.patil@intel.com>
> > Co-developed-by: Ranjani Sridharan <
> > ranjani.sridharan@linux.intel.com>
> > Co-developed-by: Fred Oh <fred.oh@linux.intel.com>
> > Co-developed-by: Leon Romanovsky <leonro@nvidia.com>
> > Signed-off-by: Kiran Patil <kiran.patil@intel.com>
> > Signed-off-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com
> > >
> > Signed-off-by: Fred Oh <fred.oh@linux.intel.com>
> > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> > Signed-off-by: Dave Ertman <david.m.ertman@intel.com>
> > Reviewed-by: Pierre-Louis Bossart <
> > pierre-louis.bossart@linux.intel.com>
> > Reviewed-by: Shiraz Saleem <shiraz.saleem@intel.com>
> > Reviewed-by: Parav Pandit <parav@mellanox.com>
> > Reviewed-by: Dan Williams <dan.j.williams@intel.com>
> > Reviewed-by: Martin Habets <mhabets@solarflare.com>
> > Link: 
> > https://lore.kernel.org/r/20201113161859.1775473-2-david.m.ertman@intel.com
> > Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> > ---
> > This patch is "To:" the maintainers that have a pending backlog of
> > driver updates dependent on this facility, and "Cc:" Greg. Greg, I
> > understand you have asked for more time to fully review this and
> > apply
> > it to driver-core.git, likely for v5.12, but please consider Acking
> > it
> > for v5.11 instead. It looks good to me and several other
> > stakeholders.
> > Namely, stakeholders that have pressure building up behind this
> > facility
> > in particular Mellanox RDMA, but also SOF, Intel Ethernet, and
> > later on
> > Compute Express Link.
> > 
> > I will take the blame for the 2 months of silence that made this
> > awkward
> > to take through driver-core.git, but at the same time I do not want
> > to
> > see that communication mistake inconvenience other parties that
> > reasonably thought this was shaping up to land in v5.11.
> > 
> > I am willing to host this version at:
> > 
> > git://git.kernel.org/pub/scm/linux/kernel/git/djbw/linux
> > tags/auxiliary-bus-for-5.11
> > 
> > ...for all the independent drivers to have a common commit
> > baseline. It
> > is not there yet pending Greg's Ack.
> 
> Here is now a signed tag for everyone else to pull from and build on
> top
> of, for 5.11-rc1, that includes this patch, and the 3 others I sent
> in
> this series.
> 
> Please let me know if anyone has any problems with this tag.  I'll
> keep
> it around until 5.11-rc1 is released, after which it doesn't make any
> sense to be there.
> thanks,
> 
> greg k-h

Hi Mark,

Could I request you to please pull from this tag and will we re-submit
the SOF changes soon after.

Thanks,
Ranjani

