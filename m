Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1398B4A95CE
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 10:14:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240740AbiBDJON (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 04:14:13 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:25483 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236690AbiBDJOF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Feb 2022 04:14:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1643966045; x=1675502045;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ePRSpVCf73WCXDwnkOoXfCkUwDAGs+nG4vIBHM8Ud3E=;
  b=jwoXkY8vx6+VD1F7WG8pgO5/ShM5e228gDJcRzAujYUYWgJZNeKycS2Q
   PVuSfOVKV8Wdcmtw5Jp2dii3hlwHRKeo3S0ZQXJ2zjBTcdZ+XTEqh4bzR
   aUYKj0lC2sef8zQnOdRvtrXA12Amj5ce27Yobt2CiIMi+Aa7zxLQc0Saa
   kqn+UuIMz5hvckR0cANRmpCVr3eL1LBQOR65Lj4eg81U6BZuFStKVmtXt
   vDi4JKKJOJaTvSSpMSvBk6lpec4j1UM4DlqrId07S4rOD90ZxWvtEDUwL
   jowdD/1NMNLguBKewFgVf84moo6RS1IX3BpyXzMcMMUtacfWoMme87wrB
   Q==;
IronPort-SDR: yuKN5kV8tfLxaj3Ydq9gLjCL/P1phX9CBPJVhQxKNphxJGzlo0amQF8IzqYusbiiL1F3aFj/8a
 Q9lsqX+1cvaGvuIfZUJTW388UgdMzNh7CGOyz9kuHx1CXHiP0xkMbv8DzeO843FSXZkJwUDkIk
 GTE7jSrzoyWB/2tx0jGbK80SQEUOxYRkZDt0/LIRjjY8NY5f7EF9GEeWmIv+iZxO/pxI47/M39
 1ozVvNYzBisggb/zzj5v/T43hpqIJmlyNe/D8u5HH4PDGgybUR1H8X3A//n+HBpf57AG/FpsR1
 c0soa58v17/c0aZfryyLrBHu
X-IronPort-AV: E=Sophos;i="5.88,342,1635231600"; 
   d="scan'208";a="161091300"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 04 Feb 2022 02:14:05 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Fri, 4 Feb 2022 02:14:04 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Fri, 4 Feb 2022 02:14:02 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <UNGLinuxDriver@microchip.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <linux@armlinux.org.uk>, <f.fainelli@gmail.com>,
        <vivien.didelot@gmail.com>, <vladimir.oltean@nxp.com>,
        <andrew@lunn.ch>, Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next 1/3] net: lan966x: Update the PGID used by IPV6 data frames
Date:   Fri, 4 Feb 2022 10:14:50 +0100
Message-ID: <20220204091452.403706-2-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220204091452.403706-1-horatiu.vultur@microchip.com>
References: <20220204091452.403706-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When enabling the multicast snooping, the forwarding of the IPV6 frames
has it's own forwarding mask.

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 drivers/net/ethernet/microchip/lan966x/lan966x_main.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
index 8eaaa7559407..3d1072955183 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
@@ -767,7 +767,7 @@ static void lan966x_init(struct lan966x *lan966x)
 	/* Setup flooding PGIDs */
 	lan_wr(ANA_FLOODING_IPMC_FLD_MC4_DATA_SET(PGID_MCIPV4) |
 	       ANA_FLOODING_IPMC_FLD_MC4_CTRL_SET(PGID_MC) |
-	       ANA_FLOODING_IPMC_FLD_MC6_DATA_SET(PGID_MC) |
+	       ANA_FLOODING_IPMC_FLD_MC6_DATA_SET(PGID_MCIPV6) |
 	       ANA_FLOODING_IPMC_FLD_MC6_CTRL_SET(PGID_MC),
 	       lan966x, ANA_FLOODING_IPMC);
 
@@ -829,6 +829,10 @@ static void lan966x_init(struct lan966x *lan966x)
 		ANA_PGID_PGID,
 		lan966x, ANA_PGID(PGID_MCIPV4));
 
+	lan_rmw(GENMASK(lan966x->num_phys_ports - 1, 0),
+		ANA_PGID_PGID,
+		lan966x, ANA_PGID(PGID_MCIPV6));
+
 	/* Unicast to all other ports */
 	lan_rmw(GENMASK(lan966x->num_phys_ports - 1, 0),
 		ANA_PGID_PGID,
-- 
2.33.0

