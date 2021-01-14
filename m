Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BA7B2F6EF5
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 00:30:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730999AbhANX3s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 18:29:48 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:47997 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730834AbhANX3s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 18:29:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610666900;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ViZ8l0DYo9h84obQz/IZRPxYDyMw1nBcgpmC9M7PNGg=;
        b=ixQLIK5NYyIrWa7QsfH4ebo2bCKUoYg8jYJHk2cfpNPYKCDiEphmftBhvjEUS+r2XBoIqr
        EzEAowPWsGDO3mTl6iXny1RKAU0sf9wItyiw/30Y3Wk4TNrUvrKwJm87pV6cfPPEqYHknu
        HlnNna0KXKIFNFKrEp2/xorDTb5odL0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-188-plygUR_eOFyb2kJApSFILw-1; Thu, 14 Jan 2021 18:28:16 -0500
X-MC-Unique: plygUR_eOFyb2kJApSFILw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7FBDE107ACF7;
        Thu, 14 Jan 2021 23:28:14 +0000 (UTC)
Received: from omen.home.shazbot.org (ovpn-112-255.phx2.redhat.com [10.3.112.255])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B258D5C1A3;
        Thu, 14 Jan 2021 23:28:13 +0000 (UTC)
Date:   Thu, 14 Jan 2021 16:28:12 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-pci <linux-pci@vger.kernel.org>,
        linux-rdma@vger.kernel.org, Netdev <netdev@vger.kernel.org>,
        Don Dutile <ddutile@redhat.com>
Subject: Re: [PATCH mlx5-next v1 2/5] PCI: Add SR-IOV sysfs entry to read
 number of MSI-X vectors
Message-ID: <20210114162812.268d684a@omen.home.shazbot.org>
In-Reply-To: <CAKgT0UcaRgY4XnM0jgWRvwBLj+ufiabFzKPyrf3jkLrF1Z8zEg@mail.gmail.com>
References: <20210112065601.GD4678@unreal>
        <CAKgT0UdndGdA3xONBr62hE-_RBdL-fq6rHLy0PrdsuMn1936TA@mail.gmail.com>
        <20210113061909.GG4678@unreal>
        <CAKgT0Uc4v54vqRVk_HhjOk=OLJu-20AhuBVcg7=C9_hsLtzxLA@mail.gmail.com>
        <20210114065024.GK4678@unreal>
        <CAKgT0UeTXMeH24L9=wsPc2oJ=ZJ5jSpJeOqiJvsB2J9TFRFzwQ@mail.gmail.com>
        <20210114164857.GN4147@nvidia.com>
        <CAKgT0UcKqt=EgE+eitB8-u8LvxqHBDfF+u2ZSi5urP_Aj0Btvg@mail.gmail.com>
        <20210114182945.GO4147@nvidia.com>
        <CAKgT0UcQW+nJjTircZAYs1_GWNrRud=hSTsphfVpsc=xaF7aRQ@mail.gmail.com>
        <20210114200825.GR4147@nvidia.com>
        <CAKgT0UcaRgY4XnM0jgWRvwBLj+ufiabFzKPyrf3jkLrF1Z8zEg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 14 Jan 2021 13:43:57 -0800
Alexander Duyck <alexander.duyck@gmail.com> wrote:

> On Thu, Jan 14, 2021 at 12:08 PM Jason Gunthorpe <jgg@nvidia.com> wrote:
> >
> > On Thu, Jan 14, 2021 at 11:24:12AM -0800, Alexander Duyck wrote:
> >  
> > > > As you say BAR and MSI vector table are not so different, it seems
> > > > perfectly in line with current PCI sig thinking to allow resizing the
> > > > MSI as well  
> > >
> > > The resizing of a BAR has an extended capability that goes with it and
> > > isn't something that the device can just do on a whim. This patch set
> > > is not based on implementing some ECN for resizable MSI-X tables. I
> > > view it as arbitrarily rewriting the table size for a device after it
> > > is created.  
> >
> > The only difference is resizing the BAR is backed by an ECN, and this
> > is an extension. The device does not "do it on a whim" the OS tells it
> > when to change the size, exactly like for BAR resizing.
> >  
> > > In addition Leon still hasn't answered my question on preventing the
> > > VF driver from altering entries beyond the ones listed in the table.  
> >
> > Of course this is blocked, the FW completely revokes the HW resource
> > backing the vectors.  
> 
> One of the troubles with this is that I am having to take your word
> for it. The worst case scenario in my mind is that this is just was
> Leon described it earlier and the firmware interface is doing nothing
> more than altering the table size in the MSI-X config space so that
> the value can be picked up by VFIO and advertised to the guest. In
> such a situation you end up opening up a backdoor as now there are
> vectors that could be configured by userspace since the protections
> provided by VFIO are disabled as you could be reporting a size that is
> smaller than the actual number or vectors.

