Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD37056947C
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 23:34:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234680AbiGFVd3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 17:33:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234644AbiGFVdZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 17:33:25 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49AF42AC5B;
        Wed,  6 Jul 2022 14:33:18 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id j7so9550224wmp.2;
        Wed, 06 Jul 2022 14:33:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Bds9xAu3klfQ+wqm9PCg4K3cNprnBdTynecdrif+mQQ=;
        b=c6t5zKOhSLZN28PQhH4riQFqW8ORqZJ/UTW1A9oSQjwZvoR7+A9dxmnaz8xB/NUgY2
         rrzC6DDhKYvZCcPhl+yMoMY8EdpLf5Knj7z13VKFltCGoXRTmCHXDWGet1diiuZJiYtO
         rnbcx6G94b6XkjtQqV5a7nwg0CWWwTTLwcjlnNm2jXWfpOjC9GPliZXMkRPQApTfKvEw
         dgmAgfiiNWRxtjje+W5s/uVKYGXs3cRdCzCxovgXVmUz45iSCtF0aw+ZsZJycQp/I9Wt
         IQuIgpjIQi9yk3jVdhXQlqBGBVdDt22MrVJZwUfAwY5A6qlYfpLLtygnXakIOHzZIA3Q
         QLfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Bds9xAu3klfQ+wqm9PCg4K3cNprnBdTynecdrif+mQQ=;
        b=OkxLoh0smqOF4vzyt2NvO46UDGWbKZ+jVJBadprY8WsEMSGkVYEnSYwXSlZqrxlEdt
         j6V5shViWOALW4RFkTXN9nLRWMdU+mpkXNqd4RwByIhfk6PeqIk0HxPdIvjo3ZC35DzP
         sPvVZQ0sS+hyCH8apSOlLJoZSRASS2S7QHFOg6W3rmN6YymV6/aOI7o24HaMRt0McWq6
         jVUmtnZsiu8OVjWGcZ5p0o8rRcIyZodIsnrqkf3zVXH/F7Pjq9um16wT1lw+kA/lMY2s
         dBXLXB3FVTaeoQZSvoSqgJmoV87MWFvleAaQEjCAZnTCHJ5AGaAZjzh7SuYxLCDa4ZvT
         Rprg==
X-Gm-Message-State: AJIora8CLJxxRL04Z2kWZ9Fr3Jb6fuZbThwBDqaVF8gT2xkgwEgaSlv6
        PpWovj15hD1Rs0MhN/Rd5w4=
X-Google-Smtp-Source: AGRyM1u9PJFU/8XguToPxbpTOU5b8rLXLfULnvPSPRbG8QQM+30I9Ez0Nid3ps309p+4PLtLjw0IWg==
X-Received: by 2002:a05:600c:1c84:b0:3a0:69fe:18fe with SMTP id k4-20020a05600c1c8400b003a069fe18femr677287wms.40.1657143196503;
        Wed, 06 Jul 2022 14:33:16 -0700 (PDT)
Received: from localhost (p200300e41f12c800f22f74fffe1f3a53.dip0.t-ipconnect.de. [2003:e4:1f12:c800:f22f:74ff:fe1f:3a53])
        by smtp.gmail.com with ESMTPSA id b10-20020a5d4d8a000000b0021d4aca9d1esm19192334wru.99.2022.07.06.14.33.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Jul 2022 14:33:13 -0700 (PDT)
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
Subject: [PATCH v3 7/9] arm64: tegra: Enable MGBE on Jetson AGX Orin Developer Kit
Date:   Wed,  6 Jul 2022 23:32:53 +0200
Message-Id: <20220706213255.1473069-8-thierry.reding@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220706213255.1473069-1-thierry.reding@gmail.com>
References: <20220706213255.1473069-1-thierry.reding@gmail.com>
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
index 02a10bb38562..d5e7c29837e6 100644
--- a/arch/arm64/boot/dts/nvidia/tegra234-p3737-0000+p3701-0000.dts
+++ b/arch/arm64/boot/dts/nvidia/tegra234-p3737-0000+p3701-0000.dts
@@ -2017,6 +2017,27 @@ chosen {
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

