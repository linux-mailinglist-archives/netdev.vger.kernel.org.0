Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 356342940D0
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 18:50:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388907AbgJTQuj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 12:50:39 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53011 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726492AbgJTQuj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Oct 2020 12:50:39 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1kUuqE-000611-CC; Tue, 20 Oct 2020 16:50:30 +0000
From:   Colin King <colin.king@canonical.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net: dsa: bcm_sf2: make const array static, makes object smaller
Date:   Tue, 20 Oct 2020 17:50:29 +0100
Message-Id: <20201020165029.56383-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Don't populate the const array rate_table on the stack but instead it
static. Makes the object code smaller by 46 bytes.

Before:
   text	   data	    bss	    dec	    hex	filename
  29812	   3824	    192	  33828	   8424	drivers/net/dsa/bcm_sf2.o

After:
   text	   data	    bss	    dec	    hex	filename
  29670	   3920	    192	  33782	   83f6	drivers/net/dsa/bcm_sf2.o

(gcc version 10.2.0)

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/dsa/bcm_sf2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/bcm_sf2.c b/drivers/net/dsa/bcm_sf2.c
index 0b5b2b33b3b6..1e9a0adda2d6 100644
--- a/drivers/net/dsa/bcm_sf2.c
+++ b/drivers/net/dsa/bcm_sf2.c
@@ -54,7 +54,7 @@ static void bcm_sf2_recalc_clock(struct dsa_switch *ds)
 	unsigned long new_rate;
 	unsigned int ports_active;
 	/* Frequenty in Mhz */
-	const unsigned long rate_table[] = {
+	static const unsigned long rate_table[] = {
 		59220000,
 		60820000,
 		62500000,
-- 
2.27.0

