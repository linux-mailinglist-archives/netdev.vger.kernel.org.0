Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26C212AFE1A
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 06:34:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728526AbgKLFdu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 00:33:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729109AbgKLEwp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Nov 2020 23:52:45 -0500
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 571E6C061A4A;
        Wed, 11 Nov 2020 20:51:45 -0800 (PST)
Received: by mail-pg1-x541.google.com with SMTP id i7so3142484pgh.6;
        Wed, 11 Nov 2020 20:51:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LCPFIFvf2WyLPPp3RLSwFmZavkgjy6AwPxXPI8M3yQg=;
        b=EIvMMINEh+BEFxDbe0YH49gcyumemLXXGE7XBBiovA639AMxFdhr0gbHb7sG1kaPkp
         YkHIaOQ4b8LDjaaQ8FPQ9xfKW3+Tmg7rnJM9wtPatGkyowG0nzBVHsvcpoddUD3etlyG
         V8Uge+VGGOH2uVglz6C5xLiIoFsJcv84IXAwLWvSvtz4C9gTTcHTEsFVl6smS8vtMOMR
         j2mBB9PSgtvWSf4UeFBkWAFtbJe+2qGW2AdGBP9cyz9vJwn5aYP470pVQkpirrUzBrmk
         bPl1SezMrWMWgPgYlFqSJYiEQ4ZuhSjfnwiEDhM0mTXMwqAu/3H/9f2oD5PB5yoHfUol
         p7XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LCPFIFvf2WyLPPp3RLSwFmZavkgjy6AwPxXPI8M3yQg=;
        b=bKcvMp824RaqG+PfgcIEI1mniI2Nd3KykLBdqkBUrhnMJ7aUyBpahKPW6wHpivlqNp
         A5dxo4k+zC4QgdoyBgTLe4F7639is9Ks6bask6SVZ7a5/vsnbSVdTTY1+kMYADNQpLSd
         5OVALHuwCa9eGqkwhht5qLuiZkoY3nvqaO9qiKOdvQaR+Kw85e84q7cqiUn6OHCaspof
         B0N4j/8eFH4pNGAYFvh2t/ShCSbIw3w4QbK6jJ2SHlCNl98fjcCeZynsfISf5XLXt3at
         6kBJvwarCMfiZE/2iHTn/JUpi/UZJeFGf23jQy2cLtmXMWPcFJcb+yKZNMZFlQoquJ51
         Si6g==
X-Gm-Message-State: AOAM533HwhdhwAUJU6DuuZKJxnK2wZmTJjRcH/8KgvYnI1NqpMxcb6nL
        +yn/urmf6hZYCHK/xUWilCI=
X-Google-Smtp-Source: ABdhPJzDvj1WVdiMKyE+tCy2yMoaEtI8ylDICmFzKQPyL77UqUkWq6lj8v3v4d3slylN83oJfROQmw==
X-Received: by 2002:a62:32c5:0:b029:158:7361:58d3 with SMTP id y188-20020a6232c50000b0290158736158d3mr26455822pfy.75.1605156704897;
        Wed, 11 Nov 2020 20:51:44 -0800 (PST)
Received: from 1G5JKC2.Broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id gk22sm4189087pjb.39.2020.11.11.20.51.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Nov 2020 20:51:44 -0800 (PST)
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
Subject: [PATCH v2 09/10] ARM: dts: NSP: Provide defaults ports container node
Date:   Wed, 11 Nov 2020 20:50:19 -0800
Message-Id: <20201112045020.9766-10-f.fainelli@gmail.com>
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

arch/arm/boot/dts/bcm958522er.dt.yaml:
ethernet-switch@36000: 'oneOf' conditional failed, one must be fixed:
            'ports' is a required property
            'ethernet-ports' is a required property
            From schema:
