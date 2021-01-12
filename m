Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10B9B2F3DF1
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 01:44:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393554AbhALVtP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 16:49:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392300AbhALVgF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 16:36:05 -0500
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57F98C0617A7;
        Tue, 12 Jan 2021 13:35:02 -0800 (PST)
Received: by mail-io1-xd2d.google.com with SMTP id u26so7294411iof.3;
        Tue, 12 Jan 2021 13:35:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sDeAqm+LFH/+YEjj7tR7t+NLtygzAyr4AwNJQrZj4o8=;
        b=d3KS/b6o4l1X7mT9/yVOtc79XKM/ftjmGKrR+8dcVWGzgzUZva3IjKiBby3kIFdDeJ
         gYiwgydpo6taTF0jDTtpzkTEoH101w9+AAOtfpkWEm8GByCs/1pNFbdqsoRgWxr3xPlP
         Ufw2tDxiZEV2DqpadhIIRyM2BZh97qigG20ujKG+yHOMzTpMGXJFESvTZvbKtGOL794t
         a6q84vcoKRyxDin0I7IYDfOF93K6DkleGQm0qH4Z08Ll69k73IeWY1RHcupliweOggD0
         f8SepEg4fBhVbN8tgwHkCWcvkUg4j6zh8/YIennY9c8syFXhmS5jN3xQl1EpgNQ5YcuH
         hREA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sDeAqm+LFH/+YEjj7tR7t+NLtygzAyr4AwNJQrZj4o8=;
        b=AT3dcmDuBqFplj2IlfGB2Avz6c+pBW0cE8K9mpVZ7X4wP6YCCN2cdiwdjD/gJXZ8r/
         XCs4kWBbP24od4PK6ZYVZ5pUuNB24vqemB6Y5BqfQbBcsuM0AGmE7sv+Rp0nHOxH0MUU
         3Ex1jZpKaIVfZOKBHOqbUM5oAAMkZzbwx2y8OrObH2behu5Tio/chgN5S4Wg2y0Vpvde
         yY3+2MkWPVj2tf4iOyyhzrb25b6waTry8WPvErHL7t6PqC5NBi2DtsodXSy/V6jbof2e
         QHOm24O3L5/TQUHEZ3Q+lafzz5t7zB5/hQk2Zo4tKyqqbL+FLQ0D+9tCPYA4zr3CmCki
         vH9A==
X-Gm-Message-State: AOAM533VO2wioTO/02SnUnJxs08NOEAM/7CqKS5z5rMqlLUDK1PA7V9O
        O8yL4STjq2Lr8GTIIImnV5MCL2NU45wlB0K5POM=
X-Google-Smtp-Source: ABdhPJzjn/TNYAGAH6/SXpllAAMU5SXgaWLsv3NEdJpo5dqEL96pcE0w+cXeO3MWP28fnIjqwgn2BDVfncP71gze6FQ=
X-Received: by 2002:a5e:9812:: with SMTP id s18mr846974ioj.138.1610487301573;
 Tue, 12 Jan 2021 13:35:01 -0800 (PST)
MIME-Version: 1.0
References: <20210110150727.1965295-1-leon@kernel.org> <20210110150727.1965295-3-leon@kernel.org>
 <CAKgT0Uczu6cULPsVjFuFVmir35SpL-bs0hosbfH-T5sZLZ78BQ@mail.gmail.com> <20210112065601.GD4678@unreal>
In-Reply-To: <20210112065601.GD4678@unreal>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Tue, 12 Jan 2021 13:34:50 -0800
Message-ID: <CAKgT0UdndGdA3xONBr62hE-_RBdL-fq6rHLy0PrdsuMn1936TA@mail.gmail.com>
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

