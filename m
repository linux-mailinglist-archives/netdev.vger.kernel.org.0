Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05A8A318FCD
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 17:25:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230187AbhBKQWh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 11:22:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231860AbhBKQTb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 11:19:31 -0500
Received: from mail-il1-x129.google.com (mail-il1-x129.google.com [IPv6:2607:f8b0:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09E21C061797;
        Thu, 11 Feb 2021 08:18:39 -0800 (PST)
Received: by mail-il1-x129.google.com with SMTP id m20so5514358ilj.13;
        Thu, 11 Feb 2021 08:18:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=C5Y/YYGLT27TTbQWPy2GuX5CRZJc9WquBjUOYm1/AT0=;
        b=tWkwSUdxV+qF50Lxp8/LWfJ3wIhNLj8xz5PO9Ww/WuKme3jF8nb6obAf7sdaGQdmBr
         SQeKvfrELao/Fkxc7bxIxrzkWHhhoK+qf83bD5cDgUBMUzMTQ6bSxzyrQrNG/ZP1Bg+k
         SAT/YJp0Ux6n6OyuiBZbYfdiZPpu2IAA21BMaEglT/Ou9IPHyWLT4/hnl2bI4cRfSCwP
         WSOvn/WkxF+FIQ0+g2Oux2BoF5iCFDJFaXskJlPp124uNBe47dI2R87mjGU3W0rEPVtd
         aRzFzZXgcM4JdwZTfnIO9CiKf1UY2PELT5KywmoZNaKchC4+g6n7WNJOpbyy+aKkfz6/
         pE9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=C5Y/YYGLT27TTbQWPy2GuX5CRZJc9WquBjUOYm1/AT0=;
        b=HDGArOKZ6GY+Q/BRInP4yyMYxqSNEbif1tmGUGjh54FuUWz9V3qCN+YQdGd4tpAPcC
         WucNaoica3qy6NUoPoLgnPuqWTIsBn0VoXqhnOEZxfApYLWVWwhxyG7HUopOFeIGeGL6
         YMMopB6FNTLPMKV+VPIE8BGasfTX0jhIDSmCFvlfRTUSgzRIM2fIt77ogP7NpicDr1sd
         /G0hxlrR1W4DIROMF16syu96cvF9jI2KwtO2cTw1gKiCySgK0R3vnNBCW4ERuAJ3u+Vu
         HXHj6YWBVOyQ6RjOQc9GXp+GTFQiEp2fFeUqIvAJjk8H+utEc3WWns3Om8qs0lbQJuxl
         p1Pg==
X-Gm-Message-State: AOAM532eDMTo9vjOQBWEKfvptA5nr4b2DjzxrJ4y2qotyNGHop7GuHXu
        tYFsIJA+wHAbd3aSs/hh1p4=
X-Google-Smtp-Source: ABdhPJz9J4p6111K+XvJ3TS0WDuNYQjoJfMUq5OIN8RVwWi64WwGIBLWvIo51OF4Y+9XdfBlfyMWPg==
X-Received: by 2002:a92:c781:: with SMTP id c1mr6310007ilk.74.1613060318313;
        Thu, 11 Feb 2021 08:18:38 -0800 (PST)
Received: from localhost.localdomain ([198.52.185.246])
        by smtp.gmail.com with ESMTPSA id d135sm2729913iog.35.2021.02.11.08.18.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Feb 2021 08:18:37 -0800 (PST)
From:   Sven Van Asbroeck <thesven73@gmail.com>
X-Google-Original-From: Sven Van Asbroeck <TheSven73@gmail.com>
To:     Bryan Whitehead <bryan.whitehead@microchip.com>,
        UNGLinuxDriver@microchip.com, David S Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Sven Van Asbroeck <thesven73@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Alexey Denisov <rtgbnm@gmail.com>,
        Sergej Bauer <sbauer@blackbox.su>,
        Tim Harvey <tharvey@gateworks.com>,
        =?UTF-8?q?Anders=20R=C3=B8nningen?= <anders@ronningen.priv.no>,
        Hillf Danton <hdanton@sina.com>,
        Christoph Hellwig <hch@lst.de>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v2 3/5] TEST ONLY: lan743x: limit rx ring buffer size to 500 bytes
Date:   Thu, 11 Feb 2021 11:18:28 -0500
Message-Id: <20210211161830.17366-4-TheSven73@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210211161830.17366-1-TheSven73@gmail.com>
References: <20210211161830.17366-1-TheSven73@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sven Van Asbroeck <thesven73@gmail.com>

Signed-off-by: Sven Van Asbroeck <thesven73@gmail.com>
---

To: Bryan Whitehead <bryan.whitehead@microchip.com>
To: UNGLinuxDriver@microchip.com
To: "David S. Miller" <davem@davemloft.net>
To: Jakub Kicinski <kuba@kernel.org>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Alexey Denisov <rtgbnm@gmail.com>
Cc: Sergej Bauer <sbauer@blackbox.su>
Cc: Tim Harvey <tharvey@gateworks.com>
Cc: Anders Rønningen <anders@ronningen.priv.no>
Cc: Hillf Danton <hdanton@sina.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org

 drivers/net/ethernet/microchip/lan743x_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/microchip/lan743x_main.c b/drivers/net/ethernet/microchip/lan743x_main.c
index 36cc67c72851..90d49231494d 100644
--- a/drivers/net/ethernet/microchip/lan743x_main.c
+++ b/drivers/net/ethernet/microchip/lan743x_main.c
@@ -1973,7 +1973,7 @@ static int lan743x_rx_init_ring_element(struct lan743x_rx *rx, int index)
 	struct sk_buff *skb;
 	dma_addr_t dma_ptr;
 
-	buffer_length = netdev->mtu + ETH_HLEN + 4 + RX_HEAD_PADDING;
+	buffer_length = 500 + ETH_HLEN + 4 + RX_HEAD_PADDING;
 
 	descriptor = &rx->ring_cpu_ptr[index];
 	buffer_info = &rx->buffer_info[index];
-- 
2.17.1

