Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD3CC56956A
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 00:46:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232287AbiGFWqq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 18:46:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229768AbiGFWqo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 18:46:44 -0400
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D10B2B1BE
        for <netdev@vger.kernel.org>; Wed,  6 Jul 2022 15:46:43 -0700 (PDT)
Received: by mail-yb1-xb33.google.com with SMTP id r3so29654787ybr.6
        for <netdev@vger.kernel.org>; Wed, 06 Jul 2022 15:46:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sGO2KmAAzrpAl6kAYx9AdPAV8dUrIAcT8nRhDDK6jiI=;
        b=hn08DNIzFwal/bnJR5VKWwwjNmPgwr6n4bvoWroYyO2DpbHwRRYAcfW6/1ZTCyBZmi
         442HaMUNtNpyaruLX8iPwxcoiAyug/ARLFHstON9Q9TjfVvmUSePKhO6pNPUvK9mXYPm
         lMSmcQA5troeHy2OcvMiHoxIIoFGnZ91sySMhuLRMouwol2hgAJPAAneYSr2vs8gl1yy
         6bU9ohkXrSGklWzrrHSYdxQcmEoWiHMEzdKC5cNB6gMdZ0+w9NSgZ/0uirhMeRfNXoIm
         ZjCD9o/emfhBNGnfOb/w5O+3btJJGOfa4Y53th1jGuCeZAzGg6LEEMHG3PCe0nKPdnpf
         9CYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sGO2KmAAzrpAl6kAYx9AdPAV8dUrIAcT8nRhDDK6jiI=;
        b=rDjMAQdysF2uNdmeocv7V51ZAGpES5MoByOVGp+CMNbLzQM0BkocJeBYuQF1Ov0BMI
         jBiX7aVyUUt+eyGo6M3nXq7tcMhtC7HvbopOMdRfl+GHFZkAwig+LoNedxZRN+Kg3sgV
         s1LHFUbpFPMkVf7kYe41cN7MRBiq3JnjyTM9cGEhFa7DzbiDMl2MjYBGVpaECoGcSoo5
         uq/Ec3TVJPtcZ6JHIkVY+RZP70c1HNRhFOwh/EnjVgz+R1VBwcfMOHKIMxtr+HlAygYX
         FHPzmj8V6PmqkEzLUylcvXwRZtj6xg2Uf4BKMLnVoH799PlM+8FNT7/CTTvZ3VIeIWrm
         KdXg==
X-Gm-Message-State: AJIora/bjIORihSTcm9jIk/BPE7hcWDLwJRhffUEZHQTeZHeMu0sbyCV
        nNQqPWjPpgRyEzutS9hTyUroJDvSHUS1IGqfozzggQ==
X-Google-Smtp-Source: AGRyM1uaFc0IM4WHsDrwwCHO1Der3xWvlmlupuFTBmgrkJ0/QSm68C1x66tIxyPkwSNLJ8ORuxnDLKewZswBi93lxWA=
X-Received: by 2002:a25:6cc5:0:b0:66e:6606:74fe with SMTP id
 h188-20020a256cc5000000b0066e660674femr16268009ybc.291.1657147602658; Wed, 06
 Jul 2022 15:46:42 -0700 (PDT)
MIME-Version: 1.0
References: <YsQIjC7UpcGWJovx@shell.armlinux.org.uk>
In-Reply-To: <YsQIjC7UpcGWJovx@shell.armlinux.org.uk>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Thu, 7 Jul 2022 00:46:30 +0200
Message-ID: <CACRpkda3tdo0q2xZGrAO2b6Pef-Pt2GV0VyVam1uFKotk4iXKA@mail.gmail.com>
Subject: Re: [PATCH RFC net-next v2 0/5] net: dsa: always use phylink
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        =?UTF-8?Q?Alvin_=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        DENG Qingfang <dqfext@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        George McCollister <george.mccollister@gmail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Jakub Kicinski <kuba@kernel.org>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Landen Chao <Landen.Chao@mediatek.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Sean Wang <sean.wang@mediatek.com>,
        UNGLinuxDriver@microchip.com,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Woojung Huh <woojung.huh@microchip.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 5, 2022 at 11:47 AM Russell King (Oracle)
<linux@armlinux.org.uk> wrote:

> A new revision of the series which incorporates changes that Marek
> suggested. Specifically, the changes are:
>
> 1. Patch 2 - use the phylink_get_caps method in mv88e6xxx to get the
>    default interface rather than re-using port_max_speed_mode()
>
> 2. Patch 4 - if no default interface is provided, use the supported
>    interface mask to search for the first interface that gives the
>    fastest speed.
>
> 3. Patch 5 - now also removes the port_max_speed_mode() method

Pulled in the patch set on top of net-next and tested on the
D-Link DIR-685 with the RTL8366RB switch with no
regressions, so:
Tested-by: Linus Walleij <linus.walleij@linaro.org>

The plan is to enhance the phylink handling in the RTL8366RB
on top of Russell's patch in some time.

Yours,
Linus Walleij
