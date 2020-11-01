Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4DD42A1DFD
	for <lists+netdev@lfdr.de>; Sun,  1 Nov 2020 13:52:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726595AbgKAMwU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Nov 2020 07:52:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726529AbgKAMwT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Nov 2020 07:52:19 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4049CC0617A6;
        Sun,  1 Nov 2020 04:52:19 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id a71so5992405edf.9;
        Sun, 01 Nov 2020 04:52:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CE8O+iXI0LJQAsd2XN/mBfygYe3MHSbV6Xjjfa6myGg=;
        b=bY3KGijKaZrE+H+4EsPcZmNIRwa4Vjrq7mHtOlk6+J1WA2vOton0rok6K/p04jo65T
         3DCp8WpK1mS2PP12IjfvMrBP5+reSuvhg2ynMWm27yaor6SwNNQg/SIkxGK1gZgRCL/f
         keIZczOna4QAURVs/U6gatYSl1ERiqcUNxBOKw2pDMmNjhwbpFVFg9OCX/b0HVJ7w47Z
         2FeU52pcu4rLzEkiIm3PpW/X+9gTnBzyERwJ9dJ54pu2y62zXXc/VhYLRyu0ce+ZFqN1
         wN4HpdvfrATBK2+lThQ4Wf4NlMV5LERSffNDEJRu4PTrcGZPLF9GvGoW/P47pfaNo1xH
         RL/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CE8O+iXI0LJQAsd2XN/mBfygYe3MHSbV6Xjjfa6myGg=;
        b=U6WYiGdP+R9WtyYYaUCUvf+5lp1ZpTiPz3naIBqf0lfv058OpZ/DGVXyhL4AV0ZNM/
         fMVUxdqjpM1WX6o5rJN9fcCShjuh4OnsQReMN+2fkVbK+2uR7O+7gkMVA1Dc46SvYTFI
         oIOsIEGPUvKpHWNJFeXO+5woPRj8XTTmbjivN77w+ev7eedUwaooe5dEvBt3umqGJ2Qh
         inVyPH9CC1Ru9KUHFStAlvP5hbv07e3gNn+6zqvw3zAXX0EQqNLmyCPO4leIMw9eQsH+
         prVFKk6dNUnHiLpkDHoSpfMp033M1nhD4e8PP77b9FcKa6rV658T+petkW+lv1/h5p50
         MdsQ==
X-Gm-Message-State: AOAM530yrKw4XjDVraJmUofotSDQd1ndvRSGWS3pIbWkFtq0Yj0Hoq7y
        PrvJ/rik0I7ZTClXQjAHjlk=
X-Google-Smtp-Source: ABdhPJzHILBkIMTJrRxPo/2zBo0IQx3U94dogfMJZ3V76uANNJmcFhHb4q8WbExTEKfOoaMnXGixtw==
X-Received: by 2002:a05:6402:2292:: with SMTP id cw18mr12199049edb.112.1604235137193;
        Sun, 01 Nov 2020 04:52:17 -0800 (PST)
Received: from yoga-910.localhost ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id c5sm8133603edx.58.2020.11.01.04.52.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Nov 2020 04:52:16 -0800 (PST)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
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
Subject: [PATCH net-next v2 00/19] net: phy: add support for shared interrupts (part 1)
Date:   Sun,  1 Nov 2020 14:50:55 +0200
Message-Id: <20201101125114.1316879-1-ciorneiioana@gmail.com>
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

	if (!(irq_status & irq_mask))
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

Changes in v2:
 - Rework the .handle_interrupt() implementation for each driver so that
   only the enabled interrupts are taken into account when
   IRQ_NONE/IRQ_HANDLED it returned. The main idea is so that we avoid
   falsely blaming a device for triggering an interrupt when this is not
   the case.
   The only devices for which I was unable to make this adjustment were
   the BCM8706, BCM8727, BCMAC131 and BCM5241 since I do not have access
   to their datasheets.
 - I also updated the pseudo-code added in the cover-letter so that it's
   more clear how a .handle_interrupt() callback should look like.

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

 drivers/net/phy/aquantia_main.c  |  59 +++++++++----
 drivers/net/phy/at803x.c         |  50 +++++++++--
 drivers/net/phy/bcm-cygnus.c     |   2 +-
 drivers/net/phy/bcm-phy-lib.c    |  49 ++++++++++-
 drivers/net/phy/bcm-phy-lib.h    |   1 +
 drivers/net/phy/bcm54140.c       |  46 +++++++---
 drivers/net/phy/bcm63xx.c        |  20 +++--
 drivers/net/phy/bcm87xx.c        |  50 ++++++-----
 drivers/net/phy/broadcom.c       |  70 +++++++++++-----
 drivers/net/phy/cicada.c         |  35 +++++++-
 drivers/net/phy/davicom.c        |  63 ++++++++++----
 drivers/net/phy/mscc/mscc_main.c |  70 ++++++++--------
 drivers/net/phy/phy.c            |   6 +-
 drivers/net/phy/phy_device.c     |  23 ++++-
 drivers/net/phy/realtek.c        | 140 +++++++++++++++++++++++++++----
 include/linux/phy.h              |   3 +
 16 files changed, 529 insertions(+), 158 deletions(-)

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

