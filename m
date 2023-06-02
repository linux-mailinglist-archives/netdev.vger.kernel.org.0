Return-Path: <netdev+bounces-7430-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3FCE67203E8
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 16:00:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EEB3B281989
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 14:00:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 284A919BA0;
	Fri,  2 Jun 2023 13:59:48 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A10619918
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 13:59:48 +0000 (UTC)
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A293C13E;
	Fri,  2 Jun 2023 06:59:46 -0700 (PDT)
Received: by mail-lf1-x12f.google.com with SMTP id 2adb3069b0e04-4f4d80bac38so2749540e87.2;
        Fri, 02 Jun 2023 06:59:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685714385; x=1688306385;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nTN3SqBStdfh47dkRHJQq2annqGcH5JYkK2qy9Njd5A=;
        b=NlIcjLaqw+UJ4KMHwtXzN9tvEZMSxzwkfvzVg988ePm1k7mdTVc3Nc6ItSknw3wLvo
         POZi029DR3dzEnfriPincsQejUzZckw1MH2qBUPxCDKliTPL59/El/Q9N9AII5rAh+Cz
         VP8yXiVo8I4yg7KHWjMJmThZNjmcqXghnnKSLtfBkeuH89RkvOG7+NeLszWIhx9nQV/7
         oCzuOsbvjbKigEnUwh3Q6dFaWebml9aG/iKhI8uKoUMLxPXTg93LkAC+AgOm9pKlMv0I
         V3Wvvi0pd/Djyx1yO7HpFE5VvKaIYbiTVCHY7D//8dVGNRJhuMYsaTV7dDI/EXhV5zdt
         9QgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685714385; x=1688306385;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nTN3SqBStdfh47dkRHJQq2annqGcH5JYkK2qy9Njd5A=;
        b=RXvHWD99IuRFbFent/VsQEmuGDFtNQ2gaeoXIfG0/NkstM5DPiOAswS8BCFriz2QF5
         wfoa0N3YTFU2VAxYSAwcESfE3MuINIURsPS59rh5t45i4Mm4uCEFvY3TW8VQhn4bWOKq
         Xnl6NxvM/LnIKT9kPzv6vnOBlYNMwCTu+wtm/G2N91uCZDRtyUrElMPOPAeJXU7ryNrV
         92pM6y75ciWjFrXb+HPnqexlB+NY2W+zoKE3EB6fIj7GypmpedbXrvPI2B9tvBrWdukE
         fxtBCdYdwV9WRto4GoU5bS6YoSA31/R0iteLR7kYj5bjv1/O2N11B+TckMnqgbyb/H0+
         gGtA==
X-Gm-Message-State: AC+VfDwiCYrXa1qQeloLm89kBfSkhcqxsrKe1wlAp/bSkw/eicmJzDRS
	YOpIcgspd3hK1/wwckU3Ayc=
X-Google-Smtp-Source: ACHHUZ7l909Tryh8qYkMllMSiYfajl6Ve8Ib66Jep6sx4kUqMNiBCc0vU3137Hc8OAifDcZmjGy9wg==
X-Received: by 2002:a2e:87d6:0:b0:2ac:819f:f73f with SMTP id v22-20020a2e87d6000000b002ac819ff73fmr68955ljj.20.1685714384802;
        Fri, 02 Jun 2023 06:59:44 -0700 (PDT)
Received: from localhost.lan (031011218106.poznan.vectranet.pl. [31.11.218.106])
        by smtp.gmail.com with ESMTPSA id e25-20020a2e8199000000b002adbf24212esm236579ljg.49.2023.06.02.06.59.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Jun 2023 06:59:44 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: Kalle Valo <kvalo@kernel.org>,
	Florian Fainelli <f.fainelli@gmail.com>
Cc: "David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Rob Herring <robh+dt@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Hauke Mehrtens <hauke@hauke-m.de>,
	Arend Van Spriel <arend@broadcom.com>,
	linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org,
	devicetree@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	bcm-kernel-feedback-list@broadcom.com,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>
Subject: [PATCH 3/3] ARM: dts: BCM5301X: Add Netgear R8000 WiFi regulator mappings
Date: Fri,  2 Jun 2023 15:59:25 +0200
Message-Id: <20230602135925.14143-3-zajec5@gmail.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20230602135925.14143-1-zajec5@gmail.com>
References: <20230602135925.14143-1-zajec5@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
	FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Rafał Miłecki <rafal@milecki.pl>

This allows setting FullMAC firmware regulatory domain.

Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
---
 arch/arm/boot/dts/bcm4709-netgear-r8000.dts | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/arch/arm/boot/dts/bcm4709-netgear-r8000.dts b/arch/arm/boot/dts/bcm4709-netgear-r8000.dts
index 14303ab521ea..3552b6deffc2 100644
--- a/arch/arm/boot/dts/bcm4709-netgear-r8000.dts
+++ b/arch/arm/boot/dts/bcm4709-netgear-r8000.dts
@@ -137,8 +137,10 @@ bridge@0,0,0 {
 		#size-cells = <2>;
 
 		wifi@0,1,0 {
+			compatible = "brcm,bcm4366-fmac", "brcm,bcm4329-fmac";
 			reg = <0x0000 0 0 0 0>;
 			ieee80211-freq-limit = <5735000 5835000>;
+			brcm,ccode-map = "JP-JP-78", "US-Q2-86";
 		};
 	};
 };
@@ -159,6 +161,19 @@ bridge@1,1,0 {
 			#address-cells = <3>;
 			#size-cells = <2>;
 
+			bridge@1,0 {
+				reg = <0x800 0 0 0 0>;
+
+				#address-cells = <3>;
+				#size-cells = <2>;
+
+				wifi@0,0 {
+					compatible = "brcm,bcm4366-fmac", "brcm,bcm4329-fmac";
+					reg = <0x0000 0 0 0 0>;
+					brcm,ccode-map = "JP-JP-78", "US-Q2-86";
+				};
+			};
+
 			bridge@1,2,2 {
 				reg = <0x1000 0 0 0 0>;
 
@@ -166,8 +181,10 @@ bridge@1,2,2 {
 				#size-cells = <2>;
 
 				wifi@1,4,0 {
+					compatible = "brcm,bcm4366-fmac", "brcm,bcm4329-fmac";
 					reg = <0x0000 0 0 0 0>;
 					ieee80211-freq-limit = <5170000 5730000>;
+					brcm,ccode-map = "JP-JP-78", "US-Q2-86";
 				};
 			};
 		};
-- 
2.35.3


