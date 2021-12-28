Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93CBF480D9D
	for <lists+netdev@lfdr.de>; Tue, 28 Dec 2021 23:11:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233451AbhL1WL5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Dec 2021 17:11:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230144AbhL1WL5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Dec 2021 17:11:57 -0500
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F9B8C061574
        for <netdev@vger.kernel.org>; Tue, 28 Dec 2021 14:11:56 -0800 (PST)
Received: by mail-wr1-x432.google.com with SMTP id k18so4009072wrg.11
        for <netdev@vger.kernel.org>; Tue, 28 Dec 2021 14:11:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language
         :from:to:cc:references:in-reply-to:content-transfer-encoding;
        bh=4+fNuvMIzktHZcAPTAkp0zD3O+2nYAT63n5vQR/X5Ko=;
        b=mXjjDgsrnFyPevtRIupiHP3085fVrY//gSs9dlxUmWZhwLp0WrrLtYYEBGzTJZqE0b
         QuONiiWq46E/RTnDwnfIHH5+QqWpZySRVAuoCG5a63zz/AmELxw1k54XY/9SOAl3hm35
         O3em1A6e3/jjO8liNKwwoToEMfcUq+wPk+mlxOX5Z0cKwX2E8F0VlMunGOiUkp5PXsDR
         Hk7a/1m7N5Rtf1ZJOYZ4Zg3sQEqo7AVktiJ2SjfKABUgJ5zmnrgZnTYKWO0IicjV3ong
         LJSRpEgCHAjcl7wTuHORNjomiy32e4la6ocoOw8bGOgAUZ4lxMh1Xjy3lXjtrLRKXCa8
         3vgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=4+fNuvMIzktHZcAPTAkp0zD3O+2nYAT63n5vQR/X5Ko=;
        b=D7kt8DzsGfXddTjcRQ9ekar+fg0nbBGIXyu6sfrRplmjtaq8mif1uJOslpJ3PZDZA/
         GvXtN7vAy07LenY1gLkNeMg6s1sAuo1hSffjVWV1CaPYo9vs3Erq605OQuOu4YHYE8eq
         poMWGzcG4yCU0e04xBhva5EPmHIlUsrUdts/yE99CkR1mpnKEmfAqOLS3duL0je5uEoC
         QILNaJxGVD/nvY5iAT0MzPWpeRQ4NL9SBGBdgezOmDXbv7ss2DonVChsdQWs7xITcOy0
         YWLE3xHKeYJcz6JIHX7Ua+ainQFgZ+qPdye1NB7dAKkXMR/xwU604UEIYQRIE2koOwvx
         Z69A==
X-Gm-Message-State: AOAM5305g2JQx1w7dwLqTXgf/swCCc8hcdJAPQv3jAmmdb4PyMqvme5V
        gYUeD+b/NMcRRSvAHmP/d6M=
X-Google-Smtp-Source: ABdhPJxv5C2Snua8aIPVyWuGRiUqBj3pljXdwTMvsG3SOHMbDqL117krw9kgYFYGRJkUDKmTiMQt0A==
X-Received: by 2002:a05:6000:2c6:: with SMTP id o6mr18116784wry.286.1640729514986;
        Tue, 28 Dec 2021 14:11:54 -0800 (PST)
Received: from ?IPV6:2003:ea:8f24:fd00:1db4:9082:d8f:5ea5? (p200300ea8f24fd001db490820d8f5ea5.dip0.t-ipconnect.de. [2003:ea:8f24:fd00:1db4:9082:d8f:5ea5])
        by smtp.googlemail.com with ESMTPSA id bg34sm24439066wmb.47.2021.12.28.14.11.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Dec 2021 14:11:54 -0800 (PST)
Message-ID: <70cd60cd-5472-25b6-91f5-a2d313dc6294@gmail.com>
Date:   Tue, 28 Dec 2021 23:11:47 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [PATCH net-next] r8169: don't use pci_irq_vector() in atomic
 context
