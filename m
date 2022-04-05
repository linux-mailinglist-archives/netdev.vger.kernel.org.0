Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84ADE4F35AC
	for <lists+netdev@lfdr.de>; Tue,  5 Apr 2022 15:52:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232356AbiDEKxz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Apr 2022 06:53:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244557AbiDEJl2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 05:41:28 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CA50BBE08
        for <netdev@vger.kernel.org>; Tue,  5 Apr 2022 02:26:59 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id d15so5060759pll.10
        for <netdev@vger.kernel.org>; Tue, 05 Apr 2022 02:26:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=18aEhZqxqni23oeSOiNVFxkklmTsPbag40eOHFXJhw4=;
        b=MtQpV+HAPkpl9nIZgEfWNU5eIUoiDzA9wf7wQr/foKpSJxitgbcp36g6IEEzJBO2jk
         4RNVtzoLCE6GG4RT/sqdzIWBKU5ee6LIE7yt25wc3cGbqwYTDVP4Yqx8mQZKXaJSqFD2
         gxNN/XrOgcoGtm1Qc61D0Hl6xrOc9CPHCFaM3RLfxHxcEg+yc67yhI5MPr4f/RULUsvB
         2J5lV1kxH+Cv8EMCWNeTdfCYT9kiA4Cl28FEZnv9NUNKB1tGkHi4hn7a1kDhbh+NSzq+
         imjqTIutohSZZczAOU+JuC06Cl/ONykc805K0ZGyKCHrk3jQdIteosRiFVLSnnvxFTqK
         wOrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=18aEhZqxqni23oeSOiNVFxkklmTsPbag40eOHFXJhw4=;
        b=K5i2v8mGl1JvHL4xWenpLYg5+KIvoPNl3LWWjHESqel2hQvYbBoEG379zraAhKPzUo
         u4fWoOc0WJeAJ2fmiOViAgx2gyN6+Ff7qUIfk5/06Y6lhD6c9K/gItB/QZM6RLqMfOn2
         VSBQkmv8bUExKu+oBKqbSRIZAaQl+gjpNC4Rs6kGFgnI9taYN9kTJRv7zLKgoW7YVe7c
         nuZpxW7LKpfyyvD5Vk3WpAWErgwLRPJdC5w0/tH+ekWB+4yrZ+nQqq2xnszygeJCUTbo
         KDgphzh48AuB6Q5W+G9yqif3weXVzKleVjeUylf+4Rf+nO5tAU9qXipddw09yB+UYTMh
         vHPg==
X-Gm-Message-State: AOAM532Qx05m8CJAJHQXfR5kd5ay6IOSgm3YZ3/7BhrAPnscYxQM/IIm
        U1SUetGZxY6965NXUm9A9JRcjg==
X-Google-Smtp-Source: ABdhPJxJpOoqIbkrQZcXwD86PNwRc2NeuTW0czkP/GnednZod6DBEGo+I1OislXJCSGNfs7aM8ifhA==
X-Received: by 2002:a17:902:c94a:b0:156:ae43:4023 with SMTP id i10-20020a170902c94a00b00156ae434023mr2380919pla.115.1649150819493;
        Tue, 05 Apr 2022 02:26:59 -0700 (PDT)
Received: from archlinux.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id b4-20020aa78704000000b004fe0ce6d6e1sm5824291pfo.32.2022.04.05.02.26.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Apr 2022 02:26:59 -0700 (PDT)
From:   Andy Chiu <andy.chiu@sifive.com>
To:     davem@davemloft.net, michal.simek@xilinx.com,
        radhey.shyam.pandey@xilinx.com
Cc:     andrew@lunn.ch, kuba@kernel.org, pabeni@redhat.com,
        robh+dt@kernel.org, krzk+dt@kernel.org, linux@armlinux.org.uk,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        Andy Chiu <andy.chiu@sifive.com>,
        Greentime Hu <greentime.hu@sifive.com>,
        Robert Hancock <robert.hancock@calian.com>
Subject: [PATCH v8 net-next 1/4] net: axienet: setup mdio unconditionally
Date:   Tue,  5 Apr 2022 17:19:26 +0800
Message-Id: <20220405091929.670951-2-andy.chiu@sifive.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220405091929.670951-1-andy.chiu@sifive.com>
References: <20220405091929.670951-1-andy.chiu@sifive.com>
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

