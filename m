Return-Path: <netdev+bounces-6678-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 77CFD717689
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 08:06:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 150131C20D36
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 06:05:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF76263BA;
	Wed, 31 May 2023 06:05:59 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE26363B5
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 06:05:59 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B71AE122
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 23:05:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685513156;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ou+5sXSLOwAQJI6Awwyqpw5gZJXY5Y2V0YJU3uR/AHg=;
	b=irBQP0+A5Hq1aTzH6DU9R2XqTPIJdNbushUvoCjYi3gVwNbhVJ3FULbd82u3RiLRiAQDkP
	r7fMNjfdFyb+xLB7nzKgoPIDeVX9o+mWxDLUkFmjn+8NOiUBxiU9TEZ0uuoKlB0zElh7fJ
	nO5h+SVyplyAEkrjPkhNOt2y0S7elFA=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-479-qcMOabsNP8K1NOQvGepo5g-1; Wed, 31 May 2023 02:05:55 -0400
X-MC-Unique: qcMOabsNP8K1NOQvGepo5g-1
Received: by mail-lj1-f197.google.com with SMTP id 38308e7fff4ca-2af4f9678f3so28898061fa.0
        for <netdev@vger.kernel.org>; Tue, 30 May 2023 23:05:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685513154; x=1688105154;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ou+5sXSLOwAQJI6Awwyqpw5gZJXY5Y2V0YJU3uR/AHg=;
        b=Kju2Ml/29P4ANztXVHDhPaCJ3K3ASv4I+RD/HkqgdhzIGgPBkpGLsZZRGAiPeXD5DJ
         GocyUFA9L+HLERRUnxw5fHi+JiLwY6MBjQ4aULoCh39UW313QytqI57arEAY+82QJx8x
         5GN5tHGKM/4WaJrC2z7mv+OsBiYulylImGHAhxsdVZGhjEwWDvH8vrK2POjCQu0ddYjG
         +kvYAnkTRqivvwrI9pQ3RS5BlB4iWl2baKEsycxciYMbecEGyocSElz8uBf/yFKCgLo0
         T08977ReVygM+RVTZOFEpVGUUO1d/wGc60UeT4d9o1Bu13zxk/Qzmk+APWHiTEzuyoDm
         5Ftw==
X-Gm-Message-State: AC+VfDykQAhwdUUQvleGoXBdDR+5OwZhCGhUHeRLuyy8qCMIcroZu20Y
	lQB9aAhlzQ+AxSOyS7+jQf1Qd7+dDtznpsdd5w1uGwCXTwBAveSL4K+fpp1eiWGnTqbfDdHKGKu
	nCZEFCPhy9GLSwVZn
X-Received: by 2002:a2e:2c06:0:b0:2aa:3cee:c174 with SMTP id s6-20020a2e2c06000000b002aa3ceec174mr2205503ljs.13.1685513154049;
        Tue, 30 May 2023 23:05:54 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7QK8TfbvjiBnDbKSYoPbLz/3rbttQ5aFeOQdbxTgJBzjoA6Cb/qqVYl5vEMyjO7/7x0qs5sg==
X-Received: by 2002:a2e:2c06:0:b0:2aa:3cee:c174 with SMTP id s6-20020a2e2c06000000b002aa3ceec174mr2205491ljs.13.1685513153714;
        Tue, 30 May 2023 23:05:53 -0700 (PDT)
Received: from redhat.com ([176.12.143.106])
        by smtp.gmail.com with ESMTPSA id 11-20020a05651c008b00b002a8c271de33sm3038274ljq.67.2023.05.30.23.05.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 May 2023 23:05:53 -0700 (PDT)
