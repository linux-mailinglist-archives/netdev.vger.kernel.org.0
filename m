Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 454E054C3D4
	for <lists+netdev@lfdr.de>; Wed, 15 Jun 2022 10:44:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344221AbiFOIoe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jun 2022 04:44:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347035AbiFOIn5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jun 2022 04:43:57 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5641F42492;
        Wed, 15 Jun 2022 01:43:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655282636; x=1686818636;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=9BCmaDXuxZ78d4GhPN+LZuRqgQk4eGFz2he5NDkGKa4=;
  b=mCCHKCM21FJnIc4dzvHH93pTnROJG/VKYN/ySmVdSrBgIqAsRggxJpm4
   DjAOGqSpVjuvqIAtTkdUOdlGwNYeGrn/Pw5znh0Crthj3n6zZE9wkJDsI
   zdWH44Q+L55AbDC/5+iuJa+XxQnALs9J+8zAxVExaSyP1yhIuDCUWqKym
   5d0gGoCcsN/Zl+cK9fbmLVScbtY7j1YAUI+cjslwCfzLjOqouboogtR66
   1VQqZOzTSiujlvXyRCmY4cHT87XBMTwGfkjchU/cxX+Qskrs9GMeHVsDP
   11j2x2tgNCQAGVY1vyJUXbcsFPUbqR18AoUX5OVjlSJn7aIrs1+CrRGKH
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10378"; a="277676289"
X-IronPort-AV: E=Sophos;i="5.91,300,1647327600"; 
   d="scan'208";a="277676289"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2022 01:43:55 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,300,1647327600"; 
   d="scan'208";a="712849326"
Received: from p12hl98bong5.png.intel.com ([10.158.65.178])
  by orsmga004.jf.intel.com with ESMTP; 15 Jun 2022 01:43:49 -0700
From:   Ong Boon Leong <boon.leong.ong@intel.com>
To:     Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Vladimir Oltean <olteanv@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>
Cc:     netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Emilio Riva <emilio.riva@ericsson.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>
Subject: [PATCH net-next v5 0/5] pcs-xpcs, stmmac: add 1000BASE-X AN for network switch
Date:   Wed, 15 Jun 2022 16:39:03 +0800
Message-Id: <20220615083908.1651975-1-boon.leong.ong@intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=AC_FROM_MANY_DOTS,BAYES_00,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks for v4 review feedback in [1] and [2]. I have changed the v5
implementation as follow.

v5 changes:
1/5 - No change from v4.
2/5 - No change from v4.
3/5 - [Fix] make xpcs_modify_changed() static and use
      mdiodev_modify_changed() for cleaner code as suggested by
      Russell King.
4/5 - [Fix] Use fwnode_get_phy_mode() as recommended by Andrew Lunn.
5/5 - [Fix] Make fwnode = of_fwnode_handle(priv->plat->phylink_node)
      order after priv = netdev_priv(dev).

v4 changes:
1/5 - Squash v3:1/7 & 2/7 patches into v4:1/6 so that it passes build.
2/5 - [No change] same as v3:3/7
3/5 - [Fix] Fix issues identified by Russell in [1]
4/5 - [Fix] Drop v3:5/7 patch per input by Russell in [2] and make
            dwmac-intel clear the ovr_an_inband flag if fixed-link
            is used in ACPI _DSD.
5/5 - [No change] same as v3:7/7

For the steps to setup ACPI _DSD and checking, they are the same
as in [3]

Reference:
[1] https://patchwork.kernel.org/comment/24894239/
[2] https://patchwork.kernel.org/comment/24895330/
[3] https://patchwork.kernel.org/project/netdevbpf/cover/20220610033610.114084-1-boon.leong.ong@intel.com/

Thanks
Boon Leong

Ong Boon Leong (5):
  net: make xpcs_do_config to accept advertising for pcs-xpcs and
    sja1105
  stmmac: intel: prepare to support 1000BASE-X phy interface setting
  net: pcs: xpcs: add CL37 1000BASE-X AN support
  stmmac: intel: add phy-mode and fixed-link ACPI _DSD setting support
  net: stmmac: make mdio register skips PHY scanning for fixed-link

 drivers/net/dsa/sja1105/sja1105_main.c        |   2 +-
 .../net/ethernet/stmicro/stmmac/dwmac-intel.c |  34 +++-
 .../net/ethernet/stmicro/stmmac/stmmac_main.c |  12 +-
 .../net/ethernet/stmicro/stmmac/stmmac_mdio.c |  14 ++
 drivers/net/pcs/pcs-xpcs.c                    | 176 +++++++++++++++++-
 drivers/net/pcs/pcs-xpcs.h                    |   1 -
 include/linux/pcs/pcs-xpcs.h                  |   3 +-
 7 files changed, 229 insertions(+), 13 deletions(-)

--
2.25.1

