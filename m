Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B145D45011C
	for <lists+netdev@lfdr.de>; Mon, 15 Nov 2021 10:21:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237129AbhKOJYG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 04:24:06 -0500
Received: from mx1.tq-group.com ([93.104.207.81]:12298 "EHLO mx1.tq-group.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230302AbhKOJX6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Nov 2021 04:23:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=tq-group.com; i=@tq-group.com; q=dns/txt; s=key1;
  t=1636968063; x=1668504063;
  h=from:to:cc:subject:date:message-id;
  bh=R7JejJ5VAsSxtFi0cVkHZzS9RvuBmx6TwR8T9DEr7IQ=;
  b=eTq/A/vSJYkYNTOVOSco2tCrGpK3Xlb9l8+p5Jg6k6eugSFou9L+Ytpt
   9wtlPDFdQiIE4Nuz6dUn5JZJF75CiasoEp23OfgN6gesY86YsaNtHXg1j
   f9hY+jT2D7unmcTEDcMf9UK3taacKjF5PE5h+9trWshB1DoTicPRTG6TU
   za8UCfwYvbi5JnAUkpuUAdzpQ/dH/q/iIhmz5Kdb23JOkRpXwGg7RKdbg
   9zKuskN4LZ6YYSlT26aSmPWO+L3L1OdqszwMovDMU/MgUMxeoP2iZQY2T
   JeByLjVhrQ9hgmSQhxsCJCs52f4cRv6pTyy99cS68GMHRnVz68Mb3IkRO
   g==;
X-IronPort-AV: E=Sophos;i="5.87,236,1631570400"; 
   d="scan'208";a="20459396"
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
  bh=R7JejJ5VAsSxtFi0cVkHZzS9RvuBmx6TwR8T9DEr7IQ=;
  b=Mk7ZMzkATH+7DeIgEUGGMeNddfenbH4W9D+Ya1MrynX4oujAUkMP041T
   ivmBSvwoz7KKbANPX4gKaXwT3YVDEF31WZNfyAVNyRCsMX+GjFxHuXHGd
   uNx/6r6o7V3fkjBnlCcgx7fYBAy3v/k6GsV8a+4Z+NfeJkyKpSF24u6wW
   kgoeQSPPyyiFWzA/5QHhlQUcS7BqYwOL1HRQQvVbAYqg7weTxiTyMwUda
   gy/JriNEdjoZjG9FU62BjK/ZbkG1V5EgDE2kC6hYiuL5qiXY0p09LA6ec
   JfDi8UBmhYkmnN8N2n6sPJ01x1ghS8nlETHv+KFbiwkL7DnRMISQ+LDVl
   Q==;
X-IronPort-AV: E=Sophos;i="5.87,236,1631570400"; 
   d="scan'208";a="20459395"
Received: from vtuxmail01.tq-net.de ([10.115.0.20])
  by mx1.tq-group.com with ESMTP; 15 Nov 2021 10:20:19 +0100
Received: from schifferm-ubuntu4.tq-net.de (schifferm-ubuntu4.tq-net.de [10.121.48.12])
        by vtuxmail01.tq-net.de (Postfix) with ESMTPA id 5615228007C;
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
Subject: [PATCH net 3/4] can: m_can: make custom bittiming fields const
Date:   Mon, 15 Nov 2021 10:18:51 +0100
Message-Id: <4508fa4e639164b2584c49a065d90c78a91fa568.1636967198.git.matthias.schiffer@ew.tq-group.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1636967198.git.matthias.schiffer@ew.tq-group.com>
References: <cover.1636967198.git.matthias.schiffer@ew.tq-group.com>
In-Reply-To: <cover.1636967198.git.matthias.schiffer@ew.tq-group.com>
References: <cover.1636967198.git.matthias.schiffer@ew.tq-group.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The assigned timing structs will be defined a const anyway, so we can
avoid a few casts by declaring the struct fields as const as well.

Signed-off-by: Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
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
2.17.1

