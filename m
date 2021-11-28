Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D119460302
	for <lists+netdev@lfdr.de>; Sun, 28 Nov 2021 03:40:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237761AbhK1Cmw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Nov 2021 21:42:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235964AbhK1Ckw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Nov 2021 21:40:52 -0500
Received: from mail-il1-x129.google.com (mail-il1-x129.google.com [IPv6:2607:f8b0:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0589DC061574;
        Sat, 27 Nov 2021 18:37:36 -0800 (PST)
Received: by mail-il1-x129.google.com with SMTP id s11so5967868ilv.3;
        Sat, 27 Nov 2021 18:37:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=uZsW4vKAD42FBQLBm7RlaIj3WM0Zuzdt9kxEEmUrNBc=;
        b=pS0Yvh2bATvCt+KtwU4raYn0HDh4lHnAJCf1ChnjFfFyCsAY5MnRfNbZqqobhfUT/Y
         03cAIrqtaFVT5OJUmYwCptETrSDbZKCedyg65G6MQgGDohs2Jye57Si/aSGI6wq4pKZE
         aiTfPIkZpetDjwG7gRXGSZl6ChDWWicYRhdAr7bMxrcdAMqgDo83yIZyoRGU6lOAZ438
         bZJXCZTzZJSNV3aRTslUw1ozgSVND9aR3NqDFBOQqkl1hLdzzUxUt0ilYdwZ3Nqr62yG
         SLizbcwV6orw34BE7tmD53FdCjV5hIY69bSlH+08+lVfsCk+hpzpT7BI+7+BTa9LWwk8
         G+gA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=uZsW4vKAD42FBQLBm7RlaIj3WM0Zuzdt9kxEEmUrNBc=;
        b=FvkkHWpTQUkzPSxRvqkfl8JhIco3ktTnFY+LCfF/N30GroJh7irboK6n9eLzUOGFQ6
         Rxr2jRIlZcDSqxKs31V0ygB/goqXRJ6prp4HvEHRegujFA0VTdxDS+HVznkCFK7ZoZR8
         l5VpZESd11BWoArlQPdFA8NOm12UmpSEqU6/oJtQiwfMAQXcpyLYZsdySdwlh4bi9eIx
         VWv5G46C82ZZRgYYze5xZcMbP39t+eEfnPiezXcAVXEix8QO1YsDa5Qoevtbz0rTXFJu
         vRLe2VN6jl/UPH/m3N6xz9EXMQ5+Wz33/jsL8IkNN3mJWcYSp0MxCbSZBh+gyJp12QFr
         MCig==
X-Gm-Message-State: AOAM531pc+zqqtciuVp6g6VllfwsGoKJ9EGnm8GdEr4C1kG1XMZ91Yqa
        KJDwFTfzWmMm9qPNaYAXLnLvaPip4AMgaA==
X-Google-Smtp-Source: ABdhPJz+xKA0D6Bb6XV9fJrfFY2XXSpo2QcxVDRwW6lZtC+Sdb9sM2zDpYRzEVqmCchQX26oEn/M2w==
X-Received: by 2002:a05:6e02:1d10:: with SMTP id i16mr46494963ila.182.1638067056229;
        Sat, 27 Nov 2021 18:37:36 -0800 (PST)
Received: from cth-desktop-dorm.mad.wi.cth451.me ([2600:6c44:113f:8901:6f66:c6f8:91db:cfda])
        by smtp.gmail.com with ESMTPSA id g7sm4337845iln.67.2021.11.27.18.37.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 27 Nov 2021 18:37:35 -0800 (PST)
Date:   Sat, 27 Nov 2021 20:37:33 -0600
From:   Tianhao Chai <cth451@gmail.com>
To:     Igor Russkikh <irusskikh@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Hector Martin <marcan@marcan.st>, Sven Peter <sven@svenpeter.dev>,
        Alyssa Rosenzweig <alyssa@rosenzweig.io>
Subject: [PATCH] ethernet: aquantia: Try MAC address from device tree
Message-ID: <20211128023733.GA466664@cth-desktop-dorm.mad.wi.cth451.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Apple M1 Mac minis (2020) with 10GE NICs do not have MAC address in the
card, but instead need to obtain MAC addresses from the device tree. In
this case the hardware will report an invalid MAC.

Currently atlantic driver does not query the DT for MAC address and will
randomly assign a MAC if the NIC doesn't have a permanent MAC burnt in.
This patch causes the driver to perfer a valid MAC address from OF (if
present) over HW self-reported MAC and only fall back to a random MAC
address when neither of them is valid.

Signed-off-by: Tianhao Chai <cth451@gmail.com>
---
 .../net/ethernet/aquantia/atlantic/aq_nic.c   | 28 ++++++++++++-------
 1 file changed, 18 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
index 1acf544afeb4..ae6c4a044390 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
@@ -316,18 +316,26 @@ int aq_nic_ndev_register(struct aq_nic_s *self)
 	aq_macsec_init(self);
 #endif
 
-	mutex_lock(&self->fwreq_mutex);
-	err = self->aq_fw_ops->get_mac_permanent(self->aq_hw, addr);
-	mutex_unlock(&self->fwreq_mutex);
-	if (err)
-		goto err_exit;
+	if (eth_platform_get_mac_address(&self->pdev->dev, addr) == 0 &&
+	    is_valid_ether_addr(addr)) {
+		// DT supplied a valid MAC address
+		eth_hw_addr_set(self->ndev, addr);
+	} else {
+		// If DT has none or an invalid one, ask device for MAC address
+		mutex_lock(&self->fwreq_mutex);
+		err = self->aq_fw_ops->get_mac_permanent(self->aq_hw, addr);
+		mutex_unlock(&self->fwreq_mutex);
 
-	eth_hw_addr_set(self->ndev, addr);
+		if (err)
+			goto err_exit;
 
-	if (!is_valid_ether_addr(self->ndev->dev_addr) ||
-	    !aq_nic_is_valid_ether_addr(self->ndev->dev_addr)) {
-		netdev_warn(self->ndev, "MAC is invalid, will use random.");
-		eth_hw_addr_random(self->ndev);
+		if (is_valid_ether_addr(addr) &&
+		    aq_nic_is_valid_ether_addr(addr)) {
+			eth_hw_addr_set(self->ndev, addr);
+		} else {
+			netdev_warn(self->ndev, "MAC is invalid, will use random.");
+			eth_hw_addr_random(self->ndev);
+		}
 	}
 
 #if defined(AQ_CFG_MAC_ADDR_PERMANENT)
-- 
2.30.2

