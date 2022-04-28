Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E193B512E99
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 10:35:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344390AbiD1IhK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 04:37:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344393AbiD1IgY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 04:36:24 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD198A6E1E
        for <netdev@vger.kernel.org>; Thu, 28 Apr 2022 01:29:18 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id s21so5679019wrb.8
        for <netdev@vger.kernel.org>; Thu, 28 Apr 2022 01:29:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=solid-run-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cv/E5yoqyGyEevSFvF+VVXMqKZJxjfaitSIn3h7asHE=;
        b=Ud5pD39oYgaUFAQLGBkT2HJp4aTmaENEKW16r9OrUV7vwTGXKn47MvaWrAttLZ67gO
         UAnwlg/QwAvqzipv7oVS23w6lIq/OND6oXWsFV6QMKDwCQgwFgrcAoR1MzpeOf3vEbX2
         WiPWwY0eSMLoU9S0SiVcUosW5Kk3O1geswYjpbjAPBfFiHgvRANe4MnSZ/r77yqJQl6y
         vNILqyfr1KEb5uBFfVZHau8Ccn51RN68dLcYupHuMK9/Vbj3ddIBWmjOAJpV/P818x/j
         Ur32stung8zQjRVuqg9b/gUV892P1jDYdLC27Y0knaWn4LThbARVw0EOCT8dmaAb+/ax
         YSyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cv/E5yoqyGyEevSFvF+VVXMqKZJxjfaitSIn3h7asHE=;
        b=d+CsvqqxvVC/HjoPeXgLsbEwJ7ajYBQWZxidxbS01k65N4hN3VddvqOjjVnJdk3dVe
         AYFAmjXxA+qqzuUhmb9PNiC/4qOPHU2Cg+3PssHDBq9SORHxOGD/jxYx2KhHge0IdALT
         mhoZFmvz4oKP0WJfX8vzjJeCsx96gDdAdVWcgdci9UHWIF3EHwdMnwKQayH/7icmrhyq
         iGnLi7d/Bw5vogIzlrgcc+Hk6UfhFrvKBqQwDoZyN84BzUZXx2nsQz05gOCyeq6unsK0
         rDfaH8/8wBzD2nb2QxBiZEMwnBY4I2hGVo/aPfyL/C0D2oBYPg6rhj8C5jLdMoEe4FXB
         dQ/g==
X-Gm-Message-State: AOAM532J3ywvD75a7KkN5KLzGEzNe8qHnjdwrvoXMVikcX3exW4TrgNV
        HALbMSQPkOCsXWRtKr7cROXh5/5izSwuucFlJ2GenQ==
X-Google-Smtp-Source: ABdhPJzbgZMWhWLRgWIxZajhO9ys3c7vf613ZFoKudJ1MPht9j9JgFM7ezSoUHzHHPFZR3jxb5D1vw==
X-Received: by 2002:adf:fc42:0:b0:20a:c45d:3767 with SMTP id e2-20020adffc42000000b0020ac45d3767mr25560165wrs.486.1651134557050;
        Thu, 28 Apr 2022 01:29:17 -0700 (PDT)
Received: from josua-work.lan (bzq-82-81-222-124.cablep.bezeqint.net. [82.81.222.124])
        by smtp.gmail.com with ESMTPSA id bj3-20020a0560001e0300b0020af3d365f4sm1876249wrb.98.2022.04.28.01.29.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Apr 2022 01:29:16 -0700 (PDT)
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
Subject: [PATCH v3 3/3] ARM: dts: imx6qdl-sr-som: update phy configuration for som revision 1.9
Date:   Thu, 28 Apr 2022 11:28:48 +0300
Message-Id: <20220428082848.12191-4-josua@solid-run.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220428082848.12191-1-josua@solid-run.com>
References: <20220419102709.26432-1-josua@solid-run.com>
 <20220428082848.12191-1-josua@solid-run.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
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
2.34.1

