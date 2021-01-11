Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30E1E2F1F6E
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 20:32:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403929AbhAKTb0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 14:31:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732738AbhAKTbZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 14:31:25 -0500
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBA4BC061795;
        Mon, 11 Jan 2021 11:30:44 -0800 (PST)
Received: by mail-io1-xd29.google.com with SMTP id q1so809516ion.8;
        Mon, 11 Jan 2021 11:30:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1Q3XkyimqmHilM0dZitgB5skrZkbp4Cr6XHZvmlMCF8=;
        b=kdXxQvAIiRj9PMvPt6e0UVinqvhADDIVmCa2CZHjVVqkH5PAIAkp5wxQq03bmL8FxK
         zEaWjdTgfY4E9ps9r/bRN9FsDP/vG31RiAy8yirj0MY+YcFUfF8jdoy0Cl/UX1c6nXuW
         rjoqVs+TFl42uIK6r9dbRK4inRCM+e1o3LoI0n0M+AF1OboP8gQKbkKe2juwfb9AMhJF
         MbKjZs80VLT0rjfTFmoh7DMBVEW2PrcseyF5BuJUTQUfMY2d9gqNzE8dIp9uGIQCEHlH
         d/2nW5VDK/chOWv8C0dK+cN0UgjnMVtpTCpaSxcmvKvErNXvcJ7Zb3dDiSp4K/jaYhNZ
         kAQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1Q3XkyimqmHilM0dZitgB5skrZkbp4Cr6XHZvmlMCF8=;
        b=L+fw86fGowiMpM36Bl9sf9u+xAqkB8KAu2x2sUMopqxBrVvNKhQX+mbgXjkVHGpZsR
         Zbnn52/mo8+MVmSOLeJ27kbJrwqfR9lU3SHuYKX14G2m3rRlE4T7eqaePKHuzwQo06rD
         mdWlOiWpeNb0aCjs7nrZBCuMEIAdExLA6fmsD+f14x8savfp5EzCVZwbooU+C2VEfeor
         7M369ja/+P4ieloe9OI8mEMhlU4K+PcPUW7H98nBILfhJF9QxjwtrYSEc7avrdAGdz/0
         159mVfM7BQaJ4BetndVWzy7AneNHT9z3EZPyba/+6+g0nydsKE+xmyYcMbMPUkbDqtkH
         uL4w==
X-Gm-Message-State: AOAM533gAlCdRLaVI3REMPtu+d4fVl0hn++4ddoio1ZVRP6kAMTJI4Qu
        fhBGwNH7jRIZDrdvDZraeOvuy4NTHIEyMUrLU3U=
X-Google-Smtp-Source: ABdhPJwuuC1ylnEZ8pYOqqfAiieC9e+zhkIOiTo5Bc1HzPz97MdiBKC08sr9QDNim8MjskhCPu9NiyU5fbcVxUBC3vE=
X-Received: by 2002:a05:6638:30f:: with SMTP id w15mr1106035jap.121.1610393444099;
 Mon, 11 Jan 2021 11:30:44 -0800 (PST)
MIME-Version: 1.0
References: <20210110150727.1965295-1-leon@kernel.org> <20210110150727.1965295-2-leon@kernel.org>
In-Reply-To: <20210110150727.1965295-2-leon@kernel.org>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Mon, 11 Jan 2021 11:30:33 -0800
Message-ID: <CAKgT0UcJrSNMPAOoniRSnUn+wyRUkL62AfgR3-8QbAkak=pQ=w@mail.gmail.com>
Subject: Re: [PATCH mlx5-next v1 1/5] PCI: Add sysfs callback to allow MSI-X
 table size change of SR-IOV VFs
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Bjorn Helgaas <bhelgaas@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
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

