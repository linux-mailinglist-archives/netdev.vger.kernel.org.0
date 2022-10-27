Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37F4160FB48
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 17:09:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236089AbiJ0PJS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 11:09:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236041AbiJ0PJB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 11:09:01 -0400
Received: from wout2-smtp.messagingengine.com (wout2-smtp.messagingengine.com [64.147.123.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DA5E18F90C;
        Thu, 27 Oct 2022 08:08:49 -0700 (PDT)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id E7451320094E;
        Thu, 27 Oct 2022 11:08:47 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Thu, 27 Oct 2022 11:08:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=svenpeter.dev;
         h=cc:cc:content-transfer-encoding:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to; s=fm3; t=1666883327; x=
        1666969727; bh=vC4bjdi+ygr9v5m5Yqm8eJBkV8nUrE46VnfGZgrrnXA=; b=j
        p/zLFzA/S0Ieb51w4yelPFoj8AEpzTsUAhhfN4HhR5OYrebREObf97AiybkW66mw
        3EBUMm05890NRADJobcavQS6iuybBjAkWd5Pt/TIgW55bozGpec2+uozbRkru/59
        4a4PMwTPBx7LPGnOhRn+H0Zgi2m1Kgdh6T2zWhImIenBkhLGZCUfPVlrbAzNuI0m
        HQ0CY22iwGq7owaQUiWc0+7NTsylTQFwzKb0aalJm5y3+vt8xM8WLxcBbFfIQ2Re
        AkHaEVjOBSCkn4kWxN0URoBrQ9tXMrzqipczdRj6S91u0ZYZAzn5VCHV7GR+sdYX
        D6s17/Lq7o1Iyjv+FFEWA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; t=1666883327; x=1666969727; bh=vC4bjdi+ygr9v
        5m5Yqm8eJBkV8nUrE46VnfGZgrrnXA=; b=RNSrpmU7GLbZIVCtE1QZW5+WEFrf3
        Lcu8y7kJ6GVGHl+xqGzuZX6zcb47YYAqw0xQ8nYiwPtx7m6yK3XZ3g5mqrCYzaeq
        W3Rw/pe1UH7EY6dfFncjA95uox25uaXrCq0TYwPjOCU8IUvVb21D8C+NnjnbflvE
        gKG1siI+rPUtnXznDP8w86JkAiklEAjOPw5oD1ZY6fjnvbCtARcpXl0zKgZkgo9/
        MNqaYZH/7UOfPpfgrY36m54a3BedVYvsmizJtEjDEMqLdEi3x2lmsUGCb+lNYX7w
        L25zKUu53SgBhqpJpF6tMXk/8lkUkFNzip3JOTKObPS1ekWgiuro3XawQ==
X-ME-Sender: <xms:_p5aYwQQ3Np5jzuzF1IHMvPlxuJ6N-yk-BnVvdc04amBP_tztVuheQ>
    <xme:_p5aY9yFvGmMvVRC-eK66nMtTNX1dVaI7Y44WZ3i0Fb0PoAxxMwKeL2ClDhKyLcqT
    jDPxBILpxmbKKCYFqQ>
X-ME-Received: <xmr:_p5aY93-uIt958-8Vmqqt1N2TorPL5PUt3T5q7TSdXFu0OuRbgFo-CyBzEwwIF_s41dGwFCAqf714g-mGMPIJdvEeIohspsg8M3NcxPHHyfuGR5rKls98aY>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvgedrtdeggdekfecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefhvfevufffkffojghfggfgsedtkeertdertddtnecuhfhrohhmpefuvhgvnhcu
    rfgvthgvrhcuoehsvhgvnhesshhvvghnphgvthgvrhdruggvvheqnecuggftrfgrthhtvg
    hrnhepjeeiheehkeegvdejhfevkeejgfdutdefhfethedtieffleekieeuudefleekjeeg
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepshhvvg
    hnsehsvhgvnhhpvghtvghrrdguvghv
X-ME-Proxy: <xmx:_p5aY0B-XpE_wxv7eH6zE8uyx-8PX51d4IQF2A81eBhGjdhqzcq-UA>
    <xmx:_p5aY5gF7el4waQ--A3uJOZCzUugsKo1huzV08D9Z47hUs5yyE7Drg>
    <xmx:_p5aYwqO-AWcWLyFSZoSuCCG5276yBUE8YIl7nOkHvjXjXFPjHWgHg>
    <xmx:_55aY4RSgjMIuKN6QWtZ92PPCoMeEwumv4K6Z237cc_6yGjv4SRGYg>
Feedback-ID: i51094778:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 27 Oct 2022 11:08:44 -0400 (EDT)
From:   Sven Peter <sven@svenpeter.dev>
To:     Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Cc:     Sven Peter <sven@svenpeter.dev>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Hector Martin <marcan@marcan.st>,
        Alyssa Rosenzweig <alyssa@rosenzweig.io>,
        asahi@lists.linux.dev, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 3/7] arm64: dts: apple: t8103: Add Bluetooth controller
Date:   Thu, 27 Oct 2022 17:08:18 +0200
Message-Id: <20221027150822.26120-4-sven@svenpeter.dev>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
In-Reply-To: <20221027150822.26120-1-sven@svenpeter.dev>
References: <20221027150822.26120-1-sven@svenpeter.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add bluetooth controller nodes and the required brcm,board-type
properties to be able to select the correct firmware to all board
device trees.

Signed-off-by: Sven Peter <sven@svenpeter.dev>
---
 arch/arm64/boot/dts/apple/t8103-j274.dts  | 4 ++++
 arch/arm64/boot/dts/apple/t8103-j293.dts  | 4 ++++
 arch/arm64/boot/dts/apple/t8103-j313.dts  | 4 ++++
 arch/arm64/boot/dts/apple/t8103-j456.dts  | 4 ++++
 arch/arm64/boot/dts/apple/t8103-j457.dts  | 4 ++++
 arch/arm64/boot/dts/apple/t8103-jxxx.dtsi | 8 ++++++++
 6 files changed, 28 insertions(+)

diff --git a/arch/arm64/boot/dts/apple/t8103-j274.dts b/arch/arm64/boot/dts/apple/t8103-j274.dts
index c1f3ba9c39f6..b52ddc409893 100644
--- a/arch/arm64/boot/dts/apple/t8103-j274.dts
+++ b/arch/arm64/boot/dts/apple/t8103-j274.dts
@@ -21,6 +21,10 @@ aliases {
 	};
 };
 
