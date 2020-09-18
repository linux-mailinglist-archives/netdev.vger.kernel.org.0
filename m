Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7DB12704DB
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 21:15:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726414AbgIRTPR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 15:15:17 -0400
Received: from lelv0142.ext.ti.com ([198.47.23.249]:34338 "EHLO
        lelv0142.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726115AbgIRTPL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 15:15:11 -0400
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 08IJExeN088608;
        Fri, 18 Sep 2020 14:14:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1600456499;
        bh=wu5/xFr9pwu8Zq42Eov+lY3Ln3yttnvMD6OI37WhqmA=;
        h=From:To:CC:Subject:Date;
        b=kiqHpsZaDZ2/fW4CP2nT4EuszX3uCHbjgs/K0mMbZ8aoUm36P9Q44VwYkacNNMgiM
         d3BXPrUYCQOM6Y2BOWqQZ0Hdo4uQT7+kC4xcKIzcy4h2hkvRPFg8qskcUACEwiuKOy
         pKb6Poj5IA86we7pitMDvinZFoVPaV3Pl2ZLHx4Q=
Received: from DLEE109.ent.ti.com (dlee109.ent.ti.com [157.170.170.41])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 08IJExTk081401
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 18 Sep 2020 14:14:59 -0500
Received: from DLEE101.ent.ti.com (157.170.170.31) by DLEE109.ent.ti.com
 (157.170.170.41) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Fri, 18
 Sep 2020 14:14:59 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DLEE101.ent.ti.com
 (157.170.170.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Fri, 18 Sep 2020 14:14:59 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 08IJExLi102187;
        Fri, 18 Sep 2020 14:14:59 -0500
From:   Dan Murphy <dmurphy@ti.com>
To:     <davem@davemloft.net>, <andrew@lunn.ch>, <f.fainelli@gmail.com>,
        <hkallweit1@gmail.com>
CC:     <mkubecek@suse.cz>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Dan Murphy <dmurphy@ti.com>
Subject: [PATCH net-next v2 0/3] 100base Fx link modes
Date:   Fri, 18 Sep 2020 14:14:50 -0500
Message-ID: <20200918191453.13914-1-dmurphy@ti.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello

As per patch https://lore.kernel.org/patchwork/patch/1300241/ the link
modes for 100base FX full and half duplex modes did not exist.  Adding these
link modes to the core and ethtool allow devices like the DP83822, DP83869 and
Broadcomm PHYs to properly advertise the correct mode for Fiber 100Mbps.

Corresponding user land ethtool patches are available but rely on these patches
to be applied first.

Dan

Dan Murphy (3):
  ethtool: Add 100base-FX link mode entries
  net: dp83869: Add ability to advertise Fiber connection
  net: phy: dp83822: Update the fiber advertisement for speed

 drivers/net/phy/dp83822.c    | 13 +++++--
 drivers/net/phy/dp83869.c    | 73 ++++++++++++++++++++++++++++++++++++
 drivers/net/phy/phy-core.c   |  4 +-
 include/uapi/linux/ethtool.h |  2 +
 net/ethtool/common.c         |  2 +
 net/ethtool/linkmodes.c      |  2 +
 6 files changed, 92 insertions(+), 4 deletions(-)

-- 
2.28.0

