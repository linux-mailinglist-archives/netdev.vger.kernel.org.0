Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F51F34AEC5
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 19:51:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229969AbhCZSvV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 14:51:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230138AbhCZSu4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Mar 2021 14:50:56 -0400
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B586C0613AA;
        Fri, 26 Mar 2021 11:50:56 -0700 (PDT)
Received: by mail-io1-xd31.google.com with SMTP id z136so6393840iof.10;
        Fri, 26 Mar 2021 11:50:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Iu1JNF6SF7oEppHvP+plVN0qFTWdU5EACnfxSAygZtg=;
        b=kb62XZaX4YZ5qWRcmfvd5q2Gcf9eguV6Xdrv4Hkx+5Q1WWyj3dn2aS/WLvMTjpYEQw
         1NPs6/vCYIZee9AU99ZWUHD1oQjYCIL4+lGZn8S+yLmltUcqaY/oPWidCo+Fc2xyjhRL
         KxL5gIjuwj4aEs0x0kZ0gncw0EYeXHEL7Pe/G9GUNo+wW0UhSa364+MW7wUJd/TE4vAs
         iwXaq9FdJF6IV3AaSVvmmWa5GoS5vA8OZLRa8i8mM339erc/OF4UV1BE+bJ37DFhtT5j
         gU8L2+zzP7OpjycgSts7ybbeCPOsicsdjjYbITxZan0qrJtDcktfFLVU65FdV/MRnUO8
         WkGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Iu1JNF6SF7oEppHvP+plVN0qFTWdU5EACnfxSAygZtg=;
        b=HYjX+ewB6Lm9v4L8k+CbCBM3UdVghDbQYbzCiUXxXOwXwb22b0h98wxkW7MDvOsQ64
         E+03Jo5TBsbqKOdbX7otjQubJMOKFPqXjFVI9UE2YK6ZtdZ1+6HJWQCWy3Ww0/tCZQUF
         C0RI6EpYbCm6rg71tdhtuPlXk6U8punDgJJlYrKT6Z9d/d3kAwS6tQr7wlLRze2JZO71
         Z8wN0q240DdPlOclAZQGA1o7GGjYnrA0dRrfUhoS94fWyNTWNA/jLk7oQNG2GI0NC0qx
         fZ42Cs8YDH7tn7QnrVLtEhSWKH0tCJgp04TJUNgC4afzSTtj2n9QhvBmglmjZQfzaJ3I
         1kkw==
X-Gm-Message-State: AOAM530II3SPARPxkJ59forEI+g818hg/mFReG96lcpEei7FMOVd/5Zv
        gW7ezDhrQjRgiA1BZ9OJC8cDv3eaoVci5XHHrIc=
X-Google-Smtp-Source: ABdhPJytGgFcY8iTzhYD7d9LbEm1RzeN+QzWwUM4N7jiyltAzMSUqYm7I0K+eS+vcsEYViOIomiovODA+ea6vLj0K1w=
X-Received: by 2002:a05:6638:238c:: with SMTP id q12mr13494324jat.114.1616784655635;
 Fri, 26 Mar 2021 11:50:55 -0700 (PDT)
MIME-Version: 1.0
References: <CAKgT0UfK3eTYH+hRRC0FcL0rdncKJi=6h5j6MN0uDA98cHCb9A@mail.gmail.com>
 <20210326170831.GA890834@bjorn-Precision-5520>
In-Reply-To: <20210326170831.GA890834@bjorn-Precision-5520>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Fri, 26 Mar 2021 11:50:44 -0700
Message-ID: <CAKgT0UcXwNKDSP2ciEjM2AWj2xOZwBxkPCdzkUqDKAMtvTTKPg@mail.gmail.com>
Subject: Re: [PATCH mlx5-next v7 0/4] Dynamically assign MSI-X vectors count
To:     Bjorn Helgaas <helgaas@kernel.org>
Cc:     Leon Romanovsky <leon@kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Keith Busch <kbusch@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-pci <linux-pci@vger.kernel.org>,
        linux-rdma@vger.kernel.org, Netdev <netdev@vger.kernel.org>,
        Don Dutile <ddutile@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 26, 2021 at 10:08 AM Bjorn Helgaas <helgaas@kernel.org> wrote:
