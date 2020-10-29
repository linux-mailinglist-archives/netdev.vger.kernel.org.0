Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1644929E871
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 11:10:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726131AbgJ2KIi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 06:08:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725790AbgJ2KIi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 06:08:38 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B390C0613CF;
        Thu, 29 Oct 2020 03:08:38 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id s15so2980212ejf.8;
        Thu, 29 Oct 2020 03:08:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5uc54niYl4IGmpn///qzNyRbsYw21z8bYHcrhLCDVtM=;
        b=UHgjMSwScM0Jbyf5Vdx7WpaLkDBo/tIekGWN0Rxt424g/mWZK4JLGO5oJte5flUjcd
         TCSdGwZLfVrlkmrHwSjN6tHyLmXhGIWBud5FNSgPkZklIf8vZfMBi6GeXeIo3hDqUqCG
         2smo2PwyDBsjuyTbJSzkaVJpy8u1rhrTDm9qARC+DNA8hyl9E/sRQ2xsORKqOyRlVYYs
         6nOzNJaSVF9R46yEFPISlQWK7M0w8xij1wtmmWtHE3M1qrxnNFyOgZVYvY0fHe/PSSH7
         vOstFAWuICzh0zYVm4yf3PaxBC8/NUZPXergHZZFQVLYBNtoGJp1DlN/oKMFkykeVc1d
         umUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5uc54niYl4IGmpn///qzNyRbsYw21z8bYHcrhLCDVtM=;
        b=FUJYKKaS0Kg5VNDxTzY5NjIXDIeoDhP8lcYsNygi5YSAhPdcfBL2nZx/V0aCQ2lZNC
         qFVKujcv/i6lrnvj/NcJoGg6eaJsAZ7cX6guCTXm8n7mtAPYs18geEhMTb1CP+jl51aA
         KnOVxanudFmod4xHVO940z5vZK83QNkvOU+t/9p/ZKzLwdA+L7rv1ERgltrZRV7Feniu
         t4aaM7iiBZUokJh1geh1lOucyotr/FB3N369OzYDXHuBdwNc2nAeGcupFzEjmiDUA4tS
         CIFGitCOLqrRmQtaioq+fbfkfPKktUW1MJMshi4dfF28ZUK1eRqpb6p2ygnDLOCtva1L
         NKFg==
X-Gm-Message-State: AOAM531N+roWC8O62FgInwfXqKucrhXQm/uatvIGXA8RNATscp5sd1wp
        qWoN59jFLnxRFtNNu8sJgPk=
X-Google-Smtp-Source: ABdhPJzPnxJhMWTjrh4fJdftzszrFRhW56CZkpF6Sk+I0a5dzULu+ieTvWdKFX14AwWdTlQqffXU6A==
X-Received: by 2002:a17:906:c041:: with SMTP id bm1mr3193857ejb.202.1603966116623;
        Thu, 29 Oct 2020 03:08:36 -0700 (PDT)
Received: from yoga-910.localhost ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id m1sm1198650ejj.117.2020.10.29.03.08.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2020 03:08:35 -0700 (PDT)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
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
Subject: [PATCH net-next 00/19] net: phy: add support for shared interrupts (part 1)
Date:   Thu, 29 Oct 2020 12:07:22 +0200
Message-Id: <20201029100741.462818-1-ciorneiioana@gmail.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ioana Ciornei <ioana.ciornei@nxp.com>

This patch set aims to actually add support for shared interrupts in
phylib and not only for multi-PHY devices. While we are at it,
streamline the interrupt handling in phylib.

For a bit of context, at the moment, there are multiple phy_driver ops
that deal with this subject:

- .config_intr() - Enable/disable the interrupt line.

- .ack_interrupt() - Should quiesce any interrupts that may have been
  fired.  It's also used by phylib in conjunction with .config_intr() to
  clear any pending interrupts after the line was disabled, and before
  it is going to be enabled.

- .did_interrupt() - Intended for multi-PHY devices with a shared IRQ
  line and used by phylib to discern which PHY from the package was the
  one that actually fired the interrupt.

- .handle_interrupt() - Completely overrides the default interrupt
  handling logic from phylib. The PHY driver is responsible for checking
  if any interrupt was fired by the respective PHY and choose
  accordingly if it's the one that should trigger the link state machine.

From my point of view, the interrupt handling in phylib has become
somewhat confusing with all these callbacks that actually read the same
PHY register - the interrupt status.  A more streamlined approach would
be to just move the responsibility to write an interrupt handler to the
driver (as any other device driver does) and make .handle_interrupt()
the only way to deal with interrupts.

Another advantage with this approach would be that phylib would gain
support for shared IRQs between different PHY (not just multi-PHY
devices), something which at the moment would require extending every
PHY driver anyway in order to implement their .did_interrupt() callback
and duplicate the same logic as in .ack_interrupt(). The disadvantage
of making .did_interrupt() mandatory would be that we are slightly
changing the semantics of the phylib API and that would increase
confusion instead of reducing it.

What I am proposing is the following:

- As a first step, make the .ack_interrupt() callback optional so that
  we do not break any PHY driver amid the transition.

