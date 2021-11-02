Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00DD744383F
	for <lists+netdev@lfdr.de>; Tue,  2 Nov 2021 23:08:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231325AbhKBWLW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Nov 2021 18:11:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229525AbhKBWLW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Nov 2021 18:11:22 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75832C061203
        for <netdev@vger.kernel.org>; Tue,  2 Nov 2021 15:08:46 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id b12so673179wrh.4
        for <netdev@vger.kernel.org>; Tue, 02 Nov 2021 15:08:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kresin-me.20210112.gappssmtp.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=QQtsdMBTYCrx4ZIdrwpM406mJ59MqUemBaN1hkUC/SQ=;
        b=h9YP238PcOXtz7wky3z+3DTOyYTZQKzPCN3N5rN6iMGWmpLjFBznmW5wgRIS+2TjeQ
         wQ5PhXn+DvfpDYtJv2K/uuSP3Tv8Pq2ATyXDGohJxl4mSFtTY0LrzW7flJhSSHAn6NRY
         5TfHOQn5gFnsWo7Jlts1+IDVQMXHnS5XeUwKE8s3il7yzbYuWybDbf9W4zAMB22MBYct
         P+B4+iDUJV7sZ7izhB+3TCcnq63zyjih0gAgbcCjiq+SETdmD5g+mzDXhdA5259AtLLZ
         3KLhBJL3bljuqYlr93ryn1B/4kD7ZDfYC9Mm/FF9GkCSZqs8IlnivToAq0GXT3l8C/ZT
         /IBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QQtsdMBTYCrx4ZIdrwpM406mJ59MqUemBaN1hkUC/SQ=;
        b=1HrhTuusAzCINiyFV6wt9WW0MYA1QKY4RI5+Svkg308axdkk5HawgkqsFb/FTMa2cT
         P2P1Cw7Gv1YFgkmhj1VS+udxv/h23RrD2K6RmKi4RKP80jvdkfqHCiaZiHdS0OFVIaVv
         OVbrI7Oi8BSe+Hp989svwxSfb24O+R0At1F/p8sJy1LQxsgZ1/9H4ydECcAEHt3KZWdT
         w/BJJ+REesuPE/1WxxE3RPccjswwEdaLmMx2ROrKU64SoNlpXqgd7lAtGA63DHhtmfKE
         imnHG8FSvUtZeTYplW1r573GKpwN9I9tg3AqgbHmuXt4scG/KEpu2n8ZVF+QTEYJgI0Z
         L/Rg==
X-Gm-Message-State: AOAM530YjuL59W2gznBUH6iqSU44m91Er6aiD9k4uELv2tgIf9xFwqz9
        j7nlNpRgau50tksfuuxS8etuxg==
X-Google-Smtp-Source: ABdhPJxUvC2/L/kChoDWTaNu+8S1bSxZ9jfOV9n1fXrshS6RY3O71hlhviL+BXHtA7AQ41UCBSrEHA==
X-Received: by 2002:adf:f209:: with SMTP id p9mr47842973wro.191.1635890924929;
        Tue, 02 Nov 2021 15:08:44 -0700 (PDT)
Received: from ?IPv6:2003:ec:2f1f:8200:b487:4c63:5540:3502? (p200300ec2f1f8200b4874c6355403502.dip0.t-ipconnect.de. [2003:ec:2f1f:8200:b487:4c63:5540:3502])
        by smtp.gmail.com with ESMTPSA id g3sm285760wri.45.2021.11.02.15.08.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Nov 2021 15:08:44 -0700 (PDT)
Subject: Re: [RFC net-next/wireless-next v1 2/2] ath10k: move
 device_get_mac_address() and pass errors up the chain
To:     Christian Lamparter <chunkeey@gmail.com>, netdev@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org
Cc:     Ansuel Smith <ansuelsmth@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, Len Brown <lenb@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>, Michael Walle <michael@walle.cc>,
        Arnd Bergmann <arnd@arndb.de>
References: <20211030174111.1432663-1-chunkeey@gmail.com>
 <20211030174111.1432663-2-chunkeey@gmail.com>
From:   Mathias Kresin <dev@kresin.me>
Message-ID: <2caec4e0-94f4-915c-60d1-c78e7bdc5364@kresin.me>
Date:   Tue, 2 Nov 2021 23:08:43 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211030174111.1432663-2-chunkeey@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: de-DE
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hey Christian,

just a drive-by comment inline.

Mathias

