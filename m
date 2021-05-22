Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8A4338D705
	for <lists+netdev@lfdr.de>; Sat, 22 May 2021 20:44:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231361AbhEVSpq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 May 2021 14:45:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231252AbhEVSpp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 May 2021 14:45:45 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEE9BC061574;
        Sat, 22 May 2021 11:44:19 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id 10so17465274pfl.1;
        Sat, 22 May 2021 11:44:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=Uxzv+tkPUSkhvvyy+QrV1P1guBh5uBCx9x/nilcRSmI=;
        b=S83fk1r9ACA/cULbUNYylNjUHIJlnytEuABy0ehV89YwsWwFauTgkyl4MK66TCkY90
         E72GcQ8DrzIgwXJrIgQvnZSHBU3b3gQAQ8/vHnQjFYs0P+d/PDlxaAzRpfaWDFA4MMUl
         PqsVcCx2lTpaf/8jT3SE7mc0PjuvOqDwU1sMtEHxtu93DU362mJTkD+mEAVltmYhZHuJ
         Ng5EbgCMEK32/INI4EMGXeoQ/TxSPz2KYUDVS/Q92FQk0ULm9k7KpVnZuYifEfWjmQe9
         hIbIzOhNE87Wl7VcVzFWE9Ywy+V8PupPn7lMn8q5E+ko4c53IAj98k+U5jXL/7RXv5Eq
         lfHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=Uxzv+tkPUSkhvvyy+QrV1P1guBh5uBCx9x/nilcRSmI=;
        b=rAzFo3VvxQMMK698DvTqFbqdWBk5T9eNoqnV6hsNPPut2VZWiZ4qWNC1xeJKqau1/n
         7OJDk+PXB0xt5gkWbWySm90Iy3qv+H8X4+eNSekb5dv9iId1g1Aezu6RM8/Eb2n9Ljdz
         r4IP0JxerNpFbLozsn/Lt/TxWYbg00HXAs4l4Qh13KL51Lzluy7eQ2Lgk6MbLBA/orGd
         3lOIVZixYSQF4unS4zvejVzTyoMaxDYWQg2YT2pFfU28Q2fJXGfJO0qVHO8QMidoQiZs
         SVubN4xA1VbH1tQiIHpcxC0GOYJfwFU3kRbJFraqVRqNuVLXaulQqzXDU8Jw4Nbhw2i4
         4wnQ==
X-Gm-Message-State: AOAM531FthDm7z7dY5oOO4Yk+/Su/Tewv7iDta5j8Un2qFo9Dx/lv0k5
        CJR0xGNOcy0wKJDeiQy5wbE=
X-Google-Smtp-Source: ABdhPJwdkBJLZBJkzvDB3jnaf9ZiOixZ5rNYFTkoUWb2WQ86RnN+LIc36O+ygIg7woSSC/nljsXyAw==
X-Received: by 2002:a62:7e86:0:b029:28e:5a88:5cfa with SMTP id z128-20020a627e860000b029028e5a885cfamr16265763pfc.70.1621709059279;
        Sat, 22 May 2021 11:44:19 -0700 (PDT)
Received: from localhost ([139.5.31.183])
        by smtp.gmail.com with ESMTPSA id j9sm3245718pfc.220.2021.05.22.11.44.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 22 May 2021 11:44:18 -0700 (PDT)
Date:   Sun, 23 May 2021 00:14:16 +0530
From:   Amey Narkhede <ameynarkhede03@gmail.com>
To:     Jonas =?utf-8?Q?Dre=C3=9Fler?= <verdre@v0yd.nl>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Tsuchiya Yuto <kitakar@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Maximilian Luz <luzmaximilian@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>,
        Krzysztof =?utf-8?Q?Wilczy=C5=84ski?= <kw@linux.com>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi017@gmail.com>,
        Sharvari Harisangam <sharvari.harisangam@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [RFC PATCH 2/3] mwifiex: pcie: add reset_d3cold quirk for
 Surface gen4+ devices
Message-ID: <20210522184416.mscbmay27jciy2hv@archlinux>
References: <20210522131827.67551-1-verdre@v0yd.nl>
 <20210522131827.67551-3-verdre@v0yd.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210522131827.67551-3-verdre@v0yd.nl>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 21/05/22 03:18PM, Jonas Dreﬂler wrote:
