Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B8951CE997
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 02:24:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727976AbgELAYn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 20:24:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725855AbgELAYn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 20:24:43 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC2C0C061A0C;
        Mon, 11 May 2020 17:24:42 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id r10so4835551pgv.8;
        Mon, 11 May 2020 17:24:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=NrIpz6vUz6TlKjzyo8M6MU8mPTVTm6PFboLLZ6IJLYg=;
        b=Jq9+YAJNInoQ2XwX4U1q7T19pkx3rfiS49Cm2//kUVBs6wEhst83w17xDja+HiI0/0
         myTV6r+DLRK9UXvdmDfFicL74ApeH0r9XUrGT1oxn0jFY/DXAYpMR0D0wkCAMBtGsTXh
         EAemiBAZ9Nm/PzG7FWN+6aRzNNQhzN+6slD075dXKqLoJH3uWuHSI4VLTuwgtWkBTd2i
         tOHAxkum5ExzicX8DA+8+ycWDbSVn3agEKoyT/+tvLfaE5SF33o4wOW2iKMuyHB73s4O
         wT2PeyDqHBEUa+qGNZN5iM7Yjy4g2RG3uDOb4HMvn9GCEDqjiD8NhEyL1s7N/yZkdSGW
         Y4sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=NrIpz6vUz6TlKjzyo8M6MU8mPTVTm6PFboLLZ6IJLYg=;
        b=kUmfAVYY87qu0nalywvT36w0aRi1t6c7TWwP4VMf1yGkZVE4fL1nXRKmQsa905VEXZ
         +FVpVUEkkNAeeleVwsZBCnppQFnp2RR4PvPVv/OwBJw5MH0tK/8jA+nVJzGZiLPiFgOA
         KSafq88JTLW2Z+qVll3PmTBtA/Bq3t5RDSwjFnOaRxpaUw+VwKWAOM6Y57YuP/XuylPI
         bAot73e9fQB2InG1efggYnZFRR8CB+qVNRYKAOiqYsx6LQn/9+F5zlcchP7/DNejboWk
         TaKjWHKmkX7iVSmlwAPkrpmuhYbW274sbCg8LGvfFTFX52x4iXpXkfy4jnwZx7uL3/Pt
         uQTg==
X-Gm-Message-State: AGi0PubN248+XRftGAA4cnsvB6W1EL1ynOPtjD3JWBgupqEH70wBlLcp
        ir6soCSJMrAB/JsAWdQBvZQ=
X-Google-Smtp-Source: APiQypJ1KWZIbeMmZE/wGde6uQxE3MJO0GQkpdGcGOAMJc6etfbidBN+AL+XeQVGbdVcm0Im0o3+ag==
X-Received: by 2002:a63:3206:: with SMTP id y6mr16950589pgy.68.1589243082152;
        Mon, 11 May 2020 17:24:42 -0700 (PDT)
Received: from stbirv-lnx-3.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 23sm9062112pgm.18.2020.05.11.17.24.40
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 11 May 2020 17:24:41 -0700 (PDT)
From:   Doug Berger <opendmb@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Doug Berger <opendmb@gmail.com>
Subject: [PATCH net-next 0/4] Extend phylib implementation of pause support
Date:   Mon, 11 May 2020 17:24:06 -0700
Message-Id: <1589243050-18217-1-git-send-email-opendmb@gmail.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit set extends the implementation introduced by
commit 5652b46e4e80 ("Merge branch 'Pause-updates-for-phylib-and-phylink'")
to support the less problematic behavior alluded to by Russell King's
comment in commit f904f15ea9b5 ("net: phylink: allow ethtool -A to
change flow control advertisement").

+	/*
+	 * See the comments for linkmode_set_pause(), wrt the deficiencies
+	 * with the current implementation.  A solution to this issue would
+	 * be:
+	 * ethtool  Local device
+	 *  rx  tx  Pause AsymDir
+	 *  0   0   0     0
+	 *  1   0   1     1
+	 *  0   1   0     1
+	 *  1   1   1     1
+	 * and then use the ethtool rx/tx enablement status to mask the
+	 * rx/tx pause resolution.
+	 */

Specifically, the linkmode_set_pause() function is extended to support
both the existing Pause/AsymPause mapping and the mapping specified by
the IEEE standard (and Russell). A phy_set_pause() function is added to
the phylib that can make use of this extension based on the value of
the pause autoneg parameter. The bcmgenet driver adds support for the
ethtool pauseparam ops based on these phylib services and uses "the
ethtool rx/tx enablement status to mask the rx/tx pause resolution".

The first commit in this set addresses a small deficiency in the 
phy_validate_pause() function.

The second extends linkmode_set_pause() with an autoneg parameter to
allow selection of the desired mapping for advertisement.

The third introduces the phy_set_pause() function based on the existing
phy_set_asym_pause() implementation. One aberration here is the direct
manipulation of the phy state machine to allow a new link up event to
notify the MAC that the pause parameters may have changed. This is a
convenience to simplify the MAC driver by allowing one implementation
of the pause configuration logic to be located in its adjust_link
callback. Otherwise, the MAC driver would need to handle configuring
the pause parameters for an already active PHY link which would likely
require additional synchronization logic to protect the logic from
asynchronous changes in the PHY state.

The logic in phy_set_asym_pause() that looks for a change in
advertising is not particularly helpful here since now a change from
tx=1 rx=1 to tx=0 rx=1 no longer changes the advertising if autoneg is
enabled so phy_start_aneg() would not be called. I took the alternate
approach of unconditionally calling phy_start_aneg() since it
accommodates both manual and autoneg configured links. The "aberrant"
logic allows manually configured and autonegotiated links that don't
change their advertised parameters to receive an adjust_link call to
act on pause parameters that have no effect on the PHY layer.

It seemed excessive to bring the PHY down and back up when nogotiation
is not necessary, but that could be an alternative approach. I am
certainly open to any suggestions on how to improve that portion of
the code if it is controversial and a consensus can be reached.

The last commit is a reference implementation of pause support by the
bcmgenet driver based on my preferences for the functionality. It is my
desire that other network drivers prefer this behavior and the changes
to the phylib will make it easier for them to support.

Many thanks to Russell King and Andrew Lunn for their efforts to clean
up and centralize support for pause and to document its shortcommings.

Doug Berger (4):
  net: ethernet: validate pause autoneg setting
  net: add autoneg parameter to linkmode_set_pause
  net: ethernet: introduce phy_set_pause
  net: bcmgenet: add support for ethtool flow control

 drivers/net/ethernet/broadcom/genet/bcmgenet.c |  54 +++++++++++++
 drivers/net/ethernet/broadcom/genet/bcmgenet.h |   4 +
 drivers/net/ethernet/broadcom/genet/bcmmii.c   |  38 +++++++--
 drivers/net/phy/linkmode.c                     | 104 +++++++++++++++++++------
 drivers/net/phy/phy_device.c                   |  37 ++++++++-
 drivers/net/phy/phylink.c                      |   6 +-
 include/linux/linkmode.h                       |   3 +-
 include/linux/phy.h                            |   1 +
 8 files changed, 212 insertions(+), 35 deletions(-)

-- 
2.7.4

