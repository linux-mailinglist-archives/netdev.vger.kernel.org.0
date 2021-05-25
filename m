Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CD4638FA46
	for <lists+netdev@lfdr.de>; Tue, 25 May 2021 07:53:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230514AbhEYFy3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 May 2021 01:54:29 -0400
Received: from mga14.intel.com ([192.55.52.115]:6192 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230218AbhEYFy2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 May 2021 01:54:28 -0400
IronPort-SDR: mk8xeAO3w08ihiIf/P9orMz9H8wfrn5tlnOF0XnL3TsWUCrAH/hyRRdFcumHL2p1IEmgPlgS+u
 VM6ua0/CCPoA==
X-IronPort-AV: E=McAfee;i="6200,9189,9994"; a="201859993"
X-IronPort-AV: E=Sophos;i="5.82,327,1613462400"; 
   d="scan'208";a="201859993"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 May 2021 22:52:58 -0700
IronPort-SDR: dZ5C0inDdbv+mXAVzHPrvk6zdDzAaviFQY2bh4fRteUlvryOhRU6dLhTjBxhBWOIgZQB0B62z+
 QSHX3PwOWTkQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,327,1613462400"; 
   d="scan'208";a="546369985"
Received: from linux.intel.com ([10.54.29.200])
  by fmsmga001.fm.intel.com with ESMTP; 24 May 2021 22:52:58 -0700
Received: from glass.png.intel.com (glass.png.intel.com [10.158.65.59])
        by linux.intel.com (Postfix) with ESMTP id 44EE4580911;
        Mon, 24 May 2021 22:52:57 -0700 (PDT)
From:   Wong Vee Khee <vee.khee.wong@linux.intel.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RFC net-next 0/2] Introduce MDIO probe order C45 over C22
Date:   Tue, 25 May 2021 13:58:03 +0800
Message-Id: <20210525055803.22116-1-vee.khee.wong@linux.intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Synopsys MAC controller is capable of pairing with external PHY devices
that accessible via Clause-22 and Clause-45.

There is a problem when it is paired with Marvell 88E2110 which returns
PHY ID of 0 using get_phy_c22_id(). We can add this check in that
function, but this will break swphy, as swphy_reg_reg() return 0. [1]

Hence, we introduce MDIOBUS_CAP_C45_C22 which allow us to probe using
Clause-45, if it fails, we then proceed to try with Clause-22.

[1]: https://lkml.org/lkml/2021/3/18/584


Wong Vee Khee (2):
  net: phy: allow mdio bus to probe for c45 devices before c22
  net: stmmac: allow gmac4 to probe for c45 devices before c22

 drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c | 2 +-
 include/linux/phy.h                               | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

-- 
2.25.1

