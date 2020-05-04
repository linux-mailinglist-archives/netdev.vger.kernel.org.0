Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE3821C32E5
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 08:26:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728079AbgEDG0t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 02:26:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728058AbgEDG0t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 02:26:49 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBFBEC061A0E;
        Sun,  3 May 2020 23:26:48 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id b2so8497536ljp.4;
        Sun, 03 May 2020 23:26:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=lqVG7t82i77h5kEn5TCPzHYtd4/tKpgSC9SyCQ77F9Y=;
        b=nPlgEx/belfPjcRR4Bghp8yryWgoPyQ7o8FjnzRfJlCdIuJ+LlTkIGo2GbbtV20w57
         NLmsDyBuIE/c62iqddO/XCNr/M/y5DE3aOODgBKotlZwVoguEEB7/W7o/tZhKY7gTF8B
         U2YJ/i88yEjYjUFkmtMIadnkoqcFWB00J38pH6E785DACMr/nVX1auX0WbeGVrswSg7f
         6LcUhN74dY4+dymVIyYpNegqiZ0BdeW09ltenIHU/M+CNhzgAcw5lwdwuuv5bqDRywn6
         +Fd4eqPKZmaKo2zx6FaPcoZTdkg/sTglYkcfRM8RTBmk2LGd5RfQPhctWlWB2PMlA1Ly
         lAhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=lqVG7t82i77h5kEn5TCPzHYtd4/tKpgSC9SyCQ77F9Y=;
        b=buvuVJQXNinZnaXD6h/nvEQxb2lYPJ9eTvqIXnvErSZrsP2OsbwXTjSC8k6WTnktrH
         3lX2ITtP+ipbxyaTaiHdckdW+Vsv+kyXGfhl26EMro67x5IaY1HMGz/hBiTuxJk+vTGk
         GvLpU/5LxxO23p3kbLcdi2Gy8Xw0zHOK9Jz302NQsGuXCxY0hPy2Npq+rBMSWhMctr62
         MzC6YdhERZfj7hGQQRyK3FMFXu9ASXUvSkwA6VPB9ZCSdECPKV7YfNo549uJqPx1qkLa
         me198TZ8G3qeB4wC7oyHYXKc9EuxyD/jga4UVErGLpvq0dKVmWIA9SgeU4hSBLu7Zyl7
         Ri9Q==
X-Gm-Message-State: AGi0PuZ589FQYPjMocRy9FiJI+eBJcP6P3JdyyO8jVFV9mcX+4X4y8oj
        O5iN0ca1IbL8GVG+qW1oU6j6eqtVwwBQcA==
X-Google-Smtp-Source: APiQypKlaRQvNe91ghJO+H02IP0tDnoY0U0Mg0AUefcKD7RuUMS7u3ljVlRdZQL7uzU3479S/gH+FQ==
X-Received: by 2002:a2e:9691:: with SMTP id q17mr8437589lji.116.1588573607244;
        Sun, 03 May 2020 23:26:47 -0700 (PDT)
Received: from maxim-hplinux ([89.179.187.12])
        by smtp.gmail.com with ESMTPSA id g20sm8628735lfj.1.2020.05.03.23.26.46
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 03 May 2020 23:26:46 -0700 (PDT)
Date:   Mon, 4 May 2020 09:26:43 +0300
From:   Maxim Petrov <mmrmaximuzz@gmail.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc:     mmrmaximuzz@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] stmmac: fix pointer check after utilization in
 stmmac_interrupt
Message-ID: <20200504062639.GA11585@maxim-hplinux>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The paranoidal pointer check in IRQ handler looks very strange - it
really protects us only against bogus drivers which request IRQ line
with null pointer dev_id. However, the code fragment is incorrect
because the dev pointer is used before the actual check which leads
to undefined behavior. Remove the check to avoid confusing people
with incorrect code.

Signed-off-by: Maxim Petrov <mmrmaximuzz@gmail.com>
---
Changes in V2:
* Remove the incorrect check instead of fixing it (suggested by
  David Miller)
* Add clarification to the function description

 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 565da6498c84..e2b095d936cf 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -4060,7 +4060,7 @@ static int stmmac_set_features(struct net_device *netdev,
 /**
  *  stmmac_interrupt - main ISR
  *  @irq: interrupt number.
- *  @dev_id: to pass the net device pointer.
+ *  @dev_id: to pass the net device pointer (must be valid).
  *  Description: this is the main driver interrupt service routine.
  *  It can call:
  *  o DMA service routine (to manage incoming frame reception and transmission
@@ -4084,11 +4084,6 @@ static irqreturn_t stmmac_interrupt(int irq, void *dev_id)
 	if (priv->irq_wake)
 		pm_wakeup_event(priv->device, 0);
 
-	if (unlikely(!dev)) {
-		netdev_err(priv->dev, "%s: invalid dev pointer\n", __func__);
-		return IRQ_NONE;
-	}
-
 	/* Check if adapter is up */
 	if (test_bit(STMMAC_DOWN, &priv->state))
 		return IRQ_HANDLED;

base-commit: 6a8b55ed4056ea5559ebe4f6a4b247f627870d4c
-- 
2.17.1

