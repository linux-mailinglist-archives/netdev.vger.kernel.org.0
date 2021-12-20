Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E987E47A6C8
	for <lists+netdev@lfdr.de>; Mon, 20 Dec 2021 10:23:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231709AbhLTJXR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Dec 2021 04:23:17 -0500
Received: from mx1.tq-group.com ([93.104.207.81]:58435 "EHLO mx1.tq-group.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231234AbhLTJXO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Dec 2021 04:23:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=tq-group.com; i=@tq-group.com; q=dns/txt; s=key1;
  t=1639992194; x=1671528194;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=x3QrKeifM9r4PzgOTLR5iQlnX3eVXnbOYQ77dU5BH0Y=;
  b=ovVVEbNxRSFE8ov8o6c6dTLd2n/NP+m2zv1PdVWG++m42uesTG656rGa
   307Dcn4QlSSxOHo1b/7PItRHWzeCzcaFxB1YVbfP3cXEn6LJSbuhYKUik
   R3TyMjmKYozS6hKywlY79dJzZMm9POlkOwufcoZOKsPHQavjpgPE60lDu
   Yd+sP604eZJy70rX1CdbjrAjAsMunocLUiwTGWLwQ3IAER8C+AXPzgZ1G
   TqZ5s5f9mcMekwVivLPxIeEHEuE+vVSktmtsTLjFngR03mEyb6vgGrqN1
   ZtKEef3pcmdtRzSltx9GxqIi+/m7CJN0/aUKQbfaQjS3Bk5l7hyvjoqZ8
   g==;
X-IronPort-AV: E=Sophos;i="5.88,220,1635199200"; 
   d="scan'208";a="21148421"
Received: from unknown (HELO tq-pgp-pr1.tq-net.de) ([192.168.6.15])
  by mx1-pgp.tq-group.com with ESMTP; 20 Dec 2021 10:23:11 +0100
Received: from mx1.tq-group.com ([192.168.6.7])
  by tq-pgp-pr1.tq-net.de (PGP Universal service);
  Mon, 20 Dec 2021 10:23:11 +0100
X-PGP-Universal: processed;
        by tq-pgp-pr1.tq-net.de on Mon, 20 Dec 2021 10:23:11 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=tq-group.com; i=@tq-group.com; q=dns/txt; s=key1;
  t=1639992191; x=1671528191;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=x3QrKeifM9r4PzgOTLR5iQlnX3eVXnbOYQ77dU5BH0Y=;
  b=JpNCM5Y4EnGOzJVWzLmZLTtDp5ElE4gh29StPdfyS2FSYzoD2ijziHsi
   ofGWr+NbINs/rsE80XepWSBb+i2PYv9hlfJhqy6kJdpNHtT8cY8v1/xK/
   lQ+ixUE+1JdJFHz9hqsO1R6NxInVOBLNhjqTlgyvel6UIz1v68HymPIvD
   9gWkJGzk8TXT+MgN8WcQadusIP4qhLV0SVO1/7HA9nT5ehepLMnBv2d2h
   opy8hCk7lYc8ZSftaXRT/9t8gEjZDyURgoGJ1DkYdA3SSprhDRLAjO/1Z
   dB1k9Js2hgwczHxHj5xHWerQFnu8nvEK5QaRi/jPf9vZTnlrKg12lVW5P
   A==;
X-IronPort-AV: E=Sophos;i="5.88,220,1635199200"; 
   d="scan'208";a="21148420"
Received: from vtuxmail01.tq-net.de ([10.115.0.20])
  by mx1.tq-group.com with ESMTP; 20 Dec 2021 10:23:11 +0100
Received: from localhost.localdomain (SCHIFFERM-M2.tq-net.de [10.121.201.15])
        by vtuxmail01.tq-net.de (Postfix) with ESMTPA id E3E0B280075;
        Mon, 20 Dec 2021 10:23:10 +0100 (CET)
From:   Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
To:     stable@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-can@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>,
        davem@davemloft.net, kuba@kernel.org,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
Subject: [PATCH 5.15 1/3] Revert "can: m_can: remove support for custom bit timing"
Date:   Mon, 20 Dec 2021 10:22:15 +0100
Message-Id: <ff820b1ae98fe0dd30e60bc14e6dfcc082438fab.1639990483.git.matthias.schiffer@ew.tq-group.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1639990483.git.matthias.schiffer@ew.tq-group.com>
References: <cover.1639990483.git.matthias.schiffer@ew.tq-group.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

commit ea768b2ffec6cc9c3e17c37ef75d0539b8f89ff5 upstream.

The timing limits specified by the Elkhart Lake CPU datasheets do not
match the defaults. Let's reintroduce the support for custom bit timings.

This reverts commit 0ddd83fbebbc5537f9d180d31f659db3564be708.

Link: https://lore.kernel.org/all/00c9e2596b1a548906921a574d4ef7a03c0dace0.1636967198.git.matthias.schiffer@ew.tq-group.com
Signed-off-by: Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/m_can/m_can.c | 24 ++++++++++++++++++------
 drivers/net/can/m_can/m_can.h |  3 +++
 2 files changed, 21 insertions(+), 6 deletions(-)

diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
index e330b4c121bf..c2a8421e7845 100644
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
2.25.1

