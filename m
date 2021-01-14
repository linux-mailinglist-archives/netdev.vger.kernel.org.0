Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A5012F661E
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 17:41:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726868AbhANQlH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 11:41:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726241AbhANQlH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 11:41:07 -0500
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03F03C061574;
        Thu, 14 Jan 2021 08:40:26 -0800 (PST)
Received: by mail-io1-xd36.google.com with SMTP id n4so12321993iow.12;
        Thu, 14 Jan 2021 08:40:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kTVZeH+Nerpx4yb7apqtyKe2UvOVcLM7vXdZ2/CUJJQ=;
        b=TRH+l9paCVZpA4vlWODt/wOM0kElm6Pq4nRK7Ofz/kq/k2b5N/9RLl1tDb5XG/Siqr
         uoYyoJxKQrSxKjU9hFtwaYH4yK4xmW3WpnKOIb6Q1/xZWgUTgyhIuVj4ExPSqpmAILOn
         bhgXkBnziNzhQ1BlFiDCMJlrtVEnRO2mxmcF80NmbEOyelQkGJ53rq9Nh2u20QWXNGZS
         iifVt1kJtJO/ZW9lV3Fy4hsOEiadhiJ2M6jk38/8jUG/4bQdKhGtNeI0l8shbiyuJ1Jf
         A2kw1BGYZVWOCJS0tECO5aRofx6v3IiCfH35A2LPZc4CCX2pf7InTZAQesm5HW3Gs7xX
         mNgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kTVZeH+Nerpx4yb7apqtyKe2UvOVcLM7vXdZ2/CUJJQ=;
        b=a9U1/Kp2F8zfvkq+djBO6CNTOsX8aUW8Yf8t4RK997bLKmfgnXLHjMD6Sh/0kNAOfP
         qb45ePPVd6/y+j+NOr52y4OeCJrlGFGidHGWwNckmAOIYxC1bRRLN9HKLe2g15+zWM/t
         x/YQDCKqkMDwFwg3KmNBNyKN7XIHnEqrB7l0oErhX1np8r8uew/qry41z5u2yKlmpG5l
         i1lxwzubAey36M12q6aDmCRus0Q+uRYCAh//Ja+plHFJcPy7N0ueZhvVHpLR5BDr1Ci4
         gdhP1+FOEV7Y6TclUDWG6xexduZ5bl6H6Wih4Ha4Nt/tHQonmg188XJEc57msI+aoSo2
         aLhw==
X-Gm-Message-State: AOAM532EmxNGOqu7ipzCaY5hC175a7k+1KhVgP3V61jnCi2Fpcanwuga
        jn6wd8NZHuHnd+FcKeGop0YftKfc7SP7b0dCM7U=
X-Google-Smtp-Source: ABdhPJyHWYzvAP9bhf+tKhQLF5tArHJNAlMYdqBMQXMjprbSDbRSmtN3SK7Jlm6JtZW/UNiuHocUZWoEdPw4SHaUP/0=
X-Received: by 2002:a92:d210:: with SMTP id y16mr7353234ily.97.1610642426011;
 Thu, 14 Jan 2021 08:40:26 -0800 (PST)
MIME-Version: 1.0
References: <20210110150727.1965295-1-leon@kernel.org> <20210110150727.1965295-3-leon@kernel.org>
 <CAKgT0Uczu6cULPsVjFuFVmir35SpL-bs0hosbfH-T5sZLZ78BQ@mail.gmail.com>
 <20210112065601.GD4678@unreal> <CAKgT0UdndGdA3xONBr62hE-_RBdL-fq6rHLy0PrdsuMn1936TA@mail.gmail.com>
 <20210113061909.GG4678@unreal> <CAKgT0Uc4v54vqRVk_HhjOk=OLJu-20AhuBVcg7=C9_hsLtzxLA@mail.gmail.com>
 <20210114065024.GK4678@unreal>