This is why we have interrupt remappers.  We gave up trying to actually
prevent vfio users from having access to write the MSI-X vector table,
there are too many backdoors and page-size issues that this is
impractical.  Instead we rely on interrupt remappers or equivalent
IOMMU hardware to make sure that a device can only signal the interrupts
we've programmed, which occurs via vfio ioctls making use of the MSI-X
capability information.  So if vfio thinks the limit is lower than
actually implemented in the vector table, the user shouldn't be able to
do anything with the extra vectors anyway.

Regarding the read-only nature of the MSI-X capability, would it help
if this interface posted a value which was enabled on FLR of the VF?
I think that would be legal relative to the spec, so really we're
talking about the semantics of whether we really need those a device
reset to change the value report in a read-only field.

> These are the kind of things I am worried about with this interface.
> It just seems like this is altering the VF PCIe device config to
> address an issue that would be better handled by the vfio interface
> ath VM creation time. At least if this was left to vfio it could
> prevent the VM from being able to access the unused entries and just
> limit the guest to the ones that we want to have the VM access.
> Instead we are just being expected to trust the firmware for security
> from the VF should it decide to try and be malicious.

It is possible for vfio to fake the MSI-X capability and limit what a
user can access, but I don't think that's what is being done here.
There was a previous comment that the goal is actually to expand the
number of MSI-X vectors for some devices.  vfio can't do that.  That
requires interaction and coordination with a PF driver managing a pool
of resources where we might require not only device ownership, but host
administrative privileges to prevent a user exhausting the pool.  That's
not ioctl material for vfio.

> > > From what I can tell, the mlx5 Linux driver never reads the MSI-X
> > > flags register so it isn't reading the MSI-X size either.  
> >
> > I don't know why you say that. All Linux drivers call into something
> > like pci_alloc_irq_vectors() requesting a maximum # of vectors and
> > that call returns the actual allocated. Drivers can request more
> > vectors than the system provides, which is what mlx5 does.
> >
> > Under the call chain of pci_alloc_irq_vectors() it calls
> > pci_msix_vec_count() which does
> >
> >         pci_read_config_word(dev, dev->msix_cap + PCI_MSIX_FLAGS, &control);
> >         return msix_table_size(control);
> >
> > And eventually uses that to return the result to the driver.
> >
> > So, yes, it reads the config space and ensures it doesn't allocate
> > more vectors than that.
> >
> > Every driver using MSI does this in Linux.
> >
> > Adjusting config space *directly* limits the number of vectors the
> > driver allocates.
> >
> > You should be able to find the call chain in mlx5 based on the above
> > guidance.  
> 
> Yes, but at the same time you also end up passing a max_vecs into the
> function as you have multiple limitations that come into account from
> both the driver, the system, and the table. The MSI-X table size is
> just one piece. Specifically the bit in the code for the mlx5 driver
> is:
> 
> nvec = MLX5_CAP_GEN(dev, num_ports) * num_online_cpus() +
>       MLX5_IRQ_VEC_COMP_BASE;
> nvec = min_t(int, nvec, num_eqs);
> 
> So saying that the MSI-X table size is what defines the number of
> interrupts you can use is only partially true. What it defines is the
> aperture available in MMIO to define the possible addresses and values
> to be written to trigger the interrupts. The device itself plays a
> large role in defining the number of interrupts ultimately requested.
> 
> > > At a minimum I really think we need to go through and have a clear
> > > definition on when updating the MSI-X table size is okay and when it
> > > is not. I am not sure just saying to not update it when a driver isn't
> > > attached is enough to guarantee all that.  
> >
> > If you know of a real issue then please state it, other don't fear
> > monger "maybe" issues that don't exist.  
> 
> Well I don't have visibility into your firmware so I am not sure what
> is going on in response to this command so forgive me when I do a bit
> of fear mongering when somebody tells me that all this patch set does
> is modify the VF configuration space.
> 
> As I have said my main concern is somebody really screwing something
> like this up and creating a security vulnerability where they do
> something exactly like updating just the MSI-X table size without
> protecting the MMIO region that contains the remaining MSI-X table
> entries. This is why I would be much more comfortable with something
> like a vfio ioctl that says that while the device supports the number
> reported in the MSI-X table size the vfio will only present some
> subset of those entries to the guest. With that I could at least
> review the code and verify that it is providing the expected
> protections.

We put a lot of trust in VF firmware otherwise, perhaps too much, but I
don't see how this is outside of how we already trust VFs.  MSIs are
just a DMA write, users don't need to use the vector table to make
devices perform arbitrary DMA writes.  If we trust VF firmware to
signal MSIs with the VF RID, then the IOMMU should provide protection.

