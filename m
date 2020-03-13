Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 800901849B6
	for <lists+netdev@lfdr.de>; Fri, 13 Mar 2020 15:43:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726651AbgCMOnI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Mar 2020 10:43:08 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:45883 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726436AbgCMOnI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Mar 2020 10:43:08 -0400
Received: by mail-pg1-f194.google.com with SMTP id m15so5086683pgv.12;
        Fri, 13 Mar 2020 07:43:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=SpWWV8Vzt0B/4ORSdBbXWuLXrkvKyLnGYjPx6j+va9s=;
        b=m5LgmXEhwH7qCMpy8AMDQtFnKbFzLNd1lr8HbI+GFBXXqqW/U4D2/KYjmL2jzG7Gkx
         M1tgXjecGU60owDjsMItfb2FLXxIV0w58gQtMcgOUtkpmit0RQOA2R/IHV1yKcKQwhv1
         2Kl2JDS6eL/Ykw2oMVcgdxPBxDCejryFlWxySlM/eK/yjHzoq+/DYHygSkqCHV6DsSVu
         3rulJur/sf4uP23ZLtnbmejV+P0cZ3W+hz3WbGfpA0Kghk2bOPYnnPymXChNVon3NHU5
         9A0JPNXyrG7c6ND4Y7seYi+1uljFG0f6rCPiJhStPjqtVX842n1R0PL6Vq0R7ww9jBwA
         awzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=SpWWV8Vzt0B/4ORSdBbXWuLXrkvKyLnGYjPx6j+va9s=;
        b=mmR7cKZoexH1PsK73t7QSSyfCkkrvPYOJkl5sZww7QqoTN9Q6wcirMFYAFr+ktTr7+
         0AywYK/cLM4URuapprLxSopa39E5WtQSmoXrg91o02YTbK1n+HZBvNmL3K7PSgpf0ybS
         81Nq4/tkKkwOdDfkx+9IMbTv/Cx49ooEdcc6+lv0ngk8PEDSrUnXlPzlMKpEGn7nB9kP
         xcp+GRccZUaOsF3OE5bEMnKOtpMmrbVZGfOAYwXxesM+yBi6J6Vb0El/2jFdA2SQpD7a
         tRi20CaJ2cag0PI/9EhgqgQOHfzNOETxlpxmhh1XEHcwBxTtNmD9va8i0xLTZlyaPwJj
         dmqg==
X-Gm-Message-State: ANhLgQ379Lf0U/7NUrc7Cz10WfBPwMYo1gd0mvPpl27hO9DM+OqsC/6S
        E/IzKF0cOSfDRG4apSdEN6w=
X-Google-Smtp-Source: ADFU+vvCSWa2zU2rVO+1qqNp6WqSxenT9MGNGT5GMXvMz5XxJH9Q1BP281Kw1otg0AVl+FTOOIzmzw==
X-Received: by 2002:a63:6907:: with SMTP id e7mr13366263pgc.445.1584110586743;
        Fri, 13 Mar 2020 07:43:06 -0700 (PDT)
Received: from localhost ([216.24.188.11])
        by smtp.gmail.com with ESMTPSA id f8sm1000121pfq.178.2020.03.13.07.43.04
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 13 Mar 2020 07:43:06 -0700 (PDT)
From:   Dejin Zheng <zhengdejin5@gmail.com>
To:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, davem@davemloft.net,
        mcoquelin.stm32@gmail.com, netdev@vger.kernel.org
Cc:     linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Dejin Zheng <zhengdejin5@gmail.com>
Subject: [PATCH net-next] net: stmmac: platform: convert to devm_platform_ioremap_resource
Date:   Fri, 13 Mar 2020 22:42:57 +0800
Message-Id: <20200313144257.9351-1-zhengdejin5@gmail.com>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use devm_platform_ioremap_resource() to simplify code, which
contains platform_get_resource and devm_ioremap_resource.

Signed-off-by: Dejin Zheng <zhengdejin5@gmail.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
index d10ac54bf385..bbc0a2ce24c0 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
@@ -645,8 +645,6 @@ EXPORT_SYMBOL_GPL(stmmac_remove_config_dt);
 int stmmac_get_platform_resources(struct platform_device *pdev,
 				  struct stmmac_resources *stmmac_res)
 {
-	struct resource *res;
-
 	memset(stmmac_res, 0, sizeof(*stmmac_res));
 
 	/* Get IRQ information early to have an ability to ask for deferred
@@ -674,8 +672,7 @@ int stmmac_get_platform_resources(struct platform_device *pdev,
 	if (stmmac_res->lpi_irq == -EPROBE_DEFER)
 		return -EPROBE_DEFER;
 
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	stmmac_res->addr = devm_ioremap_resource(&pdev->dev, res);
+	stmmac_res->addr = devm_platform_ioremap_resource(pdev, 0);
 
 	return PTR_ERR_OR_ZERO(stmmac_res->addr);
 }
-- 
2.25.0

