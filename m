Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11F5E4864FA
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 14:11:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239309AbiAFNK6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 08:10:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238990AbiAFNK5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jan 2022 08:10:57 -0500
Received: from mail.marcansoft.com (marcansoft.com [IPv6:2a01:298:fe:f::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5338EC061245;
        Thu,  6 Jan 2022 05:10:57 -0800 (PST)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (No client certificate requested)
        (Authenticated sender: marcan@marcan.st)
        by mail.marcansoft.com (Postfix) with ESMTPSA id D8F9341F5D;
        Thu,  6 Jan 2022 13:10:47 +0000 (UTC)
Subject: Re: [PATCH v2 12/35] brcmfmac: pcie: Fix crashes due to early IRQs
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
References: <20220104072658.69756-1-marcan@marcan.st>
 <20220104072658.69756-13-marcan@marcan.st>
 <CAHp75VdeNhmRUW1mFY-H5vyzTRHZ9Y2dv03eo+rfcTQKjn9tuQ@mail.gmail.com>
From:   Hector Martin <marcan@marcan.st>
Message-ID: <759f46bd-bfc2-62c6-6257-a2a0d702e2b6@marcan.st>
Date:   Thu, 6 Jan 2022 22:10:45 +0900
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <CAHp75VdeNhmRUW1mFY-H5vyzTRHZ9Y2dv03eo+rfcTQKjn9tuQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: es-ES
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 04/01/2022 23.12, Andy Shevchenko wrote:
> On Tue, Jan 4, 2022 at 9:29 AM Hector Martin <marcan@marcan.st> wrote:
>>
>> The driver was enabling IRQs before the message processing was
>> initialized. This could cause IRQs to come in too early and crash the
>> driver. Instead, move the IRQ enable and hostready to a bus preinit
>> function, at which point everything is properly initialized.
>>
>> Fixes: 9e37f045d5e7 ("brcmfmac: Adding PCIe bus layer support.")
> 
> You should gather fixes at the beginning of the series, and even
> possible to send them as a separate series. In the current state it's
> unclear if there are dependencies on your new feature (must not be for
> fixes that meant to be backported).
> 

Thanks, I wasn't sure what order you wanted those in. I'll put them at
the top for v3. I think none of those should have any dependencies on
the rest of the patches, modulo some trivial rebase wrangling.

-- 
Hector Martin (marcan@marcan.st)
Public Key: https://mrcn.st/pub
