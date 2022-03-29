Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDD524EA582
	for <lists+netdev@lfdr.de>; Tue, 29 Mar 2022 04:52:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231269AbiC2CxV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Mar 2022 22:53:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230033AbiC2CxS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Mar 2022 22:53:18 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C59891B370B
        for <netdev@vger.kernel.org>; Mon, 28 Mar 2022 19:51:36 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id f3so13395769pfe.2
        for <netdev@vger.kernel.org>; Mon, 28 Mar 2022 19:51:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=18aEhZqxqni23oeSOiNVFxkklmTsPbag40eOHFXJhw4=;
        b=kKdY1AZb7fKL9iY/FdwTBa37vrBkrrH30evEfYQ01+MS4yIuYBeQs0cLp/L1+edmuu
         hezLQAReiit3wsioUujFm/yjMc+PUl5toX9YEvhfplEav42cz5QrRsHhZHHlnlA9RS0J
         utmoHYjgEgMpiFxRuGMdxEtFPCSrZfa9wE25Usifjj6Skp6Qtc0LNOC5M0i/2hBIUkVX
         ZRJfGx+70V8hm2T6eEodsucp9xPuMROOoIMMRUrAIVzG69+wpdcC2AhiUsLltIYG5hNn
         h1xLuE3KR7ISDObCtlaYTWGUzpC5QvxKjiJ2fcHg6DgOm76yx4QZVDlBu8UgxlsXkzxs
         kSXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=18aEhZqxqni23oeSOiNVFxkklmTsPbag40eOHFXJhw4=;
        b=U3fb/Dd0LdklClfPQdTjgts94+Lf7oD9ptQbZUmFjSKOkECLERgIU8gwEEXyoPjyas
         liKiwAskOnBZfRIWrbxRuYCLD4Gs2nau6+dFUF+qKAB9pWaIlTq6Hrm+F2r1BUfU+Ss7
         ytaWNzyuIuHqnTafg0Ah7M/wugwOHxZLTTYrzOrML95jyTxRGVb/RJZrtBqr5mdAZOhu
         aGXQDy3bVJ/PsHw+DClPo/Nk0hG1n20Rd8Y22tTvtUT/D0+FX/WmGTr5XuSjg3ckTICy
         G5dm/bdh2u6H/57oQG0XBVMdad1g7D52Is0Ywhtqt3kP53zqOE91eaL4lBMs2m3Y5rJw
         tu8g==
X-Gm-Message-State: AOAM532y3RjQSCtk2+ZSyX5ZCqAGLX6vWPI1cUyLiSQ5e2XDLprVol3E
        fbuBXCx4wsNcKbOJ5xoFMl4lY6j7Jn2m5GP3
X-Google-Smtp-Source: ABdhPJz7aObK2yWpJIgjdfrEy6zk/GWdVoGyZl/AA5FMJxv7fHBbQHiTIZVWOhST53EL0Ja52wlVxg==
X-Received: by 2002:a63:6f4c:0:b0:386:4801:a83e with SMTP id k73-20020a636f4c000000b003864801a83emr400506pgc.184.1648522296296;
        Mon, 28 Mar 2022 19:51:36 -0700 (PDT)
Received: from archlinux.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id f14-20020a63380e000000b0038253c4d5casm14136053pga.36.2022.03.28.19.51.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Mar 2022 19:51:36 -0700 (PDT)
From:   Andy Chiu <andy.chiu@sifive.com>
To:     kuba@kernel.org, radhey.shyam.pandey@xilinx.com,
        robert.hancock@calian.com, michal.simek@xilinx.com, andrew@lunn.ch
Cc:     davem@davemloft.net, pabeni@redhat.com, robh+dt@kernel.org,
        linux@armlinux.org.uk, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, robh@kernel.org,
        Andy Chiu <andy.chiu@sifive.com>,
        Greentime Hu <greentime.hu@sifive.com>
Subject: [PATCH v7 net 1/4] net: axienet: setup mdio unconditionally
Date:   Tue, 29 Mar 2022 10:49:18 +0800
Message-Id: <20220329024921.2739338-2-andy.chiu@sifive.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220329024921.2739338-1-andy.chiu@sifive.com>
References: <20220329024921.2739338-1-andy.chiu@sifive.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
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
Reviewed-by: Robert Hancock <robert.hancock@calian.com>
---
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index c7eb05e4a6bf..78a991bbbcf9 100644
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

