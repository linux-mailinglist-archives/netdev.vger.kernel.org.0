Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 530412F6AE2
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 20:27:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730033AbhANTZE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 14:25:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726472AbhANTZE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 14:25:04 -0500
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D457FC061757;
        Thu, 14 Jan 2021 11:24:23 -0800 (PST)
Received: by mail-io1-xd30.google.com with SMTP id w18so13531427iot.0;
        Thu, 14 Jan 2021 11:24:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=js7HHq3LTad9ixc5DutSYP9XyZNdeih2UKdu5gNL9h0=;
        b=HlmdNZPvrNQsxTC7dWYJhiR0ilFFinkKe6L9YwnlN+UG4pA1XVLpHhY8XvaEIUm0O6
         VcJIIltOfSHclfVe//ECZUePE9RNbE4pAhVeSrCYddiWriHn7kzLxBkPmk8KMEG02Na/
         tyv2XE7leUxpDqsBcQ80M7yT6RBW7vwd+lq3uhKAyK+FRUjUtBy1u8MfYlFCmh8Dy/o6
         PO6tP2AiGJlsltW8j08NhX9SYJIOABu/hEMwSJRJ0naH8nufaX2yfqIb8evyime8yt8O
         Ea3a1GdckkjgEyjLkS+sxEzbyhY3JRF2NTqJZwTMIo70p/YlrL43uWO45IoLeOdq/aOT
         dpvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=js7HHq3LTad9ixc5DutSYP9XyZNdeih2UKdu5gNL9h0=;
        b=uZcpQTjU9+Jqsf0yh1Nk7azsYwhooo/v4QsqXba8P3eeM1Q2N0rNoRTzSzHqg55Yqr
         fqUHx2sGgEOLAzPCecbjeLD8tazxoYtRAils0zinOV75HpV902pnrV1vIHYHlmXNBQwF
         +gSOnvsmzJ2R+puG6J4wQwLI6OYE9aCHfe1Ijzgdnn0SX0c6VShKCSQCOrtEthSFhwd7
         K8i+r7XG+zu7e5jX4BuCC4hAvV2+wwF4rkhto6aLgsDH9YcrWj7Z/kAdafVZ5xfB+0LA
         LnucROZK/rZf8qurFNPkyDPj2YnT3ctrRrauvdDZQ+tdgVgIUo8M52Rtp0G3/TmXBqKK
         YvyA==
X-Gm-Message-State: AOAM530QpVvZEs1Tpx3M4b9O4CQe9aQSQna2LYk0zqjJbN3bM01O7uD9
        DP9HgIynMF6rghM0oEnzznnhlbMvYAh+gM3tvdc=
X-Google-Smtp-Source: ABdhPJyDW1WpMGNID5jiC/ILWZd6TbBwbMrkNWfqQezCULqQBWDwI8EBYAoutrvvIMiq4lx/TnshX7cBsAQKNz2YKLs=
X-Received: by 2002:a05:6638:204b:: with SMTP id t11mr1587495jaj.87.1610652263136;
 Thu, 14 Jan 2021 11:24:23 -0800 (PST)
MIME-Version: 1.0
References: <20210110150727.1965295-3-leon@kernel.org> <CAKgT0Uczu6cULPsVjFuFVmir35SpL-bs0hosbfH-T5sZLZ78BQ@mail.gmail.com>
 <20210112065601.GD4678@unreal> <CAKgT0UdndGdA3xONBr62hE-_RBdL-fq6rHLy0PrdsuMn1936TA@mail.gmail.com>
 <20210113061909.GG4678@unreal> <CAKgT0Uc4v54vqRVk_HhjOk=OLJu-20AhuBVcg7=C9_hsLtzxLA@mail.gmail.com>
 <20210114065024.GK4678@unreal> <CAKgT0UeTXMeH24L9=wsPc2oJ=ZJ5jSpJeOqiJvsB2J9TFRFzwQ@mail.gmail.com>
 <20210114164857.GN4147@nvidia.com> <CAKgT0UcKqt=EgE+eitB8-u8LvxqHBDfF+u2ZSi5urP_Aj0Btvg@mail.gmail.com>
 <20210114182945.GO4147@nvidia.com>
