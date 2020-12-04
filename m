Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 003A82CEE1C
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 13:34:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729965AbgLDMea (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 07:34:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:50008 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725852AbgLDMe3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Dec 2020 07:34:29 -0500
Date:   Fri, 4 Dec 2020 13:35:05 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1607085228;
        bh=zmxko2CBQcTrRimzgblGXja5H1EAFSbtho5hMRphqPo=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=EAiA0/sN4gEYu8wNjWKaEjoBeLgLcEJvii/TTk5yXELcQpVmaMRZ3jjzJj+Fa394+
         4PQIHgB4q/CIwQLwNEnsVjn1OYMpq0QbndnuBw4uxM9E2NjGJC6v8XEo94sNO9N+5p
         bI5n+GCr5KOe1ypzoIF6T4f6BaOqnFts+L/3lVtU=
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Dan Williams <dan.j.williams@intel.com>
Cc:     broonie@kernel.org, lgirdwood@gmail.com, davem@davemloft.net,
        kuba@kernel.org, jgg@nvidia.com,
        Kiran Patil <kiran.patil@intel.com>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Fred Oh <fred.oh@linux.intel.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Dave Ertman <david.m.ertman@intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Shiraz Saleem <shiraz.saleem@intel.com>,
        Parav Pandit <parav@mellanox.com>,
        Martin Habets <mhabets@solarflare.com>,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: Re: [resend/standalone PATCH v4] Add auxiliary bus support
Message-ID: <X8os+X515fxeqefg@kroah.com>
References: <160695681289.505290.8978295443574440604.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160695681289.505290.8978295443574440604.stgit@dwillia2-desk3.amr.corp.intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 02, 2020 at 04:54:24PM -0800, Dan Williams wrote:
> From: Dave Ertman <david.m.ertman@intel.com>
> 
> Add support for the Auxiliary Bus, auxiliary_device and auxiliary_driver.
> It enables drivers to create an auxiliary_device and bind an
> auxiliary_driver to it.
> 
> The bus supports probe/remove shutdown and suspend/resume callbacks.
> Each auxiliary_device has a unique string based id; driver binds to
> an auxiliary_device based on this id through the bus.
> 
> Co-developed-by: Kiran Patil <kiran.patil@intel.com>
> Co-developed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
> Co-developed-by: Fred Oh <fred.oh@linux.intel.com>
> Co-developed-by: Leon Romanovsky <leonro@nvidia.com>
> Signed-off-by: Kiran Patil <kiran.patil@intel.com>
> Signed-off-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
> Signed-off-by: Fred Oh <fred.oh@linux.intel.com>
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> Signed-off-by: Dave Ertman <david.m.ertman@intel.com>
> Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
> Reviewed-by: Shiraz Saleem <shiraz.saleem@intel.com>
> Reviewed-by: Parav Pandit <parav@mellanox.com>
> Reviewed-by: Dan Williams <dan.j.williams@intel.com>
> Reviewed-by: Martin Habets <mhabets@solarflare.com>
> Link: https://lore.kernel.org/r/20201113161859.1775473-2-david.m.ertman@intel.com
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
> This patch is "To:" the maintainers that have a pending backlog of
> driver updates dependent on this facility, and "Cc:" Greg. Greg, I
> understand you have asked for more time to fully review this and apply
> it to driver-core.git, likely for v5.12, but please consider Acking it
> for v5.11 instead. It looks good to me and several other stakeholders.
> Namely, stakeholders that have pressure building up behind this facility
> in particular Mellanox RDMA, but also SOF, Intel Ethernet, and later on
> Compute Express Link.
> 
> I will take the blame for the 2 months of silence that made this awkward
> to take through driver-core.git, but at the same time I do not want to
> see that communication mistake inconvenience other parties that
> reasonably thought this was shaping up to land in v5.11.
> 
> I am willing to host this version at:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/djbw/linux tags/auxiliary-bus-for-5.11
> 
> ...for all the independent drivers to have a common commit baseline. It
> is not there yet pending Greg's Ack.

Here is now a signed tag for everyone else to pull from and build on top
of, for 5.11-rc1, that includes this patch, and the 3 others I sent in
this series.

Please let me know if anyone has any problems with this tag.  I'll keep
it around until 5.11-rc1 is released, after which it doesn't make any
sense to be there.

thanks,

greg k-h

---------------

The following changes since commit f8394f232b1eab649ce2df5c5f15b0e528c92091:

  Linux 5.10-rc3 (2020-11-08 16:10:16 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/driver-core.git tags/auxbus-5.11-rc1

for you to fetch changes up to 0d2bf11a6b3e275a526b8d42d8d4a3a6067cf953:

  driver core: auxiliary bus: minor coding style tweaks (2020-12-04 13:30:59 +0100)

----------------------------------------------------------------
Auxiliary Bus support tag for 5.11-rc1

This is a signed tag for other subsystems to be able to pull in the
auxiliary bus support into their trees for the 5.11-rc1 merge.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Dave Ertman (1):
      Add auxiliary bus support

Greg Kroah-Hartman (3):
      driver core: auxiliary bus: move slab.h from include file
      driver core: auxiliary bus: make remove function return void
      driver core: auxiliary bus: minor coding style tweaks

 Documentation/driver-api/auxiliary_bus.rst | 234 ++++++++++++++++++++++++
 Documentation/driver-api/index.rst         |   1 +
 drivers/base/Kconfig                       |   3 +
 drivers/base/Makefile                      |   1 +
 drivers/base/auxiliary.c                   | 274 +++++++++++++++++++++++++++++
 include/linux/auxiliary_bus.h              |  77 ++++++++
 include/linux/mod_devicetable.h            |   8 +
 scripts/mod/devicetable-offsets.c          |   3 +
 scripts/mod/file2alias.c                   |   8 +
 9 files changed, 609 insertions(+)
 create mode 100644 Documentation/driver-api/auxiliary_bus.rst
 create mode 100644 drivers/base/auxiliary.c
 create mode 100644 include/linux/auxiliary_bus.h
