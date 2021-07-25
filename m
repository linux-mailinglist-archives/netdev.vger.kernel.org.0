Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0295D3D4EAC
	for <lists+netdev@lfdr.de>; Sun, 25 Jul 2021 18:12:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230515AbhGYPbm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Jul 2021 11:31:42 -0400
Received: from smtp-34.italiaonline.it ([213.209.10.34]:51765 "EHLO libero.it"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230193AbhGYPbb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 25 Jul 2021 11:31:31 -0400
Received: from passgat-Modern-14-A10M.homenet.telecomitalia.it
 ([79.45.45.231])
        by smtp-34.iol.local with ESMTPA
        id 7gjJmU9oJLCum7gjQmo2af; Sun, 25 Jul 2021 18:12:00 +0200
x-libjamoibt: 1601
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=libero.it; s=s2021;
        t=1627229520; bh=ukKbkV8ZQ3gcpPYd1NqECiAHtTGPMg1hlJa5khe340Q=;
        h=From;
        b=EpPZYY5ByvJp0lrg1Zi6s5oGl90NKPFWe7w2qYKcpi93QwgSFEc3fisX7nVCs9U0L
         M5Qi96g0Owbbadf/XwR3tnI8KUXKvXsnFCTP1jKhtgHw63JlfEGihNAbPh6E0vBW3o
         qzUZhn6LOdYst87GRu+MNjQY9H3CbkuaOt6kJjZ3cvG/9smGo518a0PARUg12ItvQ5
         HcptLC7dkClRSmavEgT7OvmYUIpJXTLmsc9F3nSxGeb2S4jx2PUhfSJeA0Qe6GN4XS
         upj2qxEX9s2USjemCoVG0ZLm3l/UBYATwkN4nmFNCM0oouFWrZ3GiHiNzE79AvN9vv
         k/qSSvUc6fdvQ==
X-CNFS-Analysis: v=2.4 cv=a8D1SWeF c=1 sm=1 tr=0 ts=60fd8d50 cx=a_exe
 a=TX8r+oJM0yLPAmPh5WrBoQ==:117 a=TX8r+oJM0yLPAmPh5WrBoQ==:17
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
Subject: [RESEND PATCH 1/4] can: c_can: remove struct c_can_priv::priv field
Date:   Sun, 25 Jul 2021 18:11:47 +0200
Message-Id: <20210725161150.11801-2-dariobin@libero.it>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210725161150.11801-1-dariobin@libero.it>
References: <20210725161150.11801-1-dariobin@libero.it>
X-CMAE-Envelope: MS4xfJeXdyHedOw0ts0LyJhcJzHXuN79YT/uv4IU9SvVqG08qfRMLNlv01T3VreYJagfFelH1UkoxTG5hGKvwCIdVTCUWm9t9iBddkNTXrLCgUsDFDcYHipC
 rV3o9uuDGwfWkXjkyxhIirLue12LMjjo2PxzGhI4MlgU5uVqOW5Bvqdc3kAmPd4cqIXKNi4ibjI2qhQQ2YataYb0aV4F8BLRZnEUDqknyrwPcfIvXq3K9DFa
 LrL512c0PGvbr30Zt7lnxKnEFJIWAw5pjl2V+RfDLghxfInctamQSyl+ldXca4DPDB9cbx5ENPuUSXzqxgsdCT9KwznwVnJH17Q0zUH47HxA3wGKvugpWZK5
 miB2tO7sqKkP+w3CdDPdi/70QPrsx3nw03R+c6Le60oIm6xZmNudDl8LWdnp2yyiDKNEBGPiBKmKqhIVgN+Pjcr1TLvQiWmLekI/dJArcj9oHQlVO+4SwmDa
 +QYq3xHpB7Zkg5qBchD5X6ZjyKT8TPj3l5wxDYaouXu4kM/vMcjE+L+Eh+fde5gvqAiSspFB9pOghDW4
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

