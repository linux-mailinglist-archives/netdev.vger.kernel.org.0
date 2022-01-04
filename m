Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1243B4840CF
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 12:28:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232229AbiADL2W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 06:28:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229659AbiADL2V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jan 2022 06:28:21 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F579C061761;
        Tue,  4 Jan 2022 03:28:21 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id w16so147348104edc.11;
        Tue, 04 Jan 2022 03:28:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fk+MXdhGuxGANDnbKqaK+lUGLqXfEjiOKNpHt8IS6MQ=;
        b=Dcprum5t91/Ay0IRGUNY2s69hogkoCg7yq4NLMQ0qHu6f9p/4TaAhmoSfbCAYZt/kd
         q7dMH+W0DyS97h++oMVIhAabAjxlPIj2fqy4hkFKwf80Dr8D3I4InXuha958j+4vOlAQ
         jCOnBLSTPcUhiEbXtcYmjF0PTjoIQBiHH8V+52JBmkfCSVAB7po/2DXLiBSiJwlTAV1w
         RQluWIVrljR3h2qMOZO1LA1BsjPW3PZKeQknCVfOiyTVqNZcwi9JkO76XVpy8l50QETO
         7hLD3JcXt/7/raQLw0noV8EQnmGRQLyRpuVh0MvqkVHsoLBD7X5H+G5jtLZXVtr76cCs
         kJMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fk+MXdhGuxGANDnbKqaK+lUGLqXfEjiOKNpHt8IS6MQ=;
        b=dB402rkiZJLnMeUbMixSplAOGssH1vTTwAozD4DaVLsRFXJqRuENlPiu10c9SzRws4
         nDJgEUqM8as/sbHNB9XI6PH5bi5H4hkSddc69oCvkwgbB0mtI+T1ursqmFrL1SbhGMck
         j577qVxhsMHxySH37oGWCW1lDmcvw0s0ArkuYhhegguaTZjeJBapRyx0o/WavSPFXUFe
         vY5RLczQ4d6SruTGchIqYuVjnPjAbr/TeI9pwsiw9w18pMZwnu0YEvqK/FjTENG1CSvh
         kEq51+xqehvCG9dUMHBTVotbJF5KLUICuK7kKCau8xLqj0HR7gezgWMgIPEF20Ic+4TN
         b2cw==
X-Gm-Message-State: AOAM533EBJI8jV8Mptq7MBDu9cQA/IO/uelRnBDEz1z/XIMosTwbLY+r
        0kXTqgnBBkRxtQcEMrL7D8ctBtrcbWGKlM1NLpo=
X-Google-Smtp-Source: ABdhPJxs1Kj3XO7Y1IUz0dSzeatqT7wnZbxOMDc6kFWVOtHW24bzb4KeYsA+Q8QPmGmrfQcKk1MI+6CWEwq0aRkYXuw=
X-Received: by 2002:a05:6402:12c4:: with SMTP id k4mr46850463edx.218.1641295699714;
 Tue, 04 Jan 2022 03:28:19 -0800 (PST)
MIME-Version: 1.0
References: <20220104072658.69756-1-marcan@marcan.st> <20220104072658.69756-8-marcan@marcan.st>
In-Reply-To: <20220104072658.69756-8-marcan@marcan.st>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Tue, 4 Jan 2022 13:26:28 +0200
Message-ID: <CAHp75VcHjGAVog31AHaVLAq452=h=tqEN-1GNm_Aiu3113oTLA@mail.gmail.com>
Subject: Re: [PATCH v2 07/35] brcmfmac: pcie: Read Apple OTP information
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
> On Apple platforms, the One Time Programmable ROM in the Broadcom chips
> contains information about the specific board design (module, vendor,
> version) that is required to select the correct NVRAM file. Parse this
> OTP ROM and extract the required strings.
>
> Note that the user OTP offset/size is per-chip. This patch does not add
> any chips yet.

...

