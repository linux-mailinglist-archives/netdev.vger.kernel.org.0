Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B8A91DE62F
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 14:07:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729816AbgEVMHk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 08:07:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729771AbgEVMHi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 May 2020 08:07:38 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2D53C08C5C0
        for <netdev@vger.kernel.org>; Fri, 22 May 2020 05:07:37 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id c11so436497wrn.6
        for <netdev@vger.kernel.org>; Fri, 22 May 2020 05:07:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nZF4M1Ryr6CWnpRgUMWuRsLTKn/UHmWXZ3+MZTEjA0A=;
        b=w4oNVCj57ugEIKAorgiwr/6ZhMyAJS7/d21wbhVVREFgDobNnsPNnnl0wzfNPGIvcx
         iJsLaX/gM/6OJexLtHL+UEgWQ/Ie371efyRycyFoXc1owXFpLfN7trsim+yWQC8EHONE
         wl1bDzLXkJG502X4CQzRCO/pg8ANFX08KvuAYQqtybM5G33ioTSTwae0nnbCcYuBZmnf
         uXCwj7dSGhQY8fj0Xt+AjeTzbNFfuCjqTzVcG4Xb/CcRE4murxFQ+ORGDNOeANy68FdR
         4z953GHOUhZ3Mu10PtM6oFNTmDEbRv8nI2vWsi3AL7iMeAlfsOoqSoKKGRO6vlpvyYUw
         KYKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nZF4M1Ryr6CWnpRgUMWuRsLTKn/UHmWXZ3+MZTEjA0A=;
        b=Ac3pz2usobaC6hP9V0jopzs3h5gm64B91rDplW+SLusDslTm90//6BnfXG11maO6Wa
         OPNqSSeecpfHVrsG0b2Try55mvUNMeW1M0rQjLhdPNJnJOPPSMOv44uE2cA5oKap0k9Z
         PQ+hoVGNcOZbMK4zUtqiZe6L0stnMG6uTrmsHNGXEvMHoM0w7cbIWmqHVkOH1wiOKEue
         4sp17HOkAL+diMn2M4RVoEFcuwfNshA1YlbHArNdkfRSw/qaHVnX61+6d+hJazO5Yxru
         Ztq0GsKF7cfiDiQ8NNde5YGR75z+Rgq9HalBvufyXzT52NQr19LyUq6fQ1IPHx613tND
         Rbqg==
X-Gm-Message-State: AOAM530x8K8bO/mqGRjKaWBdM51HQVJG5Wtx7ois0VlJCG3RMpNCKxoe
        DRLnPIe1X75urLcB6clXLkRGqA==
X-Google-Smtp-Source: ABdhPJzSAlF/xo0X4V7amcXkOuTqudFkmEG0Vyv0vxLP8Rs1EDgRp8NvMKPwUFcm1KhlXMSc0PUCRQ==
X-Received: by 2002:adf:fccd:: with SMTP id f13mr3320501wrs.386.1590149256443;
        Fri, 22 May 2020 05:07:36 -0700 (PDT)
Received: from localhost.localdomain (lfbn-nic-1-65-232.w2-15.abo.wanadoo.fr. [2.15.156.232])
        by smtp.gmail.com with ESMTPSA id f128sm9946233wme.1.2020.05.22.05.07.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 May 2020 05:07:35 -0700 (PDT)
From:   Bartosz Golaszewski <brgl@bgdev.pl>
To:     Rob Herring <robh+dt@kernel.org>,
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
Subject: [PATCH v5 11/11] ARM64: dts: mediatek: enable ethernet on pumpkin boards
Date:   Fri, 22 May 2020 14:07:00 +0200
Message-Id: <20200522120700.838-12-brgl@bgdev.pl>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200522120700.838-1-brgl@bgdev.pl>
References: <20200522120700.838-1-brgl@bgdev.pl>
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

