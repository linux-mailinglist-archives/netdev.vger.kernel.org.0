Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E3AD462BD5
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 05:51:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238282AbhK3EzK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 23:55:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231844AbhK3EzK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 23:55:10 -0500
Received: from mail-qk1-x729.google.com (mail-qk1-x729.google.com [IPv6:2607:f8b0:4864:20::729])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DED90C061574;
        Mon, 29 Nov 2021 20:51:51 -0800 (PST)
Received: by mail-qk1-x729.google.com with SMTP id m186so25481295qkb.4;
        Mon, 29 Nov 2021 20:51:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=M17/W6kgOYyF+cgBlFzL7pz8EMYW8LaCbMQL/p87ZvU=;
        b=WilKfh5xdx7JWpQVQ87QlY2Tc2f4BoDmdEbmoKdLxq1DIgdXw/X+d0rGI0kVcUsvq7
         1vwX26v6MmaamyismCkoGwyRUV1jxLWeXSNjAZGNxi6tYi9cQr7JKqjeO0/tyB8Cx+aq
         QI9D6EuOsdW7JxeaDsLTnSfSvWDqp9bNQyrpdTb5TIUToZuTAOUvvKetEKAkv78p0uel
         3zoeSzSlJZhhG/XiqPDsGQNO7Nsi+9lYWSCh9LTgzL/r0b2pTLzhyxfRkAb2s0OYGx++
         4Mxdoo8qg2yzU475PYLuUb1/ugZfpWxqsJQs38/LivHhQu36ak1rjdHWdX/VQrPqlw58
         ejSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=M17/W6kgOYyF+cgBlFzL7pz8EMYW8LaCbMQL/p87ZvU=;
        b=N6B+1xzguiHVbQn/R7YviU4JL954CIbb/aobv4PK/a7e8bmh6w/qSmDjc+yPJJuqpK
         1oOyGZlk7cqfyUC6uTMBlC+tzVga2X9Tbt5CDDze7O+o68jKa0RBR+qEIEKj0QvGTH4S
         4Uf2C/Di0LEyKkGQP/pCmikYaRb9CvM713Tg54fkxCt5ZN+P0fTsOw4dOiCIKebGrg/X
         D73noBwu3LI5PMlEUwhtg26+a6TBwv0aNxjTGHH1S81SPHxbFV3vz361XLkhh7g1d8N/
         rNYYKBorl6gLk0q4+NTbI283TjYpu5+0DexuZgHtOPt6WvyN8gj8k1pkpThXTDZ785Uc
         uctg==
X-Gm-Message-State: AOAM533z+ELEWjbVtc7n0+LDPCb5yAAoPYCnD9xjvSIEeac63ca++NG9
        34FFuVj9qNcMxWW3VXy9VqtYUAvKABNYpA==
X-Google-Smtp-Source: ABdhPJzQ/vsYYIksg0wFuByOjXmqgUaAOkOQiVfQnAqSIxgk2Ot+y28LxMwM/fk1tHJ9t7pzx0eWOQ==
X-Received: by 2002:a37:c205:: with SMTP id i5mr36344229qkm.657.1638247910821;
        Mon, 29 Nov 2021 20:51:50 -0800 (PST)
Received: from cth-desktop-dorm.mad.wi.cth451.me ([2600:6c44:113f:8901:6f66:c6f8:91db:cfda])
        by smtp.gmail.com with ESMTPSA id e20sm10265127qty.14.2021.11.29.20.51.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Nov 2021 20:51:50 -0800 (PST)
Date:   Mon, 29 Nov 2021 22:51:47 -0600
From:   Tianhao Chai <cth451@gmail.com>
To:     Igor Russkikh <irusskikh@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Hector Martin <marcan@marcan.st>, Sven Peter <sven@svenpeter.dev>,
        Alyssa Rosenzweig <alyssa@rosenzweig.io>
Subject: [PATCHv2] ethernet: aquantia: Try MAC address from device tree
Message-ID: <20211130045147.GA1456556@cth-desktop-dorm.mad.wi.cth451.me>
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
 .../net/ethernet/aquantia/atlantic/aq_nic.c   | 27 ++++++++++++-------
 1 file changed, 17 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
index 1acf544afeb4..ad89721c1cf6 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
@@ -316,18 +316,25 @@ int aq_nic_ndev_register(struct aq_nic_s *self)
 	aq_macsec_init(self);
 #endif
 
-	mutex_lock(&self->fwreq_mutex);
-	err = self->aq_fw_ops->get_mac_permanent(self->aq_hw, addr);
-	mutex_unlock(&self->fwreq_mutex);
-	if (err)
-		goto err_exit;
+	if (eth_platform_get_mac_address(&self->pdev->dev, addr) == 0) {
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

