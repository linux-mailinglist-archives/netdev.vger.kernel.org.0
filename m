Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D4B4DDE0
	for <lists+netdev@lfdr.de>; Mon, 29 Apr 2019 10:35:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727868AbfD2IfK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 04:35:10 -0400
Received: from first.geanix.com ([116.203.34.67]:50018 "EHLO first.geanix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727840AbfD2IfH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Apr 2019 04:35:07 -0400
Received: from localhost (unknown [193.163.1.7])
        by first.geanix.com (Postfix) with ESMTPSA id 2FAF3308E90;
        Mon, 29 Apr 2019 08:33:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=geanix.com; s=first;
        t=1556526823; bh=PytYnicUuc/O21kzrcWf0rld8thVs5rVdqWWcoh3Fn8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=CqHry/b5qTCDY3gHoL263FGq8g8IblP0SKhPGnySfg0CAYjSObhmjgT9KKK8UTijH
         2a42gtrobIjpEuTk9fi8C49vmotO2YfCD9Jehu9mrnBUyZ6bQ5Y941RfxU2AYEyFEZ
         7NnWWZXpQLS9nxo+0D1o4hcapWftAy14G/awyMDVg5Fs8Wf1BtVfiblBcI0RnX/V0f
         bhhi0PBgiAidJMEZ66sRyowlyta0D2CCq+RUtIOdKTTGH9/BmHp4iyk49Mdxc86hEo
         ZW/s47jL520QZb6sDUMdL/GynNAY93/1DPeOB2Xs/jC0lvHSYUpbJYKTfLYPLAJJBr
         sc20D55njQ6HA==
From:   Esben Haabendal <esben@geanix.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Michal Simek <michal.simek@xilinx.com>,
        YueHaibing <yuehaibing@huawei.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Yang Wei <yang.wei9@zte.com.cn>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 10/12] net: ll_temac: Replace bad usage of msleep() with usleep_range()
Date:   Mon, 29 Apr 2019 10:34:20 +0200
Message-Id: <20190429083422.4356-11-esben@geanix.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190429083422.4356-1-esben@geanix.com>
References: <20190426073231.4008-1-esben@geanix.com>
 <20190429083422.4356-1-esben@geanix.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,UNPARSEABLE_RELAY,URIBL_BLOCKED
        autolearn=disabled version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on 3e0c63300934
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use usleep_range() to avoid problems with msleep() actually sleeping
much longer than expected.

Signed-off-by: Esben Haabendal <esben@geanix.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/ethernet/xilinx/ll_temac_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/xilinx/ll_temac_main.c b/drivers/net/ethernet/xilinx/ll_temac_main.c
index 2d50646..5e7b8f0 100644
--- a/drivers/net/ethernet/xilinx/ll_temac_main.c
+++ b/drivers/net/ethernet/xilinx/ll_temac_main.c
@@ -92,7 +92,7 @@ int temac_indirect_busywait(struct temac_local *lp)
 			WARN_ON(1);
 			return -ETIMEDOUT;
 		}
-		msleep(1);
+		usleep_range(500, 1000);
 	}
 	return 0;
 }
-- 
2.4.11

