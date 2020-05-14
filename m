Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E3DE1D295B
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 10:01:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727076AbgENIAg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 04:00:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726937AbgENIAa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 04:00:30 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D7B8C061A0F
        for <netdev@vger.kernel.org>; Thu, 14 May 2020 01:00:30 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id m24so19557460wml.2
        for <netdev@vger.kernel.org>; Thu, 14 May 2020 01:00:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nZF4M1Ryr6CWnpRgUMWuRsLTKn/UHmWXZ3+MZTEjA0A=;
        b=nXmcTgWKai8rBQ2DXas2d5H6t5IBpKKtBOFHUcEyAvlLdEQGxeg/oH6FNz59RFXfP1
         P7Qkldx/02KKtlnaijnKKo8qjlOii2FQNyb0gmqEdu8VwcCQdYj6QtgMy32fr6gphqMs
         7RJ1yCfST+TpHaSnZ1uw1gU9H+l+9GEZ4z8cIuXsToR7E6n+IZbRXPy8YZmXzcTpV4j0
         nKM0IY3O82aZcgwehgScYrbMYMQyyI2Gy90P+Et9IdpErBIOvAYByQc+cW+D49uP72Lm
         NOIOWdT1Jgd2LiHVVUqA2u2f/rYlHEJc0jXjQ0XYKT7TteUWkZPzMfha+VuT7f4ys2Ky
         tuOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nZF4M1Ryr6CWnpRgUMWuRsLTKn/UHmWXZ3+MZTEjA0A=;
        b=GeXU/2SIRGBhfUnKKrVQeh27xrTMwY1Lb7n6D6JLysqrdkMdVvln98FskS9yxncu5O
         PO6yI3X0l3zNIWj6iSP893s9poJ2n466urmlNLApPNza9NHo2dBbssvX5ZEmN6QMPVWj
         Ar/eg6cvRZQWhRQsmzqvh37+TV4Tz95iYxwlYyI3JtVcDBJz+iWmUhvg8yGyoSrfHO13
         /dKOVpNRqiidPRrpjAF+JZoUGfj/vUzC5fb09mLTNdpIZMPas98FLOXRC2Jiy80JSQ1v
         vwEQl2bUGBPnrz+2nTx/dNuyPtA9iF1O10SxypfkJsLi9EAoUDiaXP+0kK45Dz1vQv+6
         NjoQ==
X-Gm-Message-State: AGi0Pubxrd5YEXm8UlRU0YDsabVsQscYLzGzvK+qtygpNck2m31NTBNF
        klPsVYu3klz64PHcV8Hhe5LsuQ==
X-Google-Smtp-Source: APiQypLkHL0DWLpTgfSdy1BAdMqLrKiddZcunwHMW5P3bAckgztG6gV48Xmw/vqS4Ej0EtW7WbyHNQ==
X-Received: by 2002:a1c:f609:: with SMTP id w9mr46778546wmc.123.1589443229077;
        Thu, 14 May 2020 01:00:29 -0700 (PDT)
Received: from localhost.localdomain (lfbn-nic-1-65-232.w2-15.abo.wanadoo.fr. [2.15.156.232])
        by smtp.gmail.com with ESMTPSA id 81sm23337446wme.16.2020.05.14.01.00.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 May 2020 01:00:28 -0700 (PDT)
From:   Bartosz Golaszewski <brgl@bgdev.pl>
To:     Jonathan Corbet <corbet@lwn.net>, Rob Herring <robh+dt@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Fabien Parent <fparent@baylibre.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Edwin Peer <edwin.peer@broadcom.com>
Cc:     devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        Stephane Le Provost <stephane.leprovost@mediatek.com>,
        Pedro Tsai <pedro.tsai@mediatek.com>,
        Andrew Perepech <andrew.perepech@mediatek.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Subject: [PATCH v3 15/15] ARM64: dts: mediatek: enable ethernet on pumpkin boards
Date:   Thu, 14 May 2020 09:59:42 +0200
Message-Id: <20200514075942.10136-16-brgl@bgdev.pl>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200514075942.10136-1-brgl@bgdev.pl>
References: <20200514075942.10136-1-brgl@bgdev.pl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bartosz Golaszewski <bgolaszewski@baylibre.com>

Add remaining properties to the ethernet node and enable it.

Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
---
 .../boot/dts/mediatek/pumpkin-common.dtsi      | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/arch/arm64/boot/dts/mediatek/pumpkin-common.dtsi b/arch/arm64/boot/dts/mediatek/pumpkin-common.dtsi
index 4b1d5f69aba6..dfceffe6950a 100644
--- a/arch/arm64/boot/dts/mediatek/pumpkin-common.dtsi
+++ b/arch/arm64/boot/dts/mediatek/pumpkin-common.dtsi
@@ -167,6 +167,24 @@ &uart0 {
 	status = "okay";
 };
 
+&ethernet {
+	pinctrl-names = "default";
+	pinctrl-0 = <&ethernet_pins_default>;
+	phy-handle = <&eth_phy>;
+	phy-mode = "rmii";
+	mac-address = [00 00 00 00 00 00];
+	status = "okay";
+
+	mdio {
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		eth_phy: ethernet-phy@0 {
+			reg = <0>;
+		};
+	};
+};
+
 &usb0 {
 	status = "okay";
 	dr_mode = "peripheral";
-- 
2.25.0

