Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78FA85BD284
	for <lists+netdev@lfdr.de>; Mon, 19 Sep 2022 18:50:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230204AbiISQuB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 12:50:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230107AbiISQtm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 12:49:42 -0400
Received: from out5-smtp.messagingengine.com (out5-smtp.messagingengine.com [66.111.4.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5758CFF;
        Mon, 19 Sep 2022 09:49:39 -0700 (PDT)
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id E6BC75C03FD;
        Mon, 19 Sep 2022 12:49:38 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 19 Sep 2022 12:49:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=svenpeter.dev;
         h=cc:cc:content-transfer-encoding:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to; s=fm2; t=1663606178; x=
        1663692578; bh=wxxQ6YT/4575N1Kfd9SDXQTkZm34HHJKCWYyD8NcZ7g=; b=T
        aTeBVbtBQFO4tBrKsUAG5FFkUfNSycy+kIXLwfhzWclncKsXYYaTlTRCkV7bbToq
        Rl2ylleyow2Jf/xTxgQMSvGdh5/aUJTzFZNXnk9SdOPPF4JCwn7KGVt5HsePLf33
        96HY+gsHhEMmmrYXjIREdnwnPhBT9zzYCjDCFn7FMZ8BNy7frR6D62vr3ozsCzL1
        9EuU6kWNVsEYQLJlqNgyBJrJVz72dYhb2ucwWKPQGxmwnACl1cDxFi8d/BnipcJI
        cyipsFDURZFvU3nN1ilZYPgPoG1B6GHV6iMisE1SGCgaZluk7RYB211Lr7lR1EJx
        BSuCp+1d0z6SUBNAaJYug==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm2; t=1663606178; x=1663692578; bh=wxxQ6YT/4575N
        1Kfd9SDXQTkZm34HHJKCWYyD8NcZ7g=; b=ONTmyrfKwhIvYyLEN4h6P/hVJO3ck
        N0MtNpT5uPDx1e5urwQA94CCXs2f0OLCK89vPTb4XckS9rrGWZBKTm08KUGJqVPb
        pK7sITArKb7ZnVm9/1xbZcw6EUZnO+WSSQMNPo7bbO0QwONSmf5YMiauon4AjeaW
        kxKa4KiX6wN3/IdXhPzF6TEZBXe3qbSqJKzGjLoNWNAPHan3KFl5TJfx1+oZhMut
        LN5ZJLDc5VYGfaa/I8Ds6vhQjfoCGoX3wb37PYNqNaog4SDheFejod1TffO8XmWr
        ufDvjTCQ828eCfn97p3wWPHZ3zhWpinPPW8whfEgxkiwgCYG7+xkeQiug==
X-ME-Sender: <xms:op0oY8BDX7rzH_yT1-1FQd2mzuzmM5Iyt4GkrNfURzdS_N1L9CWamw>
    <xme:op0oY-h0ZC7ZPRuEqQIlX1tGeQX9g6yKOztg5jHWl-yXZNJkQzkPvt7--xItDCzl2
    qOWB98OVN_jP7ths6Q>
X-ME-Received: <xmr:op0oY_mODu_0SNwnf77sRI_EhNn0N9zjN6R7LT2dbw-Kmo87pPZkb0AgQJoemmVr-v49ocX-zefwXJcAMXhWj4H-ecnDMgsdsxKh7htuf02Lji-CY7yNHfU>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrfedvjedguddtkecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpefhvfevufffkffojghfggfgsedtkeertdertddtnecuhfhrohhmpefuvhgv
    nhcurfgvthgvrhcuoehsvhgvnhesshhvvghnphgvthgvrhdruggvvheqnecuggftrfgrth
    htvghrnhepjeeiheehkeegvdejhfevkeejgfdutdefhfethedtieffleekieeuudefleek
    jeegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepsh
    hvvghnsehsvhgvnhhpvghtvghrrdguvghv
X-ME-Proxy: <xmx:op0oYywCFt5EAy8jjYViLZjUBGBIvBfiYxd1urFYZoFMJstYW06YlQ>
    <xmx:op0oYxQ5JrpEzff4yZPi0AbtU99AKwedB462Wn9FCYK6eLMKXUm_KA>
    <xmx:op0oY9bh5BDDRmvRzRHlfAvE24yB7i5R2Mni0iuhqQ2JGOrOJlVAVg>
    <xmx:op0oYyBp9N_fzsax1zBi_No2akUUkNWZjdiBSayI3inEpz7G4xjHkA>
Feedback-ID: i51094778:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 19 Sep 2022 12:49:36 -0400 (EDT)
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
Subject: [PATCH v3 3/7] arm64: dts: apple: t8103: Add Bluetooth controller
Date:   Mon, 19 Sep 2022 18:48:30 +0200
Message-Id: <20220919164834.62739-4-sven@svenpeter.dev>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
In-Reply-To: <20220919164834.62739-1-sven@svenpeter.dev>
References: <20220919164834.62739-1-sven@svenpeter.dev>
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
new commit in v3

 arch/arm64/boot/dts/apple/t8103-j274.dts  | 4 ++++
 arch/arm64/boot/dts/apple/t8103-j293.dts  | 4 ++++
 arch/arm64/boot/dts/apple/t8103-j313.dts  | 4 ++++
 arch/arm64/boot/dts/apple/t8103-j456.dts  | 4 ++++
 arch/arm64/boot/dts/apple/t8103-j457.dts  | 4 ++++
 arch/arm64/boot/dts/apple/t8103-jxxx.dtsi | 8 ++++++++
 6 files changed, 28 insertions(+)

diff --git a/arch/arm64/boot/dts/apple/t8103-j274.dts b/arch/arm64/boot/dts/apple/t8103-j274.dts
index 2cd429efba5b..f043237ef06b 100644
--- a/arch/arm64/boot/dts/apple/t8103-j274.dts
+++ b/arch/arm64/boot/dts/apple/t8103-j274.dts
@@ -21,6 +21,10 @@ aliases {
 	};
 };
 
+&bluetooth0 {
+	brcm,board-type = "apple,atlantisb";
+};
+
 /*
  * Force the bus number assignments so that we can declare some of the
  * on-board devices and properties that are populated by the bootloader
diff --git a/arch/arm64/boot/dts/apple/t8103-j293.dts b/arch/arm64/boot/dts/apple/t8103-j293.dts
index 49cdf4b560a3..24dbcc4dcb09 100644
--- a/arch/arm64/boot/dts/apple/t8103-j293.dts
+++ b/arch/arm64/boot/dts/apple/t8103-j293.dts
@@ -17,6 +17,10 @@ / {
 	model = "Apple MacBook Pro (13-inch, M1, 2020)";
 };
 
+&bluetooth0 {
+	brcm,board-type = "apple,honshu";
+};
+
 /*
  * Remove unused PCIe ports and disable the associated DARTs.
  */
diff --git a/arch/arm64/boot/dts/apple/t8103-j313.dts b/arch/arm64/boot/dts/apple/t8103-j313.dts
index b0ebb45bdb6f..747f04901a9d 100644
--- a/arch/arm64/boot/dts/apple/t8103-j313.dts
+++ b/arch/arm64/boot/dts/apple/t8103-j313.dts
@@ -17,6 +17,10 @@ / {
 	model = "Apple MacBook Air (M1, 2020)";
 };
 
+&bluetooth0 {
+	brcm,board-type = "apple,shikoku";
+};
+
 /*
  * Remove unused PCIe ports and disable the associated DARTs.
  */
diff --git a/arch/arm64/boot/dts/apple/t8103-j456.dts b/arch/arm64/boot/dts/apple/t8103-j456.dts
index 884fddf7d363..1a1a99665c18 100644
--- a/arch/arm64/boot/dts/apple/t8103-j456.dts
+++ b/arch/arm64/boot/dts/apple/t8103-j456.dts
@@ -21,6 +21,10 @@ aliases {
 	};
 };
 
