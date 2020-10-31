Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF0682A1240
	for <lists+netdev@lfdr.de>; Sat, 31 Oct 2020 01:58:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726108AbgJaA6u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 20:58:50 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:55894 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725536AbgJaA6s (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Oct 2020 20:58:48 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kYfEE-004Rqh-Uk; Sat, 31 Oct 2020 01:58:46 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next 1/2] drivers: net: davicom: Fixed unused but set variable with W=1
Date:   Sat, 31 Oct 2020 01:58:32 +0100
Message-Id: <20201031005833.1060316-2-andrew@lunn.ch>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201031005833.1060316-1-andrew@lunn.ch>
References: <20201031005833.1060316-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

drivers/net/ethernet/davicom//dm9000.c: In function ‘dm9000_dumpblk_8bit’:
drivers/net/ethernet/davicom//dm9000.c:235:6: warning: variable ‘tmp’ set but not used [-Wunused-but-set-variable]

The driver needs to read packet data from the device even when the
packet is known bad. There is no need to assign the data to a variable
during this discard operation.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/ethernet/davicom/dm9000.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/davicom/dm9000.c b/drivers/net/ethernet/davicom/dm9000.c
index 5c6c8c5ec747..3fdc70dab5c1 100644
--- a/drivers/net/ethernet/davicom/dm9000.c
+++ b/drivers/net/ethernet/davicom/dm9000.c
@@ -232,32 +232,29 @@ static void dm9000_inblk_32bit(void __iomem *reg, void *data, int count)
 static void dm9000_dumpblk_8bit(void __iomem *reg, int count)
 {
 	int i;
-	int tmp;
 
 	for (i = 0; i < count; i++)
-		tmp = readb(reg);
+		readb(reg);
 }
 
 static void dm9000_dumpblk_16bit(void __iomem *reg, int count)
 {
 	int i;
-	int tmp;
 
 	count = (count + 1) >> 1;
 
 	for (i = 0; i < count; i++)
-		tmp = readw(reg);
+		readw(reg);
 }
 
 static void dm9000_dumpblk_32bit(void __iomem *reg, int count)
 {
 	int i;
-	int tmp;
 
 	count = (count + 3) >> 2;
 
 	for (i = 0; i < count; i++)
-		tmp = readl(reg);
+		readl(reg);
 }
 
 /*
-- 
2.28.0