In-Reply-To: <20210114065024.GK4678@unreal>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Thu, 14 Jan 2021 08:40:14 -0800
Message-ID: <CAKgT0UeTXMeH24L9=wsPc2oJ=ZJ5jSpJeOqiJvsB2J9TFRFzwQ@mail.gmail.com>
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

On Wed, Jan 13, 2021 at 10:50 PM Leon Romanovsky <leon@kernel.org> wrote:
>
> On Wed, Jan 13, 2021 at 02:44:45PM -0800, Alexander Duyck wrote:
> > On Tue, Jan 12, 2021 at 10:19 PM Leon Romanovsky <leon@kernel.org> wrote:
> > >
> > > On Tue, Jan 12, 2021 at 01:34:50PM -0800, Alexander Duyck wrote:
> > > > On Mon, Jan 11, 2021 at 10:56 PM Leon Romanovsky <leon@kernel.org> wrote:
> > > > >
> > > > > On Mon, Jan 11, 2021 at 11:30:39AM -0800, Alexander Duyck wrote:
> > > > > > On Sun, Jan 10, 2021 at 7:10 AM Leon Romanovsky <leon@kernel.org> wrote:
> > > > > > >
> > > > > > > From: Leon Romanovsky <leonro@nvidia.com>
> > > > > > >
> > > > > > > Some SR-IOV capable devices provide an ability to configure specific
> > > > > > > number of MSI-X vectors on their VF prior driver is probed on that VF.
> > > > > > >
> > > > > > > In order to make management easy, provide new read-only sysfs file that
> > > > > > > returns a total number of possible to configure MSI-X vectors.
> > > > > > >
> > > > > > > cat /sys/bus/pci/devices/.../sriov_vf_total_msix
> > > > > > >   = 0 - feature is not supported
> > > > > > >   > 0 - total number of MSI-X vectors to consume by the VFs
> > > > > > >
> > > > > > > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> > > > > > > ---
> > > > > > >  Documentation/ABI/testing/sysfs-bus-pci | 14 +++++++++++
> > > > > > >  drivers/pci/iov.c                       | 31 +++++++++++++++++++++++++
> > > > > > >  drivers/pci/pci.h                       |  3 +++
> > > > > > >  include/linux/pci.h                     |  2 ++
> > > > > > >  4 files changed, 50 insertions(+)
> > > > > > >
> > > > > > > diff --git a/Documentation/ABI/testing/sysfs-bus-pci b/Documentation/ABI/testing/sysfs-bus-pci
> > > > > > > index 05e26e5da54e..64e9b700acc9 100644
> > > > > > > --- a/Documentation/ABI/testing/sysfs-bus-pci
> > > > > > > +++ b/Documentation/ABI/testing/sysfs-bus-pci
> > > > > > > @@ -395,3 +395,17 @@ Description:
> > > > > > >                 The file is writable if the PF is bound to a driver that
> > > > > > >                 supports the ->sriov_set_msix_vec_count() callback and there
> > > > > > >                 is no driver bound to the VF.
> > > > > > > +
> > > > > > > +What:          /sys/bus/pci/devices/.../sriov_vf_total_msix
> > > > > >
> > > > > > In this case I would drop the "vf" and just go with sriov_total_msix
> > > > > > since now you are referring to a global value instead of a per VF
> > > > > > value.
> > > > >
> > > > > This field indicates the amount of MSI-X available for VFs, it doesn't
> > > > > include PFs. The missing "_vf_" will mislead users who will believe that
> > > > > it is all MSI-X vectors available for this device. They will need to take
> > > > > into consideration amount of PF MSI-X in order to calculate the VF distribution.
> > > > >
> > > > > So I would leave "_vf_" here.
> > > >
> > > > The problem is you aren't indicating how many are available for an
> > > > individual VF though, you are indicating how many are available for
> > > > use by SR-IOV to give to the VFs. The fact that you are dealing with a
> > > > pool makes things confusing in my opinion. For example sriov_vf_device
> > > > describes the device ID that will be given to each VF.
> > >
> > > sriov_vf_device is different and is implemented accordingly to the PCI
> > > spec, 9.3.3.11 VF Device ID (Offset 1Ah)
> > > "This field contains the Device ID that should be presented for every VF
> > > to the SI."
> > >
> > > It is one ID for all VFs.
> >
> > Yes, but that is what I am getting at. It is also what the device
> > configuration will be for one VF. So when I read sriov_vf_total_msix
> > it reads as the total for a single VF, not all of the the VFs. That is
> > why I think dropping the "vf_" part of the name would make sense, as
> > what you are describing is the total number of MSI-X vectors for use
> > by SR-IOV VFs.
>
> I can change to anything as long as new name will give clear indication
> that this total number is for VFs and doesn't include SR-IOV PF MSI-X.

