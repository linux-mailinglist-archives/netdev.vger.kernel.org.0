Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7321548434F
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 15:26:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232868AbiADO0h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 09:26:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229798AbiADO0h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jan 2022 09:26:37 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5E50C061761;
        Tue,  4 Jan 2022 06:26:36 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id y22so149246519edq.2;
        Tue, 04 Jan 2022 06:26:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CG+rHtZHuoElrdyDC84Mj1DiZQU3+b7Wo+ZjIpKoo+4=;
        b=RQhTxZkEuTB/il/R45lXihVcPmDhg1TCkC+WCIdEXMfnSWZV/yRncSYK361LdK47hz
         YBtwwNpitCs0UnSoYG/ZTKXq1ygSNfm4by7KWSqb7fCVEvaxStLwKDFdDRHM3rRldXut
         lw+sJICRllp9hJPOzkOHGYAtzEqfEpKRSnyvohzJQ5+yiuP2X5ntILnLUS3PSS0tfAiP
         vlur6CUC3g7YxCSjHXDnioqeDIcwXOaoUY9vGYOJNvTjovyGzh46LBAKn6j897Ue2vr+
         UFJMgjvKBW0dpzqYCOIJW+ehwYHVFs0udRuxn+X1gcVLzAIMeY0yigYxhObsE174MbWZ
         jatQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CG+rHtZHuoElrdyDC84Mj1DiZQU3+b7Wo+ZjIpKoo+4=;
        b=Weup6xp8PlHVzihJxPdYdCHgqe9jwp+khE3PPUej0f2LAN2I2m55LvIiO1F+LmZLzR
         vZ+FayOgvZCgrCaO4ZNca1yCoyyVTT8ULZgclHMd5UJ//Z10lo/ZAv7hNEqpPopbhnEV
         CxSWUtjF4LsNspHZrY8GnDoP7rqbViWAx4Gc6GVYR6aNY1d7hAvPoLl9zctqpBtL+Ch8
         kaznzD57fLYdWFf5G2RlbAQnGh0kPlUI2UkM7QSCrC/XmCuoGw72iudjQ/9B3YpaR9XX
         5/PdrlsVdYlwFixClLPZIMKlyCQu2ieT5fT9C1ZJiL9rtky51KbEIrZLliiMP7pz5HsX
         1qpw==
X-Gm-Message-State: AOAM532DT+tzxF4VZAMQD+ZwEl8jv7Cnv3xOVcyQN5LZThgoQBp89+Ss
        eGveJm6mVCVFjTVGdgh5CVTQh3f+NTie2utALOI=
X-Google-Smtp-Source: ABdhPJzt05oF6uWJcvUFJYXQYC2SL6Ipb2PJXCH9MFydobGwXpZl9+vxtfy8aHc/r4Rte+VhAFkal2ooF19EGXTMlJo=
X-Received: by 2002:a05:6402:2693:: with SMTP id w19mr47375705edd.158.1641306395280;
 Tue, 04 Jan 2022 06:26:35 -0800 (PST)
MIME-Version: 1.0
References: <20220104072658.69756-1-marcan@marcan.st> <20220104072658.69756-10-marcan@marcan.st>
In-Reply-To: <20220104072658.69756-10-marcan@marcan.st>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Tue, 4 Jan 2022 16:24:44 +0200
Message-ID: <CAHp75VeN=RkBHnNkQB7_WwjtKuk9OP=utZp+tMf18VF2=CogkA@mail.gmail.com>
Subject: Re: [PATCH v2 09/35] brcmfmac: pcie: Perform firmware selection for
 Apple platforms
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
        Chi-hsien Lin <chi-hsien.lin@infineon.com>,
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
        SHA-cyfmac-dev-list@infineon.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 4, 2022 at 9:28 AM Hector Martin <marcan@marcan.st> wrote:
