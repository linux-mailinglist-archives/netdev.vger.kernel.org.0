Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3027A3034D6
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 06:29:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732951AbhAZF2x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 00:28:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731168AbhAYSvp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 13:51:45 -0500
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 067F0C061573;
        Mon, 25 Jan 2021 10:51:05 -0800 (PST)
Received: by mail-io1-xd34.google.com with SMTP id z22so28654083ioh.9;
        Mon, 25 Jan 2021 10:51:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=x6NroVxX2SWf6rFQUodqk2IRulqgxWpNQowIvS6mbio=;
        b=oNG0YvE6d1+LPMfu8lhs1xh4hDry5O1VQIjxAOxWuDsOvyiW9B4ozbRo3z2QLWEkE1
         LW1xP471aut6jntxnHI0X4FSJdww6I34spiY5MDXJF4qqnRzYY56lFEwCjEBDFHx8t3e
         Do7QZAtQsLxdC1gr70T0DiJvPwMPnASpDadWiVn0ljCKsgC30psR1Z5Zo7uhsc2yI7ag
         ze7McL87eoi/eZgX/3yj4f+t3Wkd1R4YtGR/iiuoF0zhgjMulY2f3jsxq2+6jmVAlHX6
         1s9LXGpv/8dBLsQqMslDVJae77JRo2RkzhcC5EvoWK4jP5D6U6IsU9fpRLsLBla9WosW
         sYRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=x6NroVxX2SWf6rFQUodqk2IRulqgxWpNQowIvS6mbio=;
        b=i/IezMBRSkVEuP54ZV9qNy3v6kEVHvdyfEX0o6g01bmXdVAFVYViY6pFziIEq1gRHN
         qyokK3oGmSb6bc/SZPBxeNc/QYhTH9nKvn4rIvSXAUE9DcizZRUk7ho7Ad65kWNpXWsd
         /sImHQAZ9x4OT0JgYxmgEl5XicYYQ4aJYdxRBGWAnHxSqIaat88E3dZuWzS5SdfHI/2T
         csl0+wpIDlFsUIR2E06ZlIXANgOE5s7l4O/6llFIF0zbHDZMNOJ/oHcYOdALfVI8r/DG
         tQRmeeCpv8LurD738rB4ytAqEg9jX1YjPhTkEzUWR4XYc0jYM+klTrORjpBcaAvg/NRW
         uvYA==
X-Gm-Message-State: AOAM531K9UTksVzMU8TIDxi0zIfonok+ye8edlePrXm3EtsSCQ0wyoTA
        AOBLfIUEEf69J3MRuspMGLvT7eRFdJkf/BDhtHg=
X-Google-Smtp-Source: ABdhPJyqz9jX4buTPBcsgvEXYJj8K/2dd3DWgeKNmCq9jaLdVt5a/NASGYUXGfPo0E4usHKQd/9lriE/Eq28Z2ikHkY=
X-Received: by 2002:a05:6638:b12:: with SMTP id a18mr1926735jab.114.1611600664343;
 Mon, 25 Jan 2021 10:51:04 -0800 (PST)
MIME-Version: 1.0
References: <20210124131119.558563-1-leon@kernel.org> <20210124131119.558563-2-leon@kernel.org>
 <CAKgT0UcJQ3uy6J_CCLizDLfzGL2saa_PjOYH4nK+RQjfmpNA=w@mail.gmail.com>
 <20210124190032.GD5038@unreal> <20210125184719.GK579511@unreal>
In-Reply-To: <20210125184719.GK579511@unreal>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Mon, 25 Jan 2021 10:50:53 -0800
Message-ID: <CAKgT0UdPMGUax-UbeBK7-iNmsBqU_0w6hGdZ--P5EwfgmdN2ug@mail.gmail.com>
Subject: Re: [PATCH mlx5-next v4 1/4] PCI: Add sysfs callback to allow MSI-X
 table size change of SR-IOV VFs
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Bjorn Helgaas <bhelgaas@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-pci <linux-pci@vger.kernel.org>,
        linux-rdma@vger.kernel.org, Netdev <netdev@vger.kernel.org>,
        Don Dutile <ddutile@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "David S . Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 25, 2021 at 10:47 AM Leon Romanovsky <leon@kernel.org> wrote:
