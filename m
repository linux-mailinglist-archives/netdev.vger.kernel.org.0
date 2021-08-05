Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 756803E1D41
	for <lists+netdev@lfdr.de>; Thu,  5 Aug 2021 22:19:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240719AbhHEUTg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 16:19:36 -0400
Received: from smtp-32.italiaonline.it ([213.209.10.32]:54597 "EHLO libero.it"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231738AbhHEUTe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Aug 2021 16:19:34 -0400
Received: from passgat-Modern-14-A10M.homenet.telecomitalia.it
 ([82.60.87.158])
        by smtp-32.iol.local with ESMTPA
        id BjpbmFmMJPvRTBjpjmCR6f; Thu, 05 Aug 2021 22:19:15 +0200
x-libjamoibt: 1601
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=libero.it; s=s2021;
        t=1628194755; bh=h42hvfOsVcsxyMi5VYbK7VWGEQ0NFsL2rgTVmpybmxg=;
        h=From;
        b=vsUir8SH70yeB1CULxIG31kcj3kpeUJornMCqxizuthopgAdPDu5b3i6DBverhNyH
         BeUqXsxjXGX7HTA2tdS96xsBP5EY5FGjnoA6xa+JreO4FeOlhAfHuJr0mzPyF7UcVa
         uRfQinRFGTk6ksrYYAEiu+Hj4fkczIwgNzRhPaLMr/SQWltGk26DRGJ8y3namTpOKU
         tp7D+me/1WJ4Nw9ms5otPYffa9uQB/cwwuBUOD7FGOaA40xPOJIBCYnI2ihVbD1tyt
         a5p32ltT5OzAuWL/xZmvwE26af7zpD0N20wgjVDirZLoj2nyi3jjaeID89l/cerRn7
         Mxcgo0tvBVxcA==
X-CNFS-Analysis: v=2.4 cv=NqgUz+RJ c=1 sm=1 tr=0 ts=610c47c3 cx=a_exe
 a=Hc/BMeSBGyun2kpB8NmEvQ==:117 a=Hc/BMeSBGyun2kpB8NmEvQ==:17
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
Subject: [PATCH v2 1/4] can: c_can: remove struct c_can_priv::priv field
Date:   Thu,  5 Aug 2021 22:18:57 +0200
Message-Id: <20210805201900.23146-2-dariobin@libero.it>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210805201900.23146-1-dariobin@libero.it>
References: <20210805201900.23146-1-dariobin@libero.it>
X-CMAE-Envelope: MS4xfCg1RXEu0dWcrSBgjc5/KTJJ/xciA6R3hLC+jW98EiEq2B915oF8B7RSauQE0FQbJleLtOObl4uXSbCBcJ6aIB4+E2jEPDbL2M0vc8VoS/Lqp6n1pQG6
 VJsbBOqDAsVjoGJsnHLI+RJPcM4sI18h88z81cN0UXjwNyU5x1eLrmC2httY5cTRZs/1/QP9lmTx9fidcEybM7UH0gPEIeuEBgKWbs+XyJZq7fjwdy4C8xmS
 l0ILuG1OoVfsjJOjmfZsEFX96C0Iq3/Vw3gwS70oV+2ZDkRsPrkajlqmqlf1WF+KSqqK5hxFFxS86hMFmpYqVxg4DBCR4tDp1Bd60iIQiV7RlT+PbT/25CPm
 VFl604m1n6zP7MthNcceRsoZ4BofmJ9E/Mn1z5/5oy52e6ch1CoUMdRCb/5gEakXL9XaPFQMoAzZaN2T24wX/GWk3fDFu4SZa6pZOJaYEvlRwsF2a9j0gblY
 31/3aaEeGgjWTg0AOAbfZgf7jX6PPf/qEAiPUPP6mS5bikw4BvYtBesFQI+A+VCuV8z2M85JMR8I2+C9
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It references the clock but it is never used. So let's remove it.

Signed-off-by: Dario Binacchi <dariobin@libero.it>
---

(no changes since v1)

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

