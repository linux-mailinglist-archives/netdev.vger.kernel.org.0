Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0ED416DBFA8
	for <lists+netdev@lfdr.de>; Sun,  9 Apr 2023 13:27:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229484AbjDIL0x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Apr 2023 07:26:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbjDIL0w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Apr 2023 07:26:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 247213C3D
        for <netdev@vger.kernel.org>; Sun,  9 Apr 2023 04:26:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AAD7E60BC9
        for <netdev@vger.kernel.org>; Sun,  9 Apr 2023 11:26:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 410BBC433EF;
        Sun,  9 Apr 2023 11:26:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681039610;
        bh=zMecTRBUJ9RyIElCVrnNR3xugCjiDRIdAmVs11fj8UQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=S4F2Stp6kcx9zchBTAPNfpdRrNAf9mxEDVAaUR4HaKawe3IvastMKMnexdXfs7yHk
         JlmTYK7WzSvnv/3Q1ymHKn5FvBivNmmbHBwQCl4KKJL9ncA1x+4vLtUZf3yAj37PEx
         Sjgr6WWSazpAzLhywfaqCFaA217AW/nRsWtn9lVyrT5h8CsAhqXCm8ICaAFVfNanvz
         WtKGnhRnUMbV8G58w/ZenMCh2wNiZhz38Ybq52PngPjVdcaAUD8vKK2VS1XXa1dsBU
         pWFpNIhtn8HP6pOEdAx5ZQjKxhoEUXclOv4YsI2skY/8F4unurLFsMOUpwW2UGMm3J
         PKGLYtnRajPSA==
Date:   Sun, 9 Apr 2023 14:26:45 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Shannon Nelson <shannon.nelson@amd.com>
Cc:     brett.creeley@amd.com, davem@davemloft.net, netdev@vger.kernel.org,
        kuba@kernel.org, drivers@pensando.io, jiri@resnulli.us
Subject: Re: [PATCH v9 net-next 01/14] pds_core: initial framework for
 pds_core PF driver
Message-ID: <20230409112645.GS14869@unreal>
References: <20230406234143.11318-1-shannon.nelson@amd.com>
 <20230406234143.11318-2-shannon.nelson@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230406234143.11318-2-shannon.nelson@amd.com>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 06, 2023 at 04:41:30PM -0700, Shannon Nelson wrote:
> This is the initial PCI driver framework for the new pds_core device
> driver and its family of devices.  This does the very basics of
> registering for the new PF PCI device 1dd8:100c, setting up debugfs
> entries, and registering with devlink.
> 
> Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
> ---
>  .../device_drivers/ethernet/amd/pds_core.rst  |  40 ++
>  .../device_drivers/ethernet/index.rst         |   1 +
>  drivers/net/ethernet/amd/pds_core/Makefile    |   8 +
>  drivers/net/ethernet/amd/pds_core/core.h      |  63 ++
>  drivers/net/ethernet/amd/pds_core/debugfs.c   |  34 ++
>  drivers/net/ethernet/amd/pds_core/main.c      | 285 +++++++++
>  include/linux/pds/pds_common.h                |  14 +
>  include/linux/pds/pds_core_if.h               | 540 ++++++++++++++++++
>  8 files changed, 985 insertions(+)
>  create mode 100644 Documentation/networking/device_drivers/ethernet/amd/pds_core.rst
>  create mode 100644 drivers/net/ethernet/amd/pds_core/Makefile
>  create mode 100644 drivers/net/ethernet/amd/pds_core/core.h
>  create mode 100644 drivers/net/ethernet/amd/pds_core/debugfs.c
>  create mode 100644 drivers/net/ethernet/amd/pds_core/main.c
>  create mode 100644 include/linux/pds/pds_common.h
>  create mode 100644 include/linux/pds/pds_core_if.h

<...>

> +#ifdef CONFIG_DEBUG_FS
> +void pdsc_debugfs_create(void);
> +void pdsc_debugfs_destroy(void);
> +void pdsc_debugfs_add_dev(struct pdsc *pdsc);
> +void pdsc_debugfs_del_dev(struct pdsc *pdsc);
> +#else
> +static inline void pdsc_debugfs_create(void) { }
> +static inline void pdsc_debugfs_destroy(void) { }
> +static inline void pdsc_debugfs_add_dev(struct pdsc *pdsc) { }
> +static inline void pdsc_debugfs_del_dev(struct pdsc *pdsc) { }
> +#endif

I don't think that you need CONFIG_DEBUG_FS guard as debugfs code is
built to handle this case, so you can call to internal debugfs_*() calls
without completed initialization of debugfs.

