Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BAEC4E580B
	for <lists+netdev@lfdr.de>; Wed, 23 Mar 2022 19:02:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343926AbiCWSEJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Mar 2022 14:04:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343923AbiCWSEI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Mar 2022 14:04:08 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12FC4888D1
        for <netdev@vger.kernel.org>; Wed, 23 Mar 2022 11:02:36 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id q19so1771146pgm.6
        for <netdev@vger.kernel.org>; Wed, 23 Mar 2022 11:02:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gNEGSlS2mPCYLZrFQejehM36cdi8B+KPhgqHYrJkMJk=;
        b=U+FC0zvEMskeJPO6QafbDtyAkMA40WHTepQKPxaUHxq6GWxi8+VaKwMIO0YhMmownc
         Y2BO7w9D+7LkM23KMhAdAjTZozsf6iWea/g8PTshI4Almyv/+Bcr8S22AA3CKvpqr0vT
         TOsm6e5koKGGabEXziNF0hbOgJPz4aMuUvovvMoBP68YjPOolwBky100vvztJMr0M29G
         b9iRUyon8M+5x2IQCfFbNu238/CiG94NIXWqgCxxHMGaV4zXNzNL6cx4m6Fhih/qUmrI
         Y2PL8MjjCZQT8t+izQTvZr7LMh59Xbhq1CVUbNlI2SfpZMNrDllxR5W2rb1gToqnSTxC
         X/tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gNEGSlS2mPCYLZrFQejehM36cdi8B+KPhgqHYrJkMJk=;
        b=2HUM+GvERAJUpxcmlXhiXb2j+joCS4Tfkv7pm3OCsznL2dwQpaZYZdJAxv78CDyrdj
         Txvy4I9XA4p1YgSyZRj7112oJeo1PrFmHnq97S02HyVH0NIEWvRC/2klWSKRJYGlsfrW
         lyB5B8fdmuKNfg+uvZtCXnA4wr2qTeQCWFCSNNV5v/2d3zXnsu4yFKOOLGAP98R4Kala
         nHgFg01E+VOm2+7o2JT0T8Btn/l8blBf8Bcwz5Z9Y2I7TZp1CAmsz7sCCxWi//lIG6+7
         9VqJgO9MlFmaMs6j9rhS/nzFkjUXori+bPtpBC/HKncGexFadLGZc4DVKfBPPAyWH6pV
         HqzA==
X-Gm-Message-State: AOAM533BRvVHtsVnKb7rhY6slvyD29W+s12sj46bh/twn9iQHMeLxijG
        un1w/Q5SChS4DN2uws0A+d+u/A==
X-Google-Smtp-Source: ABdhPJyrXAem/49LdGoF6jLSNndXSt4r+mvKChNrDteg/iCxp5KVfvKgpbwZokPKRJrLFaJqz1pnoA==
X-Received: by 2002:a63:e201:0:b0:382:6afe:f0ec with SMTP id q1-20020a63e201000000b003826afef0ecmr819472pgh.339.1648058556422;
        Wed, 23 Mar 2022 11:02:36 -0700 (PDT)
Received: from archlinux.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id l19-20020a17090aec1300b001c7a31ba88csm1265870pjy.1.2022.03.23.11.02.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Mar 2022 11:02:36 -0700 (PDT)
From:   Andy Chiu <andy.chiu@sifive.com>
To:     radhey.shyam.pandey@xilinx.com, robert.hancock@calian.com,
        michal.simek@xilinx.com
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        robh+dt@kernel.org, linux@armlinux.org.uk, andrew@lunn.ch,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        robh@kernel.org, Andy Chiu <andy.chiu@sifive.com>,
        Greentime Hu <greentime.hu@sifive.com>
Subject: [PATCH v5 net 2/4] net: axienet: factor out phy_node in struct axienet_local
Date:   Thu, 24 Mar 2022 02:00:20 +0800
Message-Id: <20220323180022.864567-3-andy.chiu@sifive.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220323180022.864567-1-andy.chiu@sifive.com>
References: <20220323180022.864567-1-andy.chiu@sifive.com>
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

the struct member `phy_node` of struct axienet_local is not used by the
driver anymore after initialization. It might be a remnent of old code
and could be removed.

Signed-off-by: Andy Chiu <andy.chiu@sifive.com>
Reviewed-by: Greentime Hu <greentime.hu@sifive.com>
Reviewed-by: Robert Hancock <robert.hancock@calian.com>
---
 drivers/net/ethernet/xilinx/xilinx_axienet.h      |  2 --
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c | 13 +++++--------
 2 files changed, 5 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet.h b/drivers/net/ethernet/xilinx/xilinx_axienet.h
index 5b4d153b1492..6a0b7ad958cd 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet.h
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet.h
@@ -428,8 +428,6 @@ struct axienet_local {
 	struct net_device *ndev;
 	struct device *dev;
 
-	struct device_node *phy_node;
-
 	struct phylink *phylink;
 	struct phylink_config phylink_config;
 
diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index 93be1adc303f..a4783f95b979 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -2067,18 +2067,20 @@ static int axienet_probe(struct platform_device *pdev)
 
 	if (lp->phy_mode == PHY_INTERFACE_MODE_SGMII ||
 	    lp->phy_mode == PHY_INTERFACE_MODE_1000BASEX) {
-		lp->phy_node = of_parse_phandle(pdev->dev.of_node, "phy-handle", 0);
-		if (!lp->phy_node) {
+		np = of_parse_phandle(pdev->dev.of_node, "phy-handle", 0);
+		if (!np) {
 			dev_err(&pdev->dev, "phy-handle required for 1000BaseX/SGMII\n");
 			ret = -EINVAL;
 			goto cleanup_mdio;
 		}
-		lp->pcs_phy = of_mdio_find_device(lp->phy_node);
+		lp->pcs_phy = of_mdio_find_device(np);
 		if (!lp->pcs_phy) {
 			ret = -EPROBE_DEFER;
+			of_node_put(np);
 			goto cleanup_mdio;
 		}
 		lp->phylink_config.pcs_poll = true;
+		of_node_put(np);
 	}
 
 	lp->phylink_config.dev = &ndev->dev;
@@ -2120,8 +2122,6 @@ static int axienet_probe(struct platform_device *pdev)
 		put_device(&lp->pcs_phy->dev);
 	if (lp->mii_bus)
 		axienet_mdio_teardown(lp);
-	of_node_put(lp->phy_node);
-
 cleanup_clk:
 	clk_bulk_disable_unprepare(XAE_NUM_MISC_CLOCKS, lp->misc_clks);
 	clk_disable_unprepare(lp->axi_clk);
@@ -2150,9 +2150,6 @@ static int axienet_remove(struct platform_device *pdev)
 	clk_bulk_disable_unprepare(XAE_NUM_MISC_CLOCKS, lp->misc_clks);
 	clk_disable_unprepare(lp->axi_clk);
 
-	of_node_put(lp->phy_node);
-	lp->phy_node = NULL;
-
 	free_netdev(ndev);
 
 	return 0;
-- 
2.34.1

