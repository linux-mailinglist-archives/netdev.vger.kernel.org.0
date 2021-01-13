Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 491052F576C
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 04:00:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729341AbhANB7p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 20:59:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729447AbhAMXj4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jan 2021 18:39:56 -0500
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3C3CC061575;
        Wed, 13 Jan 2021 14:44:56 -0800 (PST)
Received: by mail-io1-xd33.google.com with SMTP id y19so7511644iov.2;
        Wed, 13 Jan 2021 14:44:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Jp+QX8KdT4lzR3e/aV/6wYQpGFyZWdIs9GWj82wlKdE=;
        b=Z8C092hPk5rTxwubDmQx3tAOWYm5arWFNspu3djG4R0L3PGvVKCLV4PGf6azsDD1CQ
         lwWpe+LDIjBo1C8rKHp3/6dUUrVrfV5vQ/GgQ+dEXLfFM2fQyW4so2ra+A45YRDCWDd+
         u8H3lX+FSjx/40DFLAqVOiyTBtr8iV94+DseuH9E0wab1HuEW7soU7+dH1jKwJde+hrB
         trJ+Lh4sDFujeFrpOQrGXb70r/VvEJ5W0NOWHKNV58qMMedXclhYQ90lDEG/st8DstbA
         q250vAJDBZKeY774kkFB7nhkeG7o8eK7jrMdrl3PkqTllfIl7qz8AOoqYEsrDS5hxvCY
         P51g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Jp+QX8KdT4lzR3e/aV/6wYQpGFyZWdIs9GWj82wlKdE=;
        b=n1pCv42S/2odzLV08vk7zGFGrqRj4oSakDKhb3hPM3ohi33fllODJJ6yZ0qnYZJIvV
         cLgti0WG5ASXEI98gp740x1XdHBD5AXuWdSq2oIyaUsoqNLqqLpUsVKKX5qe8MXasFWT
         QzwP9GsgS5XIphKhU9QkzunhWo5yraqeJd54mt93iaMb5dkbYi4QgtrPG6GgSvvgudvf
         nirvbndHkrWfpPp1UDg9e23zFSgIhaFIEIeAP89XoKyMC7fJxWWg7P4TPYF13u6li895
         oh+hWFpg5ZZ8COczVNFvKC9I9N6wJY3wBwdlD3qPoPJyaQv8R/zFGss1HG8D8rh3j3US
         7N6w==
X-Gm-Message-State: AOAM533WlkI3F0j+0+dMKGvN7aF/+VzeBzm52tgLJANhceFRxOeHTz6n
        n1K7U3n0LNvG+SzLFyNL/I28dyVMpxddm1IC+Ho=
X-Google-Smtp-Source: ABdhPJxTTJ+LVeIRmmKrn7gX+wAIs1dszT2UKs4JckU1bp9WmyiIBkRkWXVYLCnWlfETwGOmwBfxfbvOcpbcZ4xNHF8=
X-Received: by 2002:a05:6602:152:: with SMTP id v18mr3320439iot.187.1610577896161;
 Wed, 13 Jan 2021 14:44:56 -0800 (PST)
MIME-Version: 1.0
References: <20210110150727.1965295-1-leon@kernel.org> <20210110150727.1965295-3-leon@kernel.org>
 <CAKgT0Uczu6cULPsVjFuFVmir35SpL-bs0hosbfH-T5sZLZ78BQ@mail.gmail.com>
 <20210112065601.GD4678@unreal> <CAKgT0UdndGdA3xONBr62hE-_RBdL-fq6rHLy0PrdsuMn1936TA@mail.gmail.com>
 <20210113061909.GG4678@unreal>
