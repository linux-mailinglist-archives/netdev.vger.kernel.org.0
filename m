Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C44CB2F53C7
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 21:01:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728779AbhAMUAx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 15:00:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728698AbhAMUAw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jan 2021 15:00:52 -0500
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5595AC061575;
        Wed, 13 Jan 2021 12:00:12 -0800 (PST)
Received: by mail-io1-xd2f.google.com with SMTP id q1so6608893ion.8;
        Wed, 13 Jan 2021 12:00:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ug4lxiPSLxqiOUoVUvwPGPMVsksT+QewaSLAyssNLT8=;
        b=niDOQikfivG1csD9oynZFH3OMttp9YFxXoh9++ilfwtScrv/bqF9JcsdG7QQsVvrNT
         p9Pb05zp2wWpWminxNWcG53LmlQY+gaHlmH+pUu22BtFPlGU7C1b3zcMftCOU5W6JpqW
         uURUDvGAPNREnFZLpiEk/PIpK/b/4Wc9HbEoRh4QO8+t1HIJxBSIDkJWqANY1CA6tEXY
         NJXM0b5TuGzgRQUs/HXMS1Zhtfn68hKFaT1XIK+/4k8Ttbix5ntdu4y9NqQXyJYAe4W6
         F1VRwsfLm6DtdtB04Nsp+6/7CCpuWIOTzbUnYFwBXDZ5eZJVH8R206UIPJRkjEbeD2/A
         9FHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ug4lxiPSLxqiOUoVUvwPGPMVsksT+QewaSLAyssNLT8=;
        b=PwZk/VH2lFodBqKcUw5L91qVzMDVXhRzaekCYFdhTirshCuQqf5K8FTam0bCGV3Nq/
         7R1/rVgxeqp1Qpq8LRj1KOE5dqs4ar3lRTY8nWhFmUF2rd5fYrna5knpb0tsa6jyzlit
         y86NJ0cHhDoXpjAzkdVdtXrL0TZBNvGESLHhfvF7N8B8gX90sSqS5lejP3ihpqt0i0gM
         /xRAk0fXTHIJGkaLr/IXsR3ANFyVt2Wnoc7Q/roFGYfSMEFyCLMTgn5dKdgIY88u5h4e
         FYkeScwYfMURGbysH1ce76qj6MsCz2gw0TgnxUM26m3Y13S0ZrBxFLdJoiWvkIFhFB+I
         QokQ==
X-Gm-Message-State: AOAM533NV6YEgTz/Na1vX3sLk9kTtwA0pY1XjlVufLnTcshyCkaU/Xej
        sUyLiijdcNVGhbfflKSpjO32mo37fMNWRTY5Drs=
X-Google-Smtp-Source: ABdhPJxhUzJrugTQp49tjEankoY00ZqINxVKTgxQmuXKBmbSDWsuNlZO0ZLxhdDLD9Uj3ywq3ZKWbxZuRjIhK7XXjnA=
X-Received: by 2002:a6b:d007:: with SMTP id x7mr2995953ioa.88.1610568011420;
 Wed, 13 Jan 2021 12:00:11 -0800 (PST)
MIME-Version: 1.0
References: <20210110150727.1965295-1-leon@kernel.org> <20210110150727.1965295-2-leon@kernel.org>
 <CAKgT0UcJrSNMPAOoniRSnUn+wyRUkL62AfgR3-8QbAkak=pQ=w@mail.gmail.com>
 <20210112063925.GC4678@unreal> <CAKgT0Udxd01agBMruooMi8TfAE+QkMt8n7-a2QrZ7Pj6-oFEAg@mail.gmail.com>
 <20210113060938.GF4678@unreal>
In-Reply-To: <20210113060938.GF4678@unreal>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Wed, 13 Jan 2021 12:00:00 -0800
Message-ID: <CAKgT0UecBX+LTR9GuxFb=P+pcUkjU5RYNNjeynExS-9Pik1Hsg@mail.gmail.com>
Subject: Re: [PATCH mlx5-next v1 1/5] PCI: Add sysfs callback to allow MSI-X
 table size change of SR-IOV VFs
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

