Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38D3357719F
	for <lists+netdev@lfdr.de>; Sat, 16 Jul 2022 23:47:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231700AbiGPVrE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Jul 2022 17:47:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229619AbiGPVrD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Jul 2022 17:47:03 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C936511807
        for <netdev@vger.kernel.org>; Sat, 16 Jul 2022 14:47:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658008020;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=epB7rlrzw6XyEr2+HEifgpL7PVvDrusi3GoURdV5q2k=;
        b=K0KZ74rqZRskbyarYt+uEx/05J6WjZAYqT3JcDpQ1hMdtb7J9hm1QVwaxRJdpYTP/xNPyc
        AU47/5+QJ3lUVlcqvpKK6z8icEO9FHevLMqMMkuUVnePY8/KzW8/IHMKFE60OqUazpiRGZ
        yFm8IkJztyKT6ZvnvPypiDT/nqcAjn0=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-341-ke1xfmJgPYSsw2K3QjWPeQ-1; Sat, 16 Jul 2022 17:46:59 -0400
X-MC-Unique: ke1xfmJgPYSsw2K3QjWPeQ-1
Received: by mail-qt1-f197.google.com with SMTP id x11-20020ac84d4b000000b0031ed94d739dso4254878qtv.11
        for <netdev@vger.kernel.org>; Sat, 16 Jul 2022 14:46:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=epB7rlrzw6XyEr2+HEifgpL7PVvDrusi3GoURdV5q2k=;
        b=aUx2PX4seak1QD7lZZuC7cI4B60v50C7AeHCTkErYD08a9+vZJ1aJ3pIf4uHQXCZ4H
         0YMDVwQ5Q2UX8BLcrZHzui/apk+IUt/jO3rNP8isVERQ9qVrq6EodojLYIr8wIPDE/y7
         iU0mYVHTjSKP8liCuC23GYRwczBqoAxPDMTaPvhBuzJ7YHtCND8ELOEkdI5V3A4pVabm
         fm0vyc1xK2Mlhwzg/FlYIIeNS6nL5eBDN0VMqO2Hyb8/GBQgYv3in8qY+x0Y8XDAC8uH
         iY7n+3qY/zPEzc+IW/kpocto0C0XW+gGcmb4TPCuoYjEjVsuiidUeAog49wHsl8WCTlP
         oeIQ==
X-Gm-Message-State: AJIora+TH++aXIcff0E180qBTX+aeBxhjPuMMOrPMfyQrUZl6isN064S
        HlZqn/BhDy1F3S31jr7WI9L1TYo6YNdmyj2LQncZsf0N9TMfpq8KxrtsBLK62chtvo3wXNSRMKV
        ip08N2UF89wc0TlmZ
X-Received: by 2002:a37:2f44:0:b0:6b5:b10d:6f1 with SMTP id v65-20020a372f44000000b006b5b10d06f1mr13314485qkh.519.1658008018875;
        Sat, 16 Jul 2022 14:46:58 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1sCWMb1HpZpVkq7nYKBH6ZxTcvmV5ifECAsHhu9bjCZGadDxzE/B/vvdUPRDZA6qJClbqRJjg==
X-Received: by 2002:a37:2f44:0:b0:6b5:b10d:6f1 with SMTP id v65-20020a372f44000000b006b5b10d06f1mr13314475qkh.519.1658008018680;
        Sat, 16 Jul 2022 14:46:58 -0700 (PDT)
Received: from dell-per740-01.7a2m.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id o21-20020a05620a2a1500b006b5cdbbfccfsm5742503qkp.79.2022.07.16.14.46.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 16 Jul 2022 14:46:58 -0700 (PDT)
From:   Tom Rix <trix@redhat.com>
To:     nbd@nbd.name, john@phrozen.org, sean.wang@mediatek.com,
        Mark-MC.Lee@mediatek.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, matthias.bgg@gmail.com
Cc:     netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        Tom Rix <trix@redhat.com>
Subject: [PATCH] net: ethernet: mtk_eth_soc: fix off by one check of ARRAY_SIZE
Date:   Sat, 16 Jul 2022 17:46:54 -0400
Message-Id: <20220716214654.1540240-1-trix@redhat.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In mtk_wed_tx_ring_setup(.., int idx, ..), idx is used as an index here
  struct mtk_wed_ring *ring = &dev->tx_ring[idx];

The bounds of idx are checked here
  BUG_ON(idx > ARRAY_SIZE(dev->tx_ring));

If idx is the size of the array, it will pass this check and overflow.
So change the check to >= .

Fixes: 804775dfc288 ("net: ethernet: mtk_eth_soc: add support for Wireless Ethernet Dispatch (WED)")
Signed-off-by: Tom Rix <trix@redhat.com>
---
 drivers/net/ethernet/mediatek/mtk_wed.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_wed.c b/drivers/net/ethernet/mediatek/mtk_wed.c
index 8f0cd3196aac..29be2fcafea3 100644
--- a/drivers/net/ethernet/mediatek/mtk_wed.c
+++ b/drivers/net/ethernet/mediatek/mtk_wed.c
@@ -651,7 +651,7 @@ mtk_wed_tx_ring_setup(struct mtk_wed_device *dev, int idx, void __iomem *regs)
 	 * WDMA RX.
 	 */
 
-	BUG_ON(idx > ARRAY_SIZE(dev->tx_ring));
+	BUG_ON(idx >= ARRAY_SIZE(dev->tx_ring));
 
 	if (mtk_wed_ring_alloc(dev, ring, MTK_WED_TX_RING_SIZE))
 		return -ENOMEM;
-- 
2.27.0

