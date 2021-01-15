Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 670952F7047
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 02:58:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731772AbhAOB5P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 20:57:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731750AbhAOB5O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 20:57:14 -0500
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0304C061575;
        Thu, 14 Jan 2021 17:56:32 -0800 (PST)
Received: by mail-io1-xd36.google.com with SMTP id e22so15311626iom.5;
        Thu, 14 Jan 2021 17:56:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dLQgjGVMgCuMvWDTRLIplUZNmGbHvmNs6PLF0FnXzH4=;
        b=FiFoTww9JBNCJ+16PrzNWPNXo2XYlkhc/l91jTRxS96o7ApW1qKNsFcTEl6VjeyX8B
         T5VKku/hCV0c+iwSiyaZFApDdR5vNm2B7rFrIzgrZp2jbUNSae4lVTUUNu7xlWi9aAcp
         f7sTbUWasGWp1Ura3cUdbPheyyeaoRsXQycIdYLZM5ABNgNtV42+XK8q7/WTihQ1eQDk
         GuhXgAdCpE85nK7T9kqhhwJONKZl/oth9MuEqiW+DhrREhWfLYkHYqHV+Do+eZGku7gp
         6TJ7DJWCPdJp5E60V05Vg9rFWw42KDAq58tVNjQGl6SIZJ5bhnnRh8+i8ObUdeD61fpd
         8oLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dLQgjGVMgCuMvWDTRLIplUZNmGbHvmNs6PLF0FnXzH4=;
        b=qyrKM6HOrkaCyWe3A/97e/qGSUF3iU0mEGwICCYcDRT6pT3ephmr4++XF1mznPmM9o
         JY0yCvOAJ/v5RTYiLY1UADeJkQA3pdukldZjUHX0mgZBWVLam45ksS2O/H9fGpVXSG9D
         gcBQdGSuBwLNbz13nvmZ6SrcKNCGYfpKW/9LBNK3hr09U8IU3Z1nTntladGtrWed8rGr
         /x3lWayC6ZVRgmXGCl8nizZshEv7c0l3NzcJJZH8OnsV06j6lNCsXkWbqS4ukVLEu66e
         I5BMlnZm+37jrTK5dCqmmHX9XseKse1OSMw/oOCJsOseSVB0hwXJ/FNR8zdvdXcZ3atp
         34ig==
X-Gm-Message-State: AOAM533AjHreOaz8gUPjQd6Ohb7I3JzRohOOhH3iY++RsYsth62xEW1N
        n1/bG1HVk7BgjhPrgs2Df78uEdZfIiCx+xEfBBczTm/4BymdNA==
X-Google-Smtp-Source: ABdhPJzqAQKYjpW93mTO9pMMIut/3o3yuhFfsXC+F04f2LYfC3bDmnSPLa6Pf0MwsKuugupERxR7/x9WnQxSii6c2qc=
X-Received: by 2002:a92:d592:: with SMTP id a18mr9019448iln.64.1610675791762;
 Thu, 14 Jan 2021 17:56:31 -0800 (PST)
MIME-Version: 1.0
References: <20210112065601.GD4678@unreal> <CAKgT0UdndGdA3xONBr62hE-_RBdL-fq6rHLy0PrdsuMn1936TA@mail.gmail.com>
 <20210113061909.GG4678@unreal> <CAKgT0Uc4v54vqRVk_HhjOk=OLJu-20AhuBVcg7=C9_hsLtzxLA@mail.gmail.com>
 <20210114065024.GK4678@unreal> <CAKgT0UeTXMeH24L9=wsPc2oJ=ZJ5jSpJeOqiJvsB2J9TFRFzwQ@mail.gmail.com>
 <20210114164857.GN4147@nvidia.com> <CAKgT0UcKqt=EgE+eitB8-u8LvxqHBDfF+u2ZSi5urP_Aj0Btvg@mail.gmail.com>
 <20210114182945.GO4147@nvidia.com> <CAKgT0UcQW+nJjTircZAYs1_GWNrRud=hSTsphfVpsc=xaF7aRQ@mail.gmail.com>
 <20210114200825.GR4147@nvidia.com> <CAKgT0UcaRgY4XnM0jgWRvwBLj+ufiabFzKPyrf3jkLrF1Z8zEg@mail.gmail.com>
 <20210114162812.268d684a@omen.home.shazbot.org>
In-Reply-To: <20210114162812.268d684a@omen.home.shazbot.org>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Thu, 14 Jan 2021 17:56:20 -0800
Message-ID: <CAKgT0Ufe1w4PpZb3NXuSxug+OMcjm1RP3ZqVrJmQqBDt3ByOZQ@mail.gmail.com>
Subject: Re: [PATCH mlx5-next v1 2/5] PCI: Add SR-IOV sysfs entry to read
 number of MSI-X vectors
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-pci <linux-pci@vger.kernel.org>,
        linux-rdma@vger.kernel.org, Netdev <netdev@vger.kernel.org>,
        Don Dutile <ddutile@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 14, 2021 at 3:28 PM Alex Williamson
