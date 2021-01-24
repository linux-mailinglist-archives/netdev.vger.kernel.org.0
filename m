Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39F10301D91
	for <lists+netdev@lfdr.de>; Sun, 24 Jan 2021 17:49:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726362AbhAXQso (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Jan 2021 11:48:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726278AbhAXQsg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Jan 2021 11:48:36 -0500
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD652C061574;
        Sun, 24 Jan 2021 08:47:55 -0800 (PST)
Received: by mail-io1-xd35.google.com with SMTP id u17so21796841iow.1;
        Sun, 24 Jan 2021 08:47:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wIgSlR36uyBNzzuWq9sdWAXrQ+VFAY02q13n34GMiSM=;
        b=aWzlo8XlWowDL6UW6hzzuky+Cj7K5BsI+wau9979rUC3+SjIXpxbZacYsxZ2ixb2UY
         RzV02XevfUckoJ4SQuqLi0vmYefmr65vYCj1PhMCBAg+YzSF2LsNnWl/s9YZ76w50t5b
         DiBgE9eo7sJMdJSt3djLYaCnyWATrePUGx+6irGWqRfIhe91k+xZkUuIL8Y91hxlmpZ4
         AHFTnyYuHJHgEs/Adib2n9YeH6YAqRpM5Mutvyfr1/I3TSliK2TQ/TMmhledl0lnRMNE
         eowHDZuoy6tEreJD3jU0UnaIWsK6HA7LdKevaYqhyjJO0Z/Rpn2qrwzSs3m4tFE1yPaY
         OFhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wIgSlR36uyBNzzuWq9sdWAXrQ+VFAY02q13n34GMiSM=;
        b=tf6Hgxa4bMxCDd/MOqNfKmKl+351f+MA5YhnNf1iVEXgYco8HGcSOoftnSzO+EG4/K
         4Qyt9QsF8ksGGjEDxrzxwHWUS2TF+OyaDZSbc2cv3/PAV1VyDol5aw3iiTA5+geynYrs
         PzSH4FAaUfSwMmT6PbLw4+EIhorUzorpuFUoXlO5jLyY+vh3wuzY3buUA7op/8IMNmbN
         xY5pnnMl5hh1Sg3qpzzxCHeB7N5LthelOaHq1HPi3VlWjgW+uluu9zNIzUfsjKNkn7XY
         OVPpKzLIYl0S2haCZNRvCxx83uNt1SEduoyY6kX24YUfHiTJZU0lE4Jz8G5ffisN/Dsk
         n7yA==
X-Gm-Message-State: AOAM530veX2jJEC1k8x2mCobptNXqLdTXkiTx1KhnH4Ko47qmsTZ7Us+
        2BWZsTvU5oo5vDmMlMUvaDI92jECfMb58x7R4nk=
X-Google-Smtp-Source: ABdhPJz5zd6pscp17Ec0e4J7AT8hDTMQ6xbJmMPHGg4ePr1tM5uFVb+7J5TzHS7iTDuJSBTfL6mLIU3D2MfWowmyU2I=
X-Received: by 2002:a05:6602:2c52:: with SMTP id x18mr568092iov.5.1611506875046;
 Sun, 24 Jan 2021 08:47:55 -0800 (PST)
MIME-Version: 1.0
References: <20210124131119.558563-1-leon@kernel.org> <20210124131119.558563-2-leon@kernel.org>
In-Reply-To: <20210124131119.558563-2-leon@kernel.org>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Sun, 24 Jan 2021 08:47:44 -0800
Message-ID: <CAKgT0UcJQ3uy6J_CCLizDLfzGL2saa_PjOYH4nK+RQjfmpNA=w@mail.gmail.com>
Subject: Re: [PATCH mlx5-next v4 1/4] PCI: Add sysfs callback to allow MSI-X
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
        Alex Williamson <alex.williamson@redhat.com>,
        "David S . Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 24, 2021 at 5:11 AM Leon Romanovsky <leon@kernel.org> wrote:
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
> 1) The newly added /sys/bus/pci/devices/.../vfs_overlay/sriov_vf_msix_count
> file will be seen for the VFs and it is writable as long as a driver is not
> bounded to the VF.
>
> The values accepted are:
>  * > 0 - this will be number reported by the VF's MSI-X capability
>  * < 0 - not valid
>  * = 0 - will reset to the device default value
>
> 2) In order to make management easy, provide new read-only sysfs file that
> returns a total number of possible to configure MSI-X vectors.
>
> cat /sys/bus/pci/devices/.../vfs_overlay/sriov_vf_total_msix
>   = 0 - feature is not supported
>   > 0 - total number of MSI-X vectors to consume by the VFs
>
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> ---
>  Documentation/ABI/testing/sysfs-bus-pci |  32 +++++
>  drivers/pci/iov.c                       | 180 ++++++++++++++++++++++++
>  drivers/pci/msi.c                       |  47 +++++++
>  drivers/pci/pci.h                       |   4 +
>  include/linux/pci.h                     |  10 ++
>  5 files changed, 273 insertions(+)
>

<snip>

> +
> +static umode_t sriov_pf_attrs_are_visible(struct kobject *kobj,
> +                                         struct attribute *a, int n)
> +{
> +       struct device *dev = kobj_to_dev(kobj);
> +       struct pci_dev *pdev = to_pci_dev(dev);
> +
> +       if (!pdev->msix_cap || !dev_is_pf(dev))
> +               return 0;
> +
> +       return a->mode;
> +}
> +
> +static umode_t sriov_vf_attrs_are_visible(struct kobject *kobj,
> +                                         struct attribute *a, int n)
> +{
> +       struct device *dev = kobj_to_dev(kobj);
> +       struct pci_dev *pdev = to_pci_dev(dev);
> +
> +       if (!pdev->msix_cap || dev_is_pf(dev))
> +               return 0;
> +
> +       return a->mode;
> +}
> +

Given the changes I don't see why we need to add the "visible"
functions. We are only registering this from the PF if there is a need
to make use of the interfaces, correct? If so we can just assume that
the interfaces should always be visible if they are requested.

Also you may want to look at placing a link to the VF folders in the
PF folder, although I suppose there are already links from the PF PCI
device to the VF PCI devices so maybe that isn't necessary. It just
takes a few extra steps to navigate between the two.
