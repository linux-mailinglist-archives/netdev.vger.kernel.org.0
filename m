Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C421261A306
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 22:14:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230104AbiKDVOD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 17:14:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229948AbiKDVNr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 17:13:47 -0400
Received: from wout3-smtp.messagingengine.com (wout3-smtp.messagingengine.com [64.147.123.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D4C84E42C;
        Fri,  4 Nov 2022 14:13:33 -0700 (PDT)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id CFADD3200929;
        Fri,  4 Nov 2022 17:13:31 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Fri, 04 Nov 2022 17:13:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=svenpeter.dev;
         h=cc:cc:content-transfer-encoding:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to; s=fm3; t=1667596411; x=
        1667682811; bh=vC4bjdi+ygr9v5m5Yqm8eJBkV8nUrE46VnfGZgrrnXA=; b=M
        SqKlNu/yBgiza4qrPIusKJiDFaBtdfTZTOIimqpL3MnjX6A920XWKPudaMCilYLi
        MnMWKkMD6JboAgW7qdOf4XsXtOUv4POuIpPu84405VEvxNLV1gDPHyBcdjfS1yEP
        sQUiFTnjSQJmr2Yz4Rvi2feGTTaLQRoMZwEdvGPYuz6YxEYLEVyl+EICGFJqODb5
        i13aCGeKOMQZl++mMSU7fQYIFca1sUIDO45aASvEQGO9b+lj3QROaWPDaFLhQuDo
        lu/o09WEHvNAgne9HK9CpUQvxMnA0k/at7SW1e7TK+P0apdGVA28SthFv2RZYbdg
        C3jhLPCwaiSharNIV4k3g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; t=1667596411; x=1667682811; bh=vC4bjdi+ygr9v
        5m5Yqm8eJBkV8nUrE46VnfGZgrrnXA=; b=I5hIgD2USr/ixa7pgK7djMSZNa9wb
        M1fz8+QtVDVmyJ0Ko3HNlHSPP6dkrWFMRsPlhEl+eFn80RmzyP8uak5zLMrRHPXA
        nB1hXst9gcgNqam9IdMxDuKVx6gpXuk9dhpfROmNAnjbdze59fX52NA31VYZsF3e
        JzoKVEeUjrRzqTo9UZbscZFVKxqnVrGA+Pb5WxyXBBSPAtyjnoATLn6I72vqgJa3
        KUu+pL1R0A7vmzs9SWCfU9y9Bi1cYkN2K6zwhMJwlEA2IHYAjKdshMn7fkATn10/
        X2L3oBxTP9Ht6rezMLMl+AgkdanQ/QkZBt0EjzwDLdFa54QLgTJbwqFlg==
X-ME-Sender: <xms:e4BlY_pFX8V56Q7r4lo2axsO4t-AfKtxWhKK3jI6-nvIndbZMCmVrA>
    <xme:e4BlY5qD3TiMGy3HpuNgS3N8VLyELx059aDoLMrFsnfHDvm28Wo8Ufh_Ut2V8uE4m
    tLv3Kx-nGO67rtKgEo>
X-ME-Received: <xmr:e4BlY8O85Q8XKbf_oj4OM_I-5YTFF_5E08Dz3vR4MzgBIWP-JSuM8kXPZVpuq7HHiKHkzeRorH3cAfWzji6iAsDphfJ2FwC6nqdJpMXYMkiYsvaN5i3n8vAmgn4ydA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvgedrvddugddugeefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhephffvvefufffkofgjfhgggfestdekredtredttdenucfhrhhomhepufhvvghn
    ucfrvghtvghruceoshhvvghnsehsvhgvnhhpvghtvghrrdguvghvqeenucggtffrrghtth
    gvrhhnpeejieehheekgedvjefhveekjefguddtfefhteehtdeiffelkeeiuedufeelkeej
    geenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehsvh
    gvnhesshhvvghnphgvthgvrhdruggvvh
X-ME-Proxy: <xmx:e4BlYy79D4-qMQXZMEeWH7r-x8l_Slzhw8nQObKlqVq9-kXD2CXqvQ>
    <xmx:e4BlY-7k8c0z3PPqARgGwFAu5lzHcKn_6QmDYJN8nA_CRJEl4OpC3g>
    <xmx:e4BlY6jp-vPmKeGyMZuI2EDclcbKg4NDlbGHAxf6RStUJC9RERmTGw>
    <xmx:e4BlY6ocbdQ7k5bZZvQFUDKOIm-qyVLaqsCk2u-CVHTJf_s4rk0HGQ>
Feedback-ID: i51094778:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 4 Nov 2022 17:13:28 -0400 (EDT)
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
Subject: [PATCH v5 3/7] arm64: dts: apple: t8103: Add Bluetooth controller
Date:   Fri,  4 Nov 2022 22:12:59 +0100
Message-Id: <20221104211303.70222-4-sven@svenpeter.dev>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
In-Reply-To: <20221104211303.70222-1-sven@svenpeter.dev>
References: <20221104211303.70222-1-sven@svenpeter.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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

