Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6AA9D1003D5
	for <lists+netdev@lfdr.de>; Mon, 18 Nov 2019 12:25:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727543AbfKRLYt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 06:24:49 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:52384 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727491AbfKRLYf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Nov 2019 06:24:35 -0500
Received: by mail-wm1-f68.google.com with SMTP id l1so16934059wme.2
        for <netdev@vger.kernel.org>; Mon, 18 Nov 2019 03:24:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rasmusvillemoes.dk; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=iA65MKMzLkvpbCJtw1dgfKRTfY/LMh1lX20RtWmEnL4=;
        b=KjmkIq+xQGH3odHbzh8WQ29uNzIeULjrmnEIUn6rJk6d3kPG3Yrdormidcf9MOozuP
         jJjPm4aVw6O7o5m4NM6A/QynyvvjsztfxnHyuBalLbiFxT2tEkouhimouboIfT9wG8Rx
         D3uUNCrpcumEIR0nRoTJWxEdlKOyT4vTPdS3Q=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=iA65MKMzLkvpbCJtw1dgfKRTfY/LMh1lX20RtWmEnL4=;
        b=oemD/K4V3aO3wqnVXXJ8gBezfj0OuFUHYaPZHvuCu5zLp1dzIEJx3boONjGog+LZh8
         qpiZeC+PvVZZO1KZ9m+wAEKVumbYEMt7fvX6pbmXMHEvc6//lIJIA8wpT2TyK3ifIQvH
         HHyxeJEwWUYLOkmhQ3YcQVLAB2di8VUd4g7oq3u7axLNTUKSGOCOG5NMN6J9dRjkVgzy
         CsD5eM64iz/TScU7BGs3IA7d1xk+MlYiI9FYIfqKst8+t9cUpcV+1B0bSFT+69MyMy11
         AQZo0Onvr3agwiiC2I9Rq5dxWXl8mUSzVkkqmLXs2gp1t266Ghjq7Uw72Jmgt/VcPRmT
         2wrA==
X-Gm-Message-State: APjAAAUQI/6XHDMnzRnqspW7VRHdFNIhFEB5o7cLBckvrue2ru2K+gfE
        cuzrhSejnGjrEPXaxKXXB7c1oQ==
X-Google-Smtp-Source: APXvYqymuTf1eyZnezM6aM+hof+hm0Vr9Bfgz8sSkP7x97G19etwlRYffVBDTcw2EHmGvdaGH++2sg==
X-Received: by 2002:a1c:2e0f:: with SMTP id u15mr28930458wmu.47.1574076273195;
        Mon, 18 Nov 2019 03:24:33 -0800 (PST)
Received: from prevas-ravi.prevas.se (ip-5-186-115-54.cgn.fibianet.dk. [5.186.115.54])
        by smtp.gmail.com with ESMTPSA id y2sm21140815wmy.2.2019.11.18.03.24.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Nov 2019 03:24:32 -0800 (PST)
From:   Rasmus Villemoes <linux@rasmusvillemoes.dk>
To:     Qiang Zhao <qiang.zhao@nxp.com>, Li Yang <leoyang.li@nxp.com>,
        Christophe Leroy <christophe.leroy@c-s.fr>
Cc:     linuxppc-dev@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Scott Wood <oss@buserror.net>, Timur Tabi <timur@kernel.org>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        netdev@vger.kernel.org
Subject: [PATCH v5 47/48] net: ethernet: freescale: make UCC_GETH explicitly depend on PPC32
Date:   Mon, 18 Nov 2019 12:23:23 +0100
Message-Id: <20191118112324.22725-48-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191118112324.22725-1-linux@rasmusvillemoes.dk>
References: <20191118112324.22725-1-linux@rasmusvillemoes.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, QUICC_ENGINE depends on PPC32, so this in itself does not
change anything. In order to allow removing the PPC32 dependency from
QUICC_ENGINE and avoid allmodconfig build failures, add this explicit
dependency.

Also, the QE Ethernet has never been integrated on any non-PowerPC SoC
and most likely will not be in the future.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 drivers/net/ethernet/freescale/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/Kconfig b/drivers/net/ethernet/freescale/Kconfig
index 6a7e8993119f..2bd7ace0a953 100644
--- a/drivers/net/ethernet/freescale/Kconfig
+++ b/drivers/net/ethernet/freescale/Kconfig
@@ -74,7 +74,7 @@ config FSL_XGMAC_MDIO
 
 config UCC_GETH
 	tristate "Freescale QE Gigabit Ethernet"
-	depends on QUICC_ENGINE
+	depends on QUICC_ENGINE && PPC32
 	select FSL_PQ_MDIO
 	select PHYLIB
 	---help---
-- 
2.23.0

