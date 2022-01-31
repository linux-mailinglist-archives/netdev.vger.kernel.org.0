Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4244E4A4C02
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 17:28:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380394AbiAaQ2h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 11:28:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380370AbiAaQ2e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Jan 2022 11:28:34 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DED60C06173B;
        Mon, 31 Jan 2022 08:28:33 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id p7so27757180edc.12;
        Mon, 31 Jan 2022 08:28:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dwt+S+xaQOb5oolekdBKMH+fGFi5CzTZ33U4PJNpXnE=;
        b=XbUONObw9m3FeEzG8kzzGOJWeQjOCK9wirykP4FDExl5B/1dbMR8BtSh9kkOYF3yQe
         eUJfi+QOYsFQnKvZJZmBR2+gm3vdnl5dGuvjC4RaV3LPOwFiNi25VQpe2kw4ikxgJvqi
         r5oEJSbkV7qby8nT8R0fhesITOQShBmhjsrTYlraw2qpoNgDHH9q0567RyXRDIQrvzpW
         WiTMf4ODMq//41ZC0RbVpi3jhxUZfeV+oJlNM5+xOHspbVD0yOYbBBGze5iTRBgf9Ssq
         oXaOYs6eCQn0mHh7MarPkl2a28yjSULvkoD8A3j/mxP+7gZgyGTI1IqYErNLJ+SVg0UX
         OfnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dwt+S+xaQOb5oolekdBKMH+fGFi5CzTZ33U4PJNpXnE=;
        b=VgBqXY5xEobCQJzAiN7z9iy5SovzNVCmb1a4sQWPKYcrR2oxMMl4PWGSb0bWMydUPW
         w097uFX/4yuHrIgdus4cOcNjTS9P3iAcNGuxM9C+B+P9cG4e0sHGQZasVqNXdH74ZvTS
         owHGJGP4fAvCnb4OcGVkwAqxcf1w3cqKHr/URtFBn+sxk9GxgsZVsjbe5GJZO9ayN2mu
         gn12p/ZR71bNwHdp/QCRgSpi9/ptU+T97f0wcZSp/j25tWRwApKURzXk0FL0IGAAxCV8
         cbbx8pnTsCCpfI6BvqPOyPVlxsY/CtE+lMRWrgWf2lUUJmQd93SZxjKy+HLxRv0lENkG
         Oyng==
X-Gm-Message-State: AOAM5303PK83iaxBpiSfvQHIGBEAWLSDGkp16AZPqyJPfa4y9KUEiRNl
        3N6h4wrMDz6w7KIrOLK+zYWe9Eki934mX7kkuZU=
X-Google-Smtp-Source: ABdhPJxSBz18NwyW86CThCeoCdkkXwq6+Gjg58B4suZ/8V/WkVaJw3IipwwO7vMKIpFbTBJGMyRYHQ29vDLeDxuWYeg=
X-Received: by 2002:aa7:d1d4:: with SMTP id g20mr21531766edp.296.1643646512457;
 Mon, 31 Jan 2022 08:28:32 -0800 (PST)
MIME-Version: 1.0
References: <20220131160713.245637-1-marcan@marcan.st> <20220131160713.245637-2-marcan@marcan.st>
In-Reply-To: <20220131160713.245637-2-marcan@marcan.st>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Mon, 31 Jan 2022 18:26:56 +0200
Message-ID: <CAHp75VcQ=BRkVb3QT0brAO7P_L47tyaymfkM-syOPDMAKG5R3A@mail.gmail.com>
Subject: Re: [PATCH v4 1/9] brcmfmac: pcie: Release firmwares in the
 brcmf_pcie_setup error path
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

On Mon, Jan 31, 2022 at 6:07 PM Hector Martin <marcan@marcan.st> wrote:
>
> This avoids leaking memory if brcmf_chip_get_raminfo fails. Note that
> the CLM blob is released in the device remove path.

Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>


> Fixes: 82f93cf46d60 ("brcmfmac: get chip's default RAM info during PCIe setup")
> Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
> Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Hector Martin <marcan@marcan.st>
> ---
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
> index 8b149996fc00..f876b1d8d00d 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
> @@ -1777,6 +1777,8 @@ static void brcmf_pcie_setup(struct device *dev, int ret,
>         ret = brcmf_chip_get_raminfo(devinfo->ci);
>         if (ret) {
>                 brcmf_err(bus, "Failed to get RAM info\n");
> +               release_firmware(fw);
> +               brcmf_fw_nvram_free(nvram);
>                 goto fail;
>         }
>
> --
> 2.33.0
>


-- 
With Best Regards,
Andy Shevchenko