> > > What we are talking about is the MSI-X table size. Not the number of
> > > MSI-X vectors being requested by the device driver. Those are normally
> > > two seperate things.  
> >
> > Yes, table size is what is critical. The number of entries in that BAR
> > memory is what needs to be controlled.  
> 
> That is where we disagree. My past experience is that in the device
> you have to be able to associate an interrupt cause to an interrupt
> vector. Normally as a part of that the device itself will place some
> limit on how many causes and vectors you can associate before you even
> get to the MSI-X table. The MSI-X table size is usually a formality
> that defines the upper limit on the number of entries the device might
> request. The reason why most drivers don't bother asking for it or
> reading it is because it is defined early as a part of the definition
> of the device itself.
> 
> Going back to my earlier example I am not going to size a MSI-X table
> at 2048 for a device that only has a few interrupt sources. Odds are I
> would size it such that I will have enough entries in the table to
> cover all my interrupt sources. Usually the limiting factor for an
> MSI-X request is the system itself as too many devices requesting a
> large number of interrupts may end up eating up all the vectors
> available for a given CPU.
> 
> > > > The standards based way to communicate that limit is the MSI table cap
> > > > size.  
> > >
> > > This only defines the maximum number of entries, not how many have to be used.  
> >
> > A driver can't use entries beyond the cap. We are not trying to
> > reclaim vectors that are available but not used by the OS.  
> 
> The MSI-X table consists of a MMIO region in one of the BARs on the
> device. It is easily possible to code something up in a driver that
> would go in and be able to access the region. Most sensible devices
> place it in a separate BAR but even then you have to worry about them
> possibly sharing the memory region internally among several devices.
> 
> The big thing I see as an issue with all this is that arbitrarily
> reducing the size of the MSI-X table doesn't have any actual effect on
> the MMIO resources. They are still there. So a bad firmware doing
> something like reducing the table size without also restricting access
> to the resources in the BAR potentially opens up a security hole as
> the MSI-X vector is really nothing more than a pre-programmed PCIe
> write waiting for something to trigger it. Odds are an IOMMU would
> block it, but still not necessarily a good thing.

Exactly, it's nothing more than a DMA write, which a malicious user can
trigger the device to perform in other ways if not through the vector
table.  We rely on the IOMMU for protection.

> As such my preference would be to leave the MSI-X table size static at
> the size of possible vectors that could be modified, and instead have
> the firmware guarantee that writing to those registers has no effect.
> Then when you do something like a direct assignment vfio_pci will also
> guard that region of MMIO instead of only guarding a portion of it.
> 
> > > I'm not offering up a non-standard way to do this. Just think about
> > > it. If I have a device that defines an MSI-X table size of 2048 but
> > > makes use of only one vector how would that be any different than what
> > > I am suggesting where you size your VF to whatever the maximum is you
> > > need but only make use of some fixed number from the hardware.  
> >
> > That is completely different, in the hypervisor there is no idea how
> > many vectors a guest OS will create. The FW is told to only permit 1
> > vector. How is the guest to know this if we don't update the config
> > space *as the standard requires* ?  
> 
> Doesn't the guest driver talk to the firmware? Last I knew it had to
> request additional resources such as queues and those come from the
> firmware don't they?
> 
> > > I will repeat what I said before. Why can't this be handled via the
> > > vfio interface?  
> >
> > 1) The FW has to be told of the limit and everything has to be in sync
> >    If the FW is out of sync with the config space then everything
> >    breaks if the user makes even a small mistake - for instance
> >    forgetting to use the ioctl to override vfio. This is needlessly
> >    frail and complicated.  
> 
> That is also the way I feel about the sysfs solution.
> 
> I just see VFIO making the call to the device to notify it that it
> only needs X number of vectors instead of having the VF sysfs doing
> it.

Where does this occur?  As above, the device owner shouldn't
necessarily have privileges to exhaust the entire PF of vectors.  Are
we really going to go to the trouble of creating cgroups for MSI-X
vectors?  Reducing vectors through emulation is easy, but that's only a
partial solution to the goal here I think.  Thanks,

Alex

> > 2) VFIO needs to know how to tell the FW the limit so it can override
> >    the config space with emulation. This is all device specific and I
> >    don't see that adding an extension to vfio is any better than
> >    adding one here.  
> 
> So it depends on the setup. In my suggestion I was suggesting VFIO
> defines the maximum, not the minimum. So the guest would automatically
> know exactly how many it would have as the table size would be
> specified inside the guest.
> 
> > 3) VFIO doesn't cover any other driver that binds to the VF, so
> >    this "solution" leaves the normal mlx5_core functionally broken on
> >    VFs which is a major regression.
> >
> > Overall the entire idea to have the config space not reflect the
> > actual current device configuration seems completely wrong to me - why
> > do this? For what gain? It breaks everything.  
> 
> Your configuration is admittedly foreign to me as well. So if I am
> understanding correctly your limiting factor isn't the number of
> interrupt causes in the platform, but the firmware deciding to provide
> too few interrupt vectors in the MSI-X table. I'm just kind of
> surprised the firmware itself isn't providing some sort of messaging
> on the number of interrupt vectors that a given device has since I
> assume that it is already providing you with information on the number
> of queues and such since that isn't provided by any other mechanism.
> 

