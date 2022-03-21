Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AE314E2C2E
	for <lists+netdev@lfdr.de>; Mon, 21 Mar 2022 16:27:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350177AbiCUP2j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 11:28:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241364AbiCUP2i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 11:28:38 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C1A0160FDC
        for <netdev@vger.kernel.org>; Mon, 21 Mar 2022 08:27:13 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id 6so10547854pgg.0
        for <netdev@vger.kernel.org>; Mon, 21 Mar 2022 08:27:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pYfXEHfZl09/d0W/8k6bn6GHeCrNBUTTAtovTezahB8=;
        b=SsAGVFcNjJmV8fMQbUyG7TiYJXK2+32iN/1XMrye7xFZFnwPrpwxT6DyJ3Y/rRRDr7
         5uCZqKj+BhyDIO26VKMm/iKlT2Evf0yTKoOj5CPhLL5k2VOxlx42W/oPVzytc48Or8Qj
         MvDiR7ItkG9up8TfH/vHxgn5tS4tmsgk8MgrphVO1MVe5YUTOjKbEkpmvIhNUp67OlsI
         y3j5DkywFu6uUP2ZkhqcNAPDdk7/fphPgaY0FN2ieWv6mCE1dsvC5b/8d1CfP70J/v1/
         fjI1vaH5C1cjLBtfzgRajpdkJOhiwgVZrMCmLoiKIe7z/34AeW7zxouMEyc8NfIiqU1S
         5cDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pYfXEHfZl09/d0W/8k6bn6GHeCrNBUTTAtovTezahB8=;
        b=O2S8co1bPX4ubU8DkfunxkOYoJMTW6XecRs/lM4MNnd01e4QcLJUoS8g5i/MR+aCq8
         Mx67LBjlSqG5l4UqUDGVbvgjyAoklQ+URCajJc9Ox6ol5L9JJbdhwO9IVbfxBCZE+nCc
         YFcKF6qkeGV6TIE3qOVlCfHbOjQMZi4osax5RFNdQ7GlzUES67q1mZzH3lQeVYpoA3a8
         PM/CA6TiHZeOyoT/+I9X9SjwxQpd7xb4lIdoDCyNcEnD3IolJrnA2Ep9kHmmKxpNAsOY
         EiJesUIX2nNhbsOmV0ZWjBItgqKJNYTFLvr3LZx5yNJeaDUqQV4pf/n4KVEGrecDVtjF
         YYtQ==
X-Gm-Message-State: AOAM533QSDBpiWKBPl5Prix2TOesqVFBqZX9wkcnMa2lDWew9KatbmkC
        VPWJLDGeWZsd+urkghRLoYtnww==
X-Google-Smtp-Source: ABdhPJwh1907hH4HbirjpJw7g0In/BLkgy+uXWdIJGQYLEHnZlrq68MS04W6NEiEWxXi8lNC6Bhkzg==
X-Received: by 2002:a05:6a00:1152:b0:4be:ab79:fcfa with SMTP id b18-20020a056a00115200b004beab79fcfamr24585061pfm.3.1647876432798;
        Mon, 21 Mar 2022 08:27:12 -0700 (PDT)
Received: from archlinux.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id i15-20020a63b30f000000b003803aee35a2sm15342644pgf.31.2022.03.21.08.27.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Mar 2022 08:27:12 -0700 (PDT)
From:   Andy Chiu <andy.chiu@sifive.com>
To:     radhey.shyam.pandey@xilinx.com, robert.hancock@calian.com,
        michal.simek@xilinx.com
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        robh+dt@kernel.org, linux@armlinux.org.uk, andrew@lunn.ch,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        Andy Chiu <andy.chiu@sifive.com>,
        Greentime Hu <greentime.hu@sifive.com>
Subject: [PATCH v4 1/4] net: axienet: setup mdio unconditionally
Date:   Mon, 21 Mar 2022 23:25:12 +0800
Message-Id: <20220321152515.287119-1-andy.chiu@sifive.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The call to axienet_mdio_setup should not depend on whether "phy-node"
pressents on the DT. Besides, since `lp->phy_node` is used if PHY is in
SGMII or 100Base-X modes, move it into the if statement. And the next patch
will remove `lp->phy_node` from driver's private structure and do an
of_node_put on it right away after use since it is not used elsewhere.

Signed-off-by: Andy Chiu <andy.chiu@sifive.com>
Reviewed-by: Greentime Hu <greentime.hu@sifive.com>
---
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index 6fd5157f0a6d..5d41b8de840a 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -2064,15 +2064,14 @@ static int axienet_probe(struct platform_device *pdev)
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
2.34.1

