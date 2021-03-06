Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1F4232F70E
	for <lists+netdev@lfdr.de>; Sat,  6 Mar 2021 01:04:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229704AbhCFAEW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Mar 2021 19:04:22 -0500
Received: from mail-ot1-f50.google.com ([209.85.210.50]:46698 "EHLO
        mail-ot1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229493AbhCFAD7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Mar 2021 19:03:59 -0500
Received: by mail-ot1-f50.google.com with SMTP id 97so3473289otf.13;
        Fri, 05 Mar 2021 16:03:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FCbBlEEqgxfjPjtQfKvWFaWJOfXoBc2uhQxuYQUH8F0=;
        b=GO0LtwNWRYb9u4XW25NfkPD3r/RhI52VXi+uLjQZXiRGoxB+UYP/kOBmc04kE4FFYp
         xQ8TS5N6gQdOD4dDJznuOcZs0SkR1SAqdon/N0PoVEtxASSFJ2iLpH7jvhmmaYFaVAbt
         nAnLsXtCODcHqzQoDNGsUZUPgFRILYQi29jlfVS5dbIFUOPXGruVY4X5rLIL1tUdaUqs
         RNk+GeJIAC3wus7jKOFUHHykqyHGAN8tohhg89Ykpg6SBn8AUdHHKl6O2kLXhcm44id3
         dD5r3s4fYbhvyADD7OenDthaRClQI63h3MSxhSChP33x6zliEG6nyZ6dV4zBbf0DqTad
         7ZPA==
X-Gm-Message-State: AOAM532Flxfhqx+QmMTvX64ZHEOPYkiGp3QpkKLpzzPqWCKNLQZzu/Vk
        xqAIXJJUJQWjNtJ4WUzk36oUbcidzU4uWw==
X-Google-Smtp-Source: ABdhPJyXvrdIbaJFHWm44DBCGnI1b4zn6+CHh1kzE5vAHgRbojumfT5/HghxSzgA/e0GigtlZ/hwCg==
X-Received: by 2002:a9d:7ac1:: with SMTP id m1mr6652621otn.186.1614989038139;
        Fri, 05 Mar 2021 16:03:58 -0800 (PST)
Received: from mail-oi1-f172.google.com (mail-oi1-f172.google.com. [209.85.167.172])
        by smtp.gmail.com with ESMTPSA id v3sm847536oix.48.2021.03.05.16.03.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Mar 2021 16:03:57 -0800 (PST)
Received: by mail-oi1-f172.google.com with SMTP id y131so1550429oia.8;
        Fri, 05 Mar 2021 16:03:56 -0800 (PST)
X-Received: by 2002:a54:4794:: with SMTP id o20mr9228337oic.51.1614989036851;
 Fri, 05 Mar 2021 16:03:56 -0800 (PST)
MIME-Version: 1.0
References: <20210301084257.945454-1-hch@lst.de>
In-Reply-To: <20210301084257.945454-1-hch@lst.de>
From:   Li Yang <leoyang.li@nxp.com>
Date:   Fri, 5 Mar 2021 18:03:45 -0600
X-Gmail-Original-Message-ID: <CADRPPNTSzuuqW97_vd3h5cpHe7gOLyw3zCaqapb8YVqPF-rOfA@mail.gmail.com>
Message-ID: <CADRPPNTSzuuqW97_vd3h5cpHe7gOLyw3zCaqapb8YVqPF-rOfA@mail.gmail.com>
Subject: Re: cleanup unused or almost unused IOMMU APIs and the FSL PAMU driver
To:     Christoph Hellwig <hch@lst.de>
Cc:     Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
        freedreno@lists.freedesktop.org, kvm@vger.kernel.org,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        dri-devel@lists.freedesktop.org,
        virtualization@lists.linux-foundation.org,
        Linux IOMMU <iommu@lists.linux-foundation.org>,
        Netdev <netdev@vger.kernel.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        David Woodhouse <dwmw2@infradead.org>,
        "moderated list:ARM/FREESCALE IMX / MXC ARM ARCHITECTURE" 
        <linux-arm-kernel@lists.infradead.org>,
        Lu Baolu <baolu.lu@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 1, 2021 at 2:44 AM Christoph Hellwig <hch@lst.de> wrote:
>
> Hi all,
>
> there are a bunch of IOMMU APIs that are entirely unused, or only used as
> a private communication channel between the FSL PAMU driver and it's only
> consumer, the qbman portal driver.
>
> So this series drops a huge chunk of entirely unused FSL PAMU
> functionality, then drops all kinds of unused IOMMU APIs, and then
> replaces what is left of the iommu_attrs with properly typed, smaller
> and easier to use specific APIs.

It looks like the unused APIs were added for functionality that were
never completed later on.  So

Acked-by: Li Yang <leoyang.li@nxp.com>

>
> Diffstat:
>  arch/powerpc/include/asm/fsl_pamu_stash.h   |   12
>  drivers/gpu/drm/msm/adreno/adreno_gpu.c     |    2
>  drivers/iommu/amd/iommu.c                   |   23
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c |   85 ---
>  drivers/iommu/arm/arm-smmu/arm-smmu.c       |  122 +---
>  drivers/iommu/dma-iommu.c                   |    8
>  drivers/iommu/fsl_pamu.c                    |  264 ----------
>  drivers/iommu/fsl_pamu.h                    |   10
>  drivers/iommu/fsl_pamu_domain.c             |  694 ++--------------------------
>  drivers/iommu/fsl_pamu_domain.h             |   46 -
>  drivers/iommu/intel/iommu.c                 |   55 --
>  drivers/iommu/iommu.c                       |   75 ---
>  drivers/soc/fsl/qbman/qman_portal.c         |   56 --
>  drivers/vfio/vfio_iommu_type1.c             |   31 -
>  drivers/vhost/vdpa.c                        |   10
>  include/linux/iommu.h                       |   81 ---
>  16 files changed, 214 insertions(+), 1360 deletions(-)