>
> On Sun, Jan 24, 2021 at 09:00:32PM +0200, Leon Romanovsky wrote:
> > On Sun, Jan 24, 2021 at 08:47:44AM -0800, Alexander Duyck wrote:
> > > On Sun, Jan 24, 2021 at 5:11 AM Leon Romanovsky <leon@kernel.org> wrote:
> > > >
> > > > From: Leon Romanovsky <leonro@nvidia.com>
> > > >
> > > > Extend PCI sysfs interface with a new callback that allows configure
> > > > the number of MSI-X vectors for specific SR-IO VF. This is needed
> > > > to optimize the performance of newly bound devices by allocating
> > > > the number of vectors based on the administrator knowledge of targeted VM.
> > > >
> > > > This function is applicable for SR-IOV VF because such devices allocate
> > > > their MSI-X table before they will run on the VMs and HW can't guess the
> > > > right number of vectors, so the HW allocates them statically and equally.
> > > >
> > > > 1) The newly added /sys/bus/pci/devices/.../vfs_overlay/sriov_vf_msix_count
> > > > file will be seen for the VFs and it is writable as long as a driver is not
> > > > bounded to the VF.
> > > >
> > > > The values accepted are:
> > > >  * > 0 - this will be number reported by the VF's MSI-X capability
> > > >  * < 0 - not valid
> > > >  * = 0 - will reset to the device default value
> > > >
> > > > 2) In order to make management easy, provide new read-only sysfs file that
> > > > returns a total number of possible to configure MSI-X vectors.
> > > >
> > > > cat /sys/bus/pci/devices/.../vfs_overlay/sriov_vf_total_msix
> > > >   = 0 - feature is not supported
> > > >   > 0 - total number of MSI-X vectors to consume by the VFs
> > > >
> > > > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> > > > ---
> > > >  Documentation/ABI/testing/sysfs-bus-pci |  32 +++++
> > > >  drivers/pci/iov.c                       | 180 ++++++++++++++++++++++++
> > > >  drivers/pci/msi.c                       |  47 +++++++
> > > >  drivers/pci/pci.h                       |   4 +
> > > >  include/linux/pci.h                     |  10 ++
> > > >  5 files changed, 273 insertions(+)
> > > >
> > >
> > > <snip>
> > >
> > > > +
> > > > +static umode_t sriov_pf_attrs_are_visible(struct kobject *kobj,
> > > > +                                         struct attribute *a, int n)
> > > > +{
> > > > +       struct device *dev = kobj_to_dev(kobj);
> > > > +       struct pci_dev *pdev = to_pci_dev(dev);
> > > > +
> > > > +       if (!pdev->msix_cap || !dev_is_pf(dev))
> > > > +               return 0;
> > > > +
> > > > +       return a->mode;
> > > > +}
> > > > +
> > > > +static umode_t sriov_vf_attrs_are_visible(struct kobject *kobj,
> > > > +                                         struct attribute *a, int n)
> > > > +{
> > > > +       struct device *dev = kobj_to_dev(kobj);
> > > > +       struct pci_dev *pdev = to_pci_dev(dev);
> > > > +
> > > > +       if (!pdev->msix_cap || dev_is_pf(dev))
> > > > +               return 0;
> > > > +
> > > > +       return a->mode;
> > > > +}
> > > > +
> > >
> > > Given the changes I don't see why we need to add the "visible"
> > > functions. We are only registering this from the PF if there is a need
> > > to make use of the interfaces, correct? If so we can just assume that
> > > the interfaces should always be visible if they are requested.
> >
> > I added them to make extension of this vfs_overlay interface more easy,
> > so we won't forget that current fields needs "msix_cap". Also I followed
> > same style as other attribute_group which has .is_visible.
> >
> > >
> > > Also you may want to look at placing a link to the VF folders in the
> > > PF folder, although I suppose there are already links from the PF PCI
> > > device to the VF PCI devices so maybe that isn't necessary. It just
> > > takes a few extra steps to navigate between the two.
> >
> > We already have, I don't think that we need to add extra links, it will
> > give nothing.
> >
> > [leonro@vm ~]$ ls -l /sys/bus/pci/devices/0000\:01\:00.0/
> > ....
> > drwxr-xr-x 2 root root        0 Jan 24 14:02 vfs_overlay
> > lrwxrwxrwx 1 root root        0 Jan 24 14:02 virtfn0 -> ../0000:01:00.1
> > lrwxrwxrwx 1 root root        0 Jan 24 14:02 virtfn1 -> ../0000:01:00.2
> > ....
>
> Alexander, are we clear here? Do you expect v5 without ".is_visible" from me?

Yeah, I am okay with the .is_visible being left around. It just seems
redundant is all.

Thanks.

 -Alex
