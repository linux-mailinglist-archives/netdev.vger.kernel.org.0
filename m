Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87E95197DC2
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 16:01:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727745AbgC3OBi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 10:01:38 -0400
Received: from mx1.tq-group.com ([62.157.118.193]:24401 "EHLO mx1.tq-group.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726099AbgC3OBi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Mar 2020 10:01:38 -0400
X-Greylist: delayed 428 seconds by postgrey-1.27 at vger.kernel.org; Mon, 30 Mar 2020 10:01:37 EDT
IronPort-SDR: k/cMlrQ310LNtxZ/PBbgfkj3G9s0OFe7JKVwqbNI5a206LhugYvWtpFil4i043OZpgWSW2Qm7e
 7So3pC8bRw+bBiMCyDunuNXCLksfE+1Uve8gDtwDUoWxdKpP0WCbGDQ2KNwdLUGJw2Uar+vDsN
 Morn2QbsKgWv1QA10KcHiOmELGFGf9F9z2uqrGYSlu/rXYwVXbdYA63ugjuXLWSlnFTCDfPurW
 zBmdcGcwiiKYdtdRNx9RMI3jVZdex7f8r88zmdE9I3c2wfVVflYI3WuVT2+4IDoOG+/4KQyLof
 NFg=
X-IronPort-AV: E=Sophos;i="5.72,324,1580770800"; 
   d="scan'208";a="11606916"
Received: from unknown (HELO tq-pgp-pr1.tq-net.de) ([192.168.6.15])
  by mx1-pgp.tq-group.com with ESMTP; 30 Mar 2020 15:54:28 +0200
Received: from mx1.tq-group.com ([192.168.6.7])
  by tq-pgp-pr1.tq-net.de (PGP Universal service);
  Mon, 30 Mar 2020 15:54:28 +0200
X-PGP-Universal: processed;
        by tq-pgp-pr1.tq-net.de on Mon, 30 Mar 2020 15:54:28 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=tq-group.com; i=@tq-group.com; q=dns/txt; s=key1;
  t=1585576468; x=1617112468;
  h=from:to:cc:subject:date:message-id;
  bh=MG3g/7I8r8bIcTVclYiAY0P1thD3kW/rua30GE+/02Y=;
  b=AZWoPvAdO0lBMGq4fPwBJXOvlCOdwC7ZvN1wg1JxRVw6g+Dbbao/IGLx
   ARA8vxlsI8hvu0j4FE23kZvtIEAp6pjefwSyg5sunFoD/wS7ZSUoOue/+
   8ASGdG3Nz+a++OszVOlvBUEWnEx+76hzLH6vwUUOWCiJ7gOG/BjKo4lRo
   uVsBeKE5cZwqz0Z3caDOJCu7i2R1Hch6nvFysbyv+hvcvKmbU3O9j2MlA
   Of4EY5LlzrIff/BKoWwfc93oP7++7sD/qA+UPRuCesWvC1LuDPgbYYvXx
   pRORYa6RikOtDINmCKkrniJKhvxrvAFrpPVDQiUsStQMFZghDWyWG9HjC
   w==;
IronPort-SDR: v/DD+d0Grq+WKNTuyZJ84oEobeE86incUxDdycNXkMEac3CbgDSIaVK8EKeirB7ajeva1D7AqZ
 bzQrNhV3YAc/Hj3G/ER1/W5mqYQ9oD7VfwvVcbKOPE3KYEbgmw0pEemxA1ON6g3Q5M5JWPVelS
 g3OZ5uuTFdxOCXjXIOtvgNLS1oNHL0+Uh8IXxq8AbnvAu3ADNN7WEsWvgZ+y34Mg9sCdlr+pkM
 N2+iD2IZgqP2LB9dYAERCXJCCZy8J7P9YRUwDTj9XHZGRR5ORPVCL5+4rNC54hh194gFcvyH/I
 QQs=
X-IronPort-AV: E=Sophos;i="5.72,324,1580770800"; 
   d="scan'208";a="11606915"
Received: from vtuxmail01.tq-net.de ([10.115.0.20])
  by mx1.tq-group.com with ESMTP; 30 Mar 2020 15:54:28 +0200
Received: from schifferm-ubuntu4.tq-net.de (schifferm-ubuntu4.tq-net.de [10.117.49.26])
        by vtuxmail01.tq-net.de (Postfix) with ESMTPA id C9D86280065;
        Mon, 30 Mar 2020 15:54:32 +0200 (CEST)
From:   Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
To:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
Subject: [PATCH net-next 1/4] net: dsa: allow switch drivers to override default slave PHY addresses
Date:   Mon, 30 Mar 2020 15:53:42 +0200
Message-Id: <20200330135345.4361-1-matthias.schiffer@ew.tq-group.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Avoid having to define a PHY for every physical port when PHY addresses
are fixed, but port index != PHY address.

Signed-off-by: Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
---
 include/net/dsa.h |  1 +
 net/dsa/slave.c   | 10 ++++++++--
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index aeb411e77b9a..8216f3687799 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -391,6 +391,7 @@ struct dsa_switch_ops {
 
 	int	(*setup)(struct dsa_switch *ds);
 	void	(*teardown)(struct dsa_switch *ds);
+	int	(*get_phy_address)(struct dsa_switch *ds, int port);
 	u32	(*get_phy_flags)(struct dsa_switch *ds, int port);
 
 	/*
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 8ced165a7908..1c78f8cae9e9 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -1546,7 +1546,7 @@ static int dsa_slave_phy_setup(struct net_device *slave_dev)
 	struct dsa_switch *ds = dp->ds;
 	phy_interface_t mode;
 	u32 phy_flags = 0;
-	int ret;
+	int addr, ret;
 
 	ret = of_get_phy_mode(port_dn, &mode);
 	if (ret)
@@ -1578,7 +1578,13 @@ static int dsa_slave_phy_setup(struct net_device *slave_dev)
 		/* We could not connect to a designated PHY or SFP, so try to
 		 * use the switch internal MDIO bus instead
 		 */
-		ret = dsa_slave_phy_connect(slave_dev, dp->index);
+
+		if (ds->ops->get_phy_address)
+			addr = ds->ops->get_phy_address(ds, dp->index);
+		else
+			addr = dp->index;
+
+		ret = dsa_slave_phy_connect(slave_dev, addr);
 		if (ret) {
 			netdev_err(slave_dev,
 				   "failed to connect to port %d: %d\n",
-- 
2.17.1

