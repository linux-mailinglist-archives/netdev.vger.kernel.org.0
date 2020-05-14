Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 169B01D2954
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 10:00:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726647AbgENIA0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 04:00:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726444AbgENIAY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 04:00:24 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AF80C05BD0A
        for <netdev@vger.kernel.org>; Thu, 14 May 2020 01:00:22 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id j5so2638797wrq.2
        for <netdev@vger.kernel.org>; Thu, 14 May 2020 01:00:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=A3BhZ5w2nZuK3+ZudhXc+00fKQMrXVNQ6trbR5U2M5Y=;
        b=JJCxO3Exc7DnGIwr2iuuQUzDbvfOLbZbgPpv5L3N74cFZsgnyJHeo5Sc60JJTq+MbP
         XwFLwQsDTsS0wGHd4KAwQHWKbM9MwDOMb86EwwIBhrl0F6j84h5tjc2/n3ZabjTtMh9D
         ky3W3TQ+YF5EhKOyDkGQ3o2KIlO7tbPkHLOmpD4Nrk5F1S5+YN1zv+gHWLHEzDcrxu+g
         rabtnGA8f9E8JFjGQkbJ2p0Qn0ZRvcwuKhqf+n5uk9hGMcmu+GqfDrq5yfic4Rk4Cv04
         Tu/m1I679dB1PLq36SC+1yxLv5TcGKGsz+b/f+0RUtSrRVXjYdBuloDHyilE/A1AhdW4
         cHAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=A3BhZ5w2nZuK3+ZudhXc+00fKQMrXVNQ6trbR5U2M5Y=;
        b=N8QI0DuRAhGdRag3PK3+zDm3lhybvSxOXeqZKlKMuGCxShhN8+yk0fscooc/VxMamb
         p0m2De8nVaPRUZbN5wCwXQP3NG57OxkANSAa6nLZQWlDtGcPrCjGDNqop+IIyo2U4+qF
         JuJiQad5YXHq0MhVzLGFCj3XwCq1elPOHC3YqqrMU/Qa7P8ozrZCGzYoQhsqScCp5Rh4
         07aAU68tbsKxRzpKOaSxZNLcUmDy8IJMcOkgoRKotrqFkrgX31yMv3Aw436ed9rnMKN8
         NqKuBGMYmBZYFak4yI8ObK7MrPJwcpO61TgSHLMpcHCgElruBzvIrn8r26hv2DlDZ9G5
         /Vbw==
X-Gm-Message-State: AOAM533GQV3bn21dVoxc7AQlhm780iR1SxQkwKNViaJxfxwJt/8onvfi
        Ua2BlBh+kDeGO0xbKRJfHqHKCA==
X-Google-Smtp-Source: ABdhPJwQsAtFFDpkxmlp3HoBK9HFLKTyKPF/9otGNSorLEiCutYPpPt/Uz19BtSeOpUqWag0enyEZw==
X-Received: by 2002:a5d:400f:: with SMTP id n15mr4090320wrp.419.1589443221364;
        Thu, 14 May 2020 01:00:21 -0700 (PDT)
Received: from localhost.localdomain (lfbn-nic-1-65-232.w2-15.abo.wanadoo.fr. [2.15.156.232])
        by smtp.gmail.com with ESMTPSA id 81sm23337446wme.16.2020.05.14.01.00.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 May 2020 01:00:20 -0700 (PDT)
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
Subject: [PATCH v3 11/15] ARM64: dts: mediatek: add pericfg syscon to mt8516.dtsi
Date:   Thu, 14 May 2020 09:59:38 +0200
Message-Id: <20200514075942.10136-12-brgl@bgdev.pl>
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

