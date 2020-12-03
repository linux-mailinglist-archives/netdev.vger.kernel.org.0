Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FB2D2CE122
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 22:49:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502123AbgLCVrk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 16:47:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2502110AbgLCVrj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Dec 2020 16:47:39 -0500
Received: from mail-qv1-xf43.google.com (mail-qv1-xf43.google.com [IPv6:2607:f8b0:4864:20::f43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A59C6C08E861;
        Thu,  3 Dec 2020 13:46:50 -0800 (PST)
Received: by mail-qv1-xf43.google.com with SMTP id ek7so1784839qvb.6;
        Thu, 03 Dec 2020 13:46:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=+E+uz7zuA1WB6pwsgKOtfhChnQQmpTGyAUV3IiWnnIA=;
        b=VoI87Vp1GJvO6oN9QCkaZxu/0CILLPQ5DYwpQ//SNKkXVXzdiazn2O7O3pDPr8IfS8
         cELyjT5qIRjIgTw1QBnhU80eNOGQ+Ko/DzP31V1Cr9lXQ1trWzw1YDZpD/Ujb8KU+Dy4
         xTx5uLcivVMG6EIUi2C1s1KstTPjUkjWKjXve/Q68i44idW0xo6lm1vj3oIPGn8wE/TB
         z99beYMIr3dPHqY0YnsH9sKO2pvILFZHPMCnps+oOGpLF40IR8DSCbgsLUtvBkAXagUs
         XrCZTw7j7A1yRvjLBdhPt2OMowx+HhW+fcmuR4ydaO2iXHtaqoCC0fzwl0Q9UTrT6thW
         PIzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=+E+uz7zuA1WB6pwsgKOtfhChnQQmpTGyAUV3IiWnnIA=;
        b=mQIbsdnlfeEt2bUWqxe7GvL3Ly9SnSI0ciXy122MvQODCyCpmh1Maxj13yStMTUBP/
         wzGZ8iodWtnrfRser7+l2bHlX4xMwrO8z75moUM6YzfX60LotYe3g3BtsvzNQNlZ7Fwy
         KTqhh88VIcqeVvfISS117iX0PWmx8PHkNgpaGofNsc6HFznnMrMxjHOO5BGRgMju6cxR
         nIC/AjCkWhXf42rSoZyatHhbl4y+h9Ywe2Vh1guexpAGg7oDqRkFsL4rVTHIyYH9de9R
         Oonq+5Zx7bCrC/ta3vnVjMc2PTv/FYyd1Y6zAPmTSWerFfG9JFaMme/9IqwIwhF8Wzh8
         qZqQ==
X-Gm-Message-State: AOAM532J31vRmgBhlZPAxd8yfNqfC7GwvaYWYMf2km/FEGHbWUJiieS6
        1eQ6TZHxUC2vdrlc+Ew3ekg=
X-Google-Smtp-Source: ABdhPJxhK8uB4IT40UiGaz7gyVsBmPBETd2FXW2E/lVWEyHrKZmfKWve60o9UlhOY3A9lbOWzNDdNw==
X-Received: by 2002:ad4:5bad:: with SMTP id 13mr1195018qvq.23.1607032009842;
        Thu, 03 Dec 2020 13:46:49 -0800 (PST)
Received: from svens-asus.arcx.com ([184.94.50.30])
        by smtp.gmail.com with ESMTPSA id d66sm3018268qke.132.2020.12.03.13.46.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Dec 2020 13:46:49 -0800 (PST)
From:   Sven Van Asbroeck <thesven73@gmail.com>
X-Google-Original-From: Sven Van Asbroeck <TheSven73@gmail.com>
To:     Woojung Huh <woojung.huh@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        David S Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Sven Van Asbroeck <thesven73@gmail.com>,
        Marek Vasut <marex@denx.de>,
        Tristram Ha <Tristram.Ha@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net v1] net: dsa: ksz8795: use correct number of physical ports
Date:   Thu,  3 Dec 2020 16:46:45 -0500
Message-Id: <20201203214645.31217-1-TheSven73@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sven Van Asbroeck <thesven73@gmail.com>

The ksz8795 has five physical ports, but the driver assumes
it has only four. This prevents the driver from working correctly.

Fix by indicating the correct number of physical ports.

Fixes: e66f840c08a23 ("net: dsa: ksz: Add Microchip KSZ8795 DSA driver")
Tested-by: Sven Van Asbroeck <thesven73@gmail.com> # ksz8795
Signed-off-by: Sven Van Asbroeck <thesven73@gmail.com>
---

Tree: git://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git # 39e367766fe1

To: Woojung Huh <woojung.huh@microchip.com>
To: Andrew Lunn <andrew@lunn.ch>
To: Vivien Didelot <vivien.didelot@gmail.com>
To: Florian Fainelli <f.fainelli@gmail.com>
To: Vladimir Oltean <olteanv@gmail.com>
To: "David S. Miller" <davem@davemloft.net>
To: Jakub Kicinski <kuba@kernel.org>
Cc: Marek Vasut <marex@denx.de>
Cc: Tristram Ha <Tristram.Ha@microchip.com>
Cc: Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>
Cc: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org (open list)

 drivers/net/dsa/microchip/ksz8795.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/microchip/ksz8795.c b/drivers/net/dsa/microchip/ksz8795.c
index 1e101ab56cea..367cebe37ae6 100644
--- a/drivers/net/dsa/microchip/ksz8795.c
+++ b/drivers/net/dsa/microchip/ksz8795.c
@@ -1194,7 +1194,7 @@ static const struct ksz_chip_data ksz8795_switch_chips[] = {
 		.num_alus = 0,
 		.num_statics = 8,
 		.cpu_ports = 0x10,	/* can be configured as cpu port */
-		.port_cnt = 4,		/* total physical port count */
+		.port_cnt = 5,		/* total physical port count */
 	},
 	{
 		.chip_id = 0x8794,
-- 
2.17.1

