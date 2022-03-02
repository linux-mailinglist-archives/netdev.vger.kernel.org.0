Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32C974C9DF3
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 07:48:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236719AbiCBGtD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 01:49:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232083AbiCBGtC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 01:49:02 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EA73B1533;
        Tue,  1 Mar 2022 22:48:17 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id ev16-20020a17090aead000b001bc3835fea8so996360pjb.0;
        Tue, 01 Mar 2022 22:48:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=jtz+6fV1bDp1SQ+YOKwQMc0tM8/hXnczU8fsqnQBpk8=;
        b=YI5Hpjaxj+sqQn1WvB8/KtXhynPberuV3zMbWhFSa1wels48T/oO+gQt93komUs/aL
         DWDN7cBF2Ho1Zca4mUzvZbLb6WMUlVQ/AHqpbgnkxSmJtS7wQm1liGiLnoRKF8KjEIUE
         DQpl3glslxDjzaDDFSkrWWxGqkMCpY5AwShPSHRg8t2rR4yhSHvr9/qfY+OjhVWHwzMY
         Us3USBQPef2WAagQYTo5NEdKBeWE8r2lWqjdQzDH5b3K02LZ3r66InFLWdO0W2m6aE8A
         E70IbZY6GRS4EtfHbg0VsqBhUy5RkLgiliIEOO/iIt3EbHoUifJlcxIxNwvTIoATNvNK
         2Ksg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=jtz+6fV1bDp1SQ+YOKwQMc0tM8/hXnczU8fsqnQBpk8=;
        b=5lLTS0drgDe+jO3TaNyph56yXXdsFZaXRh7V5RgrbCURH8JcdNXJ89hNiZdS4A4s77
         dC67WhhJPOOQEN7GlK8mT07D9XjNYRqqO6fo9JFrn38XJcQQFivaBT2lIqoGYG2aW0PA
         Xw4UURbJ7wl+1i34lJ53gOOAQIk+EgcAYELrE+HwCyHtZlPBXhoFSiWsTccsXzEcEuvj
         dbM2gruN3Q2waLkrxFoYj4dPqFHsUIGaZoqj4CupBUZfJTK3Vyqf5NRubGfHUzayARt9
         3tZic8OkZ08mTwLZq8MkEBzBGiQXpe0IUDnpEWXBEQqlF1Edkm9SN57l1SPBPV/ktGwg
         A1DA==
X-Gm-Message-State: AOAM532MPlCWZuU5S9GvgHWGniKPuKn+0zhR9TYDaUQQqz9ddhuC8KQA
        fWeyfGy0S8AkUFCQ/mq6XIff6KRM9/CwVukC
X-Google-Smtp-Source: ABdhPJxDIM3q2YqVVfB4Uycl5N+vkqwfQIFMYu6jwYFI6B0Pd3R6ZnClg920xKPtsbLlOLaJQeUXtg==
X-Received: by 2002:a17:90a:a510:b0:1bc:5887:d957 with SMTP id a16-20020a17090aa51000b001bc5887d957mr25330563pjq.38.1646203696671;
        Tue, 01 Mar 2022 22:48:16 -0800 (PST)
Received: from meizu.meizu.com ([137.59.103.163])
        by smtp.gmail.com with ESMTPSA id q194-20020a6275cb000000b004f396541cecsm18403322pfc.155.2022.03.01.22.48.14
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 01 Mar 2022 22:48:16 -0800 (PST)
From:   Haowen Bai <baihaowen88@gmail.com>
To:     sebastian.hesselbarth@gmail.com, davem@davemloft.net,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Haowen Bai <baihaowen88@gmail.com>
Subject: [PATCH v2] net: marvell: Use min() instead of doing it manually
Date:   Wed,  2 Mar 2022 14:48:06 +0800
Message-Id: <1646203686-30397-1-git-send-email-baihaowen88@gmail.com>
X-Mailer: git-send-email 2.7.4
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix following coccicheck warning:
drivers/net/ethernet/marvell/mv643xx_eth.c:1664:35-36: WARNING opportunity for min()

Signed-off-by: Haowen Bai <baihaowen88@gmail.com>
---
 drivers/net/ethernet/marvell/mv643xx_eth.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/mv643xx_eth.c b/drivers/net/ethernet/marvell/mv643xx_eth.c
index 143ca8b..e3e79cf 100644
--- a/drivers/net/ethernet/marvell/mv643xx_eth.c
+++ b/drivers/net/ethernet/marvell/mv643xx_eth.c
@@ -1661,7 +1661,7 @@ mv643xx_eth_set_ringparam(struct net_device *dev, struct ethtool_ringparam *er,
 	if (er->rx_mini_pending || er->rx_jumbo_pending)
 		return -EINVAL;
 
-	mp->rx_ring_size = er->rx_pending < 4096 ? er->rx_pending : 4096;
+	mp->rx_ring_size = min(er->rx_pending, (unsigned)4096);
 	mp->tx_ring_size = clamp_t(unsigned int, er->tx_pending,
 				   MV643XX_MAX_SKB_DESCS * 2, 4096);
 	if (mp->tx_ring_size != er->tx_pending)
-- 
2.7.4

