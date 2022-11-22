Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 945AD633446
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 04:55:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230473AbiKVDy5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 22:54:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229553AbiKVDyz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 22:54:55 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 121B42C658
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 19:53:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669089235;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UnA6VEzTKifeem9RtrvwZliEQhxCSeVw1+4dsT4f6tk=;
        b=aIUe14XXfsBvXuz0xdZ9Qiv2yv/CFYVAHz6TyVRz+KuXp1U755H6lk92swEI0G+gGjNZvG
        rTHOaDWRTfqAwRj6eONSJ/dZYlSXHDlthWIK23gvWfkDxtfEgARSX8w30YOpPam0/5ZEyc
        vqcTQtlBYiIL6UzF9kZNn8NFJlhcUCk=
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com
 [209.85.215.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-581-Xj07t_EkNoWzHYlfaEH1uQ-1; Mon, 21 Nov 2022 22:53:53 -0500
X-MC-Unique: Xj07t_EkNoWzHYlfaEH1uQ-1
Received: by mail-pg1-f199.google.com with SMTP id 186-20020a6301c3000000b0046fa202f720so7961556pgb.20
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 19:53:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UnA6VEzTKifeem9RtrvwZliEQhxCSeVw1+4dsT4f6tk=;
        b=xCMJle5Oy31pJVXEA+Hhzl/aS16ofV0TtwfIT4vqpMf7kBgld6alAB7GT1ehUlLLjf
         lA7hn27z/VKolX6eiZU9XSXS+Ere9orrP4dCW5miGkEi5vGtci4CQXbizLxgEFTCpdWJ
         bKMY5yUe5XM3J6FE71+g5Zmu0TM7fd75EDh5CZQ3c+DqtvaQsOaNDcJPxDRFgUxIxJMg
         Ol1XJgbHpBSilvzRSaDIMXwtVeFafb1Og+VoEwwQDVuMEbyKTYFNkzsymrkz3cPakYqV
         rRnlkeAdl+ftZuGT2SVUkypMB+Knl/oCR1g3sBirdmjbnBW6NtYYOL9V29Py2U3kVgdH
         uKdw==
X-Gm-Message-State: ANoB5plClJ9ctxg4TfJwMo/AemD6yRO2DHsP2iFkFNyDwcBRhoMV+iJ9
        lW9IIBXMBCGYVVKavlevoT8pkJpOMSIZP+aKH2iMOlM6WCE8yHSpEqoOIpwQAUQpkiWl1CkwAD1
        dn7+DZnxYUooFre0a
X-Received: by 2002:a17:902:6ac4:b0:186:bb44:946d with SMTP id i4-20020a1709026ac400b00186bb44946dmr2285645plt.11.1669089231667;
        Mon, 21 Nov 2022 19:53:51 -0800 (PST)
X-Google-Smtp-Source: AA0mqf4bQ0qKvVUOID5m7EQMxpxgrH6dlQ12o2Xou3quJOhs0N+wiapUdoT7hxgqNqRExGjZpOAdLA==
X-Received: by 2002:a17:902:6ac4:b0:186:bb44:946d with SMTP id i4-20020a1709026ac400b00186bb44946dmr2285620plt.11.1669089231304;
        Mon, 21 Nov 2022 19:53:51 -0800 (PST)
Received: from [10.72.13.197] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id y3-20020a17090322c300b0018912c37c8fsm5735336plg.129.2022.11.21.19.53.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Nov 2022 19:53:50 -0800 (PST)
Message-ID: <5f7eba6a-442c-4b26-d83f-de7cf633ce65@redhat.com>
Date:   Tue, 22 Nov 2022 11:53:44 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.5.0
Subject: Re: [RFC PATCH net-next 14/19] pds_vdpa: Add new PCI VF device for
 PDS vDPA services
Content-Language: en-US
To:     Shannon Nelson <snelson@pensando.io>, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, mst@redhat.com,
        virtualization@lists.linux-foundation.org
Cc:     drivers@pensando.io
References: <20221118225656.48309-1-snelson@pensando.io>
 <20221118225656.48309-15-snelson@pensando.io>
From:   Jason Wang <jasowang@redhat.com>
In-Reply-To: <20221118225656.48309-15-snelson@pensando.io>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2022/11/19 06:56, Shannon Nelson 写道:
> This is the initial PCI driver framework for the new pds_vdpa VF
> device driver, an auxiliary_bus client of the pds_core driver.
> This does the very basics of registering for the new PCI
> device 1dd8:100b, setting up debugfs entries, and registering
> with devlink.
>
> The new PCI device id has not made it to the official PCI ID Repository
> yet, but will soon be registered there.
>
> Signed-off-by: Shannon Nelson <snelson@pensando.io>
> ---
>   drivers/vdpa/pds/Makefile       |   7 +
>   drivers/vdpa/pds/debugfs.c      |  44 +++++++
>   drivers/vdpa/pds/debugfs.h      |  22 ++++
>   drivers/vdpa/pds/pci_drv.c      | 143 +++++++++++++++++++++
>   drivers/vdpa/pds/pci_drv.h      |  46 +++++++
>   include/linux/pds/pds_core_if.h |   1 +
>   include/linux/pds/pds_vdpa.h    | 219 ++++++++++++++++++++++++++++++++
>   7 files changed, 482 insertions(+)
>   create mode 100644 drivers/vdpa/pds/Makefile
>   create mode 100644 drivers/vdpa/pds/debugfs.c
>   create mode 100644 drivers/vdpa/pds/debugfs.h
>   create mode 100644 drivers/vdpa/pds/pci_drv.c
>   create mode 100644 drivers/vdpa/pds/pci_drv.h
>   create mode 100644 include/linux/pds/pds_vdpa.h
>
> diff --git a/drivers/vdpa/pds/Makefile b/drivers/vdpa/pds/Makefile
> new file mode 100644
> index 000000000000..3ba28a875574
> --- /dev/null
> +++ b/drivers/vdpa/pds/Makefile
> @@ -0,0 +1,7 @@
> +# SPDX-License-Identifier: GPL-2.0-only
> +# Copyright(c) 2022 Pensando Systems, Inc
> +
> +obj-$(CONFIG_PDS_VDPA) := pds_vdpa.o
> +
> +pds_vdpa-y := pci_drv.o	\
> +	      debugfs.o
> diff --git a/drivers/vdpa/pds/debugfs.c b/drivers/vdpa/pds/debugfs.c
> new file mode 100644
> index 000000000000..f5b6654ae89b
> --- /dev/null
> +++ b/drivers/vdpa/pds/debugfs.c
> @@ -0,0 +1,44 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/* Copyright(c) 2022 Pensando Systems, Inc */
> +
> +#include <linux/module.h>
> +#include <linux/pci.h>
> +#include <linux/types.h>
> +
> +#include <linux/pds/pds_core_if.h>
> +#include <linux/pds/pds_vdpa.h>
> +
> +#include "pci_drv.h"
> +#include "debugfs.h"
> +
> +#ifdef CONFIG_DEBUG_FS
> +
> +static struct dentry *dbfs_dir;
> +
> +void
> +pds_vdpa_debugfs_create(void)
> +{
> +	dbfs_dir = debugfs_create_dir(PDS_VDPA_DRV_NAME, NULL);
> +}
> +
> +void
> +pds_vdpa_debugfs_destroy(void)
> +{
> +	debugfs_remove_recursive(dbfs_dir);
> +	dbfs_dir = NULL;
> +}
> +
> +void
> +pds_vdpa_debugfs_add_pcidev(struct pds_vdpa_pci_device *vdpa_pdev)
> +{
> +	vdpa_pdev->dentry = debugfs_create_dir(pci_name(vdpa_pdev->pdev), dbfs_dir);
> +}
> +
> +void
> +pds_vdpa_debugfs_del_pcidev(struct pds_vdpa_pci_device *vdpa_pdev)
> +{
> +	debugfs_remove_recursive(vdpa_pdev->dentry);
> +	vdpa_pdev->dentry = NULL;
> +}
> +
> +#endif /* CONFIG_DEBUG_FS */
> diff --git a/drivers/vdpa/pds/debugfs.h b/drivers/vdpa/pds/debugfs.h
> new file mode 100644
> index 000000000000..ac31ab47746b
> --- /dev/null
> +++ b/drivers/vdpa/pds/debugfs.h
> @@ -0,0 +1,22 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/* Copyright(c) 2022 Pensando Systems, Inc */
> +
> +#ifndef _PDS_VDPA_DEBUGFS_H_
> +#define _PDS_VDPA_DEBUGFS_H_
> +
> +#include <linux/debugfs.h>
> +
> +#ifdef CONFIG_DEBUG_FS
> +
> +void pds_vdpa_debugfs_create(void);
> +void pds_vdpa_debugfs_destroy(void);
> +void pds_vdpa_debugfs_add_pcidev(struct pds_vdpa_pci_device *vdpa_pdev);
> +void pds_vdpa_debugfs_del_pcidev(struct pds_vdpa_pci_device *vdpa_pdev);
> +#else
> +static inline void pds_vdpa_debugfs_create(void) { }
> +static inline void pds_vdpa_debugfs_destroy(void) { }
> +static inline void pds_vdpa_debugfs_add_pcidev(struct pds_vdpa_pci_device *vdpa_pdev) { }
> +static inline void pds_vdpa_debugfs_del_pcidev(struct pds_vdpa_pci_device *vdpa_pdev) { }
> +#endif
> +
> +#endif /* _PDS_VDPA_DEBUGFS_H_ */
> diff --git a/drivers/vdpa/pds/pci_drv.c b/drivers/vdpa/pds/pci_drv.c
> new file mode 100644
> index 000000000000..369e11153f21
> --- /dev/null
> +++ b/drivers/vdpa/pds/pci_drv.c
> @@ -0,0 +1,143 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/* Copyright(c) 2022 Pensando Systems, Inc */
> +
> +#include <linux/module.h>
> +#include <linux/pci.h>
> +#include <linux/aer.h>
> +#include <linux/types.h>
> +#include <linux/vdpa.h>
> +
> +#include <linux/pds/pds_core_if.h>
> +#include <linux/pds/pds_vdpa.h>
> +
> +#include "pci_drv.h"
> +#include "debugfs.h"
> +
> +static void
> +pds_vdpa_dma_action(void *data)
> +{
> +	pci_free_irq_vectors((struct pci_dev *)data);
> +}


Nit: since we're release irq vectors, it might be better to use 
"pds_vdpa_irq_action"


> +
> +static int
> +pds_vdpa_pci_probe(struct pci_dev *pdev,
> +		   const struct pci_device_id *id)
> +{
> +	struct pds_vdpa_pci_device *vdpa_pdev;
> +	struct device *dev = &pdev->dev;
> +	int err;
> +
> +	vdpa_pdev = kzalloc(sizeof(*vdpa_pdev), GFP_KERNEL);
> +	if (!vdpa_pdev)
> +		return -ENOMEM;
> +	pci_set_drvdata(pdev, vdpa_pdev);
> +
> +	vdpa_pdev->pdev = pdev;
> +	vdpa_pdev->vf_id = pci_iov_vf_id(pdev);
> +	vdpa_pdev->pci_id = PCI_DEVID(pdev->bus->number, pdev->devfn);
> +
> +	/* Query system for DMA addressing limitation for the device. */
> +	err = dma_set_mask_and_coherent(dev, DMA_BIT_MASK(PDS_CORE_ADDR_LEN));
> +	if (err) {
> +		dev_err(dev, "Unable to obtain 64-bit DMA for consistent allocations, aborting. %pe\n",
> +			ERR_PTR(err));
> +		goto err_out_free_mem;
> +	}
> +
> +	pci_enable_pcie_error_reporting(pdev);
> +
> +	/* Use devres management */
> +	err = pcim_enable_device(pdev);
> +	if (err) {
> +		dev_err(dev, "Cannot enable PCI device: %pe\n", ERR_PTR(err));
> +		goto err_out_free_mem;
> +	}
> +
> +	err = devm_add_action_or_reset(dev, pds_vdpa_dma_action, pdev);
> +	if (err) {
> +		dev_err(dev, "Failed adding devres for freeing irq vectors: %pe\n",
> +			ERR_PTR(err));
> +		goto err_out_pci_release_device;
> +	}
> +
> +	pci_set_master(pdev);
> +
> +	pds_vdpa_debugfs_add_pcidev(vdpa_pdev);
> +
> +	dev_info(dev, "%s: PF %#04x VF %#04x (%d) vf_id %d domain %d vdpa_aux %p vdpa_pdev %p\n",
> +		 __func__, pci_dev_id(vdpa_pdev->pdev->physfn),
> +		 vdpa_pdev->pci_id, vdpa_pdev->pci_id, vdpa_pdev->vf_id,
> +		 pci_domain_nr(pdev->bus), vdpa_pdev->vdpa_aux, vdpa_pdev);
> +
> +	return 0;
> +
> +err_out_pci_release_device:
> +	pci_disable_device(pdev);


Do we still need to care about this consider we use 
devres/pcim_enable_device()?


> +err_out_free_mem:
> +	pci_disable_pcie_error_reporting(pdev);
> +	kfree(vdpa_pdev);
> +	return err;
> +}
> +
> +static void
> +pds_vdpa_pci_remove(struct pci_dev *pdev)
> +{
> +	struct pds_vdpa_pci_device *vdpa_pdev = pci_get_drvdata(pdev);
> +
> +	pds_vdpa_debugfs_del_pcidev(vdpa_pdev);
> +	pci_clear_master(pdev);
> +	pci_disable_pcie_error_reporting(pdev);
> +	pci_disable_device(pdev);
> +	kfree(vdpa_pdev);
> +
> +	dev_info(&pdev->dev, "Removed\n");
> +}
> +
> +static const struct pci_device_id
> +pds_vdpa_pci_table[] = {
> +	{ PCI_VDEVICE(PENSANDO, PCI_DEVICE_ID_PENSANDO_VDPA_VF) },
> +	{ 0, }
> +};
> +MODULE_DEVICE_TABLE(pci, pds_vdpa_pci_table);
> +
> +static struct pci_driver
> +pds_vdpa_pci_driver = {
> +	.name = PDS_VDPA_DRV_NAME,
> +	.id_table = pds_vdpa_pci_table,
> +	.probe = pds_vdpa_pci_probe,
> +	.remove = pds_vdpa_pci_remove
> +};
> +
> +static void __exit
> +pds_vdpa_pci_cleanup(void)
> +{
> +	pci_unregister_driver(&pds_vdpa_pci_driver);
> +
> +	pds_vdpa_debugfs_destroy();
> +}
> +module_exit(pds_vdpa_pci_cleanup);
> +
> +static int __init
> +pds_vdpa_pci_init(void)
> +{
> +	int err;
> +
> +	pds_vdpa_debugfs_create();
> +
> +	err = pci_register_driver(&pds_vdpa_pci_driver);
> +	if (err) {
> +		pr_err("%s: pci driver register failed: %pe\n", __func__, ERR_PTR(err));
> +		goto err_pci;
> +	}
> +
> +	return 0;
> +
> +err_pci:
> +	pds_vdpa_debugfs_destroy();
> +	return err;
> +}
> +module_init(pds_vdpa_pci_init);
> +
> +MODULE_DESCRIPTION(PDS_VDPA_DRV_DESCRIPTION);
> +MODULE_AUTHOR("Pensando Systems, Inc");
> +MODULE_LICENSE("GPL");
> diff --git a/drivers/vdpa/pds/pci_drv.h b/drivers/vdpa/pds/pci_drv.h
> new file mode 100644
> index 000000000000..747809e0df9e
> --- /dev/null
> +++ b/drivers/vdpa/pds/pci_drv.h
> @@ -0,0 +1,46 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/* Copyright(c) 2022 Pensando Systems, Inc */
> +
> +#ifndef _PCI_DRV_H
> +#define _PCI_DRV_H
> +
> +#include <linux/pci.h>
> +#include <linux/virtio_pci_modern.h>
> +
> +#define PDS_VDPA_DRV_NAME           "pds_vdpa"
> +#define PDS_VDPA_DRV_DESCRIPTION    "Pensando vDPA VF Device Driver"
> +
> +#define PDS_VDPA_BAR_BASE	0
> +#define PDS_VDPA_BAR_INTR	2
> +#define PDS_VDPA_BAR_DBELL	4
> +
> +struct pds_dev_bar {
> +	int           index;
> +	void __iomem  *vaddr;
> +	phys_addr_t   pa;
> +	unsigned long len;
> +};
> +
> +struct pds_vdpa_intr_info {
> +	int index;
> +	int irq;
> +	int qid;
> +	char name[32];
> +};
> +
> +struct pds_vdpa_pci_device {
> +	struct pci_dev *pdev;
> +	struct pds_vdpa_aux *vdpa_aux;
> +
> +	int vf_id;
> +	int pci_id;
> +
> +	int nintrs;
> +	struct pds_vdpa_intr_info *intrs;
> +
> +	struct dentry *dentry;
> +
> +	struct virtio_pci_modern_device vd_mdev;
> +};
> +
> +#endif /* _PCI_DRV_H */
> diff --git a/include/linux/pds/pds_core_if.h b/include/linux/pds/pds_core_if.h
> index 6333ec351e14..6e92697657e4 100644
> --- a/include/linux/pds/pds_core_if.h
> +++ b/include/linux/pds/pds_core_if.h
> @@ -8,6 +8,7 @@
>   
>   #define PCI_VENDOR_ID_PENSANDO			0x1dd8
>   #define PCI_DEVICE_ID_PENSANDO_CORE_PF		0x100c
> +#define PCI_DEVICE_ID_PENSANDO_VDPA_VF          0x100b
>   
>   #define PDS_CORE_BARS_MAX			4
>   #define PDS_CORE_PCI_BAR_DBELL			1
> diff --git a/include/linux/pds/pds_vdpa.h b/include/linux/pds/pds_vdpa.h
> new file mode 100644
> index 000000000000..7ecef890f175
> --- /dev/null
> +++ b/include/linux/pds/pds_vdpa.h
> @@ -0,0 +1,219 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/* Copyright(c) 2022 Pensando Systems, Inc */
> +
> +#ifndef _PDS_VDPA_IF_H_
> +#define _PDS_VDPA_IF_H_
> +
> +#include <linux/pds/pds_common.h>
> +
> +#define PDS_DEV_TYPE_VDPA_STR	"vDPA"
> +#define PDS_VDPA_DEV_NAME	PDS_CORE_DRV_NAME "." PDS_DEV_TYPE_VDPA_STR
> +
> +/*
> + * enum pds_vdpa_cmd_opcode - vDPA Device commands
> + */
> +enum pds_vdpa_cmd_opcode {
> +	PDS_VDPA_CMD_INIT		= 48,
> +	PDS_VDPA_CMD_IDENT		= 49,
> +	PDS_VDPA_CMD_RESET		= 51,
> +	PDS_VDPA_CMD_VQ_RESET		= 52,
> +	PDS_VDPA_CMD_VQ_INIT		= 53,
> +	PDS_VDPA_CMD_STATUS_UPDATE	= 54,
> +	PDS_VDPA_CMD_SET_FEATURES	= 55,
> +	PDS_VDPA_CMD_SET_ATTR		= 56,
> +};
> +
> +/**
> + * struct pds_vdpa_cmd - generic command
> + * @opcode:	Opcode
> + * @vdpa_index:	Index for vdpa subdevice
> + * @vf_id:	VF id
> + */
> +struct pds_vdpa_cmd {
> +	u8     opcode;
> +	u8     vdpa_index;
> +	__le16 vf_id;
> +};
> +
> +/**
> + * struct pds_vdpa_comp - generic command completion
> + * @status:	Status of the command (enum pds_core_status_code)
> + * @rsvd:	Word boundary padding
> + * @color:	Color bit
> + */
> +struct pds_vdpa_comp {
> +	u8 status;
> +	u8 rsvd[14];
> +	u8 color;
> +};
> +
> +/**
> + * struct pds_vdpa_init_cmd - INIT command
> + * @opcode:	Opcode PDS_VDPA_CMD_INIT
> + * @vdpa_index: Index for vdpa subdevice
> + * @vf_id:	VF id
> + * @len:	length of config info DMA space
> + * @config_pa:	address for DMA of virtio_net_config struct


Looks like the structure is not specific to net, if yes, we may tweak 
the above comment to say it's the address of the device configuration space.


> + */
> +struct pds_vdpa_init_cmd {
> +	u8     opcode;
> +	u8     vdpa_index;
> +	__le16 vf_id;
> +	__le32 len;
> +	__le64 config_pa;
> +};
> +
> +/**
> + * struct pds_vdpa_ident - vDPA identification data
> + * @hw_features:	vDPA features supported by device
> + * @max_vqs:		max queues available (2 queues for a single queuepair)
> + * @max_qlen:		log(2) of maximum number of descriptors
> + * @min_qlen:		log(2) of minimum number of descriptors


Note that is you have the plan to support packed virtqueue, the qlen is 
not necessarily the power of 2.


> + *
> + * This struct is used in a DMA block that is set up for the PDS_VDPA_CMD_IDENT
> + * transaction.  Set up the DMA block and send the address in the IDENT cmd
> + * data, the DSC will write the ident information, then we can remove the DMA
> + * block after reading the answer.  If the completion status is 0, then there
> + * is valid information, else there was an error and the data should be invalid.
> + */
> +struct pds_vdpa_ident {
> +	__le64 hw_features;
> +	__le16 max_vqs;
> +	__le16 max_qlen;
> +	__le16 min_qlen;
> +};
> +
> +/**
> + * struct pds_vdpa_ident_cmd - IDENT command
> + * @opcode:	Opcode PDS_VDPA_CMD_IDENT
> + * @rsvd:       Word boundary padding
> + * @vf_id:	VF id
> + * @len:	length of ident info DMA space
> + * @ident_pa:	address for DMA of ident info (struct pds_vdpa_ident)
> + *			only used for this transaction, then forgotten by DSC
> + */
> +struct pds_vdpa_ident_cmd {
> +	u8     opcode;
> +	u8     rsvd;
> +	__le16 vf_id;
> +	__le32 len;
> +	__le64 ident_pa;
> +};
> +
> +/**
> + * struct pds_vdpa_status_cmd - STATUS_UPDATE command
> + * @opcode:	Opcode PDS_VDPA_CMD_STATUS_UPDATE
> + * @vdpa_index: Index for vdpa subdevice
> + * @vf_id:	VF id
> + * @status:	new status bits
> + */
> +struct pds_vdpa_status_cmd {
> +	u8     opcode;
> +	u8     vdpa_index;
> +	__le16 vf_id;
> +	u8     status;
> +};
> +
> +/**
> + * enum pds_vdpa_attr - List of VDPA device attributes
> + * @PDS_VDPA_ATTR_MAC:          MAC address
> + * @PDS_VDPA_ATTR_MAX_VQ_PAIRS: Max virtqueue pairs
> + */
> +enum pds_vdpa_attr {
> +	PDS_VDPA_ATTR_MAC          = 1,
> +	PDS_VDPA_ATTR_MAX_VQ_PAIRS = 2,
> +};
> +
> +/**
> + * struct pds_vdpa_setattr_cmd - SET_ATTR command
> + * @opcode:		Opcode PDS_VDPA_CMD_SET_ATTR
> + * @vdpa_index:		Index for vdpa subdevice
> + * @vf_id:		VF id
> + * @attr:		attribute to be changed (enum pds_vdpa_attr)
> + * @pad:		Word boundary padding
> + * @mac:		new mac address to be assigned as vdpa device address
> + * @max_vq_pairs:	new limit of virtqueue pairs
> + */
> +struct pds_vdpa_setattr_cmd {
> +	u8     opcode;
> +	u8     vdpa_index;
> +	__le16 vf_id;
> +	u8     attr;
> +	u8     pad[3];
> +	union {
> +		u8 mac[6];
> +		__le16 max_vq_pairs;


So does this mean if we want to set both mac and max_vq_paris, we need 
two commands? The seems to be less efficient, since the mgmt layer could 
provision more attributes here. Can we pack all attributes into a single 
command?


> +	} __packed;
> +};
> +
> +/**
> + * struct pds_vdpa_vq_init_cmd - queue init command
> + * @opcode: Opcode PDS_VDPA_CMD_VQ_INIT
> + * @vdpa_index:	Index for vdpa subdevice
> + * @vf_id:	VF id
> + * @qid:	Queue id (bit0 clear = rx, bit0 set = tx, qid=N is ctrlq)


I wonder any reason we need to design it like this, it would be better 
to make it general to be used by other type of virtio devices.


> + * @len:	log(2) of max descriptor count
> + * @desc_addr:	DMA address of descriptor area
> + * @avail_addr:	DMA address of available descriptors (aka driver area)
> + * @used_addr:	DMA address of used descriptors (aka device area)
> + * @intr_index:	interrupt index


Is this something like MSI-X vector?


> + */
> +struct pds_vdpa_vq_init_cmd {
> +	u8     opcode;
> +	u8     vdpa_index;
> +	__le16 vf_id;
> +	__le16 qid;
> +	__le16 len;
> +	__le64 desc_addr;
> +	__le64 avail_addr;
> +	__le64 used_addr;
> +	__le16 intr_index;
> +};
> +
> +/**
> + * struct pds_vdpa_vq_init_comp - queue init completion
> + * @status:	Status of the command (enum pds_core_status_code)
> + * @hw_qtype:	HW queue type, used in doorbell selection
> + * @hw_qindex:	HW queue index, used in doorbell selection
> + * @rsvd:	Word boundary padding
> + * @color:	Color bit


More comment is needed to know the how to use this color bit.


> + */
> +struct pds_vdpa_vq_init_comp {
> +	u8     status;
> +	u8     hw_qtype;
> +	__le16 hw_qindex;
> +	u8     rsvd[11];
> +	u8     color;
> +};
> +
> +/**
> + * struct pds_vdpa_vq_reset_cmd - queue reset command
> + * @opcode:	Opcode PDS_VDPA_CMD_VQ_RESET


Is there a chance that we could have more type of opcode here?

Thanks


> + * @vdpa_index:	Index for vdpa subdevice
> + * @vf_id:	VF id
> + * @qid:	Queue id
> + */
> +struct pds_vdpa_vq_reset_cmd {
> +	u8     opcode;
> +	u8     vdpa_index;
> +	__le16 vf_id;
> +	__le16 qid;
> +};
> +
> +/**
> + * struct pds_vdpa_set_features_cmd - set hw features
> + * @opcode: Opcode PDS_VDPA_CMD_SET_FEATURES
> + * @vdpa_index:	Index for vdpa subdevice
> + * @vf_id:	VF id
> + * @rsvd:       Word boundary padding
> + * @features:	Feature bit mask
> + */
> +struct pds_vdpa_set_features_cmd {
> +	u8     opcode;
> +	u8     vdpa_index;
> +	__le16 vf_id;
> +	__le32 rsvd;
> +	__le64 features;
> +};
> +
> +#endif /* _PDS_VDPA_IF_H_ */

