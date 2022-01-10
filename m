Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C7B4489703
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 12:10:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244424AbiAJLJz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 06:09:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233981AbiAJLJz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jan 2022 06:09:55 -0500
Received: from mail.marcansoft.com (marcansoft.com [IPv6:2a01:298:fe:f::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09982C06173F;
        Mon, 10 Jan 2022 03:09:55 -0800 (PST)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (No client certificate requested)
        (Authenticated sender: marcan@marcan.st)
        by mail.marcansoft.com (Postfix) with ESMTPSA id 660093FA5E;
        Mon, 10 Jan 2022 11:09:44 +0000 (UTC)
Message-ID: <5785c77d-9746-4b3f-b1dc-63270a2b1e73@marcan.st>
Date:   Mon, 10 Jan 2022 20:09:42 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.4.1
Subject: Re: [PATCH v2 17/35] brcmfmac: pcie: Provide a buffer of random bytes
 to the device
Content-Language: en-US
To:     Arend van Spriel <arend.vanspriel@broadcom.com>,
        Kalle Valo <kvalo@codeaurora.org>,
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
        Dmitry Osipenko <digetx@gmail.com>
Cc:     Sven Peter <sven@svenpeter.dev>,
        Alyssa Rosenzweig <alyssa@rosenzweig.io>,
        Mark Kettenis <kettenis@openbsd.org>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Hans de Goede <hdegoede@redhat.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        "brian m. carlson" <sandals@crustytoothpaste.net>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com
References: <20220104072658.69756-1-marcan@marcan.st>
 <20220104072658.69756-18-marcan@marcan.st>
 <3844c03f-627b-8bf6-f526-8fda3e7892e0@broadcom.com>
From:   Hector Martin <marcan@marcan.st>
In-Reply-To: <3844c03f-627b-8bf6-f526-8fda3e7892e0@broadcom.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022/01/10 18:11, Arend van Spriel wrote:
> On 1/4/2022 8:26 AM, Hector Martin wrote:
>> Newer Apple firmwares on chipsets without a hardware RNG require the
>> host to provide a buffer of 256 random bytes to the device on
>> initialization. This buffer is present immediately before NVRAM,
>> suffixed by a footer containing a magic number and the buffer length.
>>
>> This won't affect chips/firmwares that do not use this feature, so do it
>> unconditionally.
> 
> Not sure what the general opinion is here, but pulling random bytes for 
> naught seems wasteful to me. So if there is a way of knowing it is 
> needed please make it conditional.

We could gate it on specific chips only, if you don't mind maintaining a
list of those. AIUI that would be all the T2 platform chips or so (the
newer two don't seem to need it).

Alternatively we could just do this only if an Apple OTP is detected.
That is already implicitly gated by the OTP offset chip list.

-- 
Hector Martin (marcan@marcan.st)
Public Key: https://mrcn.st/pub
