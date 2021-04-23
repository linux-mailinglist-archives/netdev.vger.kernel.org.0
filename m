Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5FB3368C87
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 07:22:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240880AbhDWFWU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 01:22:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240597AbhDWFWE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Apr 2021 01:22:04 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E3FCC06138C;
        Thu, 22 Apr 2021 22:21:29 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id y22-20020a17090a8b16b0290150ae1a6d2bso646149pjn.0;
        Thu, 22 Apr 2021 22:21:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gd2eeenzHzwxV4sfn08mWZUyZJLiTmgc3YKbWO6N3GU=;
        b=qH12pRVy93Bpwpu9grmZX/L/ts8gdwG8rLRbo6+mrLLehr1BCvFrMpf+YUOHiDYyXW
         p3TG8yP/iZIrQVa+VoYBMyaiSHb8prsVoMYBhgWQ4Sj7ZZmzAJjG4GbbSveS9WXYExFJ
         tfnj8xWDI69wTmaGqHq8NVxqBxcKPQF2+Zdq1hxsERD9tOqsymiaSA3Y5bkbK4Tf6P6+
         05kaVXqTtH6JA2NB0NqkqAme+F9DdohNa0fAuv/WNxuc3KYx9BxEf5J8cepxIgwwMjsr
         c1B5YPeIljm23GYN+CJfPHwxR1qygxc2GOA1jRNRKY0KpEr/BkhR44AIr/qO6giYqzUy
         ucqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gd2eeenzHzwxV4sfn08mWZUyZJLiTmgc3YKbWO6N3GU=;
        b=R1quE44qABIgr92cM16bzi+arI+62osAApKfy2wEugwfOID9jo94mRDMI44DwBBeP1
         IteNLTp7gcxA9AxzJvwy65q97nE+lHJQY/kF9/mCIYaoYlngm9e9OqauUopliMCW5Tqu
         ygabSGF8Lwfc0+IumPei/TPhw+UGQQdqExI3Sm6SZHjunji6OBG+Zukwq5DyEaB/BG73
         q2yq0gsEyGuxE/hcpz1cqDclQqKmTX4ELJ9vsGnC+hrQQyF5CYzUBKxgIKJuE6F4YeZi
         3nQJj9DJskvfF6c7g7/MfKG818qPitDz56F4eJ4Xt8eBE+Z9N9OcLlg+XkQbcVx9Yt0l
         XcUA==
X-Gm-Message-State: AOAM530FocZ5Jyxy0OeNggrKdpUzC07PYS/b6YL+oBBNej4+4uMoh1r6
        lE8eNjLH7/tYB+6/dOl2Xm4=
X-Google-Smtp-Source: ABdhPJzSMCg+HXa0Dmt7mvnI+vnZq8ce7m2ns7uSGSYbxV/thCTkhu7yKbJoA8wAJIdnkYkmDVrFwQ==
X-Received: by 2002:a17:902:b68c:b029:eb:6c82:60da with SMTP id c12-20020a170902b68cb02900eb6c8260damr2410047pls.25.1619155288670;
        Thu, 22 Apr 2021 22:21:28 -0700 (PDT)
Received: from z640-arch.lan ([2602:61:7344:f100::678])
        by smtp.gmail.com with ESMTPSA id y24sm6238825pjp.26.2021.04.22.22.21.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Apr 2021 22:21:28 -0700 (PDT)
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
Subject: [PATCH net-next v2 12/15] net: ethernet: mtk_eth_soc: reduce unnecessary interrupts
Date:   Thu, 22 Apr 2021 22:21:05 -0700
Message-Id: <20210423052108.423853-13-ilya.lipnitskiy@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210423052108.423853-1-ilya.lipnitskiy@gmail.com>
References: <20210423052108.423853-1-ilya.lipnitskiy@gmail.com>
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
index 4735942ed283..e1792ccaedc3 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -1519,8 +1519,8 @@ static int mtk_napi_tx(struct napi_struct *napi, int budget)
 	if (status & MTK_TX_DONE_INT)
 		return budget;
 
-	napi_complete(napi);
-	mtk_tx_irq_enable(eth, MTK_TX_DONE_INT);
+	if (napi_complete(napi))
+		mtk_tx_irq_enable(eth, MTK_TX_DONE_INT);
 
 	return tx_done;
 }
@@ -1553,8 +1553,9 @@ static int mtk_napi_rx(struct napi_struct *napi, int budget)
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