On Sun, Jan 10, 2021 at 7:12 AM Leon Romanovsky <leon@kernel.org> wrote:
>
> From: Leon Romanovsky <leonro@nvidia.com>
>
> Extend PCI sysfs interface with a new callback that allows configure
> the number of MSI-X vectors for specific SR-IO VF. This is needed
> to optimize the performance of newly bound devices by allocating
> the number of vectors based on the administrator knowledge of targeted VM.
>
> This function is applicable for SR-IOV VF because such devices allocate
> their MSI-X table before they will run on the VMs and HW can't guess the
> right number of vectors, so the HW allocates them statically and equally.
>
> The newly added /sys/bus/pci/devices/.../vf_msix_vec file will be seen
> for the VFs and it is writable as long as a driver is not bounded to the VF.
>
> The values accepted are:
>  * > 0 - this will be number reported by the VF's MSI-X capability
>  * < 0 - not valid
>  * = 0 - will reset to the device default value
>
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> ---
>  Documentation/ABI/testing/sysfs-bus-pci | 20 ++++++++
>  drivers/pci/iov.c                       | 62 +++++++++++++++++++++++++
>  drivers/pci/msi.c                       | 29 ++++++++++++
>  drivers/pci/pci-sysfs.c                 |  1 +
>  drivers/pci/pci.h                       |  2 +
>  include/linux/pci.h                     |  8 +++-
>  6 files changed, 121 insertions(+), 1 deletion(-)
>
> diff --git a/Documentation/ABI/testing/sysfs-bus-pci b/Documentation/ABI/testing/sysfs-bus-pci
> index 25c9c39770c6..05e26e5da54e 100644
> --- a/Documentation/ABI/testing/sysfs-bus-pci
> +++ b/Documentation/ABI/testing/sysfs-bus-pci
> @@ -375,3 +375,23 @@ Description:
>                 The value comes from the PCI kernel device state and can be one
>                 of: "unknown", "error", "D0", D1", "D2", "D3hot", "D3cold".
>                 The file is read only.
> +
> +What:          /sys/bus/pci/devices/.../vf_msix_vec

So the name for this doesn't seem to match existing SR-IOV naming.  It
seems like this should probably be something like sriov_vf_msix_count
in order to be closer to the actual naming of what is being dealt
with.

