Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4700A5068B2
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 12:27:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242238AbiDSKaX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Apr 2022 06:30:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242232AbiDSKaQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Apr 2022 06:30:16 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF3B029CAA
        for <netdev@vger.kernel.org>; Tue, 19 Apr 2022 03:27:33 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id r187-20020a1c44c4000000b0038ccb70e239so1231489wma.3
        for <netdev@vger.kernel.org>; Tue, 19 Apr 2022 03:27:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=solid-run-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5+tgWfRT5KkGLaLdGp3cU5SMohIsQZQInO1lK0btHuI=;
        b=lFkV7SKtYx6N+ODnzzRJ7iIK5MYy6xR2x0sV4JFfPwq5pizAlvMmJyUv6zE5Fn3XBi
         f2D+U40Dbt+b/8mzE33KWreWfursubUXyqGUUik4IhYhU1zzk5l4Iv3DnIZsPFxm0hmR
         +n0Nac/0PY++CCNHDUvpJXuhrWdJIq30ps5ml67GHypa5vm/sJe2cU2js8wysSjOc66O
         441VLqweVXJfZtfPywTupYYpOWEJ6XCXIzRQr6Xofz6udgTKwN3p0//RWWJQnLPvclf1
         QutodjQTyfXjXPEETvqGdJa9lkZ0E3y3CeM63zD3jIA+VU499Te4DeyluyofooOvbEVt
         rBDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5+tgWfRT5KkGLaLdGp3cU5SMohIsQZQInO1lK0btHuI=;
        b=sz2RPB/Vuo72OiXbiCf8zdoxGwqUdPg1EciDRO3V731q/01Gx3Lt2swNo3BkjQHvct
         BKe7HFOfu2vAnly/MmyBUwNl+cY0kaPKlEUuiZG2HhY9xOSmTuy2/JIy3eHmbUo/EEa5
         JfTmNx4enflhxcnLXqedV+3e4MmRGKoZPfyho2/QzLsvG2pZ5ApZjV3NJB1j6w07AInA
         jtyOJladZUJhmS+g+pT3luu86QDPuO114E/1mph5RmSeVS9xNVJL4HBSofVxolDGu1nI
         bKMsk5cZ24iNKc8anVjAvih217SA8+Cu9lMFmVsUR0AtzcdKD3FY5JKi0Qe/xyAUI5Hq
         VtyQ==
X-Gm-Message-State: AOAM531sVxLUBHV+fIFX9LjjSFNmaKmyiOa3mFwMeEjHXwQaU2B96Phh
        zU4HDQyZhbky8G1vCCxIrfFe3Y8wxdLHqjpc
X-Google-Smtp-Source: ABdhPJxIXCu34noO4y0ZNTDYgfcM0RwxrPuvhPKfZlcdu00kRsgWAJ4GVKbBlt7uDLBuYlMRi5oViQ==
X-Received: by 2002:a05:600c:35cf:b0:391:b474:272c with SMTP id r15-20020a05600c35cf00b00391b474272cmr15441753wmq.198.1650364052160;
        Tue, 19 Apr 2022 03:27:32 -0700 (PDT)
Received: from josua-work.lan (bzq-82-81-222-124.cablep.bezeqint.net. [82.81.222.124])
        by smtp.gmail.com with ESMTPSA id m4-20020a7bcb84000000b00389efb7a5b4sm19036166wmi.17.2022.04.19.03.27.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Apr 2022 03:27:31 -0700 (PDT)
From:   Josua Mayer <josua@solid-run.com>
To:     netdev@vger.kernel.org
Cc:     alvaro.karsz@solid-run.com, Josua Mayer <josua@solid-run.com>,
        Russell King <linux@armlinux.org.uk>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>
Subject: [PATCH v2 3/3] ARM: dts: imx6qdl-sr-som: update phy configuration for som revision 1.9
Date:   Tue, 19 Apr 2022 13:27:09 +0300
Message-Id: <20220419102709.26432-4-josua@solid-run.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220419102709.26432-1-josua@solid-run.com>
References: <20220410104626.11517-1-josua@solid-run.com>
 <20220419102709.26432-1-josua@solid-run.com>
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

Co-developed-by: Alvaro Karsz <alvaro.karsz@solid-run.com>
Signed-off-by: Alvaro Karsz <alvaro.karsz@solid-run.com>
Signed-off-by: Josua Mayer <josua@solid-run.com>
---
V1 -> V2: changed dts property name

 arch/arm/boot/dts/imx6qdl-sr-som.dtsi | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm/boot/dts/imx6qdl-sr-som.dtsi b/arch/arm/boot/dts/imx6qdl-sr-som.dtsi
index f86efd0ccc40..d46182095d79 100644
--- a/arch/arm/boot/dts/imx6qdl-sr-som.dtsi
+++ b/arch/arm/boot/dts/imx6qdl-sr-som.dtsi
@@ -83,6 +83,12 @@ ethernet-phy@4 {
 			qca,clk-out-frequency = <125000000>;
 			qca,smarteee-tw-us-1g = <24>;
 		};
+
+		/* ADIN1300 (som rev 1.9 or later) */
+		ethernet-phy@1 {
+			reg = <1>;
+			adi,phy-output-clock = "125mhz-free-running";
+		};
 	};
 };
 
-- 
2.34.1

