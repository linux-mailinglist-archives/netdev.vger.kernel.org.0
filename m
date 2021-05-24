Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 130C938F62A
	for <lists+netdev@lfdr.de>; Tue, 25 May 2021 01:22:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229750AbhEXXYD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 May 2021 19:24:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbhEXXYA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 May 2021 19:24:00 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A730C061574
        for <netdev@vger.kernel.org>; Mon, 24 May 2021 16:22:30 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id r11so33823503edt.13
        for <netdev@vger.kernel.org>; Mon, 24 May 2021 16:22:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PTysxuplQu8slwbE2fcnC5fUrUD5x5Gs7UipxMmgmdk=;
        b=POPs1jFyYESRH4zvAi0iwhqlq4os+dhCNFtB2OP1CfR7VUG4NROXnsj97xKokHa+VY
         V/aJhryKNc80ROVGOYWZCeFTXcfFauzEJHbJFNs4NmA9Z71e/tsPzGklu3XosWzmvGam
         Hf1YnU0V8BYL/nQkUa6hMY6e5syKUzD+DcsZnyh+D8WIy9OYbkQWKtG+oXNwV+hidtk9
         Vui+QyS8Zf36KYrLm0VNwmXFxfdCMjGgvm1vsaecKpXeaVDxuZKpgLiVT6ynTRU10buX
         n2O/1lSfYxrMHLFrK8QClY+pWUIP6h1+rnx5No9myoITouqIs0yL6PaRMrMKWauhSQ+o
         3BSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PTysxuplQu8slwbE2fcnC5fUrUD5x5Gs7UipxMmgmdk=;
        b=q3gpYjxu122qQ0lM9fI6b67MtNsO6oxzlBIaUWm73xcL4cUbqF9Lrz18/j3KKoUNAa
         sc1cwg2Y2QGUSKi561VHVNLH6VD8Q9NLlNaAKbuQe2h4DAuXtzN5SDsZJcthqNKSf446
         aNgNpmq2hEM16tl5JEMUQoJKa9kyo7pO4C/DJoMDxFwJY1uWbMiDyZppkJbiT+z3Hywy
         MlgJJdh1aQUk5BSGCGMtZn6s0wb2gOIFUE9ys31Ywi25lIoxXqRlZh7I8kKUUxycyYSb
         JFqZBcfkCEYYj0sJl1hG7SmDMzib7m1TVaKwthbWOneo4Ead0NlzzBBPD5hkuIQfoAzY
         xE2A==
X-Gm-Message-State: AOAM533szV++21CZUcR6wuJ3Wt0vRW1tqu7fXdgrEZBmthQ14/eAkXk6
        XGX6Ru9GhgpiNdgSqqBtbVw=
X-Google-Smtp-Source: ABdhPJx9woHuFmQTSID4xwE50pO50nxU+CkvPR8OvRUCaRbYatEiXCV0zI0VRTARgmANRCqZ05h8ow==
X-Received: by 2002:aa7:df96:: with SMTP id b22mr28265605edy.95.1621898548818;
        Mon, 24 May 2021 16:22:28 -0700 (PDT)
Received: from localhost.localdomain ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id di7sm9922746edb.34.2021.05.24.16.22.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 May 2021 16:22:28 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Russell King <linux@armlinux.org.uk>
Subject: [PATCH net-next 00/13] Add NXP SJA1110 support to the sja1105 DSA driver
Date:   Tue, 25 May 2021 02:22:01 +0300
Message-Id: <20210524232214.1378937-1-olteanv@gmail.com>
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

PHY interrupts might be possible, however I believe that the board I am
working on does not have them wired, which makes things a bit more
difficult to test.

Cc: Russell King <linux@armlinux.org.uk>

Vladimir Oltean (13):
  net: dsa: sja1105: be compatible with "ethernet-ports" OF node name
  net: dsa: sja1105: allow SGMII PCS configuration to be per port
  net: dsa: sja1105: the 0x1F0000 SGMII "base address" is actually
    MDIO_MMD_VEND2
  net: dsa: sja1105: cache the phy-mode port property
  net: dsa: sja1105: add a PHY interface type compatibility matrix
  net: dsa: sja1105: add a translation table for port speeds
  net: dsa: sja1105: always keep RGMII ports in the MAC role
  net: dsa: sja1105: some table entries are always present when read
    dynamically
  dt-bindings: net: dsa: sja1105: add compatible strings for SJA1110
  net: dsa: sja1105: add support for the SJA1110 switch family
  net: dsa: sja1105: register the MDIO buses for 100base-T1 and
    100base-TX
  net: dsa: sja1105: expose the SGMII PCS as an mdio_device
  net: dsa: sja1105: add support for the SJA1110 SGMII/2500base-x PCS

 .../devicetree/bindings/net/dsa/sja1105.txt   |   4 +
 drivers/net/dsa/sja1105/Makefile              |   1 +
 drivers/net/dsa/sja1105/sja1105.h             |  88 ++-
 drivers/net/dsa/sja1105/sja1105_clocking.c    | 120 +++-
 .../net/dsa/sja1105/sja1105_dynamic_config.c  | 336 ++++++++++-
 .../net/dsa/sja1105/sja1105_dynamic_config.h  |   1 +
 drivers/net/dsa/sja1105/sja1105_main.c        | 518 +++++++++++++----
 drivers/net/dsa/sja1105/sja1105_mdio.c        | 530 ++++++++++++++++++
 drivers/net/dsa/sja1105/sja1105_sgmii.h       |  63 ++-
 drivers/net/dsa/sja1105/sja1105_spi.c         | 368 +++++++++++-
 .../net/dsa/sja1105/sja1105_static_config.c   | 483 ++++++++++++++++
 .../net/dsa/sja1105/sja1105_static_config.h   |  98 +++-
 12 files changed, 2442 insertions(+), 168 deletions(-)
 create mode 100644 drivers/net/dsa/sja1105/sja1105_mdio.c

-- 
2.25.1

