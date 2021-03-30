Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C204A34E6B7
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 13:47:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232145AbhC3LrO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 07:47:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231990AbhC3Lqi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Mar 2021 07:46:38 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C21B6C061765
        for <netdev@vger.kernel.org>; Tue, 30 Mar 2021 04:46:37 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1lRCpQ-0006G5-Bu
        for netdev@vger.kernel.org; Tue, 30 Mar 2021 13:46:36 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id C888C603E82
        for <netdev@vger.kernel.org>; Tue, 30 Mar 2021 11:46:20 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 4E3B1603E07;
        Tue, 30 Mar 2021 11:46:08 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 49ed7017;
        Tue, 30 Mar 2021 11:46:00 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Xulin Sun <xulin.sun@windriver.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [net-next 17/39] can: m_can: m_can_class_allocate_dev(): remove impossible error return judgment
Date:   Tue, 30 Mar 2021 13:45:37 +0200
Message-Id: <20210330114559.1114855-18-mkl@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210330114559.1114855-1-mkl@pengutronix.de>
References: <20210330114559.1114855-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xulin Sun <xulin.sun@windriver.com>

If the CAN net device has been successfully allocated, its private
data structure is impossible to be empty, remove this redundant error
return judgment.

Link: https://lore.kernel.org/r/20210205072559.13241-2-xulin.sun@windriver.com
Signed-off-by: Xulin Sun <xulin.sun@windriver.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/m_can/m_can.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
index 2ae3da16cbfe..12a75ebe9ce1 100644
--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -1787,11 +1787,6 @@ struct m_can_classdev *m_can_class_allocate_dev(struct device *dev,
 	}
 
 	class_dev = netdev_priv(net_dev);
-	if (!class_dev) {
-		dev_err(dev, "Failed to init netdev cdevate");
-		goto out;
-	}
-
 	class_dev->net = net_dev;
 	class_dev->dev = dev;
 	SET_NETDEV_DEV(net_dev, dev);
-- 
2.30.2


