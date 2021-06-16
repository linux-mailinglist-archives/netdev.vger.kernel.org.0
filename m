Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E161D3A916D
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 07:53:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229698AbhFPFzb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 01:55:31 -0400
Received: from out30-132.freemail.mail.aliyun.com ([115.124.30.132]:51777 "EHLO
        out30-132.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229543AbhFPFzZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Jun 2021 01:55:25 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04420;MF=jiapeng.chong@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0Uca.DB._1623822795;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0Uca.DB._1623822795)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 16 Jun 2021 13:53:18 +0800
From:   Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To:     davem@davemloft.net
Cc:     kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Subject: [PATCH] net: mhi_net: make mhi_wwan_ops static
Date:   Wed, 16 Jun 2021 13:53:09 +0800
Message-Id: <1623822790-1404-1-git-send-email-jiapeng.chong@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This symbol is not used outside of net.c, so marks it static.

Fix the following sparse warning:

drivers/net/mhi/net.c:385:23: warning: symbol 'mhi_wwan_ops' was not
declared. Should it be static?

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
---
 drivers/net/mhi/net.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/mhi/net.c b/drivers/net/mhi/net.c
index 78d4a06..e5ec0d7 100644
--- a/drivers/net/mhi/net.c
+++ b/drivers/net/mhi/net.c
@@ -382,7 +382,7 @@ static void mhi_net_dellink(void *ctxt, struct net_device *ndev,
 	dev_set_drvdata(&mhi_dev->dev, NULL);
 }
 
-const struct wwan_ops mhi_wwan_ops = {
+static const struct wwan_ops mhi_wwan_ops = {
 	.owner = THIS_MODULE,
 	.priv_size = sizeof(struct mhi_net_dev),
 	.setup = mhi_net_setup,
-- 
1.8.3.1