<alex.williamson@redhat.com> wrote:
>
> On Thu, 14 Jan 2021 13:43:57 -0800
> Alexander Duyck <alexander.duyck@gmail.com> wrote:
>
> > On Thu, Jan 14, 2021 at 12:08 PM Jason Gunthorpe <jgg@nvidia.com> wrote:
> > >
> > > On Thu, Jan 14, 2021 at 11:24:12AM -0800, Alexander Duyck wrote:
> > >
> > > > > As you say BAR and MSI vector table are not so different, it seems
> > > > > perfectly in line with current PCI sig thinking to allow resizing the
> > > > > MSI as well
> > > >
> > > > The resizing of a BAR has an extended capability that goes with it and
> > > > isn't something that the device can just do on a whim. This patch set
> > > > is not based on implementing some ECN for resizable MSI-X tables. I
> > > > view it as arbitrarily rewriting the table size for a device after it
> > > > is created.
> > >
> > > The only difference is resizing the BAR is backed by an ECN, and this
> > > is an extension. The device does not "do it on a whim" the OS tells it
> > > when to change the size, exactly like for BAR resizing.
> > >
> > > > In addition Leon still hasn't answered my question on preventing the
> > > > VF driver from altering entries beyond the ones listed in the table.
> > >
> > > Of course this is blocked, the FW completely revokes the HW resource
> > > backing the vectors.
> >
> > One of the troubles with this is that I am having to take your word
> > for it. The worst case scenario in my mind is that this is just was
> > Leon described it earlier and the firmware interface is doing nothing
> > more than altering the table size in the MSI-X config space so that
> > the value can be picked up by VFIO and advertised to the guest. In
> > such a situation you end up opening up a backdoor as now there are
> > vectors that could be configured by userspace since the protections
> > provided by VFIO are disabled as you could be reporting a size that is
> > smaller than the actual number or vectors.
>
> This is why we have interrupt remappers.  We gave up trying to actually
> prevent vfio users from having access to write the MSI-X vector table,
> there are too many backdoors and page-size issues that this is
> impractical.  Instead we rely on interrupt remappers or equivalent
> IOMMU hardware to make sure that a device can only signal the interrupts
> we've programmed, which occurs via vfio ioctls making use of the MSI-X
> capability information.  So if vfio thinks the limit is lower than
> actually implemented in the vector table, the user shouldn't be able to
> do anything with the extra vectors anyway.
>
> Regarding the read-only nature of the MSI-X capability, would it help
> if this interface posted a value which was enabled on FLR of the VF?
> I think that would be legal relative to the spec, so really we're
> talking about the semantics of whether we really need those a device
> reset to change the value report in a read-only field.

I realized this kind of got derailed when we started arguing about the
MSI-X table size. I am okay with the table size changing, however I am
still not a fan of the VF driver having to probe the PF driver to do
so. I really think it would work much better the other way around with
the PF having to probe the VF.

That said, it only works at the driver level. So if the firmware is
the one that is having to do this it also occured to me that if this
update happened on FLR that would probably be preferred. Specifically
if it were tied in with the devlink resources interface I think it
would be a good fit for this issue as you could have a global pool of
vf-interrupt resources that are distributed though individual
subresources where each subresource would indicate an individual VF.
In addition the resources functionality for devlink has the concept of
a posted update where changes do not apply immediately if they cannot
be updated until some event occurs such as an FLR.

Since the mlx5 already supports devlink I don't see any reason why the
driver couldn't be extended to also support the devlink resource
interface and apply it to interrupts.

> > These are the kind of things I am worried about with this interface.
> > It just seems like this is altering the VF PCIe device config to
> > address an issue that would be better handled by the vfio interface
> > ath VM creation time. At least if this was left to vfio it could
> > prevent the VM from being able to access the unused entries and just
> > limit the guest to the ones that we want to have the VM access.
> > Instead we are just being expected to trust the firmware for security
> > from the VF should it decide to try and be malicious.
>
> It is possible for vfio to fake the MSI-X capability and limit what a
> user can access, but I don't think that's what is being done here.

Yeah, I am assuming that is what is being done here. However some of
the things Leon said gave me pause when he made a comment earlier that
it was just updating the MSI-X config. That may not have been what he
meant, but what worries me is an interface like this sets up things
for something like that in the future where someone decides to
short-cut the interface.

