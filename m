Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A3C13F49E2
	for <lists+netdev@lfdr.de>; Mon, 23 Aug 2021 13:34:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236603AbhHWLeE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Aug 2021 07:34:04 -0400
Received: from cmccmta1.chinamobile.com ([221.176.66.79]:44190 "EHLO
        cmccmta1.chinamobile.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236520AbhHWLeB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Aug 2021 07:34:01 -0400
Received: from spf.mail.chinamobile.com (unknown[172.16.121.3]) by rmmx-syy-dmz-app01-12001 (RichMail) with SMTP id 2ee16123876fd13-04795; Mon, 23 Aug 2021 19:33:05 +0800 (CST)
X-RM-TRANSID: 2ee16123876fd13-04795
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG: 00000000
Received: from localhost.localdomain (unknown[223.112.105.130])
        by rmsmtp-syy-appsvr02-12002 (RichMail) with SMTP id 2ee261238767421-c70da;
        Mon, 23 Aug 2021 19:33:05 +0800 (CST)
X-RM-TRANSID: 2ee261238767421-c70da
From:   Tang Bin <tangbin@cmss.chinamobile.com>
To:     davem@davemloft.net, wg@grandegger.com, mkl@pengutronix.de,
        kuba@kernel.org, kevinbrace@bracecomputerlab.com,
        romieu@fr.zoreil.com
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Tang Bin <tangbin@cmss.chinamobile.com>
Subject: [PATCH 3/3] can: mscan: mpc5xxx_can: Use of_device_get_match_data to simplify code
Date:   Mon, 23 Aug 2021 19:33:38 +0800
Message-Id: <20210823113338.3568-4-tangbin@cmss.chinamobile.com>
X-Mailer: git-send-email 2.20.1.windows.1
In-Reply-To: <20210823113338.3568-1-tangbin@cmss.chinamobile.com>
References: <20210823113338.3568-1-tangbin@cmss.chinamobile.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Retrieve OF match data, it's better and cleaner to use
'of_device_get_match_data' over 'of_match_device'.

Signed-off-by: Tang Bin <tangbin@cmss.chinamobile.com>
---
 drivers/net/can/mscan/mpc5xxx_can.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/can/mscan/mpc5xxx_can.c b/drivers/net/can/mscan/mpc5xxx_can.c
index e254e04ae..3b7465acd 100644
--- a/drivers/net/can/mscan/mpc5xxx_can.c
+++ b/drivers/net/can/mscan/mpc5xxx_can.c
@@ -279,7 +279,6 @@ static u32 mpc512x_can_get_clock(struct platform_device *ofdev,
 static const struct of_device_id mpc5xxx_can_table[];
 static int mpc5xxx_can_probe(struct platform_device *ofdev)
 {
-	const struct of_device_id *match;
 	const struct mpc5xxx_can_data *data;
 	struct device_node *np = ofdev->dev.of_node;
 	struct net_device *dev;
@@ -289,10 +288,9 @@ static int mpc5xxx_can_probe(struct platform_device *ofdev)
 	int irq, mscan_clksrc = 0;
 	int err = -ENOMEM;
 
-	match = of_match_device(mpc5xxx_can_table, &ofdev->dev);
-	if (!match)
+	data = of_device_get_match_data(&ofdev->dev);
+	if (!data)
 		return -EINVAL;
-	data = match->data;
 
 	base = of_iomap(np, 0);
 	if (!base) {
-- 
2.20.1.windows.1



