Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46BF72CF2DA
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 18:13:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388483AbgLDRMT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 12:12:19 -0500
Received: from mga05.intel.com ([192.55.52.43]:16320 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726152AbgLDRMS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Dec 2020 12:12:18 -0500
IronPort-SDR: lYxAXEnAOKK+z93SOsH9dCYfPxiaZNEqNl2OAQjrQ5C4vWo4vuARSGg49/Wo8MzbfsT+s7jRjN
 Eci49+sifX2g==
X-IronPort-AV: E=McAfee;i="6000,8403,9825"; a="258121283"
X-IronPort-AV: E=Sophos;i="5.78,393,1599548400"; 
   d="scan'208";a="258121283"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Dec 2020 09:10:35 -0800
IronPort-SDR: Q+kE0BgnPU7r7p9k4wspq1KsSVeTDsFrzsFNtygkwpTILxTTJpT1uFQm7NdtGN+n3JtkEsQNsh
 z4MleMyQy3BQ==
X-IronPort-AV: E=Sophos;i="5.78,393,1599548400"; 
   d="scan'208";a="551015315"
Received: from mwalsh7-mobl1.amr.corp.intel.com ([10.212.248.252])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Dec 2020 09:10:34 -0800
Message-ID: <f8371c36608084144fe6e8ca089901d330a7191f.camel@linux.intel.com>
Subject: Re: [resend/standalone PATCH v4] Add auxiliary bus support
From:   Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
To:     Greg KH <gregkh@linuxfoundation.org>,
        Leon Romanovsky <leonro@nvidia.com>
Cc:     Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        alsa-devel@alsa-project.org, Kiran Patil <kiran.patil@intel.com>,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        Martin Habets <mhabets@solarflare.com>, lgirdwood@gmail.com,
        Fred Oh <fred.oh@linux.intel.com>, broonie@kernel.org,
        jgg@nvidia.com, Dave Ertman <david.m.ertman@intel.com>,
        kuba@kernel.org, Dan Williams <dan.j.williams@intel.com>,
        Shiraz Saleem <shiraz.saleem@intel.com>, davem@davemloft.net,
        linux-kernel@vger.kernel.org, Parav Pandit <parav@mellanox.com>
Date:   Fri, 04 Dec 2020 09:10:34 -0800
In-Reply-To: <X8oyqpxDQ4JV31tj@kroah.com>
References: <160695681289.505290.8978295443574440604.stgit@dwillia2-desk3.amr.corp.intel.com>
         <X8ogtmrm7tOzZo+N@kroah.com> <20201204123207.GH16543@unreal>
         <X8oyqpxDQ4JV31tj@kroah.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.3-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2020-12-04 at 13:59 +0100, Greg KH wrote:
> On Fri, Dec 04, 2020 at 02:32:07PM +0200, Leon Romanovsky wrote:
> > On Fri, Dec 04, 2020 at 12:42:46PM +0100, Greg KH wrote:
> > > On Wed, Dec 02, 2020 at 04:54:24PM -0800, Dan Williams wrote:
> > > > From: Dave Ertman <david.m.ertman@intel.com>
> > > > 
> > > > Add support for the Auxiliary Bus, auxiliary_device and
> > > > auxiliary_driver.
> > > > It enables drivers to create an auxiliary_device and bind an
> > > > auxiliary_driver to it.
> > > > 
> > > > The bus supports probe/remove shutdown and suspend/resume
> > > > callbacks.
> > > > Each auxiliary_device has a unique string based id; driver
> > > > binds to
> > > > an auxiliary_device based on this id through the bus.
> > > > 
> > > > Co-developed-by: Kiran Patil <kiran.patil@intel.com>
> > > > Co-developed-by: Ranjani Sridharan <
> > > > ranjani.sridharan@linux.intel.com>
> > > > Co-developed-by: Fred Oh <fred.oh@linux.intel.com>
> > > > Co-developed-by: Leon Romanovsky <leonro@nvidia.com>
> > > > Signed-off-by: Kiran Patil <kiran.patil@intel.com>
> > > > Signed-off-by: Ranjani Sridharan <
> > > > ranjani.sridharan@linux.intel.com>
> > > > Signed-off-by: Fred Oh <fred.oh@linux.intel.com>
> > > > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> > > > Signed-off-by: Dave Ertman <david.m.ertman@intel.com>
> > > > Reviewed-by: Pierre-Louis Bossart <
> > > > pierre-louis.bossart@linux.intel.com>
> > > > Reviewed-by: Shiraz Saleem <shiraz.saleem@intel.com>
> > > > Reviewed-by: Parav Pandit <parav@mellanox.com>
> > > > Reviewed-by: Dan Williams <dan.j.williams@intel.com>
> > > > Reviewed-by: Martin Habets <mhabets@solarflare.com>
> > > > Link: 
> > > > https://lore.kernel.org/r/20201113161859.1775473-2-david.m.ertman@intel.com
> > > > Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> > > > ---
> > > > This patch is "To:" the maintainers that have a pending backlog
> > > > of
> > > > driver updates dependent on this facility, and "Cc:" Greg.
> > > > Greg, I
> > > > understand you have asked for more time to fully review this
> > > > and apply
> > > > it to driver-core.git, likely for v5.12, but please consider
> > > > Acking it
> > > > for v5.11 instead. It looks good to me and several other
> > > > stakeholders.
> > > > Namely, stakeholders that have pressure building up behind this
> > > > facility
> > > > in particular Mellanox RDMA, but also SOF, Intel Ethernet, and
> > > > later on
> > > > Compute Express Link.
> > > > 
> > > > I will take the blame for the 2 months of silence that made
> > > > this awkward
> > > > to take through driver-core.git, but at the same time I do not
> > > > want to
> > > > see that communication mistake inconvenience other parties that
> > > > reasonably thought this was shaping up to land in v5.11.
> > > > 
> > > > I am willing to host this version at:
> > > > 
> > > > git://git.kernel.org/pub/scm/linux/kernel/git/djbw/linux
> > > > tags/auxiliary-bus-for-5.11
> > > > 
> > > > ...for all the independent drivers to have a common commit
> > > > baseline. It
> > > > is not there yet pending Greg's Ack.
> > > > 
> > > > For example implementations incorporating this patch, see Dave
> > > > Ertman's
> > > > SOF series:
> > > > 
> > > > https://lore.kernel.org/r/20201113161859.1775473-2-david.m.ertman@intel.com
> > > > 
> > > > ...and Leon's mlx5 series:
> > > > 
> > > > http://lore.kernel.org/r/20201026111849.1035786-1-leon@kernel.org
> > > > 
> > > > PS: Greg I know I promised some review on newcomer patches to
> > > > help with
> > > > your queue, unfortunately Intel-internal review is keeping my
> > > > plate
> > > > full. Again, I do not want other stakeholder to be waiting on
> > > > me to
> > > > resolve that backlog.
> > > 
> > > Ok, I spent some hours today playing around with this.  I wrote
> > > up a
> > > small test-patch for this (how did anyone test this thing???).
> > 
> > We are running all verifications tests that we have over our
> > mlx5 driver. It includes devices reloads, power failures, FW
> > reconfiguration to emulate different devices with and without error
> > injections and many more. Up till now, no new bugs that are not
> > known
> > to us were found.
> 
> Yes, sorry, I was implying that the authors here had to create _some_
> code to test this with, it would have been nice to include that as
> well
> here.  We are collecting more and more in-kernel tests, having one
> for
> this code would be nice to also have so we make sure not to break any
> functionality in the future.

Hi Greg,

Thanks for your patience with this series. The v4 version submitted by
Dave included the SOF usage code to demonstrate the usage. We have run
all tests for device registration, module reload, PM etc and have not
observed any regressions in the SOF audio driver.

Thanks,
Ranjani