- Every PHY driver gains a .handle_interrupt() implementation that, for
  the most part, would look like below:

	irq_status = phy_read(phydev, INTR_STATUS);
	if (irq_status < 0) {
		phy_error(phydev);
		return IRQ_NONE;
	}

	if (irq_status == 0)
		return IRQ_NONE;

	phy_trigger_machine(phydev);

	return IRQ_HANDLED;

- Remove each PHY driver's implementation of the .ack_interrupt() by
  actually taking care of quiescing any pending interrupts before
  enabling/after disabling the interrupt line.

- Finally, after all drivers have been ported, remove the
  .ack_interrupt() and .did_interrupt() callbacks from phy_driver.

This patch set is part 1 and it addresses the changes needed in phylib
and 7 PHY drivers. The rest can be found on my Github branch here:
https://github.com/IoanaCiornei/linux/commits/phylib-shared-irq

I do not have access to most of these PHY's, therefore I Cc-ed the
latest contributors to the individual PHY drivers in order to have
access, hopefully, to more regression testing.

Ioana Ciornei (19):
  net: phy: export phy_error and phy_trigger_machine
  net: phy: add a shutdown procedure
  net: phy: make .ack_interrupt() optional
  net: phy: at803x: implement generic .handle_interrupt() callback
  net: phy: at803x: remove the use of .ack_interrupt()
  net: phy: mscc: use phy_trigger_machine() to notify link change
  net: phy: mscc: implement generic .handle_interrupt() callback
  net: phy: mscc: remove the use of .ack_interrupt()
  net: phy: aquantia: implement generic .handle_interrupt() callback
  net: phy: aquantia: remove the use of .ack_interrupt()
  net: phy: broadcom: implement generic .handle_interrupt() callback
  net: phy: broadcom: remove use of ack_interrupt()
  net: phy: cicada: implement the generic .handle_interrupt() callback
  net: phy: cicada: remove the use of .ack_interrupt()
  net: phy: davicom: implement generic .handle_interrupt() calback
  net: phy: davicom: remove the use of .ack_interrupt()
  net: phy: add genphy_handle_interrupt_no_ack()
  net: phy: realtek: implement generic .handle_interrupt() callback
  net: phy: realtek: remove the use of .ack_interrupt()

 drivers/net/phy/aquantia_main.c  |  57 ++++++++++----
 drivers/net/phy/at803x.c         |  42 ++++++++--
 drivers/net/phy/bcm-cygnus.c     |   2 +-
 drivers/net/phy/bcm-phy-lib.c    |  37 ++++++++-
 drivers/net/phy/bcm-phy-lib.h    |   1 +
 drivers/net/phy/bcm54140.c       |  39 +++++++---
 drivers/net/phy/bcm63xx.c        |  20 +++--
 drivers/net/phy/bcm87xx.c        |  50 ++++++------
 drivers/net/phy/broadcom.c       |  70 ++++++++++++-----
 drivers/net/phy/cicada.c         |  35 ++++++++-
 drivers/net/phy/davicom.c        |  59 ++++++++++----
 drivers/net/phy/mscc/mscc_main.c |  70 +++++++++--------
 drivers/net/phy/phy.c            |   6 +-
 drivers/net/phy/phy_device.c     |  23 +++++-
 drivers/net/phy/realtek.c        | 128 +++++++++++++++++++++++++++----
 include/linux/phy.h              |   3 +
 16 files changed, 484 insertions(+), 158 deletions(-)

Cc: Alexandru Ardelean <alexandru.ardelean@analog.com>
Cc: Andre Edich <andre.edich@microchip.com>
Cc: Antoine Tenart <atenart@kernel.org>
Cc: Baruch Siach <baruch@tkos.co.il>
Cc: Christophe Leroy <christophe.leroy@c-s.fr>
Cc: Dan Murphy <dmurphy@ti.com>
Cc: Divya Koppera <Divya.Koppera@microchip.com>
Cc: Florian Fainelli <f.fainelli@gmail.com>
Cc: Hauke Mehrtens <hauke@hauke-m.de>
Cc: Heiner Kallweit <hkallweit1@gmail.com>
Cc: Jerome Brunet <jbrunet@baylibre.com>
Cc: Kavya Sree Kotagiri <kavyasree.kotagiri@microchip.com>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Marco Felsch <m.felsch@pengutronix.de>
Cc: Marek Vasut <marex@denx.de>
Cc: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc: Mathias Kresin <dev@kresin.me>
Cc: Maxim Kochetkov <fido_max@inbox.ru>
Cc: Michael Walle <michael@walle.cc>
Cc: Neil Armstrong <narmstrong@baylibre.com>
Cc: Nisar Sayed <Nisar.Sayed@microchip.com>
Cc: Oleksij Rempel <o.rempel@pengutronix.de>
Cc: Philippe Schenker <philippe.schenker@toradex.com>
Cc: Willy Liu <willy.liu@realtek.com>
Cc: Yuiko Oshino <yuiko.oshino@microchip.com>

-- 
2.28.0

