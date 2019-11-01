Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DFAD6EC374
	for <lists+netdev@lfdr.de>; Fri,  1 Nov 2019 14:02:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727213AbfKANCy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Nov 2019 09:02:54 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:41559 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727200AbfKANCx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Nov 2019 09:02:53 -0400
Received: by mail-lj1-f195.google.com with SMTP id m9so10151626ljh.8
        for <netdev@vger.kernel.org>; Fri, 01 Nov 2019 06:02:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=c9W010bePpb3OOGnKRElBxkQbvyqmresES6SORuIRPg=;
        b=lqtN08HqXra8vS2ZQwN34VQ3mbUzilaONUN/1vaug++BgQlN2uzi4XefvguK4Beb4a
         DqnNyDqSXJg/8DaX6dZZhF9GhnUB4JIuoYMtWXYg5VGGW3UQPm0EAflzrFazZwtdhHzZ
         Q77h/ppit2TQRHzVO3MnEPk9kwjb+Ox65brMWJ4tmm0mLryD/9d3kiEHj+3LU7CjYP/l
         A53j+5UUf9aUp20CPR7935ZJGeKJZPV52HHN4bafhlmJpYLmehtdsIkU3eQgRz6wOUip
         l5QOhCa/YGtzs1J+i8RqerTfEiZODoR44olNVbovOAcQLHOrI2WC0M92IysVQIBX/2jB
         Lgpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=c9W010bePpb3OOGnKRElBxkQbvyqmresES6SORuIRPg=;
        b=qIKNWygL252lgi/NmsiDi3nutqS4KgDmSgxqM9kyjBKl7m4m9hojxszW2sh/F8I5l4
         goytNwVw79gdsSrpMPOX1MoHTs1KQMXlOZ5dux2tXlY+MDMHR4E3JN5Dl/6BlIH+8JBi
         W669/jFBe6BXBNAEwWiMC6/5iO8wN+V5t9Vhqvd7gXqjYRMf9N59AsTXjfQVtXsiZYeN
         8poyHvwLU+/H1rR1jwOQZG7Fv4xAJuZsSeiV51o7rN6A/i1YKVeyZq1DtDo+V/JCBrun
         cgZnKZ4O8Qk3LE6H3vavFTpGBvT3/GT73MGrRChQvKFY3DfjAR/VWiTB5nzExsuC6Xpy
         TuXA==
X-Gm-Message-State: APjAAAVeVK8yJQ7/6oCWMq/pJfeiS2V7hirdZDGlmBwPFn4U8Uvf09cI
        xzQPvUzK1foPdOrrzQ/ZUlmUmbgr/lC1zA==
X-Google-Smtp-Source: APXvYqym6LEoQ+L0bWEEkIZdGK/5n+fclcT4T6pMm7IxZq0DR1lLBzU3h1EiEJgYSghkF8lAhNGjJg==
X-Received: by 2002:a2e:85ce:: with SMTP id h14mr4861703ljj.92.1572613370415;
        Fri, 01 Nov 2019 06:02:50 -0700 (PDT)
Received: from localhost.bredbandsbolaget (c-79c8225c.014-348-6c756e10.bbcust.telenor.se. [92.34.200.121])
        by smtp.gmail.com with ESMTPSA id c3sm2516749lfi.32.2019.11.01.06.02.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Nov 2019 06:02:49 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        stable@vger.kernel.org
Subject: [PATCH net-next 10/10 v2] net: ethernet: ixp4xx: Use parent dev for DMA pool
Date:   Fri,  1 Nov 2019 14:02:24 +0100
Message-Id: <20191101130224.7964-11-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191101130224.7964-1-linus.walleij@linaro.org>
References: <20191101130224.7964-1-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use the netdevice struct device .parent field when calling
dma_pool_create(): the .dma_coherent_mask and .dma_mask
pertains to the bus device on the hardware (platform)
bus in this case, not the struct device inside the network
device. This makes the pool allocation work.

Cc: stable@vger.kernel.org
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
ChangeLog v1->v2:
- Rebase with the rest of the series.
- Tag for stable, this is pretty serious.
- I have no real idea when this stopped working.
---
 drivers/net/ethernet/xscale/ixp4xx_eth.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/xscale/ixp4xx_eth.c b/drivers/net/ethernet/xscale/ixp4xx_eth.c
index c5835a2fb965..4baceae50490 100644
--- a/drivers/net/ethernet/xscale/ixp4xx_eth.c
+++ b/drivers/net/ethernet/xscale/ixp4xx_eth.c
@@ -1086,7 +1086,7 @@ static int init_queues(struct port *port)
 	int i;
 
 	if (!ports_open) {
-		dma_pool = dma_pool_create(DRV_NAME, &port->netdev->dev,
+		dma_pool = dma_pool_create(DRV_NAME, port->netdev->dev.parent,
 					   POOL_ALLOC_SIZE, 32, 0);
 		if (!dma_pool)
 			return -ENOMEM;
-- 
2.21.0

