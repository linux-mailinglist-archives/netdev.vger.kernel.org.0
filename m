Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C7DC482E5A
	for <lists+netdev@lfdr.de>; Mon,  3 Jan 2022 07:03:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230120AbiACGDh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jan 2022 01:03:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbiACGDg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jan 2022 01:03:36 -0500
Received: from mail.marcansoft.com (marcansoft.com [IPv6:2a01:298:fe:f::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C841EC061761;
        Sun,  2 Jan 2022 22:03:35 -0800 (PST)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (No client certificate requested)
        (Authenticated sender: marcan@marcan.st)
        by mail.marcansoft.com (Postfix) with ESMTPSA id A8608424D0;
        Mon,  3 Jan 2022 06:03:24 +0000 (UTC)
Message-ID: <fa19a8d2-f65d-c998-4c84-ae4d7736a681@marcan.st>
Date:   Mon, 3 Jan 2022 15:03:22 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.4.1
Subject: Re: [PATCH 16/34] brcmfmac: acpi: Add support for fetching Apple ACPI
 properties
Content-Language: en-US
To:     Linus Walleij <linus.walleij@linaro.org>
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
        Chung-hsien Hsu <chung-hsien.hsu@infineon.com>,
        Sven Peter <sven@svenpeter.dev>,
        Alyssa Rosenzweig <alyssa@rosenzweig.io>,
        Mark Kettenis <kettenis@openbsd.org>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Hans de Goede <hdegoede@redhat.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        "Daniel (Deognyoun) Kim" <dekim@broadcom.com>,
        "brian m. carlson" <sandals@crustytoothpaste.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com
References: <20211226153624.162281-1-marcan@marcan.st>
 <20211226153624.162281-17-marcan@marcan.st>
 <CACRpkdbWs=5s-5qZXoDOf+f-y=c6XZOGZb7w0LL7bDEJpnnVpw@mail.gmail.com>
From:   Hector Martin <marcan@marcan.st>
In-Reply-To: <CACRpkdbWs=5s-5qZXoDOf+f-y=c6XZOGZb7w0LL7bDEJpnnVpw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022/01/02 14:58, Linus Walleij wrote:
> On Sun, Dec 26, 2021 at 4:38 PM Hector Martin <marcan@marcan.st> wrote:
> 
>> On DT platforms, the module-instance and antenna-sku-info properties
>> are passed in the DT. On ACPI platforms, module-instance is passed via
>> the analogous Apple device property mechanism, while the antenna SKU
>> info is instead obtained via an ACPI method that grabs it from
>> non-volatile storage.
>>
>> Add support for this, to allow proper firmware selection on Apple
>> platforms.
>>
>> Signed-off-by: Hector Martin <marcan@marcan.st>
> 
> If the strings treated here are exactly the same as for the device tree,
> you should be able to just use "devprops" (firmware node) to handle it
> abstractly, and then the respective DT and ACPI backend will provide
> the properties.
> 
> I don't know if this patch I made recently is enough of an examples:
> https://lore.kernel.org/linux-hwmon/20211206020423.62402-2-linus.walleij@linaro.org/
> 
> If the ACPI and DT differs a lot in format and strings etc it may not
> be worth it.

It's not quite the same; module-instance is the same from macOS'
perspective, but we don't use Apple's device tree directly but rather
roll our own DT which uses a different property name in this case.
antenna-sku-info uses an ACPI method on x86, so that one is completely
different. So in the end nothing is actually shared.

-- 
Hector Martin (marcan@marcan.st)
Public Key: https://mrcn.st/pub