It is interesting that you make that distinction.

So in the case of the Intel hardware we had one pool of MSI-X
interrupts that was available for the entire port, both PF and VF.
When we enabled SR-IOV we had to repartition that pool in order to
assign interrupts to devices. So it sounds like in your case you don't
do that and instead the PF is static and the VFs are the only piece
that is flexible. Do I have that correct?

> >
> > > >
> > > > > >
> > > > > > > +Date:          January 2021
> > > > > > > +Contact:       Leon Romanovsky <leonro@nvidia.com>
> > > > > > > +Description:
> > > > > > > +               This file is associated with the SR-IOV PFs.
> > > > > > > +               It returns a total number of possible to configure MSI-X
> > > > > > > +               vectors on the enabled VFs.
> > > > > > > +
> > > > > > > +               The values returned are:
> > > > > > > +                * > 0 - this will be total number possible to consume by VFs,
> > > > > > > +                * = 0 - feature is not supported
> > > > > > > +
> > > > > > > +               If no SR-IOV VFs are enabled, this value will return 0.
> > > > > > > diff --git a/drivers/pci/iov.c b/drivers/pci/iov.c
> > > > > > > index 42c0df4158d1..0a6ddf3230fd 100644
> > > > > > > --- a/drivers/pci/iov.c
> > > > > > > +++ b/drivers/pci/iov.c
> > > > > > > @@ -394,12 +394,22 @@ static ssize_t sriov_drivers_autoprobe_store(struct device *dev,
> > > > > > >         return count;
> > > > > > >  }
> > > > > > >
> > > > > > > +static ssize_t sriov_vf_total_msix_show(struct device *dev,
> > > > > > > +                                       struct device_attribute *attr,
> > > > > > > +                                       char *buf)
> > > > > > > +{
> > > > > > > +       struct pci_dev *pdev = to_pci_dev(dev);
> > > > > > > +
> > > > > > > +       return sprintf(buf, "%d\n", pdev->sriov->vf_total_msix);
> > > > > > > +}
> > > > > > > +
> > > > > >
> > > > > > You display it as a signed value, but unsigned values are not
> > > > > > supported, correct?
> > > > >
> > > > > Right, I made it similar to the vf_msix_set. I can change.
> > > > >
> > > > > >
> > > > > > >  static DEVICE_ATTR_RO(sriov_totalvfs);
> > > > > > >  static DEVICE_ATTR_RW(sriov_numvfs);
> > > > > > >  static DEVICE_ATTR_RO(sriov_offset);
> > > > > > >  static DEVICE_ATTR_RO(sriov_stride);
> > > > > > >  static DEVICE_ATTR_RO(sriov_vf_device);
> > > > > > >  static DEVICE_ATTR_RW(sriov_drivers_autoprobe);
> > > > > > > +static DEVICE_ATTR_RO(sriov_vf_total_msix);
> > > > > > >
> > > > > > >  static struct attribute *sriov_dev_attrs[] = {
> > > > > > >         &dev_attr_sriov_totalvfs.attr,
> > > > > > > @@ -408,6 +418,7 @@ static struct attribute *sriov_dev_attrs[] = {
> > > > > > >         &dev_attr_sriov_stride.attr,
> > > > > > >         &dev_attr_sriov_vf_device.attr,
> > > > > > >         &dev_attr_sriov_drivers_autoprobe.attr,
> > > > > > > +       &dev_attr_sriov_vf_total_msix.attr,
> > > > > > >         NULL,
> > > > > > >  };
> > > > > > >
> > > > > > > @@ -658,6 +669,7 @@ static void sriov_disable(struct pci_dev *dev)
> > > > > > >                 sysfs_remove_link(&dev->dev.kobj, "dep_link");
> > > > > > >
> > > > > > >         iov->num_VFs = 0;
> > > > > > > +       iov->vf_total_msix = 0;
> > > > > > >         pci_iov_set_numvfs(dev, 0);
> > > > > > >  }
> > > > > > >
> > > > > > > @@ -1116,6 +1128,25 @@ int pci_sriov_get_totalvfs(struct pci_dev *dev)
> > > > > > >  }
> > > > > > >  EXPORT_SYMBOL_GPL(pci_sriov_get_totalvfs);
> > > > > > >
> > > > > > > +/**
> > > > > > > + * pci_sriov_set_vf_total_msix - set total number of MSI-X vectors for the VFs
> > > > > > > + * @dev: the PCI PF device
> > > > > > > + * @numb: the total number of MSI-X vector to consume by the VFs
> > > > > > > + *
> > > > > > > + * Sets the number of MSI-X vectors that is possible to consume by the VFs.
> > > > > > > + * This interface is complimentary part of the pci_set_msix_vec_count()
> > > > > > > + * that will be used to configure the required number on the VF.
> > > > > > > + */
> > > > > > > +void pci_sriov_set_vf_total_msix(struct pci_dev *dev, int numb)
> > > > > > > +{
> > > > > > > +       if (!dev->is_physfn || !dev->driver ||
> > > > > > > +           !dev->driver->sriov_set_msix_vec_count)
> > > > > > > +               return;
> > > > > > > +
> > > > > > > +       dev->sriov->vf_total_msix = numb;
> > > > > > > +}
> > > > > > > +EXPORT_SYMBOL_GPL(pci_sriov_set_vf_total_msix);
> > > > > > > +
> > > > > >
> > > > > > This seems broken. What validation is being done on the numb value?
> > > > > > You pass it as int, and your documentation all refers to tests for >=
> > > > > > 0, but isn't a signed input a possibility as well? Also "numb" doesn't
> > > > > > make for a good abbreviation as it is already a word of its own. It
> > > > > > might make more sense to use count or something like that rather than
> > > > > > trying to abbreviate number.
> > > > >
> > > > > "Broken" is a nice word to describe misunderstanding.
> > > >
> > > > Would you prefer "lacking input validation".
> > > >
> > > > I see all this code in there checking for is_physfn and driver and
> > > > sriov_set_msix_vec_count before allowing the setting of vf_total_msix.
> > > > It just seems like a lot of validation is taking place on the wrong
> > > > things if you are just going to be setting a value reporting the total
> > > > number of MSI-X vectors in use for SR-IOV.
> > >
> > > All those checks are in place to ensure that we are not overwriting the
> > > default value, which is 0.
> >
> > Okay, so what you really have is surplus interrupts that you are
> > wanting to give out to VF devices. So when we indicate 0 here as the
> > default it really means we have no additional interrupts to give out.
> > Am I understanding that correctly?
>
> The vf_total_msix is static value and shouldn't be recalculated after
> every MSI-X vector number change. So 0 means that driver doesn't support
> at all this feature. The operator is responsible to make proper assignment
> calculations, because he is already doing it for the CPUs and netdev queues.

