Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC30D4C948A
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 20:41:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237187AbiCATl7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 14:41:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232810AbiCATl6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 14:41:58 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DB54C65495
        for <netdev@vger.kernel.org>; Tue,  1 Mar 2022 11:41:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646163676;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=z8aoFAHDyCvrmmG3m5O00aIMo9cy+HOZ0s5XKRgwMVM=;
        b=MKFx8n+ygk3Go0pZfK2BD9ij8EC5+ecWIcNxbcUeeHH1v7Mpi6hGzkd0JCUKkwl7+OPYGD
        pR/5yb3o36jNXjpjOnecNZWeOYsEW/Sj9YD99eBkdOI5RmpliGwVx9m4Ddb06hhzXpatPJ
        dLvz7E8NvqYt7ytl6U0RYOphqjTPpMY=
Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com
 [209.85.167.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-673-lsUF7x-lNnufw4PDCdtRvA-1; Tue, 01 Mar 2022 14:41:14 -0500
X-MC-Unique: lsUF7x-lNnufw4PDCdtRvA-1
Received: by mail-oi1-f200.google.com with SMTP id s83-20020acaa956000000b002d41cfd2926so7989142oie.0
        for <netdev@vger.kernel.org>; Tue, 01 Mar 2022 11:41:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=z8aoFAHDyCvrmmG3m5O00aIMo9cy+HOZ0s5XKRgwMVM=;
        b=K+6yJHBYGBuIio112VuqlC+rZ178Sd+BMKH37X3pSksGJVEW7t98yCXrlcStzgod/B
         UQ36t9VAQFgfYCWg+sXxDNQiZbuUj+1JrPxLXMVtk5lG6G1CUNQFvcEa1iOmFKYwVI2S
         UTS5z93/xZM8dlRse9ZWOafK8MZWdv56qj9IczUqRxtomAIZDr0lQhc5H+N2jgzNyGR9
         kenSjRSnT3Mt7ZeLioTv191zL5jyyXtbWpshjCwxss4cq3YCBSxauaG7ncnBy4ubFMAz
         j+CCAxbXfVkaP8UZcBzhPeL6F0rR8GgTxFOFBH7ziUW+gqVUnnxZXOscL1pR7ugG0cnU
         gNPA==
X-Gm-Message-State: AOAM533skPoSIizmvjLgXSX/i9911pTbOppvt0LIwxZNOEffum3zZAX8
        LHisl+SJIRXrmy4liWxGbrnuf51E3Ilek1ilwbaEX+SQsjfH/KD6IGvDgKkwJJJd4AOvNgVsTTD
        aD8lddyKeDRFyayFH
X-Received: by 2002:aca:1306:0:b0:2d4:62a5:44a8 with SMTP id e6-20020aca1306000000b002d462a544a8mr14449848oii.38.1646163674209;
        Tue, 01 Mar 2022 11:41:14 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzNiL70nrDv61YRdGiqJzXuVzW8jjuHCVlqM9f4meP7eGkVuTIW4KacN5FDKjwJRNplLIUkwg==
X-Received: by 2002:aca:1306:0:b0:2d4:62a5:44a8 with SMTP id e6-20020aca1306000000b002d462a544a8mr14449833oii.38.1646163673952;
        Tue, 01 Mar 2022 11:41:13 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id y19-20020a056830209300b005afb1e59e0fsm6701622otq.55.2022.03.01.11.41.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Mar 2022 11:41:13 -0800 (PST)
Date:   Tue, 1 Mar 2022 12:41:12 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     bhelgaas@google.com, jgg@nvidia.com, saeedm@nvidia.com,
        Leon Romanovsky <leonro@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>, linux-pci@vger.kernel.org,
        kvm@vger.kernel.org, netdev@vger.kernel.org, kuba@kernel.org,
        kwankhede@nvidia.com, mgurtovoy@nvidia.com, maorg@nvidia.com,
        cohuck@redhat.com, ashok.raj@intel.com, kevin.tian@intel.com,
        shameerali.kolothum.thodi@huawei.com
Subject: Re: [GIT PULL] Add mlx5 live migration driver and v2 migration
 protocol
Message-ID: <20220301124112.477ab6fc.alex.williamson@redhat.com>
In-Reply-To: <20220228123934.812807-1-leon@kernel.org>
References: <20220228123934.812807-1-leon@kernel.org>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 28 Feb 2022 14:39:34 +0200
Leon Romanovsky <leon@kernel.org> wrote:

> From: Leon Romanovsky <leonro@nvidia.com>
> 
> Hi Alex,
> 
> This pull request contains the v9 version of recently submitted mlx5 live migration
> driver from Yishai and Jason.
> 
> In addition to changes in VFIO, this series extended the ethernet part of mlx5 driver.
> Such changes have all chances to create merge conflicts between VFIO, netdev and RDMA
> subsystems, which are eliminated with this PR.

I know that Connie and perhaps others have spent a good deal of time
reviewing this, so I'd at least like to give them an opportunity to
chime in with their Reviewed-by before merging a PR.  For me please add
my

Reviewed-by: Alex Williamson <alex.williamson@redhat.com>

to patches 8-15 in Yishai's v9 posting.  If it's easier, I can adjust
the commits from this PR manually, I see there are just a few minor
commit log differences versus the v9 post.  Let's give this one more
day to collect any further outstanding comments or reviews.  Thanks,

Alex

> ------------------------------------------------------------------------------------
> 
> The following changes since commit cfb92440ee71adcc2105b0890bb01ac3cddb8507:
> 
>   Linux 5.17-rc5 (2022-02-20 13:07:20 -0800)
> 
> are available in the Git repository at:
> 
>   https://git.kernel.org/pub/scm/linux/kernel/git/mellanox/linux.git tags/mlx5-vfio-v9
> 
> for you to fetch changes up to d18f3ba69448b8f68caf8592a9abb39e75c76e8d:
> 
>   vfio/mlx5: Use its own PCI reset_done error handler (2022-02-27 11:44:00 +0200)
> 
> ----------------------------------------------------------------
> Add mlx5 live migration driver and v2 migration protocol
> 
> This series adds mlx5 live migration driver for VFs that are migration
> capable and includes the v2 migration protocol definition and mlx5
> implementation.
> 
> The mlx5 driver uses the vfio_pci_core split to create a specific VFIO
> PCI driver that matches the mlx5 virtual functions. The driver provides
> the same experience as normal vfio-pci with the addition of migration
> support.
> 
> In HW the migration is controlled by the PF function, using its
> mlx5_core driver, and the VFIO PCI VF driver co-ordinates with the PF to
> execute the migration actions.
> 
> The bulk of the v2 migration protocol is semantically the same v1,
> however it has been recast into a FSM for the device_state and the
> actual syscall interface uses normal ioctl(), read() and write() instead
> of building a syscall interface using the region.
> 
> Several bits of infrastructure work are included here:
>  - pci_iov_vf_id() to help drivers like mlx5 figure out the VF index from
>    a BDF
>  - pci_iov_get_pf_drvdata() to clarify the tricky locking protocol when a
>    VF reaches into its PF's driver
>  - mlx5_core uses the normal SRIOV lifecycle and disables SRIOV before
>    driver remove, to be compatible with pci_iov_get_pf_drvdata()
>  - Lifting VFIO_DEVICE_FEATURE into core VFIO code
> 
> This series comes after alot of discussion. Some major points:
> - v1 ABI compatible migration defined using the same FSM approach:
>    https://lore.kernel.org/all/0-v1-a4f7cab64938+3f-vfio_mig_states_jgg@nvidia.com/
> - Attempts to clarify how the v1 API works:
>    Alex's:
>      https://lore.kernel.org/kvm/163909282574.728533.7460416142511440919.stgit@omen/
>    Jason's:
>      https://lore.kernel.org/all/0-v3-184b374ad0a8+24c-vfio_mig_doc_jgg@nvidia.com/
> - Etherpad exploring the scope and questions of general VFIO migration:
>      https://lore.kernel.org/kvm/87mtm2loml.fsf@redhat.com/
> 
> NOTE: As this series touched mlx5_core parts we need to send this in a
> pull request format to VFIO to avoid conflicts.
> 
> Matching qemu changes can be previewed here:
>  https://github.com/jgunthorpe/qemu/commits/vfio_migration_v2
> 
> Link: https://lore.kernel.org/all/20220224142024.147653-1-yishaih@nvidia.com
> Signed-of-by: Leon Romanovsky <leonro@nvidia.com>
> 
> ----------------------------------------------------------------
> Jason Gunthorpe (6):
>       PCI/IOV: Add pci_iov_vf_id() to get VF index
>       PCI/IOV: Add pci_iov_get_pf_drvdata() to allow VF reaching the drvdata of a PF
>       vfio: Have the core code decode the VFIO_DEVICE_FEATURE ioctl
>       vfio: Define device migration protocol v2
>       vfio: Extend the device migration protocol with RUNNING_P2P
>       vfio: Remove migration protocol v1 documentation
> 
> Leon Romanovsky (1):
>       net/mlx5: Reuse exported virtfn index function call
> 
> Yishai Hadas (8):
>       net/mlx5: Disable SRIOV before PF removal
>       net/mlx5: Expose APIs to get/put the mlx5 core device
>       net/mlx5: Introduce migration bits and structures
>       net/mlx5: Add migration commands definitions
>       vfio/mlx5: Expose migration commands over mlx5 device
>       vfio/mlx5: Implement vfio_pci driver for mlx5 devices
>       vfio/pci: Expose vfio_pci_core_aer_err_detected()
>       vfio/mlx5: Use its own PCI reset_done error handler
> 
>  MAINTAINERS                                        |   6 +
>  drivers/net/ethernet/mellanox/mlx5/core/cmd.c      |  10 +
>  drivers/net/ethernet/mellanox/mlx5/core/main.c     |  45 ++
>  .../net/ethernet/mellanox/mlx5/core/mlx5_core.h    |   1 +
>  drivers/net/ethernet/mellanox/mlx5/core/sriov.c    |  17 +-
>  drivers/pci/iov.c                                  |  43 ++
>  drivers/vfio/pci/Kconfig                           |   3 +
>  drivers/vfio/pci/Makefile                          |   2 +
>  drivers/vfio/pci/mlx5/Kconfig                      |  10 +
>  drivers/vfio/pci/mlx5/Makefile                     |   4 +
>  drivers/vfio/pci/mlx5/cmd.c                        | 259 ++++++++
>  drivers/vfio/pci/mlx5/cmd.h                        |  36 ++
>  drivers/vfio/pci/mlx5/main.c                       | 676 +++++++++++++++++++++
>  drivers/vfio/pci/vfio_pci.c                        |   1 +
>  drivers/vfio/pci/vfio_pci_core.c                   | 101 ++-
>  drivers/vfio/vfio.c                                | 295 ++++++++-
>  include/linux/mlx5/driver.h                        |   3 +
>  include/linux/mlx5/mlx5_ifc.h                      | 147 ++++-
>  include/linux/pci.h                                |  15 +-
>  include/linux/vfio.h                               |  53 ++
>  include/linux/vfio_pci_core.h                      |   4 +
>  include/uapi/linux/vfio.h                          | 406 ++++++-------
>  22 files changed, 1846 insertions(+), 291 deletions(-)
>  create mode 100644 drivers/vfio/pci/mlx5/Kconfig
>  create mode 100644 drivers/vfio/pci/mlx5/Makefile
>  create mode 100644 drivers/vfio/pci/mlx5/cmd.c
>  create mode 100644 drivers/vfio/pci/mlx5/cmd.h
>  create mode 100644 drivers/vfio/pci/mlx5/main.c
> 

