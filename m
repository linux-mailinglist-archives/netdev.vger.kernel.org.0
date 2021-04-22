Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABDCB367858
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 06:13:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235102AbhDVELD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 00:11:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234686AbhDVEKW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Apr 2021 00:10:22 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CC25C06138B;
        Wed, 21 Apr 2021 21:09:48 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id em21-20020a17090b0155b029014e204a81e6so2020419pjb.1;
        Wed, 21 Apr 2021 21:09:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9BOejhcXoXhyXTSBmLuvv47XDq5x1HtwxwRsIb2foI0=;
        b=kXLXNAS45PBewZl46uLw8yvajpf7UbKUWcXnUL7NxHB1rIq7y4NE3XI+kwO9y5mIlr
         RFcLwrUkVE1FEoXGQ9mEy9cMIlCyCFFXVssKp7SbCTUr+Zwn7ROumRk88XmThh3lNj8E
         zmiYac46vrstHv+nl9kQ0eUJjTYTvTkE28VYEbN/Hx295dvNUAcJgZOINDnWx1CxcvvJ
         SWp845sDxxvOJIJQmKZcd0XUBr/HqiijzZLkKAU3gCuJbguTny1vspGg+up5NkSh2TPy
         IyJIfofltt2JleFHax76OlALlkddx/4UeMcD46q3mtt6v/MHccEkq9y7Uiz3ZjHOoToD
         qVVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9BOejhcXoXhyXTSBmLuvv47XDq5x1HtwxwRsIb2foI0=;
        b=Z8GwnZdDo6nqwMhiWUfSoGIooXMUZDMr+Lbe/oN69wMzVTFFn8OHIIQep86PCKUw7w
         QV6yM7SE4kyGLwPGb70jxO8Ac9OvWuJZ2rcfICfgi0aNISoClQ29LR2TcgNaUdUrfoDT
         WTX1TM4pP2xDmq3Y+SNVgxVflE7pj4/cJLRSNv4yHWNJXkpJblYHPQ3QsSH3eMrEWt8R
         PnXWFXzGd+yE8954WsBFR73ENgW5nOLL0STuMYwoTc0PjDew9p075wAtYYOhq7e2Gc0S
         pyfJAIZfLyQUzYfhXribZLi5i6YMgSC5lVahA8I0PmsrFZtcInNtFqv4+uiOf+9ORPgK
         07Kg==
X-Gm-Message-State: AOAM530wlrh7uKcN+izOtK5BeusaHM4SKLMwXXbvOHJS5M5q5fCfh76j
        zkdS0VjIxx5BDyGMbGZ6zpM=
X-Google-Smtp-Source: ABdhPJz2F7ul6sPxW+us4a3mzFh33oXjK5llgy7v+IeTQIwQiGEmxWbOHVBvse0swyjBzk0X5z+UGA==
X-Received: by 2002:a17:902:cec3:b029:eb:5441:9897 with SMTP id d3-20020a170902cec3b02900eb54419897mr1387610plg.48.1619064587945;
        Wed, 21 Apr 2021 21:09:47 -0700 (PDT)
Received: from z640-arch.lan ([2602:61:7344:f100::678])
        by smtp.gmail.com with ESMTPSA id i17sm635354pfd.84.2021.04.21.21.09.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Apr 2021 21:09:47 -0700 (PDT)
From:   Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
To:     Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Cc:     Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
Subject: [PATCH net-next 12/14] net: ethernet: mtk_eth_soc: reduce unnecessary interrupts
Date:   Wed, 21 Apr 2021 21:09:12 -0700
Message-Id: <20210422040914.47788-13-ilya.lipnitskiy@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210422040914.47788-1-ilya.lipnitskiy@gmail.com>
References: <20210422040914.47788-1-ilya.lipnitskiy@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Felix Fietkau <nbd@nbd.name>

Avoid rearming interrupt if napi_complete returns false

Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index 5a531bb83348..88a437f478fd 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -1517,8 +1517,8 @@ static int mtk_napi_tx(struct napi_struct *napi, int budget)
 	if (status & MTK_TX_DONE_INT)
 		return budget;
 
-	napi_complete(napi);
-	mtk_tx_irq_enable(eth, MTK_TX_DONE_INT);
+	if (napi_complete(napi))
+		mtk_tx_irq_enable(eth, MTK_TX_DONE_INT);
 
 	return tx_done;
 }
@@ -1551,8 +1551,9 @@ static int mtk_napi_rx(struct napi_struct *napi, int budget)
 		remain_budget -= rx_done;
 		goto poll_again;
 	}
-	napi_complete(napi);
-	mtk_rx_irq_enable(eth, MTK_RX_DONE_INT);
+
+	if (napi_complete(napi))
+		mtk_rx_irq_enable(eth, MTK_RX_DONE_INT);
 
 	return rx_done + budget - remain_budget;
 }
-- 
2.31.1

