Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC24726ABF1
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 20:31:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727954AbgIOSaH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 14:30:07 -0400
Received: from lelv0143.ext.ti.com ([198.47.23.248]:59206 "EHLO
        lelv0143.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728004AbgIOSRc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Sep 2020 14:17:32 -0400
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 08FIHEeI046506;
        Tue, 15 Sep 2020 13:17:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1600193834;
        bh=wu5/xFr9pwu8Zq42Eov+lY3Ln3yttnvMD6OI37WhqmA=;
        h=From:To:CC:Subject:Date;
        b=x5liqt0F8Q39uFnYRjTy+xwM687ntDHUR5xdEAoNcBadgbHT8vVpsBNoWc/zv4TTA
         QODs5066XmPE4L23iW8GEbgZ2WLxmml2QWIU+UFd3FQwZsqlOPsiD6wGefuYqykfRr
         UG98LQLAESELJdmbj3ysFQhD2k83vWobCWTsDj1A=
Received: from DFLE113.ent.ti.com (dfle113.ent.ti.com [10.64.6.34])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 08FIHE7v024757
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 15 Sep 2020 13:17:14 -0500
Received: from DFLE104.ent.ti.com (10.64.6.25) by DFLE113.ent.ti.com
 (10.64.6.34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Tue, 15
 Sep 2020 13:17:14 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DFLE104.ent.ti.com
 (10.64.6.25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Tue, 15 Sep 2020 13:17:14 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 08FIHET1112551;
        Tue, 15 Sep 2020 13:17:14 -0500
From:   Dan Murphy <dmurphy@ti.com>
To:     <davem@davemloft.net>, <andrew@lunn.ch>, <f.fainelli@gmail.com>,
        <hkallweit1@gmail.com>
CC:     <mkubecek@suse.cz>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Dan Murphy <dmurphy@ti.com>
Subject: [PATCH net-next 0/3] 100base Fx link modes
Date:   Tue, 15 Sep 2020 13:17:05 -0500
Message-ID: <20200915181708.25842-1-dmurphy@ti.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
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