> There was a previous comment that the goal is actually to expand the
> number of MSI-X vectors for some devices.  vfio can't do that.  That
> requires interaction and coordination with a PF driver managing a pool
> of resources where we might require not only device ownership, but host
> administrative privileges to prevent a user exhausting the pool.  That's
> not ioctl material for vfio.

In this case the PF driver isn't really managing that, it is the
firmware. Basically it is an entity outside the kernel as the PF
doesn't even have control over its own resources, it is the firmware
that decides what it gets. Thus why the mlx5 driver is apparently at
the mercy of the MSI-X table size to determine how many interrupts it
can actually have.. :)

> > > > From what I can tell, the mlx5 Linux driver never reads the MSI-X
> > > > flags register so it isn't reading the MSI-X size either.
> > >
> > > I don't know why you say that. All Linux drivers call into something
> > > like pci_alloc_irq_vectors() requesting a maximum # of vectors and
> > > that call returns the actual allocated. Drivers can request more
> > > vectors than the system provides, which is what mlx5 does.
> > >
> > > Under the call chain of pci_alloc_irq_vectors() it calls
> > > pci_msix_vec_count() which does
> > >
> > >         pci_read_config_word(dev, dev->msix_cap + PCI_MSIX_FLAGS, &control);
> > >         return msix_table_size(control);
> > >
> > > And eventually uses that to return the result to the driver.
> > >
> > > So, yes, it reads the config space and ensures it doesn't allocate
> > > more vectors than that.
> > >
> > > Every driver using MSI does this in Linux.
> > >
> > > Adjusting config space *directly* limits the number of vectors the
> > > driver allocates.
> > >
> > > You should be able to find the call chain in mlx5 based on the above
> > > guidance.
> >
> > Yes, but at the same time you also end up passing a max_vecs into the
> > function as you have multiple limitations that come into account from
> > both the driver, the system, and the table. The MSI-X table size is
> > just one piece. Specifically the bit in the code for the mlx5 driver
> > is:
> >
> > nvec = MLX5_CAP_GEN(dev, num_ports) * num_online_cpus() +
> >       MLX5_IRQ_VEC_COMP_BASE;
> > nvec = min_t(int, nvec, num_eqs);
> >
> > So saying that the MSI-X table size is what defines the number of
> > interrupts you can use is only partially true. What it defines is the
> > aperture available in MMIO to define the possible addresses and values
> > to be written to trigger the interrupts. The device itself plays a
> > large role in defining the number of interrupts ultimately requested.
> >
> > > > At a minimum I really think we need to go through and have a clear
> > > > definition on when updating the MSI-X table size is okay and when it
> > > > is not. I am not sure just saying to not update it when a driver isn't
> > > > attached is enough to guarantee all that.
> > >
> > > If you know of a real issue then please state it, other don't fear
> > > monger "maybe" issues that don't exist.
> >
> > Well I don't have visibility into your firmware so I am not sure what
> > is going on in response to this command so forgive me when I do a bit
> > of fear mongering when somebody tells me that all this patch set does
> > is modify the VF configuration space.
> >
> > As I have said my main concern is somebody really screwing something
> > like this up and creating a security vulnerability where they do
> > something exactly like updating just the MSI-X table size without
> > protecting the MMIO region that contains the remaining MSI-X table
> > entries. This is why I would be much more comfortable with something
> > like a vfio ioctl that says that while the device supports the number
> > reported in the MSI-X table size the vfio will only present some
> > subset of those entries to the guest. With that I could at least
> > review the code and verify that it is providing the expected
> > protections.
>
> We put a lot of trust in VF firmware otherwise, perhaps too much, but I
> don't see how this is outside of how we already trust VFs.  MSIs are
> just a DMA write, users don't need to use the vector table to make
> devices perform arbitrary DMA writes.  If we trust VF firmware to
> signal MSIs with the VF RID, then the IOMMU should provide protection.

Agreed. The IOMMU should take care of this. I'm not a fan of the
dynamic table resizing, however I can live with it. The one part that
is a hard no for me is the VF sysfs file. I would much rather see this
managed through the Devlink Resource interface.
https://www.kernel.org/doc/html/latest/networking/devlink/devlink-resource.html

That combined with the update taking place on FLR would likely be a
perfect fit in my eyes.