>
> On Fri, Mar 26, 2021 at 09:00:50AM -0700, Alexander Duyck wrote:
> > On Thu, Mar 25, 2021 at 11:44 PM Leon Romanovsky <leon@kernel.org> wrote:
> > > On Thu, Mar 25, 2021 at 03:28:36PM -0300, Jason Gunthorpe wrote:
> > > > On Thu, Mar 25, 2021 at 01:20:21PM -0500, Bjorn Helgaas wrote:
> > > > > On Thu, Mar 25, 2021 at 02:36:46PM -0300, Jason Gunthorpe wrote:
> > > > > > On Thu, Mar 25, 2021 at 12:21:44PM -0500, Bjorn Helgaas wrote:
> > > > > >
> > > > > > > NVMe and mlx5 have basically identical functionality in this respect.
> > > > > > > Other devices and vendors will likely implement similar functionality.
> > > > > > > It would be ideal if we had an interface generic enough to support
> > > > > > > them all.
> > > > > > >
> > > > > > > Is the mlx5 interface proposed here sufficient to support the NVMe
> > > > > > > model?  I think it's close, but not quite, because the the NVMe
> > > > > > > "offline" state isn't explicitly visible in the mlx5 model.
> > > > > >
> > > > > > I thought Keith basically said "offline" wasn't really useful as a
> > > > > > distinct idea. It is an artifact of nvme being a standards body
> > > > > > divorced from the operating system.
> > > > > >
> > > > > > In linux offline and no driver attached are the same thing, you'd
> > > > > > never want an API to make a nvme device with a driver attached offline
> > > > > > because it would break the driver.
> > > > >
> > > > > I think the sticky part is that Linux driver attach is not visible to
> > > > > the hardware device, while the NVMe "offline" state *is*.  An NVMe PF
> > > > > can only assign resources to a VF when the VF is offline, and the VF
> > > > > is only usable when it is online.
> > > > >
> > > > > For NVMe, software must ask the PF to make those online/offline
> > > > > transitions via Secondary Controller Offline and Secondary Controller
> > > > > Online commands [1].  How would this be integrated into this sysfs
> > > > > interface?
> > > >
> > > > Either the NVMe PF driver tracks the driver attach state using a bus
> > > > notifier and mirrors it to the offline state, or it simply
> > > > offline/onlines as part of the sequence to program the MSI change.
> > > >
> > > > I don't see why we need any additional modeling of this behavior.
> > > >
> > > > What would be the point of onlining a device without a driver?
> > >
> > > Agree, we should remember that we are talking about Linux kernel model
> > > and implementation, where _no_driver_ means _offline_.
> >
> > The only means you have of guaranteeing the driver is "offline" is by
> > holding on the device lock and checking it. So it is only really
> > useful for one operation and then you have to release the lock. The
> > idea behind having an "offline" state would be to allow you to
> > aggregate multiple potential operations into a single change.
> >
> > For example you would place the device offline, then change
> > interrupts, and then queues, and then you could online it again. The
> > kernel code could have something in place to prevent driver load on
> > "offline" devices. What it gives you is more of a transactional model
> > versus what you have right now which is more of a concurrent model.
>
> Thanks, Alex.  Leon currently does enforce the "offline" situation by
> holding the VF device lock while checking that it has no driver and
> asking the PF to do the assignment.  I agree this is only useful for a
> single operation.  Would the current series *prevent* a transactional
> model from being added later if it turns out to be useful?  I think I
> can imagine keeping the same sysfs files but changing the
> implementation to check for the VF being offline, while adding
> something new to control online/offline.

My concern would be that we are defining the user space interface.
Once we have this working as a single operation I could see us having
to support it that way going forward as somebody will script something
not expecting an "offline" sysfs file, and the complaint would be that
we are breaking userspace if we require the use of an "offline" file.
So my preference would be to just do it that way now rather than wait
as the behavior will be grandfathered in once we allow the operation
without it.

> I also want to resurrect your idea of associating
> "sriov_vf_msix_count" with the PF instead of the VF.  I really like
> that idea, and it better reflects the way both mlx5 and NVMe work.  I
> don't think there was a major objection to it, but the discussion
> seems to have petered out after your suggestion of putting the PCI
> bus/device/funcion in the filename, which I also like [1].
>
> Leon has implemented a ton of variations, but I don't think having all
> the files in the PF directory was one of them.
>
> Bjorn
>
> [1] https://lore.kernel.org/r/CAKgT0Ue363fZEwqGUa1UAAYotUYH8QpEADW1U5yfNS7XkOLx0Q@mail.gmail.com

I almost wonder if it wouldn't make sense to just partition this up to
handle flexible resources in the future. Maybe something like having
the directory setup such that you have "sriov_resources/msix/" and
then you could have individual files with one for the total and the
rest with the VF BDF naming scheme. Then if we have to, we could add
other subdirectories in the future to handle things like queues in the
future.
