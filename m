Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B12484895DF
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 10:59:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243528AbiAJJ74 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 04:59:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243577AbiAJJ7n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jan 2022 04:59:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0F77C061751;
        Mon, 10 Jan 2022 01:59:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 743FB6123D;
        Mon, 10 Jan 2022 09:59:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F9EFC36AED;
        Mon, 10 Jan 2022 09:59:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641808781;
        bh=9Ee0ff4Qp1c7d4QxMmb6qnqRRmqMvh/DUDbTOfKY4gU=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=du8UeFOKDrGkuHEFUi+BTHuDP2crO5/CdmhSu0A0wtqwe2vRb+BRtm6ZTc8j/vVZN
         Njhf2M2b+To4bLKP4F/rk7lrv0vqaAO3LPIOCo0QXyPYjgMnUpJ0lz+0/6I5og3Iit
         /e/5B9k5IR0cou7OfrBX8t7WZiIIdkhsoD9u6eGUJVZS2Bs6dmiVFl2ArpYO5MtIFX
         XkSH0q6E19DoUlP36FzMQNyifP8BuR4OGWOrsrQ0/nS5cDkyox5Sf0iWxOnVPvVkyh
         fLk1E7i72OUC8r+UPVnSIXjM3gVftuoSVRgqAqPpa2QqdW8Ogpya5TA6Gp0pPNC6im
         Xtltb1msfN6OQ==
From:   Kalle Valo <kvalo@kernel.org>
To:     Andy Shevchenko <andy.shevchenko@gmail.com>
Cc:     Hector Martin <marcan@marcan.st>,
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
        Chung-hsien Hsu <chung-hsien.hsu@infineon.com>,
        Sven Peter <sven@svenpeter.dev>,
        Alyssa Rosenzweig <alyssa@rosenzweig.io>,
        Mark Kettenis <kettenis@openbsd.org>,
        =?utf-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Hans de Goede <hdegoede@redhat.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        "Daniel \(Deognyoun\) Kim" <dekim@broadcom.com>,
        "brian m. carlson" <sandals@crustytoothpaste.net>,
        "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev\@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree\@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi\@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "brcm80211-dev-list.pdl\@broadcom.com" 
        <brcm80211-dev-list.pdl@broadcom.com>,
        "SHA-cyfmac-dev-list\@infineon.com" 
        <SHA-cyfmac-dev-list@infineon.com>
Subject: Re: [PATCH 16/34] brcmfmac: acpi: Add support for fetching Apple ACPI properties
References: <20211226153624.162281-1-marcan@marcan.st>
        <20211226153624.162281-17-marcan@marcan.st>
        <CAHp75VcZcJ+zCDL-J+w8gEeKXGYdJajjLoa1JTj_kkJixrV12Q@mail.gmail.com>
Date:   Mon, 10 Jan 2022 11:59:31 +0200
In-Reply-To: <CAHp75VcZcJ+zCDL-J+w8gEeKXGYdJajjLoa1JTj_kkJixrV12Q@mail.gmail.com>
        (Andy Shevchenko's message of "Mon, 3 Jan 2022 18:20:47 +0200")
Message-ID: <87y23nvrlo.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andy Shevchenko <andy.shevchenko@gmail.com> writes:

> On Sunday, December 26, 2021, Hector Martin <marcan@marcan.st> wrote:
>
>  On DT platforms, the module-instance and antenna-sku-info properties
>  are passed in the DT. On ACPI platforms, module-instance is passed via
>  the analogous Apple device property mechanism, while the antenna SKU
>  info is instead obtained via an ACPI method that grabs it from
>  non-volatile storage.
>
>  Add support for this, to allow proper firmware selection on Apple
>  platforms.
>
>  Signed-off-by: Hector Martin <marcan@marcan.st>
>  ---
>   .../broadcom/brcm80211/brcmfmac/Makefile      |  2 +
>   .../broadcom/brcm80211/brcmfmac/acpi.c        | 51 +++++++++++++++++++
>   .../broadcom/brcm80211/brcmfmac/common.c      |  1 +
>   .../broadcom/brcm80211/brcmfmac/common.h      |  9 ++++
>   4 files changed, 63 insertions(+)
>   create mode 100644 drivers/net/wireless/broadcom/brcm80211/brcmfmac/acpi.c
>
>  diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/Makefile
>  b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/Makefile
>  index 13c13504a6e8..19009eb9db93 100644
>  --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/Makefile
>  +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/Makefile
>  @@ -47,3 +47,5 @@ brcmfmac-$(CONFIG_OF) += \
>                  of.o
>   brcmfmac-$(CONFIG_DMI) += \
>                  dmi.o
>  +brcmfmac-$(CONFIG_ACPI) += \
>  +               acpi.o
>  diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/acpi.c
>  b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/acpi.c
>  new file mode 100644
>  index 000000000000..3e56dc7a8db2
>  --- /dev/null
>  +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/acpi.c
>  @@ -0,0 +1,51 @@
>  +// SPDX-License-Identifier: ISC
>  +/*
>  + * Copyright The Asahi Linux Contributors
>  + */
>  +
>  +#include <linux/acpi.h>
>  +#include "debug.h"
>  +#include "core.h"
>  +#include "common.h"
>  +
>  +void brcmf_acpi_probe(struct device *dev, enum brcmf_bus_type bus_type,
>  +                     struct brcmf_mp_device *settings)
>  +{
>  +       acpi_status status;
>  +       struct acpi_device *adev = ACPI_COMPANION(dev);
>
> Please, move the assignment closer to its first user 

Andy, your email was formatted in HTML. I'm sure you know this already,
but our mailing lists drop all HTML emails so other people (and
patchwork) don't see your comments.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
