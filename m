Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFC9142A4B3
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 14:38:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236611AbhJLMkJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 08:40:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236619AbhJLMja (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Oct 2021 08:39:30 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FA55C061749
        for <netdev@vger.kernel.org>; Tue, 12 Oct 2021 05:37:23 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id ec8so30847977edb.6
        for <netdev@vger.kernel.org>; Tue, 12 Oct 2021 05:37:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pqrs.dk; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dgfaR6ADJUjKQDS11YfFKaQI7Sj88w9HaVjDkJ1g5CM=;
        b=V7oXHXKSs+e7huxrifptFlprhFqFwR7VoF63Xh5GipXnUNI73NB4L3GE//HezsRoT5
         FCjVvHU5YkNbv8+7iG0B8D5pZP8Qxq1N2y/qQf5ONhaAD9UGQ8YZ4xU5cLn//inrxDrX
         i2xK/BhwNibszjhirgfc5YwTdgTNIEuurPBbY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dgfaR6ADJUjKQDS11YfFKaQI7Sj88w9HaVjDkJ1g5CM=;
        b=jQ12m8AYJPWUCcLTOJbXYMotnJaL1IoKWQv62409ZMIJjOvSIdResnDdTw2uu5vh2M
         y/zwlY5iMy3xSmNM4lY3bR5YmG0TfzHx7INjX0mVGhuQVDVtCHwaJtaGFJFqfdQ9Qrdj
         euomCZJza4dbn8HTP1fXnNLyyXjx9iv11lWDVWGQrUQP+3UdeDP72ls31gcwpEX3yvAK
         +pqEzSGYcUJdxMGre/5uaQJh5p43Yyoc9BAuOtOY4TPH9gKim5TqpJR1dZ8/rtfWs5SH
         hmMVOWrR7slLyGmyDs6+hDvhjEGKYqVDoG0WassdpT03K3IUpHTHNzmN0suwq0PKWKK+
         ocPg==
X-Gm-Message-State: AOAM531XGss/ZWwxLl/+qO9vZJcv86PJbCZHY3X87NV/PxvAlNfxqj+A
        Alr3H72AEqQaNKmLd9vwjiMKsw==
X-Google-Smtp-Source: ABdhPJzBy4+KjRu3dtdFX3wA07tO7xxCSpikCE6MauepCTqRQd3C4yNdwLAge44U9w8FijC36UAdDA==
X-Received: by 2002:a50:e188:: with SMTP id k8mr51904823edl.119.1634042241713;
        Tue, 12 Oct 2021 05:37:21 -0700 (PDT)
Received: from capella.. (27-reverse.bang-olufsen.dk. [193.89.194.27])
        by smtp.gmail.com with ESMTPSA id b5sm5763629edu.13.2021.10.12.05.37.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Oct 2021 05:37:21 -0700 (PDT)
From:   =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alvin@pqrs.dk>
To:     Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 6/6] net: phy: realtek: add support for RTL8365MB-VC internal PHYs
Date:   Tue, 12 Oct 2021 14:35:55 +0200
Message-Id: <20211012123557.3547280-7-alvin@pqrs.dk>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211012123557.3547280-1-alvin@pqrs.dk>
References: <20211012123557.3547280-1-alvin@pqrs.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alvin Šipraga <alsi@bang-olufsen.dk>

The RTL8365MB-VC ethernet switch controller has 4 internal PHYs for its
user-facing ports. All that is needed is to let the PHY driver core
pick up the IRQ made available by the switch driver.

Signed-off-by: Alvin Šipraga <alsi@bang-olufsen.dk>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
---

RFC -> v1: no change; collect Reviewed-by

 drivers/net/phy/realtek.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/phy/realtek.c b/drivers/net/phy/realtek.c
index 11be60333fa8..a5671ab896b3 100644
--- a/drivers/net/phy/realtek.c
+++ b/drivers/net/phy/realtek.c
@@ -1023,6 +1023,14 @@ static struct phy_driver realtek_drvs[] = {
 		.resume		= genphy_resume,
 		.read_page	= rtl821x_read_page,
 		.write_page	= rtl821x_write_page,
+	}, {
+		PHY_ID_MATCH_EXACT(0x001cc942),
+		.name		= "RTL8365MB-VC Gigabit Ethernet",
+		/* Interrupt handling analogous to RTL8366RB */
+		.config_intr	= genphy_no_config_intr,
+		.handle_interrupt = genphy_handle_interrupt_no_ack,
+		.suspend	= genphy_suspend,
+		.resume		= genphy_resume,
 	},
 };
 
-- 
2.32.0

