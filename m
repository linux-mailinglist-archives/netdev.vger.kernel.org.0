Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9872E47A8D7
	for <lists+netdev@lfdr.de>; Mon, 20 Dec 2021 12:36:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231936AbhLTLgy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Dec 2021 06:36:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231239AbhLTLgy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Dec 2021 06:36:54 -0500
Received: from mail-qk1-x729.google.com (mail-qk1-x729.google.com [IPv6:2607:f8b0:4864:20::729])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03643C061574;
        Mon, 20 Dec 2021 03:36:54 -0800 (PST)
Received: by mail-qk1-x729.google.com with SMTP id l25so8992836qkl.5;
        Mon, 20 Dec 2021 03:36:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=yJJiyjdfsULMBTvd0urPhrZDTQqpdHh9o/xRZvWxFmE=;
        b=d5GusZXStbS810bb8KHJdLhAl7l+fY6sci/7mbz+JIlf1LYRjxPEPB2Oq4mB5k+VYg
         gP4zgZQ15qRt+7oicAm1xuk9TK0mt5uR/5xSN56giCjyUsOr5aE/3mWoob8kMKImqAjN
         foIngnoEp0VeclLqLAbFfptbqRSmh/X7NSKFuX8I+k7LF1v3ttkCcGkbIHcFjZgdpE8l
         xezZ1GaX5tI80Dio/afrlP/Z+x2PZg9Avo09BJzpj/GCD6fw2I7mgyQSxLQlnANohyBI
         EB212RSmB1EA85dJabYWK0LGSt/XB9VgjL0hUdWtfLJKoLb/pOjnGCWdOjbuoEf2UnNf
         iwBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=yJJiyjdfsULMBTvd0urPhrZDTQqpdHh9o/xRZvWxFmE=;
        b=pA9FVq+VyFIUa5nf4/O3zMi8agbtY7wIs2ohj9JtiDbC8FFsLIqYx6gKc3DcTXnfV+
         8oK4iSBId0L2vsu4Vy2YA+8UtcBRX7qMrpB8quxrsdTK1AYeBM0VJ89u4XMrfeFq06m8
         IR2ZldoyIQ+JDrqoA3IdFMxmIJISGMfknCZyriYkXVvdbQMhLkdiaGZau7/3rXCbmOFy
         XVcRd9DMHDTR6oDxADaA34kCm0knlBOJEbzhWcp9M0fMWyhCU7r59EZ0XRDR4xVgBeVq
         gC0YyCcIVZi0riAyuCkDrq1T4Y7RmH69Rqovg6hQTogFsc7snrHj6Rb5B8+czFc6FPlD
         ++yQ==
X-Gm-Message-State: AOAM532BajLuSTere/kMN4G4xR2rJo99DsOMFGyoIEj33T1mUjwyEPbp
        hZ9k7qV5jkVTZX7wrUAcfOE=
X-Google-Smtp-Source: ABdhPJy7K4LCx5o2Y8bJc4yi92IeBdvZYlJ8WKbZib+ajSbh7CPKo6Z27pR6e1/1EurX/z2hhbM9tg==
X-Received: by 2002:a05:620a:4445:: with SMTP id w5mr8909634qkp.617.1640000213234;
        Mon, 20 Dec 2021 03:36:53 -0800 (PST)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id s6sm11553827qko.43.2021.12.20.03.36.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Dec 2021 03:36:52 -0800 (PST)
From:   cgel.zte@gmail.com
X-Google-Original-From: deng.changcheng@zte.com.cn
To:     thomas.petazzoni@bootlin.com
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Changcheng Deng <deng.changcheng@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH] net: mvneta: use min() to make code cleaner
Date:   Mon, 20 Dec 2021 11:36:48 +0000
Message-Id: <20211220113648.473204-1-deng.changcheng@zte.com.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Changcheng Deng <deng.changcheng@zte.com.cn>

Use min() in order to make code cleaner.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Changcheng Deng <deng.changcheng@zte.com.cn>
---
 drivers/net/ethernet/marvell/mvneta.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index 83c8908f0cc7..cf1319fe7b0f 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -4634,8 +4634,7 @@ mvneta_ethtool_set_ringparam(struct net_device *dev,
 
 	if ((ring->rx_pending == 0) || (ring->tx_pending == 0))
 		return -EINVAL;
-	pp->rx_ring_size = ring->rx_pending < MVNETA_MAX_RXD ?
-		ring->rx_pending : MVNETA_MAX_RXD;
+	pp->rx_ring_size = min(ring->rx_pending, MVNETA_MAX_RXD);
 
 	pp->tx_ring_size = clamp_t(u16, ring->tx_pending,
 				   MVNETA_MAX_SKB_DESCS * 2, MVNETA_MAX_TXD);
-- 
2.25.1

