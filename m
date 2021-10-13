Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A20842C400
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 16:51:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237859AbhJMOxZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 10:53:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237860AbhJMOxN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Oct 2021 10:53:13 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCC46C061764
        for <netdev@vger.kernel.org>; Wed, 13 Oct 2021 07:51:09 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id g10so11432889edj.1
        for <netdev@vger.kernel.org>; Wed, 13 Oct 2021 07:51:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pqrs.dk; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qIGrxPrX/5Qdzso08VaHMbyDPIhwyDSE1YbGuKz74Ic=;
        b=Gca8ta1WL/iPld9An4mFFTAeMO8yjMYP2PvRvYoYRKDMAcHQJ3m3g2OcHscvzDxW4o
         1b3ywQWHHzR1j6lgrHwtPd2cMcmoftk1d7nBTwg/bMSoFRagexzN5Nmp8g6ZGxc8nxPY
         QEsPKEV/IZ/YUgkk1yO0QlfYWMPr/ZetBUOF4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qIGrxPrX/5Qdzso08VaHMbyDPIhwyDSE1YbGuKz74Ic=;
        b=T/S+KshxIRgAiiaq6iTgXaVzyMTULWJIlR3KY5yNffBU9uZzc+QScmDghHle6yeR/X
         T4NI9BsHp+elDVTjcaqmUMD2Kyj2SQmh3hJuJF8gpAVw423f7PTp+T65nDokLrrDg0Gy
         6JFtxwE+Wr0Eqy/H8RohBQDdUKs5dmaaoWqSU5bWFuyyaZOcYCjg5qMmei2+9RPXc2jq
         g6aL6JecDtyiB7filF9nGS22RmkEotqljPsUxO931qEphQGdwV70JWsxpsnPA/QGRFqc
         1M0Pa5F76CNxbNKVWzA4wjx0ix97p+pc0fmIDpwy/cWkjnOubUyH5psykDpivN2tPn+i
         tzJA==
X-Gm-Message-State: AOAM532OW7byAlCD37We3wY3ekRf+jM6AGRjKpJerQ2/VQ5TelHT4khL
        TvYiZ60UP4u2bUu5iT/hP8X4ag==
X-Google-Smtp-Source: ABdhPJwpLeOjWe9aVOSzKFAmwWYh7KjPb8DX+cO0BCTUCesFPom2MJE5rJ1x/BnbJNfVyBnJPT999Q==
X-Received: by 2002:a05:6402:5187:: with SMTP id q7mr10119779edd.374.1634136668453;
        Wed, 13 Oct 2021 07:51:08 -0700 (PDT)
Received: from capella.. (27-reverse.bang-olufsen.dk. [193.89.194.27])
        by smtp.gmail.com with ESMTPSA id nd22sm7535098ejc.98.2021.10.13.07.51.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Oct 2021 07:51:08 -0700 (PDT)
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
Subject: [PATCH v2 net-next 6/6] net: phy: realtek: add support for RTL8365MB-VC internal PHYs
Date:   Wed, 13 Oct 2021 16:50:38 +0200
Message-Id: <20211013145040.886956-7-alvin@pqrs.dk>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211013145040.886956-1-alvin@pqrs.dk>
References: <20211013145040.886956-1-alvin@pqrs.dk>
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