Date: Wed, 31 May 2023 02:05:42 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Tony Nguyen <anthony.l.nguyen@intel.com>
Cc: davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
	edumazet@google.com, netdev@vger.kernel.org,
	Phani Burra <phani.r.burra@intel.com>, pavan.kumar.linga@intel.com,
	emil.s.tantilov@intel.com, jesse.brandeburg@intel.com,
	sridhar.samudrala@intel.com, shiraz.saleem@intel.com,
	sindhu.devale@intel.com, willemb@google.com, decot@google.com,
	andrew@lunn.ch, leon@kernel.org, simon.horman@corigine.com,
	shannon.nelson@amd.com, stephen@networkplumber.org,
	Alan Brady <alan.brady@intel.com>,
	Madhu Chittim <madhu.chittim@intel.com>,
	Shailendra Bhatnagar <shailendra.bhatnagar@intel.com>,
	Krishneil Singh <krishneil.k.singh@intel.com>
Subject: Re: [PATCH net-next 02/15] idpf: add module register and probe
 functionality
Message-ID: <20230531015711-mutt-send-email-mst@kernel.org>
References: <20230530234501.2680230-1-anthony.l.nguyen@intel.com>
 <20230530234501.2680230-3-anthony.l.nguyen@intel.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230530234501.2680230-3-anthony.l.nguyen@intel.com>
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 30, 2023 at 04:44:48PM -0700, Tony Nguyen wrote:
> From: Phani Burra <phani.r.burra@intel.com>
> 
> Add the required support to register IDPF PCI driver, as well as
> probe and remove call backs. Enable the PCI device and request
> the kernel to reserve the memory resources that will be used by the
> driver. Finally map the BAR0 address space.
> 
> Signed-off-by: Phani Burra <phani.r.burra@intel.com>
> Co-developed-by: Alan Brady <alan.brady@intel.com>
> Signed-off-by: Alan Brady <alan.brady@intel.com>
> Co-developed-by: Madhu Chittim <madhu.chittim@intel.com>
> Signed-off-by: Madhu Chittim <madhu.chittim@intel.com>
> Co-developed-by: Shailendra Bhatnagar <shailendra.bhatnagar@intel.com>
> Signed-off-by: Shailendra Bhatnagar <shailendra.bhatnagar@intel.com>
> Co-developed-by: Pavan Kumar Linga <pavan.kumar.linga@intel.com>
> Signed-off-by: Pavan Kumar Linga <pavan.kumar.linga@intel.com>
> Reviewed-by: Sridhar Samudrala <sridhar.samudrala@intel.com>
> Reviewed-by: Willem de Bruijn <willemb@google.com>
> Tested-by: Krishneil Singh <krishneil.k.singh@intel.com>
> Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
> ---
>  drivers/net/ethernet/intel/idpf/Makefile      |   9 ++
>  drivers/net/ethernet/intel/idpf/idpf.h        |  22 +++
>  .../net/ethernet/intel/idpf/idpf_controlq.h   |  14 ++
>  drivers/net/ethernet/intel/idpf/idpf_devids.h |  10 ++
>  drivers/net/ethernet/intel/idpf/idpf_main.c   | 136 ++++++++++++++++++
>  5 files changed, 191 insertions(+)
>  create mode 100644 drivers/net/ethernet/intel/idpf/Makefile
>  create mode 100644 drivers/net/ethernet/intel/idpf/idpf.h
>  create mode 100644 drivers/net/ethernet/intel/idpf/idpf_controlq.h
>  create mode 100644 drivers/net/ethernet/intel/idpf/idpf_devids.h
>  create mode 100644 drivers/net/ethernet/intel/idpf/idpf_main.c
> 
> diff --git a/drivers/net/ethernet/intel/idpf/Makefile b/drivers/net/ethernet/intel/idpf/Makefile
> new file mode 100644
> index 000000000000..77f5500d7707
> --- /dev/null
> +++ b/drivers/net/ethernet/intel/idpf/Makefile
> @@ -0,0 +1,9 @@
> +# SPDX-License-Identifier: GPL-2.0-only
> +# Copyright (C) 2023 Intel Corporation
> +
> +# Makefile for Infrastructure Data Path Function Linux Driver
> +
> +obj-$(CONFIG_IDPF) += idpf.o
> +
> +idpf-y := \
> +	idpf_main.o
> diff --git a/drivers/net/ethernet/intel/idpf/idpf.h b/drivers/net/ethernet/intel/idpf/idpf.h
> new file mode 100644
> index 000000000000..08be5621140f
> --- /dev/null
> +++ b/drivers/net/ethernet/intel/idpf/idpf.h
> @@ -0,0 +1,22 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/* Copyright (C) 2023 Intel Corporation */
> +
> +#ifndef _IDPF_H_
> +#define _IDPF_H_
> +
> +#include <linux/aer.h>
> +#include <linux/etherdevice.h>
> +#include <linux/pci.h>
> +
> +#include "idpf_controlq.h"
> +
> +/* available message levels */
> +#define IDPF_AVAIL_NETIF_M (NETIF_MSG_DRV | NETIF_MSG_PROBE | NETIF_MSG_LINK)
> +
> +struct idpf_adapter {
> +	struct pci_dev *pdev;
> +	u32 msg_enable;
> +	struct idpf_hw hw;
> +};
> +
> +#endif /* !_IDPF_H_ */
> diff --git a/drivers/net/ethernet/intel/idpf/idpf_controlq.h b/drivers/net/ethernet/intel/idpf/idpf_controlq.h
> new file mode 100644
> index 000000000000..11388834cf64
> --- /dev/null
> +++ b/drivers/net/ethernet/intel/idpf/idpf_controlq.h
> @@ -0,0 +1,14 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/* Copyright (C) 2023 Intel Corporation */
> +
> +#ifndef _IDPF_CONTROLQ_H_
> +#define _IDPF_CONTROLQ_H_
> +
> +struct idpf_hw {
> +	void __iomem *hw_addr;
> +	resource_size_t hw_addr_len;
> +
> +	struct idpf_adapter *back;
> +};
> +
> +#endif /* _IDPF_CONTROLQ_H_ */
> diff --git a/drivers/net/ethernet/intel/idpf/idpf_devids.h b/drivers/net/ethernet/intel/idpf/idpf_devids.h
> new file mode 100644
> index 000000000000..5154a52ae61c
> --- /dev/null
> +++ b/drivers/net/ethernet/intel/idpf/idpf_devids.h
> @@ -0,0 +1,10 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/* Copyright (C) 2023 Intel Corporation */
> +
> +#ifndef _IDPF_DEVIDS_H_
> +#define _IDPF_DEVIDS_H_
> +
> +#define IDPF_DEV_ID_PF			0x1452
> +#define IDPF_DEV_ID_VF			0x145C
> +
> +#endif /* _IDPF_DEVIDS_H_ */
> diff --git a/drivers/net/ethernet/intel/idpf/idpf_main.c b/drivers/net/ethernet/intel/idpf/idpf_main.c
> new file mode 100644
> index 000000000000..e290f560ce14
> --- /dev/null
> +++ b/drivers/net/ethernet/intel/idpf/idpf_main.c
> @@ -0,0 +1,136 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/* Copyright (C) 2023 Intel Corporation */
> +
> +#include "idpf.h"
> +#include "idpf_devids.h"
> +
> +#define DRV_SUMMARY	"Infrastructure Data Path Function Linux Driver"

