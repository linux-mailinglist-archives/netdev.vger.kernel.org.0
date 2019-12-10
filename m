Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF73A118C84
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 16:28:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727508AbfLJP2y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 10:28:54 -0500
Received: from gateway20.websitewelcome.com ([192.185.55.25]:33813 "EHLO
        gateway20.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727434AbfLJP2y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 10:28:54 -0500
Received: from cm11.websitewelcome.com (cm11.websitewelcome.com [100.42.49.5])
        by gateway20.websitewelcome.com (Postfix) with ESMTP id E50A1400C733E
        for <netdev@vger.kernel.org>; Tue, 10 Dec 2019 07:54:09 -0600 (CST)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id eh3tiJGvyiJ43eh3tijrVO; Tue, 10 Dec 2019 09:04:30 -0600
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Type:MIME-Version:Message-ID:Subject:
        Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=di6itqzy1Kz6qTiVDOx+IF2EnF+F8GJNKypw7OnCAyA=; b=erGq0mpwB/ttMA8iQzgnj6nRSo
        +hvbQTfkTsD27mUp9UFIBDHI+BI28AiDkknua5jG2WGDSkz7QjmuB5pUmnQ1/EPO7bvGAqiFsKNbv
        7JhHdQOKIZKtC8JbB1o9uqePw2KMJppguDO4R8zIV8Y5RylMmucnrgIRiE6BisnsLJA26BDckQsK3
        n/V39u4QiRRB1Z+vVH4HML3zdh+fBi1S45x0FatjeCPHrIvfXTboKDEcQ5qx+tdmVqjLulGF1Yp0n
        wKDvCXjjCiBPdr9SQLESOUzgA1NaxQi96mutVxOeyMV839FA4kIz5aLYzxOnIPWyRU/BHag+gfcKu
        zH/v63zA==;
Received: from [187.192.35.14] (port=36632 helo=embeddedor)
        by gator4166.hostgator.com with esmtpa (Exim 4.92)
        (envelope-from <gustavo@embeddedor.com>)
        id 1ieh3s-000Syo-0a; Tue, 10 Dec 2019 09:04:28 -0600
Date:   Tue, 10 Dec 2019 09:05:32 -0600
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To:     Dan Murphy <dmurphy@ti.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Sean Nyekjaer <sean@geanix.com>
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH][next] can: tcan45x: Fix inconsistent IS_ERR and PTR_ERR
Message-ID: <20191210150532.GA12732@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4166.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - embeddedor.com
X-BWhitelist: no
X-Source-IP: 187.192.35.14
X-Source-L: No
X-Exim-ID: 1ieh3s-000Syo-0a
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: (embeddedor) [187.192.35.14]:36632
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 7
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix inconsistent IS_ERR and PTR_ERR in tcan4x5x_parse_config.

The proper pointer to be passed as argument is tcan4x5x->device_wake_gpio.

This bug was detected with the help of Coccinelle.

Fixes: 2de497356955 ("can: tcan45x: Make wake-up GPIO an optional GPIO")
Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 drivers/net/can/m_can/tcan4x5x.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/can/m_can/tcan4x5x.c b/drivers/net/can/m_can/tcan4x5x.c
index 4e1789ea2bc3..6676ecec48c3 100644
--- a/drivers/net/can/m_can/tcan4x5x.c
+++ b/drivers/net/can/m_can/tcan4x5x.c
@@ -355,7 +355,7 @@ static int tcan4x5x_parse_config(struct m_can_classdev *cdev)
 	tcan4x5x->device_wake_gpio = devm_gpiod_get(cdev->dev, "device-wake",
 						    GPIOD_OUT_HIGH);
 	if (IS_ERR(tcan4x5x->device_wake_gpio)) {
-		if (PTR_ERR(tcan4x5x->power) == -EPROBE_DEFER)
+		if (PTR_ERR(tcan4x5x->device_wake_gpio) == -EPROBE_DEFER)
 			return -EPROBE_DEFER;
 
 		tcan4x5x_disable_wake(cdev);
-- 
2.23.0

