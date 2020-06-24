Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D30CA2078F7
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 18:22:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404844AbgFXQWV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 12:22:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404701AbgFXQWU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jun 2020 12:22:20 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D228FC061795
        for <netdev@vger.kernel.org>; Wed, 24 Jun 2020 09:22:19 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id t8so2610409ilm.7
        for <netdev@vger.kernel.org>; Wed, 24 Jun 2020 09:22:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=STD7qLvWtpSzAtO1gXjXJztLXOvVuvn065ZWjIwBzm8=;
        b=GDbX4i4/9sFa2QnOyFKV3sAmgpvbd4H9sf69kAM0V93uCHV4aw7EViw8WQGFnmGhGL
         RCC+okJfghc3Wz2bz8HZeO7YwxG7/oL/0OfQHSSw8KaxqyDX+3pN+o3xIH3aODH5BQjK
         vTgBiV68m+YydOFw1YZbI/IzAxH09eBSYoeOnD2WwMhuNy5dRivxMDq8sxhdaJcPIFVE
         xpNn8lwne15R7K3Ux72CJTplglE9cuR4bjD2TZvXf3CiAqo230jAdvO8oHmtF2Psgl2p
         YadWLDh4Bl411uJHkly3hQX/7NFaklwQk0TAShizwVTPmjXzGeqZOsMfxFNXOJwnROdt
         D35Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=STD7qLvWtpSzAtO1gXjXJztLXOvVuvn065ZWjIwBzm8=;
        b=k69Gc0EaD6x+r2EcuolTPFMr25q2xewEGQwMr0Ysc1J0nsxqwUD0vQxS87Z/CFLtic
         icGhWtAQagbmBmcdBb70TAVSxs5OAkTdBexJSXdFPhOzLMxQBpSEVMxT7HRefFJtRrtV
         L4jCfaylyj4pIkGu4Ma2ZGYC3EEHw3janDYV1hIsvRbLidNnuyRHkX66v6Ru68FdOWNJ
         WW59Ru4FG/rkUxRk1s+xQOudmrIAuEWo8LhVpra4ywDnKnpkOdVDsh35r5uUaIxZFAXo
         vgIVwstRzhkKQ7PxjC4oj9a9nN68/WX+YmLXynSEHKxTP0IBsBdUcC6KRso586NZIh89
         c97w==
X-Gm-Message-State: AOAM5300GqcN6I0ak7o+lbOj5+5/zVm0qPckUIkcVuOm1wYk//uwE1+t
        x1a4szQQJEuFW8WPqsJrmpcKGl7+OkBEHFQeTj4BLA==
X-Google-Smtp-Source: ABdhPJyCu6OdPyGuzSe1OJNhDF0LoYbiaX834HuGofRmFkCh2g6eAXaOlNsVAMtygwLHq1VOlmz7okN+XaK4lvMSMqk=
X-Received: by 2002:a92:c509:: with SMTP id r9mr28062372ilg.189.1593015739191;
 Wed, 24 Jun 2020 09:22:19 -0700 (PDT)
MIME-Version: 1.0
References: <20200622093744.13685-1-brgl@bgdev.pl> <20200622093744.13685-6-brgl@bgdev.pl>
 <1da91144-076d-bf1e-f12a-2b4fe242febc@gmail.com>
In-Reply-To: <1da91144-076d-bf1e-f12a-2b4fe242febc@gmail.com>
From:   Bartosz Golaszewski <brgl@bgdev.pl>
Date:   Wed, 24 Jun 2020 18:22:08 +0200
Message-ID: <CAMRc=MeCTNuwY4-h=OhVVT1RHWYfi-VwEZMvm0RNrS_qNu_EPw@mail.gmail.com>
Subject: Re: [PATCH 05/15] net: phy: reset the PHY even if probe() is not implemented
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
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

wt., 23 cze 2020 o 21:14 Florian Fainelli <f.fainelli@gmail.com> napisa=C5=
=82(a):
>
> On 6/22/20 2:37 AM, Bartosz Golaszewski wrote:
> > From: Bartosz Golaszewski <bgolaszewski@baylibre.com>
> >
> > Currently we only call phy_device_reset() if the PHY driver implements
> > the probe() callback. This is not mandatory and many drivers (e.g.
> > realtek) don't need probe() for most devices but still can have reset
> > GPIOs defined. There's no reason to depend on the presence of probe()
> > here so pull the reset code out of the if clause.
> >
> > Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
>
> OK, but now let's imagine that a PHY device has two or more reset lines,
> one of them is going to be managed by the core PHY library and the rest
> is going to be under the responsibility of the PHY driver, that does not
> sound intuitive or convenient at all. This is a hypothetical case, but
> it could conceivable happen, so how about adding a flag to the driver
> that says "let me manage it a all"?

This sounds good as a new feature idea but doesn't seem to be related
to what this patch is trying to do. The only thing it does is improve
the current behavior. I'll note your point for the future work on the
pre-probe stage.

Bartosz
