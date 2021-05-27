Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 192DE393745
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 22:45:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235601AbhE0UrP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 16:47:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235379AbhE0UrN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 May 2021 16:47:13 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAA5BC061574
        for <netdev@vger.kernel.org>; Thu, 27 May 2021 13:45:39 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id y7so2378489eda.2
        for <netdev@vger.kernel.org>; Thu, 27 May 2021 13:45:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=SaT/vLHCQCyzy7/SOjdKUNsHHBOiv8MZKllqNWNqN+U=;
        b=Hlww5TEyH4Bi0p3cYm+dIjyRQBl9KSUg7OgignRdqTtKE0dAAYniWT9cXFHsHHYyP8
         qOLRPmMlrdwwTiUA9yK8hrCl2TBxzFqTzzCzdU84CHRV5YaWcF3Yum/Q+CHsKUjjluqJ
         CGvuM7V7wjScdHe0dGgJer1ABwo3o8NJxpbBZt4WiW5FWhLeS7PhdLg3kMy0z6Y5cqUk
         HG5w/NCodK1hfKrGaX6mh5mGS4N1dh54AXcSuu/doe+wVKyKJl+lHLmkXIopz1yFOFlk
         UFcjS96RGZVEa9cTtSQmiF/9sT/FKG4CE58zmoUDvN5CjvxP9cwEgJFtkHQWcIiiepoy
         scog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=SaT/vLHCQCyzy7/SOjdKUNsHHBOiv8MZKllqNWNqN+U=;
        b=f6mmJEDh+3J8L0B2XiaoWhWmcrKppJ3oKiLioX0CAGQi2+0ZxudP3oihb0vpRW0VZp
         2A5+kNKm3fBeaiHaAoHcQNrpeict2k+sPAfep1yzRrtnj14WL6BB1VzqwBntbEkvZQof
         ZF9esh+M7RtY70Ta0KkKfMXYu5fpQu9bx+aAiqjbJBT1Iq2iWq6LNBOvdJAvsVQTjFH5
         KTb/SZlQ7VS+4VX5b9ztLDel9ig0fcvGmfNMdaX+IYsMW+07+gx30MLp9cYjQMvrzd5n
         nDgzUJbnLNzvDxrPszylmJKxp1YTImBk6A+Zq4EAavNoZlfU1y20Rnl2angIOng/B3xq
         ZNPw==
X-Gm-Message-State: AOAM533rBpLWh6n4mRmxOjp/xnNd26LYh+aMJaSdgQ3tNiZ5sdltR75S
        hJvDqzvBJtX4SRlkrGnHhQRzFZdaCWc=
X-Google-Smtp-Source: ABdhPJxtlTh4Qyz5TWaxPWkpkRXhjSh4yszF2aCvGos94vL1d3NwJqWMoj3EggX5v/6WHFyH4WVwuA==
X-Received: by 2002:a05:6402:c8:: with SMTP id i8mr6249535edu.380.1622148338201;
        Thu, 27 May 2021 13:45:38 -0700 (PDT)
Received: from localhost.localdomain ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id g11sm1654145edt.85.2021.05.27.13.45.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 May 2021 13:45:37 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [RFC PATCH net-next 0/8] Convert xpcs to phylink_pcs_ops
Date:   Thu, 27 May 2021 23:45:20 +0300
Message-Id: <20210527204528.3490126-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

This patch series is COMPLETELY UNTESTED (I don't have stmmac hardware
with the xpcs) hence the RFC tag. If people from Intel could test this
it would be great.

Background: the sja1105 DSA driver currently drives a Designware XPCS
for SGMII and 2500base-X, and it would be nice to reuse some code with
the xpcs module. This would also help consolidate the phylink_pcs_ops,
since the only user of that, currently, is the lynx_pcs.

Therefore, this series makes the xpcs expose the same kind of API that
the lynx_pcs module does.

Note: this patch series must be applied on top of:
https://patchwork.kernel.org/project/netdevbpf/patch/20210527155959.3270478-1-olteanv@gmail.com/

Vladimir Oltean (8):
  net: pcs: xpcs: delete shim definition for mdio_xpcs_get_ops()
  net: pcs: xpcs: check for supported PHY interface modes in
    phylink_validate
  net: pcs: xpcs: export xpcs_validate
  net: pcs: export xpcs_config_eee
  net: pcs: xpcs: export xpcs_probe
  net: pcs: xpcs: convert to phylink_pcs_ops
  net: pcs: xpcs: use mdiobus_c45_addr in xpcs_{read,write}
  net: pcs: xpcs: convert to mdio_device

 drivers/net/ethernet/stmicro/stmmac/common.h  |   3 +-
 drivers/net/ethernet/stmicro/stmmac/hwif.h    |  14 --
 .../ethernet/stmicro/stmmac/stmmac_ethtool.c  |   5 +-
 .../net/ethernet/stmicro/stmmac/stmmac_main.c |  41 +---
 .../net/ethernet/stmicro/stmmac/stmmac_mdio.c |  41 ++--
 drivers/net/pcs/pcs-xpcs.c                    | 199 +++++++++++-------
 include/linux/pcs/pcs-xpcs.h                  |  35 +--
 7 files changed, 162 insertions(+), 176 deletions(-)

-- 
2.25.1