+&bluetooth0 {
+	brcm,board-type = "apple,atlantisb";
+};
+
 &wifi0 {
 	brcm,board-type = "apple,atlantisb";
 };
diff --git a/arch/arm64/boot/dts/apple/t8103-j293.dts b/arch/arm64/boot/dts/apple/t8103-j293.dts
index ecb10d237a05..151074109a11 100644
--- a/arch/arm64/boot/dts/apple/t8103-j293.dts
+++ b/arch/arm64/boot/dts/apple/t8103-j293.dts
@@ -17,6 +17,10 @@ / {
 	model = "Apple MacBook Pro (13-inch, M1, 2020)";
 };
 
+&bluetooth0 {
+	brcm,board-type = "apple,honshu";
+};
+
 &wifi0 {
 	brcm,board-type = "apple,honshu";
 };
diff --git a/arch/arm64/boot/dts/apple/t8103-j313.dts b/arch/arm64/boot/dts/apple/t8103-j313.dts
index df741737b8e6..bc1f865aa790 100644
--- a/arch/arm64/boot/dts/apple/t8103-j313.dts
+++ b/arch/arm64/boot/dts/apple/t8103-j313.dts
@@ -17,6 +17,10 @@ / {
 	model = "Apple MacBook Air (M1, 2020)";
 };
 
+&bluetooth0 {
+	brcm,board-type = "apple,shikoku";
+};
+
 &wifi0 {
 	brcm,board-type = "apple,shikoku";
 };
diff --git a/arch/arm64/boot/dts/apple/t8103-j456.dts b/arch/arm64/boot/dts/apple/t8103-j456.dts
index 8c6bf9592510..7ea27456f33c 100644
--- a/arch/arm64/boot/dts/apple/t8103-j456.dts
+++ b/arch/arm64/boot/dts/apple/t8103-j456.dts
@@ -21,6 +21,10 @@ aliases {
 	};
 };
 
+&bluetooth0 {
+	brcm,board-type = "apple,capri";
+};
+
 &wifi0 {
 	brcm,board-type = "apple,capri";
 };
diff --git a/arch/arm64/boot/dts/apple/t8103-j457.dts b/arch/arm64/boot/dts/apple/t8103-j457.dts
index fe7c0aaf7d62..8ee0ac871426 100644
--- a/arch/arm64/boot/dts/apple/t8103-j457.dts
+++ b/arch/arm64/boot/dts/apple/t8103-j457.dts
@@ -21,6 +21,10 @@ aliases {
 	};
 };
 
+&bluetooth0 {
+	brcm,board-type = "apple,santorini";
+};
+
 &wifi0 {
 	brcm,board-type = "apple,santorini";
 };
diff --git a/arch/arm64/boot/dts/apple/t8103-jxxx.dtsi b/arch/arm64/boot/dts/apple/t8103-jxxx.dtsi
index 3d15b8e2a6c1..cc2e04035763 100644
--- a/arch/arm64/boot/dts/apple/t8103-jxxx.dtsi
+++ b/arch/arm64/boot/dts/apple/t8103-jxxx.dtsi
@@ -11,6 +11,7 @@
 
 / {
 	aliases {
+		bluetooth0 = &bluetooth0;
 		serial0 = &serial0;
 		serial2 = &serial2;
 		wifi0 = &wifi0;
@@ -77,4 +78,11 @@ wifi0: network@0,0 {
 		local-mac-address = [00 00 00 00 00 00];
 		apple,antenna-sku = "XX";
 	};
+
+	bluetooth0: bluetooth@0,1 {
+		compatible = "pci14e4,5f69";
+		reg = <0x10100 0x0 0x0 0x0 0x0>;
+		/* To be filled by the loader */
+		local-bd-address = [00 00 00 00 00 00];
+	};
 };
-- 
2.25.1

