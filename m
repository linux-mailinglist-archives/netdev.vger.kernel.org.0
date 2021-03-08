Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94781331583
	for <lists+netdev@lfdr.de>; Mon,  8 Mar 2021 19:08:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231143AbhCHSI2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Mar 2021 13:08:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231153AbhCHSIH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Mar 2021 13:08:07 -0500
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D44CC06174A;
        Mon,  8 Mar 2021 10:08:07 -0800 (PST)
Received: by mail-wm1-x32b.google.com with SMTP id r10-20020a05600c35cab029010c946c95easo4365957wmq.4;
        Mon, 08 Mar 2021 10:08:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=D+ix1bqUHR67y7Zw/xnEWdiKaUUj6x6vhu5NPNbvDhM=;
        b=Lyj7j02qihdEKejj+zqGj0rM0dQ6F9rynpqHHWnjbSdMnXkVxCcL+RJLtPjswC/DE6
         kp/GvJ0rjvHbLLL6fKJHJmaIc4fxcI2XZSb2R1tReGMZNmeouxU48fLNoGG9qCyLtY6f
         xk7epHgGwHAW/4jZNpOgqmmvBpdtIp1QOJTuScVaJSjdX6LlVBWdGAW3XLpt2mLBANDJ
         kojMvw4U3ky1iWXgsksDbmgxHDUj18Gtuqxy+TJNx6a/Vg8X0ENUm5CmG+t3QnXU0mSE
         aeMWzUjTeDfrsuHp+UKbTchwlps6BEygglB8fb8O51bEbPeTggdaB2jDTRagHL/zGH+c
         g96g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=D+ix1bqUHR67y7Zw/xnEWdiKaUUj6x6vhu5NPNbvDhM=;
        b=dRQLKqCnd6TEXFqG9RD+QbQIx1cPMuW7yibOvC6Gu9qd7kMM3hamZnTcls+shCd9NH
         flSBJuzafQ/FBMEUOfovNL2X/nZ3+S0zPgviBOPkAo4M35xFrvakTqOchSqPLvwYYCXx
         e9OZKjTMalKyFVvT3X1axeuwDUPxVPasuzD+dqdlLgOwivw2pje37LTIioaJAttI8giX
         fssFp0zRoc1oPL5perocGN1xIXDso/+lt1KJQIeQ9uQsHOthCNXUNUZwL1czVu4phrmk
         wfkFLoF8WOVdyRcmgzMVHS8OLfMCj0Nf4To4Erv/c8CVpC9bFNt5HoqZcFbiGskje87V
         AVsw==
X-Gm-Message-State: AOAM5300YD0lfBdis71b1WsqLCdj+hlPsOfNQe1jHGwwZI4TEjSQmxvF
        W+zwEl1V7tClx2FrbbsCxB66ZeACVAnOYQ==
X-Google-Smtp-Source: ABdhPJyvfbrsOOL+LcrMMEZEYCTfVZ8LnSFPDGg74WGtp/ZTSc54P/TK0EEqx/Gb5NzdGcLe4lzT6g==
X-Received: by 2002:a1c:6a05:: with SMTP id f5mr38033wmc.75.1615226885731;
        Mon, 08 Mar 2021 10:08:05 -0800 (PST)
Received: from skynet.lan (224.red-2-138-103.dynamicip.rima-tde.net. [2.138.103.224])
        by smtp.gmail.com with ESMTPSA id t188sm147975wma.25.2021.03.08.10.08.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Mar 2021 10:08:05 -0800 (PST)
From:   =?UTF-8?q?=C3=81lvaro=20Fern=C3=A1ndez=20Rojas?= 
        <noltari@gmail.com>
To:     jonas.gorski@gmail.com, Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     =?UTF-8?q?=C3=81lvaro=20Fern=C3=A1ndez=20Rojas?= 
        <noltari@gmail.com>
Subject: [PATCH] net: dsa: b53: relax is63xx() condition
Date:   Mon,  8 Mar 2021 19:08:03 +0100
Message-Id: <20210308180803.19123-1-noltari@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

BCM63xx switches are present on bcm63xx and bmips devices.

Signed-off-by: Álvaro Fernández Rojas <noltari@gmail.com>
---
 drivers/net/dsa/b53/b53_priv.h | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/net/dsa/b53/b53_priv.h b/drivers/net/dsa/b53/b53_priv.h
index 8419bb7f4505..82700a5714c1 100644
--- a/drivers/net/dsa/b53/b53_priv.h
+++ b/drivers/net/dsa/b53/b53_priv.h
@@ -186,11 +186,7 @@ static inline int is531x5(struct b53_device *dev)
 
 static inline int is63xx(struct b53_device *dev)
 {
-#ifdef CONFIG_BCM63XX
 	return dev->chip_id == BCM63XX_DEVICE_ID;
-#else
-	return 0;
-#endif
 }
 
 static inline int is5301x(struct b53_device *dev)
-- 
2.20.1

