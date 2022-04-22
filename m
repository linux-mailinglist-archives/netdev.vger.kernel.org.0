Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C459550B1D2
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 09:41:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1444937AbiDVHmV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 03:42:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1444917AbiDVHmT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 03:42:19 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D620E515BE;
        Fri, 22 Apr 2022 00:39:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650613167; x=1682149167;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=ceiOamkSNXFkwRvrAB5A2HWzHS4prL9tkVLL0BwFR5g=;
  b=Y4XrtTsXULlEN7F8ip45q8Y/68JN/RfdlrA/24Kr71UHoJtU/HIT7f/G
   mVdPg9YXZnSS/z1LGsPdcoWJ9FaKQ1BFzJfRYFIFiVoIuwZ+3JfG2g/C1
   3EkvR5vMprD1nbQy/NIbc9mphM3KOEVKvRMC76FZ/e2WQ54i2XLFs9rc3
   ohaAQgmnzTurxtjiTBaogFuCCy4fywSIAi/qJhxERQi9kr+6kOsjAAUNp
   PEkULkIUF/UdqAHg+qh6f55G7FpRYEtHhRSw8m5F39tACVlE9iM3l0qAF
   5VPCepdGsWjx00BpRIEB6ZmzJLlcBYVVJMxVplmBDewkcthodUomhPnVd
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10324"; a="245180184"
X-IronPort-AV: E=Sophos;i="5.90,281,1643702400"; 
   d="scan'208";a="245180184"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2022 00:39:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,281,1643702400"; 
   d="scan'208";a="648516302"
Received: from p12hl98bong5.png.intel.com ([10.158.65.178])
  by FMSMGA003.fm.intel.com with ESMTP; 22 Apr 2022 00:39:23 -0700
From:   Ong Boon Leong <boon.leong.ong@intel.com>
To:     Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>
Cc:     netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Ong Boon Leong <boon.leong.ong@intel.com>
Subject: [PATCH net-next 0/4] pcs-xpcs, stmmac: add 1000BASE-X AN for network switch
Date:   Fri, 22 Apr 2022 15:35:01 +0800
Message-Id: <20220422073505.810084-1-boon.leong.ong@intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=AC_FROM_MANY_DOTS,BAYES_00,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

1/4: Add the support for 1000BASE-X AN to pcs-xpcs which previously supports
     C37 SGMII AN mode.
2/4: Add the capability to bypass PHY device detection in stmmac driver as
     hinted based on platform data.
3/4 & 4/4: Make dwmac-intel to detect DMI info to switch specific ethernet
           interface to use phyless mode according to Ericsson platform
           need.

This patch series has been tested by Ericsson engineer Emilio Riva
<emilio.riva@ericsson.com> separately on its lab.

Thanks

Ong Boon Leong (4):
  net: pcs: xpcs: add CL37 1000BASE-X AN support
  net: stmmac: introduce PHY-less setup support
  stmmac: intel: prepare to support 1000BASE-X phy interface setting
  stmmac: intel: introduce platform data phyless setting for Ericsson
    system

 .../net/ethernet/stmicro/stmmac/dwmac-intel.c |  68 ++++++-
 .../net/ethernet/stmicro/stmmac/stmmac_main.c |  10 +-
 .../net/ethernet/stmicro/stmmac/stmmac_mdio.c |   2 +-
 drivers/net/pcs/pcs-xpcs.c                    | 174 +++++++++++++++++-
 include/linux/pcs/pcs-xpcs.h                  |   3 +-
 include/linux/stmmac.h                        |   1 +
 6 files changed, 250 insertions(+), 8 deletions(-)

--
2.25.1

