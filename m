Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26233318A48
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 13:21:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230402AbhBKMTj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 07:19:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231341AbhBKMOW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 07:14:22 -0500
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25A7AC061794;
        Thu, 11 Feb 2021 04:13:21 -0800 (PST)
Received: by mail-lj1-x22d.google.com with SMTP id a17so7109164ljq.2;
        Thu, 11 Feb 2021 04:13:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0n1rj6KXJV8lItBfQGefDY+6pvSVUYY2v+L9R4Nw21U=;
        b=haJpz5MbihVmiUw234yx3dHPVu2/LgXK1XrqZIpSHMqCr9oFmWUaXz3qj5vELuu1AY
         zIhaM8wWxVdjP90jMMhUmsGSbOcLO4XvfNF/boV/rQxrTeY2f+6IaChi8wWKVSSMle/N
         9HW1QQilwu2yJCdr3qMka0Hur4cEiynnaY8wVTbV7ftO5XtmxVSHw6zjRjSGLry1ZUI9
         ZgoDdNjPmgrRghVYuU/hhsDG27jO2Hsx0VuBfGkZtp8/PbCqTIReiq6gXwwMnRau9kAS
         h4h7iu1wnh409snhrnljZz/PE620w5wSUQ0q+Ld4z7GM0zAYSOS9VIEXebvLroBDW22y
         7Ldg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0n1rj6KXJV8lItBfQGefDY+6pvSVUYY2v+L9R4Nw21U=;
        b=oD15f5AoDPb6IkhLc+cpbXoiNR/TwJQqZ/1pO0FdvawTiQiSOh1oAVQrRVrSdUoAyc
         LB8zTWGZWgsxrieZS3+ASmng/jwGCzLWAMw3vYGPTmJQS0GN64n1VE2d5n/Q9z5xSSse
         yMmX/CTuuEVkrywG6RO+idsdCYv1l7zktvjzd5j7R7keuF8A051ouU8LdlVvV8MoWbtm
         jt6607LJ30IpTwfI7CQcf/D9C9jKNDL8cPybIDp16C6gvME9MlrAoWDGDk/2W/zk1Ijt
         h5vdBaZixLMoP15khJ0csAXZeS6OYaNc91gdgmx/HVC6MiEyemSHqVw6JQw089sroicf
         mjow==
X-Gm-Message-State: AOAM531CgiiIqzWJXbbAnrLy7Am417rENhO45Lp9RTYvDB5EaOWm4s0v
        JRA6kh2eSnU5alqB6Mko1p4Dv0/xKNU=
X-Google-Smtp-Source: ABdhPJy1AqfS6XAHbyY5VYW5hW5IviqUvTWOaD67yK6QFGakSNVApDWlL7C+w3VHvb7tvTu/ins+Hw==
X-Received: by 2002:a2e:b552:: with SMTP id a18mr4819235ljn.330.1613045599693;
        Thu, 11 Feb 2021 04:13:19 -0800 (PST)
Received: from localhost.lan (ip-194-187-74-233.konfederacka.maverick.com.pl. [194.187.74.233])
        by smtp.gmail.com with ESMTPSA id f23sm834783ljn.131.2021.02.11.04.13.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Feb 2021 04:13:19 -0800 (PST)
From:   =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Masahiro Yamada <masahiroy@kernel.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, bcm-kernel-feedback-list@broadcom.com,
        Andrew Lunn <andrew@lunn.ch>,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>
Subject: [PATCH net-next 5.12 6/8] net: broadcom: bcm4908_enet: fix minor typos
Date:   Thu, 11 Feb 2021 13:12:37 +0100
Message-Id: <20210211121239.728-7-zajec5@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210211121239.728-1-zajec5@gmail.com>
References: <20210209230130.4690-2-zajec5@gmail.com>
 <20210211121239.728-1-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rafał Miłecki <rafal@milecki.pl>

1. Fix "ensable" typo noticed by Andrew
2. Fix chipset name in the struct net_device_ops variable

Suggested-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/ethernet/broadcom/bcm4908_enet.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bcm4908_enet.c b/drivers/net/ethernet/broadcom/bcm4908_enet.c
index 7d619aa9410a..47c1b7d827c5 100644
--- a/drivers/net/ethernet/broadcom/bcm4908_enet.c
+++ b/drivers/net/ethernet/broadcom/bcm4908_enet.c
@@ -328,8 +328,8 @@ static int bcm4908_enet_dma_init(struct bcm4908_enet *enet)
 	return 0;
 }
 
-static void bcm4908_enet_dma_tx_ring_ensable(struct bcm4908_enet *enet,
-					     struct bcm4908_enet_dma_ring *ring)
+static void bcm4908_enet_dma_tx_ring_enable(struct bcm4908_enet *enet,
+					    struct bcm4908_enet_dma_ring *ring)
 {
 	enet_write(enet, ring->cfg_block + ENET_DMA_CH_CFG, ENET_DMA_CH_CFG_ENABLE);
 }
@@ -519,7 +519,7 @@ static int bcm4908_enet_start_xmit(struct sk_buff *skb, struct net_device *netde
 	buf_desc->addr = cpu_to_le32((uint32_t)slot->dma_addr);
 	buf_desc->ctl = cpu_to_le32(tmp);
 
-	bcm4908_enet_dma_tx_ring_ensable(enet, &enet->tx_ring);
+	bcm4908_enet_dma_tx_ring_enable(enet, &enet->tx_ring);
 
 	if (++ring->write_idx == ring->length - 1)
 		ring->write_idx = 0;
@@ -583,7 +583,7 @@ static int bcm4908_enet_poll(struct napi_struct *napi, int weight)
 	return handled;
 }
 
-static const struct net_device_ops bcm96xx_netdev_ops = {
+static const struct net_device_ops bcm4908_enet_netdev_ops = {
 	.ndo_open = bcm4908_enet_open,
 	.ndo_stop = bcm4908_enet_stop,
 	.ndo_start_xmit = bcm4908_enet_start_xmit,
@@ -623,7 +623,7 @@ static int bcm4908_enet_probe(struct platform_device *pdev)
 
 	SET_NETDEV_DEV(netdev, &pdev->dev);
 	eth_hw_addr_random(netdev);
-	netdev->netdev_ops = &bcm96xx_netdev_ops;
+	netdev->netdev_ops = &bcm4908_enet_netdev_ops;
 	netdev->min_mtu = ETH_ZLEN;
 	netdev->mtu = ENET_MTU_MAX;
 	netdev->max_mtu = ENET_MTU_MAX;
-- 
2.26.2

