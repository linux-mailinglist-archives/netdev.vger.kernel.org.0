Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C9702A1124
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 23:46:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725979AbgJ3Wqi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 18:46:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725792AbgJ3Wqi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Oct 2020 18:46:38 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C412FC0613D5;
        Fri, 30 Oct 2020 15:46:37 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id s15so10720187ejf.8;
        Fri, 30 Oct 2020 15:46:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=hdzDQCqjJnyS3Rh4YggWshAkvweKf0RvdENbWdlXEkM=;
        b=CY4unsu17OUZQUauhh2Rye+vPeAYREKAhg2mX/BP1/pKALco4g6FN8LYtMFWjpB8Q3
         ThGudIMUk2SwzRFyZBUVDHpm6zylt8aOS1iOpK1gO9rMorrdB6U3yfLR+xuXzhyNDvMx
         rBfJlebdcqXgfORR3MEFyUKPPtnHCF4Xxwx3ofqaQMa2TZ1oYYuFasUCYog5op5R92Jy
         FTa4JnQff2RZ+ZI2Qei6u52Y9gsgEThw5mSeiSNG0djPec+SsDKDiAdD6NgiDNomJqZz
         Ogf2rlJmSkU1w8x5E5oxryKCPKODBzwfAbMwqKsgDJsBVrQnJP97T4gKeWysv12VPWyn
         b85Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=hdzDQCqjJnyS3Rh4YggWshAkvweKf0RvdENbWdlXEkM=;
        b=E+1D1tKd4VdnRZVviWP6ryUlqzgmCtVfLKZqkEkQjiUIIoUpQWpPh3oy/N2ODhhWpz
         qShopynnpoLaqb5H0zZE3/La5407Q0fpHqBXEhEFyeHyJa6CYML36zYLKM8XWzcRNIMc
         gURGlUXfrP2xjea8TkDRNcComgggrEztAM/4lK7Gbmj5s/eLDQrBfHqyoouyU+VqW2JZ
         Zn3vfDhGFV+TjHWsKN34/arOif6cBLDhk1r251oZC07LqxWjronDnabu//SWSGt3SC6Z
         UdYHyHMQVSRBgljpREd+buu+jGqTOWJh/oC80CkFVVAT1ax2jUIvrzxfP7bd6fDE+2l4
         1y5A==
X-Gm-Message-State: AOAM533jZN/uZTUFvISXgzj3hIf1U+CNrVvmWbzpT18eMJhTFYDNv8jj
        ShWGAPAK+9WGy5Hxd/kk5ng=
X-Google-Smtp-Source: ABdhPJyx2iiPB5QekUKLvQvIJOO45HCgd8rDjQpuJSC1lrnZ8+reRpTv1dpezghb2eQUWhLEXC14Tw==
X-Received: by 2002:a17:906:c114:: with SMTP id do20mr4645145ejc.169.1604097996471;
        Fri, 30 Oct 2020 15:46:36 -0700 (PDT)
Received: from skbuf ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id ce13sm3720161edb.32.2020.10.30.15.46.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2020 15:46:35 -0700 (PDT)
Date:   Sat, 31 Oct 2020 00:46:33 +0200
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
Message-ID: <20201030224633.wxvkt7p7pb2kfbuk@skbuf>
References: <20201029100741.462818-1-ciorneiioana@gmail.com>
 <43d672ae-c089-6621-5ab3-3a0f0303e51a@gmail.com>
 <20201030220642.ctkt2pitdvri3byt@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201030220642.ctkt2pitdvri3byt@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 31, 2020 at 12:06:42AM +0200, Vladimir Oltean wrote:
> On Fri, Oct 30, 2020 at 10:56:24PM +0100, Heiner Kallweit wrote:
> > I'd just like to avoid the term "shared interrupt", because it has
> > a well-defined meaning. Our major concern isn't shared interrupts
> > but support for multiple interrupt sources (in addition to
> > link change) in a PHY.
> 
> You may be a little bit confused Heiner.
> This series adds support for exactly _that_ meaning of shared interrupts.
> Shared interrupts (aka wired-OR on the PCB) don't work today with the
> PHY library. I have a board that won't even boot to prompt when the
> interrupt lines of its 2 PHYs are enabled, that this series fixes.
> You might need to take another look through the commit messages I'm afraid.

Maybe this diagram will help you visualize better.

