Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E9D24A4C73
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 17:49:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380625AbiAaQtf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 11:49:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380616AbiAaQtX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Jan 2022 11:49:23 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47B63C061714;
        Mon, 31 Jan 2022 08:49:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DA99060B58;
        Mon, 31 Jan 2022 16:49:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 132DCC340E8;
        Mon, 31 Jan 2022 16:49:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643647762;
        bh=jSlR0Ku6H+5Q0glrHsE2hxMaoDdNYeF1Plc8PvJ9Jr0=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=HEX1WXp8CNmeczzTfusuIZoaGOayKsUt+uKdCfEHP1G3UsjfmqaEygGMQSStRtIJ7
         ROVShGUIrG7cx9al6RxoXKP81ryXJ0Sng7rco+WDGZNuuTrgQ4aWgkoNFaQBeOlC+L
         gd3hy2Kw4Iq3i8dJonI0Li2bkMaBe8tsZ1jnheGDye3e3pac1Xq+sPkAgjzDgXwpxj
         EFPX6fLd4r3nXHInuY+RqvCcrTHPF7ogPgVeIPQs420YonZGK1yPOkszzbus9inIwt
         r2hhboInvPHCaEZs7ZbhyPiesmWBNJTHDg7MuTcYlvVOpUf0lbpvU0aeGdYDmcsI8O
         MFTwMRgrFDTGg==
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
References: <20220131160713.245637-1-marcan@marcan.st>
        <20220131160713.245637-4-marcan@marcan.st>
        <CAHp75VdgXdYXio8pTDdxsYy-iCXMvVpZM1T6gNmcxo3c1V+uJA@mail.gmail.com>
Date:   Mon, 31 Jan 2022 18:49:13 +0200
In-Reply-To: <CAHp75VdgXdYXio8pTDdxsYy-iCXMvVpZM1T6gNmcxo3c1V+uJA@mail.gmail.com>
        (Andy Shevchenko's message of "Mon, 31 Jan 2022 18:28:25 +0200")
Message-ID: <878ruvetpy.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andy Shevchenko <andy.shevchenko@gmail.com> writes:

> On Mon, Jan 31, 2022 at 6:07 PM Hector Martin <marcan@marcan.st> wrote:
>>
>> This unbreaks support for USB devices, which do not have a board_type
>> to create an alt_path out of and thus were running into a NULL
>> dereference.
>
> ...
>
>> @@ -599,6 +599,9 @@ static char *brcm_alt_fw_path(const char *path,
>> const char *board_type)
>>         char alt_path[BRCMF_FW_NAME_LEN];
>>         char suffix[5];
>>
>> +       if (!board_type)
>> +               return NULL;
>
> I still think it's better to have both callers do the same thing.
>
> Now it will be the double check in one case,

I already applied a similar patch:

https://git.kernel.org/wireless/wireless/c/665408f4c3a5

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
