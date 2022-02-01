Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D7634A5613
	for <lists+netdev@lfdr.de>; Tue,  1 Feb 2022 06:13:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233533AbiBAFNM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 00:13:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231557AbiBAFNL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Feb 2022 00:13:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61F7EC061714;
        Mon, 31 Jan 2022 21:13:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 30097B82CEF;
        Tue,  1 Feb 2022 05:13:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1BF4C340EB;
        Tue,  1 Feb 2022 05:13:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643692388;
        bh=Xb8CZdOTSWjrdt4EdYttNizm/lliup2LcALWMFNFeBs=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=W9gSO+ja/SWl0WUmOCdWNYXXqb5xtHHQYJAmVZUWbkk+Yyudzgbk6i94T/IdLDWBU
         Pz0Wa/Ibw2xRJBgAwbCSgsP4jNHeqG8UwtjED+37Iigo/iE+/xeUcDYA5150rD8ak7
         nlIJDEzlWbIQlgCa4kkJT/YXYHKfN1URBsEgjgagNIcXX7NyDuelIEpLHnqRYTcbw6
         +nWFqCxSBR5W39wCY6SHLjY4uO2/uqTnURBkWm/KzIs2oL346EjttogVoQFo6wSGLi
         jxCDH4mcVWEhIMszPvz4g1GzGtOHNdTsljEHqVAT0+oYGaOnXqUPRCR5bI4rBZPvag
         WjLuhYauXIDzw==
From:   Kalle Valo <kvalo@kernel.org>
To:     Hector Martin <marcan@marcan.st>
Cc:     Andy Shevchenko <andy.shevchenko@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
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
        =?utf-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Hans de Goede <hdegoede@redhat.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        "brian m. carlson" <sandals@crustytoothpaste.net>,
        "open list\:TI WILINK WIRELES..." <linux-wireless@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        devicetree <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        "open list\:BROADCOM BRCM80211 IEEE802.11n WIRELESS DRIVER" 
        <brcm80211-dev-list.pdl@broadcom.com>,
        SHA-cyfmac-dev-list@infineon.com,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Stable <stable@vger.kernel.org>
Subject: Re: [PATCH v4 3/9] brcmfmac: firmware: Do not crash on a NULL board_type
In-Reply-To: <c6e1bf98-55d6-1828-f19d-a3e13692da94@marcan.st> (Hector Martin's
        message of "Tue, 1 Feb 2022 01:53:36 +0900")
References: <20220131160713.245637-1-marcan@marcan.st>
        <20220131160713.245637-4-marcan@marcan.st>
        <CAHp75VdgXdYXio8pTDdxsYy-iCXMvVpZM1T6gNmcxo3c1V+uJA@mail.gmail.com>
        <878ruvetpy.fsf@kernel.org>
        <c6e1bf98-55d6-1828-f19d-a3e13692da94@marcan.st>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
Date:   Tue, 01 Feb 2022 07:12:57 +0200
Message-ID: <8735l3dvae.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hector Martin <marcan@marcan.st> writes:

> On 01/02/2022 01.49, Kalle Valo wrote:
>> Andy Shevchenko <andy.shevchenko@gmail.com> writes:
>> 
>>> On Mon, Jan 31, 2022 at 6:07 PM Hector Martin <marcan@marcan.st> wrote:
>>>>
>>>> This unbreaks support for USB devices, which do not have a board_type
>>>> to create an alt_path out of and thus were running into a NULL
>>>> dereference.
>>>
>>> ...
>>>
>>>> @@ -599,6 +599,9 @@ static char *brcm_alt_fw_path(const char *path,
>>>> const char *board_type)
>>>>         char alt_path[BRCMF_FW_NAME_LEN];
>>>>         char suffix[5];
>>>>
>>>> +       if (!board_type)
>>>> +               return NULL;
>>>
>>> I still think it's better to have both callers do the same thing.
>>>
>>> Now it will be the double check in one case,
>> 
>> I already applied a similar patch:
>> 
>> https://git.kernel.org/wireless/wireless/c/665408f4c3a5
>> 
>
> Feel free to drop this one from the series then, if everything else
> looks good.

Yes, I'll drop this patch 3.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
