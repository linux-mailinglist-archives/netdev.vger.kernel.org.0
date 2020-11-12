Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2A5B2AFF06
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 06:43:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728441AbgKLFdl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 00:33:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729070AbgKLEvM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Nov 2020 23:51:12 -0500
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0507CC061A04;
        Wed, 11 Nov 2020 20:51:12 -0800 (PST)
Received: by mail-pl1-x642.google.com with SMTP id b3so2135473pls.11;
        Wed, 11 Nov 2020 20:51:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=eymV9DPXl6rW5fvsGqm9k7n71o4eeWLnLxjPc7ap6qE=;
        b=QJlDqZ4oGECEsJ50gzCe0WfmK3QsVgy4ErEl2hg3gpfqmLNzkTE4vzcGzI9/UAGi7k
         vFdhZgrTSzmMvrltyNiGmmLLxcmp0l0hUn2b0k2dEV7LZeYzrKF3TZ/8xf9fG3p/wWDG
         L9Kyd3uBOgiDVLPLRJHUKrbtyDe11sBgjhHdKiCPl9VQvOm2GYprvb8T7z3H4Xu7RTfY
         uPQ91ARoFJ/Xdfs/FFOo4qk6ea0viwDNjjbebyd1BjfiiZQD1MQbfEhsGOnnJ9FZIG76
         +HdKicS5qaniJKFxnbEPkcBvRCQfcTZKkXI+uv/pevRHGdEUgtlxkk302qGN1+Ruq2NM
         mXGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eymV9DPXl6rW5fvsGqm9k7n71o4eeWLnLxjPc7ap6qE=;
        b=lMsJGfUB0szCAoyP4sKJC3b11DJ91sUqP8emFNbtLAL45BiIn6z6wD6Fc4dUgXpFGF
         +3O3FSuHMBNcRsoRpwxlUxr0NCW7mhKIBQ9UJ0cVskrhV3J+Zf+Jadzi3RsvCVr02ppg
         NOiQJGWN0T5GU2PtrUJYytyEy1LvnHuKtVkPjzVnhfEWgob8nEaa63mCgsYMAGQ0W7EL
         E883GfJgKvSZP95UX4Tii3OL4i8FwMtEoVu6tdyhfczz7rDx4x2kl0IcMERm8o0j4e2q
         DRt5GI8QuQgOjEhbp810tqJ6JCoyQClzrW9ftZzvlMdJTyQ7gNYl7Ds7ANcZqX0Y5fjh
         t1iw==
X-Gm-Message-State: AOAM533gyawe2VKn9fMQHQ/Cu5+/Dm67alcnhMvxxkmteVqOrTGH6zyq
        C7xhmo0uGSS2U4eC3y93KBOHwO6xatw=
X-Google-Smtp-Source: ABdhPJxjCPbtoWPkZh5ct2SpWZgvbWBAMIA7bfNL9NoB0ZRrPjeT4pIHmHOO3HYLCKDxjI5QgxXRfA==
X-Received: by 2002:a17:902:c254:b029:d6:ac10:6d50 with SMTP id 20-20020a170902c254b02900d6ac106d50mr25648302plg.48.1605156671550;
        Wed, 11 Nov 2020 20:51:11 -0800 (PST)
Received: from 1G5JKC2.Broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id gk22sm4189087pjb.39.2020.11.11.20.51.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Nov 2020 20:51:10 -0800 (PST)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     linux-arm-kernel@lists.infradead.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        bcm-kernel-feedback-list@broadcom.com (maintainer:BROADCOM IPROC ARM
        ARCHITECTURE), Hauke Mehrtens <hauke@hauke-m.de>,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>,
        netdev@vger.kernel.org (open list:NETWORKING DRIVERS),
        devicetree@vger.kernel.org (open list:OPEN FIRMWARE AND FLATTENED
        DEVICE TREE BINDINGS), linux-kernel@vger.kernel.org (open list),
        Kurt Kanzenbach <kurt@kmk-computers.de>
Subject: [PATCH v2 05/10] ARM: dts: BCM5301X: Provide defaults ports container node
Date:   Wed, 11 Nov 2020 20:50:15 -0800
Message-Id: <20201112045020.9766-6-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201112045020.9766-1-f.fainelli@gmail.com>
References: <20201112045020.9766-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Provide an empty 'ports' container node with the correct #address-cells
and #size-cells properties. This silences the following warning:

arch/arm/boot/dts/bcm4708-asus-rt-ac56u.dt.yaml:
ethernet-switch@18007000: 'oneOf' conditional failed, one must be fixed:
        'ports' is a required property
        'ethernet-ports' is a required property
        From schema:
