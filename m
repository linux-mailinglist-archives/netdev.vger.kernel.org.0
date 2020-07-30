Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A12E4233966
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 21:58:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730627AbgG3T6K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 15:58:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726838AbgG3T6H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jul 2020 15:58:07 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34F47C061574
        for <netdev@vger.kernel.org>; Thu, 30 Jul 2020 12:58:07 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id f7so26030386wrw.1
        for <netdev@vger.kernel.org>; Thu, 30 Jul 2020 12:58:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bcPqhsvqsE2643w+eIzGN/iXUqPT8svg+jyoJiKV7Ps=;
        b=SnOYUNHkhe1nmFDQKTTtDH8/iEGWM51J+nKaIY0hZP+gPh73+w26pSQidrPHw5FmeD
         q831L7MWWoXO5Ebszc68u5poWcySLPwqW/SwWg6WWD1mmkf3weP6/adDDbxPk8L4w9DL
         nnIILBSRumcoDqSYzcW09bey09QYTLbgUXhi+MwXnEhWyj/syA4dXihwH2/7qgSMwoN3
         MFIGn1t1OsaSz8lY7fawYbFewOg+b/acf+SBXZ9T+8SuEjVUa6Iv4hXVXRc9dQF4214G
         8OhbOptSJHLeDF/UX0eRvsQBbIi3whpjsXK7OqMT3S6I0GVNUjMYi5NlYdRQ/LDD009I
         OE1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bcPqhsvqsE2643w+eIzGN/iXUqPT8svg+jyoJiKV7Ps=;
        b=oMK2/WmQ9hypsoLxsk7x2/jXkfiZax2z+SKzOYcScXxN/EAAHDDSkT1vvfR2SljulC
         LWdIR5V4YQOxWx0BOjn4CdRbo9LjvTNLoKTT0CNtnJXMtJgxpnlgYI/j0B8W2iwPD034
         z/Jb/4wY3pYsBDc1cB6c6r3iWPtdyJb/KnfYhobglfH5DghUVsk7D7neRB0yfG4CTdlF
         4h202ed8IpiIHfUJZ/hnhtm8emhujfGP8La/Tagt9rdklJBTcnuUka34jSGy2O5+9e/V
         8EkiSWMQD1QDGCaB+2NrKTrk7L3bdxt55SLz4WTuV6e+GqoCOpKtaIlEvCgFIviUYBu1
         s2+w==
X-Gm-Message-State: AOAM530GsFE3UtC2UyoV6iA0G2kRABjNoESEDPHM29erMkflLXnESa8E
        em+at11cNiH6ZwlZYko+wRUhqaX/9tuXvQ==
X-Google-Smtp-Source: ABdhPJwLPjdzcxbx9XGcE3Crh1zpkNKql5Rjt47noZMaZFi149M3x9Z6Mv5/VZb0C6bipAvGGYutEQ==
X-Received: by 2002:adf:f847:: with SMTP id d7mr306940wrq.328.1596139085613;
        Thu, 30 Jul 2020 12:58:05 -0700 (PDT)
Received: from xps13.lan (3e6b1cc1.rev.stofanet.dk. [62.107.28.193])
        by smtp.googlemail.com with ESMTPSA id z6sm11326993wml.41.2020.07.30.12.58.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jul 2020 12:58:05 -0700 (PDT)
From:   Bruno Thomsen <bruno.thomsen@gmail.com>
To:     netdev <netdev@vger.kernel.org>
Cc:     Bruno Thomsen <bruno.thomsen@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Fabio Estevam <festevam@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Lars Alex Pedersen <laa@kamstrup.com>,
        Bruno Thomsen <bth@kamstrup.com>
Subject: [PATCH v2 0/4 net-next] Improve MDIO Ethernet PHY reset
Date:   Thu, 30 Jul 2020 21:57:45 +0200
Message-Id: <20200730195749.4922-1-bruno.thomsen@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series is a result of trying to upstream a new device
tree for a TQMa7D based board[1][2]. Initial this DTS used some
deprecated PHY reset properties on the FEC device; NXP Ethernet
MAC also known as Freescale Fast Ethernet Controller.

