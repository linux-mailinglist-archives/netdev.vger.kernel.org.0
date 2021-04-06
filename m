Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4776E3558AE
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 18:02:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242542AbhDFQCO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 12:02:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231787AbhDFQCM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Apr 2021 12:02:12 -0400
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 706D0C06174A;
        Tue,  6 Apr 2021 09:02:04 -0700 (PDT)
Received: by mail-io1-xd30.google.com with SMTP id v26so16075968iox.11;
        Tue, 06 Apr 2021 09:02:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=y6td6U/wgXJy1PKxkTx+qADiVVwnBDVWbevDjru0nls=;
        b=XvPpCjYxNmJmPbhWQwWWLjNrOfwWJekG5FGqReCq3HR7smTKgok8w/+146+n12sXYh
         g1SrBLJkHm6800/a8NRq/X+CMSiz6G/JNNS8hv/BXu44w47pWOn4xjF227zQ2lkprOIh
         eGWepOCNQdmUWzQmHnj7HDx92mhDsbhqkmNXhEA/G8FyxFn6hoH1IVrtQ7PnvK8DwgzB
         PpYChXnoMFzZkwxfV3WUOwaNcPHs1chU+ro8WE+MMTT1XaElw/fgi6L1oS8RhBNtOjdF
         OYxHMqvZRgAwps12+XvU/yKiF+SLtPa48N5qxjKKm0GQe2t7kykpeRwCrm/FaC3hYWj6
         A/SA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=y6td6U/wgXJy1PKxkTx+qADiVVwnBDVWbevDjru0nls=;
        b=SzFu7dNqvnWeg8Fhs3e+9gK+fpERM08uBEIozvp5jrcwMhhcgDLFjxhEZHz3sv3+OA
         x3hHJ/eBjmL6M60YLr6QvQxM3GfNyHHpWUj/OzN2V4UZMKl0eFoWCVOLCLzPZXodR8bR
         0hw2dtTJg7Po3I+vp77NHFCDKzG4kt9rulj9e/0StWbcgO4NUO5nyJbWuIDih++jx6Zz
         wprdXd6cR9m6luynF5+McHRfSFbWBxvoBObhUb0HcYTFMBk4YAxR/EA1fVbVVmVAqKAX
         xMeEi1sWA8VDafz5TGXTUxzvy1FszO2pyo6rUsT9IpJzhHqOpmrszn55u8FXkwhUdce8
         33zg==
X-Gm-Message-State: AOAM530xNQOdaY1OBLmFyjUc/GZ6rUJZLnzz/oVy3806Tev9QCPm+LsO
        h+k/F0whamCeitgcjpwh1YMzS3CZXck/HjFR3nQ=
X-Google-Smtp-Source: ABdhPJzrupn5Tqo/qGYiJFhgY4pom3bPfOsFnrJ4YLA/PGWrDxckk5HncixtyDHTPC1rXWyNlr2qX0SRG+OFMzNoklo=
X-Received: by 2002:a05:6638:144e:: with SMTP id l14mr29148356jad.76.1617724924002;
 Tue, 06 Apr 2021 09:02:04 -0700 (PDT)
MIME-Version: 1.0
References: <20210406141819.1025864-1-dqfext@gmail.com> <20210406141819.1025864-3-dqfext@gmail.com>
 <YGx+nyYkSY3Xu0Za@lunn.ch> <CALW65jYhBGmz8dy+9C_YCpJU5wa-KAwgrGjCSpa3nqUNT+xU+g@mail.gmail.com>
 <YGyC9liu9v+DFSHA@lunn.ch>
In-Reply-To: <YGyC9liu9v+DFSHA@lunn.ch>
From:   DENG Qingfang <dqfext@gmail.com>
Date:   Wed, 7 Apr 2021 00:02:00 +0800
Message-ID: <CALW65jaTfcJoMqZPfLjbYXd+JWvG8CciUiGRmQwc_bf2538kog@mail.gmail.com>
Subject: Re: [RFC net-next 2/4] net: dsa: mt7530: add interrupt support
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Sean Wang <sean.wang@mediatek.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sergio Paracuellos <sergio.paracuellos@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>,
        linux-staging@lists.linux.dev,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
        Weijie Gao <weijie.gao@mediatek.com>,
        Chuanhong Guo <gch981213@gmail.com>,
        =?UTF-8?Q?Ren=C3=A9_van_Dorst?= <opensource@vdorst.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 6, 2021 at 11:49 PM Andrew Lunn <andrew@lunn.ch> wrote:
> O.K. So that makes it similar to the mv88e6xxx. With that driver, i
> kept interrupt setup and mdio setup separate. I add the interrupt
> controller first, and then do mdio setup, calling a helper to map the
> PHY interrupts and assign them to bus->irq[].
>
> That gives you a cleaner structure when you start using the other
> interrupts.

Okay. Will split the function in v2. Thanks.

>
>         Andrew
