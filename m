Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 926524A4BF4
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 17:27:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380357AbiAaQ06 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 11:26:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380330AbiAaQ0w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Jan 2022 11:26:52 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D595C06173B;
        Mon, 31 Jan 2022 08:26:51 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id c24so28095160edy.4;
        Mon, 31 Jan 2022 08:26:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AwY1rSHuM6lR8KH0jH1kl90JqbVxGnmUft5540hRLCY=;
        b=JSZLimqxvV78eQdGZrVUSM/ug924VQcIQmGwPdjeelVdRmUR71pz3y0aLcrR8yCSjy
         rNCyOTEpY/wuhFUFLXpa8+eOSqvybCqgqgkyhZcS2eQoa4xxn0WTXTE1kLx6LslibDox
         vrRhMHrcPhKxD3pz10NCEpJ1U7hdQQl/eoi+CQjeC3LDirZZgO8auFDR7ZmQHAU3b9CW
         BLDz6q4MZumYYCf5IrkDFmcm8loaxmZWXUysz7eCAv6RIT5iNVAkE4lloKPvVlyDyl0h
         eKhvpH9+VMOBUrQSbKviUNKlAB7edQ+n4yiwnjz8jkrzqkoW6tdX+RTOeih0fY/+c0fd
         pUtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AwY1rSHuM6lR8KH0jH1kl90JqbVxGnmUft5540hRLCY=;
        b=r1vg671FqmKnacwG/v/xeI8xUaI6HDOBvMIsLwNgTfX3MHcMrt/x7HMPSq4xXegr1b
         uyLLWmUoykhsuGYhTzaNto+4st0vuU5XaOv3EYen8O4QPRDSfUhtKhF3arKwffPh2lN7
         IPLxXEnyd2JhwC5+l5a3nc2xnTd4a0wMHRvl5wWnfEV0LfiDirP3bKdxQCcT5UXYlHK0
         lw1vCo1g4Fdnv8kWmfkpIjd54pzySImoD9CqK0tTmO73A0rAZ0BNh49Q8nSbKCUSg9jr
         XYbaEt0Qbk8TEFLTb9LDUZU3AxIIDMe5thT3wpPKFxRfDyaSnDq8xCI/2+UTZ/DtGEV+
         26VQ==
X-Gm-Message-State: AOAM533d3q3HiFHnQK0rG452K2XYFlA4H9O0FdQsiGl2AgkzvNUfKRe8
        HDY4u8xR0x3uFGMDLYFQ3sbdOH3e7KjLWV2SD+A=
X-Google-Smtp-Source: ABdhPJxsX78+TBYmegbl+zF1b04vUK6cR5MHOFkie3rMlu/nf4u8SmJ/qKw623OO4UdFy7ANZ/+hd8psMh/eIAycN4s=
X-Received: by 2002:a05:6402:4248:: with SMTP id g8mr21292274edb.158.1643646410161;
 Mon, 31 Jan 2022 08:26:50 -0800 (PST)
MIME-Version: 1.0
References: <20220131160713.245637-1-marcan@marcan.st> <20220131160713.245637-7-marcan@marcan.st>
In-Reply-To: <20220131160713.245637-7-marcan@marcan.st>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Mon, 31 Jan 2022 18:25:14 +0200
Message-ID: <CAHp75VdmeepjqAO422v9Hz0YoiGZDTcTLbykxxL-CtRuuOZWPg@mail.gmail.com>
Subject: Re: [PATCH v4 6/9] brcmfmac: pcie: Fix crashes due to early IRQs
To:     Hector Martin <marcan@marcan.st>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Len Brown <lenb@kernel.org>,
        Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Wright Feng <wright.feng@infineon.com>,
        Dmitry Osipenko <digetx@gmail.com>,
        Sven Peter <sven@svenpeter.dev>,
        Alyssa Rosenzweig <alyssa@rosenzweig.io>,
        Mark Kettenis <kettenis@openbsd.org>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Hans de Goede <hdegoede@redhat.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        "brian m. carlson" <sandals@crustytoothpaste.net>,
        "open list:TI WILINK WIRELES..." <linux-wireless@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        devicetree <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        "open list:BROADCOM BRCM80211 IEEE802.11n WIRELESS DRIVER" 
        <brcm80211-dev-list.pdl@broadcom.com>,
        SHA-cyfmac-dev-list@infineon.com,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 31, 2022 at 6:08 PM Hector Martin <marcan@marcan.st> wrote:
>
> The driver was enabling IRQs before the message processing was
> initialized. This could cause IRQs to come in too early and crash the
> driver. Instead, move the IRQ enable and hostready to a bus preinit
> function, at which point everything is properly initialized.

Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>

> Fixes: 9e37f045d5e7 ("brcmfmac: Adding PCIe bus layer support.")
> Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
> Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Hector Martin <marcan@marcan.st>
> ---
>  .../wireless/broadcom/brcm80211/brcmfmac/pcie.c  | 16 +++++++++++++---
>  1 file changed, 13 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
> index c25f48db1f60..3ff4997e1c97 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
> @@ -1315,6 +1315,18 @@ static void brcmf_pcie_down(struct device *dev)
>  {
>  }
>
> +static int brcmf_pcie_preinit(struct device *dev)
> +{
> +       struct brcmf_bus *bus_if = dev_get_drvdata(dev);
> +       struct brcmf_pciedev *buspub = bus_if->bus_priv.pcie;
> +
> +       brcmf_dbg(PCIE, "Enter\n");
> +
> +       brcmf_pcie_intr_enable(buspub->devinfo);
> +       brcmf_pcie_hostready(buspub->devinfo);
> +
> +       return 0;
> +}
>
>  static int brcmf_pcie_tx(struct device *dev, struct sk_buff *skb)
>  {
> @@ -1423,6 +1435,7 @@ static int brcmf_pcie_reset(struct device *dev)
>  }
>
>  static const struct brcmf_bus_ops brcmf_pcie_bus_ops = {
> +       .preinit = brcmf_pcie_preinit,
>         .txdata = brcmf_pcie_tx,
>         .stop = brcmf_pcie_down,
>         .txctl = brcmf_pcie_tx_ctlpkt,
> @@ -1795,9 +1808,6 @@ static void brcmf_pcie_setup(struct device *dev, int ret,
>
>         init_waitqueue_head(&devinfo->mbdata_resp_wait);
>
> -       brcmf_pcie_intr_enable(devinfo);
> -       brcmf_pcie_hostready(devinfo);
> -
>         ret = brcmf_attach(&devinfo->pdev->dev);
>         if (ret)
>                 goto fail;
> --
> 2.33.0
>


-- 
With Best Regards,
Andy Shevchenko
