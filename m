Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52E6247CA77
	for <lists+netdev@lfdr.de>; Wed, 22 Dec 2021 01:39:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238340AbhLVAjk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 19:39:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231169AbhLVAjk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Dec 2021 19:39:40 -0500
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 934D7C061574;
        Tue, 21 Dec 2021 16:39:39 -0800 (PST)
Received: by mail-wr1-x432.google.com with SMTP id i22so1273710wrb.13;
        Tue, 21 Dec 2021 16:39:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xVXHL7FyFxnwIsqjzuFgRIVfeBo1Zhxkx+qtv0+xi04=;
        b=pFdy/hdzx33MmHp/o4hC90x9UO/y/ld6yECrNWmF7DW7V7UUw6x6+cWoXxctyLxmrW
         u2pRZoA+96YeEqOGT3ysANZ9B//0Grn8oUseK7jeZnGLC0xor3VUUZrwFe44RXiaGKpg
         AlG5PR4oQqa7zVVUoQNNt5SyBDIKs/jZwl83/6Nl0BCMKhkWJ3706TtX6nlk7pD5YOKc
         csBUUoet3ZAdtzpIAdcRO4XotAVB5eyp7d+bLh+Ty03ppGGh5VWq/5Sg5wV+6xYVXUsR
         aDyjQk3g58/JSl+XUyyvBPWgUMoybT9FBWb5OzODmyoJP8qrS9S/mtNCXPML23FVnup0
         7J7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xVXHL7FyFxnwIsqjzuFgRIVfeBo1Zhxkx+qtv0+xi04=;
        b=ZKJUpU6jksZUacdIsGbsjvMEEa00qVNjJs4Wj2MmhT73AVVMUj9Pvv5L+/UUX2xegO
         fwAnDYcX/SEklwqHIKmBQ+rWRlH07hmUli0/4twN7h5D0QbEYdzaW/pfn5X8G7NM5JY+
         2TRVPD++boY/LdR8yqnPCDAw4lMFdm3YQZtcdIv32J33I2jJmJIJmZM8fNi16sMpZqul
         e+Ek/XxoEKOr8b6E880WW1X3vDK0N1Hx6btr+1ufMJK2RD3PUoNWQ4LVHbuzWvjZCFoX
         JI/AENJB6OLnS2HhzZ3ir4DHoCw032/tY81njykBT2gB5r21icRfZyibNfJRHAA0/zQD
         FKpQ==
X-Gm-Message-State: AOAM531FLGhbR+E8iVwDBgSf1AKmJud2hq3ytxJPBj5K4xsmAQbrQafW
        KE6ZVWla27EPQzt9q1WkCqqZJn7njzUsmmUhUXujTQ==
X-Google-Smtp-Source: ABdhPJyQkmqMUWb4XESZ7RcmFhsZh8H5eyWabK6v0OfoUKK5st4FaQFR55DDnykKiqjhNfHmP6k0RA==
X-Received: by 2002:a05:6000:1acd:: with SMTP id i13mr403677wry.406.1640133578286;
        Tue, 21 Dec 2021 16:39:38 -0800 (PST)
Received: from localhost (cpc154979-craw9-2-0-cust193.16-3.cable.virginm.net. [80.193.200.194])
        by smtp.gmail.com with ESMTPSA id i9sm438746wrb.84.2021.12.21.16.39.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Dec 2021 16:39:37 -0800 (PST)
From:   Colin Ian King <colin.i.king@gmail.com>
To:     =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
        bcm-kernel-feedback-list@broadcom.com,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net: broadcom: bcm4908enet: remove redundant variable bytes
Date:   Wed, 22 Dec 2021 00:39:37 +0000
Message-Id: <20211222003937.727325-1-colin.i.king@gmail.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The variable bytes is being used to summate slot lengths,
however the value is never used afterwards. The summation
is redundant so remove variable bytes.

Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
---
 drivers/net/ethernet/broadcom/bcm4908_enet.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bcm4908_enet.c b/drivers/net/ethernet/broadcom/bcm4908_enet.c
index b07cb9bc5f2d..4a2622b05ee1 100644
--- a/drivers/net/ethernet/broadcom/bcm4908_enet.c
+++ b/drivers/net/ethernet/broadcom/bcm4908_enet.c
@@ -635,7 +635,6 @@ static int bcm4908_enet_poll_tx(struct napi_struct *napi, int weight)
 	struct bcm4908_enet_dma_ring_bd *buf_desc;
 	struct bcm4908_enet_dma_ring_slot *slot;
 	struct device *dev = enet->dev;
-	unsigned int bytes = 0;
 	int handled = 0;
 
 	while (handled < weight && tx_ring->read_idx != tx_ring->write_idx) {
@@ -646,7 +645,6 @@ static int bcm4908_enet_poll_tx(struct napi_struct *napi, int weight)
 
 		dma_unmap_single(dev, slot->dma_addr, slot->len, DMA_TO_DEVICE);
 		dev_kfree_skb(slot->skb);
-		bytes += slot->len;
 		if (++tx_ring->read_idx == tx_ring->length)
 			tx_ring->read_idx = 0;
 
-- 
2.33.1

