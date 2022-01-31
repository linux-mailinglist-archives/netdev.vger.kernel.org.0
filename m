Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C16D4A4BFD
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 17:28:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380341AbiAaQ22 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 11:28:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380451AbiAaQ17 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Jan 2022 11:27:59 -0500
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68F44C06173E;
        Mon, 31 Jan 2022 08:27:37 -0800 (PST)
Received: by mail-ej1-x636.google.com with SMTP id j2so44245003ejk.6;
        Mon, 31 Jan 2022 08:27:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dZOePB9QjNAYiNKauHeirK5pevUoAsv4ueKQKshpJRQ=;
        b=hGHagcalOH44drGxxD/MoK2ikGX9zfIpfchIap8oo/rceJSg+nq+21ioGi065pAh5r
         ADeLZw54l/wVIzekDoI6t50DWHGfx3qsIg7xzRYPTcffLU8sJCLVNpEbT4uNznCORRlA
         LKU89jp5E3jc3XllI++4zxlXcqyupEk5mr++4uh92JAv/s3/EZzSEtKbmlOq+bXRXiVn
         3tYAqa2l3m4aoLvEmo3d4GCOnNWWfPERGJeTTovaUv2uxt6zAFuyxzOyNks4+FT3GiPP
         GFEg+0mxMxT7bHX7HDKPKYD6QRFagwQRLtz175HK0h/eWuIgO1a175TLWaPpjuJosNuQ
         6Ssw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dZOePB9QjNAYiNKauHeirK5pevUoAsv4ueKQKshpJRQ=;
        b=fnTCsRu970SS4wUJMQp7bPSHHw1k/CkUO0xgFuPKXDjqQMlPGV72I5m6EHdl8UtdH8
         CplNLmzEjOULlazJZvaBNeQUskZreR/JCeVJpMuppuQAk13/o6x4BGc8lh7Fufr/fBcM
         EwPdkUQwD49dk9QA1a/+D8nr4rin55LV9/LMvMI36/xhWAOaRZbuopUSXjMLqbwJ9xVg
         3/x/YVlRBnPkFEbJgMNZlfu54onBmUH+zq991Fe5i6lrCfj+BD8eF8MNzz5q6DLc47nA
         bOHMZ8G2NEeRvceVTiZGPbFnUhYgLt7XmxQe1n4Vi9KY6b8xcLNHxaFO487L5/e4PPIX
         eFZQ==
X-Gm-Message-State: AOAM5326JLiN0EDGUkffkESuhrVxXQhkvsyuF7F5ACvhQNyLy0QvCs/d
        sUJDL+9TEe8zWW22MR0ZOaJcZn9x0sQDryandWM=
X-Google-Smtp-Source: ABdhPJw4dOYqjyaB/vjErRBa74ILdESAo1tCkt164uJa/5L7WNYYYgCX57bs03CT9s6H5/HjHQc1Qxm4lT2628BCptE=
X-Received: by 2002:a17:907:2d92:: with SMTP id gt18mr17177209ejc.579.1643646453901;
 Mon, 31 Jan 2022 08:27:33 -0800 (PST)
MIME-Version: 1.0
References: <20220131160713.245637-1-marcan@marcan.st> <20220131160713.245637-10-marcan@marcan.st>
In-Reply-To: <20220131160713.245637-10-marcan@marcan.st>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Mon, 31 Jan 2022 18:25:58 +0200
Message-ID: <CAHp75Vcvtm1EvsEAaX8ii+qA_09iJ2-J9gFjSzsUPyOUzPoUBg@mail.gmail.com>
Subject: Re: [PATCH v4 9/9] brcmfmac: pcie: Read the console on init and shutdown
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
        Arend van Spriel <arend.vanspriel@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 31, 2022 at 6:08 PM Hector Martin <marcan@marcan.st> wrote:
>
> This allows us to get console messages if the firmware crashed during
> early init, or if an operation failed and we're about to shut down.

fails

Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>

> Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
> Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> Signed-off-by: Hector Martin <marcan@marcan.st>
> ---
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
> index 3ff4997e1c97..4fe341376a16 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
> @@ -744,6 +744,8 @@ static void brcmf_pcie_bus_console_read(struct brcmf_pciedev_info *devinfo,
>                 return;
>
>         console = &devinfo->shared.console;
> +       if (!console->base_addr)
> +               return;
>         addr = console->base_addr + BRCMF_CONSOLE_WRITEIDX_OFFSET;
>         newidx = brcmf_pcie_read_tcm32(devinfo, addr);
>         while (newidx != console->read_idx) {
> @@ -1520,6 +1522,7 @@ brcmf_pcie_init_share_ram_info(struct brcmf_pciedev_info *devinfo,
>                   shared->max_rxbufpost, shared->rx_dataoffset);
>
>         brcmf_pcie_bus_console_init(devinfo);
> +       brcmf_pcie_bus_console_read(devinfo, false);
>
>         return 0;
>  }
> @@ -1959,6 +1962,7 @@ brcmf_pcie_remove(struct pci_dev *pdev)
>                 return;
>
>         devinfo = bus->bus_priv.pcie->devinfo;
> +       brcmf_pcie_bus_console_read(devinfo, false);
>
>         devinfo->state = BRCMFMAC_PCIE_STATE_DOWN;
>         if (devinfo->ci)
> --
> 2.33.0
>


-- 
With Best Regards,
Andy Shevchenko
