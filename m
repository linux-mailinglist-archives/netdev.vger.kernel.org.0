Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C0EA790182
	for <lists+netdev@lfdr.de>; Fri, 16 Aug 2019 14:27:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727198AbfHPM1f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Aug 2019 08:27:35 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:55977 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727022AbfHPM1f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Aug 2019 08:27:35 -0400
Received: by mail-wm1-f65.google.com with SMTP id f72so3906655wmf.5
        for <netdev@vger.kernel.org>; Fri, 16 Aug 2019 05:27:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=i8GTKczDao+f0rWi7nMc/7vSnceCGi95sUaqyHpV3eo=;
        b=hNOGcJkN7OLUjhog65CjmTWotN2xqWYRiBoAhAK+GcpnoN2eHq61t6jICr9xvl3Kql
         eaz0FFWeyGx74uBgQfJev+igpTX1vWgAKWLbgTV7Djbe0TP9hm5PT5/XmwbXE/N1iON1
         wYSN7hWTDIFfVxSTTXKJGSgHSfcYXWkwJ7bhWuvFKgSM5BdZQbNzv3FXBAHB0PtRATBh
         fQfN2ZGL4zqpdNQmAhKMLufGMsdsq3zLmAGLIa3qiG0/jnitOqWovLikkQ9J920e8lo6
         5SzeJB0+pcmUIzQJTBfKZ16L97i85W92UU6o31UOOGNHwF//lPoUxHzIHTNp+ZCIh4W2
         DryQ==
X-Gm-Message-State: APjAAAWhNbO1k0rRfzWG52Y8tBd4vuNE0QYcCn78VOu85l91VXLC9Kx4
        GeX2G20mpEqO+MFPKekN7c9G7g==
X-Google-Smtp-Source: APXvYqz5POVD8d0hDu3+HT/ogWFdIQxctT6BfNfWDcMulU0XWKLX3/LVv51Y/SwlMMtXIWFDIGGCzw==
X-Received: by 2002:a05:600c:24d0:: with SMTP id 16mr6960658wmu.83.1565958452915;
        Fri, 16 Aug 2019 05:27:32 -0700 (PDT)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id l3sm8609082wrb.41.2019.08.16.05.27.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Aug 2019 05:27:32 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Haiyang Zhang <haiyangz@microsoft.com>,
        "sashal\@kernel.org" <sashal@kernel.org>,
        "davem\@davemloft.net" <davem@davemloft.net>,
        "saeedm\@mellanox.com" <saeedm@mellanox.com>,
        "leon\@kernel.org" <leon@kernel.org>,
        "eranbe\@mellanox.com" <eranbe@mellanox.com>,
        "lorenzo.pieralisi\@arm.com" <lorenzo.pieralisi@arm.com>,
        "bhelgaas\@google.com" <bhelgaas@google.com>,
        "linux-pci\@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-hyperv\@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev\@vger.kernel.org" <netdev@vger.kernel.org>
Cc:     Haiyang Zhang <haiyangz@microsoft.com>,
        KY Srinivasan <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next, 2/6] PCI: hv: Add a Hyper-V PCI mini driver for software backchannel interface
In-Reply-To: <1565809632-39138-3-git-send-email-haiyangz@microsoft.com>
References: <1565809632-39138-1-git-send-email-haiyangz@microsoft.com> <1565809632-39138-3-git-send-email-haiyangz@microsoft.com>
Date:   Fri, 16 Aug 2019 14:27:31 +0200
Message-ID: <878srt8fd8.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Haiyang Zhang <haiyangz@microsoft.com> writes:

> This mini driver is a helper driver allows other drivers to
> have a common interface with the Hyper-V PCI frontend driver.
>
> Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
> ---
>  MAINTAINERS                              |  1 +
>  drivers/pci/Kconfig                      |  1 +
>  drivers/pci/controller/Kconfig           |  7 ++++
>  drivers/pci/controller/Makefile          |  1 +
>  drivers/pci/controller/pci-hyperv-mini.c | 70 ++++++++++++++++++++++++++++++++
>  drivers/pci/controller/pci-hyperv.c      | 12 ++++--
>  include/linux/hyperv.h                   | 30 ++++++++++----
>  7 files changed, 111 insertions(+), 11 deletions(-)
>  create mode 100644 drivers/pci/controller/pci-hyperv-mini.c
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index e352550..c4962b9 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -7453,6 +7453,7 @@ F:	drivers/hid/hid-hyperv.c
>  F:	drivers/hv/
>  F:	drivers/input/serio/hyperv-keyboard.c
>  F:	drivers/pci/controller/pci-hyperv.c
> +F:	drivers/pci/controller/pci-hyperv-mini.c
>  F:	drivers/net/hyperv/
>  F:	drivers/scsi/storvsc_drv.c
>  F:	drivers/uio/uio_hv_generic.c
> diff --git a/drivers/pci/Kconfig b/drivers/pci/Kconfig
> index 2ab9240..bb852f5 100644
> --- a/drivers/pci/Kconfig
> +++ b/drivers/pci/Kconfig
> @@ -182,6 +182,7 @@ config PCI_LABEL
>  config PCI_HYPERV
>          tristate "Hyper-V PCI Frontend"
>          depends on X86 && HYPERV && PCI_MSI && PCI_MSI_IRQ_DOMAIN && X86_64
> +	select PCI_HYPERV_MINI
>          help
>            The PCI device frontend driver allows the kernel to import arbitrary
>            PCI devices from a PCI backend to support PCI driver domains.
> diff --git a/drivers/pci/controller/Kconfig b/drivers/pci/controller/Kconfig
> index fe9f9f1..8e31cba 100644
> --- a/drivers/pci/controller/Kconfig
> +++ b/drivers/pci/controller/Kconfig
> @@ -281,5 +281,12 @@ config VMD
>  	  To compile this driver as a module, choose M here: the
>  	  module will be called vmd.
>  
> +config PCI_HYPERV_MINI
> +	tristate "Hyper-V PCI Mini"
> +	depends on X86 && HYPERV && PCI_MSI && PCI_MSI_IRQ_DOMAIN && X86_64
> +	help
> +	  The Hyper-V PCI Mini is a helper driver allows other drivers to
> +	  have a common interface with the Hyper-V PCI frontend driver.
> +