10/30/21 7:41 PM, Christian Lamparter:
> device_get_mac_address() can now return -EPROBE_DEFER.
> This has to be passed back to the device subsystem so
> the driver will be probed again at a later time.
> 
> This was somewhat involved because the best place for this
> seemed in ath10k_core_create() right after allocation.
> Thing is that ath10k_core_create() was setup to either
> return a valid ath10k* instance, or NULL. So each ath10k
> implementation has to be modified to account for ERR_PTR.
> 
> This introduces a new side-effect: the returned error codes
> from ath10k_core_create() will now be passed along. It's no
> longer just -ENOMEM.
> 
> Note: If device_get_mac_address() didn't get a valid MAC from
> either the DT/ACPI, nvmem, etc... the driver will just generate
> random MAC (same as it did before).
> 
> Signed-off-by: Christian Lamparter <chunkeey@gmail.com>
> ---
> @Kalle from what I can tell, this is how nvmem-mac could be
> done with the existing device_get_mac_address() - at a
> different place. The reason for the move was that -EPROBE_DEFER
> needs to be returned by the pci/usb/snoc/ahb _probe functions().
> This wasn't possible in the old location. As ath10k deferres
> the "bring-up" process into a workqueue task which can't return
> any errors (it just printk/dev_err them at the end).
> Also, When I was asking around about this. The common consensus was
> to just post it and see. This is based on net-next + wireless-testing
> 
>   drivers/net/wireless/ath/ath10k/ahb.c  |  8 +++++---
>   drivers/net/wireless/ath/ath10k/core.c | 14 ++++++++------
>   drivers/net/wireless/ath/ath10k/pci.c  |  8 +++++---
>   drivers/net/wireless/ath/ath10k/sdio.c |  8 +++++---
>   drivers/net/wireless/ath/ath10k/snoc.c |  8 +++++---
>   drivers/net/wireless/ath/ath10k/usb.c  |  8 +++++---
>   6 files changed, 33 insertions(+), 21 deletions(-)
> 
>   
> 
> diff --git a/drivers/net/wireless/ath/ath10k/ahb.c b/drivers/net/wireless/ath/ath10k/ahb.c
> index ab8f77ae5e66..ad282a06b376 100644
> --- a/drivers/net/wireless/ath/ath10k/ahb.c
> +++ b/drivers/net/wireless/ath/ath10k/ahb.c
> @@ -745,9 +745,11 @@ static int ath10k_ahb_probe(struct platform_device *pdev)
>   	size = sizeof(*ar_pci) + sizeof(*ar_ahb);
>   	ar = ath10k_core_create(size, &pdev->dev, ATH10K_BUS_AHB,
>   				hw_rev, &ath10k_ahb_hif_ops);
> -	if (!ar) {
> -		dev_err(&pdev->dev, "failed to allocate core\n");
> -		return -ENOMEM;
> +	if (IS_ERR(ar)) {
> +		ret = PTR_ERR(ar);
> +		if (ret != -EPROBE_DEFER)
> +			dev_err(&pdev->dev, "failed to allocate core: %d\n", ret);

There's a helper for that: dev_err_probe().

> +		return ret;
>   	}
>   
>   	ath10k_dbg(ar, ATH10K_DBG_BOOT, "ahb probe\n");
> diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
> index 72a366aa9f60..85d2e8143101 100644
> --- a/drivers/net/wireless/ath/ath10k/core.c
> +++ b/drivers/net/wireless/ath/ath10k/core.c
> @@ -3291,8 +3291,6 @@ static int ath10k_core_probe_fw(struct ath10k *ar)
>   		ath10k_debug_print_board_info(ar);
>   	}
>   
> -	device_get_mac_address(ar->dev, ar->mac_addr);
> -
>   	ret = ath10k_core_init_firmware_features(ar);
>   	if (ret) {
>   		ath10k_err(ar, "fatal problem with firmware features: %d\n",
> @@ -3451,11 +3449,11 @@ struct ath10k *ath10k_core_create(size_t priv_size, struct device *dev,
>   				  const struct ath10k_hif_ops *hif_ops)
>   {
>   	struct ath10k *ar;
> -	int ret;
> +	int ret = -ENOMEM;
>   
>   	ar = ath10k_mac_create(priv_size);
>   	if (!ar)
> -		return NULL;
> +		goto err_out;
>   
>   	ar->ath_common.priv = ar;
>   	ar->ath_common.hw = ar->hw;
> @@ -3464,6 +3462,10 @@ struct ath10k *ath10k_core_create(size_t priv_size, struct device *dev,
>   	ar->hif.ops = hif_ops;
>   	ar->hif.bus = bus;
>   
> +	ret = device_get_mac_address(dev, ar->mac_addr);
> +	if (ret == -EPROBE_DEFER)
> +		goto err_free_mac;
> +
>   	switch (hw_rev) {
>   	case ATH10K_HW_QCA988X:
>   	case ATH10K_HW_QCA9887:
> @@ -3580,8 +3582,8 @@ struct ath10k *ath10k_core_create(size_t priv_size, struct device *dev,
>   	destroy_workqueue(ar->workqueue);
>   err_free_mac:
>   	ath10k_mac_destroy(ar);
> -
> -	return NULL;
> +err_out:
> +	return ERR_PTR(ret);
>   }
>   EXPORT_SYMBOL(ath10k_core_create);
>   
> diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
> index 4d4e2f91e15c..f4736148a382 100644
> --- a/drivers/net/wireless/ath/ath10k/pci.c
> +++ b/drivers/net/wireless/ath/ath10k/pci.c
> @@ -3602,9 +3602,11 @@ static int ath10k_pci_probe(struct pci_dev *pdev,
>   
>   	ar = ath10k_core_create(sizeof(*ar_pci), &pdev->dev, ATH10K_BUS_PCI,
>   				hw_rev, &ath10k_pci_hif_ops);
> -	if (!ar) {
> -		dev_err(&pdev->dev, "failed to allocate core\n");
> -		return -ENOMEM;
> +	if (IS_ERR(ar)) {
> +		ret = PTR_ERR(ar);
> +		if (ret != -EPROBE_DEFER)
> +			dev_err(&pdev->dev, "failed to allocate core: %d\n", ret);
> +		return ret;
>   	}
>   
>   	ath10k_dbg(ar, ATH10K_DBG_BOOT, "pci probe %04x:%04x %04x:%04x\n",
> diff --git a/drivers/net/wireless/ath/ath10k/sdio.c b/drivers/net/wireless/ath/ath10k/sdio.c
> index 63e1c2d783c5..87941e047d07 100644
> --- a/drivers/net/wireless/ath/ath10k/sdio.c
> +++ b/drivers/net/wireless/ath/ath10k/sdio.c
> @@ -2526,9 +2526,11 @@ static int ath10k_sdio_probe(struct sdio_func *func,
>   
>   	ar = ath10k_core_create(sizeof(*ar_sdio), &func->dev, ATH10K_BUS_SDIO,
>   				hw_rev, &ath10k_sdio_hif_ops);
> -	if (!ar) {
> -		dev_err(&func->dev, "failed to allocate core\n");
> -		return -ENOMEM;
> +	if (IS_ERR(ar)) {
> +		ret = PTR_ERR(ar);
> +		if (ret != -EPROBE_DEFER)
> +			dev_err(&func->dev, "failed to allocate core: %d\n", ret);
> +		return ret;
>   	}
>   
>   	netif_napi_add(&ar->napi_dev, &ar->napi, ath10k_sdio_napi_poll,
> diff --git a/drivers/net/wireless/ath/ath10k/snoc.c b/drivers/net/wireless/ath/ath10k/snoc.c
> index 9513ab696fff..b9ac89e226a2 100644
> --- a/drivers/net/wireless/ath/ath10k/snoc.c
> +++ b/drivers/net/wireless/ath/ath10k/snoc.c
> @@ -1728,9 +1728,11 @@ static int ath10k_snoc_probe(struct platform_device *pdev)
>   
>   	ar = ath10k_core_create(sizeof(*ar_snoc), dev, ATH10K_BUS_SNOC,
>   				drv_data->hw_rev, &ath10k_snoc_hif_ops);
> -	if (!ar) {
> -		dev_err(dev, "failed to allocate core\n");
> -		return -ENOMEM;
> +	if (IS_ERR(ar)) {
> +		ret = PTR_ERR(ar);
> +		if (ret != -EPROBE_DEFER)
> +			dev_err(dev, "failed to allocate core: %d\n", ret);
> +		return ret;
>   	}
>   
>   	ar_snoc = ath10k_snoc_priv(ar);
> diff --git a/drivers/net/wireless/ath/ath10k/usb.c b/drivers/net/wireless/ath/ath10k/usb.c
> index 3d98f19c6ec8..d6dc830a6fa8 100644
> --- a/drivers/net/wireless/ath/ath10k/usb.c
> +++ b/drivers/net/wireless/ath/ath10k/usb.c
> @@ -987,9 +987,11 @@ static int ath10k_usb_probe(struct usb_interface *interface,
>   
>   	ar = ath10k_core_create(sizeof(*ar_usb), &dev->dev, ATH10K_BUS_USB,
>   				hw_rev, &ath10k_usb_hif_ops);
> -	if (!ar) {
> -		dev_err(&dev->dev, "failed to allocate core\n");
> -		return -ENOMEM;
> +	if (IS_ERR(ar)) {
> +		ret = PTR_ERR(ar);
> +		if (ret != -EPROBE_DEFER)
> +			dev_err(&dev->dev, "failed to allocate core: %d\n", ret);
> +		return ret;
>   	}
>   
>   	usb_get_dev(dev);
> 

