Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5DC64837A7
	for <lists+netdev@lfdr.de>; Mon,  3 Jan 2022 20:40:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234201AbiACTkf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jan 2022 14:40:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233450AbiACTke (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jan 2022 14:40:34 -0500
Received: from mail-vk1-xa33.google.com (mail-vk1-xa33.google.com [IPv6:2607:f8b0:4864:20::a33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49184C061761;
        Mon,  3 Jan 2022 11:40:34 -0800 (PST)
Received: by mail-vk1-xa33.google.com with SMTP id m200so19421907vka.6;
        Mon, 03 Jan 2022 11:40:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0yThoTV+RS18CRQ2uhToFwD8vowRI/t+DmQcT4bfRDQ=;
        b=AYJ0m/hJg238lQCW9AljqQ6g7YTe5SMoBHWAEcv/ADmCK+3mK6RLrgpfHpDAWmyfno
         664nsNaFLdeebOM1kcDbhtJGyDqmvHs78JPOc+QCzCswfS0MIb/J6RPmYCIKW/W/sWaZ
         STa0m2KXzHvCiLdwwmqm2Qejg7q+DT0NbW+Ft+WrzkyiTI6pWODVZyPwVLMpGosyM3eC
         efZ8rNvxZv+ZBY3nx5APRLnMmsw/mblubL9C2AgIi5843TV+3x3n2X7kfNwzs/pr1QmS
         qoF6kQJxwTI66s8gkLtzVcqY+ALr4DiDyraYLeHDAHE9rf5weQnajK7Tbnypz15M5G15
         opeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0yThoTV+RS18CRQ2uhToFwD8vowRI/t+DmQcT4bfRDQ=;
        b=6FNZZm1BWNb6x4cTT5H+l5tksQAxgRM0/FwDhwjVkcWyWebprJ6i/Xz0Ee/TYHM4mh
         AuD+Uza+E1PyEkWxy4CKDQIBERqRhFg88KgLhwABoLsS5OVSamqLX52Y/eiAdxME11vb
         gidKqJIsLQAduvjYDtYgq9rQCNKSAYvSYl1FjIAb6/iKhwF2WLcJVGTTpU2lmnR8raTl
         yCHT+ZenpuoyMnretXjfRia5+5eH6j963D2Wp5Yisg1H9HGlsE+2Y2rganjBjfrKakUn
         BQHdRZnOjxWR8mjmw2cZwz0LBZ89T6F6hcgsEdrVG8TBSNsjH/yGVwwiBC4hvaY4i8BD
         KK2Q==
X-Gm-Message-State: AOAM533yLd0HDsZIwkdarkhx/uhdWpgdN5nAHNGraXBcNL+GTmhT+qwJ
        f1fsqmrz3WyekY4XFFYgPNjFe8AK5OM=
X-Google-Smtp-Source: ABdhPJxKqGuaNP5wEXjBHSvdtqcp4oMCCQOLx4Zq4avFwousGq32deS9be7pp/BmtMoDye4/GRTkfQ==
X-Received: by 2002:a1f:1bd0:: with SMTP id b199mr1788528vkb.33.1641238833064;
        Mon, 03 Jan 2022 11:40:33 -0800 (PST)
Received: from 7YHHR73.igp.broadcom.net ([192.19.161.250])
        by smtp.gmail.com with ESMTPSA id y19sm4595905uad.14.2022.01.03.11.40.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Jan 2022 11:40:32 -0800 (PST)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Maxime Bizon <mbizon@freebox.fr>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net-next] net: mdio: Demote probed message to debug print
Date:   Mon,  3 Jan 2022 11:40:24 -0800
Message-Id: <20220103194024.2620-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On systems with large numbers of MDIO bus/muxes the message indicating
that a given MDIO bus has been successfully probed is repeated for as
many buses we have, which can eat up substantial boot time for no
reason, demote to a debug print.

Reported-by: Maxime Bizon <mbizon@freebox.fr>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/phy/mdio_bus.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
index f52da568cce3..58d602985877 100644
--- a/drivers/net/phy/mdio_bus.c
+++ b/drivers/net/phy/mdio_bus.c
@@ -597,7 +597,7 @@ int __mdiobus_register(struct mii_bus *bus, struct module *owner)
 	mdiobus_setup_mdiodev_from_board_info(bus, mdiobus_create_device);
 
 	bus->state = MDIOBUS_REGISTERED;
-	pr_info("%s: probed\n", bus->name);
+	dev_dbg(&bus->dev, "probed\n");
 	return 0;
 
 error:
-- 
2.25.1

