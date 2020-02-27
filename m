Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B0AB172966
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 21:21:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729767AbgB0UVQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Feb 2020 15:21:16 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:37646 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726758AbgB0UVP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Feb 2020 15:21:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=QTuJNNGDtptHGRCKouJIZPfySFkxGZ1ALSKzSVzG/qc=; b=qvSWGNMD/oxYsOZS0EdW7KJ8qz
        9yZgEIf+pl7Ey15FdL0Ghxz607C8AkkYUpnuvX9ThUkO0QhQPbBrt4zr2+IB6Z12eF/ix1vKcQRAH
        NgF97reDBWPGgFy0YZglWXIL1ruYHx18auPAkMPmvwy17LW1vmrsO67AJT1jOFrAQT+M=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1j7Peg-0007my-H2; Thu, 27 Feb 2020 21:21:10 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Chris Healy <Chris.Healy@zii.aero>,
        Andrew Lunn <andrew@lunn.ch>,
        Kevin Benson <Kevin.Benson@zii.aero>
Subject: [PATCH net] net: dsa: mv88e6xxx: Fix masking of egress port
Date:   Thu, 27 Feb 2020 21:20:49 +0100
Message-Id: <20200227202049.29895-1-andrew@lunn.ch>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add missing ~ to the usage of the mask.

Reported-by: Kevin Benson <Kevin.Benson@zii.aero>
Reported-by: Chris Healy <Chris.Healy@zii.aero>
Fixes: 5c74c54ce6ff ("net: dsa: mv88e6xxx: Split monitor port configuration")
Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/dsa/mv88e6xxx/global1.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/global1.c b/drivers/net/dsa/mv88e6xxx/global1.c
index b016cc205f81..ca3a7a7a73c3 100644
--- a/drivers/net/dsa/mv88e6xxx/global1.c
+++ b/drivers/net/dsa/mv88e6xxx/global1.c
@@ -278,13 +278,13 @@ int mv88e6095_g1_set_egress_port(struct mv88e6xxx_chip *chip,
 	switch (direction) {
 	case MV88E6XXX_EGRESS_DIR_INGRESS:
 		dest_port_chip = &chip->ingress_dest_port;
-		reg &= MV88E6185_G1_MONITOR_CTL_INGRESS_DEST_MASK;
+		reg &= ~MV88E6185_G1_MONITOR_CTL_INGRESS_DEST_MASK;
 		reg |= port <<
 		       __bf_shf(MV88E6185_G1_MONITOR_CTL_INGRESS_DEST_MASK);
 		break;
 	case MV88E6XXX_EGRESS_DIR_EGRESS:
 		dest_port_chip = &chip->egress_dest_port;
-		reg &= MV88E6185_G1_MONITOR_CTL_EGRESS_DEST_MASK;
+		reg &= ~MV88E6185_G1_MONITOR_CTL_EGRESS_DEST_MASK;
 		reg |= port <<
 		       __bf_shf(MV88E6185_G1_MONITOR_CTL_EGRESS_DEST_MASK);
 		break;
-- 
2.25.0

