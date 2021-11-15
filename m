Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2A98450121
	for <lists+netdev@lfdr.de>; Mon, 15 Nov 2021 10:21:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237360AbhKOJYL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 04:24:11 -0500
Received: from mx1.tq-group.com ([93.104.207.81]:45337 "EHLO mx1.tq-group.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237595AbhKOJXg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Nov 2021 04:23:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=tq-group.com; i=@tq-group.com; q=dns/txt; s=key1;
  t=1636968041; x=1668504041;
  h=from:to:cc:subject:date:message-id;
  bh=aVBt81scfc0Gj2SHHVWURSNtrhvz6bU+CHiaiOknVOc=;
  b=a8NZ/e5qD6S4hRL42mN2hAshZ0iplraWsqfCd9k9TJ+L2JsnbdiNMPEY
   kkXwerra5neqSBa+E82qMCUz6uUapDf0Kc0gn0E6DbB1u9VIRP4LmRtYu
   t/L3SGFhXUEcIpqbvpsmW4UgqaW8eEy8K4cm0lMokLGV9voWuGw5x5Yip
   TX+sQ2rzZ5KsJA7f17j/CqNBYs5qeU1CyvkMEpWBD3vkBED2hR3xdu8ha
   0vVO8PEuHDc0SR5r2aZxkEEyVwDftfsBX3yQVzhl5DDqdIsmoyCWHpgqz
   XSh1hzth+MGMaSGSwhXhENgmgjLw4P2gI0koRLBj3Ve262afYVVlHWYgM
   g==;
X-IronPort-AV: E=Sophos;i="5.87,236,1631570400"; 
   d="scan'208";a="20459394"
Received: from unknown (HELO tq-pgp-pr1.tq-net.de) ([192.168.6.15])
  by mx1-pgp.tq-group.com with ESMTP; 15 Nov 2021 10:20:19 +0100
Received: from mx1.tq-group.com ([192.168.6.7])
  by tq-pgp-pr1.tq-net.de (PGP Universal service);
  Mon, 15 Nov 2021 10:20:19 +0100
X-PGP-Universal: processed;
        by tq-pgp-pr1.tq-net.de on Mon, 15 Nov 2021 10:20:19 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=tq-group.com; i=@tq-group.com; q=dns/txt; s=key1;
  t=1636968019; x=1668504019;
  h=from:to:cc:subject:date:message-id;
  bh=aVBt81scfc0Gj2SHHVWURSNtrhvz6bU+CHiaiOknVOc=;
  b=lam6DKpdbl6nDRvIA6S3QCvsg1QoYGTNPAIC0lII0XEgtw20hWFxAvwS
   tGo3Q7bFHd0Qm+YnMjwaWwJfxiMP8x0vV/r+F6BwIC4mFCIxwzG4nd1iG
   nk4BzOp+HV5ElOyGu0PYG6z3RmUNy389E5UkumdI7gMOvEqzKGl8BZTCt
   8PSgrMHmAKlLnLDYOxEoKJN9QTbDjI+/HgOH33yv+ZH6kWFGo2WRSYoT/
   2aRQZ2emQMV/kEl7l5s/E6jKcAQxEeQZLw6OBEcl+9bWIzuTtMm5ZVLsx
   /iut11R/aNL5aCKC7HnqTzrFPMGY311pTVilMtt26+wqypVBQvAw+stmE
   Q==;
X-IronPort-AV: E=Sophos;i="5.87,236,1631570400"; 
   d="scan'208";a="20459393"
Received: from vtuxmail01.tq-net.de ([10.115.0.20])
  by mx1.tq-group.com with ESMTP; 15 Nov 2021 10:20:19 +0100
Received: from schifferm-ubuntu4.tq-net.de (schifferm-ubuntu4.tq-net.de [10.121.48.12])
        by vtuxmail01.tq-net.de (Postfix) with ESMTPA id 29D1E280078;
        Mon, 15 Nov 2021 10:20:19 +0100 (CET)
From:   Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
To:     Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Felipe Balbi (Intel)" <balbi@kernel.org>,
        Jarkko Nikula <jarkko.nikula@linux.intel.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
Subject: [PATCH net 2/4] Revert "can: m_can: remove support for custom bit timing"
Date:   Mon, 15 Nov 2021 10:18:50 +0100
Message-Id: <00c9e2596b1a548906921a574d4ef7a03c0dace0.1636967198.git.matthias.schiffer@ew.tq-group.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1636967198.git.matthias.schiffer@ew.tq-group.com>
References: <cover.1636967198.git.matthias.schiffer@ew.tq-group.com>
In-Reply-To: <cover.1636967198.git.matthias.schiffer@ew.tq-group.com>
References: <cover.1636967198.git.matthias.schiffer@ew.tq-group.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The timing limits specified by the Elkhart Lake CPU datasheets do not
match the defaults. Let's reintroduce the support for custom bit timings.

This reverts commit 0ddd83fbebbc5537f9d180d31f659db3564be708.

Signed-off-by: Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
---
 drivers/net/can/m_can/m_can.c | 24 ++++++++++++++++++------
 drivers/net/can/m_can/m_can.h |  3 +++
 2 files changed, 21 insertions(+), 6 deletions(-)

diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
index 2470c47b2e31..529f754faae6 100644
--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -1494,20 +1494,32 @@ static int m_can_dev_setup(struct m_can_classdev *cdev)
 	case 30:
 		/* CAN_CTRLMODE_FD_NON_ISO is fixed with M_CAN IP v3.0.x */
 		can_set_static_ctrlmode(dev, CAN_CTRLMODE_FD_NON_ISO);
-		cdev->can.bittiming_const = &m_can_bittiming_const_30X;
-		cdev->can.data_bittiming_const = &m_can_data_bittiming_const_30X;
+		cdev->can.bittiming_const = cdev->bit_timing ?
+			cdev->bit_timing : &m_can_bittiming_const_30X;
+
+		cdev->can.data_bittiming_const = cdev->data_timing ?
+			cdev->data_timing :
+			&m_can_data_bittiming_const_30X;
 		break;
 	case 31:
 		/* CAN_CTRLMODE_FD_NON_ISO is fixed with M_CAN IP v3.1.x */
 		can_set_static_ctrlmode(dev, CAN_CTRLMODE_FD_NON_ISO);
-		cdev->can.bittiming_const = &m_can_bittiming_const_31X;
-		cdev->can.data_bittiming_const = &m_can_data_bittiming_const_31X;
+		cdev->can.bittiming_const = cdev->bit_timing ?
+			cdev->bit_timing : &m_can_bittiming_const_31X;
+
+		cdev->can.data_bittiming_const = cdev->data_timing ?
+			cdev->data_timing :
+			&m_can_data_bittiming_const_31X;
 		break;
 	case 32:
 	case 33:
 		/* Support both MCAN version v3.2.x and v3.3.0 */
-		cdev->can.bittiming_const = &m_can_bittiming_const_31X;
-		cdev->can.data_bittiming_const = &m_can_data_bittiming_const_31X;
+		cdev->can.bittiming_const = cdev->bit_timing ?
+			cdev->bit_timing : &m_can_bittiming_const_31X;
+
+		cdev->can.data_bittiming_const = cdev->data_timing ?
+			cdev->data_timing :
+			&m_can_data_bittiming_const_31X;
 
 		cdev->can.ctrlmode_supported |=
 			(m_can_niso_supported(cdev) ?
diff --git a/drivers/net/can/m_can/m_can.h b/drivers/net/can/m_can/m_can.h
index d18b515e6ccc..ad063b101411 100644
--- a/drivers/net/can/m_can/m_can.h
+++ b/drivers/net/can/m_can/m_can.h
@@ -85,6 +85,9 @@ struct m_can_classdev {
 	struct sk_buff *tx_skb;
 	struct phy *transceiver;
 
+	struct can_bittiming_const *bit_timing;
+	struct can_bittiming_const *data_timing;
+
 	struct m_can_ops *ops;
 
 	int version;
-- 
2.17.1

