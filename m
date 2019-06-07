Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ADDFB389F1
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 14:14:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727866AbfFGMOX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jun 2019 08:14:23 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:42299 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727047AbfFGMOX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jun 2019 08:14:23 -0400
Received: by mail-qk1-f194.google.com with SMTP id b18so1053041qkc.9
        for <netdev@vger.kernel.org>; Fri, 07 Jun 2019 05:14:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=tTxdi5UsVspr/VkIsQ9XXiwzMsmDpxe2YtahvaqThcQ=;
        b=VK2SMw5QvOiNiWkF32TKGUTeY2rEwhB7fZvD+DmFAqIBUvg4cO4ZdkbaX+7IH7umfq
         KBRtaVu87Yxd+61n9ItpI05X0d2dURvTeAtQcs2igMRW6iPMzNsOrkrHbh6aqajZiDOr
         qUv9OfboFtEexs4de2m3lCbKuSMqh0XoK26K3EdkoJoSK2m/QhmSwOhE/IlzsQkvT6VA
         DXEMdjiBIIb+MSKqtSOndmXVkPl/UEd1L5l20YJn381lhwaRCGj1JAX0c6Lx6Szu5dGs
         Dosv9TsdZaTbHVKbj7BoT1xOjj/UF9+LOM/QJJyNIadZUOG6fdvbamOmj+vQp6NjhncT
         bVaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=tTxdi5UsVspr/VkIsQ9XXiwzMsmDpxe2YtahvaqThcQ=;
        b=GDnp4Dds2R4iB/+e7I5b2g5KSwjdzbKhbh/MPMO7JfEajubmnh3cg0b+tK+4cQ9m9g
         2EyqQu7qnpa7jgeuWjFzJEkp7vDduHuayU6c4KTh6hrsRp7evBVgR08ivF1UwUdfto+m
         hG6O0b8btNuYm8UcMw3vcxMd2CIxGheK8gPy6w23NaDJsNqZYVNHZeAS1/Xl+jIUrXjp
         Dp0ZbLPoeeVlvVa6xiRdMrW/h4R39wj2ZmZJX4AN9QpDC+9aIQJe+5n8vCQBtF9DC/G+
         ZlP6doN0MaRob4rGN97gU59rPDQq5mC31piFywn/qG9GX9GChjv7oN0eMeUn34FmbHCC
         1sqA==
X-Gm-Message-State: APjAAAUXIhKHzB22vMrzXntHyI6ohwuzHrNe8hmSb3ww1K16+GlIwP8O
        2K/WrDyfZTDLyYr5KtT38/Q=
X-Google-Smtp-Source: APXvYqx3L9nJBCaPZj66cgU+uLTkApLSjHRuphKjRjwIJqjFj1wZ5mHaf/TW/MctU7mf3m7SIPaZaw==
X-Received: by 2002:a37:6652:: with SMTP id a79mr24718359qkc.60.1559909662557;
        Fri, 07 Jun 2019 05:14:22 -0700 (PDT)
Received: from fabio-Latitude-E5450.am.freescale.net ([2804:14c:482:3c8::2])
        by smtp.gmail.com with ESMTPSA id y42sm1232903qtc.66.2019.06.07.05.14.20
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 07 Jun 2019 05:14:21 -0700 (PDT)
From:   Fabio Estevam <festevam@gmail.com>
To:     davem@davemloft.net
Cc:     fugang.duan@nxp.com, netdev@vger.kernel.org,
        Fabio Estevam <festevam@gmail.com>
Subject: [PATCH v3 net-next] net: fec_main: Use dev_err() instead of pr_err()
Date:   Fri,  7 Jun 2019 09:14:18 -0300
Message-Id: <20190607121418.16760-1-festevam@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

dev_err() is more appropriate for printing error messages inside
drivers, so switch to dev_err().

Signed-off-by: Fabio Estevam <festevam@gmail.com>
---
Changes since v2:
- Use dev_err() instead of netdev_err() - Andy

 drivers/net/ethernet/freescale/fec_main.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index 2ee72452ca76..9d459ccf251d 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -2446,30 +2446,31 @@ static int
 fec_enet_set_coalesce(struct net_device *ndev, struct ethtool_coalesce *ec)
 {
 	struct fec_enet_private *fep = netdev_priv(ndev);
+	struct device *dev = &fep->pdev->dev;
 	unsigned int cycle;
 
 	if (!(fep->quirks & FEC_QUIRK_HAS_COALESCE))
 		return -EOPNOTSUPP;
 
 	if (ec->rx_max_coalesced_frames > 255) {
-		pr_err("Rx coalesced frames exceed hardware limitation\n");
+		dev_err(dev, "Rx coalesced frames exceed hardware limitation\n");
 		return -EINVAL;
 	}
 
 	if (ec->tx_max_coalesced_frames > 255) {
-		pr_err("Tx coalesced frame exceed hardware limitation\n");
+		dev_err(dev, "Tx coalesced frame exceed hardware limitation\n");
 		return -EINVAL;
 	}
 
 	cycle = fec_enet_us_to_itr_clock(ndev, fep->rx_time_itr);
 	if (cycle > 0xFFFF) {
-		pr_err("Rx coalesced usec exceed hardware limitation\n");
+		dev_err(dev, "Rx coalesced usec exceed hardware limitation\n");
 		return -EINVAL;
 	}
 
 	cycle = fec_enet_us_to_itr_clock(ndev, fep->tx_time_itr);
 	if (cycle > 0xFFFF) {
-		pr_err("Rx coalesced usec exceed hardware limitation\n");
+		dev_err(dev, "Rx coalesced usec exceed hardware limitation\n");
 		return -EINVAL;
 	}
 
-- 
2.17.1

