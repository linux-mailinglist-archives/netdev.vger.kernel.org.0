Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEEDC4AE5BF
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 01:08:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239155AbiBIAIH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 19:08:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239101AbiBIAIE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 19:08:04 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2497DC06157B
        for <netdev@vger.kernel.org>; Tue,  8 Feb 2022 16:08:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644365282;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Lc9Lm5985twS+sRxlWTsNS/BopDzbEB8uOS6Pi7bwTg=;
        b=HIBb5foFPCbNm0o/D8WxFH1rJByjjVGnjYQ+r1A548stUTXaxT8ewrMbLAUDvncc+mdT3G
        Y2F+tIsGXHVX7KJQgEqbPd3f74DLGt5g5gLlu+KwJYCKrTHlxL/66I6LCqIPM8a47Emrx0
        3Is13CW7BnINFeqaCWLkiEczI84bKic=
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com
 [209.85.166.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-281-OtCycchcPq-CtyxjbpuXbg-1; Tue, 08 Feb 2022 19:08:01 -0500
X-MC-Unique: OtCycchcPq-CtyxjbpuXbg-1
Received: by mail-io1-f72.google.com with SMTP id p65-20020a6bbf44000000b00604c0757591so632365iof.6
        for <netdev@vger.kernel.org>; Tue, 08 Feb 2022 16:08:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=Lc9Lm5985twS+sRxlWTsNS/BopDzbEB8uOS6Pi7bwTg=;
        b=mz7ZWLI5i+iz7diVGmozWYk4W5WJd6Y/G16HKn7XvhVkNTGFV2VVBI3QhAEbth3Ajf
         +ElaErgh8JTPHhnpKPx22AVGtFnsCVvF7Cx5grR4sq+Bn6h9zOyJWJ5AJARrURQOOxXE
         AxcLro3E9FTXLnb1noOdHmXe2relUnvlc3eu2oNlkcHWF6MkrwAFF9ClD+xzVT7DKzKk
         9q7gxzIJ2HCDRO3Lk+2NaVv/hzLxSKaJ48Omz+5mtmjXNtu2zjRl+D+kx7dN9ap/l58t
         44W1UfUVq8Q9at24F3udWGCZhSMjaTiMVUHiBqasrSOibAl2rzeJdOvo0dTrWdfmu4Yo
         dlhg==
X-Gm-Message-State: AOAM532COWJbCsfFOPH4zRAGbiePgTZgJAcwpV95HL6zEcZf0vtUBM6a
        3XeSLo6hFify4hnkIDke5AECO+qu1Mq3vMCHJGyJxxKLWZ1DLs41z9ftipvG7nLHUwdZyrHLBcG
        A1b+u8ntufWZfJthY
X-Received: by 2002:a92:c569:: with SMTP id b9mr3319120ilj.140.1644365280633;
        Tue, 08 Feb 2022 16:08:00 -0800 (PST)
X-Google-Smtp-Source: ABdhPJywblXXWaC+On/ejrPQPFKI5TY6fQri38q7QXP5X10t9UODkgWyVQo1w9VqbvT8Kxxbj9HnJg==
X-Received: by 2002:a92:c569:: with SMTP id b9mr3319107ilj.140.1644365280395;
        Tue, 08 Feb 2022 16:08:00 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id i17sm5917685ilq.19.2022.02.08.16.07.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Feb 2022 16:08:00 -0800 (PST)
Date:   Tue, 8 Feb 2022 17:07:58 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Yishai Hadas <yishaih@nvidia.com>
Cc:     <bhelgaas@google.com>, <jgg@nvidia.com>, <saeedm@nvidia.com>,
        <linux-pci@vger.kernel.org>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>, <leonro@nvidia.com>,
        <kwankhede@nvidia.com>, <mgurtovoy@nvidia.com>, <maorg@nvidia.com>,
        <ashok.raj@intel.com>, <kevin.tian@intel.com>,
        <shameerali.kolothum.thodi@huawei.com>
Subject: Re: [PATCH V7 mlx5-next 12/15] vfio/mlx5: Implement vfio_pci driver
 for mlx5 devices
Message-ID: <20220208170758.48c17719.alex.williamson@redhat.com>
In-Reply-To: <20220207172216.206415-13-yishaih@nvidia.com>
References: <20220207172216.206415-1-yishaih@nvidia.com>
        <20220207172216.206415-13-yishaih@nvidia.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 7 Feb 2022 19:22:13 +0200
Yishai Hadas <yishaih@nvidia.com> wrote:

> This patch adds support for vfio_pci driver for mlx5 devices.
> 
> It uses vfio_pci_core to register to the VFIO subsystem and then
> implements the mlx5 specific logic in the migration area.
> 
> The migration implementation follows the definition from uapi/vfio.h and
> uses the mlx5 VF->PF command channel to achieve it.
> 
> This patch implements the suspend/resume flows.
> 
> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  MAINTAINERS                    |   6 +
>  drivers/vfio/pci/Kconfig       |   3 +
>  drivers/vfio/pci/Makefile      |   2 +
>  drivers/vfio/pci/mlx5/Kconfig  |  10 +
>  drivers/vfio/pci/mlx5/Makefile |   4 +
>  drivers/vfio/pci/mlx5/cmd.h    |   1 +
>  drivers/vfio/pci/mlx5/main.c   | 623 +++++++++++++++++++++++++++++++++
>  7 files changed, 649 insertions(+)
>  create mode 100644 drivers/vfio/pci/mlx5/Kconfig
>  create mode 100644 drivers/vfio/pci/mlx5/Makefile
>  create mode 100644 drivers/vfio/pci/mlx5/main.c
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index ea3e6c914384..5c5216f5e43d 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -20260,6 +20260,12 @@ L:	kvm@vger.kernel.org
>  S:	Maintained
>  F:	drivers/vfio/platform/
>  
> +VFIO MLX5 PCI DRIVER
> +M:	Yishai Hadas <yishaih@nvidia.com>
> +L:	kvm@vger.kernel.org
> +S:	Maintained
> +F:	drivers/vfio/pci/mlx5/
> +
>  VGA_SWITCHEROO
>  R:	Lukas Wunner <lukas@wunner.de>
>  S:	Maintained
> diff --git a/drivers/vfio/pci/Kconfig b/drivers/vfio/pci/Kconfig
> index 860424ccda1b..187b9c259944 100644
> --- a/drivers/vfio/pci/Kconfig
> +++ b/drivers/vfio/pci/Kconfig
> @@ -43,4 +43,7 @@ config VFIO_PCI_IGD
>  
>  	  To enable Intel IGD assignment through vfio-pci, say Y.
>  endif
> +
> +source "drivers/vfio/pci/mlx5/Kconfig"
> +
>  endif
> diff --git a/drivers/vfio/pci/Makefile b/drivers/vfio/pci/Makefile
> index 349d68d242b4..ed9d6f2e0555 100644
> --- a/drivers/vfio/pci/Makefile
> +++ b/drivers/vfio/pci/Makefile
> @@ -7,3 +7,5 @@ obj-$(CONFIG_VFIO_PCI_CORE) += vfio-pci-core.o
>  vfio-pci-y := vfio_pci.o
>  vfio-pci-$(CONFIG_VFIO_PCI_IGD) += vfio_pci_igd.o
>  obj-$(CONFIG_VFIO_PCI) += vfio-pci.o
> +
> +obj-$(CONFIG_MLX5_VFIO_PCI)           += mlx5/
> diff --git a/drivers/vfio/pci/mlx5/Kconfig b/drivers/vfio/pci/mlx5/Kconfig
> new file mode 100644
> index 000000000000..29ba9c504a75
> --- /dev/null
> +++ b/drivers/vfio/pci/mlx5/Kconfig
> @@ -0,0 +1,10 @@
> +# SPDX-License-Identifier: GPL-2.0-only
> +config MLX5_VFIO_PCI
> +	tristate "VFIO support for MLX5 PCI devices"
> +	depends on MLX5_CORE
> +	depends on VFIO_PCI_CORE
> +	help
> +	  This provides migration support for MLX5 devices using the VFIO
> +	  framework.
> +
> +	  If you don't know what to do here, say N.
> diff --git a/drivers/vfio/pci/mlx5/Makefile b/drivers/vfio/pci/mlx5/Makefile
> new file mode 100644
> index 000000000000..689627da7ff5
> --- /dev/null
> +++ b/drivers/vfio/pci/mlx5/Makefile
> @@ -0,0 +1,4 @@
> +# SPDX-License-Identifier: GPL-2.0-only
> +obj-$(CONFIG_MLX5_VFIO_PCI) += mlx5-vfio-pci.o
> +mlx5-vfio-pci-y := main.o cmd.o
> +
> diff --git a/drivers/vfio/pci/mlx5/cmd.h b/drivers/vfio/pci/mlx5/cmd.h
> index 69a1481ed953..1392a11a9cc0 100644
> --- a/drivers/vfio/pci/mlx5/cmd.h
> +++ b/drivers/vfio/pci/mlx5/cmd.h
> @@ -12,6 +12,7 @@
>  struct mlx5_vf_migration_file {
>  	struct file *filp;
>  	struct mutex lock;
> +	bool disabled;
>  
>  	struct sg_append_table table;
>  	size_t total_length;
> diff --git a/drivers/vfio/pci/mlx5/main.c b/drivers/vfio/pci/mlx5/main.c
> new file mode 100644
> index 000000000000..acd205bcff70
> --- /dev/null
> +++ b/drivers/vfio/pci/mlx5/main.c
> @@ -0,0 +1,623 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Copyright (c) 2021-2022, NVIDIA CORPORATION & AFFILIATES. All rights reserved
> + */
> +
> +#include <linux/device.h>
> +#include <linux/eventfd.h>
> +#include <linux/file.h>
> +#include <linux/interrupt.h>
> +#include <linux/iommu.h>
> +#include <linux/module.h>
> +#include <linux/mutex.h>
> +#include <linux/notifier.h>
> +#include <linux/pci.h>
> +#include <linux/pm_runtime.h>
> +#include <linux/types.h>
> +#include <linux/uaccess.h>
> +#include <linux/vfio.h>
> +#include <linux/sched/mm.h>
> +#include <linux/vfio_pci_core.h>
> +#include <linux/anon_inodes.h>
> +
> +#include "cmd.h"
> +
> +/* Arbitrary to prevent userspace from consuming endless memory */
> +#define MAX_MIGRATION_SIZE (512*1024*1024)
> +
> +struct mlx5vf_pci_core_device {
> +	struct vfio_pci_core_device core_device;
> +	u8 migrate_cap:1;
> +	/* protect migration state */
> +	struct mutex state_mutex;
> +	enum vfio_device_mig_state mig_state;
> +	u16 vhca_id;
> +	struct mlx5_vf_migration_file *resuming_migf;
> +	struct mlx5_vf_migration_file *saving_migf;
> +};

Nit, migrate_cap and vhca_id could minimally be contiguous for better
packing of this struct.  Thanks,

Alex

