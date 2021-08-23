Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B29E3F446C
	for <lists+netdev@lfdr.de>; Mon, 23 Aug 2021 06:44:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231276AbhHWEpV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Aug 2021 00:45:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbhHWEpN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Aug 2021 00:45:13 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DDCDC061575;
        Sun, 22 Aug 2021 21:44:31 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id h1so5282110pjs.2;
        Sun, 22 Aug 2021 21:44:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Kimq81Qxw6v1wSE08WSZPq384v+/RN3JYeCnUsxOALc=;
        b=n9O7CBENvG8TkCdxP+Kgz3Z/GrSpRczECUWQSwHTNsKstuYhnDx1KEkKeNBwg2IuK4
         ja068jQ3P84VgEpBCpbHkzy9CjLY3kve5vNfc2y15qiDBJqvE7L5+/5EKlWNLqhaiDzi
         tXBxLxBxVpM82U3uFHzR9tn8V7WIgLRLGPQGFlt/W9P+yFFM0EJY7LncIcxqoYb7xHQ5
         y1urzhvo52PKFpZ3fJFVRxPu5sieRxMOuuM5sgsk/eWPlRW8OJTg1GF9qS4B7YL8NAUQ
         ru55WbOXIcrDw7DBcztcGmOjzDoGYyHTFgYRHqj2uqBxI82Lsw+uvZjt+t3BvcpXoFcY
         ql1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Kimq81Qxw6v1wSE08WSZPq384v+/RN3JYeCnUsxOALc=;
        b=mEofDJCIep6ZUmHN0gdKfA9g2g04XddWshbP7PQIw8ZTojowLUppBymq2xd/HqXclU
         Kzbt6tMvOmXz83Bi8ofWSVOseUBa0gYC+bSsszkgSJ7qhIdnjAVI7/Pf/fV3F2tn6Ki/
         FYvvGKit/EGErqYHdvOE6RA53eSDuRMR2wB+9xv99RJxi4sEeqEWLpoEi1abkiXhMF7m
         RqW+io1RqDze6WlkOM8rg4hvnEhTFhAvdXEvoqAeki8ptpOa+KsUj22IiG6UpXdkU1cy
         QL64lMMLoeht4vn6EtcwJekWqbmzww9kdAQON0+C4TJP9AH4T6hi7Dw5NPUZCs1/dopF
         jw8A==
X-Gm-Message-State: AOAM5303WLw4DoxLvTZGAv3XTJKLnrPiO6/jgHlNtqqDmO1KofpSfJ6s
        7/byfnrfZhff0YpcI3ci8Nc=
X-Google-Smtp-Source: ABdhPJziW7qgZ0SgjWRqZtRHKEW7G9Nvqi47fjiME67bnyVWX4uyYzl67PW8+omECJu+4iPsDRQnVw==
X-Received: by 2002:a17:90a:4894:: with SMTP id b20mr18369064pjh.13.1629693870752;
        Sun, 22 Aug 2021 21:44:30 -0700 (PDT)
Received: from haswell-ubuntu20.lan ([138.197.212.246])
        by smtp.gmail.com with ESMTPSA id t5sm14351856pfd.133.2021.08.22.21.44.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Aug 2021 21:44:30 -0700 (PDT)
From:   DENG Qingfang <dqfext@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org (open list:ETHERNET PHY LIBRARY),
        linux-kernel@vger.kernel.org (open list),
        linux-arm-kernel@lists.infradead.org (moderated list:ARM/Mediatek SoC
        support),
        linux-mediatek@lists.infradead.org (moderated list:ARM/Mediatek SoC
        support)
Subject: [PATCH net] net: phy: mediatek: add the missing suspend/resume callbacks
Date:   Mon, 23 Aug 2021 12:44:21 +0800
Message-Id: <20210823044422.164184-1-dqfext@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Without suspend/resume callbacks, the PHY cannot be powered down/up
administratively.

Fixes: e40d2cca0189 ("net: phy: add MediaTek Gigabit Ethernet PHY driver")
Signed-off-by: DENG Qingfang <dqfext@gmail.com>
---
 drivers/net/phy/mediatek-ge.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/phy/mediatek-ge.c b/drivers/net/phy/mediatek-ge.c
index 11ff335d6228..b7a5ae20edd5 100644
--- a/drivers/net/phy/mediatek-ge.c
+++ b/drivers/net/phy/mediatek-ge.c
@@ -81,6 +81,8 @@ static struct phy_driver mtk_gephy_driver[] = {
 		 */
 		.config_intr	= genphy_no_config_intr,
 		.handle_interrupt = genphy_handle_interrupt_no_ack,
+		.suspend	= genphy_suspend,
+		.resume		= genphy_resume,
 		.read_page	= mtk_gephy_read_page,
 		.write_page	= mtk_gephy_write_page,
 	},
@@ -93,6 +95,8 @@ static struct phy_driver mtk_gephy_driver[] = {
 		 */
 		.config_intr	= genphy_no_config_intr,
 		.handle_interrupt = genphy_handle_interrupt_no_ack,
+		.suspend	= genphy_suspend,
+		.resume		= genphy_resume,
 		.read_page	= mtk_gephy_read_page,
 		.write_page	= mtk_gephy_write_page,
 	},
-- 
2.25.1

