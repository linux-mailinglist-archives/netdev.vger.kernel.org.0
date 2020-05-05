Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C495E1C57D6
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 16:03:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729412AbgEEOD1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 10:03:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729398AbgEEODW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 10:03:22 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 653C8C061A0F
        for <netdev@vger.kernel.org>; Tue,  5 May 2020 07:03:22 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id h9so2935089wrt.0
        for <netdev@vger.kernel.org>; Tue, 05 May 2020 07:03:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=A3BhZ5w2nZuK3+ZudhXc+00fKQMrXVNQ6trbR5U2M5Y=;
        b=hNfGjv2/etgG+8tAzkJNYt+mnC4ApvZHNSMUbk3vWQMdUyC5rAhLLs4oNMtdc8pWO/
         +cznGtdZyPWshkwy7QjHeTbd4wCTnOtTYZdvbIev5g5UseKkBk0fUo4iLnnZ75GyQs4U
         H8D34z7J3KjSeKQEdFbBCdRt9FGeNoc4MfPDf83NbPBBgB9RjME50vZ2MAWLkAP+y9y0
         7VdS+zOU/SET80n0dWqurzUFhJ5AXRUU7jpf/PNzchSdBW0yV0XHGCxGC7kOCvLp1lH8
         nMeRYEISvEOshTVVoJXnHBySh1CLyGHxNnSGV5R8sK3bF2l12XSQrqsZuVLdRaF32KT0
         P8zQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=A3BhZ5w2nZuK3+ZudhXc+00fKQMrXVNQ6trbR5U2M5Y=;
        b=tsTxN3bOc3qng+VFyj4Vml8iXXJ6Qy6oyjU0e/lBXRCeOJ7HYg1GTmHOMAyqWT23yl
         TKpFETaTf2sZvOLGwWRjYyi61Oe5ME2maCBqzZIZvY9MqQnqf3B0t8Z/IJzIVc6KCy2F
         PrC8PPkgGAOOfFuqpPw+e1hCLlA5FWvCZ2+IwHZptVfuQG4OPT1OJjcg4hYceGBkw6Fc
         k+5K89KwYFUdEpZwlWWFKauGcGqonbo4UEO+Gw4uJvddIhyTsNzZt2fdD4IxjL5sNQMY
         pRlRCxw5puEpiOgimNoY5YRJvNqK4YZ4Nym/jbu0959jif1QqmYel50VM6WsrVBXzV5p
         81fg==
X-Gm-Message-State: AGi0PubjolHsC8Uy68WjsS54klqg/59FR3T+gl/+PEaNNXbbzYA8b44M
        gTmSR2USmjrZADvCj7AalfbP5Q==
X-Google-Smtp-Source: APiQypIJAcz7+8YuVqS0Fb+BpugSz7czS+kkRMyzeeVjVlyOtSkG709fxRrSUgqXs+QH46mCuYaAyg==
X-Received: by 2002:a5d:5228:: with SMTP id i8mr3913687wra.359.1588687393914;
        Tue, 05 May 2020 07:03:13 -0700 (PDT)
Received: from localhost.localdomain (lfbn-nic-1-65-232.w2-15.abo.wanadoo.fr. [2.15.156.232])
        by smtp.gmail.com with ESMTPSA id c190sm4075755wme.4.2020.05.05.07.03.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 May 2020 07:03:13 -0700 (PDT)
From:   Bartosz Golaszewski <brgl@bgdev.pl>
To:     Rob Herring <robh+dt@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Felix Fietkau <nbd@openwrt.org>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Fabien Parent <fparent@baylibre.com>
Cc:     devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Subject: [PATCH 07/11] ARM64: dts: mediatek: add pericfg syscon to mt8516.dtsi
Date:   Tue,  5 May 2020 16:02:27 +0200
Message-Id: <20200505140231.16600-8-brgl@bgdev.pl>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200505140231.16600-1-brgl@bgdev.pl>
References: <20200505140231.16600-1-brgl@bgdev.pl>
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

