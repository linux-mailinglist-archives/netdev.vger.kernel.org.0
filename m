Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73FD433EBB9
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 09:42:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229705AbhCQImL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 04:42:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229680AbhCQImE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Mar 2021 04:42:04 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B3CEC06174A;
        Wed, 17 Mar 2021 01:42:04 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id o16so925961wrn.0;
        Wed, 17 Mar 2021 01:42:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tl5HId0xwwJxvtCOBdoa3c+9abyowKjjD80oBW/qHJs=;
        b=mHwlHIVQrCEff1ehYYMS4NfPCvKiThi24ZcKv8eKMQ3a8utZda8zCSqx1OY2fO7I2K
         s7cE9ZxPMl7cnYuUgf+Dg1Pa5QLvLU3ZLxnYXrPazE9Y3l/qtxnNUz9OUW24L69wdno6
         prpBx4M4ZQgBTX9xkaEjsVkHJRIds2PP3EpxxkJuWB0N1eU8jFHfRyC8zi4WnQpTD6XN
         NDzfW6uptUgwdVqbIZhYUOH3RydHE6uOD0ZkengZS/xGf5rCHTXxEJyED2QMmwYFm8nj
         qqKj4FsFHB/aXYGvaHupgd1hb2VptkfC9k/BprRDbOdOwy60m2u9UqgV6ivR7rCcTs7o
         HdVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tl5HId0xwwJxvtCOBdoa3c+9abyowKjjD80oBW/qHJs=;
        b=KDGOr6U9L5eUumQpduGrm9SJ06Cascw/wW/03v4osEN+j6EicTHZMn5zGP3N3PcmHd
         qmCTIEfrReSvyi5molfviaRIs/uMmVQP1E02pKuPWst6IVDQcyMI9/8GjZQEnRqtDP0x
         lUxzfYmZ1nZBzcwHOuR4bCZFkfZ99YHmO33ZIij6h6C5dH4yo4lvmm7okrZk2PNchUfZ
         pSZEvstWorXhldUAHMieFH0p+ve2z7P81zQgdrXxFOHC0eP8JF7oYrqmYMMp+QbGMilm
         wlJa3LaBZNPl+kS0RxsBT6C815lkEgQSlOMXIMSF9LjvZgVPtWnLqoXtEDkFVfYmvnJt
         OySA==
X-Gm-Message-State: AOAM533ijK+OYiu2uReu17ziemPlrOh83ixOOK0nZqyCKOr6khQnuG4Q
        wPlK0Oy9y4Vf3ndQwC4ZwaM=
X-Google-Smtp-Source: ABdhPJz9q3/PFDTQq68cyo+/oXRZpsXe9N9g1WUJovdyUPwt9qHBb2lY+z9hDznH9bT2O1lsPcVmpg==
X-Received: by 2002:adf:fb05:: with SMTP id c5mr3278599wrr.302.1615970523320;
        Wed, 17 Mar 2021 01:42:03 -0700 (PDT)
Received: from skynet.lan ([80.31.204.166])
        by smtp.gmail.com with ESMTPSA id i16sm1126707wmq.3.2021.03.17.01.42.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Mar 2021 01:42:03 -0700 (PDT)
From:   =?UTF-8?q?=C3=81lvaro=20Fern=C3=A1ndez=20Rojas?= 
        <noltari@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     =?UTF-8?q?=C3=81lvaro=20Fern=C3=A1ndez=20Rojas?= 
        <noltari@gmail.com>
Subject: [PATCH net-next resend] net: dsa: b53: relax is63xx() condition
Date:   Wed, 17 Mar 2021 09:42:01 +0100
Message-Id: <20210317084201.32279-1-noltari@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

BCM63xx switches are present on bcm63xx and bmips devices.

Signed-off-by: Álvaro Fernández Rojas <noltari@gmail.com>
Acked-by: Florian Fainelli <f.fainelli@gmail.com>
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

