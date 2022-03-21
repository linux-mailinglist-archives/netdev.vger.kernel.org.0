Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47B964E2C36
	for <lists+netdev@lfdr.de>; Mon, 21 Mar 2022 16:27:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350192AbiCUP27 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 11:28:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350202AbiCUP2x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 11:28:53 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0E6F160C06
        for <netdev@vger.kernel.org>; Mon, 21 Mar 2022 08:27:27 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id i11so12369323plr.1
        for <netdev@vger.kernel.org>; Mon, 21 Mar 2022 08:27:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=byyRM7FRPcTp0/TWjhs6tA/Rpn9nRn9/ZHQ+fneiAdg=;
        b=e8A0RJMdeku8s8Xs22hqidjph/JGEqCzluM0p1RfKcm8juV1+4CrAhmNipqkXYSvaW
         3Y0xqC/C1mLl+HIOlluKTJ5HB7wDykwPET4cSQVRSAsseNj+6QDw5gwy8lZl9Zi6nByR
         y2YNIPel0XgMJy+erR+Ni13RuFhsiyHVwi6LUzqIWDran2cES3KieXacc3r9ipSqe4qE
         Us4aJoFowC33UjcPmzUMeyDji6sYyrUcKq4bt9ec87y3ijrtbzhm3RN1WbJR6EM1GRsV
         9GwP7y08lmrr007OyteCJUTvlDa4qP8Dmkh3UHv03QZ0PMPCw+VjS9YYQq1MnOcnjiGy
         yl4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=byyRM7FRPcTp0/TWjhs6tA/Rpn9nRn9/ZHQ+fneiAdg=;
        b=Y9WvotBw+6tYRBMRNb2FHRPtA2WkfEZR+0cyuGo7iBTcJHq/AHrd8g4CP3fcAooCqm
         OT8xL5kmI/W51k2bKz8/FPwkDuHIR1eBdc6iFtPhowBFhinzDrOzM8aVWeIgRFGawLv+
         Pt2a3LnCnCOQsa1k/ZPXf7FgA9Pjxz6uOn32lOjRkVwfqeRTghzMM5eFX07c8VWiVtH7
         8b485hHDPGaa2N5L3euxR5yWcICFT+lrIO03PoU0iW9WaVkBsSxaHt6tBCqURsb+S8Tj
         rqgeCAjsvOdQk5UKu53yO51HFpWct7BBwIQroJ6MlI+qaMVYS68sy9tJNHNODwJLoUo5
         Wifw==
X-Gm-Message-State: AOAM530t8cl/Py2u60uW5bMyIImkk/zNdp0ddPUlETHFwuiiCFhsyIOB
        fjuVR7nTRcshrxcgHt5Uqa3H/A==
X-Google-Smtp-Source: ABdhPJznwl4ki1kBF4LNxWVBRGlWNXhrqi3Ku39jK3D4COpS1ubm0QiSPvp7jK2IbWkcGMQChutNow==
X-Received: by 2002:a17:903:234c:b0:154:317:3828 with SMTP id c12-20020a170903234c00b0015403173828mr13478816plh.123.1647876447455;
        Mon, 21 Mar 2022 08:27:27 -0700 (PDT)
Received: from archlinux.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id i15-20020a63b30f000000b003803aee35a2sm15342644pgf.31.2022.03.21.08.27.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Mar 2022 08:27:27 -0700 (PDT)
From:   Andy Chiu <andy.chiu@sifive.com>
To:     radhey.shyam.pandey@xilinx.com, robert.hancock@calian.com,
        michal.simek@xilinx.com
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        robh+dt@kernel.org, linux@armlinux.org.uk, andrew@lunn.ch,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        Andy Chiu <andy.chiu@sifive.com>,
        Greentime Hu <greentime.hu@sifive.com>
Subject: [PATCH v4 4/4] net: axiemac: use a phandle to reference pcs_phy
Date:   Mon, 21 Mar 2022 23:25:15 +0800
Message-Id: <20220321152515.287119-4-andy.chiu@sifive.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220321152515.287119-1-andy.chiu@sifive.com>
References: <20220321152515.287119-1-andy.chiu@sifive.com>
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

In some SGMII use cases where both a fixed link external PHY and the
internal PCS/PMA PHY need to be configured, we should explicitly use a
phandle "pcs-phy" to get the reference to the PCS/PMA PHY. Otherwise, the
driver would use "phy-handle" in the DT as the reference to both the
external and the internal PCS/PMA PHY.

In other cases where the core is connected to a SFP cage, we could still
point phy-handle to the intenal PCS/PMA PHY, and let the driver connect
to the SFP module, if exist, via phylink.

Fixes: 1a02556086fc (net: axienet: Properly handle PCS/PMA PHY for 1000BaseX mode)
Signed-off-by: Andy Chiu <andy.chiu@sifive.com>
Reviewed-by: Greentime Hu <greentime.hu@sifive.com>
---
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index 496a9227e760..163753508464 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -2071,9 +2071,16 @@ static int axienet_probe(struct platform_device *pdev)
 
 	if (lp->phy_mode == PHY_INTERFACE_MODE_SGMII ||
 	    lp->phy_mode == PHY_INTERFACE_MODE_1000BASEX) {
-		np = of_parse_phandle(pdev->dev.of_node, "phy-handle", 0);
+		np = of_parse_phandle(pdev->dev.of_node, "pcs-handle", 0);
 		if (!np) {
-			dev_err(&pdev->dev, "phy-handle required for 1000BaseX/SGMII\n");
+			/* Deprecated: Always use "pcs-handle" for pcs_phy.
+			 * Falling back to "phy-handle" here is only for
+			 * backward compatibility with old device trees.
+			 */
+			np = of_parse_phandle(pdev->dev.of_node, "phy-handle", 0);
+		}
+		if (!np) {
+			dev_err(&pdev->dev, "pcs-handle (preferred) or phy-handle required for 1000BaseX/SGMII\n");
 			ret = -EINVAL;
 			goto cleanup_mdio;
 		}
-- 
2.34.1

