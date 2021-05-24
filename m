Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEE4E38F459
	for <lists+netdev@lfdr.de>; Mon, 24 May 2021 22:27:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233339AbhEXU3G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 May 2021 16:29:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232676AbhEXU3G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 May 2021 16:29:06 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB6EBC061574;
        Mon, 24 May 2021 13:27:37 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id b15-20020a17090a550fb029015dad75163dso11869884pji.0;
        Mon, 24 May 2021 13:27:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=YOLffSd93kh02GTMjTKHizOrglJPKYSVjdsNozWOQhM=;
        b=Adp+KffXTXWNkZcw9zQlHHv+k1lCOuoE8LCoLR9s+xuP/FEyQHIJffudAT4ZIMunql
         q8Q9pllpsnG7W8eSfGowVHIq0rhmiOieGHkYfflMomldnt6/1ACXGi5YPsLzJaKOp3kq
         bxY+YFYMzGxrFGlzbCTYzTEJ03XsbGGfiZtQW5QGrCJiGfrXRsMePGmD0rqjXJWIwGh5
         VDZfGN0YSPcsWfG2UK1TC4FOMwIz4ipiqbLIJ9EwvfCT4GYnFH9Jlz1n10i6UpX4xZN2
         orWrm99zBuYWSbxFTi6d3Z90kwYU8rf22QYiE4tCBmYCCuuK9OM3LifMqzw4gWPEVGIf
         Hkaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=YOLffSd93kh02GTMjTKHizOrglJPKYSVjdsNozWOQhM=;
        b=DIxYidsr6KB0gXtoTR9ec2GQQKjVUBT/osaroT0kJjd+vYo/vUcyUAp3C6eWK7xNiU
         mOpuGU0VABWhZs4qU8P/5JNnCU/RJmJy560OPaHE4XJVNFXzKybUqq11M3zaDYuEs5Y0
         E97M1P7QrhuvU5/Xl2O1o325EIDoesQASog7Q7N3mzlE6oYjMVKwCCyO8IpzM3pynkw3
         VRB/16gkQYYCz+WaLrtHBKHZUGXQYSdsDUXMMwkIh52e4MnJonSscjwvP+3Ld+YZiVLM
         ywJz6H5ohE7J0MlViGmcClvoDVgcd6cQY1Q5x/32XfyNAZ9BfNSmq/4mWohRaSHJT3bt
         iGtw==
X-Gm-Message-State: AOAM533OVUorA+40QBLQEWiX5wIPEfwkJE7R/p3nZd09LkDLvlbqy1LL
        Vy0ikX6TsKPAbufGxLcsEdvZobxmkh9WwA==
X-Google-Smtp-Source: ABdhPJwZ9+OE9EzwcDACYwXeN1EYhcmt5XtNITTXAkRRnjB4zPkGkgjP3bMjI2uZBZXXnNtgqmQ87g==
X-Received: by 2002:a17:90b:3692:: with SMTP id mj18mr27065279pjb.121.1621888057251;
        Mon, 24 May 2021 13:27:37 -0700 (PDT)
Received: from localhost ([103.248.31.164])
        by smtp.gmail.com with ESMTPSA id ie5sm264285pjb.14.2021.05.24.13.27.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 May 2021 13:27:36 -0700 (PDT)
Date:   Tue, 25 May 2021 01:57:34 +0530
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
Message-ID: <20210524202734.sgvv4qtzonlqmj7p@archlinux>
References: <20210522131827.67551-1-verdre@v0yd.nl>
 <20210522131827.67551-3-verdre@v0yd.nl>
 <20210522184416.mscbmay27jciy2hv@archlinux>
 <1a844abf-2259-ff4f-d49d-de95870345dc@mailbox.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1a844abf-2259-ff4f-d49d-de95870345dc@mailbox.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 21/05/23 12:28PM, Jonas Dreﬂler wrote:
> On 5/22/21 8:44 PM, Amey Narkhede wrote:
> > On 21/05/22 03:18PM, Jonas Dreﬂler wrote:
> > > From: Tsuchiya Yuto <kitakar@gmail.com>
> > >
> > > To reset mwifiex on Surface gen4+ (Pro 4 or later gen) devices, it
> > > seems that putting the wifi device into D3cold is required according
> > > to errata.inf file on Windows installation (Windows/INF/errata.inf).
> > >
> > > This patch adds a function that performs power-cycle (put into D3cold
> > > then D0) and call the function at the end of reset_prepare().
> > >
> > > Note: Need to also reset the parent device (bridge) of wifi on SB1;
> > > it might be because the bridge of wifi always reports it's in D3hot.
> > > When I tried to reset only the wifi device (not touching parent), it gave
> > > the following error and the reset failed:
> > >
> > >      acpi device:4b: Cannot transition to power state D0 for parent in D3hot
> > >      mwifiex_pcie 0000:03:00.0: can't change power state from D3cold to D0 (config space inaccessible)
> > >
> > May I know how did you reset only the wifi device when you encountered
> > this error?
>
> Not exactly sure what you mean by that, the trick was to put the parent
> bridge into D3cold and then into D0 before transitioning the card into
> D0.
>
If the parent bridge has multiple devices attached to it, this can
have some side effects on other devices after the reset but as you
mentioned below that parent bridge is only connected to wifi card it
should be fine in that case.