Honestly that makes things even uglier. So basically this is a feature
where if it isn't supported it will make it look like the SR-IOV
device doesn't support MSI-X. I realize it is just the way it is
worded but it isn't very pretty.

> >
> > The problem is this is very vendor specific so I am doing my best to
> > understand it as it is different then the other NICs I have worked
> > with.
>
> There is nothing vendor specific here. There are two types of devices:
> 1. Support this feature. - The vf_total_msix will be greater than 0 for them
> and their FW will do sanity checks when user overwrites their default number
> that they sat in the VF creation stage.
> 2. Doesn't support this feature - The vf_total_msix will be 0.
>
> It is PCI spec, so those "other NICs" that didn't implement the PCI spec
> will stay with option #2. It is not different from current situation.

Where in the spec is this?

I know in the PCI spec it says that the MSI-X table size is read-only
and is not supposed to be written by system software. That is what is
being overwritten right now by your patches that has me concerned.

As far as the logic behind the approach described above. You can
define up to the MSI-X table size worth of interrupt vectors, however
nothing says the device has to make use of those vectors. So defining
a table with unused entries works within the spec since all the table
is defining is interrupts you can use, not interrupts you must use. It
basically comes down to the fact that an interrupt can be broken into
target actions which are defined in the table, and "initiators" or
"sources" which are controlled by the internal configuration of the
device and must be associated with the target action for something to
occur. You can have a fixed number of initiators that can be shared
between the targets.

