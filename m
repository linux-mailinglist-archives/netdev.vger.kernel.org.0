Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBBD92B0961
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 17:01:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728778AbgKLP6S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 10:58:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728758AbgKLP6R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 10:58:17 -0500
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBEB3C0613D1;
        Thu, 12 Nov 2020 07:58:16 -0800 (PST)
Received: by mail-ed1-x543.google.com with SMTP id t11so6806798edj.13;
        Thu, 12 Nov 2020 07:58:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=IKZ0bJ9wrwGZuyOlCMns8U747V5thrsJagTuvXdjRs0=;
        b=Gs8ocfeIX5ONLTW9ozPMdd5HxbyWWOMRw0clObL+hMWt9zjgrj+mqHC3l0hDF/ihpR
         DJUWlmAB55Um9PVdhFg6BxBQwLnccJ6gvQCEvmmc7rwXDC9yBI7Rw16wZFFL5crH7axI
         td1JPfk8bXScK0WJiOapCmD654WwYW/B0rwOC66G4hlHN1KeIboP+ly9kS4gu6hqaZYr
         h+3EsBMudz0I8+DXsbmN9zakoT4Uc457QjDZmdGGftqsknUGE9hj2pPkKVK3wAqnhPE9
         7cCgqVjah66y8F3wsvSrDbZq6Jbmq6u4mwna8NROEOYrXyONvZvfsU1plBBlKxZCpmot
         4nsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=IKZ0bJ9wrwGZuyOlCMns8U747V5thrsJagTuvXdjRs0=;
        b=bkLFeJwutvx6rbiCzT9eHMDknjyTul94x6z+iSTwYkB+6LLwYheUH+D/A0570VImTU
         U5f02IKxPPtFFLDDg5uWoqJZGCwag/fq0Y7NwxXkxxF3aStPZCkMRF4unttob0PtN/pA
         ycMckC3NIHu/OFf6Y4VbWWeJ7t35wlevLvyTEwxv/dYyFd2LOKhUvlXX3rLA8BqUXj3F
         cpu/wj0/U0csqZn32trW/1btrXoyjsxxNgu7u1XXLy9u+rGIoKM9Iq8baH2lOFya6YWl
         io2NfqidpiO6nKgTyEJv2Md/WLnZcBEtNNIyobWflLhv+5FeHjNMW3mKE7UajxH/Nj6D
         UBAA==
X-Gm-Message-State: AOAM530JTnYQvZGXSx0cREF5NED8ZA3AntPJ3VkIz3EMj1yrd7VCcMY7
        ugZlzwAAZQ9BcqxOwpPCx4I=
X-Google-Smtp-Source: ABdhPJy2UZAtvuJnRjXYWNnt+bVbjdvt647JwfqbQixYhwXBCSp3DqML+BXBoswntePYKr4UYLkqDA==
X-Received: by 2002:a50:d784:: with SMTP id w4mr391175edi.201.1605196695371;
        Thu, 12 Nov 2020 07:58:15 -0800 (PST)
Received: from yoga-910.localhost ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id q15sm2546540edt.95.2020.11.12.07.58.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2020 07:58:14 -0800 (PST)
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
        Baruch Siach <baruch@tkos.co.il>,
        Christophe Leroy <christophe.leroy@c-s.fr>,
        Kavya Sree Kotagiri <kavyasree.kotagiri@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Marco Felsch <m.felsch@pengutronix.de>,
        Marek Vasut <marex@denx.de>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Nisar Sayed <Nisar.Sayed@microchip.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Robert Hancock <robert.hancock@calian.com>,
        Yuiko Oshino <yuiko.oshino@microchip.com>
Subject: [PATCH net-next 00/18] net: phy: add support for shared interrupts (part 2)
Date:   Thu, 12 Nov 2020 17:54:55 +0200
Message-Id: <20201112155513.411604-1-ciorneiioana@gmail.com>
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

This patch set is part 2 of the entire change set and it addresses the
changes needed in 9 PHY drivers. The rest can be found on my Github
branch here:
https://github.com/IoanaCiornei/linux/commits/phylib-shared-irq

I do not have access to most of these PHY's, therefore I Cc-ed the
latest contributors to the individual PHY drivers in order to have
access, hopefully, to more regression testing.

Ioana Ciornei (18):
  net: phy: vitesse: implement generic .handle_interrupt() callback
  net: phy: vitesse: remove the use of .ack_interrupt()
  net: phy: microchip: implement generic .handle_interrupt() callback
  net: phy: microchip: remove the use of .ack_interrupt()
  net: phy: marvell: implement generic .handle_interrupt() callback
  net: phy: marvell: remove the use of .ack_interrupt()
  net: phy: lxt: implement generic .handle_interrupt() callback
  net: phy: lxt: remove the use of .ack_interrupt()
  net: phy: nxp-tja11xx: implement generic .handle_interrupt() callback
  net: phy: nxp-tja11xx: remove the use of .ack_interrupt()
  net: phy: amd: implement generic .handle_interrupt() callback
  net: phy: amd: remove the use of .ack_interrupt()
  net: phy: smsc: implement generic .handle_interrupt() callback
  net: phy: smsc: remove the use of .ack_interrupt()
  net: phy: ste10Xp: implement generic .handle_interrupt() callback
  net: phy: ste10Xp: remove the use of .ack_interrupt()
  net: phy: adin: implement generic .handle_interrupt() callback
  net: phy: adin: remove the use of the .ack_interrupt()

 drivers/net/phy/adin.c         | 45 +++++++++++++---
 drivers/net/phy/amd.c          | 37 +++++++++++--
 drivers/net/phy/lxt.c          | 94 ++++++++++++++++++++++++++++++----
 drivers/net/phy/marvell.c      | 88 ++++++++++++++++---------------
 drivers/net/phy/microchip.c    | 24 +++++++--
 drivers/net/phy/microchip_t1.c | 28 +++++++---
 drivers/net/phy/nxp-tja11xx.c  | 42 +++++++++++++--
 drivers/net/phy/smsc.c         | 55 ++++++++++++++++----
 drivers/net/phy/ste10Xp.c      | 53 +++++++++++++------
 drivers/net/phy/vitesse.c      | 61 ++++++++++++++--------
 10 files changed, 405 insertions(+), 122 deletions(-)

Cc: Alexandru Ardelean <alexandru.ardelean@analog.com>
Cc: Andre Edich <andre.edich@microchip.com>
Cc: Baruch Siach <baruch@tkos.co.il>
Cc: Christophe Leroy <christophe.leroy@c-s.fr>
Cc: Kavya Sree Kotagiri <kavyasree.kotagiri@microchip.com>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Marco Felsch <m.felsch@pengutronix.de>
Cc: Marek Vasut <marex@denx.de>
Cc: Maxim Kochetkov <fido_max@inbox.ru>
Cc: Nisar Sayed <Nisar.Sayed@microchip.com>
Cc: Oleksij Rempel <o.rempel@pengutronix.de>
Cc: Robert Hancock <robert.hancock@calian.com>
Cc: Yuiko Oshino <yuiko.oshino@microchip.com>

-- 
2.28.0

