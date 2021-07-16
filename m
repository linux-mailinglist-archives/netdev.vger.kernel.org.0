Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B22D43CBAC6
	for <lists+netdev@lfdr.de>; Fri, 16 Jul 2021 18:57:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230256AbhGPQ75 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Jul 2021 12:59:57 -0400
Received: from smtp-33.italiaonline.it ([213.209.10.33]:34251 "EHLO libero.it"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229794AbhGPQ7y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Jul 2021 12:59:54 -0400
Received: from passgat-Modern-14-A10M.homenet.telecomitalia.it ([79.54.92.92])
        by smtp-33.iol.local with ESMTPA
        id 4R8tmKNNmS6GM4R8zmO7bE; Fri, 16 Jul 2021 18:56:57 +0200
x-libjamoibt: 1601
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=libero.it; s=s2021;
        t=1626454617; bh=ukKbkV8ZQ3gcpPYd1NqECiAHtTGPMg1hlJa5khe340Q=;
        h=From;
        b=PvKsqz2ilX8HLF1W+dIjHYBr5w5CTtdCOS7Skf32W6bO/t3G51+Yumry2woQVanWt
         EGAIJjzWS7ZAFWR4+/RkKDZnEgm4WwG2ZWPG0Jg2/aELrO7Htb4RscVgZxlHE3a6go
         9G/K6oGEJojUAgoRKNsR/2VcABQlXBDWMWJHFn7fLcL7c63E1yMHTjQZXDHm6kbzvh
         4ITMIzK5Vk5zsl1li2Kt9aBrT8RI0QQ7tlvRAiT4BOeLY9RfqwiIEU1OdTj9cMYcaW
         XKwYb8i/3y7PCenVKSsdV4EreDBEGq9FGL5+uoEFLaeWKRJY6086tLXKqFdwzxAoLM
         394N6KjQv3LSg==
X-CNFS-Analysis: v=2.4 cv=AcF0o1bG c=1 sm=1 tr=0 ts=60f1ba59 cx=a_exe
 a=eKwsI+FXzXP/Nc4oRbpalQ==:117 a=eKwsI+FXzXP/Nc4oRbpalQ==:17
 a=TSeAaTSCjiJB7GOU1roA:9
From:   Dario Binacchi <dariobin@libero.it>
To:     linux-kernel@vger.kernel.org
Cc:     Gianluca Falavigna <gianluca.falavigna@inwind.it>,
        Dario Binacchi <dariobin@libero.it>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Tong Zhang <ztong0001@gmail.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 1/4] can: c_can: remove struct c_can_priv::priv field
Date:   Fri, 16 Jul 2021 18:56:20 +0200
Message-Id: <20210716165623.19677-2-dariobin@libero.it>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210716165623.19677-1-dariobin@libero.it>
References: <20210716165623.19677-1-dariobin@libero.it>
X-CMAE-Envelope: MS4xfKoMV/+nZGBCPIXBiH3gvl6PDXsLIr3ajj3MP7Mrxti8SWfQlE/FXiPXzaPo3/kHl2XKpq4Gy1ZfkK7F1OP7Wfm9TETNnU1dtw+U56kgbTbcL3g2u1YN
 ItnFnJG5lXNPyTBo5oQjLpt8tnjq6mhufAss2yoNaPmKrVAtfctBfjD9X5jec6FT0TKq+QEf6bxYkGdrxWEDn8Y50gZEeS0i3DeEi6bM1iaPQNRwqRXisEVx
 /3p6Uonpt9uW1AapLvVqBNwL5yneD2CeenAe5qCVjBdY3McW7MsSoko84sGBgJ8ZsolWYSRM6UnZuPJ9axnV5Hq6tbKF3FNv/YvoCCRfiqtDKIqZV2vc9QWg
 pJaUlH4TjjOuKiD44lZU/G1uxqTzG9P5QQ61fwJyK5B5bVLCgAw+3kAtEajNvJ33VIxjPUk2sNo68SCGcMYgwAwvT2lvelE7KR6DlUwZC9At4ThTfH+AsMvF
 YxJmrJqMdgr1bfpJUU8fVjdHMXCKNAnx1psceFuGnYRRyebx/KP/y63R3RNZp7RunUTginxg8tucDuTW
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It references the clock but it is never used. So let's remove it.

Signed-off-by: Dario Binacchi <dariobin@libero.it>
---

 drivers/net/can/c_can/c_can.h          | 1 -
 drivers/net/can/c_can/c_can_platform.c | 1 -
 2 files changed, 2 deletions(-)

diff --git a/drivers/net/can/c_can/c_can.h b/drivers/net/can/c_can/c_can.h
index 4247ff80a29c..8f23e9c83c84 100644
--- a/drivers/net/can/c_can/c_can.h
+++ b/drivers/net/can/c_can/c_can.h
@@ -200,7 +200,6 @@ struct c_can_priv {
 	void (*write_reg32)(const struct c_can_priv *priv, enum reg index, u32 val);
 	void __iomem *base;
 	const u16 *regs;
-	void *priv;		/* for board-specific data */
 	enum c_can_dev_id type;
 	struct c_can_raminit raminit_sys;	/* RAMINIT via syscon regmap */
 	void (*raminit)(const struct c_can_priv *priv, bool enable);
diff --git a/drivers/net/can/c_can/c_can_platform.c b/drivers/net/can/c_can/c_can_platform.c
index 36950363682f..86e95e9d6533 100644
--- a/drivers/net/can/c_can/c_can_platform.c
+++ b/drivers/net/can/c_can/c_can_platform.c
@@ -385,7 +385,6 @@ static int c_can_plat_probe(struct platform_device *pdev)
 	priv->base = addr;
 	priv->device = &pdev->dev;
 	priv->can.clock.freq = clk_get_rate(clk);
-	priv->priv = clk;
 	priv->type = drvdata->id;
 
 	platform_set_drvdata(pdev, dev);
-- 
2.17.1