> >
> > So this value is the size of the total pool of interrupt vectors you
> > have to split up between the functions, or just the spare ones you
> > could add to individual VFs? Since you say "total" I am assuming it is
> > the total pool which means that in order to figure out how many are
> > available to be reserved we would have to run through all the VFs and
> > figure out what has already been assigned, correct? If so it wouldn't
> > hurt to also think about having a free and in-use count somewhere as
> > well.
>
> It is not really necessary, the VFs are created with some defaults,
> because FW needs to ensure that after "echo X > sriov_numvfs" everything
> is operable.
>
> As we already discussed, FW has no other way but create VFs with same
> configuration. It means that user needs to check only first VF MSI-X
> number and multiply by number of VFs to get total number of already
> consumed.

That is only at the start though. Once they start modifying VF
interrupts the individual numbers could be all over the place.

> The reserved vectors are implemented by checks in FW to ensure that user
> can't write number below certain level.
>
> I prefer to stay "lean" as much as possible and add extra fields only
> after the real need arise. Right now and for seen future, it is not needed.

It isn't so much about extra fields as the availability of data. When
you have data placed in multiple locations and only a single error
return type if things go wrong it makes it kind of ugly in terms of a
user interface.

> >
> > > >
> > > > In addition this value seems like a custom purpose being pushed into
> > > > the PCIe code since there isn't anything that defaults the value. It
> > > > seems like at a minimum there should be something that programs a
> > > > default value for both of these new fields that are being added so
> > > > that you pull the maximum number of VFs when SR-IOV is enabled, the
> > > > maximum number of MSI-X vectors from a single VF, and then the default
> > > > value for this should be the multiple of the two which can then be
> > > > overridden later.
> > >
> > > The default is 0, because most SR-IOV doesn't have proper support of
> > > setting VF MSI-X.
> >
> > It wasn't designed to work this way. That is why it doesn't really work.
>
> It can be true for everything that doesn't work.
> I will rewrite my sentence above:
> "The default is 0, because I don't have other than mlx5 devices at my disposal,
> so leave it to other driver authors to implement their callbacks"

So you are saying this is a vendor specific interface then? Until we
have another party willing to sign on as this being an approach they
are going to take with their NIC I would question if this is really
the way we want to go about handling this.

I would be curious if any other vendor supports editing the VF MSI-X
table size on the fly. If so then maybe we will have to accept it as a
quirk of SR-IOV. However we really should be trying to avoid this as a
supported method if possible.