In-Reply-To: <20210113061909.GG4678@unreal>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Wed, 13 Jan 2021 14:44:45 -0800
Message-ID: <CAKgT0Uc4v54vqRVk_HhjOk=OLJu-20AhuBVcg7=C9_hsLtzxLA@mail.gmail.com>
Subject: Re: [PATCH mlx5-next v1 2/5] PCI: Add SR-IOV sysfs entry to read
 number of MSI-X vectors
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Bjorn Helgaas <bhelgaas@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-pci <linux-pci@vger.kernel.org>,
        linux-rdma@vger.kernel.org, Netdev <netdev@vger.kernel.org>,
        Don Dutile <ddutile@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 12, 2021 at 10:19 PM Leon Romanovsky <leon@kernel.org> wrote:
>
> On Tue, Jan 12, 2021 at 01:34:50PM -0800, Alexander Duyck wrote:
> > On Mon, Jan 11, 2021 at 10:56 PM Leon Romanovsky <leon@kernel.org> wrote:
> > >
> > > On Mon, Jan 11, 2021 at 11:30:39AM -0800, Alexander Duyck wrote:
> > > > On Sun, Jan 10, 2021 at 7:10 AM Leon Romanovsky <leon@kernel.org> wrote:
> > > > >
> > > > > From: Leon Romanovsky <leonro@nvidia.com>
> > > > >
> > > > > Some SR-IOV capable devices provide an ability to configure specific
> > > > > number of MSI-X vectors on their VF prior driver is probed on that VF.
> > > > >
> > > > > In order to make management easy, provide new read-only sysfs file that
> > > > > returns a total number of possible to configure MSI-X vectors.
> > > > >
> > > > > cat /sys/bus/pci/devices/.../sriov_vf_total_msix
> > > > >   = 0 - feature is not supported
> > > > >   > 0 - total number of MSI-X vectors to consume by the VFs
> > > > >
> > > > > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> > > > > ---
> > > > >  Documentation/ABI/testing/sysfs-bus-pci | 14 +++++++++++
> > > > >  drivers/pci/iov.c                       | 31 +++++++++++++++++++++++++
> > > > >  drivers/pci/pci.h                       |  3 +++
> > > > >  include/linux/pci.h                     |  2 ++
> > > > >  4 files changed, 50 insertions(+)
> > > > >
> > > > > diff --git a/Documentation/ABI/testing/sysfs-bus-pci b/Documentation/ABI/testing/sysfs-bus-pci
> > > > > index 05e26e5da54e..64e9b700acc9 100644
> > > > > --- a/Documentation/ABI/testing/sysfs-bus-pci
> > > > > +++ b/Documentation/ABI/testing/sysfs-bus-pci
> > > > > @@ -395,3 +395,17 @@ Description:
> > > > >                 The file is writable if the PF is bound to a driver that
> > > > >                 supports the ->sriov_set_msix_vec_count() callback and there
> > > > >                 is no driver bound to the VF.
> > > > > +
> > > > > +What:          /sys/bus/pci/devices/.../sriov_vf_total_msix
> > > >
> > > > In this case I would drop the "vf" and just go with sriov_total_msix
> > > > since now you are referring to a global value instead of a per VF
> > > > value.
> > >
> > > This field indicates the amount of MSI-X available for VFs, it doesn't
> > > include PFs. The missing "_vf_" will mislead users who will believe that
> > > it is all MSI-X vectors available for this device. They will need to take
> > > into consideration amount of PF MSI-X in order to calculate the VF distribution.
> > >
> > > So I would leave "_vf_" here.
> >
> > The problem is you aren't indicating how many are available for an
> > individual VF though, you are indicating how many are available for
> > use by SR-IOV to give to the VFs. The fact that you are dealing with a
> > pool makes things confusing in my opinion. For example sriov_vf_device
> > describes the device ID that will be given to each VF.
>
> sriov_vf_device is different and is implemented accordingly to the PCI
> spec, 9.3.3.11 VF Device ID (Offset 1Ah)
> "This field contains the Device ID that should be presented for every VF
> to the SI."
>
> It is one ID for all VFs.

Yes, but that is what I am getting at. It is also what the device
configuration will be for one VF. So when I read sriov_vf_total_msix
it reads as the total for a single VF, not all of the the VFs. That is
why I think dropping the "vf_" part of the name would make sense, as
what you are describing is the total number of MSI-X vectors for use
by SR-IOV VFs.

