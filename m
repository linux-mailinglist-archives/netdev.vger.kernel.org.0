Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21099605B5E
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 11:41:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229519AbiJTJl2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 05:41:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229867AbiJTJlZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 05:41:25 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1BB4183E04
        for <netdev@vger.kernel.org>; Thu, 20 Oct 2022 02:41:16 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id y4so939828plb.2
        for <netdev@vger.kernel.org>; Thu, 20 Oct 2022 02:41:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MAk1sPj8uS6Y5Snv3u/+4VG4lGdBQLp4u90+6Vwe3Fs=;
        b=EqeKkMQaubuaNVKiFCjJArFycc4ci1OODQUmEfJsLBvRxzOw28iOY9im71XWU3pau6
         63CFElZmmhg2vXi1tqKXARyZna0lDrY8DrDSkzeyNiG0FcUYodXzgqJAxCNytanYG5wK
         H5wvbtEg0KgAdlTA5pAeQubjbTKN85Ztk9vjh0wj6XExO8OhhcKbmqWL2jIV0N0YF8/N
         hRpGhuMvszEbtO2mJfF5aY4iRLE0TnSiFxUQSwR9KOtdQIMqq9zG6yL5/MNBJCvlam/w
         08eL1Y8GHZy1E3FNTh+3qQ+lLW56Sya4aYiKxyCY5XjM77tVdc/50QofSHHthZbPskbJ
         d5sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MAk1sPj8uS6Y5Snv3u/+4VG4lGdBQLp4u90+6Vwe3Fs=;
        b=kcCDAsH2TOrtetTN6Xzg3cx6yqhatdDAoprHqF2z3p0n7tqmVK92MkdMQ7syw7Sw76
         8WWzmramExKg/yMgJvBv+vOMQIVWfBKNrqmMKnB0Y9iJyNTl++unPNg6rRYszOM67JhR
         lSJOsd9lOs0oe/znTjyuiUgz1yRSjQ/zlMaby1gEZGxlt+tCW+Y0XKos0qfclvFiLKs2
         9Ijyj437yHqWqZg86JqHnPfCx6hgWbR73HEKmmd+d4AG0Pze4gSP//tTXmjjTIp/PfGF
         xhqHWHzdZmD9qgIctwy8YFDfv/WjA60Ldu84XSbmiPdPQOwjR8rY6cmR8HvxSgDctxZO
         lANA==
X-Gm-Message-State: ACrzQf0iax9YfYCs5Lw7HO1g2JL3EIwWKZ8cCihRnBmYo0FYRfGNu7Xg
        2jgX3pwityAt1Du9lwej2uRSGw==
X-Google-Smtp-Source: AMsMyM4P3IKsg2wslCeJuhY4BUsKVntSp9uAuDJJtrhkPakUF6JHjXjj8ZoviVt6up2m7pnVUUMdMQ==
X-Received: by 2002:a17:90a:c306:b0:211:8e5e:9a66 with SMTP id g6-20020a17090ac30600b002118e5e9a66mr3753662pjt.152.1666258875668;
        Thu, 20 Oct 2022 02:41:15 -0700 (PDT)
Received: from archlinux.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id o12-20020a170902d4cc00b0016d9d6d05f7sm12425675plg.273.2022.10.20.02.41.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Oct 2022 02:41:15 -0700 (PDT)
From:   Andy Chiu <andy.chiu@sifive.com>
To:     davem@davemloft.net, kuba@kernel.org, michal.simek@xilinx.com,
        radhey.shyam.pandey@xilinx.com
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        krzysztof.kozlowski+dt@linaro.org, robh+dt@kernel.org,
        pabeni@redhat.com, edumazet@google.com, andy.chiu@sifive.com,
        greentime.hu@sifive.com
Subject: [PATCH net-next 1/2] net:xilinx_axi: set mdio frequency according to DT
Date:   Thu, 20 Oct 2022 17:41:05 +0800
Message-Id: <20221020094106.559266-2-andy.chiu@sifive.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20221020094106.559266-1-andy.chiu@sifive.com>
References: <20221020094106.559266-1-andy.chiu@sifive.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some FPGA platforms has 80KHz MDIO bus frequency constraint when
conecting Ethernet to its on-board external Marvell PHY. Thus, we may
have to set MDIO clock according to the DT. Otherwise, use the default
2.5 MHz, as specified by 802.3, if the entry is not present.

Signed-off-by: Andy Chiu <andy.chiu@sifive.com>
Reviewed-by: Greentime Hu <greentime.hu@sifive.com>
---
 .../net/ethernet/xilinx/xilinx_axienet_mdio.c | 25 ++++++++++++++++---
 1 file changed, 21 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_mdio.c b/drivers/net/ethernet/xilinx/xilinx_axienet_mdio.c
index 0b3b6935c558..d07c39d3bcf0 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_mdio.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_mdio.c
@@ -18,6 +18,7 @@
 #include "xilinx_axienet.h"
 
 #define MAX_MDIO_FREQ		2500000 /* 2.5 MHz */
+#define MDIO_CLK_DIV_MASK	0x3f /* bits[5:0] */
 #define DEFAULT_HOST_CLOCK	150000000 /* 150 MHz */
 
 /* Wait till MDIO interface is ready to accept a new transaction.*/
@@ -155,7 +156,9 @@ static int axienet_mdio_write(struct mii_bus *bus, int phy_id, int reg,
  **/
 int axienet_mdio_enable(struct axienet_local *lp)
 {
+	u32 clk_div;
 	u32 host_clock;
+	u32 mdio_freq;
 
 	lp->mii_clk_div = 0;
 
@@ -184,6 +187,13 @@ int axienet_mdio_enable(struct axienet_local *lp)
 			    host_clock);
 	}
 
+	if (of_property_read_u32(lp->dev->of_node, "xlnx,mdio-freq",
+				 &mdio_freq)) {
+		mdio_freq = MAX_MDIO_FREQ;
+		netdev_info(lp->ndev, "Setting default mdio clock to %u\n",
+			    mdio_freq);
+	}
+
 	/* clk_div can be calculated by deriving it from the equation:
 	 * fMDIO = fHOST / ((1 + clk_div) * 2)
 	 *
@@ -209,13 +219,20 @@ int axienet_mdio_enable(struct axienet_local *lp)
 	 * "clock-frequency" from the CPU
 	 */
 
-	lp->mii_clk_div = (host_clock / (MAX_MDIO_FREQ * 2)) - 1;
+	clk_div = (host_clock / (mdio_freq * 2)) - 1;
 	/* If there is any remainder from the division of
-	 * fHOST / (MAX_MDIO_FREQ * 2), then we need to add
+	 * fHOST / (mdio_freq * 2), then we need to add
 	 * 1 to the clock divisor or we will surely be above 2.5 MHz
 	 */
-	if (host_clock % (MAX_MDIO_FREQ * 2))
-		lp->mii_clk_div++;
+	if (host_clock % (mdio_freq * 2))
+		clk_div++;
+
+	/* Check for overflow of mii_clk_div */
+	if (clk_div & ~MDIO_CLK_DIV_MASK) {
+		netdev_dbg(lp->ndev, "MDIO clock divisor overflow, setting to maximum value\n");
+		clk_div = MDIO_CLK_DIV_MASK;
+	}
+	lp->mii_clk_div = (u8)clk_div;
 
 	netdev_dbg(lp->ndev,
 		   "Setting MDIO clock divisor to %u/%u Hz host clock.\n",
-- 
2.36.0

