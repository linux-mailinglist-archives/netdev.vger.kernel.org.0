Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFA03476D34
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 10:17:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235166AbhLPJRW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Dec 2021 04:17:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235164AbhLPJRU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Dec 2021 04:17:20 -0500
Received: from mail-qk1-x72b.google.com (mail-qk1-x72b.google.com [IPv6:2607:f8b0:4864:20::72b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45DE2C06173E;
        Thu, 16 Dec 2021 01:17:20 -0800 (PST)
Received: by mail-qk1-x72b.google.com with SMTP id d21so15414552qkl.3;
        Thu, 16 Dec 2021 01:17:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=WqQ0KJAV/sB2BrhVHdi1jGSeQPiM2L9NcTy4hRpXIq0=;
        b=Q2NlOsPmRia8fogvyzJ8O4+S8/SSoC6qKL9pzJ1EQ2wRmeDAT57E4upsdqTBFu3Tot
         uD4H5vaYO2GGxyBYP7ioeA1TggvRw1G5dOiTDltaho8fmhkh+VcuDjjLzjGILGgu0+hp
         GoV426LwXjnVGgUICOxOZligXJ8C1cnSBLwrk1gOusU+ml5tsZKefiNgSkOFwunUFZtm
         4Wy/5wszIqkC1ElWMWYbNYSYoXY3PxQium5u08Yxo3Qx2c7fUyNFyIj2C/qfo7gaXQG1
         XQwL+LFtDBOU7ozXqnslibgwRXa9mwf+4KTVHiYV89F0I4TDO0wMWUEp8AskytLsScuZ
         44lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=WqQ0KJAV/sB2BrhVHdi1jGSeQPiM2L9NcTy4hRpXIq0=;
        b=3PqdDfNHZRhNGb8v7AnusiyqaxuVZQ0nSXYfO0buhz4B4jJkGYC9X9IgwDglB1zeaS
         sT3qqe1j4g4yz+iGNpOb8YLi0bvjeK4woOBcQYTP5V9ECtqHGkN5Ki1Gcm+avuRpZuw1
         t3v3SLn8WOdvsc2E8Mg00MiaK1tzCzy7u+yswGPDmqLrB7P6fQUgkl7n1pXkVnPp+I8W
         Yd7eOzkylQps9Y/K9JyswBIFZJ88qTsTCOP31vZD9Abo7tHn5TX4fe9vQ1BRyg9B/bL5
         dAwtCsP26efeNqSMfofpsrGTI/vIhh0gYzRg8+2seoqa/OFeR4gqsguXab1O3H3o8I63
         PX8w==
X-Gm-Message-State: AOAM530BUDwiPUz7f9h1c04Fa/OJzrWeIeoyS2LZ99vfJr08VH9irE8C
        VI7EobgtylAEFvKFNx4aAlk=
X-Google-Smtp-Source: ABdhPJxQez2uKtCH1lS2Qr4sSt/5Q8RcxuKhMKuo/J5SeEmcu2wcApDpVIrZMbuwRV/bxX+tkrNyAA==
X-Received: by 2002:a05:620a:4045:: with SMTP id i5mr11266578qko.592.1639646239514;
        Thu, 16 Dec 2021 01:17:19 -0800 (PST)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id o10sm3698169qtx.33.2021.12.16.01.17.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Dec 2021 01:17:19 -0800 (PST)
From:   cgel.zte@gmail.com
X-Google-Original-From: deng.changcheng@zte.com.cn
To:     ajay.kathat@microchip.com
Cc:     claudiu.beznea@microchip.com, kvalo@kernel.org,
        davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Changcheng Deng <deng.changcheng@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH] wilc1000: use min() to make code cleaner
Date:   Thu, 16 Dec 2021 09:17:13 +0000
Message-Id: <20211216091713.449841-1-deng.changcheng@zte.com.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Changcheng Deng <deng.changcheng@zte.com.cn>

Use min() in order to make code cleaner.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Changcheng Deng <deng.changcheng@zte.com.cn>
---
 drivers/net/wireless/microchip/wilc1000/spi.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/net/wireless/microchip/wilc1000/spi.c b/drivers/net/wireless/microchip/wilc1000/spi.c
index 6e7fd18c14e7..629ba5d7a7df 100644
--- a/drivers/net/wireless/microchip/wilc1000/spi.c
+++ b/drivers/net/wireless/microchip/wilc1000/spi.c
@@ -675,10 +675,7 @@ static int wilc_spi_dma_rw(struct wilc *wilc, u8 cmd, u32 adr, u8 *b, u32 sz)
 		int nbytes;
 		u8 rsp;
 
-		if (sz <= DATA_PKT_SZ)
-			nbytes = sz;
-		else
-			nbytes = DATA_PKT_SZ;
+		nbytes = min(sz, DATA_PKT_SZ);
 
 		/*
 		 * Data Response header
-- 
2.25.1

