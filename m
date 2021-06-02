Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5195C398FD2
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 18:20:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229981AbhFBQWe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 12:22:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229904AbhFBQWd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Jun 2021 12:22:33 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46AE1C06174A
        for <netdev@vger.kernel.org>; Wed,  2 Jun 2021 09:20:33 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id gb17so4693252ejc.8
        for <netdev@vger.kernel.org>; Wed, 02 Jun 2021 09:20:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=41Bl77NUyEnvs3+ONIvTMnq4lppJ6RHlCiScY9O6mbk=;
        b=Zld1fAfijyM1PF2W+nkDX1EI691BSzKDLZL1V/8C5nTLeg42yWU+l5JrNY7afWsieC
         vBzzpGXOitNUDOwoe6zNCCt66zfxcmfZlJt0AryWUXuU6qEXl07v8XceyCJVGDoOgbb6
         EYhzybaoYXParPZtzI/UJIdAB9QF1IWbAX3RWN1igIaZSXQup60LLt+1c74hrRbFf8Qc
         Bp5ft1NZE87FsOarqTcdQ/1pZFI6UmpB4oLJswrt9pLgfZ1Q+tzn+PejCfRDEktpxILp
         CJOL7iuOPbm4E0/9GMEacfQsI37VSV3PfIwLvRmetDb2A9wZAG/Gw8NWbAgccVI9jX+S
         XV0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=41Bl77NUyEnvs3+ONIvTMnq4lppJ6RHlCiScY9O6mbk=;
        b=d6kI/7kdLHIP5t30RE/rihtmPB6bC0pDO7w43izop4xdb026b9u4Jv/k6QIG4Trqq0
         eCCNOxRr+OVbVNKkRu7fVaSsXrNrIcYv0zmIDQu2Zo+oarX7qkBDcXkBKcI2KIQcC+sb
         ajst/AEGIWS1r1YsEwcrHMTkPkeCQzu/JvDJCX+j1pJ14lBDSaXAAxycsCjHhuL1W2wE
         kBn6iyOZSYUJJrLDxmOc8ESvQ1alBGxO0g6oXpatBUBfEO84SPUmSTKKeYzvs1PGkHaH
         I+9JtaufVJtgj7qArh4rVKMacopKfv2/A/t7+6bPlLDncVljX1/F5JDAOzpYGPWq9gpu
         AY9A==
X-Gm-Message-State: AOAM531jcfM4ep2v/Ijm0nBgwe9iOVohZ8pZrr/fUV6mOyuWfavoTxEQ
        bwekKNn+gj3L2t42z+afJYxWGRiIm2A=
X-Google-Smtp-Source: ABdhPJxDbyzSxtIu9VaCLV+zhlHr3I1z/m4T0yHkU7M/Vwbb4ARfytPXT3rtDxh561gRnu5tgN4iXA==
X-Received: by 2002:a17:906:2bd3:: with SMTP id n19mr34930378ejg.210.1622650831811;
        Wed, 02 Jun 2021 09:20:31 -0700 (PDT)
Received: from localhost.localdomain ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id m12sm228078edc.40.2021.06.02.09.20.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Jun 2021 09:20:31 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Wong Vee Khee <vee.khee.wong@linux.intel.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v3 net-next 0/9] Convert xpcs to phylink_pcs_ops
Date:   Wed,  2 Jun 2021 19:20:10 +0300
Message-Id: <20210602162019.2201925-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Background: the sja1105 DSA driver currently drives a Designware XPCS
for SGMII and 2500base-X, and it would be nice to reuse some code with
the xpcs module. This would also help consolidate the phylink_pcs_ops,
since the only other dedicated PCS driver, currently, is the lynx_pcs.

Therefore, this series makes the xpcs expose the same kind of API that
the lynx_pcs module does. The main changes are getting rid of struct
mdio_xpcs_ops, being compatible with struct phylink_pcs_ops and being
less reliant on the phy_interface_t passed to xpcs_probe (now renamed to
xpcs_create).

This patch series is partially tested (some code paths have been covered
on the NXP SJA1105 and some others with the help of Vee Khee Wong on
Intel Tiger Lake / stmmac) but further testing on 10G setups would be
appreciated, if possible.

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
 .../net/ethernet/stmicro/stmmac/stmmac_main.c |  39 +-
 .../net/ethernet/stmicro/stmmac/stmmac_mdio.c |  47 +--
 drivers/net/pcs/pcs-xpcs.c                    | 395 ++++++++++++------
 include/linux/pcs/pcs-xpcs.h                  |  40 +-
 7 files changed, 319 insertions(+), 231 deletions(-)

-- 
2.25.1

