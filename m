Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2C3439534D
	for <lists+netdev@lfdr.de>; Mon, 31 May 2021 01:00:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229976AbhE3XBa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 May 2021 19:01:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229887AbhE3XB3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 May 2021 19:01:29 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF11DC061574
        for <netdev@vger.kernel.org>; Sun, 30 May 2021 15:59:49 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id df21so11360533edb.3
        for <netdev@vger.kernel.org>; Sun, 30 May 2021 15:59:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gpMNT+51oW1fkh1SozegmEoALxLI/TykTkQPlzU8ES0=;
        b=k78wMl3UI5DpgCX/3qQ6j0g0CizYdZ3B7nOZQgq0ngCkS7K+R9xmgZHV8fYKG7szs1
         wvqwdeLX+ol5GDgkFBXEnCyqPS1oBohMfwXTpFuczzDNNM4JStGsutwZz1+QGwMEDCLD
         7mekK++eY30CuuNJ5JbV+017G8gK7K/FDMhdcLKZc30nV7yj4Xd/gnnRkw6JiTATwg7x
         4ztjycbXmI7UC8iD5U9JNA+UljH4hy35WYC8JfSbKluGLIsJV6xXBLhKTGOyL8NUu39C
         aAPy2qGUOR0ZJOSUaSHRD+t8fwv4+ARX9tkiatwV8Po9xTF+GRhagJlhRszMIMqxV9p7
         Tw5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gpMNT+51oW1fkh1SozegmEoALxLI/TykTkQPlzU8ES0=;
        b=fu3HYIt+Yol2jK2vbXT4kZlveyyDqN7qZpt9MSabqo5veqqMVEjh0G3pVHSOQ1Q/to
         X2Zf/tVPRI1m3Kg2jZcVpdp8EYZwzLLssd1jq4gpTB1QAYP10iVi9s4CK824uGqGf9Y9
         3206Myj2bCABff7Mn0Mlwo1PQI7cT3XToXsA6CzmTDY3nF7Zmpztl4EJonhp/yO2p2QT
         l3GxlI4qBkeGvuRI0ygHlSSlQQoZhC1Qvva3xBtn+3aodV177vLWKS47ivigexxW/YnD
         H59AyK2/wJFu4M7UnDDwCWY4NYKJeHqspV89sJiezwn9ntnY+VZXXSTO2kmUBLKFfPTO
         HH7Q==
X-Gm-Message-State: AOAM533d5ycWapp5rOH3zhnYdVH1yyHyrDRcBjx+BWo6nNNb5mwsLhne
        UCiU0rEpEgb3/0I1B+j6iEE=
X-Google-Smtp-Source: ABdhPJxxyFnJscx8weMNBu2YBo054RU9I3JH52q6a1rUiSukeq2/xeOagjhOsT58rsKSodzatTyveA==
X-Received: by 2002:a05:6402:3585:: with SMTP id y5mr22445508edc.121.1622415588214;
        Sun, 30 May 2021 15:59:48 -0700 (PDT)
Received: from localhost.localdomain ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id c6sm5135120eje.9.2021.05.30.15.59.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 30 May 2021 15:59:47 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH v3 net-next 0/8] Part 2 of SJA1105 DSA driver preparation for new switch introduction (SJA1110)
Date:   Mon, 31 May 2021 01:59:31 +0300
Message-Id: <20210530225939.772553-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

This series is a continuation of:
https://patchwork.kernel.org/project/netdevbpf/cover/20210524131421.1030789-1-olteanv@gmail.com/

even though it isn't the first time these patches are submitted (they
were part of the group previously called "Add NXP SJA1110 support to the
sja1105 DSA driver"):
https://patchwork.kernel.org/project/netdevbpf/cover/20210526135535.2515123-1-vladimir.oltean@nxp.com/

but I broke that up again since these patches are already reviewed, for
the most part. There are no changes compared to v2 and v1.

This series of patches contains:

- an adaptation of the driver to the new "ethernet-ports" OF node name
- an adaptation of the driver to support more than 1 SGMII port
- a generalization of the supported phy_interface_t values per port
- an adaptation to encode SPEED_10, SPEED_100, SPEED_1000 into the
  hardware registers differently depending on switch revision
- a consolidation of the PHY interface type used for RGMII and another
  one for the API exposed for sja1105_dynamic_config_read()

Cc: Russell King <linux@armlinux.org.uk>
Cc: Heiner Kallweit <hkallweit1@gmail.com>

Vladimir Oltean (8):
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

 drivers/net/dsa/sja1105/sja1105.h             |  24 +-
 drivers/net/dsa/sja1105/sja1105_clocking.c    |  29 +--
 .../net/dsa/sja1105/sja1105_dynamic_config.c  |  15 +-
 drivers/net/dsa/sja1105/sja1105_main.c        | 207 ++++++++++--------
 drivers/net/dsa/sja1105/sja1105_spi.c         |  63 +++++-
 5 files changed, 206 insertions(+), 132 deletions(-)

-- 
2.25.1