On Mon, Jan 11, 2021 at 10:56 PM Leon Romanovsky <leon@kernel.org> wrote:
>
> On Mon, Jan 11, 2021 at 11:30:39AM -0800, Alexander Duyck wrote:
> > On Sun, Jan 10, 2021 at 7:10 AM Leon Romanovsky <leon@kernel.org> wrote:
> > >
> > > From: Leon Romanovsky <leonro@nvidia.com>
> > >
> > > Some SR-IOV capable devices provide an ability to configure specific
> > > number of MSI-X vectors on their VF prior driver is probed on that VF.
> > >
> > > In order to make management easy, provide new read-only sysfs file that
> > > returns a total number of possible to configure MSI-X vectors.
> > >
> > > cat /sys/bus/pci/devices/.../sriov_vf_total_msix
> > >   = 0 - feature is not supported
> > >   > 0 - total number of MSI-X vectors to consume by the VFs
> > >
> > > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> > > ---
> > >  Documentation/ABI/testing/sysfs-bus-pci | 14 +++++++++++
> > >  drivers/pci/iov.c                       | 31 +++++++++++++++++++++++++
> > >  drivers/pci/pci.h                       |  3 +++
> > >  include/linux/pci.h                     |  2 ++
> > >  4 files changed, 50 insertions(+)
> > >
> > > diff --git a/Documentation/ABI/testing/sysfs-bus-pci b/Documentation/ABI/testing/sysfs-bus-pci
> > > index 05e26e5da54e..64e9b700acc9 100644
> > > --- a/Documentation/ABI/testing/sysfs-bus-pci
> > > +++ b/Documentation/ABI/testing/sysfs-bus-pci
> > > @@ -395,3 +395,17 @@ Description:
> > >                 The file is writable if the PF is bound to a driver that
> > >                 supports the ->sriov_set_msix_vec_count() callback and there
> > >                 is no driver bound to the VF.
> > > +
> > > +What:          /sys/bus/pci/devices/.../sriov_vf_total_msix
> >
> > In this case I would drop the "vf" and just go with sriov_total_msix
> > since now you are referring to a global value instead of a per VF
> > value.
>
> This field indicates the amount of MSI-X available for VFs, it doesn't
> include PFs. The missing "_vf_" will mislead users who will believe that
> it is all MSI-X vectors available for this device. They will need to take
> into consideration amount of PF MSI-X in order to calculate the VF distribution.
>
> So I would leave "_vf_" here.

The problem is you aren't indicating how many are available for an
individual VF though, you are indicating how many are available for
use by SR-IOV to give to the VFs. The fact that you are dealing with a
pool makes things confusing in my opinion. For example sriov_vf_device
describes the device ID that will be given to each VF.

> >
> > > +Date:          January 2021
> > > +Contact:       Leon Romanovsky <leonro@nvidia.com>
> > > +Description:
> > > +               This file is associated with the SR-IOV PFs.
> > > +               It returns a total number of possible to configure MSI-X
> > > +               vectors on the enabled VFs.
> > > +
> > > +               The values returned are:
> > > +                * > 0 - this will be total number possible to consume by VFs,
> > > +                * = 0 - feature is not supported
> > > +
> > > +               If no SR-IOV VFs are enabled, this value will return 0.
> > > diff --git a/drivers/pci/iov.c b/drivers/pci/iov.c
> > > index 42c0df4158d1..0a6ddf3230fd 100644
> > > --- a/drivers/pci/iov.c
> > > +++ b/drivers/pci/iov.c
> > > @@ -394,12 +394,22 @@ static ssize_t sriov_drivers_autoprobe_store(struct device *dev,
> > >         return count;
> > >  }
> > >
> > > +static ssize_t sriov_vf_total_msix_show(struct device *dev,
> > > +                                       struct device_attribute *attr,
> > > +                                       char *buf)
> > > +{
> > > +       struct pci_dev *pdev = to_pci_dev(dev);
> > > +
> > > +       return sprintf(buf, "%d\n", pdev->sriov->vf_total_msix);
> > > +}
> > > +
> >
> > You display it as a signed value, but unsigned values are not
> > supported, correct?
>
> Right, I made it similar to the vf_msix_set. I can change.
>
> >
> > >  static DEVICE_ATTR_RO(sriov_totalvfs);
> > >  static DEVICE_ATTR_RW(sriov_numvfs);
> > >  static DEVICE_ATTR_RO(sriov_offset);
> > >  static DEVICE_ATTR_RO(sriov_stride);
> > >  static DEVICE_ATTR_RO(sriov_vf_device);
> > >  static DEVICE_ATTR_RW(sriov_drivers_autoprobe);
> > > +static DEVICE_ATTR_RO(sriov_vf_total_msix);
> > >
> > >  static struct attribute *sriov_dev_attrs[] = {
> > >         &dev_attr_sriov_totalvfs.attr,
> > > @@ -408,6 +418,7 @@ static struct attribute *sriov_dev_attrs[] = {
> > >         &dev_attr_sriov_stride.attr,
> > >         &dev_attr_sriov_vf_device.attr,
> > >         &dev_attr_sriov_drivers_autoprobe.attr,
> > > +       &dev_attr_sriov_vf_total_msix.attr,
> > >         NULL,
> > >  };
> > >
> > > @@ -658,6 +669,7 @@ static void sriov_disable(struct pci_dev *dev)
> > >                 sysfs_remove_link(&dev->dev.kobj, "dep_link");
> > >
> > >         iov->num_VFs = 0;
> > > +       iov->vf_total_msix = 0;
> > >         pci_iov_set_numvfs(dev, 0);
> > >  }
> > >
> > > @@ -1116,6 +1128,25 @@ int pci_sriov_get_totalvfs(struct pci_dev *dev)
> > >  }
> > >  EXPORT_SYMBOL_GPL(pci_sriov_get_totalvfs);
> > >
> > > +/**
> > > + * pci_sriov_set_vf_total_msix - set total number of MSI-X vectors for the VFs
> > > + * @dev: the PCI PF device
> > > + * @numb: the total number of MSI-X vector to consume by the VFs
> > > + *
> > > + * Sets the number of MSI-X vectors that is possible to consume by the VFs.
> > > + * This interface is complimentary part of the pci_set_msix_vec_count()
> > > + * that will be used to configure the required number on the VF.
> > > + */
> > > +void pci_sriov_set_vf_total_msix(struct pci_dev *dev, int numb)
> > > +{
> > > +       if (!dev->is_physfn || !dev->driver ||
> > > +           !dev->driver->sriov_set_msix_vec_count)
> > > +               return;
> > > +
> > > +       dev->sriov->vf_total_msix = numb;
> > > +}
> > > +EXPORT_SYMBOL_GPL(pci_sriov_set_vf_total_msix);
> > > +
> >
> > This seems broken. What validation is being done on the numb value?
> > You pass it as int, and your documentation all refers to tests for >=
> > 0, but isn't a signed input a possibility as well? Also "numb" doesn't
> > make for a good abbreviation as it is already a word of its own. It
> > might make more sense to use count or something like that rather than
> > trying to abbreviate number.
>
> "Broken" is a nice word to describe misunderstanding.

