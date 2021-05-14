Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D92F381248
	for <lists+netdev@lfdr.de>; Fri, 14 May 2021 23:01:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229610AbhENVCG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 May 2021 17:02:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231860AbhENVBq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 May 2021 17:01:46 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AF9AC061761;
        Fri, 14 May 2021 14:00:32 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id m12so596066eja.2;
        Fri, 14 May 2021 14:00:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=q2k47yfXQ6N5mq8ul+N9N9tXITaHlPGjSLKh+GAf2aw=;
        b=eBaUfwPNy1gNwiS+xgfibdT1qO6c3zGM5kgT4aIj0fZeHqzQmdqzDhPsJ6BkL1yU8K
         NdwpRiIlYFkssILbut5cX7QDB9uhH6x7RdljzqIncCxZBtV6xKiXWNwi76C44qo6ENw0
         ijv6o6L1oHwXtoWPn7bixnKAIYWtTQZ2BsKoFz7Z7Pw/O2D3X6mZb04kVWW7+QUB7OPc
         pYi3PHBAm3CCMAmplQ5gHZlVOqy+gNUrFYIt6sypwHbiXdv0HTN+w4KzgeiIZ3OHbfjN
         gOxNwJC+I4AWLskzd6nmM9ScbfZYczFzLcXESGPl60uH2PUOWA4TWDfcdB5AAF3drpji
         vG3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=q2k47yfXQ6N5mq8ul+N9N9tXITaHlPGjSLKh+GAf2aw=;
        b=HvfrN8UX4jXBXcSz3WgbRNBICHkiNdyuj/5cBxT99di/bGA8xof+4BnVwWjIWb+67p
         Aiu6Fn7IS6cHzuey1vKNYXkAyQLenaYBOlgFgt8lIRa2UumXgyM+3xzfFU+bmMRe4cyn
         hHdrVT44v7XeY/KHrhB2/WkZhmB9SWLg2FSRKHOIFkKtj6+ldHnhu5NEWYD1L6A4EJTc
         QXhMftaSbaiskr6Svw//tzYbgbf/rMX0Rc78G6zDNZHwEVCQ2bbZqJoYDIdu87BKmiNz
         UtarV0Ein4+nJ5v/rTu8v7y/dEgJTCCvIk20C0m03EiGYFxwtyMM+jZ/vVHsvc+j64TR
         U85w==
X-Gm-Message-State: AOAM533EaQvqqc2fD+0+VnDCL7kY0zC6Uomlk/wk1AzYBJvmWHYPKyFT
        1Lsj1nGTIU5b5fW3jcbf3uZWOueLy4MNTw==
X-Google-Smtp-Source: ABdhPJw8aYVgGD6OLGKBIOwSvigVWroTGsdpGoYRCyVEsbTjD2hm/IMOQNcS0EdKi1gsqKco+h2IoA==
X-Received: by 2002:a17:907:9691:: with SMTP id hd17mr50623537ejc.67.1621026031198;
        Fri, 14 May 2021 14:00:31 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-35-189-2.ip56.fastwebnet.it. [93.35.189.2])
        by smtp.googlemail.com with ESMTPSA id c3sm5455237edn.16.2021.05.14.14.00.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 May 2021 14:00:30 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Ansuel Smith <ansuelsmth@gmail.com>
Subject: [PATCH net-next v6 15/25] net: dsa: qca8k: add ethernet-ports fallback to setup_mdio_bus
Date:   Fri, 14 May 2021 23:00:05 +0200
Message-Id: <20210514210015.18142-16-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210514210015.18142-1-ansuelsmth@gmail.com>
References: <20210514210015.18142-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dsa now also supports ethernet-ports. Add this new binding as a fallback
if the ports node can't be found.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/dsa/qca8k.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index 35ff4cf08786..cc9ab35f8b17 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -718,6 +718,9 @@ qca8k_setup_mdio_bus(struct qca8k_priv *priv)
 	int err;
 
 	ports = of_get_child_by_name(priv->dev->of_node, "ports");
+	if (!ports)
+		ports = of_get_child_by_name(priv->dev->of_node, "ethernet-ports");
+
 	if (!ports)
 		return -EINVAL;
 
-- 
2.30.2