> That "Cannot transition to power state" warning is just the kernel
> enforcing ACPI specs afaik, and that prevents us from putting the device
> into ACPI state D0. This in turn means the device still has no power and
> we can't set the PCI power state to D0, which is the second error.
>
> >
> > > Signed-off-by: Tsuchiya Yuto <kitakar@gmail.com>
> > > Signed-off-by: Jonas Dreﬂler <verdre@v0yd.nl>
> > > ---
> > >   drivers/net/wireless/marvell/mwifiex/pcie.c   |   7 +
> > >   .../wireless/marvell/mwifiex/pcie_quirks.c    | 123 ++++++++++++++++++
> > >   .../wireless/marvell/mwifiex/pcie_quirks.h    |   3 +
> > >   3 files changed, 133 insertions(+)
> > >
> > > diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c b/drivers/net/wireless/marvell/mwifiex/pcie.c
> > > index 02fdce926de5..d9acfea395ad 100644
> > > --- a/drivers/net/wireless/marvell/mwifiex/pcie.c
> > > +++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
> > > @@ -528,6 +528,13 @@ static void mwifiex_pcie_reset_prepare(struct pci_dev *pdev)
> > >   	mwifiex_shutdown_sw(adapter);
> > >   	clear_bit(MWIFIEX_IFACE_WORK_DEVICE_DUMP, &card->work_flags);
> > >   	clear_bit(MWIFIEX_IFACE_WORK_CARD_RESET, &card->work_flags);
> > > +
> > > +	/* For Surface gen4+ devices, we need to put wifi into D3cold right
> > > +	 * before performing FLR
> > > +	 */
> > > +	if (card->quirks & QUIRK_FW_RST_D3COLD)
> > > +		mwifiex_pcie_reset_d3cold_quirk(pdev);
> > > +
> > >   	mwifiex_dbg(adapter, INFO, "%s, successful\n", __func__);
> > >
> > >   	card->pci_reset_ongoing = true;
> > > diff --git a/drivers/net/wireless/marvell/mwifiex/pcie_quirks.c b/drivers/net/wireless/marvell/mwifiex/pcie_quirks.c
> > > index 4064f99b36ba..b5f214fc1212 100644
> > > --- a/drivers/net/wireless/marvell/mwifiex/pcie_quirks.c
> > > +++ b/drivers/net/wireless/marvell/mwifiex/pcie_quirks.c
> > > @@ -15,6 +15,72 @@
> > >
> > >   /* quirk table based on DMI matching */
> > >   static const struct dmi_system_id mwifiex_quirk_table[] = {
> > > +	{
> > > +		.ident = "Surface Pro 4",
> > > +		.matches = {
> > > +			DMI_EXACT_MATCH(DMI_SYS_VENDOR, "Microsoft Corporation"),
> > > +			DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "Surface Pro 4"),
> > > +		},
> > > +		.driver_data = (void *)QUIRK_FW_RST_D3COLD,
> > > +	},
> > > +	{
> > > +		.ident = "Surface Pro 5",
> > > +		.matches = {
> > > +			/* match for SKU here due to generic product name "Surface Pro" */
> > > +			DMI_EXACT_MATCH(DMI_SYS_VENDOR, "Microsoft Corporation"),
> > > +			DMI_EXACT_MATCH(DMI_PRODUCT_SKU, "Surface_Pro_1796"),
> > > +		},
> > > +		.driver_data = (void *)QUIRK_FW_RST_D3COLD,
> > > +	},
> > > +	{
> > > +		.ident = "Surface Pro 5 (LTE)",
> > > +		.matches = {
> > > +			/* match for SKU here due to generic product name "Surface Pro" */
> > > +			DMI_EXACT_MATCH(DMI_SYS_VENDOR, "Microsoft Corporation"),
> > > +			DMI_EXACT_MATCH(DMI_PRODUCT_SKU, "Surface_Pro_1807"),
> > > +		},
> > > +		.driver_data = (void *)QUIRK_FW_RST_D3COLD,
> > > +	},
> > > +	{
> > > +		.ident = "Surface Pro 6",
> > > +		.matches = {
> > > +			DMI_EXACT_MATCH(DMI_SYS_VENDOR, "Microsoft Corporation"),
> > > +			DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "Surface Pro 6"),
> > > +		},
> > > +		.driver_data = (void *)QUIRK_FW_RST_D3COLD,
> > > +	},
> > > +	{
> > > +		.ident = "Surface Book 1",
> > > +		.matches = {
> > > +			DMI_EXACT_MATCH(DMI_SYS_VENDOR, "Microsoft Corporation"),
> > > +			DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "Surface Book"),
> > > +		},
> > > +		.driver_data = (void *)QUIRK_FW_RST_D3COLD,
> > > +	},
> > > +	{
> > > +		.ident = "Surface Book 2",
> > > +		.matches = {
> > > +			DMI_EXACT_MATCH(DMI_SYS_VENDOR, "Microsoft Corporation"),
> > > +			DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "Surface Book 2"),
> > > +		},
> > > +		.driver_data = (void *)QUIRK_FW_RST_D3COLD,
> > > +	},
> > > +	{
> > > +		.ident = "Surface Laptop 1",
> > > +		.matches = {
> > > +			DMI_EXACT_MATCH(DMI_SYS_VENDOR, "Microsoft Corporation"),
> > > +			DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "Surface Laptop"),
> > > +		},
> > > +		.driver_data = (void *)QUIRK_FW_RST_D3COLD,
> > > +	},
> > > +	{
> > > +		.ident = "Surface Laptop 2",
> > > +		.matches = {
> > > +			DMI_EXACT_MATCH(DMI_SYS_VENDOR, "Microsoft Corporation"),
> > > +			DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "Surface Laptop 2"),
> > > +		},
> > > +		.driver_data = (void *)QUIRK_FW_RST_D3COLD,
> > > +	},
> > >   	{}
> > >   };
> > >
> > > @@ -29,4 +95,61 @@ void mwifiex_initialize_quirks(struct pcie_service_card *card)
> > >
> > >   	if (!card->quirks)
> > >   		dev_info(&pdev->dev, "no quirks enabled\n");
> > > +	if (card->quirks & QUIRK_FW_RST_D3COLD)
> > > +		dev_info(&pdev->dev, "quirk reset_d3cold enabled\n");
> > > +}
> > > +
> > > +static void mwifiex_pcie_set_power_d3cold(struct pci_dev *pdev)
> > > +{
> > > +	dev_info(&pdev->dev, "putting into D3cold...\n");
> > > +
> > > +	pci_save_state(pdev);
> > > +	if (pci_is_enabled(pdev))
> > > +		pci_disable_device(pdev);
> > > +	pci_set_power_state(pdev, PCI_D3cold);
> > > +}
> > pci_set_power_state with PCI_D3cold state calls
> > pci_bus_set_current_state(dev->subordinate, PCI_D3cold).
> > Maybe this was the reason for the earlier problem you had?
> > Not 100% sure about this though CCing: Alex
>
> Hmm, so we'd only have to put the bridge into D3cold and that takes care
> of the device going to D3cold automatically?
>
Yeah I think it should do it. Have you tried this?
> >
> > > +
> > > +static int mwifiex_pcie_set_power_d0(struct pci_dev *pdev)
> > > +{
> > > +	int ret;
> > > +
> > > +	dev_info(&pdev->dev, "putting into D0...\n");
> > > +
> > > +	pci_set_power_state(pdev, PCI_D0);
> > > +	ret = pci_enable_device(pdev);
> > > +	if (ret) {
> > > +		dev_err(&pdev->dev, "pci_enable_device failed\n");
> > > +		return ret;
> > > +	}
> > > +	pci_restore_state(pdev);
> > On the side note just save and restore is enough in this case?
> > What would be the device <-> driver state after the reset as you
> > are calling this on parent_pdev below so that affects other
> > devices on bus?
>
> Not sure we can do anything more than save and restore, can we? I don't
> think it will affect other devices on the bus, the parent bridge is only
> connected to the wifi card, nothing else.
>
I was thinking of doing remove-reset-rescan but I think save-restore
should be ok if there is a single device connected to the parent bridge.

Thanks,
Amey
[...]
> > > diff --git a/drivers/net/wireless/marvell/mwifiex/pcie_quirks.h b/drivers/net/wireless/marvell/mwifiex/pcie_quirks.h
> > > index 7a1fe3b3a61a..549093067813 100644
> > > --- a/drivers/net/wireless/marvell/mwifiex/pcie_quirks.h
> > > +++ b/drivers/net/wireless/marvell/mwifiex/pcie_quirks.h
> > > @@ -5,4 +5,7 @@
> > >
> > >   #include "pcie.h"
> > >
> > > +#define QUIRK_FW_RST_D3COLD	BIT(0)
> > > +
> > >   void mwifiex_initialize_quirks(struct pcie_service_card *card);
> > > +int mwifiex_pcie_reset_d3cold_quirk(struct pci_dev *pdev);
> > > --
> > > 2.31.1
> > >
>
> Thanks for the review,
> Jonas
