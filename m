Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4C51367851
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 06:13:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234920AbhDVEKf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 00:10:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231631AbhDVEKS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Apr 2021 00:10:18 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40C09C06138F;
        Wed, 21 Apr 2021 21:09:44 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id u11so16942680pjr.0;
        Wed, 21 Apr 2021 21:09:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=afUBNnLCnALHd7nnFx3FLIxkkAO2cCALl7BKYrqLlkY=;
        b=NYPusNMiIJkw5Pdj0XLU0ZWAtBJ0PRpny5fTeVCaCzLnmSQcEDHAq7Vi7RNZjCpNTQ
         I5AampDypMlwhKH63+UIQ9Rqo0b/ucLYFYhkqmpcZsvN0/tElVkYsN0c4svAcDAHxaZH
         4y8FzJ9y1M2kNkuLvnfpGPkgqxcOJ2VAIjBdBcHb7mwcpCShQdGbUKnHrJtWkteMN4IT
         w0NS/kGQzmcUKU0MKLeAUh/x0Bih+w1G8WEM+2c3MmDaYDJKoJvqrQ0XUsWFC6iBdpKw
         TcVeoTYNjvy5iMlkQjl2/duH/+wQRLDvC3YQMzrCLRGU004SfgDZs4LUh6xvY9khhGJY
         89PQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=afUBNnLCnALHd7nnFx3FLIxkkAO2cCALl7BKYrqLlkY=;
        b=I90iVXO2t0Ycaeyc0YJE2nZj0Cc+XiNYBsaPIB7J4W/LXK72Xkk0XMue73tdl8ZANT
         J/gFP8rT3gIcJLNLiyqucG8CM0DM6J0wKmZzST/ubZ7J0NdjkK567Xxhv7aEevMxYERe
         venZwMYzL4L8lprSYHQVggGCR2BN+os+akG0g7i9IhMU+Ib0p4sHyuMtqP4YsaocoF19
         4VzIlZ2Nzmc1sghkxiGooynweSlUtl4i/7Y3+DqOAKxxbIc4q1Pc16tD4EDChNj9NtWJ
         Vyy6spQFl2ORZmprrkAFGDw/dmTi0mDzxcuPwibwVKrEIqqFEwlYa4rMf/RKmGwf2pjF
         kzxQ==
X-Gm-Message-State: AOAM531nV7vDvsdT0n5t+/XVVZPGHdXvR66apTeqkjgWMRDYe87QV/59
        2GcV6hQ1ghlUszQoPu2EUhM=
X-Google-Smtp-Source: ABdhPJyT3tO2UDDnQGbg/SV0FqbB8c0SOkNZA3M1yGxzusU3coNCVsdmTqvxDM6990gfNcEuqYSXXg==
X-Received: by 2002:a17:902:e34b:b029:ec:9a57:9cba with SMTP id p11-20020a170902e34bb02900ec9a579cbamr1505555plc.56.1619064583871;
        Wed, 21 Apr 2021 21:09:43 -0700 (PDT)
Received: from z640-arch.lan ([2602:61:7344:f100::678])
        by smtp.gmail.com with ESMTPSA id i17sm635354pfd.84.2021.04.21.21.09.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Apr 2021 21:09:43 -0700 (PDT)
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
Subject: [PATCH net-next 08/14] net: ethernet: mtk_eth_soc: increase DMA ring sizes
Date:   Wed, 21 Apr 2021 21:09:08 -0700
Message-Id: <20210422040914.47788-9-ilya.lipnitskiy@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210422040914.47788-1-ilya.lipnitskiy@gmail.com>
References: <20210422040914.47788-1-ilya.lipnitskiy@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Felix Fietkau <nbd@nbd.name>

256 descriptors is not enough for multi-gigabit traffic under load on
MT7622. Bump it to 512 to improve performance.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.h b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
index 039c39d750e0..4999f8123180 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.h
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
@@ -22,7 +22,7 @@
 #define MTK_MAX_RX_LENGTH	1536
 #define MTK_MAX_RX_LENGTH_2K	2048
 #define MTK_TX_DMA_BUF_LEN	0x3fff
-#define MTK_DMA_SIZE		256
+#define MTK_DMA_SIZE		512
 #define MTK_NAPI_WEIGHT		64
 #define MTK_MAC_COUNT		2
 #define MTK_RX_ETH_HLEN		(ETH_HLEN + ETH_FCS_LEN)
-- 
2.31.1