Documentation/devicetree/bindings/net/dsa/b53.yaml

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 arch/arm/boot/dts/bcm4708-luxul-xap-1510.dts     | 3 ---
 arch/arm/boot/dts/bcm4708-luxul-xwc-1000.dts     | 3 ---
 arch/arm/boot/dts/bcm4708-smartrg-sr400ac.dts    | 3 ---
 arch/arm/boot/dts/bcm47081-luxul-xap-1410.dts    | 3 ---
 arch/arm/boot/dts/bcm47081-luxul-xwr-1200.dts    | 3 ---
 arch/arm/boot/dts/bcm47094-linksys-panamera.dts  | 3 ---
 arch/arm/boot/dts/bcm47094-luxul-xap-1610.dts    | 3 ---
 arch/arm/boot/dts/bcm47094-luxul-xwc-2000.dts    | 3 ---
 arch/arm/boot/dts/bcm47094-luxul-xwr-3100.dts    | 3 ---
 arch/arm/boot/dts/bcm47094-luxul-xwr-3150-v1.dts | 3 ---
 arch/arm/boot/dts/bcm5301x.dtsi                  | 4 ++++
 arch/arm/boot/dts/bcm953012er.dts                | 3 ---
 12 files changed, 4 insertions(+), 33 deletions(-)

