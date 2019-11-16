Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 48CCBFEB1F
	for <lists+netdev@lfdr.de>; Sat, 16 Nov 2019 08:34:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726257AbfKPHeJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Nov 2019 02:34:09 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:6684 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726034AbfKPHeJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 16 Nov 2019 02:34:09 -0500
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 9CB5E6AA3D2E3713EDA0;
        Sat, 16 Nov 2019 15:34:06 +0800 (CST)
Received: from huawei.com (10.90.53.225) by DGGEMS414-HUB.china.huawei.com
 (10.3.19.214) with Microsoft SMTP Server id 14.3.439.0; Sat, 16 Nov 2019
 15:34:00 +0800
From:   zhengbin <zhengbin13@huawei.com>
To:     <stas.yakovlev@gmail.com>, <kvalo@codeaurora.org>,
        <davem@davemloft.net>, <linux-wireless@vger.kernel.org>,
        <netdev@vger.kernel.org>
CC:     <zhengbin13@huawei.com>
Subject: [PATCH -next 2/2] ipw2x00: remove set but not used variable 'force_update'
Date:   Sat, 16 Nov 2019 15:41:23 +0800
Message-ID: <1573890083-33761-3-git-send-email-zhengbin13@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1573890083-33761-1-git-send-email-zhengbin13@huawei.com>
References: <1573890083-33761-1-git-send-email-zhengbin13@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.90.53.225]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes gcc '-Wunused-but-set-variable' warning:

drivers/net/wireless/intel/ipw2x00/ipw2100.c: In function shim__set_security:
drivers/net/wireless/intel/ipw2x00/ipw2100.c:5582:9: warning: variable force_update set but not used [-Wunused-but-set-variable]

It is introduced by commit 367a1092b555 ("ipw2x00:
move under intel vendor directory"), but never used, so remove it.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: zhengbin <zhengbin13@huawei.com>
---
 drivers/net/wireless/intel/ipw2x00/ipw2100.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/ipw2x00/ipw2100.c b/drivers/net/wireless/intel/ipw2x00/ipw2100.c
index 8dfbaff..c4c83ab 100644
--- a/drivers/net/wireless/intel/ipw2x00/ipw2100.c
+++ b/drivers/net/wireless/intel/ipw2x00/ipw2100.c
@@ -5565,7 +5565,7 @@ static void shim__set_security(struct net_device *dev,
 			       struct libipw_security *sec)
 {
 	struct ipw2100_priv *priv = libipw_priv(dev);
-	int i, force_update = 0;
+	int i;

 	mutex_lock(&priv->action_mutex);
 	if (!(priv->status & STATUS_INITIALIZED))
@@ -5605,7 +5605,6 @@ static void shim__set_security(struct net_device *dev,
 		priv->ieee->sec.flags |= SEC_ENABLED;
 		priv->ieee->sec.enabled = sec->enabled;
 		priv->status |= STATUS_SECURITY_UPDATED;
-		force_update = 1;
 	}

 	if (sec->flags & SEC_ENCRYPT)
--
2.7.4

