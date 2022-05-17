Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2B46529CFB
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 10:55:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243858AbiEQIzI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 04:55:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243841AbiEQIyz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 04:54:55 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EF4843AFF
        for <netdev@vger.kernel.org>; Tue, 17 May 2022 01:54:53 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id w4so23716119wrg.12
        for <netdev@vger.kernel.org>; Tue, 17 May 2022 01:54:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=solid-run-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=UVdywUTBgu9XAfLc/SG8dfQa8tykDs7XjfwadMtClU0=;
        b=BZchBGQc/GtA3wCFmG7VyrDobefRmHDj7WuZh8oYC5pFp0wodDj8SSYaxgKDFyufJU
         Rb5iN7Yw6vMedYRrJ8q61nmRv0CCqT8yaKe0cayYW1jrvCmdCIP4FN3chIG9MiTDXtDY
         u0FIPjUGTwvdpHbTg7CkF6VLPAr48Pt/ozR+mCwB2ZQX+AaJ0/aSdl/3DxGrhmc6Qj/e
         vsiKISMr8bV4aTsA7saWm+eOBCuFazlRcD+oHma8yc9f/ge7k491oy7zhrDR1sD7hFrf
         FalnO5hadudCdnySACMyUiTiYzCB7BbuyPGPLt8DiCONoRNe3GM28KnFufl6xmXspePw
         l2lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UVdywUTBgu9XAfLc/SG8dfQa8tykDs7XjfwadMtClU0=;
        b=NAGcml7VcQIYOJ60nnZI9UGRFoNzNrgEVCcoKqciYcY34tlX93IzU6eITBEwM9bxlY
         U8CwCtUgcuCP5xKpi95G4y77fkm4lAbpD+xRzFTiAuYzI4tck8TZHzl0fsd0EHust+s7
         8u1dykiDsHbnhUJ3GO75maVS96WJYCX635UAgYeQo+Yw3MbOzETcuUJc+0R0LWPJnTcs
         KsVEAlzPyUZOHPMTpM3GlX4ikUomrmBfDq1TolI7MXyarVnf0ZS6HQ/zKvSi/hDoGDt9
         xXRjF3yFUtXYiOr+cw6M90HS31+ClrYVwbbV1j478brS2EB3dLP7leMu87y2vobb9NI2
         YT4A==
X-Gm-Message-State: AOAM532mhNDVabHy25uyO5fzAMf4T+PwkUKanIB+/2DUQt+ZQynga9BI
        31L4lzlNjQUCS6bp8s+qgdSktfbKKn6EcSD8EIw=
X-Google-Smtp-Source: ABdhPJwcua4z0TLg5bABdHbXhH1PCSvqbvtfzVirJ3AkRZOO0hCBazlxjzE7V5EK2NTeJ5R/D9SYLA==
X-Received: by 2002:a5d:6802:0:b0:20d:295:cca2 with SMTP id w2-20020a5d6802000000b0020d0295cca2mr10590554wru.394.1652777691621;
        Tue, 17 May 2022 01:54:51 -0700 (PDT)
Received: from localhost.localdomain (bzq-82-81-54-179.red.bezeqint.net. [82.81.54.179])
        by smtp.gmail.com with ESMTPSA id c13-20020adfa70d000000b0020c5253d8bfsm11880386wrd.11.2022.05.17.01.54.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 May 2022 01:54:51 -0700 (PDT)
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
Subject: [PATCH v5 3/3] ARM: dts: imx6qdl-sr-som: update phy configuration for som revision 1.9
Date:   Tue, 17 May 2022 11:54:31 +0300
Message-Id: <20220517085431.3895-3-josua@solid-run.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220517085431.3895-1-josua@solid-run.com>
References: <20220517085143.3749-1-josua@solid-run.com>
 <20220517085431.3895-1-josua@solid-run.com>
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