Out of pure curiosity, why not just export this interface from
PCI_HYPERV directly? Why do we need this stub?

>  source "drivers/pci/controller/dwc/Kconfig"
>  endmenu
> diff --git a/drivers/pci/controller/Makefile b/drivers/pci/controller/Makefile
> index d56a507..77e0132 100644
> --- a/drivers/pci/controller/Makefile
> +++ b/drivers/pci/controller/Makefile
> @@ -4,6 +4,7 @@ obj-$(CONFIG_PCIE_CADENCE_HOST) += pcie-cadence-host.o
>  obj-$(CONFIG_PCIE_CADENCE_EP) += pcie-cadence-ep.o
>  obj-$(CONFIG_PCI_FTPCI100) += pci-ftpci100.o
>  obj-$(CONFIG_PCI_HYPERV) += pci-hyperv.o
> +obj-$(CONFIG_PCI_HYPERV_MINI) += pci-hyperv-mini.o
>  obj-$(CONFIG_PCI_MVEBU) += pci-mvebu.o
>  obj-$(CONFIG_PCI_AARDVARK) += pci-aardvark.o
>  obj-$(CONFIG_PCI_TEGRA) += pci-tegra.o
> diff --git a/drivers/pci/controller/pci-hyperv-mini.c b/drivers/pci/controller/pci-hyperv-mini.c
> new file mode 100644
> index 0000000..9b6cd1c
> --- /dev/null
> +++ b/drivers/pci/controller/pci-hyperv-mini.c
> @@ -0,0 +1,70 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (c) Microsoft Corporation.
> + *
> + * Author:
> + *   Haiyang Zhang <haiyangz@microsoft.com>
> + *
> + * This mini driver is a helper driver allows other drivers to
> + * have a common interface with the Hyper-V PCI frontend driver.
> + */
> +
> +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> +
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/hyperv.h>
> +
> +struct hyperv_pci_block_ops hvpci_block_ops;
> +EXPORT_SYMBOL(hvpci_block_ops);
> +
> +int hyperv_read_cfg_blk(struct pci_dev *dev, void *buf, unsigned int buf_len,
> +			unsigned int block_id, unsigned int *bytes_returned)
> +{
> +	if (!hvpci_block_ops.read_block)
> +		return -EOPNOTSUPP;
> +
> +	return hvpci_block_ops.read_block(dev, buf, buf_len, block_id,
> +					  bytes_returned);
> +}
> +EXPORT_SYMBOL(hyperv_read_cfg_blk);
> +
> +int hyperv_write_cfg_blk(struct pci_dev *dev, void *buf, unsigned int len,
> +			 unsigned int block_id)
> +{
> +	if (!hvpci_block_ops.write_block)
> +		return -EOPNOTSUPP;
> +
> +	return hvpci_block_ops.write_block(dev, buf, len, block_id);
> +}
> +EXPORT_SYMBOL(hyperv_write_cfg_blk);
> +
> +int hyperv_reg_block_invalidate(struct pci_dev *dev, void *context,
> +				void (*block_invalidate)(void *context,
> +							 u64 block_mask))
> +{
> +	if (!hvpci_block_ops.reg_blk_invalidate)
> +		return -EOPNOTSUPP;
> +
> +	return hvpci_block_ops.reg_blk_invalidate(dev, context,
> +						  block_invalidate);
> +}
> +EXPORT_SYMBOL(hyperv_reg_block_invalidate);
> +
> +static void __exit exit_hv_pci_mini(void)
> +{
> +	pr_info("unloaded\n");
> +}
> +
> +static int __init init_hv_pci_mini(void)
> +{
> +	pr_info("loaded\n");
> +
> +	return 0;
> +}
> +
> +module_init(init_hv_pci_mini);
> +module_exit(exit_hv_pci_mini);
> +
> +MODULE_DESCRIPTION("Hyper-V PCI Mini");
> +MODULE_LICENSE("GPL v2");
> diff --git a/drivers/pci/controller/pci-hyperv.c b/drivers/pci/controller/pci-hyperv.c
> index 57adeca..9c93ac2 100644
> --- a/drivers/pci/controller/pci-hyperv.c
> +++ b/drivers/pci/controller/pci-hyperv.c
> @@ -983,7 +983,6 @@ int hv_read_config_block(struct pci_dev *pdev, void *buf, unsigned int len,
>  	*bytes_returned = comp_pkt.bytes_returned;
>  	return 0;
>  }
> -EXPORT_SYMBOL(hv_read_config_block);
>  
>  /**
>   * hv_pci_write_config_compl() - Invoked when a response packet for a write
> @@ -1070,7 +1069,6 @@ int hv_write_config_block(struct pci_dev *pdev, void *buf, unsigned int len,
>  
>  	return 0;
>  }
> -EXPORT_SYMBOL(hv_write_config_block);
>  
>  /**
>   * hv_register_block_invalidate() - Invoked when a config block invalidation
> @@ -1101,7 +1099,6 @@ int hv_register_block_invalidate(struct pci_dev *pdev, void *context,
>  	return 0;
>  
>  }
> -EXPORT_SYMBOL(hv_register_block_invalidate);
>  
>  /* Interrupt management hooks */
>  static void hv_int_desc_free(struct hv_pci_dev *hpdev,
> @@ -3045,10 +3042,19 @@ static int hv_pci_remove(struct hv_device *hdev)
>  static void __exit exit_hv_pci_drv(void)
>  {
>  	vmbus_driver_unregister(&hv_pci_drv);
> +
> +	hvpci_block_ops.read_block = NULL;
> +	hvpci_block_ops.write_block = NULL;
> +	hvpci_block_ops.reg_blk_invalidate = NULL;
>  }
>  
>  static int __init init_hv_pci_drv(void)
>  {
> +	/* Initialize PCI block r/w interface */
> +	hvpci_block_ops.read_block = hv_read_config_block;
> +	hvpci_block_ops.write_block = hv_write_config_block;
> +	hvpci_block_ops.reg_blk_invalidate = hv_register_block_invalidate;
> +
>  	return vmbus_driver_register(&hv_pci_drv);
>  }
>  
> diff --git a/include/linux/hyperv.h b/include/linux/hyperv.h
> index 9d37f8c..2afe6fd 100644
> --- a/include/linux/hyperv.h
> +++ b/include/linux/hyperv.h
> @@ -1579,18 +1579,32 @@ struct vmpacket_descriptor *
>  	    pkt = hv_pkt_iter_next(channel, pkt))
>  
>  /*
> - * Functions for passing data between SR-IOV PF and VF drivers.  The VF driver
> + * Interface for passing data between SR-IOV PF and VF drivers. The VF driver
>   * sends requests to read and write blocks. Each block must be 128 bytes or
>   * smaller. Optionally, the VF driver can register a callback function which
>   * will be invoked when the host says that one or more of the first 64 block
>   * IDs is "invalid" which means that the VF driver should reread them.
>   */
>  #define HV_CONFIG_BLOCK_SIZE_MAX 128
> -int hv_read_config_block(struct pci_dev *dev, void *buf, unsigned int buf_len,
> -			 unsigned int block_id, unsigned int *bytes_returned);
> -int hv_write_config_block(struct pci_dev *dev, void *buf, unsigned int len,
> -			  unsigned int block_id);
> -int hv_register_block_invalidate(struct pci_dev *dev, void *context,
> -				 void (*block_invalidate)(void *context,
> -							  u64 block_mask));
> +
> +int hyperv_read_cfg_blk(struct pci_dev *dev, void *buf, unsigned int buf_len,
> +			unsigned int block_id, unsigned int *bytes_returned);
> +int hyperv_write_cfg_blk(struct pci_dev *dev, void *buf, unsigned int len,
> +			 unsigned int block_id);
> +int hyperv_reg_block_invalidate(struct pci_dev *dev, void *context,
> +				void (*block_invalidate)(void *context,
> +							 u64 block_mask));
> +
> +struct hyperv_pci_block_ops {
> +	int (*read_block)(struct pci_dev *dev, void *buf, unsigned int buf_len,
> +			  unsigned int block_id, unsigned int *bytes_returned);
> +	int (*write_block)(struct pci_dev *dev, void *buf, unsigned int len,
> +			   unsigned int block_id);
> +	int (*reg_blk_invalidate)(struct pci_dev *dev, void *context,
> +				  void (*block_invalidate)(void *context,
> +							   u64 block_mask));
> +};
> +
> +extern struct hyperv_pci_block_ops hvpci_block_ops;
> +
>  #endif /* _HYPERV_H */

-- 
Vitaly
