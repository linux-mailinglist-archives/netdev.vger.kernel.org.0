Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABD9A3006CE
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 16:13:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728605AbhAVPM6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 10:12:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729095AbhAVPI6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jan 2021 10:08:58 -0500
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51178C06178B
        for <netdev@vger.kernel.org>; Fri, 22 Jan 2021 07:08:15 -0800 (PST)
Received: by mail-wr1-x432.google.com with SMTP id g10so5418232wrx.1
        for <netdev@vger.kernel.org>; Fri, 22 Jan 2021 07:08:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=mn6O2bBi2EbzByGFrsSlwzOHB9bYWAcVoVZch/5H50w=;
        b=RL8RnyOuEeLjkRSeDATQ9WqU4Y2lYjDzKl/HmgSuPqjLhEBbJo/1fLAu1l/WvcPxja
         MAyRljDmBr7Ah7uLjtJEFCPR5W9oBAToSypkBn6oRXz12aY2r7NE687i6S9TghXBQayD
         XmGvX6JpmNfUcp6IVFSL+9SK3f873jznbHOpGGQkKAErn9rhja20hw+kWfwebCKOcntb
         Ff+NcXu/alllJo4tRZEgvbwQiKGUr3/vSprlDWfrKPho02hPfc7k/t+YbvSkBLQmPkFw
         3rEz5tQW0Gz/3MsJRnDiBQbr2J52KooJT9Qk8AeaJj/e8T5AjBzXeM0D+YZoJjxEWCe2
         0ZLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=mn6O2bBi2EbzByGFrsSlwzOHB9bYWAcVoVZch/5H50w=;
        b=dKJOtFqi7Rme2clhNxokaePk1KDKdQcskuNsfhh8BL+eocIRe1yLGQNdf7DKNF7mq8
         lmpZ9C6A1df1+WFmBDlynEsk3jsk7FBpPY7KnQJTBNKe5YhwJOeGIITwb7d9xPFlvF9M
         6wJw9VFkM3FQY2sfJedDFzN/qV05Zh/slqky6BkvnRu7TtOU0EPxz86kwPyanonX0A8Y
         VbenG3N6swyydhXHLejjj7xi1tNi5F1PAMo2X2vxPf5NQwLCatmbl2FTn1jfNA2u+YIU
         57pdvbCmwV4ukm/V74Qj4w2xAtqPS2McGR8SVI/W85rXs/tY68VtyGs/ixGzgznV8XeG
         NqGQ==
X-Gm-Message-State: AOAM530M6pwRo1EFw0lM04Xyv2QUP/kATESeRmX3pbjFkuX4flTyCeri
        Of6pCr/7AJUPPvLtNF5IUL526A==
X-Google-Smtp-Source: ABdhPJx+eErWjaO42Z+LeydKvcyAIIRdL95LBiULulMGf8BXJ/R0tTs41aCfVkfJEvZeLS/2HG00ZQ==
X-Received: by 2002:adf:fb05:: with SMTP id c5mr4867793wrr.69.1611328093963;
        Fri, 22 Jan 2021 07:08:13 -0800 (PST)
Received: from localhost.localdomain ([88.122.66.28])
        by smtp.gmail.com with ESMTPSA id r13sm435131wmh.9.2021.01.22.07.08.13
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 22 Jan 2021 07:08:13 -0800 (PST)
From:   Loic Poulain <loic.poulain@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Loic Poulain <loic.poulain@linaro.org>
Subject: [PATCH v2 net-next]  net: mhi: Set wwan device type
Date:   Fri, 22 Jan 2021 16:15:54 +0100
Message-Id: <1611328554-1414-1-git-send-email-loic.poulain@linaro.org>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 'wwan' devtype is meant for devices that require additional
configuration to be used, like WWAN specific APN setup over AT/QMI
commands, rmnet link creation, etc. This is the case for MHI (Modem
host Interface) netdev which targets modem/WWAN endpoints.

Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
---
 v2: rebase on net-next

 drivers/net/mhi_net.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/mhi_net.c b/drivers/net/mhi_net.c
index 5f3a4cc..a5a214d 100644
--- a/drivers/net/mhi_net.c
+++ b/drivers/net/mhi_net.c
@@ -248,6 +248,10 @@ static void mhi_net_rx_refill_work(struct work_struct *work)
 		schedule_delayed_work(&mhi_netdev->rx_refill, HZ / 2);
 }
 
+static struct device_type wwan_type = {
+	.name = "wwan",
+};
+
 static int mhi_net_probe(struct mhi_device *mhi_dev,
 			 const struct mhi_device_id *id)
 {
@@ -267,6 +271,7 @@ static int mhi_net_probe(struct mhi_device *mhi_dev,
 	mhi_netdev->ndev = ndev;
 	mhi_netdev->mdev = mhi_dev;
 	SET_NETDEV_DEV(ndev, &mhi_dev->dev);
+	SET_NETDEV_DEVTYPE(ndev, &wwan_type);
 
 	/* All MHI net channels have 128 ring elements (at least for now) */
 	mhi_netdev->rx_queue_sz = 128;
-- 
2.7.4