In-Reply-To: <20210114182945.GO4147@nvidia.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Thu, 14 Jan 2021 11:24:12 -0800
Message-ID: <CAKgT0UcQW+nJjTircZAYs1_GWNrRud=hSTsphfVpsc=xaF7aRQ@mail.gmail.com>
Subject: Re: [PATCH mlx5-next v1 2/5] PCI: Add SR-IOV sysfs entry to read
 number of MSI-X vectors
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Leon Romanovsky <leon@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-pci <linux-pci@vger.kernel.org>,
        linux-rdma@vger.kernel.org, Netdev <netdev@vger.kernel.org>,
        Don Dutile <ddutile@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 14, 2021 at 10:29 AM Jason Gunthorpe <jgg@nvidia.com> wrote:
>
> On Thu, Jan 14, 2021 at 09:55:24AM -0800, Alexander Duyck wrote:
> > On Thu, Jan 14, 2021 at 8:49 AM Jason Gunthorpe <jgg@nvidia.com> wrote:
> > >
> > > On Thu, Jan 14, 2021 at 08:40:14AM -0800, Alexander Duyck wrote:
> > >
> > > > Where I think you and I disagree is that I really think the MSI-X
> > > > table size should be fixed at one value for the life of the VF.
> > > > Instead of changing the table size it should be the number of vectors
> > > > that are functional that should be the limit. Basically there should
> > > > be only some that are functional and some that are essentially just
> > > > dummy vectors that you can write values into that will never be used.
> > >
> > > Ignoring the PCI config space to learn the # of available MSI-X
> > > vectors is big break on the how the device's programming ABI works.
> > >
> > > Or stated another way, that isn't compatible with any existing drivers
> > > so it is basically not a useful approach as it can't be deployed.
> > >
> > > I don't know why you think that is better.
> > >
> > > Jason
> >
> > First off, this is technically violating the PCIe spec section 7.7.2.2
> > because this is the device driver modifying the Message Control
> > register for a device, even if it is the PF firmware modifying the VF.
> > The table size is something that should be set and fixed at device
> > creation and not changed.
>
> The word "violating" is rather an over-reaction, at worst this is an
> extension.
>
> > The MSI-X table is essentially just an MMIO resource, and I believe it
> > should not be resized, just as you wouldn't expect any MMIO BAR to be
> > dynamically resized.
>
> Resizing the BAR is already defined see commit 276b738deb5b ("PCI:
> Add resizable BAR infrastructure")
>
> As you say BAR and MSI vector table are not so different, it seems
> perfectly in line with current PCI sig thinking to allow resizing the
> MSI as well

The resizing of a BAR has an extended capability that goes with it and
isn't something that the device can just do on a whim. This patch set
is not based on implementing some ECN for resizable MSI-X tables. I
view it as arbitrarily rewriting the table size for a device after it
is created.

In addition Leon still hasn't answered my question on preventing the
VF driver from altering entries beyond the ones listed in the table.
My concern is that this may just be glossing over things and
introducing potential issues in the process if a VF can access
resources that don't belong to it.

> > Many drivers don't make use of the full MSI-X table nor do they
> > bother reading the size. We just populate a subset of the table
> > based on the number of interrupt causes we will need to associate to
> > interrupt handlers.
>
> This isn't about "many drivers" this is about what mlx5 does in all
> the various OS drivers it has, and mlx5 has a sophisticated use of
> MSI-X.

Can you please cite an example for me? The problem here is you are
claiming things without any proof. I feel like the requirement for
changing the VF MSI-X table size is coming from something outside of
Linux and without having any info on that I cannot really understand
the issue this is trying to resolve.

From what I can tell, the mlx5 Linux driver never reads the MSI-X
flags register so it isn't reading the MSI-X size either.

> > What I see this patch doing is trying to push driver PF policy onto
> > the VF PCIe device configuration space dynamically.
>
> Huh? This is using the PF to dynamically reconfigure a child VF beyond
> what the PCI spec defined. This is done safely under Linux because no
> driver is bound when it is reconfigured, and any stale config data is
> flushed out of any OS caches.
>
> This is also why there is not a strong desire to standardize an ECN at
> PCI-sig, the rules for how resizing can work are complicated and OS
> specific.

At a minimum I really think we need to go through and have a clear
definition on when updating the MSI-X table size is okay and when it
is not. I am not sure just saying to not update it when a driver isn't
attached is enough to guarantee all that.

On top of that the interface as defined here is rather ugly. It is
just providing a sysfs front end for a vendor proprietary
circumvention of the fact that the MSI-X table size is read-only. If
we are going to do that we might as well allow any vendor that has a
backdoor to their PCIe config go through and edit it.

> > Having some limited number of interrupt causes should really be what
> > is limiting things here.
>
> MSI inherently requires dedicated on-die resources to implement, so
> every device has a maximum # of MSI vectors it can currently
> expose. This is some consequence of various PCI rules and applies to
> all devices.
>
> To make effective use of this limited pool requires a hard restriction
> enforced by the secure domain (hypervisor and FW) onto every
> user. Every driver attached to the function needs to be aware of the
> hard enforced limit by the secure domain to operate properly. It has
> nothing to do with "limited number of interrupt causes".

What we are talking about is the MSI-X table size. Not the number of
MSI-X vectors being requested by the device driver. Those are normally
two seperate things.

I can only assume you have some out-of-tree issue or some other OS
that is the problem. If you can describe the issue in more detail for
me we have something to work with. Otherwise the request so far seems
unreasonable to me.

> The standards based way to communicate that limit is the MSI table cap
> size.

This only defines the maximum number of entries, not how many have to be used.

> To complain that changing the MSI table cap size dynamically is
> non-standard then offer up a completely non-standard way to operate
> MSI instead seems to miss the entire point.

I'm not offering up a non-standard way to do this. Just think about
it. If I have a device that defines an MSI-X table size of 2048 but
makes use of only one vector how would that be any different than what
I am suggesting where you size your VF to whatever the maximum is you
need but only make use of some fixed number from the hardware.

> The important standard is to keep the PCI config space acting per-spec
> so all the various consumers can work as-is. The extension is to only
> modify the rare hypervisor to support a dynamic MSI resizing extension
> for VFs.

I will repeat what I said before. Why can't this be handled via the
vfio interface? You just need to add the ability to specify the upper
limit on vdev->msix_size so that it is a number between 1 and whatever
your max table size is. It sounds like something that probably belongs
in the vfio_pci_ioctl somewhere. Then if you have an OS running in a
guest that cannot help itself and will allocate an interrupt for every
vector, you can simply modify that value so that it puts a cap on the
total number of vectors it will try to allocate in the guest.

> As far as applicability, any device working at high scale with MSI and
> VMs is going to need this. Dynamically assigning the limited MSI HW is
> really required to support the universe of VM configurations people
> want. eg generally I would expect a VM to receive the number of MSI
> vectors equal to the number of CPUs the VM gets.

Again, you are pushing VM requirements on to PCI. That really seems
like the realm of vfio rather than PCI. Especially since your answer
to the problem is to update a value that is only really being read by
vfio on the host. It really just seems like it would make more sense
to maybe make this part of the vfio ioctl call so you could limit the
use of the MSI-X table in the guest.

> > I see that being mostly a thing between the firmware and the VF in
> > terms of configuration and not something that necessarily has to be
> > pushed down onto the PCIe configuration space itself.
>
> If mlx5 drivers had been designed long ago to never use standard based
> MSI and instead did something internal with FW you might have a point,
> but they weren't. All the mlx5 drivers use standards based MSI and
> expect the config space to be correct.

Again, from what I can tell you are updating a field that isn't read
by the mlx5 driver. It is read/written by the OS and the field itself
is only supposed to be updated by the OS according to the PCIe spec.
While it is all well and good that the firmware can circumvent this
and modify the MMIO space I really feel like it shouldn't be doing
that.

In my mind it sounds a lot like this is something that really should
have been configured in the VFIO driver as the problems you have
described all seem to be issues either with some unknown userspace app
or OSes other than Linux.
