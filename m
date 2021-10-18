Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB5C74313B3
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 11:41:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231712AbhJRJny (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 05:43:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231736AbhJRJnZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Oct 2021 05:43:25 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D29F4C06177A
        for <netdev@vger.kernel.org>; Mon, 18 Oct 2021 02:40:51 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id w19so68344854edd.2
        for <netdev@vger.kernel.org>; Mon, 18 Oct 2021 02:40:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pqrs.dk; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=buH7vAjMrMNiFZgCnqX8LWzTqvVQhWMwnzUc5mp4HKY=;
        b=jXJkDGVZAzJISWZM4ruartPN4Ikgw3wlZM19cVv7i30FnZlvvwYp2opQ09OhpLSZFz
         FZZt6Ih72r7DUPzs21Duruaa47EuRU7vByDoyLz7QVhgAbA2y1qhynxkq4R4LMyydirq
         RqxlNpLCeF3KV99CumSdj332ay6hi//ZHJPwM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=buH7vAjMrMNiFZgCnqX8LWzTqvVQhWMwnzUc5mp4HKY=;
        b=zm66TJh2Chu2SZHOzX8TrDL2l4NQcPDuPmRfCmGVx9dCr0Q+ovCk2tXV86jznZbO7k
         EajoPqIMUIhYmtuejoTj1DHY2uCs2b2ToVPURMl4HDl29cqyxHl4nRh94aymOwIT4qGg
         Wul+j+D9+qR+AMN16FD+hsyPyZrbgFgKPp6TXk8680WBAmUpX4hielUF9biyw+sFJ7Lw
         WifAKpxpiHiT+NOTKVbMUlx/8YfXdP2ys1XP48uw5SzDhxHFO5X5WAjqHkJRoKDXeeyT
         TsAIDdk4Qqx/RoqnhoUUE8a5sF60z5dr4Z7HRJ6/zh13bw8I/4LXKFuWDxUBfg2GBGcH
         mNnA==
X-Gm-Message-State: AOAM531LiJKMg/1ubS2FyrEbL45ugU01dSU6BoCX+Y4uBSoMStpQ9u+s
        /eOIIzPVjeORqe2nGNxtG+eMvg==
X-Google-Smtp-Source: ABdhPJxEHSRz1cCu0m7TXyoTnaLc7pxPXQ3mL/GnGCFCTS9JN9vdq+H0L63oyvPUoLu9gnRZIxPPng==
X-Received: by 2002:a05:6402:3489:: with SMTP id v9mr43316435edc.130.1634550050056;
        Mon, 18 Oct 2021 02:40:50 -0700 (PDT)
Received: from capella.. ([80.208.66.147])
        by smtp.gmail.com with ESMTPSA id z1sm10134566edc.68.2021.10.18.02.40.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Oct 2021 02:40:49 -0700 (PDT)
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
Cc:     arinc.unal@arinc9.com,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v4 net-next 7/7] net: phy: realtek: add support for RTL8365MB-VC internal PHYs
Date:   Mon, 18 Oct 2021 11:38:02 +0200
Message-Id: <20211018093804.3115191-8-alvin@pqrs.dk>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211018093804.3115191-1-alvin@pqrs.dk>
References: <20211018093804.3115191-1-alvin@pqrs.dk>
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

v3 -> v4: no change

v2 -> v3: no change

v1 -> v2: no change

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