+&bluetooth0 {
+	brcm,board-type = "apple,capri";
+};
+
 &i2c0 {
 	hpm2: usb-pd@3b {
 		compatible = "apple,cd321x";
diff --git a/arch/arm64/boot/dts/apple/t8103-j457.dts b/arch/arm64/boot/dts/apple/t8103-j457.dts
index d7c622931627..13f086eca4a6 100644
--- a/arch/arm64/boot/dts/apple/t8103-j457.dts
+++ b/arch/arm64/boot/dts/apple/t8103-j457.dts
@@ -21,6 +21,10 @@ aliases {
 	};
 };
 
+&bluetooth0 {
+	brcm,board-type = "apple,santorini";
+};
+
 /*
  * Force the bus number assignments so that we can declare some of the
  * on-board devices and properties that are populated by the bootloader
diff --git a/arch/arm64/boot/dts/apple/t8103-jxxx.dtsi b/arch/arm64/boot/dts/apple/t8103-jxxx.dtsi
index fe2ae40fa9dd..744afae3c839 100644
--- a/arch/arm64/boot/dts/apple/t8103-jxxx.dtsi
+++ b/arch/arm64/boot/dts/apple/t8103-jxxx.dtsi
@@ -11,6 +11,7 @@
 
 / {
 	aliases {
+		bluetooth0 = &bluetooth0;
 		serial0 = &serial0;
 		serial2 = &serial2;
 		wifi0 = &wifi0;
@@ -75,4 +76,11 @@ wifi0: network@0,0 {
 		/* To be filled by the loader */
 		local-mac-address = [00 00 00 00 00 00];
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

