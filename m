Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E71591D2958
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 10:00:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726907AbgENIAa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 04:00:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726033AbgENIA0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 04:00:26 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CD27C05BD0A
        for <netdev@vger.kernel.org>; Thu, 14 May 2020 01:00:26 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id y16so2634304wrs.3
        for <netdev@vger.kernel.org>; Thu, 14 May 2020 01:00:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1qePp19LiRiOBXtccpgQ+eI6GUOhz0auoBWQ11adkXY=;
        b=A0xVcmEWRDaG3Z/7+1DM1W7TJCWEWrBCYQ3bDkOtG7yxOo/ZUzFZP8QFaxifgngVLd
         VPcWESAtBLaibbRqDQjSRWN333avDH1S/qikpFUJla/psrQR0/mq4psad2R0bwm9sge/
         pIq3J1V+u4B8Ab6r0Wg2p0wDFFRAi0ZW6OoFpmEhpyJ0xJfqoRQ/mJSzrHmE8nWarSMj
         eN8B5mppmtl2sXH+UbITdJB1fzx6mQr6iDAJNYF7raKBqVoOIdZykmoSQUJhXGsngf17
         MDZ9gFoMfcspyDCT8khDWTxlmLYUO5/Fy0svDuwQpFMSNyAXANR1fH7+E98Ef7mYQxdc
         fubw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1qePp19LiRiOBXtccpgQ+eI6GUOhz0auoBWQ11adkXY=;
        b=ebxQ//HtOLFrwfjRXka5d6Q/bhLDna/A+FKqlrwQZYXMeNsCn3zlUmn0fbLwcILOW2
         3RHIela57xHVrWjzSw5lQYF+oWCE93vbSZLXxZQykeQDYNIYUzlG+HSGxHyHiHHpaeC2
         hJvPuhr58gx+gHKM4Hf4GPoJ5uEYZrvT3BVCARn855V+eyybEE1TgjdAr7EYoIx809Tt
         AamGVu/wOumYwr/J/H3FLDcdtPQD6Ar/7uy6fcnQkMLyZmXlHe59sYB1SutT6dqjRR/p
         doZnE0TDxiidzTyKko/1VEqgXgkaRJiTjRG0/J+CL7j84mb06QgHM8OTDwLS9qz9xdgY
         uftw==
X-Gm-Message-State: AOAM530p5kiSrvfODXNctW3cNJNuNopHyTy/5nGbbm66YkzeFivvVpn5
        joLknArAeoJwMxKgIm8ZKdwGxQ==
X-Google-Smtp-Source: ABdhPJxE2Nr5gqc48KKQ7TyBu8V/dSLVZvEBAnxJMTulHZMm4c3i92GjiXIt7jmUvzDNI+9reMe0yg==
X-Received: by 2002:a05:6000:1187:: with SMTP id g7mr4053217wrx.54.1589443225024;
        Thu, 14 May 2020 01:00:25 -0700 (PDT)
Received: from localhost.localdomain (lfbn-nic-1-65-232.w2-15.abo.wanadoo.fr. [2.15.156.232])
        by smtp.gmail.com with ESMTPSA id 81sm23337446wme.16.2020.05.14.01.00.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 May 2020 01:00:24 -0700 (PDT)
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
Subject: [PATCH v3 13/15] ARM64: dts: mediatek: add an alias for ethernet0 for pumpkin boards
Date:   Thu, 14 May 2020 09:59:40 +0200
Message-Id: <20200514075942.10136-14-brgl@bgdev.pl>
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

Add the ethernet0 alias for ethernet so that u-boot can find this node
and fill in the MAC address.

Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
---
 arch/arm64/boot/dts/mediatek/pumpkin-common.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/mediatek/pumpkin-common.dtsi b/arch/arm64/boot/dts/mediatek/pumpkin-common.dtsi
index a31093d7142b..97d9b000c37e 100644
--- a/arch/arm64/boot/dts/mediatek/pumpkin-common.dtsi
+++ b/arch/arm64/boot/dts/mediatek/pumpkin-common.dtsi
@@ -9,6 +9,7 @@
 / {
 	aliases {
 		serial0 = &uart0;
+		ethernet0 = &ethernet;
 	};
 
 	chosen {
-- 
2.25.0

