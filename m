Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16E824DD501
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 08:03:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232881AbiCRHEc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 03:04:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232875AbiCRHEb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 03:04:31 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E9C8261DEF
        for <netdev@vger.kernel.org>; Fri, 18 Mar 2022 00:03:13 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id q19so4453734pgm.6
        for <netdev@vger.kernel.org>; Fri, 18 Mar 2022 00:03:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=uqDjL/1BO0nPCLpS37RaEts+BiqaEQevdv8fufq8h3I=;
        b=P01TL+Cu5pO2fT2ISQfRWcBI/flLw1t/ghIC+Kr5BbpiBR7BnibdS5IBjnAoA76e5a
         kHTkbm3KdkmeN+KokjynwKIUgvKtElFSgR3wuiaG4OdmSbEWflVE/aOPQ8X7vRjodakV
         PhJaYOPz/dTH3nnFtYsI8Q/KS/7uR5P2OI7Z9kyFMR9etqyFIcFfNfaohdNzVaHzdO1p
         FUCIyy9jKObEdwpU+DWh2XrtCLPnMCLf1ZW80EqLCRfj391hKgQZ35ZtaNjY+bf0D4y+
         QMQboyz4oWAnJhNjSN4UEehxrAq4I5wQUXNGmtVNMkz785ztQ3sxdmsmAE2S+AhSYtHI
         Fr+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uqDjL/1BO0nPCLpS37RaEts+BiqaEQevdv8fufq8h3I=;
        b=TagD9jTsBlDOqx0TFH1IxjAUfw0f75N/pMQQTAYQuqsCLjo3fS9ep5b5mRi+4PdOZG
         46g/leQOfX9t0VvoVaU/ILS+FmcJ5hEwu8+MZ7t1gZ84jMJ3qNUxXA6BbUwIwz8dLiSk
         qhwLoLgjxRp8zapty/tgl2Qu4894+0c1BBJ3eShzlMm4xnaBs0rJ555PeRoDVxkNu4LO
         TLSHB/J4DVbQi7yTFurORi5QzxSr36PItHQtDQfLgiLDWUnDACD+piNPu6ez/kvo6sGZ
         BE2y9R61FpDp5G1eAD1QEALUjwIbS3G7Pd/nkCqTB6Sfcd44kMDhp/ujadcXDAao6VKe
         AWNA==
X-Gm-Message-State: AOAM531VLz0jOxfRfwhZO7F5+WGbd/hvCu0T/AGWtwVS5WPJ5N6MnO1X
        YZDPRnof/i0Mw7HE5mmV2TiPFg==
X-Google-Smtp-Source: ABdhPJwyU6tDkheUHctRkcLKG4PEF7mikh6bFhN2PFZWA3mLQP6BDWRpGC8CIlzf4Mgi0N4ppmf+NQ==
X-Received: by 2002:a63:907:0:b0:374:b3c2:2df2 with SMTP id 7-20020a630907000000b00374b3c22df2mr6607353pgj.614.1647586992589;
        Fri, 18 Mar 2022 00:03:12 -0700 (PDT)
Received: from archlinux.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id 68-20020a621647000000b004fa763ef1easm130630pfw.125.2022.03.18.00.03.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Mar 2022 00:03:12 -0700 (PDT)
From:   Andy Chiu <andy.chiu@sifive.com>
To:     radhey.shyam.pandey@xilinx.com, robert.hancock@calian.com,
        michal.simek@xilinx.com
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        robh+dt@kernel.org, linux@armlinux.org.uk, andrew@lunn.ch,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        Andy Chiu <andy.chiu@sifive.com>,
        Greentime Hu <greentime.hu@sifive.com>
Subject: [PATCH v3 2/2] net: axiemac: use a phandle to reference pcs_phy
Date:   Fri, 18 Mar 2022 15:00:39 +0800
Message-Id: <20220318070039.108948-2-andy.chiu@sifive.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220318070039.108948-1-andy.chiu@sifive.com>
References: <20220318070039.108948-1-andy.chiu@sifive.com>
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
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index 6fd5157f0a6d..6f81d756e6c8 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -2078,7 +2078,17 @@ static int axienet_probe(struct platform_device *pdev)
 			ret = -EINVAL;
 			goto cleanup_mdio;
 		}
-		lp->pcs_phy = of_mdio_find_device(lp->phy_node);
+		np = of_parse_phandle(pdev->dev.of_node, "pcs-handle", 0);
+		if (np) {
+			lp->pcs_phy = of_mdio_find_device(np);
+			of_node_put(np);
+		} else {
+			/* Deprecated: Always use "pcs-handle" for pcs_phy.
+			 * Falling back to "phy-handle" here is only for
+			 * backward compatibility with old device trees.
+			 */
+			lp->pcs_phy = of_mdio_find_device(lp->phy_node);
+		}
 		if (!lp->pcs_phy) {
 			ret = -EPROBE_DEFER;
 			goto cleanup_mdio;
-- 
2.34.1

