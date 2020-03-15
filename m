Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4992F185B89
	for <lists+netdev@lfdr.de>; Sun, 15 Mar 2020 10:35:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728183AbgCOJfQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Mar 2020 05:35:16 -0400
Received: from mx2.suse.de ([195.135.220.15]:57090 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728128AbgCOJfJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 15 Mar 2020 05:35:09 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 83EFFAC24;
        Sun, 15 Mar 2020 09:35:07 +0000 (UTC)
From:   Takashi Iwai <tiwai@suse.de>
To:     netdev@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, oss-drivers@netronome.com
Subject: [PATCH v2 4/6] net: ionic: Use scnprintf() for avoiding potential buffer overflow
Date:   Sun, 15 Mar 2020 10:35:01 +0100
Message-Id: <20200315093503.8558-5-tiwai@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20200315093503.8558-1-tiwai@suse.de>
References: <20200315093503.8558-1-tiwai@suse.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since snprintf() returns the would-be-output size instead of the
actual output size, the succeeding calls may go beyond the given
buffer limit.  Fix it by replacing with scnprintf().

Reviewed-by: Simon Horman <simon.horman@netronome.com>
Acked-by: Shannon Nelson <snelson@pensando.io>
Cc: "David S . Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: oss-drivers@netronome.com
Cc: netdev@vger.kernel.org
Signed-off-by: Takashi Iwai <tiwai@suse.de>
---
v1->v2: Align the remaining lines to the open parenthesis

 drivers/net/ethernet/pensando/ionic/ionic_lif.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index b903016193df..fc951ae0f5a6 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -949,18 +949,18 @@ static void ionic_lif_rx_mode(struct ionic_lif *lif, unsigned int rx_mode)
 	int i;
 #define REMAIN(__x) (sizeof(buf) - (__x))
 
-	i = snprintf(buf, sizeof(buf), "rx_mode 0x%04x -> 0x%04x:",
-		     lif->rx_mode, rx_mode);
+	i = scnprintf(buf, sizeof(buf), "rx_mode 0x%04x -> 0x%04x:",
+		      lif->rx_mode, rx_mode);
 	if (rx_mode & IONIC_RX_MODE_F_UNICAST)
-		i += snprintf(&buf[i], REMAIN(i), " RX_MODE_F_UNICAST");
+		i += scnprintf(&buf[i], REMAIN(i), " RX_MODE_F_UNICAST");
 	if (rx_mode & IONIC_RX_MODE_F_MULTICAST)
-		i += snprintf(&buf[i], REMAIN(i), " RX_MODE_F_MULTICAST");
+		i += scnprintf(&buf[i], REMAIN(i), " RX_MODE_F_MULTICAST");
 	if (rx_mode & IONIC_RX_MODE_F_BROADCAST)
-		i += snprintf(&buf[i], REMAIN(i), " RX_MODE_F_BROADCAST");
+		i += scnprintf(&buf[i], REMAIN(i), " RX_MODE_F_BROADCAST");
 	if (rx_mode & IONIC_RX_MODE_F_PROMISC)
-		i += snprintf(&buf[i], REMAIN(i), " RX_MODE_F_PROMISC");
+		i += scnprintf(&buf[i], REMAIN(i), " RX_MODE_F_PROMISC");
 	if (rx_mode & IONIC_RX_MODE_F_ALLMULTI)
-		i += snprintf(&buf[i], REMAIN(i), " RX_MODE_F_ALLMULTI");
+		i += scnprintf(&buf[i], REMAIN(i), " RX_MODE_F_ALLMULTI");
 	netdev_dbg(lif->netdev, "lif%d %s\n", lif->index, buf);
 
 	err = ionic_adminq_post_wait(lif, &ctx);
-- 
2.16.4

