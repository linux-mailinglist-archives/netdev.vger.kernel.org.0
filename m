Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14C08318A4B
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 13:21:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231874AbhBKMUb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 07:20:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230525AbhBKMPy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 07:15:54 -0500
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89D61C061797;
        Thu, 11 Feb 2021 04:13:24 -0800 (PST)
Received: by mail-lf1-x134.google.com with SMTP id u25so7782545lfc.2;
        Thu, 11 Feb 2021 04:13:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5jBv6+wQs+1iSUDgV0nyq65E1gECWYEx7EKoseRNJ2A=;
        b=OGZ9PZmeIdhle3+Scn8/ejoghrCCylgUFhZMLAx7vpg+WuGICL44nd+DhkL0+aIKO+
         K0F4uVm1U7owS7S0qXtx7pxL/PfE67JX/59gWXJQNoSYyh9hPtMgoi/s4gt9DPXoMlO4
         gYCbY4ZIw3EGAhyyuYkeWzcf9WQPUH/JYd/sqeKGx9BoqqU9ccllRFwOkldN5gCyFMuQ
         P0Qb5R1/E+X5gOvC30hePo9xyEBAuxcjzz7/o3EwxgBkXVZMJa3Q4paUU91tXRPDDkPa
         J0DvfM/ebVwP2IXy+irR2SXwSOb070+wdxVbuMRfGozAdUdn1jDNYvN/VWauh5MDm9w9
         ck3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5jBv6+wQs+1iSUDgV0nyq65E1gECWYEx7EKoseRNJ2A=;
        b=GxiYZUsTSRxbZQcwo4vHpnn5S9YQc/p9R66XHChLBXglTgmt6OA9QxRcHjyt6Mf9+t
         7SSwBjR2BiUkFYqaGOGUvrBPWb4hThv/GwFer3o7K6uHLutsgkYaqknKT6N2l/Wez8SL
         BiLifSqGfE8lthcPEzf5TPacisSUbbppu978rfVdBhRxvPNuYs6FNp1xAN5XK4DALXdW
         wPzHwxPuXkGO3KRAhaMoXkRuID5oreC+cCrAaEC+FVxYKjezWcvMLWdRpq/PxQDZg8sg
         YSmboHazHQC7UPg6YkkZaXzLyGXS7WZOsjs9BDG9VZGD9QWCeiCn89YFruKLR9vIKOgV
         cQ3A==
X-Gm-Message-State: AOAM530GcdRRgj6Em9BrqmRmDok4LUJWw1JyP4ozuAeMvxpfZyu0NSjG
        r3uuwJUAgl/kXU4L65cpqAo=
X-Google-Smtp-Source: ABdhPJxife9Z3qnRWVO1rxqnUiFfTeksjfM3MpVJI0k0/pPPCsCB4dxO12N7CiNdPyrCwmPk66b9+g==
X-Received: by 2002:a19:4013:: with SMTP id n19mr4156077lfa.543.1613045603088;
        Thu, 11 Feb 2021 04:13:23 -0800 (PST)
Received: from localhost.lan (ip-194-187-74-233.konfederacka.maverick.com.pl. [194.187.74.233])
        by smtp.gmail.com with ESMTPSA id f23sm834783ljn.131.2021.02.11.04.13.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Feb 2021 04:13:22 -0800 (PST)
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
Subject: [PATCH net-next 5.12 7/8] net: broadcom: bcm4908_enet: fix received skb length
Date:   Thu, 11 Feb 2021 13:12:38 +0100
Message-Id: <20210211121239.728-8-zajec5@gmail.com>
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

Use ETH_FCS_LEN instead of magic value and drop incorrect + 2

Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
---
 drivers/net/ethernet/broadcom/bcm4908_enet.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bcm4908_enet.c b/drivers/net/ethernet/broadcom/bcm4908_enet.c
index 47c1b7d827c5..2e825db3b2f1 100644
--- a/drivers/net/ethernet/broadcom/bcm4908_enet.c
+++ b/drivers/net/ethernet/broadcom/bcm4908_enet.c
@@ -567,7 +567,7 @@ static int bcm4908_enet_poll(struct napi_struct *napi, int weight)
 
 		dma_unmap_single(dev, slot.dma_addr, slot.len, DMA_FROM_DEVICE);
 
-		skb_put(slot.skb, len - 4 + 2);
+		skb_put(slot.skb, len - ETH_FCS_LEN);
 		slot.skb->protocol = eth_type_trans(slot.skb, enet->netdev);
 		netif_receive_skb(slot.skb);
 
-- 
2.26.2

