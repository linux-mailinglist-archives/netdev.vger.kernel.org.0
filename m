Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A4F2520003
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 16:38:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237424AbiEIOlK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 10:41:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237417AbiEIOkk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 10:40:40 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0524E1D7341
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 07:36:47 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id a14-20020a7bc1ce000000b00393fb52a386so10917714wmj.1
        for <netdev@vger.kernel.org>; Mon, 09 May 2022 07:36:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=solid-run-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=UVdywUTBgu9XAfLc/SG8dfQa8tykDs7XjfwadMtClU0=;
        b=PHgQC67xpgKJJd2BYvnVQu83taeX0Gu37NlE/vdcRclHm+nQnHt5w64w+F6KLK4FUJ
         +3E3R3DL8ma5qNMeGG+Y88GQF3pPLSLVpLR1vaxaRbBZLvUCNGNjoFwOwG4o2hy74Tz/
         MoIy7rZqyvqrGnzAEzAY3NDRkk+qtk1jQ2204oEXljQby1JTJDCnVR6Z/jUVGD6wiW5k
         UAhFYmQecdgmA/gWudzgq+N2ypH7BONpBPNwIhZeoYo630yckTH9iJtNGrv33TahOLyE
         LHL8iBUeSbxPlq7EqMINPhigcRVeMfdCsMn0uXV4gyzJXGmk1gebUac8p4LKkO/s7gBC
         ArHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UVdywUTBgu9XAfLc/SG8dfQa8tykDs7XjfwadMtClU0=;
        b=W/XhNB+9+QaKxh1sOQh3LZD9atToHke3A6hBX25QM2Z/q5hFwJ3O0GmdROS8pgolGd
         qp88tyLR3r1qRrO9jEIRufSQq7z5Qq9JRPuHI2NtSGG5S1SF5f3fHnlqlh1O+ukN6jKP
         K3/ytdhkX7FvCpZr/hC3SuLSTfLmsz9Ao8lH6qen9Zd5gON9lkhIZja8IzMLhUNEAO+C
         gSmRDXEF82yaEmHoW/H37J0ca5DxZUDAsp5Z5rXptU76DanKeItp15zgZh2nb+G9a/mI
         8iw7CUm+Kvg1sKJAd0M/PpFhnAOSz6mOhftjZj4NbJxAdTWR6VzT5HEroOcmPbW9Sjvu
         KXHg==
X-Gm-Message-State: AOAM531iKGBuEbTgeV4eO3DmgDum59C98PoeXPY5GP8g4Z6SQCGeAg1d
        4vGHB9dE6Z1UwGP4g628vB48/A0W7cHLPgF/0maW1w==
X-Google-Smtp-Source: ABdhPJylZ63z2aku3hTebhCVMv4XDXiBTc6kkmu914sTUqbsSLpDi5DnJhu+DZ0+0AQN+AybSInknA==
X-Received: by 2002:a05:600c:1e23:b0:394:6133:a746 with SMTP id ay35-20020a05600c1e2300b003946133a746mr16399264wmb.17.1652107005300;
        Mon, 09 May 2022 07:36:45 -0700 (PDT)
Received: from josua-work.lan (bzq-82-81-222-124.cablep.bezeqint.net. [82.81.222.124])
        by smtp.gmail.com with ESMTPSA id x18-20020adfdd92000000b0020c5253d915sm11121155wrl.97.2022.05.09.07.36.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 May 2022 07:36:44 -0700 (PDT)
From:   Josua Mayer <josua@solid-run.com>
To:     netdev@vger.kernel.org
Cc:     alvaro.karsz@solid-run.com, Josua Mayer <josua@solid-run.com>,
        Russell King <linux@armlinux.org.uk>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>
Subject: [PATCH v4 3/3] ARM: dts: imx6qdl-sr-som: update phy configuration for som revision 1.9
Date:   Mon,  9 May 2022 17:36:35 +0300
Message-Id: <20220509143635.26233-4-josua@solid-run.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220509143635.26233-1-josua@solid-run.com>
References: <20220428082848.12191-1-josua@solid-run.com>
 <20220509143635.26233-1-josua@solid-run.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since SoM revision 1.9 the PHY has been replaced with an ADIN1300,
add an entry for it next to the original.

As Russell King pointed out, additional phy nodes cause warnings like:
mdio_bus 2188000.ethernet-1: MDIO device at address 1 is missing
To avoid this the new node has its status set to disabled. U-Boot will
be modified to enable the appropriate phy node after probing.

The existing ar8035 nodes have to stay enabled by default to avoid
breaking existing systems when they update Linux only.

Co-developed-by: Alvaro Karsz <alvaro.karsz@solid-run.com>
Signed-off-by: Alvaro Karsz <alvaro.karsz@solid-run.com>
Signed-off-by: Josua Mayer <josua@solid-run.com>
---
V2 -> V3: new phy node status set disabled
V1 -> V2: changed dts property name

 arch/arm/boot/dts/imx6qdl-sr-som.dtsi | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/arm/boot/dts/imx6qdl-sr-som.dtsi b/arch/arm/boot/dts/imx6qdl-sr-som.dtsi
index f86efd0ccc40..ce543e325cd3 100644
--- a/arch/arm/boot/dts/imx6qdl-sr-som.dtsi
+++ b/arch/arm/boot/dts/imx6qdl-sr-som.dtsi
@@ -83,6 +83,16 @@ ethernet-phy@4 {
 			qca,clk-out-frequency = <125000000>;
 			qca,smarteee-tw-us-1g = <24>;
 		};
+
+		/*
+		 * ADIN1300 (som rev 1.9 or later) is always at address 1. It
+		 * will be enabled automatically by U-Boot if detected.
+		 */
+		ethernet-phy@1 {
+			reg = <1>;
+			adi,phy-output-clock = "125mhz-free-running";
+			status = "disabled";
+		};
 	};
 };
 
-- 
2.35.3

