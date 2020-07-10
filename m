Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A51A21B55A
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 14:47:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727059AbgGJMrX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jul 2020 08:47:23 -0400
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:49507 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726820AbgGJMrX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jul 2020 08:47:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1594385242; x=1625921242;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=xLfmshkpWd2aPH7pkCemLYvnT4Uwrw+Ep4bfRxiIgoI=;
  b=vd2IDop9IMn2PlGdA93Fp808vN8C1Uaowf5Vx+AX3qlQrSldIrw0edIZ
   NrYnp4y2ASAmT9TyC/q9krHrraehBVZbztr9mMo+BIXhVyIRuL9i1uaqP
   S4gQgYeAG6vdY59v35tWSjeOCNKm9hJ4WokDV/ijhK7Ciu+0so7dEeOQn
   e0qNEZXc54iWRjsvVpvulGyAnQxXYNa81xx7FH2wcK5ryQyBE85PWh7W4
   jkO1EO1EXHf8N8odUQCIG0kiea/R/e1NK3/zn0s+DwhBeQk3zrPvVX9ge
   jE0Xe51KZefqYvlVyJ3lJC9KOgokvtcYqMiAr0eQfh+WFncHpTmQQgkCW
   A==;
IronPort-SDR: 29sAthIvWYA09TD6RubA5XnKXwmkVwup5JbrbBbAFI2mNB6uqYyGe53H3DmoFlRU1QOdjoR1nA
 5YJNC32onJ7wLmZkxhaU0I29tXzYTqqe1xlixE7dtO0gb1QnGQbdnyya1VX5AHdHKMh1Gc2Px5
 nFOxOAIe2Ync+HoubkPzulMaeC3wh3UtTp3j1vgwbCaxPjEXW4yTzoGeVuHgAsNIP+Nqs4TCj0
 0hhx1QdaULMWTbomAWh25qkAaQMkEYFVUX3A0dLo+w9w7fUxnKTn9/hqjY9sagt2VWE0N6rJbf
 yPo=
X-IronPort-AV: E=Sophos;i="5.75,335,1589266800"; 
   d="scan'208";a="87021923"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 10 Jul 2020 05:47:22 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 10 Jul 2020 05:46:54 -0700
Received: from ness.mchp-main.com (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Fri, 10 Jul 2020 05:47:18 -0700
From:   <nicolas.ferre@microchip.com>
To:     <linux@armlinux.org.uk>, <linux-arm-kernel@lists.infradead.org>,
        <netdev@vger.kernel.org>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        <harini.katakam@xilinx.com>, <f.fainelli@gmail.com>
CC:     <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        <antoine.tenart@bootlin.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>
Subject: [PATCH v5 0/5] net: macb: Wake-on-Lan magic packet fixes and GEM handling
Date:   Fri, 10 Jul 2020 14:46:40 +0200
Message-ID: <cover.1594384335.git.nicolas.ferre@microchip.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nicolas Ferre <nicolas.ferre@microchip.com>

Hi,
Here is a split series to fix WoL magic-packet on the current macb driver. Only
fixes in this one based on current net/master.

Best regards,
  Nicolas

Changes in v5:
- Addressed the error code returned by phylink_ethtool_set_wol() as suggested
  by Russell.
  If PHY handles WoL, MAC doesn't stay in the way.
- Removed Florian's tag on 3/5 because of the above changes.
- Correct the "Fixes" tag on 1/5.

Changes in v4:
- Pure bug fix series for 'net'. GEM addition and MACB update removed: will be
  sent later.

Changes in v3:
- Revert some of the v2 changes done in macb_resume(). Now the resume function
  supports in-depth re-configuration of the controller in order to deal with
  deeper sleep states. Basically as it was before changes introduced by this
  series
- Tested for non-regression with our deeper Power Management mode which cuts
  power to the controller completely

Changes in v2:
- Add patch 4/7 ("net: macb: fix macb_suspend() by removing call to netif_carrier_off()")
  needed for keeping phy state consistent
- Add patch 5/7 ("net: macb: fix call to pm_runtime in the suspend/resume functions") that prevent
  putting the macb in runtime pm suspend mode when WoL is used
- Collect review tags on 3 first patches from Florian: Thanks!
- Review of macb_resume() function
- Addition of pm_wakeup_event() in both MACB and GEM WoL IRQ handlers


Nicolas Ferre (5):
  net: macb: fix wakeup test in runtime suspend/resume routines
  net: macb: mark device wake capable when "magic-packet" property
    present
  net: macb: fix macb_get/set_wol() when moving to phylink
  net: macb: fix macb_suspend() by removing call to netif_carrier_off()
  net: macb: fix call to pm_runtime in the suspend/resume functions

 drivers/net/ethernet/cadence/macb_main.c | 31 +++++++++++++++---------
 1 file changed, 19 insertions(+), 12 deletions(-)

-- 
2.27.0