diff --git a/arch/arm/boot/dts/bcm4708-luxul-xap-1510.dts b/arch/arm/boot/dts/bcm4708-luxul-xap-1510.dts
index 810fc32f1895..766107a28d4d 100644
--- a/arch/arm/boot/dts/bcm4708-luxul-xap-1510.dts
+++ b/arch/arm/boot/dts/bcm4708-luxul-xap-1510.dts
@@ -65,9 +65,6 @@ &srab {
 	status = "okay";
 
 	ports {
-		#address-cells = <1>;
-		#size-cells = <0>;
-
 		port@0 {
 			reg = <0>;
 			label = "poe";
diff --git a/arch/arm/boot/dts/bcm4708-luxul-xwc-1000.dts b/arch/arm/boot/dts/bcm4708-luxul-xwc-1000.dts
index 7604b4480bb1..530380272a93 100644
--- a/arch/arm/boot/dts/bcm4708-luxul-xwc-1000.dts
+++ b/arch/arm/boot/dts/bcm4708-luxul-xwc-1000.dts
@@ -72,9 +72,6 @@ &srab {
 	status = "okay";
 
 	ports {
-		#address-cells = <1>;
-		#size-cells = <0>;
-
 		port@4 {
 			reg = <4>;
 			label = "lan";
diff --git a/arch/arm/boot/dts/bcm4708-smartrg-sr400ac.dts b/arch/arm/boot/dts/bcm4708-smartrg-sr400ac.dts
index abd35a518046..51c64f0b2560 100644
--- a/arch/arm/boot/dts/bcm4708-smartrg-sr400ac.dts
+++ b/arch/arm/boot/dts/bcm4708-smartrg-sr400ac.dts
@@ -122,9 +122,6 @@ &srab {
 	status = "okay";
 
 	ports {
-		#address-cells = <1>;
-		#size-cells = <0>;
-
 		port@0 {
 			reg = <0>;
 			label = "lan4";
diff --git a/arch/arm/boot/dts/bcm47081-luxul-xap-1410.dts b/arch/arm/boot/dts/bcm47081-luxul-xap-1410.dts
index 1ec655809e57..afc98234170f 100644
--- a/arch/arm/boot/dts/bcm47081-luxul-xap-1410.dts
+++ b/arch/arm/boot/dts/bcm47081-luxul-xap-1410.dts
@@ -65,9 +65,6 @@ &srab {
 	status = "okay";
 
 	ports {
-		#address-cells = <1>;
-		#size-cells = <0>;
-
 		port@4 {
 			reg = <4>;
 			label = "poe";
diff --git a/arch/arm/boot/dts/bcm47081-luxul-xwr-1200.dts b/arch/arm/boot/dts/bcm47081-luxul-xwr-1200.dts
index 04bfd58127fc..811bc371562e 100644
--- a/arch/arm/boot/dts/bcm47081-luxul-xwr-1200.dts
+++ b/arch/arm/boot/dts/bcm47081-luxul-xwr-1200.dts
@@ -113,9 +113,6 @@ &srab {
 	status = "okay";
 
 	ports {
-		#address-cells = <1>;
-		#size-cells = <0>;
-
 		port@0 {
 			reg = <0>;
 			label = "lan4";
diff --git a/arch/arm/boot/dts/bcm47094-linksys-panamera.dts b/arch/arm/boot/dts/bcm47094-linksys-panamera.dts
index 3bb3fe5bfbf8..3725f2b0d60b 100644
--- a/arch/arm/boot/dts/bcm47094-linksys-panamera.dts
+++ b/arch/arm/boot/dts/bcm47094-linksys-panamera.dts
@@ -201,9 +201,6 @@ &srab {
 	dsa,member = <0 0>;
 
 	ports {
-		#address-cells = <1>;
-		#size-cells = <0>;
-
 		port@1 {
 			reg = <1>;
 			label = "lan7";
diff --git a/arch/arm/boot/dts/bcm47094-luxul-xap-1610.dts b/arch/arm/boot/dts/bcm47094-luxul-xap-1610.dts
index 068e384b8ab7..6fa101f0a90d 100644
--- a/arch/arm/boot/dts/bcm47094-luxul-xap-1610.dts
+++ b/arch/arm/boot/dts/bcm47094-luxul-xap-1610.dts
@@ -59,9 +59,6 @@ &srab {
 	status = "okay";
 
 	ports {
-		#address-cells = <1>;
-		#size-cells = <0>;
-
 		port@0 {
 			reg = <0>;
 			label = "poe";
diff --git a/arch/arm/boot/dts/bcm47094-luxul-xwc-2000.dts b/arch/arm/boot/dts/bcm47094-luxul-xwc-2000.dts
index 9ae815ddbb4b..4f8d777ae18d 100644
--- a/arch/arm/boot/dts/bcm47094-luxul-xwc-2000.dts
+++ b/arch/arm/boot/dts/bcm47094-luxul-xwc-2000.dts
@@ -57,9 +57,6 @@ &srab {
 	status = "okay";
 
 	ports {
-		#address-cells = <1>;
-		#size-cells = <0>;
-
 		port@0 {
 			reg = <0>;
 			label = "lan";
diff --git a/arch/arm/boot/dts/bcm47094-luxul-xwr-3100.dts b/arch/arm/boot/dts/bcm47094-luxul-xwr-3100.dts
index a21b2d185596..e17e9a17fb00 100644
--- a/arch/arm/boot/dts/bcm47094-luxul-xwr-3100.dts
+++ b/arch/arm/boot/dts/bcm47094-luxul-xwr-3100.dts
@@ -108,9 +108,6 @@ &srab {
 	status = "okay";
 
 	ports {
-		#address-cells = <1>;
-		#size-cells = <0>;
-
 		port@0 {
 			reg = <0>;
 			label = "lan4";
diff --git a/arch/arm/boot/dts/bcm47094-luxul-xwr-3150-v1.dts b/arch/arm/boot/dts/bcm47094-luxul-xwr-3150-v1.dts
index 4d5c5aa7dc42..a270d6798363 100644
--- a/arch/arm/boot/dts/bcm47094-luxul-xwr-3150-v1.dts
+++ b/arch/arm/boot/dts/bcm47094-luxul-xwr-3150-v1.dts
@@ -79,9 +79,6 @@ &srab {
 	status = "okay";
 
 	ports {
-		#address-cells = <1>;
-		#size-cells = <0>;
-
 		port@0 {
 			reg = <0>;
 			label = "lan4";
diff --git a/arch/arm/boot/dts/bcm5301x.dtsi b/arch/arm/boot/dts/bcm5301x.dtsi
index a4ab3aabf8b0..7db72a2f1020 100644
--- a/arch/arm/boot/dts/bcm5301x.dtsi
+++ b/arch/arm/boot/dts/bcm5301x.dtsi
@@ -490,6 +490,10 @@ srab: ethernet-switch@18007000 {
 		status = "disabled";
 
 		/* ports are defined in board DTS */
+		ports {
+			#address-cells = <1>;
+			#size-cells = <0>;
+		};
 	};
 
 	rng: rng@18004000 {
diff --git a/arch/arm/boot/dts/bcm953012er.dts b/arch/arm/boot/dts/bcm953012er.dts
index 957468224622..52feca0fb906 100644
--- a/arch/arm/boot/dts/bcm953012er.dts
+++ b/arch/arm/boot/dts/bcm953012er.dts
@@ -69,9 +69,6 @@ &srab {
 	status = "okay";
 
 	ports {
-		#address-cells = <1>;
-		#size-cells = <0>;
-
 		port@0 {
 			reg = <0>;
 			label = "port0";
-- 
2.25.1

