Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D71CA3C6997
	for <lists+netdev@lfdr.de>; Tue, 13 Jul 2021 07:01:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232122AbhGMFEY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Jul 2021 01:04:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:41530 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229470AbhGMFEX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Jul 2021 01:04:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3BE7260725;
        Tue, 13 Jul 2021 05:01:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626152494;
        bh=pi3/8CoqzjVtefalb1lWMBNyAW91jVNorghWkKWho4Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EqaYF2N5sMlq0M0fk5mUicFGrE6aNAmXHAc2fMoL2DSv0gKGJ2/60bUYhr+1OQX8J
         8jsjHtpmgjqkCNQ0K59/TPvzZI+TjecAjGMpek0JQPn35c5Lo6z9N9CFzWxdasDR8U
         207WXhjs27NbxS7Z8XNNQUjJZuoto1O3YZNMDo+/lObOZ1LccEt/vmK4N+Ng7xMawH
         vf+Vz+Ybr8U211B6xEfeH71tSFQi5x0T+olygk3gNRRf/2HESt2q/mX/8yEfL8XSpT
         q2tvic72ShedZz/IOiSP/DHwFN/Z4ieixhGNdCJNbsTQJMo2KgeOZrS4U4OICgLquT
         2fbdSdrAsDzKw==
Date:   Tue, 13 Jul 2021 08:01:30 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Nitesh Lal <nilal@redhat.com>
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        netdev@vger.kernel.org, linux-api@vger.kernel.org,
        linux-pci@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Ingo Molnar <mingo@kernel.org>, jbrandeb@kernel.org,
        frederic@kernel.org, Juri Lelli <juri.lelli@redhat.com>,
        Alex Belits <abelits@marvell.com>,
        Bjorn Helgaas <bhelgaas@google.com>, rostedt@goodmis.org,
        peterz@infradead.org, davem@davemloft.net,
        akpm@linux-foundation.org, sfr@canb.auug.org.au,
        stephen@networkplumber.org, rppt@linux.vnet.ibm.com,
        chris.friesen@windriver.com, Marc Zyngier <maz@kernel.org>,
        Neil Horman <nhorman@tuxdriver.com>, pjwaskiewicz@gmail.com,
        Stefan Assmann <sassmann@redhat.com>,
        Tomas Henzl <thenzl@redhat.com>, kashyap.desai@broadcom.com,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        shivasharan.srikanteshwara@broadcom.com,
        sathya.prakash@broadcom.com,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        suganath-prabu.subramani@broadcom.com, james.smart@broadcom.com,
        dick.kennedy@broadcom.com, Ken Cox <jkc@redhat.com>,
        faisal.latif@intel.com, shiraz.saleem@intel.com, tariqt@nvidia.com,
        Alaa Hleihel <ahleihel@redhat.com>,
        Kamal Heib <kheib@redhat.com>, borisp@nvidia.com,
        saeedm@nvidia.com, benve@cisco.com, govind@gmx.com,
        jassisinghbrar@gmail.com, ajit.khaparde@broadcom.com,
        sriharsha.basavapatna@broadcom.com, somnath.kotur@broadcom.com,
        "Nikolova, Tatyana E" <tatyana.e.nikolova@intel.com>,
        "Ismail, Mustafa" <mustafa.ismail@intel.com>,
        Al Stone <ahs3@redhat.com>
Subject: Re: [PATCH v2 00/14] genirq: Cleanup the usage of
 irq_set_affinity_hint
Message-ID: <YO0eKv2GJcADQTHH@unreal>
References: <20210629152746.2953364-1-nitesh@redhat.com>
 <CAFki+LnUGiEE-7Uf-x8-TQZYZ+3Migrr=81gGLYszxaK-6A9WQ@mail.gmail.com>
 <YOrWqPYPkZp6nRLS@unreal>
 <CAFki+L=FYOTQ1+-MHWmTuA6ZxTUcZA9t41HRL2URYgv03oFbDg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFki+L=FYOTQ1+-MHWmTuA6ZxTUcZA9t41HRL2URYgv03oFbDg@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 12, 2021 at 05:27:05PM -0400, Nitesh Lal wrote:
> Hi Leon,
> 
> On Sun, Jul 11, 2021 at 7:32 AM Leon Romanovsky <leonro@nvidia.com> wrote:
> >
> > On Thu, Jul 08, 2021 at 03:24:20PM -0400, Nitesh Lal wrote:
> > > On Tue, Jun 29, 2021 at 11:28 AM Nitesh Narayan Lal <nitesh@redhat.com> wrote:
> >
> > <...>
> >
> > > >
> > > >  drivers/infiniband/hw/i40iw/i40iw_main.c      |  4 +-
> > > >  drivers/mailbox/bcm-flexrm-mailbox.c          |  4 +-
> > > >  drivers/net/ethernet/cisco/enic/enic_main.c   |  8 +--
> > > >  drivers/net/ethernet/emulex/benet/be_main.c   |  4 +-
> > > >  drivers/net/ethernet/huawei/hinic/hinic_rx.c  |  4 +-
> > > >  drivers/net/ethernet/intel/i40e/i40e_main.c   |  8 +--
> > > >  drivers/net/ethernet/intel/iavf/iavf_main.c   |  8 +--
> > > >  drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 10 ++--
> > > >  drivers/net/ethernet/mellanox/mlx4/eq.c       |  8 ++-
> > > >  .../net/ethernet/mellanox/mlx5/core/pci_irq.c |  6 +--
> > > >  drivers/scsi/lpfc/lpfc_init.c                 |  4 +-
> > > >  drivers/scsi/megaraid/megaraid_sas_base.c     | 27 +++++-----
> > > >  drivers/scsi/mpt3sas/mpt3sas_base.c           | 21 ++++----
> > > >  include/linux/interrupt.h                     | 53 ++++++++++++++++++-
> > > >  kernel/irq/manage.c                           |  8 +--
> > > >  15 files changed, 113 insertions(+), 64 deletions(-)
> > > >
> > > > --
> > > >
> > > >
> > >
> > > Gentle ping.
> > > Any comments or suggestions on any of the patches included in this series?
> >
> > Please wait for -rc1, rebase and resend.
> > At least i40iw was deleted during merge window.
> >
> 
> In -rc1 some non-trivial mlx5 changes also went in.  I was going through
> these changes and it seems after your patch
> 
> e4e3f24b822f: ("net/mlx5: Provide cpumask at EQ creation phase")
> 
> we do want to control the affinity for the mlx5 interrupts from the driver.
> Is that correct? 

We would like to create devices with correct affinity from the
beginning. For this, we will introduce extension to devlink to control
affinity that will be used prior initialization sequence.

Currently, netdev users who don't want irqbalance are digging into
their procfs, reconfigure affinity on already existing devices and
hope for the best. 

This is even more cumbersome for the SIOV use case, where every physical
NIC PCI device will/can create thousands of lightweights netdevs that will
be forwarded to the containers later. These containers are limited to known
CPU cores, so no reason do not limit netdev device too.

The same goes for other sub-functions of that PCI device, like RDMA,
vdpa e.t.c.

> This would mean that we should use irq_set_affinity_and_hint() instead
> of irq_update_affinity_hint().

I think so.

Thanks

> 
> -- 
> Thanks
> Nitesh
> 
