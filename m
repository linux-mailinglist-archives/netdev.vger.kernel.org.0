Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 57E63F3C5F
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 00:58:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727794AbfKGX6e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 18:58:34 -0500
Received: from ssl.serverraum.org ([176.9.125.105]:53867 "EHLO
        ssl.serverraum.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725906AbfKGX6e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 18:58:34 -0500
Received: from apollo.fritz.box (unknown [IPv6:2a02:810c:c200:2e91:6257:18ff:fec4:ca34])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 5114823E23;
        Fri,  8 Nov 2019 00:58:31 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc;
        s=mail2016061301; t=1573171112;
        bh=GTbVnP35xn/Y0nwP1JsExVBFBqddoJ9o4ht2MFIvCXc=;
        h=From:To:Cc:Subject:Date:From;
        b=EFn1nWBMWzQD8wXQluoJRpaHKI3W5QmMXS6MDB7D6kEHxXXRDKzyFU+1lk1ExxHkZ
         CupqapBjs0Xi3IfNENrk0ZIYIPA7Exe30ZDr3E09M7m3T5mZOp8tGG10cxS6a8CnM/
         8wbey6e9kT9PEUnnJAe0jdetgJz3VryGr+lmG+/0=
From:   Michael Walle <michael@walle.cc>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>, Michael Walle <michael@walle.cc>
Subject: [PATCH] enetc: fix return value for enetc_ioctl()
Date:   Fri,  8 Nov 2019 00:58:21 +0100
Message-Id: <20191107235821.12767-1-michael@walle.cc>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: clamav-milter 0.101.4 at web
X-Virus-Status: Clean
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Return -EOPNOTSUPP instead of -EINVAL if the requested ioctl is not
implemented.

Signed-off-by: Michael Walle <michael@walle.cc>
---
 drivers/net/ethernet/freescale/enetc/enetc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index 25af207f1962..3e8f9819f08c 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -1601,7 +1601,7 @@ int enetc_ioctl(struct net_device *ndev, struct ifreq *rq, int cmd)
 #endif
 
 	if (!ndev->phydev)
-		return -EINVAL;
+		return -EOPNOTSUPP;
 	return phy_mii_ioctl(ndev->phydev, rq, cmd);
 }
 
-- 
2.20.1

