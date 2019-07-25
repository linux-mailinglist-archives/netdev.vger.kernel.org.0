Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F133275128
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 16:30:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387881AbfGYOaS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jul 2019 10:30:18 -0400
Received: from relay11.mail.gandi.net ([217.70.178.231]:56403 "EHLO
        relay11.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725867AbfGYOaQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jul 2019 10:30:16 -0400
Received: from localhost (lfbn-1-17395-211.w86-250.abo.wanadoo.fr [86.250.200.211])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay11.mail.gandi.net (Postfix) with ESMTPSA id A1ADD100007;
        Thu, 25 Jul 2019 14:30:13 +0000 (UTC)
From:   Antoine Tenart <antoine.tenart@bootlin.com>
To:     davem@davemloft.net, richardcochran@gmail.com,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com
Cc:     Antoine Tenart <antoine.tenart@bootlin.com>,
        netdev@vger.kernel.org, thomas.petazzoni@bootlin.com,
        allan.nielsen@microchip.com
Subject: [PATCH net-next v4 5/6] net: mscc: remove the frame_info cpuq member
Date:   Thu, 25 Jul 2019 16:27:06 +0200
Message-Id: <20190725142707.9313-6-antoine.tenart@bootlin.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190725142707.9313-1-antoine.tenart@bootlin.com>
References: <20190725142707.9313-1-antoine.tenart@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In struct frame_info, the cpuq member is never used. This cosmetic patch
removes it from the structure, and from the parsing of the frame header
as it's only set but never used.

Signed-off-by: Antoine Tenart <antoine.tenart@bootlin.com>
---
 drivers/net/ethernet/mscc/ocelot.h       | 1 -
 drivers/net/ethernet/mscc/ocelot_board.c | 1 -
 2 files changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.h b/drivers/net/ethernet/mscc/ocelot.h
index e0da8b4eddf2..515dee6fa8a6 100644
--- a/drivers/net/ethernet/mscc/ocelot.h
+++ b/drivers/net/ethernet/mscc/ocelot.h
@@ -45,7 +45,6 @@ struct frame_info {
 	u32 len;
 	u16 port;
 	u16 vid;
-	u8 cpuq;
 	u8 tag_type;
 };
 
diff --git a/drivers/net/ethernet/mscc/ocelot_board.c b/drivers/net/ethernet/mscc/ocelot_board.c
index 5e4f1718dd99..df8d15994a89 100644
--- a/drivers/net/ethernet/mscc/ocelot_board.c
+++ b/drivers/net/ethernet/mscc/ocelot_board.c
@@ -33,7 +33,6 @@ static int ocelot_parse_ifh(u32 *_ifh, struct frame_info *info)
 
 	info->port = IFH_EXTRACT_BITFIELD64(ifh[1], 43, 4);
 
-	info->cpuq = IFH_EXTRACT_BITFIELD64(ifh[1], 20, 8);
 	info->tag_type = IFH_EXTRACT_BITFIELD64(ifh[1], 16,  1);
 	info->vid = IFH_EXTRACT_BITFIELD64(ifh[1], 0,  12);
 
-- 
2.21.0

