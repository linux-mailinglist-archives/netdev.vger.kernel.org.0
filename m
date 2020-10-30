Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 083952A1102
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 23:42:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725979AbgJ3Wmr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 18:42:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725780AbgJ3Wmq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Oct 2020 18:42:46 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 459E5C0613D5;
        Fri, 30 Oct 2020 15:42:44 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id l8so4251830wmg.3;
        Fri, 30 Oct 2020 15:42:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Ldf9nHDM5+h/GHVp04n6dFe8WCel+IPrH+AkDZsKWpk=;
        b=q8fHeQHwFpcH8+Btti7MBLlaKvAAsXw0lmlYOQA3hS/lpnsL6Svlk+zBWf22JdQFlo
         9g7pQx81QrDaH9pImRXuFcKJJDaRntC64ziCfh89lfy6poXGojJ+QiVL/owMWTDic648
         x2E0dlu3tMYsQr7D22gnxU5oKS/B5WkzzwW5UXSD22s5a8rvCIj72eEIAT8vv1lCvnkj
         3qJw5KPGYP11cgOWRFz8Nvtj9beUE4bXBMWWbJ+Liu4KacLpghHhj42YmfvAF70U4Q00
         RWug1dJtZuhVYb1o5BNMCv6WsaSnUZUCJ673dL+hIaxoeuF2SW5nA6CCRqn44HMTFNwb
         BdmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Ldf9nHDM5+h/GHVp04n6dFe8WCel+IPrH+AkDZsKWpk=;
        b=tB5HF5NYkWRBhDrY8XvM3ioWi4t3tvkGqh9QWcdWBTbylHja5ljEeu4hq0HYpNRcb7
         kQ+qrBWP5G40wkKssJn1NJZJknKvqQun89rvLS78j5GDZUNaMFST2Ntw03Z/cnNfBsAF
         Bx2TxXNhV67t/2WG0eJvI2vVseQZztEXA/FkXw8S2FQT7OLF+Bmq1WQ2fP6gfB+s4kyu
         h6TSO+Yv14o570P0+KHe3Zm1LjjgwgZGDfTF0sZbWEWK/a6RcqO/Zn4BfM2PqLgai+gZ
         9jKCWY3D8ojmpUuhtyIACYYacVgCMMWayz5qhncOhNS5ad7MIlE5mgHcN3ROH7Nm0yM4
         GsYQ==
X-Gm-Message-State: AOAM532bQjflUtQrEpqUoD9/fw4gL75QZLdazCn+DPspVb2/a8lXRrUa
        hnC38KDZkWywxF8PBVj7Zsw=
X-Google-Smtp-Source: ABdhPJx1x2944kgjZpsTiIgxsBur0xID9tM8JaIEMFbmoyzo2G5OoFWn5Ga6E2+HEJAIJ7GwfRXcGQ==
X-Received: by 2002:a1c:9695:: with SMTP id y143mr4829432wmd.146.1604097762971;
        Fri, 30 Oct 2020 15:42:42 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f23:2800:9d19:4c77:c465:2524? (p200300ea8f2328009d194c77c4652524.dip0.t-ipconnect.de. [2003:ea:8f23:2800:9d19:4c77:c465:2524])
        by smtp.googlemail.com with ESMTPSA id u3sm10806096wro.33.2020.10.30.15.42.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 30 Oct 2020 15:42:42 -0700 (PDT)
Subject: Re: [PATCH net-next 00/19] net: phy: add support for shared
 interrupts (part 1)
To:     Ioana Ciornei <ciorneiioana@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>,
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
References: <20201029100741.462818-1-ciorneiioana@gmail.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <d05587fc-0cec-59fb-4e84-65386d0b3d6b@gmail.com>
Date:   Fri, 30 Oct 2020 23:42:36 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201029100741.462818-1-ciorneiioana@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 29.10.2020 11:07, Ioana Ciornei wrote:
> From: Ioana Ciornei <ioana.ciornei@nxp.com>
> 
> This patch set aims to actually add support for shared interrupts in
> phylib and not only for multi-PHY devices. While we are at it,
> streamline the interrupt handling in phylib.
> 
> For a bit of context, at the moment, there are multiple phy_driver ops
> that deal with this subject:
> 
> - .config_intr() - Enable/disable the interrupt line.
> 
> - .ack_interrupt() - Should quiesce any interrupts that may have been
>   fired.  It's also used by phylib in conjunction with .config_intr() to
>   clear any pending interrupts after the line was disabled, and before
>   it is going to be enabled.
> 
> - .did_interrupt() - Intended for multi-PHY devices with a shared IRQ
>   line and used by phylib to discern which PHY from the package was the
>   one that actually fired the interrupt.
> 
> - .handle_interrupt() - Completely overrides the default interrupt
>   handling logic from phylib. The PHY driver is responsible for checking
>   if any interrupt was fired by the respective PHY and choose
>   accordingly if it's the one that should trigger the link state machine.
> 
>>From my point of view, the interrupt handling in phylib has become
> somewhat confusing with all these callbacks that actually read the same
> PHY register - the interrupt status.  A more streamlined approach would
> be to just move the responsibility to write an interrupt handler to the
> driver (as any other device driver does) and make .handle_interrupt()
> the only way to deal with interrupts.
> 
> Another advantage with this approach would be that phylib would gain
> support for shared IRQs between different PHY (not just multi-PHY
> devices), something which at the moment would require extending every
> PHY driver anyway in order to implement their .did_interrupt() callback
> and duplicate the same logic as in .ack_interrupt(). The disadvantage
> of making .did_interrupt() mandatory would be that we are slightly
> changing the semantics of the phylib API and that would increase
> confusion instead of reducing it.
> 
> What I am proposing is the following:
> 
> - As a first step, make the .ack_interrupt() callback optional so that
>   we do not break any PHY driver amid the transition.
> 
> - Every PHY driver gains a .handle_interrupt() implementation that, for
>   the most part, would look like below:
> 
> 	irq_status = phy_read(phydev, INTR_STATUS);
> 	if (irq_status < 0) {
> 		phy_error(phydev);
> 		return IRQ_NONE;
> 	}
> 
> 	if (irq_status == 0)

