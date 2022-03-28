Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84C1A4E96BE
	for <lists+netdev@lfdr.de>; Mon, 28 Mar 2022 14:35:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242527AbiC1Mgx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Mar 2022 08:36:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232505AbiC1Mgu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Mar 2022 08:36:50 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1600F64E4
        for <netdev@vger.kernel.org>; Mon, 28 Mar 2022 05:35:10 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id s8so12464546pfk.12
        for <netdev@vger.kernel.org>; Mon, 28 Mar 2022 05:35:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qQ1E9vaYcbwB4kkyy3glJ3m1Y05xvh8o6YtkdTT7sgU=;
        b=VVp3L17Ge6XD9nWnUnODq51rprCkbWHLs5OggBtgrVRqeJJOqPzQjysXpjqGdBSCiw
         7LYmn03vj1h9ThVWJ/11ybkVfqHFAfWwbA/hECa4N70M6rnsyjhH4xYsnV+9RAajOw1l
         vOHI8XazCc9CJg1T4R4nGD6g4tSR2DjDkzp6j5bZYMHjvSO6tn+G3gQuJJHLJLyqp+tV
         Qn2T5S4nirwOQPUL/X932DYbj3P//wek6FZD58TC6iIsaWfZdMylqHKyYRlCeZ+tmP5P
         YyWVmY3r+OKF46FqJL/nDi9bWDhE2sms6Q88kEOEj+7uX6iTcWUSm/W1dnHidIU7DfTG
         ox8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qQ1E9vaYcbwB4kkyy3glJ3m1Y05xvh8o6YtkdTT7sgU=;
        b=q5VB2YpBW9dw2ac/3AbD95f/KKfA9eAonZKq31/0rAldONJ9KrUbemvRs8QGyGSknv
         XqAalNNqMr/9cXWtwypeA03upbqJfFAM8jVIGTZgmjzpe79JsUOj09RMqKRbIVhAQs8q
         vmvNeBQ+VDmq/UzQU5p3LIPcwxol4J4FQPpqurx23MQ3It7dptA+EwX7GrCWxvXRkqOC
         wAWxqfML8lQBhRuExDb4yVAii05gXSKk/fZ0Hj4g2hkuKtwgV6ieutl5P5zrcU6qPkdE
         du5eBboSf5Bv1YYTDje1CuejSmDtxsGLLgDgKbmhLtlI3yP1cVS4P22OhpeJmbDiirek
         xTIw==
X-Gm-Message-State: AOAM531110KDr26+bYsWUdKo2dAm/DEXvFKqBwbFpPGNX15Khgbb2Ued
        NXebrWOtTRmvFTYRuIZ2I/gN8g==
X-Google-Smtp-Source: ABdhPJw9B9JCzNYnhoNHh9uuHG2lGBfW7hDnJ9YCpKo0j0gxnWAZ8pTpTI9P7BNexSAyA8g95OBNPQ==
X-Received: by 2002:a63:f0d:0:b0:381:ee45:f557 with SMTP id e13-20020a630f0d000000b00381ee45f557mr10214201pgl.436.1648470909602;
        Mon, 28 Mar 2022 05:35:09 -0700 (PDT)
Received: from archlinux.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id h12-20020a056a00170c00b004fab8f3244esm16314597pfc.28.2022.03.28.05.35.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Mar 2022 05:35:09 -0700 (PDT)
From:   Andy Chiu <andy.chiu@sifive.com>
To:     radhey.shyam.pandey@xilinx.com, robert.hancock@calian.com,
        michal.simek@xilinx.com, andrew@lunn.ch
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        robh+dt@kernel.org, linux@armlinux.org.uk, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, robh@kernel.org,
        Andy Chiu <andy.chiu@sifive.com>,
        Greentime Hu <greentime.hu@sifive.com>
Subject: [PATCH v6 net 1/4] net: axienet: setup mdio unconditionally
Date:   Mon, 28 Mar 2022 20:32:35 +0800
Message-Id: <20220328123238.2569322-2-andy.chiu@sifive.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220328123238.2569322-1-andy.chiu@sifive.com>
References: <20220328123238.2569322-1-andy.chiu@sifive.com>
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

