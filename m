Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 804DA483B7E
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 06:23:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229960AbiADFXL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 00:23:11 -0500
Received: from marcansoft.com ([212.63.210.85]:42784 "EHLO mail.marcansoft.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229577AbiADFXL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 Jan 2022 00:23:11 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (No client certificate requested)
        (Authenticated sender: marcan@marcan.st)
        by mail.marcansoft.com (Postfix) with ESMTPSA id 43A34419BC;
        Tue,  4 Jan 2022 05:22:59 +0000 (UTC)
Message-ID: <6343ce9e-9d9e-fde9-7242-5ec612438fa1@marcan.st>
Date:   Tue, 4 Jan 2022 14:22:57 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.4.1
Subject: Re: [PATCH 16/34] brcmfmac: acpi: Add support for fetching Apple ACPI
 properties
Content-Language: en-US
To:     Andy Shevchenko <andy.shevchenko@gmail.com>
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
        Sven Peter <sven@svenpeter.dev>,
        Alyssa Rosenzweig <alyssa@rosenzweig.io>,
        Mark Kettenis <kettenis@openbsd.org>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Hans de Goede <hdegoede@redhat.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        "brian m. carlson" <sandals@crustytoothpaste.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "brcm80211-dev-list.pdl@broadcom.com" 
        <brcm80211-dev-list.pdl@broadcom.com>,
        "SHA-cyfmac-dev-list@infineon.com" <SHA-cyfmac-dev-list@infineon.com>
References: <20211226153624.162281-1-marcan@marcan.st>
 <20211226153624.162281-17-marcan@marcan.st>
 <CAHp75VcZcJ+zCDL-J+w8gEeKXGYdJajjLoa1JTj_kkJixrV12Q@mail.gmail.com>
 <87cd5244-501d-1a3a-35d1-2687cf145bb9@marcan.st>
 <CAHp75Vedgs_zTH2O120jtUuQiuseA0VN62TJiJ7kAi1f5nDQ6Q@mail.gmail.com>
From:   Hector Martin <marcan@marcan.st>
In-Reply-To: <CAHp75Vedgs_zTH2O120jtUuQiuseA0VN62TJiJ7kAi1f5nDQ6Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022/01/04 7:50, Andy Shevchenko wrote:
>     >     +       status = acpi_evaluate_object(adev->handle, "RWCV",
>     NULL, &buf);
>     >     +       o = buf.pointer;
>     >     +       if (!ACPI_FAILURE(status) && o && o->type ==
>     ACPI_TYPE_BUFFER &&
>     >     +           o->buffer.length >= 2) {
>     >     +               char *antenna_sku = devm_kzalloc(dev, 3,
>     GFP_KERNEL);
>     >     +
>     >     +               memcpy(antenna_sku, o->buffer.pointer, 2);
>     >
>     >
>     > NIH devm_kmemdup()?
> 
>     Not *quite*. I take the first two bytes of the returned buffer and turn
>     them into a null-terminated 3-byte string. kmemdup wouldn't
>     null-terminate or would copy too much, depending on length.
> 
> 
> 
> devm_kstrndup() then?
> 
>  

That doesn't seem to be a thing.


-- 
Hector Martin (marcan@marcan.st)
Public Key: https://mrcn.st/pub
