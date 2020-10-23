Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43A712968CD
	for <lists+netdev@lfdr.de>; Fri, 23 Oct 2020 05:33:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S374868AbgJWDdu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Oct 2020 23:33:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S374825AbgJWDdu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Oct 2020 23:33:50 -0400
Received: from ozlabs.org (bilbo.ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40350C0613CE;
        Thu, 22 Oct 2020 20:33:50 -0700 (PDT)
Received: by ozlabs.org (Postfix, from userid 1034)
        id 4CHVFQ6MvJz9sSs; Fri, 23 Oct 2020 14:33:46 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ellerman.id.au;
        s=201909; t=1603424026;
        bh=AwOSiExI8NbntUvUtGVI5OP3bq4Ymzz/W7ahgDUbvLY=;
        h=From:To:Cc:Subject:Date:From;
        b=D10j4BBwWTAKb5ZBcmye4YTVu192Aio1PIHlJoc0gPDo1/RvtnE1CjJxnTlMmw2vO
         xfA1Bq8AAl1zIdzdgkBYgQ1Y4Rt5hze4WKVymcV6nG8fCbcxCUnriJzp4fIyed2YtV
         maOOINbUB9y6sFyMXE6F14y5/zM6/il5Nu4ekBJGZTe0StrL0CfONe65QPTWh0wTL+
         as7pwNnbt2PSuYUECVqGmrXI6836PRw9UzyyYKjorsNTHJWV72CUEi0szipbRUeLMF
         dE8KYBp2hnkkJVXzQIJn3z2y40L0XxN8TXgd/TdsbUtQhXzo2cYLn0D8fMZtK+5gaB
         JiN5R9azn9MPw==
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     linuxppc-dev@ozlabs.org, netdev@vger.kernel.org
Cc:     davem@davemloft.net, linux-kernel@vger.kernel.org, kuba@kernel.org,
        leoyang.li@nxp.com
Subject: [PATCH] net: ucc_geth: Drop extraneous parentheses in comparison
Date:   Fri, 23 Oct 2020 14:32:36 +1100
Message-Id: <20201023033236.3296988-1-mpe@ellerman.id.au>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Clang warns about the extra parentheses in this comparison:

  drivers/net/ethernet/freescale/ucc_geth.c:1361:28:
  warning: equality comparison with extraneous parentheses
    if ((ugeth->phy_interface == PHY_INTERFACE_MODE_SGMII))
         ~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~~~~

It seems clear the intent here is to do a comparison not an
assignment, so drop the extra parentheses to avoid any confusion.

Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
---
 drivers/net/ethernet/freescale/ucc_geth.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/ucc_geth.c b/drivers/net/ethernet/freescale/ucc_geth.c
index db791f60b884..d8ad478a0a13 100644
--- a/drivers/net/ethernet/freescale/ucc_geth.c
+++ b/drivers/net/ethernet/freescale/ucc_geth.c
@@ -1358,7 +1358,7 @@ static int adjust_enet_interface(struct ucc_geth_private *ugeth)
 	    (ugeth->phy_interface == PHY_INTERFACE_MODE_RTBI)) {
 		upsmr |= UCC_GETH_UPSMR_TBIM;
 	}
-	if ((ugeth->phy_interface == PHY_INTERFACE_MODE_SGMII))
+	if (ugeth->phy_interface == PHY_INTERFACE_MODE_SGMII)
 		upsmr |= UCC_GETH_UPSMR_SGMM;
 
 	out_be32(&uf_regs->upsmr, upsmr);
-- 
2.25.1

