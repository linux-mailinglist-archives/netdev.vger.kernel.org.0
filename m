Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56E92689999
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 14:21:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231761AbjBCNVO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 08:21:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231171AbjBCNVM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 08:21:12 -0500
Received: from mx1.tq-group.com (mx1.tq-group.com [93.104.207.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C9DE7199A
        for <netdev@vger.kernel.org>; Fri,  3 Feb 2023 05:21:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=tq-group.com; i=@tq-group.com; q=dns/txt; s=key1;
  t=1675430469; x=1706966469;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=ImTIjT1vboN4+h3/cQflLupWkOpeReyyqT7RLLshX5U=;
  b=pZXOxKD48522ojmsRQY34oeMLECYBsabIwCaICnhZGwNGpmXuzFb5ArU
   YpKDuAXbcS8z/nVbbAT9DZ67Pb1j/inxJ+TNxvq1EFiyW2Q2anu+sRZBR
   LEmzrpdP2waSUEhQES3mc7FT7qW+Ic6hwCH04UBXIWHrX4LhwAvnGBlva
   4fQvYtGQH6McVZOO8+kb6G2mx0sl7G/omNguzo3/wsfZ7VH9GkEq2Nfc9
   OVsJL47HZ/vTnJMAbTbXf+URX1P5f8xxnoEzEwU3kK5k61AbnwxuB6Zhj
   3ZswskCLoZt4dJ5DDy6c8gMgfZvHOm1I7uFq8BS2iapDmcu4jsK2VlW49
   Q==;
X-IronPort-AV: E=Sophos;i="5.97,270,1669071600"; 
   d="scan'208";a="28856831"
Received: from unknown (HELO tq-pgp-pr1.tq-net.de) ([192.168.6.15])
  by mx1-pgp.tq-group.com with ESMTP; 03 Feb 2023 14:21:07 +0100
Received: from mx1.tq-group.com ([192.168.6.7])
  by tq-pgp-pr1.tq-net.de (PGP Universal service);
  Fri, 03 Feb 2023 14:21:07 +0100
X-PGP-Universal: processed;
        by tq-pgp-pr1.tq-net.de on Fri, 03 Feb 2023 14:21:07 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=tq-group.com; i=@tq-group.com; q=dns/txt; s=key1;
  t=1675430467; x=1706966467;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=ImTIjT1vboN4+h3/cQflLupWkOpeReyyqT7RLLshX5U=;
  b=HMt6x/udFVAAEkVDsWAA4mvuf+zqVwC7ZnWzLNUA3oP8Rtpx434jI4Jb
   /KWSM4ceEqskruWuj3EfgLhSvwwbwWrHhwDhq9BokdVsQojPDPUDogvrw
   9+2RZ/gb0ogPCpbfiZn/5MDIky/loOaNeQ6vdl+Z8jnyAllO4HRscu+MA
   oQQvF8nL4l7wg7YVREMg0bTjHBbVV0/Rb7WrQOvrX/XaVc0WgwFGrp/fm
   3xstZf+9MWEpci+WHLuTp9/PGbqC3P5sQBvl83hdIfn+uX8Sg+HeQRuds
   Ty/k/+gijjGg/iMygovo983ASnij6Hau44eFgJitzbRtB+24ugNR4ujXj
   w==;
X-IronPort-AV: E=Sophos;i="5.97,270,1669071600"; 
   d="scan'208";a="28856830"
Received: from vtuxmail01.tq-net.de ([10.115.0.20])
  by mx1.tq-group.com with ESMTP; 03 Feb 2023 14:21:07 +0100
Received: from steina-w.tq-net.de (unknown [10.123.53.21])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by vtuxmail01.tq-net.de (Postfix) with ESMTPSA id AE785280056;
        Fri,  3 Feb 2023 14:21:06 +0100 (CET)
From:   Alexander Stein <alexander.stein@ew.tq-group.com>
To:     Wei Fang <wei.fang@nxp.com>, Shenwei Wang <shenwei.wang@nxp.com>,
        Clark Wang <xiaoning.wang@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     Alexander Stein <alexander.stein@ew.tq-group.com>,
        NXP Linux Team <linux-imx@nxp.com>, netdev@vger.kernel.org
Subject: [PATCH 1/1] net: fec: Don't fail on missing optional phy-reset-gpios
Date:   Fri,  3 Feb 2023 14:21:02 +0100
Message-Id: <20230203132102.313314-1-alexander.stein@ew.tq-group.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The conversion to gpio descriptors accidentally removed the short return
if there is no 'phy-reset-gpios' property, leading to the error

fec 30be0000.ethernet: error -ENOENT: failed to get phy-reset-gpios

This is especially the case when the PHY reset GPIO is specified in
the PHY node itself.

Fixes: 468ba54bd616 ("fec: convert to gpio descriptor")
Signed-off-by: Alexander Stein <alexander.stein@ew.tq-group.com>
---
 drivers/net/ethernet/freescale/fec_main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index 2716898e0b9b..1fddd7ec1118 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -4058,6 +4058,8 @@ static int fec_reset_phy(struct platform_device *pdev)
 
 	phy_reset = devm_gpiod_get(&pdev->dev, "phy-reset",
 			active_high ? GPIOD_OUT_HIGH : GPIOD_OUT_LOW);
+	if (PTR_ERR(phy_reset) == -ENOENT)
+		return 0;
 	if (IS_ERR(phy_reset))
 		return dev_err_probe(&pdev->dev, PTR_ERR(phy_reset),
 				     "failed to get phy-reset-gpios\n");
-- 
2.34.1

