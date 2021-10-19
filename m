Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D62B433EB1
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 20:44:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234526AbhJSSqM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 14:46:12 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:57998 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230059AbhJSSqL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Oct 2021 14:46:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634669038;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Sr+x84SCkmGLApJEjQsX0aDeUaBjlbrwfVOJ4N8OhpA=;
        b=N8OW5jdH6bnDiG/2SH7s0CPZhFFy0SI0yd7LT+pU7m+zMa2W7Xoan0oBeOaLeLW4eRV6Ch
        YShXHKgJISe6bygXxky0sOux+JNdqDCb1eip03lyq+QHhNrA9G8PABv/heKq8osoKr0GOh
        d1oPsdCxZs8R92hD2QdPNgE6WCwq3Rc=
Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com
 [209.85.167.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-354-DTnFjxt6MqWyFQtRQQ8Ezw-1; Tue, 19 Oct 2021 14:43:57 -0400
X-MC-Unique: DTnFjxt6MqWyFQtRQQ8Ezw-1
Received: by mail-oi1-f198.google.com with SMTP id w26-20020a056808019a00b00298e7b4523cso2356367oic.9
        for <netdev@vger.kernel.org>; Tue, 19 Oct 2021 11:43:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Sr+x84SCkmGLApJEjQsX0aDeUaBjlbrwfVOJ4N8OhpA=;
        b=gXzmnYakFqjur3Kzz/03JX6QH30Z969VTKt3AldeUrBFGvb9NfaFFc8OnSEllk/2j9
         9a2nDPv/7kQmNNtJlur7zpw2HsuTd/23IrvO5wE8gIkN5H2Efd+rWwufozyd742YIVme
         mnI7fjiqN9GcUzW7BRxnjHXaN7yiZvyl5fhU6K4K4eE78dA2B7d+EXscSdc70j50+Zh8
         tsZ903S9XizNoUHveJzRsZU4owmvZ8JMFeMZmm8FMTa2NLOsCjTZ1+YF5gcZfPm9QdBM
         8/BBTA1cUUmOpT3fPA8S5LoxZ0wqGTbrFPHX1o5gB1Kahl8/9dy7TpzqUbp2uofDhjWH
         J4Qg==
X-Gm-Message-State: AOAM530HoqzjzJS0Yyr5J+7YA4DYK6DidCzk2tPmmDs+MtnQ6E6VmARR
        gGN3mkZVRzaaghzOLSpVdlk0dtvvtgk0Nv0r4Bj0ZI4rYUBk+B/hiGzikLhwPnUE+qYzKtwQ4Dw
        X9+/Co63sucrNhpLQ
X-Received: by 2002:a05:6808:21a7:: with SMTP id be39mr5821694oib.145.1634669035227;
        Tue, 19 Oct 2021 11:43:55 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzdPrscBK1YG1VH1rUMi0yLuvlurM9VfSCdKInuWJvERwiEMMvX78fAUQE+08Aj4iTiMq6yiQ==
X-Received: by 2002:a05:6808:21a7:: with SMTP id be39mr5821661oib.145.1634669034900;
        Tue, 19 Oct 2021 11:43:54 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id bb39sm4048561oib.28.2021.10.19.11.43.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Oct 2021 11:43:54 -0700 (PDT)
Date:   Tue, 19 Oct 2021 12:43:52 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Yishai Hadas <yishaih@nvidia.com>
Cc:     <bhelgaas@google.com>, <jgg@nvidia.com>, <saeedm@nvidia.com>,
        <linux-pci@vger.kernel.org>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>, <leonro@nvidia.com>,
        <kwankhede@nvidia.com>, <mgurtovoy@nvidia.com>, <maorg@nvidia.com>
Subject: Re: [PATCH V2 mlx5-next 12/14] vfio/mlx5: Implement vfio_pci driver
 for mlx5 devices
Message-ID: <20211019124352.74c3b6ba.alex.williamson@redhat.com>
In-Reply-To: <20211019105838.227569-13-yishaih@nvidia.com>
References: <20211019105838.227569-1-yishaih@nvidia.com>
        <20211019105838.227569-13-yishaih@nvidia.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 19 Oct 2021 13:58:36 +0300
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
> ---
>  MAINTAINERS                    |   6 +
>  drivers/vfio/pci/Kconfig       |   3 +
>  drivers/vfio/pci/Makefile      |   2 +
>  drivers/vfio/pci/mlx5/Kconfig  |  10 +
>  drivers/vfio/pci/mlx5/Makefile |   4 +
>  drivers/vfio/pci/mlx5/main.c   | 696 +++++++++++++++++++++++++++++++++
>  6 files changed, 721 insertions(+)
>  create mode 100644 drivers/vfio/pci/mlx5/Kconfig
>  create mode 100644 drivers/vfio/pci/mlx5/Makefile
>  create mode 100644 drivers/vfio/pci/mlx5/main.c
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index abdcbcfef73d..e824bfab4a01 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -19699,6 +19699,12 @@ L:	kvm@vger.kernel.org
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
> index 000000000000..119712656400
> --- /dev/null
> +++ b/drivers/vfio/pci/mlx5/Kconfig
> @@ -0,0 +1,10 @@
> +# SPDX-License-Identifier: GPL-2.0-only
> +config MLX5_VFIO_PCI
> +	tristate "VFIO support for MLX5 PCI devices"
> +	depends on MLX5_CORE
> +	select VFIO_PCI_CORE
> +	help
> +	  This provides a migration support for MLX5 devices using the VFIO

s/ a//


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
> diff --git a/drivers/vfio/pci/mlx5/main.c b/drivers/vfio/pci/mlx5/main.c
> new file mode 100644
> index 000000000000..621b7fc60544
> --- /dev/null
> +++ b/drivers/vfio/pci/mlx5/main.c
> @@ -0,0 +1,696 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Copyright (c) 2021, NVIDIA CORPORATION & AFFILIATES. All rights reserved
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
> +
> +#include "cmd.h"
> +
> +enum {
> +	MLX5VF_PCI_FREEZED = 1 << 0,
> +};
> +
> +enum {
> +	MLX5VF_REGION_PENDING_BYTES = 1 << 0,
> +	MLX5VF_REGION_DATA_SIZE = 1 << 1,
> +};
> +
> +enum {
> +	MLX5VF_SUPPORTED_DEVICE_STATES = VFIO_DEVICE_STATE_RUNNING |
> +					 VFIO_DEVICE_STATE_SAVING |
> +					 VFIO_DEVICE_STATE_RESUMING,
> +};
> +
> +#define MLX5VF_MIG_REGION_DATA_SIZE SZ_128K
> +/* Data section offset from migration region */
> +#define MLX5VF_MIG_REGION_DATA_OFFSET                                          \
> +	(sizeof(struct vfio_device_migration_info))
> +
> +#define VFIO_DEVICE_MIGRATION_OFFSET(x)                                        \
> +	(offsetof(struct vfio_device_migration_info, x))
> +
> +struct mlx5vf_pci_migration_info {
> +	u32 vfio_dev_state; /* VFIO_DEVICE_STATE_XXX */
> +	u32 dev_state; /* device migration state */
> +	u32 region_state; /* Use MLX5VF_REGION_XXX */
> +	u16 vhca_id;
> +	struct mlx5_vhca_state_data vhca_state_data;
> +};
> +
> +struct mlx5vf_pci_core_device {
> +	struct vfio_pci_core_device core_device;
> +	u8 migrate_cap:1;
> +	/* protect migartion state */

s/migartion/migration/

> +	struct mutex state_mutex;
> +	struct mlx5vf_pci_migration_info vmig;
> +};
> +
> +static int mlx5vf_pci_unquiesce_device(struct mlx5vf_pci_core_device *mvdev)
> +{
> +	return mlx5vf_cmd_resume_vhca(mvdev->core_device.pdev,
> +				      mvdev->vmig.vhca_id,
> +				      MLX5_RESUME_VHCA_IN_OP_MOD_RESUME_MASTER);
> +}
> +
> +static int mlx5vf_pci_quiesce_device(struct mlx5vf_pci_core_device *mvdev)
> +{
> +	return mlx5vf_cmd_suspend_vhca(
> +		mvdev->core_device.pdev, mvdev->vmig.vhca_id,
> +		MLX5_SUSPEND_VHCA_IN_OP_MOD_SUSPEND_MASTER);
> +}
> +
> +static int mlx5vf_pci_unfreeze_device(struct mlx5vf_pci_core_device *mvdev)
> +{
> +	int ret;
> +
> +	ret = mlx5vf_cmd_resume_vhca(mvdev->core_device.pdev,
> +				     mvdev->vmig.vhca_id,
> +				     MLX5_RESUME_VHCA_IN_OP_MOD_RESUME_SLAVE);
> +	if (ret)
> +		return ret;
> +
> +	mvdev->vmig.dev_state &= ~MLX5VF_PCI_FREEZED;
> +	return 0;
> +}
> +
> +static int mlx5vf_pci_freeze_device(struct mlx5vf_pci_core_device *mvdev)
> +{
> +	int ret;
> +
> +	ret = mlx5vf_cmd_suspend_vhca(
> +		mvdev->core_device.pdev, mvdev->vmig.vhca_id,
> +		MLX5_SUSPEND_VHCA_IN_OP_MOD_SUSPEND_SLAVE);
> +	if (ret)
> +		return ret;
> +
> +	mvdev->vmig.dev_state |= MLX5VF_PCI_FREEZED;
> +	return 0;
> +}
> +
> +static int mlx5vf_pci_save_device_data(struct mlx5vf_pci_core_device *mvdev)
> +{
> +	u32 state_size = 0;
> +	int ret;
> +
> +	if (!(mvdev->vmig.dev_state & MLX5VF_PCI_FREEZED))
> +		return -EFAULT;
> +
> +	/* If we already read state no reason to re-read */
> +	if (mvdev->vmig.vhca_state_data.state_size)
> +		return 0;
> +
> +	ret = mlx5vf_cmd_query_vhca_migration_state(
> +		mvdev->core_device.pdev, mvdev->vmig.vhca_id, &state_size);
> +	if (ret)
> +		return ret;
> +
> +	return mlx5vf_cmd_save_vhca_state(mvdev->core_device.pdev,
> +					  mvdev->vmig.vhca_id, state_size,
> +					  &mvdev->vmig.vhca_state_data);
> +}
> +
> +static int mlx5vf_pci_new_write_window(struct mlx5vf_pci_core_device *mvdev)
> +{
> +	struct mlx5_vhca_state_data *state_data = &mvdev->vmig.vhca_state_data;
> +	u32 num_pages_needed;
> +	u64 allocated_ready;
> +	u32 bytes_needed;
> +
> +	/* Check how many bytes are available from previous flows */
> +	WARN_ON(state_data->num_pages * PAGE_SIZE <
> +		state_data->win_start_offset);
> +	allocated_ready = (state_data->num_pages * PAGE_SIZE) -
> +			  state_data->win_start_offset;
> +	WARN_ON(allocated_ready > MLX5VF_MIG_REGION_DATA_SIZE);
> +
> +	bytes_needed = MLX5VF_MIG_REGION_DATA_SIZE - allocated_ready;
> +	if (!bytes_needed)
> +		return 0;
> +
> +	num_pages_needed = DIV_ROUND_UP_ULL(bytes_needed, PAGE_SIZE);
> +	return mlx5vf_add_migration_pages(state_data, num_pages_needed);
> +}
> +
> +static ssize_t
> +mlx5vf_pci_handle_migration_data_size(struct mlx5vf_pci_core_device *mvdev,
> +				      char __user *buf, bool iswrite)
> +{
> +	struct mlx5vf_pci_migration_info *vmig = &mvdev->vmig;
> +	u64 data_size;
> +	int ret;
> +
> +	if (iswrite) {
> +		/* data_size is writable only during resuming state */
> +		if (vmig->vfio_dev_state != VFIO_DEVICE_STATE_RESUMING)
> +			return -EINVAL;
> +
> +		ret = copy_from_user(&data_size, buf, sizeof(data_size));
> +		if (ret)
> +			return -EFAULT;
> +
> +		vmig->vhca_state_data.state_size += data_size;
> +		vmig->vhca_state_data.win_start_offset += data_size;
> +		ret = mlx5vf_pci_new_write_window(mvdev);
> +		if (ret)
> +			return ret;
> +
> +	} else {
> +		if (vmig->vfio_dev_state != VFIO_DEVICE_STATE_SAVING)
> +			return -EINVAL;
> +
> +		data_size = min_t(u64, MLX5VF_MIG_REGION_DATA_SIZE,
> +				  vmig->vhca_state_data.state_size -
> +				  vmig->vhca_state_data.win_start_offset);
> +		ret = copy_to_user(buf, &data_size, sizeof(data_size));
> +		if (ret)
> +			return -EFAULT;
> +	}
> +
> +	vmig->region_state |= MLX5VF_REGION_DATA_SIZE;
> +	return sizeof(data_size);
> +}
> +
> +static ssize_t
> +mlx5vf_pci_handle_migration_data_offset(struct mlx5vf_pci_core_device *mvdev,
> +					char __user *buf, bool iswrite)
> +{
> +	static const u64 data_offset = MLX5VF_MIG_REGION_DATA_OFFSET;
> +	int ret;
> +
> +	/* RO field */
> +	if (iswrite)
> +		return -EFAULT;
> +
> +	ret = copy_to_user(buf, &data_offset, sizeof(data_offset));
> +	if (ret)
> +		return -EFAULT;
> +
> +	return sizeof(data_offset);
> +}
> +
> +static ssize_t
> +mlx5vf_pci_handle_migration_pending_bytes(struct mlx5vf_pci_core_device *mvdev,
> +					  char __user *buf, bool iswrite)
> +{
> +	struct mlx5vf_pci_migration_info *vmig = &mvdev->vmig;
> +	u64 pending_bytes;
> +	int ret;
> +
> +	/* RO field */
> +	if (iswrite)
> +		return -EFAULT;
> +
> +	if (vmig->vfio_dev_state == (VFIO_DEVICE_STATE_SAVING |
> +				     VFIO_DEVICE_STATE_RUNNING)) {
> +		/* In pre-copy state we have no data to return for now,
> +		 * return 0 pending bytes
> +		 */
> +		pending_bytes = 0;
> +	} else {
> +		if (!vmig->vhca_state_data.state_size)
> +			return 0;
> +		pending_bytes = vmig->vhca_state_data.state_size -
> +				vmig->vhca_state_data.win_start_offset;
> +	}
> +
> +	ret = copy_to_user(buf, &pending_bytes, sizeof(pending_bytes));
> +	if (ret)
> +		return -EFAULT;
> +
> +	/* Window moves forward once data from previous iteration was read */
> +	if (vmig->region_state & MLX5VF_REGION_DATA_SIZE)
> +		vmig->vhca_state_data.win_start_offset +=
> +			min_t(u64, MLX5VF_MIG_REGION_DATA_SIZE, pending_bytes);
> +
> +	WARN_ON(vmig->vhca_state_data.win_start_offset >
> +		vmig->vhca_state_data.state_size);
> +
> +	/* New iteration started */
> +	vmig->region_state = MLX5VF_REGION_PENDING_BYTES;
> +	return sizeof(pending_bytes);
> +}
> +
> +static int mlx5vf_load_state(struct mlx5vf_pci_core_device *mvdev)
> +{
> +	if (!mvdev->vmig.vhca_state_data.state_size)
> +		return 0;
> +
> +	return mlx5vf_cmd_load_vhca_state(mvdev->core_device.pdev,
> +					  mvdev->vmig.vhca_id,
> +					  &mvdev->vmig.vhca_state_data);
> +}
> +
> +static void mlx5vf_reset_mig_state(struct mlx5vf_pci_core_device *mvdev)
> +{
> +	struct mlx5vf_pci_migration_info *vmig = &mvdev->vmig;
> +
> +	vmig->region_state = 0;
> +	mlx5vf_reset_vhca_state(&vmig->vhca_state_data);
> +}
> +
> +static int mlx5vf_pci_set_device_state(struct mlx5vf_pci_core_device *mvdev,
> +				       u32 state)
> +{
> +	struct mlx5vf_pci_migration_info *vmig = &mvdev->vmig;
> +	u32 old_state = vmig->vfio_dev_state;
> +	int ret = 0;
> +
> +	if (old_state == VFIO_DEVICE_STATE_ERROR ||
> +	    !VFIO_DEVICE_STATE_VALID(state) ||
> +	    (state & ~MLX5VF_SUPPORTED_DEVICE_STATES))
> +		return -EINVAL;
> +
> +	/* Running switches off */
> +	if (((old_state ^ state) & VFIO_DEVICE_STATE_RUNNING) &&
> +	    (old_state & VFIO_DEVICE_STATE_RUNNING)) {
> +		ret = mlx5vf_pci_quiesce_device(mvdev);
> +		if (ret)
> +			return ret;
> +		ret = mlx5vf_pci_freeze_device(mvdev);
> +		if (ret) {
> +			vmig->vfio_dev_state = VFIO_DEVICE_STATE_ERROR;
> +			return ret;
> +		}
> +	}
> +
> +	/* Resuming switches off */
> +	if (((old_state ^ state) & VFIO_DEVICE_STATE_RESUMING) &&
> +	    (old_state & VFIO_DEVICE_STATE_RESUMING)) {
> +		/* deserialize state into the device */
> +		ret = mlx5vf_load_state(mvdev);
> +		if (ret) {
> +			vmig->vfio_dev_state = VFIO_DEVICE_STATE_ERROR;
> +			return ret;
> +		}
> +	}
> +
> +	/* Resuming switches on */
> +	if (((old_state ^ state) & VFIO_DEVICE_STATE_RESUMING) &&
> +	    (state & VFIO_DEVICE_STATE_RESUMING)) {
> +		mlx5vf_reset_mig_state(mvdev);
> +		ret = mlx5vf_pci_new_write_window(mvdev);
> +		if (ret)
> +			return ret;
> +	}

A couple nits here...

Perhaps:

	if ((old_state ^ state) & VFIO_DEVICE_STATE_RESUMING)) {
		/* Resuming bit cleared */
		if (old_state & VFIO_DEVICE_STATE_RESUMING) {
			...
		} else { /* Resuming bit set */
			...
		}
	}

Also

	u32 flipped_bits = old_state ^ state;

or similar would simplify all these cases slightly.


> +
> +	/* Saving switches on */
> +	if (((old_state ^ state) & VFIO_DEVICE_STATE_SAVING) &&
> +	    (state & VFIO_DEVICE_STATE_SAVING)) {
> +		if (!(state & VFIO_DEVICE_STATE_RUNNING)) {
> +			/* serialize post copy */
> +			ret = mlx5vf_pci_save_device_data(mvdev);
> +			if (ret)
> +				return ret;
> +		}
> +	}

This doesn't catch all the cases, and in fact misses the most expected
case where userspace clears the _RUNNING bit while _SAVING is already
enabled.  Does that mean this hasn't actually been tested with QEMU?

It seems like there also needs to be a clause in the case where
_RUNNING switches off to test if _SAVING is already set and has not
toggled.


> +
> +	/* Running switches on */
> +	if (((old_state ^ state) & VFIO_DEVICE_STATE_RUNNING) &&
> +	    (state & VFIO_DEVICE_STATE_RUNNING)) {
> +		ret = mlx5vf_pci_unfreeze_device(mvdev);
> +		if (ret)
> +			return ret;
> +		ret = mlx5vf_pci_unquiesce_device(mvdev);
> +		if (ret) {
> +			vmig->vfio_dev_state = VFIO_DEVICE_STATE_ERROR;
> +			return ret;
> +		}
> +	}

Per previous discussion, I understand that freeze and quiesce are
loosely stop-responding-to-dma and stop-sending-dma, respectively.
Once we're quiesced and frozen, device state doesn't change.  What are
the implications to userspace that we don't expose a quiesce state
(yet)?  I'm wondering if this needs to be resolved before we introduce
our first in-tree user of the uAPI (and before QEMU support becomes
non-experimental).  Thanks,

Alex

