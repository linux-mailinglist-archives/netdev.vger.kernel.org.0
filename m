Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69BF5210BCB
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 15:09:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730852AbgGANJR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 09:09:17 -0400
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:32587 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730656AbgGANJN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jul 2020 09:09:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1593608953; x=1625144953;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=yZXM5jwTj3IjGvPe3sjNrDrjgeA8OBDnvK5TxI3UrD8=;
  b=stGgyoux4j3sBmVxvDfVUhowway3+uP5OVCqY0KZyCg0nfXSW7+N+I+J
   7yboMbh+tFz7kGAPrhKc7BHVlREMhA/ak+v34415TOCDx1+85DW9tHxoY
   vZveqZ9D5rHx0KM4c0a9ZwXZdrlLiZw4gmqzcCV34rQ+r/nLE4ApMOCka
   JeCa6dUBS/2qr8G1mU6sT4rMxehiiLGykumTMlk+xrw33QpnDgat/edfd
   InjURX07iS3/GscPHERZ2b5blyzNGoJfcvQOjGH+XFiUYBROruja7bxIr
   A/WrMKSlIwPez9W3zZsSo0JJQnU3XG3RkQ02sXWvNuAC9IHcJg959BHR4
   g==;
IronPort-SDR: ms0NRyaYJQ2bEzckjxXrXToHmwtv8gh4I9vxSltGZvu+S8KsayTcwGwjEIVqRO4aYP4whliy+x
 0ydU5OyDv6GCYc3pMKxTXChhlQvY+xklEiyHXEP+eN33QmkQHQ2OhzIuubp+4FUz/wf1pZKX3B
 sj7zq3l+lvK5sIR0EyRrm82IneqO97GyYvgNuO9ltTGGj75OiaAzam17g06MEb+7SZoBivZ/is
 NiLqaZLPjsO570Zc/JHaKaU7hsKx1pFfKVfLn8JiMaWweuyd+WAMQ8ku0C6ahFwEiC3eW2r0G8
 ytI=
X-IronPort-AV: E=Sophos;i="5.75,300,1589266800"; 
   d="scan'208";a="81529535"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 01 Jul 2020 06:09:10 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 1 Jul 2020 06:09:06 -0700
Received: from m18063-ThinkPad-T460p.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Wed, 1 Jul 2020 06:09:04 -0700
From:   Claudiu Beznea <claudiu.beznea@microchip.com>
To:     <nicolas.ferre@microchip.com>, <davem@davemloft.net>,
        <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Claudiu Beznea <claudiu.beznea@microchip.com>
Subject: [PATCH net-next 3/4] net: macb: do not initialize queue variable
Date:   Wed, 1 Jul 2020 16:08:50 +0300
Message-ID: <1593608931-3718-4-git-send-email-claudiu.beznea@microchip.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1593608931-3718-1-git-send-email-claudiu.beznea@microchip.com>
References: <1593608931-3718-1-git-send-email-claudiu.beznea@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Do not initialize queue variable. It is already initialized in for loops.

Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>
---
 drivers/net/ethernet/cadence/macb_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index a84fb0ec53f0..3603ab707e0f 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -1467,7 +1467,7 @@ static void macb_hresp_error_task(unsigned long data)
 {
 	struct macb *bp = (struct macb *)data;
 	struct net_device *dev = bp->dev;
-	struct macb_queue *queue = bp->queues;
+	struct macb_queue *queue;
 	unsigned int q;
 	u32 ctrl;
 
-- 
2.7.4