> +
> +#endif /* _PDSC_H_ */
> diff --git a/drivers/net/ethernet/amd/pds_core/debugfs.c b/drivers/net/ethernet/amd/pds_core/debugfs.c
> new file mode 100644
> index 000000000000..9b2385c19c41
> --- /dev/null
> +++ b/drivers/net/ethernet/amd/pds_core/debugfs.c
> @@ -0,0 +1,34 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Copyright(c) 2023 Advanced Micro Devices, Inc */
> +
> +#ifdef CONFIG_DEBUG_FS
> +
> +#include <linux/pci.h>
> +
> +#include "core.h"
> +
> +static struct dentry *pdsc_dir;
> +
> +void pdsc_debugfs_create(void)
> +{
> +	pdsc_dir = debugfs_create_dir(PDS_CORE_DRV_NAME, NULL);
> +}
> +
> +void pdsc_debugfs_destroy(void)
> +{
> +	debugfs_remove_recursive(pdsc_dir);
> +}
> +
> +void pdsc_debugfs_add_dev(struct pdsc *pdsc)
> +{
> +	pdsc->dentry = debugfs_create_dir(pci_name(pdsc->pdev), pdsc_dir);
> +
> +	debugfs_create_ulong("state", 0400, pdsc->dentry, &pdsc->state);
> +}
> +
> +void pdsc_debugfs_del_dev(struct pdsc *pdsc)
> +{
> +	debugfs_remove_recursive(pdsc->dentry);
> +	pdsc->dentry = NULL;
> +}
> +#endif /* CONFIG_DEBUG_FS */
> diff --git a/drivers/net/ethernet/amd/pds_core/main.c b/drivers/net/ethernet/amd/pds_core/main.c
> new file mode 100644
> index 000000000000..1c2f3fbaa27c
> --- /dev/null
> +++ b/drivers/net/ethernet/amd/pds_core/main.c
> @@ -0,0 +1,285 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Copyright(c) 2023 Advanced Micro Devices, Inc */
> +
> +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> +
> +#include <linux/pci.h>
> +
> +#include <linux/pds/pds_common.h>
> +
> +#include "core.h"
> +
> +MODULE_DESCRIPTION(PDSC_DRV_DESCRIPTION);
> +MODULE_AUTHOR("Advanced Micro Devices, Inc");
> +MODULE_LICENSE("GPL");
> +
> +/* Supported devices */
> +static const struct pci_device_id pdsc_id_table[] = {
> +	{ PCI_VDEVICE(PENSANDO, PCI_DEVICE_ID_PENSANDO_CORE_PF) },
> +	{ 0, }	/* end of table */
> +};
> +MODULE_DEVICE_TABLE(pci, pdsc_id_table);
> +
> +static void pdsc_unmap_bars(struct pdsc *pdsc)
> +{
> +	struct pdsc_dev_bar *bars = pdsc->bars;
> +	unsigned int i;
> +
> +	for (i = 0; i < PDS_CORE_BARS_MAX; i++) {
> +		if (bars[i].vaddr) {
> +			pci_iounmap(pdsc->pdev, bars[i].vaddr);
> +			bars[i].vaddr = NULL;
> +		}
> +
> +		bars[i].len = 0;
> +		bars[i].bus_addr = 0;
> +		bars[i].res_index = 0;

Why are you clearing it? You are going to release bars[] anyway.
It will be great to remove this zeroing pattern from whole driver
as it hides use-after-free bugs.

> +	}
> +}
> +
> +static int pdsc_map_bars(struct pdsc *pdsc)
> +{
> +	struct pdsc_dev_bar *bar = pdsc->bars;
> +	struct pci_dev *pdev = pdsc->pdev;
> +	struct device *dev = pdsc->dev;
> +	struct pdsc_dev_bar *bars;
> +	unsigned int i, j;
> +	int num_bars = 0;
> +	int err;
> +	u32 sig;
> +
> +	bars = pdsc->bars;
> +	num_bars = 0;

You set it to zero 4 lines above.

> +

<...>

> +module_init(pdsc_init_module);
> +module_exit(pdsc_cleanup_module);
> diff --git a/include/linux/pds/pds_common.h b/include/linux/pds/pds_common.h
> new file mode 100644
> index 000000000000..bd041a5170a6
> --- /dev/null
> +++ b/include/linux/pds/pds_common.h
> @@ -0,0 +1,14 @@
> +/* SPDX-License-Identifier: (GPL-2.0 OR Linux-OpenIB) OR BSD-2-Clause */
> +/* Copyright(c) 2023 Advanced Micro Devices, Inc. */
> +
> +#ifndef _PDS_COMMON_H_
> +#define _PDS_COMMON_H_
> +
> +#define PDS_CORE_DRV_NAME			"pds_core"

It is KBUILD_MODNAME.

> +
> +/* the device's internal addressing uses up to 52 bits */
> +#define PDS_CORE_ADDR_LEN	52
> +#define PDS_CORE_ADDR_MASK	(BIT_ULL(PDS_ADDR_LEN) - 1)
> +#define PDS_PAGE_SIZE		4096

Thanks
