Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A69C26CCC8
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 22:49:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728317AbgIPUs5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Sep 2020 16:48:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726379AbgIPRAw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Sep 2020 13:00:52 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80DDCC0D941A;
        Wed, 16 Sep 2020 09:49:22 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id l191so4239605pgd.5;
        Wed, 16 Sep 2020 09:49:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=E24YwumgMfA6aEIrvJQfADpO1/yrnjk3KqOQV8pyq0Q=;
        b=EQzwIEAJ+8hZF+WaJzjUgSO3hpHvsTXojm00pKZ+pv/Kx9i59Xx+4QdEcLm5EKDWh+
         bxYHuGwi+fUEsRbZZAS30kfzWk0HwYp9MhUBlksfgfxQNpviPGRv9yBFXASftTcS8MFw
         hFtikLwGV9DhOOjzI4na4zl0fm0gERmLPkOKTypfejdxch1J3tOB0zFRk3jW0sX2QqSf
         Ruyv3kMO7Ak8cr9ebuodeB6dyFcIXqf8umuAz1tHD8NP2c5gXWO9Yxf/punazKcRbU1g
         eBIM06azndQleSrfQcIFsUf87ykbo3iH/4roRft3gZC/hPPrlCbhcTRnufgVHHCnKZsH
         U2Hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=E24YwumgMfA6aEIrvJQfADpO1/yrnjk3KqOQV8pyq0Q=;
        b=jlMWyr/eAUUjLntsAWgGKv5T3eX8NllfAi/2GAClunY7wXWfWTl27kBoG02CDntvcZ
         Eo/Nb3s4tfsq4LlFRnvQdOWIQh+LrVBoQCNHczzfnRjEQ4trS8u9cTtfcnGWIdRvfWgQ
         LytgsEdpvIBSRq5u5LyflsxCuQzH5JWKcz+E4QnaEzmT9spdccKKUD4r7K51U2DWAnur
         PuC+kLJms9yTM8h2b6aHEvpA0KJkQl98f1HhDWjKH0XwH6O6ihLtu007K9WhcwCiHFJS
         sg2/g7oF30YtpaAh3U1mF8kSxuyd1UtVsDXtuBLFZsGhX+cWQh5rUtRUcso00Ksk9rLK
         wgPA==
X-Gm-Message-State: AOAM530pERGJnv0izzFKZj3fbLc234FROynZiZIPYkZa4lBiwLCDpH01
        qHLx5sGAXnWOaPaEmBNPSRM=
X-Google-Smtp-Source: ABdhPJw+eKytvMFnT3cEur1zIgvXJyxzQn4xPHL5/BlOqiSf0xX7WO5dxj6nSo7l+bOLb9Mj0u9w1A==
X-Received: by 2002:aa7:8397:0:b029:13e:d13d:a07c with SMTP id u23-20020aa783970000b029013ed13da07cmr23289758pfm.19.1600274962073;
        Wed, 16 Sep 2020 09:49:22 -0700 (PDT)
Received: from shane-XPS-13-9380.hsd1.ca.comcast.net ([2601:646:8800:1c00:29a5:9632:a091:4adb])
        by smtp.gmail.com with ESMTPSA id e1sm18799080pfl.162.2020.09.16.09.49.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2020 09:49:21 -0700 (PDT)
From:   Xie He <xie.he.0141@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Xie He <xie.he.0141@gmail.com>, Martin Schiller <ms@dev.tdt.de>
Subject: [PATCH net] drivers/net/wan/lapbether: Make skb->protocol consistent with the header
Date:   Wed, 16 Sep 2020 09:49:18 -0700
Message-Id: <20200916164918.450933-1-xie.he.0141@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This driver is a virtual driver stacked on top of Ethernet interfaces.

When this driver transmits data on the Ethernet device, the skb->protocol
setting is inconsistent with the Ethernet header prepended to the skb.

This causes a user listening on the Ethernet interface with an AF_PACKET
socket, to see different sll_protocol values for incoming and outgoing
frames, because incoming frames would have this value set by parsing the
Ethernet header.

This patch changes the skb->protocol value for outgoing Ethernet frames,
making it consistent with the Ethernet header prepended. This makes a
user listening on the Ethernet device with an AF_PACKET socket, to see
the same sll_protocol value for incoming and outgoing frames.

Cc: Martin Schiller <ms@dev.tdt.de>
Signed-off-by: Xie He <xie.he.0141@gmail.com>
---
 drivers/net/wan/lapbether.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wan/lapbether.c b/drivers/net/wan/lapbether.c
index 732a6c1851f5..b6be2454b8bd 100644
--- a/drivers/net/wan/lapbether.c
+++ b/drivers/net/wan/lapbether.c
@@ -198,8 +198,6 @@ static void lapbeth_data_transmit(struct net_device *ndev, struct sk_buff *skb)
 	struct net_device *dev;
 	int size = skb->len;
 
-	skb->protocol = htons(ETH_P_X25);
-
 	ptr = skb_push(skb, 2);
 
 	*ptr++ = size % 256;
@@ -210,6 +208,8 @@ static void lapbeth_data_transmit(struct net_device *ndev, struct sk_buff *skb)
 
 	skb->dev = dev = lapbeth->ethdev;
 
+	skb->protocol = htons(ETH_P_DEC);
+
 	skb_reset_network_header(skb);
 
 	dev_hard_header(skb, dev, ETH_P_DEC, bcast_addr, NULL, 0);
-- 
2.25.1

