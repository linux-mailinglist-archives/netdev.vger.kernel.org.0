Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A24B82C0EFB
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 16:40:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389542AbgKWPio (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 10:38:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730956AbgKWPim (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Nov 2020 10:38:42 -0500
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67D29C0613CF;
        Mon, 23 Nov 2020 07:38:42 -0800 (PST)
Received: by mail-ej1-x62b.google.com with SMTP id f23so23941292ejk.2;
        Mon, 23 Nov 2020 07:38:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=DWXhh3DFHIhh3qb0m/ol0Y43T5CsgoKeo5vg1kRBGns=;
        b=BQwhXEDhefCTq8drpN1aWVrHxE+3km1BjCi2lrIOVzbAFur/OI5/LBa+iFAuLkGkNE
         /ha9+fJLSjSoqd26SskWY+kBdEYHKxzwakuCsSLKf0Tf786uOqE8C9Zulcis9gYSTeXH
         KGC4h36hGpyubCX4YQWHke6jMM+6zivLV80r4SKNYxczbEdXSIpRpepLWLcvdf35SPMA
         PmqMrxE9ic2IwhHMWQCS3LEjX8plC6OCPk2lqOF54qE5ZCbVun8pjtkDfSQKtu15Xqtx
         +o2eRcH+xnuC9p/SwxroZ6NWOnG+PUvsicw8AXVhjWeO+us3DkeMrM81jStjd8cCuZho
         lGKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=DWXhh3DFHIhh3qb0m/ol0Y43T5CsgoKeo5vg1kRBGns=;
        b=DHQQdv0hKaV9pTSzErxI6Q7czIAZC9+dFKVzal70ISLH9jYGXzsUI8dgAyg0JfBNoq
         VGHmPn396Vz9aU5fFEhFAMVk9mDAL++k9TQ9NKJya1eBH6Twmf4EvOPV7Bse8RcKZ3+u
         LmWnWjZjEXvHH0OGSRW4rbcJ6ogqjchy+/rSsy8II1hJikMb9D1hoyR8fCxiasyc3/tP
         bQRcf4dbwC93GbV0Zc3Z20824jYeWlFlxIG6UbgU5Xfty+HrfIAufe0atXnQG+E9FDil
         BCENI04MHKYVNNJhF3XLLSOZKm9GDkGKsS2lLSqbRlMBIqfmfHXmoKhJoKpm4an1KEvi
         +0bg==
X-Gm-Message-State: AOAM530rbwCoR3jla/OLW6mff6haDwTTFE5tiKFY3CiYqXK4Smn/zCGn
        El1pRLD0hXO7Urs7CqMA+aqr9fJY7tM=
X-Google-Smtp-Source: ABdhPJwzqsKyYEKEU5Kxf08U2i6w6Xjllvl4oB9MhHhApbhCgiRshdPluotVDyuO7p5MyJr6hPJ7sw==
X-Received: by 2002:a17:906:d8b0:: with SMTP id qc16mr187096ejb.268.1606145918378;
        Mon, 23 Nov 2020 07:38:38 -0800 (PST)
Received: from yoga-910.localhost ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id c6sm4800126edy.62.2020.11.23.07.38.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2020 07:38:37 -0800 (PST)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>,
        Antoine Tenart <atenart@kernel.org>,
        Dan Murphy <dmurphy@ti.com>,
        Divya Koppera <Divya.Koppera@microchip.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Jerome Brunet <jbrunet@baylibre.com>,
        Marek Vasut <marex@denx.de>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Mathias Kresin <dev@kresin.me>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Philippe Schenker <philippe.schenker@toradex.com>
Subject: [PATCH net-next 00/15] net: phy: add support for shared interrupts (part 3)
Date:   Mon, 23 Nov 2020 17:38:02 +0200
Message-Id: <20201123153817.1616814-1-ciorneiioana@gmail.com>
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

This patch set is part 3 (and final) of the entire change set and it
addresses the remaining PHY drivers that have not been migrated
previosly. Also, it finally removed the .did_interrupt() and
.ack_interrupt() callbacks since they are of no use anymore.

I do not have access to most of these PHY's, therefore I Cc-ed the
latest contributors to the individual PHY drivers in order to have
access, hopefully, to more regression testing.

Ioana Ciornei (15):
  net: phy: intel-xway: implement generic .handle_interrupt() callback
  net: phy: intel-xway: remove the use of .ack_interrupt()
  net: phy: icplus: implement generic .handle_interrupt() callback
  net: phy: icplus: remove the use .ack_interrupt()
  net: phy: meson-gxl: implement generic .handle_interrupt() callback
  net: phy: meson-gxl: remove the use of .ack_callback()
  net: phy: micrel: implement generic .handle_interrupt() callback
  net: phy: micrel: remove the use of .ack_interrupt()
  net: phy: national: implement generic .handle_interrupt() callback
  net: phy: national: remove the use of the .ack_interrupt()
  net: phy: ti: implement generic .handle_interrupt() callback
  net: phy: ti: remove the use of .ack_interrupt()
  net: phy: qsemi: implement generic .handle_interrupt() callback
  net: phy: qsemi: remove the use of .ack_interrupt()
  net: phy: remove the .did_interrupt() and .ack_interrupt() callback

 drivers/net/phy/dp83640.c    | 38 ++++++++++++++++++-
 drivers/net/phy/dp83822.c    | 54 ++++++++++++++++++---------
 drivers/net/phy/dp83848.c    | 47 +++++++++++++++++++++++-
 drivers/net/phy/dp83867.c    | 44 +++++++++++++++++++---
 drivers/net/phy/dp83869.c    | 42 +++++++++++++++++++--
 drivers/net/phy/dp83tc811.c  | 53 ++++++++++++++++++++++++++-
 drivers/net/phy/icplus.c     | 58 +++++++++++++++++++----------
 drivers/net/phy/intel-xway.c | 71 +++++++++++++++++++++---------------
 drivers/net/phy/meson-gxl.c  | 37 +++++++++++++++----
 drivers/net/phy/micrel.c     | 65 +++++++++++++++++++++++++--------
 drivers/net/phy/national.c   | 58 ++++++++++++++++++++++-------
 drivers/net/phy/phy.c        | 48 +-----------------------
 drivers/net/phy/phy_device.c |  2 +-
 drivers/net/phy/qsemi.c      | 42 +++++++++++++++++++--
 include/linux/phy.h          | 19 ++--------
 15 files changed, 497 insertions(+), 181 deletions(-)

Cc: Antoine Tenart <atenart@kernel.org>
Cc: Dan Murphy <dmurphy@ti.com>
Cc: Divya Koppera <Divya.Koppera@microchip.com>
Cc: Hauke Mehrtens <hauke@hauke-m.de>
Cc: Jerome Brunet <jbrunet@baylibre.com>
Cc: Marek Vasut <marex@denx.de>
Cc: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc: Mathias Kresin <dev@kresin.me>
Cc: Neil Armstrong <narmstrong@baylibre.com>
Cc: Oleksij Rempel <o.rempel@pengutronix.de>
Cc: Philippe Schenker <philippe.schenker@toradex.com>

-- 
2.28.0

