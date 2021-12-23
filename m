Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4CDE47DD43
	for <lists+netdev@lfdr.de>; Thu, 23 Dec 2021 02:18:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346151AbhLWBQp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Dec 2021 20:16:45 -0500
Received: from o1.ptr2625.egauge.net ([167.89.112.53]:18404 "EHLO
        o1.ptr2625.egauge.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345781AbhLWBOT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Dec 2021 20:14:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=egauge.net;
        h=from:subject:in-reply-to:references:mime-version:to:cc:
        content-transfer-encoding:content-type;
        s=sgd; bh=eTCBwwd712xb7qk5FJKt9s2SPN4iZ3evhxEvhrmqVG0=;
        b=qFAobek2GlJ0Bkyz99qu4u/sbAGwfA94iQP2eQnx6F0l3ZQqMGl3V9ATyVBFo5tka1ys
        VDLmw83n7hy/5Lcij+pLHuzMeMVrRa9bEMmsIgMz80r/r5NOAyfO9T7AXoruljLkCQEioR
        sJ7zyntVMAYNMTtus9Vil6m9tF7Ke9sEHpFmRm66WRyGArWbXZP+9OCn1P9kMTifTBhSX/
        06ScxdAJPbPv5adpoAxV6AzGPSj/eTH1Rsuij9VLmJsdgZB7sBUp7UdoC9Yqf8X8k0z1aK
        ePO/7TH5YcNLE/q/Zl+/h8mhvNEYUu8dH0CUJgiLYALRYVFWlh/BtYsO1CHcVOuw==
Received: by filterdrecv-64fcb979b9-tjknx with SMTP id filterdrecv-64fcb979b9-tjknx-1-61C3CD5E-1D
        2021-12-23 01:14:06.570345309 +0000 UTC m=+8644589.373863885
Received: from pearl.egauge.net (unknown)
        by geopod-ismtpd-4-0 (SG)
        with ESMTP
        id Ix1XkgGqSFi8py498O2p_g
        Thu, 23 Dec 2021 01:14:06.429 +0000 (UTC)
Received: by pearl.egauge.net (Postfix, from userid 1000)
        id 2F9327012D2; Wed, 22 Dec 2021 18:14:05 -0700 (MST)
From:   David Mosberger-Tang <davidm@egauge.net>
Subject: [PATCH v2 17/50] wilc1000: remove no longer used "vif" argument from
 init_txq_entry()
Date:   Thu, 23 Dec 2021 01:14:06 +0000 (UTC)
Message-Id: <20211223011358.4031459-18-davidm@egauge.net>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211223011358.4031459-1-davidm@egauge.net>
References: <20211223011358.4031459-1-davidm@egauge.net>
MIME-Version: 1.0
X-SG-EID: =?us-ascii?Q?+kMxBqj35EdRUKoy8diX1j4AXmPtd302oan+iXZuF8m2Nw4HRW2irNspffT=2Fkh?=
 =?us-ascii?Q?ET6RJF6+Prbl0h=2FEtF1rRLvF57zItUWDc68Njwz?=
 =?us-ascii?Q?om2zBXkmJEYQhgSnJ3Qik1UqW8tfJqfcvcHJvYK?=
 =?us-ascii?Q?bKbeuYAkOQbStMz=2Fkx2DZvHrec6MDTRxN=2FCHm6e?=
 =?us-ascii?Q?NEIb=2F9SLNo81zV5Q5f9QmK5PiJ6mQTGCUX14yOk?=
 =?us-ascii?Q?on0Ti+98Xhl81CpNdsAoRicUuxHmNJXj+iP62O?=
To:     Ajay Singh <ajay.kathat@microchip.com>
Cc:     Claudiu Beznea <claudiu.beznea@microchip.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        David Mosberger-Tang <davidm@egauge.net>
X-Entity-ID: Xg4JGAcGrJFIz2kDG9eoaQ==
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=us-ascii
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With the tx-path switched to sk_buffs, there is no longer any need for
the "vif" argument in init_txq_entry().

Signed-off-by: David Mosberger-Tang <davidm@egauge.net>
---
 drivers/net/wireless/microchip/wilc1000/wlan.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/microchip/wilc1000/wlan.c b/drivers/net/wireless/microchip/wilc1000/wlan.c
index a970ddf43edf0..8bff1d8050b11 100644
--- a/drivers/net/wireless/microchip/wilc1000/wlan.c
+++ b/drivers/net/wireless/microchip/wilc1000/wlan.c
@@ -37,7 +37,7 @@ static inline void release_bus(struct wilc *wilc, enum bus_release release)
 	mutex_unlock(&wilc->hif_cs);
 }
 
-static void init_txq_entry(struct sk_buff *tqe, struct wilc_vif *vif,
+static void init_txq_entry(struct sk_buff *tqe,
 			   u8 type, enum ip_pkt_priority q_num)
 {
 	struct wilc_skb_tx_cb *tx_cb = WILC_SKB_TX_CB(tqe);
@@ -53,7 +53,7 @@ static void wilc_wlan_txq_add_to_tail(struct net_device *dev, u8 type, u8 q_num,
 	struct wilc_vif *vif = netdev_priv(dev);
 	struct wilc *wilc = vif->wilc;
 
-	init_txq_entry(tqe, vif, type, q_num);
+	init_txq_entry(tqe, type, q_num);
 	if (type == WILC_NET_PKT && vif->ack_filter.enabled)
 		tcp_process(dev, tqe);
 
@@ -68,7 +68,7 @@ static void wilc_wlan_txq_add_to_head(struct wilc_vif *vif, u8 type, u8 q_num,
 {
 	struct wilc *wilc = vif->wilc;
 
-	init_txq_entry(tqe, vif, type, q_num);
+	init_txq_entry(tqe, type, q_num);
 
 	mutex_lock(&wilc->txq_add_to_head_cs);
 
-- 
2.25.1