time
 |
 |       PHY 1                  PHY 2 has pending IRQ
 |         |                      (e.g. link up)
 |         v                             |
 |   phy_interrupt()                     |
 |  called for PHY 1                     |
 |         |                             |
 |         v                             |
 | returns IRQ_HANDLED via               |
 |  phy_clear_interrupt()                |
 |         |                             |
 |         |                             |
 |         v                             |
 | handling of shared IRQ                |
 |     ends here                         |
 |         |                             |
 |         |                             v
 |         |                PHY 2 still has pending IRQ
 |         |            because, you know, it wasn't actually
 |         |                          serviced
 |         v                             |
 |   phy_interrupt()                     |
 |  called for PHY 1                     |
 |         |                             |
 |         v                             |
 | returns IRQ_HANDLED via               |
 |  phy_clear_interrupt()                |
 |         |                             |
 |         |                             |
 |         v                             |
 | handling of shared IRQ                |
 |     ends here                         |
 |         |                PHY 2: Hey! It's me! Over here!
 |         |                             |
 |         v                             |
 |   phy_interrupt()                     |
 |  called for PHY 1                     |
 |         |                             |
 |         v                             |
 | returns IRQ_HANDLED via               |
 |  phy_clear_interrupt()                |
 |         |                             |
 |         |                             |
 |         v                             |
 | handling of shared IRQ                |
 |     ends here                         |
 |         |                       PHY 2: Srsly?
 |         |                             |
 |         v                             |
 |   phy_interrupt()                     |
 |  called for PHY 1                     |
 |         |                             |
 |         v                             |
 |        ...                           ...
 |
 |               21 seconds later
 |
 |                  RCU stall
 v

This happens because today, the way phy_interrupt() is written, you can
only return IRQ_NONE and give the other driver a chance _if_ your driver
implements .did_interrupt(). But the kernel documentation of
.did_interrupt() only recommends to implement that function if you are a
multi-PHY package driver (otherwise stated, the hardware chip has an
embedded shared IRQ). But as things stand, _everybody_ should implement
.did_interrupt() in order for any combination of PHY drivers to support
shared IRQs.

What Ioana is proposing, and this is something that I fully agree with,
is that we just get rid of the layering where the PHY library tries to
be helpful but instead invites everybody to write systematically bad
code. Anyone knows how to write an IRQ handler with eyes closed, but the
fact that .did_interrupt() is mandatory for proper shared IRQ support is
not obvious to everybody, it seems. So let's just have a dedicated IRQ
handling function per each PHY driver, so that we don't get confused in
this sloppy mess of return values, and the code can actually be
followed.

Even _with_ Ioana's changes, there is one more textbook case of shared
interrupts causing trouble, and that is actually the reason why nobody
likes them except hardware engineers who don't get to deal with this.

time
 |
 |   PHY 1 probed
 | (module or built-in)
 |         |                   PHY 2 has pending IRQ
 |         |               (it had link up from previous
 |         v               boot, or from bootloader, etc)
 |   phy_interrupt()                     |
 |  called for PHY 1                     |
 |         |                             |
 |         v                             |
 | returns IRQ_NONE as                   |
 |     it should                         v
 |         |                PHY 2 still has pending IRQ
 |         |               but its handler wasn't called
 |         |              because its driver has not been
 |         |                        yet loaded
 |         v                             |
 |   phy_interrupt()                     |
 |  called for PHY 1                     |
 |         |                             |
 |         v                             |
 | returns IRQ_NONE as                   |
 |      it should                        v
 |         |                   PHY 2: Not again :(
 |         |                             |
 |         v                             |
 |   phy_interrupt()                     |
 |  called for PHY 1                     |
 |         |                             |
 |         v                             |
 | returns IRQ_NONE as                   |
 |      it should                        |
 |         |                             |
 |        ...                           ...
 |         |                             |
 |         |                PHY 2 driver never gets probed
 |         |               either because it's a module or
 |         |                because the system is too busy
 |         |                checking PHY 1 over and over
 |         |                again for an interrupt that
 |         |                     it did not trigger
 |         |                             |
 |        ...                           ...
 |
 |               21 seconds later
 |
 |                  RCU stall
 v

The way that it's solved is that it's never 100% solved.
This one you can just avoid, but never recover from it.
To avoid it, you must ensure from your previous boot environments
(bootloader, kexec) that the IRQ line is not pending. Because if you
leave the shared IRQ line pending, the system is kaput if it happens to
probe the drivers in the wrong order (aka don't probe first the driver
that will clear that shared IRQ). It's like Minesweeper, only worse.

That's why the shutdown hook is there, as a best-effort attempt for
Linux to clean up after itself. But we're always at the mercy of the
bootloader, or even at the mercy of chance. If the previous kernel
panicked, there's no orderly cleanup to speak of.

Hope it's clearer now.
