Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D47F61CDE32
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 17:09:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730443AbgEKPIi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 11:08:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730368AbgEKPIh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 11:08:37 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7F59C05BD0B
        for <netdev@vger.kernel.org>; Mon, 11 May 2020 08:08:35 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id v12so11383315wrp.12
        for <netdev@vger.kernel.org>; Mon, 11 May 2020 08:08:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=A3BhZ5w2nZuK3+ZudhXc+00fKQMrXVNQ6trbR5U2M5Y=;
        b=yQRdWTUUY8BtpgYf0O6+JxCpTQQ7YY5DMoBHZh8lfcBtgFmcmYRFvaqU5qMeGhFDWm
         CDpXAd4jp+N5aZunI52e7jbDLHpfUyC9o5by8J/55R1jm0qIu1qYfQvBHJO+tNsKWB1p
         AolpfCzCBQBM2ESWJvao6fiQ/CS9fG2NadGPhDtw4J3JQ2dJL7QuxIM/MknGHbUu5wIv
         wZY8Yr8s+nmwW5TODaI1j7Uq9uLSRlxnSfYy5+qg50Ah1fgmd50NMNW6QYL9yX70K7E/
         yGbZ1CcIgQcQCmmebj6kZ2+Yp5FhiwtSlR45BZow7MfGMl2dI+79rr2j+m0UEUkUaGdI
         +pjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=A3BhZ5w2nZuK3+ZudhXc+00fKQMrXVNQ6trbR5U2M5Y=;
        b=ftE3ayq1P+dhJeg2VqO5KRlGibTfsprLYBPCotHJ/b5uoh+qtbj1yj9ZfEKwlrjg+6
         KYSLLpKdEYsgbWID3VKemhfo0brPuVaFbvafqSqGnuvmcYZ10s2dS8KhZ19kAWp2ljvx
         2Y1q1ZgKP7h7hhqm+23ToEBxEWCOWO4jtPSzPF0lIS17FRAYZxpAnlIftZfUedYHWrPy
         fmZIrt4lXqZd6H1P7S541lmyAvSR6IOC6EXFicXKqENQlCK4mpCn41mOcG/XawlTKt13
         fMTNtFOSlK6QqhdN8yLgsObudv1iDxWxPF+fbU+oy4K4qGclNMkOyHlw1z5HQlQVN5x2
         0RvQ==
X-Gm-Message-State: AGi0PuY6K7O0arhBgcJ54hODQ+U159sNwidVhPFZAQXvi4zGDrv8tTZ1
        vwH6Y5RQRWknCF4K2RBVhl+CXg==
X-Google-Smtp-Source: APiQypLYCrKbbP67ZuW6k/GvCnVZzqnJrj+rFWSiKDfJIOmzuY0m86IY8Y+0AfqHvjKqDVcpGVV22Q==
X-Received: by 2002:a5d:4f06:: with SMTP id c6mr20552983wru.12.1589209714391;
        Mon, 11 May 2020 08:08:34 -0700 (PDT)
Received: from localhost.localdomain (lfbn-nic-1-65-232.w2-15.abo.wanadoo.fr. [2.15.156.232])
        by smtp.gmail.com with ESMTPSA id 94sm3514792wrf.74.2020.05.11.08.08.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2020 08:08:33 -0700 (PDT)
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
Subject: [PATCH v2 10/14] ARM64: dts: mediatek: add pericfg syscon to mt8516.dtsi
Date:   Mon, 11 May 2020 17:07:55 +0200
Message-Id: <20200511150759.18766-11-brgl@bgdev.pl>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200511150759.18766-1-brgl@bgdev.pl>
References: <20200511150759.18766-1-brgl@bgdev.pl>
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

