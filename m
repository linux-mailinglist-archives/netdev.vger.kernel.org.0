Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B769E2F1F76
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 20:32:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391137AbhAKTbf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 14:31:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388953AbhAKTbb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 14:31:31 -0500
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54037C06179F;
        Mon, 11 Jan 2021 11:30:51 -0800 (PST)
Received: by mail-il1-x136.google.com with SMTP id t3so272041ilh.9;
        Mon, 11 Jan 2021 11:30:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JIuxxLTazDRWAXeqaTZImGLR40cYEqjTEL+0/lNjsHM=;
        b=ddiuZoQyx8zsdtXYgkYr5nTtmJfpxqxIoDp3A5TH/5/wKII8axPm2hpGjTSHXmYOCK
         9qInhRPT1rQUPRcVVxo62GtHj6WbuFh92btRIqe0PS3Js+lRw8thBNydopd9V9AYjTsT
         jb59KwIVxep6Wzj5DlnP+Va3sieRHfIuHKOy5z+QsFkHvPnUalNwqTUP1OPW2d08TTz2
         1v5iFtUV210+FnU7jl24sWqLFQuQD0MQ1uO+UOuSYTkY+t1dLbQ3yGR9LqcGT1Ag/VKd
         DpVQAZLtADfr/KRNHdfhaYATr47pJz4ZKOYbmVVqS2plWAlcmZrqsYNpayIlc9B+JBTl
         buUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JIuxxLTazDRWAXeqaTZImGLR40cYEqjTEL+0/lNjsHM=;
        b=mXdX2WQwH58fe54ETw7VZiMtYHgR7k1qo8oZTyf8hdlX2ZERLMp4WA3T/VPVw4IjB+
         wpx8XyIxvIhJwjOYV/bA1bLBlPfBeXEnEdog5fJpYywjrfWfcEQ6QH4t9LOh+3Wgfunz
         b75QMIeNcBCfmZaH0YHA89MkBgPLMF/lG9xmsnaSTCil7QVg/HDoqpvMwR6HL7TDIg/M
         0I81dtg13RlSvT/2Gynyqg9NvJSI+6kJ0QxWRjvFLp/pkImuETnqk38dilBzCaedhr51
         dscpAVGgzytUNNc2dFKI7DTqouC5jysR3Jn7CUf1FuhqlpGpRdRBjflzIXbU/aUpCuxO
         h6mQ==
X-Gm-Message-State: AOAM5310OExH0ML7+YpHlCpHta79pO/7jTHZGhejMuGHwtAjjJh1NbHE
        yiAUtgjzW7u7LrDRuKuInQfKwE4r90zZqghBSfg=
X-Google-Smtp-Source: ABdhPJwUv3o30ee0xhxr+qCCY6492nIyVe3Bb3yl8+KqecTXDCTETIlUv4lR3/1oLfRqmBqIaUL7aR0JHu7jLZrK3eQ=
X-Received: by 2002:a92:d210:: with SMTP id y16mr640881ily.97.1610393450675;
 Mon, 11 Jan 2021 11:30:50 -0800 (PST)
MIME-Version: 1.0
References: <20210110150727.1965295-1-leon@kernel.org> <20210110150727.1965295-3-leon@kernel.org>
In-Reply-To: <20210110150727.1965295-3-leon@kernel.org>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Mon, 11 Jan 2021 11:30:39 -0800
Message-ID: <CAKgT0Uczu6cULPsVjFuFVmir35SpL-bs0hosbfH-T5sZLZ78BQ@mail.gmail.com>
Subject: Re: [PATCH mlx5-next v1 2/5] PCI: Add SR-IOV sysfs entry to read
 number of MSI-X vectors
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

On Sun, Jan 10, 2021 at 7:10 AM Leon Romanovsky <leon@kernel.org> wrote:
>
> From: Leon Romanovsky <leonro@nvidia.com>
>
> Some SR-IOV capable devices provide an ability to configure specific
> number of MSI-X vectors on their VF prior driver is probed on that VF.
>
> In order to make management easy, provide new read-only sysfs file that
> returns a total number of possible to configure MSI-X vectors.
>
> cat /sys/bus/pci/devices/.../sriov_vf_total_msix
>   = 0 - feature is not supported
>   > 0 - total number of MSI-X vectors to consume by the VFs
>
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> ---
>  Documentation/ABI/testing/sysfs-bus-pci | 14 +++++++++++
>  drivers/pci/iov.c                       | 31 +++++++++++++++++++++++++
>  drivers/pci/pci.h                       |  3 +++
>  include/linux/pci.h                     |  2 ++
>  4 files changed, 50 insertions(+)
>
> diff --git a/Documentation/ABI/testing/sysfs-bus-pci b/Documentation/ABI/testing/sysfs-bus-pci
> index 05e26e5da54e..64e9b700acc9 100644
> --- a/Documentation/ABI/testing/sysfs-bus-pci
> +++ b/Documentation/ABI/testing/sysfs-bus-pci
> @@ -395,3 +395,17 @@ Description:
>                 The file is writable if the PF is bound to a driver that
>                 supports the ->sriov_set_msix_vec_count() callback and there
>                 is no driver bound to the VF.
> +
> +What:          /sys/bus/pci/devices/.../sriov_vf_total_msix

In this case I would drop the "vf" and just go with sriov_total_msix
since now you are referring to a global value instead of a per VF
value.

