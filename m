Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BA174A4C87
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 17:53:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380641AbiAaQxs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 11:53:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232421AbiAaQxs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Jan 2022 11:53:48 -0500
Received: from mail.marcansoft.com (marcansoft.com [IPv6:2a01:298:fe:f::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7994C061714;
        Mon, 31 Jan 2022 08:53:47 -0800 (PST)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (No client certificate requested)
        (Authenticated sender: marcan@marcan.st)
        by mail.marcansoft.com (Postfix) with ESMTPSA id AFC5A419BC;
        Mon, 31 Jan 2022 16:53:38 +0000 (UTC)
Subject: Re: [PATCH v4 3/9] brcmfmac: firmware: Do not crash on a NULL
 board_type
To:     Kalle Valo <kvalo@kernel.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
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
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Stable <stable@vger.kernel.org>
References: <20220131160713.245637-1-marcan@marcan.st>
 <20220131160713.245637-4-marcan@marcan.st>
 <CAHp75VdgXdYXio8pTDdxsYy-iCXMvVpZM1T6gNmcxo3c1V+uJA@mail.gmail.com>
 <878ruvetpy.fsf@kernel.org>
From:   Hector Martin <marcan@marcan.st>
Message-ID: <c6e1bf98-55d6-1828-f19d-a3e13692da94@marcan.st>
Date:   Tue, 1 Feb 2022 01:53:36 +0900
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <878ruvetpy.fsf@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: es-ES
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 01/02/2022 01.49, Kalle Valo wrote:
> Andy Shevchenko <andy.shevchenko@gmail.com> writes:
> 
>> On Mon, Jan 31, 2022 at 6:07 PM Hector Martin <marcan@marcan.st> wrote:
>>>
>>> This unbreaks support for USB devices, which do not have a board_type
>>> to create an alt_path out of and thus were running into a NULL
>>> dereference.
>>
>> ...
>>
>>> @@ -599,6 +599,9 @@ static char *brcm_alt_fw_path(const char *path,
>>> const char *board_type)
>>>         char alt_path[BRCMF_FW_NAME_LEN];
>>>         char suffix[5];
>>>
>>> +       if (!board_type)
>>> +               return NULL;
>>
>> I still think it's better to have both callers do the same thing.
>>
>> Now it will be the double check in one case,
> 
> I already applied a similar patch:
> 
> https://git.kernel.org/wireless/wireless/c/665408f4c3a5
> 

Feel free to drop this one from the series then, if everything else
looks good.


-- 
Hector Martin (marcan@marcan.st)
Public Key: https://mrcn.st/pub