Content-Language: en-US
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
References: <3cd24763-f307-78f5-76ed-a5fbf315fb28@gmail.com>
In-Reply-To: <3cd24763-f307-78f5-76ed-a5fbf315fb28@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 28.12.2021 22:02, Heiner Kallweit wrote:
> From: Thomas Gleixner <tglx@linutronix.de>
> 
> Since referenced change pci_irq_vector() can't be used in atomic
> context any longer. This conflicts with our usage of this function
> in rtl8169_netpoll(). Therefore store the interrupt number in
> struct rtl8169_private.
> 
> Fixes: 495c66aca3da ("genirq/msi: Convert to new functions")

Seeing the "fail" in patchwork: The referenced commit just recently
showed up in linux-next and isn't in net-next yet.


> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> ---
>  drivers/net/ethernet/realtek/r8169_main.c | 14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
> index 3d6843332..7161a5b1c 100644
> --- a/drivers/net/ethernet/realtek/r8169_main.c
> +++ b/drivers/net/ethernet/realtek/r8169_main.c
> @@ -615,6 +615,7 @@ struct rtl8169_private {
>  	struct ring_info tx_skb[NUM_TX_DESC];	/* Tx data buffers */
>  	u16 cp_cmd;
>  	u32 irq_mask;
> +	int irq;
>  	struct clk *clk;
>  
>  	struct {
> @@ -4712,7 +4713,7 @@ static int rtl8169_close(struct net_device *dev)
>  
>  	cancel_work_sync(&tp->wk.work);
>  
> -	free_irq(pci_irq_vector(pdev, 0), tp);
> +	free_irq(tp->irq, tp);
>  
>  	phy_disconnect(tp->phydev);
>  
> @@ -4733,7 +4734,7 @@ static void rtl8169_netpoll(struct net_device *dev)
>  {
>  	struct rtl8169_private *tp = netdev_priv(dev);
>  
> -	rtl8169_interrupt(pci_irq_vector(tp->pci_dev, 0), tp);
> +	rtl8169_interrupt(tp->irq, tp);
>  }
>  #endif
>  
> @@ -4767,8 +4768,7 @@ static int rtl_open(struct net_device *dev)
>  	rtl_request_firmware(tp);
>  
>  	irqflags = pci_dev_msi_enabled(pdev) ? IRQF_NO_THREAD : IRQF_SHARED;
> -	retval = request_irq(pci_irq_vector(pdev, 0), rtl8169_interrupt,
> -			     irqflags, dev->name, tp);
> +	retval = request_irq(tp->irq, rtl8169_interrupt, irqflags, dev->name, tp);
>  	if (retval < 0)
>  		goto err_release_fw_2;
>  
> @@ -4785,7 +4785,7 @@ static int rtl_open(struct net_device *dev)
>  	return retval;
>  
>  err_free_irq:
> -	free_irq(pci_irq_vector(pdev, 0), tp);
> +	free_irq(tp->irq, tp);
>  err_release_fw_2:
>  	rtl_release_firmware(tp);
>  	rtl8169_rx_clear(tp);
> @@ -5360,6 +5360,7 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
>  		dev_err(&pdev->dev, "Can't allocate interrupt\n");
>  		return rc;
>  	}
> +	tp->irq = pci_irq_vector(pdev, 0);
>  
>  	INIT_WORK(&tp->wk.work, rtl_task);
>  
> @@ -5435,8 +5436,7 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
>  		return rc;
>  
>  	netdev_info(dev, "%s, %pM, XID %03x, IRQ %d\n",
> -		    rtl_chip_infos[chipset].name, dev->dev_addr, xid,
> -		    pci_irq_vector(pdev, 0));
> +		    rtl_chip_infos[chipset].name, dev->dev_addr, xid, tp->irq);
>  
>  	if (jumbo_max)
>  		netdev_info(dev, "jumbo features [frames: %d bytes, tx checksumming: %s]\n",

