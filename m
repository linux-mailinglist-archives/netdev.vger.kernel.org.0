Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 835FF4E5809
	for <lists+netdev@lfdr.de>; Wed, 23 Mar 2022 19:02:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343919AbiCWSEF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Mar 2022 14:04:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343917AbiCWSEE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Mar 2022 14:04:04 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3089887B7
        for <netdev@vger.kernel.org>; Wed, 23 Mar 2022 11:02:33 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id w21so1768196pgm.7
        for <netdev@vger.kernel.org>; Wed, 23 Mar 2022 11:02:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qQ1E9vaYcbwB4kkyy3glJ3m1Y05xvh8o6YtkdTT7sgU=;
        b=ADCQYwnsYTuQVfKVb77+jTY66sthiMnCvTTBS5pnIc53UJayaHRJ2rzjk9CnwEF5bj
         3LRQBHLloVGcwOo+3c/HrgTNLhJm6nZXITHmB2HdMtSc63lVtui/qbAfhB0Zzm72VUHB
         347FFEiQvA/qIMxvtjh2V4EMo2joacOJuWiVrr21jhzc6kTu1d5lSKXlePrhJb+3t+ha
         k4xX0ai7epdaRv8lBQtWXOUI/aoBZ1nrDxBjF57P+L+3vlk8gKm9OOkpXJ6vTgPCCPWt
         LuwmKw6s8Qx6PsfejfF3qX+zWgtUyswyGEZO65nbMs6hd322vcRjP87bkTHpIREtjq4+
         WWpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qQ1E9vaYcbwB4kkyy3glJ3m1Y05xvh8o6YtkdTT7sgU=;
        b=IZ0KXEGL2O3mzxkwuBbL7CBjpRJfmgA8FMyG2u/tmi/phLZUzN2Ulo09Q0/qxZ2emC
         rFSbCFgczGB3E6eN4V1UcA1kg/YzT1VbIwmnvWNL6/zwJ7WCB5icdqzXLrs+KyuXjyzp
         hronR6fnaVjSCjo/Qdtzx8zUD4r+bB1fmDe1lEvWSKWdBgn8eAU3t5FNVoBcLwLzwiC1
         OR9EbubJJNVhetXlzAy+CGd5yrjsWkcem8prVX4qyeLkE46J1NErqxOaAUxsGwtOnvZk
         2DDEn6j6tz+qMS388U92cwfgUgW70omLa7RZKaOkUcedOJeZaAWsfyxCMAbw73QZd6rh
         Ni5g==
X-Gm-Message-State: AOAM533A3+SoGGxcmNOuP2U2be31NEgfcdfaHw0CrCXFzJNfUIy7TLat
        q48zkKfR7p6ejx2ZKRnjR5G7+w==
X-Google-Smtp-Source: ABdhPJxDO8NG2fc7zGONtuqoTiifZZtH3+1350O31j7lSlMYvAv4BMIz1arfl3lcKRJzm9x/hWkPkw==
X-Received: by 2002:aa7:8d54:0:b0:4e0:bd6:cfb9 with SMTP id s20-20020aa78d54000000b004e00bd6cfb9mr1152383pfe.60.1648058553255;
        Wed, 23 Mar 2022 11:02:33 -0700 (PDT)
Received: from archlinux.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id l19-20020a17090aec1300b001c7a31ba88csm1265870pjy.1.2022.03.23.11.02.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Mar 2022 11:02:32 -0700 (PDT)
From:   Andy Chiu <andy.chiu@sifive.com>
To:     radhey.shyam.pandey@xilinx.com, robert.hancock@calian.com,
        michal.simek@xilinx.com
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        robh+dt@kernel.org, linux@armlinux.org.uk, andrew@lunn.ch,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        robh@kernel.org, Andy Chiu <andy.chiu@sifive.com>,
        Greentime Hu <greentime.hu@sifive.com>
Subject: [PATCH v5 net 1/4] net: axienet: setup mdio unconditionally
Date:   Thu, 24 Mar 2022 02:00:19 +0800
Message-Id: <20220323180022.864567-2-andy.chiu@sifive.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220323180022.864567-1-andy.chiu@sifive.com>
References: <20220323180022.864567-1-andy.chiu@sifive.com>
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
Reviewed-by: Robert Hancock <robert.hancock@calian.com>
---
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index 377c94ec2486..93be1adc303f 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -2060,15 +2060,14 @@ static int axienet_probe(struct platform_device *pdev)
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