> >
> > > Regarding the calculation, it is not correct for the mlx5. We have large
> > > pool of MSI-X vectors, but setting small number of them. This allows us
> > > to increase that number on specific VF without need to decrease on
> > > others "to free" the vectors.
> >
> > I think I am finally starting to grok what is going on here, but I
> > really don't like the approach.
> >
> > Is there any reason why you couldn't have configured your VF to
> > support whatever the maximum number of MSI-X vectors you wanted to use
> > was, and then just internally masked off or disabled the ones that you
> > couldn't allocate to the VF and communicate that to the VF via some
> > sort of firmware message so it wouldn't use them? If I am not mistaken
> > that is the approach that has been taken in the past for at least this
> > portion of things in the Intel drivers.
>
> I'm not proficient in Intel drivers and can't comment it, but the idea
> looks very controversial and hacky to me.
>
> There are so many issues with proposed model:
> 1. During driver probe, the __pci_enable_msix() is called and device MSI-X
> number is used to set internal to the kernel and device configuration.
> It means that vfio will try to set it to be large (our default is huge),
> so we will need to provide some module parameter or sysfs to limit in VFIO
> and it should be done per-VM.

How would that be much different than what you have now? What I was
suggesting is that you could expose your sysfs value either as a part
of binding the VFIO driver, or as a module parameter. You said that
your orchestration was managing this per VM so I see this behaving the
same way. Your orchestration layer would be setting this value to
limit what is exposed in the VM.

The extra call to the PF may be needed in order to guarantee that the
device/firmware knows that it is supposed to ignore the interrupts
past a certain point.

> 2. Without limiting in VFIO during VM attach, the first VM can and will
> grab everything and we are returning to square one.

It depends on how you have this implemented. As I mentioned earlier
the editing of the VF configuration space is troubling since you are
essentially using the firmware to circumvent the read-only protection
that is provided by the spec in order to change the MSI-X table size
on the fly.

Where I think you and I disagree is that I really think the MSI-X
table size should be fixed at one value for the life of the VF.
Instead of changing the table size it should be the number of vectors
that are functional that should be the limit. Basically there should
be only some that are functional and some that are essentially just
dummy vectors that you can write values into that will never be used.

> 3. The difference in lspci output on the hypervisor and inside VM in
> regards of MSI-X vector count will be source of endless bug reports.

Nothing says the two have to differ other than the fact that at a
certain point the MSI-X table stops being written to the hardware and
those vectors beyond that point are internally masked and disabled.

> 4. I afraid that is not how orchestration works.
>
> This supports even more than before the need to do it properly in
> pci/core and make user experience clean, easy and reliable.

I would think that would be pretty straight forward. Basically the
hardware would ignore interrupt vectors entries past a certain point,
and the PBA bits for those entries would always read 0.

> >
> > Then the matter is how to configure it. I'm not a big fan of adding
> > sysfs to the VF to manage resources that are meant to be controlled by
> > the PF. Especially when you are having to add sysfs to the PF as well
> > which creates an asymmetric setup where you are having to read the PF
> > to find out what resources you can move to the VF. I wonder if
> > something like the Devlink Resource interface wouldn't make more sense
> > in this case. Then you would just manage "vf-interrupts" or something
> > like that with the resource split between each of the VFs with each VF
> > uniquely identified as a separate sub resource.
>
> I remind you that this feature is applicable to all SR-IOV devices, we have
> RDMA, NVMe, crypto, FPGA and netdev VFs. The devlink is not supported
> outside of netdev world and implementation there will make this feature
> is far from being usable.

To quote the documentation:
"devlink is an API to expose device information and resources not directly
related to any device class, such as chip-wide/switch-ASIC-wide configuration."

> Right now, the configuration of PCI/core is done through sysfs, so let's
> review this feature from PCI/core perspective and not from netdev where
> sysfs is not widely used.

The problem is what you are configuring is not necessarily PCI device
specific. You are configuring the firmware which operates at a level
above the PCI device. You just have it manifesting as a PCI behavior
as you are editing a read-only configuration space field.

Also as I mentioned a few times now the approach you are taking
violates the PCIe spec by essentially providing a means of making a
read-only field writable.