> +Date:          December 2020
> +Contact:       Leon Romanovsky <leonro@nvidia.com>
> +Description:
> +               This file is associated with the SR-IOV VFs.
> +               It allows configuration of the number of MSI-X vectors for
> +               the VF. This is needed to optimize performance of newly bound
> +               devices by allocating the number of vectors based on the
> +               administrator knowledge of targeted VM.
> +
> +               The values accepted are:
> +                * > 0 - this will be number reported by the VF's MSI-X
> +                        capability
> +                * < 0 - not valid
> +                * = 0 - will reset to the device default value
> +
> +               The file is writable if the PF is bound to a driver that
> +               supports the ->sriov_set_msix_vec_count() callback and there
> +               is no driver bound to the VF.
> diff --git a/drivers/pci/iov.c b/drivers/pci/iov.c
> index 4afd4ee4f7f0..42c0df4158d1 100644
> --- a/drivers/pci/iov.c
> +++ b/drivers/pci/iov.c
> @@ -31,6 +31,7 @@ int pci_iov_virtfn_devfn(struct pci_dev *dev, int vf_id)
>         return (dev->devfn + dev->sriov->offset +
>                 dev->sriov->stride * vf_id) & 0xff;
>  }
> +EXPORT_SYMBOL(pci_iov_virtfn_devfn);
>
>  /*
>   * Per SR-IOV spec sec 3.3.10 and 3.3.11, First VF Offset and VF Stride may
> @@ -426,6 +427,67 @@ const struct attribute_group sriov_dev_attr_group = {
>         .is_visible = sriov_attrs_are_visible,
>  };
>
> +#ifdef CONFIG_PCI_MSI
> +static ssize_t vf_msix_vec_show(struct device *dev,
> +                               struct device_attribute *attr, char *buf)
> +{
> +       struct pci_dev *pdev = to_pci_dev(dev);
> +       int numb = pci_msix_vec_count(pdev);
> +       struct pci_dev *pfdev;
> +
> +       if (numb < 0)
> +               return numb;
> +
> +       pfdev = pci_physfn(pdev);
> +       if (!pfdev->driver || !pfdev->driver->sriov_set_msix_vec_count)
> +               return -EOPNOTSUPP;
> +

This doesn't make sense to me. You are getting the vector count for
the PCI device and reporting that. Are you expecting to call this on
the PF or the VFs? It seems like this should be a PF attribute and not
be called on the individual VFs.

If you are calling this on the VFs then it doesn't really make any
sense anyway since the VF is not a "VF PCI dev representor" and
shouldn't be treated as such. In my opinion if we are going to be
doing per-port resource limiting that is something that might make
more sense as a part of the devlink configuration for the VF since the
actual change won't be visible to an assigned device.

> +       return sprintf(buf, "%d\n", numb);
> +}
> +
> +static ssize_t vf_msix_vec_store(struct device *dev,
> +                                struct device_attribute *attr, const char *buf,
> +                                size_t count)
> +{
> +       struct pci_dev *vf_dev = to_pci_dev(dev);
> +       int val, ret;
> +
> +       ret = kstrtoint(buf, 0, &val);
> +       if (ret)
> +               return ret;
> +
> +       ret = pci_set_msix_vec_count(vf_dev, val);
> +       if (ret)
> +               return ret;
> +
> +       return count;
> +}
> +static DEVICE_ATTR_RW(vf_msix_vec);
> +#endif
> +
> +static struct attribute *sriov_vf_dev_attrs[] = {
> +#ifdef CONFIG_PCI_MSI
> +       &dev_attr_vf_msix_vec.attr,
> +#endif
> +       NULL,
> +};
> +
> +static umode_t sriov_vf_attrs_are_visible(struct kobject *kobj,
> +                                         struct attribute *a, int n)
> +{
> +       struct device *dev = kobj_to_dev(kobj);
> +
> +       if (dev_is_pf(dev))
> +               return 0;
> +
> +       return a->mode;
> +}
> +
> +const struct attribute_group sriov_vf_dev_attr_group = {
> +       .attrs = sriov_vf_dev_attrs,
> +       .is_visible = sriov_vf_attrs_are_visible,
> +};
> +
>  int __weak pcibios_sriov_enable(struct pci_dev *pdev, u16 num_vfs)
>  {
>         return 0;
> diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
> index 3162f88fe940..20705ca94666 100644
> --- a/drivers/pci/msi.c
> +++ b/drivers/pci/msi.c
> @@ -991,6 +991,35 @@ int pci_msix_vec_count(struct pci_dev *dev)
>  }
>  EXPORT_SYMBOL(pci_msix_vec_count);
>
> +/**
> + * pci_set_msix_vec_count - change the reported number of MSI-X vectors
> + * This function is applicable for SR-IOV VF because such devices allocate
> + * their MSI-X table before they will run on the VMs and HW can't guess the
> + * right number of vectors, so the HW allocates them statically and equally.
> + * @dev: VF device that is going to be changed
> + * @numb: amount of MSI-X vectors
> + **/
> +int pci_set_msix_vec_count(struct pci_dev *dev, int numb)
> +{
> +       struct pci_dev *pdev = pci_physfn(dev);
> +
> +       if (!dev->msix_cap || !pdev->msix_cap)
> +               return -EINVAL;
> +
> +       if (dev->driver || !pdev->driver ||
> +           !pdev->driver->sriov_set_msix_vec_count)
> +               return -EOPNOTSUPP;
> +
> +       if (numb < 0)
> +               /*
> +                * We don't support negative numbers for now,
> +                * but maybe in the future it will make sense.
> +                */
> +               return -EINVAL;
> +
> +       return pdev->driver->sriov_set_msix_vec_count(dev, numb);
> +}
> +

If you are going to have a set operation for this it would make sense
to have a get operation. Your show operation seems unbalanced since
you are expecting to call it on the VF directly which just seems
wrong.

