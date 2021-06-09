Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50A173A1CF0
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 20:43:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230096AbhFISpW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 14:45:22 -0400
Received: from mail-ej1-f42.google.com ([209.85.218.42]:39585 "EHLO
        mail-ej1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230106AbhFISpU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Jun 2021 14:45:20 -0400
Received: by mail-ej1-f42.google.com with SMTP id l1so39932492ejb.6
        for <netdev@vger.kernel.org>; Wed, 09 Jun 2021 11:43:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rceO9tKZcSeK1TyIcro0IgiEMH2dHetibPh65Qbviq8=;
        b=DeYoYzZJ+O2+XyMOIUplTJ2GYHhUDQzQQHpJAYshiCsv+fL27nzoNUhjS9MrntRCh4
         33Udl+0YQ5Tbxcbs1p+tDKxRPU/dw49YfqYPAqADt4tD/OQkMgDQVDrhUE2moVQKXNFn
         yUXAK5KhiC0NLZRUZw/e00oUjtGgF8LR4S6LnYRUtG6GBswFrTYnIXGYJqX/iib6ZQAR
         VD9u4CmVcde8WSUAsCuNhl/gFLjrRw7cISACcLjQ7s3fJpXwdOqS/xiCO2Xc9dZmZrS8
         iYAHVkrs16NVUsZDvqW1jYgIdul15wMATF8JSlpqO6KMbYVdMxibMxi9qIkIr/l2juYH
         UZ0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rceO9tKZcSeK1TyIcro0IgiEMH2dHetibPh65Qbviq8=;
        b=iZybI2I5Ks1mvisWjIa2JPCeQsddXrzJpPkBo+6DOgS6XXOJaMhL7tAjT7m8jsxo5w
         L41PIh0To0VZur0hB0yj6h4CqzVH58rao8xv135D+XJ6GVc56ijiWziCyCR9/GZfdMb7
         EZxWFTwfJWxCxr7eZ41nIedE1d/asQBGmjy3/lwcrOoUdKFcM6wyINb8+zXAC5lYcqbb
         +hN7fFk8t0IWc0bPW5g7JgbrLVV2CfLPg3XsBAyZW/Ne+ZOIyJhSSVjIR8qrOD3He5Dy
         qnrbdZuEGf3x/mz0KDoLJU5O8Cjeq78jTGP6wWPE8vONvdVHTPzICRwdLjeyyZ3miXu5
         Xkrw==
X-Gm-Message-State: AOAM530zQF4ORo1N7TLs8TUqzKbjIQM4YlYuYpuOtoZkBobwXO84Anq4
        dwz9waoul1V/9OVh5u68SdQ=
X-Google-Smtp-Source: ABdhPJwkZwR1zUoEaJWrWm20KXLAjMPZB8UBtSC+R09qA/Tev6elWynVOIIuM+WycJ51zgq4RhkKIQ==
X-Received: by 2002:a17:906:b41:: with SMTP id v1mr1157588ejg.246.1623264131584;
        Wed, 09 Jun 2021 11:42:11 -0700 (PDT)
Received: from localhost.localdomain ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id oz11sm194935ejb.16.2021.06.09.11.42.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Jun 2021 11:42:11 -0700 (PDT)
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
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net-next 00/13] Port the SJA1105 DSA driver to XPCS
Date:   Wed,  9 Jun 2021 21:41:42 +0300
Message-Id: <20210609184155.921662-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

As requested when adding support for the NXP SJA1110, the SJA1105 driver
could make use of the common XPCS driver, to eliminate some hardware
specific code duplication.

This series modifies the XPCS driver so that it can accommodate the XPCS
instantiation from NXP switches, and the SJA1105 driver so it can expose
what the XPCS driver expects.

Tested on NXP SJA1105S and SJA1110A.

Vladimir Oltean (13):
  net: pcs: xpcs: rename mdio_xpcs_args to dw_xpcs
  net: stmmac: reverse Christmas tree notation in stmmac_xpcs_setup
  net: stmmac: reduce indentation when calling stmmac_xpcs_setup
  net: pcs: xpcs: move register bit descriptions to a header file
  net: pcs: xpcs: add support for sgmii with no inband AN
  net: pcs: xpcs: also ignore phy id if it's all ones
  net: pcs: xpcs: add support for NXP SJA1105
  net: pcs: xpcs: add support for NXP SJA1110
  net: pcs: xpcs: export xpcs_do_config and xpcs_link_up
  net: dsa: sja1105: migrate to xpcs for SGMII
  net: dsa: sja1105: register the PCS MDIO bus for SJA1110
  net: dsa: sja1105: SGMII and 2500base-x on the SJA1110 are 'special'
  net: dsa: sja1105: plug in support for 2500base-x

 MAINTAINERS                                   |   2 +
 drivers/net/dsa/sja1105/Kconfig               |   1 +
 drivers/net/dsa/sja1105/sja1105.h             |   9 +
 drivers/net/dsa/sja1105/sja1105_main.c        | 186 +++----------
 drivers/net/dsa/sja1105/sja1105_mdio.c        | 254 +++++++++++++++++
 drivers/net/dsa/sja1105/sja1105_sgmii.h       |   2 -
 drivers/net/dsa/sja1105/sja1105_spi.c         |  17 ++
 drivers/net/ethernet/stmicro/stmmac/common.h  |   2 +-
 .../net/ethernet/stmicro/stmmac/stmmac_main.c |  10 +-
 .../net/ethernet/stmicro/stmmac/stmmac_mdio.c |   6 +-
 drivers/net/pcs/Makefile                      |   2 +-
 drivers/net/pcs/pcs-xpcs-nxp.c                | 185 ++++++++++++
 drivers/net/pcs/pcs-xpcs.c                    | 263 +++++++++---------
 drivers/net/pcs/pcs-xpcs.h                    | 115 ++++++++
 include/linux/pcs/pcs-xpcs.h                  |  21 +-
 15 files changed, 770 insertions(+), 305 deletions(-)
 create mode 100644 drivers/net/pcs/pcs-xpcs-nxp.c
 create mode 100644 drivers/net/pcs/pcs-xpcs.h

-- 
2.25.1