Would you prefer "lacking input validation".

I see all this code in there checking for is_physfn and driver and
sriov_set_msix_vec_count before allowing the setting of vf_total_msix.
It just seems like a lot of validation is taking place on the wrong
things if you are just going to be setting a value reporting the total
number of MSI-X vectors in use for SR-IOV.

In addition this value seems like a custom purpose being pushed into
the PCIe code since there isn't anything that defaults the value. It
seems like at a minimum there should be something that programs a
default value for both of these new fields that are being added so
that you pull the maximum number of VFs when SR-IOV is enabled, the
maximum number of MSI-X vectors from a single VF, and then the default
value for this should be the multiple of the two which can then be
overridden later.

> The vf_total_msix is not set by the users and used solely by the drivers
> to advertise their capability. This field is needed to give a way to
> calculate how much MSI-X VFs can get. The driver code is part of the
> kernel and like any other kernel code, it is trusted.
>
> I'm checking < 0 in another _set_ routine to make sure that we will be
> able to extend this sysfs entry if at some point of time negative vector
> count will make sense.

I would rather have a strict interface that doesn't allow for
unintended flexibility. Out-of-tree drivers tend to exploit that kind
of stuff and it is problematic when it can occur.

> "Count" instead of "numb" is fine by me.
> >
> >
> > >  /**
> > >   * pci_sriov_configure_simple - helper to configure SR-IOV
> > >   * @dev: the PCI device
> > > diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
> > > index 1fd273077637..0fbe291eb0f2 100644
> > > --- a/drivers/pci/pci.h
> > > +++ b/drivers/pci/pci.h
> > > @@ -327,6 +327,9 @@ struct pci_sriov {
> > >         u16             subsystem_device; /* VF subsystem device */
> > >         resource_size_t barsz[PCI_SRIOV_NUM_BARS];      /* VF BAR size */
> > >         bool            drivers_autoprobe; /* Auto probing of VFs by driver */
> > > +       int             vf_total_msix;  /* Total number of MSI-X vectors the VFs
> > > +                                        * can consume
> > > +                                        */
> > >  };
> > >
> > >  /**
> > > diff --git a/include/linux/pci.h b/include/linux/pci.h
> > > index a17cfc28eb66..fd9ff1f42a09 100644
> > > --- a/include/linux/pci.h
> > > +++ b/include/linux/pci.h
> > > @@ -2074,6 +2074,7 @@ int pci_sriov_get_totalvfs(struct pci_dev *dev);
> > >  int pci_sriov_configure_simple(struct pci_dev *dev, int nr_virtfn);
> > >  resource_size_t pci_iov_resource_size(struct pci_dev *dev, int resno);
> > >  void pci_vf_drivers_autoprobe(struct pci_dev *dev, bool probe);
> > > +void pci_sriov_set_vf_total_msix(struct pci_dev *dev, int numb);
> > >
> > >  /* Arch may override these (weak) */
> > >  int pcibios_sriov_enable(struct pci_dev *pdev, u16 num_vfs);
> > > @@ -2114,6 +2115,7 @@ static inline int pci_sriov_get_totalvfs(struct pci_dev *dev)
> > >  static inline resource_size_t pci_iov_resource_size(struct pci_dev *dev, int resno)
> > >  { return 0; }
> > >  static inline void pci_vf_drivers_autoprobe(struct pci_dev *dev, bool probe) { }
> > > +static inline void pci_sriov_set_vf_total_msix(struct pci_dev *dev, int numb) {}
> > >  #endif
> > >
> > >  #if defined(CONFIG_HOTPLUG_PCI) || defined(CONFIG_HOTPLUG_PCI_MODULE)
> > > --
> > > 2.29.2
> > >