>  static int __pci_enable_msix(struct pci_dev *dev, struct msix_entry *entries,
>                              int nvec, struct irq_affinity *affd, int flags)
>  {
> diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
> index fb072f4b3176..0af2222643c2 100644
> --- a/drivers/pci/pci-sysfs.c
> +++ b/drivers/pci/pci-sysfs.c
> @@ -1557,6 +1557,7 @@ static const struct attribute_group *pci_dev_attr_groups[] = {
>         &pci_dev_hp_attr_group,
>  #ifdef CONFIG_PCI_IOV
>         &sriov_dev_attr_group,
> +       &sriov_vf_dev_attr_group,
>  #endif
>         &pci_bridge_attr_group,
>         &pcie_dev_attr_group,
> diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
> index 5c59365092fa..1fd273077637 100644
> --- a/drivers/pci/pci.h
> +++ b/drivers/pci/pci.h
> @@ -183,6 +183,7 @@ extern unsigned int pci_pm_d3hot_delay;
>
>  #ifdef CONFIG_PCI_MSI
>  void pci_no_msi(void);
> +int pci_set_msix_vec_count(struct pci_dev *dev, int numb);
>  #else
>  static inline void pci_no_msi(void) { }
>  #endif
> @@ -502,6 +503,7 @@ resource_size_t pci_sriov_resource_alignment(struct pci_dev *dev, int resno);
>  void pci_restore_iov_state(struct pci_dev *dev);
>  int pci_iov_bus_range(struct pci_bus *bus);
>  extern const struct attribute_group sriov_dev_attr_group;
> +extern const struct attribute_group sriov_vf_dev_attr_group;
>  #else
>  static inline int pci_iov_init(struct pci_dev *dev)
>  {
> diff --git a/include/linux/pci.h b/include/linux/pci.h
> index b32126d26997..a17cfc28eb66 100644
> --- a/include/linux/pci.h
> +++ b/include/linux/pci.h
> @@ -856,6 +856,8 @@ struct module;
>   *             e.g. drivers/net/e100.c.
>   * @sriov_configure: Optional driver callback to allow configuration of
>   *             number of VFs to enable via sysfs "sriov_numvfs" file.
> + * @sriov_set_msix_vec_count: Driver callback to change number of MSI-X vectors
> + *              exposed by the sysfs "vf_msix_vec" entry.

Hopefully it is doing more than just changing the displayed sysfs
value. What is the effect of changing that value on the actual system
state? I'm assuming this is some limit that is enforced by the PF or
the device firmware?


>   * @err_handler: See Documentation/PCI/pci-error-recovery.rst
>   * @groups:    Sysfs attribute groups.
>   * @driver:    Driver model structure.
> @@ -871,6 +873,7 @@ struct pci_driver {
>         int  (*resume)(struct pci_dev *dev);    /* Device woken up */
>         void (*shutdown)(struct pci_dev *dev);
>         int  (*sriov_configure)(struct pci_dev *dev, int num_vfs); /* On PF */
> +       int  (*sriov_set_msix_vec_count)(struct pci_dev *vf, int msix_vec_count); /* On PF */
>         const struct pci_error_handlers *err_handler;
>         const struct attribute_group **groups;
>         struct device_driver    driver;
> @@ -2057,7 +2060,6 @@ void __iomem *pci_ioremap_wc_bar(struct pci_dev *pdev, int bar);
>
>  #ifdef CONFIG_PCI_IOV
>  int pci_iov_virtfn_bus(struct pci_dev *dev, int id);
> -int pci_iov_virtfn_devfn(struct pci_dev *dev, int id);
>
>  int pci_enable_sriov(struct pci_dev *dev, int nr_virtfn);
>  void pci_disable_sriov(struct pci_dev *dev);
> @@ -2402,6 +2404,10 @@ static inline bool pci_is_thunderbolt_attached(struct pci_dev *pdev)
>  void pci_uevent_ers(struct pci_dev *pdev, enum  pci_ers_result err_type);
>  #endif
>
> +#ifdef CONFIG_PCI_IOV
> +int pci_iov_virtfn_devfn(struct pci_dev *dev, int vf_id);
> +#endif
> +
>  /* Provide the legacy pci_dma_* API */
>  #include <linux/pci-dma-compat.h>
>
> --
> 2.29.2
>
