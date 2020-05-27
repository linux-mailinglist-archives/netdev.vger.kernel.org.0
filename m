Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C95141E3D7C
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 11:24:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728599AbgE0JYU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 05:24:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728585AbgE0JYU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 05:24:20 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4411C061A0F
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 02:24:19 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id r15so2305715wmh.5
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 02:24:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=iK/p1RCXvKF/OvIr3JooWyPvnEDB/sbZcEn98mkIDwE=;
        b=K9sfDNJcKCyRlgVNfYviMiUKOkM1L1ErbyvdGqC349mim10kIuJ7iesKN3kHKaByg/
         9aMV+55ANv6LyrS67uYorbrZ7jMaXwcPPtbOq66POFClQLvDUGeA3ckVrMl1X8Obagqx
         E2oZe/pmR+eoF1mVMwgvRp3DI33gG466+YY4+Qd3Fl5YXJ9zW433Xk0/0UNwi3JxbOpI
         SwVI4dnmpxTuQqJF12eLnupZw2ZTGgpRF6DHpEppgi+dgLsu7l6Nm5Bm+8r0y5glNSl8
         z3cCOiDxTJ+vg4IFq8+dNTQ4VLZSIOW4fExS/0qo3rcOcCpBlh6FS1kkDKAKDbrqPfzb
         xFcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=iK/p1RCXvKF/OvIr3JooWyPvnEDB/sbZcEn98mkIDwE=;
        b=HDBm//I1+0YysKnbM4CrvYkEooqwhffRwb5QBhwKQs5PZ2eVQhPLRyoeVpeGXwRLnx
         ihWlxzeeGQTz1K6RUwpa0Rnwod8TAZXNxaGj2UQ51IBSj4k+0PZuTzFdUw09xJ2eWDpl
         l0fTqPOTRVdazPiO8IkJsmv5P3TaG7eLUqrLCstzhdQollDSJ2GlzKrTh7VnUy8efYSz
         +lGUmX/A3mX81OXctb/nvENuDl3tftFf+GQ8J2e6Xauxs6iaCvKdITF8JnniPD6oWLql
         L4e0uwQ+eOZZ5N4MxJ0wkNOBMLWCf2Oju+OehnzSrldMZDeBAf5bh/EZLU5Z3RyP3oUp
         M2Yg==
X-Gm-Message-State: AOAM532fancqokwx5TNMZUPdfWLQCQy67EBcaqk2KYjUtRI8cJmBQfWx
        DZaG6VHj0RqNPFRsXbntJipVdQ==
X-Google-Smtp-Source: ABdhPJyCox//hlsTwOFPPKuQKWeWBXVZn0uc8sk6yk61mpiZuZ7Lb2amN/+W7d8zFEtcVbRbgYS+mw==
X-Received: by 2002:a05:600c:2614:: with SMTP id h20mr3540149wma.155.1590571458351;
        Wed, 27 May 2020 02:24:18 -0700 (PDT)
Received: from localhost.localdomain (lfbn-nic-1-65-232.w2-15.abo.wanadoo.fr. [2.15.156.232])
        by smtp.gmail.com with ESMTPSA id o6sm2278500wrp.3.2020.05.27.02.24.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 May 2020 02:24:17 -0700 (PDT)
From:   Bartosz Golaszewski <brgl@bgdev.pl>
To:     John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>
Cc:     netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        Fabien Parent <fparent@baylibre.com>,
        Stephane Le Provost <stephane.leprovost@mediatek.com>,
        Pedro Tsai <pedro.tsai@mediatek.com>,
        Andrew Perepech <andrew.perepech@mediatek.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Nathan Chancellor <natechancellor@gmail.com>
Subject: [PATCH] net: ethernet: mtk-star-emac: fix error path in RX handling
Date:   Wed, 27 May 2020 11:24:04 +0200
Message-Id: <20200527092404.3567-1-brgl@bgdev.pl>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bartosz Golaszewski <bgolaszewski@baylibre.com>

The dma_addr field in desc_data must not be overwritten until after the
new skb is mapped. Currently we do replace it with uninitialized value
in error path. This change fixes it by moving the assignment before the
label to which we jump after mapping or allocation errors.

Fixes: 8c7bd5a454ff ("net: ethernet: mtk-star-emac: new driver")
Reported-by: Nathan Chancellor <natechancellor@gmail.com>
Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
---
 drivers/net/ethernet/mediatek/mtk_star_emac.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_star_emac.c b/drivers/net/ethernet/mediatek/mtk_star_emac.c
index b74349cede28..72bb624a6a68 100644
--- a/drivers/net/ethernet/mediatek/mtk_star_emac.c
+++ b/drivers/net/ethernet/mediatek/mtk_star_emac.c
@@ -1308,6 +1308,8 @@ static int mtk_star_receive_packet(struct mtk_star_priv *priv)
 		goto push_new_skb;
 	}
 
+	desc_data.dma_addr = new_dma_addr;
+
 	/* We can't fail anymore at this point: it's safe to unmap the skb. */
 	mtk_star_dma_unmap_rx(priv, &desc_data);
 
@@ -1318,7 +1320,6 @@ static int mtk_star_receive_packet(struct mtk_star_priv *priv)
 	netif_receive_skb(desc_data.skb);
 
 push_new_skb:
-	desc_data.dma_addr = new_dma_addr;
 	desc_data.len = skb_tailroom(new_skb);
 	desc_data.skb = new_skb;
 
-- 
2.25.0

