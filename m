Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BE60569C20
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 09:49:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235133AbiGGHs4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 03:48:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234285AbiGGHsg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 03:48:36 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6789E28E13;
        Thu,  7 Jul 2022 00:48:33 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id t17-20020a1c7711000000b003a0434b0af7so10237811wmi.0;
        Thu, 07 Jul 2022 00:48:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=oh1z//JLoO/Xhoxj5qMgPiUpRrKCA2Fe0sFhmzqNLgQ=;
        b=BHT8iMi8Wo3uBbfVjI1h09go2zHMfeSMc0nUfP8tJJ1igfG/UGZqI8+jdbL+qgHFnd
         sga7grW3odh5oOVly8ZRgnF8pQleuEB3WUYuVnlRDWAPKJ8bvrcBZhWxuztS5rDbj7qs
         Yu4YGERQlFEdVAfGFHCKvxbK9JmXB4cet78x0a9P1y2btDOEhrQ8G4RqvIgKylsI7x43
         QASSsasfhgdBZgsKYQhtJ7hLkl0aKKSAqZ0jVCl3fpbjANkcC+jWD2YfWW72lMAbK/Kh
         f+cwHO2czZqVhpK5gRmwheTe2LP1RSLrOSADaNhyXuuDg09m89Ah+cKum5MmjO9Ff0Rb
         e10Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oh1z//JLoO/Xhoxj5qMgPiUpRrKCA2Fe0sFhmzqNLgQ=;
        b=svA0nYh0DRaO4I4pezIOaQTJHQwJr070ioYNa4LzM5zOcUWzQf46rBu+Ujz8wpXfxR
         BX1cZIPKOiNEUBwfufzVOEncNEJ/oOfgR0EyqI80JRL1higNyP70M/7VUKABIWaKMj9m
         FXpossS29S/kc9FbZBWCyB+03flqszTMv3ONPRACsy6+i7CJdJ8u4vxLyWQTK/SXx8cC
         H8u4l4iMHWfNKxNLoUkmvOMYd6s+io47RPXC9r9Y/SYTL1i/6aQndy0uTXUjBd0Uifgy
         fezHctGG69eDXX2DveJZHTjsdfKR4ho1nOqeBKbTOS71zyaQdtIEpiPhpXLn4wm5XwBs
         EXpA==
X-Gm-Message-State: AJIora86+y7rBc+b9SVLWLclr8UqgaD6B2Lwzfp8FLR7PDcPCWyiPW5J
        ffnu27dWZZXMR2iM6WiDvUz2VjSa6Rw=
X-Google-Smtp-Source: AGRyM1tpyk2bBtixDX+/lBP+Z4mrZSCq7CI4o6CBg1K2yMyGqBnZ/kdl0iTaRApYtqSStOPFe4bAkQ==
X-Received: by 2002:a1c:7903:0:b0:3a0:3936:b71f with SMTP id l3-20020a1c7903000000b003a03936b71fmr2938942wme.168.1657180111920;
        Thu, 07 Jul 2022 00:48:31 -0700 (PDT)
Received: from localhost (p200300e41f12c800f22f74fffe1f3a53.dip0.t-ipconnect.de. [2003:e4:1f12:c800:f22f:74ff:fe1f:3a53])
        by smtp.gmail.com with ESMTPSA id n27-20020a05600c3b9b00b003a04e900552sm1972536wms.1.2022.07.07.00.48.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jul 2022 00:48:30 -0700 (PDT)
From:   Thierry Reding <thierry.reding@gmail.com>
To:     Thierry Reding <thierry.reding@gmail.com>
Cc:     Jon Hunter <jonathanh@nvidia.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Bhadram Varka <vbhadram@nvidia.com>,
        devicetree@vger.kernel.org, linux-tegra@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH v4 7/9] arm64: tegra: Enable MGBE on Jetson AGX Orin Developer Kit
Date:   Thu,  7 Jul 2022 09:48:16 +0200
Message-Id: <20220707074818.1481776-8-thierry.reding@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220707074818.1481776-1-thierry.reding@gmail.com>
References: <20220707074818.1481776-1-thierry.reding@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

A Multi-Gigabit Ethernet (MGBE) instance drives the primary Ethernet
port on the Jetson AGX Orin Developer Kit. Enable it.

Signed-off-by: Bhadram Varka <vbhadram@nvidia.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 .../nvidia/tegra234-p3737-0000+p3701-0000.dts | 21 +++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/arch/arm64/boot/dts/nvidia/tegra234-p3737-0000+p3701-0000.dts b/arch/arm64/boot/dts/nvidia/tegra234-p3737-0000+p3701-0000.dts
index eaf1994abb04..8e2618a902ab 100644
--- a/arch/arm64/boot/dts/nvidia/tegra234-p3737-0000+p3701-0000.dts
+++ b/arch/arm64/boot/dts/nvidia/tegra234-p3737-0000+p3701-0000.dts
@@ -1976,6 +1976,27 @@ chosen {
 		stdout-path = "serial0:115200n8";
 	};
 
+	bus@0 {
+		ethernet@6800000 {
+			status = "okay";
+
+			phy-handle = <&mgbe0_phy>;
+			phy-mode = "usxgmii";
+
+			mdio {
+				#address-cells = <1>;
+				#size-cells = <0>;
+
+				mgbe0_phy: phy@0 {
+					compatible = "ethernet-phy-ieee802.3-c45";
+					reg = <0x0>;
+
+					#phy-cells = <0>;
+				};
+			};
+		};
+	};
+
 	gpio-keys {
 		compatible = "gpio-keys";
 		status = "okay";
-- 
2.36.1

