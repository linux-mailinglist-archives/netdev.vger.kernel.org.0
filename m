Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFD6946E19E
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 05:44:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232147AbhLIEsH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 23:48:07 -0500
Received: from o1.ptr2625.egauge.net ([167.89.112.53]:11574 "EHLO
        o1.ptr2625.egauge.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230333AbhLIEsE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 23:48:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=egauge.net;
        h=from:subject:in-reply-to:references:mime-version:to:cc:
        content-transfer-encoding:content-type;
        s=sgd; bh=4jU+mibC8yxDcqhHS9INe1ECc6xPDEbLP0oXfY4SoDE=;
        b=p2BtZf9MNWKPHhQkhD5d40Z2Bjnyu48vmYfd+goUKmnVPuB17sZxcYedfB4A867AP7VP
        G51ipKkF0QtawjziP3EEco389WNdeMdV8x3lKJP2WIMtZw/M8Au1sUf6MwnxIJETXL9rrz
        P8QTg5uoKPyP+BXBtp0BC1Nt2wsJjpXFZhiag7BZNklOIGrmb4oFbwcCS0JkfVIA3YRmHJ
        nzdmTEh0S9i/QRcJ2YhGuBlWMuGJtEO59qYcJgXPYFQvZERv86Np6RKWVRlhoR6wr72zhe
        +3QYiNR0pEweqYjRfdiVEK/bzJVUTyamtv2CC9WFMFf1MFj8jw4XCk17cLRlo+FA==
Received: by filterdrecv-75ff7b5ffb-7dt9d with SMTP id filterdrecv-75ff7b5ffb-7dt9d-1-61B189AC-14
        2021-12-09 04:44:28.568802866 +0000 UTC m=+8490232.442480606
Received: from pearl.egauge.net (unknown)
        by geopod-ismtpd-4-0 (SG)
        with ESMTP
        id vmywDYzRR0qPNZGoPANOAw
        Thu, 09 Dec 2021 04:44:28.452 +0000 (UTC)
Received: by pearl.egauge.net (Postfix, from userid 1000)
        id 258F27002CB; Wed,  8 Dec 2021 21:44:28 -0700 (MST)
From:   David Mosberger-Tang <davidm@egauge.net>
Subject: [PATCH 3/4] wilc1000: Rename tx task from "K_TXQ_TASK" to NETDEV-tx
Date:   Thu, 09 Dec 2021 04:44:28 +0000 (UTC)
Message-Id: <20211209044411.3482259-4-davidm@egauge.net>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211209044411.3482259-1-davidm@egauge.net>
References: <20211209044411.3482259-1-davidm@egauge.net>
MIME-Version: 1.0
X-SG-EID: =?us-ascii?Q?+kMxBqj35EdRUKoy8diX1j4AXmPtd302oan+iXZuF8m2Nw4HRW2irNspffT=2Fkh?=
 =?us-ascii?Q?ET6RJF6+Prbl0h=2FEtF1rRLvPTgbt+ZgFQ0kkP0k?=
 =?us-ascii?Q?m9CAA5WLs05wsIeWz9KOel9Qh+wQViyidf1vLTe?=
 =?us-ascii?Q?gz4uABBl6OVnG1aHdivTRQJ33AWxhcj3ZfDrCUt?=
 =?us-ascii?Q?NzvYTojkmUQbGfzTwxHzLaoseFMu6ipd70NOGeO?=
 =?us-ascii?Q?TXoEWmicn6ffHkr9sg6Q6HZfwoOb3W86yOXhCk?=
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

This follows normal Linux conventions and is also more useful because
the netdevice name is part of the task name (e.g., "wlan0-tx" for
network device "wlan0").

Signed-off-by: David Mosberger-Tang <davidm@egauge.net>
---
 drivers/net/wireless/microchip/wilc1000/netdev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/microchip/wilc1000/netdev.c b/drivers/net/wireless/microchip/wilc1000/netdev.c
index fae6b364ce5c..e3b7629b9410 100644
--- a/drivers/net/wireless/microchip/wilc1000/netdev.c
+++ b/drivers/net/wireless/microchip/wilc1000/netdev.c
@@ -468,7 +468,7 @@ static int wlan_initialize_threads(struct net_device *dev)
 	struct wilc *wilc = vif->wilc;
 
 	wilc->txq_thread = kthread_run(wilc_txq_task, (void *)wilc,
-				       "K_TXQ_TASK");
+				       "%s-tx", dev->name);
 	if (IS_ERR(wilc->txq_thread)) {
 		netdev_err(dev, "couldn't create TXQ thread\n");
 		wilc->close = 0;
-- 
2.25.1

