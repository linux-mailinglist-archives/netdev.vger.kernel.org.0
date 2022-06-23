Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C193557412
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 09:40:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229961AbiFWHkZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 03:40:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbiFWHkY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jun 2022 03:40:24 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A65C24666E;
        Thu, 23 Jun 2022 00:40:22 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id 23so12211346pgc.8;
        Thu, 23 Jun 2022 00:40:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BJaWp4a1tWsJmYrMIxcQvHfF8fGl7s3JflZw6+GG7E4=;
        b=KiwmhuKiOGsU4BQ0Kocc/jTyTXJlmIz2tf+HMyLs48pNn+xpiQjyuSr3V+xaIEc9kP
         x2MvJNSQh3stGUxWBNetXAYBEE+kXbzum6+VM7LLj8nWoSyn/m9CgDoesC5bcBGpFVuM
         8s/hsTlujBKC2L+gXZflKLf2joW9hbJ/r3vxaLUFYOk7SSUKvWE4rVDPf6/0jvT7QR4h
         wwqaX+1trexU2R5lwHNNKcbBRHF/cDj8mrFpbsHn9GrBlj4L3gsFLqfr+QaPdCEXyg3U
         ixPSjCrrs0quU3dWFRyd4fHrC5/k2t6DdBm1h4Lo++IZOdhHaO7sa8jskOE/raoqlikX
         8ocw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BJaWp4a1tWsJmYrMIxcQvHfF8fGl7s3JflZw6+GG7E4=;
        b=P5o+BcQdqopqynpajxNxHvRHRWomWXctfQ1yUEMQdCtgq4EmsI2GV6Pwzw74Iyc12a
         aaGa5X0S+gmNK+9RJNvEkg54nt14qck3h2Y33m1xHOGVqlJiQ1e3Dgv4QXqQonPe1pOb
         YiY7WVzy5jtdDSxY4FsT4u3AwnwSdNU81eCWNgxAkKiSYazQRx3IdnwO7kPVy3/9SBC1
         fySBMhAPbmO7vpNNG7hXMHf2FuZAwZQ0IEV8mv8PJxXiay8JQ6Z7FfTLvdrq2ZlTdq1K
         1tEHcclvv/RQZycbWbhJ5G7HxmyZMGEhB09x8BZSFC/FTMZOS7RW5FPUb1oHDL7BAd50
         5hhg==
X-Gm-Message-State: AJIora+UqkdBUjzUiGDXmrlyZqsDtvEmdURmMHC/Uj795HLa28hHDLUO
        In4HQ1CKZdMM0Gwe+/czw5E=
X-Google-Smtp-Source: AGRyM1u+JO+nQKjV2iJ4RUEoYgYCWxmeGWw0POrGaKaHXvxDb4TkD6ivW2fWcigPw5Ku+KcCAXe9Gg==
X-Received: by 2002:a63:8ac8:0:b0:40d:4bd5:d6f6 with SMTP id y191-20020a638ac8000000b0040d4bd5d6f6mr2468363pgd.76.1655970021966;
        Thu, 23 Jun 2022 00:40:21 -0700 (PDT)
Received: from tong-desktop.local ([2600:1700:3ec7:421f:869f:7e22:7df6:1f98])
        by smtp.googlemail.com with ESMTPSA id b9-20020a17090a550900b001eaec814132sm5520768pji.3.2022.06.23.00.40.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jun 2022 00:40:21 -0700 (PDT)
From:   Tong Zhang <ztong0001@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, Jason Gunthorpe <jgg@ziepe.ca>,
        Tong Zhang <ztong0001@gmail.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Yilun Wu <yiluwu@cs.stonybrook.edu>
Subject: [PATCH] epic100: fix use after free on rmmod
Date:   Thu, 23 Jun 2022 00:40:04 -0700
Message-Id: <20220623074005.259309-1-ztong0001@gmail.com>
X-Mailer: git-send-email 2.25.1
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

Fixes: ae150435b59e ("smsc: Move the SMC (SMSC) drivers")
Reported-by: Yilun Wu <yiluwu@cs.stonybrook.edu>
Signed-off-by: Tong Zhang <ztong0001@gmail.com>
---
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