Documentation/devicetree/bindings/net/dsa/b53.yaml

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 arch/arm/boot/dts/bcm-nsp.dtsi    | 4 ++++
 arch/arm/boot/dts/bcm958622hr.dts | 3 ---
 arch/arm/boot/dts/bcm958623hr.dts | 3 ---
 arch/arm/boot/dts/bcm958625hr.dts | 3 ---
 arch/arm/boot/dts/bcm958625k.dts  | 3 ---
 arch/arm/boot/dts/bcm988312hr.dts | 3 ---
 6 files changed, 4 insertions(+), 15 deletions(-)

diff --git a/arch/arm/boot/dts/bcm-nsp.dtsi b/arch/arm/boot/dts/bcm-nsp.dtsi
index 09fd7e55c069..b4d2cc70afb1 100644
--- a/arch/arm/boot/dts/bcm-nsp.dtsi
+++ b/arch/arm/boot/dts/bcm-nsp.dtsi
@@ -420,6 +420,10 @@ srab: ethernet-switch@36000 {
 			status = "disabled";
 
 			/* ports are defined in board DTS */
+			ports {
+				#address-cells = <1>;
+				#size-cells = <0>;
+			};
 		};
 
 		i2c0: i2c@38000 {
diff --git a/arch/arm/boot/dts/bcm958622hr.dts b/arch/arm/boot/dts/bcm958622hr.dts
index a49c2fd21f4a..83cb877d63db 100644
--- a/arch/arm/boot/dts/bcm958622hr.dts
+++ b/arch/arm/boot/dts/bcm958622hr.dts
@@ -176,9 +176,6 @@ &srab {
 	status = "okay";
 
 	ports {
-		#address-cells = <1>;
-		#size-cells = <0>;
-
 		port@0 {
 			label = "port0";
 			reg = <0>;
diff --git a/arch/arm/boot/dts/bcm958623hr.dts b/arch/arm/boot/dts/bcm958623hr.dts
index dd6dff6452b8..4e106ce1384a 100644
--- a/arch/arm/boot/dts/bcm958623hr.dts
+++ b/arch/arm/boot/dts/bcm958623hr.dts
@@ -180,9 +180,6 @@ &srab {
 	status = "okay";
 
 	ports {
-		#address-cells = <1>;
-		#size-cells = <0>;
-
 		port@0 {
 			label = "port0";
 			reg = <0>;
diff --git a/arch/arm/boot/dts/bcm958625hr.dts b/arch/arm/boot/dts/bcm958625hr.dts
index a71371b4065e..cda6cc281e18 100644
--- a/arch/arm/boot/dts/bcm958625hr.dts
+++ b/arch/arm/boot/dts/bcm958625hr.dts
@@ -195,9 +195,6 @@ &srab {
 	status = "okay";
 
 	ports {
-		#address-cells = <1>;
-		#size-cells = <0>;
-
 		port@0 {
 			label = "port0";
 			reg = <0>;
diff --git a/arch/arm/boot/dts/bcm958625k.dts b/arch/arm/boot/dts/bcm958625k.dts
index 7782b61c51a1..ffbff0014c65 100644
--- a/arch/arm/boot/dts/bcm958625k.dts
+++ b/arch/arm/boot/dts/bcm958625k.dts
@@ -216,9 +216,6 @@ &srab {
 	status = "okay";
 
 	ports {
-		#address-cells = <1>;
-		#size-cells = <0>;
-
 		port@0 {
 			label = "port0";
 			reg = <0>;
diff --git a/arch/arm/boot/dts/bcm988312hr.dts b/arch/arm/boot/dts/bcm988312hr.dts
index edd0f630e025..3fd39c479a3c 100644
--- a/arch/arm/boot/dts/bcm988312hr.dts
+++ b/arch/arm/boot/dts/bcm988312hr.dts
@@ -184,9 +184,6 @@ &srab {
 	status = "okay";
 
 	ports {
-		#address-cells = <1>;
-		#size-cells = <0>;
-
 		port@0 {
 			label = "port0";
 			reg = <0>;
-- 
2.25.1

