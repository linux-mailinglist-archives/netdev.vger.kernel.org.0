Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64BF055B638
	for <lists+netdev@lfdr.de>; Mon, 27 Jun 2022 06:36:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230205AbiF0Eel (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jun 2022 00:34:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbiF0Eek (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jun 2022 00:34:40 -0400
Received: from mail-ot1-x331.google.com (mail-ot1-x331.google.com [IPv6:2607:f8b0:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D608E2704;
        Sun, 26 Jun 2022 21:34:39 -0700 (PDT)
Received: by mail-ot1-x331.google.com with SMTP id b23-20020a9d7557000000b00616c7999865so2108440otl.12;
        Sun, 26 Jun 2022 21:34:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PTiy5Tb9IS5NFyaRIUmIImxLF1PcQ7hdoFm9vOTIWvM=;
        b=PpXbOwC/IWLxnbj0+pl87GNOlfocFRpiErYv1YDECGl55WPBRfTTQP44L/5bMeLjgo
         HM8TFAFOgmeO9PnkV4ispYE7ExDcvusfgiuXhs/1pUUhN+6ZChBSevUBZ+uM+n5O0wlo
         GKLTtRDl8/H6J+Iq/H3PerY/OAXh4xbKCSRhyBdiTHCGQdDPPA7taL29Xk+mOHfU8UWZ
         4y0RmSvuUJZ3PfCZeEKZVwUAz05QCdTk3CpyoEdu1+QX4k8WGpGP6jnsI58xPVwVY0yD
         q6X5gQf5QLyprFC8flJHYtTto/BsSNbYywqcQSPrTUNPAdZ0L3IuQtjk54iFQ39wVJg+
         81eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PTiy5Tb9IS5NFyaRIUmIImxLF1PcQ7hdoFm9vOTIWvM=;
        b=qJVvUio4ywRIohS3rmY4HvnQtp6xHw32mF/5Lbsz1H4D4OBcEaqYoZou6fMXRXBqGs
         25ofgA2ml1XYXMW2FkobRhpS+QEctEntdpJ1rjTAuHZ3OtppROl7xx48/JkIZ/UVjFWV
         A7MjTw8A2EflpR4N7ZmOPSaY7L/bvPm7cPYBKS1zsB64zxWHMWuF/lzbDz0FhtFveanU
         UhnK3VmOWNtMli6rW7ntt+TR9S2BSyx2XO/xW2rhZt4fQ7C9ggyu3LRGctiP5PB6Qdfi
         xLF9qWVzPReDak36HX+UqHyKnQOXsxeCdO19DGDiX6T6p8JMlT+67ZX9Bt/8yKNUH3Ck
         6bCQ==
X-Gm-Message-State: AJIora82X0MInPyrzkPQcrkyzEo1Zdx1UEhGaLcSHudQi7EvnBUIzZY4
        +Ef/jWy8kj1q5vqDvPdPrOQ=
X-Google-Smtp-Source: AGRyM1vdST1SfYQxcW9TvOmt+Ke2t0hkzCtIdSNxBA+ceTqsG2ghQJS+p8XeiV7fBp2n1MVw8kaCYA==
X-Received: by 2002:a9d:317:0:b0:616:92d6:4416 with SMTP id 23-20020a9d0317000000b0061692d64416mr5024849otv.328.1656304478937;
        Sun, 26 Jun 2022 21:34:38 -0700 (PDT)
Received: from tong-desktop.local ([2600:1700:3ec7:421f:e26b:39d3:3538:41bb])
        by smtp.googlemail.com with ESMTPSA id cz42-20020a05687064aa00b00101c83352c6sm6472361oab.34.2022.06.26.21.34.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Jun 2022 21:34:38 -0700 (PDT)
From:   Tong Zhang <ztong0001@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Tong Zhang <ztong0001@gmail.com>,
        Jason Gunthorpe <jgg@ziepe.ca>, Arnd Bergmann <arnd@arndb.de>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Yilun Wu <yiluwu@cs.stonybrook.edu>,
        Francois Romieu <romieu@fr.zoreil.com>
Subject: [PATCH v2] epic100: fix use after free on rmmod
Date:   Sun, 26 Jun 2022 21:33:48 -0700
Message-Id: <20220627043351.25615-1-ztong0001@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220624114121.2c95c3aa@kernel.org>
References: <20220624114121.2c95c3aa@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

epic_close() calls epic_rx() and uses dma buffer, but in epic_remove_one()
we already freed the dma buffer. To fix this issue, reorder function calls
like in the .probe function.

BUG: KASAN: use-after-free in epic_rx+0xa6/0x7e0 [epic100]
Call Trace:
 epic_rx+0xa6/0x7e0 [epic100]
 epic_close+0xec/0x2f0 [epic100]
 unregister_netdev+0x18/0x20
 epic_remove_one+0xaa/0xf0 [epic100]

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: Yilun Wu <yiluwu@cs.stonybrook.edu>
Signed-off-by: Tong Zhang <ztong0001@gmail.com>
Reviewed-by: Francois Romieu <romieu@fr.zoreil.com>
---
v2: amend fix tag
 drivers/net/ethernet/smsc/epic100.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/smsc/epic100.c b/drivers/net/ethernet/smsc/epic100.c
index a0654e88444c..0329caf63279 100644
--- a/drivers/net/ethernet/smsc/epic100.c
+++ b/drivers/net/ethernet/smsc/epic100.c
@@ -1515,14 +1515,14 @@ static void epic_remove_one(struct pci_dev *pdev)
 	struct net_device *dev = pci_get_drvdata(pdev);
 	struct epic_private *ep = netdev_priv(dev);
 
+	unregister_netdev(dev);
 	dma_free_coherent(&pdev->dev, TX_TOTAL_SIZE, ep->tx_ring,
 			  ep->tx_ring_dma);
 	dma_free_coherent(&pdev->dev, RX_TOTAL_SIZE, ep->rx_ring,
 			  ep->rx_ring_dma);
-	unregister_netdev(dev);
 	pci_iounmap(pdev, ep->ioaddr);
-	pci_release_regions(pdev);
 	free_netdev(dev);
+	pci_release_regions(pdev);
 	pci_disable_device(pdev);
 	/* pci_power_off(pdev, -1); */
 }
-- 
2.25.1

