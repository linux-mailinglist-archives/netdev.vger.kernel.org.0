Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7061B342163
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 16:58:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230476AbhCSP5e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Mar 2021 11:57:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230461AbhCSP5N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Mar 2021 11:57:13 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39D6FC061760
        for <netdev@vger.kernel.org>; Fri, 19 Mar 2021 08:57:13 -0700 (PDT)
Received: from [2a0a:edc0:0:c01:1d::a2] (helo=drehscheibe.grey.stw.pengutronix.de)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mtr@pengutronix.de>)
        id 1lNHUt-0007z1-LF; Fri, 19 Mar 2021 16:57:11 +0100
Received: from [2a0a:edc0:0:1101:1d::39] (helo=dude03.red.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <mtr@pengutronix.de>)
        id 1lNHUs-00011D-Cq; Fri, 19 Mar 2021 16:57:10 +0100
Received: from mtr by dude03.red.stw.pengutronix.de with local (Exim 4.92)
        (envelope-from <mtr@pengutronix.de>)
        id 1lNHUs-00BilQ-9U; Fri, 19 Mar 2021 16:57:10 +0100
From:   Michael Tretter <m.tretter@pengutronix.de>
To:     netdev@vger.kernel.org, devicetree@vger.kernel.org
Cc:     m.tretter@pengutronix.de, kernel@pengutronix.de,
        robh+dt@kernel.org, andrew@lunn.ch, hkallweit1@gmail.com,
        dmurphy@ti.com
Subject: [PATCH 0/2] net: phy: dp83867: Configure LED modes via device tree
Date:   Fri, 19 Mar 2021 16:57:08 +0100
Message-Id: <20210319155710.2793637-1-m.tretter@pengutronix.de>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: mtr@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

The dp83867 has 4 LED pins, which can be multiplexed with different functions
of the phy.

This series adds a device tree binding to describe the multiplexing of the
functions to the LEDs and implements the binding for the dp83867 phy.

I found existing bindings for configuring the LED modes for other phys:

In Documentation/devicetree/bindings/net/micrel.txt, the binding is not
flexible enough for the use case in the dp83867, because there is a value for
each LED configuration, which would be a lot of values for the dp83867.

In Documentation/devicetree/bindings/net/mscc-phy-vsc8532.txt, there is a
separate property for each LED, which would work, but I found rather
unintuitive compared to how clock bindings etc. work.

The new binding defines two properties: one for the led names and another
property for the modes of the LEDs with defined values in the same order.
Currently, the binding is specific to the dp83867, but I guess that the
binding could be made more generic and used for other phys, too.

Let me know, what you think.

Michael

Michael Tretter (1):
  dt-bindings: dp83867: Add binding for LED mode configuration

Thomas Haemmerle (1):
  net: phy: dp83867: add support for changing LED modes

 .../devicetree/bindings/net/ti,dp83867.yaml   | 24 ++++++++
 drivers/net/phy/dp83867.c                     | 57 +++++++++++++++++++
 include/dt-bindings/net/ti-dp83867.h          | 16 ++++++
 3 files changed, 97 insertions(+)

-- 
2.29.2

