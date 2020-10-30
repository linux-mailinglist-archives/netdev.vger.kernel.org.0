Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 995142A10AA
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 23:06:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725907AbgJ3WGr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 18:06:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725797AbgJ3WGr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Oct 2020 18:06:47 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B17DC0613CF;
        Fri, 30 Oct 2020 15:06:46 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id l16so8246699eds.3;
        Fri, 30 Oct 2020 15:06:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=3EaeiHxHi/g6G5ROqfUs+oSpGqvS/KG2JfUQSdxi54I=;
        b=jS4KKAUFecGNEOaIehjt4dH23+K9OgYnyWTkDWQBAl4AnOvzUjP8mIav1q4sUoonVN
         tdgidoJkouQQgQePhOX19OxC/sn97hDaxerSTNrsV7w2llPc2aa6h9hvZV2RfmmBC5dY
         7ALBRyLrdFrhXaCo+Xos3Cvjaxd/TMW/CYoJQGxjJkf3zAKlORPVXrZReBNLdLTWe8D7
         1oH+QAQGyCdjwoyQRAvn5Z8EHlzJ9nDkwwT9Va4zwjFEN55QxLqSCSIVLVQ97TYU4JhS
         AeiYEF7PXzVMPHKnbg9v3o3Wqf8/s5hwhrUd5K+8gOZLUxJsQ3vV/tU6+gLcGUgQBbvz
         WIuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=3EaeiHxHi/g6G5ROqfUs+oSpGqvS/KG2JfUQSdxi54I=;
        b=QxjqjnLVNeVXlJBJ9wP3CIOU9z6o9cNe9kjwbDQ4BZsqgUlgQ9YgdQTSvpAPHFCABk
         pQUKajQ/BbG3dhvIGnL7XsTmElviMTYpSnTpKokL/iQu3u+nWIIrQbc6AUhf/g+hQuG8
         hRDRdg1Agg62Z0G8VVsWigHvxJcgtaGalGxBuW4j2nLsXj9UVfaUgooZ51WtUsO7kBC9
         AnkbxDlUt4Gy9lN699iPLWhdKO7DUXs9kEt8Fvecyq8aTFXxWYQUGGQlmjBgmVLG0rxI
         bS8uUdS82pZIdDyrVbiS4pjNaffXfCjOZYUlWXPowYEgUdwscRbh3QPacDM5C3IZ++gE
         OYiA==
X-Gm-Message-State: AOAM530sud94AkhzU7E0P3woRnu1gJvrC8gMffhyiYfsUJ/JCjqRTOMa
        I8Q2Hn9hYUwpUFLMs57kXtusUgCK/aTWww==
X-Google-Smtp-Source: ABdhPJx6iiK9+gLKNAIeuGTGcAdKai1w8pMO5FmSZLu+Gmv0ak537VpCQhzV6qRtUsi72b4dWsphBQ==
X-Received: by 2002:a05:6402:187:: with SMTP id r7mr4628793edv.360.1604095605113;
        Fri, 30 Oct 2020 15:06:45 -0700 (PDT)
Received: from skbuf ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id bw25sm3455667ejb.119.2020.10.30.15.06.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2020 15:06:44 -0700 (PDT)
Date:   Sat, 31 Oct 2020 00:06:42 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Ioana Ciornei <ciorneiioana@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>,
        Andre Edich <andre.edich@microchip.com>,
        Antoine Tenart <atenart@kernel.org>,
        Baruch Siach <baruch@tkos.co.il>,
        Christophe Leroy <christophe.leroy@c-s.fr>,
        Dan Murphy <dmurphy@ti.com>,
        Divya Koppera <Divya.Koppera@microchip.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Jerome Brunet <jbrunet@baylibre.com>,
        Kavya Sree Kotagiri <kavyasree.kotagiri@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Marco Felsch <m.felsch@pengutronix.de>,
        Marek Vasut <marex@denx.de>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Mathias Kresin <dev@kresin.me>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Michael Walle <michael@walle.cc>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Nisar Sayed <Nisar.Sayed@microchip.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Philippe Schenker <philippe.schenker@toradex.com>,
        Willy Liu <willy.liu@realtek.com>,
        Yuiko Oshino <yuiko.oshino@microchip.com>
Subject: Re: [PATCH net-next 00/19] net: phy: add support for shared
 interrupts (part 1)
Message-ID: <20201030220642.ctkt2pitdvri3byt@skbuf>
References: <20201029100741.462818-1-ciorneiioana@gmail.com>
 <43d672ae-c089-6621-5ab3-3a0f0303e51a@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <43d672ae-c089-6621-5ab3-3a0f0303e51a@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 30, 2020 at 10:56:24PM +0100, Heiner Kallweit wrote:
> I'd just like to avoid the term "shared interrupt", because it has
> a well-defined meaning. Our major concern isn't shared interrupts
> but support for multiple interrupt sources (in addition to
> link change) in a PHY.

You may be a little bit confused Heiner.
This series adds support for exactly _that_ meaning of shared interrupts.
Shared interrupts (aka wired-OR on the PCB) don't work today with the
PHY library. I have a board that won't even boot to prompt when the
interrupt lines of its 2 PHYs are enabled, that this series fixes.
You might need to take another look through the commit messages I'm afraid.