> > > > What we are talking about is the MSI-X table size. Not the number of
> > > > MSI-X vectors being requested by the device driver. Those are normally
> > > > two seperate things.
> > >
> > > Yes, table size is what is critical. The number of entries in that BAR
> > > memory is what needs to be controlled.
> >
> > That is where we disagree. My past experience is that in the device
> > you have to be able to associate an interrupt cause to an interrupt
> > vector. Normally as a part of that the device itself will place some
> > limit on how many causes and vectors you can associate before you even
> > get to the MSI-X table. The MSI-X table size is usually a formality
> > that defines the upper limit on the number of entries the device might
> > request. The reason why most drivers don't bother asking for it or
> > reading it is because it is defined early as a part of the definition
> > of the device itself.
> >
> > Going back to my earlier example I am not going to size a MSI-X table
> > at 2048 for a device that only has a few interrupt sources. Odds are I
> > would size it such that I will have enough entries in the table to
> > cover all my interrupt sources. Usually the limiting factor for an
> > MSI-X request is the system itself as too many devices requesting a
> > large number of interrupts may end up eating up all the vectors
> > available for a given CPU.
> >
> > > > > The standards based way to communicate that limit is the MSI table cap
> > > > > size.
> > > >
> > > > This only defines the maximum number of entries, not how many have to be used.
> > >
> > > A driver can't use entries beyond the cap. We are not trying to
> > > reclaim vectors that are available but not used by the OS.
> >
> > The MSI-X table consists of a MMIO region in one of the BARs on the
> > device. It is easily possible to code something up in a driver that
> > would go in and be able to access the region. Most sensible devices
> > place it in a separate BAR but even then you have to worry about them
> > possibly sharing the memory region internally among several devices.
> >
> > The big thing I see as an issue with all this is that arbitrarily
> > reducing the size of the MSI-X table doesn't have any actual effect on
> > the MMIO resources. They are still there. So a bad firmware doing
> > something like reducing the table size without also restricting access
> > to the resources in the BAR potentially opens up a security hole as
> > the MSI-X vector is really nothing more than a pre-programmed PCIe
> > write waiting for something to trigger it. Odds are an IOMMU would
> > block it, but still not necessarily a good thing.
>
> Exactly, it's nothing more than a DMA write, which a malicious user can
> trigger the device to perform in other ways if not through the vector
> table.  We rely on the IOMMU for protection.

I'm just not a fan of opening up more vectors, but as I said above I
would be willing to concede this part of the argument since it seems
like the mlx5 programming model requires the MSI-X table size to match
the limit.

> > As such my preference would be to leave the MSI-X table size static at
> > the size of possible vectors that could be modified, and instead have
> > the firmware guarantee that writing to those registers has no effect.
> > Then when you do something like a direct assignment vfio_pci will also
> > guard that region of MMIO instead of only guarding a portion of it.
> >
> > > > I'm not offering up a non-standard way to do this. Just think about
> > > > it. If I have a device that defines an MSI-X table size of 2048 but
> > > > makes use of only one vector how would that be any different than what
> > > > I am suggesting where you size your VF to whatever the maximum is you
> > > > need but only make use of some fixed number from the hardware.
> > >
> > > That is completely different, in the hypervisor there is no idea how
> > > many vectors a guest OS will create. The FW is told to only permit 1
> > > vector. How is the guest to know this if we don't update the config
> > > space *as the standard requires* ?
> >
> > Doesn't the guest driver talk to the firmware? Last I knew it had to
> > request additional resources such as queues and those come from the
> > firmware don't they?
> >
> > > > I will repeat what I said before. Why can't this be handled via the
> > > > vfio interface?
> > >
> > > 1) The FW has to be told of the limit and everything has to be in sync
> > >    If the FW is out of sync with the config space then everything
> > >    breaks if the user makes even a small mistake - for instance
> > >    forgetting to use the ioctl to override vfio. This is needlessly
> > >    frail and complicated.
> >
> > That is also the way I feel about the sysfs solution.
> >
> > I just see VFIO making the call to the device to notify it that it
> > only needs X number of vectors instead of having the VF sysfs doing
> > it.
>
> Where does this occur?  As above, the device owner shouldn't
> necessarily have privileges to exhaust the entire PF of vectors.  Are
> we really going to go to the trouble of creating cgroups for MSI-X
> vectors?  Reducing vectors through emulation is easy, but that's only a
> partial solution to the goal here I think.  Thanks,
>
> Alex

In my mind this would have been in response to having an ioctl call
come down indicating that we want to limit the number of MSI-X vectors
to some value. Keep in mind that also in this model I was suggesting
that the device just advertise whatever the maximum MSI-X table size
could be for the VF. So we would only ever be shrinking the device,
not growing it.

I was just kind of thinking that something like this might have uses
outside of the mlx5 case as I seem to recall, and not my memory could
be faulty, that there were some OSes such as Windows that would do the
kind of setup where it would allocate as many vectors as a device
could handle when the CPU count got high. In such a VM it might be
useful to have an option for the hypervisor to override the MSI-X
table size and tell the OS that it cannot allocate asw many vectors.

Anyway I was just kind of wandering into solution space on this trying
to come up with an alternate solution. As I said the ideal solution
for me at this point would be to see the Devlink Resource interface be
used to assign the interrupts, and then apply the changes on FLR.
