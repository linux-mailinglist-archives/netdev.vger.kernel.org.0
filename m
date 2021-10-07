Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A41124260AD
	for <lists+netdev@lfdr.de>; Fri,  8 Oct 2021 01:43:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237982AbhJGXnw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 19:43:52 -0400
Received: from smtp-relay-canonical-0.canonical.com ([185.125.188.120]:36202
        "EHLO smtp-relay-canonical-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229778AbhJGXnt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Oct 2021 19:43:49 -0400
Received: from localhost (1.general.cking.uk.vpn [10.172.193.212])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-0.canonical.com (Postfix) with ESMTPSA id BEA443F226;
        Thu,  7 Oct 2021 23:41:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1633650113;
        bh=xcI8ZGeSFCk6ZEUuzxl7/qYwHZsqf/PSG6Ov6OHHj+c=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type;
        b=BQiKBs9mshkGku5TLdxn8jGHo9Yi/4GPqHXGx1oRJUNuRW8z1ZcHZyP5tQZ86tRi6
         TlQb5HDR9kPEYFEfEY6EZT7iAG1vMiZbd+1+YYwU/SWlTjkmquB9O+sjrwtfebBmJI
         Ck5rfbED65Ls+eA5fWWPc752AmcyL2HNWLUCjH26DmqHKwpJxGtN9JrI1opsQUQcAx
         W0nJ9Nn1HurvlZRVkQez9WPti919HJZQMgW5kBRDe+KwgS8znuVMjTbevPqmJAdJlA
         uoXfVOeH1j4khNn+rVZiHJB6p6F5qhUoXeCmyN1CZtHdq8x54DB1vB4QPQFejn+hA8
         9VDH23jU9oBBg==
From:   Colin King <colin.king@canonical.com>
To:     Jakub Kicinski <kubakici@wp.pl>, Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] mt7601u: Remove redundant initialization of variable ret
Date:   Fri,  8 Oct 2021 00:41:53 +0100
Message-Id: <20211007234153.31222-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The variable ret is being initialized with a value that is never read,
it is assigned later on with a different value. The initialization is
redundant and can be removed.

Addresses-Coverity: ("Unused value")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/wireless/mediatek/mt7601u/dma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt7601u/dma.c b/drivers/net/wireless/mediatek/mt7601u/dma.c
index ed78d2cb35e3..457147394edc 100644
--- a/drivers/net/wireless/mediatek/mt7601u/dma.c
+++ b/drivers/net/wireless/mediatek/mt7601u/dma.c
@@ -515,7 +515,7 @@ static int mt7601u_alloc_tx(struct mt7601u_dev *dev)
 
 int mt7601u_dma_init(struct mt7601u_dev *dev)
 {
-	int ret = -ENOMEM;
+	int ret;
 
 	tasklet_setup(&dev->tx_tasklet, mt7601u_tx_tasklet);
 	tasklet_setup(&dev->rx_tasklet, mt7601u_rx_tasklet);
-- 
2.32.0

