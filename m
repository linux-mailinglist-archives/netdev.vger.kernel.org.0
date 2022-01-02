Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47ADF482A73
	for <lists+netdev@lfdr.de>; Sun,  2 Jan 2022 08:10:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232892AbiABHKm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Jan 2022 02:10:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229520AbiABHKl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Jan 2022 02:10:41 -0500
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2315DC061574;
        Sat,  1 Jan 2022 23:10:41 -0800 (PST)
Received: by mail-lj1-x22d.google.com with SMTP id s4so33197560ljd.5;
        Sat, 01 Jan 2022 23:10:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=hfD3IuIg6pdNo9TN2JW8khFOKRGxES2dhfKpDZQlvDE=;
        b=pPglPZ9vsTtly8T3l99MUJwNgpJ2K8APXG7xVIFpADlz2VxIwJEi6hvQ3gE7RyTvj9
         nG23DYA5BwsIRn/NH+VMG3bm11jwM++CKSK6xuQJkUoB0e6eicAHPBU4hQv5j28SbaaU
         /F09SBvRebDrNAqIrrj6CR0dfh4/ELCI0B7ARa5NJcUGjWmOOg53NJUONiLrVbgTC8LD
         FX+mvPjRUSCnsqimWdcr8rlZ4pqE404ns4c4tIuEIxJstQJU4BoBu63mxD2LvW9Eanvv
         8XUTTDHUNcE5PBqg/O4QctoLTgKWGvqmpaqoX0XK1XF422I5XJh5XtoQ+SU2V3vCbxcA
         5CiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hfD3IuIg6pdNo9TN2JW8khFOKRGxES2dhfKpDZQlvDE=;
        b=v89iP7ORNQjFunswK6yBOSSS6uVLeeWwtheHXNI+HNkSmOjZ6Du5mphkzssYvAM0wM
         cKUI3v1YmrtxlVeT0n2MP9hOONecuQFJs5Lrbwy5NehSMGz/GHuJQbpHzRn1YOdvu6nb
         tAU1RTy9XQ7Yfdf6L6KhbbqrIxo68hTvehq2XQBn5mgxcAYh8Vilv+424d+VlRHrt4yb
         LfVEws06rAxo7OR8GGr2vhi1xi+tsJ0fDFleiCFtGCMqhpo7rx/4fO1GQ2BwpbrA9izf
         4WvyCIllLS1Vth+T+1qZh1mgzbBZCUu+kuVjhzSmDPanzNswEtmcbeq6ZwxcPtz0MLue
         A9YQ==
X-Gm-Message-State: AOAM532nzApSYEHANb6TvHA87q66PTZj4jHhWBrpY/92Kt4vCItI6J9C
        Ff/y8V2Auo0fSwqjquaLF+s=
X-Google-Smtp-Source: ABdhPJxBKsU9NsobtF4GQlSqOt0S5qgZwmXLiuJL4sHLM/+NpgfKJBrd0ij6HhEY51Hm6CMG+Xll0Q==
X-Received: by 2002:a2e:b60c:: with SMTP id r12mr34353597ljn.396.1641107439500;
        Sat, 01 Jan 2022 23:10:39 -0800 (PST)
Received: from [192.168.2.145] (46-138-43-24.dynamic.spd-mgts.ru. [46.138.43.24])
        by smtp.googlemail.com with ESMTPSA id w12sm3254510lfe.256.2022.01.01.23.10.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 01 Jan 2022 23:10:39 -0800 (PST)
Subject: Re: [PATCH 03/34] brcmfmac: firmware: Support having multiple alt
 paths
To:     Linus Walleij <linus.walleij@linaro.org>,
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
 <20211226153624.162281-4-marcan@marcan.st>
 <CACRpkdZc75XUJh7afPhcBNaVE63Ovby2HVBe+HObvURN8i84KQ@mail.gmail.com>
From:   Dmitry Osipenko <digetx@gmail.com>
Message-ID: <7e485fd1-8cb5-386c-92da-cecb6312f212@gmail.com>
Date:   Sun, 2 Jan 2022 10:10:38 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <CACRpkdZc75XUJh7afPhcBNaVE63Ovby2HVBe+HObvURN8i84KQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

02.01.2022 08:31, Linus Walleij пишет:
> On Sun, Dec 26, 2021 at 4:37 PM Hector Martin <marcan@marcan.st> wrote:
> 
>> Apple platforms have firmware and config files identified with multiple
>> dimensions. We want to be able to find the most specific firmware
>> available for any given platform, progressively trying more general
>> firmwares.
>>
>> First, add support for having multiple alternate firmware paths.
>>
>> Signed-off-by: Hector Martin <marcan@marcan.st>
> 
> This looks OK to me so FWIW:
> Acked-by: Linus Walleij <linus.walleij@linaro.org>
> 
> Make sure Dmitry Osipenko gets to review this though, he has many
> valuable insights about how the FW is loaded and helped me out a
> lot when I patched this.

Thanks, Linus. I took a brief look at the patch and may give it a test
next time, once it will compile without errors and warnings.
