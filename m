Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D83B831589E
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 22:32:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233823AbhBIV0B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 16:26:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234215AbhBIVJB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Feb 2021 16:09:01 -0500
Received: from mail-il1-x134.google.com (mail-il1-x134.google.com [IPv6:2607:f8b0:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1069CC06174A;
        Tue,  9 Feb 2021 13:06:37 -0800 (PST)
Received: by mail-il1-x134.google.com with SMTP id e7so17408210ile.7;
        Tue, 09 Feb 2021 13:06:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=15OODCihpty0UWi0a0aB28afyJjig1mNPU55XHksU0Y=;
        b=WGXCYkfG2UPIZGxYCJxQlssPEm1c/IlOG/OKZvuBR+izcGLbqIiFcfuejjz/mGmaXQ
         OfzIgOqW63BCSbhlSfev2owDbikYinz5IvA+aXtZi8UAmRcKM1JtOTRsxFiDdqbB+rZK
         cMssXcwgnShvLxiXKNb1af1X6+vePNNgHf71OWkAAWi/LSCIRQgBXyzm3xqfEmBefztI
         vTJG4RRv71a/763zsXLPjnDxESRZrXyXxXLc9gyOQ3mz3UtI2jkPQY9DyHWsdMQb1OZ/
         6MvSndL/Mb4iTPgxdOvDg2Yz1PRmd1nCTbcm3mgb2ZyLbJ5qSGTBIrZ/Dp2EcdpoqliJ
         gUhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=15OODCihpty0UWi0a0aB28afyJjig1mNPU55XHksU0Y=;
        b=s91Xm145AjTv+qg71k908NZ1gPEnT6GRtM70UVYsXE+Gh/0nwW/NfvQ/+DwXMRkUlB
         1GOFYanrHOqPgQjNCwZ/hWhAB1ns/Nnm0s8xjg5rtCE55NICrFSdzTYkAlUy/UONVI/X
         6Zbb8qOja2Xt3LDX8EL0bgmITtCgZcxPtRRrg1SDknDQZdRTlflvir1HCUMz7aUDOVM2
         2nPpchGlB0z0ocEqBUQkl3I+BdKWlsr5ORoucCYR63VHSzzBRaR38Ikm2uoJwr+uheOu
         KZ5H1jcMZJPfZ81xpPbTnmCjYzNoTObIuvOqS29wiBuwKnwOUMYTbjgjnFx90z40N8ud
         mp/A==
X-Gm-Message-State: AOAM530oK6UePWaMwPGEUUbGzi1crnurqop1u+VgJDPzwlVNVsNSDYV3
        g7HIaCDD6O9S9mZ1/yulvIKZInIEOMNZeYzXS10=
X-Google-Smtp-Source: ABdhPJx6CJULSRazipUh8Vc7wnERN3KJ4SipHXstSl2Km+4a0nkeP2kgKY7mN/5Pjmc5k6lp53CnVDwOyTqVCG4rPrQ=
X-Received: by 2002:a92:cec2:: with SMTP id z2mr2768778ilq.42.1612904796430;
 Tue, 09 Feb 2021 13:06:36 -0800 (PST)
MIME-Version: 1.0
References: <20210209133445.700225-1-leon@kernel.org>
In-Reply-To: <20210209133445.700225-1-leon@kernel.org>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Tue, 9 Feb 2021 13:06:25 -0800
Message-ID: <CAKgT0Ud+c6wzo3n_8VgtVBQm-2UPic6U2QFuqqN-P9nEv_Y+JQ@mail.gmail.com>
Subject: Re: [PATCH mlx5-next v6 0/4] Dynamically assign MSI-X vectors count
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

On Tue, Feb 9, 2021 at 5:34 AM Leon Romanovsky <leon@kernel.org> wrote:
>
> From: Leon Romanovsky <leonro@nvidia.com>

<snip>

> --------------------------------------------------------------------
> Hi,
>
> The number of MSI-X vectors is PCI property visible through lspci, that
> field is read-only and configured by the device.
>
> The static assignment of an amount of MSI-X vectors doesn't allow utilize
> the newly created VF because it is not known to the device the future load
> and configuration where that VF will be used.
>
> The VFs are created on the hypervisor and forwarded to the VMs that have
> different properties (for example number of CPUs).
>
> To overcome the inefficiency in the spread of such MSI-X vectors, we
> allow the kernel to instruct the device with the needed number of such
> vectors, before VF is initialized and bounded to the driver.
>
> Before this series:
> [root@server ~]# lspci -vs 0000:08:00.2
> 08:00.2 Ethernet controller: Mellanox Technologies MT27800 Family [ConnectX-5 Virtual Function]
> ....
>         Capabilities: [9c] MSI-X: Enable- Count=12 Masked-
>
> Configuration script:
> 1. Start fresh
> echo 0 > /sys/bus/pci/devices/0000\:08\:00.0/sriov_numvfs
> modprobe -q -r mlx5_ib mlx5_core
> 2. Ensure that driver doesn't run and it is safe to change MSI-X
> echo 0 > /sys/bus/pci/devices/0000\:08\:00.0/sriov_drivers_autoprobe
> 3. Load driver for the PF
> modprobe mlx5_core
> 4. Configure one of the VFs with new number
> echo 2 > /sys/bus/pci/devices/0000\:08\:00.0/sriov_numvfs
> echo 21 > /sys/bus/pci/devices/0000\:08\:00.2/sriov_vf_msix_count
>
> After this series:
> [root@server ~]# lspci -vs 0000:08:00.2
> 08:00.2 Ethernet controller: Mellanox Technologies MT27800 Family [ConnectX-5 Virtual Function]
> ....
>         Capabilities: [9c] MSI-X: Enable- Count=21 Masked-
>
> Thanks
>
> Leon Romanovsky (4):
>   PCI: Add sysfs callback to allow MSI-X table size change of SR-IOV VFs
>   net/mlx5: Add dynamic MSI-X capabilities bits
>   net/mlx5: Dynamically assign MSI-X vectors count
>   net/mlx5: Allow to the users to configure number of MSI-X vectors
>
>  Documentation/ABI/testing/sysfs-bus-pci       |  28 ++++
>  .../net/ethernet/mellanox/mlx5/core/main.c    |  17 ++
>  .../ethernet/mellanox/mlx5/core/mlx5_core.h   |  27 ++++
>  .../net/ethernet/mellanox/mlx5/core/pci_irq.c |  72 +++++++++
>  .../net/ethernet/mellanox/mlx5/core/sriov.c   |  58 ++++++-
>  drivers/pci/iov.c                             | 153 ++++++++++++++++++
>  include/linux/mlx5/mlx5_ifc.h                 |  11 +-
>  include/linux/pci.h                           |  12 ++
>  8 files changed, 375 insertions(+), 3 deletions(-)
>

This seems much improved from the last time I reviewed the patch set.
I am good with the drop of the folder in favor of using "sriov" in the
naming of the fields.

For the series:
Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>
