Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B039C575D7B
	for <lists+netdev@lfdr.de>; Fri, 15 Jul 2022 10:32:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232653AbiGOIax (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 04:30:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232626AbiGOIaw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 04:30:52 -0400
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A782380504
        for <netdev@vger.kernel.org>; Fri, 15 Jul 2022 01:30:50 -0700 (PDT)
Received: by mail-lf1-x133.google.com with SMTP id e28so6709874lfj.4
        for <netdev@vger.kernel.org>; Fri, 15 Jul 2022 01:30:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=BdfeAVJL1SU2mFuVJ1kQVRCy8ah9BFcYe/si9tBZYrM=;
        b=GLARdVNDa+EOTo/liODtN4RtO7gdJGoxxMiIojNRienYvOHet52dUwDhdzs3SWPu0v
         /VICwkJMevBOcqioe1dIWqIyBxnLId0yHoAeku6sUjnf33FNeq5oHvyuf/Q5YjXcKIPu
         EFmw865o5XztvO0/2QbrIo8oD/KJnxvZJJ66H9QIbT7Nv6DRNqPg8X4CsEO6W4AVjeuW
         5d/7bhWvniaPPPPyGQJQRcR7Obt/jCiKnnUEHiYC2KPMhSMz9PEDnYQJdE83YKdEh8kD
         BhFIO/9XQ3cGoHTg91Lw77vF/TcmAbKhLHAm0yECPwdN2rtKMjen3zEog0N2EVCCMshn
         i4iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=BdfeAVJL1SU2mFuVJ1kQVRCy8ah9BFcYe/si9tBZYrM=;
        b=kgxve+RRB7F0c5vRDv+c8JaC5PYFVHQ9btce6egVyddOjG46Gjw5TJ2OjHZyQ2jKmb
         yTp16Tj2GxKKyOKM88WxfmcKuEHGZkuOQ7leI18nIWzrdsc1ToM3/H+XbZVZ4jFoFjDF
         i+Q3PLkitBVSwqNlIyid58nzASRmTt+uD84yGUmL489PTDhTRTppoOqaSHk+14mPsnm9
         s97bOD4vPzIkOqvRimBxsB26dZrDuWgNRe+aNLVMR/jFO4Hq5jFw5CNuZi+Gk3pq5/Ve
         Q/Yymkxh8obYm5CreAHPVy5/qmJp0S4Q7v4dblghB2aD+r0b0bx+UHj25L4X2G/fabya
         0T6A==
X-Gm-Message-State: AJIora+bz+c0Xsi5GEVWaM2wmFAd1NwmPiIljJ3eBQVnjNZ+fgPOS6IM
        Z9eLe3v+MTmO6GnbwwLEDNZZn9e3TZqHyfis16ymJA==
X-Google-Smtp-Source: AGRyM1vmEiGNxsGwfaphjeldpisE1hbkgmPH1zGFyJKH3Y3sHn8434T6rxRbnWsNte9tdSs0qEZP170/McAyw0pTMMo=
X-Received: by 2002:a05:6512:2315:b0:489:cbc1:886a with SMTP id
 o21-20020a056512231500b00489cbc1886amr6852844lfu.428.1657873847553; Fri, 15
 Jul 2022 01:30:47 -0700 (PDT)
MIME-Version: 1.0
References: <Ys7RdzGgHbYiPyB1@shell.armlinux.org.uk>
In-Reply-To: <Ys7RdzGgHbYiPyB1@shell.armlinux.org.uk>
From:   Marcin Wojtas <mw@semihalf.com>
Date:   Fri, 15 Jul 2022 10:30:37 +0200
Message-ID: <CAPv3WKda3kxNKkd46AbLDTFeQ_V=J8_b1iFZ4oyVFBA9o_fDzQ@mail.gmail.com>
Subject: Re: [PATCH RFC v2 0/6] net: dsa: always use phylink
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        =?UTF-8?Q?Alvin_=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Daniel Scally <djrscally@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        DENG Qingfang <dqfext@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        George McCollister <george.mccollister@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        =?UTF-8?B?TWFyZWsgQmVow7pu?= <kabel@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Sean Wang <sean.wang@mediatek.com>,
        UNGLinuxDriver@microchip.com,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Woojung Huh <woojung.huh@microchip.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

=C5=9Br., 13 lip 2022 o 16:16 Russell King (Oracle) <linux@armlinux.org.uk>
napisa=C5=82(a):
>
> Hi,
>
> This is a re-hash of the previous RFC series, this time using the
> suggestion from Vladimir to create a swnode based fixed-link
> specifier.
>
> Most of the changes are to DSA and phylink code from the previous
> series. I've tested on my Clearfog (which has just one Marvell DSA
> switch) and it works there - also tested without the fixed-link
> specified in DT.
>
>  drivers/base/swnode.c                  |  14 ++-
>  drivers/net/dsa/b53/b53_common.c       |   3 +-
>  drivers/net/dsa/bcm_sf2.c              |   3 +-
>  drivers/net/dsa/hirschmann/hellcreek.c |   3 +-
>  drivers/net/dsa/lantiq_gswip.c         |   6 +-
>  drivers/net/dsa/microchip/ksz_common.c |   3 +-
>  drivers/net/dsa/mt7530.c               |   3 +-
>  drivers/net/dsa/mv88e6xxx/chip.c       | 134 ++++++++++++-------------
>  drivers/net/dsa/mv88e6xxx/chip.h       |   6 +-
>  drivers/net/dsa/mv88e6xxx/port.c       |  32 ------
>  drivers/net/dsa/mv88e6xxx/port.h       |   5 -
>  drivers/net/dsa/ocelot/felix.c         |   3 +-
>  drivers/net/dsa/qca/ar9331.c           |   3 +-
>  drivers/net/dsa/qca8k.c                |   3 +-
>  drivers/net/dsa/realtek/rtl8365mb.c    |   3 +-
>  drivers/net/dsa/sja1105/sja1105_main.c |   3 +-
>  drivers/net/dsa/xrs700x/xrs700x.c      |   3 +-
>  drivers/net/phy/phylink.c              |  30 ++++--
>  include/linux/phylink.h                |   1 +
>  include/linux/property.h               |   4 +
>  include/net/dsa.h                      |   3 +-
>  net/dsa/port.c                         | 175 +++++++++++++++++++++++++++=
++----
>  22 files changed, 290 insertions(+), 153 deletions(-)
>

I tested the patchset on top of net-next/master alone and with my
fwnode_/ACPI patchset:
* On EspressoBIN
* On SolidRun CN913x CEx7 Eval Board
  - with DT (with and without fixed-link description in CPU port)
  - with ACPI (with and without fixed-link description in CPU port)

All works as expected, so:
Tested-by: Marcin Wojtas <mw@semihalf.com>

FWIW, the patches LGTM:
Reviewed-by: Marcin Wojtas <mw@semihalf.com>

Best regards,
Marcin