On Tue, Jan 12, 2021 at 10:09 PM Leon Romanovsky <leon@kernel.org> wrote:
>
> On Tue, Jan 12, 2021 at 01:59:51PM -0800, Alexander Duyck wrote:
> > On Mon, Jan 11, 2021 at 10:39 PM Leon Romanovsky <leon@kernel.org> wrote:
> > >
> > > On Mon, Jan 11, 2021 at 11:30:33AM -0800, Alexander Duyck wrote:
> > > > On Sun, Jan 10, 2021 at 7:12 AM Leon Romanovsky <leon@kernel.org> wrote:
> > > > >
> > > > > From: Leon Romanovsky <leonro@nvidia.com>
> > > > >
> > > > > Extend PCI sysfs interface with a new callback that allows configure
> > > > > the number of MSI-X vectors for specific SR-IO VF. This is needed
> > > > > to optimize the performance of newly bound devices by allocating
> > > > > the number of vectors based on the administrator knowledge of targeted VM.
> > > > >
> > > > > This function is applicable for SR-IOV VF because such devices allocate
> > > > > their MSI-X table before they will run on the VMs and HW can't guess the
> > > > > right number of vectors, so the HW allocates them statically and equally.
> > > > >
> > > > > The newly added /sys/bus/pci/devices/.../vf_msix_vec file will be seen
> > > > > for the VFs and it is writable as long as a driver is not bounded to the VF.
> > > > >
> > > > > The values accepted are:
> > > > >  * > 0 - this will be number reported by the VF's MSI-X capability
> > > > >  * < 0 - not valid
> > > > >  * = 0 - will reset to the device default value
> > > > >
> > > > > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> > > > > ---
> > > > >  Documentation/ABI/testing/sysfs-bus-pci | 20 ++++++++
> > > > >  drivers/pci/iov.c                       | 62 +++++++++++++++++++++++++
> > > > >  drivers/pci/msi.c                       | 29 ++++++++++++
> > > > >  drivers/pci/pci-sysfs.c                 |  1 +
> > > > >  drivers/pci/pci.h                       |  2 +
> > > > >  include/linux/pci.h                     |  8 +++-
> > > > >  6 files changed, 121 insertions(+), 1 deletion(-)
> > > > >
> > > > > diff --git a/Documentation/ABI/testing/sysfs-bus-pci b/Documentation/ABI/testing/sysfs-bus-pci
> > > > > index 25c9c39770c6..05e26e5da54e 100644
> > > > > --- a/Documentation/ABI/testing/sysfs-bus-pci
> > > > > +++ b/Documentation/ABI/testing/sysfs-bus-pci
> > > > > @@ -375,3 +375,23 @@ Description:
> > > > >                 The value comes from the PCI kernel device state and can be one
> > > > >                 of: "unknown", "error", "D0", D1", "D2", "D3hot", "D3cold".
> > > > >                 The file is read only.
> > > > > +
> > > > > +What:          /sys/bus/pci/devices/.../vf_msix_vec
> > > >
> > > > So the name for this doesn't seem to match existing SR-IOV naming.  It
> > > > seems like this should probably be something like sriov_vf_msix_count
> > > > in order to be closer to the actual naming of what is being dealt
> > > > with.
> > >
> > > I'm open for suggestions. I didn't use sriov_vf_msix_count because it
> > > seems too long for me.
> > >
> > > >
> > > > > +Date:          December 2020
> > > > > +Contact:       Leon Romanovsky <leonro@nvidia.com>
> > > > > +Description:
> > > > > +               This file is associated with the SR-IOV VFs.
> > > > > +               It allows configuration of the number of MSI-X vectors for
> > > > > +               the VF. This is needed to optimize performance of newly bound
> > > > > +               devices by allocating the number of vectors based on the
> > > > > +               administrator knowledge of targeted VM.
> > > > > +
> > > > > +               The values accepted are:
> > > > > +                * > 0 - this will be number reported by the VF's MSI-X
> > > > > +                        capability
> > > > > +                * < 0 - not valid
> > > > > +                * = 0 - will reset to the device default value
> > > > > +
> > > > > +               The file is writable if the PF is bound to a driver that
> > > > > +               supports the ->sriov_set_msix_vec_count() callback and there
> > > > > +               is no driver bound to the VF.
> > > > > diff --git a/drivers/pci/iov.c b/drivers/pci/iov.c
> > > > > index 4afd4ee4f7f0..42c0df4158d1 100644
> > > > > --- a/drivers/pci/iov.c
> > > > > +++ b/drivers/pci/iov.c
> > > > > @@ -31,6 +31,7 @@ int pci_iov_virtfn_devfn(struct pci_dev *dev, int vf_id)
> > > > >         return (dev->devfn + dev->sriov->offset +
> > > > >                 dev->sriov->stride * vf_id) & 0xff;
> > > > >  }
> > > > > +EXPORT_SYMBOL(pci_iov_virtfn_devfn);
> > > > >
> > > > >  /*
> > > > >   * Per SR-IOV spec sec 3.3.10 and 3.3.11, First VF Offset and VF Stride may
> > > > > @@ -426,6 +427,67 @@ const struct attribute_group sriov_dev_attr_group = {
> > > > >         .is_visible = sriov_attrs_are_visible,
> > > > >  };
> > > > >
> > > > > +#ifdef CONFIG_PCI_MSI
> > > > > +static ssize_t vf_msix_vec_show(struct device *dev,
> > > > > +                               struct device_attribute *attr, char *buf)
> > > > > +{
> > > > > +       struct pci_dev *pdev = to_pci_dev(dev);
> > > > > +       int numb = pci_msix_vec_count(pdev);
> > > > > +       struct pci_dev *pfdev;
> > > > > +
> > > > > +       if (numb < 0)
> > > > > +               return numb;
> > > > > +
> > > > > +       pfdev = pci_physfn(pdev);
> > > > > +       if (!pfdev->driver || !pfdev->driver->sriov_set_msix_vec_count)
> > > > > +               return -EOPNOTSUPP;
> > > > > +
> > > >
> > > > This doesn't make sense to me. You are getting the vector count for
> > > > the PCI device and reporting that. Are you expecting to call this on
> > > > the PF or the VFs? It seems like this should be a PF attribute and not
> > > > be called on the individual VFs.
> > >
> > > We had this discussion over v0 variant of this series.
> > > https://lore.kernel.org/linux-pci/20210108072525.GB31158@unreal/
> > >
> > > This is per-VF property, but this VF is not bounded to the driver so you
> > > need some way to convey new number to the HW, so it will update PCI value.
> > >
> > > You must change/update this field after VF is created, because all SR-IOV VFs
> > > are created at the same time. The operator (administrator/orchestration
> > > software/e.t.c) will know the right amount of MSI-X vectors right before
> > > he will bind this VF to requested VM.
> > >
> > > It means that extending PF sysfs to get both VF index and count will
> > > look very unfriendly for the users.
> > >
> > > The PF here is an anchor to the relevant driver.
> >
> > Yes, but the problem is you are attempting to do it after a driver may
> > have already bound itself to the VF device. This setup works for the
> > direct assigned VF case, however if the VF drivers are running on the
> > host then this gets ugly as the driver may already be up and running.
>
> Please take a look on the pci_set_msix_vec_count() implementation, it
> checks that VF is not probed yet. I outlined this requirement almost
> in all my responses and commit messages.
>
> So no, it is not possible to set MSI-X vectors to already bound device.

Unless you are holding the device lock you cannot guarantee that as
Alex Williamson pointed out you can end up racing with the driver
probe/remove.

Secondly the fact that the driver might be probed before you even get
to make your call will cause this to return EOPNOTSUPP which doesn't
exactly make sense since it is supported, you just cannot do it since
the device is busy.

> >
> > Also I am not a big fan of the VF groping around looking for a PF
> > interface as it means the interface will likely be exposed in the
> > guest as well, but it just won't work.
>
> If you are referring to VF exposed to the VM, so in this case VF must be
> bound too vfio driver, or any other driver, and won't allow MSI-X change.
> If you are referring to PF exposed to the VM, it is very unlikely scenario
> in real world and reserved for braves among us. Even in this case, the
> set MSI-X won't work, because PF will be connected to the hypervisor driver
> that doesn't support set_msix.
>
> So both cases are handled.

I get that they are handled. However I am not a huge fan of the sysfs
attributes for one device being dependent on another device. When you
have to start searching for another device it just makes things messy.

> >
> > > >
> > > > If you are calling this on the VFs then it doesn't really make any
> > > > sense anyway since the VF is not a "VF PCI dev representor" and
> > > > shouldn't be treated as such. In my opinion if we are going to be
> > > > doing per-port resource limiting that is something that might make
> > > > more sense as a part of the devlink configuration for the VF since the
> > > > actual change won't be visible to an assigned device.
> > >
> > > https://lore.kernel.org/linux-pci/20210112061535.GB4678@unreal/
> >
> > So the question I would have is if we are spawning the VFs and
> > expecting them to have different configs or the same configuration?
>
> By default, they have same configuration.
>
> > I'm assuming in your case you are looking for a different
> > configuration per port. Do I have that correct?
>
> No, per-VF as represents one device in the PCI world. For example, mlx5
> can have more than one physical port.

Sorry, I meant per virtual function, not per port.

> >
> > Where this gets ugly is that SR-IOV assumes a certain uniformity per
> > VF so doing a per-VF custom limitation gets ugly pretty quick.
>
> I don't find any support for this "uniformity" claim in the PCI spec.

I am referring to the PCI configuration space. Each VF ends up with
some fixed amount of MMIO resources per function. So typically when
you spawn VFs we had things setup so that all you do is say how many
you want.

> > I wonder if it would make more sense if we are going this route to just
> > define a device-tree like schema that could be fed in to enable VFs
> > instead of just using echo X > sriov_numvfs and then trying to fix
> > things afterwards. Then you could define this and other features that
> > I am sure you would need in the future via json-schema like is done in
> > device-tree and write it once enabling the set of VFs that you need.
>
> Sorry, but this is overkill, it won't give us much and it doesn't fit
> the VF usage model at all.
>
> Right now, all heavy users of SR-IOV are creating many VFs up to the maximum.
> They do it with autoprobe disabled, because it is too time consuming to wait
> till all VFs probe themselves and unbind them later.
>
> After that, they wait for incoming request to provision VM on VF, they set MAC
> address, change MSI-X according to VM properties and bind that VF to new VM.
>
> So MSI-X change is done after VFs were created.

So if I understand correctly based on your comments below you are
dynamically changing the VF's MSI-X configuration space then?

> >
> > Given that SR-IOV isn't meant to be tweaked dynamically it seems like
> > that would be a much better fit for most users as then you can just
> > modify the schema and reload it which would probably be less effort
> > than having to manually redo all the commands needed to setup the VFs
> > using this approach if you are having to manually update each VF.
>
> Quite opposite it true. First users use orchestration software to manage it.
> Second, you will need to take care of already bound device.

This is the part that concerns me. It seems like this is all adding a
bunch of orchestration need to all of this. Basically the device
config can shift out from under us on the host if we aren't paying
attention.

> >
> > > >
> > > > > +       return sprintf(buf, "%d\n", numb);
> > > > > +}
> > > > > +
> > > > > +static ssize_t vf_msix_vec_store(struct device *dev,
> > > > > +                                struct device_attribute *attr, const char *buf,
> > > > > +                                size_t count)
> > > > > +{
> > > > > +       struct pci_dev *vf_dev = to_pci_dev(dev);
> > > > > +       int val, ret;
> > > > > +
> > > > > +       ret = kstrtoint(buf, 0, &val);
> > > > > +       if (ret)
> > > > > +               return ret;
> > > > > +
> > > > > +       ret = pci_set_msix_vec_count(vf_dev, val);
> > > > > +       if (ret)
> > > > > +               return ret;
> > > > > +
> > > > > +       return count;
> > > > > +}
> > > > > +static DEVICE_ATTR_RW(vf_msix_vec);
> > > > > +#endif
> > > > > +
> > > > > +static struct attribute *sriov_vf_dev_attrs[] = {
> > > > > +#ifdef CONFIG_PCI_MSI
> > > > > +       &dev_attr_vf_msix_vec.attr,
> > > > > +#endif
> > > > > +       NULL,
> > > > > +};
> > > > > +
> > > > > +static umode_t sriov_vf_attrs_are_visible(struct kobject *kobj,
> > > > > +                                         struct attribute *a, int n)
> > > > > +{
> > > > > +       struct device *dev = kobj_to_dev(kobj);
> > > > > +
> > > > > +       if (dev_is_pf(dev))
> > > > > +               return 0;
> > > > > +
> > > > > +       return a->mode;
> > > > > +}
> > > > > +
> > > > > +const struct attribute_group sriov_vf_dev_attr_group = {
> > > > > +       .attrs = sriov_vf_dev_attrs,
> > > > > +       .is_visible = sriov_vf_attrs_are_visible,
> > > > > +};
> > > > > +
> > > > >  int __weak pcibios_sriov_enable(struct pci_dev *pdev, u16 num_vfs)
> > > > >  {
> > > > >         return 0;
> > > > > diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
> > > > > index 3162f88fe940..20705ca94666 100644
> > > > > --- a/drivers/pci/msi.c
> > > > > +++ b/drivers/pci/msi.c
> > > > > @@ -991,6 +991,35 @@ int pci_msix_vec_count(struct pci_dev *dev)
> > > > >  }
> > > > >  EXPORT_SYMBOL(pci_msix_vec_count);
> > > > >
> > > > > +/**
> > > > > + * pci_set_msix_vec_count - change the reported number of MSI-X vectors
> > > > > + * This function is applicable for SR-IOV VF because such devices allocate
> > > > > + * their MSI-X table before they will run on the VMs and HW can't guess the
> > > > > + * right number of vectors, so the HW allocates them statically and equally.
> > > > > + * @dev: VF device that is going to be changed
> > > > > + * @numb: amount of MSI-X vectors
> > > > > + **/
> > > > > +int pci_set_msix_vec_count(struct pci_dev *dev, int numb)
> > > > > +{
> > > > > +       struct pci_dev *pdev = pci_physfn(dev);
> > > > > +
> > > > > +       if (!dev->msix_cap || !pdev->msix_cap)
> > > > > +               return -EINVAL;
> > > > > +
> > > > > +       if (dev->driver || !pdev->driver ||
> > > > > +           !pdev->driver->sriov_set_msix_vec_count)
> > > > > +               return -EOPNOTSUPP;
> > > > > +
> > > > > +       if (numb < 0)
> > > > > +               /*
> > > > > +                * We don't support negative numbers for now,
> > > > > +                * but maybe in the future it will make sense.
> > > > > +                */
> > > > > +               return -EINVAL;
> > > > > +
> > > > > +       return pdev->driver->sriov_set_msix_vec_count(dev, numb);
> > > > > +}
> > > > > +
> > > >
> > > > If you are going to have a set operation for this it would make sense
> > > > to have a get operation. Your show operation seems unbalanced since
> > > > you are expecting to call it on the VF directly which just seems
> > > > wrong.
> > >
> > > There is already get operator - pci_msix_vec_count().
> > > The same as above, PF is an anchor for the driver. VF doesn't have
> > > driver yet and we can't write directly to this PCI field - it is read-only.
> >
> > That returns the maximum. I would want to know what the value is that
> > you wrote here.
>
> It returns the value from the device and not maximum.

Okay, that was the part I hadn't caught onto. That you were using this
to make read-only configuration space writable.

> >
> > Also being able to change this once the device already exists is kind
> > of an ugly setup as I would imagine there will be cases where the
> > device has already partitioned out the vectors that it wanted.
>
> It is not possible, because all VFs starts with some value. Normal FW
> won't allow you to decrease vector count below certain limit.
>
> So VFs are always operable.

I get that. My concern is more the fact that you are modifying read
only bits within the configuration space that is visible to the host.
I initially thought you were doing the dynamic resizing behind the
scenes by just not enabling some of the MSI-X vectors in the table.
However, as I understand it now you are resizing the MSI-X table
itself which doesn't seem correct to me. The read-only portions of the
configuration space shouldn't be changed, at least within the host. I
just see the changing of fields that are expected to be static to be
problematic.

If all of this is just to tweak the MSI-X table size in the guest
/userspace wouldn't it just make more sense to add the ability for
vfio to limit this directly and perhaps intercept the reads to the
MSI-X control register? Then you could have vfio also take care of the
coordination of things with the driver which would make much more
sense to me as then you don't have to worry about a device on the host
changing size unexpectedly.

Anyway that is just my $.02.

- Alex
