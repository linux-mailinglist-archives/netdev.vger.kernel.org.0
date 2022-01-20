Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23D5C494EB4
	for <lists+netdev@lfdr.de>; Thu, 20 Jan 2022 14:15:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359680AbiATNP1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jan 2022 08:15:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359583AbiATNP0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jan 2022 08:15:26 -0500
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFB91C061574;
        Thu, 20 Jan 2022 05:15:25 -0800 (PST)
Received: by mail-lf1-x131.google.com with SMTP id p27so21587731lfa.1;
        Thu, 20 Jan 2022 05:15:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=Z8T4ODCid5Vg8gPhZXOgJAmkKij4UIWo8oSKzIeZ2Ac=;
        b=YzlNFN3Tid4qpfZ4OzWnS5ZqKpoA6cMhAbaJXB9KrFeNuxk9gHzSVPsF8kOAzNU2Cd
         ABRLnxcmKOZMNqC2D0kM8WzJZDk1rZ3OYs9TDwiR08rvBYcxKwOMuplhUmtwlavyBQU3
         kQXSLI/CT0GYUT3tsQnhGf2+DH1otcOt55wymvj35ybfKD6IhC/oqvDfYPIdAozS0M2A
         vdN1Mfdwz6msgIoT5O02PagbD3goD43WPQLM7bn+gkXAvfsH6M62W7OdFgd0EE0rKoPg
         m+yS7xH9IUUerW7dlRglLzj08EZa4C68Kc6KyxTw1YcZGqvY4SnoeRjvmzCYUwtA06lc
         hijw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Z8T4ODCid5Vg8gPhZXOgJAmkKij4UIWo8oSKzIeZ2Ac=;
        b=q1swfJxsyf8Lff/8KU57hRdPmZhzWp3y5Z37xlHg//qo8ZBHQmE7VmuPuD3N2yFQnI
         G31pzBg3plY+JTyZl0GEb9vX7VWaBOG1889OxkFXWrmGhtrWcequ0KvswGw2AmMKMpsp
         0O8VX69iKbWDJrpjM868cGtbQRy+m9t8L5wVEmDUYTcH2IKCdZRMSHvThCqCwqCHYGZs
         fllwUT7UCVjipVy88DyO5dqYePbh9XdtmXYoAN/rKs0ewP2rJ7f4Q+rrHA3kfI+Bct/K
         iRSZMnN+ZU6aux8PZOuGK5jlYgBfcQP/4Me61Y1WtP/MX2DwkSNlaaQYBv8/Bu4848Ga
         gaew==
X-Gm-Message-State: AOAM530fKS7475CS5kg5oWDGBnwGxyRx62PBJpHEcsg9yFpLyJYy6hZe
        kfqmCSi6bRFmua8gpVG/yKU=
X-Google-Smtp-Source: ABdhPJycfCNrik94+hanjb71FiMe5oe1rEjXxkRErg+pWgi5Cabbu2OB2VF8HCGDq4zAfVtsnoJ1iA==
X-Received: by 2002:a05:6512:2606:: with SMTP id bt6mr32394264lfb.202.1642684524235;
        Thu, 20 Jan 2022 05:15:24 -0800 (PST)
Received: from [192.168.2.145] (109-252-139-36.dynamic.spd-mgts.ru. [109.252.139.36])
        by smtp.googlemail.com with ESMTPSA id m4sm21357lfq.204.2022.01.20.05.15.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Jan 2022 05:15:23 -0800 (PST)
Message-ID: <5807426a-70e5-4513-53bf-c98e74daf42f@gmail.com>
Date:   Thu, 20 Jan 2022 16:15:22 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v3 1/9] brcmfmac: pcie: Release firmwares in the
 brcmf_pcie_setup error path
Content-Language: en-US
To:     Andy Shevchenko <andy.shevchenko@gmail.com>
Cc:     Hector Martin <marcan@marcan.st>,
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
 <9a222199-6620-15b7-395f-e079b8e6e529@gmail.com>
 <CAHp75VdY1gNzVFNneEexEivx1RL_MiX8HxgHoFFd9TN8vXgGLQ@mail.gmail.com>
From:   Dmitry Osipenko <digetx@gmail.com>
In-Reply-To: <CAHp75VdY1gNzVFNneEexEivx1RL_MiX8HxgHoFFd9TN8vXgGLQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

20.01.2022 00:31, Andy Shevchenko пишет:
> On Wed, Jan 19, 2022 at 11:22 PM Dmitry Osipenko <digetx@gmail.com> wrote:
>>
>> 19.01.2022 20:49, Andy Shevchenko пишет:
>>> On Mon, Jan 17, 2022 at 4:30 PM Hector Martin <marcan@marcan.st> wrote:
>>>>
>>>> This avoids leaking memory if brcmf_chip_get_raminfo fails. Note that
>>>> the CLM blob is released in the device remove path.
>>>
>>> ...
>>>
>>>>         if (ret) {
>>>
>>>>                 brcmf_err(bus, "Failed to get RAM info\n");
>>>> +               release_firmware(fw);
>>>> +               brcmf_fw_nvram_free(nvram);
>>>
>>> Can we first undo the things and only after print a message?
>>
>> Having message first usually is more preferred because at minimum you'll
>> get the message if "undoing the things" crashes, i.e. will be more
>> obvious what happened.
> 
> If "undo the things" crashes, I would rather like to see that crash
> report, while serial UART at 9600 will continue flushing the message
> and then hang without any pointers to what the heck happened. Not
> here, but in general, messages are also good to be out of the locks.

The hang is actually a better example. It's the most annoying when there
is a silent hang and no error messages.
