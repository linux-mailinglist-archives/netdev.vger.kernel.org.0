Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1D926DDAF9
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 14:37:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229969AbjDKMhC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 08:37:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjDKMg7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 08:36:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD3184495
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 05:36:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 67C4761F16
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 12:36:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FB47C433EF;
        Tue, 11 Apr 2023 12:36:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681216617;
        bh=kTOshIxUAyadmSYZBE7svKb4fyBemcujDHrtTMdUwRI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KuCgkcysanRYLfeqTt3q2Q9dPAHwb1tcpCxuvyjd0gksnY5dTgQxY9IOzEs33/o3B
         WOgaZF+U+6pYBNj3WUsVgdfSXrbclxvy3cAcFBBP6IuoAMmS2EA5qeT9V4rLqtoDGA
         Bd6H8iXQT2xIUPql9cGvYZEIQ6f8s2UfDbzvqziyJt7XlOPhz0RU71TqkxaXp/zu7h
         9BOYVKVfiL6bKH6p6yT7atmb3YKiyP8QylP1IOwdL0HBhxVKNmmMzLY85fe+K9jg+s
         27q6mMEQ+wS+jAACu4UKX4LItpx0o/5vOkqwaNolIgrr8pZep7D5hV+Ejw4SNFYItX
         AQ5LqNksuvcVQ==
Date:   Tue, 11 Apr 2023 15:36:53 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Pavan Kumar Linga <pavan.kumar.linga@intel.com>
Cc:     intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        emil.s.tantilov@intel.com, joshua.a.hay@intel.com,
        sridhar.samudrala@intel.com, jesse.brandeburg@intel.com,
        anthony.l.nguyen@intel.com, willemb@google.com, decot@google.com,
        pabeni@redhat.com, kuba@kernel.org, edumazet@google.com,
        davem@davemloft.net, Phani Burra <phani.r.burra@intel.com>,
        Alan Brady <alan.brady@intel.com>,
        Madhu Chittim <madhu.chittim@intel.com>,
        Shailendra Bhatnagar <shailendra.bhatnagar@intel.com>
Subject: Re: [PATCH net-next v2 02/15] idpf: add module register and probe
 functionality
Message-ID: <20230411123653.GW182481@unreal>
References: <20230411011354.2619359-1-pavan.kumar.linga@intel.com>
 <20230411011354.2619359-3-pavan.kumar.linga@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230411011354.2619359-3-pavan.kumar.linga@intel.com>
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 10, 2023 at 06:13:41PM -0700, Pavan Kumar Linga wrote:
> From: Phani Burra <phani.r.burra@intel.com>
> 
> Add the required support to register IDPF PCI driver, as well as
> probe and remove call backs. Enable the PCI device and request
> the kernel to reserve the memory resources that will be used by the
> driver. Finally map the BAR0 address space.
> 
> PCI IDs table is intentionally left blank to prevent the kernel from
> probing the device with the incomplete driver. It will be added
> in the last patch of the series.
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
> ---
>  drivers/net/ethernet/intel/Kconfig            | 11 +++
>  drivers/net/ethernet/intel/Makefile           |  1 +
>  drivers/net/ethernet/intel/idpf/Makefile      | 10 ++
>  drivers/net/ethernet/intel/idpf/idpf.h        | 27 ++++++
>  .../net/ethernet/intel/idpf/idpf_controlq.h   | 14 +++
>  drivers/net/ethernet/intel/idpf/idpf_lib.c    | 96 +++++++++++++++++++
>  drivers/net/ethernet/intel/idpf/idpf_main.c   | 70 ++++++++++++++
>  7 files changed, 229 insertions(+)
>  create mode 100644 drivers/net/ethernet/intel/idpf/Makefile
>  create mode 100644 drivers/net/ethernet/intel/idpf/idpf.h
>  create mode 100644 drivers/net/ethernet/intel/idpf/idpf_controlq.h
>  create mode 100644 drivers/net/ethernet/intel/idpf/idpf_lib.c
>  create mode 100644 drivers/net/ethernet/intel/idpf/idpf_main.c

<...>

> +/**
> + * idpf_remove_common - Device removal routine
> + * @pdev: PCI device information struct
> + */
> +void idpf_remove_common(struct pci_dev *pdev)
> +{
> +	struct idpf_adapter *adapter = pci_get_drvdata(pdev);
> +
> +	if (!adapter)

How is it possible to have adapter be NULL here?

> +		return;
> +
> +	pci_disable_pcie_error_reporting(pdev);
> +}
> diff --git a/drivers/net/ethernet/intel/idpf/idpf_main.c b/drivers/net/ethernet/intel/idpf/idpf_main.c
> new file mode 100644
> index 000000000000..617df9b924fa
> --- /dev/null
> +++ b/drivers/net/ethernet/intel/idpf/idpf_main.c
> @@ -0,0 +1,70 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/* Copyright (C) 2023 Intel Corporation */
> +
> +#include "idpf.h"
> +
> +#define DRV_SUMMARY	"Infrastructure Data Path Function Linux Driver"
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
> +	if (!adapter)

Ditto

> +		return;
> +
> +	idpf_remove_common(pdev);
> +	pci_set_drvdata(pdev, NULL);
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
> + * idpf_probe - Device initialization routine
> + * @pdev: PCI device information struct
> + * @ent: entry in idpf_pci_tbl
> + *
> + * Returns 0 on success, negative on failure
> + */
> +static int idpf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
> +{
> +	struct idpf_adapter *adapter;
> +
> +	adapter = devm_kzalloc(&pdev->dev, sizeof(*adapter), GFP_KERNEL);

Why devm_kzalloc() and not kzalloc?

> +	if (!adapter)
> +		return -ENOMEM;
> +
> +	return idpf_probe_common(pdev, adapter);

There is no need in idpf_probe_common/idpf_remove_common functions and
they better be embedded here. They called only once and just obfuscate
the code.

> +}
> +
> +/* idpf_pci_tbl - PCI Dev idpf ID Table
> + */
> +static const struct pci_device_id idpf_pci_tbl[] = {
> +	{ /* Sentinel */ }

What does it mean empty pci_device_id table?

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
> 2.37.3
> 
