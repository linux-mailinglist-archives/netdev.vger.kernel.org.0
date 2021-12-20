Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77AB147A6D0
	for <lists+netdev@lfdr.de>; Mon, 20 Dec 2021 10:23:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231631AbhLTJXQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Dec 2021 04:23:16 -0500
Received: from mx1.tq-group.com ([93.104.207.81]:58440 "EHLO mx1.tq-group.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231521AbhLTJXO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Dec 2021 04:23:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=tq-group.com; i=@tq-group.com; q=dns/txt; s=key1;
  t=1639992194; x=1671528194;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=EsOt02UEvIY21ObFuARK2CExDgJwbTEvA7Gdrn8Cz+E=;
  b=Hdd98HTM1HNua/PQncdXVdZlGtYJpCmzPx5Z9ml4b2neHlF+31e+h/rQ
   ctA0ERfRHXLMsfZpRTGWHf2/uuNoXPYNn64lmcuDE4aJx0iMQ67Bf+vtY
   PxvvzKIFKDRbUrS9OWFaSvsHmZ+5P5sNwDngKMD8Z5HpYuVdbE8HtnDCV
   Uqi7rdBRcPD/SzaHPFvYSwIfHMDqfvvwmFsYLpLv+2w1wYIXYvjP+TMPJ
   uCkKqGdIaD7Ie1pzvMd5H2vd3B/rt15Xg+0g4llvJncNlKojFaZN2FHrk
   Icm+T4MsaadrMLMD6nNzLcwPrDPM437jRK/HMoZ9R9DVahm+/qnnsMAEM
   Q==;
X-IronPort-AV: E=Sophos;i="5.88,220,1635199200"; 
   d="scan'208";a="21148423"
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
  bh=EsOt02UEvIY21ObFuARK2CExDgJwbTEvA7Gdrn8Cz+E=;
  b=K8nonIMWkuIKmsOIPx3ZzJdLW65d2M/PkpfYvtfd8q1fvizTFrLvQC4G
   JFcrdx/hczHNE9DJK+c7/OVvRSo85i4hINHqSrALjuBDRTDMyCbECoyX1
   7DM0acvTlnax/HLJ9PWGRn19PWyPUbwjsbRp6G49QJsQSIf42I+xw8xva
   vOQcXgTZ+/Q4STyFrRy2nWS2B0yFUergYe/tAeimAMeEg8hYjimIUmjr4
   jDpUbpDJu4MpyFW8FgvbTqneULyzgoG6GmkiazllrIZT0Af18qK7gOlCU
   lmkEiLT6vCAandQZ93SibfPRitT9dox3v3Pkp0fi1kvqwNJLS8JFLuD6U
   A==;
X-IronPort-AV: E=Sophos;i="5.88,220,1635199200"; 
   d="scan'208";a="21148422"
Received: from vtuxmail01.tq-net.de ([10.115.0.20])
  by mx1.tq-group.com with ESMTP; 20 Dec 2021 10:23:11 +0100
Received: from localhost.localdomain (SCHIFFERM-M2.tq-net.de [10.121.201.15])
        by vtuxmail01.tq-net.de (Postfix) with ESMTPA id 1951C280065;
        Mon, 20 Dec 2021 10:23:11 +0100 (CET)
From:   Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
To:     stable@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-can@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>,
        davem@davemloft.net, kuba@kernel.org,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
Subject: [PATCH 5.15 2/3] can: m_can: make custom bittiming fields const
Date:   Mon, 20 Dec 2021 10:22:16 +0100
Message-Id: <a5f7f14b1122056399484f2a8e16bd4d7de6e15e.1639990483.git.matthias.schiffer@ew.tq-group.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1639990483.git.matthias.schiffer@ew.tq-group.com>
References: <cover.1639990483.git.matthias.schiffer@ew.tq-group.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

commit ea22ba40debee29ee7257c42002409899e9311c1 upstream.

The assigned timing structs will be defined a const anyway, so we can
avoid a few casts by declaring the struct fields as const as well.

Link: https://lore.kernel.org/all/4508fa4e639164b2584c49a065d90c78a91fa568.1636967198.git.matthias.schiffer@ew.tq-group.com
Signed-off-by: Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/m_can/m_can.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/can/m_can/m_can.h b/drivers/net/can/m_can/m_can.h
index ad063b101411..2c5d40997168 100644
--- a/drivers/net/can/m_can/m_can.h
+++ b/drivers/net/can/m_can/m_can.h
@@ -85,8 +85,8 @@ struct m_can_classdev {
 	struct sk_buff *tx_skb;
 	struct phy *transceiver;
 
-	struct can_bittiming_const *bit_timing;
-	struct can_bittiming_const *data_timing;
+	const struct can_bittiming_const *bit_timing;
+	const struct can_bittiming_const *data_timing;
 
 	struct m_can_ops *ops;
 
-- 
2.25.1

