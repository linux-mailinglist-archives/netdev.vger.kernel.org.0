Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C5254CB468
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 02:42:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231396AbiCCBjk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 20:39:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231383AbiCCBjj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 20:39:39 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D5411B50F1;
        Wed,  2 Mar 2022 17:38:55 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id t5so3492944pfg.4;
        Wed, 02 Mar 2022 17:38:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=mKMsACRp5oRLS03/lYQR8en8vNEhdoGVbG88wJgersg=;
        b=A+iA2TYK8RY6gwD75NIAUIxeW+r8MuEJRXrNW1/eBJmt2wX1Mvsg03Yhf1hiCFvZy6
         khYLuOiXoIuSgbLKjKl8MzSUMYsbBqAGA2NHz6BOFV2OL0m5sptaW40LU3xq58lwm7LC
         T83kklT/eaks7HPgFqRaWRetQ5OE2AX5IVfDVuKs74Lez0ZErGApv5RRTmD1wZyXZE2J
         ajWxBbwFra8aNbM7KMjoVChMBJ3BUGIsnWcFOAOsLQkoBnIziV9OYqiMhN4XOvC+uES1
         Qe1e4Sa7WikjRAG5D4kFtfz7V2bIEaamtBU+tuHVEWKDeJ948+ZpYk0GMSUx90ZMj8OQ
         HLXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=mKMsACRp5oRLS03/lYQR8en8vNEhdoGVbG88wJgersg=;
        b=rRh608yNVuieF5j+saxPQQpQ8aUS5Ibr2w4iOE7tyz8k6Ps82fwKSr/u61P9Hru4dR
         kpMPtxs5G4eFAnkMdnw0F1NDtr5EktN4utTEVXFm4bl/CBPuzX9Kk63GnfCT11cV0A3s
         lSixM6ORnkEOQKGCvtogJdXbx+MhBGqazxy0IWDOQQaYinzWdv8NfBfrdDPANnDy5tYK
         xsPX9//V8PAoOJKX/n/2gk6FttX41PwpIc2aUgtNLaJIa7lNWKKPxhKbDYALDDfS43w+
         +iqo3HwIMyu0myGxPCp67rax5PvM5oKYK/LU5M0GVod2z97wbP8TsuccO2STQVb+sbIh
         yZdA==
X-Gm-Message-State: AOAM531rpCNgeHT0jlVLnVZFNxymELo+GI5zh6EruRLgfQU3WSkIRg46
        Q1/8dcNIJFIJYFRnqxYRY1qCeIq2P6cqm0sFKQc=
X-Google-Smtp-Source: ABdhPJzmY/RRWGuSl4LXFbZOF7g+ZmoJEXNQXsRqWU4K6Q3kXvGHsAABmj7F0VT4m4/3b2QWil5jXg==
X-Received: by 2002:a65:654f:0:b0:378:b8f6:ebe4 with SMTP id a15-20020a65654f000000b00378b8f6ebe4mr13778134pgw.399.1646271534494;
        Wed, 02 Mar 2022 17:38:54 -0800 (PST)
Received: from meizu.meizu.com ([137.59.103.163])
        by smtp.gmail.com with ESMTPSA id 16-20020a056a00073000b004dfe2217090sm418764pfm.200.2022.03.02.17.38.52
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 02 Mar 2022 17:38:54 -0800 (PST)
From:   Haowen Bai <baihaowen88@gmail.com>
To:     sebastian.hesselbarth@gmail.com, davem@davemloft.net,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Haowen Bai <baihaowen88@gmail.com>
Subject: [PATCH] [PATCH v3] net: marvell: Use min() instead of doing it manually
Date:   Thu,  3 Mar 2022 09:38:49 +0800
Message-Id: <1646271529-7659-1-git-send-email-baihaowen88@gmail.com>
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
index 143ca8b..c31cbba 100644
--- a/drivers/net/ethernet/marvell/mv643xx_eth.c
+++ b/drivers/net/ethernet/marvell/mv643xx_eth.c
@@ -1661,7 +1661,7 @@ mv643xx_eth_set_ringparam(struct net_device *dev, struct ethtool_ringparam *er,
 	if (er->rx_mini_pending || er->rx_jumbo_pending)
 		return -EINVAL;
 
-	mp->rx_ring_size = er->rx_pending < 4096 ? er->rx_pending : 4096;
+	mp->rx_ring_size = min(er->rx_pending, 4096U);
 	mp->tx_ring_size = clamp_t(unsigned int, er->tx_pending,
 				   MV643XX_MAX_SKB_DESCS * 2, 4096);
 	if (mp->tx_ring_size != er->tx_pending)
-- 
2.7.4

