Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74191494ED6
	for <lists+netdev@lfdr.de>; Thu, 20 Jan 2022 14:23:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344655AbiATNXv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jan 2022 08:23:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232966AbiATNXv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jan 2022 08:23:51 -0500
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEAD4C061574;
        Thu, 20 Jan 2022 05:23:50 -0800 (PST)
Received: by mail-lf1-x130.google.com with SMTP id p27so21680079lfa.1;
        Thu, 20 Jan 2022 05:23:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=IJ3AVBXXw8houHFsBwqKNxRpnoMUHCzOHWMOL+64gNc=;
        b=NH6NAQT0AB4FawArepBcdhhKB/vzBDv2D9Fdvp1PFU21amw5N2mVyQM0KvfrU/4FtJ
         MUrencMsVqsQ3K4NklXZzYQKFjuGlazr5xY72ZUqy8Dg6Es2q2vQwWEpTomZ4LXHI0K6
         GVZLL+7wTpwosjSzRJKpUvemXvaqGQGYDbj/3QQjwsxoJxpKI5qOBNsOoyGaq8r1FjFv
         m6Au/doq5b+rQWdTfEIim7gqn28W+GMlBu91TqE+2MCEVyiDbczrh03B5bpDE9bcVJXM
         z8kvaUKr6/fZe5krlLKQWUGBA0u8npEw6SKb5626sQ5Ocn3yksqe+0hjYRfRjB7AIyI1
         1oNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=IJ3AVBXXw8houHFsBwqKNxRpnoMUHCzOHWMOL+64gNc=;
        b=V4jZ+F7JASE94pcaOAT13fG2dwr4qFwfGxCvWP3gcJ4uxBtxhgF2MPO+090U5K3fYu
         NfIprzM8fseoU/LVQZXZB/7VF3u8BOqDPCFQcYK4H++94uBVxmONlvpWwVEoTAeTYvkN
         o2M/Mky+hBro8gHPEpm7k/7DAtF2uWMrrhL0bWkhUa41GEEVTBWfacrYDnrRSno9CUtE
         HOW5mYcw3VGIA/V4eler7Q4so9dgOtLh70wHIukV0zVZllfN0W5K4U60N7fbV6n/kCoV
         Qlx45oTqaE0B9hE3CkrVng6BYLUUUtS+g2EUDX6rp8rURzKXE2PEiAHLJnZzbPmPlb/n
         fuag==
X-Gm-Message-State: AOAM5325jgkpU7qUb9IRSRfUKI41ZpOCc5SXeGX9TK2I5O/LkgxhmhrR
        2ulxM7uut6JkxKRkupka/H4=
X-Google-Smtp-Source: ABdhPJymsWGP8t1p46DpW44R3ZXzy6QM24UBihuoBW2Cahxj6xRxDhVq58roRtPU8AlidSSiIT8D9A==
X-Received: by 2002:a19:f803:: with SMTP id a3mr31079126lff.95.1642685029058;
        Thu, 20 Jan 2022 05:23:49 -0800 (PST)
Received: from [192.168.2.145] (109-252-139-36.dynamic.spd-mgts.ru. [109.252.139.36])
        by smtp.googlemail.com with ESMTPSA id k2sm243852lfe.213.2022.01.20.05.23.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Jan 2022 05:23:48 -0800 (PST)
Message-ID: <5dca45ba-a8a9-7091-365b-7a73fdd3be26@gmail.com>
Date:   Thu, 20 Jan 2022 16:23:47 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v3 3/9] brcmfmac: firmware: Do not crash on a NULL
 board_type
Content-Language: en-US
To:     Arend van Spriel <arend.vanspriel@broadcom.com>,
        Hector Martin <marcan@marcan.st>,
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
        Wright Feng <wright.feng@infineon.com>
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
References: <20220117142919.207370-1-marcan@marcan.st>
 <20220117142919.207370-4-marcan@marcan.st>
 <be66ea27-c98a-68d3-40b1-f79ab62460d5@gmail.com>
 <9db96f20-38fb-46e0-5f33-e5cd36501bf0@broadcom.com>
From:   Dmitry Osipenko <digetx@gmail.com>
In-Reply-To: <9db96f20-38fb-46e0-5f33-e5cd36501bf0@broadcom.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

20.01.2022 11:29, Arend van Spriel пишет:
> On 1/19/2022 11:02 PM, Dmitry Osipenko wrote:
>> 17.01.2022 17:29, Hector Martin пишет:
>>> This unbreaks support for USB devices, which do not have a board_type
>>> to create an alt_path out of and thus were running into a NULL
>>> dereference.
>>>
>>> Fixes: 5ff013914c62 ("brcmfmac: firmware: Allow per-board firmware
>>> binaries")
>>> Signed-off-by: Hector Martin <marcan@marcan.st>
>>
>> Technically, all patches that are intended to be included into next
>> stable kernel update require the "Cc: stable@vger.kernel.org" tag.
> 
> Being the nit picker that I am I would say it is recommended to safe
> yourself extra work, not required, for the reason you give below.

Will be nice if stable tag could officially become a recommendation,
implying the stable tag. It's a requirement today, at least Greg KH
always demands to add it :)
