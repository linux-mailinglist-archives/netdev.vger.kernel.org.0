Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D23F321D9E3
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 17:12:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730055AbgGMPMM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 11:12:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729308AbgGMPML (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 11:12:11 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8449DC061755
        for <netdev@vger.kernel.org>; Mon, 13 Jul 2020 08:12:11 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id q5so16968701wru.6
        for <netdev@vger.kernel.org>; Mon, 13 Jul 2020 08:12:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=c9xxbXFyrtlGeFDUjb611TWuOvSdsWZ5MdXBOYYr2j8=;
        b=YKsGX6vZMawq7T2fMKOHhZBjRXmK2aFNzZOc1jZ6HIHbBIqYejfmAC9S7AQhTVE7u6
         0Qo66R4UQGE9m5FcdrBHVZm08dkZngp4+e3dIjfTn1y2R1CtM6jJGmgeSukEbmjVxb88
         /fK8ZVsp94fwqQ4Wfjd+aHg+wPYKvdFccL8/4BNe0LrzXvkTq1gJiD+KaoCaak+eFFBo
         UvmJ3kTp13r6Ey7PGzV+17Hey7b7JzDu/fp09foEBdOYBYLCfRuRyJwXjTe0GOGm+eqa
         xO6NefVRgOmwcmplwCqHyZioMU8cfFuQOUCSzc8y6S6jY5V9kWzk+KgdOUANk4DXYwKg
         m5QQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=c9xxbXFyrtlGeFDUjb611TWuOvSdsWZ5MdXBOYYr2j8=;
        b=pPXObi/AkOoVl0A7HlOehEKtOMnHM5Z3+JBtVohsflAwJo7FgGm6xpGDlGoYea5kZe
         YDhnpbwtaXGE6qBwM0FO2fo/GrB0wfq5x5r9FsBZIRg9Ha/O4A47ipEpGmvF/ZxkSOgc
         6E+VZkQ29k3W98YBrhJS3cnNz/fc8udVvjH1ijfC1SBPd5A+wRIoFbHR3FoeaW7+ZQqa
         WboJbEyX0k5+xhMyhTQv8SSAtpkN8nyagat7OAOrEURtEyMrqY3hWpJ2+wqd4rM6QL7V
         tcPDIiye2FQVDihxFPjOxvZGAAhfVDs6RzdACuTg5gTlIbceuPK3jBsG2Ax4cuzj9vuF
         GqWg==
X-Gm-Message-State: AOAM530tKP+FRhXsNyZ86ntO26wicW7ZepVPWsB9A8jbakYxMwOyqWeB
        TnorZCJUykdFNLa1Lo/OJ2GqIQ==
X-Google-Smtp-Source: ABdhPJxgl7e4SXZGiBQHgW6nDqBxiEfI26ZYvhrRLJFDd7dULkmU0/xIRAlcSaiExjcYdao35CCBvg==
X-Received: by 2002:a5d:4a84:: with SMTP id o4mr38781714wrq.104.1594653130157;
        Mon, 13 Jul 2020 08:12:10 -0700 (PDT)
Received: from debian-brgl.home (lfbn-nic-1-68-20.w2-15.abo.wanadoo.fr. [2.15.159.20])
        by smtp.gmail.com with ESMTPSA id j24sm25203665wrd.43.2020.07.13.08.12.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2020 08:12:09 -0700 (PDT)
From:   Bartosz Golaszewski <brgl@bgdev.pl>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        kernel test robot <lkp@intel.com>
Subject: [PATCH] net: phy: fix mdio-mscc-miim build
Date:   Mon, 13 Jul 2020 17:12:07 +0200
Message-Id: <20200713151207.29451-1-brgl@bgdev.pl>
X-Mailer: git-send-email 2.26.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bartosz Golaszewski <bgolaszewski@baylibre.com>

PHYLIB is not selected by mdio-mscc-miim but it uses mdio devres helpers.
Explicitly select MDIO_DEVRES in this driver's Kconfig entry.

Reported-by: kernel test robot <lkp@intel.com>
Fixes: 1814cff26739 ("net: phy: add a Kconfig option for mdio_devres")
Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
---
 drivers/net/phy/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/phy/Kconfig b/drivers/net/phy/Kconfig
index 7ffa8a4529a8e..dd20c2c27c2f6 100644
--- a/drivers/net/phy/Kconfig
+++ b/drivers/net/phy/Kconfig
@@ -185,6 +185,7 @@ config MDIO_MOXART
 config MDIO_MSCC_MIIM
 	tristate "Microsemi MIIM interface support"
 	depends on HAS_IOMEM
+	select MDIO_DEVRES
 	help
 	  This driver supports the MIIM (MDIO) interface found in the network
 	  switches of the Microsemi SoCs; it is recommended to switch on
-- 
2.26.1

