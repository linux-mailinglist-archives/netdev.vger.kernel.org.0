Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 291AC3A49E0
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 22:07:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230303AbhFKUI6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 16:08:58 -0400
Received: from mail-ed1-f51.google.com ([209.85.208.51]:33382 "EHLO
        mail-ed1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230523AbhFKUIx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Jun 2021 16:08:53 -0400
Received: by mail-ed1-f51.google.com with SMTP id f5so33442832eds.0
        for <netdev@vger.kernel.org>; Fri, 11 Jun 2021 13:06:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Ll27mDkR2Nn4CAVr/nM06w1iVZSiEYp0rZ5xtbtYd4U=;
        b=dzZBGpG+d5zXDBADJKaPJ9kRBGj3zlm2aKmxo5Xm+bWyxje6+MCpr/BDnD+EDH/UVU
         cGYaj2we1IsvSTRA4cQ5eoSQi0nGR6VjXJRgKhf5uvnAFesDrxAZadyUwyrHWQrRiM0E
         Xad3oOqKBEj3siYiVPHb9HCyqm9GiEC/72ttmmh24gLMgQIwRhVRvT4wAK41OkyuwD8t
         tgXx1AnLPGMDd6YXvvzi3TKCCjoyg9eVaSPp0riZ218m5656JO0fzB1QWJ9e/wpOLXt1
         1igOBIprpg4qx4hyl6lXtG53Y/fZnxVBRSbvvjxqCwvEdxuofI0D2W42Un0vEjKckAqc
         JXRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Ll27mDkR2Nn4CAVr/nM06w1iVZSiEYp0rZ5xtbtYd4U=;
        b=mJduZzxPkAM2OY0pZ1cq7tpmHQ8elWxmOympT8crSHIoUU5QI4HT5tICO6i5n4xXcO
         HyXNZ6nPVEnEHA/TKUaEr9IOQURhN/8jCygPVNJn1AULcaSheaXJNUUjjSz4bheOJGYT
         vOFR0PADj0wl/42Jep7B6IjHAw2A18Q1D0eh11e61VsAo2WYTfoqmWE0rahqClB8se1x
         HNCvyPZLolVqvPrCpSLxip/t/DQglbxpNdIqg9PKUSBs4S4LmU9by4WkdSom2cT3GaKO
         +MLm4+yR9ScyxoKo8ADheUIxXbCVd5xSydfeSDJjq9RGj0oD1JDFb6+6aAn9uRKp/n3A
         vrHw==
X-Gm-Message-State: AOAM531LsQbfD55ZqZJqk8AUG3unao4knJLiSyPQf2zR84D+P1bNDSoj
        Wzt0fgTifWmF6IJfSkSNUGQ=
X-Google-Smtp-Source: ABdhPJzunxNNjjyMF0VXDIesSOjh6QPhWVlV3iNn5LUCNKqbbCDbVQdrLvN9Jmj25SjP5YdpqxWViw==
X-Received: by 2002:a50:f403:: with SMTP id r3mr5380022edm.101.1623441945575;
        Fri, 11 Jun 2021 13:05:45 -0700 (PDT)
Received: from localhost.localdomain ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id w2sm2392084ejn.118.2021.06.11.13.05.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Jun 2021 13:05:45 -0700 (PDT)
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
        linux-arm-kernel@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v3 net-next 00/13] Port the SJA1105 DSA driver to XPCS
Date:   Fri, 11 Jun 2021 23:05:18 +0300
Message-Id: <20210611200531.2384819-1-olteanv@gmail.com>
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

Changes in v3:
None. This is a resend of v2 which had "changes requested" even though
there was no direct feedback.

Changes in v2:
- fix module build (pcs-xpcs-nxp.c is not a different module so this
  means that we need to change the name of pcs-xpcs.ko to pcs_xpcs.ko).
- delete sja1105_sgmii.h
- just check for priv->pcs[port] instead of checking the PHY interface
  mode each time.
- add the 2500base-x check in one place where it was missing (before
  mdio_device_create)
- remove it from a few places where it is no longer necessary now that
  we check more generically for the presence of priv->xpcs[port]

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
 drivers/net/dsa/sja1105/sja1105_mdio.c        | 255 +++++++++++++++++
 drivers/net/dsa/sja1105/sja1105_sgmii.h       |  53 ----
 drivers/net/dsa/sja1105/sja1105_spi.c         |  17 ++
 drivers/net/ethernet/stmicro/stmmac/common.h  |   2 +-
 .../net/ethernet/stmicro/stmmac/stmmac_main.c |  10 +-
 .../net/ethernet/stmicro/stmmac/stmmac_mdio.c |   6 +-
 drivers/net/pcs/Makefile                      |   4 +-
 drivers/net/pcs/pcs-xpcs-nxp.c                | 185 ++++++++++++
 drivers/net/pcs/pcs-xpcs.c                    | 263 +++++++++---------
 drivers/net/pcs/pcs-xpcs.h                    | 115 ++++++++
 include/linux/pcs/pcs-xpcs.h                  |  21 +-
 15 files changed, 772 insertions(+), 357 deletions(-)
 delete mode 100644 drivers/net/dsa/sja1105/sja1105_sgmii.h
 create mode 100644 drivers/net/pcs/pcs-xpcs-nxp.c
 create mode 100644 drivers/net/pcs/pcs-xpcs.h

-- 
2.25.1