> +Date:          January 2021
> +Contact:       Leon Romanovsky <leonro@nvidia.com>
> +Description:
> +               This file is associated with the SR-IOV PFs.
> +               It returns a total number of possible to configure MSI-X
> +               vectors on the enabled VFs.
> +
> +               The values returned are:
> +                * > 0 - this will be total number possible to consume by VFs,
> +                * = 0 - feature is not supported
> +
> +               If no SR-IOV VFs are enabled, this value will return 0.
> diff --git a/drivers/pci/iov.c b/drivers/pci/iov.c
> index 42c0df4158d1..0a6ddf3230fd 100644
> --- a/drivers/pci/iov.c
> +++ b/drivers/pci/iov.c
> @@ -394,12 +394,22 @@ static ssize_t sriov_drivers_autoprobe_store(struct device *dev,
>         return count;
>  }
>
> +static ssize_t sriov_vf_total_msix_show(struct device *dev,
> +                                       struct device_attribute *attr,
> +                                       char *buf)
> +{
> +       struct pci_dev *pdev = to_pci_dev(dev);
> +
> +       return sprintf(buf, "%d\n", pdev->sriov->vf_total_msix);
> +}
> +

You display it as a signed value, but unsigned values are not
supported, correct?

>  static DEVICE_ATTR_RO(sriov_totalvfs);
>  static DEVICE_ATTR_RW(sriov_numvfs);
>  static DEVICE_ATTR_RO(sriov_offset);
>  static DEVICE_ATTR_RO(sriov_stride);
>  static DEVICE_ATTR_RO(sriov_vf_device);
>  static DEVICE_ATTR_RW(sriov_drivers_autoprobe);
> +static DEVICE_ATTR_RO(sriov_vf_total_msix);
>
>  static struct attribute *sriov_dev_attrs[] = {
>         &dev_attr_sriov_totalvfs.attr,
> @@ -408,6 +418,7 @@ static struct attribute *sriov_dev_attrs[] = {
>         &dev_attr_sriov_stride.attr,
>         &dev_attr_sriov_vf_device.attr,
>         &dev_attr_sriov_drivers_autoprobe.attr,
> +       &dev_attr_sriov_vf_total_msix.attr,
>         NULL,
>  };
>
> @@ -658,6 +669,7 @@ static void sriov_disable(struct pci_dev *dev)
>                 sysfs_remove_link(&dev->dev.kobj, "dep_link");
>
>         iov->num_VFs = 0;
> +       iov->vf_total_msix = 0;
>         pci_iov_set_numvfs(dev, 0);
>  }
>
> @@ -1116,6 +1128,25 @@ int pci_sriov_get_totalvfs(struct pci_dev *dev)
>  }
>  EXPORT_SYMBOL_GPL(pci_sriov_get_totalvfs);
>
> +/**
> + * pci_sriov_set_vf_total_msix - set total number of MSI-X vectors for the VFs
> + * @dev: the PCI PF device
> + * @numb: the total number of MSI-X vector to consume by the VFs
> + *
> + * Sets the number of MSI-X vectors that is possible to consume by the VFs.
> + * This interface is complimentary part of the pci_set_msix_vec_count()
> + * that will be used to configure the required number on the VF.
> + */
> +void pci_sriov_set_vf_total_msix(struct pci_dev *dev, int numb)
> +{
> +       if (!dev->is_physfn || !dev->driver ||
> +           !dev->driver->sriov_set_msix_vec_count)
> +               return;
> +
> +       dev->sriov->vf_total_msix = numb;
> +}
> +EXPORT_SYMBOL_GPL(pci_sriov_set_vf_total_msix);
> +

This seems broken. What validation is being done on the numb value?
You pass it as int, and your documentation all refers to tests for >=
0, but isn't a signed input a possibility as well? Also "numb" doesn't
make for a good abbreviation as it is already a word of its own. It
might make more sense to use count or something like that rather than
trying to abbreviate number.


>  /**
>   * pci_sriov_configure_simple - helper to configure SR-IOV
>   * @dev: the PCI device
> diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
> index 1fd273077637..0fbe291eb0f2 100644
> --- a/drivers/pci/pci.h
> +++ b/drivers/pci/pci.h
> @@ -327,6 +327,9 @@ struct pci_sriov {
>         u16             subsystem_device; /* VF subsystem device */
>         resource_size_t barsz[PCI_SRIOV_NUM_BARS];      /* VF BAR size */
>         bool            drivers_autoprobe; /* Auto probing of VFs by driver */
> +       int             vf_total_msix;  /* Total number of MSI-X vectors the VFs
> +                                        * can consume
> +                                        */
>  };
>
>  /**
> diff --git a/include/linux/pci.h b/include/linux/pci.h
> index a17cfc28eb66..fd9ff1f42a09 100644
> --- a/include/linux/pci.h
> +++ b/include/linux/pci.h
> @@ -2074,6 +2074,7 @@ int pci_sriov_get_totalvfs(struct pci_dev *dev);
>  int pci_sriov_configure_simple(struct pci_dev *dev, int nr_virtfn);
>  resource_size_t pci_iov_resource_size(struct pci_dev *dev, int resno);
>  void pci_vf_drivers_autoprobe(struct pci_dev *dev, bool probe);
> +void pci_sriov_set_vf_total_msix(struct pci_dev *dev, int numb);
>
>  /* Arch may override these (weak) */
>  int pcibios_sriov_enable(struct pci_dev *pdev, u16 num_vfs);
> @@ -2114,6 +2115,7 @@ static inline int pci_sriov_get_totalvfs(struct pci_dev *dev)
>  static inline resource_size_t pci_iov_resource_size(struct pci_dev *dev, int resno)
>  { return 0; }
>  static inline void pci_vf_drivers_autoprobe(struct pci_dev *dev, bool probe) { }
> +static inline void pci_sriov_set_vf_total_msix(struct pci_dev *dev, int numb) {}
>  #endif
>
>  #if defined(CONFIG_HOTPLUG_PCI) || defined(CONFIG_HOTPLUG_PCI_MODULE)
> --
> 2.29.2
>