>
> On Apple platforms, firmware selection uses the following elements:
>
>   Property         Example   Source
>   ==============   =======   ========================
> * Chip name        4378      Device ID
> * Chip revision    B1        OTP
> * Platform         shikoku   DT (ARM64) or ACPI (x86)
> * Module type      RASP      OTP
> * Module vendor    m         OTP
> * Module version   6.11      OTP
> * Antenna SKU      X3        DT (ARM64) or ACPI (x86)
>
> In macOS, these firmwares are stored using filenames in this format
> under /usr/share/firmware/wifi:
>
>     C-4378__s-B1/P-shikoku-X3_M-RASP_V-m__m-6.11.txt
>
> To prepare firmwares for Linux, we rename these to a scheme following
> the existing brcmfmac convention:
>
>     brcmfmac<chip><lower(rev)>-pcie.apple,<platform>-<mod_type>-\
>         <mod_vendor>-<mod_version>-<antenna_sku>.txt
>
> The NVRAM uses all the components, while the firmware and CLM blob only
> use the chip/revision/platform/antenna_sku:
>
>     brcmfmac<chip><lower(rev)>-pcie.apple,<platform>-<antenna_sku>.bin
>
> e.g.
>
>     brcm/brcmfmac4378b1-pcie.apple,shikoku-RASP-m-6.11-X3.txt
>     brcm/brcmfmac4378b1-pcie.apple,shikoku-X3.bin
>
> In addition, since there are over 1000 files in total, many of which are
> symlinks or outright duplicates, we deduplicate and prune the firmware
> tree to reduce firmware filenames to fewer dimensions. For example, the
> shikoku platform (MacBook Air M1 2020) simplifies to just 4 files:
>
>     brcm/brcmfmac4378b1-pcie.apple,shikoku.clm_blob
>     brcm/brcmfmac4378b1-pcie.apple,shikoku.bin
>     brcm/brcmfmac4378b1-pcie.apple,shikoku-RASP-m.txt
>     brcm/brcmfmac4378b1-pcie.apple,shikoku-RASP-u.txt
>
> This reduces the total file count to around 170, of which 75 are
> symlinks and 95 are regular files: 7 firmware blobs, 27 CLM blobs, and
> 61 NVRAM config files. We also slightly process NVRAM files to correct
> some formatting issues.
>
> To handle this, the driver must try the following path formats when
> looking for firmware files:
>
>     brcm/brcmfmac4378b1-pcie.apple,shikoku-RASP-m-6.11-X3.txt
>     brcm/brcmfmac4378b1-pcie.apple,shikoku-RASP-m-6.11.txt
>     brcm/brcmfmac4378b1-pcie.apple,shikoku-RASP-m.txt
>     brcm/brcmfmac4378b1-pcie.apple,shikoku-RASP.txt
>     brcm/brcmfmac4378b1-pcie.apple,shikoku-X3.txt *
>     brcm/brcmfmac4378b1-pcie.apple,shikoku.txt
>
> * Not relevant for NVRAM, only for firmware/CLM.
>
> The chip revision nominally comes from OTP on Apple platforms, but it
> can be mapped to the PCI revision number, so we ignore the OTP revision
> and continue to use the existing PCI revision mechanism to identify chip
> revisions, as the driver already does for other chips. Unfortunately,
> the mapping is not consistent between different chip types, so this has
> to be determined experimentally.

...

> +       /* Apple platforms with fancy firmware/NVRAM selection */
> +       if (devinfo->settings->board_type &&
> +           devinfo->settings->antenna_sku &&
> +           devinfo->otp.valid) {
> +               char *buf;
> +               int len;
> +
> +               brcmf_dbg(PCIE, "Apple board: %s\n",
> +                         devinfo->settings->board_type);
> +
> +               /* Example: apple,shikoku-RASP-m-6.11-X3 */
> +               len = (strlen(devinfo->settings->board_type) + 1 +
> +                      strlen(devinfo->otp.module) + 1 +
> +                      strlen(devinfo->otp.vendor) + 1 +
> +                      strlen(devinfo->otp.version) + 1 +
> +                      strlen(devinfo->settings->antenna_sku) + 1);

NIH devm_kasprrintf() ?

> +               /* apple,shikoku */
> +               fwreq->board_types[5] = devinfo->settings->board_type;
> +
> +               buf = devm_kzalloc(&devinfo->pdev->dev, len, GFP_KERNEL);
> +
> +               strscpy(buf, devinfo->settings->board_type, len);
> +               strlcat(buf, "-", len);
> +               strlcat(buf, devinfo->settings->antenna_sku, len);
> +               /* apple,shikoku-X3 */
> +               fwreq->board_types[4] = devm_kstrdup(&devinfo->pdev->dev, buf,
> +                                                    GFP_KERNEL);
> +
> +               strscpy(buf, devinfo->settings->board_type, len);
> +               strlcat(buf, "-", len);
> +               strlcat(buf, devinfo->otp.module, len);
> +               /* apple,shikoku-RASP */
> +               fwreq->board_types[3] = devm_kstrdup(&devinfo->pdev->dev, buf,
> +                                                    GFP_KERNEL);
> +
> +               strlcat(buf, "-", len);
> +               strlcat(buf, devinfo->otp.vendor, len);
> +               /* apple,shikoku-RASP-m */
> +               fwreq->board_types[2] = devm_kstrdup(&devinfo->pdev->dev, buf,
> +                                                    GFP_KERNEL);
> +
> +               strlcat(buf, "-", len);
> +               strlcat(buf, devinfo->otp.version, len);
> +               /* apple,shikoku-RASP-m-6.11 */
> +               fwreq->board_types[1] = devm_kstrdup(&devinfo->pdev->dev, buf,
> +                                                    GFP_KERNEL);
> +
> +               strlcat(buf, "-", len);
> +               strlcat(buf, devinfo->settings->antenna_sku, len);
> +               /* apple,shikoku-RASP-m-6.11-X3 */
> +               fwreq->board_types[0] = buf;

-- 
With Best Regards,
Andy Shevchenko
