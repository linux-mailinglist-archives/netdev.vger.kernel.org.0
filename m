Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1EAE760BFB
	for <lists+netdev@lfdr.de>; Fri,  5 Jul 2019 21:55:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727903AbfGETzh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jul 2019 15:55:37 -0400
Received: from relay9-d.mail.gandi.net ([217.70.183.199]:59985 "EHLO
        relay9-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727179AbfGETzh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Jul 2019 15:55:37 -0400
X-Originating-IP: 90.76.143.236
Received: from localhost (lfbn-1-2078-236.w90-76.abo.wanadoo.fr [90.76.143.236])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay9-d.mail.gandi.net (Postfix) with ESMTPSA id BF8FDFF803;
        Fri,  5 Jul 2019 19:55:34 +0000 (UTC)
From:   Antoine Tenart <antoine.tenart@bootlin.com>
To:     davem@davemloft.net, richardcochran@gmail.com,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
        ralf@linux-mips.org, paul.burton@mips.com, jhogan@kernel.org
Cc:     Antoine Tenart <antoine.tenart@bootlin.com>,
        netdev@vger.kernel.org, linux-mips@vger.kernel.org,
        thomas.petazzoni@bootlin.com, allan.nielsen@microchip.com
Subject: [PATCH net-next v2 7/8] net: mscc: remove the frame_info cpuq member
Date:   Fri,  5 Jul 2019 21:52:12 +0200
Message-Id: <20190705195213.22041-8-antoine.tenart@bootlin.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190705195213.22041-1-antoine.tenart@bootlin.com>
References: <20190705195213.22041-1-antoine.tenart@bootlin.com>
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
index 09ad6a123347..008a762512b9 100644
--- a/drivers/net/ethernet/mscc/ocelot_board.c
+++ b/drivers/net/ethernet/mscc/ocelot_board.c
@@ -33,7 +33,6 @@ static int ocelot_parse_ifh(u32 *_ifh, struct frame_info *info)
 
 	info->port = IFH_EXTRACT_BITFIELD64(ifh[1], 43, 4);
 
-	info->cpuq = IFH_EXTRACT_BITFIELD64(ifh[1], 20, 8);
 	info->tag_type = IFH_EXTRACT_BITFIELD64(ifh[1], 16,  1);
 	info->vid = IFH_EXTRACT_BITFIELD64(ifh[1], 0,  12);
 
-- 
2.21.0

