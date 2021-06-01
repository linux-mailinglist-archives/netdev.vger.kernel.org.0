Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B198A396A4D
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 02:33:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232528AbhFAAfY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 May 2021 20:35:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232317AbhFAAfP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 May 2021 20:35:15 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D07ECC061574
        for <netdev@vger.kernel.org>; Mon, 31 May 2021 17:33:33 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id dg27so5471858edb.12
        for <netdev@vger.kernel.org>; Mon, 31 May 2021 17:33:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8OGwKJxbOjs1hXuQaNAP8RaNzK8u7Wh+SLBseSiRNc4=;
        b=EQWEV047V/8pOupOyLr/DG0+E7NOaD/4rgSq9z/5avhnRuTsud4827FvxCWu5YYfXd
         1ADVzEFe1/EX4YqzyRThscs9tHzXrnhSEGAR2zxzrUwLqx8a/6x4GyIf9YPaF4t3Lpkf
         mSuuJslAkKFfugk4OhNPLVlWq4TnJvAhbrI3BDZvYcyGHAILvq+JnxaVhtH7hv5xwDSi
         C70dJf6ZLSoCX8yCdCg1smCd3aE0i2YEIwcGIDtTsJjR+1u4ku8Obc6I/keExtHXXgvq
         D9eqNtkOm1xDda1VuNpsKlVy3jFG9FBlwFT6s80m1o0AhdW5ZYV+8+WbDNNnRcJx3Ri+
         mzJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8OGwKJxbOjs1hXuQaNAP8RaNzK8u7Wh+SLBseSiRNc4=;
        b=il+N5VZkSdeujV7EfvlRSq2KlmsYbIYuL/HVR7gScBdUaWA1SDUPWH6AeD2iQ+TJt3
         SSrgKoxDL3mBHt0fJqZte97vi1PnXODGY3kYrKtXXeEEp+tBIP5ZELuIEiwNKjkIjorJ
         2TrkXgtxajBfUkfukTcAb7JhWdQLlFrbQBPkKYjGav5+OEN1cMKsaBB/wXlyTkgzqU0T
         Ce87kNfkVGRGQx1Bi4BkOruH7uhQj8nGnO4p+nS2RKByv/piktIic2TLZY5N+Fylol28
         f/QA5HgxYc8J9gqeoMkE8HwBiUMOtzTuQn/Gs0uM51FA3aFrO5z7dQb76EmbO7a/FCqk
         gs9Q==
X-Gm-Message-State: AOAM530p+ESd9Qb4GeZV3LEVBRzwLSwS35M8HTKRe8SXmNIYQ3dfyNjW
        vQBVBe1cJ2+5J7ay2YVD88c=
X-Google-Smtp-Source: ABdhPJx8sRVzwF31qsGb9RFbqfZYRzJRbLZr62YE8b/QfOVKRIrG2QVpEXIBCGCSNN8UMqFFWSUm9g==
X-Received: by 2002:aa7:dc4f:: with SMTP id g15mr9817709edu.277.1622507611380;
        Mon, 31 May 2021 17:33:31 -0700 (PDT)
Received: from localhost.localdomain ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id g13sm6510521ejr.63.2021.05.31.17.33.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 May 2021 17:33:31 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Wong Vee Khee <vee.khee.wong@linux.intel.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [RFC PATCH v2 net-next 0/9] Convert xpcs to phylink_pcs_ops
Date:   Tue,  1 Jun 2021 03:33:16 +0300
Message-Id: <20210601003325.1631980-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

This patch series is partially tested (some code paths have been covered
on the NXP SJA1105) but since I don't have stmmac hardware, it would
still be appreciated if people from Intel could give this another run.

Background: the sja1105 DSA driver currently drives a Designware XPCS
for SGMII and 2500base-X, and it would be nice to reuse some code with
the xpcs module. This would also help consolidate the phylink_pcs_ops,
since the only other dedicated PCS driver, currently, is the lynx_pcs.

Therefore, this series makes the xpcs expose the same kind of API that
the lynx_pcs module does. The main changes are getting rid of struct
mdio_xpcs_ops, being compatible with struct phylink_pcs_ops and being
less reliant on the phy_interface_t passed to xpcs_probe (now renamed to
xpcs_create).

Vladimir Oltean (9):
  net: pcs: xpcs: delete shim definition for mdio_xpcs_get_ops()
  net: pcs: xpcs: there is only one PHY ID
  net: pcs: xpcs: make the checks related to the PHY interface mode
    stateless
  net: pcs: xpcs: export xpcs_validate
  net: pcs: xpcs: export xpcs_config_eee
  net: pcs: xpcs: export xpcs_probe
  net: pcs: xpcs: use mdiobus_c45_addr in xpcs_{read,write}
  net: pcs: xpcs: convert to mdio_device
  net: pcs: xpcs: convert to phylink_pcs_ops

 drivers/net/ethernet/stmicro/stmmac/common.h  |   3 +-
 drivers/net/ethernet/stmicro/stmmac/hwif.h    |  14 -
 .../ethernet/stmicro/stmmac/stmmac_ethtool.c  |  12 +-
 .../net/ethernet/stmicro/stmmac/stmmac_main.c |  44 +--
 .../net/ethernet/stmicro/stmmac/stmmac_mdio.c |  47 ++-
 drivers/net/pcs/pcs-xpcs.c                    | 371 ++++++++++++------
 include/linux/pcs/pcs-xpcs.h                  |  40 +-
 7 files changed, 306 insertions(+), 225 deletions(-)

-- 
2.25.1

