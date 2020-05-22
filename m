Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0FA41DE62B
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 14:07:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729688AbgEVMHg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 08:07:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729073AbgEVMHd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 May 2020 08:07:33 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5D01C08C5C2
        for <netdev@vger.kernel.org>; Fri, 22 May 2020 05:07:31 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id z4so8432427wmi.2
        for <netdev@vger.kernel.org>; Fri, 22 May 2020 05:07:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=A3BhZ5w2nZuK3+ZudhXc+00fKQMrXVNQ6trbR5U2M5Y=;
        b=agS9SYZmiExPn1QFT+zp3KAP7WUdbVr14uPS6nJ27iB1uTA+ehxDy0YnoR9vFVYpwe
         ejKdXTzf8HvvGvnXEBEKYv0XRMvOXLfibnVZ4RxWk+opDqL/ZcUAhJfc3z/bq9Kd+/Lv
         ruVgGtvfmDrn3JOLXqEAJ6ZeygoSjuZdHAhLF0oHaU+To5M7N4RW+0P2ItNRNBKmSbBE
         P4pXfoUCxapPvWFYEm/mn3y/hTHEXZT2TuYxVmxdofXn2xpEq3tf4L0boBEWWiTDpsO9
         6AKtCVsk83JdgrJUbOkFst5Wy7TT750YifbEa617FJS68K9UwdH1KMuj3t3gdeqwoNUh
         txoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=A3BhZ5w2nZuK3+ZudhXc+00fKQMrXVNQ6trbR5U2M5Y=;
        b=Qmvnn/5WHmMt9YabEZaaaA0m9WdWt2CLdLuvANrW6zJIL0WM8RqBNavEOzKJbR28LZ
         GCazSIwwUDkmly25Yfc8o/nkJdiL4NjN5k2lfP5e+mw/gQvcv1uDccw4dH9JN4k/SaPw
         32FO2mACjlSbGrtqw1GsKPMUjEsfNLhpcgiShY2Se9g4N9FhvIINigOFwIuboK0mRWad
         y3IBp/zkRJRlGWq5p+h39QYkbfSlQrhdc/612CBmvdrdkLNFyhGMMcPdTARWMo8qxCqB
         fgeAvC+V+e5zLh0fwqqPmny641NpAum+EQnkWNFaNvyVuHtn1Mbnir+MbBYeUahd363C
         9BZw==
X-Gm-Message-State: AOAM530OjjXprXEUaG8EuKHNKCmy4x3o0RySP3k4/u+r5AvglvgNAqhM
        ycRJCfvkN2RtdGMK5kTcgFhflg==
X-Google-Smtp-Source: ABdhPJyMDEfpWBgRlr7TcCLSZc1VpzT4+1vIWxF001lm1q4j5p/zwqQ3+nBq6019j5V6S7cI+dSStA==
X-Received: by 2002:a7b:c778:: with SMTP id x24mr13962597wmk.144.1590149250359;
        Fri, 22 May 2020 05:07:30 -0700 (PDT)
Received: from localhost.localdomain (lfbn-nic-1-65-232.w2-15.abo.wanadoo.fr. [2.15.156.232])
        by smtp.gmail.com with ESMTPSA id f128sm9946233wme.1.2020.05.22.05.07.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 May 2020 05:07:29 -0700 (PDT)
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
Subject: [PATCH v5 07/11] ARM64: dts: mediatek: add pericfg syscon to mt8516.dtsi
Date:   Fri, 22 May 2020 14:06:56 +0200
Message-Id: <20200522120700.838-8-brgl@bgdev.pl>
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

This adds support for the PERICFG register range as a syscon. This will
soon be used by the MediaTek Ethernet MAC driver for NIC configuration.

Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
---
 arch/arm64/boot/dts/mediatek/mt8516.dtsi | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm64/boot/dts/mediatek/mt8516.dtsi b/arch/arm64/boot/dts/mediatek/mt8516.dtsi
index 2f8adf042195..8cedaf74ae86 100644
--- a/arch/arm64/boot/dts/mediatek/mt8516.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8516.dtsi
@@ -191,6 +191,11 @@ infracfg: infracfg@10001000 {
 			#clock-cells = <1>;
 		};
 
+		pericfg: pericfg@10003050 {
+			compatible = "mediatek,mt8516-pericfg", "syscon";
+			reg = <0 0x10003050 0 0x1000>;
+		};
+
 		apmixedsys: apmixedsys@10018000 {
 			compatible = "mediatek,mt8516-apmixedsys", "syscon";
 			reg = <0 0x10018000 0 0x710>;
-- 
2.25.0

