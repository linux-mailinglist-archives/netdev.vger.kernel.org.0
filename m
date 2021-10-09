Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1F42427D03
	for <lists+netdev@lfdr.de>; Sat,  9 Oct 2021 21:08:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230499AbhJITKt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Oct 2021 15:10:49 -0400
Received: from relmlor2.renesas.com ([210.160.252.172]:31354 "EHLO
        relmlie6.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S230345AbhJITKl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Oct 2021 15:10:41 -0400
X-IronPort-AV: E=Sophos;i="5.85,361,1624287600"; 
   d="scan'208";a="96659013"
Received: from unknown (HELO relmlir5.idc.renesas.com) ([10.200.68.151])
  by relmlie6.idc.renesas.com with ESMTP; 10 Oct 2021 04:08:43 +0900
Received: from localhost.localdomain (unknown [10.226.92.6])
        by relmlir5.idc.renesas.com (Postfix) with ESMTP id B26874012BE8;
        Sun, 10 Oct 2021 04:08:40 +0900 (JST)
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Biju Das <biju.das.jz@bp.renesas.com>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sergey Shtylyov <s.shtylyov@omprussia.ru>,
        Adam Ford <aford173@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Yuusuke Ashizuka <ashiduka@fujitsu.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>,
        Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>
Subject: [PATCH 10/14] ravb: Optimize ravb_emac_init_gbeth function
Date:   Sat,  9 Oct 2021 20:07:58 +0100
Message-Id: <20211009190802.18585-11-biju.das.jz@bp.renesas.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211009190802.18585-1-biju.das.jz@bp.renesas.com>
References: <20211009190802.18585-1-biju.das.jz@bp.renesas.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Optimize CXR31 register initialization on ravb_emac_init_gbeth
function.

Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Suggested-by: Sergey Shtylyov <s.shtylyov@omp.ru>
Reviewed-by: Sergey Shtylyov <s.shtylyov@omp.ru>
---
RFC->V1:
 * No Change. Added Sergey's Rb tag.
RFC changes:
 * New patch.
---
 drivers/net/ethernet/renesas/ravb_main.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
index eac3bbefff11..081d9b70f038 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -538,8 +538,7 @@ static void ravb_emac_init_gbeth(struct net_device *ndev)
 	/* E-MAC interrupt enable register */
 	ravb_write(ndev, ECSIPR_ICDIP, ECSIPR);
 
-	ravb_modify(ndev, CXR31, CXR31_SEL_LINK1, 0);
-	ravb_modify(ndev, CXR31, CXR31_SEL_LINK0, CXR31_SEL_LINK0);
+	ravb_modify(ndev, CXR31, CXR31_SEL_LINK0 | CXR31_SEL_LINK1, CXR31_SEL_LINK0);
 }
 
 static void ravb_emac_init_rcar(struct net_device *ndev)
-- 
2.17.1

