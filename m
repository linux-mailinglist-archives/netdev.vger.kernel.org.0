Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18793F120
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 09:19:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726690AbfD3HSs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Apr 2019 03:18:48 -0400
Received: from first.geanix.com ([116.203.34.67]:43758 "EHLO first.geanix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726650AbfD3HSn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Apr 2019 03:18:43 -0400
Received: from localhost (unknown [193.163.1.7])
        by first.geanix.com (Postfix) with ESMTPSA id 64555308E9F;
        Tue, 30 Apr 2019 07:18:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=geanix.com; s=first;
        t=1556608715; bh=UQLE8VpCv3H1XnniIW5bE3FmCFUWCrjGdch+TKnVucE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=TLa9X32VcVwJhAYMoIvsFZdvpVn4UUIlfZbVrF7sO8x2rq40FcuDrMPDxx0XoDdSP
         S3S5w7NlLEO+NUE4a7fUCAkUw+4iFmfkeP+qNXAuaTOexd5cXD1IUdOcLrxfWVQDiz
         xI5X9qTy2vKdSq7DBGfCunQfiqT+Mcsc42TpLZYVe4VJRMR3TNjm6jlJ1eh1Nf1/Zh
         20lCYVJsCkxuSzbqOmQFr3bEa/ZYqQXDhw36Yw+tNnuQ5PHZwwNLK5cagQyR4SE+R6
         kErnKqS6SSz+2ZjLA4NzbejOXSOj7OENx+D39hsZOY3fLow3JTOqsiVzPskXTAZnRy
         R6NqENBdMz4Xg==
From:   Esben Haabendal <esben@geanix.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Michal Simek <michal.simek@xilinx.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Yang Wei <yang.wei9@zte.com.cn>,
        YueHaibing <yuehaibing@huawei.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 10/12] net: ll_temac: Replace bad usage of msleep() with usleep_range()
Date:   Tue, 30 Apr 2019 09:17:57 +0200
Message-Id: <20190430071759.2481-11-esben@geanix.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190430071759.2481-1-esben@geanix.com>
References: <20190429083422.4356-1-esben@geanix.com>
 <20190430071759.2481-1-esben@geanix.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,UNPARSEABLE_RELAY,URIBL_BLOCKED
        autolearn=disabled version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on b7bf6291adac
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
index 6837565..fec8e4c 100644
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