> From: Tsuchiya Yuto <kitakar@gmail.com>
>
> To reset mwifiex on Surface gen4+ (Pro 4 or later gen) devices, it
> seems that putting the wifi device into D3cold is required according
> to errata.inf file on Windows installation (Windows/INF/errata.inf).
>
> This patch adds a function that performs power-cycle (put into D3cold
> then D0) and call the function at the end of reset_prepare().
>
> Note: Need to also reset the parent device (bridge) of wifi on SB1;
> it might be because the bridge of wifi always reports it's in D3hot.
> When I tried to reset only the wifi device (not touching parent), it gave
> the following error and the reset failed:
>
>     acpi device:4b: Cannot transition to power state D0 for parent in D3hot
>     mwifiex_pcie 0000:03:00.0: can't change power state from D3cold to D0 (config space inaccessible)
>
May I know how did you reset only the wifi device when you encountered
this error?

> Signed-off-by: Tsuchiya Yuto <kitakar@gmail.com>
> Signed-off-by: Jonas Dreﬂler <verdre@v0yd.nl>
> ---
>  drivers/net/wireless/marvell/mwifiex/pcie.c   |   7 +
>  .../wireless/marvell/mwifiex/pcie_quirks.c    | 123 ++++++++++++++++++
>  .../wireless/marvell/mwifiex/pcie_quirks.h    |   3 +
>  3 files changed, 133 insertions(+)
>
> diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c b/drivers/net/wireless/marvell/mwifiex/pcie.c
> index 02fdce926de5..d9acfea395ad 100644
> --- a/drivers/net/wireless/marvell/mwifiex/pcie.c
> +++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
> @@ -528,6 +528,13 @@ static void mwifiex_pcie_reset_prepare(struct pci_dev *pdev)
>  	mwifiex_shutdown_sw(adapter);
>  	clear_bit(MWIFIEX_IFACE_WORK_DEVICE_DUMP, &card->work_flags);
>  	clear_bit(MWIFIEX_IFACE_WORK_CARD_RESET, &card->work_flags);
> +
> +	/* For Surface gen4+ devices, we need to put wifi into D3cold right
> +	 * before performing FLR
> +	 */
> +	if (card->quirks & QUIRK_FW_RST_D3COLD)
> +		mwifiex_pcie_reset_d3cold_quirk(pdev);
> +
>  	mwifiex_dbg(adapter, INFO, "%s, successful\n", __func__);
>
>  	card->pci_reset_ongoing = true;
> diff --git a/drivers/net/wireless/marvell/mwifiex/pcie_quirks.c b/drivers/net/wireless/marvell/mwifiex/pcie_quirks.c
> index 4064f99b36ba..b5f214fc1212 100644
> --- a/drivers/net/wireless/marvell/mwifiex/pcie_quirks.c
> +++ b/drivers/net/wireless/marvell/mwifiex/pcie_quirks.c
> @@ -15,6 +15,72 @@
>
>  /* quirk table based on DMI matching */
>  static const struct dmi_system_id mwifiex_quirk_table[] = {
> +	{
> +		.ident = "Surface Pro 4",
> +		.matches = {
> +			DMI_EXACT_MATCH(DMI_SYS_VENDOR, "Microsoft Corporation"),
> +			DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "Surface Pro 4"),
> +		},
> +		.driver_data = (void *)QUIRK_FW_RST_D3COLD,
> +	},
> +	{
> +		.ident = "Surface Pro 5",
> +		.matches = {
> +			/* match for SKU here due to generic product name "Surface Pro" */
> +			DMI_EXACT_MATCH(DMI_SYS_VENDOR, "Microsoft Corporation"),
> +			DMI_EXACT_MATCH(DMI_PRODUCT_SKU, "Surface_Pro_1796"),
> +		},
> +		.driver_data = (void *)QUIRK_FW_RST_D3COLD,
> +	},
> +	{
> +		.ident = "Surface Pro 5 (LTE)",
> +		.matches = {
> +			/* match for SKU here due to generic product name "Surface Pro" */
> +			DMI_EXACT_MATCH(DMI_SYS_VENDOR, "Microsoft Corporation"),
> +			DMI_EXACT_MATCH(DMI_PRODUCT_SKU, "Surface_Pro_1807"),
> +		},
> +		.driver_data = (void *)QUIRK_FW_RST_D3COLD,
> +	},
> +	{
> +		.ident = "Surface Pro 6",
> +		.matches = {
> +			DMI_EXACT_MATCH(DMI_SYS_VENDOR, "Microsoft Corporation"),
> +			DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "Surface Pro 6"),
> +		},
> +		.driver_data = (void *)QUIRK_FW_RST_D3COLD,
> +	},
> +	{
> +		.ident = "Surface Book 1",
> +		.matches = {
> +			DMI_EXACT_MATCH(DMI_SYS_VENDOR, "Microsoft Corporation"),
> +			DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "Surface Book"),
> +		},
> +		.driver_data = (void *)QUIRK_FW_RST_D3COLD,
> +	},
> +	{
> +		.ident = "Surface Book 2",
> +		.matches = {
> +			DMI_EXACT_MATCH(DMI_SYS_VENDOR, "Microsoft Corporation"),
> +			DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "Surface Book 2"),
> +		},
> +		.driver_data = (void *)QUIRK_FW_RST_D3COLD,
> +	},
> +	{
> +		.ident = "Surface Laptop 1",
> +		.matches = {
> +			DMI_EXACT_MATCH(DMI_SYS_VENDOR, "Microsoft Corporation"),
> +			DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "Surface Laptop"),
> +		},
> +		.driver_data = (void *)QUIRK_FW_RST_D3COLD,
> +	},
> +	{
> +		.ident = "Surface Laptop 2",
> +		.matches = {
> +			DMI_EXACT_MATCH(DMI_SYS_VENDOR, "Microsoft Corporation"),
> +			DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "Surface Laptop 2"),
> +		},
> +		.driver_data = (void *)QUIRK_FW_RST_D3COLD,
> +	},
>  	{}
>  };
>
> @@ -29,4 +95,61 @@ void mwifiex_initialize_quirks(struct pcie_service_card *card)
>
>  	if (!card->quirks)
>  		dev_info(&pdev->dev, "no quirks enabled\n");
> +	if (card->quirks & QUIRK_FW_RST_D3COLD)
> +		dev_info(&pdev->dev, "quirk reset_d3cold enabled\n");
> +}
> +
> +static void mwifiex_pcie_set_power_d3cold(struct pci_dev *pdev)
> +{
> +	dev_info(&pdev->dev, "putting into D3cold...\n");
> +
> +	pci_save_state(pdev);
> +	if (pci_is_enabled(pdev))
> +		pci_disable_device(pdev);
> +	pci_set_power_state(pdev, PCI_D3cold);
> +}
pci_set_power_state with PCI_D3cold state calls
pci_bus_set_current_state(dev->subordinate, PCI_D3cold).
Maybe this was the reason for the earlier problem you had?
Not 100% sure about this though CCing: Alex

