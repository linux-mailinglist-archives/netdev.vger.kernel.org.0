Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3BC4494276
	for <lists+netdev@lfdr.de>; Wed, 19 Jan 2022 22:22:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357399AbiASVWr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jan 2022 16:22:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229675AbiASVWr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jan 2022 16:22:47 -0500
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0F79C061574;
        Wed, 19 Jan 2022 13:22:46 -0800 (PST)
Received: by mail-lf1-x132.google.com with SMTP id o15so13370277lfo.11;
        Wed, 19 Jan 2022 13:22:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=8xNKNi1LRojJeVt1Nef5G921Lvb9Zw/m0g+80h/uJSo=;
        b=SkamCFGOsuq/rDEk6pV84f1GSUdxKbi/UN0kRg5ytrVxjwIC4oXlo8DKtUipEQtCmf
         as4pwgaaAHm1qbd/ypGFAx0WQb0exzSaNGUtVp5IH45Sct0tUnHMH+x6w3x7lfvpMVQG
         AgL3OtR+fxlelKv8GwmgK6mqB5CK6DVVscl6/yy7M0qpPiotY/zc2o0bygCJmGQ8s1nC
         +/ZbvZz6Kza/T3UxsFF9/5SYdDBgxWtM9pZ9NIxSPvK0uDEk1m1k7uYablP3L0Fc9R7Y
         qX1JMjDCkJghd8VQC+i25BZ3B32Yxht+JP9mi2fS7A17PA+9ghFn6gCloaTWmd2bVC0t
         /XvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=8xNKNi1LRojJeVt1Nef5G921Lvb9Zw/m0g+80h/uJSo=;
        b=ydydbfARIBgfcs8Jh7K0qjF269g9GLaubN8UNkrI3U9nKT/1nznUDLYYj9anWzunM8
         kNyet0FB7jCTQJ88+NeEu9H6ad+DYP41xKlOpzOzFPCSjkCHikUgFXmPNwchbGlXokVH
         RtgaGqDPW4x37ZW04TaQ2+e1YXqD/TjyhV2O/0aAYz+MAS63BvfaO+URUj3kFcbgkW+g
         3dkUt30mqyaP6nl88Rq5z1loypwqDRgx7JRpAH7U+9QCJ52/3Q3rBHm+Wcm6yp/i2gsP
         ptAZC/pYP12flRtqH7Xss4epQyL7Ydt6LbZcE282eV2owTbN7fResG2CkREG0qf8yLQ0
         9xYw==
X-Gm-Message-State: AOAM531E/Ey+f/H0UaUYkbF9x+HuR9tAWbkzceiKP8gBbnxawNfLNtHh
        yz1Mkm9I/k/WkYFEmW5FXn0=
X-Google-Smtp-Source: ABdhPJweVJly6NKb6ZA2lRyT41+I8V+ACkOYJ06Lwz1sNGgqOMsF0TizWnjd5oSUTYkzqgxJHcOlGg==
X-Received: by 2002:ac2:518c:: with SMTP id u12mr30171416lfi.299.1642627365178;
        Wed, 19 Jan 2022 13:22:45 -0800 (PST)
Received: from [192.168.2.145] (109-252-139-36.dynamic.spd-mgts.ru. [109.252.139.36])
        by smtp.googlemail.com with ESMTPSA id m17sm78789lfc.130.2022.01.19.13.22.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Jan 2022 13:22:44 -0800 (PST)
Message-ID: <9a222199-6620-15b7-395f-e079b8e6e529@gmail.com>
Date:   Thu, 20 Jan 2022 00:22:43 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v3 1/9] brcmfmac: pcie: Release firmwares in the
 brcmf_pcie_setup error path
Content-Language: en-US
To:     Andy Shevchenko <andy.shevchenko@gmail.com>,
        Hector Martin <marcan@marcan.st>
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
        "open list:TI WILINK WIRELES..." <linux-wireless@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        devicetree <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        "open list:BROADCOM BRCM80211 IEEE802.11n WIRELESS DRIVER" 
        <brcm80211-dev-list.pdl@broadcom.com>,
        SHA-cyfmac-dev-list@infineon.com
References: <20220117142919.207370-1-marcan@marcan.st>
 <20220117142919.207370-2-marcan@marcan.st>
 <CAHp75VfVuX-BG1MJcEoQrOW6jn=PSMZH0jTcwGj9PwWxocG_Gw@mail.gmail.com>
From:   Dmitry Osipenko <digetx@gmail.com>
In-Reply-To: <CAHp75VfVuX-BG1MJcEoQrOW6jn=PSMZH0jTcwGj9PwWxocG_Gw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

19.01.2022 20:49, Andy Shevchenko пишет:
> On Mon, Jan 17, 2022 at 4:30 PM Hector Martin <marcan@marcan.st> wrote:
>>
>> This avoids leaking memory if brcmf_chip_get_raminfo fails. Note that
>> the CLM blob is released in the device remove path.
> 
> ...
> 
>>         if (ret) {
> 
>>                 brcmf_err(bus, "Failed to get RAM info\n");
>> +               release_firmware(fw);
>> +               brcmf_fw_nvram_free(nvram);
> 
> Can we first undo the things and only after print a message?

Having message first usually is more preferred because at minimum you'll
get the message if "undoing the things" crashes, i.e. will be more
obvious what happened.
