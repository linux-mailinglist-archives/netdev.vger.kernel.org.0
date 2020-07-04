Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FB892145E9
	for <lists+netdev@lfdr.de>; Sat,  4 Jul 2020 14:45:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726934AbgGDMp3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Jul 2020 08:45:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726738AbgGDMp2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Jul 2020 08:45:28 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45644C061794
        for <netdev@vger.kernel.org>; Sat,  4 Jul 2020 05:45:28 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id z17so30228229edr.9
        for <netdev@vger.kernel.org>; Sat, 04 Jul 2020 05:45:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BtMItCIHkBZgVPtbMbn0J3xA+pBHoz9HsiH92E66oxw=;
        b=lF4aGZTLCC3kN4hddZiUiOgbw27Nu3jysh03nwe1+Kt/vJtZUow0Xz9OIZ+5FJIAhK
         tIGzEjLNcKNYeEusx8Tq0btQu0V2eX1BDhZtN7P1lLjy+7Y4GLv7JHYLHyNFo12AMI1g
         Bhe4UpDJhPqlAIawbaW5UAdUyHU7E4ArI+OPSNlXHmKobZj2pqzhkVmsSPZvM3M44daD
         BmHHcde8+3+k5H/K+8ZGCNPdXbzWTK4ybZZKjrNI5d1vzal8TR0RRoIYt2b2BFbGojgs
         RcReLTbUh1vMlv/WYL0q4GEwYSfvcI8EBSCgh1f1cKR7je4rBHR9fq0uY05TAQElVe/J
         7uKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BtMItCIHkBZgVPtbMbn0J3xA+pBHoz9HsiH92E66oxw=;
        b=M4IY04h96by7yLVM073p1YbxOsy3HQ7nJUodwYCPSfQupIqpMeDkI4lx8dVOSby4Gy
         F8VdT9cuQ19mbhRn4nBkTWJPpJkDqI8hiIX+q2nSNVhe+i8UJD8P6VQ/TTtUR7UkEsHk
         u+9+LEUUohM8Cnabss6nhHQbfnVmJTaIAON89D/rmx9EAdy/C3yK5vZPr6/07pEEVCMY
         mJlVwUK13rqcP3ByWJHjBg09Q4CKAriY7Neg851n2K6YuYdUC63AIEGR9jPA58gTlOYo
         tBvGw4mgLxcA/TguHc9FboUtwqpDETWUKntkq3+bHTt391DfznhtVAWYKb7QJ2B92ynR
         Sm/g==
X-Gm-Message-State: AOAM530CwaOHlAkOvazzExF+BESjhxEgC64S0dYl681QUTp1uCMTLqzU
        bL8y7+iFSsVlIPOaR2QATFs=
X-Google-Smtp-Source: ABdhPJx3EijtjDGerOXtZtVoZ4GZLolUgZH1k4bAdNJJKXPIBb5T/06qLd62IVs/WQtzblXOItNS1w==
X-Received: by 2002:a50:e14e:: with SMTP id i14mr43747158edl.279.1593866726870;
        Sat, 04 Jul 2020 05:45:26 -0700 (PDT)
Received: from localhost.localdomain ([188.25.219.134])
        by smtp.gmail.com with ESMTPSA id dm1sm12983851ejc.99.2020.07.04.05.45.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Jul 2020 05:45:26 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        claudiu.manoil@nxp.com, alexandru.marginean@nxp.com,
        ioana.ciornei@nxp.com, linux@armlinux.org.uk
Subject: [PATCH v2 net-next 0/6] PHYLINK integration improvements for Felix DSA driver
Date:   Sat,  4 Jul 2020 15:45:01 +0300
Message-Id: <20200704124507.3336497-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

This is an overhaul of the Felix switch driver's PHYLINK operations.

Patches 1, 3, 4 and 5 are cleanup, patch 2 is adding a new feature and
and patch 6 is adaptation to the new format of an existing phylink API
(mac_link_up).

Changes since v1:
- Now using phy_clear_bits and phy_set_bits instead of plain writes to
  MII_BMCR. This combines former patches 1/7 and 6/7 into a single new
  patch 1/6.
- Updated commit message of patch 5/6.

Vladimir Oltean (6):
  net: dsa: felix: clarify the intention of writes to MII_BMCR
  net: dsa: felix: support half-duplex link modes
  net: dsa: felix: unconditionally configure MAC speed to 1000Mbps
  net: dsa: felix: set proper pause frame timers based on link speed
  net: dsa: felix: delete .phylink_mac_an_restart code
  net: dsa: felix: use resolved link config in mac_link_up()

 drivers/net/dsa/ocelot/felix.c         | 108 +++++----
 drivers/net/dsa/ocelot/felix.h         |  11 +-
 drivers/net/dsa/ocelot/felix_vsc9959.c | 298 ++++++++++++-------------
 include/linux/fsl/enetc_mdio.h         |   1 +
 4 files changed, 213 insertions(+), 205 deletions(-)

-- 
2.25.1

