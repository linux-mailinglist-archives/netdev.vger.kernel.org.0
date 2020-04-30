Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F9F71BF7FA
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 14:15:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726631AbgD3MPf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 08:15:35 -0400
Received: from cmccmta3.chinamobile.com ([221.176.66.81]:5142 "EHLO
        cmccmta3.chinamobile.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725280AbgD3MPf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 08:15:35 -0400
Received: from spf.mail.chinamobile.com (unknown[172.16.121.9]) by rmmx-syy-dmz-app12-12012 (RichMail) with SMTP id 2eec5eaac1463c3-cd75d; Thu, 30 Apr 2020 20:15:04 +0800 (CST)
X-RM-TRANSID: 2eec5eaac1463c3-cd75d
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG: 00000000
Received: from localhost.localdomain (unknown[112.1.172.204])
        by rmsmtp-syy-appsvr05-12005 (RichMail) with SMTP id 2ee55eaac146994-cdc8f;
        Thu, 30 Apr 2020 20:15:04 +0800 (CST)
X-RM-TRANSID: 2ee55eaac146994-cdc8f
From:   Tang Bin <tangbin@cmss.chinamobile.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tang Bin <tangbin@cmss.chinamobile.com>,
        Zhang Shengju <zhangshengju@cmss.chinamobile.com>
Subject: [PATCH] net/faraday: Fix unnecessary check in ftmac100_probe()
Date:   Thu, 30 Apr 2020 20:15:31 +0800
Message-Id: <20200430121532.22768-1-tangbin@cmss.chinamobile.com>
X-Mailer: git-send-email 2.20.1.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The function ftmac100_probe() is only called with an openfirmware
platform device. Therefore there is no need to check that the passed
in device is NULL.

Signed-off-by: Zhang Shengju <zhangshengju@cmss.chinamobile.com>
Signed-off-by: Tang Bin <tangbin@cmss.chinamobile.com>
---
 drivers/net/ethernet/faraday/ftmac100.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/ethernet/faraday/ftmac100.c b/drivers/net/ethernet/faraday/ftmac100.c
index 6c247cbbd..2be173b03 100644
--- a/drivers/net/ethernet/faraday/ftmac100.c
+++ b/drivers/net/ethernet/faraday/ftmac100.c
@@ -1059,9 +1059,6 @@ static int ftmac100_probe(struct platform_device *pdev)
 	struct ftmac100 *priv;
 	int err;
 
-	if (!pdev)
-		return -ENODEV;
-
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!res)
 		return -ENXIO;
-- 
2.20.1.windows.1



