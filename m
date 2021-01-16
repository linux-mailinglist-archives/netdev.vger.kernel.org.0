Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39E472F8A24
	for <lists+netdev@lfdr.de>; Sat, 16 Jan 2021 02:01:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728195AbhAPBBP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 20:01:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725922AbhAPBBO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 20:01:14 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F68CC0613D3
        for <netdev@vger.kernel.org>; Fri, 15 Jan 2021 17:00:34 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id c6so4381938ede.0
        for <netdev@vger.kernel.org>; Fri, 15 Jan 2021 17:00:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GuXe8n8f6keqmEOLm9HYYit1Rg7v4+z1Z3up9dGO/Dw=;
        b=DowkSW1LxseJscNuLO/1tvfFvUrS94kFj8xXk4Umc5peYKzBiAu2Wabei/YmL47vIf
         dgq5QqvmHHq/l379d7kgvTt0fnflNiFmr5QnmaoTN510c3eZSLo/xDy4Pzi6s8yPsSOk
         MeGGhIk4zqwAhGUY84JYB4NjAThgVWhSDiY3YgfdAm/8lMiVUllI+hbYU9jUUAnQ3oU9
         Ryw/9fCdQ+IPyGJbVtCSU8QuSFPNi+VfdbZM002VyIxN5fArdzIdD3DTDg5rk3wDkfT4
         GEc2BgK2BQTkpwMD/Ku5XwqClkqncq8rdeH7j/xmYy3H0AubBEqOMdrz8dicL5h6aPQv
         y5AA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GuXe8n8f6keqmEOLm9HYYit1Rg7v4+z1Z3up9dGO/Dw=;
        b=r2Kywo344HQkQvSkJvOj99Sc56zJrcxlXm4szgy4VzDoc0Zbevv2+fKFgp8U3Qmj+y
         fAGwbneifBhjcGyYv9a0BtGAC5kSTWJZS0C/M85HYzmtQT3JFazWekIsUcEb4zBVMDsa
         EIVtPgPk6y+lsyPjJjbE0YEjcDTOqSl6D7HVJJkcyhwCqEzchvx6Nji48b/DPi+cEdXF
         14Edipn/7ty3O8WE/rBE8qpwRlvTt890/2j+bYfejXNA/s2Oletdmia96FEfqtGB+d4h
         4k6hCQujw7+9qW7l2Z4HHlf0LAeOZW0tKVugDilahvG9Ubqo5T/bGsB1eO9HCJONdpnT
         xjTg==
X-Gm-Message-State: AOAM531VlTlz/sHYoXJ8SOostelK3d8MnI4DV0554QBozk1MjVUJJQxX
        21nU49KG4hDdvk4M4uSmMt0=
X-Google-Smtp-Source: ABdhPJxIqNPPz1KJ5Vx5VK2VlIy2acjYE1jj/KuK+Ez1vKPJb0pq/doXsuWLtFISFAmqp7YHX5iaAQ==
X-Received: by 2002:aa7:c719:: with SMTP id i25mr7265149edq.197.1610758833249;
        Fri, 15 Jan 2021 17:00:33 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id k3sm5666655eds.87.2021.01.15.17.00.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Jan 2021 17:00:32 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Maxim Kochetkov <fido_max@inbox.ru>
Subject: [PATCH v2 net-next 00/14] LAG offload for Ocelot DSA switches
Date:   Sat, 16 Jan 2021 02:59:29 +0200
Message-Id: <20210116005943.219479-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

This patch series reworks the ocelot switchdev driver such that it could
share the same implementation for LAG offload as the felix DSA driver.

Testing has been done in the following topology:

         +----------------------------------+
         | Board 1         br0              |
         |             +---------+          |
         |            /           \         |
         |            |           |         |
         |            |         bond0       |
         |            |        +-----+      |
         |            |       /       \     |
         |  eno0     swp0    swp1    swp2   |
         +---|--------|-------|-------|-----+
             |        |       |       |
             +--------+       |       |
               Cable          |       |
                         Cable|       |Cable
               Cable          |       |
             +--------+       |       |
             |        |       |       |
         +---|--------|-------|-------|-----+
         |  eno0     swp0    swp1    swp2   |
         |            |       \       /     |
         |            |        +-----+      |
         |            |         bond0       |
         |            |           |         |
         |            \           /         |
         |             +---------+          |
         | Board 2         br0              |
         +----------------------------------+

The same script can be run on both Board 1 and Board 2 to set this up:

#!/bin/bash

ip link del bond0
ip link add bond0 type bond mode 802.3ad
ip link set swp1 down && ip link set swp1 master bond0 && ip link set swp1 up
ip link set swp2 down && ip link set swp2 master bond0 && ip link set swp2 up
ip link del br0
ip link add br0 type bridge
ip link set bond0 master br0
ip link set swp0 master br0

Then traffic can be tested between eno0 of Board 1 and eno0 of Board 2.

Note: series applies on top of:
https://patchwork.kernel.org/project/netdevbpf/cover/20210115021120.3055988-1-olteanv@gmail.com/

Vladimir Oltean (14):
  net: mscc: ocelot: allow offloading of bridge on top of LAG
  net: mscc: ocelot: rename ocelot_netdevice_port_event to
    ocelot_netdevice_changeupper
  net: mscc: ocelot: use a switch-case statement in
    ocelot_netdevice_event
  net: mscc: ocelot: don't refuse bonding interfaces we can't offload
  net: mscc: ocelot: use ipv6 in the aggregation code
  net: mscc: ocelot: set up the bonding mask in a way that avoids a
    net_device
  net: mscc: ocelot: avoid unneeded "lp" variable in LAG join
  net: mscc: ocelot: use "lag" variable name in
    ocelot_bridge_stp_state_set
  net: mscc: ocelot: reapply bridge forwarding mask on bonding
    join/leave
  net: mscc: ocelot: set up logical port IDs centrally
  net: mscc: ocelot: drop the use of the "lags" array
  net: mscc: ocelot: rename aggr_count to num_ports_in_lag
  net: mscc: ocelot: rebalance LAGs on link up/down events
  net: dsa: felix: propagate the LAG offload ops towards the ocelot lib

 drivers/net/dsa/ocelot/felix.c         |  28 +++
 drivers/net/ethernet/mscc/ocelot.c     | 256 ++++++++++++++-----------
 drivers/net/ethernet/mscc/ocelot.h     |   4 -
 drivers/net/ethernet/mscc/ocelot_net.c | 131 ++++++++-----
 include/soc/mscc/ocelot.h              |  11 +-
 5 files changed, 265 insertions(+), 165 deletions(-)

-- 
2.25.1

