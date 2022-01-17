Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE9C849020E
	for <lists+netdev@lfdr.de>; Mon, 17 Jan 2022 07:39:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234761AbiAQGjL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 01:39:11 -0500
Received: from marcansoft.com ([212.63.210.85]:52262 "EHLO mail.marcansoft.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231189AbiAQGjL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 Jan 2022 01:39:11 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (No client certificate requested)
        (Authenticated sender: marcan@marcan.st)
        by mail.marcansoft.com (Postfix) with ESMTPSA id 6C9773FA5E;
        Mon, 17 Jan 2022 06:39:01 +0000 (UTC)
Subject: Re: [PATCH v2 10/35] brcmfmac: firmware: Allow platform to override
 macaddr
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
 <20220104072658.69756-11-marcan@marcan.st>
 <199f0a6d-f80d-1600-842d-44fba9b7d5fc@broadcom.com>
From:   Hector Martin <marcan@marcan.st>
Message-ID: <ef7e23e3-ebbf-090c-f571-6993dac2d01d@marcan.st>
Date:   Mon, 17 Jan 2022 15:38:59 +0900
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <199f0a6d-f80d-1600-842d-44fba9b7d5fc@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Language: es-ES
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 09/01/2022 05.14, Arend van Spriel wrote:
> On 1/4/2022 8:26 AM, Hector Martin wrote:
>> On Device Tree platforms, it is customary to be able to set the MAC
>> address via the Device Tree, as it is often stored in system firmware.
>> This is particularly relevant for Apple ARM64 platforms, where this
>> information comes from system configuration and passed through by the
>> bootloader into the DT.
>>
>> Implement support for this by fetching the platform MAC address and
>> adding or replacing the macaddr= property in nvram. This becomes the
>> dongle's default MAC address.
>>
>> On platforms with an SROM MAC address, this overrides it. On platforms
>> without one, such as Apple ARM64 devices, this is required for the
>> firmware to boot (it will fail if it does not have a valid MAC at all).
> 
> What overrides what. Can you elaborate a bit?

The behavior seems to be:

- Use the NVRAM MAC address, if any
- Use the SROM MAC address, if any
- Fail to boot

So a platform with a module containing a MAC address may choose to
override it using the DT mechanism with this patch. This is consistent
with the behavior of other drivers implementing platform MAC support.

-- 
Hector Martin (marcan@marcan.st)
Public Key: https://mrcn.st/pub
