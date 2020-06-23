Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B687204E2B
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 11:41:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732135AbgFWJlZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 05:41:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732026AbgFWJlX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 05:41:23 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88BC8C061755
        for <netdev@vger.kernel.org>; Tue, 23 Jun 2020 02:41:22 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id y2so5039314ioy.3
        for <netdev@vger.kernel.org>; Tue, 23 Jun 2020 02:41:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=eYT530/2mRtpAyh0DpDIsFqdUu0RZKvGKhfFQ+olAzg=;
        b=q/Wwwp8A1BT//ycShNsM7XqmB3bG24wQBAirlMbmZaCGJ14WlIrYk1hUeGFPFvFYh9
         18AuWxnLJ1U1xdH/pGBPRjrPFyfPQg7q+9IucqCmFfeBCfeps7rxI2SW2DoKIfLUr5up
         QiSEWrkcSOyboUd9lJ8T7gHRuzsG0YMSv8qg4VHWp/kK/35QhddY4oGB6G4nqgWMrCZh
         syPjBA05FOD90Sz9u5udUM+MDkSo1wLudZ9Ufcpzj9Ht4F4P+CCs4YMhBoTiJJpc3hEZ
         C3x7fLzfiu+6I1zCZCYLoB7ldYctRJTYQSe0hOhS8cOtdYjiuOJfUpqpndg4fwtYgwqc
         4scA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=eYT530/2mRtpAyh0DpDIsFqdUu0RZKvGKhfFQ+olAzg=;
        b=lFeaUtAYxYdhQ5yFdgnl1lgXXCEHaerh87xYKz+f+Sm9sH7wKheN8bZ/btsKo9HZ+S
         Ishk4uyWosP7JDmqNUUbZ9sjgCG1ksFhoBLHYA+lju9a5z6Ls/niBcckScAAAYOShVWN
         L8TzMUg36KSqaxGoZUJ/tIG+NULGkGoN8WZlFwACdC9GbVSJEHmr1gz0NUY2j8e2EOKh
         VoGYvuzbZlvNq5q689B37T0y7oyJm5Vh5aCSsYW1yR300FFlsDkLhWARwNTlpprDq17L
         1UpHRLEsjAqzrdkACiSsfP1G12y5BkCQ+GtBZGh5mSCbBuWPCAJbaMXrawgm0TI6KJTl
         L3uA==
X-Gm-Message-State: AOAM533qGhFRb08yZALMKC9WDnE0bVeW7ZXA09Bc6ZcsRyhWf73Ax6T2
        +jI9yaP/b1owo6DLZs4QEPZGWm85jVY/Gfnt0xV1Rw==
X-Google-Smtp-Source: ABdhPJx3IjaiDsJ/En/rPYv6gBlyL3k6lTKfuVMMpv+FRtlkN7ZNw3o69BET+TAsLrzyXAm77vQTkunODede1IEEHSw=
X-Received: by 2002:a02:cdc4:: with SMTP id m4mr22844233jap.57.1592905281814;
 Tue, 23 Jun 2020 02:41:21 -0700 (PDT)
MIME-Version: 1.0
References: <20200622093744.13685-1-brgl@bgdev.pl> <20200622093744.13685-15-brgl@bgdev.pl>
 <20200622132921.GI1551@shell.armlinux.org.uk>
In-Reply-To: <20200622132921.GI1551@shell.armlinux.org.uk>
From:   Bartosz Golaszewski <brgl@bgdev.pl>
Date:   Tue, 23 Jun 2020 11:41:11 +0200
Message-ID: <CAMRc=Me1r3Mzfg3-gTsGk4rEtvB=P9ESkn9q=c7z0Q=YQDsw2A@mail.gmail.com>
Subject: Re: [PATCH 14/15] net: phy: add PHY regulator support
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Iyappan Subramanian <iyappan@os.amperecomputing.com>,
        Keyur Chudgar <keyur@os.amperecomputing.com>,
        Quan Nguyen <quan@os.amperecomputing.com>,
        Frank Rowand <frowand.list@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        devicetree <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        "moderated list:ARM/Mediatek SoC..." 
        <linux-mediatek@lists.infradead.org>,
        Fabien Parent <fparent@baylibre.com>,
        Stephane Le Provost <stephane.leprovost@mediatek.com>,
        Pedro Tsai <pedro.tsai@mediatek.com>,
        Andrew Perepech <andrew.perepech@mediatek.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

pon., 22 cze 2020 o 15:29 Russell King - ARM Linux admin
<linux@armlinux.org.uk> napisa=C5=82(a):
>

[snip!]

>
> This is likely to cause issues for some PHY drivers.  Note that we have
> some PHY drivers which register a temperature sensor in the probe
> function, which means they can be accessed independently of the lifetime
> of the PHY bound to the network driver (which may only be while the
> network device is "up".)  We certainly do not want hwmon failing just
> because the network device is down.
>
> That's kind of worked around for the reset stuff, because there are two
> layers to that: the mdio device layer reset support which knows nothing
> of the PHY binding state to the network driver, and the phylib reset
> support, but it is not nice.
>

Regulators are reference counted so if the hwmon driver enables it
using mdio_device_power_on() it will stay on even after the PHY driver
calls phy_device_power_off(), right? Am I missing something?

Bart