> >
> > > >
> > > > > +Date:          January 2021
> > > > > +Contact:       Leon Romanovsky <leonro@nvidia.com>
> > > > > +Description:
> > > > > +               This file is associated with the SR-IOV PFs.
> > > > > +               It returns a total number of possible to configure MSI-X
> > > > > +               vectors on the enabled VFs.
> > > > > +
> > > > > +               The values returned are:
> > > > > +                * > 0 - this will be total number possible to consume by VFs,
> > > > > +                * = 0 - feature is not supported
> > > > > +
> > > > > +               If no SR-IOV VFs are enabled, this value will return 0.
> > > > > diff --git a/drivers/pci/iov.c b/drivers/pci/iov.c
> > > > > index 42c0df4158d1..0a6ddf3230fd 100644
> > > > > --- a/drivers/pci/iov.c
> > > > > +++ b/drivers/pci/iov.c
> > > > > @@ -394,12 +394,22 @@ static ssize_t sriov_drivers_autoprobe_store(struct device *dev,
> > > > >         return count;
> > > > >  }
> > > > >
> > > > > +static ssize_t sriov_vf_total_msix_show(struct device *dev,
> > > > > +                                       struct device_attribute *attr,
> > > > > +                                       char *buf)
> > > > > +{
> > > > > +       struct pci_dev *pdev = to_pci_dev(dev);
> > > > > +
> > > > > +       return sprintf(buf, "%d\n", pdev->sriov->vf_total_msix);
> > > > > +}
> > > > > +
> > > >
> > > > You display it as a signed value, but unsigned values are not
> > > > supported, correct?
> > >
> > > Right, I made it similar to the vf_msix_set. I can change.
> > >
> > > >
> > > > >  static DEVICE_ATTR_RO(sriov_totalvfs);
> > > > >  static DEVICE_ATTR_RW(sriov_numvfs);
> > > > >  static DEVICE_ATTR_RO(sriov_offset);
> > > > >  static DEVICE_ATTR_RO(sriov_stride);
> > > > >  static DEVICE_ATTR_RO(sriov_vf_device);
> > > > >  static DEVICE_ATTR_RW(sriov_drivers_autoprobe);
> > > > > +static DEVICE_ATTR_RO(sriov_vf_total_msix);
> > > > >
> > > > >  static struct attribute *sriov_dev_attrs[] = {
> > > > >         &dev_attr_sriov_totalvfs.attr,
> > > > > @@ -408,6 +418,7 @@ static struct attribute *sriov_dev_attrs[] = {
> > > > >         &dev_attr_sriov_stride.attr,
> > > > >         &dev_attr_sriov_vf_device.attr,
> > > > >         &dev_attr_sriov_drivers_autoprobe.attr,
> > > > > +       &dev_attr_sriov_vf_total_msix.attr,
> > > > >         NULL,
> > > > >  };
> > > > >
> > > > > @@ -658,6 +669,7 @@ static void sriov_disable(struct pci_dev *dev)
> > > > >                 sysfs_remove_link(&dev->dev.kobj, "dep_link");
> > > > >
> > > > >         iov->num_VFs = 0;
> > > > > +       iov->vf_total_msix = 0;
> > > > >         pci_iov_set_numvfs(dev, 0);
> > > > >  }
> > > > >
> > > > > @@ -1116,6 +1128,25 @@ int pci_sriov_get_totalvfs(struct pci_dev *dev)
> > > > >  }
> > > > >  EXPORT_SYMBOL_GPL(pci_sriov_get_totalvfs);
> > > > >
> > > > > +/**
> > > > > + * pci_sriov_set_vf_total_msix - set total number of MSI-X vectors for the VFs
> > > > > + * @dev: the PCI PF device
> > > > > + * @numb: the total number of MSI-X vector to consume by the VFs
> > > > > + *
> > > > > + * Sets the number of MSI-X vectors that is possible to consume by the VFs.
> > > > > + * This interface is complimentary part of the pci_set_msix_vec_count()
> > > > > + * that will be used to configure the required number on the VF.
> > > > > + */
> > > > > +void pci_sriov_set_vf_total_msix(struct pci_dev *dev, int numb)
> > > > > +{
> > > > > +       if (!dev->is_physfn || !dev->driver ||
> > > > > +           !dev->driver->sriov_set_msix_vec_count)
> > > > > +               return;
> > > > > +
> > > > > +       dev->sriov->vf_total_msix = numb;
> > > > > +}
> > > > > +EXPORT_SYMBOL_GPL(pci_sriov_set_vf_total_msix);
> > > > > +
> > > >
> > > > This seems broken. What validation is being done on the numb value?
> > > > You pass it as int, and your documentation all refers to tests for >=
> > > > 0, but isn't a signed input a possibility as well? Also "numb" doesn't
> > > > make for a good abbreviation as it is already a word of its own. It
> > > > might make more sense to use count or something like that rather than
> > > > trying to abbreviate number.
> > >
> > > "Broken" is a nice word to describe misunderstanding.
> >
> > Would you prefer "lacking input validation".
> >
> > I see all this code in there checking for is_physfn and driver and
> > sriov_set_msix_vec_count before allowing the setting of vf_total_msix.
> > It just seems like a lot of validation is taking place on the wrong
> > things if you are just going to be setting a value reporting the total
> > number of MSI-X vectors in use for SR-IOV.
>
> All those checks are in place to ensure that we are not overwriting the
> default value, which is 0.

