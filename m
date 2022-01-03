Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D10F5482D6C
	for <lists+netdev@lfdr.de>; Mon,  3 Jan 2022 02:26:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231311AbiACB0V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Jan 2022 20:26:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230110AbiACB0U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Jan 2022 20:26:20 -0500
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30BC3C061761;
        Sun,  2 Jan 2022 17:26:20 -0800 (PST)
Received: by mail-lf1-x12a.google.com with SMTP id x7so72091430lfu.8;
        Sun, 02 Jan 2022 17:26:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=LOG+LRnFpNPHGcbZgexu8NnNf42wYWPGSEjdgT8j34Y=;
        b=LDuf7jp1iGCDGF/Phth7mxhqpRpg6gEA869QeS6uWzxl7NG5QOemxoHXNMjYvowX1I
         MmOlEwTe46SDzM2b8blgf6TFvb9IV14yOW23g4r1ZG4h/WNl25rAggVGIHNa/GjwKj3s
         dBDEyAYkBUsY5J/87asojbXG+B5Ypa8BE/vLL0z0xtyAJ2SGWDtnq4q1p+0XzC7lhJ52
         75aaf0dMceQClHkqHB9lDV2cqHZGVnRnbVrmM049bKvYznmK6Ps54XaXRUi3/NpfLbO2
         hjCohLxihMTAfPLPIEnE5ka6I857i8Ry5KUe7P5dQT9EqHGvndZ7evUfLb6pj6f7pvrW
         EOnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LOG+LRnFpNPHGcbZgexu8NnNf42wYWPGSEjdgT8j34Y=;
        b=2CVnR/P6eD7TUTLWfj1II7JVMoijQc7R5BBXNFsgwixFEoiwYqBrVJhaEEnXorealH
         IkZ0rJdVzS3JyMLwDWDiE9EdNcKXOWrb5H24BBFZFPjcTa+YVznQVOq7csGk7//oh3s5
         UHaYslIrB/yjTb8FmFKKXcSo0NL7t2vu10x5Rip1i0MJvtuKasu6YUeG5hYUZ/LQYkJF
         yYxfuR0XyA8mn2ttLV0QFl99yFh/CP7DR9DL8+tOMOsS0lwlutdng9P8rQUaaIYOjwXu
         YnQKm91YqsW1aMLW2m/251B85HHOOY8XCzwB7+/OGqqBrpfAynHItDxmufAtjfjJ+5KD
         qwWA==
X-Gm-Message-State: AOAM532N54gFhOE8eG+ZYD2qmfKAb1oFCeRbb6T/fCLMq0qPEdfunLCh
        XeSzMLj2JNPHpLX+K0qfTag=
X-Google-Smtp-Source: ABdhPJyEa/GRkFoaZ/6C94axN4nLg9bDFQsbmGsslW3JBM0Y64w0IUKXjq3OOgLvP86NJtfc2P1zyw==
X-Received: by 2002:a05:6512:2305:: with SMTP id o5mr39533999lfu.564.1641173178486;
        Sun, 02 Jan 2022 17:26:18 -0800 (PST)
Received: from [192.168.2.145] (46-138-43-24.dynamic.spd-mgts.ru. [46.138.43.24])
        by smtp.googlemail.com with ESMTPSA id p14sm3442104ljj.12.2022.01.02.17.26.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 02 Jan 2022 17:26:18 -0800 (PST)
Subject: Re: [PATCH 03/34] brcmfmac: firmware: Support having multiple alt
 paths
To:     Hector Martin <marcan@marcan.st>,
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
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com
References: <20211226153624.162281-1-marcan@marcan.st>
 <20211226153624.162281-4-marcan@marcan.st>
 <8e99eb47-2bc1-7899-5829-96f2a515b2cb@gmail.com>
 <e9ecbd0b-8741-1e7d-ae7a-f839287cb5c9@marcan.st>
 <48f16559-6891-9401-dd8e-762c7573304c@gmail.com>
 <d96fe60e-c029-b400-9c29-0f95c3632301@marcan.st>
From:   Dmitry Osipenko <digetx@gmail.com>
Message-ID: <4a307f13-0bd3-5fa5-dd51-9cd1d39eaa33@gmail.com>
Date:   Mon, 3 Jan 2022 04:26:17 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <d96fe60e-c029-b400-9c29-0f95c3632301@marcan.st>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

03.01.2022 03:41, Hector Martin пишет:
>> There is indeed no need for the castings in such cases, it's a typical
>> code pattern in kernel. You would need to do the casting for the other
>> way around, i.e. if char ** was returned and **alt_paths was a const.
> You do need to do the cast. Try it.
> 
> $ cat test.c
> int main() {
>         char *foo[1];
>         const char **bar = foo;
> 
>         return 0;
> }
> 
> $ gcc test.c
> test.c: In function ‘main’:
> test.c:4:28: warning: initialization of ‘const char **’ from
> incompatible pointer type ‘char **’ [-Wincompatible-pointer-types]
>     4 |         const char **bar = foo;
>       |
> 
> You can implicitly cast char* to const char*, but you *cannot*
> impliclicitly cast char** to const char** for the reason I explained. It
> requires a cast.

Right, I read it as "char * const *". The "const char **" vs "char *
const *" always confuses me.

Hence you should've written "const char **alt_paths;" in
brcm_alt_fw_paths() in the first place and then casting wouldn't have
been needed.
