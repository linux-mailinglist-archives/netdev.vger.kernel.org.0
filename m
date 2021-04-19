Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D009364760
	for <lists+netdev@lfdr.de>; Mon, 19 Apr 2021 17:47:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240008AbhDSPrj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 11:47:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241330AbhDSPrh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Apr 2021 11:47:37 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5A6EC061761;
        Mon, 19 Apr 2021 08:47:07 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id p12so24533480pgj.10;
        Mon, 19 Apr 2021 08:47:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5bzjff+su6HXIaTpyjBroSwlupbpwpZmI0kJmdwR1sA=;
        b=B9MXwRU5X1n4ceTorijsBBZblGJ8kcjMP43LSuW2efFbARNz7+Zvc5/SDoJ5hYkUKk
         aruI5gIM/i/+tKcnmSNUbHsG2g78SBSuBs6lKM21q/r0eHxTL9ZjaGzWVDfiT5h+ipAF
         QJnDmdyQ6htpSA3O8f0eSD7iYufopn+KFNDIg2gvLQPDh4TMQP7rJUSaLJO5JoQFloEm
         Q0fh76kPDqV6Ad31pVKMMI5PpqI8e4JnyjcWPS7dBdJJD+b2GaohejF+/HJqlPS+M2wA
         7aozd+lOFtMVviIWSSiPGlxXG/qsD6rKkGyz77O5HOk03CFUhcxKjmspZZpfa0B3VcbX
         8Wbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5bzjff+su6HXIaTpyjBroSwlupbpwpZmI0kJmdwR1sA=;
        b=CDRUpn0+im4a/QWb7T4A3FMAtn/R8dRLz6iOWN2Amf9X2S6y0z/fdPaii1fMJIj8Jb
         YEMaDDM/GwRiy2XjUpQePfjDDfhRbJZbF6E14nLEQj3wO+pULXSWs43HZkI94zHpqGwS
         OTaFTlVejN1sU4EkS/IfxU4ctzeBZOIgVGZKy26WL2n6suVkxRJzWIScQ1PlH71v3Irb
         MSHN4ck++no2/rSwHd2JDfbuop9lAiewn1HL9WKRR9ErGvaX6J/XACS2ZbPG4rw6Sb6b
         t6bFthLLtcT5cyOQO3x4/k0vrHgQIlJrOj8QTNLlmde0Bjh+34j+GtMPiOs7kgBAEpbd
         0riw==
X-Gm-Message-State: AOAM5306M92DghUpN0uSL1NgO2Mgzb8mJRsIJ7eWWRpCAB1ckZA5JZ6V
        xMq8q/nFbcnYdZHpLm3b2mI=
X-Google-Smtp-Source: ABdhPJy9R/pUClK4i2RW8B6XQkBUuBDnjzRtHvwyP++1eSHFoDzj6/4ku6ALOfkrnznbdlMghY4OKQ==
X-Received: by 2002:a63:e405:: with SMTP id a5mr8785503pgi.89.1618847227364;
        Mon, 19 Apr 2021 08:47:07 -0700 (PDT)
Received: from z640-arch.lan ([2602:61:7344:f100::678])
        by smtp.gmail.com with ESMTPSA id u1sm15314139pjj.19.2021.04.19.08.47.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Apr 2021 08:47:07 -0700 (PDT)
From:   Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Felix Fietkau <nbd@nbd.name>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Cc:     Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>,
        =?UTF-8?q?Ren=C3=A9=20van=20Dorst?= <opensource@vdorst.com>
Subject: [PATCH net-next v2 2/2] net: ethernet: mediatek: support custom GMAC label
Date:   Mon, 19 Apr 2021 08:46:59 -0700
Message-Id: <20210419154659.44096-3-ilya.lipnitskiy@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210419154659.44096-1-ilya.lipnitskiy@gmail.com>
References: <20210419154659.44096-1-ilya.lipnitskiy@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The MAC device name can now be set within DTS file instead of always
being "ethX". This is helpful for DSA to clearly label the DSA master
device and distinguish it from DSA slave ports.

For example, some devices, such as the Ubiquiti EdgeRouter X, may have
ports labeled ethX. Labeling the master GMAC with a different prefix
than DSA ports helps with clarity.

Suggested-by: René van Dorst <opensource@vdorst.com>
Signed-off-by: Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index 6b00c12c6c43..df3cda63a8c5 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -2845,6 +2845,7 @@ static const struct net_device_ops mtk_netdev_ops = {
 
 static int mtk_add_mac(struct mtk_eth *eth, struct device_node *np)
 {
+	const char *label = of_get_property(np, "label", NULL);
 	const __be32 *_id = of_get_property(np, "reg", NULL);
 	phy_interface_t phy_mode;
 	struct phylink *phylink;
@@ -2867,9 +2868,10 @@ static int mtk_add_mac(struct mtk_eth *eth, struct device_node *np)
 		return -EINVAL;
 	}
 
-	eth->netdev[id] = alloc_etherdev(sizeof(*mac));
+	eth->netdev[id] = alloc_netdev(sizeof(*mac), label ? label : "eth%d",
+				       NET_NAME_UNKNOWN, ether_setup);
 	if (!eth->netdev[id]) {
-		dev_err(eth->dev, "alloc_etherdev failed\n");
+		dev_err(eth->dev, "alloc_netdev failed\n");
 		return -ENOMEM;
 	}
 	mac = netdev_priv(eth->netdev[id]);
-- 
2.31.1

