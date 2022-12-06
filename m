Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0A20644373
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 13:52:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233928AbiLFMwI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 07:52:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230327AbiLFMwH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 07:52:07 -0500
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C2C812AD8;
        Tue,  6 Dec 2022 04:52:05 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id m18so4381074eji.5;
        Tue, 06 Dec 2022 04:52:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=51QssTzfadvu9MbJIavM+zYO5rlyPy5FsJ0qUzBEE+4=;
        b=FMinxXABhkCBk/+6+8lBxAEZskm4Tjpm7cGQMzN4II6hrwCXo2YGphcUbW41gbTlqM
         v+hmI55npuoRclSLEbmyteS0VFOQyaKKkkw3DpS6MOsa3MJ+9pmZxp3FHuS3gwPeP7eG
         9D0pVJMOeSKXd6f72M4LjZcs4iy3kY26oJG+pzmr+Mob1Y8tLAUpkhBT88rzOBdGIoxR
         e1hWV49L/VTVDogmQcJEJ9ajVzscfF9aiBlKCZ90nDPp6ApwEW5sCFwD7VnjVkBdGNi7
         fXrPxXwOYBPfDa4NpUBgt4q56bqt35dASb4vpf3Gl0S2+M/7ITket7q7iY2/j48a6oP4
         Vnzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=51QssTzfadvu9MbJIavM+zYO5rlyPy5FsJ0qUzBEE+4=;
        b=cBrIRXnzSlNGyExjhRb+pr+wLzW98eeranKvM594hY2AaKQ7t7FdKcKhEtzEqVhjA1
         WlHv618HatvzH/5DyAd0KDIqzqbQ5/8D4n63j/KbVob8YCK/9Mr+n+C97WZLxaHtPSmW
         meLCRQD1351zjfzDDeCJbyZL7NLcDZLtWpjgse+YrTvZJf2xtpt8enc87gfYDazA8A7l
         px9oalbek3lKA73Z8xY72BqnjfZsGnvxRdijcpw01xeMKs/PPBPTmkdGkbIolBTXGoSo
         PRr95/nwEh9UEL/wVKmyVedqLJPmaxFXyBYPBcHIMNk+fBY9pvJ/jom2mgBstzBVEb4O
         lphw==
X-Gm-Message-State: ANoB5pn8plk8iJRu4TTVuZcz5Cz3pe/mZTZKF8LIHqG11T7McS3QJMqb
        0eNyVmfYb6PHwYzFRYMu7Tw=
X-Google-Smtp-Source: AA0mqf7v809hh8emV7VAW7lcHVQgxNKRWs+9aq9wdve4yIPv0rU73ShiMR6tafNpQXoExB8FykWlnw==
X-Received: by 2002:a17:906:6d8a:b0:7ad:69eb:923b with SMTP id h10-20020a1709066d8a00b007ad69eb923bmr10925466ejt.19.1670331123718;
        Tue, 06 Dec 2022 04:52:03 -0800 (PST)
Received: from gvm01 (net-2-45-26-236.cust.vodafonedsl.it. [2.45.26.236])
        by smtp.gmail.com with ESMTPSA id f8-20020a056402150800b0046146c730easm928170edw.75.2022.12.06.04.52.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Dec 2022 04:52:03 -0800 (PST)
Date:   Tue, 6 Dec 2022 13:52:13 +0100
From:   Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Oleksij Rempel <o.rempel@pengutronix.de>
Subject: [PATCH v4 net-next 0/5] add PLCA RS support and onsemi NCN26000
Message-ID: <cover.1670329232.git.piergiorgio.beruto@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset adds support for getting/setting the Physical Layer 
Collision Avoidace (PLCA) Reconciliation Sublayer (RS) configuration and
status on Ethernet PHYs that supports it.

PLCA is a feature that provides improved media-access performance in terms
of throughput, latency and fairness for multi-drop (P2MP) half-duplex PHYs.
PLCA is defined in Clause 148 of the IEEE802.3 specifications as amended
by 802.3cg-2019. Currently, PLCA is supported by the 10BASE-T1S single-pair
Ethernet PHY defined in the same standard and related amendments. The OPEN
Alliance SIG TC14 defines additional specifications for the 10BASE-T1S PHY,
including a standard register map for PHYs that embeds the PLCA RS (see
PLCA management registers at https://www.opensig.org/about/specifications/).

The changes proposed herein add the appropriate ethtool netlink interface
for configuring the PLCA RS on PHYs that supports it. A separate patchset
further modifies the ethtool userspace program to show and modify the
configuration/status of the PLCA RS.

Additionally, this patchset adds support for the onsemi NCN26000
Industrial Ethernet 10BASE-T1S PHY that uses the newly added PLCA
infrastructure.

Piergiorgio Beruto (5):
  net/ethtool: add netlink interface for the PLCA RS
  drivers/net/phy: add the link modes for the 10BASE-T1S Ethernet PHY
  drivers/net/phy: add connection between ethtool and phylib for PLCA
  drivers/net/phy: add helpers to get/set PLCA configuration
  drivers/net/phy: add driver for the onsemi NCN26000 10BASE-T1S PHY

 Documentation/networking/ethtool-netlink.rst | 133 +++++++++
 MAINTAINERS                                  |  14 +
 drivers/net/phy/Kconfig                      |   7 +
 drivers/net/phy/Makefile                     |   1 +
 drivers/net/phy/mdio-open-alliance.h         |  44 +++
 drivers/net/phy/ncn26000.c                   | 193 ++++++++++++
 drivers/net/phy/phy-c45.c                    | 180 ++++++++++++
 drivers/net/phy/phy-core.c                   |   5 +-
 drivers/net/phy/phy.c                        | 175 +++++++++++
 drivers/net/phy/phy_device.c                 |   3 +
 drivers/net/phy/phylink.c                    |   6 +-
 include/linux/ethtool.h                      |  11 +
 include/linux/phy.h                          |  81 ++++++
 include/uapi/linux/ethtool.h                 |   3 +
 include/uapi/linux/ethtool_netlink.h         |  25 ++
 net/ethtool/Makefile                         |   2 +-
 net/ethtool/common.c                         |   8 +
 net/ethtool/netlink.c                        |  30 ++
 net/ethtool/netlink.h                        |   6 +
 net/ethtool/plca.c                           | 290 +++++++++++++++++++
 20 files changed, 1214 insertions(+), 3 deletions(-)
 create mode 100644 drivers/net/phy/mdio-open-alliance.h
 create mode 100644 drivers/net/phy/ncn26000.c
 create mode 100644 net/ethtool/plca.c

-- 
2.35.1

