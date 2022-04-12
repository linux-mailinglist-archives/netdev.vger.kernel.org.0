Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2E384FCA86
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 02:51:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244405AbiDLAyK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 20:54:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343685AbiDLAxU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 20:53:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 210A533E39;
        Mon, 11 Apr 2022 17:48:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D140EB819B4;
        Tue, 12 Apr 2022 00:48:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A8DCC385A4;
        Tue, 12 Apr 2022 00:48:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649724487;
        bh=EcZIn9B50ER/b5XM1sUKQIjm37ZI2VynoYO5vl94STY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VqUW2iD/lk4Xz+5Nv+rFTwjWbxCeG0vyJTbjIZb20doHAafJ5C/pGhEJkqMy6Ew9D
         ICv+a2NqKJq3XL5b4ophSo1XY5VFfU+iY1V9ALNykksm9fnMQbMTK89nJxJSkthBs2
         Fc8geCPcqh825u3OkB9HrFZ0NtkV+CJhxkhPVGl3F0n2YpZaxzmrgc+R2U4WPsy0Dd
         a03l4ROk01JOuailK2+ozYab4oBsFJTWtm7q5HciyyN7q1W3YPzCBGr+40xbrWk3Tk
         YLA5NJInADtu/iZ8Nhk+9zyOZdQ7NOx9EX3akpVGJwaE0ojBAspkeTuGWzLBlo0fij
         q8U7pDp0CgDmA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andy Chiu <andy.chiu@sifive.com>,
        Greentime Hu <greentime.hu@sifive.com>,
        Robert Hancock <robert.hancock@calian.com>,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, kuba@kernel.org,
        pabeni@redhat.com, michal.simek@xilinx.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.15 24/41] net: axienet: setup mdio unconditionally
Date:   Mon, 11 Apr 2022 20:46:36 -0400
Message-Id: <20220412004656.350101-24-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412004656.350101-1-sashal@kernel.org>
References: <20220412004656.350101-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andy Chiu <andy.chiu@sifive.com>

[ Upstream commit d1c4f93e3f0a023024a6f022a61528c06cf1daa9 ]

The call to axienet_mdio_setup should not depend on whether "phy-node"
pressents on the DT. Besides, since `lp->phy_node` is used if PHY is in
SGMII or 100Base-X modes, move it into the if statement. And the next patch
will remove `lp->phy_node` from driver's private structure and do an
of_node_put on it right away after use since it is not used elsewhere.

Signed-off-by: Andy Chiu <andy.chiu@sifive.com>
Reviewed-by: Greentime Hu <greentime.hu@sifive.com>
Reviewed-by: Robert Hancock <robert.hancock@calian.com>
Reviewed-by: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index 80637ffcca93..fbbbcfe0e891 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -2127,15 +2127,14 @@ static int axienet_probe(struct platform_device *pdev)
 	if (ret)
 		goto cleanup_clk;
 
-	lp->phy_node = of_parse_phandle(pdev->dev.of_node, "phy-handle", 0);
-	if (lp->phy_node) {
-		ret = axienet_mdio_setup(lp);
-		if (ret)
-			dev_warn(&pdev->dev,
-				 "error registering MDIO bus: %d\n", ret);
-	}
+	ret = axienet_mdio_setup(lp);
+	if (ret)
+		dev_warn(&pdev->dev,
+			 "error registering MDIO bus: %d\n", ret);
+
 	if (lp->phy_mode == PHY_INTERFACE_MODE_SGMII ||
 	    lp->phy_mode == PHY_INTERFACE_MODE_1000BASEX) {
+		lp->phy_node = of_parse_phandle(pdev->dev.of_node, "phy-handle", 0);
 		if (!lp->phy_node) {
 			dev_err(&pdev->dev, "phy-handle required for 1000BaseX/SGMII\n");
 			ret = -EINVAL;
-- 
2.35.1

