Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B390746452F
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 03:57:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241503AbhLADAd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 22:00:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230406AbhLADAb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 22:00:31 -0500
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DA4FC061746;
        Tue, 30 Nov 2021 18:57:11 -0800 (PST)
Received: by mail-io1-xd2e.google.com with SMTP id v23so28871876iom.12;
        Tue, 30 Nov 2021 18:57:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=wiPYTcAHVwhA2rfc2hhHlD9xwe9XFPwcNmMOICFA7To=;
        b=EqWzuWgHFKYe/ZKczz4kJDJc96hbbpE0lcICbU+CtZAoLV1Fsjxf/D+EHgd2pWfTZ7
         91ndcPI8szo56Kk2hiokoJYWxYJx+XTpI1KLVxBV14ubqDKgRzLhLE64vFfwoi/JLloG
         cfPOwTVpvs8XW3xIDHQ9kPw0hNGLeztmY1huszYrS7g6RAo/nMN/lnWRmXoLCaFwHF+T
         ogo7iZ6nCGGAt4pDy8OyzxN731l44F5Y7FnZFNHK6C/53/ThOx1NqdAGXQLeWjqIZz+3
         WyaQU0ON3aLSZyB7LtyRJGPtpbE69PCkBuJaRU/OHjReOyR0eydMx3QPh00tOwerE/IL
         Ua7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=wiPYTcAHVwhA2rfc2hhHlD9xwe9XFPwcNmMOICFA7To=;
        b=j+cfhkVoEXvXNu0FoIGWW6ncMn2Fj4wg6M7OY9AvoLcaCbxXTuOkh8VAs0kI0bYdLn
         plMWRGTgXoY41mCFIg/DXgNKdcwnTEyFE7FcNUqGfsze+qzaJmKIXScq+9lrdVFW5c6C
         Wio2TbKBwd0c5mJr9p+cxNMFSGcsZK+KBQNXzdF6YFp1rwJBENOsMjOR872oxmMHIiI5
         t2T+zYcxVbf5ZfeeShjywq6yUIGGj/sNZchgMl3acfNV1JUgtJRnPlLooRwQXKR4WrZ7
         QTroXRORpbtzTqGG0QuZzTtHvghmFGE5y562hMwKinzkw9UcCvsLSZBd6zIwNIv4i925
         zF/g==
X-Gm-Message-State: AOAM533cfxxaXr5Lyh3QaiSjfsESs+R4UN5aejTh2aMy/VkbhVLdcSa8
        yFPx1KUVjk2Enm3TeVO38d6cGCoZnPK63g==
X-Google-Smtp-Source: ABdhPJzF5T+B1XnrxQ+NMydVZTt6lbDQT6IGiz4ewIcx/Dcd5VbMf2lNHLtbhW2bn6f9dtxjEJgjLw==
X-Received: by 2002:a05:6602:3c2:: with SMTP id g2mr5750281iov.65.1638327429577;
        Tue, 30 Nov 2021 18:57:09 -0800 (PST)
Received: from cth-desktop-dorm.mad.wi.cth451.me ([2600:6c44:113f:8901:6f66:c6f8:91db:cfda])
        by smtp.gmail.com with ESMTPSA id j8sm8385799ilu.64.2021.11.30.18.57.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Nov 2021 18:57:09 -0800 (PST)
Date:   Tue, 30 Nov 2021 20:57:06 -0600
From:   Tianhao Chai <cth451@gmail.com>
To:     Igor Russkikh <irusskikh@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Cc:     Hector Martin <marcan@marcan.st>, Sven Peter <sven@svenpeter.dev>,
        Alyssa Rosenzweig <alyssa@rosenzweig.io>
Subject: [PATCHv3] ethernet: aquantia: Try MAC address from device tree
Message-ID: <20211201025706.GA2181732@cth-desktop-dorm.mad.wi.cth451.me>
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
 .../net/ethernet/aquantia/atlantic/aq_nic.c   | 24 +++++++++++--------
 1 file changed, 14 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
index 1acf544afeb4..2a1ab154f681 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
@@ -316,18 +316,22 @@ int aq_nic_ndev_register(struct aq_nic_s *self)
 	aq_macsec_init(self);
 #endif
 
-	mutex_lock(&self->fwreq_mutex);
-	err = self->aq_fw_ops->get_mac_permanent(self->aq_hw, addr);
-	mutex_unlock(&self->fwreq_mutex);
-	if (err)
-		goto err_exit;
+	if (platform_get_ethdev_address(&self->pdev->dev, self->ndev) != 0) {
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