Okay, so what you really have is surplus interrupts that you are
wanting to give out to VF devices. So when we indicate 0 here as the
default it really means we have no additional interrupts to give out.
Am I understanding that correctly?

The problem is this is very vendor specific so I am doing my best to
understand it as it is different then the other NICs I have worked
with.

So this value is the size of the total pool of interrupt vectors you
have to split up between the functions, or just the spare ones you
could add to individual VFs? Since you say "total" I am assuming it is
the total pool which means that in order to figure out how many are
available to be reserved we would have to run through all the VFs and
figure out what has already been assigned, correct? If so it wouldn't
hurt to also think about having a free and in-use count somewhere as
well.

> >
> > In addition this value seems like a custom purpose being pushed into
> > the PCIe code since there isn't anything that defaults the value. It
> > seems like at a minimum there should be something that programs a
> > default value for both of these new fields that are being added so
> > that you pull the maximum number of VFs when SR-IOV is enabled, the
> > maximum number of MSI-X vectors from a single VF, and then the default
> > value for this should be the multiple of the two which can then be
> > overridden later.
>
> The default is 0, because most SR-IOV doesn't have proper support of
> setting VF MSI-X.

It wasn't designed to work this way. That is why it doesn't really work.

> Regarding the calculation, it is not correct for the mlx5. We have large
> pool of MSI-X vectors, but setting small number of them. This allows us
> to increase that number on specific VF without need to decrease on
> others "to free" the vectors.

I think I am finally starting to grok what is going on here, but I
really don't like the approach.

Is there any reason why you couldn't have configured your VF to
support whatever the maximum number of MSI-X vectors you wanted to use
was, and then just internally masked off or disabled the ones that you
couldn't allocate to the VF and communicate that to the VF via some
sort of firmware message so it wouldn't use them? If I am not mistaken
that is the approach that has been taken in the past for at least this
portion of things in the Intel drivers.

Then the matter is how to configure it. I'm not a big fan of adding
sysfs to the VF to manage resources that are meant to be controlled by
the PF. Especially when you are having to add sysfs to the PF as well
which creates an asymmetric setup where you are having to read the PF
to find out what resources you can move to the VF. I wonder if
something like the Devlink Resource interface wouldn't make more sense
in this case. Then you would just manage "vf-interrupts" or something
like that with the resource split between each of the VFs with each VF
uniquely identified as a separate sub resource.
