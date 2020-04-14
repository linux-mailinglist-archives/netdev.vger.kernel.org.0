Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCA1D1A8EB6
	for <lists+netdev@lfdr.de>; Wed, 15 Apr 2020 00:40:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392042AbgDNWkC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Apr 2020 18:40:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729629AbgDNWkA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Apr 2020 18:40:00 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB0CCC061A0C;
        Tue, 14 Apr 2020 15:39:58 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id m16so513456pls.4;
        Tue, 14 Apr 2020 15:39:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9t1OfRpRitZtOf4uo1UYB1/mDlF//ZHx3ZZOkOotBBs=;
        b=l3XQpqCuW3oYa5DHK/NlM9glUOcgF931LKIPpyUBbva6wQh/ApqWSeCHyzi1hghTZH
         E28Z7/PJgq8fK1ExjJYDRNg4bZEoHVY1Ka5gYHY7mRzcqb+ZSh6TFhMkpczIT5DetY1E
         Vfj0fgXh0s7lbHOBTeyH7qVzN6vqDxOPeyU369EWm3IC4lAaYIl58qqVXJdRpWo98ba6
         YwME3XfFr32hcDXqmy2j9PTh2FH/yV5Kc3Dbd3hIWB0AH7Sd2tg6uCIGaKfOW18TVAkM
         jLTIivkcJLKxd3oVpuERxs6gjCojoeC0IVzTuimvDjg/UPsqZ8qI/Yy/o+l+uNXkalOH
         7SeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9t1OfRpRitZtOf4uo1UYB1/mDlF//ZHx3ZZOkOotBBs=;
        b=lsKMUZOdi+fJrvMaKXVrzsVJDkVhTscdtKQGCcyAN49PFH3PKBLoS7I+hH+ENLMhSb
         6jEO7Wl/hmFIacQ6e3k9c0ycAS5rIHEJvkA0aiIUN29SHloN3PbRPeYEQF8jiRG6L3F2
         vOt/9opm5VuaRYulFaRp3yJXed6KB+R7Iz3+o3J6wX+Xpsf+TVbfsTaQQYrYn02GmOgw
         fLueMmilHWeJfPTTA8OO/W1uzY1Ql6O0amJF0LH6xkkdkbG2kGywJHVXal8EMJskRN62
         /VwN+XV0NkJEOgaSN4q0iYYUeAtLc3JZ8gXM5lgTXJbdAYXrMQgV4d4GzwGH02Pvbdbr
         itqg==
X-Gm-Message-State: AGi0PuZCAmJpN9Kt9zsNCpvZY2QtHs+9ABFYxSmhlCeF0bzpx5We4ZEo
        SKR66ePAE8jgAE3pAIVROIL1CJfT
X-Google-Smtp-Source: APiQypLpzCWuUJeGz0XSN07gJ7EzCXSnJI9C2zEP968l+WFRfqF85ygGJoM3ztime9HQeFmq1bturg==
X-Received: by 2002:a17:902:262:: with SMTP id 89mr2073094plc.131.1586903997813;
        Tue, 14 Apr 2020 15:39:57 -0700 (PDT)
Received: from localhost.localdomain (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id e11sm12176214pfl.65.2020.04.14.15.39.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Apr 2020 15:39:56 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     olteanv@gmail.com, Florian Fainelli <f.fainelli@gmail.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Ripard <mripard@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        linux-arm-kernel@lists.infradead.org (moderated list:ARM/Allwinner
        sunXi SoC support),
        linux-stm32@st-md-mailman.stormreply.com (moderated list:ARM/STM32
        ARCHITECTURE), linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net] net: stmmac: dwmac-sunxi: Provide TX and RX fifo sizes
Date:   Tue, 14 Apr 2020 15:39:52 -0700
Message-Id: <20200414223952.5886-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After commit bfcb813203e619a8960a819bf533ad2a108d8105 ("net: dsa:
configure the MTU for switch ports") my Lamobo R1 platform which uses
an allwinner,sun7i-a20-gmac compatible Ethernet MAC started to fail
by rejecting a MTU of 1536. The reason for that is that the DMA
capabilities are not readable on this version of the IP, and there
is also no 'tx-fifo-depth' property being provided in Device Tree. The
property is documented as optional, and is not provided.

Chen-Yu indicated that the FIFO sizes are 4KB for TX and 16KB for RX, so
provide these values through platform data as an immediate fix until
various Device Tree sources get updated accordingly.

Fixes: eaf4fac47807 ("net: stmmac: Do not accept invalid MTU values")
Suggested-by: Chen-Yu Tsai <wens@csie.org>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-sunxi.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-sunxi.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-sunxi.c
index 7d40760e9ba8..0e1ca2cba3c7 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-sunxi.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-sunxi.c
@@ -150,6 +150,8 @@ static int sun7i_gmac_probe(struct platform_device *pdev)
 	plat_dat->init = sun7i_gmac_init;
 	plat_dat->exit = sun7i_gmac_exit;
 	plat_dat->fix_mac_speed = sun7i_fix_speed;
+	plat_dat->tx_fifo_size = 4096;
+	plat_dat->rx_fifo_size = 16384;
 
 	ret = sun7i_gmac_init(pdev, plat_dat->bsp_priv);
 	if (ret)
-- 
2.19.1

