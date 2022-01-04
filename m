Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60B5E48434D
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 15:25:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234109AbiADOZe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 09:25:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230407AbiADOZe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jan 2022 09:25:34 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C385C061761;
        Tue,  4 Jan 2022 06:25:33 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id bm14so149174958edb.5;
        Tue, 04 Jan 2022 06:25:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=h/xsPDoEcdc8p+a2+2Nq0a9K/MB4RnvUnz4O8aVYj9w=;
        b=Ox+u+qWFtGv8ci/9UGweISjg+4vOgLw0odlNwfHv/kEji7z5TX3ILBuWzMElTLNjMl
         5waqr9ikteP/GSkKy8qOEN9po8WWqAa2spWKEY/iyeZuj+t5Oc54Fb3AyLhUxxrsv4DC
         ByR5oSJNfAJkz/hO5wUr6r8pk+a1uYaJeKdYzkpwXFFTO6vROSZ7dccGBXTJMHrBsU8h
         n41/hG3nOaX12dUGHHUhYDouTvCRyilj94ACaEJqgpzpNA8rcZzd9hxzWPHy3Mmr7Maw
         Xf60336M2OaFarnqojl9GkqU+KmSW+4KIKr6lFBBGaa9d3NkZUQ6Tr7Qpf10UgELaRnE
         BcMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=h/xsPDoEcdc8p+a2+2Nq0a9K/MB4RnvUnz4O8aVYj9w=;
        b=Ns1WRIQ/C94JPLRHYW4xxN3DYL4aWpHf6nt9fRTYWIM2PiSlloRm4GIjrSVEcddncb
         ynmbCvPCF69izZjxNY54WRcCSbzVPlHcdWJTXLqDxVKQ8TRBqbmXfhNtkzG9Im3EU5Vw
         Lt9IERYcdSGoqhDMPr+axSyqN4/ZsYZwwd610haYq5w5H7kWakwsQoVvKpqU+/7ArqjY
         JyFcf+mah3+9R3RZI2mjfhnt/iLXdKHvIy86bvRqI9Rkd5+tOIFsJ1r/gmkjqannNAk0
         4biWQnVclQRvV7YJKQftJ/GorpT52ck/2Z05z1ggro/XYdBCgS5vWsl9Wz+psP66ronz
         kSDQ==
X-Gm-Message-State: AOAM530T1e8SixDtlceQxJhMA1hhuGxO0vNuJ9lflWApdzZyRu17LPhe
        tPZCtymUC61AOxNvfKBHkDpYnSwmV2kqxOJQPis=
X-Google-Smtp-Source: ABdhPJyhWk1M4H+Ejgocc/F6WkSUU5agz/5nH5rtRvQMm3uPfNGst3b/OoKQScD1ixZN3hrlEeTNQbeE2ojF5S1AZDo=
X-Received: by 2002:a05:6402:518a:: with SMTP id q10mr45851875edd.29.1641306332169;
 Tue, 04 Jan 2022 06:25:32 -0800 (PST)
MIME-Version: 1.0
References: <20220104072658.69756-1-marcan@marcan.st> <20220104072658.69756-11-marcan@marcan.st>
In-Reply-To: <20220104072658.69756-11-marcan@marcan.st>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Tue, 4 Jan 2022 16:23:41 +0200
Message-ID: <CAHp75VcU1vVSucvegmSiMLoKBoPoGW5XLmqVUG0vXGdeafm2Jw@mail.gmail.com>
Subject: Re: [PATCH v2 10/35] brcmfmac: firmware: Allow platform to override macaddr
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

On Tue, Jan 4, 2022 at 9:29 AM Hector Martin <marcan@marcan.st> wrote:
>
> On Device Tree platforms, it is customary to be able to set the MAC
> address via the Device Tree, as it is often stored in system firmware.
> This is particularly relevant for Apple ARM64 platforms, where this
> information comes from system configuration and passed through by the
> bootloader into the DT.
>
> Implement support for this by fetching the platform MAC address and
> adding or replacing the macaddr= property in nvram. This becomes the
> dongle's default MAC address.
>
> On platforms with an SROM MAC address, this overrides it. On platforms
> without one, such as Apple ARM64 devices, this is required for the
> firmware to boot (it will fail if it does not have a valid MAC at all).

...

> +#define BRCMF_FW_MACADDR_FMT                   "macaddr=%pM"
> +#define BRCMF_FW_MACADDR_LEN                   (7 + ETH_ALEN * 3)

...

>                 if (strncmp(&nvp->data[nvp->entry], "boardrev", 8) == 0)
>                         nvp->boardrev_found = true;
> +               /* strip macaddr if platform MAC overrides */
> +               if (nvp->strip_mac &&
> +                   strncmp(&nvp->data[nvp->entry], "macaddr", 7) == 0)

If it has no side effects, I would rather swap the operands of && so
you match string first (it will be in align with above code at least,
although I haven't checked bigger context).

....

> +static void brcmf_fw_add_macaddr(struct nvram_parser *nvp, u8 *mac)
> +{
> +       snprintf(&nvp->nvram[nvp->nvram_len], BRCMF_FW_MACADDR_LEN + 1,
> +                BRCMF_FW_MACADDR_FMT, mac);

Please, avoid using implict format string, it's dangerous from security p.o.v.

> +       nvp->nvram_len += BRCMF_FW_MACADDR_LEN + 1;

Also, with temporary variable the code can be better to read

size_t mac_len = ...;

> +}

-- 
With Best Regards,
Andy Shevchenko