Do you want to stick Intel(R) here as well?
And did you say you wanted to add a version?

The point being making it possible to distinguish
between this one and the one we'll hopefully have down
the road binding to the IDPF class/prog ifc.

> +
> +MODULE_DESCRIPTION(DRV_SUMMARY);
> +MODULE_LICENSE("GPL");
> +
> +/**
> + * idpf_remove - Device removal routine
> + * @pdev: PCI device information struct
> + */
> +static void idpf_remove(struct pci_dev *pdev)
> +{
> +	struct idpf_adapter *adapter = pci_get_drvdata(pdev);
> +
> +	pci_disable_pcie_error_reporting(pdev);
> +	pci_set_drvdata(pdev, NULL);
> +	kfree(adapter);
> +}
> +
> +/**
> + * idpf_shutdown - PCI callback for shutting down device
> + * @pdev: PCI device information struct
> + */
> +static void idpf_shutdown(struct pci_dev *pdev)
> +{
> +	idpf_remove(pdev);
> +
> +	if (system_state == SYSTEM_POWER_OFF)
> +		pci_set_power_state(pdev, PCI_D3hot);
> +}
> +
> +/**
> + * idpf_cfg_hw - Initialize HW struct
> + * @adapter: adapter to setup hw struct for
> + *
> + * Returns 0 on success, negative on failure
> + */
> +static int idpf_cfg_hw(struct idpf_adapter *adapter)
> +{
> +	struct pci_dev *pdev = adapter->pdev;
> +	struct idpf_hw *hw = &adapter->hw;
> +
> +	hw->hw_addr = pcim_iomap_table(pdev)[0];
> +	if (!hw->hw_addr) {
> +		pci_err(pdev, "failed to allocate PCI iomap table\n");
> +
> +		return -ENOMEM;
> +	}
> +
> +	hw->back = adapter;
> +
> +	return 0;
> +}
> +
> +/**
> + * idpf_probe - Device initialization routine
> + * @pdev: PCI device information struct
> + * @ent: entry in idpf_pci_tbl
> + *
> + * Returns 0 on success, negative on failure
> + */
> +static int idpf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
> +{
> +	struct device *dev = &pdev->dev;
> +	struct idpf_adapter *adapter;
> +	int err;
> +
> +	adapter = kzalloc(sizeof(*adapter), GFP_KERNEL);
> +	if (!adapter)
> +		return -ENOMEM;
> +	adapter->pdev = pdev;
> +
> +	err = pcim_enable_device(pdev);
> +	if (err)
> +		goto err_free;
> +
> +	err = pcim_iomap_regions(pdev, BIT(0), pci_name(pdev));
> +	if (err) {
> +		pci_err(pdev, "pcim_iomap_regions failed %pe\n", ERR_PTR(err));
> +
> +		goto err_free;
> +	}
> +
> +	/* set up for high or low dma */
> +	err = dma_set_mask_and_coherent(dev, DMA_BIT_MASK(64));
> +	if (err) {
> +		pci_err(pdev, "DMA configuration failed: %pe\n", ERR_PTR(err));
> +
> +		goto err_free;
> +	}
> +
> +	pci_enable_pcie_error_reporting(pdev);
> +	pci_set_master(pdev);
> +	pci_set_drvdata(pdev, adapter);
> +
> +	/* setup msglvl */
> +	adapter->msg_enable = netif_msg_init(-1, IDPF_AVAIL_NETIF_M);
> +
> +	err = idpf_cfg_hw(adapter);
> +	if (err) {
> +		dev_err(dev, "Failed to configure HW structure for adapter: %d\n",
> +			err);
> +		goto err_cfg_hw;
> +	}
> +
> +	return 0;
> +
> +err_cfg_hw:
> +	pci_disable_pcie_error_reporting(pdev);
> +err_free:
> +	kfree(adapter);
> +	return err;
> +}
> +
> +/* idpf_pci_tbl - PCI Dev idpf ID Table
> + */
> +static const struct pci_device_id idpf_pci_tbl[] = {
> +	{ PCI_VDEVICE(INTEL, IDPF_DEV_ID_PF)},
> +	{ PCI_VDEVICE(INTEL, IDPF_DEV_ID_VF)},
> +	{ /* Sentinel */ }
> +};
> +MODULE_DEVICE_TABLE(pci, idpf_pci_tbl);
> +
> +static struct pci_driver idpf_driver = {
> +	.name			= KBUILD_MODNAME,
> +	.id_table		= idpf_pci_tbl,
> +	.probe			= idpf_probe,
> +	.remove			= idpf_remove,
> +	.shutdown		= idpf_shutdown,
> +};
> +module_pci_driver(idpf_driver);
> -- 
> 2.38.1


