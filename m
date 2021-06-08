Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F95839F23D
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 11:25:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230392AbhFHJ1q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 05:27:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbhFHJ1m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Jun 2021 05:27:42 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06B23C061574;
        Tue,  8 Jun 2021 02:25:50 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id og14so26200986ejc.5;
        Tue, 08 Jun 2021 02:25:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+VmleSb6LhjpojQBvUKMucK3YxBEy3IL2/+Yx4PI6aw=;
        b=KlZjku+OBo9x3dDfFXJHxhnPb2V+Co6bimcFo+g07p7ENL95CSpkpib4N1VtxV9ASc
         mQnnkKqvGM7TySNPaq4W79NRqfcGLgOMItKTxg6kr+C1f5vEPgW7nzmtd1Rfu2L1c8MQ
         x7/ZmRZNR5P1e7ouhacAJS593NGAZdf3p3IGTNdBMOYergbfd3LY4uYKAhqmncB2Zi9p
         B/H3EGxR6+U+CY6qbEF2suxfJaQ5OKZ0igKtn9DeuyoDp9HZAtxi2ckyFT4cJis+YRSh
         QYWbrBXGI87c8e27Vzq4BeBzRg21bx8RLUaxlKocoiCqBIBfGzuPKuophUlTNjejH218
         tO0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+VmleSb6LhjpojQBvUKMucK3YxBEy3IL2/+Yx4PI6aw=;
        b=WCbgYeyFX5PS4jk9KnOMTwizkGY1lXJxNJWWQGnoqrTVfJnCJDDQuoiGP2Hl9Hsjm8
         oy+TR1iSt8/cez41tMJ2zcWwHppxLV5ORZPy2W0UaTjWr9QKmGCW7tZwK0IP6cSUJjDg
         9qKx4NCJdyOFtxyCOD2iIE3+zdXqfumKxAeNKuDYNZdJBf/gbGUxlnjoEC5bYzPPKOo4
         VGqqs0jYESdymIbQknfsZx14x6ImoVhfuIOe20u1oHyWEjC557qyO9O99jApU5bewVa6
         UZLOWIdO4ON6MUETawAu9vevmwDCWSpGHSt5ndd4mCkRgHvxD0qDUTJLbrtsa+ESGlQq
         aaMQ==
X-Gm-Message-State: AOAM533JXncIjfiwxlkQaRwDjC6gaDbQZNPo33hzHkKAGEC6aNrULNMU
        5ykBkhXsS8rU64Gk7R91gGw=
X-Google-Smtp-Source: ABdhPJzHbH8NCZ8Nq8x5bctA3gnCifYfAoZmZTAYrmM5nT5o5xuTrBW6IKiy+JG3HK6KZtaA1hW9TA==
X-Received: by 2002:a17:907:7b97:: with SMTP id ne23mr22269862ejc.499.1623144348458;
        Tue, 08 Jun 2021 02:25:48 -0700 (PDT)
Received: from localhost.localdomain ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id x9sm639783ejc.37.2021.06.08.02.25.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Jun 2021 02:25:48 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org
Subject: [PATCH v3 net-next 0/4] Add NXP SJA1110 support to the sja1105 DSA driver
Date:   Tue,  8 Jun 2021 12:25:34 +0300
Message-Id: <20210608092538.3920217-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

The NXP SJA1110 is an automotive Ethernet switch with an embedded Arm
Cortex-M7 microcontroller. The switch has 11 ports (10 external + one
for the DSA-style connection to the microcontroller).
The microcontroller can be disabled and the switch can be controlled
over SPI, a la SJA1105 - this is how this driver handles things.

There are some integrated NXP PHYs (100base-T1 and 100base-TX). Their
initialization is handled by their own PHY drivers, the switch is only
concerned with enabling register accesses to them, by registering two
MDIO buses.

Changes in v3:
- Make sure the VLAN retagging port is enabled and functional
- Dropped SGMII PCS from this series

Changes in v2:
- converted nxp,sja1105 DT bindings to YAML
- registered the PCS MDIO bus and forced auto-probing off for all PHY
  addresses for this bus
- changed the container node name for the 2 MDIO buses from "mdio" to
  "mdios" to avoid matching on the mdio.yaml schema (it's just a
  container node, not an MDIO bus)
- fixed an uninitialized "offset" variable usage in
  sja1110_pcs_mdio_{read,write}
- using the mdiobus_c45_addr macro instead of open-coding that operation

Cc: Russell King <linux@armlinux.org.uk>
Cc: Heiner Kallweit <hkallweit1@gmail.com>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: devicetree@vger.kernel.org

Vladimir Oltean (4):
  dt-bindings: net: dsa: sja1105: add SJA1110 bindings
  net: dsa: sja1105: add support for the SJA1110 switch family
  net: dsa: sja1105: make sure the retagging port is enabled for SJA1110
  net: dsa: sja1105: register the MDIO buses for 100base-T1 and
    100base-TX

 .../bindings/net/dsa/nxp,sja1105.yaml         |  43 ++
 drivers/net/dsa/sja1105/Makefile              |   1 +
 drivers/net/dsa/sja1105/sja1105.h             |  43 +-
 drivers/net/dsa/sja1105/sja1105_clocking.c    |  91 ++++
 .../net/dsa/sja1105/sja1105_dynamic_config.c  | 321 +++++++++++-
 .../net/dsa/sja1105/sja1105_dynamic_config.h  |   1 +
 drivers/net/dsa/sja1105/sja1105_main.c        | 132 ++++-
 drivers/net/dsa/sja1105/sja1105_mdio.c        | 288 +++++++++++
 drivers/net/dsa/sja1105/sja1105_spi.c         | 282 ++++++++++
 .../net/dsa/sja1105/sja1105_static_config.c   | 483 ++++++++++++++++++
 .../net/dsa/sja1105/sja1105_static_config.h   |  99 +++-
 11 files changed, 1771 insertions(+), 13 deletions(-)
 create mode 100644 drivers/net/dsa/sja1105/sja1105_mdio.c

-- 
2.25.1