> +
> +static int mwifiex_pcie_set_power_d0(struct pci_dev *pdev)
> +{
> +	int ret;
> +
> +	dev_info(&pdev->dev, "putting into D0...\n");
> +
> +	pci_set_power_state(pdev, PCI_D0);
> +	ret = pci_enable_device(pdev);
> +	if (ret) {
> +		dev_err(&pdev->dev, "pci_enable_device failed\n");
> +		return ret;
> +	}
> +	pci_restore_state(pdev);
On the side note just save and restore is enough in this case?
What would be the device <-> driver state after the reset as you
are calling this on parent_pdev below so that affects other
devices on bus?

Thanks,
Amey

> +
> +	return 0;
> +}
> +
> +int mwifiex_pcie_reset_d3cold_quirk(struct pci_dev *pdev)
> +{
> +	struct pci_dev *parent_pdev = pci_upstream_bridge(pdev);
> +	int ret;
> +
> +	/* Power-cycle (put into D3cold then D0) */
> +	dev_info(&pdev->dev, "Using reset_d3cold quirk to perform FW reset\n");
> +
> +	/* We need to perform power-cycle also for bridge of wifi because
> +	 * on some devices (e.g. Surface Book 1), the OS for some reasons
> +	 * can't know the real power state of the bridge.
> +	 * When tried to power-cycle only wifi, the reset failed with the
> +	 * following dmesg log:
> +	 * "Cannot transition to power state D0 for parent in D3hot".
> +	 */
> +	mwifiex_pcie_set_power_d3cold(pdev);
> +	mwifiex_pcie_set_power_d3cold(parent_pdev);
> +
> +	ret = mwifiex_pcie_set_power_d0(parent_pdev);
> +	if (ret)
> +		return ret;
> +	ret = mwifiex_pcie_set_power_d0(pdev);
> +	if (ret)
> +		return ret;
> +
> +	return 0;
>  }
> diff --git a/drivers/net/wireless/marvell/mwifiex/pcie_quirks.h b/drivers/net/wireless/marvell/mwifiex/pcie_quirks.h
> index 7a1fe3b3a61a..549093067813 100644
> --- a/drivers/net/wireless/marvell/mwifiex/pcie_quirks.h
> +++ b/drivers/net/wireless/marvell/mwifiex/pcie_quirks.h
> @@ -5,4 +5,7 @@
>
>  #include "pcie.h"
>
> +#define QUIRK_FW_RST_D3COLD	BIT(0)
> +
>  void mwifiex_initialize_quirks(struct pcie_service_card *card);
> +int mwifiex_pcie_reset_d3cold_quirk(struct pci_dev *pdev);
> --
> 2.31.1
>