> +static int
> +brcmf_pcie_parse_otp_sys_vendor(struct brcmf_pciedev_info *devinfo,
> +                               u8 *data, size_t size)
> +{
> +       int idx = 4;

Can you rather have a structure

struct my_cool_and_strange_blob {
__le32 hdr;
const char ...[];
...
}

and then cast your data to this struct?

> +       const char *chip_params;
> +       const char *board_params;
> +       const char *p;
> +
> +       /* 4-byte header and two empty strings */
> +       if (size < 6)
> +               return -EINVAL;
> +
> +       if (get_unaligned_le32(data) != BRCMF_OTP_VENDOR_HDR)
> +               return -EINVAL;
> +
> +       chip_params = &data[idx];

> +       /* Skip first string, including terminator */
> +       idx += strnlen(chip_params, size - idx) + 1;

strsep() ?

> +       if (idx >= size)
> +               return -EINVAL;
> +
> +       board_params = &data[idx];
> +
> +       /* Skip to terminator of second string */
> +       idx += strnlen(board_params, size - idx);
> +       if (idx >= size)
> +               return -EINVAL;
> +
> +       /* At this point both strings are guaranteed NUL-terminated */
> +       brcmf_dbg(PCIE, "OTP: chip_params='%s' board_params='%s'\n",
> +                 chip_params, board_params);
> +
> +       p = board_params;
> +       while (*p) {
> +               char tag = *p++;
> +               const char *end;
> +               size_t len;
> +
> +               if (tag == ' ') /* Skip extra spaces */
> +                       continue;

skip_spaces()

> +
> +               if (*p++ != '=') /* implicit NUL check */
> +                       return -EINVAL;

Have you checked the next_arg() implementation?

> +               /* *p might be NUL here, if so end == p and len == 0 */
> +               end = strchrnul(p, ' ');
> +               len = end - p;
> +
> +               /* leave 1 byte for NUL in destination string */
> +               if (len > (BRCMF_OTP_MAX_PARAM_LEN - 1))
> +                       return -EINVAL;
> +
> +               /* Copy len characters plus a NUL terminator */
> +               switch (tag) {
> +               case 'M':
> +                       strscpy(devinfo->otp.module, p, len + 1);
> +                       break;
> +               case 'V':
> +                       strscpy(devinfo->otp.vendor, p, len + 1);
> +                       break;
> +               case 'm':
> +                       strscpy(devinfo->otp.version, p, len + 1);
> +                       break;
> +               }
> +
> +               /* Skip to space separator or NUL */
> +               p = end;
> +       }
> +
> +       brcmf_dbg(PCIE, "OTP: module=%s vendor=%s version=%s\n",
> +                 devinfo->otp.module, devinfo->otp.vendor,
> +                 devinfo->otp.version);
> +
> +       if (!devinfo->otp.module ||
> +           !devinfo->otp.vendor ||
> +           !devinfo->otp.version)
> +               return -EINVAL;
> +
> +       devinfo->otp.valid = true;
> +       return 0;
> +}
> +
> +static int
> +brcmf_pcie_parse_otp(struct brcmf_pciedev_info *devinfo, u8 *otp, size_t size)
> +{
> +       int p = 0;

> +       int ret = -1;

Use proper error codes.

> +       brcmf_dbg(PCIE, "parse_otp size=%ld\n", size);
> +
> +       while (p < (size - 1)) {

too many parentheses

> +               u8 type = otp[p];
> +               u8 length = otp[p + 1];
> +
> +               if (type == 0)
> +                       break;
> +
> +               if ((p + 2 + length) > size)
> +                       break;
> +
> +               switch (type) {
> +               case BRCMF_OTP_SYS_VENDOR:
> +                       brcmf_dbg(PCIE, "OTP @ 0x%x (0x%x): SYS_VENDOR\n",

length as hex a bit harder to parse

> +                                 p, length);
> +                       ret = brcmf_pcie_parse_otp_sys_vendor(devinfo,
> +                                                             &otp[p + 2],
> +                                                             length);
> +                       break;
> +               case BRCMF_OTP_BRCM_CIS:
> +                       brcmf_dbg(PCIE, "OTP @ 0x%x (0x%x): BRCM_CIS\n",
> +                                 p, length);
> +                       break;
> +               default:
> +                       brcmf_dbg(PCIE, "OTP @ 0x%x (0x%x): Unknown type 0x%x\n",
> +                                 p, length, type);
> +                       break;
> +               }

> +               p += 2 + length;


length + 2 is easier to read.

> +       }
> +
> +       return ret;
> +}

...

> +               /* Map OTP to shadow area */
> +               WRITECC32(devinfo, sromcontrol,
> +                         sromctl | BCMA_CC_SROM_CONTROL_OTPSEL);

One line?

...

> +       otp = kzalloc(sizeof(u16) * words, GFP_KERNEL);

No check, why? I see in many places you forgot to check for NULL from
allocator functions.
Moreover here you should use kcalloc() which does overflow protection.

-- 
With Best Regards,
Andy Shevchenko