When switching from FEC properties[3]:
"phy-reset-gpios"
"phy-reset-duration"
"phy-reset-post-delay"

To MDIO PHY properties[4]:
"reset-gpios"
"reset-assert-us"
"reset-deassert-us"

The result was that no Ethernet PHY device was detected on boot.

This issue could be worked around by disabling PHY type ID auto-
detection by using "ethernet-phy-id0022.1560" as compatible
string and not "ethernet-phy-ieee802.3-c22".

Upstreaming a DTS with this workaround was not accepted, so I
digged into the MDIO reset flow and found that it had a few
missing parts compared to the deprecated FEC reset function.
After some more testing and logic analyzer traces it was
revealed that the failed PHY communication was due to missing
initial device reset.

I was suggested[5] in a earlier mail thread to use MDIO bus
reset as that was performed before auto-detection, but current
device tree binding was limited to reset assert in usec.
Microchip/Micrel Ethernet PHYs recommended reset circuit[8],
figure 7-12, is a little "slow" after reset deassert as that
is left to a RC circuit with a tau of ~100ms; using a 10k PU
resistor together with a 10uF decoupling capacitor. The diode
in serie of the reset signal converts the GPIO push-pull output
into a open-drain output. So a post reset delay in the range
of 500-1000ms is needed, depending on component tolerances
and general hardware design margins.

In the first version of this patch series[6] I reused the
"reset-delay-us" property for reset deassert in usec as that
would cause 50/50% duty-cycle, but that would always apply.
The solution in this patch series is to add a new MDIO bus
property, so post reset delay is optional and configured
separately.

MDIO bus properties[7]:
"reset-delay-us"
"reset-post-delay-us" (new)

I have not marked this with "Fixes:" as no single commit is the
cause and historically this code has only supported MDIO devices
that need reset after auto-detection. The patch series also uses
a new flexible sleep helper function that was introduced in
5.8-rc1, so the driver uses the optimal sleep function depending
on value loaded from device tree.

Future work in this area could add new properties on the MDIO
device, so reset points are configurable, e.g. no reset,
before/after auto-detection or both.

[1] https://lore.kernel.org/linux-devicetree/20200629114927.17379-2-bruno.thomsen@gmail.com/
[2] https://lore.kernel.org/linux-devicetree/20200716172611.5349-2-bruno.thomsen@gmail.com/
[3] https://elixir.bootlin.com/linux/v5.7.8/source/Documentation/devicetree/bindings/net/fsl-fec.txt#L44
[4] https://elixir.bootlin.com/linux/v5.8-rc4/source/Documentation/devicetree/bindings/net/mdio.yaml#L78
[5] https://lore.kernel.org/netdev/CAOMZO5DtYDomD8FDCZDwYCSr2AwNT81Ay4==aDxXyBxtyvPiJA@mail.gmail.com/
[6] https://lore.kernel.org/netdev/20200728090203.17313-1-bruno.thomsen@gmail.com/
[7] https://elixir.bootlin.com/linux/v5.8-rc4/source/Documentation/devicetree/bindings/net/mdio.yaml#L36
[8] http://ww1.microchip.com/downloads/en/DeviceDoc/00002202C.pdf

Bruno Thomsen (4):
  dt-bindings: net: mdio: add reset-post-delay-us property
  net: mdiobus: use flexible sleeping for reset-delay-us
  net: mdiobus: add reset-post-delay-us handling
  net: mdio device: use flexible sleeping in reset function

 Documentation/devicetree/bindings/net/mdio.yaml | 7 +++++++
 drivers/net/phy/mdio_bus.c                      | 4 +++-
 drivers/net/phy/mdio_device.c                   | 2 +-
 drivers/of/of_mdio.c                            | 2 ++
 include/linux/phy.h                             | 2 ++
 5 files changed, 15 insertions(+), 2 deletions(-)


base-commit: 490ed0b908d371cd9ab63fc142213e5d02d810ee
-- 
2.26.2

