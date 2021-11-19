Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58CC14567C0
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 02:59:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233679AbhKSCCB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 21:02:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230133AbhKSCCA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 21:02:00 -0500
Received: from mail-ot1-x32e.google.com (mail-ot1-x32e.google.com [IPv6:2607:f8b0:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BF0EC061574
        for <netdev@vger.kernel.org>; Thu, 18 Nov 2021 17:59:00 -0800 (PST)
Received: by mail-ot1-x32e.google.com with SMTP id r10-20020a056830080a00b0055c8fd2cebdso14345340ots.6
        for <netdev@vger.kernel.org>; Thu, 18 Nov 2021 17:59:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qxrvQVF4m+QropEcfFogeAEuTKECfRdkgZwzd9IzrTY=;
        b=qmbmNijJFXVueQEeCkVZMl9HEyYSS88lgyh02VxPk7XYJ9R2Ott8UtcJh+tk7QOsf0
         REdukpk7uYSqlK4IKNpEKPS/Ipuec4CwCOIb1fLUc1xCeXKG7fhq0S1ZfhVxkDmLG3Je
         wVbJ/mC9FVT2/lexDnWW2Khc4F8lyISisxsiGFpydpT8PjMK+/IhEMbGbag0HyQJJ/6c
         Pxq1CzLaCI0xe+4e/r0dJJ9emSlXuK99Mm8K+cJ6yTMqpINU4iydU8NDyq9kBZkfkqUP
         vyAu0BwCxsgx8ByQkfkCBOAcrmu0y1zo9acBpy80lk+3qsyv9PtXFKU2sdyY/RXg4k1j
         QKsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qxrvQVF4m+QropEcfFogeAEuTKECfRdkgZwzd9IzrTY=;
        b=QA4p+sopqW/nJoTcwLcywn5xC1BcqQUMOSmVocRTRAj1wZzhxlGsGPCu6IxfAW35If
         Hj5s8YLiHVw7zB1K1UkjflAbDBIWgkXri9MYO0J1EC181881viv6o57K287p/TpUfK/o
         Tuss7cMrHwaQQyBSQXBCXDaBfpRIY7rjPdN/jvyfep9HvkqhRtZRgpQs1vJKiOGmaFqF
         rjoHBFdePL4Nt9udIhTAHtufUZMDCgWckWtcRF8MRBVZ+vdDYbWCBHGr4tiy9kdsxPeJ
         omEIlpBjqjI0+dvRb/xHaIs/UZBTzrKDfoaAU2fXproEejNkpm+ssfxt40OLlsjN9tZp
         qh5w==
X-Gm-Message-State: AOAM531nNsED+35e/a0DCRVF6P/idNV0w89lEPB60/rtSBVEje/bvTdu
        JPnsxyLGaCPLem4+er8gwEbvAEbJXpj8HFCIhFTTw1oIb4M=
X-Google-Smtp-Source: ABdhPJzSFZ//VcGp3AB1vc1IzBZbVM7vx0cGqccethKqVq73UW3XVPTuPDlEDoJKJOKhIjVIp+D+2yK89HGChzwnLWk=
X-Received: by 2002:a9d:a42:: with SMTP id 60mr1540817otg.179.1637287139427;
 Thu, 18 Nov 2021 17:58:59 -0800 (PST)
MIME-Version: 1.0
References: <20211116062328.1949151-1-colin.foster@in-advantage.com>
In-Reply-To: <20211116062328.1949151-1-colin.foster@in-advantage.com>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Fri, 19 Nov 2021 02:58:47 +0100
Message-ID: <CACRpkdaFmFFpYrreFsD6XRPAoivDPK1nSfAVKacNG8bWUR7rHQ@mail.gmail.com>
Subject: Re: [RFC PATCH v4 net-next 00/23] add support for VSC75XX control
 over SPI
To:     Colin Foster <colin.foster@in-advantage.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-gpio@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Colin,

nice work!

On Tue, Nov 16, 2021 at 7:23 AM Colin Foster
<colin.foster@in-advantage.com> wrote:

>   pinctrl: ocelot: combine get resource and ioremap into single call
>   pinctrl: ocelot: update pinctrl to automatic base address
>   pinctrl: ocelot: convert pinctrl to regmap
>   pinctrl: ocelot: expose ocelot_pinctrl_core_probe interface
>   pinctrl: microchip-sgpio: update to support regmap
>   device property: add helper function fwnode_get_child_node_count
>   pinctrl: microchip-sgpio: change device tree matches to use nodes
>     instead of device
>   pinctrl: microchip-sgpio: expose microchip_sgpio_core_probe interface

Can these patches be broken out to its own series and handled
separately from the DSA stuff or is there build-time dependencies?

Yours,
Linus Walleij
