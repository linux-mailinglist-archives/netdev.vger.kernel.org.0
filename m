Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 731A8479E6E
	for <lists+netdev@lfdr.de>; Sun, 19 Dec 2021 00:56:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235520AbhLRXzQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Dec 2021 18:55:16 -0500
Received: from o1.ptr2625.egauge.net ([167.89.112.53]:25684 "EHLO
        o1.ptr2625.egauge.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234948AbhLRXyY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Dec 2021 18:54:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=egauge.net;
        h=from:subject:in-reply-to:references:mime-version:to:cc:
        content-transfer-encoding:content-type;
        s=sgd; bh=R4RyJtuY/uGuGEQsEpntttzYbyVkfCoSuFhUmGGe0PA=;
        b=W+fYePf+D5IOFEHTHX0AV/isKp/q6bXyBowdk5+HUfRn52DbeN4XI0E+xWboCxCc3PJG
        7iqfg8NVw0r/BlNkOiy6D0/YHfBIDbeONChLYDBW7ctj0Y+V4i7Jzw/d4XgKs1nZKbD2W7
        e8zBJYt5rbDnZwOXmoMKClpdGQDZ38W0liiM6v9aCH7f7IBS4Z64f6KdH8inPByZXKstUU
        1AUwO2POlUisyzT+JNtALhg6+AlEu09mA6RBWoFGExbkzn39sJtEYqNqjMwZAjSf9042t0
        dLfkt7uMtH6oWa3SWODWkZ4zwueoK9SHSnmwHpddyDdHCUSK0gJWAobdYmYRtFPg==
Received: by filterdrecv-656998cfdd-phncc with SMTP id filterdrecv-656998cfdd-phncc-1-61BE74A9-3
        2021-12-18 23:54:17.151024833 +0000 UTC m=+7604818.337271612
Received: from pearl.egauge.net (unknown)
        by geopod-ismtpd-5-1 (SG)
        with ESMTP
        id 5XWLSwaNQpaKO14Zquup1w
        Sat, 18 Dec 2021 23:54:17.006 +0000 (UTC)
Received: by pearl.egauge.net (Postfix, from userid 1000)
        id C1C5E7013D4; Sat, 18 Dec 2021 16:54:15 -0700 (MST)
From:   David Mosberger-Tang <davidm@egauge.net>
Subject: [PATCH 17/23] wilc1000: remove no longer used "vif" argument from
 init_txq_entry()
Date:   Sat, 18 Dec 2021 23:54:17 +0000 (UTC)
Message-Id: <20211218235404.3963475-18-davidm@egauge.net>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211218235404.3963475-1-davidm@egauge.net>
References: <20211218235404.3963475-1-davidm@egauge.net>
MIME-Version: 1.0
X-SG-EID: =?us-ascii?Q?+kMxBqj35EdRUKoy8diX1j4AXmPtd302oan+iXZuF8m2Nw4HRW2irNspffT=2Fkh?=
 =?us-ascii?Q?ET6RJF6+Prbl0h=2FEtF1rRLvAIVGQkkNlpmJF3yJ?=
 =?us-ascii?Q?dnJor5KInhhkxafKGCb5Jd=2F4Fxe6Jl=2F4S74lBnb?=
 =?us-ascii?Q?FPJdPvmB6ZZ5vZ7Ty2vPD8OwtDFsW4Q=2F8cpPqpV?=
 =?us-ascii?Q?YbdkM47tcT4pqMBhxyzsWU33zvt0oMGKGiNEZuG?=
 =?us-ascii?Q?1w+wkDDcQnBqAkufvYPWBXgg80q3xsliprAMeK?=
To:     Ajay Singh <ajay.kathat@microchip.com>
Cc:     Claudiu Beznea <claudiu.beznea@microchip.com>,
        Kalle Valo <kvalo@codeaurora.org>,
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
index f895e4dd2e73f..286bbf9392165 100644
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

