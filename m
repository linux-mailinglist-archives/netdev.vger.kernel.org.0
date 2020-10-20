Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 325D22935E0
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 09:36:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731478AbgJTHf2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 03:35:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726754AbgJTHf2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Oct 2020 03:35:28 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 263F1C0613CE
        for <netdev@vger.kernel.org>; Tue, 20 Oct 2020 00:35:27 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id s9so833369wro.8
        for <netdev@vger.kernel.org>; Tue, 20 Oct 2020 00:35:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=OQmPt/tsW+HEDpe5xrLjZAgYGGi4SsWx2wHRRbyaLCk=;
        b=Xaj8HufkrIOIGFyU041LaS2NHh85dVEh/A6HQALiW1KbY9KP+2CGqr8G9UAg/0W3jC
         UXAlRnIEeF7em+Grap4x3/W3wOX5cIi7ubZnewRHaRHlutasP5GbCyXYnQC4TUXVcUtD
         1b2VuGvt7umuHn6fjGK5SrYKmzqmer+/O6Sb+KOChZ814gBC2thvDrwvJNtGGukLhkIF
         wmaZ8faZIfSMaVc/tzd9MBQUcRZ21kBe56EEmuurC/RFbSTTluQwfVd75d92q6CX1B49
         QOaMgS0x5cspfwhAZR+oSBKZdlV9qKk+UGQ8D/Kyh+1IPAFvkodU5dy6LBmlOTIJXj1l
         1gJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=OQmPt/tsW+HEDpe5xrLjZAgYGGi4SsWx2wHRRbyaLCk=;
        b=irqaTRXSvsn5xlF1MLDOrx0G0+AtDCXwZ11Kp6kEXEU50d5xtd9O83MInFUMrfXZp0
         rvunfWS5mxErodgUjSpSnpFPGMddOI8hN/dk/lafBt2Dyr45c4eGXeLHt/CM1M8Gc4F0
         N0bh7ocDJNmoBDhMJcUHZd7ePP67D+ZmqTEA4qixJEEkhbUXVk+m95IBJ4lsh39eFu0m
         G5+am7NetsIORW6H53zrrFJXZWmCLVSkjSJdfmF2oRme0qONW864ncPm/tk5Kq6Psw8l
         HAiyK2U4lM6Rc+yo9Or4Du5TqX1/S6AXm/5IR2H5cnsc98VYkxEc+zF2OMXeuiLdOVzH
         yJMA==
X-Gm-Message-State: AOAM532tdexjzOAfjxjALxndkw4gmAN+pPq1X/azKTIE3IxxK+7++nKP
        vDrSPbxRWBsddQi1mBJqpdHo1w==
X-Google-Smtp-Source: ABdhPJwJhMusNjyYU9HLc0n1BQp5qSSpjfmaREGTGllyXc0ludIpaQZgaVGHxhCQg0b8x0hyiI5hbQ==
X-Received: by 2002:adf:9504:: with SMTP id 4mr1928821wrs.27.1603179325854;
        Tue, 20 Oct 2020 00:35:25 -0700 (PDT)
Received: from debian-brgl.home (amarseille-656-1-4-167.w90-8.abo.wanadoo.fr. [90.8.158.167])
        by smtp.gmail.com with ESMTPSA id g83sm1344119wmf.15.2020.10.20.00.35.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2020 00:35:25 -0700 (PDT)
From:   Bartosz Golaszewski <brgl@bgdev.pl>
To:     Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        stable@vger.kernel.org
Subject: [PATCH] net: ethernet: mtk-star-emac: select REGMAP_MMIO
Date:   Tue, 20 Oct 2020 09:35:15 +0200
Message-Id: <20201020073515.22769-1-brgl@bgdev.pl>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bartosz Golaszewski <bgolaszewski@baylibre.com>

The driver depends on mmio regmap API but doesn't select the appropriate
Kconfig option. This fixes it.

Fixes: 8c7bd5a454ff ("net: ethernet: mtk-star-emac: new driver")
Cc: <stable@vger.kernel.org>
Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
---
 drivers/net/ethernet/mediatek/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mediatek/Kconfig b/drivers/net/ethernet/mediatek/Kconfig
index 62a820b1eb16..3362b148de23 100644
--- a/drivers/net/ethernet/mediatek/Kconfig
+++ b/drivers/net/ethernet/mediatek/Kconfig
@@ -17,6 +17,7 @@ config NET_MEDIATEK_SOC
 config NET_MEDIATEK_STAR_EMAC
 	tristate "MediaTek STAR Ethernet MAC support"
 	select PHYLIB
+	select REGMAP_MMIO
 	help
 	  This driver supports the ethernet MAC IP first used on
 	  MediaTek MT85** SoCs.
-- 
2.28.0