Here I have a concern, bits may be set even if the respective interrupt
source isn't enabled. Therefore we may falsely blame a device to have
triggered the interrupt. irq_status should be masked with the actually
enabled irq source bits.

> 		return IRQ_NONE;
> 
> 	phy_trigger_machine(phydev);
> 
> 	return IRQ_HANDLED;
> 
> - Remove each PHY driver's implementation of the .ack_interrupt() by
>   actually taking care of quiescing any pending interrupts before
>   enabling/after disabling the interrupt line.
> 
> - Finally, after all drivers have been ported, remove the
>   .ack_interrupt() and .did_interrupt() callbacks from phy_driver.
> 
> This patch set is part 1 and it addresses the changes needed in phylib
> and 7 PHY drivers. The rest can be found on my Github branch here:
> https://github.com/IoanaCiornei/linux/commits/phylib-shared-irq
> 
> I do not have access to most of these PHY's, therefore I Cc-ed the
> latest contributors to the individual PHY drivers in order to have
> access, hopefully, to more regression testing.
> 
> Ioana Ciornei (19):
>   net: phy: export phy_error and phy_trigger_machine
>   net: phy: add a shutdown procedure
>   net: phy: make .ack_interrupt() optional
>   net: phy: at803x: implement generic .handle_interrupt() callback
>   net: phy: at803x: remove the use of .ack_interrupt()
>   net: phy: mscc: use phy_trigger_machine() to notify link change
>   net: phy: mscc: implement generic .handle_interrupt() callback
>   net: phy: mscc: remove the use of .ack_interrupt()
>   net: phy: aquantia: implement generic .handle_interrupt() callback
>   net: phy: aquantia: remove the use of .ack_interrupt()
>   net: phy: broadcom: implement generic .handle_interrupt() callback
>   net: phy: broadcom: remove use of ack_interrupt()
>   net: phy: cicada: implement the generic .handle_interrupt() callback
>   net: phy: cicada: remove the use of .ack_interrupt()
>   net: phy: davicom: implement generic .handle_interrupt() calback
>   net: phy: davicom: remove the use of .ack_interrupt()
>   net: phy: add genphy_handle_interrupt_no_ack()
>   net: phy: realtek: implement generic .handle_interrupt() callback
>   net: phy: realtek: remove the use of .ack_interrupt()
> 
>  drivers/net/phy/aquantia_main.c  |  57 ++++++++++----
>  drivers/net/phy/at803x.c         |  42 ++++++++--
>  drivers/net/phy/bcm-cygnus.c     |   2 +-
>  drivers/net/phy/bcm-phy-lib.c    |  37 ++++++++-
>  drivers/net/phy/bcm-phy-lib.h    |   1 +
>  drivers/net/phy/bcm54140.c       |  39 +++++++---
>  drivers/net/phy/bcm63xx.c        |  20 +++--
>  drivers/net/phy/bcm87xx.c        |  50 ++++++------
>  drivers/net/phy/broadcom.c       |  70 ++++++++++++-----
>  drivers/net/phy/cicada.c         |  35 ++++++++-
>  drivers/net/phy/davicom.c        |  59 ++++++++++----
>  drivers/net/phy/mscc/mscc_main.c |  70 +++++++++--------
>  drivers/net/phy/phy.c            |   6 +-
>  drivers/net/phy/phy_device.c     |  23 +++++-
>  drivers/net/phy/realtek.c        | 128 +++++++++++++++++++++++++++----
>  include/linux/phy.h              |   3 +
>  16 files changed, 484 insertions(+), 158 deletions(-)
> 
> Cc: Alexandru Ardelean <alexandru.ardelean@analog.com>
> Cc: Andre Edich <andre.edich@microchip.com>
> Cc: Antoine Tenart <atenart@kernel.org>
> Cc: Baruch Siach <baruch@tkos.co.il>
> Cc: Christophe Leroy <christophe.leroy@c-s.fr>
> Cc: Dan Murphy <dmurphy@ti.com>
> Cc: Divya Koppera <Divya.Koppera@microchip.com>
> Cc: Florian Fainelli <f.fainelli@gmail.com>
> Cc: Hauke Mehrtens <hauke@hauke-m.de>
> Cc: Heiner Kallweit <hkallweit1@gmail.com>
> Cc: Jerome Brunet <jbrunet@baylibre.com>
> Cc: Kavya Sree Kotagiri <kavyasree.kotagiri@microchip.com>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Cc: Marco Felsch <m.felsch@pengutronix.de>
> Cc: Marek Vasut <marex@denx.de>
> Cc: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
> Cc: Mathias Kresin <dev@kresin.me>
> Cc: Maxim Kochetkov <fido_max@inbox.ru>
> Cc: Michael Walle <michael@walle.cc>
> Cc: Neil Armstrong <narmstrong@baylibre.com>
> Cc: Nisar Sayed <Nisar.Sayed@microchip.com>
> Cc: Oleksij Rempel <o.rempel@pengutronix.de>
> Cc: Philippe Schenker <philippe.schenker@toradex.com>
> Cc: Willy Liu <willy.liu@realtek.com>
> Cc: Yuiko Oshino <yuiko.oshino@microchip.com>
> 

